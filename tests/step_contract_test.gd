extends SceneTree
## TASK STEPBLIND1: blind contract test for the footwork steps inside a round (StepWire).
## Written from the CONTRACT in ops/research/TASK_STEPBLIND1.md, the ## header comments of
## scripts/state/StepWire.gd and the constants of scripts/rules/StepEffect.gd (STEPS,
## GRADE_MULT, ROPES_AT, TABLE - data) and Exchanges.EDGE / Exchanges.BODY_COST. The
## function bodies of StepWire.gd were not read, and neither were tests/step_levers_test.gd,
## tests/step_ropes_test.gd or tests/ropes_contract_test.gd. Where the code disagrees with
## the contract, one of the two is wrong; any such check is kept and reported, not weakened.

const StepWire := preload("res://scripts/state/StepWire.gd")
const StepEffect := preload("res://scripts/rules/StepEffect.gd")
const Exchanges := preload("res://scripts/rules/Exchanges.gd")
const EPS := 0.001
const GOOD := "good"
const OK := "ok"
const POOR := "poor"

var failures: int = 0

func _initialize() -> void:
	_test_open_edge()
	_test_levers_control()
	_test_levers_shape()
	_test_wrong_fit()
	_test_deny()
	_test_drain()
	_test_tank()
	_test_open()
	_test_ropes()
	StepWire.levers_on = true
	if failures == 0:
		print("STEP_CONTRACT PASS fails=0")
	else:
		print("STEP_CONTRACT FAIL fails=%d" % failures)
	quit(1 if failures > 0 else 0)

func _check(cond: bool, label: String) -> void:
	if cond:
		print("ok  " + label)
	else:
		failures += 1
		print("FAIL " + label)

func _close(a: float, b: float) -> bool:
	return absf(a - b) < EPS

func _s(ours: int, theirs: int) -> Dictionary:
	return {"landed": [ours, theirs]}

func _graded(step: String, key: String, grade: String) -> float:
	return float(StepEffect.TABLE[step][key]) * float(StepEffect.GRADE_MULT[grade])

func _rng(seed_value: int) -> RandomNumberGenerator:
	var r := RandomNumberGenerator.new()
	r.seed = seed_value
	return r

func _test_open_edge() -> void:
	StepWire.levers_on = true
	var lv := {"open": 0.5}
	var edge: float = StepWire.open_edge(lv, "step_back", true)
	_check(_close(edge, 0.0), "planned step: open_edge returns 0.0")
	_check(_close(float(lv["open"]), 0.5), "planned step: lv open is left as it was")
	lv = {"open": 0.5}
	edge = StepWire.open_edge(lv, "jab", true)
	_check(_close(edge, 0.5 * float(Exchanges.EDGE["best"])), "planned punch: returns open x Exchanges.EDGE best")
	_check(_close(float(lv["open"]), 0.0), "planned punch: the opening is spent (open back to 0)")
	lv = {"open": 0.5}
	edge = StepWire.open_edge(lv, "jab", false)
	_check(_close(edge, 0.0), "unplanned pick: returns 0.0")
	_check(_close(float(lv["open"]), 0.0), "unplanned pick: her instinct wastes the opening")
	lv = {"open": 0.5}
	edge = StepWire.open_edge(lv, "step_back", false)
	_check(_close(edge, 0.0) and _close(float(lv["open"]), 0.0), "unplanned step: 0.0 and the opening is wasted")
	StepWire.levers_on = false
	lv = {"open": 0.5}
	edge = StepWire.open_edge(lv, "jab", true)
	_check(_close(edge, 0.0), "levers off: a planned punch returns 0.0")
	_check(_close(float(lv["open"]), 0.0), "levers off: the opening is zeroed whatever the arrow")
	lv = {"open": 0.5}
	edge = StepWire.open_edge(lv, "step_back", true)
	_check(_close(edge, 0.0) and _close(float(lv["open"]), 0.0), "levers off: a planned step returns 0.0 and zeroes open")
	StepWire.levers_on = true
	lv = {"open": 0.5}
	StepWire.open_edge(lv, "step_back", true)
	edge = StepWire.open_edge(lv, "jab", true)
	_check(_close(edge, 8.5), "open 0.5, planned step_back, planned jab -> 8.5")

func _test_levers_control() -> void:
	StepWire.levers_on = false
	var lv := {}
	var s := _s(2, 4)
	var out: Dictionary = StepWire.levers(lv, s, "step_back", true, OK, _rng(101), "wrong")
	_check(out.is_empty(), "levers off: returns {}")
	_check(lv.is_empty(), "levers off: lv unchanged")
	_check(s["landed"] == [2, 4], "levers off: landed unchanged")
	StepWire.levers_on = true
	lv = {}
	s = _s(2, 4)
	out = StepWire.levers(lv, s, "step_back", false, OK, _rng(102), "wrong")
	_check(out.is_empty(), "unplanned: returns {}")
	_check(lv.is_empty(), "unplanned: lv unchanged")
	_check(s["landed"] == [2, 4], "unplanned: landed unchanged")
	lv = {}
	s = _s(2, 4)
	out = StepWire.levers(lv, s, "jab", true, OK, _rng(103), "wrong")
	_check(out.is_empty(), "not a step: returns {}")
	_check(lv.is_empty(), "not a step: lv unchanged")
	_check(s["landed"] == [2, 4], "not a step: landed unchanged")

func _test_levers_shape() -> void:
	StepWire.levers_on = true
	var lv := {}
	var s := _s(1, 5)
	var out: Dictionary = StepWire.levers(lv, s, "step_back", true, OK, _rng(201), "ok")
	_check(out.has("denied") and out.has("drain") and out.has("extra"), "levers returns {denied, drain, extra}")
	_check(float(out["denied"]) == roundf(float(out["denied"])), "denied is a whole number")
	_check(float(out["extra"]) == roundf(float(out["extra"])), "extra is a whole number")
	var id_ok := true
	var bounds_ok := true
	var zero_deny_ok := true
	for step in StepEffect.STEPS:
		for grade in [GOOD, OK, POOR]:
			for seed_value in [11, 222, 3333]:
				for fit in ["wrong", "ok", "best", "none", ""]:
					lv = {}
					s = _s(2, 5)
					out = StepWire.levers(lv, s, step, true, grade, _rng(seed_value), fit)
					var extra: int = int(out["extra"])
					var denied: int = int(out["denied"])
					var after: int = int(s["landed"][1])
					if after != 5 + extra - denied:
						id_ok = false
					if after < 0 or denied < 0:
						bounds_ok = false
					if float(StepEffect.TABLE[step]["deny"]) == 0.0 and denied != 0:
						zero_deny_ok = false
	_check(id_ok, "identity: landed after = landed before + extra - denied (all steps, grades, seeds, fits)")
	_check(bounds_ok, "landed never goes below 0 and denied is never negative")
	_check(zero_deny_ok, "a step whose graded deny is 0 denies nothing")
	var bare_ok := true
	for step in StepEffect.STEPS:
		for grade in [GOOD, OK, POOR]:
			lv = {}
			s = _s(1, 0)
			out = StepWire.levers(lv, s, step, true, grade, _rng(77), "wrong")
			if int(s["landed"][1]) < 0:
				bare_ok = false
	_check(bare_ok, "landed never below 0 even when she landed nothing")

func _test_wrong_fit() -> void:
	StepWire.levers_on = true
	for fit in ["best", "ok", "none", ""]:
		var lv := {}
		var s := _s(1, 4)
		var out: Dictionary = StepWire.levers(lv, s, "step_back", true, OK, _rng(301), fit)
		_check(int(out["extra"]) == 0, "fit \"%s\": extra is 0" % fit)
	var lv := {}
	var s := _s(1, 4)
	var out: Dictionary = StepWire.levers(lv, s, "step_back", true, OK, _rng(302))
	_check(int(out["extra"]) == 0, "omitted fit: extra is 0")
	var floor_ok := true
	var target9: float = 9.0 * StepWire.WRONG_COST
	for i in range(2000):
		lv = {}
		s = _s(0, 9)
		out = StepWire.levers(lv, s, "step_back", true, OK, _rng(1000 + i), "wrong")
		var extra: int = int(out["extra"])
		if extra != floori(target9) and extra != floori(target9) + 1:
			floor_ok = false
	_check(floor_ok, "wrong fit: extra is floor(x) or floor(x)+1 (x = max(1, theirs) x cost)")
	var total := 0
	for i in range(2000):
		lv = {}
		s = _s(0, 3)
		out = StepWire.levers(lv, s, "step_back", true, OK, _rng(2000 + i), "wrong")
		total += int(out["extra"])
	var mean: float = float(total) / 2000.0
	_check(absf(mean - 3.0 * StepWire.WRONG_COST) <= 0.03 * 3.0, "wrong fit over 2,000 seeds: mean within 0.03 x max(1, theirs) of max(1, theirs) x cost")
	total = 0
	for i in range(2000):
		lv = {}
		s = _s(0, 3)
		out = StepWire.levers(lv, s, "step_in", true, OK, _rng(4000 + i), "wrong")
		total += int(out["extra"])
	mean = float(total) / 2000.0
	var row_cost: float = float(StepEffect.TABLE["step_in"]["wrong_extra_damage"])
	_check(absf(mean - 3.0 * row_cost) <= 0.03 * 3.0, "wrong fit with a row wrong_extra_damage above 0 pays the row's share")
	total = 0
	for i in range(2000):
		lv = {}
		s = _s(0, 0)
		out = StepWire.levers(lv, s, "step_back", true, OK, _rng(3000 + i), "wrong")
		total += int(out["extra"])
	mean = float(total) / 2000.0
	_check(total > 0, "wrong fit costs something even when she landed nothing")
	_check(absf(mean - StepWire.WRONG_COST) <= 0.03, "wrong fit with theirs = 0: mean within 0.03 x max(1, 0) of max(1, 0) x cost")

func _test_deny() -> void:
	StepWire.levers_on = true
	var none_denied := true
	for seed_value in [41, 42, 43, 44, 45]:
		var lv := {}
		var s := _s(0, 7)
		var out: Dictionary = StepWire.levers(lv, s, "step_in", true, GOOD, _rng(seed_value), "ok")
		if int(out["denied"]) != 0:
			none_denied = false
	_check(none_denied, "a step whose graded deny is 0 denies nothing (step_in)")
	var mono_ok := true
	for seed_value in [51, 52, 53, 54, 55, 56]:
		var lv_a := {}
		var lv_b := {}
		var out_g: Dictionary = StepWire.levers(lv_a, _s(0, 8), "step_back", true, GOOD, _rng(seed_value), "ok")
		var out_p: Dictionary = StepWire.levers(lv_b, _s(0, 8), "step_back", true, POOR, _rng(seed_value), "ok")
		if int(out_g["denied"]) < int(out_p["denied"]):
			mono_ok = false
	_check(mono_ok, "same rng seed: a good step never denies fewer than a poor one")
	var rise_ok := true
	for seed_value in [61, 62, 63]:
		var lv := {}
		var s := _s(0, 6)
		var out: Dictionary = StepWire.levers(lv, s, "roll_out", true, GOOD, _rng(seed_value), "ok")
		if int(s["landed"][1]) > 6 + int(out["extra"]):
			rise_ok = false
	_check(rise_ok, "her landed never rises from denying (only extra can raise it)")

func _test_drain() -> void:
	StepWire.levers_on = true
	var lv := {}
	var s := _s(0, 0)
	var out: Dictionary = StepWire.levers(lv, s, "cut_off", true, OK, _rng(701), "ok")
	var expected: float = _graded("cut_off", "drain", OK) * float(Exchanges.BODY_COST)
	_check(_close(float(out["drain"]), expected), "drain = the graded row drain x Exchanges.BODY_COST")
	_check(_close(float(lv.get("opp_drain", 0.0)), expected), "lv opp_drain adds the drain up")
	out = StepWire.levers(lv, s, "cut_off", true, OK, _rng(702), "ok")
	_check(_close(float(lv.get("opp_drain", 0.0)), 2.0 * expected), "lv opp_drain accumulates over calls")
	lv = {}
	s = _s(0, 0)
	out = StepWire.levers(lv, s, "step_back", true, GOOD, _rng(703), "ok")
	_check(_close(float(out["drain"]), 0.0), "a step with a 0 drain row returns drain 0.0")
	_check(_close(float(lv.get("opp_drain", 0.0)), 0.0), "a 0-drain step does not move opp_drain")
	var mono_ok := true
	for seed_value in [71, 72, 73, 74]:
		var lv_a := {}
		var lv_b := {}
		var out_g: Dictionary = StepWire.levers(lv_a, _s(0, 0), "cut_off", true, GOOD, _rng(seed_value), "ok")
		var out_p: Dictionary = StepWire.levers(lv_b, _s(0, 0), "cut_off", true, POOR, _rng(seed_value), "ok")
		if float(out_g["drain"]) < float(out_p["drain"]):
			mono_ok = false
	_check(mono_ok, "same rng seed: a good step never drains less than a poor one")

func _test_tank() -> void:
	StepWire.levers_on = true
	var lv := {}
	var s := _s(0, 0)
	StepWire.levers(lv, s, "step_back", true, GOOD, _rng(801), "ok")
	_check(_close(float(lv.get("cost", 0.0)), float(StepEffect.TABLE["step_back"]["tank"])), "lv cost grows by the row's tank (ungraded)")
	lv = {}
	s = _s(0, 0)
	StepWire.levers(lv, s, "tie_up", true, GOOD, _rng(802), "ok")
	_check(_close(float(lv.get("cost", 0.0)), 0.0), "tie_up is not charged its tank (its refill is elsewhere)")
	StepWire.levers(lv, s, "step_back", true, GOOD, _rng(803), "ok")
	_check(_close(float(lv.get("cost", 0.0)), float(StepEffect.TABLE["step_back"]["tank"])), "a step after tie_up is charged only its own tank")
	lv = {}
	s = _s(0, 0)
	StepWire.levers(lv, s, "cut_off", true, GOOD, _rng(804), "ok")
	_check(_close(float(lv.get("cost", 0.0)), float(StepEffect.TABLE["cut_off"]["tank"])), "cut_off (good) pays its row tank, not the graded one")

func _test_open() -> void:
	StepWire.levers_on = true
	var lv := {}
	var s := _s(0, 0)
	StepWire.levers(lv, s, "feint", true, OK, _rng(901), "ok")
	var feint_open: float = _graded("feint", "open", OK)
	_check(_close(float(lv.get("open", 0.0)), feint_open), "lv open becomes the graded row open")
	StepWire.levers(lv, s, "herd", true, GOOD, _rng(902), "ok")
	var herd_open: float = _graded("herd", "open", GOOD)
	_check(_close(float(lv["open"]), maxf(feint_open, herd_open)), "two steps in a row: the bigger open wins")
	_check(float(lv["open"]) < feint_open + herd_open, "two steps in a row: open is not summed")
	StepWire.levers(lv, s, "step_in", true, OK, _rng(903), "ok")
	_check(_close(float(lv["open"]), maxf(feint_open, herd_open)), "a smaller graded open does not lower lv open")
	var mono_ok := true
	for seed_value in [91, 92, 93]:
		var lv_a := {}
		var lv_b := {}
		StepWire.levers(lv_a, _s(0, 0), "feint", true, GOOD, _rng(seed_value), "ok")
		StepWire.levers(lv_b, _s(0, 0), "feint", true, POOR, _rng(seed_value), "ok")
		if float(lv_a["open"]) < float(lv_b["open"]):
			mono_ok = false
	_check(mono_ok, "same rng seed: a good step never opens less than a poor one")

func _test_ropes() -> void:
	StepWire.levers_on = true
	var lv := {}
	_check(StepWire.times(lv) == 0, "times(lv) is 0 on a fresh lv")
	lv = {}
	var rec := {}
	StepWire.after(lv, rec, "step_back", true)
	_check(int(lv.get("ropes", 0)) == int(StepEffect.TABLE["step_back"]["ropes"]), "a planned step adds its row ropes to lv ropes")
	_check(str(rec.get("ropes_put", "")) == "", "ropes_put is '' unless the count put someone on the ropes")
	lv = {}
	StepWire.after(lv, {}, "step_back", true)
	StepWire.after(lv, {}, "step_back", true)
	var third_rec := {}
	StepWire.after(lv, third_rec, "step_back", true)
	_check(str(lv.get("at", "")) == "own_ropes", "three planned step_back in a row: at is own_ropes on the third")
	_check(int(lv.get("ropes", -1)) == 0, "own_ropes: the ropes count starts again at 0")
	_check(int(lv.get("ropes_times", 0)) == 1, "own_ropes: ropes_times + 1")
	_check(str(third_rec.get("ropes_put", "")) == "own", "own_ropes: rec ropes_put is \"own\"")
	_check(StepWire.times(lv) == 1, "times(lv) is 1 after your boxer is put on the ropes")
	lv = {}
	StepWire.after(lv, {}, "step_back", true)
	StepWire.after(lv, {}, "step_back", true)
	StepWire.after(lv, {}, "pivot_out", true)
	_check(int(lv.get("ropes", -1)) == 0, "a pivot_out between them clears the count (clears_ropes)")
	StepWire.after(lv, {}, "step_back", true)
	_check(int(lv.get("ropes", -1)) == 1, "after a clear the count builds again from 1")
	lv = {}
	StepWire.after(lv, {}, "cut_off", true)
	StepWire.after(lv, {}, "cut_off", true)
	var opp_rec := {}
	StepWire.after(lv, opp_rec, "herd", true)
	_check(str(lv.get("at", "")) == "opp_ropes", "three planned steps into her count: at is opp_ropes on the third")
	_check(int(lv.get("opp_ropes", -1)) == 0, "opp_ropes: her count starts again at 0")
	_check(str(opp_rec.get("ropes_put", "")) == "opp", "opp_ropes: rec ropes_put is \"opp\"")
	_check(int(lv.get("ropes_times", 0)) == 0, "opp_ropes does not increment your boxer's ropes_times")
	_check(StepWire.times(lv) == 0, "times(lv) stays 0 after opp_ropes")
	lv = {}
	StepWire.after(lv, {}, "step_back", true)
	var before: Dictionary = lv.duplicate(true)
	rec = {}
	StepWire.after(lv, rec, "step_back", false)
	_check(lv == before, "unplanned: lv's counts are unchanged")
	lv = {}
	StepWire.after(lv, {}, "step_back", true)
	before = lv.duplicate(true)
	rec = {}
	StepWire.after(lv, rec, "jab", true)
	_check(lv == before, "not a step: lv's counts are unchanged")
