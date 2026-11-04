extends RefCounted
## S379 the Grappling theatre's documentary camera ("movie prop"): a director that cuts 3-4 shots per move -
##   wide      a slow dolly around the pair (an arc of up to 30 degrees over the shot)
##   low       a low side angle at mat level, 3/4 to the pair's long axis
##   close     a close-up on the key contact at the move's middle (the grip, else the hips, else the nearest limbs),
##             a slow push-in, from the angle that sees the contact past both bodies (S379 film: a 1.3 m close-up from a
##             fixed angle filled the frame with the back of a head)
##   overhead  straight down on a scramble (a move whose bodies travel or turn a lot), turning slowly
## S379 operator ("the camera spins too fast on the clips, it got me dizzy"; tools/orbit_drift.gd): no camera turns faster
## than MAX_TURN_DEG_S, eased in and out - each shot's drift is capped by its length (a smoothstep peaks at 1.5x its mean
## rate) and the camera TRACKS the pair (it moves with its target at a fixed angle) instead of panning after it, so the
## only turn inside a shot is its own slow drift; a change of angle is a cut, never a whip-pan.
## Rules: no shot shorter than MIN_SHOT_S; a move's first cut lands JOIN_LEAD_S after its join, so a join always plays
## inside one continuous shot (a cut on a join would hide the pop the theatre is there to show); the camera keeps one
## side of the pair (the 180-degree rule) and is never inside a body (CAPS + CLEAR_M, checked on the joints at
## SAMPLE_HZ and pushed back along its view for the whole shot) nor under the mat (CAM_MIN_Y).
##   plan(sampler, steps, total)   sampler: theatre time -> [joints woman 0, joints woman 1] (world, PackedVector3Array)
##   cam_at(t) -> {pos, look, fov, kind}     audit(hz) -> {min_clear, min_y, shortest, shots, max_turn}
## Pure apart from the sampler it is handed (headless tests run it on the player alone).

const DB := preload("res://scripts/grapple/GrappleMapDB.gd")
const MIN_SHOT_S := 1.6
const JOIN_LEAD_S := 0.7
const CLOSE_HALF_S := 0.9
const CAM_MIN_Y := 0.3
const CLEAR_M := 0.15
const SAMPLE_HZ := 8.0
const SCRAMBLE_TRAVEL_M := 0.9
const SCRAMBLE_DROP_M := 0.45
const STAGE_YAW := 35.0
const MAX_TURN_DEG_S := 10.0
const CLOSE_FROM_M := 2.1
const CLOSE_TO_M := 1.8
const CLOSE_AIMS := [20.0, -20.0, 60.0, -60.0, 100.0, -100.0, 160.0]
const CLOSE_ELEVS := [38.0, 55.0]
## Body capsules on the data's joints [a, b, radius], our women's flesh with a margin (the drawn bones sit up to ~0.2 m
## off the joints - S379 audit - so the clearance is generous).
const CAPS := [["Core", "Neck", 0.18], ["LeftHip", "RightHip", 0.16], ["Neck", "Head", 0.14],
	["LeftShoulder", "RightShoulder", 0.12], ["LeftHip", "LeftKnee", 0.11], ["RightHip", "RightKnee", 0.11],
	["LeftKnee", "LeftAnkle", 0.08], ["RightKnee", "RightAnkle", 0.08], ["LeftShoulder", "LeftElbow", 0.08],
	["RightShoulder", "RightElbow", 0.08], ["LeftElbow", "LeftWrist", 0.07], ["RightElbow", "RightWrist", 0.07],
	["LeftAnkle", "LeftToe", 0.07], ["RightAnkle", "RightToe", 0.07], ["LeftWrist", "LeftFingers", 0.06],
	["RightWrist", "RightFingers", 0.06]]
const TORSO := ["Core", "Neck", "LeftHip", "RightHip"]
const GRIPS := ["LeftHand", "RightHand", "LeftWrist", "RightWrist", "LeftFingers", "RightFingers"]
const HIPS := ["Core", "LeftHip", "RightHip"]
const PRIORITY := {"close": 3, "overhead": 2, "low": 1, "wide": 0}

var shots: Array = []
var total := 0.0
var _sample: Callable
var _stage_yaw := STAGE_YAW


func plan(sampler: Callable, steps: Array, total_s: float) -> void:
	_sample = sampler
	total = total_s
	_stage_yaw = STAGE_YAW
	var joins: Array = []
	var beats: Array = [[0.0, "wide"]]
	for i in steps.size():
		var t0 := float(steps[i]["t0"])
		var t1 := float(steps[i]["t1"])
		var d := t1 - t0
		var mid := (t0 + t1) * 0.5
		var scramble := is_scramble(t0, t1)
		steps[i]["scramble"] = scramble
		# The angles take turns move by move (wide, then low ...); a scramble is seen from above.
		var opening: String = "overhead" if scramble else ["wide", "low"][i % 2]
		var after: String = "overhead" if scramble and opening != "overhead" else ["low", "wide"][i % 2]
		if i > 0:
			joins.append(t0)
			beats.append([t0 + JOIN_LEAD_S, opening])
		# A short move's close-up runs on into the next move (its join plays in the close-up).
		if d >= MIN_SHOT_S:
			beats.append([mid - CLOSE_HALF_S, "close"])
		if d >= 3.0:
			beats.append([mid + CLOSE_HALF_S, after])
		if d >= 6.6:
			var a := t0 + JOIN_LEAD_S
			beats.append([a + (mid - CLOSE_HALF_S - a) * 0.5, "low"])
	for b in beats:   # never cut on a join
		for j in joins:
			if absf(float(b[0]) - float(j)) < 0.3:
				b[0] = float(j) + 0.3
	beats.sort_custom(func(x, y): return float(x[0]) < float(y[0]))
	var kept: Array = [beats[0]]
	for b in beats.slice(1):
		var last: Array = kept.back()
		if str(b[1]) == str(last[1]) or float(b[0]) >= total - MIN_SHOT_S:
			continue
		if float(b[0]) - float(last[0]) >= MIN_SHOT_S:
			kept.append(b)
		elif kept.size() > 1 and PRIORITY[str(b[1])] > PRIORITY[str(last[1])] \
				and float(b[0]) - float(kept[kept.size() - 2][0]) >= MIN_SHOT_S and str(b[1]) != str(kept[kept.size() - 2][1]):
			kept[kept.size() - 1] = b
		elif str(b[1]) == "close" and float(last[0]) + MIN_SHOT_S <= float(b[0]) + 0.6 \
				and not _near_join(float(last[0]) + MIN_SHOT_S, joins):
			kept.append([float(last[0]) + MIN_SHOT_S, "close"])   # a close-up a moment late beats none
	shots = []
	for i in kept.size():
		var t1 := float(kept[i + 1][0]) if i + 1 < kept.size() else total
		shots.append(_shot(str(kept[i][1]), float(kept[i][0]), t1))


static func _near_join(t: float, joins: Array) -> bool:
	return joins.any(func(j): return absf(t - float(j)) < 0.3)


## A move is a scramble when either woman's core travels or drops a lot (a roll, a sweep, a takedown).
func is_scramble(t0: float, t1: float) -> bool:
	var a: Array = _sample.call(t0)
	var b: Array = _sample.call(t1)
	var core := DB.joint("Core")
	for w in 2:
		var pa: Vector3 = (a[w] as PackedVector3Array)[core]
		var pb: Vector3 = (b[w] as PackedVector3Array)[core]
		if Vector2(pa.x - pb.x, pa.z - pb.z).length() > SCRAMBLE_TRAVEL_M or absf(pa.y - pb.y) > SCRAMBLE_DROP_M:
			return true
	return false


func _shot(kind: String, t0: float, t1: float) -> Dictionary:
	var tm := (t0 + t1) * 0.5
	var js: Array = _sample.call(tm)
	var reach := 0.0
	var top := 0.0
	var n := maxi(2, int((t1 - t0) * SAMPLE_HZ))
	# The camera tracks the pair's middle, so the framing is the widest reach from the middle of that moment (S379 film:
	# measured from the shot's mid-time middle, a travelling cartwheel was framed from 8 m away).
	for k in n + 1:
		var tk := lerpf(t0, t1, float(k) / n)
		var s: Array = _sample.call(tk)
		var ck := centre_smooth(tk)
		for w in 2:
			for p in (s[w] as PackedVector3Array):
				reach = maxf(reach, Vector2(p.x - ck.x, p.z - ck.z).length())
				top = maxf(top, p.y)
	var side := side_yaw(js)
	var sh := {"kind": kind, "t0": t0, "t1": t1, "yaw": side, "reach": reach, "top": top, "push": 0.0}
	match kind:
		"wide":
			sh["fov"] = 40.0
			sh["dist"] = fit(reach, top, 40.0)
		"low":
			sh["fov"] = 36.0
			sh["dist"] = fit(reach, top, 36.0) * 0.9
		"close":
			sh["fov"] = 30.0
			sh["dist"] = CLOSE_FROM_M
			sh["contact"] = contact(js)
			_aim_close(sh, n)
		"overhead":
			sh["fov"] = 44.0
			sh["dist"] = maxf(2.6, reach * 1.2 / tan(deg_to_rad(22.0)) + top)
	# Clear of both bodies for the whole shot: push back along the view, then lift above the mat.
	var probe: Array = []
	for k in n + 1:
		var t := lerpf(t0, t1, float(k) / n)
		var pose := _pose(sh, t)
		probe.append([pose["pos"], ((pose["pos"] - pose["look"]) as Vector3).normalized(), _sample.call(t)])
	var push := 0.0
	while push < 3.0:
		var ok := true
		for pr in probe:
			if clearance((pr[0] as Vector3) + (pr[1] as Vector3) * push, pr[2]) < CLEAR_M:
				ok = false
				break
		if ok:
			break
		push += 0.1
	sh["push"] = push
	return sh


## The close-up's angle: of CLOSE_AIMS x CLOSE_ELEVS (around the side view), the one whose line of sight to the contact
## is blocked by a body (or whose camera sits in one) in the fewest moments of the shot; ties go to the smaller turn.
func _aim_close(sh: Dictionary, n: int) -> void:
	var looks: Array = []
	var jss: Array = []
	var es: Array = []
	for k in n + 1:
		var t := lerpf(float(sh["t0"]), float(sh["t1"]), float(k) / n)
		looks.append(contact_smooth(sh["contact"], t))
		jss.append(_sample.call(t))
		es.append(smoothstep(0.0, 1.0, float(k) / n))
	var best := INF
	for el in CLOSE_ELEVS:
		for aim in CLOSE_AIMS:
			var ry := deg_to_rad(float(sh["yaw"]) + float(aim))
			var re := deg_to_rad(float(el))
			var dir := Vector3(sin(ry) * cos(re), sin(re), cos(ry) * cos(re))
			var blocked := 0
			for k in looks.size():
				var pos: Vector3 = (looks[k] as Vector3) + dir * lerpf(CLOSE_FROM_M, CLOSE_TO_M, float(es[k]))
				if occluded(pos, looks[k], jss[k]) or clearance(pos, jss[k]) < CLEAR_M:
					blocked += 1
			var score := float(blocked) / looks.size() + absf(float(aim)) / 2000.0 + (0.02 if float(el) > 40.0 else 0.0)
			if score < best:
				best = score
				sh["aim"] = aim
				sh["elev"] = el
	sh["blocked"] = snappedf(best, 0.01)


## A body between the camera and its target: the sight line (stopping 0.3 m short of the target - the contact itself
## is on the bodies) passes through a capsule.
static func occluded(pos: Vector3, target: Vector3, js: Array) -> bool:
	var d := target - pos
	if d.length() < 0.35:
		return false
	var end := target - d.normalized() * 0.3
	for w in 2:
		var j: PackedVector3Array = js[w]
		for c in CAPS:
			var cp := Geometry3D.get_closest_points_between_segments(pos, end, j[DB.joint(str(c[0]))], j[DB.joint(str(c[1]))])
			if (cp[0] as Vector3).distance_to(cp[1]) < float(c[2]) * 0.9:
				return true
	return false


## The camera's base pose in a shot at theatre time t (before the push-back).
func _pose(sh: Dictionary, t: float) -> Dictionary:
	var u := clampf((t - float(sh["t0"])) / maxf(0.001, float(sh["t1"]) - float(sh["t0"])), 0.0, 1.0)
	var e := smoothstep(0.0, 1.0, u)
	var yaw := float(sh["yaw"])
	var dist := float(sh["dist"])
	var look := centre_smooth(t)
	var elev := 24.0
	match str(sh["kind"]):
		"wide":
			yaw += -18.0 + drift(sh, 30.0) * e
		"low":
			yaw += 32.0 + drift(sh, 8.0) * e
			elev = 7.0
			look.y = maxf(0.25, look.y * 0.8)
		"close":
			yaw += float(sh["aim"])
			elev = float(sh["elev"])
			dist = lerpf(CLOSE_FROM_M, CLOSE_TO_M, e)
			look = contact_smooth(sh["contact"], t)
		"overhead":
			yaw += drift(sh, 20.0) * e
			var r := deg_to_rad(yaw)
			return {"pos": look + Vector3(sin(r) * 0.55, dist, cos(r) * 0.55), "look": look, "fov": float(sh["fov"])}
	var ry := deg_to_rad(yaw)
	var re := deg_to_rad(elev)
	var pos := look + Vector3(sin(ry) * cos(re), sin(re), cos(ry) * cos(re)) * dist
	return {"pos": pos, "look": look, "fov": float(sh["fov"])}


## A shot's drift in degrees: what it wants, capped so the eased turn never passes MAX_TURN_DEG_S (smoothstep's
## steepest point is 1.5x its mean rate).
static func drift(sh: Dictionary, want_deg: float) -> float:
	return minf(want_deg, MAX_TURN_DEG_S * (float(sh["t1"]) - float(sh["t0"])) / 1.5)


func shot_at(t: float) -> Dictionary:
	if shots.is_empty():
		return {}
	for i in range(shots.size() - 1, -1, -1):
		if t >= float(shots[i]["t0"]):
			return shots[i]
	return shots[0]


func cam_at(t: float) -> Dictionary:
	var sh := shot_at(t)
	if sh.is_empty():
		return {"pos": Vector3(0, 1.5, 3.5), "look": Vector3(0, 0.4, 0), "fov": 40.0, "kind": "none"}
	var p := _pose(sh, t)
	var pos: Vector3 = p["pos"] + ((p["pos"] - p["look"]) as Vector3).normalized() * float(sh["push"])
	pos.y = maxf(pos.y, CAM_MIN_Y)
	return {"pos": pos, "look": p["look"], "fov": p["fov"], "kind": sh["kind"]}


## The pair's middle: both women's trunks (core, neck, hips) averaged.
func centre(t: float) -> Vector3:
	var js: Array = _sample.call(t)
	var c := Vector3.ZERO
	for w in 2:
		for n in TORSO:
			c += (js[w] as PackedVector3Array)[DB.joint(n)]
	c /= 8.0
	c.y = clampf(c.y, 0.25, 1.0)
	return c


## The middle averaged over +-0.6 s: the camera glides instead of following every hip shift.
func centre_smooth(t: float) -> Vector3:
	var c := Vector3.ZERO
	for k in range(-4, 5):
		c += centre(clampf(t + k * 0.15, 0.0, total))
	return c / 9.0


## The side view: square to the pair's long axis (the main direction of all 46 joints on the mat), on the side nearest
## the last shot's (the camera does not jump across the pair).
func side_yaw(js: Array) -> float:
	var m := Vector2.ZERO
	for w in 2:
		for p in (js[w] as PackedVector3Array):
			m += Vector2(p.x, p.z)
	m /= 46.0
	var sxx := 0.0
	var szz := 0.0
	var sxz := 0.0
	for w in 2:
		for p in (js[w] as PackedVector3Array):
			var d := Vector2(p.x, p.z) - m
			sxx += d.x * d.x
			szz += d.y * d.y
			sxz += d.x * d.y
	var axis := 0.5 * atan2(2.0 * sxz, sxx - szz)   # the long axis' angle from +x on the mat
	# The camera sits at yaw where (sin yaw, cos yaw) is its direction: square to the axis = the axis' normal.
	var a := rad_to_deg(atan2(-sin(axis), cos(axis)))
	var best := a
	for cand in [a, a + 180.0]:
		if absf(wrapf(cand - _stage_yaw, -180.0, 180.0)) < absf(wrapf(best - _stage_yaw, -180.0, 180.0)):
			best = cand
	best = _stage_yaw + wrapf(best - _stage_yaw, -180.0, 180.0)
	_stage_yaw = best
	return best


## The key contact at a moment: a hand on the other woman (the grip), else hip to hip, else the nearest limbs.
## [woman, her joint, the other's joint, label].
func contact(js: Array) -> Array:
	for pick in [[GRIPS, 0.2, "the grip"], [HIPS, 0.35, "the hips"], [DB.JOINTS, 99.0, "the contact"]]:
		var best := [0, 0, 0, "", INF]
		for w in 2:
			for jn in pick[0]:
				var a: Vector3 = (js[w] as PackedVector3Array)[DB.joint(str(jn))]
				for k in DB.JOINTS.size():
					var d := a.distance_to((js[1 - w] as PackedVector3Array)[k])
					if d < float(best[4]):
						best = [w, DB.joint(str(jn)), k, str(pick[2]), d]
		if float(best[4]) <= float(pick[1]):
			return best.slice(0, 4)
	return [0, DB.joint("Core"), DB.joint("Core"), "the contact"]


func contact_smooth(c: Array, t: float) -> Vector3:
	var p := Vector3.ZERO
	for k in range(-2, 3):
		var js: Array = _sample.call(clampf(t + k * 0.15, 0.0, total))
		p += ((js[int(c[0])] as PackedVector3Array)[int(c[1])] + (js[1 - int(c[0])] as PackedVector3Array)[int(c[2])]) * 0.5
	p /= 5.0
	p.y = maxf(p.y, 0.15)
	return p


## Distance for a framing: the widest reach across a 16:9 picture and the tallest point up and down.
static func fit(reach: float, top: float, fov: float) -> float:
	var half_v := deg_to_rad(fov * 0.5)
	var half_h := atan(tan(half_v) * 16.0 / 9.0)
	return maxf(2.0, 1.1 * maxf(reach / tan(half_h), (top * 0.5 + 0.2) / tan(half_v)) + 0.35)


## How far a point is outside both bodies (metres; negative = inside a capsule).
static func clearance(p: Vector3, js: Array) -> float:
	var best := INF
	for w in 2:
		var j: PackedVector3Array = js[w]
		for c in CAPS:
			var a := j[DB.joint(str(c[0]))]
			var b := j[DB.joint(str(c[1]))]
			var q := Geometry3D.get_closest_point_to_segment(p, a, b)
			best = minf(best, p.distance_to(q) - float(c[2]))
	return best


## The film's own check at `hz`: the closest the camera came to a body surface, its lowest point, the shortest shot.
func audit(hz: float = 30.0) -> Dictionary:
	var min_clear := INF
	var min_y := INF
	var worst_t := 0.0
	var n := int(total * hz)
	var max_turn := 0.0
	var last_fwd := Vector3.ZERO
	var last_shot := -1.0
	for f in n + 1:
		var t := float(f) / hz
		var cam := cam_at(t)
		var fwd := ((cam["look"] as Vector3) - (cam["pos"] as Vector3)).normalized()
		var sh0 := float(shot_at(t)["t0"])
		if is_equal_approx(sh0, last_shot):   # inside one shot (a cut is not a turn)
			max_turn = maxf(max_turn, rad_to_deg(last_fwd.angle_to(fwd)) * hz)
		last_fwd = fwd
		last_shot = sh0
		var cl := clearance(cam["pos"], _sample.call(t))
		if cl < min_clear:
			min_clear = cl
			worst_t = t
		min_y = minf(min_y, (cam["pos"] as Vector3).y)
	var shortest := INF
	for s in shots:
		shortest = minf(shortest, float(s["t1"]) - float(s["t0"]))
	return {"min_clear": min_clear, "min_y": min_y, "shortest": shortest, "shots": shots.size(), "worst_t": worst_t,
		"max_turn": max_turn}
