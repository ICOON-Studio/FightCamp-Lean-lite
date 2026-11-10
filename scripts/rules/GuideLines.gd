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
			return "Plan the week, then lock it in."   # S416 operator: "why start with cut weight immediately with no fight": no bout, no cut talk
		"go":
			return "Week's set. Press Continue and we go to work."
		"offer":
			if _misses_weight(c, f):
				return "%s won't make weight. Your call on the show." % who
			return "The show has asked for %s. Have a look." % who
		"prep":
			return _prep(f, who)
		"fight":
			# S419 operator: "explain what to do about the weight ?": the line says whether the scales are a problem.
			if _misses_weight(c, f):
				return "%s is over the limit. Set the diet to Cut." % who
			return "%s makes weight Friday, fights Saturday. Press Continue." % who
		"club":
			var done := FirstHour.tasks(c)
			for k in FirstHour.TASKS:
				if not bool(done[k]):
					var job := str(FirstHour.TASK_WORDS[k])
					return "Next job for the club: %s." % (job.left(1).to_lower() + job.substr(1))
	return "Press Continue. The review tells you how it went."


## S419 (operator: "the guide says open people ... from where do you find this people tab ? it has to be highlighted on
## the gym"): the gym place a step sends the player to; "" when the step is the Continue button or the guide is over.
static func place(c: Career) -> String:
	match c.guide:
		"sign":
			return "reception"
		"coach":
			return "office"
		"week", "prep":
			return "training"
		"fight":
			return "training" if _misses_weight(c, c.fighter()) else ""   # the diet is on the boxer's week
		"offer":
			return "fights"
	return ""


## The controls a step's light can ring on the open page. An empty list means the bubble's own button is the way.
static func target_names(c: Career) -> Array:
	var names: Array = _page_targets(c)
	var where := place(c)
	if where != "" and not names.has("Place_" + where):
		names.append("Place_" + where)   # on the gym picture the place itself is ringed
	return names


static func _page_targets(c: Career) -> Array:
	match c.guide:
		"sign":
			return ["Place_reception"]
		"coach":
			return ["Hire_reid", "Hire_hale"]
		"go":
			return ["Go"]
		"fight":
			return [] if _misses_weight(c, c.fighter()) else ["Go"]
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
