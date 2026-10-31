extends SceneTree
## GymBills: 10 tests.

const GB := preload("res://scripts/rules/GymBills.gd")

var failures := 0


func _initialize() -> void:
	_test1()
	_test2()
	_test3()
	_test4()
	_test5()
	_test6()
	_test7()
	_test8()
	_test9()
	_test10()
	print("GYM_BILLS failures=%d" % failures)
	quit(1 if failures > 0 else 0)


func _check(cond: bool, label: String) -> void:
	if cond:
		print("PASS ", label)
	else:
		failures += 1
		print("FAIL ", label)


## 1. Zero club: income == 0.
func _test1() -> void:
	var w: Dictionary = GB.week({"members": 0, "coach_hours_week": 0.0, "coaches": 0, "boxers": 0})
	_check(w["income"] == 0, "test 1: zero club income == 0")


## 2. A real club: 33 members, 6h coaching, 1 coach, 2 boxers.
func _test2() -> void:
	var w: Dictionary = GB.week({"members": 33, "coach_hours_week": 6.0, "coaches": 1, "boxers": 2})
	var ok := true
	if w["income"] != 267:
		ok = false
	if w["rent"] != 416:
		ok = false
	if w["coaching"] != 168:
		ok = false
	if w["fees"] != 7:
		ok = false
	if w["costs"] != 591:
		ok = false
	if w["net"] != -324:
		ok = false
	_check(ok, "test 2: real club income=267 rent=416 coaching=168 fees=7 costs=591 net=-324")


## 3. One more member adds ~8 to income.
func _test3() -> void:
	var w: Dictionary = GB.week({"members": 34, "coach_hours_week": 6.0, "coaches": 1, "boxers": 2})
	_check(w["income"] == 275, "test 3: 34 members -> income 275")


## 4. Runway weeks.
func _test4() -> void:
	var ok := true
	if GB.runway_weeks(3000, -324) != 9:
		ok = false
	if GB.runway_weeks(3000, 50) != 999:
		ok = false
	if GB.runway_weeks(-100, -324) != 0:
		ok = false
	_check(ok, "test 4: runway_weeks 9 / 999 / 0")


## 5. Status: ok / warn / red / closed.
func _test5() -> void:
	var ok := true
	if GB.status(3000, -324, 0) != "ok":
		ok = false
	if GB.status(2000, -324, 0) != "warn":
		ok = false
	if GB.status(-10, -324, 1) != "red":
		ok = false
	if GB.status(-10, -324, 4) != "closed":
		ok = false
	if GB.status(500, 100, 0) != "ok":
		ok = false
	_check(ok, "test 5: status ok/warn/red/closed")


## 6. next_below.
func _test6() -> void:
	var ok := true
	if GB.next_below(-1, 2) != 3:
		ok = false
	if GB.next_below(0, 2) != 0:
		ok = false
	if GB.next_below(100, 3) != 0:
		ok = false
	_check(ok, "test 6: next_below 3 / 0 / 0")


## 7. start_cash for the test-2 club: 591 * 4.33 * 3 = 7677 -> 7700.
func _test7() -> void:
	var sc: int = GB.start_cash({"members": 33, "coach_hours_week": 6.0, "coaches": 1, "boxers": 2})
	_check(sc == 7700, "test 7: start_cash == 7700")


## 8. break_even_members for the test-2 club: 74.
func _test8() -> void:
	var be: int = GB.break_even_members({"members": 33, "coach_hours_week": 6.0, "coaches": 1, "boxers": 2})
	_check(be == 74, "test 8: break_even_members == 74")


## 9. line().
func _test9() -> void:
	var ok := true
	if GB.line(3000, -324, 0) != "Runway: 9 weeks":
		ok = false
	if GB.line(3000, 50, 0) != "Runway: safe":
		ok = false
	if GB.line(-10, -324, 2) != "The gym closes in 2 weeks":
		ok = false
	if GB.line(-10, -324, 4) != "The gym has closed":
		ok = false
	_check(ok, "test 9: line() messages")


## 10. All values are int; determinism.
func _test10() -> void:
	var ok := true
	var g: Dictionary = {"members": 33, "coach_hours_week": 6.0, "coaches": 1, "boxers": 2}
	var w1: Dictionary = GB.week(g)
	var w2: Dictionary = GB.week(g)
	for key in ["income", "rent", "coaching", "fees", "costs", "net"]:
		if typeof(w1[key]) != TYPE_INT:
			ok = false
		if w1[key] != w2[key]:
			ok = false
	_check(ok, "test 10: all int, deterministic")
