extends SceneTree
## S533 STEPPAY2 phase 3: a planned step in its BEST situation costs no exchange - the exchange is fought on the card it
## leads to, the step stays its line, and a planned punch line there adds its plan points (StepWire.ride, read by
## LiveRound.exchange; LineGrade.edge adds pick["ride_edge"]).
## Control arm: StepWire.ride_on false = every step costs its exchange (the game before).

const StepWire := preload("res://scripts/state/StepWire.gd")
const LineGrade := preload("res://scripts/rules/LineGrade.gd")
const PlanFight := preload("res://scripts/rules/PlanFight.gd")
const Data := preload("res://scripts/state/Data.gd")
const Combos := preload("res://scripts/rules/Combos.gd")
const StrikeMap := preload("res://scripts/rules/StrikeMap.gd")

var failures := 0


func _check(ok: bool, what: String) -> void:
	print("%s %s" % ["ok  " if ok else "FAIL", what])
	if not ok:
		failures += 1


func _fighter() -> Dictionary:
	var c := Career.quick_start()
	var f: Dictionary = c.fighter()
	var moves := {}
	for k in Data.MOVES:
		moves[k] = 60.0
	f["moves"] = moves
	var combos := {}
	for m in StrikeMap.MOVES:
		if str(m["kind"]) == "combo":
			combos[str(m["combo"])] = 60.0
	f["combos"] = combos
	f["bout"] = {}
	return f


func _initialize() -> void:
	var f := _fighter()
	var attrs := LineGrade.attrs_for(f)
	var plan := [{"move": "cut_off"}, {"move": "1-2@opp_ropes"}, {"move": "step_back"}]
	var pick := PlanFight.choose(plan, "long", f["moves"], "range")
	_check(str(pick["move"]) == "cut_off" and bool(pick["planned"]), "the plan's line at long range is cut off the ring")
	# BEST situation (she boxes at range): the exchange is fought on the ropes, the step is still the line.
	var lv := {"n": 1, "at": "long"}
	var r := StepWire.ride(lv, pick, plan, f, "range", "range", "long", 0.0)
	_check(not r.is_empty() and str(r["at"]) == "opp_ropes" and str(lv["at"]) == "opp_ropes" and str(r["pick"]["move"]) == "cut_off" and bool(r["pick"]["planned"]),
		"best situation: the exchange is fought on the ropes, cut off stays the plan's line")
	var punch := PlanFight.choose([{"move": "1-2@opp_ropes"}], "opp_ropes", f["moves"], "range")
	var punch_pts := LineGrade.edge(punch, "range", 1.0, PlanFight.card_mean("opp_ropes", "range", f["moves"], f["combos"]), attrs)
	_check(str(r["pick"]["rode_punch"]) == "1-2@opp_ropes" and absf(float(r["pick"]["ride_edge"]) - punch_pts) < 0.001,
		"the planned one-two on the ropes is thrown with it: its plan points ride (%+.2f)" % punch_pts)
	var alone := LineGrade.edge(pick, "range", 1.0, 2.0, attrs)
	_check(absf(LineGrade.edge(r["pick"], "range", 1.0, 2.0, attrs) - alone - punch_pts) < 0.001, "LineGrade.edge = the step's answer + the punch line (%+.2f %+.2f)" % [alone, punch_pts])
	var rec := {}
	StepWire.after(lv, rec, "cut_off", true)
	_check(str(rec.get("rode", "")) == "cut_off" and str(rec["rode_from"]) == "long" and str(rec["rode_punch"]) == "1-2@opp_ropes"
		and not lv.has("rode_from") and int(lv.get("opp_ropes", 0)) == 1, "the record names the ride (from long, with the one-two); the ropes count moved as ever")
	var rec2 := {}
	StepWire.after(lv, rec2, "1-2@opp_ropes", true)
	_check(not rec2.has("rode"), "the next exchange is not a ride")
	# No punch line planned there, a step planned there, or the punch does not come off: the ride stands, with no punch points.
	for p in [[{"move": "cut_off"}], [{"move": "cut_off"}, {"move": "herd"}]]:
		var rn := StepWire.ride({"n": 1}, pick, p, f, "range", "range", "long", 0.0)
		_check(not rn.is_empty() and str(rn["at"]) == "opp_ropes" and float(rn["pick"]["ride_edge"]) == 0.0 and str(rn["pick"]["rode_punch"]) == "",
			"no punch line on the ropes (%d plan lines): fought there all the same, no punch points" % (p as Array).size())
	var rf := StepWire.ride({"n": 1}, pick, plan, f, "range", "range", "long", 0.999)
	_check(not rf.is_empty() and float(rf["pick"]["ride_edge"]) == 0.0, "the punch line does not come off (its own roll): no punch points")
	# WRONG or half-right situation: the step costs the exchange where she stands.
	_check(StepWire.ride({"n": 1}, pick, plan, f, "press", "press", "long", 0.0).is_empty(), "wrong situation (she presses): no ride")
	_check(StepWire.ride({"n": 1}, pick, plan, f, "counter", "counter", "long", 0.0).is_empty(), "a situation it does not answer: no ride")
	# A card with no punch to throw (the clinch): the step takes the exchange.
	var plan_t := [{"move": "tie_up"}]
	var pick_t := PlanFight.choose(plan_t, "inside", f["moves"], "loadup")
	_check(str(pick_t["move"]) == "tie_up" and StepWire.ride({"n": 1}, pick_t, plan_t, f, "loadup", "loadup", "inside", 0.0).is_empty(), "tie up leads to the clinch (no punch there): no ride")
	# A step thrown on instinct never rides; a punch never rides.
	var loose := pick.duplicate()
	loose["planned"] = false
	_check(StepWire.ride({"n": 1}, loose, plan, f, "range", "range", "long", 0.0).is_empty(), "a step thrown on instinct does not ride")
	_check(StepWire.ride({"n": 1}, punch, plan, f, "range", "range", "opp_ropes", 0.0).is_empty(), "a punch line is not a step: no ride")
	# Off her own ropes: pivot out from a presser is fought in the middle, not on the ropes.
	var plan_p := [{"move": "pivot_out"}]
	var pick_p := PlanFight.choose(plan_p, "own_ropes", f["moves"], "press")
	var rp := StepWire.ride({"n": 1}, pick_p, plan_p, f, "press", "press", "own_ropes", 0.0)
	_check(not rp.is_empty() and str(rp["at"]) == "mid", "pivot out from a presser: the exchange is fought in the middle, off the ropes")
	# Control arm.
	StepWire.ride_on = false
	_check(StepWire.ride({"n": 1}, pick, plan, f, "range", "range", "long", 0.0).is_empty(), "control arm (ride off): the step costs its exchange")
	StepWire.ride_on = true
	print("step_ride_test: %s (%d failures)" % ["PASS" if failures == 0 else "FAIL", failures])
	quit(1 if failures > 0 else 0)
