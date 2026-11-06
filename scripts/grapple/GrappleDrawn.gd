extends RefCounted
## S380 BJJ9R16: overlap on the skeleton AS DRAWN (after GrapplePose), corrected by GrapplePose.world_shift (not by moving
## joint targets). S389: every frame, by track().

const DB := preload("res://scripts/grapple/GrappleMapDB.gd")

const BONES := ["Hips", "Spine", "Neck", "Head", "LeftUpperArm", "RightUpperArm", "LeftLowerArm", "RightLowerArm",
	"LeftHand", "RightHand", "LeftUpperLeg", "RightUpperLeg", "LeftLowerLeg", "RightLowerLeg", "LeftFoot", "RightFoot",
	"LeftToes", "RightToes"]
const LIMBS := [["neck", "Neck", "Head", 0.07], ["shoulders", "LeftUpperArm", "RightUpperArm", 0.085],
	["upperarmL", "LeftUpperArm", "LeftLowerArm", 0.06], ["upperarmR", "RightUpperArm", "RightLowerArm", 0.06],
	["forearmL", "LeftLowerArm", "LeftHand", 0.045], ["forearmR", "RightLowerArm", "RightHand", 0.045],
	["thighL", "LeftUpperLeg", "LeftLowerLeg", 0.10], ["thighR", "RightUpperLeg", "RightLowerLeg", 0.10],
	["shinL", "LeftLowerLeg", "LeftFoot", 0.065], ["shinR", "RightLowerLeg", "RightFoot", 0.065],
	["footL", "LeftFoot", "LeftToes", 0.068], ["footR", "RightFoot", "RightToes", 0.068]]
## track(): metres a second at most, the share of an error closed a frame, and what counts as fine.
const TRACK_RATE := 1.4
const TRACK_GAIN := 0.3
const PEN_OK := 0.03
const GAP_OK := 0.015
const FLOOR_OK := 0.012
const REL_MAX := 0.55
const LIFT_MAX := 0.5
const LIFT_DOWN_MAX := 0.15
const GROUND_CORE_Y := 0.62


static func read_bones(skel: Skeleton3D) -> Dictionary:
	var gt := skel.global_transform
	var d := {}
	for n in BONES:
		var i := skel.find_bone(n)
		if i >= 0:
			d[n] = gt * skel.get_bone_global_pose(i).origin
	return d


## Bone origins in world space from a pose's drawn globals. `world_ofs` simulates a display shift (metres, world).
static func bone_world(pose: Node, skel: Skeleton3D, j_world: PackedVector3Array, world_ofs: Vector3 = Vector3.ZERO) -> Dictionary:
	var inv := skel.global_transform.affine_inverse()
	var j := PackedVector3Array()
	for v in j_world:
		j.append(inv * v)
	var mem: Variant = pose.get("_mem")
	var g: Dictionary = pose.pose_globals(skel, j, mem, 0.0)
	var gt := skel.global_transform
	var d := {}
	for n in BONES:
		var bi: int = skel.find_bone(n)
		if bi >= 0:
			d[n] = gt * (g[bi] as Transform3D).origin + world_ofs
	return d


static func parts(d: Dictionary) -> Dictionary:
	var lat: Vector3 = ((d["RightUpperLeg"] as Vector3) - (d["LeftUpperLeg"] as Vector3)).normalized()
	var torso: Array = [["pelvis", d["LeftUpperLeg"], d["RightUpperLeg"], 0.118]]
	for s in [1.0, -1.0]:
		torso.append(["trunk", (d["Spine"] as Vector3) + lat * 0.035 * s, (d["Neck"] as Vector3) + lat * 0.035 * s, 0.12])
	var all: Array = torso.duplicate()
	var head: Vector3 = d["Head"]
	var hc := head + (head - (d["Neck"] as Vector3)).normalized() * 0.08
	all.append(["head", hc, hc, 0.11])
	for l in LIMBS:
		all.append([l[0], d[l[1]], d[l[2]], l[3]])
	return {"torso": torso, "all": all}


static func deepest(xs: Array, ys: Array) -> float:
	var best := 0.0
	for x in xs:
		for y in ys:
			var pts := Geometry3D.get_closest_points_between_segments(x[1], x[2], y[1], y[2])
			var dd: float = float(x[3]) + float(y[3]) - (pts[0] as Vector3).distance_to(pts[1])
			best = maxf(best, dd)
	return best


static func torso_depth(p0: Dictionary, p1: Dictionary) -> float:
	return maxf(deepest(p0["all"], p1["torso"]), deepest(p1["all"], p0["torso"]))


## S389 (operator's stills: "not even close to each other", "goes inside the floor"; the drawn bars: below the mat on 63% of
## frames, torsos 0.22 m deep). The data is a thin figure's; our women are thick, so every frame the two bodies are placed
## as drawn: LIFT clears the mat for both, REL pushes torsos out of each other and, on the ground, closes a gap. Rate-capped
## so nothing pops. `st` = {rel: Vector3, lift: float}, kept by GrapplePlayer; body 1 moves +rel/2, body 0 -rel/2.
static func track(men: Array, j0: PackedVector3Array, j1: PackedVector3Array, st: Dictionary, delta: float) -> void:
	if men.size() < 2 or j0.size() != DB.JOINTS.size() or j1.size() != DB.JOINTS.size():
		return
	var rel: Vector3 = st["rel"]
	var lift := float(st["lift"])
	var up := Vector3(0.0, lift, 0.0)
	var p0 := parts(bone_world(men[0], (men[0] as Node).get_parent(), j0, up - rel * 0.5))
	var p1 := parts(bone_world(men[1], (men[1] as Node).get_parent(), j1, up + rel * 0.5))
	var step := TRACK_RATE * delta
	var ground: bool = minf(j0[DB.joint("Core")].y, j1[DB.joint("Core")].y) < GROUND_CORE_Y
	var near := _nearest(p0, p1)
	if float(near["pen"]) > PEN_OK:
		rel += (near["pen_n"] as Vector3) * minf(float(near["pen"]) * TRACK_GAIN, step)
	elif ground and float(near["gap"]) > GAP_OK:
		rel -= (near["gap_n"] as Vector3) * minf(float(near["gap"]) * TRACK_GAIN, step)
	elif not ground:
		rel = rel.move_toward(Vector3.ZERO, step * 0.5)
	st["rel"] = rel.limit_length(REL_MAX)
	var low := minf(_lowest(p0["all"]), _lowest(p1["all"]))
	if low < 0.0:
		lift += minf(-low * TRACK_GAIN * 2.0, step)
	elif low > FLOOR_OK:
		lift -= minf(low * TRACK_GAIN, step)
	st["lift"] = clampf(lift, -LIFT_DOWN_MAX, LIFT_MAX)


static func _lowest(caps: Array) -> float:
	var low := INF
	for c in caps:
		low = minf(low, minf((c[1] as Vector3).y, (c[2] as Vector3).y) - float(c[3]))
	return low


## The deepest torso overlap and the closest surfaces, each with its direction from body 0 to body 1.
static func _nearest(p0: Dictionary, p1: Dictionary) -> Dictionary:
	var out := {"pen": 0.0, "pen_n": Vector3.UP, "gap": INF, "gap_n": Vector3.RIGHT}
	for x in p0["all"]:
		for y in p1["all"]:
			var pts := Geometry3D.get_closest_points_between_segments(x[1], x[2], y[1], y[2])
			var along: Vector3 = (pts[1] as Vector3) - (pts[0] as Vector3)
			var d: float = along.length() - float(x[3]) - float(y[3])
			var n := along.normalized() if along.length() > 0.001 else Vector3.UP
			if d < float(out["gap"]):
				out["gap"] = d
				out["gap_n"] = n
			var torso: bool = str(x[0]) in ["pelvis", "trunk"] and str(y[0]) in ["pelvis", "trunk"]
			if torso and -d > float(out["pen"]):
				out["pen"] = -d
				out["pen_n"] = n
	return out
