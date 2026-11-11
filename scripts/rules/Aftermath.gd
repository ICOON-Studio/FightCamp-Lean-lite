extends RefCounted
## S430 what the fight did to the boxer (operator: "after each fight it should show a summary of the damage on the fighter
## what he learned, morale effected etc"). Pure: the result page shows these five tiles from a snapshot taken before the
## result was booked and one taken after (state/AfterFight.gd takes them).
##   tiles(before, after, facts) -> [{id, title, big, small, tone, lines}]
## before / after = {morale, mood, rank, cap, notes: [words]}
## facts = {first, opp, outcome, stopped, took, took_body, counts, worst: {place, value} or {}, injury, calls: {right,
##          wrong, ignored}, goal: "" | "met" | "missed", goal_title, rank_words, learned: [words], next_days}
## tone: "good" | "bad" | "flat". lines = everything behind the tile, for the hover.

const BodyMap := preload("res://scripts/rules/BodyMap.gd")

const PLACE_WORDS := {"head": "Head", "left_eye": "Left eye", "right_eye": "Right eye", "nose": "Nose",
	"left_ribs": "Left ribs", "right_ribs": "Right ribs"}


## S430 what a fight leaves in the legs (operator: "after the fight i need to clearly see ... his stamina level to figure
## out how long i need to rest him and plan his next training"; before this a fight cost no tiredness at all, so there was
## nothing to rest from). ESTIMATE, to be measured over a year (FIGHTTOLL1): a boxer who finishes with a full tank is at 45
## (a day off), with 60 left at 65 (two rest days), with 30 left at 80 (four); a stoppage loss adds ten. Tiredness is the
## week plan's own number (week_fatigue), so rest days bring it down at the plan's rate and training on it costs what the
## plan already charges (over 80 the next morning counts 60%).
const TOLL_BASE := 45.0
const TOLL_PER_TANK := 0.5
const TOLL_STOPPED := 10.0
const TOLL_MAX := 95.0
const FRESH_UNDER := 50.0
const REST_KEEP := 0.87   # WeekPlan.FATIGUE_KEEP: what a full rest day leaves


static func toll(before: float, tank_end: float, stopped_loss: bool) -> float:
	var after := TOLL_BASE + (100.0 - clampf(tank_end, 0.0, 100.0)) * TOLL_PER_TANK + (TOLL_STOPPED if stopped_loss else 0.0)
	return clampf(maxf(before, after), 0.0, TOLL_MAX)


## Full rest days until the boxer reads Fresh again (0 when already fresh).
static func rest_days(fatigue: float) -> int:
	var n := 0
	while fatigue >= FRESH_UNDER and n < 21:
		fatigue *= REST_KEEP
		n += 1
	return n


static func tired_word(fatigue: float) -> String:
	if fatigue >= 80.0:
		return "Spent"
	if fatigue >= 70.0:
		return "Tired"
	if fatigue >= FRESH_UNDER:
		return "Needs a rest"
	return "Fresh"


static func tiles(before: Dictionary, after: Dictionary, facts: Dictionary) -> Array:
	return [damage(before, after, facts), tired(after, facts), learned(facts), morale(before, after, facts), corner(facts),
		rank(before, after, facts)]


static func tired(after: Dictionary, facts: Dictionary) -> Dictionary:
	var v := float(after.get("fatigue", 20.0))
	var days := rest_days(v)
	var first := str(facts.get("first", "The boxer"))
	var lines: Array = []
	if days == 0:
		lines.append("%s is fresh: back to normal training tomorrow." % first)
	else:
		lines.append("About %d rest day%s until %s is fresh." % [days, "" if days == 1 else "s", first])
		lines.append("Hard training before that counts for less and risks an injury. Set the week on the Training tab.")
	return {"id": "tired", "title": "TIREDNESS", "big": "%d of 100" % int(round(v)), "small": str(lines[0]),
		"tone": "good" if days == 0 else ("bad" if v >= 80.0 else "flat"), "lines": lines, "word": tired_word(v)}


static func damage(before: Dictionary, after: Dictionary, facts: Dictionary) -> Dictionary:
	var first := str(facts.get("first", "The boxer"))
	var lines: Array = []
	var took := int(facts.get("took", 0))
	var body := int(facts.get("took_body", 0))
	lines.append("Took %d punch%s, %d to the body." % [took, "" if took == 1 else "es", body])
	var counts := int(facts.get("counts", 0))
	if counts > 0:
		lines.append("%d count%s from the referee." % [counts, "" if counts == 1 else "s"])
	var big := "Nothing lasting"
	var tone := "good"
	var worst: Dictionary = facts.get("worst", {})
	if not worst.is_empty() and float(worst.get("value", 100.0)) < BodyMap.HURT:
		var bad := float(worst["value"]) < BodyMap.CRITICAL
		big = "%s %s" % [str(PLACE_WORDS.get(str(worst["place"]), "Body")), "badly hurt" if bad else "sore"]
		tone = "bad" if bad else "flat"
		lines.append("%s: %d of 100 left at the final bell." % [str(PLACE_WORDS.get(str(worst["place"]), "Body")), int(round(float(worst["value"])))])
	var injury := str(facts.get("injury", ""))
	if injury != "":
		big = "Injured"
		tone = "bad"
		lines.push_front(injury)
	if float(after.get("cap", 0.0)) < float(before.get("cap", 0.0)) - 0.01:
		tone = "bad"
		lines.append("The stoppage left its mark: %s takes a punch a little worse from now on." % first)
	return {"id": "damage", "title": "DAMAGE", "big": big, "small": str(lines[0]), "tone": tone, "lines": lines}


static func learned(facts: Dictionary) -> Dictionary:
	var lines: Array = (facts.get("learned", []) as Array).duplicate()
	if lines.is_empty():
		return {"id": "learned", "title": "LEARNED", "big": "Nothing new", "small": "No new note from the corner this time.",
			"tone": "flat", "lines": ["No new note from the corner this time."]}
	return {"id": "learned", "title": "LEARNED", "big": "%d new" % lines.size(), "small": str(lines[0]), "tone": "good", "lines": lines}


static func morale(before: Dictionary, after: Dictionary, facts: Dictionary) -> Dictionary:
	var was := int(round(float(before.get("morale", 60.0))))
	var now := int(round(float(after.get("morale", 60.0))))
	var d := now - was
	var first := str(facts.get("first", "The boxer"))
	var opp := str(facts.get("opp", "the opponent"))
	var lines: Array = []
	var mood_was := str(before.get("mood", ""))
	var mood_now := str(after.get("mood", ""))
	lines.append("Morale %d to %d: %s." % [was, now, mood_now if mood_was == mood_now else "%s to %s" % [mood_was, mood_now]])
	var outcome := str(facts.get("outcome", ""))
	if outcome == "win":
		lines.append("Beat %s." % opp)
	elif outcome == "loss":
		lines.append("Lost to %s%s." % [opp, " inside the distance" if str(facts.get("stopped", "")) != "" else ""])
	var calls: Dictionary = facts.get("calls", {})
	if int(calls.get("right", 0)) > 0:
		lines.append("Your calls worked: %s trusts the corner more." % first)
	if int(calls.get("wrong", 0)) > 0:
		lines.append("Calls that went wrong cost some of %s's trust." % first)
	var goal := str(facts.get("goal", ""))
	if goal != "":
		lines.append("The goal \"%s\" was %s." % [str(facts.get("goal_title", "")), goal])
	return {"id": "morale", "title": "MORALE", "big": "%s%d" % ["+" if d > 0 else "", d] if d != 0 else "No change",
		"small": str(lines[0]), "tone": "good" if d > 0 else ("bad" if d < 0 else "flat"), "lines": lines}


static func corner(facts: Dictionary) -> Dictionary:
	var calls: Dictionary = facts.get("calls", {})
	var right := int(calls.get("right", 0))
	var wrong := int(calls.get("wrong", 0))
	var ignored := int(calls.get("ignored", 0))
	var said := right + wrong
	if said + ignored == 0:
		return {"id": "corner", "title": "YOUR CORNER", "big": "Said nothing", "small": "The plan ran the fight.",
			"tone": "flat", "lines": ["No shout that mattered: the plan ran the fight."]}
	var lines: Array = ["%d call%s worked, %d went wrong." % [right, "" if right == 1 else "s", wrong]]
	if ignored > 0:
		lines.append("%d call%s not taken in." % [ignored, "" if ignored == 1 else "s"])
	return {"id": "corner", "title": "YOUR CORNER", "big": "%d of %d" % [right, said] if said > 0 else "Not heard", "small": str(lines[0]),
		"tone": "good" if right > wrong else ("bad" if wrong > right or said == 0 else "flat"), "lines": lines}


static func rank(before: Dictionary, after: Dictionary, facts: Dictionary) -> Dictionary:
	var was := int(before.get("rank", 0))
	var now := int(after.get("rank", 0))
	var words := str(facts.get("rank_words", ""))
	var lines: Array = []
	if words != "":
		lines.append(words)
	var days := int(facts.get("next_days", 0))
	if days > 0:
		lines.append("The next offer comes in about %d days." % days)
	if lines.is_empty():
		lines.append("No ranking yet.")
	var tone := "flat"
	if now > 0 and (was == 0 or now < was):
		tone = "good"
	elif was > 0 and (now == 0 or now > was):
		tone = "bad"
	return {"id": "rank", "title": "RANK", "big": "No. %d" % now if now > 0 else "Unranked", "small": str(lines[0]), "tone": tone,
		"lines": lines}
