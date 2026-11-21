extends RefCounted
## THE COACH'S READ (S531; rebuilt S533 P4PBUILD1 stage 3, DESIGN_THREEP4P_V2 section 2): a decision, not an order.
## On a bout offer the coach says what this bout does to THIS boxer: any booking block first, then the strongest checked
## gain and the strongest checked cost, how much is known (1 to 3 marks: evidence, never a win chance), the read's own
## record, and the three answers each with its price in the game's own numbers. With no coach hired the same evidence is
## "Your estimate". Pure: CoachReadWire.facts hands in the facts; nothing here changes a bout.
##   read(facts) -> {verdict, tone "go"|"care"|"stop", guess, gain, cost, sure 1..3, sure_words, record, pick, choices}
## facts: gap (+ = your boxer the stronger), unsafe, rest (days since the last bout, -1 none), over (kg over at the
## weigh-in, 0 = makes it), hot, streak_words, rank_now / rank_win (place now and after a win, 0 none), goal_needs_bout,
## goal_days, coach, game_known, game_place (words), answer (the plan's line there, "" none), answer_ready, lo / hi (the win
## range, -1 unknown), days_out, booked_morale, pass_price, duck, idle_weeks / idle_at / idle_price, later_days (-1 none),
## later_rest, reads_right / reads_of.

const EVEN := 3          # BoutCompare.EVEN: within this the bout is even
const UNEVEN := 7        # BoutCompare.UNEVEN: past this it is a mismatch
const SHORT_REST := 21   # days: under three weeks since the last bout is quick for an amateur
const HEAVY_CUT := 2.0   # kg over at the weigh-in the coach will not send a boxer into
const WIDE := 0.30       # a win range this wide is still a rough guess
const NARROW := 0.20
const RECORD_MIN := 3    # resolved reads before the record is shown
const RECORD_KEEP := 15
const NO_GAIN := "No confirmed gain"
const NO_COST := "No confirmed cost"


static func read(x: Dictionary) -> Dictionary:
	var gap := int(x.get("gap", 0))
	var unsafe := bool(x.get("unsafe", false))
	var rest := int(x.get("rest", -1))
	var over := float(x.get("over", 0.0))
	var short_rest := rest >= 0 and rest < SHORT_REST
	var known := bool(x.get("game_known", false))
	var answer := str(x.get("answer", ""))
	var place := str(x.get("game_place", ""))
	var costs: Array = []
	if unsafe:
		costs.append("not safe: the federation will not sanction it")
	if over >= HEAVY_CUT:
		costs.append("%.1f kg over at the weigh-in, even cutting from tomorrow" % over)
	if short_rest:
		costs.append("only %d days since the last bout; %d is comfortable" % [rest, SHORT_REST])
	if gap <= -UNEVEN:
		costs.append("your boxer is the weaker by a distance (%d)" % gap)
	elif gap < -EVEN:
		costs.append("the opponent is the stronger (%d): a real risk of losing" % gap)
	if known and answer == "":
		costs.append("the plan has no line for where the opponent takes the bout (%s)" % place)
	elif known and not bool(x.get("answer_ready", false)):
		costs.append("the plan's line there (%s) is not sharp enough to come off yet" % answer)
	if over > 0.0 and over < HEAVY_CUT:
		costs.append("a small cut to make (%.1f kg)" % over)
	if gap >= UNEVEN:
		costs.append("little to learn from it")
	var gains: Array = []
	var rank_now := int(x.get("rank_now", 0))
	var rank_win := int(x.get("rank_win", 0))
	if rank_win > 0 and (rank_now == 0 or rank_win < rank_now):   # only a place the table's own forecast gives
		gains.append("a win takes place %d on the ladder%s" % [rank_win, " (from %d)" % rank_now if rank_now > 0 else ""])
	if bool(x.get("goal_needs_bout", false)) and int(x.get("goal_days", -1)) >= 0:
		gains.append("the goal needs a bout booked: %d days left" % int(x["goal_days"]))
	if known and answer != "" and bool(x.get("answer_ready", false)):
		gains.append("the opponent's game is known and the plan has %s ready for it" % answer)
	if bool(x.get("hot", false)):
		gains.append(str(x.get("streak_words", "on a run")).to_lower().trim_suffix("."))
	if absi(gap) <= EVEN:
		gains.append("an even bout: the kind that teaches")
	elif gap > EVEN:
		gains.append("your boxer is the stronger (+%d)" % gap)
	if unsafe:   # a bout that cannot be sanctioned gains nothing
		gains.clear()
	var later_ok := int(x.get("later_days", -1)) > 0
	var verdict := "Take it"
	var tone := "go"
	var pick := "accept"
	if unsafe:
		verdict = "Pass this one"
		tone = "stop"
		pick = "pass"
	elif over >= HEAVY_CUT:   # never a recommendation to box at a weight the boxer will miss
		verdict = "Look for a later date"
		tone = "care"
		pick = "later" if later_ok else "pass"
	elif gap <= -UNEVEN:
		verdict = "Too soon"
		tone = "stop"
		pick = "pass"
	elif short_rest:
		verdict = "Look for a later date" if later_ok else "Take it with care"
		tone = "care"
		pick = "later" if later_ok else "accept"
	elif gap < -EVEN:
		verdict = "A step up: take it knowing the risk"
		tone = "care"
	elif gap >= UNEVEN:
		verdict = "An easy night"
	var sure := _sure(known, float(x.get("lo", -1.0)), float(x.get("hi", -1.0)))
	var of := int(x.get("reads_of", 0))
	return {"verdict": verdict, "tone": tone, "guess": not bool(x.get("coach", true)), "pick": pick,
		"gain": str(gains[0]) if not gains.is_empty() else NO_GAIN, "cost": str(costs[0]) if not costs.is_empty() else NO_COST,
		"sure": int(sure[0]), "sure_words": "How sure: %d of 3 (%s)" % [int(sure[0]), str(sure[1])],
		"record": "Read right %d of the last %d" % [int(x.get("reads_right", 0)), of] if of >= RECORD_MIN else "",
		"choices": choices(x, pick)}


## How much is known, 1 to 3: evidence coverage, never a win chance.
static func _sure(known: bool, lo: float, hi: float) -> Array:
	if not known:
		return [1, "the opponent's game is not known yet"]
	if lo < 0.0 or hi < 0.0:
		return [2, "known game, no win range yet"]
	if hi - lo >= WIDE:
		return [1, "the win range is still wide"]
	if hi - lo < NARROW:
		return [3, "known game, narrow win range"]
	return [2, "known game, some range left"]


## The three answers and what each costs, in the game's own numbers. [{id, label, price, pick}]
static func choices(x: Dictionary, pick: String) -> Array:
	var needs := bool(x.get("goal_needs_bout", false))
	var idle := int(x.get("idle_weeks", 0))
	var idle_at := int(x.get("idle_at", 4))
	var acc: Array = []
	if bool(x.get("unsafe", false)):
		acc.append("not allowed: the pair is not safe")
	else:
		acc.append("a bout in %d days" % int(x.get("days_out", 0)))
		if int(x.get("booked_morale", 0)) != 0:
			acc.append("morale %+d" % int(x["booked_morale"]))
		if needs:
			acc.append("the goal's bout is booked")
		if idle > 0:
			acc.append("the no-bout count restarts")
	var pas: Array = []
	if int(x.get("pass_price", 0)) != 0:
		pas.append("loyalty %+d" % int(x["pass_price"]))
	if bool(x.get("duck", false)):
		pas.append("counts as a duck")
	if not bool(x.get("unsafe", false)) or idle > 0:
		pas.append("no bout booked: week %d of %d, then loyalty %+d" % [mini(idle + 1, idle_at), idle_at, int(x.get("idle_price", -3))])
	if needs and int(x.get("goal_days", -1)) >= 0:
		pas.append("the goal still needs a bout, %d days left" % int(x["goal_days"]))
	if pas.is_empty():
		pas.append("costs nothing")
	var lat: Array = []
	if int(x.get("later_days", -1)) > 0:
		lat.append("pass, then ask for a show in %d days on Fights" % int(x["later_days"]))
		lat.append("%d more days of rest" % int(x.get("later_rest", 0)))
		lat.append("the other corner may say no")
	else:
		lat.append("no later show can be asked for now")
	var out: Array = []
	for row in [["accept", "Accept", acc], ["pass", "Pass", pas], ["later", "Later", lat]]:
		out.append({"id": row[0], "label": row[1], "price": "; ".join(row[2] as Array), "pick": str(row[0]) == pick})
	return out


## One line for the card: 'Coach: "Take it." Gain: ... Cost: ...' (or 'Your estimate: ...'). No names (S448).
static func line(r: Dictionary, _coach_name: String = "") -> String:
	var head := ("Your estimate: %s." % r["verdict"]) if bool(r["guess"]) else ("Coach: \"%s.\"" % r["verdict"])
	return "%s  Gain: %s.  Cost: %s." % [head, r["gain"], r["cost"]]


## A pro row's read: the same shape, with the pro game's own stakes. x: mid / lo / hi (win chance 0..1), scouted, duck,
## stop (the chance of being stopped 0..1), takes (what a win brings, the row's own words), guess.
static func pro_read(x: Dictionary) -> Dictionary:
	var mid := float(x.get("mid", 0.5))
	var stop := float(x.get("stop", 0.0))
	var verdict := "A close one"
	var tone := "care"
	if mid >= 0.65:
		verdict = "Should win"
		tone = "go"
	elif mid < 0.4:
		verdict = "A hard ask"
		tone = "stop"
	var costs: Array = []
	if mid < 0.5:
		costs.append("more likely lost than won (%d%%)" % roundi(mid * 100.0))
	if stop >= 0.07:
		costs.append("a %d%% chance of being stopped" % roundi(stop * 100.0))
	if bool(x.get("duck", false)):
		costs.append("passing it counts as ducking the step up")
	var wide := float(x.get("hi", 1.0)) - float(x.get("lo", 0.0))
	var sure: Array = [1, "not scouted"] if not bool(x.get("scouted", false)) else ([3, "scouted, narrow win range"] if wide < NARROW else [2, "scouted, some range left"])
	var takes := str(x.get("takes", ""))
	return {"verdict": verdict, "tone": tone, "guess": bool(x.get("guess", false)), "gain": takes.to_lower() if takes != "" else NO_GAIN,
		"cost": str(costs[0]) if not costs.is_empty() else NO_COST, "sure": int(sure[0]), "sure_words": "How sure: %d of 3 (%s)" % [int(sure[0]), str(sure[1])]}
