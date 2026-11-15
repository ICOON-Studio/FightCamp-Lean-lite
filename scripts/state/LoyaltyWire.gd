extends RefCounted
## S485 CLUBWEEK1 v1: Loyalty.gd (pure, R58LOYAL1) made live in the club week. The bar is on the fighter's Overview
## (DarkOverview.loyalty, his Q-245 pick "0-100 bar with its word"). This file moves it:
##   stipend(c, f, on)  the gym sponsorship given (+5) or pulled (-8); dates the day job for wants_sponsor
##   week(c)            every Monday, each amateur boxer: drift +1 a week while under DRIFT_TO (pads are never short,
##                      his Q-242, so a normal week is a full week); a top prospect (pot WANTS_POT+) kept on a day job
##                      WANTS_WEEKS weeks or more: wants_sponsor (-3 a week)
## S486: leaving is Leaving.gd (R58 LEAVE1); results, goals, offers passed, the pro call and signings move loyalty at
## their own hooks (BoutFinish, Bouts.passed, Roster) - see Loyalty.MOVES.
## Never reads or writes morale (Loyalty's rule). Preloads only Loyalty (no loop: GymSpend and Sim call in).
const Loyalty := preload("res://scripts/rules/Loyalty.gd")

## The map's drift target (CLUBWEEK1 v9 3.7): a normal week lifts loyalty up to here, never past it.
const DRIFT_TO := 60
## wants_sponsor (Loyalty.MOVES): potential this high and on a day job this many weeks.
const WANTS_POT := 80
const WANTS_WEEKS := 8
## S486 LOYALHOOKS1 (map M1): fit, free and nothing booked this many Mondays running: no_bout (-3), then the count restarts.
const IDLE_WEEKS := 4


static func stipend(c: Career, f: Dictionary, on: bool) -> void:
	if on:
		Loyalty.apply(f, "sponsor_given", c.day)
		f.erase("day_job_since")
	else:
		Loyalty.apply(f, "sponsor_pulled", c.day)
		f["day_job_since"] = c.day


static func week(c: Career) -> void:
	for f in c.fighters:
		if bool(f.get("pro", false)):
			continue
		if Loyalty.value(f) < DRIFT_TO:
			Loyalty.apply(f, "full_week", c.day)
		if wants_sponsor(f, c.day):
			Loyalty.apply(f, "wants_sponsor", c.day)
		idle_week(c, f)


## A Monday with no bout booked while fit counts toward no_bout; a booked bout or an injury resets it.
## (Injuries.out inlined: Injuries preloads GymSpend, which preloads this file.)
static func idle_week(c: Career, f: Dictionary) -> void:
	var inj: Dictionary = f.get("injury", {})
	var fit := inj.is_empty() or c.day >= int(inj.get("until_day", 0))
	if not fit or not (f.get("bout", {}) as Dictionary).is_empty():
		f["idle_weeks"] = 0
		return
	f["idle_weeks"] = int(f.get("idle_weeks", 0)) + 1
	if int(f["idle_weeks"]) >= IDLE_WEEKS:
		Loyalty.apply(f, "no_bout", c.day)
		f["idle_weeks"] = 0


static func wants_sponsor(f: Dictionary, day: int) -> bool:
	return bool(f.get("day_job", false)) and int(f.get("pot", 0)) >= WANTS_POT \
		and day - int(f.get("day_job_since", 0)) >= WANTS_WEEKS * 7
