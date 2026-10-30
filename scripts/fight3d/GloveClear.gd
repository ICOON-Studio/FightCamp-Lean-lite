extends SkeletonModifier3D
## S315: a glove never sits inside the other boxer's head. Up close (inside spells, heads 14 cm apart) the guard idle,
## hooks and jabs played from clips authored at range put a glove centre deep inside the other's head in ~4 % of inside
## frames (tools/inside_guard_probe.gd: 22-36 of 571, with or without the S315 inside guard). Every frame, per hand: if the
## glove's centre (GLOVE_FWD_M past the wrist along the forearm) is nearer the other's head centre than CLEAR_M, the wrist
## is moved straight out of it by the difference and the arm re-solved as a two-bone chain (hand keeps its rotation). A
## landed punch's glove front stops on the face (PunchReach), at about the touch distance, so it moves a cm or two at most.
## tools/inside_guard_probe.gd, round 1's first 90 s: glove centre < 0.09 m from a head centre 36 -> 8 of 571 inside frames.
## Runs after HitSnap, before ElbowClear. `-- noglove` = the control arm.
##   setup(skel)  other (the other boxer's Skeleton3D, set by FightStage)

const PunchReach := preload("res://scripts/fight3d/PunchReach.gd")

## Head ~0.09 m + glove ~0.06 m radius: they touch at ~0.15 m. Kept at the touch: the other head is read before her own sway
## and snap move it (up to ~5 cm), so 0.13 left 12 of 571 inside frames deep in a head (36 without this modifier).
const CLEAR_M := 0.15
const GLOVE_FWD_M := 0.08
const HEAD_UP_M := 0.08

var other: Skeleton3D
var pushes := 0          # frames a glove was moved out (for probes)
var _arms := {}
var _head := -1


func setup(skel: Skeleton3D) -> bool:
	for side in ["Left", "Right"]:
		var ids := [skel.find_bone(side + "UpperArm"), skel.find_bone(side + "LowerArm"), skel.find_bone(side + "Hand")]
		if ids.has(-1):
			return false
		_arms[side] = ids
	_head = skel.find_bone("Head")
	return _head >= 0


func _process_modification() -> void:
	var skel := get_skeleton()
	if skel == null or other == null or not is_instance_valid(other):
		return
	var to_me := skel.global_transform.affine_inverse()
	var oh := other.find_bone("Head")
	if oh < 0:
		return
	var hc: Vector3 = to_me * (other.global_transform * other.get_bone_global_pose(oh).origin + Vector3.UP * HEAD_UP_M)
	# Skeleton space may be scaled (each body is scaled to her height): measure in world metres.
	var k := skel.global_transform.basis.get_scale().x
	for side in _arms:
		var ids: Array = _arms[side]
		var g_la: Transform3D = skel.get_bone_global_pose(int(ids[1]))
		var g_hd: Transform3D = skel.get_bone_global_pose(int(ids[2]))
		var gc := g_hd.origin + (g_hd.origin - g_la.origin).normalized() * GLOVE_FWD_M / k
		var away := gc - hc
		var d := away.length() * k
		if d >= CLEAR_M:
			continue
		var dir := away.normalized() if away.length() > 1e-5 else Vector3.UP
		var s: Vector3 = skel.get_bone_global_pose(int(ids[0])).origin
		var l1 := s.distance_to(g_la.origin)
		var l2 := g_la.origin.distance_to(g_hd.origin)
		PunchReach.solve(skel, ids, s, g_hd.origin + dir * (CLEAR_M - d) / k, l1, l2, g_hd.basis)
		pushes += 1
