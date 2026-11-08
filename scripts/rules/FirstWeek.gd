extends RefCounted
## S387 the forced first week (operator "Yes, build 1-3"; ops/research/MENU_CRITIC_S386.md item 1, first hour 3/10): a new career
## opens on Home (S388, operator: "the game wshould open on home"), then sign -> hire the coach -> set week 1 -> CONTINUE. Career.guide holds the step ("" = no guide: a save
## from before this, a veteran's skip, or a finished first hour). Each unfinished first-week step is a red need, so CONTINUE itself
## reads NEEDS YOU and takes the player to it.
## S397 rank 5 (ops/research/RANK5_FIRST_HOUR_S397.md): the guide runs on to the first Why, then three club tasks, in three
## stages: FIRST WEEK (sign, coach, week, go), FIRST FIGHT (offer, prep, fight), THE CLUB (club: FirstHour.TASKS). Only the
## first week's steps block time; the later ones are pins and a strip line, never a pop-up, and every one can be done out of
## order (the guide follows what is true). Ana (the no-gi grappler) is a first-hour teaser and joins after the club's second
## bout (FirstHour.monday; was the end of week 1, critics S397 point 11).

const NoGi := preload("res://scripts/rules/NoGi.gd")
const FirstHour := preload("res://scripts/rules/FirstHour.gd")
const Data := preload("res://scripts/state/Data.gd")

const STEPS := ["sign", "coach", "week", "go", "offer", "prep", "fight", "club"]
const STAGES := [["FIRST WEEK", ["sign", "coach", "week", "go"]], ["FIRST FIGHT", ["offer", "prep", "fight"]], ["THE CLUB", ["club"]]]
const PREFS := "user://prefs.cfg"


## A new career under the guide, unless the player turned it off on the title. The first hour's dates run either way.
static func begin(c: Career) -> void:
	c.guide = "" if skip_on() else "sign"
	FirstHour.begin(c)


## Moves the guide on from what is true now. Safe to call any time.
static func sync(c: Career) -> void:
	# TASK GUIDEFLAG2: a saved career past week 8 with a stale guide loses it on sync.
	if c.day >= 56 and c.guide != "":
		c.guide = ""
		return
	if c.guide == "sign" and c.applicant.is_empty() and not c.fighters.is_empty():
		c.guide = "coach"
	if c.guide == "coach" and not c.coach.is_empty():
		c.guide = "week"
	var f := c.fighter()
	if c.guide == "offer" and not f.is_empty() and (not (f.get("bout", {}) as Dictionary).is_empty() or bool(c.first_hour.get("fought", false))):
		c.guide = "prep"
	if c.guide == "prep" and (bool(c.first_hour.get("fought", false)) or _prepped(f) or _weighed(f)):
		c.guide = "fight"
	if c.guide == "fight" and bool(c.first_hour.get("fought", false)):
		c.guide = "club"
	if c.guide == "club" and FirstHour.tasks_left(c) == 0:
		c.guide = ""


static func _prepped(f: Dictionary) -> bool:
	return not (f.get("camp", {}) as Dictionary).is_empty() and not (f.get("arrows", []) as Array).is_empty()


static func _weighed(f: Dictionary) -> bool:
	return bool((f.get("bout", {}) as Dictionary).get("weighed", false))


static func index(c: Career) -> int:
	return STEPS.find(c.guide)


## The stage the step is in: [title, steps]; [] when no guide.
static func stage(c: Career) -> Array:
	for s in STAGES:
		if (s[1] as Array).has(c.guide):
			return s
	return []


## The player confirms the week on the fighter's Training tab.
static func set_week(c: Career) -> void:
	if c.guide == "week":
		c.guide = "go"


static func skip(c: Career) -> void:
	c.guide = ""


## The step's need for Needs.needs ({} when nothing is due). The sign step needs no row of its own: the walk-in at reception
## is already a red need; so is the offer and the weigh-in. Prep is an amber pin: CONTINUE still runs.
static func need(c: Career) -> Dictionary:
	sync(c)
	var f := c.fighter()
	var who := str(f.get("first", "the boxer"))
	match c.guide:
		"coach":
			return {"red": true, "t": "Hire an assistant coach", "s": "first week: %s needs a coach in the gym every session before week 1" % who,
				"act": "go", "arg": "gym:1", "label": "Staff"}
		"week":
			return {"red": true, "t": "Set week 1", "s": "first week: check the plan, then lock it in",
				"act": "guideweek", "arg": "", "label": "Set the week"}
		"prep":
			if not (f.get("bout", {}) as Dictionary).is_empty():
				return {"red": false, "t": "Prepare %s for the show" % who, "s": "set the camp and write the plan against %s" % str(f["bout"]["opp"].get("first", "the opponent")),
					"act": "fighter", "arg": str(f.get("id", "")), "label": "Fight prep"}
	return {}


## The end of a week (Sim, after the report is written). Week 1 hands the guide to the first fight; every Monday the first hour
## brings its people (FirstHour.monday: the second walk-in, Ana's teaser, then Ana).
static func end_of_week(c: Career, week: int) -> void:
	# TASK GUIDEFLAG2: at the end of week 1, the guide moves from "go" to "offer".
	if week == 1 and c.guide == "go":
		c.guide = "offer"
	if not FirstHour.on(c):   # a save from before rank 5 (or a test without the first hour): Ana at the end of week 1, as before
		if week == 1:
			ana_joins(c)
		return
	var m := FirstHour.monday(c)
	if str(m["walkin"]) != "":
		c.applicant = FirstHour.walkin(str(m["walkin"]))
		c.add_news("%s is at reception and asking for you." % str(c.applicant.get("name", "A boxer")))
	if bool(m["teaser"]):
		c.add_news("A no-gi grappler has been asking at the desk whether %s has mat space." % c.gym_name, false, true)
	if bool(m["ana"]):
		ana_joins(c)
	sync(c)


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
