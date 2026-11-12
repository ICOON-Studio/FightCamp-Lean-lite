extends SceneTree
## CALLSPREAD1 (TRAINING_MAP F10): a corner call's strength rises point by point from 56 to 62, not in one jump at 62.

const EX := preload("res://scripts/rules/Exchanges.gd")

var checks := 0
var failures := 0


func _initialize() -> void:
	_test_a()
	_test_b()
	_test_c()
	_test_d()
	_test_e()
	_test_f()
	print("CALL_SPREAD checks=%d failures=%d" % [checks, failures])
	quit(1 if failures > 0 else 0)


func _check(cond: bool, label: String) -> void:
	checks += 1
	if cond:
		print("PASS ", label)
	else:
		failures += 1
		print("FAIL ", label)


func _near(a: float, b: float) -> bool:
	return absf(a - b) < 0.001


## Pick a call with two needs at run time; do not hard-code the call's stats.
func _pick_two_need_call() -> String:
	for k in EX.CALLS:
		var needs: Array = (EX.CALLS[k] as Dictionary).get("needs", [])
		if needs.size() == 2:
			return k
	return ""


func _vals_for(call: String, mean: float) -> Dictionary:
	var needs: Array = (EX.CALLS[call] as Dictionary).get("needs", [])
	var v := {}
	for k in needs:
		v[k] = mean
	return v


## a. mean 55.9: mult 0.6, word OK.
func _test_a() -> void:
	var call := _pick_two_need_call()
	var g: Dictionary = EX.grade(call, _vals_for(call, 55.9))
	var m: float = float(g["mult"])
	var w: String = str(g["word"])
	_check(_near(m, 0.6) and w == "OK", "a: mean 55.9 mult 0.6 word OK (got mult=%.3f word=%s)" % [m, w])


## b. mean 59.0: mult 0.8 (within 0.001), word OK. <- RED on main (main gives 0.6)
func _test_b() -> void:
	var call := _pick_two_need_call()
	var g: Dictionary = EX.grade(call, _vals_for(call, 59.0))
	var m: float = float(g["mult"])
	var w: String = str(g["word"])
	_check(_near(m, 0.8) and w == "OK", "b: mean 59.0 mult 0.8 word OK (got mult=%.3f word=%s)" % [m, w])


## c. mean 61.0: mult within 0.001 of 0.6 + 0.4 x 5/6, word OK. <- RED on main
func _test_c() -> void:
	var call := _pick_two_need_call()
	var expect: float = 0.6 + 0.4 * 5.0 / 6.0
	var g: Dictionary = EX.grade(call, _vals_for(call, 61.0))
	var m: float = float(g["mult"])
	var w: String = str(g["word"])
	_check(_near(m, expect) and w == "OK", "c: mean 61.0 mult %.3f word OK (got mult=%.3f word=%s)" % [expect, m, w])


## d. mean 62.0: mult 1.0, word Good.
func _test_d() -> void:
	var call := _pick_two_need_call()
	var g: Dictionary = EX.grade(call, _vals_for(call, 62.0))
	var m: float = float(g["mult"])
	var w: String = str(g["word"])
	_check(_near(m, 1.0) and w == "Good", "d: mean 62.0 mult 1.0 word Good (got mult=%.3f word=%s)" % [m, w])


## e. mean 49.0: mult 0.3, word Poor.
func _test_e() -> void:
	var call := _pick_two_need_call()
	var g: Dictionary = EX.grade(call, _vals_for(call, 49.0))
	var m: float = float(g["mult"])
	var w: String = str(g["word"])
	_check(_near(m, 0.3) and w == "Poor", "e: mean 49.0 mult 0.3 word Poor (got mult=%.3f word=%s)" % [m, w])


## f. monotone: from mean 50 to 65 in steps of 0.5, mult never falls and never rises by more than
## 0.4 / 6 x 0.5 + 0.001 in one step (no jump left). <- RED on main (the jump at 62)
func _test_f() -> void:
	var call := _pick_two_need_call()
	var ok := true
	var prev_mult: float = -1.0
	var step_limit: float = 0.4 / 6.0 * 0.5 + 0.001
	var mean: float = 50.0
	while mean <= 65.0:
		var g: Dictionary = EX.grade(call, _vals_for(call, mean))
		var m: float = float(g["mult"])
		if prev_mult >= 0.0:
			if m < prev_mult - 0.0001:
				ok = false
			if m - prev_mult > step_limit + 0.0001:
				ok = false
		prev_mult = m
		mean += 0.5
	_check(ok, "f: monotone 50..65 step 0.5, no fall, no rise > %.4f" % step_limit)
