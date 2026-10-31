extends SceneTree
## BodyReport: 11 tests.

const BR := preload("res://scripts/rules/BodyReport.gd")

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
	_test11()
	print("BODY_REPORT failures=%d" % failures)
	quit(1 if failures > 0 else 0)


func _check(cond: bool, label: String) -> void:
	if cond:
		print("PASS ", label)
	else:
		failures += 1
		print("FAIL ", label)


func _same_dict(a: Dictionary, b: Dictionary) -> bool:
	if a.size() != b.size():
		return false
	for k in a:
		if not b.has(k):
			return false
		if a[k] is Dictionary and b[k] is Dictionary:
			if not _same_dict(a[k], b[k]):
				return false
		elif a[k] != b[k]:
			return false
	return true


## 1. first_went([]) == {}.
func _test1() -> void:
	var r: Dictionary = BR.first_went([])
	_check(r.is_empty(), "test 1: first_went([]) == {}")


## 2. Legs go in round 2.
func _test2() -> void:
	var rounds: Array = [{"legs": 30, "core": 20}, {"legs": 55, "lead_shoulder": 52}, {"legs": 70}]
	var r: Dictionary = BR.first_went(rounds)
	var expected: Dictionary = {"part": "legs", "round": 2}
	_check(_same_dict(r, expected),
		"test 2: first_went legs r2 (got %s, expected %s)" % [str(r), str(expected)])


## 3. Highest in the round wins.
func _test3() -> void:
	var r: Dictionary = BR.first_went([{"lead_shoulder": 60, "legs": 51}])
	var expected: Dictionary = {"part": "lead_shoulder", "round": 1}
	_check(_same_dict(r, expected),
		"test 3: first_went highest in round wins (got %s, expected %s)" % [str(r), str(expected)])


## 4. Tie -> earlier key in PARTS.
func _test4() -> void:
	var r: Dictionary = BR.first_went([{"core": 50, "legs": 50}])
	var expected: Dictionary = {"part": "core", "round": 1}
	_check(_same_dict(r, expected),
		"test 4: first_went tie -> earlier key (got %s, expected %s)" % [str(r), str(expected)])


## 5. Nothing reaches 50.
func _test5() -> void:
	var r: Dictionary = BR.first_went([{"legs": 49.9}, {"legs": 49.9}])
	_check(r.is_empty(), "test 5: first_went nothing reaches 50")


## 6. worst_at_end.
func _test6() -> void:
	var a: String = BR.worst_at_end([{"legs": 80}, {"legs": 40, "rear_arm": 41}])
	var b: String = BR.worst_at_end([])
	_check(a == "rear_arm" and b == "",
		"test 6: worst_at_end (got '%s' and '%s', expected 'rear_arm' and '')" % [a, b])


## 7. report with legs going in round 2.
func _test7() -> void:
	var rounds: Array = [{"legs": 30, "core": 20}, {"legs": 55, "lead_shoulder": 52}, {"legs": 70}]
	var r: Dictionary = BR.report(rounds, "Lucy")
	var expected: Dictionary = {"part": "legs", "round": 2, "focus": "conditioning",
		"line": "Lucy's legs went in round 2", "advice": "Next week: Conditioning"}
	_check(_same_dict(r, expected),
		"test 7: report Lucy legs r2 (got %s, expected %s)" % [str(r), str(expected)])


## 8. report focus and line for technique and power.
func _test8() -> void:
	var r1: Dictionary = BR.report([{"lead_arm": 51}], "Maria")
	var r2: Dictionary = BR.report([{"rear_shoulder": 90}], "Maria")
	var ok := true
	if str(r1["focus"]) != "technique":
		ok = false
	if str(r1["line"]) != "Maria's jab arm went in round 1":
		ok = false
	if str(r2["advice"]) != "Next week: Power":
		ok = false
	_check(ok,
		"test 8: report focus/line (r1=%s, r2=%s)" % [str(r1), str(r2)])


## 9. report held-up lines.
func _test9() -> void:
	var r1: Dictionary = BR.report([{"legs": 10}, {"legs": 20}, {"legs": 30}], "Lucy")
	var r2: Dictionary = BR.report([{"legs": 10}], "Lucy")
	var ok := true
	if str(r1["line"]) != "Lucy held up for all 3 rounds":
		ok = false
	if str(r2["line"]) != "Lucy held up for all 1 round":
		ok = false
	_check(ok,
		"test 9: report held-up lines (r1='%s', r2='%s')" % [str(r1["line"]), str(r2["line"])])


## 10. change_line.
func _test10() -> void:
	var legs_r2: Dictionary = {"part": "legs", "round": 2, "focus": "conditioning",
		"line": "Lucy's legs went in round 2", "advice": "Next week: Conditioning"}
	var legs_r3: Dictionary = {"part": "legs", "round": 3, "focus": "conditioning",
		"line": "Lucy's legs went in round 3", "advice": "Next week: Conditioning"}
	var legs_r1: Dictionary = {"part": "legs", "round": 1, "focus": "conditioning",
		"line": "Lucy's legs went in round 1", "advice": "Next week: Conditioning"}
	var none_3: Dictionary = {"part": "", "round": 0, "focus": "",
		"line": "Lucy held up for all 3 rounds", "advice": ""}
	var core_r1: Dictionary = {"part": "core", "round": 1, "focus": "conditioning",
		"line": "Lucy's body went in round 1", "advice": "Next week: Conditioning"}
	var core_r2: Dictionary = {"part": "core", "round": 2, "focus": "conditioning",
		"line": "Lucy's body went in round 2", "advice": "Next week: Conditioning"}
	var empty: Dictionary = {}
	var ok := true
	var c1: String = BR.change_line(legs_r2, legs_r3)
	if c1 != "Her legs held until round 3 this time (round 2 last fight)":
		ok = false
	var c2: String = BR.change_line(legs_r2, legs_r2)
	if c2 != "Her legs went in round 2 again":
		ok = false
	var c3: String = BR.change_line(legs_r2, legs_r1)
	if c3 != "Her legs went sooner: round 1 (round 2 last fight)":
		ok = false
	var c4: String = BR.change_line(legs_r2, none_3)
	if c4 != "Her legs held up this time (they went in round 2 last fight)":
		ok = false
	var c5: String = BR.change_line(core_r1, none_3)
	if c5 != "Her body held up this time (it went in round 1 last fight)":
		ok = false
	var c6: String = BR.change_line(empty, legs_r2)
	if c6 != "":
		ok = false
	var c7: String = BR.change_line(legs_r2, core_r2)
	if c7 != "":
		ok = false
	_check(ok,
		"test 10: change_line (c1='%s', c2='%s', c3='%s', c4='%s', c5='%s', c6='%s', c7='%s')" % [c1, c2, c3, c4, c5, c6, c7])


## 11. Same input -> same output; report() never changes the rounds array.
func _test11() -> void:
	var rounds: Array = [{"legs": 30, "core": 20}, {"legs": 55, "lead_shoulder": 52}, {"legs": 70}]
	var before: String = str(rounds)
	var r1: Dictionary = BR.report(rounds, "Lucy")
	var r2: Dictionary = BR.report(rounds, "Lucy")
	var after: String = str(rounds)
	var ok := true
	if not _same_dict(r1, r2):
		ok = false
	if before != after:
		ok = false
	_check(ok, "test 11: same input -> same output; rounds not mutated")
