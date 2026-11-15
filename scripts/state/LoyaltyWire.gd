extends RefCounted
## S485 CLUBWEEK1 v1: Loyalty.gd (pure, R58LOYAL1) made live in the club week. The bar is on the fighter's Overview
## (DarkOverview.loyalty, his Q-245 pick "0-100 bar with its word"). This file moves it:
##   stipend(c, f, on)  the gym sponsorship given (+5) or pulled (-8); dates the day job for wants_sponsor
##   week(c)            every Monday, each amateur boxer: drift +1 a week while under DRIFT_TO (pads are never short,
##                      his Q-242, so a normal week is a full week); a top prospect (pot WANTS_POT+) kept on a day job
##                      WANTS_WEEKS weeks or more: wants_sponsor (-3 a week)
## Leaving (Loyalty.leaves) and the talk wait for R58 (a fighter leaves): no code path removes a fighter today.
## Never reads or writes morale (Loyalty's rule). Preloads only Loyalty (no loop: GymSpend and Sim call in).
const Loyalty := preload("res://scripts/rules/Loyalty.gd")

## The map's drift target (CLUBWEEK1 v9 3.7): a normal week lifts loyalty up to here, never past it.
const DRIFT_TO := 60
## wants_sponsor (Loyalty.MOVES): potential this high and on a day job this many weeks.
const WANTS_POT := 80
const WANTS_WEEKS := 8


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


static func wants_sponsor(f: Dictionary, day: int) -> bool:
	return bool(f.get("day_job", false)) and int(f.get("pot", 0)) >= WANTS_POT \
		and day - int(f.get("day_job_since", 0)) >= WANTS_WEEKS * 7
