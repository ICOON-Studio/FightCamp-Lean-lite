extends SkeletonModifier3D
## Keeps each elbow outside the torso. The guard and punch clips were authored on male boxers; on a narrower body the
## tucked rear elbow sinks into the ribs and the upper arm vanishes inside the tee (operator S298: "is that a human?").
## Per arm, every frame: if the elbow sits closer to the chest's centre line than CLEAR_M, the arm is re-solved as a
## two-bone chain with the SAME shoulder and wrist positions (so the glove stays exactly where the clip put it) and the
## elbow moved to the lowest point of its circle that clears CLEAR_M. The hand keeps its global rotation. Runs before MetaHumanTwist (it reads the result).

const CLEAR_M := 0.17
const ARMS := [["LeftUpperArm", "LeftLowerArm", "LeftHand", 1.0], ["RightUpperArm", "RightLowerArm", "RightHand", -1.0]]

var _ids: Array = []
var _chest := -1
## S321: her own PunchReach. Around a landed punch's contact the striking arm is left as the reach solved it (this
## modifier's share falls to 0 as the reach weight rises): moving that elbow turned the forearm, and the taped-wrist glove
## follows the forearm (Gloves.WRIST_STRAIGHT) - inside punches landed 0.13-0.28 m off the face (hit_gap_probe).
var reach: Node = null


func setup(skel: Skeleton3D) -> bool:
	_chest = skel.find_bone("Chest")
	for a in ARMS:
		var ids := [skel.find_bone(a[0]), skel.find_bone(a[1]), skel.find_bone(a[2]), float(a[3])]
		if ids[0] < 0 or ids[1] < 0 or ids[2] < 0:
			return false
		_ids.append(ids)
	return _chest >= 0


func _process_modification() -> void:
	var skel := get_skeleton()
	if skel == null or _ids.is_empty():
		return
	var chest: Transform3D = skel.get_bone_global_pose(_chest)
	var l_sh: Vector3 = skel.get_bone_global_pose(int(_ids[0][0])).origin
	var r_sh: Vector3 = skel.get_bone_global_pose(int(_ids[1][0])).origin
	var lateral := (l_sh - r_sh)
	lateral = lateral.normalized() if lateral.length() > 0.001 else chest.basis.x.normalized()
	for ids in _ids:
		var share := 1.0
		if reach != null and not OS.get_cmdline_user_args().has("elbowsalways") 				and str(reach.get("_hand")) == skel.get_bone_name(int(ids[2])):
			share = 1.0 - clampf(float(reach.get("last_weight")), 0.0, 1.0)
		if share > 0.0:
			_clear(skel, ids, chest.origin, lateral, share)


func _clear(skel: Skeleton3D, ids: Array, centre: Vector3, lateral: Vector3, share := 1.0) -> void:
	var ua: int = ids[0]
	var la: int = ids[1]
	var hd: int = ids[2]
	var sign: float = ids[3]
	var g_ua: Transform3D = skel.get_bone_global_pose(ua)
	var g_la: Transform3D = skel.get_bone_global_pose(la)
	var g_hd: Transform3D = skel.get_bone_global_pose(hd)
	var s := g_ua.origin
	var e := g_la.origin
	var h := g_hd.origin
	var out := (e - centre).dot(lateral) * sign
	if out >= CLEAR_M:
		return
	var l1 := s.distance_to(e)
	var l2 := e.distance_to(h)
	var d := s.distance_to(h)
	if d < 0.01 or d >= l1 + l2 - 0.001:
		return
	# The elbow circle: centre on the shoulder-wrist line, radius r, in the plane normal to that line.
	var axis := (h - s) / d
	var a := (l1 * l1 - l2 * l2 + d * d) / (2.0 * d)
	var r := sqrt(maxf(0.0, l1 * l1 - a * a))
	var c := s + axis * a
	var cur := (e - c)
	cur = (cur - axis * cur.dot(axis))
	cur = cur.normalized() if cur.length() > 0.0001 else lateral * sign
	# Search the whole elbow circle: of the positions that clear her side, take the LOWEST (a boxer's elbows stay down by
	# the ribs); if none clears, the one that sticks out furthest.
	var u := cur
	var v := axis.cross(cur).normalized()
	var best := cur
	var best_y := INF
	var widest := cur
	var widest_out := -INF
	for k in 48:
		var ang := TAU * float(k) / 48.0
		var dir := (u * cos(ang) + v * sin(ang)).normalized()
		var p := c + dir * r
		var o := (p - centre).dot(lateral) * sign
		if o > widest_out:
			widest_out = o
			widest = dir
		if o >= CLEAR_M and p.y < best_y:
			best_y = p.y
			best = dir
	if best_y == INF:
		best = widest
	if share < 1.0:
		best = cur.slerp(best, share).normalized()
	var e2 := c + best * r
	# Upper arm: rotate so shoulder->elbow points at the new elbow.
	var rot_ua := Quaternion((e - s).normalized(), (e2 - s).normalized())
	var n_ua := Transform3D(Basis(rot_ua) * g_ua.basis, s)
	skel.set_bone_global_pose(ua, n_ua)
	# Forearm: it moved with its parent; rotate it so elbow->wrist points at the original wrist.
	var g_la2: Transform3D = skel.get_bone_global_pose(la)
	var h_now: Vector3 = g_la2 * (g_la.affine_inverse() * h)
	var rot_la := Quaternion((h_now - e2).normalized(), (h - e2).normalized())
	skel.set_bone_global_pose(la, Transform3D(Basis(rot_la) * g_la2.basis, e2))
	# Hand: the same global pose as the clip gave it.
	skel.set_bone_global_pose(hd, g_hd)
