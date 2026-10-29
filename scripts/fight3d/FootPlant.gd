extends SkeletonModifier3D
## S306 planted feet (found measuring the S306 side step: every short step the fight takes - circle, step in / out, the
## gap correction - slid her planted feet ~2 m in 0.6 s at up to 4 m/s, tools/sidestep_probe.gd; the guard alone 0.04 m).
## The footwork clips are the old game's walk cycles in another stance, played for a fraction of a cycle while her place
## glides at the stride speed, so the feet skate. Shipped games plant feet procedurally: each foot holds its spot on the
## canvas; when the animation has carried its foot more than STEP_M away (her body moved on), the foot takes a quick step
## (SWING_S, a LIFT_M arc, landing a little ahead of the way the body moves) onto where the animation puts it, one foot
## at a time; analytic two-bone leg IK (Holden, "Simple Two Joint IK") holds the knees. The foot keeps the animation's
## own height (never under her standing height) and turn. Falls, knockouts and the win play free (WEIGHT eases out). Runs after the join smoother.
##   attach(skel, ap, after) -> FootPlant | null

const LEGS := [["LeftUpperLeg", "LeftLowerLeg", "LeftFoot"], ["RightUpperLeg", "RightLowerLeg", "RightFoot"]]
const STEP_M := 0.10        # how far the animation may carry a planted foot before it steps
const SWING_S := 0.15       # a boxer's shuffle step
const LIFT_M := 0.05
const LEAD_S := 0.10        # a step lands this far ahead of the body's motion (seconds of its speed)
const LEAD_MAX_M := 0.12
const SNAP_M := 0.3         # an animated foot that jumps this far in one frame was set, not stepped (stills): plant it there
const URGENT := 2.5         # a foot left this many STEP_M behind steps even while the other is stepping
const FREE := ["knockout", "win", "countdown", "fall"]
const EASE_S := 0.2

var _ap: AnimationPlayer
var _bones: Array = []      # per leg [upper, lower, foot] indices
var _plant: Array = []      # per leg: world Vector3 where the foot stands
var _swing: Array = []      # per leg: {} or {"from": Vector3, "t": s}
var _prev: Array = []       # per leg: last animated foot (world), for its speed
var _ground: Array = []     # per leg: the ankle's standing height (world y): a foot never sinks below it (the old walk
                            # clips hold the ankle 5-6 cm under the guard's)
var _weight := 1.0
var last_target: Array = [Vector3.ZERO, Vector3.ZERO]   # world, per leg (probes read it)


static func attach(skel: Skeleton3D, ap: AnimationPlayer, after: Node) -> Node:
	var fp := new()
	fp.name = "FootPlant"
	if not fp.setup(skel, ap):
		fp.free()
		return null
	skel.add_child(fp)   # last in the stack unless `after` is given
	if after != null:
		skel.move_child(fp, after.get_index() + 1)
	return fp


func setup(skel: Skeleton3D, ap: AnimationPlayer) -> bool:
	_ap = ap
	for leg in LEGS:
		var ids: Array = []
		for n in leg:
			ids.append(skel.find_bone(str(n)))
		if ids.has(-1):
			return false
		_bones.append(ids)
		_plant.append(null)
		_swing.append({})
		_prev.append(null)
		_ground.append(null)
	return true


func _process_modification() -> void:
	var skel := get_skeleton()
	if skel == null or _bones.is_empty():
		return
	var delta := maxf(get_process_delta_time(), 1e-4)
	var free := false
	var clip := str(_ap.current_animation)
	for w in FREE:
		free = free or clip.contains(w)
	_weight = move_toward(_weight, 0.0 if free else 1.0, delta / EASE_S)
	var xf := skel.global_transform
	for i in _bones.size():
		var ids: Array = _bones[i]
		var anim: Vector3 = xf * skel.get_bone_global_pose(ids[2]).origin
		var jump := _flat(anim - (_prev[i] as Vector3)) if _prev[i] != null else INF
		var vel: Vector3 = (anim - (_prev[i] as Vector3)) / delta if jump < INF else Vector3.ZERO
		_prev[i] = anim
		if _ground[i] == null:
			_ground[i] = anim.y   # the first frame is her guard: the ankle's standing height
		if jump > SNAP_M:
			_plant[i] = anim
			_swing[i] = {}
		var target: Vector3 = _target(i, anim, vel, delta)
		if _weight < 1.0:
			target = anim.lerp(target, _weight)
		last_target[i] = target
		if _flat(target - anim) > 0.002:
			_solve(skel, ids, xf.affine_inverse() * target)


## Where foot i stands this frame (world): its plant, or the arc of its step onto the animated spot.
func _target(i: int, anim: Vector3, vel: Vector3, delta: float) -> Vector3:
	var s: Dictionary = _swing[i]
	if s.is_empty():
		var other: Dictionary = _swing[1 - i]
		var off := _flat(anim - (_plant[i] as Vector3))
		if off > STEP_M and (other.is_empty() or off > STEP_M * URGENT):
			s = {"from": _plant[i], "t": 0.0}
			_swing[i] = s
		else:
			var p: Vector3 = _plant[i]
			return Vector3(p.x, maxf(anim.y, float(_ground[i])), p.z)
	s["t"] = float(s["t"]) + delta
	var u := clampf(float(s["t"]) / SWING_S, 0.0, 1.0)
	var lead := Vector3(vel.x, 0.0, vel.z) * LEAD_S
	if lead.length() > LEAD_MAX_M:
		lead = lead.normalized() * LEAD_MAX_M
	var land := anim + lead * (1.0 - u)
	var k := u * u * (3.0 - 2.0 * u)
	var at: Vector3 = (s["from"] as Vector3).lerp(land, k)
	if u >= 1.0:
		_swing[i] = {}
		_plant[i] = anim
	return Vector3(at.x, maxf(anim.y, float(_ground[i])) + LIFT_M * sin(PI * u), at.z)


## Two-bone IK in the skeleton's space: turn the upper and lower leg so the ankle meets `t`, the knee bending in the
## plane it bends in now; the foot keeps the global turn the animation gave it.
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
	if axis0.length() < 1e-6:
		return   # a dead-straight leg has no bend plane
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


static func _flat(v: Vector3) -> float:
	return Vector2(v.x, v.z).length()
