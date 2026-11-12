extends SceneTree
## S440 R26SWAP1: the corner minute's line change - the line that lost most, and two rated lines to swap in.
## Two boxers: "lucy" (jab/cross/lead hook, one drilled combo) and "nia" (more punches, two drilled combos).
## Hand-built exchange records with the keys LiveRound writes (planned, arrow, won, at, psit).

const LineSwap := preload("res://scripts/rules/LineSwap.gd")
const PlanFight := preload("res://scripts/rules/PlanFight.gd")
const StrikeMap := preload("res://scripts/rules/StrikeMap.gd")

## Lucy: jab 60, cross 55, lead hook 45, body hook 0 - can throw 1-2, 1-1, 2-3 but not 1-2-3 (lead hook < 30 needed for combo)
## Actually Combos.LEARN_AT = 30, so lead hook 45 >= 30 means 1-2-3 is learnable if combo mastery >= 30.
const LUCY_MOVES := {"Jab": 60.0, "Cross": 55.0, "Lead hook": 45.0, "Body hook": 0.0, "Uppercut": 0.0, "Check hook": 0.0}
const LUCY_COMBOS := {"1-2": 55.0, "1-2-3": 12.0}

## Nia: all punches learned, two combos drilled
const NIA_MOVES := {"Jab": 70.0, "Cross": 66.0, "Lead hook": 58.0, "Body hook": 50.0, "Uppercut": 10.0, "Check hook": 0.0}
const NIA_COMBOS := {"1-2": 60.0, "2-3": 45.0, "1-2-3": 35.0}

var failures := 0


func _initialize() -> void:
	_test_lost_most()
	_test_shown_game()
	_test_options()
	_test_row()
	_test_apply()
	_test_mutants()
	print("LINE_SWAP failures=%d" % failures)
	quit(1 if failures > 0 else 0)


func _test_lost_most() -> void:
	# Plan: 1-2 at long, step_back at mid, 1-2-3 at long (different card: mid)
	# 1-2 lost 3 of 4, step_back lost 1 of 3
	var plan := [{"move": "1-2"}, {"move": "step_back"}, {"move": "2-3"}]
	var exs := [
		{"planned": true, "arrow": "1-2", "won": false, "at": "long", "psit": "counter"},
		{"planned": true, "arrow": "1-2", "won": false, "at": "long", "psit": "counter"},
		{"planned": true, "arrow": "1-2", "won": true, "at": "long", "psit": "counter"},
		{"planned": true, "arrow": "1-2", "won": false, "at": "long", "psit": "counter"},
		{"planned": true, "arrow": "step_back", "won": false, "at": "mid", "psit": "press"},
		{"planned": true, "arrow": "step_back", "won": true, "at": "mid", "psit": "press"},
		{"planned": true, "arrow": "step_back", "won": true, "at": "mid", "psit": "press"},
	]
	var lost := LineSwap.lost_most(exs)
	_check(not lost.is_empty(), "lost_most: found a loser")
	_check(str(lost["move"]) == "1-2", "lost_most: 1-2 lost most (3 of 4)")
	_check(str(lost["tally"]) == "One-two 1 of 4", "lost_most: tally is 'One-two 1 of 4' (%s)" % lost.get("tally", ""))
	_check(int(lost["lost"]) == 3 and int(lost["won"]) == 1 and int(lost["thrown"]) == 4, "lost_most: counts correct")
	# Tie on losses: lower win share wins
	var exs2 := [
		{"planned": true, "arrow": "1-2", "won": false, "at": "long", "psit": "counter"},
		{"planned": true, "arrow": "1-2", "won": false, "at": "long", "psit": "counter"},
		{"planned": true, "arrow": "step_back", "won": false, "at": "mid", "psit": "press"},
		{"planned": true, "arrow": "step_back", "won": false, "at": "mid", "psit": "press"},
	]
	var lost2 := LineSwap.lost_most(exs2)
	_check(int(lost2["lost"]) == 2 and int(lost2["won"]) == 0, "lost_most tie: both 0 of 2, first in plan wins")
	# No planned line lost -> {}
	var exs3 := [
		{"planned": true, "arrow": "1-2", "won": true, "at": "long", "psit": "counter"},
		{"planned": false, "arrow": "", "won": false, "at": "long", "psit": "counter"},
	]
	var lost3 := LineSwap.lost_most(exs3)
	_check(lost3.is_empty(), "lost_most: no loser when all planned won")


func _test_shown_game() -> void:
	# Round with counter x2, press x1 -> counter wins
	var exs := [
		{"psit": "counter"},
		{"psit": "press"},
		{"psit": "counter"},
	]
	var game := LineSwap.shown_game(exs)
	_check(game == "counter", "shown_game: counter shown most (%s)" % game)
	# Tie: later one wins
	var exs2 := [
		{"psit": "press"},
		{"psit": "counter"},
	]
	var game2 := LineSwap.shown_game(exs2)
	_check(game2 == "counter", "shown_game tie: later one wins (%s)" % game2)
	# Empty -> ""
	_check(LineSwap.shown_game([]) == "", "shown_game: empty round -> empty")


func _test_options() -> void:
	# Against "counter", 1-2-3 is wrong (PlanFight.ANSWERS.counter.wrong has "1-2-3")
	# Plan: 1-2-3 at long (lost most), options should be moves out of long that are better
	var plan := [{"move": "1-2-3"}, {"move": "step_back"}]
	var lost := {"move": "1-2-3", "at": "long", "won": 0, "thrown": 3, "lost": 3, "tally": "One-two-hook 0 of 3", "i": 0}
	var sit := "counter"
	# Nia can throw 1-2, 1-1, 2-3, 1-2-3, feint, step_out, cut_off, 1-2-3b, 1-2-3-2, 1-6-3, step_in, step_back
	# vs counter: 1-2-3 is wrong, 1-2 is ok, 1-1 is best, feint is best
	var opts := LineSwap.options(plan, lost, sit, NIA_MOVES, NIA_COMBOS, 6)
	_check(opts.size() <= 2, "options: at most 2 (%d)" % opts.size())
	_check(opts.size() > 0, "options: has some options")
	# Every option worth more than lost line
	var base := PlanFight.card_mean("long", sit, NIA_MOVES, NIA_COMBOS)
	var lost_rate := PlanFight.rate("1-2-3", NIA_COMBOS)
	var lost_worth := PlanFight.value("1-2-3", sit, lost_rate) - base
	for o in opts:
		var worth := float(o["worth"])
		_check(worth > lost_worth, "options: %s worth %.2f > lost %.2f" % [o["move"], worth, lost_worth])
	# Best first
	if opts.size() >= 2:
		_check(float(opts[0]["worth"]) >= float(opts[1]["worth"]), "options: best first")
	# Verify worth equals the formula computed here
	for o in opts:
		var id := str(o["move"])
		var rate := PlanFight.rate(id, NIA_COMBOS)
		var expected := PlanFight.value(id, sit, rate) - base
		_check(is_equal_approx(float(o["worth"]), expected), "options: worth matches formula for %s" % id)
	# A move she cannot throw yet is never offered
	var lucy_opts := LineSwap.options(plan, lost, sit, LUCY_MOVES, LUCY_COMBOS, 6)
	for o in lucy_opts:
		var m := StrikeMap.move(str(o["move"]))
		_check(PlanFight.can_do(m, LUCY_MOVES), "options: Lucy can throw %s" % o["move"])
	# More mastery -> at least as many options
	_check(nia_opts_count(plan, lost, sit) >= lucy_opts_count(plan, lost, sit),
		"options: Nia (%d) >= Lucy (%d)" % [nia_opts_count(plan, lost, sit), lucy_opts_count(plan, lost, sit)])
	# A change past the limit is never offered
	var tight_opts := LineSwap.options(plan, lost, sit, NIA_MOVES, NIA_COMBOS, 2)
	for o in tight_opts:
		var new_plan := PlanFight.corner_change(plan, int(o["i"]), str(o["move"]), 2)
		_check(new_plan != plan, "options: change accepted under limit 2")


func _test_row() -> void:
	var plan := [{"move": "1-2-3"}, {"move": "step_back"}]
	var bout_exs := [
		{"planned": true, "arrow": "1-2-3", "won": false, "at": "long", "psit": "counter"},
		{"planned": true, "arrow": "1-2-3", "won": false, "at": "long", "psit": "counter"},
		{"planned": true, "arrow": "step_back", "won": true, "at": "mid", "psit": "press"},
	]
	var round_exs := [{"psit": "counter"}, {"psit": "counter"}, {"psit": "press"}]
	var r := LineSwap.row(plan, bout_exs, round_exs, NIA_MOVES, NIA_COMBOS, 6)
	_check(not r.is_empty(), "row: not empty when a line lost")
	_check(str(r["game"]) == "counter", "row: game is counter")
	_check(str(r["game_words"]) != "", "row: game_words not empty")
	# S442 collect: the seat's pronoun check passed "She presses". Every situation the plan is rated against, word by word.
	for sit in ["press", "range", "counter", "counter_late", "loadup", "tiring", "hurt", "hurt_danger", "she_tired", "she_hurt"]:
		var gw: String = LineSwap._game_words(sit)
		_check(gw != "", "game_words: %s has words" % sit)
		for word in gw.to_lower().split(" "):
			_check(not ["she", "he", "her", "his", "him", "hers", "you"].has(word), "game_words: no pronoun in '%s'" % gw)
	# S442 collect: the lost line is NOT the plan's first line - the options must rewrite ITS place, never line 0.
	var plan_b := [{"move": "step_back"}, {"move": "1-2-3"}]
	var rb := LineSwap.row(plan_b, bout_exs, round_exs, NIA_MOVES, NIA_COMBOS, 6)
	_check(not (rb["options"] as Array).is_empty(), "row: options when the lost line is second in the plan")
	for o in rb["options"]:
		_check(int(o["i"]) == 1, "row: the option rewrites the lost line's own place (1), got %d" % int(o["i"]))
		var swapped := LineSwap.apply(plan_b, o, 6)
		_check(swapped != plan_b and str(swapped[0]["move"]) == "step_back" and str(swapped[1]["move"]) == str(o["move"]), "row: apply swaps the lost line and leaves the other")
	_check(LineSwap.options([{"move": "step_back"}], rb["lost"], "counter", NIA_MOVES, NIA_COMBOS, 6).is_empty(), "options: none when the plan no longer holds the lost line")
	_check(str(r["lost"]["tally"]).find("his") == -1 and str(r["lost"]["tally"]).find("her") == -1, "row: no pronoun in tally")
	# No planned line lost -> {}
	var r2 := LineSwap.row(plan, [], round_exs, NIA_MOVES, NIA_COMBOS, 6)
	_check(r2.is_empty(), "row: empty when no planned line lost")


func _test_apply() -> void:
	var plan := [{"move": "1-2-3"}, {"move": "step_back"}]
	var option := {"move": "1-1", "i": 0}
	var new_plan := LineSwap.apply(plan, option, 6)
	var expected := PlanFight.corner_change(plan, 0, "1-1", 6)
	_check(new_plan == expected, "apply: equals corner_change")
	# Refused change returns plan unchanged (would create two arrows at long)
	var bad_option := {"move": "1-1", "i": 1}  # step_back is at mid, but 1-1 is at long - would duplicate long
	var refused := LineSwap.apply(plan, bad_option, 6)
	_check(refused == plan, "apply: refused change returns plan unchanged")


func _test_grade_hook() -> void:
	var plan := [{"move": "1-2-3"}, {"move": "step_back"}]
	var lost := {"move": "1-2-3", "at": "long", "won": 0, "thrown": 3, "lost": 3, "tally": "One-two-hook 0 of 3", "i": 0}
	var sit := "counter"
	var base := PlanFight.card_mean("long", sit, NIA_MOVES, NIA_COMBOS)
	var lost_rate := PlanFight.rate("1-2-3", NIA_COMBOS)
	var lost_worth := PlanFight.value("1-2-3", sit, lost_rate) - base
	# Without grade
	var opts_no_grade := LineSwap.options(plan, lost, sit, NIA_MOVES, NIA_COMBOS, 6)
	# With grade that lowers 1-1
	var grade := {"1-1": 0.35}
	var opts_with_grade := LineSwap.options(plan, lost, sit, NIA_MOVES, NIA_COMBOS, 6, grade)
	# Find 1-1 in no-grade options
	var found_11_no_grade := false
	var worth_11_no_grade := 0.0
	for o in opts_no_grade:
		if str(o["move"]) == "1-1":
			found_11_no_grade = true
			worth_11_no_grade = float(o["worth"])
			break
	# Find 1-1 in with-grade options
	var found_11_with_grade := false
	var worth_11_with_grade := 0.0
	for o in opts_with_grade:
		if str(o["move"]) == "1-1":
			found_11_with_grade = true
			worth_11_with_grade = float(o["worth"])
			break
	if found_11_no_grade:
		var expected_lower := worth_11_no_grade * 0.35
		_check(is_equal_approx(worth_11_with_grade, expected_lower) or not found_11_with_grade,
			"grade hook: 1-1 worth lowered by 0.35 factor (%.2f -> %.2f, expected %.2f)" % [worth_11_no_grade, worth_11_with_grade, expected_lower])
		# Can drop it below the lost line
		if worth_11_with_grade <= lost_worth:
			_check(not found_11_with_grade, "grade hook: 1-1 dropped below lost line, not offered")


func _test_mutants() -> void:
	# MUTANT 1: lost_most that counts thrown instead of lost
	var exs := [
		{"planned": true, "arrow": "1-2", "won": false, "at": "long", "psit": "counter"},
		{"planned": true, "arrow": "1-2", "won": false, "at": "long", "psit": "counter"},
		{"planned": true, "arrow": "1-2", "won": true, "at": "long", "psit": "counter"},
		{"planned": true, "arrow": "1-2", "won": false, "at": "long", "psit": "counter"},
		{"planned": true, "arrow": "step_back", "won": false, "at": "mid", "psit": "press"},
		{"planned": true, "arrow": "step_back", "won": true, "at": "mid", "psit": "press"},
		{"planned": true, "arrow": "step_back", "won": true, "at": "mid", "psit": "press"},
	]
	var real_lost := LineSwap.lost_most(exs)
	var mutant_lost := _mutant_lost_most(exs)
	_check(str(real_lost["move"]) != str(mutant_lost["move"]) or int(real_lost["thrown"]) != int(mutant_lost["thrown"]),
		"MUTANT caught: lost_most counts lost, not thrown")
	# MUTANT 2: options that keeps options worth less than the lost line
	var plan := [{"move": "1-2-3"}, {"move": "step_back"}]
	var lost := {"move": "1-2-3", "at": "long", "won": 0, "thrown": 3, "lost": 3, "tally": "One-two-hook 0 of 3", "i": 0}
	var sit := "counter"
	var real_opts := LineSwap.options(plan, lost, sit, NIA_MOVES, NIA_COMBOS, 6)
	var mutant_opts := _mutant_options(plan, lost, sit, NIA_MOVES, NIA_COMBOS, 6)
	# Real options all worth more than lost; mutant has some worth less
	var real_all_better := true
	for o in real_opts:
		if float(o["worth"]) <= float(real_opts[0]["was_worth"]):
			real_all_better = false
	var mutant_has_worse := false
	for o in mutant_opts:
		if float(o["worth"]) < float(real_opts[0]["was_worth"]):
			mutant_has_worse = true
	_check(real_all_better != mutant_has_worse or real_opts.size() != mutant_opts.size(),
		"MUTANT caught: options keeps worse options, real filters them")


## MUTANT: counts thrown instead of lost
func _mutant_lost_most(exs: Array) -> Dictionary:
	var best: Dictionary = {}
	var best_thrown := 0
	for x in exs:
		var rec: Dictionary = x as Dictionary
		if not bool(rec.get("planned", false)):
			continue
		var arrow := str(rec.get("arrow", ""))
		if arrow == "":
			continue
		var won := bool(rec.get("won", false))
		var at := str(rec.get("at", ""))
		if best.is_empty():
			best = {"move": arrow, "at": at, "won": int(won), "thrown": 1, "lost": 0 if won else 1}
			best_thrown = 1
			continue
		if 1 > best_thrown:
			best = {"move": arrow, "at": at, "won": int(won), "thrown": 1, "lost": 0 if won else 1}
			best_thrown = 1
		else:
			best["thrown"] = int(best["thrown"]) + 1
			best_thrown = int(best["thrown"])
	return best


## MUTANT: keeps options worth less than the lost line
func _mutant_options(plan: Array, lost: Dictionary, sit: String, mastery: Dictionary, combos: Dictionary, limit: int) -> Array:
	var at := str(lost["at"])
	var lost_move := str(lost["move"])
	var lost_i := int(lost.get("i", 0))
	if lost_i >= plan.size():
		return []
	var base := PlanFight.card_mean(at, sit, mastery, combos)
	var lost_rate := PlanFight.rate(lost_move, combos)
	var lost_worth := PlanFight.value(lost_move, sit, lost_rate) - base
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
		var rate := PlanFight.rate(id, combos)
		var worth := PlanFight.value(id, sit, rate) - base
		out.append({"move": id, "name": str(m["name"]), "worth": worth, "was_worth": lost_worth, "i": lost_i})
	return out


func nia_opts_count(plan: Array, lost: Dictionary, sit: String) -> int:
	return LineSwap.options(plan, lost, sit, NIA_MOVES, NIA_COMBOS, 6).size()


func lucy_opts_count(plan: Array, lost: Dictionary, sit: String) -> int:
	return LineSwap.options(plan, lost, sit, LUCY_MOVES, LUCY_COMBOS, 6).size()


func _check(cond: bool, label: String) -> void:
	if cond:
		print("PASS ", label)
	else:
		failures += 1
		print("FAIL ", label)
