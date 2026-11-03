extends SkeletonModifier3D
## S370 TASK_KNEETRACK1: keeps each knee pointing over the toes. Retargeted mocap clips carry thigh roll that caves a bent
## knee in, bows it out or turns it backwards while the shin's twist against the thigh is fine (tools/knee_probe.gd: 57
## standing clips fail on main, up to 176 deg backwards). Before FootPlant solves its planted-foot IK (which keeps the
## knee's current bend plane), each bent leg swivels its THIGH about the hip-ankle line so the knee's horizontal offset
## sits within ALLOW_DEG of the foot's ankle-to-toes line; the ankle stays where the clip put it, the knee bend and shin
## twist are unchanged, and the FOOT's local pose is counter-rotated so its global rotation and toes stay fixed. Eases to
## zero as the bend drops under BENT_DEG (a straight leg has no direction) and frees on falls/knockouts/wins like FootPlant.
##   KneeTrack.align(skel, weight)   attach(skel, ap) -> KneeTrack | null

const LEGS := [
	["LeftUpperLeg", "LeftLowerLeg", "LeftFoot", "LeftToes"],
	["RightUpperLeg", "RightLowerLeg", "RightFoot", "RightToes"],
]
const ALLOW_DEG := 20.0      # human knee-in / knee-out left untouched (probe bar is 35 deg)
const BENT_DEG := 15.0       # full correction at and above this knee bend; eases to 0 below it
const STRAIGHT_DEG := 5.0    # dead-straight leg: zero correction
const FREE := ["knockout", "win", "countdown", "fall"]
const EASE_S := 0.2

var _ap: AnimationPlayer = null
var _weight := 1.0


static func attach(skel: Skeleton3D, ap: AnimationPlayer) -> Node:
	var kt := new()
	kt.name = "KneeTrack"
	if not kt.setup(skel, ap):
		kt.free()
		return null
	skel.add_child(kt)
	var tw := skel.find_child("MetaHumanTwist", false, false)
	if tw != null:
		skel.move_child(kt, tw.get_index())
	return kt


func setup(skel: Skeleton3D, ap: AnimationPlayer = null) -> bool:
	_ap = ap
	for leg in LEGS:
		for n in leg:
			if skel.find_bone(str(n)) < 0:
				return false
	return true


func _process_modification() -> void:
	var skel := get_skeleton()
	if skel == null:
		return
	if _ap != null:
		var delta := maxf(get_process_delta_time(), 1e-4)
		var clip := str(_ap.current_animation if _ap.current_animation != "" else _ap.assigned_animation)
		var free := false
		for w in FREE:
			free = free or clip.contains(w)
		_weight = move_toward(_weight, 0.0 if free else 1.0, delta / EASE_S)
	align(skel, influence * _weight)


static func align(skel: Skeleton3D, weight: float) -> void:
	if skel == null or weight <= 0.0:
		return
	var allow := deg_to_rad(ALLOW_DEG)
	for leg in LEGS:
		var u := skel.find_bone(str(leg[0]))
		var l := skel.find_bone(str(leg[1]))
		var f := skel.find_bone(str(leg[2]))
		var t := skel.find_bone(str(leg[3]))
		if u < 0 or l < 0 or f < 0 or t < 0:
			continue
		var gu := skel.get_bone_global_pose(u)
		var gl := skel.get_bone_global_pose(l)
		var gf := skel.get_bone_global_pose(f)
		var gt := skel.get_bone_global_pose(t)
		var hip := gu.origin
		var knee := gl.origin
		var ankle := gf.origin
		var flex := 180.0 - rad_to_deg((hip - knee).angle_to(ankle - knee))
		if flex <= STRAIGHT_DEG:
			continue
		var span := ankle - hip
		if span.length() < 0.05:
			continue
		var axis := span.normalized()
		var v0 := (knee - hip) - axis * (knee - hip).dot(axis)
		var off := Vector3(v0.x, 0.0, v0.z)
		var foot := Vector3(gt.origin.x - ankle.x, 0.0, gt.origin.z - ankle.z)
		if foot.length() <= 0.01 or off.length() <= 0.005 or v0.length() <= 0.005:
			continue
		var fwd := foot.normalized()
		var side := Vector3.UP.cross(fwd)
		var ang := atan2(off.dot(side), off.dot(fwd))
		if absf(ang) <= allow:
			continue
		var u_bend := clampf((flex - STRAIGHT_DEG) / (BENT_DEG - STRAIGHT_DEG), 0.0, 1.0)
		var w := clampf(weight, 0.0, 1.0) * u_bend * u_bend * (3.0 - 2.0 * u_bend)
		if w <= 0.0:
			continue
		var kept := clampf(ang, -allow, allow)
		var target_ang := lerpf(ang, kept, w)
		var want_xz := (fwd * cos(target_ang) + side * sin(target_ang)).normalized()
		var sy := -1.0 if axis.y < 0.0 else 1.0
		var t_vec := want_xz * maxf(absf(axis.y), 1e-4) - Vector3.UP * (want_xz.dot(axis) * sy)
		t_vec -= axis * t_vec.dot(axis)
		if t_vec.length() <= 1e-5:
			continue
		var v0_dir := v0.normalized()
		var t_dir := t_vec.normalized()
		var phi := atan2(axis.dot(v0_dir.cross(t_dir)), clampf(v0_dir.dot(t_dir), -1.0, 1.0))
		if absf(axis.y) < 1e-4:
			phi *= w
		var swivel := Quaternion(axis, phi)
		var qu := gu.basis.get_rotation_quaternion()
		var ql := gl.basis.get_rotation_quaternion()
		var qf := gf.basis.get_rotation_quaternion()
		var qu1 := (swivel * qu).normalized()
		var ql1 := (swivel * ql).normalized()
		var parent := skel.get_bone_parent(u)
		var qp := skel.get_bone_global_pose(parent).basis.get_rotation_quaternion() if parent >= 0 else Quaternion.IDENTITY
		skel.set_bone_pose_rotation(u, (qp.inverse() * qu1).normalized())
		skel.set_bone_pose_rotation(f, (ql1.inverse() * qf).normalized())
