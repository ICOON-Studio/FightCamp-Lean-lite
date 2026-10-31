extends SceneTree
## InjuryRoll: 13 tests.

const IR := preload("res://scripts/rules/InjuryRoll.gd")

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
	print("INJURY_ROLL failures=%d" % failures)
	quit(1 if failures > 0 else 0)


func _check(cond: bool, label: String) -> void:
	if cond:
		print("PASS ", label)
	else:
		failures += 1
		print("FAIL ", label)


func _near(a: float, b: float) -> bool:
	return absf(a - b) < 1e-6


## 1. bout_chance empty places rounds 3 ~ 0.024.
func _test1() -> void:
	var c: float = IR.bout_chance({"places": {}, "rounds": 3})
	_check(_near(c, 0.024), "test 1: bout_chance empty ~ 0.024 (got %f)" % c)


## 2. bout_chance various worst/rounds.
func _test2() -> void:
	var ok := true
	if not _near(IR.bout_chance({"places": {"head": 50.0}, "rounds": 3}), 0.06):
		ok = false
	if not _near(IR.bout_chance({"places": {"head": 100.0}, "rounds": 3}), 0.024):
		ok = false
	if not _near(IR.bout_chance({"places": {"head": 0.0}, "rounds": 3}), 0.096):
		ok = false
	if not _near(IR.bout_chance({"places": {"head": 50.0}, "rounds": 4}), 0.08):
		ok = false
	_check(ok, "test 2: bout_chance worst/rounds matrix")


## 3. ko_days.
func _test3() -> void:
	var ok := true
	if IR.ko_days([], 100) != 30:
		ok = false
	if IR.ko_days([40], 100) != 90:
		ok = false
	if IR.ko_days([5], 100) != 30:
		ok = false
	if IR.ko_days([10, 60], 100) != 365:
		ok = false
	if IR.ko_days([10, 60], 400) != 30:
		ok = false
	_check(ok, "test 3: ko_days 30/90/30/365/30")


## 4. bout_roll head_stoppage.
func _test4() -> void:
	var r: Dictionary = IR.bout_roll(1, {"head_stoppage": true, "ko_history": [40], "day": 100, "places": {}, "rounds": 3})
	var ok := true
	if r["injured"] != true:
		ok = false
	if str(r["type"]) != "ko":
		ok = false
	if int(r["days_out"]) != 90:
		ok = false
	_check(ok, "test 4: head_stoppage -> ko 90 days")


## 5. load_ratio.
func _test5() -> void:
	var ok := true
	if not _near(IR.load_ratio(10, 10.0), 1.0):
		ok = false
	if not _near(IR.load_ratio(15, 10.0), 1.5):
		ok = false
	if not _near(IR.load_ratio(8, 0.0), 1.0):
		ok = false
	_check(ok, "test 5: load_ratio 1.0/1.5/1.0")


## 6. load_mult.
func _test6() -> void:
	var ok := true
	if not _near(IR.load_mult(1.0), 1.0):
		ok = false
	if not _near(IR.load_mult(1.3), 1.0):
		ok = false
	if not _near(IR.load_mult(1.4), 2.0):
		ok = false
	if not _near(IR.load_mult(1.5), 3.0):
		ok = false
	if not _near(IR.load_mult(2.2), 3.0):
		ok = false
	_check(ok, "test 6: load_mult 1.0/1.0/2.0/3.0/3.0")


## 7. training_chance.
func _test7() -> void:
	var ok := true
	if not _near(IR.training_chance(10, 1.0), 0.013):
		ok = false
	if not _near(IR.training_chance(10, 1.6), 0.039):
		ok = false
	if not _near(IR.training_chance(15, 1.4), 0.039):
		ok = false
	_check(ok, "test 7: training_chance 0.013/0.039/0.039")


## 8. weeks_out.
func _test8() -> void:
	var ok := true
	if IR.weeks_out(0) != 0:
		ok = false
	if IR.weeks_out(1) != 1:
		ok = false
	if IR.weeks_out(7) != 1:
		ok = false
	if IR.weeks_out(8) != 2:
		ok = false
	if IR.weeks_out(30) != 5:
		ok = false
	_check(ok, "test 8: weeks_out 0/1/1/2/5")


## 9. line.
func _test9() -> void:
	var ok := true
	if IR.line({"type": "none", "days_out": 0}) != "No injuries":
		ok = false
	if IR.line({"type": "ko", "days_out": 30}) != "Suspended 30 days (stopped to the head)":
		ok = false
	if IR.line({"type": "hand", "days_out": 40}) != "Hand injury - out 6 weeks":
		ok = false
	if IR.line({"type": "strain", "days_out": 7}) != "Strain - out 1 week":
		ok = false
	_check(ok, "test 9: line() messages")


## 10. Determinism.
func _test10() -> void:
	var d: Dictionary = {"places": {"head": 50.0}, "rounds": 3}
	var b1: Dictionary = IR.bout_roll(123, d)
	var b2: Dictionary = IR.bout_roll(123, d)
	var t1: Dictionary = IR.training_roll(123, 10.0, 1.0)
	var t2: Dictionary = IR.training_roll(123, 10.0, 1.0)
	var ok := true
	for k in ["injured", "type", "days_out"]:
		if b1[k] != b2[k]:
			ok = false
		if t1[k] != t2[k]:
			ok = false
	_check(ok, "test 10: determinism bout + training")


## 11. Real-world bounds over 20000 seeds.
func _test11() -> void:
	var dmg: Dictionary = {"places": {"nose": 50.0, "head": 80.0}, "rounds": 3}
	var injuries: int = 0
	var cnh: int = 0
	var total_days: int = 0
	for s in range(1, 20001):
		var r: Dictionary = IR.bout_roll(s, dmg)
		if r["injured"]:
			injuries += 1
			var tp: String = str(r["type"])
			if tp == "cut" or tp == "nose" or tp == "head":
				cnh += 1
			total_days += int(r["days_out"])
	var rate: float = float(injuries) / 20000.0
	var share: float = float(cnh) / float(injuries) if injuries > 0 else 0.0
	var mean_d: float = float(total_days) / float(injuries) if injuries > 0 else 0.0
	var ok := true
	if rate < 0.052 or rate > 0.068:
		ok = false
	if share < 0.64 or share > 0.80:
		ok = false
	if mean_d < 24.0 or mean_d > 36.0:
		ok = false
	_check(ok, "test 11: bounds rate=%f share=%f mean_days=%f" % [rate, share, mean_d])


## 12. Cut face doubles cuts.
func _test12() -> void:
	var dmg_hi: Dictionary = {"places": {"nose": 50.0, "head": 80.0}, "rounds": 3}
	var dmg_lo: Dictionary = {"places": {"nose": 30.0, "head": 80.0}, "rounds": 3}
	var cuts_hi: int = 0
	var cuts_lo: int = 0
	var inj_hi: int = 0
	var inj_lo: int = 0
	for s in range(1, 20001):
		var r1: Dictionary = IR.bout_roll(s, dmg_hi)
		if r1["injured"]:
			inj_hi += 1
			if str(r1["type"]) == "cut":
				cuts_hi += 1
		var r2: Dictionary = IR.bout_roll(s, dmg_lo)
		if r2["injured"]:
			inj_lo += 1
			if str(r2["type"]) == "cut":
				cuts_lo += 1
	var share_hi: float = float(cuts_hi) / float(inj_hi) if inj_hi > 0 else 0.0
	var share_lo: float = float(cuts_lo) / float(inj_lo) if inj_lo > 0 else 0.0
	_check(share_lo > share_hi, "test 12: cut face doubles cuts hi=%f lo=%f" % [share_hi, share_lo])


## 13. Training bounds.
func _test13() -> void:
	var inj_normal: int = 0
	var inj_high: int = 0
	for s in range(1, 20001):
		if IR.training_roll(s, 10.0, 1.0)["injured"]:
			inj_normal += 1
		if IR.training_roll(s, 10.0, 1.6)["injured"]:
			inj_high += 1
	var rate_normal: float = float(inj_normal) / 20000.0
	var rate_high: float = float(inj_high) / 20000.0
	var ratio: float = rate_high / rate_normal if rate_normal > 0.0 else 0.0
	var ok := true
	if rate_normal < 0.009 or rate_normal > 0.017:
		ok = false
	if ratio < 2.5 or ratio > 3.5:
		ok = false
	_check(ok, "test 13: training rate_normal=%f rate_high=%f ratio=%f" % [rate_normal, rate_high, ratio])
