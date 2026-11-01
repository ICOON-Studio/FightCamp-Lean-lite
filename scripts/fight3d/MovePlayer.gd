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
const SM := preload("res://scripts/rules/StrikeMap.gd")
const UI := preload("res://scripts/ui/UI.gd")

const BODY_PATH := "res://assets/models/metahuman/mh_boxer_11.glb"
const GHOST_ALPHA := 0.30
const GUARD_HOLD_S := 0.8
const HER_COLOR := Color(0.78, 0.08, 0.08)
const GHOST_COLOR := Color(0.6, 0.8, 1.0)
const DEFAULT_RANGE_M := 0.6
const ROPE_RANGE_M := 0.9
const MIN_GAP_M := 0.45
const FRAME_MARGIN := 0.04

signal looped

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
	var spec_a := {"glb": BODY_PATH, "corner": "red", "stance": "orthodox", "scale": 1.0}
	var spec_b := {"glb": BODY_PATH, "corner": "blue", "stance": "orthodox", "scale": 1.0}
	_stage.setup(spec_a, spec_b)
	# Hide the ring (ropes, posts, crowd) but keep the floor
	_hide_ring()
	# Apply ghost material to boxer 1
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
	_update_camera()

func _apply_ghost_material(body: Node3D) -> void:
	var ghost_mat := StandardMaterial3D.new()
	ghost_mat.albedo_color = Color(GHOST_COLOR.r, GHOST_COLOR.g, GHOST_COLOR.b, GHOST_ALPHA)
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
	var env := WorldEnvironment.new()
	var e := Environment.new()
	e.background_mode = Environment.BG_COLOR
	e.background_color = UI.BG.darkened(0.3)
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
	cyl.top_radius = 1.5
	cyl.bottom_radius = 1.5
	cyl.height = 0.02
	floor_mi.mesh = cyl
	var floor_mat := StandardMaterial3D.new()
	floor_mat.albedo_color = Color(0.15, 0.18, 0.22)
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
	# S345: both women head to feet (fov 35 shows 2.1 m of height at 3.4 m; at 2.5 m it cut them at the shins).
	var dist := maxf(_gap_m * 1.8, 3.4)
	_cam.position = Vector3(dist, 1.0, mid_z)
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
	_clip_start_t += delta
	# Track min gap (pelvis to pelvis on the bodies)
	var gap_now := _measure_gap()
	if gap_now < _min_gap:
		_min_gap = gap_now
	# A clip advances on its own length (S343: a finished clip leaves current_animation empty).
	if _clip_idx < _clips.size() and not _looping:
		var clip := str(_clips[_clip_idx])
		var who := 1 if _is_forced else 0
		var ap: AnimationPlayer = _stage.boxers[who]["ap"]
		if not ap.has_animation(clip) or _clip_start_t >= ap.get_animation(clip).length:
			_clip_idx += 1
			if _clip_idx < _clips.size():
				_play_next_clip()
			else:
				_hold_t = 0.0
				_looping = true
				_stage.guard(who)
	# Check reach at contact for punch clips
	if _clip_idx < _clips.size():
		var clip := str(_clips[_clip_idx])
		if _is_punch_clip(clip) and _reach_at_contact < 0.0:
			var contact_s := BeatClips.contact(clip, 8.0/30.0)
			if _clip_start_t >= contact_s:
				_reach_at_contact = _measure_reach()
	if _looping:
		_hold_t += delta
		if _hold_t >= GUARD_HOLD_S:
			emit_signal("looped")
			_clip_idx = 0
			_looping = false
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
	# Play the clip using stage.play() like BeatFire
	var contact_s := BeatClips.contact(clip, 8.0/30.0)
	_stage.play(who, clip, 1.0, 0.0)
	_started_idx = maxi(_started_idx, _clip_idx + 1)   # the clips started at least once (a loop does not reset it)
	_clip_start_t = 0.0
	# For punches, land them using stage.land() like BeatFire._punch
	if _is_punch_clip(clip) and not _is_forced:
		var is_body := clip.contains("body")
		_stage.land(who, clip, is_body, 0.0, contact_s)
		# Schedule ghost reaction at contact
		_schedule_ghost_react(contact_s, clip)
	else:
		# Ghost stays in guard for non-punch clips
		_stage.guard(1)

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
	var react := BeatClips.react("jab" if not clip.contains("body") else "body_hook", false, _stage.has_move, 0.0, false)
	if react == "" or not _stage.has_move(react) or not is_inside_tree():
		return
	var id := _clip_idx
	get_tree().create_timer(contact_s).timeout.connect(func():
		if _playing and _clip_idx == id:
			_stage.play(1, react, 1.0, 0.0))

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
