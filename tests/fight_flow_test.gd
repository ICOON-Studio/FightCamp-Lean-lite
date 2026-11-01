extends SceneTree
## S340 fight flows (operator Q-S294-64 "Yes, boxing and wrestling now"): FightFlow lays the plan out top to bottom from
## the start card, labels branches with WHEN, lights a bout's arrows; FlowView draws a boxing plan, a wrestling plan and a
## lit bout. Population for the lit bout: Lucy Jackson (Data.lucy) against Maria Ortega (Data.OPPONENTS[0]) on a real plan.

const FightFlow := preload("res://scripts/rules/FightFlow.gd")
const FlowView := preload("res://scripts/ui/FlowView.gd")
const StrikeMap := preload("res://scripts/rules/StrikeMap.gd")
const TieUpPanel := preload("res://scripts/grapple/TieUpPanel.gd")
const Data := preload("res://scripts/state/Data.gd")
const Bouts := preload("res://scripts/state/Bouts.gd")
const FightNight := preload("res://scripts/ui/modals/FightNight.gd")

var failures := 0


func _initialize() -> void:
	# 1. Boxing: from long range, in the order she gets there.
	var plan := [{"move": "1-1"}, {"move": "step_in"}, {"move": "tie_up"}, {"move": "pivot_out"}, {"move": "1-2@opp_ropes"}]
	var flow := FightFlow.build(plan, StrikeMap.MOVES, "long")
	var depth := {}
	for n in flow["nodes"]:
		depth[str(n["id"])] = int(n["depth"])
	_check(int(depth.get("long", -1)) == 0, "the flow starts at long range")
	var e_step: Dictionary = (flow["edges"] as Array).filter(func(e): return str(e["move"]) == "tie_up")[0]
	_check(int(depth[str(e_step["to"])]) == int(depth[str(e_step["from"])]) + 1, "a walked-to place sits one row below the place its arrow leaves")
	_check((flow["edges"] as Array).size() == plan.size(), "one arrow per planned move (%d)" % (flow["edges"] as Array).size())
	_check(depth.has("own_ropes") and depth.has("opp_ropes"), "places the plan cannot walk to still get a row (own ropes, her ropes)")
	# S341: pivoting off the ropes into Mid range must not push Mid below the ropes.
	var br := _depths(FightFlow.build([{"move": "1-2-3-2", "when": "tiring"}, {"move": "step_back"}, {"move": "pivot_out"}], StrikeMap.MOVES, "long"))
	_check(int(br["mid"]) == 1 and int(br["own_ropes"]) > int(br["mid"]), "Long > Mid on top, the ropes below (mid %d, ropes %d)" % [int(br["mid"]), int(br["own_ropes"])])
	_check(FightFlow.label({"when": "press"}, "Step back") == "if she presses: Step back", "a branch reads 'if she presses: Step back'")
	_check(FightFlow.label({"when": ""}, "Jab, jab") == "Jab, jab", "a plain arrow reads its move")
	for id in depth:
		_check(not (FightFlow.IDEAS.get(id, []) as Array).is_empty(), "the coach wrote key ideas on %s" % id)
	# 2. Wrestling: the reaction is the branch.
	var wplan := [{"move": "collar_tie:leans in on the tie"}, {"move": "front_headlock:digs for a leg"}]
	var wflow := FightFlow.build(wplan, TieUpPanel.plan_map(), "collar_tie")
	_check((wflow["edges"] as Array).size() == 2, "wrestling: two answers")
	_check(FightFlow.label(wflow["edges"][0], "Snapdown") == "if she leans in on the tie: Snapdown", "wrestling: the reaction is the branch")
	var wd := {}
	for n in wflow["nodes"]:
		wd[str(n["id"])] = int(n["depth"])
	_check(int(wd.get("front_headlock", -1)) == 1 and int(wd.get("finish", -1)) == 2, "collar tie -> front headlock -> finish, top to bottom")
	# 3. Lit: worked / failed / unused from the bout's tally.
	var lit := FightFlow.lit(flow["edges"], {"1-1": [3, 4], "step_in": [0, 2]})
	var st := {}
	for e in lit:
		st[str(e["move"])] = str(e["state"])
	_check(st["1-1"] == "worked" and st["step_in"] == "failed" and st["tie_up"] == "unused", "lit: worked / failed / never came up")
	_check(FightFlow.bout_moves([{"arrows": {"moves": {"1-1": [1, 2]}}}, {"arrows": {"moves": {"1-1": [2, 2]}}}])["1-1"] == [3, 4], "summed over the rounds")
	# 4. A real bout: the result's lit flow carries what she threw.
	var c := Career.quick_start()
	c.fighters.append(Data.fighter_state(Data.lucy(), c.day))
	c.day = 44
	var f: Dictionary = c.fighter()
	f["camp"] = {}
	f["combos"] = {"1-1": 50.0, "1-2": 50.0}
	f["arrows"] = [{"move": "1-1"}, {"move": "step_back"}, {"move": "pivot_out"}, {"move": "tie_up"}]
	f["bout"] = {"opp": (Data.OPPONENTS[0] as Dictionary).duplicate(true), "day": c.day, "weighed": true, "made": true, "done": false, "film": 3}
	var m := {"fid": f["id"], "step": "tape", "total": 3}
	Bouts.fight_step(c, f, m, "sim")
	var bl := FightNight.lit_flow(m)
	_check(not bl.is_empty(), "the bout's plan comes back as a flow")
	var tried := 0
	for e in bl.get("edges", []):
		tried += int(e["used"])
	_check(tried > 0, "the lit flow counts the arrows she threw (%d)" % tried)
	_check(FightNight.lit_flow({"rounds": [{"plan": [], "exchanges": []}]}).is_empty(), "no plan: no flow")
	# 5. The view draws all three without errors.
	for pair in [[flow, false], [wflow, false], [bl, true]]:
		var v := FlowView.new()
		v.setup(pair[0], {"title": "T", "lit": pair[1], "place_name": func(id: String) -> String: return id,
			"move_name": func(id: String) -> String: return id})
		root.add_child(v)
		await process_frame
		_check(v.find_child("CloseFlow", true, false) != null, "the flow view opens with a Close button")
		v.queue_free()
	print("PASS fight_flow_test" if failures == 0 else "FAIL %d" % failures)
	quit(1 if failures > 0 else 0)


func _check(ok: bool, label: String) -> void:
	if not ok:
		failures += 1
		print("  FAIL: " + label)


func _depths(flow: Dictionary) -> Dictionary:
	var d := {}
	for n in flow["nodes"]:
		d[str(n["id"])] = int(n["depth"])
	return d
