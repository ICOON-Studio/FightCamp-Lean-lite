extends SceneTree
## BodyTrack: 11 tests.

const BT := preload("res://scripts/rules/BodyTrack.gd")
const BL := preload("res://scripts/rules/BodyLoad.gd")

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
	print("BODY_TRACK failures=%d" % failures)
	quit(1 if failures > 0 else 0)


func _check(cond: bool, label: String) -> void:
	if cond:
		print("PASS ", label)
	else:
		failures += 1
		print("FAIL ", label)


## 1. Endpoints: colour(0) == fresh, colour(100) == burning.
func _test1() -> void:
	var ok := true
	var c0: Color = BT.colour(0.0)
	if not c0.is_equal_approx(BT.COLOURS["fresh"]):
		ok = false
	var c100: Color = BT.colour(100.0)
	if not c100.is_equal_approx(BT.COLOURS["burning"]):
		ok = false
	_check(ok, "test 1: colour(0) == fresh, colour(100) == burning")


## 2. Band edges + agreement with BodyLoad.band at every 5.
func _test2() -> void:
	var ok := true
	if BT.band(24.9) != "fresh":
		ok = false
	if BT.band(25.0) != "warm":
		ok = false
	if BT.band(49.9) != "warm":
		ok = false
	if BT.band(50.0) != "hot":
		ok = false
	if BT.band(75.0) != "burning":
		ok = false
	var v: float = 0.0
	while v <= 100.0:
		if BT.band(v) != BL.band(v):
			ok = false
		v += 5.0
	_check(ok, "test 2: band edges + BodyLoad agreement at every 5")


## 3. Centres: colour(37.5) == warm, colour(62.5) == hot.
func _test3() -> void:
	var ok := true
	var c37: Color = BT.colour(37.5)
	if not c37.is_equal_approx(BT.COLOURS["warm"]):
		ok = false
	var c62: Color = BT.colour(62.5)
	if not c62.is_equal_approx(BT.COLOURS["hot"]):
		ok = false
	_check(ok, "test 3: colour(37.5) == warm, colour(62.5) == hot")


## 4. Lerp: colour(50) is halfway between warm and hot (each channel within 0.01).
func _test4() -> void:
	var ok := true
	var c: Color = BT.colour(50.0)
	var w: Color = BT.COLOURS["warm"]
	var h: Color = BT.COLOURS["hot"]
	if absf(c.r - lerpf(w.r, h.r, 0.5)) > 0.01:
		ok = false
	if absf(c.g - lerpf(w.g, h.g, 0.5)) > 0.01:
		ok = false
	if absf(c.b - lerpf(w.b, h.b, 0.5)) > 0.01:
		ok = false
	_check(ok, "test 4: colour(50) halfway between warm and hot")


## 5. Continuous: no channel jumps more than 0.05 between 0.5 steps.
func _test5() -> void:
	var ok := true
	var prev_c: Color = BT.colour(0.0)
	var v: float = 0.5
	while v <= 100.0:
		var cur_c: Color = BT.colour(v)
		if absf(cur_c.r - prev_c.r) > 0.05:
			ok = false
		if absf(cur_c.g - prev_c.g) > 0.05:
			ok = false
		if absf(cur_c.b - prev_c.b) > 0.05:
			ok = false
		prev_c = cur_c
		v += 0.5
	_check(ok, "test 5: continuous - no channel jump > 0.05 at 0.5 steps")


## 6. Red rises: red channel never falls from 37.5 to 100 in steps of 1.
func _test6() -> void:
	var ok := true
	var prev_r: float = BT.colour(37.5).r
	var v: float = 38.0
	while v <= 100.0:
		var cur_r: float = BT.colour(v).r
		if cur_r < prev_r - 0.001:
			ok = false
		prev_r = cur_r
		v += 1.0
	_check(ok, "test 6: red channel never falls from 37.5 to 100")


## 7. body_place: orthodox and southpaw mappings.
func _test7() -> void:
	var ok := true
	if BT.body_place("lead_shoulder", false) != "left_shoulder":
		ok = false
	if BT.body_place("rear_arm", false) != "right_arm":
		ok = false
	if BT.body_place("lead_arm", true) != "right_arm":
		ok = false
	if BT.body_place("rear_shoulder", true) != "left_shoulder":
		ok = false
	if BT.body_place("core", false) != "core":
		ok = false
	if BT.body_place("legs", true) != "legs":
		ok = false
	_check(ok, "test 7: body_place orthodox and southpaw")


## 8. pulse: threshold crossings.
func _test8() -> void:
	var ok := true
	if not BT.pulse(20.0, 30.0):
		ok = false
	if BT.pulse(30.0, 40.0):
		ok = false
	if not BT.pulse(40.0, 80.0):
		ok = false
	if BT.pulse(80.0, 40.0):
		ok = false
	if not BT.pulse(24.9, 25.0):
		ok = false
	if BT.pulse(25.0, 25.0):
		ok = false
	_check(ok, "test 8: pulse threshold crossings")


## 9. label formatting.
func _test9() -> void:
	var ok := true
	if BT.label("lead_shoulder", 60.0) != "Jab shoulder: hot":
		ok = false
	if BT.label("legs", 0.0) != "Legs: fresh":
		ok = false
	_check(ok, "test 9: label formatting")


## 10. worst_line.
func _test10() -> void:
	var ok := true
	if BT.worst_line({}) != "":
		ok = false
	if BT.worst_line({"legs": 49.0}) != "":
		ok = false
	if BT.worst_line({"legs": 80.0, "core": 60.0}) != "Legs burning":
		ok = false
	if BT.worst_line({"lead_shoulder": 60.0, "rear_shoulder": 60.0}) != "Jab shoulder hot":
		ok = false
	_check(ok, "test 10: worst_line")


## 11. Determinism: same input -> same output.
func _test11() -> void:
	var ok := true
	for i in 100:
		var burn: float = float(i) * 1.01
		if BT.band(burn) != BT.band(burn):
			ok = false
		var c1: Color = BT.colour(burn)
		var c2: Color = BT.colour(burn)
		if not c1.is_equal_approx(c2):
			ok = false
	var burns_a: Dictionary = {"lead_shoulder": 60.0, "legs": 80.0}
	var burns_b: Dictionary = {"lead_shoulder": 60.0, "legs": 80.0}
	if BT.worst_line(burns_a) != BT.worst_line(burns_b):
		ok = false
	_check(ok, "test 11: determinism")
