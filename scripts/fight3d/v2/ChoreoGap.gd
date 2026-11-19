extends RefCounted
## FIGHTPLAYER2 (S512, scope 3b): the DISTANCE PLAN of one exchange, pure. The choreographer hands it the marks it has
## decided (each punch's contact time and the gap its take is for, a hit man knocked back, the round script's step in /
## step out) and this lays the feet's work between them the way a coach counts it:
##   REST out of reach (R.REST_M) whenever no punch is near;
##   a CREEP before an attack when there is time for it (both edge in to one step from the punch's distance);
##   the STEP IN that ends as the punch lands (the puncher's own, STEP_IN_M: one step a viewer can count);
##   inside a burst the pair shifts between one take's distance and the next only for a quick follow-up; with
##   POCKET_WAIT_S or more to the next punch the man who punched steps out to the POCKET (where a jab just reaches);
##   the LEAVE: the man who threw a burst's last punch steps out STEP_OUT_M at once, then both ease back to rest
##   (S525, both critics on both v2 films: "nobody leaves", "a step out 30-40 cm within 15-30 frames of the last punch").
## The plan is piecewise linear: [[t, gap_m, who_moves], ...], t ascending; who_moves names who covers the segment that
## ENDS at that point ("a" | "b" | "both" | "" = nobody, a hold).
##   build(marks, t0, t1, gap0, log) -> plan      at(plan, t) -> gap      who(plan, t) -> who moves now
##   steps(plan) -> [{t, end_t, who, m}]  every segment a viewer can count as a step (the tracks' step events)

const R := preload("res://scripts/fight3d/v2/ChoreoRules.gd")

const LEAD_S := 0.08          # the step in is over this long before the glove lands (the front foot is down)
const HOLD_S := 0.20          # after a contact the pair stays put this long (the hand comes home, the hit shows)
const STEP_IN_M := 0.25       # the step in on the punch (the critics: lead foot 15-25 cm, down as the glove lands)
const CREEP_MPS := 0.6        # the edge in from rest to one step from the punch (calm: both men, half each)
const CREEP_S := 0.45         # ... and never quicker than this
const CREEP_GAP_S := 0.12     # between the creep's end and the step in
const APPROACH_MPS := 1.1     # the step in from the creep line (0.25 m in 0.23 s: a step of 6-8 pictures)
const LEAVE_MPS := 1.3        # the step out
const STEP_OUT_M := 0.35      # the attacker's step out after a burst's last punch
## S529 HITS MOVE THE MAN, LEGS TOO (film 6, both critics: a cross's "head jerks on a body that stays nailed down", a
## step back of 3 cm where a stiff cross moves a man 15-25): after a landed cross, hook or uppercut the man who was HIT
## takes the step out (his rear foot first, under his reaction), starting HURT_S after the blow. A jab moves nobody; a
## body shot's own stagger travels (a knock).
const HURT_OUT_M := 0.25
const HURT_S := 0.08
const EASE_OUT_WAIT_S := 0.12 # he lands that step, then both ease back to rest ...
const EASE_OUT_MPS := 0.8     # ... this fast
const POCKET_M := 1.12         # just past the jab: where the pair waits between the punches of one burst
const POCKET_WAIT_S := 0.9    # a wait this long inside a burst is spent at the pocket, not chest to chest
const POCKET_MIN_M := 0.10    # a step out to the pocket shorter than this is not worth taking
const MIN_RAMP_S := 0.12      # no move is shorter than this
## S528 (C434: "why the fighter do not walk ?"): a move a viewer counts as a step is played as a captured step take
## (StepPlay), and a boxing step takes its time: the foot leaves, travels, lands. The step out and the ease back to
## rest are never quicker than this (they were 0.27 s and 0.25 s ramps: a third of a step).
const STEP_S := 0.42
const STEP_COUNT_M := 0.12    # a segment that covers this much is a step the viewer can count


static func build(marks: Array, t0: float, t1: float, gap0: float, log: Array) -> Array:
	var out: Array = [[t0, gap0, ""]]
	var cur_t := t0
	var cur_g := gap0
	var n := marks.size()
	for i in n:
		var m: Dictionary = marks[i]
		var kind := str(m.get("kind", "contact"))
		var mt := clampf(float(m["t"]), t0, t1)
		var mg := maxf(float(m["gap"]), R.MIN_GAP_M)
		var mover := str(m.get("who", ""))
		if kind == "knock":
			# a hit man driven back by his reaction's own travel: the plan follows the take (not a step: no speed bar)
			_to(out, maxf(mt, cur_t + 0.02), mg, "knock_" + mover)
			cur_t = float(out[-1][0])
			cur_g = mg
		elif kind == "step_in" or kind == "step_out":
			var next_c := _next_contact(marks, i)
			if cur_g < R.CREEP_M - 0.05 or (next_c >= 0.0 and next_c - mt < 1.0) or mt - STEP_S < cur_t:
				continue   # in range already, or a punch is about to make the distance itself
			_to(out, mt - STEP_S, cur_g, "")
			_to(out, mt, R.CREEP_M if kind == "step_in" else R.REST_M, mover)
			cur_t = mt
			cur_g = float(out[-1][1])
		else:
			var end := mt - LEAD_S
			var line := mg + STEP_IN_M   # one step from the punch's distance
			if cur_g > line + 0.08:
				# from out of reach: a creep when there is time, then the step in on the punch
				var a_dur := maxf(STEP_IN_M / APPROACH_MPS, MIN_RAMP_S)
				var a_start := end - a_dur
				var c_dur := maxf((cur_g - line) / CREEP_MPS, CREEP_S)
				if a_start - CREEP_GAP_S - c_dur >= cur_t + 0.1:
					var c_end := a_start - CREEP_GAP_S
					_to(out, c_end - c_dur, cur_g, "")
					_to(out, c_end, line, "both")
					cur_g = line
					cur_t = c_end
				else:
					a_dur = maxf((cur_g - mg) / R.GAP_SPEED_MPS, MIN_RAMP_S)
					a_start = end - a_dur
				if a_start < cur_t:
					log.append("gap: late step in at %.2f (%.2f m in %.2f s)" % [mt, cur_g - mg, maxf(end - cur_t, 0.0)])
					a_start = cur_t
				_to(out, a_start, cur_g, "")
				_to(out, maxf(end, a_start + 0.02), mg, mover)
			else:
				# in range: shift to this take's distance as late as the speed allows
				var d := absf(mg - cur_g)
				if d > 0.005:
					var dur := maxf(d / R.GAP_SPEED_MPS, MIN_RAMP_S)
					var start := maxf(end - dur, cur_t)
					if end - start < d / R.GAP_SPEED_MPS - 0.001:
						log.append("gap: fast shift at %.2f (%.2f m in %.2f s)" % [mt, d, maxf(end - start, 0.0)])
					_to(out, start, cur_g, "")
					_to(out, maxf(end, start + 0.02), mg, mover)
				else:
					_to(out, maxf(end, cur_t), mg, "")
			cur_g = mg
			cur_t = float(out[-1][0])
			# what follows this contact: a knock (the take carries him), another punch of the burst, or the leave
			var nxt: Dictionary = marks[i + 1] if i + 1 < n else {}
			if str(nxt.get("kind", "")) == "knock":
				continue
			_after(out, marks, i, mt, t1)
			cur_t = float(out[-1][0])
			cur_g = float(out[-1][1])
			continue
		if kind == "knock":
			_after(out, marks, i, cur_t - HOLD_S, t1)
			cur_t = float(out[-1][0])
			cur_g = float(out[-1][1])
	_to(out, t1, cur_g, "")
	return out


## What the feet do after the contact (or the knock) at mark i: hold while the hit shows, then - by how long until the
## next punch - stay in range for a quick follow-up, step out to the POCKET (just past the jab) or leave to REST.
## The man who punched takes the step out; after a knock the hit man has given the ground already.
static func _after(out: Array, marks: Array, i: int, mt: float, t1: float) -> void:
	var g := float(out[-1][1])
	var knocked := str((marks[i] as Dictionary).get("kind", "contact")) == "knock"
	var hurt := "" if knocked else str((marks[i] as Dictionary).get("hurt", ""))
	var hitter := "both" if knocked else (hurt if hurt != "" else str((marks[i] as Dictionary).get("who", "both")))
	var nxt := {}
	for k in range(i + 1, marks.size()):
		if str((marks[k] as Dictionary).get("kind", "contact")) == "contact":
			nxt = marks[k]
			break
	var wait := INF if nxt.is_empty() else float(nxt["t"]) - mt
	var ls := mt + (HURT_S if hurt != "" else HOLD_S)
	if wait >= R.BURST_GAP_S:
		if g >= R.REST_M - 0.05:
			return
		var s1 := g if knocked else minf(g + (HURT_OUT_M if hurt != "" else STEP_OUT_M), R.REST_M)
		var d1 := maxf((s1 - g) / LEAVE_MPS, _whole(s1 - g)) if s1 > g + 0.005 else 0.0
		var d2 := maxf((R.REST_M - s1) / EASE_OUT_MPS, _whole(R.REST_M - s1)) if s1 < R.REST_M - 0.005 else 0.0
		if ls + d1 + EASE_OUT_WAIT_S + d2 > t1:
			return
		_to(out, ls, g, "")
		if d1 > 0.0:
			_to(out, ls + d1, s1, hitter)
		if d2 > 0.0:
			_to(out, ls + d1 + EASE_OUT_WAIT_S, s1, "")
			_to(out, ls + d1 + EASE_OUT_WAIT_S + d2, R.REST_M, "both")
		return
	var gn := maxf(float(nxt["gap"]), R.MIN_GAP_M)
	if wait >= POCKET_WAIT_S and g < POCKET_M - 0.08:
		# as far out as leaves the next punch its step back in
		var avail := float(nxt["t"]) - LEAD_S - ls
		var to := minf(POCKET_M, (avail - 0.02 + g / LEAVE_MPS + gn / R.GAP_SPEED_MPS) / (1.0 / LEAVE_MPS + 1.0 / R.GAP_SPEED_MPS))
		if to - g >= POCKET_MIN_M:
			_to(out, ls, g, "")
			_to(out, ls + maxf((to - g) / LEAVE_MPS, MIN_RAMP_S if avail < STEP_S + 0.3 else _whole(to - g)), to, hitter)
			return
	# a quick follow-up: hold only as long as the shift to its distance allows
	var need := absf(gn - g) / R.GAP_SPEED_MPS
	var hold_end := clampf(float(nxt["t"]) - LEAD_S - need, mt, mt + HOLD_S)
	if hold_end > mt + 0.03:
		_to(out, hold_end, g, "")


## The shortest a move of `m` metres may take: a whole step when a viewer can count it as one.
static func _whole(m: float) -> float:
	return STEP_S if absf(m) >= STEP_COUNT_M else MIN_RAMP_S


## The next punch contact after mark i (its time), -1 when there is none.
static func _next_contact(marks: Array, i: int) -> float:
	for k in range(i + 1, marks.size()):
		if str((marks[k] as Dictionary).get("kind", "contact")) == "contact":
			return float(marks[k]["t"])
	return -1.0


static func _to(out: Array, t: float, g: float, who: String) -> void:
	var last: Array = out[-1]
	if t <= float(last[0]) + 0.0005:
		if absf(g - float(last[1])) > 0.0005:   # two marks on one instant: the later one wins, a hair later
			out.append([float(last[0]) + 0.02, g, who])
		return
	out.append([t, g, who])


static func at(plan: Array, t: float) -> float:
	if plan.is_empty():
		return R.REST_M
	if t <= float(plan[0][0]):
		return float(plan[0][1])
	for i in range(1, plan.size()):
		if t <= float(plan[i][0]):
			var ta := float(plan[i - 1][0])
			var tb := float(plan[i][0])
			var f := 0.0 if tb <= ta else (t - ta) / (tb - ta)
			f = f * f * (3.0 - 2.0 * f)   # a step eases in and out (the slope bar is read on the straight line)
			return lerpf(float(plan[i - 1][1]), float(plan[i][1]), f)
	return float(plan[-1][1])


## Who covers the ground at time t ("" in a hold). A knocked man covers his own knock.
static func who(plan: Array, t: float) -> String:
	for i in range(1, plan.size()):
		if t <= float(plan[i][0]):
			return str(plan[i][2]).trim_prefix("knock_") if absf(float(plan[i][1]) - float(plan[i - 1][1])) > 0.0005 else ""
	return ""


## Every segment that covers STEP_COUNT_M or more: a step a viewer can count.
static func steps(plan: Array) -> Array:
	var got: Array = []
	for i in range(1, plan.size()):
		var d := float(plan[i][1]) - float(plan[i - 1][1])
		if absf(d) >= STEP_COUNT_M and str(plan[i][2]) != "" and not str(plan[i][2]).begins_with("knock"):
			got.append({"t": float(plan[i - 1][0]), "end_t": float(plan[i][0]), "who": str(plan[i][2]), "m": d})
	return got


## The plan's faults, for the tests: [] when it holds R4 (continuous in time, speed, floor, rest when nothing is near).
static func faults(plan: Array, contacts: Array, t1: float) -> Array:
	var bad: Array = []
	for i in range(1, plan.size()):
		var dt := float(plan[i][0]) - float(plan[i - 1][0])
		if dt <= 0.0:
			bad.append("time goes back at %.2f" % float(plan[i][0]))
			continue
		var v := absf(float(plan[i][1]) - float(plan[i - 1][1])) / dt
		if v > R.GAP_SPEED_MPS + 0.05 and str(plan[i][2]) != "" and not bool(str(plan[i][2]).begins_with("knock")):
			bad.append("speed %.2f m/s at %.2f" % [v, float(plan[i][0])])
		if float(plan[i][1]) < R.MIN_GAP_M - 0.001:
			bad.append("under the floor at %.2f" % float(plan[i][0]))
	var t := float(plan[0][0]) + 2.0
	while t < t1 - 0.5:
		var near := false
		for c in contacts:
			if absf(float(c) - t) < 1.5 + R.BURST_GAP_S * 0.5:
				near = true
		var g := at(plan, t)
		if not near and (g < R.REST_M - 0.2 or g > R.REST_M + 0.3):
			bad.append("not at rest at %.2f (%.2f m)" % [t, g])
		t += 0.25
	return bad
