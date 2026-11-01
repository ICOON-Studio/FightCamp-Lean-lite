extends SceneTree
## PlanBoard test: arrow limits, validation, pick, coverage, chains, change_one, rate.
## Uses BOTH maps - boxing (StrikeMap.MOVES) and wrestling (built from WrestleChains.ANSWERS).

const StrikeMap := preload("res://scripts/rules/StrikeMap.gd")
const WrestleChains := preload("res://scripts/rules/WrestleChains.gd")
const PlanBoard := preload("res://scripts/rules/PlanBoard.gd")

var failures := 0


func _initialize() -> void:
	_test_1_arrow_limit()
	_test_2_boxing_plan()
	_test_3_problems()
	_test_4_wrestling()
	_test_5_coverage()
	_test_6_change_one_and_rate()
	if failures == 0:
		print("PASS plan_board_test")
	else:
		print("FAIL %d" % failures)
	quit(1 if failures > 0 else 0)


func _check(cond: bool, label: String) -> void:
	if cond:
		print("  ok   ", label)
	else:
		failures += 1
		print("  FAIL ", label)


func _test_1_arrow_limit() -> void:
	_check(PlanBoard.arrow_limit(30) == 4, "arrow_limit(30) == 4")
	_check(PlanBoard.arrow_limit(90) == 9, "arrow_limit(90) == 9")
	_check(PlanBoard.arrow_limit(0) == 4, "arrow_limit(0) == 4")
	_check(PlanBoard.arrow_limit(200) == 9, "arrow_limit(200) == 9")
	var lim60 := PlanBoard.arrow_limit(60)
	_check(lim60 == 6 or lim60 == 7, "arrow_limit(60) is 6 or 7 (got %d)" % lim60)


func _test_2_boxing_plan() -> void:
	var map: Array = StrikeMap.MOVES
	var plan := [
		{"move": "step_in"},
		{"move": "1-2-3"},
		{"move": "3b-3"},
		{"move": "tie_up"}
	]
	var limit := 4
	var v := PlanBoard.validate(plan, map, limit)
	_check(v["ok"], "boxing plan valid with limit 4")
	_check(v["problems"].is_empty(), "no problems in boxing plan")

	var chain := PlanBoard.chains(plan, map, "outside", 10)
	_check(chain.size() == 4, "chains from outside has 4 moves")
	if chain.size() == 4:
		_check(chain[0] == "step_in", "chains[0] == step_in")
		_check(chain[1] == "1-2-3", "chains[1] == 1-2-3")
		_check(chain[2] == "3b-3", "chains[2] == 3b-3")
		_check(chain[3] == "tie_up", "chains[3] == tie_up")
	print("  chains: ", chain)


func _test_3_problems() -> void:
	var map: Array = StrikeMap.MOVES

	# Two arrows from long
	var plan1 := [
		{"move": "1-2-3"},
		{"move": "1-2"}
	]
	var v1 := PlanBoard.validate(plan1, map, 4)
	_check(not v1["ok"], "two arrows from long is invalid")
	var found_two := false
	for p in v1["problems"]:
		if str(p).contains("Two arrows"):
			found_two = true
			print("  problem: ", p)
	_check(found_two, "problem mentions 'Two arrows'")

	# Forced move
	var plan2 := [{"move": "backed_up"}]
	var v2 := PlanBoard.validate(plan2, map, 4)
	_check(not v2["ok"], "forced move is invalid")
	var found_forced := false
	for p in v2["problems"]:
		if str(p).contains("cannot be planned"):
			found_forced = true
			print("  problem: ", p)
	_check(found_forced, "problem mentions 'cannot be planned'")

	# Unknown move
	var plan3 := [{"move": "zzz"}]
	var v3 := PlanBoard.validate(plan3, map, 4)
	_check(not v3["ok"], "unknown move is invalid")
	var found_unknown := false
	for p in v3["problems"]:
		if str(p).contains("No move"):
			found_unknown = true
			print("  problem: ", p)
	_check(found_unknown, "problem mentions 'No move'")

	# Over limit
	var plan4 := [
		{"move": "step_in"},
		{"move": "1-1"},
		{"move": "1-2"},
		{"move": "2-3"},
		{"move": "1-2-3"}
	]
	var v4 := PlanBoard.validate(plan4, map, 4)
	_check(not v4["ok"], "5 arrows with limit 4 is invalid")
	var found_count := false
	for p in v4["problems"]:
		if str(p).contains("arrows") and str(p).contains("hold"):
			found_count = true
			print("  problem: ", p)
	_check(found_count, "problem mentions arrow count")


func _test_4_wrestling() -> void:
	# Build wrestling map from WrestleChains.ANSWERS
	var map: Array = []
	for a in WrestleChains.ANSWERS:
		var row := {
			"id": str(a["tie"]) + ":" + str(a["reaction"]),
			"from": str(a["tie"]),
			"to": str(a["link"]) if str(a["link"]) != "" else "finish",
			"reaction": str(a["reaction"])
		}
		map.append(row)

	# Two answers at russian_tie with different reactions are valid
	var plan1 := [
		{"move": "russian_tie:pulls her arm away"},
		{"move": "russian_tie:squares up"}
	]
	var v1 := PlanBoard.validate(plan1, map, 9)
	_check(v1["ok"], "two russian_tie answers with different reactions valid")

	# Same reaction twice is a problem
	var plan2 := [
		{"move": "russian_tie:pulls her arm away"},
		{"move": "russian_tie:pulls her arm away"}
	]
	var v2 := PlanBoard.validate(plan2, map, 9)
	_check(not v2["ok"], "same reaction twice is invalid")
	var found_reaction := false
	for p in v2["problems"]:
		if str(p).contains("Two answers") and str(p).contains("pulls her arm away"):
			found_reaction = true
			print("  problem: ", p)
	_check(found_reaction, "problem mentions 'Two answers' with reaction")

	# pick with reaction
	var plan3 := [{"move": "russian_tie:pulls her arm away"}]
	var picked := PlanBoard.pick(plan3, map, "russian_tie", "pulls her arm away")
	_check(picked == "russian_tie:pulls her arm away", "pick with reaction returns correct id")


func _test_5_coverage() -> void:
	var map: Array = StrikeMap.MOVES

	# Empty plan
	var cov0 := PlanBoard.coverage([], map)
	_check(cov0 == 0.0, "empty plan coverage == 0.0")

	# Boxing plan from test 2
	var plan1 := [
		{"move": "step_in"},
		{"move": "1-2-3"},
		{"move": "3b-3"},
		{"move": "tie_up"}
	]
	var cov1 := PlanBoard.coverage(plan1, map)
	_check(cov1 > 0.0 and cov1 < 1.0, "boxing plan coverage > 0 and < 1 (got %.2f)" % cov1)

	# Full coverage: one arrow per plannable place
	var plannable := {}
	for m in map:
		if str(m.get("kind", "")) == "forced":
			continue
		var key := str(m["from"]) + ":" + str(m.get("reaction", ""))
		if not plannable.has(key):
			plannable[key] = str(m["id"])
	var full_plan := []
	for key in plannable:
		full_plan.append({"move": plannable[key]})
	var cov2 := PlanBoard.coverage(full_plan, map)
	_check(cov2 == 1.0, "full coverage plan == 1.0 (got %.2f)" % cov2)


func _test_6_change_one_and_rate() -> void:
	var plan := [
		{"move": "step_in"},
		{"move": "1-2-3"},
		{"move": "3b-3"}
	]
	var changed := PlanBoard.change_one(plan, 1, "1-2")
	_check(changed.size() == 3, "change_one preserves size")
	_check(changed[1]["move"] == "1-2", "change_one replaces index 1")
	_check(plan[1]["move"] == "1-2-3", "change_one leaves input untouched")

	var rate1 := PlanBoard.rate("1-2-3", ["1-2-3"])
	_check(rate1 == 1.0, "rate drilled == 1.0")
	var rate2 := PlanBoard.rate("1-2-3", [])
	_check(rate2 == 0.8, "rate undrilled == 0.8")
