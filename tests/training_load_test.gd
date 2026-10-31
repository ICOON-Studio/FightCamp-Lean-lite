extends SceneTree
## TrainingLoad: 9 tests.

const TL := preload("res://scripts/rules/TrainingLoad.gd")

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
	print("TRAINING_LOAD failures=%d" % failures)
	quit(1 if failures > 0 else 0)


func _check(cond: bool, label: String) -> void:
	if cond:
		print("PASS ", label)
	else:
		failures += 1
		print("FAIL ", label)


func _near(a: float, b: float) -> bool:
	return absf(a - b) < 1e-3


## 1. hours("normal") == 10.0.
func _test1() -> void:
	_check(_near(TL.hours("normal"), 10.0), "test 1: hours(normal) == 10.0")


## 2. hours and gain for all settings plus bogus.
func _test2() -> void:
	var ok := true
	if not _near(TL.hours("rest"), 3.0):
		ok = false
	if not _near(TL.hours("light"), 6.0):
		ok = false
	if not _near(TL.hours("normal"), 10.0):
		ok = false
	if not _near(TL.hours("hard"), 15.0):
		ok = false
	if not _near(TL.hours("bogus"), 10.0):
		ok = false
	if not _near(TL.gain("rest"), 0.25):
		ok = false
	if not _near(TL.gain("light"), 0.6):
		ok = false
	if not _near(TL.gain("normal"), 1.0):
		ok = false
	if not _near(TL.gain("hard"), 1.3):
		ok = false
	if not _near(TL.gain("bogus"), 1.0):
		ok = false
	_check(ok, "test 2: hours + gain all settings")


## 3. fresh_history, push, push immutability.
func _test3() -> void:
	var fh: Array = TL.fresh_history()
	var ok := true
	if fh.size() != 4:
		ok = false
	if not _near(fh[0], 10.0) or not _near(fh[1], 10.0) or not _near(fh[2], 10.0) or not _near(fh[3], 10.0):
		ok = false
	var p1: Array = TL.push([10.0, 10.0, 10.0, 10.0], 15.0)
	if p1.size() != 4:
		ok = false
	if not _near(p1[0], 10.0) or not _near(p1[1], 10.0) or not _near(p1[2], 10.0) or not _near(p1[3], 15.0):
		ok = false
	var p2: Array = TL.push([6.0], 10.0)
	if p2.size() != 2:
		ok = false
	if not _near(p2[0], 6.0) or not _near(p2[1], 10.0):
		ok = false
	var orig: Array = [10.0, 10.0, 10.0, 10.0]
	var _p3: Array = TL.push(orig, 15.0)
	if orig.size() != 4:
		ok = false
	_check(ok, "test 3: fresh_history + push + immutability")


## 4. ratio.
func _test4() -> void:
	var ok := true
	if not _near(TL.ratio("hard", TL.fresh_history()), 1.5):
		ok = false
	if not _near(TL.ratio("normal", [6.0, 6.0, 6.0, 6.0]), 1.667):
		ok = false
	if not _near(TL.ratio("light", [10.0, 10.0, 10.0, 10.0]), 0.6):
		ok = false
	if not _near(TL.ratio("normal", []), 1.0):
		ok = false
	_check(ok, "test 4: ratio 1.5/1.667/0.6/1.0")


## 5. band.
func _test5() -> void:
	var ok := true
	if TL.band(1.0) != "safe":
		ok = false
	if TL.band(1.3) != "safe":
		ok = false
	if TL.band(1.4) != "high":
		ok = false
	if TL.band(1.5) != "spike":
		ok = false
	if TL.band(2.0) != "spike":
		ok = false
	_check(ok, "test 5: band safe/high/spike")


## 6. gauge_line.
func _test6() -> void:
	var ok := true
	if TL.gauge_line(1.0) != "Load 1.0x her usual - safe":
		ok = false
	if TL.gauge_line(1.4) != "Load 1.4x her usual - injury risk up":
		ok = false
	if TL.gauge_line(1.5) != "Load 1.5x her usual - injury risk 3x":
		ok = false
	_check(ok, "test 6: gauge_line messages")


## 7. A month of Hard from Normal settles - spike only first week.
func _test7() -> void:
	var h: Array = TL.fresh_history()
	var ratios: Array = []
	for i in range(4):
		var r: float = TL.ratio("hard", h)
		ratios.append(r)
		h = TL.push(h, 15.0)
	var ok := true
	if not _near(ratios[0], 1.5):
		ok = false
	if not _near(ratios[1], 1.333):
		ok = false
	if not _near(ratios[2], 1.2):
		ok = false
	if not _near(ratios[3], 1.0909):
		ok = false
	_check(ok, "test 7: month of Hard settles 1.5/1.333/1.2/1.091")


## 8. default_for.
func _test8() -> void:
	var ok := true
	if TL.default_for(true) != "hard":
		ok = false
	if TL.default_for(false) != "normal":
		ok = false
	_check(ok, "test 8: default_for camp=true->hard camp=false->normal")


## 9. cycle.
func _test9() -> void:
	var ok := true
	if TL.cycle("rest") != "light":
		ok = false
	if TL.cycle("light") != "normal":
		ok = false
	if TL.cycle("normal") != "hard":
		ok = false
	if TL.cycle("hard") != "rest":
		ok = false
	if TL.cycle("bogus") != "normal":
		ok = false
	_check(ok, "test 9: cycle rest->light->normal->hard->rest + bogus->normal")
