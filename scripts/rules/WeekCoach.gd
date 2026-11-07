extends RefCounted
## S356 the coach's one line on the whiteboard (operator Q-S294-84 "Yes, build it", the Miro "Whiteboard planner" mockup:
## "Thursday's in the red. Swap the bag for pads and still makes weight."): the most urgent change to this week, in his
## words, from the numbers the board already shows. Order: a day in the red (fatigue 80+ or two Hard mornings in a row), the
## weight line, the camp's stat line; else the week lands and he says leave it.
##   line(days, wk, lines, diet) -> String   (days = the week shown; wk = WeekPlan.week; lines = WeekPlan.goal_lines)
##   advice(days, wk, lines, diet) -> {say, fix, short}   fix = {dow, card} (one morning), {diet} or {} (S397: the board's Apply)
## Pure static.

const WeekPlan := preload("res://scripts/rules/WeekPlan.gd")

const DAY_NAMES := ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
## The session that builds each stat (the one he names when a line falls short).
const BUILDER := {"conditioning": "roadwork", "power": "heavy bag", "speed": "speed bag", "defense": "slip rope",
	"technique": "shadow boxing", "chin": "neck work", "fight_iq": "sparring"}
## The morning sessions that build each stat (WeekPhase.SESSIONS keys), the first one his pick when none is on the week.
const BUILDS := {"conditioning": ["roadwork", "intervals"], "power": ["heavy_bag", "strength"], "speed": ["speed_bag"],
	"defense": ["slip_rope"], "technique": ["shadow"], "chin": ["neck"]}


static func line(days: Array, wk: Dictionary, lines: Array, diet: String) -> String:
	return str(advice(days, wk, lines, diet)["say"])


## S397 blind Week critic ("Make one roadwork morning Hard" - which one? and no button): the line names the day, and fix
## is the change the board's Apply makes. The gap is said in words ("a little short"); short carries the number for the hover.
static func advice(days: Array, wk: Dictionary, lines: Array, diet: String) -> Dictionary:
	var red := -1
	for i in (wk.get("days", []) as Array).size():
		if float(wk["days"][i]["fatigue"]) >= WeekPlan.OVERREACHED or (wk.get("red", []) as Array).has(i):
			red = i
			break
	if red >= 0:
		var s := str(WeekPlan.session(str(days[red][0]))["name"]).to_lower()
		var down: Dictionary = {} if str(days[red][1]) == "light" else {"dow": red, "card": [str(days[red][0]), "light"]}
		return {"say": "%s's in the red. Take the %s down to Light, or rest it." % [DAY_NAMES[red], s], "fix": down, "short": 0.0}
	for ln in lines:
		if str(ln["id"]) == "weight" and not bool(ln["ok"]):
			var kg := float(ln["short"])
			if diet != "cut":
				# S396 blind review: a forecast, not a fact - she is under the limit today and the week puts her over it.
				return {"say": "This week ends %.1f kg over the limit. Switch the diet to Cut." % kg, "fix": {"diet": "cut"}, "short": kg}
			var hd := harder(days, "conditioning")
			return {"say": "Still %.1f kg over on a cut. %s." % [kg, _do(days, hd, "roadwork")], "fix": hd, "short": kg}
	for ln in lines:
		var id := str(ln["id"])
		if id != "weight" and id != "fatigue" and id != "opp" and not bool(ln["ok"]):
			var gap := float(ln["short"])
			var hd := harder(days, id)
			return {"say": "%s lands %s. %s." % [str(ln["label"]), gap_words(gap), _do(days, hd, str(BUILDER.get(id, "training")))],
				"fix": hd, "short": gap}
	# S360 (Q-S294-90, "the coach plans the camp, you plan the fight"): the opponent's line (WeekOpp) is the player's call.
	for ln in lines:
		if str(ln["id"]) == "opp" and not bool(ln["ok"]):
			return {"say": "My lines all land. %s is your call - you watched the tape." % str(ln["label"]).trim_prefix("vs "), "fix": {}, "short": 0.0}
	return {"say": "The week lands on every line. Leave it.", "fix": {}, "short": 0.0}


static func gap_words(short: float) -> String:
	return "a little short" if short < 0.5 else ("short" if short < 1.5 else "well short")


## The morning he would make Hard for a stat: the first of its sessions not Hard already and with no Hard day beside it
## (two in a row is the red), else the first such skill morning turned into its session; {} when none fits.
static func harder(days: Array, stat: String) -> Dictionary:
	var keys: Array = BUILDS.get(stat, [])
	if keys.is_empty():
		return {}
	var free := func(i: int) -> bool:
		return str(days[i][1]) != "hard" and str(days[i][0]) != "rest" 			and (i == 0 or str(days[i - 1][1]) != "hard") and (i == days.size() - 1 or str(days[i + 1][1]) != "hard")
	for i in days.size():
		if keys.has(str(days[i][0])) and free.call(i):
			return {"dow": i, "card": [str(days[i][0]), "hard"]}
	for i in days.size():
		if free.call(i):
			return {"dow": i, "card": [str(keys[0]), "hard"]}
	return {}


## The change in his words: "Make Saturday's roadwork Hard", "Swap Tuesday's heavy bag for Hard roadwork", or without a
## fix "Make one roadwork morning Hard".
static func _do(days: Array, fix: Dictionary, session: String) -> String:
	if fix.is_empty():
		return "Make one %s morning Hard" % session
	var i := int(fix["dow"])
	var was := str(days[i][0])
	var now := str(WeekPlan.session(str(fix["card"][0]))["name"]).to_lower()
	if was == str(fix["card"][0]):
		return "Make %s's %s Hard" % [DAY_NAMES[i], now]
	return "Swap %s's %s for Hard %s" % [DAY_NAMES[i], str(WeekPlan.session(was)["name"]).to_lower(), now]
