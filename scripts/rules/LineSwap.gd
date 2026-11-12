extends RefCounted
## S440 R26SWAP1: the corner minute's line change - the line that lost most, and two rated lines to swap in.
## Pure static; preloads PlanFight, StrikeMap, PlanLines. The screen (CornerJobsRow) reads this later.

const PlanFight := preload("res://scripts/rules/PlanFight.gd")
const StrikeMap := preload("res://scripts/rules/StrikeMap.gd")
const PlanLines := preload("res://scripts/rules/PlanLines.gd")


## The planned line with the most exchanges lost (thrown - won). Ties: lower win share, more thrown, earlier in plan.
## {} when no planned line lost an exchange.
static func lost_most(exs: Array) -> Dictionary:
	var agg := _aggregate(exs)
	if agg.is_empty():
		return {}
	var best_key := ""
	var best_lost := 0
	var best_won := 0
	var best_thrown := 0
	var best_order := 999
	var order := 0
	for arrow in agg.keys():
		var data: Dictionary = agg[arrow]
		var won := int(data["won"])
		var thrown := int(data["thrown"])
		var lost := thrown - won
		if lost <= 0:
			order += 1
			continue
		var wins := best_key == ""
		if not wins:
			var wins_more := lost > best_lost
			var wins_tie := lost == best_lost
			if wins_tie:
				wins = won < best_won or (won == best_won and (thrown > best_thrown or (thrown == best_thrown and order < best_order)))
			else:
				wins = wins_more
		if wins:
			best_key = arrow
			best_lost = lost
			best_won = won
			best_thrown = thrown
			best_order = order
		order += 1
	if best_key == "" or best_lost <= 0:
		return {}
	var data: Dictionary = agg[best_key]
	return {"move": best_key, "at": str(data["at"]), "won": int(data["won"]), "thrown": int(data["thrown"]), "lost": best_lost, "tally": _tally_str(best_key, int(data["won"]), int(data["thrown"]))}


## Aggregate planned lines over the bout: {arrow: {won, thrown, at, i}}.
static func _aggregate(exs: Array) -> Dictionary:
	var agg: Dictionary = {}
	var idx := 0
	for x in exs:
		var rec: Dictionary = x as Dictionary
		if not bool(rec.get("planned", false)):
			idx += 1
			continue
		var arrow := str(rec.get("arrow", ""))
		if arrow == "":
			idx += 1
			continue
		var won := bool(rec.get("won", false))
		var at := str(rec.get("at", ""))
		if not agg.has(arrow):
			agg[arrow] = {"won": 0, "thrown": 0, "at": at, "i": idx}
		agg[arrow]["won"] = int(agg[arrow]["won"]) + int(won)
		agg[arrow]["thrown"] = int(agg[arrow]["thrown"]) + 1
		idx += 1
	return agg


## Where the lost line sits in the plan (-1 when the plan no longer holds it): the index corner_change rewrites.
static func _plan_index(plan: Array, move_id: String) -> int:
	for i in plan.size():
		if str((plan[i] as Dictionary).get("move", "")) == move_id:
			return i
	return -1


## "One-two-hook 1 of 4" - the tally in words, no pronoun.
static func _tally_str(move_id: String, won: int, thrown: int) -> String:
	var name := str(StrikeMap.move(move_id).get("name", move_id))
	return "%s %d of %d" % [name, won, thrown]


## The situation the opponent showed most in the round just gone (the record's psit). Ties: the later one.
static func shown_game(round_exs: Array) -> String:
	var counts: Dictionary = {}
	var last_seen: Dictionary = {}
	var idx := 0
	for x in round_exs:
		var rec: Dictionary = x as Dictionary
		var psit := str(rec.get("psit", ""))
		if psit == "":
			idx += 1
			continue
		if not counts.has(psit):
			counts[psit] = 0
		counts[psit] = int(counts[psit]) + 1
		last_seen[psit] = idx
		idx += 1
	if counts.is_empty():
		return ""
	var best := ""
	var best_count := 0
	var best_last := -1
	for sit in counts.keys():
		var c := int(counts[sit])
		var l := int(last_seen[sit])
		if c > best_count or (c == best_count and l > best_last):
			best = sit
			best_count = c
			best_last = l
	return best


## Replacement options: other moves out of the lost line's card that the boxer can throw and the plan accepts.
## worth = PlanFight.value(move, sit, PlanFight.rate(move, combos)) * g - PlanFight.card_mean(at, sit, mastery, combos)
## where g = float(grade.get(move, 1.0)). Only options worth MORE than the lost line, best first.
static func options(plan: Array, lost: Dictionary, sit: String, mastery: Dictionary, combos: Dictionary, limit: int, grade: Dictionary = {}) -> Array:
	if lost.is_empty():
		return []
	var at := str(lost["at"])
	var lost_move := str(lost["move"])
	var lost_i := _plan_index(plan, lost_move)
	if lost_i < 0:
		return []
	var base := PlanFight.card_mean(at, sit, mastery, combos)
	var lost_rate := PlanFight.rate(lost_move, combos)
	var lost_worth := PlanFight.value(lost_move, sit, lost_rate) * float(grade.get(lost_move, 1.0)) - base
	var out: Array = []
	for m in StrikeMap.outs(at):
		var id := str(m["id"])
		if id == lost_move:
			continue
		if not PlanFight.can_do(m, mastery):
			continue
		var new_plan := PlanFight.corner_change(plan, lost_i, id, limit)
		if new_plan == plan:
			continue
		var g := float(grade.get(id, 1.0))
		var rate := PlanFight.rate(id, combos)
		var worth := PlanFight.value(id, sit, rate) * g - base
		if worth <= lost_worth:
			continue
		var fit := PlanFight.fit(id, sit)
		var fit_words := str(PlanLines.FIT_WORDS.get(fit, ""))
		out.append({"move": id, "name": str(m["name"]), "fit": fit, "fit_words": fit_words, "worth": worth, "was_worth": lost_worth, "i": lost_i})
	out.sort_custom(func(a, b): return float(a["worth"]) > float(b["worth"]))
	return out.slice(0, mini(2, out.size()))


## What the minute shows: {lost, game, game_words, options}, or {} when no planned line lost.
static func row(plan: Array, bout_exs: Array, round_exs: Array, mastery: Dictionary, combos: Dictionary, limit: int) -> Dictionary:
	var lost := lost_most(bout_exs)
	if lost.is_empty():
		return {}
	var game := shown_game(round_exs)
	# S442 (found drawing the corner cards): a line with a WHEN fires only in that situation, so its replacements are
	# rated there. Rated on the round's most-shown game, "Step out" read Beats it on a line that waits for a counter.
	var i := _plan_index(plan, str(lost["move"]))
	var when := str((plan[i] as Dictionary).get("when", "")) if i >= 0 else ""
	if when != "":
		game = when
	var game_words := _game_words(game)
	var opts := options(plan, lost, game, mastery, combos, limit)
	return {"lost": lost, "game": game, "game_words": game_words, "options": opts}


## The situation in words, no pronoun.
static func _game_words(sit: String) -> String:
	const WORDS := {"press": "Opponent pressed", "range": "Opponent boxed at range", "counter": "Opponent waited to counter",
		"counter_late": "Opponent waited to counter", "loadup": "Opponent loaded up", "tiring": "Opponent was tiring",
		"hurt": "Opponent was hurt", "hurt_danger": "Opponent was hurt and hit back", "she_tired": "Your fighter was tired",
		"she_hurt": "Your fighter was hurt"}
	return str(WORDS.get(sit, ""))


## One click: PlanFight.corner_change on the option's arguments.
static func apply(plan: Array, option: Dictionary, limit: int) -> Array:
	return PlanFight.corner_change(plan, int(option.get("i", 0)), str(option.get("move", "")), limit)
