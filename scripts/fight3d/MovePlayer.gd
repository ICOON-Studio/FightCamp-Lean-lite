extends Control
## S342 MOVEPLAYER1 (Round 2): the move map's player. Uses a FightStage inside the SubViewport
## with two boxers built by BoxerBuild (gloves, boots, kit). The ring is hidden. The opponent is
## a ghost (translucent). Punches land with stage.play() + stage.land() like BeatFire._punch.
## Tracks reach at contact and min_gap over the move. Rope cards show a rope line.
## S344 (Claude, collecting round 2 onto main): the S343 fixes kept - a clip advances on its own length (a finished clip
## leaves current_animation empty, so round 2's end check never fired: "Only 1 clip playing"), the ghost's reaction lands
## at the glove's contact, and the probe's gap and alphas are measured on the bodies, never read back from what was set.

const FightStage := preload("res://scripts/fight3d/FightStage.gd")
const MoveClips := preload("res://scripts/fight3d/MoveClips.gd")
const BeatClips := preload("res://scripts/fight3d/BeatClips.gd")
const Footwork := preload("res://scripts/fight3d/Footwork.gd")
const IdleMatch := preload("res://scripts/fight3d/IdleMatch.gd")
const SM := preload("res://scripts/rules/StrikeMap.gd")
const UI := preload("res://scripts/ui/UI.gd")
const MoveStudio := preload("res://scripts/fight3d/MoveStudio.gd")

const BODY_PATH := "res://assets/models/metahuman/mh_boxer_11.glb"
const GHOST_ALPHA := 0.30
const GUARD_HOLD_S := 0.8
## S359 a combination's next punch starts this long after the last one's contact (under combo_skip's 0.30 s window).
const CHAIN_AFTER_S := 0.05
## A defence after a punch starts this long after its contact (the glove on its way back). A slip or roll hands over at
## its deepest point, MEASURED per clip by tools/defence_peak_probe.gd (S359: the head furthest from its start against
## the hips, 1x seconds); a clip not measured uses the median share 0.37 of its length.
const PUNCH_TO_DEF_S := 0.15
const DEF_PEAK_S := {"slip": 0.27, "pull": 0.13, "pro_left_weave": 0.40, "pro_right_weave": 0.53, "pro_back_weave": 0.40,
	"pro_quick_weave": 0.50, "pro_left_dodge": 0.93, "pro_right_dodge": 0.70, "mc_dodge_left": 0.93, "mc_dodge_right": 0.70}
const DEF_SHARE := 0.37
## S361 TASK_ZIVAFOOT1 how long each hand-over blends, seconds - a blend per pair, not one constant.
## The operator ("slip and roll are good, still need a lot of smoothing and better timing blending"): a clip change used to
## land inside one frame. FightStage.play() starts every clip with play(name, 0.0) because its join smoother is meant to
## carry the join; on the Playbook's body the smoother cannot (two reader modifiers at either end of the modifier stack read
## the SAME pose every frame, and it is the clip's raw pose: the switch is what the viewer sees). So the player starts its
## own clips with Godot's cross-fade, play(name, custom_blend), which blends the pose she is showing into the new clip over
## the pair's blend time. tools/join_probe.gd BEFORE: worst one-frame turn 95 deg (head, the slip's counter), 59.6 (shin,
## the return to guard), mean 31 over the ten moves.
const JOIN_PUNCH_S := 0.16     # punch -> punch: the chain keeps its snap (a follow-up hands over just after contact)
const JOIN_STRIKE_S := 0.13    # punch -> defence or defence-clip free joins that are not the counter
const JOIN_DEF_S := 0.16       # into or out of a slip / weave / dodge: the head comes off the line without a step
const JOIN_GUARD_S := 0.24     # the return to the guard, eased (FightStage.GUARD_JOIN_S's own join is slower still)
const JOIN_STEP_S := 0.14      # a step's glide, a feint, and everything else
## The clip she leaves must still be playing when the next one starts: a finished clip leaves current_animation empty and
## takes the folder's _on_finished hand-over (FightStage.guard, play(name, 0.0)) with it, so no cross-fade is possible.
const JOIN_EPS_S := 0.05
## S361 the pivot's turn, spread over its frames instead of landing in one: the fight's circle step plays at
## Footwork.PIVOT_SCALE (1.3, the line turns 70 deg in ~0.32 s = ~7 deg on the pelvis a frame); the Playbook plays the same
## arc slower, so the turn is spread over ~0.49 s. The arc travelled is the same, so the step still arrives where it did.
const PIVOT_JOIN_SCALE := 0.85
## S361 a slip / weave is HELD at its deepest frame (DEF_PEAK_S) this long before the counter starts: the head stays off
## the line while the counter is thrown from there (the operator's "better timing blending").
const DEF_HOLD_S := 0.10
## S359 the steps as the fight takes them (Footwork): clip -> [seconds at 1x, play scale]; a strafe is the fight's pivot
## (its seconds come from the gap). Step in = the entry lunge, step back = the exit step.
const TRAVEL := {"advance": [0.32, Footwork.LUNGE_SCALE], "retreat": [0.38, Footwork.EXIT_SCALE],
	"strafe_left": [0.0, Footwork.PIVOT_SCALE], "strafe_right": [0.0, Footwork.PIVOT_SCALE]}
var _clip_len := -1.0   # a step's length (no clip plays under it); -1 = the clip's own


func _has_travel() -> bool:
	for c in _clips:
		if TRAVEL.has(str(c)):
			return true
	return false
const HER_COLOR := Color(0.78, 0.08, 0.08)
const GHOST_COLOR := Color(0.6, 0.8, 1.0)
const DEFAULT_RANGE_M := 0.6
const ROPE_RANGE_M := 0.9
const MIN_GAP_M := 0.45
const FRAME_MARGIN := 0.04
const STUDIO_BG := Color("#e9ecee")
const STUDIO_FLOOR := Color("#d6dadd")
const STUDIO_GHOST := Color(0.30, 0.50, 0.82, 0.42)   # the pale ghost vanishes on a light backdrop

signal looped

## S348 the Playbook (Q-S294-71): her own body and the opponent's (Faces.pair), set before the player enters the tree; and
## the play speed (Slow motion = 0.35): clips, contacts, the hold and the ghost's reaction all run on it.
var bodies := [BODY_PATH, BODY_PATH]
var speed := 1.0
## S382 MOVETIP1 the hover card's studio look (MoveTip): a plain light floor and backdrop, the camera turned `yaw_deg`
## toward her front (side-front). Set before the player enters the tree; the Playbook's own player keeps the dark room.
var studio := false
var yaw_deg := 0.0
var _jabs := 0   # S382 the studio partner slips and blocks the jab in turn (MoveStudio)

var _vp: SubViewport
var _world: Node3D
var _stage: Node3D  # FightStage
var _cam: Camera3D
var _clips: Array = []
var _clip_idx := 0
var _started_idx := 0
var _playing := false
var _hold_t := 0.0
var _looping := false
var _move_id := ""
var _gap_m := 1.0
var _jab_gap_m := 1.0   # S345 the gap this pair's jab lands at (FightStage.gap_m): where the fight throws its punches
var _min_gap := 999.0
var _clip_start_t := 0.0
var _reach_at_contact := -1.0
var _is_forced := false
var _rope_line: Node3D = null
var _first_gap := -1.0  # the pelvis gap measured on the move's first frame

func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_build_viewport()
	_build_stage()
	_build_room()

func _build_viewport() -> void:
	var container := SubViewportContainer.new()
	container.stretch = true
	container.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(container)
	_vp = SubViewport.new()
	_vp.msaa_3d = Viewport.MSAA_4X
	_vp.world_3d = World3D.new()
	container.add_child(_vp)
	_world = Node3D.new()
	_vp.add_child(_world)

func _build_stage() -> void:
	# Create a FightStage inside the viewport
	_stage = FightStage.new()
	_world.add_child(_stage)
	# Set up two boxers
	var spec_a := {"glb": str(bodies[0]), "corner": "red", "stance": "orthodox", "scale": 1.0}
	var spec_b := {"glb": str(bodies[1]), "corner": "blue", "stance": "orthodox", "scale": 1.0}
	_stage.setup(spec_a, spec_b)
	# Hide the ring (ropes, posts, crowd) but keep the floor
	_hide_ring()
	# Apply ghost material to boxer 1 (S382 the studio's partner is solid and reacts: MoveStudio)
	if not studio:
		_apply_ghost_material(_stage.boxers[1]["node"])
	# Compute gap
	_gap_m = _stage.gap_m
	_jab_gap_m = _stage.gap_m
	# Place boxers side-on
	_place_boxers()

func _hide_ring() -> void:
	# Hide RingSet nodes (ropes, posts, crowd) but keep the floor
	var ring := _stage.find_children("RingSet", "Node3D", true, false)
	if not ring.is_empty():
		for child in ring[0].get_children():
			# Hide everything except the floor (if it's a separate node)
			if child is Node3D:
				child.visible = false

func _place_boxers() -> void:
	# Side-on: her on the left (-Z), ghost on the right (+Z), facing each other
	var half_gap := _gap_m * 0.5
	_stage.boxers[0]["pos"] = Vector3(0, 0, -half_gap)
	_stage.boxers[0]["node"].position = Vector3(0, 0, -half_gap)
	_stage.boxers[0]["node"].rotation_degrees = Vector3(0, 0, 0)
	_stage.boxers[1]["pos"] = Vector3(0, 0, half_gap)
	_stage.boxers[1]["node"].position = Vector3(0, 0, half_gap)
	_stage.boxers[1]["node"].rotation_degrees = Vector3(0, 180, 0)
	MoveStudio.settle(_stage)   # S382 a glide still under way (the studio partner giving ground) ends with the move
	_update_camera()

func _apply_ghost_material(body: Node3D) -> void:
	var ghost_mat := StandardMaterial3D.new()
	ghost_mat.albedo_color = STUDIO_GHOST if studio else Color(GHOST_COLOR.r, GHOST_COLOR.g, GHOST_COLOR.b, GHOST_ALPHA)
	ghost_mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	ghost_mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	ghost_mat.depth_draw_mode = BaseMaterial3D.DEPTH_DRAW_OPAQUE_ONLY
	ghost_mat.cull_mode = BaseMaterial3D.CULL_DISABLED
	for m in body.find_children("*", "MeshInstance3D", true, false):
		var mi := m as MeshInstance3D
		for s in mi.mesh.get_surface_count():
			mi.set_surface_override_material(s, ghost_mat)

func _build_room() -> void:
	# Environment
	if studio:   # the ring's own night-arena environment (RingSet) would win over the studio's light backdrop
		for we in _stage.find_children("*", "WorldEnvironment", true, false):
			we.get_parent().remove_child(we)   # out of the world now, before the studio's own registers
			we.queue_free()
		_cam = MoveStudio.room(_world, _stage)
		_update_camera()
		return
	var env := WorldEnvironment.new()
	var e := Environment.new()
	e.background_mode = Environment.BG_COLOR
	e.background_color = STUDIO_BG if studio else UI.BG.darkened(0.3)
	e.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	e.ambient_light_color = Color(0.7, 0.75, 0.8)
	e.ambient_light_energy = 0.5
	e.tonemap_mode = Environment.TONE_MAPPER_FILMIC
	env.environment = e
	_world.add_child(env)
	# Key light
	var sun := DirectionalLight3D.new()
	sun.rotation_degrees = Vector3(-45, 30, 0)
	sun.light_energy = 1.0
	sun.shadow_enabled = false
	_world.add_child(sun)
	# Floor disc
	var floor_mi := MeshInstance3D.new()
	var cyl := CylinderMesh.new()
	cyl.top_radius = 6.0 if studio else 1.5
	cyl.bottom_radius = cyl.top_radius
	cyl.height = 0.02
	floor_mi.mesh = cyl
	var floor_mat := StandardMaterial3D.new()
	floor_mat.albedo_color = STUDIO_FLOOR if studio else Color(0.15, 0.18, 0.22)
	floor_mat.roughness = 0.9
	floor_mi.material_override = floor_mat
	floor_mi.position = Vector3(0, -0.01, 0)
	_world.add_child(floor_mi)
	# Camera
	_cam = Camera3D.new()
	_cam.fov = 35.0
	_cam.current = true
	_world.add_child(_cam)
	_update_camera()

func _update_camera() -> void:
	if _cam == null:   # S345: _build_stage places the boxers before _build_room makes the camera
		return
	var mid_z: float = (_stage.boxers[0]["node"].position.z + _stage.boxers[1]["node"].position.z) * 0.5
	if studio:
		MoveStudio.aim(_cam, mid_z, _gap_m, yaw_deg)
		return
	# S345: both women head to feet (fov 35 shows 2.1 m of height at 3.4 m; at 2.5 m it cut them at the shins).
	var dist := maxf(_gap_m * 1.8, 3.4)
	var yaw := deg_to_rad(yaw_deg)
	_cam.position = Vector3(dist * cos(yaw), 1.0, mid_z + dist * sin(yaw))
	_cam.look_at(Vector3(0, 0.92, mid_z), Vector3.UP)

func show_move(move_id: String) -> void:
	_move_id = move_id
	var mv := SM.move(move_id)
	if mv.is_empty():
		return
	var from_id := str(mv["from"])
	var card := SM.card(from_id)
	var range_m: Array = card.get("range_m", [])
	_is_forced = str(mv.get("kind", "")) == "forced"
	# Determine gap
	if range_m.size() >= 2:
		_gap_m = (float(range_m[0]) + float(range_m[1])) * 0.5
	elif from_id in ["own_ropes", "opp_ropes", "corner"]:
		_gap_m = ROPE_RANGE_M
	elif from_id == "clinch":
		_gap_m = 0.225
	else:
		_gap_m = DEFAULT_RANGE_M
	# S345 (GPU probe: the double jab from the long card's middle stopped 0.16 m short of her face): a punch combination
	# starts where the fight throws it, at the pair's own jab gap - the card names the range, the bodies set the metre.
	if str(mv.get("kind", "")) == "combo":
		_gap_m = _jab_gap_m
	_place_boxers()
	_clips = MoveClips.clips(move_id)
	_clip_idx = 0
	_started_idx = 0
	_playing = true
	_hold_t = 0.0
	_looping = false
	_min_gap = 999.0
	_reach_at_contact = -1.0
	_first_gap = -1.0
	# Add rope line for rope cards
	_remove_rope_line()
	if from_id in ["own_ropes", "opp_ropes", "corner"]:
		_add_rope_line()
	# Start both in guard
	_stage.guard(0)
	_stage.guard(1)
	# Start the first clip
	if _clips.size() > 0:
		_play_next_clip()

## S349 the Playbook's Combos tab: play a chain the player built (clip names in order) from the pair's jab gap, on a loop.
func show_chain(clips: Array) -> void:
	_move_id = ""
	_is_forced = false
	_gap_m = _jab_gap_m
	_place_boxers()
	_clips = clips.duplicate()
	_clip_idx = 0
	_started_idx = 0
	_playing = not _clips.is_empty()
	_hold_t = 0.0
	_looping = false
	_min_gap = 999.0
	_reach_at_contact = -1.0
	_first_gap = -1.0
	_remove_rope_line()
	_stage.guard(0)
	_stage.guard(1)
	if _playing:
		_play_next_clip()


func _add_rope_line() -> void:
	_rope_line = Node3D.new()
	var cyl := CylinderMesh.new()
	cyl.top_radius = 0.02
	cyl.bottom_radius = 0.02
	cyl.height = 2.0
	var mi := MeshInstance3D.new()
	mi.mesh = cyl
	var mat := StandardMaterial3D.new()
	mat.albedo_color = Color(0.8, 0.8, 0.8)
	mi.material_override = mat
	_rope_line.add_child(mi)
	if _is_forced or str(SM.move(_move_id).get("from", "")) == "own_ropes":
		_rope_line.position = Vector3(0, 1.0, _stage.boxers[0]["node"].position.z - 0.3)
	else:
		_rope_line.position = Vector3(0, 1.0, _stage.boxers[1]["node"].position.z + 0.3)
	_world.add_child(_rope_line)

func _remove_rope_line() -> void:
	if _rope_line != null and is_instance_valid(_rope_line):
		_rope_line.queue_free()
		_rope_line = null

func stop() -> void:
	_playing = false
	_clips = []
	_clip_idx = 0

func _process(delta: float) -> void:
	if not _playing:
		return
	if _stage == null or _stage.boxers.is_empty():
		return
	if _first_gap < 0.0:
		_first_gap = _measure_gap()
	_clip_start_t += delta * speed
	# Track min gap (pelvis to pelvis on the bodies)
	var gap_now := _measure_gap()
	if gap_now < _min_gap:
		_min_gap = gap_now
	# A clip advances on its own length (S343: a finished clip leaves current_animation empty).
	if _clip_idx < _clips.size() and not _looping:
		var clip := str(_clips[_clip_idx])
		var who := 1 if _is_forced else 0
		var ap: AnimationPlayer = _stage.boxers[who]["ap"]
		# S359 (operator: "i think it plays only 1 animation"; move_player_probe: a 1-2-3 played jab, guard, cross, guard,
		# hook): a punch followed by a punch hands over just after its contact, as the fight's combos do (BeatFire,
		# BeatClips.combo_skip), instead of waiting out its whole recovery in guard.
		var chain := _clip_idx + 1 < _clips.size() and _clip_len < 0.0 and _clip_start_t >= _handover(clip, str(_clips[_clip_idx + 1]), ap)
		var length := _clip_len if _clip_len >= 0.0 else (ap.get_animation(clip).length if ap.has_animation(clip) else 0.0)
		# S361 a clip that runs to its end hands over JOIN_EPS_S before it: a finished clip leaves current_animation empty
		# and the player no longer has the pose to cross-fade from (it would cut, the pop this task is about).
		var ends := length if _clip_len >= 0.0 else maxf(0.0, length - JOIN_EPS_S)
		if chain or _clip_start_t >= ends:
			_clip_idx += 1
			if _clip_idx < _clips.size():
				_play_next_clip()
			else:
				_hold_t = 0.0
				_looping = true
				_start_guard(who, JOIN_GUARD_S)   # S361 eased, not play(idle, 0.0)
	# S361 the slip / the weave is HELD at its deepest frame before the counter starts: the clip pauses at DEF_PEAK_S (the
	# head furthest off the line, tools/defence_peak_probe.gd), the head stays there, and the counter is thrown from it.
	if _clip_idx < _clips.size() and not _looping:
		var here := str(_clips[_clip_idx])
		var who_now := 1 if _is_forced else 0
		var ap_now: AnimationPlayer = _stage.boxers[who_now]["ap"]
		var peak := _peak_s(here, ap_now) if _is_defence_clip(here) else -1.0
		var next := str(_clips[_clip_idx + 1]) if _clip_idx + 1 < _clips.size() else ""
		var counted := _is_punch_clip(next) or _is_defence_clip(next)
		ap_now.speed_scale = 0.0 if peak >= 0.0 and counted and _clip_start_t >= peak and _clip_start_t < peak + DEF_HOLD_S else 1.0
		# S361 while a move plays, the player's own timeline owns her animation: the fight's fast-recovery cut (HitImpact)
		# would otherwise hand her to the guard with play(idle, 0.0) at a clip's back_s - a cut inside the move (BEFORE:
		# the weave's follow-on dodge was cut off this way, 32.9 deg on a thigh).
		_stage._cut[who_now] = {}
	# Check reach at contact for punch clips
	if _clip_idx < _clips.size():
		var clip := str(_clips[_clip_idx])
		if _is_punch_clip(clip) and _reach_at_contact < 0.0:
			var contact_s := BeatClips.contact(clip, 8.0/30.0)
			if _clip_start_t >= contact_s:
				_reach_at_contact = _measure_reach()
	if _looping:
		_hold_t += delta * speed
		if _hold_t >= GUARD_HOLD_S:
			emit_signal("looped")
			_clip_idx = 0
			_looping = false
			if _has_travel():
				_place_boxers()   # S359 a move that steps starts again from where it began
			_play_next_clip()

func _measure_gap() -> float:
	var a := _bone_at(_stage.boxers[0]["skel"], "Hips")
	var b := _bone_at(_stage.boxers[1]["skel"], "Hips")
	return Vector2(a.x - b.x, a.z - b.z).length()


func _bone_at(skel: Skeleton3D, bone: String) -> Vector3:
	var i := skel.find_bone(bone)
	return skel.global_transform * skel.get_bone_global_pose(i).origin if i >= 0 else skel.global_position

func _play_next_clip() -> void:
	if _clip_idx >= _clips.size():
		return
	var clip := str(_clips[_clip_idx])
	var who := 1 if _is_forced else 0
	var ap: AnimationPlayer = _stage.boxers[who]["ap"]
	if not _stage.has_move(clip):
		_clip_idx += 1
		_play_next_clip()
		return
	_clip_len = -1.0
	var blend := _join_s(str(_clips[_clip_idx - 1]) if _clip_idx > 0 else "", clip)
	# S359 (operator: "the pivot animation completely breaks ... something like a backkick", "step in animation also look so
	# weird"): advance / retreat / strafe are the old game's WALKING strides, which the fight stopped playing in S320 (glide
	# steps: her guard plays on, the body moves, FootPlant takes the steps). The player now steps as the fight does.
	if TRAVEL.has(clip):
		var secs := float(TRAVEL[clip][0])
		var sc := float(TRAVEL[clip][1])
		if clip.begins_with("strafe_"):
			# S361 the fight's pivot: a circle step at the held gap, the line turns PIVOT_DEG - over PIVOT_JOIN_SCALE, spread.
			sc = PIVOT_JOIN_SCALE
			secs = deg_to_rad(Footwork.PIVOT_DEG) * _gap_m / (float(Footwork.STRIDE[clip][0]) * sc)
		_stage._walk(who, clip, secs / speed, sc * speed)
		# S361 her guard plays on under the step, as the fight's glide steps do (Footwork: "her guard plays on, her body
		# moves"): the body glides while the guard is already up, so the end of the step does not hand over from a clip
		# that has finished (nothing to cross-fade from) - a move that steps out of a punch lands in her guard, eased.
		_start_guard(who, JOIN_GUARD_S)
		_clip_len = secs
		_started_idx = maxi(_started_idx, _clip_idx + 1)
		_clip_start_t = 0.0
		if who == 0:
			_stage.guard(1)
		return
	# Play the clip using stage.play() like BeatFire
	var contact_s := BeatClips.contact(clip, 8.0/30.0)
	# S359 a follow-up punch starts into its wind-up so it lands COMBO_LAND_S after the last (BeatClips.combo_skip, 1x time).
	var skip := 0.0
	if _is_punch_clip(clip) and _clip_idx > 0 and _is_punch_clip(str(_clips[_clip_idx - 1])):
		skip = BeatClips.combo_skip(contact_s, 1.0, -CHAIN_AFTER_S, 0.0, _same_hand(str(_clips[_clip_idx - 1]), clip))
	_start_clip(who, clip, speed, skip, blend)
	_started_idx = maxi(_started_idx, _clip_idx + 1)   # the clips started at least once (a loop does not reset it)
	_clip_start_t = skip
	# For punches, land them using stage.land() like BeatFire._punch
	if _is_punch_clip(clip) and not _is_forced and studio and MoveStudio.defends(_punch_kind(clip)):
		_jabs += 1   # S382 the studio's partner slips or blocks it: no glove carried onto his face
		var at := _clip_idx
		MoveStudio.defend(self, _stage, _jabs, (contact_s - skip) / speed, speed, func(): return _playing and _clip_idx == at)
	elif _is_punch_clip(clip) and not _is_forced:
		var is_body := clip.contains("body")
		_stage.land(who, clip, is_body, 0.0, (contact_s - skip) / speed)
		# Schedule ghost reaction at contact
		_schedule_ghost_react((contact_s - skip) / speed, clip)
	elif who == 0:
		# Ghost stays in guard for her non-punch clips. S359: a forced move is the ghost's own clip (backed_up, break,
		# spins_out) - guarding her here cancelled it, so those moves played nothing.
		_stage.guard(1)


## S361 TASK_ZIVAFOOT1 the blend a pair of clips gets: how long the pose she is showing takes to become the next clip.
func _join_s(prev: String, next: String) -> float:
	if _is_defence_clip(prev) or _is_defence_clip(next):
		return JOIN_DEF_S
	if _is_punch_clip(prev) and _is_punch_clip(next):
		return JOIN_PUNCH_S
	if _is_punch_clip(prev) or _is_punch_clip(next):
		return JOIN_STRIKE_S
	return JOIN_STEP_S


## S361 start `clip` on `who` through Godot's own cross-fade (the same bookkeeping FightStage.play does: the reach lowered,
## the recovery cut armed, the guard's own life cancelled), with the pair's blend time instead of play(name, 0.0).
func _start_clip(who: int, clip: String, speed: float, skip: float, blend: float) -> void:
	var bx: Dictionary = _stage.boxers[who]
	var ap: AnimationPlayer = bx["ap"]
	ap.speed_scale = 1.0
	bx["step_grace"] = 0.0
	_stage.life.cancel(who)
	if bx.get("reach") != null:
		(bx["reach"] as Node).disarm()
	# S322 (hit_gap_probe timing): play() on the clip already playing carries on from where it is, so a double jab's
	# second jab started 0.30 s in and passed its contact before the hit. A new move always starts its clip over.
	if str(ap.current_animation) == clip:
		ap.stop()
	ap.play(clip, blend, speed)
	if skip > 0.0:
		ap.seek(skip, true)
	var r := BeatClips.recovery(clip)
	_stage._cut[who] = {} if r.y <= 0.0 else {"clip": clip, "contact": r.x if r.x >= 0.15 else -1.0, "back": r.y,
		"fast": false, "scale": BeatClips.recover_scale(clip, speed)}
	# S361 the Playbook plays the move the map names, and nothing else: SideStep would follow a weave with its own dodge
	# clip (the fight's step off the line), a clip outside this move that then ends and hands her to the guard with
	# FightStage._on_finished's play(idle, 0.0) - BEFORE a 32.9 deg cut on a thigh, mid-move.
	_stage.side.arm(who, "")


## S361 the return to the guard, eased: the clip she leaves is still playing (JOIN_EPS_S), so the idle crosses in over
## `blend` seconds from the pose she is showing instead of cutting to a random point of the loop (FightStage.guard plays it
## at 0.0: BEFORE the probe read 59.6 deg on a shin at the feint's return).
func _start_guard(who: int, blend: float) -> void:
	var bx: Dictionary = _stage.boxers[who]
	var ap: AnimationPlayer = bx["ap"]
	var idle := BeatClips.first(BeatClips.GUARD, ap.has_animation)
	bx["step_grace"] = 0.0
	if idle == "" or str(ap.current_animation) == idle:
		return   # nothing to hand over from, or she is standing in it already
	var g: Array = _stage.life.settle(who, idle, ap.get_animation(idle).length)
	var at := IdleMatch.pick(bx, idle, float(g[2]), _stage.life.rng)
	ap.speed_scale = 1.0
	ap.play(idle, blend, float(g[1]))
	ap.seek(at, true)

## S359 (operator: "slip and roll are good, still need a lot of smoothing and better timing blending ... it's fun to do a
## roll+slip+uppercut"): where in `clip` (1x seconds) the next move of a chain takes over. Punch -> punch: just after
## contact (the fight's combo rhythm). Punch -> defence: as the glove comes back. Defence -> anything: at the slip's or
## roll's deepest point, where a counter is thrown from (the head is off the line, the legs loaded). Else the clip's end.
func _handover(clip: String, next: String, ap: AnimationPlayer) -> float:
	var length := ap.get_animation(clip).length if ap.has_animation(clip) else 0.0
	var last := maxf(0.0, length - JOIN_EPS_S)   # S361 hand over while the clip still plays: the cross-fade needs it
	if _is_punch_clip(clip):
		var contact := BeatClips.contact(clip, 8.0 / 30.0)
		if _is_punch_clip(next):
			return contact + CHAIN_AFTER_S
		if _is_defence_clip(next):
			return minf(last, contact + PUNCH_TO_DEF_S)
		# S361 she is back in her guard at back_s (clip_recovery.json): that is where the idle takes over. The player hands
		# over there instead of playing out the clip's tail, because the fight's fast-recovery cut is off (see _process).
		var back := BeatClips.recovery(clip).y
		return minf(last, back) if back > contact else last
	elif _is_defence_clip(clip) and (_is_punch_clip(next) or _is_defence_clip(next)):
		# S361 held at its deepest frame (DEF_HOLD_S) before the counter starts
		return minf(last, _peak_s(clip, ap) + DEF_HOLD_S + CHAIN_AFTER_S)
	return last


## S361 where the clip is deepest (the head furthest off the line, 1x seconds): the frame a counter is thrown from. The
## shares are tools/defence_peak_probe.gd's, measured on this body; an unmeasured clip uses DEF_SHARE of its length.
static func _peak_s(clip: String, ap: AnimationPlayer) -> float:
	var length := ap.get_animation(clip).length if ap.has_animation(clip) else 0.0
	return minf(length, float(DEF_PEAK_S.get(clip, length * DEF_SHARE)))


static func _is_defence_clip(clip: String) -> bool:
	return clip.contains("slip") or clip.contains("weave") or clip.contains("dodge") or clip.contains("pull") or clip.contains("roll")


## The punch a clip throws, as BeatClips.REACT names them.
static func _punch_kind(clip: String) -> String:
	if clip.contains("body"):
		return "body_hook"
	if clip.contains("uppercut"):
		return "rear_uppercut" if clip.contains("right") else "lead_uppercut"
	if clip.contains("hook"):
		return "rear_hook" if clip.contains("right") else "lead_hook"
	return "cross" if clip.contains("cross") else "jab"


static func _same_hand(a: String, b: String) -> bool:
	return (a.contains("left") or a.contains("jab")) == (b.contains("left") or b.contains("jab"))


func _is_punch_clip(clip: String) -> bool:
	return clip.contains("jab") or clip.contains("cross") or clip.contains("hook") or clip.contains("uppercut") or clip.contains("body_shot") or clip.contains("body_hook")

## S345: the front of the punching hand's glove to the point the fight aims it at (FightStage.target_point: her face in front of the
## head bone, or her ribs) - the measure the fight's own hit_gap_probe reads, not the head bone at the base of the skull.
func _measure_reach() -> float:
	var clip := str(_clips[_clip_idx]) if _clip_idx < _clips.size() else ""
	var hand: String = _stage.hand_of(0, str(BeatClips.contact_row(clip).get("hand", "RightHand" if clip.contains("cross") else "LeftHand")))
	return _stage.glove_front(0, hand).distance_to(_stage.target_point(1, clip.contains("body")))   # PunchRange.record's miss

## S343: the ghost's light hit reaction lands when her glove does (clip_contact.json via BeatClips.contact).
func _schedule_ghost_react(contact_s: float, clip: String) -> void:
	# S359: she reacts to the punch that hit her (every head punch played the jab's reaction).
	var react := BeatClips.react(_punch_kind(clip), false, _stage.has_move, randf(), false)
	if react == "" or not _stage.has_move(react) or not is_inside_tree():
		return
	var id := _clip_idx
	if studio:   # S382 he takes it: the punch's own take and the head snap / the body fold
		MoveStudio.take(self, _stage, _punch_kind(clip), contact_s, speed, _jabs, func(): return _playing and _clip_idx == id)
		return
	get_tree().create_timer(contact_s).timeout.connect(func():
		if _playing and _clip_idx == id:
			_stage.play(1, react, speed, 0.0))

func played_clips() -> Array:
	return _clips.slice(0, _started_idx)

## S343 measured on the bodies: the pelvis gap at the move's first frame, and the alpha her and the ghost's surfaces draw with.
func pelvis_gap() -> float:
	return _first_gap

func ghost_alpha() -> float:
	return _surface_alpha(_stage.boxers[1]["node"])

func her_alpha() -> float:
	return _surface_alpha(_stage.boxers[0]["node"])


## The highest alpha any surface of a body draws with (its override, else its own material).
func _surface_alpha(body: Node3D) -> float:
	var top := 0.0
	for m in body.find_children("*", "MeshInstance3D", true, false):
		var mi := m as MeshInstance3D
		if mi.mesh == null or not mi.visible:
			continue
		for s in mi.mesh.get_surface_count():
			var mat := mi.get_surface_override_material(s)
			if mat == null:
				mat = mi.material_override if mi.material_override != null else mi.mesh.surface_get_material(s)
			var sm := mat as BaseMaterial3D
			var transparent := sm != null and sm.transparency != BaseMaterial3D.TRANSPARENCY_DISABLED
			top = maxf(top, sm.albedo_color.a if transparent else 1.0)
	return top

func min_gap() -> float:
	return _min_gap if _min_gap < 999.0 else _gap_m

func reach_at_contact() -> float:
	return _reach_at_contact if _reach_at_contact >= 0.0 else 999.0

func bodies_in_frame() -> bool:
	if _cam == null or _stage == null or _stage.boxers.size() < 2:
		return false
	var vp_size := _vp.get_visible_rect().size
	if vp_size.x <= 0 or vp_size.y <= 0:
		return false
	var margin_x := vp_size.x * FRAME_MARGIN
	var margin_y := vp_size.y * FRAME_MARGIN
	for bx in _stage.boxers:
		var skel: Skeleton3D = bx["skel"]
		for bone_name in ["Head", "LeftFoot", "RightFoot"]:
			var bone_idx: int = skel.find_bone(bone_name)
			if bone_idx < 0:
				continue
			var world_pos: Vector3 = skel.global_transform * skel.get_bone_global_pose(bone_idx).origin
			var projected: Vector2 = _cam.unproject_position(world_pos)
			if projected.x < margin_x or projected.x > vp_size.x - margin_x:
				return false
			if projected.y < margin_y or projected.y > vp_size.y - margin_y:
				return false
	return true


## S345 the pair's jab gap (the probe expects a punch combination to start there).
func jab_gap() -> float:
	return _jab_gap_m
