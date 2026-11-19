extends RefCounted
## FIGHTPLAYER2 (S525, cause d of both v2 films: "two thirds of the round they are statues"; waiting scored 2 and 2.5):
## the WAITS of one exchange, planned like the punches. Pure. The v2 player showed one guard take between exchanges
## and nothing else; the owned fidgets, the pawing lead hand and the feints were never wired.
##   add(tracks, db, t0, t1, contacts, rng)  each man, on his own clock, fills every quiet stretch of his track:
##       a breath of plain guard (QUIET_S), then a FIDGET (an owned Punch PRO idle take: a bounce, a glove pump, a
##       shoulder roll; the long ones in a window), a PAW (the quick jab to half its reach and back) or a FEINT (a
##       cross or a body shot started and pulled) - never while a punch of either man is about to land;
##   breathe(gap, rng) -> gap                the distance at rest is never a still line: one man rocks in a few
##       centimetres and back (under a step: the feet stay, the weight shifts), then the other.
## Events: {t, clip, kind: "fidget" | "feint", from_s, until_s, speed, part: "whole", join_s, control_t}.

const R := preload("res://scripts/fight3d/v2/ChoreoRules.gd")

const QUIET_S := Vector2(0.35, 0.9)    # plain guard between two things (the critics: never 10 still frames, a feint every 1-3 s)
const SETTLE_S := 0.25                 # after a take of his ends, before a wait thing starts
const BEFORE_S := 0.30                 # a wait thing is over this long before his own next take starts
const CLEAR_S := Vector2(0.35, 0.55)   # no paw or feint from this long before any contact to this long after it
const WINDOW_S := Vector2(1.4, 2.4)    # how much of a long fidget take plays
## The fidgets (one actor, one stance; the census drops none of them). Short ones play whole.
const FIDGETS := ["pro_idle_fidget_v2", "pro_idle_fidget_v3", "pro_idle_fidget_v6", "pro_idle_fidget_v7",
	"pro_idle_fidget_v1", "pro_idle_fidget_v8"]
const LONG_S := 2.6                    # a fidget longer than this plays as a window
## The lead hand measures, the rear hand threatens: [clip, to_s, speed] (GuardLife's S503 measures, the old player's).
const BEATS := {"paw": ["pro_left_jab_b", 0.20, 1.0], "jab_feint": ["pro_left_jab_b", 0.12, 1.2],
	"cross_feint": ["pro_right_cross", 0.15, 1.15], "body_feint": ["pro_body_shot", 0.24, 1.3]}
const SHARE := [["fidget", 0.45], ["paw", 0.25], ["jab_feint", 0.08], ["cross_feint", 0.14], ["body_feint", 0.08]]
const BREATH_M := Vector2(0.05, 0.09)  # the rock in at rest (under FootPlant's step: the feet hold, the weight shifts)
const BREATH_FROM_M := 1.15            # holds at rest and at the pocket breathe; closer in the pair is mid-burst
const BREATH_S := 0.26                 # in, and the same back out
const BREATH_HOLD_S := Vector2(0.25, 0.7)
const BREATH_EVERY_S := Vector2(0.5, 1.1)
const BUSY := ["punch", "reaction", "block", "defence", "pass"]


## Fills both tracks' quiet stretches. `contacts`: every punch's contact time (either man's).
static func add(tracks: Dictionary, db: Dictionary, t0: float, t1: float, contacts: Array, rng: RandomNumberGenerator) -> void:
	var rows: Dictionary = db.get("rows", {})
	for w in ["a", "b"]:
		var evs: Array = tracks[w]
		var busy: Array = []   # [from, to] of his own takes
		for e in evs:
			if e.has("drift"):   # S528: a ring step is his (ChoreoDrift): no fidget or paw over it
				busy.append([float(e["t"]), float(e["end_t"])])
				continue
			if not (str(e["kind"]) in BUSY):
				continue
			var row: Dictionary = rows.get(str(e.get("clip", "")), {})
			var left: float = float(e.get("until_s", row.get("length_s", 1.2))) - float(e.get("from_s", 0.0))
			busy.append([float(e["t"]), maxf(float(e["control_t"]), float(e["t"]) + (left if str(e["kind"]) != "pass" else 2.0))])
		busy.sort_custom(func(x, y): return float(x[0]) < float(y[0]))
		var free_from := t0 + 0.2
		var last := ""
		var made: Array = []
		for k in busy.size() + 1:
			var free_to: float = (float(busy[k][0]) if k < busy.size() else t1) - BEFORE_S
			var at := free_from + _r(rng, QUIET_S)
			while at + 0.5 < free_to:
				var what := _draw(rng)
				var e := _event(what, at, free_to, rows, rng, last) if what == "fidget" else _beat(what, at, free_to, rows, contacts)
				if e.is_empty():   # a punch is landing, or the stretch is too short for it: the other kind
					e = _beat("paw", at, free_to, rows, contacts) if what == "fidget" else _event(what, at, free_to, rows, rng, last)
				if e.is_empty():
					at += 0.2
					continue
				made.append(e)
				last = str(e["clip"])
				at = float(e["end_t"]) + _r(rng, QUIET_S)
			if k < busy.size():
				free_from = maxf(free_from, float(busy[k][1]) + SETTLE_S)
		evs.append_array(made)


static func _draw(rng: RandomNumberGenerator) -> String:
	var x := rng.randf()
	for s in SHARE:
		x -= float(s[1])
		if x <= 0.0:
			return str(s[0])
	return "fidget"


static func _event(_what: String, at: float, free_to: float, rows: Dictionary, rng: RandomNumberGenerator, last: String) -> Dictionary:
	var pool: Array = FIDGETS.filter(func(n): return rows.has(n) and n != last and (rows[n].get("drop", []) as Array).is_empty())
	if pool.is_empty():
		return {}
	var clip: String = pool[rng.randi() % pool.size()]
	var length: float = float(rows[clip].get("length_s", 1.0))
	var from_s := 0.0
	var dur := length
	if length > LONG_S:
		dur = _r(rng, WINDOW_S)
		from_s = rng.randf() * (length - dur)
	dur = minf(dur, free_to - at)
	if dur < 0.45:
		return {}
	return {"t": at, "clip": clip, "kind": "fidget", "part": "whole", "from_s": from_s, "until_s": from_s + dur, "speed": 1.0,
		"join_s": R.join_for("guard"), "control_t": at, "end_t": at + dur}


static func _beat(what: String, at: float, free_to: float, rows: Dictionary, contacts: Array) -> Dictionary:
	var b: Array = BEATS[what]
	if not rows.has(str(b[0])):
		return {}
	var dur: float = float(b[1]) / float(b[2])
	if at + dur + 0.25 > free_to:
		return {}
	for c in contacts:
		if float(c) > at - CLEAR_S.y and float(c) < at + dur + CLEAR_S.x:
			return {}   # a punch is landing: nobody paws through it
	return {"t": at, "clip": str(b[0]), "kind": "feint", "part": "whole", "from_s": 0.0, "until_s": float(b[1]), "speed": float(b[2]),
		"join_s": R.join_for("punch"), "control_t": at, "end_t": at + dur + 0.25, "what": what}


static func _r(rng: RandomNumberGenerator, v: Vector2) -> float:
	return v.x + (v.y - v.x) * rng.randf()


## The distance plan with the rest holds broken up: in every hold at rest one man rocks in and back, then the other.
static func breathe(gap: Array, rng: RandomNumberGenerator) -> Array:
	var out: Array = [gap[0]]
	var who := "a" if rng.randf() < 0.5 else "b"
	for i in range(1, gap.size()):
		var ta := float(gap[i - 1][0])
		var tb := float(gap[i][0])
		var g := float(gap[i][1])
		if absf(g - float(gap[i - 1][1])) < 0.001 and g >= BREATH_FROM_M and tb - ta >= 1.2:
			var at := ta + _r(rng, BREATH_EVERY_S) * 0.5
			while true:
				var d := _r(rng, BREATH_M) * (1.0 if g >= R.REST_M - 0.05 else 0.6)
				var hold := _r(rng, BREATH_HOLD_S)
				if at + BREATH_S * 2.0 + hold > tb - 0.3:
					hold = BREATH_HOLD_S.x
				if at + BREATH_S * 2.0 + hold > tb - 0.3:
					break
				out.append([at, g, ""])
				out.append([at + BREATH_S, g - d, who])
				out.append([at + BREATH_S + hold, g - d, ""])
				out.append([at + BREATH_S * 2.0 + hold, g, who])
				who = "b" if who == "a" else "a"
				at += BREATH_S * 2.0 + hold + _r(rng, BREATH_EVERY_S)
		out.append(gap[i])
	return out
