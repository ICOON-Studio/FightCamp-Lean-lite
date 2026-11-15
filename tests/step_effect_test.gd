extends SceneTree
## STEPEFFECT1: step effects, ability grades, scaling and ropes.

const SE := preload("res://scripts/rules/StepEffect.gd")

var failures: int = 0


func _initialize() -> void:
	_check_table()
	_check_grades()
	_check_scaling()
	_check_situations_and_ropes()
	if failures == 0:
		print("STEP_EFFECT PASS fails=0")
	else:
		print("STEP_EFFECT FAIL fails=%d" % failures)
	quit(0 if failures == 0 else 1)


func _check(condition: bool, what: String) -> void:
	if condition:
		print("ok   " + what)
	else:
		failures += 1
		print("FAIL " + what)


func _near(a: float, b: float) -> bool:
	return absf(a - b) < 0.0001


func _check_table() -> void:
	var keys: Array = ["deny", "deny_on", "distance", "open", "open_on", "drain", "break_to", "ropes", "opp_ropes", "clears_ropes", "opp_steps_less", "opp_counter_edge", "ends_early", "self_tank", "tank", "wrong_extra_damage", "best", "wrong"]
	var expected_steps: Array = ["step_in", "step_out", "step_back", "pivot_out", "cut_off", "herd", "feint", "tie_up", "roll_out", "push_off"]
	_check(SE.STEPS.size() == 10 and SE.STEPS == expected_steps, "ten steps in mastery order")
	_check(SE.TABLE.size() == 10 and SE.ABILITY.size() == 10, "ten table and ability entries")
	for step in expected_steps:
		_check(SE.TABLE.has(step) and SE.ABILITY.has(step), "%s has table and ability" % step)
		if not SE.TABLE.has(step) or not SE.ABILITY.has(step):
			continue
		var row: Dictionary = SE.TABLE[step]
		var pair: Array = SE.ABILITY[step]
		var same_keys: bool = row.size() == keys.size()
		for key in keys:
			if not row.has(key):
				same_keys = false
		_check(same_keys, "%s has exactly the required keys" % step)
		_check(pair.size() == 2, "%s has an ability pair" % step)
	var back: Dictionary = SE.effect("step_back")
	_check(_near(float(back["deny"]), 0.35) and back["deny_on"] == "power" and back["ropes"] == 1, "step back effect")
	_check(SE.effect("nope") == {}, "unknown effect")
	back["deny"] = 99.0
	var best: Array = back["best"]
	best.append("changed")
	_check(_near(float(SE.TABLE["step_back"]["deny"]), 0.35) and not "changed" in SE.TABLE["step_back"]["best"], "effect is a deep copy")


func _check_grades() -> void:
	_check(SE.grade(60, 55) == "good", "good boundary")
	_check(SE.grade(55, 60) == "poor", "poor boundary")
	_check(SE.grade(58, 55) == "ok", "middle grade")
	_check(SE.grade_for("step_back", {"footwork": 70}, {"speed": 60}) == "good", "step back ability grade")
	_check(SE.grade_for("tie_up", {}, {"strength": 50}) == "poor", "missing stat counts zero")
	_check(SE.grade_for("nope", {}, {}) == "ok", "unknown step grade")


func _check_scaling() -> void:
	var back: Dictionary = SE.scaled("step_back", "good")
	_check(_near(float(back["deny"]), 0.42) and back["ropes"] == 1 and back["distance"] == "long", "good step back scaling preserves ropes and distance")
	var tie: Dictionary = SE.scaled("tie_up", "poor")
	_check(_near(float(tie["self_tank"]), 0.28) and _near(float(tie["tank"]), -0.8), "poor tie up scales recovery but not cost")
	var feint: Dictionary = SE.scaled("feint", "good")
	_check(_near(float(feint["opp_counter_edge"]), -0.12), "good feint scales negative counter edge")
	_check(SE.scaled("nope", "good") == {}, "unknown scaled step")
	_check(SE.scaled("step_in", "unknown") == SE.scaled("step_in", "ok"), "unknown grade defaults to ok")
	var scaled_keys: Array = ["deny", "open", "drain", "opp_counter_edge", "opp_steps_less", "self_tank"]
	for step in SE.STEPS:
		var original: Dictionary = SE.effect(step)
		var result: Dictionary = SE.scaled(step, "good")
		for key in original:
			if key in scaled_keys:
				_check(_near(float(result[key]), float(original[key]) * 1.2), "%s scales %s" % [step, key])
			else:
				_check(result[key] == original[key], "%s preserves %s" % [step, key])


func _check_situations_and_ropes() -> void:
	_check(SE.is_best("step_back", "press"), "step back best against press")
	_check(SE.is_wrong("step_in", "counter"), "step in wrong against counter")
	_check(not SE.is_best("feint", "press"), "feint not best against press")
	_check(not SE.is_best("nope", "press") and not SE.is_wrong("nope", "press"), "unknown step has no situations")
	_check(SE.ropes_after(2, "step_back") == 3, "step back adds ropes")
	_check(SE.ropes_after(2, "pivot_out") == 0, "pivot clears ropes")
	_check(SE.ropes_after(1, "feint") == 1, "feint leaves ropes")
	_check(SE.ropes_after(2, "nope") == 2, "unknown step leaves ropes")
	_check(SE.on_ropes(3) and not SE.on_ropes(2), "ropes threshold")
