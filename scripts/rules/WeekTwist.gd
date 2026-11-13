extends RefCounted
## S355 CORE3 step 2, the twist card (CORE3_DESIGN_S354.md "TAKEN": Kalli KALLI_CORE3_S354.md warned of "a solved week" and
## of 14 picks a week by hand). The saved week repeats on its own (CONTINUE) and ONE twist card a week changes something in
## it, so the one choice left each Monday is the interesting one: work round it or keep the plan. Drawn at the week's end for
## the next week (seeded by the week, never the same card twice running); applied to the mornings and evenings the sim runs
## and the Training tab projects. Pure static.
##   draw(week, prev_id) -> card   days(card, days) / evenings(card, evs) -> the week it leaves   touches(card, days, evs)
## S356 (operator Q-S294-83 "Yes, build it", the Miro draft "Twist cards: one every Monday"): most weeks the card is a CHOICE
## with a visible price - two answers, each a set of effects - picked on the week review or the Training tab until Monday
## runs (then it is locked; no answer = the coach's call, `default`). About 1 week in 4 is one of the small no-choice cards
## above (QUIET_SHARE). A card can need something of her week (`needs`: a booked bout, a cut, a combo on the pads, a
## southpaw opponent); fight week never draws a no-choice card that takes a session away.
##   active(f) -> the card with her answer's effects in it   pick(f, "a"|"b")   lock(f) -> the once-effects   answer(f)   deal(f, card)
## Effects: rest_hard (her first Hard morning -> rest), no_hard (every Hard morning -> Normal, S361), all_light, rest_day, morning_rest / evening_rest (day index),
## extra_spar, risk (injury rolls this week), kg_day / fat_day (WeekPlan.day), combo_mult / move_mult (the pads), and once on
## Monday: cash, morale (FighterProfile kind), rep, members, reveal (a coach's note; 1 in 3 an old habit costs technique),
## lefty (an edge on the night vs a southpaw), hot (on the night she takes the corner's fix half as well), swap_opp (a tougher
## opponent, twice the reputation on a win, the tape restarts - Bouts.short_notice), withdraw (the bout and camp end).

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
const CHOICES := [
	{"id": "tight_knee", "name": "Tight knee", "line": "Wakes up with a sore knee.", "default": "a",
		"a": {"label": "Rest it", "line": "The first Hard morning becomes a rest day.", "rest_hard": true},
		"b": {"label": "Push through", "line": "The full week - and twice the injury risk.", "risk": 2}},
	{"id": "scale_stuck", "name": "The scale will not move", "line": "The weight has stalled for three days.", "needs": "cut", "default": "a",
		"a": {"label": "Cut harder", "line": "0.3 kg more off this week; the week ends more tired - and a hot week hurts more.", "kg_day": -0.04, "fat_day": 2.0},
		"b": {"label": "Trust the process", "line": "Fresh legs; the weight stalls (0.2 kg over the plan).", "kg_day": 0.03}},
	{"id": "night_off", "name": "A night off, please", "line": "A friend's wedding falls on Saturday.", "default": "a",
		"a": {"label": "Say yes", "line": "Saturday off, morning and evening; morale up.", "rest_day": 5, "morale": "let_go"},
		"b": {"label": "Say no", "line": "The full week; morale down.", "morale": "refused"}},
	{"id": "heating", "name": "Gym heating breaks", "line": "The gym is freezing and the repair is costly.", "default": "a",
		"a": {"label": "Fix it", "line": "Pay $600 now; train as planned.", "cash": -600},
		"b": {"label": "Wait", "line": "Keep the cash; every morning counts as Light.", "all_light": true}},
	{"id": "combo_click", "name": "Combo clicking", "line": "The combination is close to clicking.", "needs": "combo", "default": "b",
		"a": {"label": "Double down", "line": "Twice the pad time on the combo, none on the new move.", "combo_mult": 2.0, "move_mult": 0.0},
		"b": {"label": "Stay balanced", "line": "Pad time as planned."}},
	{"id": "southpaw", "name": "Southpaw in town", "line": "A lefty sparring partner is here this week.", "needs": "southpaw", "default": "a",
		"a": {"label": "Take the spar", "line": "Wednesday morning off for a sparring night with the lefty: an edge on the southpaw opponent.",
			"morning_rest": 2, "extra_spar": 2, "lefty": true},
		"b": {"label": "Pass", "line": "The week stays as planned."}},
	{"id": "old_coach", "name": "The old coach visits", "line": "The first coach offers a session on the old habits.", "default": "b",
		"a": {"label": "Take the session", "line": "The coach learns one more thing; 1 in 3 an old habit costs technique.", "reveal": true},
		"b": {"label": "Decline", "line": "Nothing changes."}},
	{"id": "photoshoot", "name": "Sponsor photoshoot", "line": "A sponsor wants Thursday evening. It pays well.", "default": "a",
		"a": {"label": "Take it", "line": "+$400; Thursday evening off.", "cash": 400, "evening_rest": 3},
		"b": {"label": "Decline", "line": "The sponsor tells people: reputation -1.", "rep": -1}},
	{"id": "trash_talk", "name": "Rival talks trash", "line": "The next opponent talks trash in the local paper.", "needs": "bout", "default": "b",
		"a": {"label": "Fire back", "line": "The buzz brings 3 members now; on the night the corner's fixes land half as well.",
			"members": 3, "hot": true},
		"b": {"label": "Stay quiet", "line": "A calm camp."}},
	# S357 the last card of the Miro draft. Rare (RARE_SHARE of the weeks it can come up) and only 2+ weeks out ("swap" =
	# Sim.twist_needs: an amateur bout 14+ days away with a tougher opponent in her division to send).
	{"id": "short_notice", "name": "Short-notice swap", "line": "The opponent pulls out. The show offers a tougher one on the same night.",
		"needs": "swap", "rare": true, "default": "a",
		"a": {"label": "Take the fight", "line": "A tougher opponent and twice the reputation on a win; the tape study starts again.",
			"swap_opp": true},
		"b": {"label": "Withdraw", "line": "The bout is off and the camp ends here; the camp's cost is spent.", "withdraw": true}},
]
# S361 she pushes back (Q-S294-86 "Yes, build them", Miro top-5 card 2): some weeks the card is HER ask, rooted in her
# personality, habits or how tired the last week left her (PushBack picks it and when). Her way = "heard" (morale up); the
# plan = "overruled" (morale down, more for a low-coachability fighter). Morale is the trust score: it scales what she
# takes in of the corner's calls (FighterProfile.trust). {first} = her first name (TwistCard fills it in).
const ASKS := [
	{"id": "ask_rest", "name": "{first} asks for a day off", "line": "\"I'm cooked. Give me Saturday.\"", "ask": true, "default": "b",
		"a": {"label": "Give Saturday off", "line": "Saturday off, morning and evening; morale up.", "rest_day": 5, "morale": "heard"},
		"b": {"label": "Keep the plan", "line": "The full week; morale down.", "morale": "overruled"}},
	{"id": "ask_easy", "name": "{first} asks to ease off", "line": "\"Too many hard mornings. Can we ease off?\"", "ask": true, "default": "b",
		"a": {"label": "Ease off", "line": "Every Hard morning goes Normal (less gain, less fatigue); morale up.", "no_hard": true, "morale": "heard"},
		"b": {"label": "Keep it hard", "line": "The Hard mornings stay; morale down.", "morale": "overruled"}},
	{"id": "ask_spar", "name": "{first} wants more sparring", "line": "\"Pads are boring. Let me spar Friday.\"", "ask": true, "default": "b",
		"a": {"label": "Spar Friday", "line": "Friday evening becomes sparring (more load, more ring craft); morale up.", "extra_spar": 4, "morale": "heard"},
		"b": {"label": "Keep the plan", "line": "Friday stays as planned; morale down.", "morale": "overruled"}},
	{"id": "ask_road", "name": "{first} wants more running", "line": "\"I keep fading late. More running.\"", "ask": true, "default": "b",
		"a": {"label": "More roadwork", "line": "Speed bag and shadow mornings become roadwork; morale up.", "swap": {"speed_bag": "roadwork", "shadow": "roadwork"}, "morale": "heard"},
		"b": {"label": "Keep the plan", "line": "The week stays as planned; morale down.", "morale": "overruled"}},
	{"id": "ask_bag", "name": "{first} wants the heavy bag", "line": "\"I want to hit something. More bag.\"", "ask": true, "default": "b",
		"a": {"label": "More bag", "line": "Shadow, slip rope and speed bag mornings become heavy bag; morale up.",
			"swap": {"shadow": "heavy_bag", "slip_rope": "heavy_bag", "speed_bag": "heavy_bag"}, "morale": "heard"},
		"b": {"label": "Keep the plan", "line": "The week stays as planned; morale down.", "morale": "overruled"}},
]
## A no-choice card (the TWISTS) about one week in four; the rest are CHOICES.
const QUIET_SHARE := 0.25
## A rare card (short_notice) comes up this share of the weeks it can (its own dice, so the other draws stay as they were).
const RARE_SHARE := 0.12
## The southpaw partner's edge on the night against a southpaw (power points; PerkFight's Stiff jab is +3).
const LEFTY_EDGE := 1.5


static func card(id: String) -> Dictionary:
	for t in TWISTS + CHOICES + ASKS:
		if str(t["id"]) == id:
			return t
	return {}


## Her card with {first} filled in (S361: her asks speak in her name; the rest come back as they are).
static func card_for(f: Dictionary) -> Dictionary:
	var t := card(str(f.get("twist", "")))
	if not bool(t.get("ask", false)):
		return t
	return str_to_var(var_to_str(t).replace("{first}", str(f.get("first", "")))) as Dictionary


## The card for this week (week = the week number it is drawn for); never prev_id again. fight_week = her bout is inside the
## next 7 days: no card that takes a session away (S355: a head cold in fight week left the golden path's camp 0.05 kg over
## at the scale with no week left to answer it - luck at the weigh-in, not a choice).
## has = what her week holds for the CHOICES' needs ("bout", "cut", "combo", "southpaw").
static func draw(week: int, prev_id: String = "", fight_week: bool = false, has: Array = []) -> Dictionary:
	var rare_rng := RandomNumberGenerator.new()
	rare_rng.seed = week * 104729 + 3
	var rare_roll := rare_rng.randf()
	for t in CHOICES:
		if bool(t.get("rare", false)) and str(t["id"]) != prev_id and has.has(str(t["needs"])) and rare_roll < RARE_SHARE:
			return t
	var rng := RandomNumberGenerator.new()
	rng.seed = week * 7919 + 17
	var choices: Array = CHOICES.filter(func(t): return str(t["id"]) != prev_id and not bool(t.get("rare", false)) and (not t.has("needs") or has.has(str(t["needs"]))))
	if rng.randf() >= QUIET_SHARE and not choices.is_empty():
		return choices[rng.randi_range(0, choices.size() - 1)]
	var pool: Array = TWISTS.filter(func(t): return str(t["id"]) != prev_id and not (fight_week and t.has("rest_day")))
	return pool[rng.randi_range(0, pool.size() - 1)]


## Her answer to this week's card ("a" | "b"; the coach's default until there is one; "" for a no-choice card).
static func answer(f: Dictionary) -> String:
	var t := card_for(f)
	if not t.has("a"):
		return ""
	var a := str(f.get("twist_pick", ""))
	return a if a == "a" or a == "b" else str(t.get("default", "b"))


## The card with her answer's effects in it (a no-choice card as it is).
static func active(f: Dictionary) -> Dictionary:
	var t := card_for(f)
	var a := answer(f)
	return t if a == "" else t.merged(t[a] as Dictionary, true)


## The answer, until Monday runs (lock). Returns whether it took.
static func pick(f: Dictionary, a: String) -> bool:
	if bool(f.get("twist_locked", false)) or not card(str(f.get("twist", ""))).has(a):
		return false
	f["twist_pick"] = a
	return true


## Monday: the answer is fixed (the coach's when none) and its once-effects returned for the sim to apply.
static func lock(f: Dictionary) -> Dictionary:
	if bool(f.get("twist_locked", false)):
		return {}
	f["twist_locked"] = true
	var a := answer(f)
	if a == "":
		return {}
	f["twist_pick"] = a
	var e: Dictionary = active(f)
	var once := {}
	for k in ["cash", "morale", "rep", "members", "reveal", "lefty", "hot", "swap_opp", "withdraw"]:
		if e.has(k):
			once[k] = e[k]
	return once


## A new card for the week ahead: no answer yet.
static func deal(f: Dictionary, t: Dictionary) -> void:
	f["twist"] = str(t["id"])
	f.erase("twist_pick")
	f["twist_locked"] = false


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
	if t.has("morning_rest") and int(t["morning_rest"]) < out.size():
		out[int(t["morning_rest"])] = ["rest", "normal"]
	if bool(t.get("rest_hard", false)):
		for i in out.size():
			if str(out[i][1]) == "hard" and str(out[i][0]) != "rest":
				out[i] = ["rest", "normal"]
				break
	if bool(t.get("no_hard", false)):
		for i in out.size():
			if str(out[i][1]) == "hard":
				out[i] = [str(out[i][0]), "normal"]
	if bool(t.get("all_light", false)):
		for i in out.size():
			if str(out[i][0]) != "rest":
				out[i] = [str(out[i][0]), "light"]
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
	if t.has("evening_rest") and int(t["evening_rest"]) < out.size():
		out[int(t["evening_rest"])] = "rest"
	return out


## Whether the card changes anything in this week (a sore wrist in a week with no bag work does not).
static func touches(t: Dictionary, d: Array, evs: Array) -> bool:
	return days(t, d) != d or evenings(t, evs) != evs
