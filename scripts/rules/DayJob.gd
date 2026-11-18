extends RefCounted
## Day job: without the gym sponsorship a boxer loses 2 coached mornings a
##   week to work, and the sponsorship is billed in 4-week blocks. Pure static
##   rules: no game state, no UI, no preloads.
## Owner Q-S294-243: "2 mornings" - a boxer without the gym sponsorship loses
##   2 coached mornings a week to work.
## Build plan: ops/research/CLUBWEEK1_BUILD_S485.md, item 1 (DAYJOB1).
## lost(day_job): LOST mornings lost when working, else 0.
## lost_days(day_job, rest_days): week days lost to work; a rest day is
##   skipped and the next free day taken instead, scanning forward and
##   wrapping, never a rest day and never twice.
## mornings_left(planned, day_job): planned mornings minus the lost ones.
## gain_share(planned, day_job): share of planned mornings kept, 1.0 when
##   nothing is planned.
## block_cost(weekly_stipend): sponsorship cost of one 4-week block.
## block_end(start_day): day index on which the 4-week block ends.
## day_word(day, lost_list): WORK_WORD when the day is a lost day.
## line(day_job): the week-view line shown when working, e.g.
##   "Works 2 mornings a week (Tue, Thu)".

const LOST := 2
const LOST_DAYS := [1, 3]
const WEEK_DAYS := 6
const BLOCK_WEEKS := 4
const WORK_WORD := "Work"


static func lost(day_job: bool) -> int:
	return LOST if day_job else 0


## S519 club week v11 3.5: HALF the gym sponsorship ($125) - the boxer works HALF_LOST morning (Tue). f["half_job"] with
## f["day_job"]; a pro never works.
const HALF_LOST := 1


static func count_of(f: Dictionary) -> int:
	if bool(f.get("pro", false)) or not bool(f.get("day_job", false)):
		return 0
	return HALF_LOST if bool(f.get("half_job", false)) else LOST


static func lost_days_of(f: Dictionary, rest_days: Array = []) -> Array:
	var n := count_of(f)
	return lost_days(n > 0, rest_days, n)


static func lost_days(day_job: bool, rest_days: Array = [], count: int = LOST) -> Array:
	if not day_job:
		return []
	var rest := {}
	for d in rest_days:
		rest[str(d)] = true
	var taken := {}
	var result: Array = []
	for d in LOST_DAYS.slice(0, count):
		var day: int = int(d)
		var tried := 0
		while tried < WEEK_DAYS and (rest.has(str(day)) or taken.has(str(day))):
			day = (day + 1) % WEEK_DAYS
			tried += 1
		if tried < WEEK_DAYS:
			taken[str(day)] = true
			result.append(day)
	result.sort()
	return result


static func mornings_left(planned: int, day_job: bool) -> int:
	return max(0, planned - lost(day_job))


static func gain_share(planned: int, day_job: bool) -> float:
	if planned <= 0:
		return 1.0
	return float(mornings_left(planned, day_job)) / float(planned)


static func block_cost(weekly_stipend: int) -> int:
	return weekly_stipend * BLOCK_WEEKS


static func block_end(start_day: int) -> int:
	return start_day + BLOCK_WEEKS * 7


static func day_word(day: int, lost_list: Array) -> String:
	return WORK_WORD if lost_list.has(day) else ""


static func line(day_job: bool) -> String:
	if not day_job:
		return ""
	var names := ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
	var days: Array = []
	for d in LOST_DAYS:
		days.append(names[d])
	return "Works %d mornings a week (%s)" % [LOST, ", ".join(days)]
