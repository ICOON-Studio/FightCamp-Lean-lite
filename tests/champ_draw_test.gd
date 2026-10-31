extends SceneTree
## ChampDraw: 11 tests.

const CD := preload("res://scripts/rules/ChampDraw.gd")

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
	print("CHAMP_DRAW failures=%d" % failures)
	quit(1 if failures > 0 else 0)


func _check(cond: bool, label: String) -> void:
	if cond:
		print("PASS ", label)
	else:
		failures += 1
		print("FAIL ", label)


func _deep_eq(a, b) -> bool:
	if a is Array and b is Array:
		if a.size() != b.size():
			return false
		for i in range(a.size()):
			if not _deep_eq(a[i], b[i]):
				return false
		return true
	if a is Dictionary and b is Dictionary:
		if a.size() != b.size():
			return false
		for k in a:
			if not b.has(k):
				return false
			if not _deep_eq(a[k], b[k]):
				return false
		return true
	return a == b


## 1. order(8) == [1, 8, 4, 5, 2, 7, 3, 6].
func _test1() -> void:
	var got: Array = CD.order(8)
	var expected: Array = [1, 8, 4, 5, 2, 7, 3, 6]
	_check(got == expected, "test 1: order(8) (got %s)" % str(got))


## 2. order basic cases.
func _test2() -> void:
	var ok := true
	if CD.order(1) != [1]:
		ok = false
	if CD.order(2) != [1, 2]:
		ok = false
	if CD.order(4) != [1, 4, 2, 3]:
		ok = false
	var o16: Array = CD.order(16)
	if o16.size() != 16 or o16[0] != 1 or o16[1] != 16:
		ok = false
	_check(ok, "test 2: order(1), order(2), order(4), order(16)")


## 3. seeds: sort by rating desc, ties by id asc.
func _test3() -> void:
	var entrants: Array = [
		{"id": "c", "rating": 60.0},
		{"id": "a", "rating": 70.0},
		{"id": "b", "rating": 60.0},
	]
	var got: Array = CD.seeds(entrants)
	_check(got == ["a", "b", "c"], "test 3: seeds (got %s)" % str(got))


## 4. first_round of 6 entrants -> P=8, specific pairs.
func _test4() -> void:
	var entrants: Array = [
		{"id": "e1", "rating": 90.0},
		{"id": "e2", "rating": 80.0},
		{"id": "e3", "rating": 70.0},
		{"id": "e4", "rating": 60.0},
		{"id": "e5", "rating": 50.0},
		{"id": "e6", "rating": 40.0},
	]
	var got: Array = CD.first_round(entrants)
	var expected: Array = [
		["e1", "BYE"],
		["e4", "e5"],
		["e2", "BYE"],
		["e3", "e6"],
	]
	_check(got == expected, "test 4: first_round(6) (got %s)" % str(got))


## 5. first_round edge cases: 2, 1, 0.
func _test5() -> void:
	var ok := true
	var e2: Array = [{"id": "e1", "rating": 90.0}, {"id": "e2", "rating": 80.0}]
	if CD.first_round(e2) != [["e1", "e2"]]:
		ok = false
	var e1: Array = [{"id": "e1", "rating": 90.0}]
	if CD.first_round(e1) != [["e1", "BYE"]]:
		ok = false
	if CD.first_round([]) != []:
		ok = false
	_check(ok, "test 5: first_round(2), first_round(1), first_round(0)")


## 6. win_chance.
func _test6() -> void:
	var ok := true
	var wc1: float = CD.win_chance(60.0, 60.0)
	if abs(wc1 - 0.5) > 0.001:
		ok = false
	var wc2: float = CD.win_chance(68.0, 60.0)
	if abs(wc2 - 0.731) > 0.001:
		ok = false
	var wc3: float = CD.win_chance(60.0, 68.0)
	if abs(wc2 + wc3 - 1.0) > 0.001:
		ok = false
	_check(ok, "test 6: win_chance (60v60=%.3f, 68v60=%.3f, sum=%.3f)" % [wc1, wc2, wc2 + wc3])


## 7. opponent.
func _test7() -> void:
	var pairs: Array = [
		["e1", "BYE"],
		["e4", "e5"],
		["e2", "BYE"],
		["e3", "e6"],
	]
	var ok := true
	if CD.opponent(pairs, "e4") != "e5":
		ok = false
	if CD.opponent(pairs, "e1") != "BYE":
		ok = false
	if CD.opponent(pairs, "zz") != "":
		ok = false
	_check(ok, "test 7: opponent")


## 8. winners.
func _test8() -> void:
	var pairs: Array = [
		["e1", "BYE"],
		["e4", "e5"],
		["e2", "BYE"],
		["e3", "e6"],
	]
	var ratings: Dictionary = {
		"e1": 90.0, "e2": 80.0, "e3": 70.0,
		"e4": 60.0, "e5": 50.0, "e6": 40.0,
	}
	var ok := true
	var w1: Array = CD.winners(pairs, ratings, "e4", true, 7)
	if w1[0] != "e1":
		ok = false
	if w1[1] != "e4":
		ok = false
	if w1[2] != "e2":
		ok = false
	if w1[3] != "e3" and w1[3] != "e6":
		ok = false
	var w2: Array = CD.winners(pairs, ratings, "e4", false, 7)
	if w2[1] != "e5":
		ok = false
	var w3: Array = CD.winners(pairs, ratings, "e4", true, 7)
	if w3 != w1:
		ok = false
	var byebye: Array = [["BYE", "BYE"]]
	if CD.winners(byebye, {}, "x", true, 1) != ["BYE"]:
		ok = false
	_check(ok, "test 8: winners (w1=%s, w2[1]=%s)" % [str(w1), w2[1]])


## 9. Statistical: e1(90) beats e6(40) >= 390/400; x(60) v y(60) 160-240.
func _test9() -> void:
	var pairs_a: Array = [["e1", "e6"]]
	var ratings_a: Dictionary = {"e1": 90.0, "e6": 40.0}
	var e1_wins := 0
	for s in range(1, 401):
		var w: Array = CD.winners(pairs_a, ratings_a, "", false, s)
		if w[0] == "e1":
			e1_wins += 1
	var pairs_b: Array = [["x", "y"]]
	var ratings_b: Dictionary = {"x": 60.0, "y": 60.0}
	var x_wins := 0
	for s in range(1, 401):
		var w: Array = CD.winners(pairs_b, ratings_b, "", false, s)
		if w[0] == "x":
			x_wins += 1
	var ok := true
	if e1_wins < 390:
		ok = false
	if x_wins < 160 or x_wins > 240:
		ok = false
	_check(ok, "test 9: stats (e1_wins=%d/400, x_wins=%d/400)" % [e1_wins, x_wins])


## 10. next_round.
func _test10() -> void:
	var ok := true
	if CD.next_round(["a", "b", "c", "d"]) != [["a", "b"], ["c", "d"]]:
		ok = false
	if CD.next_round(["a"]) != []:
		ok = false
	_check(ok, "test 10: next_round")


## 11. No function changes its inputs.
func _test11() -> void:
	var ok := true
	var entrants: Array = [
		{"id": "c", "rating": 60.0},
		{"id": "a", "rating": 70.0},
		{"id": "b", "rating": 60.0},
	]
	var entrants_copy: Array = entrants.duplicate(true)
	CD.seeds(entrants)
	if not _deep_eq(entrants, entrants_copy):
		ok = false
	CD.first_round(entrants)
	if not _deep_eq(entrants, entrants_copy):
		ok = false
	var pairs: Array = [
		["e1", "BYE"],
		["e4", "e5"],
		["e2", "BYE"],
		["e3", "e6"],
	]
	var pairs_copy: Array = pairs.duplicate(true)
	var ratings: Dictionary = {
		"e1": 90.0, "e2": 80.0, "e3": 70.0,
		"e4": 60.0, "e5": 50.0, "e6": 40.0,
	}
	var ratings_copy: Dictionary = ratings.duplicate(true)
	CD.winners(pairs, ratings, "e4", true, 7)
	if not _deep_eq(pairs, pairs_copy):
		ok = false
	if not _deep_eq(ratings, ratings_copy):
		ok = false
	CD.opponent(pairs, "e4")
	if not _deep_eq(pairs, pairs_copy):
		ok = false
	CD.next_round(["a", "b", "c"])
	_check(ok, "test 11: no mutation of inputs")
