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
const PEN_OK := 0.012   # S399: 0.03 -> 0.012, torsos settled 3-4 cm deep (bar 3 cm)
static var pen_ok := _pen_arg()


static func _pen_arg() -> float:
	for x in OS.get_cmdline_user_args():
		if str(x).begins_with("penok="):
			return float(str(x).substr(6))
	return PEN_OK
const GAP_OK := 0.015
const FLOOR_OK := 0.012
const REL_MAX := 0.55
const LIFT_MAX := 0.5
const LIFT_DOWN_MAX := 0.15
const GROUND_CORE_Y := 0.62
## The head as a sphere, its centre this far past the Head bone along the neck.
const LIMB_DIP_M := 0.05
const THIGHS := ["thighL", "thighR", "shoulders", "head", "face"]
const THIGH_GIVE_M := 0.0
const REL_LEAK_S := 3.0
const THIGH_REL_MAX := 0.35   # past this the bodies are apart enough: a thigh still in is the data's, and chasing it ran `rel` to its cap
const HEAD_UP := 0.08
const HEAD_R := 0.11
const NORMAL_BAND_M := 0.02
## S399 GRAPPLEFIX1 (blind critic, 886 at 1.43 s: "blue's leg runs through red's chin"): the head sphere sits over the skull, so a
## face and jaw were free to sink into a thigh. A FACE sphere rides the head bone, FACE_FWD in front of it and FACE_UP above, in
## the body's own forward at rest.
const FACE_FWD := 0.075
const FACE_UP := 0.01
const FACE_R := 0.07
static var _face_local := {}   # pairs this much farther than the closest still steer the gap's direction


static func read_bones(skel: Skeleton3D) -> Dictionary:
	var gt := skel.global_transform
	var d := {}
	for n in BONES:
		var i := skel.find_bone(n)
		if i >= 0:
			d[n] = gt * skel.get_bone_global_pose(i).origin
	var hi := skel.find_bone("Head")
	if hi >= 0:
		d["Face"] = gt * (skel.get_bone_global_pose(hi) * face_local(skel))
	return d


## The face's centre in the head bone's own space (cached per skeleton): FACE_FWD along the body's rest forward (toes minus
## ankles, as GrapplePose finds it), FACE_UP up.
static func face_local(skel: Skeleton3D) -> Vector3:
	var key := skel.get_instance_id()
	if _face_local.has(key):
		return _face_local[key]
	var f := Vector3.ZERO
	for s in ["Left", "Right"]:
		f += skel.get_bone_global_rest(skel.find_bone(s + "Toes")).origin - skel.get_bone_global_rest(skel.find_bone(s + "Foot")).origin
	f.y = 0.0
	var head := skel.get_bone_global_rest(skel.find_bone("Head"))
	var v := head.basis.inverse() * (f.normalized() * FACE_FWD + Vector3.UP * FACE_UP)
	_face_local[key] = v
	return v


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
	var hi := skel.find_bone("Head")
	if hi >= 0:
		d["Face"] = gt * ((g[hi] as Transform3D) * face_local(skel)) + world_ofs
	return d


static func parts(d: Dictionary) -> Dictionary:
	var lat: Vector3 = ((d["RightUpperLeg"] as Vector3) - (d["LeftUpperLeg"] as Vector3)).normalized()
	var torso: Array = [["pelvis", d["LeftUpperLeg"], d["RightUpperLeg"], 0.118]]
	for s in [1.0, -1.0]:
		torso.append(["trunk", (d["Spine"] as Vector3) + lat * 0.035 * s, (d["Neck"] as Vector3) + lat * 0.035 * s, 0.12])
	var all: Array = torso.duplicate()
	var head: Vector3 = d["Head"]
	var hc := head + (head - (d["Neck"] as Vector3)).normalized() * HEAD_UP
	all.append(["head", hc, hc, HEAD_R])
	if d.has("Face"):
		all.append(["face", d["Face"], d["Face"], FACE_R])
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
static func track(men: Array, j0: PackedVector3Array, j1: PackedVector3Array, st: Dictionary, delta: float) -> Array:
	if men.size() < 2 or j0.size() != DB.JOINTS.size() or j1.size() != DB.JOINTS.size():
		return []
	var rel: Vector3 = st["rel"]
	var lift := float(st["lift"])
	var up := Vector3(0.0, lift, 0.0)
	var d0 := bone_world(men[0], (men[0] as Node).get_parent(), j0, up - rel * 0.5)
	var d1 := bone_world(men[1], (men[1] as Node).get_parent(), j1, up + rel * 0.5)
	var p0 := parts(d0)
	var p1 := parts(d1)
	var step := TRACK_RATE * delta
	var ground: bool = minf(j0[DB.joint("Core")].y, j1[DB.joint("Core")].y) < GROUND_CORE_Y
	var near := _nearest(p0, p1, rel.length() < THIGH_REL_MAX)
	st["pen"] = near["pen"]
	if float(near["pen"]) > pen_ok:
		rel += (near["pen_n"] as Vector3) * minf((float(near["pen"]) - pen_ok) * TRACK_GAIN * 2.0, step * 2.0)
	elif ground and float(near["gap"]) > GAP_OK:
		rel -= (near["gap_n"] as Vector3) * minf((float(near["gap"]) - GAP_OK) * TRACK_GAIN, step)
	elif not ground:
		rel = rel.move_toward(Vector3.ZERO, step * 0.5)
	# A shift outlives the position that needed it (a stale 0.5 m sat under a turtle on seed 11): it leaks back toward the recording.
	st["rel"] = (rel * exp(-delta / REL_LEAK_S)).limit_length(REL_MAX)
	# On the recording's limbs: a limb GrappleLimbs swung clears the mat by itself, and read here it bounced the whole pair (S391, seed 11).
	var low := minf(_lowest_recorded(men[0], p0, d0, up - rel * 0.5), _lowest_recorded(men[1], p1, d1, up + rel * 0.5))
	# S399 GRAPPLEFIX1: `ahead` (<= 0, GrapplePlayer from its baked curve) is how much lower the recording goes over the next
	# moments: the pair starts up before a dip instead of jumping 5 cm in 4 frames when it comes, and does not settle into one.
	low += minf(0.0, float(st.get("ahead", 0.0)))
	if low < 0.0:
		lift += minf(-low * TRACK_GAIN * 2.0, step)
	elif low > FLOOR_OK:
		# S399 GRAPPLEFIX1: only what is past the band (all of `low` dropped the pair 4 mm at a time, a step every few frames).
		lift -= minf((low - FLOOR_OK) * TRACK_GAIN, step)
	st["lift"] = clampf(lift, -LIFT_DOWN_MAX, LIFT_MAX)
	return [d0, d1]


## A pose's limbs as the recording alone draws them, in world space under `world_ofs`. Read after bone_world.
static func recorded(pose: Node, skel: Skeleton3D, world_ofs: Vector3) -> Dictionary:
	var gt := skel.global_transform
	var out := {}
	var rec: Dictionary = pose.get("limb_rec")
	for k in rec:
		out[k] = [gt * (rec[k][0] as Vector3) + world_ofs, gt * (rec[k][1] as Vector3) + world_ofs, gt.basis * (rec[k][2] as Vector3)]
	return out


static func _lowest_recorded(pose: Node, p: Dictionary, d: Dictionary, ofs: Vector3) -> float:
	var rec := recorded(pose, (pose as Node).get_parent(), ofs)
	if rec.is_empty():
		return _lowest(p["all"])
	var low := INF
	for c in p["all"]:
		if str(c[0]) in ["pelvis", "trunk", "head", "neck", "shoulders"]:
			low = minf(low, minf((c[1] as Vector3).y, (c[2] as Vector3).y) - float(c[3]))
	var limbs := INF
	for side in ["Left", "Right"]:
		var arm: Array = rec.get(side + "Arm", [])
		var leg: Array = rec.get(side + "Leg", [])
		if arm.is_empty() or leg.is_empty():
			return _lowest(p["all"])
		limbs = minf(limbs, minf((arm[0] as Vector3).y - 0.06, (arm[1] as Vector3).y - 0.045))
		var toes: Vector3 = (leg[1] as Vector3) + (d[side + "Toes"] as Vector3) - (d[side + "Foot"] as Vector3)
		limbs = minf(limbs, minf((leg[0] as Vector3).y - 0.10, minf((leg[1] as Vector3).y - 0.065, toes.y - 0.068)))
	# A limb the data sinks is GrappleLimbs' to lift: only past LIMB_DIP does the pair rise for it (the film: both women floating, one shin down).
	return minf(low, limbs + LIMB_DIP_M)


static func _lowest(caps: Array) -> float:
	var low := INF
	for c in caps:
		low = minf(low, minf((c[1] as Vector3).y, (c[2] as Vector3).y) - float(c[3]))
	return low


## The deepest torso overlap and the closest surfaces, each with its direction from body 0 to body 1.
## S399 GRAPPLEFIX1: each direction is the depth-weighted mean over every pair that counts, not the deepest pair's alone - the
## two trunk capsules traded "deepest" frame by frame and the push turned its sign with them (rel.z -6, +6, -8, +18 mm).
static func _nearest(p0: Dictionary, p1: Dictionary, thighs: bool = false) -> Dictionary:
	var out := {"pen": 0.0, "pen_n": Vector3.UP, "gap": INF, "gap_n": Vector3.RIGHT}
	var pen_sum := Vector3.ZERO
	var gaps: Array = []
	for x in p0["all"]:
		for y in p1["all"]:
			var pts := Geometry3D.get_closest_points_between_segments(x[1], x[2], y[1], y[2])
			var along: Vector3 = (pts[1] as Vector3) - (pts[0] as Vector3)
			var d: float = along.length() - float(x[3]) - float(y[3])
			var n := along.normalized() if along.length() > 0.001 else Vector3.UP
			if d < float(out["gap"]):
				out["gap"] = d
			gaps.append([d, n])
			var torso: bool = str(x[0]) in ["pelvis", "trunk"] and str(y[0]) in ["pelvis", "trunk"]
			# A thigh pressed in at its root, a shoulder or a head cannot swing clear (GrappleLimbs has done what it can): what is left moves the bodies.
			var root_in: bool = thighs and (str(x[0]) in THIGHS and str(y[0]) in ["pelvis", "trunk"]) or thighs and (str(y[0]) in THIGHS and str(x[0]) in ["pelvis", "trunk"])
			var depth := -d if torso else (-d - THIGH_GIVE_M if root_in else 0.0)
			if depth > 0.0:
				pen_sum += n * depth
				out["pen"] = maxf(float(out["pen"]), depth)
	if pen_sum.length() > 1e-5:
		out["pen_n"] = pen_sum.normalized()
	var gap_sum := Vector3.ZERO
	for g in gaps:
		var wg := NORMAL_BAND_M - (float(g[0]) - float(out["gap"]))
		if wg > 0.0:
			gap_sum += (g[1] as Vector3) * wg
	if gap_sum.length() > 1e-5:
		out["gap_n"] = gap_sum.normalized()
	return out
