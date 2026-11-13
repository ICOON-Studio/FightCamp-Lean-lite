extends SceneTree
## S442 LINEGRADE1: how THIS boxer does each plan line. Pure module, pure test.
## Every expected number is built from Exchanges, PlanFight and Attrs in the test, never copied from the function.

const LineGrade := preload("res://scripts/rules/LineGrade.gd")
const Exchanges := preload("res://scripts/rules/Exchanges.gd")
const PlanFight := preload("res://scripts/rules/PlanFight.gd")
const StrikeMap := preload("res://scripts/rules/StrikeMap.gd")
const Attrs := preload("res://scripts/rules/Attrs.gd")
const Data := preload("res://scripts/state/Data.gd")

var failures := 0


func _initialize() -> void:
	# 1. Every non-forced move on the map has a pair with both keys in Attrs.ABILITIES; forced moves return {}.
	var pair_ok := true
	for m in StrikeMap.MOVES:
		var id: String = str(m["id"])
		var base := PlanFight.base_id(id)
		var kind: String = str(m["kind"])
		if kind == "forced":
			var g := LineGrade.grade(id, {})
			if not g.is_empty():
				pair_ok = false
				print("  forced move ", id, " should return {}")
			continue
		if not LineGrade.DONE_WITH.has(base):
			pair_ok = false
			print("  non-forced move ", id, " (base ", base, ") has no pair in DONE_WITH")
			continue
		var keys: Array = LineGrade.DONE_WITH[base]
		if keys.size() != 2:
			pair_ok = false
			print("  pair for ", base, " has ", keys.size(), " keys")
			continue
		for k in keys:
			if not Attrs.ABILITIES.has(str(k)):
				pair_ok = false
				print("  key ", k, " for ", base, " not in Attrs.ABILITIES")
	_check(pair_ok, "every non-forced move has a pair in DONE_WITH, both keys in Attrs.ABILITIES; forced moves return {}")

	# 2. The bands sit exactly on the code's lines: OK_AT - 0.5 = Poor, OK_AT = OK, GOOD_AT - 0.5 = OK, GOOD_AT = Good.
	var good_at: float = Exchanges.GOOD_AT
	var ok_at: float = Exchanges.OK_AT
	var attrs_poor := {"footwork": ok_at - 0.5, "speed": ok_at - 0.5}
	var g_poor := LineGrade.grade("step_back", attrs_poor)
	_check(str(g_poor["word"]) == "Poor", "mean OK_AT - 0.5 (%.1f) reads Poor" % ((ok_at - 0.5)))
	var attrs_ok_low := {"footwork": ok_at, "speed": ok_at}
	var g_ok_low := LineGrade.grade("step_back", attrs_ok_low)
	_check(str(g_ok_low["word"]) == "OK", "mean OK_AT (%.1f) reads OK" % ok_at)
	var attrs_ok_high := {"footwork": good_at - 0.5, "speed": good_at - 0.5}
	var g_ok_high := LineGrade.grade("step_back", attrs_ok_high)
	_check(str(g_ok_high["word"]) == "OK", "mean GOOD_AT - 0.5 (%.1f) reads OK" % (good_at - 0.5))
	var attrs_good := {"footwork": good_at, "speed": good_at}
	var g_good := LineGrade.grade("step_back", attrs_good)
	_check(str(g_good["word"]) == "Good", "mean GOOD_AT (%.1f) reads Good" % good_at)

	# 3. The map's example: footwork 47, speed 52 on "step_back" reads Poor.
	var tess_attrs := {"footwork": 47.0, "speed": 52.0}
	var g_tess := LineGrade.grade("step_back", tess_attrs)
	_check(str(g_tess["word"]) == "Poor", "Tess step_back: Footwork 47, Speed 52 reads Poor (mean %.1f)" % float(g_tess["mean"]))
	# next_line: footwork 48 for OK (2 x OK_AT - 52), footwork 72 for Good (2 x GOOD_AT - 52).
	var nl := LineGrade.next_line("step_back", tess_attrs)
	_check(nl.size() == 2, "next_line returns two entries")
	var need_ok: float = 2.0 * ok_at - 52.0
	var need_good: float = 2.0 * good_at - 52.0
	_check(float(nl[0]["ok_at"]) == need_ok, "next_line: footwork %.0f for OK (computed 2 x OK_AT - 52)" % need_ok)
	_check(float(nl[0]["good_at"]) == need_good, "next_line: footwork %.0f for Good (computed 2 x GOOD_AT - 52)" % need_good)

	# 4. graded_value: PlanFight.value x PLUS on a plus, x COMMIT on a minus, 0 stays 0.
	var best_attrs := {"footwork": 70.0, "speed": 70.0}
	var ok_attrs := {"accuracy": 55.0, "speed": 55.0}
	var poor_attrs := {"footwork": 30.0, "speed": 30.0}
	# best: step_back vs press (best fit = 9.0 x rate 1.0)
	var bv := PlanFight.value("step_back", "press", 1.0)
	var gv_best := LineGrade.graded_value("step_back", "press", 1.0, best_attrs)
	_check(gv_best == bv * float(LineGrade.PLUS["Good"]),
		"graded_value on a best move (Good): %.1f = PlanFight.value %.1f x PLUS[Good] %.2f" % [gv_best, bv, float(LineGrade.PLUS["Good"])])
	# ok: 1-2 vs range (ok fit = 3.0)
	var ov := PlanFight.value("1-2", "range", 1.0)
	var gv_ok := LineGrade.graded_value("1-2", "range", 1.0, ok_attrs)
	_check(gv_ok == ov * float(LineGrade.PLUS["OK"]),
		"graded_value on an ok move (OK): %.1f = PlanFight.value %.1f x PLUS[OK] %.2f" % [gv_ok, ov, float(LineGrade.PLUS["OK"])])
	# wrong: step_in vs press (wrong fit = -7.0)
	var wv := PlanFight.value("step_in", "press", 1.0)
	var gv_wrong := LineGrade.graded_value("step_in", "press", 1.0, poor_attrs)
	_check(gv_wrong == wv * float(Exchanges.COMMIT["Poor"]),
		"graded_value on a wrong move (Poor): %.1f = PlanFight.value %.1f x COMMIT[Poor] %.2f" % [gv_wrong, wv, float(Exchanges.COMMIT["Poor"])])
	# 0 stays 0
	var gv_zero := LineGrade.graded_value("feint", "press", 1.0, best_attrs)
	_check(gv_zero == 0.0, "graded_value on a no-fit move: 0 stays 0")

	# 5. THE SWAP IS REAL: same move, two attr sets - Good attrs give higher worth than Poor attrs when the base
	# value is positive (the grade multiplier matters). Also: swap_hint on a Poor move finds a better alternative.
	var swap_move := "step_back"
	var swap_sit := "press"
	var swap_good_a := {"footwork": 75.0, "speed": 75.0, "strength": 55.0, "inside": 55.0,
		"accuracy": 55.0, "timing": 55.0, "explosiveness": 55.0, "stamina": 55.0,
		"fight_iq": 55.0, "composure": 55.0, "defence": 55.0, "flexibility": 55.0, "durability": 55.0}
	var swap_poor_a := {"footwork": 30.0, "speed": 30.0, "strength": 55.0, "inside": 55.0,
		"accuracy": 55.0, "timing": 55.0, "explosiveness": 55.0, "stamina": 55.0,
		"fight_iq": 55.0, "composure": 55.0, "defence": 55.0, "flexibility": 55.0, "durability": 55.0}
	var mastery := {"Jab": 60.0, "Cross": 55.0, "Lead hook": 45.0, "Body hook": 45.0, "Uppercut": 10.0, "Check hook": 0.0}
	var combos := {"1-2": 40.0, "1-2-3": 30.0, "1-2-3b": 30.0, "3b-3": 40.0}
	var w_good := LineGrade.worth(swap_move, "mid", swap_sit, mastery, combos, swap_good_a)
	var w_poor := LineGrade.worth(swap_move, "mid", swap_sit, mastery, combos, swap_poor_a)
	_check(w_good > w_poor, "grade matters: worth(Good attrs %.1f) > worth(Poor attrs %.1f) on same move" % [w_good, w_poor])
	# swap_hint: with Poor attrs on step_back, a different move on the same card is worth more.
	var swap_pairs_differ: bool = LineGrade.DONE_WITH[PlanFight.base_id("step_back")] != LineGrade.DONE_WITH[PlanFight.base_id("3b-3")]
	_check(swap_pairs_differ, "swap test: step_back and 3b-3 have different attribute pairs")
	var swap_attrs := swap_poor_a
	var w_best := w_poor
	var w_ok := LineGrade.worth("3b-3", "mid", swap_sit, mastery, combos, swap_attrs)
	var hint := LineGrade.swap_hint(swap_move, swap_sit, mastery, combos, swap_attrs)
	if not hint.is_empty():
		var hint_w: float = float(hint["worth"])
		_check(hint_w > w_best, "swap_hint on the Poor move finds something worth more (%.1f > %.1f)" % [hint_w, w_best])

	# 6. Two real boxers (Kira and Samira): at least one move grades differently; every grade reads the numbers.
	var kira := Data.PROSPECTS[0].duplicate(true)
	var samira := Data.PROSPECTS[1].duplicate(true)
	var a_kira := Attrs.of(kira)
	var a_samira := Attrs.of(samira)
	var diff_found := false
	var numbers_ok := true
	for m in StrikeMap.MOVES:
		var mid: String = str(m["id"])
		if str(m["kind"]) == "forced":
			continue
		var gk := LineGrade.grade(mid, a_kira)
		var gs := LineGrade.grade(mid, a_samira)
		if gk.is_empty() or gs.is_empty():
			continue
		if str(gk["word"]) != str(gs["word"]):
			diff_found = true
		for p in gk["pair"]:
			var k: String = str(p[0])
			var v: float = float(p[1])
			if absf(v - float(a_kira.get(k, -999.0))) > 0.01:
				numbers_ok = false
		for p in gs["pair"]:
			var k: String = str(p[0])
			var v: float = float(p[1])
			if absf(v - float(a_samira.get(k, -999.0))) > 0.01:
				numbers_ok = false
	_check(diff_found, "Kira and Samira: at least one move grades differently between them")
	_check(numbers_ok, "every grade reads the numbers Attrs.of gave")

	# 7. chain_grade of two moves equals the grade of the mean of their two means; coach_ok false only on Poor.
	var g1 := LineGrade.grade("1-1", a_kira)
	var g2 := LineGrade.grade("1-2", a_kira)
	var chain_mean := (float(g1["mean"]) + float(g2["mean"])) * 0.5
	var cg := LineGrade.chain_grade(["1-1", "1-2"], a_kira)
	_check(absf(float(cg["mean"]) - chain_mean) < 0.01, "chain_grade mean (%.1f) = mean of move means (%.1f)" % [float(cg["mean"]), chain_mean])
	var chain_word := "Good" if chain_mean >= good_at else ("OK" if chain_mean >= ok_at else "Poor")
	_check(str(cg["word"]) == chain_word, "chain_grade word matches the band (%s)" % chain_word)
	# coach_ok: false only on Poor.
	var poor_move := "step_back"
	var poor_a := {"footwork": 30.0, "speed": 30.0}
	_check(not LineGrade.coach_ok(poor_move, poor_a), "coach_ok is false on Poor")
	var ok_a := {"footwork": 55.0, "speed": 55.0}
	_check(LineGrade.coach_ok(poor_move, ok_a), "coach_ok is true on OK")
	var good_a := {"footwork": 70.0, "speed": 70.0}
	_check(LineGrade.coach_ok(poor_move, good_a), "coach_ok is true on Good")

	# 8. words() names both attributes with their values; no pronoun.
	var w := LineGrade.words("step_back", tess_attrs, "Tess")
	_check(w.contains("Tess") and w.contains("Poor") and w.contains("Footwork") and w.contains("47")
		and w.contains("Speed") and w.contains("52"), "words: Tess does it: Poor (Footwork 47, Speed 52)")
	_check(not w.contains("she") and not w.contains("he") and not w.contains("her") and not w.contains("his"),
		"words: no pronoun")
	# forced move returns ""
	_check(LineGrade.words("backed_up", {}, "Tess") == "", "words: forced move returns empty")

	# 8b. GRADE1: an average boxer's mean multiplier over the roster's lines is 1.00 +- 0.03.
	var total_mv := 0.0
	var base_mv := 0.0
	for prospect in Data.PROSPECTS:
		var fs := Data.fighter_state(prospect.duplicate(true), 0)
		var p_attrs: Dictionary = Attrs.of(fs)
		for mid in LineGrade.DONE_WITH:
			var g := LineGrade.grade(str(mid), p_attrs)
			if g.is_empty():
				continue
			var mv: float = absf(PlanFight.value(str(mid), "range", 1.0))
			base_mv += mv
			total_mv += mv * float(LineGrade.PLUS[str(g["word"])])
	var mean_mult: float = total_mv / base_mv if base_mv > 0.0 else 1.0
	_check(absf(mean_mult - 1.0) <= 0.03,
		"GRADE1: average boxer's mean multiplier %.3f is 1.00 +- 0.03" % mean_mult)

	# 9. MUTANTS: a copy of grade with > instead of >= at OK_AT must FAIL; a copy of graded_value with PLUS and
	# COMMIT swapped must FAIL. Each uncaught mutant is a failure.
	# Mutant 1: grade with > instead of >= at OK_AT.
	var mutant1_caught := false
	var m1_ok := _mutant1_grade("step_back", {"footwork": ok_at, "speed": ok_at})
	if str(m1_ok.get("word", "")) != "OK":
		mutant1_caught = true
	if not mutant1_caught:
		failures += 1
		print("FAIL MUTANT 1 uncaught: grade with > instead of >= at OK_AT should not read OK at exactly OK_AT")
	else:
		print("PASS MUTANT caught: grade with > at OK_AT fails the band assert")
	# Mutant 2: graded_value with PLUS and COMMIT swapped.
	var mutant2_caught := false
	var m2_gv := _mutant2_graded_value("step_back", "press", 1.0, best_attrs)
	var expected_plus := bv * float(LineGrade.PLUS["Good"])
	if absf(m2_gv - expected_plus) > 0.01:
		mutant2_caught = true
	if not mutant2_caught:
		failures += 1
		print("FAIL MUTANT 2 uncaught: graded_value with PLUS/COMMIT swapped should not match the real PLUS result")
	else:
		print("PASS MUTANT caught: graded_value with PLUS/COMMIT swapped fails the value assert")

	print("LINE_GRADE failures=%d" % failures)
	quit(1 if failures > 0 else 0)


## Mutant 1: grade with > instead of >= at OK_AT (the boundary shifts).
func _mutant1_grade(move_id: String, attrs: Dictionary) -> Dictionary:
	var id := PlanFight.base_id(move_id)
	if not LineGrade.DONE_WITH.has(id):
		return {}
	var keys: Array = LineGrade.DONE_WITH[id]
	var a: float = float(attrs.get(str(keys[0]), 55.0))
	var b: float = float(attrs.get(str(keys[1]), 55.0))
	var mean := (a + b) * 0.5
	var good_at: float = Exchanges.GOOD_AT
	var ok_at: float = Exchanges.OK_AT
	var word := "Good" if mean > good_at else ("OK" if mean > ok_at else "Poor")
	return {"word": word, "mean": mean, "pair": [[str(keys[0]), a], [str(keys[1]), b]]}


## Mutant 2: graded_value with PLUS and COMMIT swapped.
func _mutant2_graded_value(move_id: String, sit: String, rate_mult: float, attrs: Dictionary) -> float:
	var base := PlanFight.value(move_id, sit, rate_mult)
	if base == 0.0:
		return 0.0
	var g := LineGrade.grade(move_id, attrs)
	if g.is_empty():
		return base
	var word: String = str(g["word"])
	if base > 0.0:
		return base * float(Exchanges.COMMIT[word])
	return base * float(LineGrade.PLUS[word])


func _check(cond: bool, label: String) -> void:
	if cond:
		print("PASS ", label)
	else:
		failures += 1
		print("FAIL ", label)
