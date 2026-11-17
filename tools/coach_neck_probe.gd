extends SceneTree
## COACHNECK2 probe: measures the coach's neck angle in a saved pose.
## The owner marked C415 on the corner-minute close-up: "his neck is coming out horizontally from his neck not vertically".
## Loads the coach body, applies a pose file, measures in WORLD space, all from BONE ORIGINS (COACHNECK2: round 1 read the
## Chest bone's own +Y basis axis, and MetaHuman spine bones do not have +Y up, so it printed 131 deg where the still shows
## ~40 - that bar could never pass):
##   chest line        = spine_03 (Chest) origin -> spine_05 (UpperChest) origin, the way the man's back runs
##   (a) neck_vs_chest    = angle between Neck->Head and that chest line   <- the brief's bar: <= 20 deg
##   (b) neck_vs_vertical = the same vector against world UP               <- "visibly rise": <= 40 deg
##   (c) head_ahead_cm    = how far the Head sits in front of the neck base, horizontally
##   (d) chest_vs_vertical= how bent the trunk itself is (context: a neck can only be as upright as its back)
##   (e) pitch / yaw      = the neck's deviation from the chest line split into leaning fore-aft (pitch, about the chest's
##                          lateral axis) and leaning sideways (yaw, about the chest line). The owner's complaint is the
##                          PITCH; CornerIK sends a look's pitch down the spine and leaves the neck on the chest line.
## Prints: COACH_NECK neck_vs_chest=<deg> neck_vs_vertical=<deg> head_ahead_cm=<cm> ok=<1|0> (ok when <= 20 and <= 40).
##   <godot> --headless --audio-driver Dummy --path . --script res://tools/coach_neck_probe.gd -- <pose.json>
## The pose file is a pose taken AFTER CornerIK ran (BodylookPose.record): re-reading it can never show a CornerIK change,
## only a fresh dump through `tools/corner_film.gd ... posedump=<out>/c07_before.json` can.

const BodylookPose := preload("res://tools/bodylook_pose.gd")
const MH := preload("res://scripts/fight3d/MHRig.gd")
const COACH_GLB := "res://assets/models/metahuman/mh_staff_coach.glb"

const CHEST_LO := "Chest"        # spine_03
const CHEST_HI := "UpperChest"   # spine_05
const NECK_LOW := "Neck"         # neck_01
const HEAD := "Head"
const BAR_CHEST := 20.0
const BAR_VERTICAL := 40.0
const VERBOSE := true            # the origins, the chain and the split: a wrong axis must never hide again


func _initialize() -> void:
	var args := OS.get_cmdline_user_args()
	var pose_path := ""
	for a in args:
		if not str(a).begins_with("posedump=") and str(a).ends_with(".json"):
			pose_path = str(a)
			break
	if pose_path == "":
		if not args.is_empty():
			pose_path = str(args[0])
	if pose_path == "":
		print("COACH_NECK usage: coach_neck_probe.gd -- <pose.json>")
		quit(1)
		return
	var body := MH.load_fighter(COACH_GLB)
	root.add_child(body)
	await process_frame          # in the tree before the pose is applied, or its global transform reads as identity
	var skel := body.find_children("*", "Skeleton3D", true, false)[0] as Skeleton3D
	var cam_info := BodylookPose.apply(body, skel, pose_path)
	await process_frame
	var neck_id := skel.find_bone(NECK_LOW)
	var head_id := skel.find_bone(HEAD)
	var chest_id := skel.find_bone(CHEST_LO)
	var upchest_id := skel.find_bone(CHEST_HI)
	if neck_id < 0 or head_id < 0 or chest_id < 0 or upchest_id < 0:
		print("COACH_NECK ERROR: could not find %s/%s/%s/%s bones" % [NECK_LOW, HEAD, CHEST_LO, CHEST_HI])
		quit(1)
		return
	var neck_world: Vector3 = skel.global_transform * skel.get_bone_global_pose(neck_id).origin
	var head_world: Vector3 = skel.global_transform * skel.get_bone_global_pose(head_id).origin
	var chest_world: Vector3 = skel.global_transform * skel.get_bone_global_pose(chest_id).origin
	var upchest_world: Vector3 = skel.global_transform * skel.get_bone_global_pose(upchest_id).origin
	var neck_to_head: Vector3 = (head_world - neck_world)
	var neck_dir: Vector3 = neck_to_head.normalized()
	var chest_line: Vector3 = (upchest_world - chest_world).normalized()
	var neck_vs_chest: float = rad_to_deg(neck_dir.angle_to(chest_line))
	var neck_vs_vertical: float = rad_to_deg(neck_dir.angle_to(Vector3.UP))
	var chest_vs_vertical: float = rad_to_deg(chest_line.angle_to(Vector3.UP))
	var horiz: Vector3 = Vector3(neck_to_head.x, 0.0, neck_to_head.z)
	var head_ahead_cm: float = horiz.length() * 100.0
	var neck_cm: float = neck_to_head.length() * 100.0
	# The neck's deviation from the chest line, split: pitch leans in the body's own fore-aft plane (the owner's "coming
	# out horizontally"), yaw leans sideways. Built off the body's forward so a chest line level with it cannot make the
	# split degenerate; only a chest line PARALLEL to the body's forward does, and that falls back to world axes.
	var body_fwd: Vector3 = (body.global_transform.basis * Vector3.BACK).normalized()
	var lat: Vector3 = chest_line.cross(body_fwd)
	if lat.length() < 1e-4:
		lat = chest_line.cross(Vector3.UP)
	if lat.length() < 1e-4:
		lat = chest_line.cross(Vector3.RIGHT)
	lat = lat.normalized()
	var fwd_plane: Vector3 = lat.cross(chest_line).normalized()
	var pitch: float = rad_to_deg(atan2(neck_dir.dot(fwd_plane), maxf(neck_dir.dot(chest_line), 1e-4)))
	var yaw: float = rad_to_deg(asin(clampf(neck_dir.dot(lat), -1.0, 1.0)))
	var ok: int = 1 if (neck_vs_chest <= BAR_CHEST and neck_vs_vertical <= BAR_VERTICAL) else 0
	print("COACH_NECK neck_vs_chest=%.1f neck_vs_vertical=%.1f head_ahead_cm=%.1f ok=%d" % [neck_vs_chest, neck_vs_vertical, head_ahead_cm, ok])
	if VERBOSE:
		print("COACH_NECK.axes  chest=%s->%s  chest_vs_vertical=%.1f  neck_off_chest: pitch=%.1f yaw=%.1f  neck_len_cm=%.1f  neck_up_m=%.3f head_up_m=%.3f" % [
			CHEST_LO, CHEST_HI, chest_vs_vertical, pitch, yaw, neck_cm, neck_world.y, head_world.y])
		var names: Array = []
		var b := head_id
		var guard := 0
		while b >= 0 and guard < 8:
			names.append(skel.get_bone_name(b))
			if b == chest_id:
				break
			b = skel.get_bone_parent(b)
			guard += 1
		print("COACH_NECK.chain head-first-to-chest: %s" % " <- ".join(names))
		print("COACH_NECK.pose  %s" % pose_path)
	quit(0)
