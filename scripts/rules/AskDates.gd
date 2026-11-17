extends RefCounted
## ASKDATES1: ask for a fight - two shows side by side, what each date leaves time for, why a card is missing.
## Pure static module: no class_name, no preload of scenes. Game text never says he, she, her or him.

const AskBout := preload("res://scripts/rules/AskBout.gd")
const FightWeek := preload("res://scripts/rules/FightWeek.gd")
const BoutRules := preload("res://scripts/rules/BoutRules.gd")
const FighterProfile := preload("res://scripts/rules/FighterProfile.gd")
const AmateurBooking := preload("res://scripts/rules/AmateurBooking.gd")
## Sparring nights the fight week itself holds (FightWeek.gd header / FightWeekPlan: "0-2 fight-week sparring nights and
## one week-before night"); spar_nights counts both.
const FIGHT_WEEK_NIGHTS := 2


## The next `count` club shows a fighter can be asked onto: the first show whose days away >= CAMP_MIN_DAYS
## (a fight week fits), then the following ones. Each: {day, days_away, date_words, holder, prep}.
## A night held by one of ours is still listed, with the holder, so the screen can say why.
static func shows(day: int, show_days: Array, taken_by_ours: Array, fmt: Callable, count: int = 2) -> Array:
	var days: Array = show_days.duplicate()
	days.sort()
	var out: Array = []
	for sd in days:
		var d := int(sd)
		var away := d - day
		if away < BoutRules.CAMP_MIN_DAYS:
			continue
		out.append({"day": d, "days_away": away, "date_words": str(fmt.call(d)),
			"holder": _holder(d, taken_by_ours), "prep": prep(away)})
		if out.size() >= count:
			break
	return out


## The holder of a night: the name of our fighter already on that night, "" if free.
## Reuses AskBout's holder logic (same arithmetic: a taken_by_ours entry with a matching day).
static func _holder(d: int, taken_by_ours: Array) -> String:
	for t in taken_by_ours:
		if t is Dictionary and int((t as Dictionary).get("day", -1)) == d:
			return str((t as Dictionary).get("name", ""))
	return ""


## What the date leaves time for, from the fight-week rules.
## {fight_week, week_before, spar_nights (most that fit), film_evening, camp_words, checks}.
## checks: Array of {words, on} in this order: "Fight week", "A sparring night the week before",
## "Sparring nights: N", "A film evening". Words plain, no numbers the player can sort by except the night count.
static func prep(away: int) -> Dictionary:
	var fight_week := away >= BoutRules.CAMP_MIN_DAYS
	var week_before := away >= FightWeek.SPAR_WEEK_BEFORE_DAYS
	var spar_nights: int
	if away < 2:
		spar_nights = 0
	elif away < FightWeek.SPAR_WEEK_BEFORE_DAYS:
		spar_nights = mini(2, away - 1)
	else:
		spar_nights = 3
	var fw_nights := mini(FIGHT_WEEK_NIGHTS, spar_nights)
	var film_evening := fight_week
	var checks := [
		{"words": "Fight week", "on": fight_week},
		{"words": "A sparring night the week before", "on": week_before},
		{"words": "Sparring nights in the fight week: %d" % fw_nights, "on": fw_nights > 0},   # S512: the week-before night has its own line
		{"words": "A film evening", "on": film_evening},
	]
	return {"fight_week": fight_week, "week_before": week_before, "spar_nights": spar_nights,
		"film_evening": film_evening, "camp_words": AskBout.camp_words(away), "checks": checks}


## For each answer AskBout.answers does NOT return, {kind, why}.
## Matches AskBout.answers' own rules exactly (calls it; never re-implements legality).
static func absent(f: Dictionary, rows: Array, next_in_turn: String, min_wins: int) -> Array:
	var ans: Array = AskBout.answers(f, rows, next_in_turn, min_wins)
	var kinds: Array = []
	for a in ans:
		kinds.append(str((a as Dictionary).get("kind", "")))
	var out: Array = []
	var w := int(f.get("w", 0))
	var ranked := w >= min_wins
	if not kinds.has("sheet"):
		out.append({"kind": "sheet", "why": "No name on the sheet is legal for this fighter now."})
	if not kinds.has("step_up"):
		out.append({"kind": "step_up", "why": "Nobody above on the ladder is free." if ranked
			else "Nobody with a better record inside the novice rule."})
	if not kinds.has("name"):
		if not ranked:
			out.append({"kind": "name", "why": "Names open at %d wins (now %d)." % [min_wins, w]})
		else:
			out.append({"kind": "name",
				"why": "No other legal name up to %d places above or level." % AskBout.PICK_REACH})
	return out


## The record trade as words from the game's constants. Each kind returns an array of consequence strings.
static func trade(kind: String) -> Array:
	match kind:
		"win":
			return ["+%d members" % BoutRules.WIN_MEMBERS, "+%d reputation" % BoutRules.WIN_REPUTATION]
		"loss":
			return ["-%d member%s" % [BoutRules.LOSS_MEMBERS, _s(BoutRules.LOSS_MEMBERS)],
				"-%d reputation" % BoutRules.LOSS_REPUTATION]
		"stopped":
			return ["-%d member%s" % [BoutRules.STOPPED_LOSS_MEMBERS, _s(BoutRules.STOPPED_LOSS_MEMBERS)],
				"-%d reputation" % BoutRules.STOPPED_LOSS_REPUTATION,
				"%d days out" % _ko_days()]
	return []


## Plural suffix: "" for 1, "s" otherwise.
static func _s(n: int) -> String:
	return "" if n == 1 else "s"


## The suspension days after a stoppage loss (InjuryRoll.KO_DAYS).
static func _ko_days() -> int:
	return int(load("res://scripts/rules/InjuryRoll.gd").KO_DAYS)


## Wait words: when the sheet hasn't sent a name yet. Reads every number from the game's constants.
static func wait_words() -> String:
	var cost: int = absi(int(FighterProfile.MORALE_EVENTS.get("month_no_fight", 0)))
	return "Wait for the sheet: likely in %d to %d weeks, date unknown. A month without a fight costs %d morale." % [
		AmateurBooking.LEAD_WEEKS_MIN, AmateurBooking.LEAD_WEEKS_MAX, cost]
