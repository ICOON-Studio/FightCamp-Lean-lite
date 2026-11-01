extends SceneTree
## Padwork stills: guard, first contact, last contact on a gym-floor backdrop, 1920x1080.
## Saved under docs/playtest/padwork/. Windowed run:
##   xvfb-run -a -s "-screen 0 1920x1080x24" <godot> --path . --windowed --resolution 1920x1080 \
##       --audio-driver Dummy --fixed-fps 30 --script res://tools/padwork_still.gd -- combo=<id> fastdraw
## S349 r4: frame both bodies head to feet (Head + LeftFoot + RightFoot bones) with 4% margin.
## Gym floor backdrop, not black.

const PadWork := preload("res://scripts/fight3d/PadWork.gd")
const Combos := preload("res://scripts/rules/Combos.gd")
const MoveClips := preload("res://scripts/fight3d/MoveClips.gd")
const BeatClips := preload("res://scripts/fight3d/BeatClips.gd")
const FastDraw := preload("res://tools/fast_draw.gd")

const W := 1920
const H := 1080
const BOXER_GLB := "res://assets/models/metahuman/mh_boxer_10.glb"
const COACH_GLB := "res://assets/models/metahuman/mh_staff_coach.glb"
const OUT_DIR := "res://docs/playtest/padwork"
const MARGIN_FRAC := 0.04

var combo_id := "1-2-3"


func _initialize() -> void:
	for a in OS.get_cmdline_user_args():
		if str(a).begins_with("combo="):
			combo_id = str(a).trim_prefix("combo=")
	FastDraw.begin()
	root.size = Vector2i(W, H)
	DirAccess.make_dir_recursive_absolute(OUT_DIR)
	var row := Combos.row(combo_id)
	if row.is_empty():
		print("PADWORK_STILL unknown combo: %s" % combo_id)
		quit(1)
		return
	var beats: Array = row["beats"]
	var clips: Array = MoveClips.clips(combo_id)
	var pw := PadWork.new()
	pw.name = "PadWork"
	root.add_child(pw)
	await process_frame
	pw.build(BOXER_GLB, COACH_GLB)
	# Wait for bodies to settle.
	for i in 5:
		await process_frame
	# Add a gym floor backdrop.
	_add_gym_floor()
	# Frame both bodies head to feet with 4% margin.
	var cam := _build_framing_camera(pw)
	if cam == null:
		print("PADSTILL FAIL")
		quit(1)
		return
	# Verify both bodies are in frame with 4% margin.
	var bodies_ok := _check_bodies_in_frame(pw, cam)
	if not bodies_ok:
		print("PADSTILL FAIL")
		quit(1)
		return
	print("PADSTILL bodies 2 head to feet")
	# Still 1: guard (both idle).
	await _wait(0.5)
	await _save("guard")
	# S350 (Claude): the mitts go where her gloves land (as the probe does), and each still is taken AT that punch's own
	# contact time - fixed waits (0.3 s, then 3.0 s) caught the jab short and showed her back in guard after the hook.
	var targets: Array = await pw.compute_mitt_targets(combo_id)
	pw.play(combo_id)
	pw.set_mitt_targets(targets)
	var ps: Array = pw.get("_punches")
	var first_t: float = float(ps[0]["clip_start_t"]) + float(ps[0]["contact_s"])
	var last_t: float = float(ps[-1]["clip_start_t"]) + float(ps[-1]["contact_s"])
	# _save waits 0.2 s before its shot.
	await _wait(maxf(first_t - 0.2, 0.0))
	await _save("first_contact")
	await _wait(maxf(last_t - first_t - 0.2, 0.0))
	await _save("last_contact")
	print("PADWORK_STILL wrote stills to %s" % OUT_DIR)
	quit(0)


## Builds a camera that frames both bodies head to feet with 4% margin.
## Side-on view, looking at the pair's middle.
func _build_framing_camera(pw: Node3D) -> Camera3D:
	var boxer_node: Node3D = pw.boxer["node"]
	var coach_node: Node3D = pw.coach["node"]
	var boxer_skel: Skeleton3D = pw.boxer["skel"]
	var coach_skel: Skeleton3D = pw.coach["skel"]
	# Collect all bone positions we need to fit in frame.
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
	# Find the bounding box of all points.
	var bb_min: Vector3 = all_points[0]
	var bb_max: Vector3 = all_points[0]
	for p in all_points:
		var pt: Vector3 = p
		bb_min = bb_min.min(pt)
		bb_max = bb_max.max(pt)
	var centre := (bb_min + bb_max) * 0.5
	var size := bb_max - bb_min
	# Add some padding for the body width and visual comfort.
	var pad_x: float = maxf(size.x, 0.6) * 0.5 + 0.15
	var pad_y: float = size.y * 0.5 + 0.15
	# Camera: side-on (from negative X), at the centre height, far enough to fit everything.
	var fov_deg := 35.0
	var fov_rad := deg_to_rad(fov_deg)
	var aspect := float(W) / float(H)
	var half_h := pad_y / (1.0 - 2.0 * MARGIN_FRAC)
	var dist_for_height: float = half_h / tan(fov_rad * 0.5)
	var visible_width: float = 2.0 * dist_for_height * tan(fov_rad * 0.5) * aspect
	var needed_width: float = (pad_x * 2.0) / (1.0 - 2.0 * MARGIN_FRAC)
	var cam_dist: float = maxf(dist_for_height, dist_for_height) if needed_width > visible_width else dist_for_height
	cam_dist = maxf(cam_dist, 2.5)
	var cam := Camera3D.new()
	cam.fov = fov_deg
	cam.position = Vector3(centre.x - cam_dist, centre.y, centre.z)
	root.add_child(cam)
	cam.look_at(centre, Vector3.UP)
	return cam


## Checks that both boxer and coach Head and feet bones project inside the viewport with 4% margin.
func _check_bodies_in_frame(pw: Node3D, cam: Camera3D) -> bool:
	var boxer_skel: Skeleton3D = pw.boxer["skel"]
	var coach_skel: Skeleton3D = pw.coach["skel"]
	var margin_x: float = W * MARGIN_FRAC
	var margin_y: float = H * MARGIN_FRAC
	for skel in [boxer_skel, coach_skel]:
		for bone_name in ["Head", "LeftFoot", "RightFoot"]:
			var bone_id: int = skel.find_bone(bone_name)
			if bone_id < 0:
				continue
			var bone_world: Vector3 = skel.global_transform * skel.get_bone_global_pose(bone_id).origin
			var cam_space: Vector3 = cam.to_local(bone_world)
			if cam_space.z >= 0.0:
				print("PADSTILL point behind camera: %s" % bone_name)
				return false
			var projected: Vector2 = cam.unproject_position(bone_world)
			if projected.x < margin_x or projected.x > W - margin_x:
				print("PADSTILL %s outside X: %.1f (margin %.1f-%.1f)" % [bone_name, projected.x, margin_x, W - margin_x])
				return false
			if projected.y < margin_y or projected.y > H - margin_y:
				print("PADSTILL %s outside Y: %.1f (margin %.1f-%.1f)" % [bone_name, projected.y, margin_y, H - margin_y])
				return false
	return true


## Adds a gym floor backdrop - wooden floor with warm lighting.
func _add_gym_floor() -> void:
	var floor := MeshInstance3D.new()
	var plane := PlaneMesh.new()
	plane.size = Vector2(12, 12)
	floor.mesh = plane
	var mat := StandardMaterial3D.new()
	mat.albedo_color = Color(0.45, 0.35, 0.25)  # warm wood floor
	mat.roughness = 0.85
	floor.material_override = mat
	floor.position = Vector3(0, 0, 0.6)  # at the feet level
	root.add_child(floor)
	# Add some walls to make it feel like a gym.
	var back_wall := MeshInstance3D.new()
	var wall_plane := PlaneMesh.new()
	wall_plane.size = Vector2(12, 4)
	back_wall.mesh = wall_plane
	var wall_mat := StandardMaterial3D.new()
	wall_mat.albedo_color = Color(0.25, 0.22, 0.20)  # dark gym wall
	wall_mat.roughness = 0.95
	back_wall.material_override = wall_mat
	back_wall.position = Vector3(0, 2.6, 6.0)  # behind the coach
	back_wall.rotation_degrees = Vector3(0, 180, 0)
	root.add_child(back_wall)


func _save(name: String) -> void:
	await _wait(0.2)
	var img: Image = await FastDraw.shot(self)
	var path := OUT_DIR.path_join("padwork_%s_%s.png" % [combo_id.replace("-", "_"), name])
	img.save_png(path)
	print("wrote %s" % path)


func _wait(s: float) -> void:
	var frames := int(s * 30.0)
	for i in frames:
		await process_frame
