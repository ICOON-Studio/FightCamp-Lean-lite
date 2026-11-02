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


## 3. S327 her usual: fresh 10 h, the EWMA step (42-day span), an old save's history read as its average.
func _test3() -> void:
	var ok := true
	if not _near(TL.fresh_chronic(), 10.0):
		ok = false
	if not _near(TL.CHRONIC_DECAY, 1.0 - exp(-7.0 / 42.0)):
		ok = false
	if not _near(TL.next_chronic(10.0, 15.0), 10.768):
		ok = false
	if not _near(TL.next_chronic(10.0, 3.0), 8.925):
		ok = false
	if not _near(TL.next_chronic(10.0, 10.0), 10.0):
		ok = false
	if not _near(TL.chronic_from_history([10.0, 10.0, 3.0, 10.0]), 8.25) or not _near(TL.chronic_from_history([]), 10.0):
		ok = false
	_check(ok, "test 3: fresh_chronic 10 / next_chronic 10.768, 8.925, 10 / old history 8.25")


## 4. ratio.
func _test4() -> void:
	var ok := true
	if not _near(TL.ratio("hard", TL.fresh_chronic()), 1.5):
		ok = false
	if not _near(TL.ratio("normal", 6.0), 1.667):
		ok = false
	if not _near(TL.ratio("light", 10.0), 0.6):
		ok = false
	if not _near(TL.ratio("normal", 0.0), 1.0):
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
	if TL.gauge_line(1.0) != "Load 1.0x the usual - safe":
		ok = false
	if TL.gauge_line(1.4) != "Load 1.4x the usual - injury risk up":
		ok = false
	if TL.gauge_line(1.5) != "Load 1.5x the usual - injury risk 3x":
		ok = false
	_check(ok, "test 6: gauge_line messages")


## 7. A month of Hard from Normal settles slowly (her fitness rises): 1.5 / 1.393 / 1.314 / 1.253. And the S327 defect's
## control: Normal, a rest week, Normal again reads safe (1.120x) - the 4-week average read 1.212x.
func _test7() -> void:
	var h: float = TL.fresh_chronic()
	var ratios: Array = []
	for i in range(4):
		ratios.append(TL.ratio("hard", h))
		h = TL.next_chronic(h, 15.0)
	var ok := true
	if not _near(ratios[0], 1.5):
		ok = false
	if not _near(ratios[1], 1.393):
		ok = false
	if not _near(ratios[2], 1.314):
		ok = false
	if not _near(ratios[3], 1.253):
		ok = false
	var back: float = TL.ratio("normal", TL.next_chronic(10.0, TL.hours("rest")))
	if not _near(back, 1.120) or TL.band(back) != "safe":
		ok = false
	_check(ok, "test 7: month of Hard 1.5/1.393/1.314/1.253; back from rest 1.120 safe")


## 8. default_for.
func _test8() -> void:
	var ok := true
	if TL.default_for(true) != "hard":
		ok = false
	if TL.default_for(false) != "normal":
		ok = false
	_check(ok, "test 8: default_for camp=true->hard camp=false->normal")
	# S327 camp_default: from a normal month Hard is a spike, so Normal; once her usual is 11.6 h+ Hard is safe.
	_check(TL.camp_default(10.0) == "normal" and TL.camp_default(11.6) == "hard" and TL.camp_default(5.0) == "normal",
		"test 8b: camp_default 10 h -> normal, 11.6 h -> hard, 5 h -> normal")


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
