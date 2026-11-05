extends SkeletonModifier3D
## S306 planted feet (found measuring the S306 side step: every short step the fight takes - circle, step in / out, the
## gap correction - slid her planted feet ~2 m in 0.6 s at up to 4 m/s, tools/sidestep_probe.gd; the guard alone 0.04 m).
## The footwork clips are the old game's walk cycles in another stance, played for a fraction of a cycle while her place
## glides at the stride speed, so the feet skate. Shipped games plant feet procedurally: each foot holds its spot on the
## canvas; when the animation has carried its foot more than STEP_M away (her body moved on), the foot takes a quick step
## (SWING_S, a LIFT_M arc, landing a little ahead of the way the body moves) onto where the animation puts it, one foot
## at a time; analytic two-bone leg IK (Holden, "Simple Two Joint IK") holds the knees. The foot keeps the animation's
## own height (never under her standing height) and turn. Falls, knockouts and the win play free (WEIGHT eases out). Runs after the join smoother.
## S314 real-fight gap 7 (Game Godot/research/S310_REAL_FIGHT_GAPS.md): her stance was a little square - feet front to
## back 0.26 NA vs 0.30-0.34 real - so the animated feet's spread along her facing is stretched by STAGGER about their middle.
## S383d (operator on the owned-mocap films: "the video clip is lagging ... the knees are trembling again";
## tools/owned_mocap_jitter.gd, knee shake = RMS 2nd difference of the knee bend): on the PRO combo FootPlant made the knee
## shake 1.9x the clip's when playing and 3.4x in the films. Three causes, three fixes:
##   - the hard reach clamp pinned the knee flat at ~16 deg and let go a few frames later (a kink each time): the limit now
##     eases in (SOFT_REACH -> CAP_REACH, tanh);
##   - each step's start and landing jerked the leg: the IK target is low-passed in the WORLD (OUT_TAU_S 0.03 s; 0.06 was
##     smoother still but its landing tail slid the feet in the fight) - a held foot's target is still, so a glide gets no
##     lag - and a step takes SWING_S 0.26 s (was 0.2);
##   - a seek with update (the films' freeze) ran the modifier twice a frame, so steps ran at double speed: a repeat pass
##     in the same frame redoes the frame from its start state.
## Frame-rate independent: the logic sub-steps (SUB_S) between the last frame's and this frame's animated feet, hips and
## skeleton transform, and a teleport is a speed (SNAP_V) as well as a distance. Result (S383d): PRO combo knee shake 2.5
## vs 2.8 `nofeet`, idle 0.47 vs 0.46; tools/sidestep_probe.gd planted slide within ~0.05 m of the old FootPlant's. (Tried and dropped: letting the clip's own foot motion through - fast detail or whole steps the clip lifts
## or drags - fight clips play with their hips held in place, so that motion IS skating there: dodges slid 0.5-1.7 m.)
##   attach(skel, ap, after, body) -> FootPlant | null       step(skel, dt, free) - one frame (tests call it directly)

const LEGS := [["LeftUpperLeg", "LeftLowerLeg", "LeftFoot"], ["RightUpperLeg", "RightLowerLeg", "RightFoot"]]
const STEP_M := 0.10        # how far the animation may carry a planted foot before it steps
const SWING_S := 0.26       # a boxer's shuffle step (S376: 0.15 read as a twitch; S383d 0.2 -> 0.26 with the eased target)
const LIFT_M := 0.05
const LEAD_S := 0.10        # a step lands this far ahead of the body's motion (seconds of its speed)
const LEAD_MAX_M := 0.12
const SNAP_M := 0.3         # an animated foot that jumps this far in one frame was set, not stepped (stills): plant it there
const SNAP_V := 6.0         # ... and faster than this (m/s; a stepping foot peaks ~3-4): at 30 fps the 0.3 m rules
const URGENT := 2.5         # a foot left this many STEP_M behind steps even while the other is stepping
## S376 (operator, on the men's bout: "their leg animation are broken completely"; tools/men_fight_film.gd measured knees
## locked dead straight (> 170 deg) 15-18 % of a round with planted feet, 0-2 % with `nofeet`): a plant only ever checked
## how far the animation carried the foot, never whether the leg still reached it - the hips moved on, the IK pulled the
## leg straight and the foot snapped across. Now a foot whose plant sits past STEP_REACH of the leg's length from the hip
## steps at once, and no target is ever set past CAP_REACH (knee ~165 deg) unless the clip itself straightens the leg.
const STEP_REACH := 0.98    # ~157 deg at the knee
const CAP_REACH := 0.99     # ~165 deg at the knee
const SOFT_REACH := 0.97    # S383d: the reach limit eases in from here (~152 deg at the knee)
const FREE := ["knockout", "win", "countdown", "fall"]
const EASE_S := 0.2
## Front-back feet spread x this. tools/range_probe.gd round 1 (feet as shown): control 0.24 NA (p90 0.40); x1.23 read
## 0.30 (p90 0.49); real medians 0.30 / 0.32 / 0.34 NA (p90 ~0.6), so x1.32 aims at the middle, 0.32.
const STAGGER := 1.32
const SUB_S := 1.0 / 60.0   # S383d: logic sub-step
## S383d: the IK target is low-passed in the WORLD (a held foot's target is still, so a glide gets no lag; a step's
## start and landing ease in over ~4-6 frames instead of kinking the knee).
const OUT_TAU_S := 0.03

var _ap: AnimationPlayer
var _body: Node3D          # her facing is its +Z (Footwork.walk); null = no stagger stretch
var _bones: Array = []      # per leg [upper, lower, foot] indices
var _plant: Array = []      # per leg: world Vector3 where the foot stands (null: plant where it is)
var _swing: Array = []      # per leg: {} or {"from": Vector3, "t": s}
var _prev: Array = []       # per leg: last animated foot (world, sub-step), for its speed
var _ground: Array = []     # per leg: the ankle's standing height (world y): a foot never sinks below it (the old walk
                            # clips hold the ankle 5-6 cm under the guard's)
var _weight := 1.0
var _out: Array = []        # per leg: the target low-passed in the world (OUT_TAU_S; null: not yet)
var _last: Dictionary = {}  # last frame's skeleton transform and skeleton-space feet / hips (the sub-steps' start)
var _frame := -1
var _start: Dictionary = {} # state at the start of this frame (a repeat pass redoes the frame)
var last_target: Array = [Vector3.ZERO, Vector3.ZERO]   # world, per leg (probes read it)


static func attach(skel: Skeleton3D, ap: AnimationPlayer, after: Node, body: Node3D = null) -> Node:
	var fp := new()
	fp.name = "FootPlant"
	fp._body = body
	if not fp.setup(skel, ap):
		fp.free()
		return null
	skel.add_child(fp)   # last in the stack unless `after` is given
	if after != null:
		skel.move_child(fp, after.get_index() + 1)
	return fp


func setup(skel: Skeleton3D, ap: AnimationPlayer, body: Node3D = null) -> bool:
	_ap = ap
	if body != null:
		_body = body
	for leg in LEGS:
		var ids: Array = []
		for n in leg:
			ids.append(skel.find_bone(str(n)))
		if ids.has(-1):
			return false
		_bones.append(ids)
		_out.append(null)
		_plant.append(null)
		_swing.append({})
		_prev.append(null)
		_ground.append(null)
	return true


func _process_modification() -> void:
	var skel := get_skeleton()
	if skel == null or _bones.is_empty():
		return
	var f := Engine.get_process_frames()
	if f == _frame:
		_load(_start)
	else:
		_frame = f
		_start = _save()
	var free := false
	if _ap != null:
		var clip := str(_ap.current_animation)
		for w in FREE:
			free = free or clip.contains(w)
	step(skel, maxf(get_process_delta_time(), 1e-4), free)


## One frame of `dt` seconds on the skeleton's current (animated) pose: plants, steps, IK.
func step(skel: Skeleton3D, dt: float, free: bool = false) -> void:
	_weight = move_toward(_weight, 0.0 if free else 1.0, dt / EASE_S)
	var xf := skel.global_transform
	var feet: Array = []
	var hips: Array = []
	var legs: Array = []
	for ids in _bones:
		var gp := skel.get_bone_global_pose(ids[0]).origin
		var kp := skel.get_bone_global_pose(ids[1]).origin
		var fp := skel.get_bone_global_pose(ids[2]).origin
		feet.append(fp)
		hips.append(gp)
		legs.append((xf.basis * (kp - gp)).length() + (xf.basis * (fp - kp)).length())
	if _last.is_empty():
		_last = {"xf": xf, "feet": feet.duplicate(), "hips": hips.duplicate()}
	for i in _bones.size():
		var jump := _flat(xf * (feet[i] as Vector3) - (_last["xf"] as Transform3D) * (_last["feet"][i] as Vector3))
		if jump > maxf(SNAP_M, SNAP_V * dt):
			# Set, not stepped (a still, a teleport): plant it where it is, no sub-steps across the jump.
			_last = {"xf": xf, "feet": feet.duplicate(), "hips": hips.duplicate()}
			_prev[i] = null
			_plant[i] = null
			_swing[i] = {}
			_out[i] = null
	var n := clampi(ceili(dt / SUB_S - 1e-6), 1, 60)
	var h := dt / n
	var ao := 1.0 - exp(-h / OUT_TAU_S)
	var spread := Vector3.ZERO
	var sm: Array = [Vector3.ZERO, Vector3.ZERO]
	var targets: Array = [Vector3.ZERO, Vector3.ZERO]
	for k in range(1, n + 1):
		var s := float(k) / n
		var xk: Transform3D = (_last["xf"] as Transform3D).interpolate_with(xf, s) if k < n else xf
		for i in _bones.size():
			sm[i] = xk * (_last["feet"][i] as Vector3).lerp(feet[i], s)
		spread = _spread(sm)
		for i in _bones.size():
			var anim: Vector3 = (sm[i] as Vector3) + (spread if i == 0 else -spread)
			var vel: Vector3 = (anim - (_prev[i] as Vector3)) / h if _prev[i] != null else Vector3.ZERO
			_prev[i] = anim
			if _ground[i] == null:
				_ground[i] = anim.y   # the first frame is her guard: the ankle's standing height
			if _plant[i] == null:
				_plant[i] = anim
			var hip: Vector3 = xk * (_last["hips"][i] as Vector3).lerp(hips[i], s)
			var t := _target(i, anim, vel, h, hip, float(legs[i]))
			_out[i] = t if _out[i] == null else (_out[i] as Vector3).lerp(t, ao)
			targets[i] = _out[i]
	_last = {"xf": xf, "feet": feet.duplicate(), "hips": hips.duplicate()}
	for i in _bones.size():
		var raw: Vector3 = xf * (feet[i] as Vector3)
		var hip: Vector3 = xf * (hips[i] as Vector3)
		var target := _reach(targets[i], hip, (raw - hip).length(), float(legs[i]))
		if _weight < 1.0:
			target = (raw + (spread if i == 0 else -spread)).lerp(target, _weight)
		last_target[i] = target
		if (target - raw).length() > 0.0005:
			_solve(skel, _bones[i], xf.affine_inverse() * target)


## The target pulled in so the leg never reaches past CAP_REACH (or the clip's own reach `own` when it is straighter):
## S383d a SOFT limit from SOFT_REACH on (tanh, slope 1 where it starts) - the hard clamp pinned the knee flat at ~16 deg
## and let it go a few frames later, a kink in the bend each time (the PRO combo / idle films).
static func _reach(target: Vector3, hip: Vector3, own: float, leg: float) -> Vector3:
	var d := (target - hip).length()
	var c1 := maxf(CAP_REACH * leg, own)
	var c0 := minf(maxf(SOFT_REACH * leg, own), c1)
	if d <= c0 or d < 1e-5:
		return target
	var dd := c1 if c1 - c0 < 1e-4 else c0 + (c1 - c0) * tanh((d - c0) / (c1 - c0))
	return hip + (target - hip) / d * dd


## How far the left foot moves (the right the opposite way) so the spread along her facing is STAGGER x the clip's;
## eased out with the free clips (falls, knockouts).
func _spread(raw: Array) -> Vector3:
	if _body == null:
		return Vector3.ZERO
	var fwd := _body.global_transform.basis.z
	fwd = Vector3(fwd.x, 0.0, fwd.z)
	if fwd.length() < 1e-5:
		return Vector3.ZERO
	fwd = fwd.normalized()
	var half := ((raw[0] as Vector3) - (raw[1] as Vector3)).dot(fwd) * 0.5
	return fwd * half * (STAGGER - 1.0) * _weight


## Where foot i stands this sub-step (world): its plant, or the arc of its step onto the animated spot.
func _target(i: int, anim: Vector3, vel: Vector3, delta: float, hip: Vector3, leg: float) -> Vector3:
	var s: Dictionary = _swing[i]
	if s.is_empty():
		var other: Dictionary = _swing[1 - i]
		var off := _flat(anim - (_plant[i] as Vector3))
		var p0: Vector3 = _plant[i]
		var stretched := Vector3(p0.x, maxf(anim.y, float(_ground[i])), p0.z).distance_to(hip) > STEP_REACH * leg
		if (off > STEP_M and (other.is_empty() or off > STEP_M * URGENT)) or (stretched and off > 0.02):
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


## The state a frame starts from (a repeat modifier pass in the same frame loads it back).
func _save() -> Dictionary:
	var sw: Array = []
	for d in _swing:
		sw.append((d as Dictionary).duplicate())
	return {"plant": _plant.duplicate(), "swing": sw, "prev": _prev.duplicate(), "ground": _ground.duplicate(),
		"weight": _weight, "last": _last.duplicate(true), "out": _out.duplicate()}


func _load(st: Dictionary) -> void:
	if st.is_empty():
		return
	_plant = (st["plant"] as Array).duplicate()
	_swing = []
	for d in st["swing"]:
		_swing.append((d as Dictionary).duplicate())
	_prev = (st["prev"] as Array).duplicate()
	_ground = (st["ground"] as Array).duplicate()
	_weight = float(st["weight"])
	_last = (st["last"] as Dictionary).duplicate(true)
	_out = (st["out"] as Array).duplicate()


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
