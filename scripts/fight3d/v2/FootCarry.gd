extends "res://scripts/fight3d/FootPlant.gd"
## FIGHTPLAYER2 (S513, the NEXT list's item 2; `-- fightplayer2 fp2carry`): a leg layer for the v2 player, NOT the
## default yet (the film decides). FootPlant holds a foot until the animation is 10 cm off it, then runs after it - so
## it also chases every step a take was captured with. Measured on the real bout headless (75 s, the film's rulers;
## tmp/fightweek/s513/slipwhy.py splits them): support-foot slip 7.5 / 7.3 m against FootPlant's 9.5 / 6.5; in the
## guard 0.5 against 2.3 m; knee jerks 36-46 against 16-26. Its own tally (`tally`, printed with `fp2log`) says what
## is left: the bought takes' own shuffles, and a step of ours while the take moves the other foot.
## A body moves for two reasons, and this layer treats them apart:
##   - the TAKE's own travel (RootPath) is captured footwork: its feet are shown as captured, untouched;
##   - the PLAN's travel (the pair closing, leaving, turning to face) is the player's own and has no footwork: a foot
##     stays where it stands on the canvas while the plan moves the body off it (its offset `_o` grows), and steps -
##     one foot at a time, the foot that leads the way first - onto where the plan will have the body when it lands
##     (Player2.ahead: the plan knows), so the last step of a ramp lands on the spot and nothing is left to drag.
## `hold` (a reaction, a block played on the spot: the take's hips are pinned, so its captured steps would skate): the
## feet keep the canvas where they stood when the take began; when it ends the difference is stepped out.
## The leg IK, the reach limit and the knee's plane are FootPlant's (this extends it); FloorStand still runs after.
##   add(skel, ap, after) -> FootCarry | null      moved: () -> Transform3D   ahead: (secs) -> Vector3   hold: bool

const C_STEP_M := 0.09        # a foot left this far off its place steps
const C_SETTLE_M := 0.04      # ... or this far, once the body has stood still for C_SETTLE_S
const C_SETTLE_S := 0.25
const C_URGENT_M := 0.32      # left this far, it steps even while the other foot is in the air
const C_SWING_S := 0.24       # a step takes this long, plus C_SWING_PER_M for each metre it covers
const C_SWING_PER_M := 0.25
const C_LOOK_S := 0.45        # a foot leaves for where the plan has the body this far ahead: one step pair covers a ramp
const C_LEAD_MAX_M := 0.36    # ... but never lands further than this from under the body (the leg's reach)
const C_LIFT_M := 0.05
const C_AIR_M := 0.035        # a foot the take itself has this high is in the air (the tally names it)
const C_BUSY_MPS := 0.25      # the other foot moving this fast in the take itself is stepping: wait for it to land
const C_HOLD_LIFT_M := 0.02   # a held foot follows the take's own lift only this far
const C_Y_MPS := 1.2          # a held or just-released foot's height eases at this speed

var moved: Callable           # the plan's motion of the body since last asked (a world transform); asking resets it
var ahead: Callable           # where the plan carries the body in the next `secs` (world, flat)
var hold := false
var steps := 0                # steps taken (probes)
var _o: Array = [Vector3.ZERO, Vector3.ZERO]   # per foot: shown = natural + _o (flat)
var _sw: Array = [{}, {}]     # per foot: {} or {from, to, t, dur}
var _held: Array = [null, null]                # per foot: where it stands while `hold` (world)
var _floor: Array = [null, null]               # per foot: the ankle's standing height
var _y: Array = [null, null]                   # per foot: the height shown last frame
var _ease_y := 0.0            # seconds of height easing left after a hold
var _still := 0.0
var _tg: Array = [null, null]
var tally := {}               # probes: metres the stiller low foot moved, by what moved it (see _count)
var _tg_was: Array = [null, null]
var _was: Array = [null, null]                 # per foot: its natural place last frame
var _balls: Array = [-1, -1]                   # per foot: its toes bone (the ball: a raised heel is not a foot in the air)
var _ball_floor: Array = [null, null]
var _air: Array = [false, false]               # per foot: the take has it in the air
var _own: Array = [0.0, 0.0]                   # per foot: how fast the take itself moves it (m/s)
var _f := -1


static func add(skel: Skeleton3D, ap: AnimationPlayer, after: Node) -> Node:
	var fc := new()
	fc.name = "FootCarry"
	if not fc.setup(skel, ap):
		fc.free()
		return null
	fc._balls = [skel.find_bone("LeftToes"), skel.find_bone("RightToes")]
	skel.add_child(fc)
	if after != null:
		skel.move_child(fc, after.get_index() + 1)
	return fc


func reset() -> void:
	for i in 2:
		_o[i] = Vector3.ZERO
		_sw[i] = {}
		_held[i] = null
		_y[i] = null
		_tg[i] = null
		_was[i] = null
	_still = 0.0
	if moved.is_valid():
		moved.call()


func _process_modification() -> void:
	var skel := get_skeleton()
	if skel == null or _bones.size() < 2:
		return
	var f := Engine.get_process_frames()
	if f == _f:
		_apply(skel)   # a repeat pass in one frame (a seek with update): the same targets on the re-posed legs
		return
	if _f >= 0 and f - _f > 1:
		reset()        # switched off for a while (a director's scene): the feet stand where they are shown now
	_f = f
	var clip := str(_ap.current_animation) if _ap != null else ""
	for w in FREE:
		if clip.contains(w):
			reset()    # falls, knockouts and the win play free
			return
	carry(skel, maxf(get_process_delta_time(), 1e-4))
	_apply(skel)


## One frame: the offsets take the plan's motion, a foot steps when it is due, the targets are set.
func carry(skel: Skeleton3D, dt: float) -> void:
	var xf := skel.global_transform
	var m: Transform3D = moved.call() if moved.is_valid() else Transform3D.IDENTITY
	var back := m.affine_inverse()
	var nat: Array = [Vector3.ZERO, Vector3.ZERO]
	var anim: Array = [Vector3.ZERO, Vector3.ZERO]
	var hips: Array = [Vector3.ZERO, Vector3.ZERO]
	var legs: Array = [0.0, 0.0]
	var speed := 0.0
	for i in 2:
		var ids: Array = _bones[i]
		var a: Vector3 = xf * skel.get_bone_global_pose(ids[2]).origin
		var k: Vector3 = xf * skel.get_bone_global_pose(ids[1]).origin
		hips[i] = xf * skel.get_bone_global_pose(ids[0]).origin
		legs[i] = ((hips[i] as Vector3) - k).length() + (k - a).length()
		anim[i] = a
		if _floor[i] == null or a.y < float(_floor[i]):
			_floor[i] = a.y
		var n := a
		if hold:
			_held[i] = a if _held[i] == null else m * (_held[i] as Vector3)
			n = Vector3((_held[i] as Vector3).x, a.y, (_held[i] as Vector3).z)
		elif _held[i] != null:
			_shift(i, _flat3((_held[i] as Vector3) - a))   # handed back: the foot stays, the difference is stepped out
			_held[i] = null
			_ease_y = 0.2
		nat[i] = n
		var d := _flat3(n - back * n)   # what the plan's motion did to this foot's place this frame
		var ball_y: float = (xf * skel.get_bone_global_pose(int(_balls[i])).origin).y if int(_balls[i]) >= 0 else a.y
		if _ball_floor[i] == null or ball_y < float(_ball_floor[i]):
			_ball_floor[i] = ball_y
		_air[i] = not hold and (_sw[i] as Dictionary).is_empty() and ball_y - float(_ball_floor[i]) > C_AIR_M
		_shift(i, -d)
		_own[i] = 0.0 if _was[i] == null else _flat3(n - (_was[i] as Vector3) - d).length() / dt
		_was[i] = n
		speed = maxf(speed, d.length() / dt)
	_still = _still + dt if speed < 0.05 else 0.0
	_ease_y = maxf(_ease_y - dt, 0.0)
	_start_step(nat, hips, legs)
	var dragged := [false, false]
	for i in 2:
		var lift := 0.0
		var s: Dictionary = _sw[i]
		if not s.is_empty():
			s["t"] = float(s["t"]) + dt
			var u := clampf(float(s["t"]) / float(s["dur"]), 0.0, 1.0)
			_o[i] = (s["from"] as Vector3).lerp(s["to"], u * u * u * (u * (u * 6.0 - 15.0) + 10.0))   # no jerk at either end
			lift = C_LIFT_M * clampf(((s["from"] as Vector3) - (s["to"] as Vector3)).length() / 0.15, 0.4, 1.0) * pow(sin(PI * u), 2.0)
			if u >= 1.0:
				_sw[i] = {}
		var n: Vector3 = nat[i]
		var y := n.y
		if hold:
			y = minf(y, float(_floor[i]) + C_HOLD_LIFT_M)
		if (hold or _ease_y > 0.0) and _y[i] != null:
			y = move_toward(float(_y[i]), y, C_Y_MPS * dt)
		_y[i] = y
		var hip: Vector3 = hips[i]
		var want := Vector3(n.x + (_o[i] as Vector3).x, y + lift, n.z + (_o[i] as Vector3).z)
		_tg[i] = _reach(want, hip, ((anim[i] as Vector3) - hip).length(), float(legs[i]))
		dragged[i] = (want - (_tg[i] as Vector3)).length() > 0.003
	_count(dt, dragged)


## Probes: what moved the support foot this frame (the film's ruler: the stiller of the feet standing, over 0.15 m/s).
func _count(dt: float, dragged: Array) -> void:
	var best := INF
	var who := -1
	for i in 2:
		if _tg[i] == null or _tg_was[i] == null or (_tg[i] as Vector3).y - float(_floor[i]) > 0.03:
			continue
		var d := _flat3((_tg[i] as Vector3) - (_tg_was[i] as Vector3)).length()
		if d < best:
			best = d
			who = i
	for i in 2:
		_tg_was[i] = _tg[i]
	if who < 0 or best / dt <= 0.15:
		return
	var mine := [not (_sw[0] as Dictionary).is_empty(), not (_sw[1] as Dictionary).is_empty()]
	var key := "the take's own feet (no step of ours)"
	if bool(dragged[who]):
		key = "the leg could not reach (dragged)"
	elif mine[0] and mine[1]:
		key = "both feet stepping at once"
	elif mine[who]:
		key = "our step while the take moves the other foot" + (" (in the air)" if bool(_air[1 - who]) else "")
	elif mine[1 - who]:
		key = "the take moves this foot while ours steps"
	elif hold:
		key = "held foot moved"
	tally[key] = float(tally.get(key, 0.0)) + best


func _shift(i: int, by: Vector3) -> void:
	_o[i] = (_o[i] as Vector3) + by
	var s: Dictionary = _sw[i]
	if not s.is_empty():
		s["from"] = (s["from"] as Vector3) + by
		s["to"] = (s["to"] as Vector3) + by


## At most one foot leaves the canvas a frame, and only when the other stands (unless it is left far behind). A foot is
## due when it is C_STEP_M from where the plan will have the body C_LOOK_S from now: it leaves as a ramp starts and
## lands where the ramp ends. Of two the one that leads the way goes first (the lead foot in, the rear foot out).
func _start_step(nat: Array, hips: Array, legs: Array) -> void:
	var lead: Vector3 = _flat3(ahead.call(C_LOOK_S)) if ahead.is_valid() else Vector3.ZERO
	if lead.length() > C_LEAD_MAX_M:
		lead = lead.normalized() * C_LEAD_MAX_M
	var due: Array = []
	for i in 2:
		if not (_sw[i] as Dictionary).is_empty():
			continue
		var o: Vector3 = _o[i]
		var shown: Vector3 = (nat[i] as Vector3) + o
		var stretched := shown.distance_to(hips[i]) > STEP_REACH * float(legs[i])
		if (o - lead).length() > C_STEP_M or (stretched and o.length() > 0.02) or (_still > C_SETTLE_S and o.length() > C_SETTLE_M):
			due.append(i)
	if due.is_empty():
		return
	var i: int = due[0]
	if due.size() == 2:
		var way := lead - ((_o[0] as Vector3) + (_o[1] as Vector3)) * 0.5
		if ((nat[1] as Vector3) + (_o[1] as Vector3) - (nat[0] as Vector3) - (_o[0] as Vector3)).dot(way) > 0.0:
			i = 1
	if (not (_sw[1 - i] as Dictionary).is_empty() or float(_own[1 - i]) > C_BUSY_MPS) and (_o[i] as Vector3).length() < C_URGENT_M:
		return
	_sw[i] = {"from": _o[i], "to": lead, "t": 0.0, "dur": C_SWING_S + C_SWING_PER_M * ((_o[i] as Vector3) - lead).length()}
	steps += 1


func _apply(skel: Skeleton3D) -> void:
	var xf := skel.global_transform
	for i in 2:
		if _tg[i] == null:
			continue
		var target: Vector3 = _tg[i]
		last_target[i] = target
		if (target - xf * skel.get_bone_global_pose(_bones[i][2]).origin).length() > 0.0005:
			_solve(skel, _bones[i], xf.affine_inverse() * target)


static func _flat3(v: Vector3) -> Vector3:
	return Vector3(v.x, 0.0, v.z)
