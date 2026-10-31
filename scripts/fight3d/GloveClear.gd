extends SkeletonModifier3D
## S315: a glove never sits inside the other boxer's head. Up close (inside spells, heads 14 cm apart) the guard idle,
## hooks and jabs played from clips authored at range put a glove centre deep inside the other's head in ~4 % of inside
## frames (tools/inside_guard_probe.gd: 22-36 of 571, with or without the S315 inside guard). Every frame, per hand: if the
## glove's centre (GLOVE_FWD_M past the wrist along the forearm) is nearer the other's head centre than CLEAR_M, the wrist
## is moved straight out of it by the difference and the arm re-solved as a two-bone chain (hand keeps its rotation). A
## landed punch's glove front stops on the face (PunchReach), at about the touch distance, so it moves a cm or two at most.
## tools/inside_guard_probe.gd, round 1's first 90 s: glove centre < 0.09 m from a head centre 36 -> 8 of 571 inside frames.
## Runs after HitSnap, before ElbowClear. `-- noglove` = the control arm (gloves and heads), `-- noheads` = heads only.
## S316: her head clears the other's too (_clear_head, run before the gloves).
##   setup(skel)  other (the other boxer's Skeleton3D, set by FightStage)

const PunchReach := preload("res://scripts/fight3d/PunchReach.gd")

## Head ~0.09 m + glove ~0.06 m radius: they touch at ~0.15 m. Kept at the touch: the other head is read before her own sway
## and snap move it (up to ~5 cm), so 0.13 left 12 of 571 inside frames deep in a head (36 without this modifier).
const CLEAR_M := 0.15
const GLOVE_FWD_M := 0.08
const HEAD_UP_M := 0.08

## Head centre 8 cm up the head bone, ~0.09-0.10 m radius: two heads touch at ~0.19 m.
const HEAD_TOUCH_M := 0.19
## Each boxer leans out of this share of the overlap; over half, since the first boxer of the frame reads the other's
## head a frame late (peer.shown_head) and the arc's chord falls a little short of the push.
const HEAD_SHARE := 0.7

var other: Skeleton3D
## The other boxer's GloveClear: its head centre AS SHOWN (after her snap, sway and hit fold), in world space. Read from
## outside the stack, her skeleton gives the animated pose without them - up to ~0.15 m off in a gut shot's fold.
var peer = null
## S320 hit_gap_probe: her own PunchReach. A landing punch's glove is meant to touch the face - this modifier kept every
## glove 0.15 m from the other head's centre and pushed the scoring glove 0.13-0.22 m off the face it was carried onto
## (inside jabs and hooks "landed" short). The striking hand is left alone while its reach is on.
var reach: Node = null
var shown_head := Vector3.INF
var heads := true        # `-- noheads` turns the head clearance off (control arm)
var pushes := 0          # frames a glove was moved out (for probes)
var head_pushes := 0     # frames her trunk leaned out of the other's head
var _arms := {}
var _head := -1
var _spine := -1
var _chest := -1


func setup(skel: Skeleton3D) -> bool:
	for side in ["Left", "Right"]:
		var ids := [skel.find_bone(side + "UpperArm"), skel.find_bone(side + "LowerArm"), skel.find_bone(side + "Hand")]
		if ids.has(-1):
			return false
		_arms[side] = ids
	_head = skel.find_bone("Head")
	_spine = skel.find_bone("Spine")
	_chest = skel.find_bone("Chest")
	heads = _spine >= 0 and _chest >= 0 and not OS.get_cmdline_user_args().has("noheads")
	return _head >= 0


func _process_modification() -> void:
	var skel := get_skeleton()
	if skel == null or other == null or not is_instance_valid(other):
		return
	var to_me := skel.global_transform.affine_inverse()
	var oh := other.find_bone("Head")
	if oh < 0:
		return
	var oc: Vector3 = other.global_transform * other.get_bone_global_pose(oh).origin + Vector3.UP * HEAD_UP_M
	if peer != null and is_instance_valid(peer) and peer.shown_head.is_finite():
		oc = peer.shown_head
	var hc: Vector3 = to_me * oc
	# Skeleton space may be scaled (each body is scaled to her height): measure in world metres.
	var k := skel.global_transform.basis.get_scale().x
	# The head first: her lean moves her own arms, and the gloves are cleared after it.
	if heads:
		_clear_head(skel, hc, k)
	shown_head = skel.global_transform * (skel.get_bone_global_pose(_head).origin + Vector3.UP * HEAD_UP_M / k)
	for side in _arms:
		if reach != null and str(reach.get("_hand")).begins_with(side) and float(reach.get("last_weight")) > 0.0:
			continue
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


## S316: heads touch up close (temple to temple, a head on a shoulder) but never pass through each other - inside_guard_probe
## measured 8 of 571 inside frames with the head centres under 0.16 m (the closest 0.026 m: a gut shot's fold into a cross).
## Her trunk leans back from the other head by HEAD_SHARE of the overlap (both boxers do it, so the pair clears it), half on
## the spine, half on the chest, in the horizontal plane only. `-- noheads` = the control arm.
func _clear_head(skel: Skeleton3D, hc: Vector3, k: float) -> void:
	var c := skel.get_bone_global_pose(_head).origin + Vector3.UP * HEAD_UP_M / k
	var away := c - hc
	away.y = 0.0
	var d := (c - hc).length() * k
	if d >= HEAD_TOUCH_M or away.length() < 1e-5:
		return
	var dir := away.normalized()
	# Horizontal only: the gap that makes the 3D distance the touch, given the heads' height difference (a gut shot's fold
	# drops one head well below the other).
	var v := absf((c - hc).y) * k
	var h := away.length() * k
	var push := (sqrt(maxf(HEAD_TOUCH_M * HEAD_TOUCH_M - v * v, 0.0)) - h) * HEAD_SHARE / k
	if push <= 0.0:
		return
	for b in [_spine, _chest]:
		var g: Transform3D = skel.get_bone_global_pose(b)
		var arm := c - g.origin
		var axis := arm.cross(dir)
		if axis.length() < 1e-5 or arm.length() < 1e-3:
			continue
		var q := Quaternion(axis.normalized(), 0.5 * push / arm.length())
		skel.set_bone_global_pose(b, Transform3D(Basis(q) * g.basis, g.origin))
		c = g.origin + q * arm
	head_pushes += 1
