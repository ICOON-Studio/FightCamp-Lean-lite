extends SceneTree
## SeasonPath: 13 tests.

const SP := preload("res://scripts/rules/SeasonPath.gd")

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
	_test12()
	_test13()
	print("SEASON_PATH failures=%d" % failures)
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


func _same_sched(a: Array, b: Array) -> bool:
	if a.size() != b.size():
		return false
	for i in range(a.size()):
		if not _same_dict(a[i], b[i]):
			return false
	return true


## 1. eligible basic pass.
func _test1() -> void:
	var r: Dictionary = SP.eligible(5, 91, 22, false, false)
	var expected: Dictionary = {"ok": true, "reason": ""}
	_check(_same_dict(r, expected), "test 1: eligible(5,91,22,false,false) == ok (got %s)" % str(r))


## 2. Order: turned_pro -> injured -> age young -> age old.
func _test2() -> void:
	var r1: String = SP.eligible(0, 0, 17, true, true)["reason"]
	var r2: String = SP.eligible(0, 0, 17, true, false)["reason"]
	var r3: String = SP.eligible(0, 0, 17, false, false)["reason"]
	var r4: String = SP.eligible(9, 200, 41, false, false)["reason"]
	var ok := true
	if r1 != "Professionals cannot enter":
		ok = false
	if r2 != "Injured or suspended":
		ok = false
	if r3 != "Too young for Elite (19+)":
		ok = false
	if r4 != "Too old for Elite (40 max)":
		ok = false
	_check(ok, "test 2: eligible order (r1='%s', r2='%s', r3='%s', r4='%s')" % [r1, r2, r3, r4])


## 3. Bouts and club_days reasons.
func _test3() -> void:
	var r1: String = SP.eligible(3, 200, 22, false, false)["reason"]
	var r2: String = SP.eligible(5, 77, 22, false, false)["reason"]
	var r3: String = SP.eligible(5, 90, 22, false, false)["reason"]
	var ok := true
	if r1 != "Needs 5 bouts (has 3)":
		ok = false
	if r2 != "Needs 3 months registered (2 weeks to go)":
		ok = false
	if not r3.ends_with("(1 weeks to go)"):
		ok = false
	_check(ok, "test 3: bouts/club_days reasons (r1='%s', r2='%s', r3='%s')" % [r1, r2, r3])


## 4. entry_close.
func _test4() -> void:
	var a: int = SP.entry_close(0)
	var b: int = SP.entry_close(70)
	var c: int = SP.entry_close(71)
	var d: int = SP.entry_close(600)
	var ok := true
	if a != 70:
		ok = false
	if b != 70:
		ok = false
	if c != 434:
		ok = false
	if d != 798:
		ok = false
	_check(ok, "test 4: entry_close (0->%d, 70->%d, 71->%d, 600->%d)" % [a, b, c, d])


## 5. bouts_to_win.
func _test5() -> void:
	var ok := true
	var cases: Array = [[0, 0], [1, 0], [2, 1], [3, 2], [4, 2], [5, 3], [8, 3], [9, 4], [16, 4]]
	for pair in cases:
		var got: int = SP.bouts_to_win(pair[0])
		if got != pair[1]:
			ok = false
	_check(ok, "test 5: bouts_to_win")


## 6. has_bye.
func _test6() -> void:
	var ok := true
	if not SP.has_bye(6, 1):
		ok = false
	if not SP.has_bye(6, 2):
		ok = false
	if SP.has_bye(6, 3):
		ok = false
	if SP.has_bye(8, 1):
		ok = false
	if not SP.has_bye(1, 1):
		ok = false
	_check(ok, "test 6: has_bye")


## 7. schedule(140, 4, 3, 16, 9): 6 bouts.
func _test7() -> void:
	var got: Array = SP.schedule(140, 4, 3, 16, 9)
	var expected: Array = [
		{"stage": 0, "day": 154},
		{"stage": 1, "day": 161},
		{"stage": 2, "day": 182},
		{"stage": 3, "day": 183},
		{"stage": 4, "day": 189},
		{"stage": 5, "day": 190},
	]
	_check(_same_sched(got, expected) and got.size() == 6,
		"test 7: schedule(140,4,3,16,9) 6 bouts (got %s)" % str(got))


## 8. schedule(140, 2, 1, 8, 1): regional final + 3 national bouts.
func _test8() -> void:
	var got: Array = SP.schedule(140, 2, 1, 8, 1)
	var expected: Array = [
		{"stage": 1, "day": 161},
		{"stage": 3, "day": 183},
		{"stage": 4, "day": 189},
		{"stage": 5, "day": 190},
	]
	_check(_same_sched(got, expected),
		"test 8: schedule(140,2,1,8,1) (got %s)" % str(got))


## 9. Byes: schedule(140, 3, 1, 6, 2).
func _test9() -> void:
	var got: Array = SP.schedule(140, 3, 1, 6, 2)
	var expected: Array = [
		{"stage": 1, "day": 161},
		{"stage": 4, "day": 189},
		{"stage": 5, "day": 190},
	]
	_check(_same_sched(got, expected),
		"test 9: schedule byes (140,3,1,6,2) (got %s)" % str(got))


## 10. Walkover: schedule(140, 1, 1, 2, 1) -> only national final.
func _test10() -> void:
	var got: Array = SP.schedule(140, 1, 1, 2, 1)
	var expected: Array = [
		{"stage": 5, "day": 190},
	]
	_check(_same_sched(got, expected),
		"test 10: walkover (got %s)" % str(got))


## 11. result_words.
func _test11() -> void:
	var ok := true
	if SP.result_words(5, true) != "National champion":
		ok = false
	if SP.result_words(5, false) != "National runner-up":
		ok = false
	if SP.result_words(4, false) != "National bronze":
		ok = false
	if SP.result_words(3, false) != "Reached the national quarter-final":
		ok = false
	if SP.result_words(1, true) != "Regional champion":
		ok = false
	if SP.result_words(0, false) != "Lost in the regional semi-final":
		ok = false
	_check(ok, "test 11: result_words")


## 12. goal_line.
func _test12() -> void:
	var a: String = SP.goal_line(0, 2, 35, false)
	var b: String = SP.goal_line(30, 7, 120, true)
	var e: String = SP.goal_line(0, 4, 112, false)
	var ok := true
	if a != "Road to the nationals: 2/5 bouts, 5 of 13 weeks registered, entries close in 70 days":
		ok = false
	if b != "Ready for the nationals - enter before entries close in 40 days":
		ok = false
	if e != "Road to the nationals: 4/5 bouts, entries close in 70 days":
		ok = false
	_check(ok, "test 12: goal_line (a='%s', b='%s', e='%s')" % [a, b, e])


## 13. Same input -> same output; no function changes its inputs.
func _test13() -> void:
	var ok := true
	var r1: Dictionary = SP.eligible(3, 77, 22, false, false)
	var r2: Dictionary = SP.eligible(3, 77, 22, false, false)
	if not _same_dict(r1, r2):
		ok = false
	var s1: Array = SP.schedule(140, 4, 3, 16, 9)
	var s2: Array = SP.schedule(140, 4, 3, 16, 9)
	if not _same_sched(s1, s2):
		ok = false
	var w1: String = SP.result_words(3, false)
	var w2: String = SP.result_words(3, false)
	if w1 != w2:
		ok = false
	var g1: String = SP.goal_line(0, 2, 35, false)
	var g2: String = SP.goal_line(0, 2, 35, false)
	if g1 != g2:
		ok = false
	_check(ok, "test 13: same input -> same output")
