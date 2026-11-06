extends Control
## PLAYBOOK > Combos: full-screen modal with a SubViewport that runs PadWork for the fighter and coach.
## tools/padwork_still.gd shows build + camera framing; we loop the book combination until Close.
##   PadView.open(main, fighter, combo_id)

const SCRIPT_PATH := "res://scripts/ui/PadView.gd"
const PadWork := preload("res://scripts/fight3d/PadWork.gd")
const Faces := preload("res://scripts/rules/Faces.gd")
const Combos := preload("res://scripts/rules/Combos.gd")
const MoveClips := preload("res://scripts/fight3d/MoveClips.gd")
const UI := preload("res://scripts/ui/UI.gd")

const COACH_GLB := "res://assets/models/metahuman/mh_staff_coach.glb"
const VP_W := 1280
const VP_H := 720
const MARGIN_FRAC := 0.04
## PadWork.play loops arg is unused today; we loop on done instead.
const LOOP_ARG := 9999
## S393: a breath in guard between rounds of the combination, so the loop reads as a boxer resetting.
const LOOP_REST_S := 1.0

var _fighter: Dictionary
var _combo_id: String
var _closing := false
var _vp: SubViewport
var _pw: Node3D
var _pad_done_connected := false
var _targets: Array = []


static func open(root: Node, fighter: Dictionary, combo_id: String) -> void:
	var pv: Control = load(SCRIPT_PATH).new()
	pv.name = "PadView"
	pv._fighter = fighter
	pv._combo_id = combo_id
	root.add_child(pv)


func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	mouse_filter = Control.MOUSE_FILTER_STOP
	var scrim := ColorRect.new()
	scrim.color = Color(0.04, 0.027, 0.02, 0.72)
	scrim.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	scrim.mouse_filter = Control.MOUSE_FILTER_STOP
	add_child(scrim)
	var outer := MarginContainer.new()
	outer.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	outer.add_theme_constant_override("margin_left", 24)
	outer.add_theme_constant_override("margin_right", 24)
	outer.add_theme_constant_override("margin_top", 24)
	outer.add_theme_constant_override("margin_bottom", 24)
	add_child(outer)
	var card := PanelContainer.new()
	card.theme_type_variation = "Card"
	outer.add_child(card)
	var col := VBoxContainer.new()
	col.add_theme_constant_override("separation", 12)
	card.add_child(col)
	var head := HBoxContainer.new()
	head.add_theme_constant_override("separation", 12)
	col.add_child(head)
	var title := UI.label("On the pads: %s" % _combo_words(), UI.BODY, UI.FG, "bold")
	title.name = "PadViewTitle"
	title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	head.add_child(title)
	var close_b := UI.button("Close", "BtnSolid", _close)
	close_b.name = "PadViewClose"
	head.add_child(close_b)
	var holder := SubViewportContainer.new()
	holder.custom_minimum_size = Vector2(640, 360)
	holder.size_flags_vertical = Control.SIZE_EXPAND_FILL   # S393: fills the card; at a fixed height a white band sat under it
	holder.stretch = true
	col.add_child(holder)
	_vp = SubViewport.new()
	_vp.name = "PadViewport"
	_vp.size = Vector2i(VP_W, VP_H)
	_vp.transparent_bg = false
	_vp.render_target_update_mode = SubViewport.UPDATE_ALWAYS
	_vp.world_3d = World3D.new()
	holder.add_child(_vp)
	_deferred_start()


func _combo_words() -> String:
	var words: Array = []
	for beat in Combos.row(_combo_id).get("beats", []):
		words.append(str(beat).replace("_", " "))
	return ", ".join(words)


func _deferred_start() -> void:
	# Build after we are in the tree so the viewport runs.
	await get_tree().process_frame
	var row := Combos.row(_combo_id)
	var clips: Array = MoveClips.clips(_combo_id)
	if row.is_empty() or clips.is_empty():
		queue_free()
		return
	var boxer_glb: String = Faces.glb(Faces.stem(_fighter))
	_pw = PadWork.new()
	_pw.name = "PadWork"
	_vp.add_child(_pw)
	await get_tree().process_frame
	_pw.build(boxer_glb, COACH_GLB)
	for i in 5:
		await get_tree().process_frame
	_add_gym_floor()
	_build_framing_camera(_pw)
	if not _pad_done_connected:
		_pw.done.connect(_on_pad_done)
		_pad_done_connected = true
	_start_pad_loop()


func _start_pad_loop() -> void:
	if _closing or not is_instance_valid(_pw):
		return
	if _targets.is_empty():
		_pw.visible = false
		_targets = await _pw.compute_mitt_targets(_combo_id)
		if _closing or not is_instance_valid(_pw):
			return
		_pw.visible = true
	_pw.play(_combo_id, LOOP_ARG)
	_pw.set_mitt_targets(_targets)


func _on_pad_done() -> void:
	if _closing:
		return
	await get_tree().create_timer(LOOP_REST_S).timeout
	_start_pad_loop()


func _close() -> void:
	_closing = true
	if is_instance_valid(_pw) and _pw.done.is_connected(_on_pad_done):
		_pw.done.disconnect(_on_pad_done)
	if is_instance_valid(_vp):
		_vp.render_target_update_mode = SubViewport.UPDATE_DISABLED
	queue_free()


## Mirrors tools/padwork_still.gd: side-on camera, head to feet, margin.
func _build_framing_camera(pw: Node3D) -> Camera3D:
	var boxer_skel: Skeleton3D = pw.boxer["skel"]
	var coach_skel: Skeleton3D = pw.coach["skel"]
	var all_points: Array = []
	for skel in [boxer_skel, coach_skel]:
		for bone_name in ["Head", "Hips", "LeftFoot", "RightFoot"]:
			var bone_id: int = skel.find_bone(bone_name)
			if bone_id < 0:
				continue
			var bone_world: Vector3 = skel.global_transform * skel.get_bone_global_pose(bone_id).origin
			all_points.append(bone_world)
	if all_points.is_empty():
		return null
	var bb_min: Vector3 = all_points[0]
	var bb_max: Vector3 = all_points[0]
	for p in all_points:
		var pt: Vector3 = p
		bb_min = bb_min.min(pt)
		bb_max = bb_max.max(pt)
	var centre := (bb_min + bb_max) * 0.5
	var size := bb_max - bb_min
	var pad_x: float = maxf(size.x, 0.6) * 0.5 + 0.15
	var pad_y: float = size.y * 0.5 + 0.15
	var fov_deg := 35.0
	var fov_rad := deg_to_rad(fov_deg)
	var aspect := float(VP_W) / float(VP_H)
	var half_h := pad_y / (1.0 - 2.0 * MARGIN_FRAC)
	var dist_for_height: float = half_h / tan(fov_rad * 0.5)
	var visible_width: float = 2.0 * dist_for_height * tan(fov_rad * 0.5) * aspect
	var needed_width: float = (pad_x * 2.0) / (1.0 - 2.0 * MARGIN_FRAC)
	var cam_dist: float = dist_for_height
	if needed_width > visible_width:
		var dist_for_width: float = needed_width / (2.0 * tan(fov_rad * 0.5) * aspect)
		cam_dist = maxf(dist_for_height, dist_for_width)
	cam_dist = maxf(cam_dist, 2.5)
	var cam := Camera3D.new()
	cam.name = "PadFramingCam"
	cam.fov = fov_deg
	cam.position = Vector3(centre.x - cam_dist, centre.y, centre.z)
	_vp.add_child(cam)   # S393: look_at needs the tree; aimed outside it the view was an empty floor
	cam.look_at(centre, Vector3.UP)
	cam.current = true
	return cam


func _add_gym_floor() -> void:
	var floor := MeshInstance3D.new()
	var plane := PlaneMesh.new()
	plane.size = Vector2(60, 60)
	floor.mesh = plane
	var mat := StandardMaterial3D.new()
	mat.albedo_color = Color(0.45, 0.35, 0.25)
	mat.roughness = 0.85
	floor.material_override = mat
	floor.position = Vector3(0, 0, 0.6)
	_vp.add_child(floor)
