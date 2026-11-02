extends RefCounted
## S355 CORE3 step 2, the twist card (CORE3_DESIGN_S354.md "TAKEN": Kalli KALLI_CORE3_S354.md warned of "a solved week" and
## of 14 picks a week by hand). The saved week repeats on its own (CONTINUE) and ONE twist card a week changes something in
## it, so the one choice left each Monday is the interesting one: work round it or keep the plan. Drawn at the week's end for
## the next week (seeded by the week, never the same card twice running); applied to the mornings and evenings the sim runs
## and the Training tab projects. Pure static.
##   draw(week, prev_id) -> card   days(card, days) / evenings(card, evs) -> the week it leaves   touches(card, days, evs)

## swap: morning session -> the one it becomes; spar: sparring nights become this; rest_day: that day (0 = Monday) is a rest
## morning and evening; extra_spar: that evening becomes sparring.
const TWISTS := [
	{"id": "sore_wrist", "name": "Sore wrist", "line": "No bag work this week: heavy bag and speed bag mornings become shadow boxing.",
		"swap": {"heavy_bag": "shadow", "speed_bag": "shadow"}},
	{"id": "rain", "name": "Rain all week", "line": "Roadwork moves indoors: roadwork mornings become intervals (harder, more burn).",
		"swap": {"roadwork": "intervals"}},
	{"id": "weights_shut", "name": "Weights room shut", "line": "No strength circuit this week: those mornings become heavy bag.",
		"swap": {"strength": "heavy_bag"}},
	{"id": "partner_ill", "name": "Sparring partner off ill", "line": "No sparring this week: sparring nights become pads.",
		"spar": "pads"},
	{"id": "head_cold", "name": "A head cold", "line": "Wednesday in bed: a rest day, morning and evening.", "rest_day": 2},
	{"id": "visiting_pro", "name": "A visiting pro", "line": "An extra sparring night on Saturday, against a pro.", "extra_spar": 5},
	{"id": "quiet", "name": "A quiet week", "line": "Nothing gets in the way: the week runs as planned."},
]


static func card(id: String) -> Dictionary:
	for t in TWISTS:
		if str(t["id"]) == id:
			return t
	return {}


## The card for this week (week = the week number it is drawn for); never prev_id again. fight_week = her bout is inside the
## next 7 days: no card that takes a session away (S355: a head cold in fight week left the golden path's camp 0.05 kg over
## at the scale with no week left to answer it - luck at the weigh-in, not a choice).
static func draw(week: int, prev_id: String = "", fight_week: bool = false) -> Dictionary:
	var rng := RandomNumberGenerator.new()
	rng.seed = week * 7919 + 17
	var pool: Array = TWISTS.filter(func(t): return str(t["id"]) != prev_id and not (fight_week and t.has("rest_day")))
	return pool[rng.randi_range(0, pool.size() - 1)]


## The mornings the card leaves ([session, intensity] x 7).
static func days(t: Dictionary, d: Array) -> Array:
	var out := d.duplicate(true)
	var swap: Dictionary = t.get("swap", {})
	for i in out.size():
		var m: Array = out[i]
		if swap.has(str(m[0])):
			out[i] = [str(swap[str(m[0])]), str(m[1])]
	if t.has("rest_day") and int(t["rest_day"]) < out.size():
		out[int(t["rest_day"])] = ["rest", "normal"]
	return out


## The evenings the card leaves.
static func evenings(t: Dictionary, evs: Array) -> Array:
	var out := evs.duplicate()
	for i in out.size():
		if t.has("spar") and str(out[i]) == "sparring":
			out[i] = str(t["spar"])
	if t.has("extra_spar") and int(t["extra_spar"]) < out.size():
		out[int(t["extra_spar"])] = "sparring"
	if t.has("rest_day") and int(t["rest_day"]) < out.size():
		out[int(t["rest_day"])] = "rest"
	return out


## Whether the card changes anything in this week (a sore wrist in a week with no bag work does not).
static func touches(t: Dictionary, d: Array, evs: Array) -> bool:
	return days(t, d) != d or evenings(t, evs) != evs
