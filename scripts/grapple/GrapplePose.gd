extends SkeletonModifier3D
## S335 a GrappleMap man's 23 joints -> our MetaHuman's 22 bones (BJJ_SOURCES_S334.md "Retarget route", decided there).
## Each bone takes the rotation that turns its rest pair of directions (an aim from this joint to the next, and a second
## direction that fixes the roll) into the same pair read off the joints. Aim + roll per bone, so the rig's own bone axes
## never matter. The rolls: limbs use their bend plane (shoulder-elbow-wrist / hip-knee-ankle are three real points) and
## fall back to the body's forward when the limb is straight; the trunk uses the hip line and the shoulder line, its bend
## shared over Spine / Chest / UpperChest (1/3, 2/3, 1); feet use heel-toe-ankle; the head follows the neck; the palm roll
## is not in the data, so the hand keeps the forearm's. Bone lengths stay ours (only the hips take the data's position),
## so a longer arm reaches past the data's hand - the player scales the pair to our size first.
##   attach(skel) -> GrapplePose   .joints = PackedVector3Array(23, world)   (empty = the pose is left alone)

const DB := preload("res://scripts/grapple/GrappleMapDB.gd")
const SIDES := ["Left", "Right"]

var joints := PackedVector3Array()
var _id := {}
var _rest := {}          # bone -> global rest (skeleton space)
var _rest_local := {}    # bone -> local rest
var _fwd := Vector3.BACK # the body's forward at rest (skeleton space), from the feet


static func attach(skel: Skeleton3D) -> Node:
	var gp := new()
	gp.name = "GrapplePose"
	if not gp._setup(skel):
		gp.free()
		return null
	skel.add_child(gp)
	# Before the twist bones read the arms.
	var twist := skel.get_node_or_null("MetaHumanTwist")
	if twist != null:
		skel.move_child(gp, twist.get_index())
	return gp


func _setup(skel: Skeleton3D) -> bool:
	var names := ["Hips", "Spine", "Chest", "UpperChest", "Neck", "Head"]
	for s in SIDES:
		for b in ["Shoulder", "UpperArm", "LowerArm", "Hand", "MiddleProximal", "UpperLeg", "LowerLeg", "Foot", "Toes"]:
			names.append(s + b)
	for n in names:
		var i := skel.find_bone(n)
		if i < 0:
			return false
		_id[n] = i
	for i in skel.get_bone_count():
		_rest[i] = skel.get_bone_global_rest(i)
		_rest_local[i] = skel.get_bone_rest(i)
	var f := Vector3.ZERO
	for s in SIDES:
		f += _p(s + "Toes") - _p(s + "Foot")
	f.y = 0.0
	_fwd = f.normalized()
	return true


func _p(bone: String) -> Vector3:
	return (_rest[_id[bone]] as Transform3D).origin


## The orthonormal frame of an aim and a roll direction (columns: aim, roll made square to it, their cross).
static func frame(aim: Vector3, roll: Vector3) -> Basis:
	var a := aim.normalized()
	var s := (roll - a * a.dot(roll)).normalized()
	return Basis(a, s, a.cross(s))


## The rotation taking the rest pair onto the target pair.
static func turn(rest_aim: Vector3, rest_roll: Vector3, aim: Vector3, roll: Vector3) -> Basis:
	return frame(aim, roll) * frame(rest_aim, rest_roll).inverse()


## World rotations per bone (skeleton space) for one man's joints `j` (skeleton space). Pure apart from the rest pose.
func solve_rotations(j: PackedVector3Array) -> Dictionary:
	var J := func(n: String) -> Vector3: return j[DB.joint(n)]
	var rot := {}
	var lhip: Vector3 = J.call("LeftHip")
	var rhip: Vector3 = J.call("RightHip")
	var mid_rest := (_p("LeftUpperLeg") + _p("RightUpperLeg")) * 0.5
	var mid := (lhip + rhip) * 0.5
	var r_hips := turn(_p("Chest") - mid_rest, _p("RightUpperLeg") - _p("LeftUpperLeg"),
		J.call("Core") - mid, J.call("RightHip") - J.call("LeftHip"))
	var r_top := turn(_p("Neck") - _p("Chest"), _p("RightUpperArm") - _p("LeftUpperArm"),
		J.call("Neck") - J.call("Core"), J.call("RightShoulder") - J.call("LeftShoulder"))
	var qh := r_hips.get_rotation_quaternion()
	var qt := r_top.get_rotation_quaternion()
	rot["Hips"] = r_hips
	rot["Spine"] = Basis(qh.slerp(qt, 1.0 / 3.0))
	rot["Chest"] = Basis(qh.slerp(qt, 2.0 / 3.0))
	rot["UpperChest"] = r_top
	var r_neck := turn(_p("Head") - _p("Neck"), _p("RightUpperArm") - _p("LeftUpperArm"),
		J.call("Head") - J.call("Neck"), J.call("RightShoulder") - J.call("LeftShoulder"))
	rot["Neck"] = r_neck
	rot["Head"] = r_neck
	var fwd_top := r_top * _fwd
	var fwd_hips := r_hips * _fwd
	for s in SIDES:
		rot[s + "Shoulder"] = turn(_p(s + "UpperArm") - _p("Neck"), _p("Neck") - _p("Chest"),
			J.call(s + "Shoulder") - J.call("Neck"), J.call("Neck") - J.call("Core"))
		# Arm: a bent elbow (upper arm down, forearm forward) has the bend normal upper x fore = rest aim x forward.
		var ua: Vector3 = J.call(s + "Elbow") - J.call(s + "Shoulder")
		var fa: Vector3 = J.call(s + "Wrist") - J.call(s + "Elbow")
		var rest_ua := _p(s + "LowerArm") - _p(s + "UpperArm")
		var n := ua.normalized().cross(fa.normalized())
		if n.length() < 0.15:
			n = ua.cross(fwd_top)
		var rest_n := rest_ua.cross(_fwd)
		rot[s + "UpperArm"] = turn(rest_ua, rest_n, ua, n)
		rot[s + "LowerArm"] = turn(_p(s + "Hand") - _p(s + "LowerArm"), rest_n, fa, n)
		rot[s + "Hand"] = turn(_p(s + "MiddleProximal") - _p(s + "Hand"), rest_n, J.call(s + "Hand") - J.call(s + "Wrist"), n)
		# Leg: a bent knee (thigh forward-down, shin back-down) has thigh x shin = forward x down.
		var th: Vector3 = J.call(s + "Knee") - J.call(s + "Hip")
		var sh: Vector3 = J.call(s + "Ankle") - J.call(s + "Knee")
		var rest_th := _p(s + "LowerLeg") - _p(s + "UpperLeg")
		var m := th.normalized().cross(sh.normalized())
		if m.length() < 0.15:
			m = fwd_hips.cross(th)
		var rest_m := _fwd.cross(rest_th)
		rot[s + "UpperLeg"] = turn(rest_th, rest_m, th, m)
		rot[s + "LowerLeg"] = turn(_p(s + "Foot") - _p(s + "LowerLeg"), rest_m, sh, m)
		# Foot: toe-heel forward, ankle-heel up -> forward x up is the foot's side, at rest and in the data.
		var toe: Vector3 = J.call(s + "Toe")
		var heel: Vector3 = J.call(s + "Heel")
		var ankle: Vector3 = J.call(s + "Ankle")
		var rest_ft := _p(s + "Toes") - _p(s + "Foot")
		rot[s + "Foot"] = turn(rest_ft, Vector3(rest_ft.x, 0.0, rest_ft.z).cross(Vector3.UP),
			toe - ankle, (toe - heel).cross(ankle - heel))
		rot[s + "Toes"] = rot[s + "Foot"]
	return rot


func _process_modification() -> void:
	var skel := get_skeleton()
	if skel == null or joints.size() != DB.JOINTS.size():
		return
	var inv := skel.global_transform.affine_inverse()
	var j := PackedVector3Array()
	for v in joints:
		j.append(inv * v)
	var glob := pose_globals(skel, j)
	for i in skel.get_bone_count():
		var parent := skel.get_bone_parent(i)
		var local: Transform3D = glob[i] if parent < 0 else (glob[parent] as Transform3D).affine_inverse() * glob[i]
		skel.set_bone_pose_position(i, local.origin)
		skel.set_bone_pose_rotation(i, local.basis.get_rotation_quaternion())


## Every bone's pose in skeleton space for joints `j` (skeleton space). A bone read from outside gets the pose before
## the modifiers ran (S307 trap), so tests and cameras read this.
func pose_globals(skel: Skeleton3D, j: PackedVector3Array) -> Dictionary:
	var rot := solve_rotations(j)
	var by_id := {}
	for n in rot.keys():
		by_id[_id[n]] = rot[n]
	var mid_rest := (_p("LeftUpperLeg") + _p("RightUpperLeg")) * 0.5
	var mid := (j[DB.joint("LeftHip")] + j[DB.joint("RightHip")]) * 0.5
	var hips_pos := mid + (rot["Hips"] as Basis) * (_p("Hips") - mid_rest)
	var glob := {}
	for i in skel.get_bone_count():
		_global(skel, i, by_id, hips_pos, glob)
	return glob


## A bone's pose in skeleton space: a solved bone turns its rest by its rotation; the rest follow their parent. Every
## bone keeps its rest offset from its parent (our lengths), the hips alone go where the data puts them.
func _global(skel: Skeleton3D, i: int, by_id: Dictionary, hips_pos: Vector3, glob: Dictionary) -> Transform3D:
	if glob.has(i):
		return glob[i]
	var parent := skel.get_bone_parent(i)
	var pg: Transform3D = Transform3D.IDENTITY if parent < 0 else _global(skel, parent, by_id, hips_pos, glob)
	var t := pg * (_rest_local[i] as Transform3D)
	if by_id.has(i):
		t.basis = (by_id[i] as Basis) * (_rest[i] as Transform3D).basis
	if i == _id["Hips"]:
		t.origin = hips_pos
	glob[i] = t
	return t
