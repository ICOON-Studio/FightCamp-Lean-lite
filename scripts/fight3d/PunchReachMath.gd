extends RefCounted
## SPLIT471: the pure static math split out of PunchReach.gd (it had reached the 500-line cap).
## Two-bone IK solve, the reach-weight curve, and the glove's long-axis direction. No member state; every function takes
## what it needs as arguments. PunchReach calls these and keeps a forwarding solve() for GloveClear, GuardTuck, TellPose.

const Gloves := preload("res://scripts/fight3d/Gloves.gd")

## Clip seconds (the clip's own time, so it follows any playback speed): weight 0 -> 1 over IN_S before contact, held
## HOLD_S, 1 -> 0 over OUT_S.
const IN_S := 0.14
const HOLD_S := 0.05
const OUT_S := 0.16
## The glove's long axis leans this share from the hand onto the forearm (Gloves.WRIST_STRAIGHT; `-- bentwrist` = 0 there).
static var STRAIGHT: float = 0.0 if OS.get_cmdline_user_args().has("bentwrist") else Gloves.WRIST_STRAIGHT


## 0..1 at clip time t (`hold`: how long it stays 1 after contact; a landed drive holds through its carry, _hold()).
static func weight(t: float, contact: float, hold: float = HOLD_S) -> float:
	var u := 0.0
	if t < contact - IN_S:
		return 0.0
	elif t < contact:
		u = (t - (contact - IN_S)) / IN_S
	elif t <= contact + hold:
		return 1.0
	elif t < contact + hold + OUT_S:
		u = 1.0 - (t - contact - hold) / OUT_S
	else:
		return 0.0
	return u * u * (3.0 - 2.0 * u)


## The glove's long axis, as Gloves.gd mounts it: the wrist-to-knuckle direction turned WRIST_STRAIGHT of the way onto the
## forearm (S316 taped wrist). S321: this aimed along the bare hand alone, so wherever a clip bends the wrist (hooks, short
## inside punches) the glove's real striking face landed 0.13-0.28 m short and to the side of the face (hit_gap_probe).
static func along(skel: Skeleton3D, ids: Array) -> Vector3:
	var wrist: Vector3 = skel.get_bone_global_pose(int(ids[2])).origin
	var a: Vector3 = skel.get_bone_global_pose(int(ids[3])).origin - wrist
	if a.length() < 1e-5:
		return Vector3.FORWARD
	a = a.normalized()
	var arm: Vector3 = wrist - skel.get_bone_global_pose(int(ids[1])).origin
	if STRAIGHT > 0.0 and arm.length() > 1e-5 and a.angle_to(arm) > 1e-3:
		a = a.slerp(arm.normalized(), STRAIGHT).normalized()
	return a


## Two-bone solve: shoulder fixed, wrist on `want` (clamped to the arm's reach), elbow kept on its current side; the hand
## keeps `hand_basis`. ids = [upper arm, lower arm, hand, ...] (GuardTuck uses it too). S315: `pole_w` > 0 turns the elbow's
## side that far toward `pole` (skeleton space; GuardTuck's inside guard drops the elbows onto the ribs).
static func solve(skel: Skeleton3D, ids: Array, s: Vector3, want: Vector3, l1: float, l2: float, hand_basis: Basis, pole := Vector3.ZERO, pole_w := 0.0) -> void:
	var ua: int = ids[0]
	var la: int = ids[1]
	var hd: int = ids[2]
	var g_ua: Transform3D = skel.get_bone_global_pose(ua)
	var e: Vector3 = skel.get_bone_global_pose(la).origin
	var d := clampf(s.distance_to(want), absf(l1 - l2) + 0.01, l1 + l2 - 0.004)
	var axis := want - s
	if axis.length() < 1e-4:
		return
	axis = axis.normalized()
	var h := s + axis * d
	var a := (l1 * l1 - l2 * l2 + d * d) / (2.0 * d)
	var r := sqrt(maxf(0.0, l1 * l1 - a * a))
	var c := s + axis * a
	var bend := (e - c) - axis * (e - c).dot(axis)
	bend = bend.normalized() if bend.length() > 1e-4 else Vector3.DOWN
	if pole_w > 0.0:
		var pp := pole - axis * pole.dot(axis)
		if pp.length() > 1e-4:
			bend = bend.slerp(pp.normalized(), clampf(pole_w, 0.0, 1.0)).normalized()
	var e2 := c + bend * r
	var rot_ua := Quaternion((e - s).normalized(), (e2 - s).normalized())
	skel.set_bone_global_pose(ua, Transform3D(Basis(rot_ua) * g_ua.basis, s))
	var g_la: Transform3D = skel.get_bone_global_pose(la)
	var h_now: Vector3 = skel.get_bone_global_pose(hd).origin
	var rot_la := Quaternion((h_now - e2).normalized(), (h - e2).normalized())
	skel.set_bone_global_pose(la, Transform3D(Basis(rot_la) * g_la.basis, e2))
	skel.set_bone_global_pose(hd, Transform3D(hand_basis, h))
