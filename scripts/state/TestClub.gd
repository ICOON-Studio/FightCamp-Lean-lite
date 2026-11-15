extends RefCounted
## S489 FOURSTART1 the TEST CLUB (operator S487, Q-246: "The normal game will start with 0 fighters . The reason told you
## to make 4 fighter start was to see the menus populated how they look and for the tests"). A new career with four
## fighters already at the club: three boxers in three weight classes (Lucy, women's lightweight; Kira, women's
## featherweight; Josh, men's welterweight) and one grappler (Ana, no-gi), the sessional coach hired, past the first-week
## guide. Never the normal start: the create screen's TEST CLUB switch and `jump=club4` only; its money is not balanced.
##   make(c) -> Array (the three boxers signed)   boxers(c) -> Array   on(c) -> bool

const Data := preload("res://scripts/state/Data.gd")
const Roster := preload("res://scripts/state/Roster.gd")
const Sim := preload("res://scripts/state/Sim.gd")
const FirstWeek := preload("res://scripts/rules/FirstWeek.gd")

## The two prospects signed beside the walk-in, each in a class of their own (Lucy is the women's lightweight walk-in).
const PROSPECTS := ["kira", "josh"]
const COACH := "reid"
const PICKS := ["Jab and move", "Pad rounds", "Hill sprints"]


## Turns a career fresh from Career.quick_start / from_create into the test club. Changes c in place; a second call adds
## no one. Returns the boxers on the books.
static func make(c: Career) -> Array:
	if on(c):
		return boxers(c)
	c.test_club = true
	c.first_hour = {}   # the test club starts past the first show's guide, on the classic calendar
	FirstWeek.skip(c)
	if not c.applicant.is_empty():
		Sim.sign(c, PICKS.duplicate())
	for id in PROSPECTS:
		var p := Roster.prospect(c, id)
		if p.is_empty() or str(p.get("state", "")) == "signed":
			continue
		var raw: Dictionary = p.duplicate(true)
		for k in ["state", "trial_day", "note"]:
			raw.erase(k)
		p["state"] = "signed"
		Roster.sign_fighter(c, raw, [])
	if c.coach.is_empty():
		Sim.hire(c, COACH)
	FirstWeek.ana_joins(c)
	c.add_news("TEST CLUB: four fighters on the books to see every menu full. Not the normal start.")
	return boxers(c)


static func boxers(c: Career) -> Array:
	return c.fighters


static func on(c: Career) -> bool:
	return c.test_club
