extends SceneTree
## S371 TestDay (GOALTESTS1 phase 2): the three Sunday tests and the records wall. Population: Lucy (Data.lucy: speed
## 63.2, power 58.4, conditioning 61.6) as signed; the same boxer after a block of training; Danny Osei (a man - no
## men's norms until J_TESTS3).

const Data := preload("res://scripts/state/Data.gd")
const TestDay := preload("res://scripts/rules/TestDay.gd")

var failures := 0


func _initialize() -> void:
	_values()
	_wall()
	_men()
	print("TEST_DAY failures=%d" % failures)
	quit(1 if failures > 0 else 0)


func _check(cond: bool, label: String) -> void:
	if cond:
		print("PASS ", label)
	else:
		failures += 1
		print("FAIL ", label)


## The anchors read back (J_TESTS2): 40 = a beginner, 60 = a club boxer, 85 = elite; between them in order; no dice.
func _values() -> void:
	var f := {"stats": {"speed": 85.0, "power": 85.0, "conditioning": 85.0}}
	var m := TestDay.measure(f)
	_check(int(m["speed"]) == 52 and is_equal_approx(float(m["power"]), 990.0), "elite reads 52 punches and 990 N (%s, %s)" % [m["speed"], m["power"]])
	var b := TestDay.measure({"stats": {"speed": 40.0, "power": 40.0, "conditioning": 40.0}})
	_check(int(b["speed"]) >= 35 and int(b["speed"]) <= 42 and is_equal_approx(float(b["power"]), 490.0), "a beginner reads 35-42 punches and 490 N (%s, %s)" % [b["speed"], b["power"]])
	var lucy := TestDay.measure(Data.lucy())
	_check(int(lucy["speed"]) >= 45 and int(lucy["speed"]) <= 50, "Lucy (speed 63) is in the intermediate band 45-50 (%s)" % lucy["speed"])
	_check(TestDay.measure(Data.lucy()) == lucy, "the same week gives the same numbers")
	var top := TestDay.measure({"stats": {"speed": 99.0, "power": 99.0, "conditioning": 99.0}})
	_check(int(top["speed"]) > 52 and int(top["speed"]) < 56, "past elite the line flattens (99 -> %s punches)" % top["speed"])


func _wall() -> void:
	var f := Data.fighter_state(Data.lucy(), 0)
	_check(TestDay.wall(f).is_empty(), "no wall before the first check-in")
	var first := TestDay.record(f, 7)
	_check(first.is_empty() and TestDay.wall(f).size() == 3, "the first check-in writes three numbers and beats nothing")
	_check(TestDay.record(f, 14).is_empty(), "an unchanged week beats nothing")
	f["stats"]["speed"] = float(f["stats"]["speed"]) + 6.0
	var beat := TestDay.record(f, 21)
	_check(beat.size() == 1 and str(beat[0]["id"]) == "speed" and float(beat[0]["new"]) > float(beat[0]["old"]), "faster hands beat the speed best only (%d)" % beat.size())
	var row: Dictionary = TestDay.wall(f).filter(func(r): return str(r["id"]) == "speed")[0]
	_check(float(row["prev"]) == float(beat[0]["old"]) and int(row["d"]) == 21, "the wall keeps the beaten number to chalk through")
	_check(float(row["first"]) == float(beat[0]["old"]) and int(row["first_d"]) == 7, "S372 Day 1 vs today: the first Sunday's mark stays (day 7)")
	f["stats"]["speed"] = float(f["stats"]["speed"]) - 10.0
	_check(TestDay.record(f, 28).is_empty() and float(TestDay.wall(f)[1]["best"]) == float(beat[0]["new"]), "a slower week never lowers the best")


func _men() -> void:
	var raw: Dictionary = Data.PROSPECTS.filter(func(p): return str(p["id"]) == "danny")[0]
	var d := Data.fighter_state(raw.duplicate(true), 0)
	_check(TestDay.known("m") and str(d.get("sex", "")) == "m", "S372 J_TESTS3: a man takes the Sunday tests")
	d["stats"]["conditioning"] = 40.0
	d["stats"]["speed"] = 85.0
	var m := TestDay.measure(d)
	_check(is_equal_approx(float(m["engine"]), 9.0) and float(m["speed"]) == 57.0 and float(m["power"]) < 0.0,
		"men's norms: an untrained man's bleep 9.0, elite hands 57 in 10 s, no force test (%s)" % str(m))
	TestDay.record(d, 7)
	var ids: Array = TestDay.wall(d).map(func(r): return str(r["id"]))
	_check(ids == ["engine", "speed"], "his wall: the bleep test and hand speed, no force row (%s)" % str(ids))
