extends RefCounted
## S397 rank 5 (docs/STRUCTURE_DESIGN_S395.md 5.5, plan ops/research/RANK5_FIRST_HOUR_S397.md): the first hour after week 1.
## The first offer is a club show known from day 0 (the goal card names its date): it arrives on Monday of week 2, OFFER_DAY,
## for Saturday of week 4, SHOW_DAY, against a legal opponent drawn by the career's seed (critic S397: a second run is a new
## puzzle). Measured (tests/first_hour_test.gd, seed 1): on the weeks as planned the walk-in weighs 60.21 kg on the morning
## for 60.0 (missed); starting the cut in week 1 (the Week page's coach line, Do it) lands 59.87, the old hand's cut 59.93.
## So the weight is the hour's first real decision. (Day 19, week 3, was tried first: 60.65 / 60.20 - not makeable at all.) The show is never re-dated by
## Bouts.makeable_day: it IS makeable, by the player.
## Until the first bout is fought the week stays quiet: no twist card, no ask (critic S397 point 9).
## After the first bout: the second walk-in on the next Monday (SECOND_WALKIN), a rival coach named in the news, three club
## tasks on the guide strip; Ana is a news teaser and asks to join after the club's second bout (or ANA_BY_DAY).
## Pure rules over the career's data; preloads only Data. FirstWeek owns the guide's step; this file owns the dates and cast.

const Data := preload("res://scripts/state/Data.gd")
const ClubStart := preload("res://scripts/rules/ClubStart.gd")

const OFFER_DAY := 7    # Monday of week 2 (day 0 is Monday 5 January)
const SHOW_DAY := 26    # Saturday of week 4: Sat 31 January, 19 days after the offer
const SECOND_WALKIN := "danny"
## Operator S405: refuse the first walk-in and this is who comes in instead.
const REFUSED_QUOTE := "\"Three fights and I'm not here for trophies. Get me ready and get me a pro contract.\""
## Ana joins after the club's second bout, or by this day (week 9) if the second bout is slow to come.
const ANA_BY_DAY := 56
## S398 round 5 (blind: "the bills job ticks itself"): the third task is a decision - the first boxer's next goal (the office).
const TASKS := ["second", "book", "goal"]
const TASK_WORDS := {"second": "Sign a second boxer", "book": "Get both boxers a bout", "goal": "Set the first boxer's next goal"}
## The rival coach the news names after the first bout (one line; the full rival gym is a later rank).
const RIVAL := {"coach": "Frank Doyle", "gym": "Eastside ABC"}


## The first-hour plan for a new career: {} on an old save.
static func begin(c: Career) -> void:
	c.first_hour = {"show": SHOW_DAY, "fought": false, "walkin": false, "rival": false, "teaser": false, "backers": "",
		"tasks_done": []}


static func on(c: Career) -> bool:
	return not c.first_hour.is_empty()


## True until the club's first bout is fought: no twist cards, no asks.
static func quiet(c: Career) -> bool:
	return on(c) and not bool(c.first_hour.get("fought", false))


## The first fighter's first offer: the show, if it has not been offered yet.
static func is_show_offer(c: Career, f: Dictionary) -> bool:
	return on(c) and not bool(c.first_hour.get("offered", false)) and not c.fighters.is_empty() \
		and str(c.fighters[0]["id"]) == str(f["id"]) and (f.get("history", []) as Array).is_empty()


## The day the first fighter's first offer comes (signing sets next_offer_day; the show's offer comes on its Monday).
static func first_offer_day(c: Career, default_day: int) -> int:
	return OFFER_DAY if on(c) and c.fighters.size() == 1 and c.day < OFFER_DAY else default_day


## The show's opponent: one of the division's opponents, by the career's seed ("" names fall back to the first).
static func show_opponent(c: Career, f: Dictionary) -> String:
	var names: Array = Data.DIVISIONS[f["div"]]["opponents"]
	return str(names[posmod(c.seed, names.size())])


static func mark_offered(c: Career) -> void:
	if on(c):
		c.first_hour["offered"] = true


## After a bout is fought (Bouts.fight_done): the hour moves on. Returns news lines to add.
static func bout_done(c: Career, f: Dictionary, won: bool, missed: bool = false) -> Array:
	if not on(c):
		return []
	var out: Array = []
	var n := int(c.first_hour.get("bouts", 0)) + 1
	c.first_hour["bouts"] = n
	if not bool(c.first_hour.get("fought", false)):
		c.first_hour["fought"] = true
		if not bool(c.first_hour.get("rival", false)):
			c.first_hour["rival"] = true
			var said := "Good win, for a new club" if won else ("Can't even make weight over there" if missed else "Brave, for a first night")
			out.append("%s of %s, after %s's night: \"%s. We'll see %s again.\"" % [RIVAL["coach"], RIVAL["gym"], f["first"],
				said, c.gym_name])
	return out


## Monday: the second walk-in arrives the first Monday after the first bout; Ana's teaser, then Ana.
## Returns {"walkin": prospect id or "", "teaser": bool, "ana": bool}.
static func monday(c: Career) -> Dictionary:
	var out := {"walkin": "", "teaser": false, "ana": false}
	if not on(c):
		return out
	if bool(c.first_hour.get("fought", false)) and not bool(c.first_hour.get("walkin", false)) and c.applicant.is_empty():
		c.first_hour["walkin"] = true
		out["walkin"] = SECOND_WALKIN
	elif bool(c.first_hour.get("fought", false)) and bool(c.first_hour.get("walkin", false)) and not bool(c.first_hour.get("teaser", false)):
		c.first_hour["teaser"] = true
		out["teaser"] = true
	if c.grapplers.is_empty() and (int(c.first_hour.get("bouts", 0)) >= 2 or c.day >= ANA_BY_DAY):
		out["ana"] = true
	return out


## The second walk-in's dict (a copy of the prospect) with the line the interview shows.
static func walkin(id: String) -> Dictionary:
	for p in Data.PROSPECTS:
		if str(p["id"]) == id:
			var d := (p as Dictionary).duplicate(true)
			d["quote"] = "\"People at the shows talk about your club. I want a coach who reads the other corner, not one who shouts.\""
			return d
	return {}


## Operator S405: the person at reception is turned away for good. The first one (Lucy) is replaced by the second walk-in, who
## then does not come again later. Refusing that one leaves reception empty. Returns the toast.
static func refuse(c: Career) -> String:
	var who := str(c.applicant.get("first", "The boxer"))
	var next := walkin(SECOND_WALKIN)
	if str(c.applicant.get("id", "")) == SECOND_WALKIN or next.is_empty():
		for p in c.prospects:
			if str(p["id"]) == SECOND_WALKIN:
				p["state"] = "passed"
		c.applicant = {}
		c.add_news("%s thanks you and leaves." % who)
		return "%s thanks you and leaves. Try the Find a fighter tab." % who
	next["quote"] = REFUSED_QUOTE
	next["limit"] = float(Data.DIVISIONS[str(next["div"])]["limit"])
	c.applicant = ClubStart.walkin(c.start, next)
	if on(c):
		c.first_hour["walkin"] = true
	c.add_news("%s leaves. %s is at reception and asking for you." % [who, str(next["name"])])
	return "%s leaves. %s is at reception." % [who, str(next["name"])]


## The three club tasks after the first bout: which are done now.
static func tasks(c: Career) -> Dictionary:
	var done := {}
	done["second"] = c.fighters.size() >= 2
	done["book"] = c.fighters.size() >= 2 and c.fighters.all(func(f): return _booked_or_fought(f))
	var first := c.fighter()
	done["goal"] = not first.is_empty() and not bool(first.get("goal_talk", false)) and bool(c.first_hour.get("fought", false))
	return done


static func _booked_or_fought(f: Dictionary) -> bool:
	var b: Dictionary = f.get("bout", {})
	return not b.is_empty() or (f.get("history", []) as Array).size() > 1 or (f.get("offers", []) as Array).any(func(o): return bool(o.get("accepted", false)))


static func tasks_left(c: Career) -> int:
	var t := tasks(c)
	return TASKS.filter(func(k): return not bool(t[k])).size()


## The backed start: the first show decides the backing. "" until it is fought, then "kept" or "pulled".
static func backers_result(c: Career, won: bool) -> String:
	if not on(c) or str(c.first_hour.get("backers", "")) != "" or c.start != "backed":
		return ""
	c.first_hour["backers"] = "kept" if won else "pulled"
	return str(c.first_hour["backers"])


## The goal card's lines for Home: the closing rule the code runs (GymBills.CLOSE_AFTER_WEEKS, critic S397 point 1), the
## show's date, then the start's own bite (ClubStart card "bite"; "" for none).
static func goal_lines(c: Career, close_weeks: int, show_date: String, bite: String) -> Array:
	var who := str(c.applicant.get("first", c.fighter().get("first", "")))
	var lines: Array = ["Keep the doors open: %d weeks in a row below $0 closes the gym." % close_weeks]
	# S398 round 3 (blind: "the job still describes the slot after the offer came"): the target line follows the show.
	var f := c.fighter()
	var b: Dictionary = f.get("bout", {}) if not f.is_empty() else {}
	var open: Array = (f.get("offers", []) as Array).filter(func(o): return int(o["day"]) == SHOW_DAY and not bool(o["answered"])) if not f.is_empty() else []
	if b.has("opp") and int(b.get("day", -1)) == SHOW_DAY:
		lines.append("%s vs %s at the club show, %s." % [f["first"], b["opp"]["name"], show_date])
	elif not open.is_empty():
		lines.append("The club show on %s has offered %s a bout against %s." % [show_date, f["first"], open[0]["opp"]["name"]])
	else:
		lines.append("A club show on %s has a lightweight slot%s." % [show_date, " for %s" % who if who != "" else ""])
	if bite != "" and c.start != "fresh":
		lines.append(bite)
	return lines
