extends RefCounted
## S382 G3 (gym idea 4, operator "Yes, build both"): the camp's SPARRING NIGHTS are the Playbook's tests. No flat 3 a camp:
## a test takes the next sparring night still to come (the night runs anyway, so it costs nothing extra), and the camp has
## as many tests as it has sparring nights left before fight night. Counted the way the weeks run (WeekPhase per Monday,
## WeekPlan.SPAR_DAYS for the nights): 25 days out = Build 1 + Build 1 + Peak 2 + Taper 0 = 4; a 2-week camp = 2; fight
## week = none.
##   nights(bout, today, now_phase, now_spar) -> [days of the sparring nights from today to fight night, in order]
##   unused(nights, used) -> the nights not used yet   to_go(bout_day, day) -> the weeks strip's cell holding that day
##   used_in(bout_day, used, to_go) -> tests used on the nights of that strip cell
## now_phase / now_spar: this week's phase as the sim runs it (f["phase"]) and the player's own sparring count (-1 = the
## phase's); later weeks are the coach's. Pure static.

const WeekPhase := preload("res://scripts/rules/WeekPhase.gd")
const WeekPlan := preload("res://scripts/rules/WeekPlan.gd")


static func nights(bout: Dictionary, today: int, now_phase := "", now_spar := -1) -> Array:
	var out: Array = []
	if bout.is_empty() or bool(bout.get("done", false)):
		return out
	var bout_day := int(bout.get("day", today))
	var monday := today - posmod(today, 7)
	var k := 0
	while monday + 7 * k < bout_day:
		var p := now_phase if k == 0 and now_phase != "" and now_phase != "base" else WeekPhase.phase(bout, monday + 7 * k)
		var n := now_spar if k == 0 and now_spar >= 0 else WeekPhase.spar(p)
		for d in WeekPlan.SPAR_DAYS[clampi(n, 0, WeekPlan.SPAR_DAYS.size() - 1)]:
			var u: int = monday + 7 * k + int(d)
			if u >= today and u < bout_day:
				out.append(u)
		k += 1
	return out


static func unused(all: Array, used: Array) -> Array:
	var taken := used.map(func(u): return int(u))   # a loaded save brings the days back as floats
	return all.filter(func(u): return not taken.has(int(u)))


## The weeks strip counts back from fight night in 7-day cells (WeekStrip.cells): the cell a day falls in.
static func to_go(bout_day: int, day: int) -> int:
	return maxi(1, int(ceil((bout_day - day) / 7.0)))


static func used_in(bout_day: int, used: Array, cell: int) -> int:
	return used.filter(func(u): return to_go(bout_day, int(u)) == cell).size()
