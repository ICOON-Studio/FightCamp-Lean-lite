extends SceneTree
## GAMETREE1 (S384) the one odds formula, exact (design 3.3, 10.1):
##   p = clamp(BASE[odds, tier] x mf(m_att) x CHAIN x MOOD / (max(D_NONE, mf(m_ans)) x READ), 0.03, 0.90); BASE edges 0.94.
##   1. the mastery factor: 30 vs 30 = the base rate, 100 = x1.8, 15 = x0.5, learning (14.9) not usable; no answer = x1/0.7.
##   2. clamps 0.90 / 0.03, BASE 0.94 unclamped; CHAIN x1.15; READ 1 + 0.6 r; MOOD (morale 100 x1.5, 20 x0.5).
##   3. the base table and overrides by tier; the worked example (RNC vs a seatbelt escape at 40); chip words; P_bad.
##   4. IBJJF legality by belt (the S384 re-check: straight ankle all belts, kneebar / heel hooks / reaping brown+).

const BjjTree := preload("res://scripts/rules/BjjTree.gd")
const NoGi := preload("res://scripts/rules/NoGi.gd")

var _fails := 0


func _initialize() -> void:
	# The worked numbers (design 3.3) are at the design's start values; the shipped tuning is bjj_tree_sim_test's.
	BjjTree.T = BjjTree.T_DESIGN.duplicate()
	_factor()
	_clamps()
	_table()
	_legal()
	print("BJJ_TREE_ODDS %s failures=%d" % ["PASS" if _fails == 0 else "FAIL", _fails])
	quit(0 if _fails == 0 else 1)


func _e(mv: String) -> Dictionary:
	for id in BjjTree.data()["edge_ids"]:
		if str(BjjTree.edge(id)["move"]) == mv:
			return BjjTree.edge(id)
	return {}


func _near(a: float, b: float, eps: float = 0.0005) -> bool:
	return absf(a - b) <= eps


func _factor() -> void:
	var w := BjjTree.rules_for("white")
	var e := _e("double_leg")
	var base := BjjTree.base_rate(e, w)
	_check(_near(base, 0.33) and _near(BjjTree.odds(e, 30.0, 30.0, w), base), "30 vs 30 is the base rate exactly (double leg %.3f)" % BjjTree.odds(e, 30.0, 30.0, w))
	_check(_near(BjjTree.odds(e, 100.0, 30.0, w), base * 1.8), "mastery 100 = x1.8 (%.4f)" % BjjTree.odds(e, 100.0, 30.0, w))
	_check(_near(BjjTree.odds(e, 15.0, 30.0, w), base * 0.5), "mastery 15 (felt) = x0.5")
	_check(_near(BjjTree.mf(50.0), 1.0 + 0.8 * 20.0 / 70.0) and _near(BjjTree.mf(29.0), 29.0 / 30.0), "mf: 50 -> 1.229, 29 -> 0.967")
	_check(not BjjTree.usable(14.9) and BjjTree.usable(15.0) and BjjTree.state(14.9) == "learning" and BjjTree.state(15.0) == "felt"
		and BjjTree.state(30.0) == "owned" and BjjTree.state(50.0) == "signature", "14.9 learning (never tried), 15 felt, 30 owned, 50 signature")
	_check(_near(BjjTree.odds(e, 30.0, 0.0, w), base / 0.7), "no answer = x1/0.7 (D_NONE), not x1/0 (%.4f)" % BjjTree.odds(e, 30.0, 0.0, w))
	_check(_near(BjjTree.odds(e, 30.0, 10.0, w), base / 0.7), "an answer under 21 counts as none (mf 0.33 < 0.7)")


func _clamps() -> void:
	var w := BjjTree.rules_for("white")
	var mr := _e("mat_return")
	_check(_near(0.71 * 1.8 / 0.7, 1.8257, 0.001) and _near(BjjTree.odds(mr, 100.0, 0.0, w), 0.90), "mat return 0.71 at 100 vs nobody = 1.83 -> clamped 0.90")
	var g := _e("guillotine")
	_check(_near(BjjTree.odds(g, 15.0, 100.0, w), 0.03), "guillotine 0.10 felt at 15 vs an answer at 100 = 0.028 -> clamped 0.03")
	var pull := BjjTree.edge("e004")
	_check(str(pull["move"]) == "guard_pull" and _near(BjjTree.odds(pull, 0.0, 100.0, w), 0.94), "BASE edge (guard pull) 0.94, unclamped, whatever the masteries")
	var e := _e("double_leg")
	var base := BjjTree.base_rate(e, w)
	_check(_near(BjjTree.odds(e, 30.0, 30.0, w, true), base * 1.15), "CHAIN x1.15")
	_check(_near(BjjTree.odds(e, 30.0, 30.0, w, false, 0.5), base / 1.3) and _near(BjjTree.odds(e, 30.0, 30.0, w, false, 1.0), base / 1.6), "READ = 1 + 0.6 r")
	var f := NoGi.athlete()
	f["morale"] = 100
	_check(_near(BjjTree.mood_of(f), 0.1) and _near(BjjTree.odds(e, 30.0, 30.0, w, false, 0.0, BjjTree.mood_of(f)), base * 1.5), "morale 100: mood 0.1 -> x1.5")
	f["morale"] = 20
	_check(_near(BjjTree.odds(e, 30.0, 30.0, w, false, 0.0, BjjTree.mood_of(f)), base * 0.5), "morale 20: x0.5")
	f["morale"] = 60
	f["tough_next"] = true
	_check(_near(BjjTree.mood_of(f), -NoGi.TOUGH), "a tough bracket is win_chance's -0.05 in the mood term")
	_check(BjjTree.mood_of({}) == 0.0, "no morale (an opponent) = no mood")


func _table() -> void:
	var w := BjjTree.rules_for("white")
	var p := BjjTree.rules_for("purple")
	var b := BjjTree.rules_for("brown")
	_check(str(w["tier"]) == "amateur" and str(BjjTree.rules_for("blue")["tier"]) == "amateur" and str(p["tier"]) == "mid"
		and str(b["tier"]) == "pro" and str(BjjTree.rules_for("black")["tier"]) == "pro", "tiers: white/blue amateur, purple mid, brown/black pro")
	var rnc := _e("rear_naked_choke")
	_check(_near(BjjTree.base_rate(rnc, w), 0.35) and _near(BjjTree.base_rate(rnc, b), 0.35), "RNC 0.35 at every tier (ADCC 2022)")
	var sc := _e("scissor_sweep")
	_check(_near(BjjTree.base_rate(sc, w), 0.55) and _near(BjjTree.base_rate(sc, p), 0.435) and _near(BjjTree.base_rate(sc, b), 0.35),
		"scissor sweep 0.55 white/blue, 0.435 purple (the sweep midpoint), 0.35 pro")
	var sw := _e("hip_bump_sweep")
	_check(_near(BjjTree.base_rate(sw, w), 0.52) and _near(BjjTree.base_rate(sw, p), (0.52 + 0.35) / 2.0), "a sweep: 0.52 amateur, midpoint at purple")
	var pass_e := _e("bullfighter_pass")
	_check(_near(BjjTree.base_rate(pass_e, w), 0.23) and _near(BjjTree.base_rate(pass_e, b), 0.23), "a pass 0.23 flat")
	for mv in ["kneebar", "inside_heel_hook", "darce", "anaconda", "guillotine", "mat_return", "body_lock_pass", "leg_drag"]:
		_check(_near(BjjTree.base_rate(_e(mv), b), float(BjjTree.OVERRIDES[mv])), "override %s %.2f" % [mv, float(BjjTree.OVERRIDES[mv])])
	# The worked example (3.3): RNC vs a seatbelt escape at 40.
	var at := [[15.2, 0.16], [30.0, 0.31], [50.0, 0.386]]
	for row in at:
		var v := BjjTree.odds(rnc, float(row[0]), 40.0, w)
		_check(_near(v, float(row[1]), 0.006), "worked example: RNC at %.1f vs an escape at 40 = %.3f (design %.2f)" % [row[0], v, row[1]])
	_check(BjjTree.chip_word(0.60) == "LIKELY" and BjjTree.chip_word(0.59) == "EVEN" and BjjTree.chip_word(0.35) == "EVEN"
		and BjjTree.chip_word(0.34) == "LONG SHOT", "chips: 0.60 LIKELY, 0.59 EVEN, 0.34 LONG SHOT")
	_check(_near(BjjTree.p_bad(0.0), 0.0) and _near(BjjTree.p_bad(15.0), 0.5) and _near(BjjTree.p_bad(45.0), 1.0), "P_bad = min(1, m_ans / 30)")


func _legal() -> void:
	var w := BjjTree.rules_for("white")
	var p := BjjTree.rules_for("purple")
	var b := BjjTree.rules_for("brown")
	_check(not BjjTree.legal("kneebar", w) and not BjjTree.legal("kneebar", p) and BjjTree.legal("kneebar", b), "kneebar: brown and up")
	_check(BjjTree.legal("straight_ankle_lock", w), "straight ankle lock: legal at white (IBJJF adult)")
	for mv in ["toe_hold", "calf_slicer", "outside_heel_hook", "inside_heel_hook", "saddle_entry", "k_guard"]:
		_check(not BjjTree.legal(mv, p) and BjjTree.legal(mv, b), "%s: brown and up" % mv)
	_check(BjjTree.legal("kneebar", BjjTree.rules_for("black")) and not BjjTree.legal("kneebar", BjjTree.rules_for("black", true)),
		"a gym roll keeps white-belt leg-lock rules at any belt")
	var ck: Dictionary = BjjTree.data()["meta"].get("ibjjf_check", {})
	_check(str(ck.get("status", "")) == "re-checked" and str(ck.get("read", "")) == "2026-11-05", "the IBJJF table was re-checked (%s)" % str(ck.get("read", "")))


func _check(ok: bool, what: String) -> void:
	print(("  ok   " if ok else "  FAIL ") + what)
	if not ok:
		_fails += 1
