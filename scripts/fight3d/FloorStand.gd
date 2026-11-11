extends SkeletonModifier3D
## HUMANFIGHT1 (operator S430: "i see some animations the fighters are off the ground flying"). A standing boxer always
## has a foot on the canvas and never a foot under it - and nothing in the stack held that. The footwork rig stands the
## balls on the canvas only while it has the legs; three quarters of a round a captured take plays "pure" (RkPure: every
## leg layer off), and at each return to her guard from a duck, a block or a reaction the join smoother blends from the
## raw clip's bent, floating legs while the rig lets go in 0.2 s: the body rose 5-9 cm clear of the canvas for half a
## second, 5-13 times a boxer in two rounds (tests/human_feet_test.gd, tools/human_fight_film.gd on the real bout).
## This is the LAST leg layer and RkPure keeps it on (it adds nothing to a take whose feet already stand):
##   1. both feet over the canvas -> the hips come down until the lower foot stands (its ball or its heel, whichever is
##      lower: a raised heel keeps the ball down, a raised toe keeps the heel down);
##   2. a foot under the canvas -> that leg bends (two-bone IK, the knee in its own plane, the foot keeps its turn) until
##      the foot stands on it.
## Not when she is down or going down (FloorClear has her then), not in a free clip (falls, knockouts, the win: the same
## list FootPlant lets go for), not in a scene (a boxer on the stool has her feet where the stool puts them).
## `-- nofloorstand` = the control arm.
##   FloorStand.attach(skel, ap, stage) -> FloorStand        drop, lifts: the last frame's corrections (probes read them)

const LEGS := [["LeftUpperLeg", "LeftLowerLeg", "LeftFoot", "LeftToes"], ["RightUpperLeg", "RightLowerLeg", "RightFoot", "RightToes"]]
const FREE := ["knockout", "win", "countdown", "fall", "sit", "stool"]
const LOW_HIPS := 0.62          # of the hips' rest height: under it she is ducking deep or going down - left alone under 0.5
const DOWN_HIPS := 0.5
const EASE_S := 0.15            # in and out around a free clip or a scene

var _ap: AnimationPlayer
var _stage: Node
var _hips := -1
var _hips_rest := 1.0
var _legs: Array = []           # per leg: {ids: [upper, lower, foot, toes], ball: rest y, ankle: rest y} (skeleton units)
var _w := 0.0
var drop := 0.0                 # m the hips came down this frame (world)
var lifts: Array = [0.0, 0.0]   # m each foot came up this frame (world)


static func attach(skel: Skeleton3D, ap: AnimationPlayer, stage: Node) -> Node:
	if OS.get_cmdline_user_args().has("nofloorstand"):
		return null
	var f := new()
	f.name = "FloorStand"
	f._ap = ap
	f._stage = stage
	f._hips = skel.find_bone("Hips")
	if f._hips < 0:
		f.free()
		return null
	f._hips_rest = skel.get_bone_global_rest(f._hips).origin.y
	for leg in LEGS:
		var ids: Array = (leg as Array).map(func(n): return skel.find_bone(str(n)))
		if ids.has(-1):
			f.free()
			return null
		f._legs.append({"ids": ids, "ball": skel.get_bone_global_rest(ids[3]).origin.y, "ankle": skel.get_bone_global_rest(ids[2]).origin.y})
	skel.add_child(f)
	return f


func _process_modification() -> void:
	var skel := get_skeleton()
	if skel == null or _legs.is_empty():
		return
	drop = 0.0
	lifts = [0.0, 0.0]
	var free := _stage != null and bool(_stage.get("scene"))
	var clip := str(_ap.current_animation) if _ap != null else ""
	for word in FREE:
		free = free or clip.contains(word)
	_w = move_toward(_w, 0.0 if free else 1.0, maxf(get_process_delta_time(), 1e-4) / EASE_S)
	if _w <= 0.0:
		return
	var xf := skel.global_transform
	var s := maxf(xf.basis.get_scale().y, 1e-3)
	var floor_y := xf.origin.y   # her node stands on the canvas
	var hips_h := skel.get_bone_global_pose(_hips).origin.y / _hips_rest
	var w := _w * clampf((hips_h - DOWN_HIPS) / (LOW_HIPS - DOWN_HIPS), 0.0, 1.0)
	if w <= 0.0:
		return
	# 1. How far each foot is over (+) or under (-) the canvas, world metres.
	var clear: Array = []
	for leg in _legs:
		clear.append(_clear(skel, xf, leg, floor_y, s))
	var low: float = minf(clear[0], clear[1])
	if low > 0.0:
		drop = low * w
		var up_sk := xf.basis.inverse() * Vector3(0.0, -drop, 0.0)
		var parent := skel.get_bone_parent(_hips)
		var pb := skel.get_bone_global_pose(parent).basis if parent >= 0 else Basis.IDENTITY
		skel.set_bone_pose_position(_hips, skel.get_bone_pose_position(_hips) + pb.inverse() * up_sk)
	# 2. A foot still under it: the leg bends until the foot stands.
	for i in 2:
		var under: float = -(float(clear[i]) - drop)
		if under <= 0.0005:
			continue
		lifts[i] = under * w
		var ids: Array = _legs[i]["ids"]
		var ankle := skel.get_bone_global_pose(ids[2]).origin
		_reach(skel, ids, ankle + xf.basis.inverse() * Vector3(0.0, float(lifts[i]), 0.0))


## The foot's height over the canvas: its ball or its ankle, whichever is nearer its standing height.
func _clear(skel: Skeleton3D, xf: Transform3D, leg: Dictionary, floor_y: float, s: float) -> float:
	var ids: Array = leg["ids"]
	var ball := (xf * skel.get_bone_global_pose(ids[3]).origin).y - floor_y - float(leg["ball"]) * s
	var ankle := (xf * skel.get_bone_global_pose(ids[2]).origin).y - floor_y - float(leg["ankle"]) * s
	return minf(ball, ankle)


## Two-bone solve in skeleton space: hip ids[0], knee ids[1], ankle ids[2] meets `target`; the knee stays in the plane it
## bends in, the foot keeps its global turn.
func _reach(skel: Skeleton3D, ids: Array, target: Vector3) -> void:
	var hg := skel.get_bone_global_pose(ids[0])
	var kg := skel.get_bone_global_pose(ids[1])
	var ag := skel.get_bone_global_pose(ids[2])
	var h := hg.origin
	var k := kg.origin
	var a := ag.origin
	var l1 := (k - h).length()
	var l2 := (a - k).length()
	var to := target - h
	if l1 < 1e-5 or l2 < 1e-5 or to.length() < 1e-5:
		return
	var d := clampf(to.length(), absf(l1 - l2) + 1e-3, l1 + l2 - 1e-3)
	var dir := to.normalized()
	var n := (k - h).cross(a - h)
	if n.length() < 1e-6:
		n = hg.basis.x   # a dead-straight leg: bend about the thigh's own side axis
	n = n.normalized()
	var perp := n.cross(dir).normalized()
	if (k - h).dot(perp) < 0.0:
		perp = -perp
	var ca := clampf((l1 * l1 + d * d - l2 * l2) / (2.0 * l1 * d), -1.0, 1.0)
	var k2 := h + (dir * ca + perp * sqrt(1.0 - ca * ca)) * l1
	var t2 := h + dir * d
	var foot := ag.basis.get_rotation_quaternion()
	var q1 := Quaternion((k - h).normalized(), (k2 - h).normalized()) * hg.basis.get_rotation_quaternion()
	var shin := (Quaternion((k - h).normalized(), (k2 - h).normalized()) * (a - k)).normalized()
	var q2 := Quaternion(shin, (t2 - k2).normalized()) * Quaternion((k - h).normalized(), (k2 - h).normalized()) * kg.basis.get_rotation_quaternion()
	var parent := skel.get_bone_parent(ids[0])
	var qp := skel.get_bone_global_pose(parent).basis.get_rotation_quaternion() if parent >= 0 else Quaternion.IDENTITY
	skel.set_bone_pose_rotation(ids[0], (qp.inverse() * q1).normalized())
	skel.set_bone_pose_rotation(ids[1], (q1.inverse() * q2).normalized())
	skel.set_bone_pose_rotation(ids[2], (q2.inverse() * foot).normalized())
