extends SkeletonModifier3D
## HUMANFIGHT1 - a foot that stands on the canvas stays where it stands. Whoever has the legs (the footwork rig, a captured
## take played pure, a step clip, FootPlant, a hand-over between them), the DRAWN foot was free to slide: on main the
## stiller standing foot travels ~10 m a minute (tools/human_fight_report.py "support-foot slip"): her place is carried
## under a captured punch at 3 m/s with no leg layer, a return to guard after a side step moves her place 0.2-0.4 m in
## one frame and both planted feet with it, the body turns to face and the feet swing round with it. Each of those is a
## different upstream writer; this is the one place every one of them passes through - the last leg layer but the floor
## (FloorStand), and RkPure keeps it on. It reads each foot as the layers before it left it ("upstream") and adds nothing
## while upstream behaves:
##   - upstream lifts the foot (a step of its own: the rig's pair, a mocap step) -> the foot is free and follows it;
##   - upstream stands the foot (ball within DOWN_M of the canvas) -> it LOCKS where it was last shown (world x, z). Small
##     drift under it (retarget slide, a turning body) never shows: the ball holds, the leg's IK takes it up;
##   - the FIGHT moves her (her node travels outside a step clip: her place carried, a teleport eased by ShownRoot) and a
##     standing foot is left more than STEP_M off its lock -> the foot takes a real step onto where upstream now stands
##     it (SWING_S, a LIFT_M arc), one foot at a time unless it is FAR_M behind or the leg cannot reach its lock;
##   - nothing moves her and the take itself slides a standing foot past STEP_M -> the lock trails it (no step against
##     a captured take's own feet);
##   - upstream lifts a locked foot -> the lock lets go and what is left between them eases out over RELEASE_S.
## While the footwork rig has the legs outright (w 1) its plan already holds each planted ball to the millimetre and its
## flat-footed steps lift under UP_M: the lock only rides along there, so it already holds the frame the rig lets go.
## Off (eased) in scenes, free clips and when she is down, as FloorStand; and inside a captured step clip (rk_loc_*),
## whose feet are the take's own (tests/rokoko_clips_test.gd holds each to its raw take's slide and leg snaps). `-- nofootlock` = the control arm.
##   FootLock.attach(skel, ap, stage) -> FootLock      held: how far each foot is shown off upstream this frame (probes)

const LEGS := [["LeftUpperLeg", "LeftLowerLeg", "LeftFoot", "LeftToes"], ["RightUpperLeg", "RightLowerLeg", "RightFoot", "RightToes"]]
const FREE := ["knockout", "win", "countdown", "fall", "sit", "stool"]
const DOWN_M := 0.014          # upstream ball this close to its standing height: the foot stands
const UP_M := 0.028            # ... this far over it: the foot is in the air
const STEP_M := 0.07           # a standing foot carried this far off its lock steps after it
const FAR_M := 0.4             # ... this far: it steps even while the other foot is stepping
const REACH := 0.97            # of the leg's length (knee ~152 deg): past it the lock cannot be held, the foot steps now
const SWING_S := 0.22
const LIFT_M := 0.05
const RELEASE_S := 0.12        # what is left between lock and upstream eases out over about this (a half-life x 3)
const EASE_S := 0.15
const GRIP_S := 0.07           # a landing foot comes to rest over this (2-3 frames), not in one
const LAND_V := 0.6            # m/s: a low foot faster than this is still swinging, not landing
const SPRING := 18.0           # 1/s: the correction's spring (settles in ~0.15 s)
const CARRY_V := 0.25          # m/s: her node moving this fast outside a step clip = the fight is carrying her
const CARRY_HOLD_S := 0.45     # ... and this long after (the feet finish stepping under her)
const DOWN_HIPS := 0.5         # of the hips' rest height: under it she is down (as FloorStand)
const LOW_HIPS := 0.62
const CUT_M := 1.2             # upstream foot moved this far in a frame: a cut (setup, a scene's end), not a slide

var _ap: AnimationPlayer
var _stage: Node
var _rig: Node                  # the footwork rig: while it has the legs outright its own plan plants and steps the feet
var _hips := -1
var _hips_rest := 1.0
var _legs: Array = []           # per leg {ids, ball: rest y}
var _lock: Array = [null, null] # per foot: world Vector3 (x, z used) or null = free
var _swing: Array = [{}, {}]    # per foot: {} or {from: Vector3, t: s}
var _off: Array = [Vector3.ZERO, Vector3.ZERO]   # per foot: free-foot offset easing out (world, flat)
var _up: Array = [false, false] # upstream foot in the air (hysteresis)
var _was: Array = [null, null]  # last frame's upstream ball (world)
var _last: Array = [null, null] # per foot: the ball as shown last frame (world)
var _grip: Array = [1.0, 1.0]   # per foot: 0..1 how firmly a fresh lock holds
var _was_up: Array = [false, false]
var _move: Array = [Vector3.ZERO, Vector3.ZERO]     # per foot: the correction as shown (world)
var _move_v: Array = [Vector3.ZERO, Vector3.ZERO]   # ... and its velocity
var _carried := 0.0             # seconds left of "the fight is moving her"
var _node_was: Variant = null   # her node's place last frame (world)
var _stepped: Array = [false, false]                # per foot: mid-step last frame (the landing frame is the step's too)
var _w := 0.0
var _frame := -1
var held: Array = [0.0, 0.0]    # m each foot is shown off where upstream put it, this frame (probes)
var shown: Array = []           # each ball as shown this frame, world [left, right] (RingFeet: the rig takes her feet there)


static func attach(skel: Skeleton3D, ap: AnimationPlayer, stage: Node, rig: Node = null) -> Node:
	if OS.get_cmdline_user_args().has("nofootlock"):
		return null
	var f := new()
	f.name = "FootLock"
	f._ap = ap
	f._stage = stage
	f._rig = rig
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
		f._legs.append({"ids": ids, "ball": skel.get_bone_global_rest(ids[3]).origin.y})
	skel.add_child(f)
	return f


func _process_modification() -> void:
	var skel := get_skeleton()
	if skel == null or _legs.is_empty():
		return
	var f := Engine.get_process_frames()
	# a second pass in one frame (a seek with update) shows the same locks and must not advance the steps twice
	var dt := 0.0 if f == _frame else maxf(get_process_delta_time(), 1e-4)
	var woke := _frame >= 0 and f - _frame > 1
	_frame = f
	var free := _stage != null and bool(_stage.get("scene"))
	var clip := str(_ap.current_animation) if _ap != null else ""
	for word in FREE:
		free = free or clip.contains(word)
	var hips_h := skel.get_bone_global_pose(_hips).origin.y / _hips_rest
	free = free or hips_h < DOWN_HIPS
	_w = move_toward(_w, 0.0 if free else 1.0, dt / EASE_S)
	if _w <= 0.0 or woke:
		_let_go()
		if _w <= 0.0:
			return
	var w := _w * clampf((hips_h - DOWN_HIPS) / (LOW_HIPS - DOWN_HIPS), 0.0, 1.0)
	var xf := skel.global_transform
	var s := maxf(xf.basis.get_scale().y, 1e-3)
	var decay := exp(-dt * 3.0 * 0.693 / RELEASE_S)
	# Is the FIGHT moving her (her node travels and no step clip is carrying it)? Only then does a foot step after her.
	if _node_was != null and dt > 0.0:
		var v := _flat(xf.origin - (_node_was as Vector3)) / dt
		if v > CARRY_V and v < CUT_M / dt and not clip.begins_with("rk_loc_"):
			_carried = CARRY_HOLD_S
		else:
			_carried = maxf(0.0, _carried - dt)
	_node_was = xf.origin
	held = [0.0, 0.0]
	# How far each upstream ball is over the canvas - less what both are over it (FloorStand, next, stands the lower one).
	var balls: Array = []
	var clears: Array = []
	for leg in _legs:
		var b0: Vector3 = xf * skel.get_bone_global_pose(leg["ids"][3]).origin
		balls.append(b0)
		clears.append(b0.y - xf.origin.y - float(leg["ball"]) * s)
	var floating: float = maxf(0.0, minf(clears[0], clears[1]))
	shown = [balls[0], balls[1]]
	for i in 2:
		var leg: Dictionary = _legs[i]
		var ids: Array = leg["ids"]
		var ball: Vector3 = balls[i]
		var clear: float = float(clears[i]) - floating
		var was: Variant = _was[i]
		if was != null and _flat(ball - (was as Vector3)) > CUT_M:
			_lock[i] = null
			_swing[i] = {}
			_off[i] = Vector3.ZERO
			_last[i] = null
			was = null
		_was[i] = ball
		var rig_has: bool = _rig != null and float(_rig.w) >= 0.99
		var speed := _flat(ball - (was as Vector3)) / dt if was != null and dt > 0.0 else 0.0
		if rig_has:
			# the rig's plan stands or steps this foot itself: the lock rides along (no correction), so the frame the rig
			# lets go it already holds where the foot stood
			_up[i] = not ((_rig.plan.feet[_plan_foot(i)]["swing"] as Dictionary).is_empty())
			_lock[i] = null if bool(_up[i]) else ball
			_swing[i] = {}
			_off[i] = Vector3.ZERO
			_grip[i] = 1.0
			_was_up[i] = bool(_up[i])
			if dt > 0.0:   # what was left of a correction eases out through the same spring
				var r1: Vector3 = (_move_v[i] as Vector3) + (_move[i] as Vector3) * SPRING
				var re := exp(-SPRING * dt)
				_move[i] = ((_move[i] as Vector3) + r1 * dt) * re
				_move_v[i] = ((_move_v[i] as Vector3) - r1 * SPRING * dt) * re
			var rest: Vector3 = _move[i]
			_last[i] = ball + rest
			shown[i] = ball + rest
			_lock[i] = null if bool(_up[i]) else ball + rest
			if rest.length() > 0.0005:
				_reach(skel, ids, skel.get_bone_global_pose(ids[2]).origin + xf.affine_inverse().basis * rest)
			continue
		if clip.begins_with("rk_loc_"):
			_up[i] = true   # a captured step clip walks on its own feet, as recorded: no lock inside it (it lets go softly)
		elif bool(_up[i]):
			# it comes down when it is low AND slow: a shuffle's swinging foot passes 1-2 cm over the canvas at 1-2 m/s
			# (caught there for two frames it kinked the knee: 46 knee jerks a round in the side step alone)
			_up[i] = clear > DOWN_M or speed > LAND_V
		else:
			_up[i] = clear > UP_M
		var target := ball
		if bool(_up[i]):
			if _lock[i] != null:   # upstream lifts a locked foot: let go, ease what is left
				var left := _at(i, ball) - ball
				_off[i] = Vector3(left.x, 0.0, left.z)
				_lock[i] = null
				_swing[i] = {}
			_off[i] = (_off[i] as Vector3) * decay
			target = ball + (_off[i] as Vector3)
		else:
			if _lock[i] == null:
				# it stands: lock where it was SHOWN last frame (upstream may already have slid or jumped this frame -
				# a hand-over between the rig's feet and a clip's moved a standing foot 0.35 m in 0.2 s)
				var at: Vector3 = _last[i] if _last[i] != null else ball + (_off[i] as Vector3)
				_lock[i] = Vector3(at.x, ball.y, at.z)
				_off[i] = Vector3.ZERO
				_grip[i] = 0.0 if _last[i] == null or bool(_was_up[i]) else 1.0   # a landing foot grips softly, a standing one at once
			var sw: Dictionary = _swing[i]
			if float(_grip[i]) < 1.0 and sw.is_empty() and was != null:
				# landing: the foot keeps a falling share of upstream's motion for GRIP_S, then stands (stopped dead in one
				# frame it kinked the knee: 270 knee jerks a round against 140)
				_grip[i] = minf(1.0, float(_grip[i]) + dt / GRIP_S)
				var d: Vector3 = ball - (was as Vector3)
				_lock[i] = (_lock[i] as Vector3) + Vector3(d.x, 0.0, d.z) * (1.0 - float(_grip[i]))
			var away := _flat(ball - (_lock[i] as Vector3))
			if sw.is_empty() and _carried <= 0.0 and away > STEP_M:
				# nothing is moving her place: this is the take's own foot (a captured step slides 0.5-0.7 m in its raw
				# data). The lock gives way at STEP_M - it trails the take instead of stepping against it (stepping here
				# snapped the legs: 14-16 leg snaps in a captured step against the raw take's 2-5).
				var l0: Vector3 = _lock[i]
				var back := Vector3(l0.x - ball.x, 0.0, l0.z - ball.z).normalized() * STEP_M
				_lock[i] = Vector3(ball.x + back.x, l0.y, ball.z + back.z)
				away = STEP_M
			if sw.is_empty() and _carried > 0.0:
				var other_busy: bool = not (_swing[1 - i] as Dictionary).is_empty()
				if (away > STEP_M and (not other_busy or away > FAR_M)) or (away > 0.02 and _stretched(skel, xf, ids, _lock[i], ball)):
					sw = {"from": _lock[i], "t": 0.0}
					_swing[i] = sw
			if not sw.is_empty():
				sw["t"] = float(sw["t"]) + dt
				var u := clampf(float(sw["t"]) / SWING_S, 0.0, 1.0)
				var k := u * u * (3.0 - 2.0 * u)
				var from: Vector3 = sw["from"]
				target = Vector3(lerpf(from.x, ball.x, k), ball.y + LIFT_M * sin(PI * u), lerpf(from.z, ball.z, k))
				if u >= 1.0:
					_swing[i] = {}
					_lock[i] = ball
					_grip[i] = 1.0
			else:
				var l: Vector3 = _lock[i]
				target = Vector3(l.x, ball.y, l.z)
		_was_up[i] = bool(_up[i])
		# The correction is shown through a critically damped spring: whatever the lock decides (hold, let go, step), the
		# leg's IK target has no kink - a hard lock removed the takes' own foot slide but snapped the legs
		# (tests/rokoko_clips_test.gd: 12-13 leg snaps in a captured step against the raw take's 2-8).
		var goal := (target - ball) * w
		if not (_swing[i] as Dictionary).is_empty() or bool(_stepped[i]):
			# a step of its own is already smooth (it starts and lands at rest) and must keep its lift: through the spring
			# its arc went flat and the foot was dragged low to its new spot
			_move_v[i] = (goal - (_move[i] as Vector3)) / dt if dt > 0.0 else Vector3.ZERO
			_move[i] = goal
			_stepped[i] = not (_swing[i] as Dictionary).is_empty()
		elif dt > 0.0:
			var k := SPRING
			var j0: Vector3 = (_move[i] as Vector3) - goal
			var j1: Vector3 = (_move_v[i] as Vector3) + j0 * k
			var e := exp(-k * dt)
			_move[i] = (j0 + j1 * dt) * e + goal
			_move_v[i] = ((_move_v[i] as Vector3) - j1 * k * dt) * e
		var move: Vector3 = _move[i]
		_last[i] = ball + move
		shown[i] = ball + move
		if move.length() < 0.0005:
			continue
		held[i] = _flat(move)
		var ankle := skel.get_bone_global_pose(ids[2]).origin
		_reach(skel, ids, ankle + xf.affine_inverse().basis * move)


## Where foot i is shown now (world): its lock, or mid-step.
func _at(i: int, ball: Vector3) -> Vector3:
	var sw: Dictionary = _swing[i]
	if sw.is_empty():
		var l: Vector3 = _lock[i]
		return Vector3(l.x, ball.y, l.z)
	var u := clampf(float(sw["t"]) / SWING_S, 0.0, 1.0)
	var k := u * u * (3.0 - 2.0 * u)
	var from: Vector3 = sw["from"]
	return Vector3(lerpf(from.x, ball.x, k), ball.y, lerpf(from.z, ball.z, k))


## True when the leg cannot hold the ball on `lock` any longer (the hip has gone too far from it).
func _stretched(skel: Skeleton3D, xf: Transform3D, ids: Array, lock: Vector3, ball: Vector3) -> bool:
	var hip: Vector3 = xf * skel.get_bone_global_pose(ids[0]).origin
	var knee: Vector3 = xf * skel.get_bone_global_pose(ids[1]).origin
	var ankle: Vector3 = xf * skel.get_bone_global_pose(ids[2]).origin
	var leg := hip.distance_to(knee) + knee.distance_to(ankle)
	var want := ankle + Vector3(lock.x - ball.x, 0.0, lock.z - ball.z)
	return hip.distance_to(want) > leg * REACH


## The rig plan's foot for leg i (0 left, 1 right): plan foot 0 is her lead - the left leg on an orthodox.
func _plan_foot(i: int) -> int:
	return i if float(_rig.plan.side) > 0.0 else 1 - i


func _let_go() -> void:
	_lock = [null, null]
	_swing = [{}, {}]
	_off = [Vector3.ZERO, Vector3.ZERO]
	_was = [null, null]
	_up = [false, false]
	_last = [null, null]
	_grip = [1.0, 1.0]
	_was_up = [false, false]
	_move = [Vector3.ZERO, Vector3.ZERO]
	_move_v = [Vector3.ZERO, Vector3.ZERO]


static func _flat(v: Vector3) -> float:
	return Vector2(v.x, v.z).length()


## Two-bone solve in skeleton space (as FloorStand): the ankle meets `target`, the knee in its own plane, the foot keeps
## its global turn.
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
	var d := clampf(to.length(), absf(l1 - l2) + 1e-3, (l1 + l2) * 0.999)
	var dir := to.normalized()
	var n := (k - h).cross(a - h)
	if n.length() < 1e-6:
		n = hg.basis.x
	n = n.normalized()
	var perp := n.cross(dir).normalized()
	if (k - h).dot(perp) < 0.0:
		perp = -perp
	var ca := clampf((l1 * l1 + d * d - l2 * l2) / (2.0 * l1 * d), -1.0, 1.0)
	var k2 := h + (dir * ca + perp * sqrt(1.0 - ca * ca)) * l1
	var t2 := h + dir * d
	var foot := ag.basis.get_rotation_quaternion()
	var turn := Quaternion((k - h).normalized(), (k2 - h).normalized())
	var q1 := turn * hg.basis.get_rotation_quaternion()
	var shin := (turn * (a - k)).normalized()
	var q2 := Quaternion(shin, (t2 - k2).normalized()) * turn * kg.basis.get_rotation_quaternion()
	var parent := skel.get_bone_parent(ids[0])
	var qp := skel.get_bone_global_pose(parent).basis.get_rotation_quaternion() if parent >= 0 else Quaternion.IDENTITY
	skel.set_bone_pose_rotation(ids[0], (qp.inverse() * q1).normalized())
	skel.set_bone_pose_rotation(ids[1], (q1.inverse() * q2).normalized())
	skel.set_bone_pose_rotation(ids[2], (q2.inverse() * foot).normalized())
