extends RefCounted
## S519 club week v11 3.3 wired (his Q-S294-272 "Yes, build it"): the coach deals the club's coached mornings
## (CoachedMornings.week_deal: You 4 + the coach 2 sessional / 3 full time) over this week's boxers. Computed from the plans as
## they stand, never stored, so the Training screen, the week forecast and the day the sim runs read the same deal. One boxer
## = no deal, the week as before (v11 section 2).
##   of(c, f) -> {dow: {use, mult, ability, mate}} for f     rows(c) -> the deal's input, fight weeks first

const WeekPlan := preload("res://scripts/rules/WeekPlan.gd")
const WeekTwist := preload("res://scripts/rules/WeekTwist.gd")
const DayJob := preload("res://scripts/rules/DayJob.gd")
const CoachedMornings := preload("res://scripts/rules/CoachedMornings.gd")


static func coach_kind(c: Career) -> String:
	return "full_time" if bool(c.coach.get("full_time", false)) else "sessional"


## Each boxer's week as the abilities her mornings train ("" = rest, work, mobility, neck), taper (fight week) first.
static func rows(c: Career) -> Array:
	var out: Array = []
	for f in c.fighters:
		var days := WeekTwist.days(WeekTwist.active(f), WeekPlan.days_of(f))
		var rest_days: Array = range(7).filter(func(k): return str((days[k] as Array)[0]) == "rest")
		var work: Array = DayJob.lost_days_of(f, rest_days)
		var abs: Array = []
		for i in 7:
			var st := str(WeekPlan.session(str((days[i] as Array)[0])).get("stat", ""))
			abs.append("" if work.has(i) else st)
		out.append({"id": str(f["id"]), "stats": f.get("stats", {}), "days": abs,
			"fw": str(f.get("phase", "")) == "taper"})
	var fw := out.filter(func(r): return bool(r["fw"]))
	return fw + out.filter(func(r): return not bool(r["fw"]))


static func deal(c: Career) -> Dictionary:
	if c == null or c.fighters.size() < 2:
		return {}
	return CoachedMornings.week_deal(rows(c), coach_kind(c))


static func of(c: Career, f: Dictionary) -> Dictionary:
	return deal(c).get(str(f.get("id", "")), {})
