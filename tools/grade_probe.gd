extends SceneTree
## GRADE1 probe: find the centred PLUS table (mean_mult 1.00) that keeps right_plan_GOOD within 10 of the ungraded
## baseline and makes Good vs Poor on a line worth 2+ wins in 100. Same 540 bouts fight_why_test uses (days 40.., GOOD
## plan, Lucy vs Maria). Arms A-E: A wired=false (today), B current PLUS, C/D/E centred with spread +-0.2/0.3/0.4.
## Then GOOD_VS_POOR: two boxers who differ only in one planned line's two attributes, 500 bouts each.

const Data := preload("res://scripts/state/Data.gd")
const Bouts := preload("res://scripts/state/Bouts.gd")
const FightWhy := preload("res://scripts/rules/FightWhy.gd")
const LineGrade := preload("res://scripts/rules/LineGrade.gd")
const Attrs := preload("res://scripts/rules/Attrs.gd")
const PlanFight := preload("res://scripts/rules/PlanFight.gd")
const StrikeMap := preload("res://scripts/rules/StrikeMap.gd")
const BoutRead := preload("res://scripts/rules/BoutRead.gd")

const GOOD := [{"move": "1-1"}, {"move": "step_back"}, {"move": "pivot_out"}, {"move": "tie_up"}]
const BOUTS := 540


func _initialize() -> void:
	print("GRADE_PROBE grade distribution over roster:")
	var dist := _grade_dist()
	var g_share := float(dist["good"]) / float(dist["total"])
	var o_share := float(dist["ok"]) / float(dist["total"])
	var p_share := float(dist["poor"]) / float(dist["total"])
	print("  good=%d ok=%d poor=%d total=%d (shares %.3f / %.3f / %.3f)" % [
		dist["good"], dist["ok"], dist["poor"], dist["total"], g_share, o_share, p_share])
	print("  value-weighted: total_value=%.1f base_total=%.1f" % [dist["total_value"], dist["base_total"]])
	print("")

	# Arm A: wired=false (today's ungraded baseline).
	print("Running arms (540 bouts each)...")
	var arm_a := _run_arm("A", false, {"Good": 1.0, "OK": 1.0, "Poor": 1.0})
	var base_good: int = arm_a[2]

	# Arms B-G: wired=true with different PLUS tables.
	# B = the original (too low). C/D/E = OK=1.0 spreads (mean off). F/G = centred on the roster's distribution.
	var arm_b := _run_arm("B", true, {"Good": 1.2, "OK": 0.85, "Poor": 0.35})
	var arm_c := _run_arm("C", true, {"Good": 1.2, "OK": 1.0, "Poor": 0.8})
	var arm_d := _run_arm("D", true, {"Good": 1.3, "OK": 1.0, "Poor": 0.7})
	var arm_e := _run_arm("E", true, {"Good": 1.4, "OK": 1.0, "Poor": 0.6})
	var arm_f := _run_arm("F", true, {"Good": 1.15, "OK": 0.95, "Poor": 0.85})
	var arm_g := _run_arm("G", true, {"Good": 1.20, "OK": 0.95, "Poor": 0.80})
	var arm_h := _run_arm("H", true, {"Good": 1.15, "OK": 0.99, "Poor": 0.90})
	var arm_i := _run_arm("I", true, {"Good": 1.20, "OK": 0.97, "Poor": 0.80})

	print("")
	print("GRADE_PROBE summary:")
	print("  Arm A (ungraded):  right_plan_GOOD=%d/540" % arm_a[2])
	print("  Arm B (current):   right_plan_GOOD=%d/540 (delta %d)" % [arm_b[2], arm_b[2] - base_good])
	print("  Arm C (+-0.2):     right_plan_GOOD=%d/540 (delta %d)" % [arm_c[2], arm_c[2] - base_good])
	print("  Arm D (+-0.3):     right_plan_GOOD=%d/540 (delta %d)" % [arm_d[2], arm_d[2] - base_good])
	print("  Arm E (+-0.4):     right_plan_GOOD=%d/540 (delta %d)" % [arm_e[2], arm_e[2] - base_good])
	print("  Arm F (0.20/0.95): right_plan_GOOD=%d/540 (delta %d)" % [arm_f[2], arm_f[2] - base_good])
	print("  Arm G (0.25/0.95): right_plan_GOOD=%d/540 (delta %d)" % [arm_g[2], arm_g[2] - base_good])
	print("  Arm H (0.16/0.99): right_plan_GOOD=%d/540 (delta %d)" % [arm_h[2], arm_h[2] - base_good])
	print("  Arm I (0.23/0.97): right_plan_GOOD=%d/540 (delta %d)" % [arm_i[2], arm_i[2] - base_good])

	# Find the smallest-spread centred table within 10 of arm A and mean_mult within 0.03 of 1.00.
	var chosen_name := ""
	var chosen_plus := {}
	var arms_to_check := [
		["H", {"Good": 1.15, "OK": 0.99, "Poor": 0.90}, arm_h],
		["I", {"Good": 1.20, "OK": 0.97, "Poor": 0.80}, arm_i],
		["F", {"Good": 1.15, "OK": 0.95, "Poor": 0.85}, arm_f],
		["G", {"Good": 1.20, "OK": 0.95, "Poor": 0.80}, arm_g],
		["C", {"Good": 1.2, "OK": 1.0, "Poor": 0.8}, arm_c],
		["D", {"Good": 1.3, "OK": 1.0, "Poor": 0.7}, arm_d],
		["E", {"Good": 1.4, "OK": 1.0, "Poor": 0.6}, arm_e],
	]
	for arm in arms_to_check:
		var name: String = str(arm[0])
		var plus: Dictionary = arm[1] as Dictionary
		var result: Array = arm[2] as Array
		var rpg: int = result[2]
		var mm: float = result[3]
		if absi(rpg - base_good) <= 10 and absf(mm - 1.0) <= 0.03:
			chosen_name = name
			chosen_plus = plus.duplicate()
			break
	if chosen_name == "":
		print("  NO centred table within 10 of arm A (%d)" % base_good)
	else:
		print("  CHOSEN: Arm %s (within 10 of %d)" % [chosen_name, base_good])
		print("")
		_good_vs_poor(chosen_plus)

	print("GRADE_PROBE done")
	quit(0)


## Run one arm: set LineGrade, clear caches, fight BOUTS bouts, return [rpg, wins, rpg_int, mean_mult, win_share_str].
func _run_arm(name: String, w: bool, plus: Dictionary) -> Array:
	LineGrade.wired = w
	LineGrade.PLUS = plus.duplicate()
	BoutRead.clear_cache()
	var rpg := 0
	var wins := 0
	for i in BOUTS:
		var m := _bout(40 + i, GOOD)
		var grade := str(FightWhy.read(m["rounds"], "Lucy", "Maria")["grade"])
		if grade == "good":
			rpg += 1
		var rw := 0
		for r in m.get("rounds", []):
			if bool(r.get("won", false)):
				rw += 1
		if rw * 2 > m.get("rounds", []).size():
			wins += 1
	var dist := _grade_dist()
	var mean_mult: float = 1.0
	if float(dist["base_total"]) > 0.0:
		mean_mult = float(dist["total_value"]) / float(dist["base_total"])
	var ws := float(wins) / float(BOUTS)
	print("ARM %s wired=%s good=%.2f ok=%.2f poor=%.2f mean_mult=%.3f right_plan_GOOD=%d/540 win_share=%.3f" % [
		name, str(w), float(plus.get("Good", 1.0)), float(plus.get("OK", 1.0)), float(plus.get("Poor", 1.0)),
		mean_mult, rpg, ws])
	return [rpg, wins, rpg, mean_mult, "%.3f" % ws]


## Grade distribution over the roster's (boxer, planned line) pairs.
func _grade_dist() -> Dictionary:
	var counts := {"good": 0, "ok": 0, "poor": 0, "total": 0}
	var total_value := 0.0
	var base_total := 0.0
	for prospect in Data.PROSPECTS:
		var fs := Data.fighter_state(prospect.duplicate(true), 0)
		var attrs: Dictionary = Attrs.of(fs)
		for mid in LineGrade.DONE_WITH:
			var g := LineGrade.grade(str(mid), attrs)
			if g.is_empty():
				continue
			counts["total"] += 1
			var word: String = str(g["word"])
			match word:
				"Good": counts["good"] += 1
				"OK": counts["ok"] += 1
				"Poor": counts["poor"] += 1
			var bv := PlanFight.value(str(mid), "range", 1.0)
			base_total += absf(bv)
			total_value += absf(bv) * float(LineGrade.PLUS[word])
	counts["total_value"] = total_value
	counts["base_total"] = base_total
	return counts


## Two boxers who differ only in one planned line's two attributes, 500 bouts each.
func _good_vs_poor(plus: Dictionary) -> void:
	LineGrade.wired = true
	LineGrade.PLUS = plus.duplicate()
	BoutRead.clear_cache()
	var test_move := "step_back"
	var pair: Array = LineGrade.DONE_WITH[test_move]
	var k0: String = str(pair[0])
	var k1: String = str(pair[1])

	var lucy_state := Data.fighter_state(Data.lucy().duplicate(true), 77)
	var base_attrs: Dictionary = Attrs.of(lucy_state).duplicate()
	base_attrs[k0] = 55.0
	base_attrs[k1] = 55.0

	var good_f := _make_attr_variant(lucy_state, base_attrs, {k0: 75.0, k1: 75.0}, "grade1_good", "GradeGood")
	var poor_f := _make_attr_variant(lucy_state, base_attrs, {k0: 30.0, k1: 30.0}, "grade1_poor", "GradePoor")

	var wins_good := 0
	var wins_poor := 0
	var gp := _grade_pair(good_f["attrs"], test_move)
	var pp := _grade_pair(poor_f["attrs"], test_move)
	print("  GOOD_VS_POOR move=%s attrs=(%s, %s) good_grade=%s poor_grade=%s" % [test_move, k0, k1, gp, pp])
	for i in 500:
		wins_good += int(_bout_with(77 + i, good_f, GOOD))
		wins_poor += int(_bout_with(77 + i, poor_f, GOOD))
	var gap := float(wins_good - wins_poor) / 5.0
	print("GOOD_VS_POOR wins_good=%d wins_poor=%d gap_per_100=%.1f" % [wins_good, wins_poor, gap])


## Copy a fighter state, replace its attrs with `base` plus `changes`, and keep stats/stats_seen consistent so
## Attrs.of does not revert the change (absorb sees no stat delta).
func _make_attr_variant(src: Dictionary, base: Dictionary, changes: Dictionary, id: String, name: String) -> Dictionary:
	var f := src.duplicate(true)
	f["id"] = id
	f["name"] = name
	f["first"] = name
	var a := base.duplicate()
	for k in changes:
		a[k] = float(changes[k])
	f["attrs"] = a
	if f.has("stats_seen"):
		for k in changes:
			f["stats_seen"][k] = float(changes[k])
	for k in changes:
		f["stats"][k] = float(changes[k])
	if changes.has("footwork"):
		f["footwork"] = float(changes["footwork"])
		if f.has("stats_seen"):
			f["stats_seen"]["_footwork"] = float(changes["footwork"])
	return f


func _grade_pair(attrs: Dictionary, move_id: String) -> String:
	var g := LineGrade.grade(move_id, attrs)
	if g.is_empty():
		return "?"
	return str(g["word"])


func _bout(day: int, arrows: Array) -> Dictionary:
	var c := Career.quick_start()
	c.fighters.append(Data.fighter_state(Data.lucy(), c.day))
	c.day = day
	var f: Dictionary = c.fighter()
	f["camp"] = {}
	f["combos"] = {"1-1": 50.0, "1-2": 50.0}
	f["arrows"] = arrows.duplicate(true)
	f["bout"] = {"opp": (Data.OPPONENTS[0] as Dictionary).duplicate(true), "day": c.day, "weighed": true, "made": true, "done": false,
		"film": 0, "rounds": 3}
	var m := {"fid": f["id"], "step": "tape", "total": 3}
	Bouts.fight_step(c, f, m, "sim")
	return m


func _bout_with(day: int, f: Dictionary, arrows: Array) -> bool:
	var c := Career.quick_start()
	c.fighters.append(f.duplicate(true))
	c.day = day
	var ff: Dictionary = c.fighter()
	ff["camp"] = {}
	if not ff.has("combos") or (ff.get("combos", {}) as Dictionary).is_empty():
		ff["combos"] = {"1-1": 50.0, "1-2": 50.0}
	ff["arrows"] = arrows.duplicate(true)
	ff["bout"] = {"opp": (Data.OPPONENTS[0] as Dictionary).duplicate(true), "day": c.day, "weighed": true, "made": true, "done": false,
		"film": 0, "rounds": 3}
	var m := {"fid": ff["id"], "step": "tape", "total": 3}
	Bouts.fight_step(c, ff, m, "sim")
	var rounds_won := 0
	for r in m.get("rounds", []):
		if bool(r.get("won", false)):
			rounds_won += 1
	return rounds_won * 2 > m.get("rounds", []).size()
