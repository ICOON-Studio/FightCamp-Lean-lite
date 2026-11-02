extends SceneTree
## PlanLines (S360): the plan's arrows read and written as lines, each option rated as the bout scores it.
## Population: two fighters who differ in pad time - "raw" (jab and cross learned, no combination drilled) and "drilled"
## (every punch learned, the one-two and cross-hook drilled); the opponent's game a presser ("press") or a range boxer ("range").

const PlanLines := preload("res://scripts/rules/PlanLines.gd")
const PlanBoard := preload("res://scripts/rules/PlanBoard.gd")
const PlanFight := preload("res://scripts/rules/PlanFight.gd")
const SM := preload("res://scripts/rules/StrikeMap.gd")

const RAW := {"Jab": 45.0, "Cross": 35.0, "Lead hook": 10.0, "Body hook": 0.0, "Uppercut": 0.0, "Check hook": 0.0}
const DRILLED := {"Jab": 70.0, "Cross": 66.0, "Lead hook": 58.0, "Body hook": 50.0, "Uppercut": 41.0, "Check hook": 38.0}
const DRILLED_COMBOS := {"1-2": 55.0, "2-3": 40.0}

var _fails := 0


func _initialize() -> void:
	_test_1_lines_are_the_arrows()
	_test_2_set_and_clear()
	_test_3_options_rated()
	_test_4_strength()
	_test_5_coach_lines()
	print("PLAN_LINES %s" % ("PASS" if _fails == 0 else "FAIL %d" % _fails))
	quit(0 if _fails == 0 else 1)


func _test_1_lines_are_the_arrows() -> void:
	var plan := [{"move": "pivot_out"}, {"move": "1-2"}, {"move": "step_back", "when": "press"}, {"move": "step_in"}]
	var ls := PlanLines.lines(plan)
	_check(ls.size() == 4, "test 1: one line an arrow (%d)" % ls.size())
	var order: Array = ls.map(func(l): return str(l["place"]))
	_check(order == ["outside", "long", "mid", "own_ropes"], "test 1: lines in ring order (%s)" % [order])
	_check(str(ls[2]["when"]) == "press" and int(ls[2]["i"]) == 2, "test 1: a situation line keeps its when and arrow index")
	_check(PlanLines.find(plan, "mid", "press") == 2 and PlanLines.find(plan, "mid") == -1, "test 1: find by place + when")


func _test_2_set_and_clear() -> void:
	var plan: Array = PlanFight.starter()
	var p2 := PlanLines.set_line(plan, "long", "", "1-1")
	_check(p2.size() == plan.size() and PlanLines.find(p2, "long") >= 0 and str(p2[PlanLines.find(p2, "long")]["move"]) == "1-1",
		"test 2: setting a filled line replaces its answer")
	_check(str(plan[0]["move"]) == "1-2", "test 2: the old plan is not changed")
	var p3 := PlanLines.set_line(p2, "mid", "press", "slip 2-3")
	_check(p3.size() == plan.size() + 1 and str(p3[-1].get("when", "")) == "press", "test 2: a new situation line adds an arrow")
	_check(PlanBoard.validate(p3, SM.MOVES, 6)["ok"], "test 2: the lines stay a legal plan")
	_check(PlanLines.set_line(p3, "long", "", "tie_up") == p3, "test 2: a move from another place is refused")
	var p4 := PlanLines.clear_line(p3, "mid", "press")
	_check(p4.size() == plan.size() and PlanLines.find(p4, "mid", "press") == -1, "test 2: clearing removes the line only")


func _test_3_options_rated() -> void:
	var raw := PlanLines.options("long", "range", RAW, {})
	_check(raw.size() == SM.outs("long").size(), "test 3: every move out of the place is an option (%d)" % raw.size())
	var first_grey := -1
	for i in raw.size():
		if str(raw[i]["why"]) != "" and first_grey < 0:
			first_grey = i
		if first_grey >= 0:
			_check(str(raw[i]["why"]) != "", "test 3: usable options come before locked ones (%s)" % raw[i]["id"])
	var hook := _opt(raw, "2-3")
	_check(str(hook["why"]).contains("Lead hook") and float(hook["edge"]) == 0.0, "test 3: a locked move says what to learn, no edge")
	var vs_range := PlanLines.options("long", "range", DRILLED, DRILLED_COMBOS)
	_check(str(vs_range[0]["fit"]) == "best", "test 3: against a range boxer the top option beats it (%s)" % vs_range[0]["id"])
	var out_step := _opt(vs_range, "step_out")
	_check(str(out_step["fit"]) == "wrong" and float(out_step["edge"]) < 0.0, "test 3: stepping out walks into a range boxer (edge %.1f)" % out_step["edge"])
	var one_two := _opt(vs_range, "1-2")
	var raw_12 := _opt(raw, "1-2")
	_check(float(one_two["rate"]) == 1.0 and float(raw_12["rate"]) == PlanBoard.UNDRILLED, "test 3: pad time shows in the rate")
	var vs_press := PlanLines.options("outside", "press", DRILLED, DRILLED_COMBOS)
	var step_in := _opt(vs_press, "step_in")
	_check(str(step_in["fit"]) == "wrong", "test 3: the same move rates differently against another game (step in vs a presser)")
	var unknown := PlanLines.options("long", "", DRILLED, DRILLED_COMBOS)
	_check(unknown.all(func(o): return str(o["fit"]) == "none"), "test 3: no known game, no rating")


func _test_4_strength() -> void:
	var good := [{"move": "1-2"}, {"move": "2-3"}]
	var bad := [{"move": "step_out"}, {"move": "step_back"}]
	var sg := PlanLines.strength(good, "range", DRILLED, DRILLED_COMBOS)
	var sb := PlanLines.strength(bad, "range", DRILLED, DRILLED_COMBOS)
	_check(float(sg["edge"]) > 0.0 and float(sb["edge"]) < 0.0, "test 4: a plan that answers the game reads positive (%.1f vs %.1f)" % [sg["edge"], sb["edge"]])
	_check(int(sg["beats"]) == 2 and int(sb["walks"]) == 2, "test 4: lines counted by fit")
	var sr := PlanLines.strength(good, "range", RAW, {})
	_check(int(sr["untrained"]) == 1, "test 4: an undrilled combination is counted (%d)" % sr["untrained"])
	_check(float(sr["edge"]) < float(sg["edge"]), "test 4: the raw fighter's same plan is worth less")
	_check(float(PlanLines.strength(good, "", DRILLED, DRILLED_COMBOS)["edge"]) == 0.0, "test 4: no known game, no edge")


func _test_5_coach_lines() -> void:
	for n in range(PlanBoard.NEW_COACH + 1, PlanBoard.TOP_COACH + 1):
		var s := PlanLines.skill_for(n)
		_check(PlanBoard.arrow_limit(s) == n and PlanBoard.arrow_limit(s - 1) == n - 1, "test 5: coach %d holds %d lines" % [s, n])
	_check(PlanLines.skill_for(4) == 0, "test 5: the newest coach holds 4")


func _opt(opts: Array, id: String) -> Dictionary:
	for o in opts:
		if str(o["id"]) == id:
			return o
	return {}


func _check(ok: bool, what: String) -> void:
	print(("  ok   " if ok else "  FAIL ") + what)
	if not ok:
		_fails += 1
