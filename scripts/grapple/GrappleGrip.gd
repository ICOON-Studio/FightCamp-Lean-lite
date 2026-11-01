extends SkeletonModifier3D
## S336 hands that grip (S335 film, operator: "can still be improved"): GrappleMap's men have a hand and a fingers joint but no
## fingers, so our women held every collar, wrist and leg with flat open hands. When a hand is near the other body (her
## capsules, the radii TASK_GROUND2A uses), its fingers curl into a grip, eased in over a few frames; away, it opens again.
## The curl axis of each finger bone is read off the hand's own rest shape (finger direction x palm normal, the palm side
## being the thumb's side), so the rig's bone axes never matter. Runs after GrapplePose (it only touches finger bones).
##   attach(skel, me: GrapplePose, them: GrapplePose) -> GrappleGrip    .curl = Vector2(left, right) 0 open .. 1 grip

const DB := preload("res://scripts/grapple/GrappleMapDB.gd")
const SIDES := ["Left", "Right"]
const FINGERS := ["Index", "Middle", "Ring", "Little"]
## A grip on an arm, a collar or a leg, not a closed fist (degrees per joint at full curl).
const GRIP_DEG := {"Proximal": 65.0, "Intermediate": 85.0, "Distal": 55.0}
const THUMB_DEG := {"Metacarpal": 15.0, "Proximal": 30.0, "Distal": 35.0}
## Hand to the other body's skin: full grip under NEAR_M, open past FAR_M.
const NEAR_M := 0.04
const FAR_M := 0.12
const EASE := 8.0
## The other body as capsules between its joints (radius, metres; hands left out: two hands do not grip each other).
const BODY := [["Core", "Neck", 0.13], ["LeftHip", "RightHip", 0.11], ["Neck", "Head", 0.07], ["Head", "Head", 0.10],
	["LeftHip", "LeftKnee", 0.075], ["RightHip", "RightKnee", 0.075], ["LeftKnee", "LeftAnkle", 0.05],
	["RightKnee", "RightAnkle", 0.05], ["LeftShoulder", "LeftElbow", 0.05], ["RightShoulder", "RightElbow", 0.05],
	["LeftElbow", "LeftWrist", 0.04], ["RightElbow", "RightWrist", 0.04], ["Core", "LeftHip", 0.12],
	["Core", "RightHip", 0.12], ["LeftAnkle", "LeftToe", 0.04], ["RightAnkle", "RightToe", 0.04]]

var me: Node     # this woman's GrapplePose (its .joints, world)
var them: Node   # the other woman's GrapplePose
var curl := Vector2.ZERO
## false = the curl jumps to its target (tests, stills)
var ease := true
var _bones := {}   # side -> [[bone index, rest local rotation, local axis, degrees], ...]


static func attach(skel: Skeleton3D, mine: Node, other: Node) -> Node:
	var g := new()
	g.name = "GrappleGrip"
	if not g._setup(skel):
		g.free()
		return null
	g.me = mine
	g.them = other
	skel.add_child(g)
	if mine != null and mine.get_parent() == skel:
		skel.move_child(g, mine.get_index() + 1)
	return g


func _setup(skel: Skeleton3D) -> bool:
	for s in SIDES:
		var hand := skel.find_bone(s + "Hand")
		var mid := skel.find_bone(s + "MiddleProximal")
		var idx := skel.find_bone(s + "IndexProximal")
		var lit := skel.find_bone(s + "LittleProximal")
		var thb := skel.find_bone(s + "ThumbProximal")
		if mini(mini(hand, mid), mini(mini(idx, lit), thb)) < 0:
			return false
		var h := skel.get_bone_global_rest(hand).origin
		var d := (skel.get_bone_global_rest(mid).origin - h).normalized()
		var across := skel.get_bone_global_rest(idx).origin - skel.get_bone_global_rest(lit).origin
		across = (across - d * d.dot(across)).normalized()
		var n := d.cross(across).normalized()
		if n.dot(skel.get_bone_global_rest(thb).origin - h) < 0.0:
			n = -n
		var list: Array = []
		for f in FINGERS:
			for seg in GRIP_DEG.keys():
				list.append(_bone(skel, s + f + seg, n, GRIP_DEG[seg]))
		for seg in THUMB_DEG.keys():
			list.append(_bone(skel, s + "Thumb" + seg, n, THUMB_DEG[seg]))
		_bones[s] = list.filter(func(b): return not b.is_empty())
	return true


## One finger bone: its curl axis (its direction x the palm normal, so a positive turn folds it to the palm) in its own frame.
static func _bone(skel: Skeleton3D, name: String, palm: Vector3, deg: float) -> Array:
	var i := skel.find_bone(name)
	if i < 0:
		return []
	var g := skel.get_bone_global_rest(i)
	var dir := Vector3.ZERO
	for c in skel.get_bone_children(i):
		dir = skel.get_bone_global_rest(c).origin - g.origin
	if dir.length() < 1e-5:
		dir = g.origin - skel.get_bone_global_rest(skel.get_bone_parent(i)).origin
	var axis := dir.normalized().cross(palm)
	if axis.length() < 1e-4:
		return []
	return [i, skel.get_bone_rest(i).basis.get_rotation_quaternion(), (g.basis.inverse() * axis.normalized()).normalized(), deg]


## How closed each hand should be (left, right) for these joints (world): 1 on the other body's skin, 0 a hand away.
static func targets(mine: PackedVector3Array, other: PackedVector3Array) -> Vector2:
	var out := Vector2.ZERO
	if mine.size() != DB.JOINTS.size() or other.size() != DB.JOINTS.size():
		return out
	for k in 2:
		var p := (mine[DB.joint(SIDES[k] + "Hand")] + mine[DB.joint(SIDES[k] + "Fingers")]) * 0.5
		var gap := skin_distance(p, other)
		out[k] = 1.0 - smoothstep(NEAR_M, FAR_M, gap)
	return out


## From a point to the nearest skin of the other body (negative inside it).
static func skin_distance(p: Vector3, other: PackedVector3Array) -> float:
	var best := INF
	for c in BODY:
		var a: Vector3 = other[DB.joint(c[0])]
		var b: Vector3 = other[DB.joint(c[1])]
		var ab := b - a
		var t := 0.0 if ab.length_squared() < 1e-8 else clampf((p - a).dot(ab) / ab.length_squared(), 0.0, 1.0)
		best = minf(best, p.distance_to(a + ab * t) - float(c[2]))
	return best


## The finger rotations (local, by bone index) for a hand closed by `amount` (0..1).
func hand_pose(side: String, amount: float) -> Dictionary:
	var out := {}
	for b in _bones.get(side, []):
		out[b[0]] = (b[1] as Quaternion) * Quaternion(b[2] as Vector3, deg_to_rad(float(b[3])) * amount)
	return out


func _process_modification() -> void:
	var skel := get_skeleton()
	if skel == null or me == null or them == null:
		return
	var want := targets(me.joints, them.joints)
	if ease:
		curl = curl.lerp(want, minf(1.0, get_process_delta_time() * EASE))
	else:
		curl = want
	for k in 2:
		var pose := hand_pose(SIDES[k], curl[k])
		for i in pose.keys():
			skel.set_bone_pose_rotation(i, pose[i])
