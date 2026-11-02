extends SceneTree
## S368 (operator, on the board's clip previews: "they all need work on the footing and smoothness"): one baked fight clip on
## the game's boxer, played headless frame by frame the way the fight plays it (FightClips._add_baked: hips = this body's rest
## + the clip's offset, X/Z held for a move thrown in place), measured on the bones:
##   feet   a foot is PLANTED while it is within PLANT_M of its lowest point in the clip; slide_m = how far a planted foot
##          travels on the floor (it should stay put), max_mps = its fastest planted frame
##   smooth a SNAP is a frame where a bone's turn changes by more than SNAP_DEG from the turn of the frame before (the second
##          difference of its rotation): snaps = how many, worst_deg = the largest
##   punches the lead hand's reach from the upper chest: peaks over 85 % of its most, apart by a dip under 60 %
##   <godot.exe> --headless --path . --script res://tools/clip_feet_probe.gd -- clip=<stem or .res path> [hold=0] [glb=mh_boxer_10]
## Prints one CLIPFEET line.

const MH := preload("res://scripts/fight3d/MHRig.gd")
const BAKED := "res://assets/anim/baked/"
const PLANT_M := 0.03
const SNAP_DEG := 6.0


func _initialize() -> void:
	var args := {}
	for a in OS.get_cmdline_user_args():
		if str(a).contains("="):
			args[str(a).get_slice("=", 0)] = str(a).get_slice("=", 1)
	var clip := str(args.get("clip", ""))
	var p := clip if clip.contains("/") or clip.contains("\\") else BAKED + clip + ".res"
	var src := ResourceLoader.load(p) as Animation
	if src == null:
		print("CLIPFEET no clip ", p)
		quit(1)
		return
	var body := MH.load_fighter("res://assets/models/metahuman/%s.glb" % str(args.get("glb", "mh_boxer_10")))
	root.add_child(body)
	var skel := body.find_children("*", "Skeleton3D", true, false)[0] as Skeleton3D
	var hips := skel.find_bone("Hips")
	var hips_rest := skel.get_bone_rest(hips).origin
	var hold := str(args.get("hold", "1")) != "0"
	var bones := {}
	for t in src.get_track_count():
		bones[t] = skel.find_bone(str(src.track_get_path(t)))
	var fps := roundi(1.0 / maxf(src.step, 0.001))
	var n := int(round(src.length * fps)) + 1
	var feet := {"LeftFoot": skel.find_bone("LeftFoot"), "RightFoot": skel.find_bone("RightFoot")}
	var hand := skel.find_bone("LeftHand")
	var rhand := skel.find_bone("RightHand")
	var chest := skel.find_bone("UpperChest")
	var foot_at := {"LeftFoot": [], "RightFoot": []}
	var reach: Array = []
	var rreach: Array = []
	var first_xz := Vector3.INF
	for f in n:
		var time := minf(f / float(fps), src.length)
		for t in src.get_track_count():
			var b: int = bones[t]
			if b < 0:
				continue
			if src.track_get_type(t) == Animation.TYPE_ROTATION_3D:
				skel.set_bone_pose_rotation(b, src.rotation_track_interpolate(t, time))
			elif src.track_get_type(t) == Animation.TYPE_POSITION_3D:
				var pos := hips_rest + src.position_track_interpolate(t, time)
				if hold:
					if first_xz == Vector3.INF:
						first_xz = pos
					pos = Vector3(first_xz.x, pos.y, first_xz.z)
				skel.set_bone_pose_position(b, pos)
		for k in feet:
			foot_at[k].append(_global(skel, feet[k]).origin)
		var hp := _global(skel, hand).origin
		var cp := _global(skel, chest).origin
		reach.append(Vector2(hp.x - cp.x, hp.z - cp.z).length())
		var rp := _global(skel, rhand).origin
		rreach.append(Vector2(rp.x - cp.x, rp.z - cp.z).length())
	# feet
	var slide := 0.0
	var max_mps := 0.0
	for k in foot_at:
		var arr: Array = foot_at[k]
		var low := INF
		for v in arr:
			low = minf(low, (v as Vector3).y)
		for i in range(1, arr.size()):
			var a: Vector3 = arr[i - 1]
			var b: Vector3 = arr[i]
			if a.y <= low + PLANT_M and b.y <= low + PLANT_M:
				var d := Vector2(b.x - a.x, b.z - a.z).length()
				slide += d
				max_mps = maxf(max_mps, d * fps)
	# smoothness: second difference of every rotation track. A punching arm locking out is a real fast stop, so the arms
	# (shoulder to hand) are counted apart; the body's snaps (hips, spine, neck, head, legs, feet) are the roughness.
	var snaps := 0
	var arm_snaps := 0
	var worst := 0.0
	var worst_at := ""
	for t in src.get_track_count():
		if src.track_get_type(t) != Animation.TYPE_ROTATION_3D:
			continue
		var is_arm := str(src.track_get_path(t)).contains("Arm") or str(src.track_get_path(t)).contains("Hand") \
			or str(src.track_get_path(t)).contains("Shoulder")
		var prev_turn := Quaternion.IDENTITY
		var have := false
		for f in range(1, n):
			var q0 := src.rotation_track_interpolate(t, (f - 1) / float(fps))
			var q1 := src.rotation_track_interpolate(t, minf(f / float(fps), src.length))
			var turn := q1 * q0.inverse()
			if have:
				var d := rad_to_deg(turn.angle_to(prev_turn))
				if d > SNAP_DEG and is_arm:
					arm_snaps += 1
				elif d > SNAP_DEG:
					snaps += 1
				if d > worst and not is_arm:
					worst = d
					worst_at = "%s at %.2f s" % [src.track_get_path(t), f / float(fps)]
			prev_turn = turn
			have = true
	# punches: each hand's extensions over 85 % of the longer hand's reach (a guard hand never gets there)
	var most := 0.0
	for r in reach + rreach:
		most = maxf(most, float(r))
	var punches := _peaks(reach, most) + _peaks(rreach, most)
	print("CLIPFEET %s frames=%d fps=%d slide_m=%.3f max_mps=%.2f body_snaps=%d worst_deg=%.1f (%s) arm_snaps=%d punches=%d (lead %d, rear %d) reach_m=%.2f" % [
		clip.get_file().get_basename(), n, fps, slide, max_mps, snaps, worst, worst_at, arm_snaps, punches, _peaks(reach, most), _peaks(rreach, most), most])
	quit(0)


static func _peaks(arr: Array, most: float) -> int:
	var n := 0
	var armed := true
	for r in arr:
		if armed and float(r) >= most * 0.85:
			n += 1
			armed = false
		elif not armed and float(r) <= most * 0.6:
			armed = true
	return n


## A bone's pose in the skeleton's space, built up its parent chain from the local poses just set (the skeleton's own
## global cache is not refreshed between frames of a headless loop).
static func _global(skel: Skeleton3D, b: int) -> Transform3D:
	var tf := skel.get_bone_pose(b)
	var p := skel.get_bone_parent(b)
	while p >= 0:
		tf = skel.get_bone_pose(p) * tf
		p = skel.get_bone_parent(p)
	return tf
