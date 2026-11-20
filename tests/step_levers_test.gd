extends SceneTree
## S525 STEPLEVERS: a planned step that fires does its StepEffect row in the exchange (StepWire.levers / open_edge).
## Control arm: levers_on false returns nothing and changes nothing (the TREEVALUE2 state, where roll_out read 0).

const StepWire := preload("res://scripts/state/StepWire.gd")
const Exchanges := preload("res://scripts/rules/Exchanges.gd")

var failures := 0


func _check(ok: bool, what: String) -> void:
	print("%s %s" % ["ok  " if ok else "FAIL", what])
	if not ok:
		failures += 1


func _lv() -> Dictionary:
	return {"cost": 0.0}


func _initialize() -> void:
	var rng := RandomNumberGenerator.new()
	rng.seed = 7
	# DENY: roll_out takes head hooks out of the opponent's landed punches; over 200 exchanges of 6 landed, ~0.4 x 0.19 x 6.
	var denied := 0
	for k in 200:
		var s := {"landed": [2, 6]}
		denied += int(StepWire.levers(_lv(), s, "roll_out", true, "ok", rng).get("denied", 0))
	var want := 200.0 * 6.0 * 0.4 * 0.85 * 0.19
	_check(absf(float(denied) - want) < want * 0.35, "roll_out denies ~%.0f of 1200 landed head hooks (%d)" % [want, denied])
	# Step back denies every kind, more than roll_out's hooks only.
	var s2 := {"landed": [2, 6]}
	var sb := 0
	for k in 200:
		s2 = {"landed": [2, 6]}
		sb += int(StepWire.levers(_lv(), s2, "step_back", true, "ok", rng).get("denied", 0))
	_check(sb > denied, "step back (all punches) denies more than roll out (head hooks) (%d vs %d)" % [sb, denied])
	# DRAIN + the step's own tank: push off drains the opponent and costs us its tank; tie up costs nothing here.
	var lv := _lv()
	var r := StepWire.levers(lv, {"landed": [3, 3]}, "push_off", true, "good", rng)
	_check(float(lv.get("opp_drain", 0.0)) > 0.0 and float(r["drain"]) > 0.0, "push off drains the opponent's tank (%.2f)" % float(lv.get("opp_drain", 0.0)))
	_check(float(lv["cost"]) > 0.0, "push off costs our tank (%.2f)" % float(lv["cost"]))
	var lt := _lv()
	StepWire.levers(lt, {"landed": [3, 3]}, "tie_up", true, "ok", rng)
	_check(float(lt["cost"]) == 0.0, "tie up's refill stays ClinchRest's (no tank change here)")
	# OPEN: roll_out opens the next planned punch line; a step line or an unplanned punch gets nothing; spent either way.
	var lo := _lv()
	StepWire.levers(lo, {"landed": [3, 3]}, "roll_out", true, "ok", rng)
	var e1 := StepWire.open_edge(lo, "1-2", true)
	_check(e1 > 0.0 and absf(e1 - 0.1 * 0.85 * float(Exchanges.EDGE["best"])) < 0.01, "roll out opens the next 1-2 (+%.2f)" % e1)
	_check(StepWire.open_edge(lo, "1-2", true) == 0.0, "the open is spent after one line")
	StepWire.levers(lo, {"landed": [3, 3]}, "roll_out", true, "ok", rng)
	_check(StepWire.open_edge(lo, "step_back", true) == 0.0, "a step line takes no open")
	# S528 STEPS_SCOPE phase 1: the step line passes the opening on to the punch after it (it was spent there - STEPTUNE2 s3).
	_check(StepWire.open_edge(lo, "1-2", true) > 0.0, "the punch after a step line still gets the opening")
	StepWire.levers(lo, {"landed": [3, 3]}, "roll_out", true, "ok", rng)
	_check(StepWire.open_edge(lo, "1-2", false) == 0.0 and StepWire.open_edge(lo, "1-2", true) == 0.0, "an unplanned pick wastes the opening")
	# S528 phase 1: a step on a wrong fit lets more of her punches land; on an ok fit it lets none in.
	var extra := 0
	var same := true
	for k in 200:
		var sw := {"landed": [3, 5]}
		extra += int(StepWire.levers(_lv(), sw, "step_back", true, "ok", rng, "wrong").get("extra", 0))
		var so := {"landed": [3, 5]}
		StepWire.levers(_lv(), so, "step_back", true, "ok", rng, "ok")
		same = same and int(so["landed"][1]) <= 5
	_check(extra >= 150 and extra <= 250, "a wrong step lets ~1 more punch in of 5 (%d over 200)" % extra)
	_check(same, "an ok step lets none in")
	# Unplanned or a punch line: no lever.
	_check(StepWire.levers(_lv(), {"landed": [3, 6]}, "roll_out", false, "ok", rng).is_empty(), "an unplanned step does nothing")
	_check(StepWire.levers(_lv(), {"landed": [3, 6]}, "1-2", true, "ok", rng).is_empty(), "a punch line is not a step")
	# S531 STEPTUNE3 s3c: the deny reaches the duel BEFORE settle (an edge), bigger for a step that denies every kind.
	var e_back := StepWire.deny_edge("step_back", true, "ok")
	var e_roll := StepWire.deny_edge("roll_out", true, "ok")
	_check(e_roll > 0.0 and e_back > e_roll, "deny reaches the score: step back %.2f > roll out %.2f > 0" % [e_back, e_roll])
	_check(StepWire.deny_edge("step_back", false, "ok") == 0.0 and StepWire.deny_edge("1-2", true, "ok") == 0.0,
		"no deny edge unplanned or on a punch line")
	_check(e_back < Exchanges.EDGE["best"], "a step's deny edge stays under a best call's whole edge (%.2f)" % e_back)
	# S531 phase 5d: the deny follows the step's fit against her game this exchange (TREEVALUE6: it helped every style).
	var f_best := StepWire.deny_edge("step_back", true, "ok", "best")
	var f_ok := StepWire.deny_edge("step_back", true, "ok", "ok")
	var f_none := StepWire.deny_edge("step_back", true, "ok", "none")
	_check(is_equal_approx(f_best, e_back) and f_best > f_ok and f_ok > f_none and f_none > 0.0,
		"deny by fit: best %.2f > ok %.2f > none %.2f > 0" % [f_best, f_ok, f_none])
	_check(StepWire.deny_edge("step_back", true, "ok", "wrong") == 0.0, "a wrong-fit step denies nothing (its cost is WRONG_COST)")
	# S531 phase 6: a sharp boxer holds a wrong-fit step more often than a dull one; never an ok or best one.
	_check(StepWire.hold_chance(40.0) == 0.0 and is_equal_approx(StepWire.hold_chance(100.0), StepWire.HOLD_MAX) and StepWire.hold_chance(70.0) > 0.3,
		"hold chance grows with fight IQ: 40 -> 0, 70 -> %.2f, 100 -> %.2f" % [StepWire.hold_chance(70.0), StepWire.hold_chance(100.0)])
	_check(StepWire.holds("wrong", 90.0, 0.1) and not StepWire.holds("ok", 90.0, 0.0) and not StepWire.holds("best", 100.0, 0.0),
		"only a wrong-fit step is held")
	# Control arm.
	StepWire.levers_on = false
	_check(StepWire.deny_edge("step_back", true, "ok") == 0.0, "levers off: no deny edge")
	_check(not StepWire.holds("wrong", 100.0, 0.0), "levers off: no step is held")
	var sc := {"landed": [2, 6]}
	var lc := _lv()
	_check(StepWire.levers(lc, sc, "roll_out", true, "ok", rng).is_empty() and int(sc["landed"][1]) == 6 and float(lc["cost"]) == 0.0,
		"levers off: nothing denied, nothing spent")
	StepWire.levers_on = true
	print("STEP_LEVERS failures=%d" % failures)
	quit(0 if failures == 0 else 1)
