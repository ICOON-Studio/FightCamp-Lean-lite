extends SkeletonModifier3D
## S307 the corner minute's hands and eyes (docs/FIGHT_NIGHT_SCRIPT.md v2 step 5, "the hands meet what they reach"):
## a hand reaches a point (the bottle at her lips, the cutman's fingers on her cheekbone) by analytic two-bone arm IK
## (FootPlant's solver, Holden "Simple Two Joint IK"), and the head turns to look at a point (the coach and his boxer face
## to face; the ActionForge crouch and sit look at the floor). Each eases in and out over EASE_S; the hand keeps the turn
## the clip gave it; the head turns at most MAX_LOOK_DEG, the neck taking NECK_SHARE of it.
##   attach(skel, body) -> CornerIK   reach(side, target: Callable | null)   look(target: Callable | null)

const EASE_S := 0.35
const MAX_LOOK_DEG := 65.0
const NECK_SHARE := 0.4

var _body: Node3D
var _arms := {}            # "Left"/"Right" -> [upper, lower, hand]
var _reach := {}           # side -> {target: Callable, w: float, on: bool}
var _look := {"target": Callable(), "w": 0.0, "on": false}
var _neck := -1
var _head := -1
var _face_local := Vector3.BACK   # the face's direction in the head bone's own frame
var _fwd_skel := Vector3.BACK     # the body's forward in the skeleton's space (a straight arm's elbow bends behind it)


static func attach(skel: Skeleton3D, body: Node3D) -> Node:
	var ik := new()
	ik.name = "CornerIK"
	ik._body = body
	if not ik._setup(skel):
		ik.free()
		return null
	skel.add_child(ik)
	# Before the twist bones read the arms (MetaHumanTwist follows the forearm this pose gives).
	var twist := skel.get_node_or_null("MetaHumanTwist")
	if twist != null:
		skel.move_child(ik, twist.get_index())
	return ik


func _setup(skel: Skeleton3D) -> bool:
	for side in ["Left", "Right"]:
		var ids := [skel.find_bone(side + "UpperArm"), skel.find_bone(side + "LowerArm"), skel.find_bone(side + "Hand")]
		if ids.has(-1):
			return false
		_arms[side] = ids
		_reach[side] = {"target": Callable(), "w": 0.0, "on": false}
	_neck = skel.find_bone("Neck")
	_head = skel.find_bone("Head")
	if _neck < 0 or _head < 0:
		return false
	# In the rest pose the body faces +Z of its own frame; read that direction in the head bone's frame.
	var fwd_skel := (skel.global_transform.basis.inverse() * _body.global_transform.basis * Vector3.BACK).normalized()
	_fwd_skel = fwd_skel
	_face_local = (skel.get_bone_global_rest(_head).basis.inverse() * fwd_skel).normalized()
	return true


## `target` returns the world point the hand goes to; null lets the arm go back to its clip.
func reach(side: String, target: Variant) -> void:
	var r: Dictionary = _reach[side]
	r["on"] = target != null
	if target != null:
		r["target"] = target


func look(target: Variant) -> void:
	_look["on"] = target != null
	if target != null:
		_look["target"] = target


func _process_modification() -> void:
	var skel := get_skeleton()
	if skel == null:
		return
	var delta := maxf(get_process_delta_time(), 1e-4)
	var to_skel := skel.global_transform.affine_inverse()
	for side in _arms:
		var r: Dictionary = _reach[side]
		r["w"] = move_toward(float(r["w"]), 1.0 if bool(r["on"]) else 0.0, delta / EASE_S)
		if float(r["w"]) > 0.0 and (r["target"] as Callable).is_valid():
			var ids: Array = _arms[side]
			var anim := skel.get_bone_global_pose(ids[2]).origin
			var want: Vector3 = to_skel * ((r["target"] as Callable).call() as Vector3)
			_solve(skel, ids, anim.lerp(want, _smooth(float(r["w"]))))
	_look["w"] = move_toward(float(_look["w"]), 1.0 if bool(_look["on"]) else 0.0, delta / EASE_S)
	if float(_look["w"]) > 0.0 and (_look["target"] as Callable).is_valid():
		_turn_head(skel, to_skel * ((_look["target"] as Callable).call() as Vector3), _smooth(float(_look["w"])))


static func _smooth(u: float) -> float:
	return u * u * (3.0 - 2.0 * u)


## Turns neck and head (skeleton space) so the face points at `t`, by at most MAX_LOOK_DEG, `w` of the way.
func _turn_head(skel: Skeleton3D, t: Vector3, w: float) -> void:
	var gn := skel.get_bone_global_pose(_neck)
	var gh := skel.get_bone_global_pose(_head)
	var face := (gh.basis.orthonormalized() * _face_local).normalized()
	var want := (t - gh.origin).normalized()
	var angle := face.angle_to(want)
	if angle < 0.01:
		return
	var axis := face.cross(want)
	if axis.length() < 1e-6:
		return
	var turn := minf(angle, deg_to_rad(MAX_LOOK_DEG)) * w
	var qn := Quaternion(axis.normalized(), turn * NECK_SHARE)
	var qh := Quaternion(axis.normalized(), turn * (1.0 - NECK_SHARE))
	var parent := skel.get_bone_parent(_neck)
	var qp := skel.get_bone_global_pose(parent).basis.get_rotation_quaternion() if parent >= 0 else Quaternion.IDENTITY
	var n1 := qn * gn.basis.get_rotation_quaternion()
	var h1 := qh * qn * gh.basis.get_rotation_quaternion()
	# The head's parent (neck_02 on a MetaHuman) turns with the neck: its new global turn is qn on the old one.
	var hp := skel.get_bone_parent(_head)
	var qhp := qn * skel.get_bone_global_pose(hp).basis.get_rotation_quaternion()
	skel.set_bone_pose_rotation(_neck, (qp.inverse() * n1).normalized())
	skel.set_bone_pose_rotation(_head, (qhp.inverse() * h1).normalized())


## Two-bone IK in the skeleton's space (FootPlant._solve): the elbow bends in the plane it bends in now.
func _solve(skel: Skeleton3D, ids: Array, t: Vector3) -> void:
	var ga := skel.get_bone_global_pose(ids[0])
	var gb := skel.get_bone_global_pose(ids[1])
	var gc := skel.get_bone_global_pose(ids[2])
	var a := ga.origin
	var b := gb.origin
	var c := gc.origin
	var lab := (b - a).length()
	var lcb := (c - b).length()
	if lab < 1e-5 or lcb < 1e-5 or (c - a).length() < 1e-5 or (t - a).length() < 1e-5:
		return
	var lat := clampf((t - a).length(), absf(lab - lcb) + 1e-4, lab + lcb - 1e-4)
	var ac_ab_0 := acos(clampf((c - a).normalized().dot((b - a).normalized()), -1.0, 1.0))
	var ba_bc_0 := acos(clampf((a - b).normalized().dot((c - b).normalized()), -1.0, 1.0))
	var ac_at_0 := acos(clampf((c - a).normalized().dot((t - a).normalized()), -1.0, 1.0))
	var ac_ab_1 := acos(clampf((lcb * lcb - lab * lab - lat * lat) / (-2.0 * lab * lat), -1.0, 1.0))
	var ba_bc_1 := acos(clampf((lat * lat - lab * lab - lcb * lcb) / (-2.0 * lab * lcb), -1.0, 1.0))
	var axis0 := (c - a).cross(b - a)
	if axis0.length() < 1e-4:
		# A hanging arm is dead straight: bend it as an arm bends, the elbow back and down.
		ac_ab_0 = 0.0
		ba_bc_0 = PI
		axis0 = (c - a).cross(-_fwd_skel * 0.8 + Vector3.DOWN * 0.2)
		if axis0.length() < 1e-6:
			return
	axis0 = axis0.normalized()
	var r0 := Quaternion(axis0, ac_ab_1 - ac_ab_0)
	var r1 := Quaternion(axis0, ba_bc_1 - ba_bc_0)
	var axis1 := (c - a).cross(t - a)
	var r2 := Quaternion(axis1.normalized(), ac_at_0) if axis1.length() > 1e-6 else Quaternion.IDENTITY
	var qa := ga.basis.get_rotation_quaternion()
	var qb := gb.basis.get_rotation_quaternion()
	var qc := gc.basis.get_rotation_quaternion()
	var qa1 := r2 * r0 * qa
	var qb1 := r2 * r1 * r0 * qb
	var parent := skel.get_bone_parent(ids[0])
	var qp := skel.get_bone_global_pose(parent).basis.get_rotation_quaternion() if parent >= 0 else Quaternion.IDENTITY
	skel.set_bone_pose_rotation(ids[0], (qp.inverse() * qa1).normalized())
	skel.set_bone_pose_rotation(ids[1], (qa1.inverse() * qb1).normalized())
	skel.set_bone_pose_rotation(ids[2], (qb1.inverse() * qc).normalized())
