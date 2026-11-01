extends Node3D
## PadWork: the coach holds the mitts, the boxer throws the combo she drills.
## build(boxer_glb, coach_glb) play(combo_id, loops) start_punch(i, clip, beat)
## glove_real_pos(hand) get_mitt_pos(side) compute_mitt_targets(combo_id)
## S349 r4: the mitt target is computed ONCE before each punch by sampling the boxer's
## clip at its contact time. No per-frame tracking. The coach raises the mitt from guard
## over 0.2-0.3s before the punch starts.

const MH := preload("res://scripts/fight3d/MHRig.gd")
const FightClips := preload("res://scripts/fight3d/FightClips.gd")
const CornerIK := preload("res://scripts/fight3d/CornerIK.gd")
const Mitts := preload("res://scripts/fight3d/Mitts.gd")
const BeatClips := preload("res://scripts/fight3d/BeatClips.gd")
const MoveClips := preload("res://scripts/fight3d/MoveClips.gd")
const Combos := preload("res://scripts/rules/Combos.gd")
const Gloves := preload("res://scripts/fight3d/Gloves.gd")
const FighterKit := preload("res://scripts/fight3d/FighterKit.gd")

const LONG_RANGE_M := 1.225
const POP_BACK_M := 0.04
const RAISE_LEAD_S := 0.25
const GLOVE_RADIUS_M := 0.08

signal done
var boxer: Dictionary = {}
var coach: Dictionary = {}
var mitts: Node = null
var _punches: Array = []
var _t := 0.0
var _playing := false
var _mitt_targets_ready := false


func build(boxer_glb: String, coach_glb: String) -> void:
	# --- Boxer ---
	var boxer_body := MH.load_fighter(boxer_glb)
	add_child(boxer_body)
	var boxer_skel := boxer_body.find_children("*", "Skeleton3D", true, false)[0] as Skeleton3D
	var boxer_ap := boxer_body.find_children("*", "AnimationPlayer", true, false)[0] as AnimationPlayer
	FightClips.load_into(boxer_ap, boxer_skel)
	FighterKit.dress(boxer_body, boxer_glb, "boxing")
	var gl := Gloves.new()
	gl.name = "Gloves"
	boxer_body.add_child(gl)
	gl.mount(boxer_body, Color(0.62, 0.06, 0.06), Color(0.95, 0.95, 0.92))
	boxer = {"node": boxer_body, "skel": boxer_skel, "ap": boxer_ap, "gloves": gl, "front_m": gl.front_m()}
	boxer_body.position = Vector3.ZERO
	# --- Coach ---
	var coach_body := MH.load_fighter(coach_glb)
	add_child(coach_body)
	var coach_skel := coach_body.find_children("*", "Skeleton3D", true, false)[0] as Skeleton3D
	var coach_ap := coach_body.find_children("*", "AnimationPlayer", true, false)[0] as AnimationPlayer
	FightClips.load_into(coach_ap, coach_skel, true)
	FighterKit._dress_metahuman(coach_body, coach_skel, load(FighterKit.BOOT_PATH))
	coach_body.position = Vector3(0, 0, LONG_RANGE_M)
	coach_body.rotation = Vector3(0, PI, 0)
	var ik := CornerIK.attach(coach_skel, coach_body)
	coach = {"node": coach_body, "skel": coach_skel, "ap": coach_ap, "ik": ik}
	mitts = Mitts.new()
	mitts.name = "Mitts"
	coach_body.add_child(mitts)
	mitts.mount(coach_body)
	_build_gym_lighting()
	_play_idle()


func _build_gym_lighting() -> void:
	var env := WorldEnvironment.new()
	var e := Environment.new()
	e.background_mode = Environment.BG_COLOR
	e.background_color = Color(0.12, 0.10, 0.08)
	e.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	e.ambient_light_color = Color(0.40, 0.38, 0.35)
	e.ambient_light_energy = 0.5
	e.tonemap_mode = Environment.TONE_MAPPER_AGX
	e.tonemap_exposure = 1.3
	env.environment = e
	add_child(env)
	var key := DirectionalLight3D.new()
	key.rotation_degrees = Vector3(-50, -30, 0)
	key.light_energy = 1.6
	key.light_color = Color(1.0, 0.95, 0.88)
	key.shadow_enabled = true
	add_child(key)
	var fill := DirectionalLight3D.new()
	fill.rotation_degrees = Vector3(-25, 140, 0)
	fill.light_energy = 0.6
	fill.light_color = Color(0.85, 0.88, 0.95)
	add_child(fill)
	var overhead := OmniLight3D.new()
	overhead.position = Vector3(0, 3.5, LONG_RANGE_M * 0.5)
	overhead.omni_range = 5.0
	overhead.light_energy = 1.2
	overhead.light_color = Color(1.0, 0.97, 0.92)
	add_child(overhead)


func _play_idle() -> void:
	var b_ap: AnimationPlayer = boxer["ap"]
	var c_ap: AnimationPlayer = coach["ap"]
	if b_ap.has_animation("pro_idle"): b_ap.play("pro_idle")
	elif b_ap.has_animation("idle"): b_ap.play("idle")
	if c_ap.has_animation("af_idle"): c_ap.play("af_idle")


## Computes mitt targets by sampling the boxer's glove at each punch's contact time.
## Returns an array of Vector3 positions (one per punch in the combo).
## Must be awaited to complete.
func compute_mitt_targets(combo_id: String) -> Array:
	var row := Combos.row(combo_id)
	if row.is_empty():
		return []
	var beats: Array = row["beats"]
	var clips: Array = MoveClips.clips(combo_id)
	var targets: Array = []
	for i in beats.size():
		var beat: String = str(beats[i])
		var clip: String = str(clips[i]) if i < clips.size() else beat
		var boxer_hand := "Left" if beat in ["jab", "lead_hook", "lead_uppercut"] else "Right"
		var glove_at_contact: Vector3 = await _sample_glove_at_contact(clip, boxer_hand)
		if glove_at_contact.length() > 0.01:
			# Place mitt at glove position, offset towards the coach by glove radius so they meet face to face.
			var b_node: Node3D = boxer["node"]
			var b_fwd: Vector3 = b_node.global_transform.basis.z.normalized()
			targets.append(glove_at_contact + b_fwd * GLOVE_RADIUS_M)
		else:
			targets.append(_calc_aim_fallback(clip, "Left" if boxer_hand == "Left" else "Right"))
	_mitt_targets_ready = true
	return targets


## Samples the boxer's glove position at the clip's contact time.
func _sample_glove_at_contact(clip: String, hand: String) -> Vector3:
	var b_ap: AnimationPlayer = boxer["ap"]
	if not b_ap.has_animation(clip):
		return Vector3.ZERO
	var contact_s: float = BeatClips.contact(clip, 0.4)
	# Save current animation state.
	var prev_anim := b_ap.current_animation
	var prev_pos := b_ap.current_animation_position
	# Play the clip and seek to contact time.
	b_ap.play(clip)
	b_ap.seek(contact_s, true)
	# Force skeleton update by waiting frames.
	for i in 3:
		await get_tree().process_frame
	# Read glove position.
	var glove_pos: Vector3 = glove_real_pos(hand)
	# Restore previous animation.
	if prev_anim != "" and b_ap.has_animation(prev_anim):
		b_ap.play(prev_anim)
		b_ap.seek(prev_pos, true)
	return glove_pos


func play(combo_id: String, loops: int = 1) -> void:
	var row := Combos.row(combo_id)
	if row.is_empty():
		done.emit()
		return
	var beats: Array = row["beats"]
	var clips: Array = MoveClips.clips(combo_id)
	_punches.clear()
	var cum_t := 0.0
	for i in beats.size():
		var beat: String = str(beats[i])
		var clip: String = str(clips[i]) if i < clips.size() else beat
		var aim_side := "Left" if beat in ["jab", "lead_hook", "lead_uppercut"] else "Right"
		var contact_s: float = BeatClips.contact(clip, 0.4)
		var boxer_hand := "Left" if aim_side == "Left" else "Right"
		var coach_mitt_side := "Right" if boxer_hand == "Left" else "Left"
		_punches.append({"clip": clip, "beat": beat, "contact_s": contact_s,
			"clip_start_t": cum_t, "aim_side": aim_side, "boxer_hand": boxer_hand,
			"coach_mitt_side": coach_mitt_side,
			"mitt_target": Vector3.ZERO, "mitt_set": false,
			"started": false, "pop_t": -1.0})
		cum_t += contact_s + 0.25
	_playing = true
	_t = 0.0
	if _punches.size() > 0:
		_do_start_punch(0)


## Sets the mitt targets from a pre-computed array (from compute_mitt_targets).
func set_mitt_targets(targets: Array) -> void:
	for i in mini(targets.size(), _punches.size()):
		_punches[i]["mitt_target"] = targets[i]


func _calc_aim_fallback(clip: String, aim_side: String) -> Vector3:
	var b_node: Node3D = boxer["node"]
	var fwd := b_node.global_transform.basis.z.normalized()
	var pos := b_node.global_position
	var row := BeatClips.contact_row(clip)
	var reach: float = 0.30
	if row is Dictionary and row.has("reach_m"): reach = float(row["reach_m"])
	var off := -0.08 if aim_side == "Left" else 0.08
	return pos + fwd * (LONG_RANGE_M - reach) + Vector3(off, 1.35, 0)


func start_punch(i: int, clip: String, beat: String) -> void:
	while _punches.size() <= i:
		_punches.append({"clip": "", "beat": "", "contact_s": 0.0, "clip_start_t": 0.0,
			"aim_side": "Left", "boxer_hand": "Left", "coach_mitt_side": "Right",
			"mitt_target": Vector3.ZERO, "mitt_set": false, "started": false, "pop_t": -1.0})
	var p: Dictionary = _punches[i]
	p["clip"] = clip
	p["beat"] = beat
	p["started"] = true
	p["pop_t"] = -1.0
	p["contact_s"] = BeatClips.contact(clip, 0.4)
	p["aim_side"] = "Left" if beat in ["jab", "lead_hook", "lead_uppercut"] else "Right"
	p["boxer_hand"] = "Left" if p["aim_side"] == "Left" else "Right"
	p["coach_mitt_side"] = "Right" if p["boxer_hand"] == "Left" else "Left"
	var b_ap: AnimationPlayer = boxer["ap"]
	if b_ap.has_animation(clip): b_ap.play(clip)
	# Raise the mitt to its pre-computed target.
	_raise_mitt(i)


func _do_start_punch(i: int) -> void:
	if i >= _punches.size(): return
	var p: Dictionary = _punches[i]
	start_punch(i, str(p["clip"]), str(p["beat"]))


func _raise_mitt(i: int) -> void:
	var p: Dictionary = _punches[i]
	var side: String = str(p["coach_mitt_side"])
	var target: Vector3 = p["mitt_target"]
	if target.length() < 0.01:
		target = _calc_aim_fallback(str(p["clip"]), str(p["aim_side"]))
		p["mitt_target"] = target
	var ik = coach["ik"]
	if ik != null: ik.reach(side, func(): return target)
	if mitts != null:
		mitts.set_target_pos(side, target)
		mitts.position_mitt(side, target)
	p["mitt_set"] = true


func glove_real_pos(hand: String) -> Vector3:
	var gl: Node = boxer.get("gloves")
	if gl == null: return Vector3.ZERO
	var side_key := "l" if hand.begins_with("Left") else "r"
	var g: Node3D = gl.gloves.get(side_key)
	if g == null: return Vector3.ZERO
	var front_m: float = float(boxer.get("front_m", 0.15))
	return g.global_position + g.global_transform.basis.y.normalized() * front_m


func get_mitt_pos(side: String) -> Vector3:
	if mitts == null: return Vector3.ZERO
	return mitts.mitt_pos(side)


func _process(delta: float) -> void:
	if not _playing: return
	_t += delta
	var all_done := true
	for i in _punches.size():
		var p: Dictionary = _punches[i]
		if not bool(p["started"]):
			var clip_start: float = float(p.get("clip_start_t", 0.0))
			if _t >= clip_start - RAISE_LEAD_S and not bool(p.get("mitt_set", false)):
				# Raise mitt 0.25s before punch starts.
				_raise_mitt(i)
			if _t >= clip_start:
				_do_start_punch(i)
			else:
				all_done = false
			continue
		var cs: float = float(p["contact_s"])
		var clip_start: float = float(p.get("clip_start_t", 0.0))
		var abs_contact: float = clip_start + cs
		if _t >= abs_contact and float(p["pop_t"]) < 0.0:
			p["pop_t"] = _t
			_pop_mitt(i)
		if _t < abs_contact + 0.3: all_done = false
	if all_done and _t > 0.5:
		_playing = false
		_play_idle()
		done.emit()


func _pop_mitt(i: int) -> void:
	var p: Dictionary = _punches[i]
	var side: String = str(p["coach_mitt_side"])
	var aim: Vector3 = p["mitt_target"]
	var b_node: Node3D = boxer["node"]
	var to_boxer := (b_node.global_position - aim).normalized()
	var pop_pos := aim + to_boxer * POP_BACK_M
	if mitts != null: mitts.set_target_pos(side, pop_pos)
	var ik = coach["ik"]
	if ik != null: ik.reach(side, func(): return pop_pos)
