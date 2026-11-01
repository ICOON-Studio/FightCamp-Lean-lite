extends Control
const MH := preload("res://scripts/fight3d/MHRig.gd")
const FightClips := preload("res://scripts/fight3d/FightClips.gd")
const BeatClips := preload("res://scripts/fight3d/BeatClips.gd")
const FighterKit := preload("res://scripts/fight3d/FighterKit.gd")
const JoinSmoother := preload("res://scripts/fight3d/JoinSmoother.gd")
const MoveClips := preload("res://scripts/fight3d/MoveClips.gd")
const SM := preload("res://scripts/rules/StrikeMap.gd")
const UI := preload("res://scripts/ui/UI.gd")
const BODY_PATH := "res://assets/models/metahuman/mh_boxer_11.glb"
const GHOST_ALPHA := 0.30
const GUARD_HOLD_S := 0.8
const HER_COLOR := Color(0.78, 0.08, 0.08)
const GHOST_COLOR := Color(0.6, 0.8, 1.0)
const DEFAULT_RANGE_M := 0.6
signal looped
var _vp: SubViewport
var _world: Node3D
var _cam: Camera3D
var _her_body: Node3D
var _ghost_body: Node3D
var _her_skel: Skeleton3D
var _ghost_skel: Skeleton3D
var _her_ap: AnimationPlayer
var _ghost_ap: AnimationPlayer
var _her_js: Node
var _ghost_js: Node
var _clips: Array = []
var _clip_idx := 0
var _started_idx := 0  # tracks how many clips have been started
var _playing := false
var _hold_t := 0.0
var _looping := false
var _move_id := ""
var _gap_m := 1.0
var _clip_start_t := 0.0  # seconds the current clip has played
var _first_gap := -1.0  # the pelvis gap measured on the move's first frame
func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_build_viewport()
	_build_bodies()
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
func _build_bodies() -> void:
	_her_body = MH.load_fighter(BODY_PATH)
	_world.add_child(_her_body)
	MH.colour_trunks(_her_body, Color(0.38, 0.03, 0.03), 0.65)
	FighterKit.colour_vest(_her_body, HER_COLOR, 0.65)
	FighterKit.cloth_normals(_her_body)
	FighterKit.dress(_her_body, BODY_PATH, "boxing")
	_her_skel = _her_body.find_children("*", "Skeleton3D", true, false)[0] as Skeleton3D
	_her_ap = _her_body.find_children("*", "AnimationPlayer", true, false)[0] as AnimationPlayer
	FightClips.load_into(_her_ap, _her_skel)
	_her_js = _setup_js(_her_skel, _her_ap)
	_ghost_body = MH.load_fighter(BODY_PATH)
	_world.add_child(_ghost_body)
	_apply_ghost_material(_ghost_body)
	_ghost_skel = _ghost_body.find_children("*", "Skeleton3D", true, false)[0] as Skeleton3D
	_ghost_ap = _ghost_body.find_children("*", "AnimationPlayer", true, false)[0] as AnimationPlayer
	FightClips.load_into(_ghost_ap, _ghost_skel)
	_ghost_js = _setup_js(_ghost_skel, _ghost_ap)
func _setup_js(skel: Skeleton3D, ap: AnimationPlayer) -> Node:
	var js := JoinSmoother.new()
	if (js as JoinSmoother).setup(skel, _track_bones(ap)):
		skel.add_child(js)
		skel.move_child(js, 0)
		return js
	js.free()
	return null
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
func _track_bones(ap: AnimationPlayer) -> Array:
	var out: Array = []
	for clip in ["pro_idle", "idle", "pro_left_jab", "jab"]:
		if not ap.has_animation(clip):
			continue
		var anim := ap.get_animation(clip)
		for i in anim.get_track_count():
			var bone := str(anim.track_get_path(i).get_concatenated_subnames())
			if bone != "" and not out.has(bone):
				out.append(bone)
	return out
func show_move(move_id: String) -> void:
	_move_id = move_id
	var mv := SM.move(move_id)
	if mv.is_empty():
		return
	var from_id := str(mv["from"])
	var card := SM.card(from_id)
	var range_m: Array = card.get("range_m", [])
	if range_m.size() >= 2:
		_gap_m = (float(range_m[0]) + float(range_m[1])) * 0.5
	else:
		# Cards with no range_m (own_ropes, opp_ropes, corner, clinch)
		if from_id == "clinch":
			_gap_m = 0.225
		else:
			_gap_m = DEFAULT_RANGE_M
	_place_boxers()
	_clips = MoveClips.clips(move_id)
	_first_gap = -1.0
	_clip_idx = 0
	_started_idx = 0
	_playing = true
	_hold_t = 0.0
	_looping = false
	_start_guard()
	# Start the first clip
	if _clips.size() > 0:
		_play_next_clip()
func _place_boxers() -> void:
	# Side-on: her on the left (-X), ghost on the right (+X), facing each other
	var half_gap := _gap_m * 0.5
	_her_body.position = Vector3(-half_gap, 0, 0)
	_her_body.rotation_degrees = Vector3(0, 90, 0)  # facing +X (toward ghost)
	_ghost_body.position = Vector3(half_gap, 0, 0)
	_ghost_body.rotation_degrees = Vector3(0, -90, 0)  # facing -X (toward her)
	_update_camera()
func _update_camera() -> void:
	# Side-on at chest height, both bodies in frame
	var mid_x := (_her_body.position.x + _ghost_body.position.x) * 0.5
	var chest_y := 1.2
	var dist := maxf(_gap_m * 1.8, 2.5)
	_cam.position = Vector3(mid_x, chest_y, dist)
	_cam.look_at(Vector3(mid_x, chest_y * 0.9, 0), Vector3.UP)
func _start_guard() -> void:
	# Both start in guard
	var guard := BeatClips.first(BeatClips.GUARD, _her_ap.has_animation)
	if guard != "":
		_her_ap.play(guard)
		_her_ap.seek(0.0, true)
	var ghost_guard := BeatClips.first(BeatClips.GUARD, _ghost_ap.has_animation)
	if ghost_guard != "":
		_ghost_ap.play(ghost_guard)
		_ghost_ap.seek(0.0, true)
func stop() -> void:
	_playing = false
	_clips = []
	_clip_idx = 0
func _process(delta: float) -> void:
	if not _playing:
		return
	if _her_ap == null or _ghost_ap == null:
		return
	if _first_gap < 0.0:
		_first_gap = _measure_gap()
	_clip_start_t += delta
	# S343 (Claude, collecting: the probe on a real GPU read 3/5 - a finished clip leaves current_animation empty, so the
	# old "is it still this clip at its end" check never fired and the double jab and the pivot stopped after one clip):
	# a clip advances on its own length.
	if _clip_idx < _clips.size() and not _looping:
		var clip := str(_clips[_clip_idx])
		if not _her_ap.has_animation(clip) or _clip_start_t >= _her_ap.get_animation(clip).length:
			_clip_idx += 1
			if _clip_idx < _clips.size():
				_play_next_clip()
			else:
				_hold_t = 0.0
				_looping = true
				var guard := BeatClips.first(BeatClips.GUARD, _her_ap.has_animation)
				if guard != "":
					if _her_js != null:
						(_her_js as JoinSmoother).join()
					_her_ap.play(guard)
	if _looping:
		_hold_t += delta
		if _hold_t >= GUARD_HOLD_S:
			emit_signal("looped")
			# Loop: restart from first clip
			_clip_idx = 0
			_looping = false
			_play_next_clip()
func _play_next_clip() -> void:
	if _clip_idx >= _clips.size():
		return
	var clip := str(_clips[_clip_idx])
	if not _her_ap.has_animation(clip):
		_clip_idx += 1
		_play_next_clip()
		return
	# Play on her (from its first frame, also when the same clip plays twice in a row: the double jab)
	if _her_js != null:
		(_her_js as JoinSmoother).join()
	_her_ap.stop()
	_her_ap.play(clip, 0.0, 1.0)
	_her_ap.seek(0.0, true)
	_started_idx = maxi(_started_idx, _clip_idx + 1)   # the clips started at least once (a loop does not reset it)
	_clip_start_t = 0.0
	# Ghost plays a light hit reaction at contact time (for punches)
	if _is_punch_clip(clip):
		var contact_s := BeatClips.contact(clip, 0.27)
		_schedule_ghost_react(contact_s)
	else:
		# Ghost stays in guard for non-punch clips
		var guard := BeatClips.first(BeatClips.GUARD, _ghost_ap.has_animation)
		if guard != "":
			_ghost_ap.play(guard)
func _is_punch_clip(clip: String) -> bool:
	return clip.contains("jab") or clip.contains("cross") or clip.contains("hook") or clip.contains("uppercut") or clip.contains("body_shot")
## S343: the ghost's light hit reaction lands when her glove does (clip_contact.json via BeatClips.contact), not as she
## starts the punch.
func _schedule_ghost_react(contact_s: float) -> void:
	var react := BeatClips.react("jab", false, _ghost_ap.has_animation, 0.0, false)
	if react == "" or not _ghost_ap.has_animation(react) or not is_inside_tree():
		return
	var id := _clip_idx
	get_tree().create_timer(contact_s).timeout.connect(func():
		if not _playing or _clip_idx != id:
			return
		if _ghost_js != null:
			(_ghost_js as JoinSmoother).join()
		_ghost_ap.play(react, 0.0, 1.0))
func played_clips() -> Array:
	return _clips.slice(0, _started_idx)
## S343 measured on the bodies (the probe read back the values it set): the pelvis gap at the move's first frame, and the
## alpha her and the ghost's surfaces actually draw with.
func pelvis_gap() -> float:
	return _first_gap
func _measure_gap() -> float:
	var a := _bone_at(_her_skel, "Hips")
	var b := _bone_at(_ghost_skel, "Hips")
	return Vector2(a.x - b.x, a.z - b.z).length()
func _bone_at(skel: Skeleton3D, bone: String) -> Vector3:
	var i := skel.find_bone(bone)
	return skel.global_transform * skel.get_bone_global_pose(i).origin if i >= 0 else skel.global_position
func ghost_alpha() -> float:
	return _surface_alpha(_ghost_body)
func her_alpha() -> float:
	return _surface_alpha(_her_body)
## The highest alpha any surface of a body draws with (its override, else its own material).
func _surface_alpha(body: Node3D) -> float:
	var top := 0.0
	for m in body.find_children("*", "MeshInstance3D", true, false):
		var mi := m as MeshInstance3D
		for s in mi.mesh.get_surface_count():
			var mat := mi.get_surface_override_material(s)
			if mat == null:
				mat = mi.mesh.surface_get_material(s)
			var sm := mat as BaseMaterial3D
			var transparent := sm != null and sm.transparency != BaseMaterial3D.TRANSPARENCY_DISABLED
			top = maxf(top, sm.albedo_color.a if transparent else 1.0)
	return top
func bodies_in_frame() -> bool:
	if _cam == null or _her_skel == null or _ghost_skel == null:
		return false
	var vp_size := _vp.get_visible_rect().size
	if vp_size.x <= 0 or vp_size.y <= 0:
		return false
	for skel in [_her_skel, _ghost_skel]:
		for bone_name in ["Hips", "Head"]:
			var bone_idx: int = skel.find_bone(str(bone_name))
			if bone_idx < 0:
				continue
			var world_pos: Vector3 = skel.global_transform * skel.get_bone_global_pose(bone_idx).origin
			var projected: Vector2 = _cam.unproject_position(world_pos)
			if projected.x < 0 or projected.x > vp_size.x or projected.y < 0 or projected.y > vp_size.y:
				return false
	return true
