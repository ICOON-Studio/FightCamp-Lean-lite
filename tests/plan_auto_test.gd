extends SceneTree
## S482 PLANFLOW1 P6: PlanAuto - the plans the chart writes are lines she can fire. Population: a hand-built fighter dict
## (moves learned, two combinations at different pad levels, step bars at 0 and 45), a found-file row set, two results.

const PlanAuto := preload("res://scripts/rules/PlanAuto.gd")
const PlanLines := preload("res://scripts/rules/PlanLines.gd")
const FireLevel := preload("res://scripts/rules/FireLevel.gd")
const StepMastery := preload("res://scripts/rules/StepMastery.gd")

var _fails := 0


func _initialize() -> void:
	var steps := StepMastery.start_values(50.0)
	steps["step_back"] = 45.0
	var moves := {}
	for m in ["Jab", "Cross", "Lead hook", "Rear hook", "Lead uppercut", "Rear uppercut", "Body jab", "Lead body hook", "Rear body hook"]:
		moves[m] = 60.0
	var f := {"id": "f1", "moves": moves, "combos": {"1-2": 70.0, "1-1-2": 10.0}, "steps": steps,
		"arrows": [{"move": "1-2"}, {"move": "step_back", "when": "press"}]}
	var fire_all := func(arr: Array) -> bool: return arr.all(func(a): return PlanAuto.fires(f, str(a["move"])))

	var sug := PlanAuto.suggestion(f, "press")
	_check(not sug.is_empty() and fire_all.call(sug), "suggestion: every line fires (%s)" % [sug])

	var rows := [{"known": true, "sit": "press"}, {"known": false, "sit": "counter"}, {"known": true, "sit": "tiring"}, {"known": true, "sit": ""}]
	var plan := PlanAuto.coach(f, rows, "press", 6)
	_check(fire_all.call(plan), "coach: every line fires (%s)" % [plan])
	_check(plan.size() <= 6, "coach: within the line cap")
	_check(not plan.any(func(a): return str(a.get("when", "")) == "counter"), "coach: a mode film has not found gets no IF")
	_check(plan.filter(func(a): return str(a.get("when", "")) != "").size() <= 2, "coach: at most one IF a found moment")
	_check(PlanAuto.coach(f, rows, "press", 1).size() == 1, "coach: a 1-line coach writes one line")

	var none := PlanAuto.last_bout(f, [], 6)
	_check(not bool(none["ok"]) and str(none["why"]) != "", "last bout: no record says why (%s)" % none["why"])
	var results := [{"fid": "f1", "plan_rec": {"lines": {"1-2": [5, 9], "1-1-2": [3, 6], "step_back": [1, 2]}}},
		{"fid": "f1", "plan_rec": {"lines": {"jab": [9, 20]}}}, {"fid": "other", "plan_rec": {"lines": {"1-2": [1, 1]}}}]
	var last := PlanAuto.last_bout(f, results, 6)
	var ids: Array = (last["arrows"] as Array).map(func(a): return str(a["move"]))
	_check(bool(last["ok"]) and ids.has("1-2") and ids.has("step_back"), "last bout: keeps the lines thrown most (%s)" % [ids])
	_check(not ids.has("1-1-2"), "last bout: a line she cannot fire (1-1-2 at 10) is left out")
	_check(not ids.has("jab"), "last bout: only the newest bout counts")
	_check((last["arrows"] as Array).any(func(a): return str(a["move"]) == "step_back" and str(a.get("when", "")) == "press"),
		"last bout: a kept line keeps its IF from her plan")
	print("PLAN_AUTO %s fails=%d" % ["PASS" if _fails == 0 else "FAIL", _fails])
	quit(0 if _fails == 0 else 1)


func _check(ok: bool, what: String) -> void:
	if not ok:
		_fails += 1
	print(("ok   " if ok else "FAIL ") + what)
