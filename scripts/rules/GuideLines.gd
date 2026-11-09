extends RefCounted
## S413 operator, Q-S294-140 "Yes, build him"; S411 "the guide text is very weak": the first hour's guide as a person. An old trainer
## says one short line. Every line is under 12 words, uses the boxer's name and never a he or she (operator S412, sandbox).
## Pure: reads the career, changes nothing. The numbers behind a line stay in FirstWeekStrip.why (the bubble's tooltip).
##   line(c) -> String     target_names(c, weight_ok) -> [node names to ring, first found wins]

const FirstHour := preload("res://scripts/rules/FirstHour.gd")
const Sim := preload("res://scripts/state/Sim.gd")

const MAX_WORDS := 11


static func line(c: Career) -> String:
	var f := c.fighter()
	var who := str(c.applicant.get("first", f.get("first", "the boxer")))
	match c.guide:
		"sign":
			if c.applicant.is_empty():
				return "Nobody at the desk. Go and find a fighter."
			return "%s is at the desk. Go and talk." % who
		"coach":
			return "You can't hold every pad. Get yourself an assistant."
		"week":
			var over := float(f.get("weight", 0.0)) - float(f.get("limit", 99.0))
			if over > 0.0 and str(f.get("diet", "")) != "cut":
				return "%s is %.1f kilos over. Start the cut this week." % [who, over]
			return "Plan the week, then lock it in."
		"go":
			return "Week's set. Press Continue and we go to work."
		"offer":
			if _misses_weight(c, f):
				return "%s won't make weight. Your call on the show." % who
			return "The show has asked for %s. Have a look." % who
		"prep":
			return _prep(f, who)
		"fight":
			return "Scales Friday, fight Saturday. Press Continue."
		"club":
			var done := FirstHour.tasks(c)
			for k in FirstHour.TASKS:
				if not bool(done[k]):
					var job := str(FirstHour.TASK_WORDS[k])
					return "Next job for the club: %s." % (job.left(1).to_lower() + job.substr(1))
	return "Press Continue. The review tells you how it went."


## The controls a step's light can ring on the open page. An empty list means the bubble's own button is the way.
static func target_names(c: Career) -> Array:
	match c.guide:
		"sign":
			return ["Place_reception"]
		"coach":
			return ["Hire_reid", "Hire_hale"]
		"go", "fight":
			return ["Go"]
		"offer":
			return ["Accept", "GuideHomeAction"]
		"prep":
			return ["SetCamp"] if (c.fighter().get("camp", {}) as Dictionary).is_empty() else []
	return []


static func _misses_weight(c: Career, f: Dictionary) -> bool:
	if f.is_empty() or float(f["weight"]) <= float(f["limit"]):
		return false
	return not bool(Sim.weigh_forecast(c, f, FirstHour.SHOW_DAY)["ok"])


static func _prep(f: Dictionary, who: String) -> String:
	var bout: Dictionary = f.get("bout", {})
	var opp := str((bout.get("opp", {}) as Dictionary).get("first", "the opponent"))
	if (f.get("camp", {}) as Dictionary).is_empty():
		return "%s needs a camp before %s." % [who, opp]
	if (f.get("arrows", []) as Array).is_empty():
		return "Write one line against %s. Your plan, not mine." % opp
	return "Good. Press Continue and we go to work."
