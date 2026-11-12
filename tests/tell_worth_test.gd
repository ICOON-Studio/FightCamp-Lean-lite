extends SceneTree
## R19WORTH1 a hidden tell shown as a RANGE of worth, exact once found. Pure rule module + its test.
## Population: Maria Ortega (Pressure fighter, Data.OPPONENTS[0]) and Priya Nair (Counter-puncher, [1]);
## two boxers: "raw" (jab and cross only) and "drilled" (every punch, the one-two and cross-hook drilled).

const Data := preload("res://scripts/state/Data.gd")
const OppFile := preload("res://scripts/rules/OppFile.gd")
const PlanLines := preload("res://scripts/rules/PlanLines.gd")
const Exchanges := preload("res://scripts/rules/Exchanges.gd")
const TW := preload("res://scripts/rules/TellWorth.gd")

const RAW := {"Jab": 45.0, "Cross": 35.0, "Lead hook": 10.0, "Body hook": 0.0, "Uppercut": 0.0, "Check hook": 0.0}
const DRILLED := {"Jab": 70.0, "Cross": 66.0, "Lead hook": 58.0, "Body hook": 50.0, "Uppercut": 41.0, "Check hook": 38.0}
const DRILLED_COMBOS := {"1-2": 55.0, "2-3": 40.0}
const ROUNDS := 3

var failures := 0


func _initialize() -> void:
	var maria: Dictionary = (Data.OPPONENTS[0] as Dictionary).duplicate(true)
	var priya: Dictionary = (Data.OPPONENTS[1] as Dictionary).duplicate(true)

	# 1. candidates: the distinct column-3 values from the tables, recomputed in the test.
	var exp_weapon: Dictionary = {}
	for r in OppFile.WEAPON_ANSWERS:
		exp_weapon[str(r[3])] = true
	var got_weapon: Dictionary = {}
	for s in TW.candidates("weapon"):
		got_weapon[str(s)] = true
	_check(exp_weapon == got_weapon, "candidates(weapon) matches WEAPON_ANSWERS column 3: %s" % str(got_weapon.keys()))

	var exp_weak: Dictionary = {}
	for r in OppFile.WEAKNESS_ANSWERS:
		exp_weak[str(r[3])] = true
	var got_weak: Dictionary = {}
	for s in TW.candidates("weakness"):
		got_weak[str(s)] = true
	_check(exp_weak == got_weak, "candidates(weakness) matches WEAKNESS_ANSWERS column 3: %s" % str(got_weak.keys()))

	var exp_habit: Dictionary = {}
	for k in PlanLines.HABIT_SITS:
		exp_habit[str(PlanLines.HABIT_SITS[k])] = true
	var got_habit: Dictionary = {}
	for s in TW.candidates("habit"):
		got_habit[str(s)] = true
	_check(exp_habit == got_habit, "candidates(habit) matches HABIT_SITS values: %s" % str(got_habit.keys()))

	# 2. kind_of
	_check(TW.kind_of("weapon") == "weapon" and TW.kind_of("weakness") == "weakness" and TW.kind_of("habit:fades_late") == "habit" and TW.kind_of("look") == "", "kind_of: weapon, weakness, habit:..., else empty")

	# 3. worth_a_use: equals the best usable PlanLines.options edge recomputed in the test.
	var sit_press := "press"
	var place := PlanLines.place_for(sit_press)
	var opts := PlanLines.options(place, sit_press, DRILLED, DRILLED_COMBOS)
	var exp_best := 0.0
	for o in opts:
		if str(o["why"]) == "":
			exp_best = maxf(exp_best, float(o["edge"]))
	exp_best = maxf(exp_best, 0.0)
	_check(is_equal_approx(TW.worth_a_use(sit_press, DRILLED, DRILLED_COMBOS), exp_best), "worth_a_use(press, drilled) = %.2f (recomputed from PlanLines.options)" % exp_best)
	_check(is_equal_approx(TW.worth_a_use("", DRILLED, DRILLED_COMBOS), 0.0), "worth_a_use empty sit = 0")

	# worth_a_use with raw fighter (lower pad time)
	var raw_val := TW.worth_a_use(sit_press, RAW, {})
	var opts_raw := PlanLines.options(place, sit_press, RAW, {})
	var exp_raw := 0.0
	for o in opts_raw:
		if str(o["why"]) == "":
			exp_raw = maxf(exp_raw, float(o["edge"]))
	exp_raw = maxf(exp_raw, 0.0)
	_check(is_equal_approx(raw_val, exp_raw), "worth_a_use(press, raw) = %.2f (recomputed)" % exp_raw)

	# 4. uses_a_bout: for "press" on a Pressure fighter = STYLE_MODES share x EXCHANGES x rounds.
	var press_share := float((Exchanges.STYLE_MODES["Pressure fighter"] as Dictionary)["press"])
	var exp_uses := press_share * float(Exchanges.EXCHANGES) * float(ROUNDS)
	_check(is_equal_approx(TW.uses_a_bout("press", maria, ROUNDS), exp_uses), "uses_a_bout(press, Maria, %d) = %.2f = %.2f x %d x %d" % [ROUNDS, exp_uses, press_share, Exchanges.EXCHANGES, ROUNDS])

	# "tiring" = OTHER_USES (one round's exchanges; an ESTIMATE)
	_check(is_equal_approx(TW.uses_a_bout("tiring", maria, ROUNDS), float(TW.OTHER_USES)), "uses_a_bout(tiring) = OTHER_USES = %d" % TW.OTHER_USES)

	# 5. Hidden weapon: lo <= exact worth <= hi; once open, lo == hi == exact worth. REVIEW3: every expected number is
	# recomputed HERE from OppFile, PlanLines and Exchanges (the delivery used TW.worth_a_use / TW.uses_a_bout).
	var hidden_before := OppFile.hidden(maria)
	_check(not hidden_before.is_empty() and str(hidden_before[0]) == "weapon", "Maria's first hidden tell is weapon")
	var r_hidden := TW.range_of(maria, "weapon", DRILLED, DRILLED_COMBOS, ROUNDS)
	_check(not bool(r_hidden["known"]), "weapon is hidden: known=false")
	var want_hidden := _range_here(maria, "weapon", DRILLED, DRILLED_COMBOS)
	_check(_range_ok(r_hidden, want_hidden), "hidden weapon range = min/max over the candidates, recomputed: [%.2f, %.2f] (want [%.2f, %.2f])"
		% [float(r_hidden["lo"]), float(r_hidden["hi"]), float(want_hidden["lo"]), float(want_hidden["hi"])])
	var maria_open: Dictionary = (Data.OPPONENTS[0] as Dictionary).duplicate(true)
	OppFile.open(maria_open, "weapon")
	var real_sit := _real_sit_here(maria_open, "weapon")
	var exp_exact := _worth_here(real_sit, DRILLED, DRILLED_COMBOS) * _uses_here(real_sit, maria_open)
	_check(float(r_hidden["lo"]) <= exp_exact and exp_exact <= float(r_hidden["hi"]) and float(r_hidden["lo"]) < float(r_hidden["hi"]),
		"hidden range covers the exact worth and is a real range: %.2f in [%.2f, %.2f] (sit '%s')" % [exp_exact, r_hidden["lo"], r_hidden["hi"], real_sit])
	var r_known := TW.range_of(maria_open, "weapon", DRILLED, DRILLED_COMBOS, ROUNDS)
	_check(bool(r_known["known"]) and _range_ok(r_known, {"lo": exp_exact, "hi": exp_exact}),
		"once open: lo == hi == %.2f (sit '%s')" % [exp_exact, real_sit])

	# 5b. REVIEW3 the one trap: while hidden, nothing depends on WHICH tell it is. Two Pressure fighters with different real
	# weapons (body hook -> press; long jab -> range) show the same hidden range, and each real worth sits inside it.
	var other: Dictionary = maria.duplicate(true)
	other["threat"] = "Long jab"
	var other_open: Dictionary = other.duplicate(true)
	OppFile.open(other_open, "weapon")
	_check(_real_sit_here(other_open, "weapon") != real_sit, "test setup: the two weapons answer different situations")
	var r_other := TW.range_of(other, "weapon", DRILLED, DRILLED_COMBOS, ROUNDS)
	_check(_range_ok(r_other, {"lo": r_hidden["lo"], "hi": r_hidden["hi"]}), "hidden range does not depend on which weapon it is")
	# every row's real situation is one of the candidates, so no real tell can fall outside a hidden range
	var cover := true
	for tbl in [[OppFile.WEAPON_ANSWERS, "weapon"], [OppFile.WEAKNESS_ANSWERS, "weakness"]]:
		for row in tbl[0]:
			var sit := PlanLines.tell_sit({"id": tbl[1], "when": str(row[3]), "call": str(row[2])})
			cover = cover and TW.candidates(str(tbl[1])).has(sit)
	_check(cover, "every weapon and weakness row's real situation is a candidate of its kind")

	# 5c. worth 0 when the boxer has no answer that beats the card's own average there (RAW at a pressure fighter's mid range).
	var raw_press := _worth_here("press", RAW, {})
	_check(is_equal_approx(raw_press, 0.0) and is_equal_approx(TW.worth_a_use("press", RAW, {}), 0.0),
		"raw boxer against pressure: no answer worth more than the card's average, worth 0 (got %.2f)" % TW.worth_a_use("press", RAW, {}))

	# 6. next_film: names the first hidden id; after opening it on a copy, names the NEXT one (REVIEW3: exactly
	# OppFile.hidden's second, not just "a different tell"); no tape gives {}.
	var nf := TW.next_film(maria, DRILLED, DRILLED_COMBOS, ROUNDS)
	_check(not nf.is_empty() and str(nf["id"]) == str(hidden_before[0]), "next_film: first hidden is weapon (%s)" % str(nf.get("id", "")))
	_check(not nf.is_empty() and is_equal_approx(float(nf["lo"]), float(want_hidden["lo"])) and is_equal_approx(float(nf["hi"]), float(want_hidden["hi"])),
		"next_film carries the hidden range")
	var nf2 := TW.next_film(maria_open, DRILLED, DRILLED_COMBOS, ROUNDS)
	_check(not nf2.is_empty() and str(nf2["id"]) == str(hidden_before[1]), "after opening weapon, next_film names %s (got %s)" % [str(hidden_before[1]), str(nf2.get("id", ""))])
	var no_tape_opp: Dictionary = (Data.OPPONENTS[0] as Dictionary).duplicate(true)
	no_tape_opp["w"] = 0
	no_tape_opp["l"] = 0
	_check(not OppFile.has_tape(no_tape_opp) and TW.next_film(no_tape_opp, DRILLED, DRILLED_COMBOS, ROUNDS).is_empty(), "no tape (0-0 record): next_film = {}")

	# 7. range_of, next_film and file never change the opponent (REVIEW3: the WHOLE dict, deep, not only file_found).
	var maria_fresh: Dictionary = (Data.OPPONENTS[0] as Dictionary).duplicate(true)
	OppFile.open(maria_fresh, "weapon")
	var before := var_to_str(maria_fresh)
	var _r := TW.range_of(maria_fresh, "weakness", DRILLED, DRILLED_COMBOS, ROUNDS)
	var _nf := TW.next_film(maria_fresh, DRILLED, DRILLED_COMBOS, ROUNDS)
	var _f := TW.file(maria_fresh, DRILLED, DRILLED_COMBOS, ROUNDS)
	_check(var_to_str(maria_fresh) == before, "range_of/next_film/file never change the opponent (deep compare)")

	# 8. Better-drilled boxer's hi >= the other's hi on the same tell (and strictly more here, so it is not 0 >= 0).
	var r_drilled := TW.range_of(maria, "weapon", DRILLED, DRILLED_COMBOS, ROUNDS)
	var r_raw := TW.range_of(maria, "weapon", RAW, {}, ROUNDS)
	_check(float(r_drilled["hi"]) > float(r_raw["hi"]), "drilled hi (%.2f) > raw hi (%.2f) on same tell" % [r_drilled["hi"], r_raw["hi"]])

	# 9. file(): one range per tape tell, in file order.
	var tape_file := TW.file(maria, DRILLED, DRILLED_COMBOS, ROUNDS)
	var tape_tells: Array = OppFile.tells(maria).filter(func(t): return str(t["how"]) == "tape")
	_check(tape_file.size() == tape_tells.size(), "file: %d ranges for %d tape tells" % [tape_file.size(), tape_tells.size()])
	_check(not bool(tape_file[0]["known"]), "file[0] (weapon) is hidden")

	# 10. Priya: a different opponent, different style.
	var priya_hidden := OppFile.hidden(priya)
	_check(not priya_hidden.is_empty(), "Priya has hidden tells")
	var r_priya := TW.range_of(priya, str(priya_hidden[0]), DRILLED, DRILLED_COMBOS, ROUNDS)
	_check(_range_ok(r_priya, _range_here(priya, str(priya_hidden[0]), DRILLED, DRILLED_COMBOS)), "Priya: hidden range recomputed")
	var priya_press_uses := TW.uses_a_bout("press", priya, ROUNDS)
	var priya_counter_uses := TW.uses_a_bout("counter", priya, ROUNDS)
	_check(priya_counter_uses > priya_press_uses, "Priya (Counter-puncher): counter uses (%.2f) > press uses (%.2f)" % [priya_counter_uses, priya_press_uses])
	var nobody: Dictionary = {"style": "Unknown style", "w": 1, "l": 0}
	_check(is_equal_approx(TW.uses_a_bout("press", nobody, ROUNDS), 0.0), "a style the table does not know presses 0 times")

	# 11. MUTANTS, through the SAME asserts the real module passes.
	var leak := _mutant_leak_range(maria, "weapon", DRILLED, DRILLED_COMBOS)
	var leak_fails := not _range_ok(leak, want_hidden)
	_check(leak_fails, "MUTANT leak fails the hidden-range assert")
	if leak_fails:
		print("  MUTANT caught: leak")
	# The no-floor copy: PlanLines rates an option against the card mean of the moves the boxer can throw (PlanFight.card_mean),
	# so the best usable edge is never below 0 and the floor cannot be reached with today's tables: the mutant is EQUIVALENT.
	# This checks that reason on every situation for both boxers; it goes red the day the floor starts to matter.
	var floor_matters := false
	for sit in ["press", "range", "counter", "loadup", "tiring", "hurt", "she_hurt", "she_tired"]:
		for b in [[RAW, {}], [DRILLED, DRILLED_COMBOS]]:
			if not is_equal_approx(_mutant_no_floor(sit, b[0], b[1]), TW.worth_a_use(sit, b[0], b[1])):
				floor_matters = true
	if floor_matters:
		print("  MUTANT caught: no floor")
	else:
		print("  MUTANT equivalent: no floor (best usable edge >= the card mean on every situation)")

	print("TELL_WORTH failures=%d" % failures)
	quit(1 if failures > 0 else 0)


## REVIEW3: the test's own recomputation of worth a use (PlanLines.options, best usable edge, floored at 0).
func _worth_here(sit: String, mastery: Dictionary, combos: Dictionary) -> float:
	if sit == "":
		return 0.0
	var best := 0.0
	for o in PlanLines.options(PlanLines.place_for(sit), sit, mastery, combos):
		if str(o["why"]) == "":
			best = maxf(best, float(o["edge"]))
	return best


## REVIEW3: uses a bout recomputed from Exchanges (share x EXCHANGES x rounds for the four games, else one round).
func _uses_here(sit: String, opp: Dictionary) -> float:
	var row: Dictionary = Exchanges.STYLE_MODES.get(str(opp.get("style", "")), {})
	var games: Dictionary = Exchanges.STYLE_MODES["Pressure fighter"]
	if games.has(sit):
		return float(row.get(sit, 0.0)) * float(Exchanges.EXCHANGES) * float(ROUNDS)
	return float(Exchanges.EXCHANGES)


func _real_sit_here(opp: Dictionary, id: String) -> String:
	for t in OppFile.tells(opp):
		if str(t["id"]) == id:
			return PlanLines.tell_sit(t)
	return ""


## The hidden range recomputed: min and max of worth x uses over the candidate situations of the tell's kind, built here.
func _range_here(opp: Dictionary, id: String, mastery: Dictionary, combos: Dictionary) -> Dictionary:
	var sits: Dictionary = {}
	if id == "weapon":
		for r in OppFile.WEAPON_ANSWERS:
			sits[str(r[3])] = true
	elif id == "weakness":
		for r in OppFile.WEAKNESS_ANSWERS:
			sits[str(r[3])] = true
	else:
		for k in PlanLines.HABIT_SITS:
			sits[str(PlanLines.HABIT_SITS[k])] = true
	var lo := INF
	var hi := -INF
	for s in sits:
		var v := _worth_here(str(s), mastery, combos) * _uses_here(str(s), opp)
		lo = minf(lo, v)
		hi = maxf(hi, v)
	return {"lo": lo, "hi": hi}


func _range_ok(got: Dictionary, want: Dictionary) -> bool:
	return is_equal_approx(float(got["lo"]), float(want["lo"])) and is_equal_approx(float(got["hi"]), float(want["hi"]))


## MUTANT: a copy of range_of that, while hidden, returns only the real situation's worth (leaks the hidden tell).
func _mutant_leak_range(opp: Dictionary, id: String, mastery: Dictionary, combos: Dictionary) -> Dictionary:
	var sit := _real_sit_here(opp, id)
	var v := TW.worth_a_use(sit, mastery, combos) * TW.uses_a_bout(sit, opp, ROUNDS)
	return {"lo": v, "hi": v, "known": false, "sits": [sit]}


## MUTANT: a copy of worth_a_use without the floor at 0.
func _mutant_no_floor(sit: String, mastery: Dictionary, combos: Dictionary) -> float:
	if sit == "":
		return 0.0
	var best := -INF
	for o in PlanLines.options(PlanLines.place_for(sit), sit, mastery, combos):
		if str(o["why"]) == "":
			best = maxf(best, float(o["edge"]))
	return best


func _check(cond: bool, label: String) -> void:
	if cond:
		print("PASS ", label)
	else:
		failures += 1
		print("FAIL ", label)
