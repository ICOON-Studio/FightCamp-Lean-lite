extends RefCounted
## S387 the forced first week (operator "Yes, build 1-3"; ops/research/MENU_CRITIC_S386.md item 1, first hour 3/10): a new career
## opens on the boxer, then sign -> hire the coach -> set week 1 -> CONTINUE. Career.guide holds the step ("" = no guide: a save
## from before this, a veteran's skip, or a finished first week). Each unfinished step is a red need, so CONTINUE itself reads
## NEEDS YOU and takes the player to it. Ana (the no-gi grappler) joins at the end of week 1 (operator S353: BJJ stays).

const NoGi := preload("res://scripts/rules/NoGi.gd")

const STEPS := ["sign", "coach", "week", "go"]
const PREFS := "user://prefs.cfg"


## A new career under the guide, unless the player turned it off on the title.
static func begin(c: Career) -> void:
	c.guide = "" if skip_on() else "sign"


## Moves the guide on from what is true now. Safe to call any time.
static func sync(c: Career) -> void:
	if c.guide == "sign" and c.applicant.is_empty() and not c.fighters.is_empty():
		c.guide = "coach"
	if c.guide == "coach" and not c.coach.is_empty():
		c.guide = "week"


static func index(c: Career) -> int:
	return STEPS.find(c.guide)


## The player confirms the week on the fighter's Training tab.
static func set_week(c: Career) -> void:
	if c.guide == "week":
		c.guide = "go"


static func skip(c: Career) -> void:
	c.guide = ""


## The step's need for Needs.needs ({} when nothing blocks time). The sign step needs no row of its own: the walk-in at reception
## is already a red need.
static func need(c: Career) -> Dictionary:
	sync(c)
	match c.guide:
		"coach":
			return {"red": true, "t": "Hire a coach", "s": "first week: %s needs a coach before week 1" % str(c.fighter().get("first", "the boxer")),
				"act": "go", "arg": "gym:1", "label": "Staff"}
		"week":
			return {"red": true, "t": "Set week 1", "s": "first week: check the plan, then lock it in",
				"act": "guideweek", "arg": "", "label": "Set the week"}
	return {}


## The end of a week (Sim, after the report is written): the guide is over and Ana walks in. The check is on the week, so a skipped
## guide gets her at the same moment.
static func end_of_week(c: Career, week: int) -> void:
	if week != 1:
		return
	c.guide = ""
	ana_joins(c)


static func ana_joins(c: Career) -> void:
	if not c.grapplers.is_empty():
		return
	c.grapplers = [NoGi.athlete()]
	c.add_news("%s, a no-gi grappler, asks to train at %s. The mat is open." % [c.grapplers[0]["name"], c.gym_name])


static func skip_on() -> bool:
	var cfg := ConfigFile.new()
	return cfg.load(PREFS) == OK and bool(cfg.get_value("guide", "skip", false))


static func set_skip(on: bool) -> void:
	var cfg := ConfigFile.new()
	cfg.load(PREFS)
	cfg.set_value("guide", "skip", on)
	cfg.save(PREFS)
