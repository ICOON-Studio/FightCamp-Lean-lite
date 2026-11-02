extends RefCounted
## S356 the coach's one line on the whiteboard (operator Q-S294-84 "Yes, build it", the Miro "Whiteboard planner" mockup:
## "Thursday's in the red. Swap the bag for pads and still makes weight."): the most urgent change to this week, in his
## words, from the numbers the board already shows. Order: a day in the red (fatigue 80+ or two Hard mornings in a row), the
## weight line, the camp's stat line; else the week lands and he says leave it.
##   line(days, wk, lines, diet) -> String   (days = the week shown; wk = WeekPlan.week; lines = WeekPlan.goal_lines)
## Pure static.

const WeekPlan := preload("res://scripts/rules/WeekPlan.gd")

const DAY_NAMES := ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
## The session that builds each stat (the one he names when a line falls short).
const BUILDER := {"conditioning": "roadwork", "power": "heavy bag", "speed": "speed bag", "defense": "slip rope",
	"technique": "shadow boxing", "chin": "neck work", "fight_iq": "sparring"}


static func line(days: Array, wk: Dictionary, lines: Array, diet: String) -> String:
	var red := -1
	for i in (wk.get("days", []) as Array).size():
		if float(wk["days"][i]["fatigue"]) >= WeekPlan.OVERREACHED or (wk.get("red", []) as Array).has(i):
			red = i
			break
	if red >= 0:
		var s := str(WeekPlan.session(str(days[red][0]))["name"]).to_lower()
		return "%s's in the red. Take the %s down to Light, or rest it." % [DAY_NAMES[red], s]
	for ln in lines:
		if str(ln["id"]) == "weight" and not bool(ln["ok"]):
			if diet != "cut":
				return "She's %.1f kg over at the weigh-in. Switch the diet to Cut." % float(ln["short"])
			return "Still %.1f kg over on a cut. Make one roadwork morning Hard." % float(ln["short"])
	for ln in lines:
		var id := str(ln["id"])
		if id != "weight" and id != "fatigue" and id != "opp" and not bool(ln["ok"]):
			return "%s lands %.1f short. Make one %s morning Hard." % [str(ln["label"]), float(ln["short"]), BUILDER.get(id, "training")]
	# S360 (Q-S294-90, "the coach plans the camp, you plan the fight"): the opponent's line (WeekOpp) is the player's call.
	for ln in lines:
		if str(ln["id"]) == "opp" and not bool(ln["ok"]):
			return "My lines all land. %s is your call - you watched the tape." % str(ln["label"]).trim_prefix("vs ")
	return "The week lands on every line. Leave it."
