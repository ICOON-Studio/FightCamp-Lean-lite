extends RefCounted
## S496 TRAININGK1 (operator Q-S294-259 "Yes, build it", Training K v6c): the boxing coach's evening shared between the
## boxers on pads that night. One coach holds NIGHT_MIN pad minutes a night (WeekPlan.EVENINGS pads 75); the boxers on the
## pads split them; the player drags the line between two faces. A boxer's drilling that night is her minutes over a full
## night (75 min alone = PadWeek.PAD_NIGHT_MINUTES): linear, as the coach spec worked it out (COACHSPEC1_MAP_R5_S495.md
## section 12: "75 min moves a drilled line about one band in a night, 45 min about 60% of that"; three boxers at 25 min
## each = a band in about three nights).
##   split(on_pads, set, coaches) -> {fid: minutes}   drag(on_pads, now, edge, left_min, coaches) -> {fid: minutes}
##   factor(minutes) -> float   total(coaches) -> float
## on_pads: the boxers on pads that night, in screen order. set: {fid: minutes} the player fixed (others share the rest).
## Pure static - no preloads, no state.

## One boxing coach's pad minutes a night (WeekPlan.EVENINGS["pads"]["min"]).
const NIGHT_MIN := 75.0
## The smallest share a boxer on the pads keeps, and the step the line snaps to.
const MIN_SHARE := 5.0
const STEP := 5.0


static func total(coaches: int = 1) -> float:
	return NIGHT_MIN * float(maxi(1, coaches))


## Each boxer's minutes. A boxer the player set keeps hers (within the night); the rest share what is left evenly. The sum
## is always the night's total; nobody on the pads gets under MIN_SHARE.
static func split(on_pads: Array, set: Dictionary = {}, coaches: int = 1) -> Dictionary:
	var out := {}
	var n := on_pads.size()
	if n == 0:
		return out
	var all := total(coaches)
	if n == 1:
		out[str(on_pads[0])] = all
		return out
	var fixed := 0.0
	var free: Array = []
	for id in on_pads:
		var k := str(id)
		if set.has(k):
			out[k] = clampf(float(set[k]), MIN_SHARE, all - MIN_SHARE * float(n - 1))
			fixed += float(out[k])
		else:
			free.append(k)
	if free.is_empty():   # every share fixed: scale them onto the night
		var sum := 0.0
		for k in out:
			sum += float(out[k])
		for k in out:
			out[k] = float(out[k]) * all / maxf(sum, 0.001)
		return _floor(out, on_pads, all)
	var left := maxf(all - fixed, MIN_SHARE * float(free.size()))
	for k in free:
		out[k] = left / float(free.size())
	if fixed + left > all + 0.001:   # the fixed shares asked too much: they give way, the free ones keep MIN_SHARE
		var over := fixed + left - all
		for k in out:
			if not free.has(k):
				out[k] = float(out[k]) - over * float(out[k]) / maxf(fixed, 0.001)
	return _floor(out, on_pads, all)


static func _floor(out: Dictionary, on_pads: Array, all: float) -> Dictionary:
	var short := 0.0
	var big := ""
	for id in on_pads:
		var k := str(id)
		if float(out[k]) < MIN_SHARE:
			short += MIN_SHARE - float(out[k])
			out[k] = MIN_SHARE
		if big == "" or float(out[k]) > float(out[big]):
			big = k
	if short > 0.0:
		out[big] = float(out[big]) - short
	return out


## The white line between boxer `edge` and `edge + 1` moved so the boxers left of it hold `left_min` together. Only the two
## beside the line change; the result snaps to STEP and keeps MIN_SHARE each. Returns the new {fid: minutes} (every boxer
## on the pads fixed, so the next split keeps the picture as dragged).
static func drag(on_pads: Array, now: Dictionary, edge: int, left_min: float, coaches: int = 1) -> Dictionary:
	var out := split(on_pads, now, coaches)
	if edge < 0 or edge >= on_pads.size() - 1:
		return out
	var a := str(on_pads[edge])
	var b := str(on_pads[edge + 1])
	var before := 0.0
	for i in edge:
		before += float(out[str(on_pads[i])])
	var pair := float(out[a]) + float(out[b])
	var want := snappedf(left_min - before, STEP)
	out[a] = clampf(want, MIN_SHARE, pair - MIN_SHARE)
	out[b] = pair - float(out[a])
	return out


## A boxer's drilling that night against a full night alone with the coach (1.0 = PadWeek.PAD_NIGHT_MINUTES). One boxer
## never takes more than one coach's whole night, however many coaches there are.
static func factor(minutes: float) -> float:
	return clampf(minutes / NIGHT_MIN, 0.0, 1.0)
