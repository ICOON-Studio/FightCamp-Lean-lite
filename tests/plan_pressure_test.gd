extends SceneTree
## S397 rank 3 lever 2 (PlanPressure): right answers that land build pressure that cuts the opponent's landed punches and
## lasts past the bell (eased); wrong answers punished shrink our tank's ceiling for the rest of the bout, never under FLOOR;
## no plan touches neither. The Why line says both. Prints PLAN_PRESSURE checks=<n> failures=<n>.

const PlanPressure := preload("res://scripts/rules/PlanPressure.gd")
const FightWhy := preload("res://scripts/rules/FightWhy.gd")

var checks := 0
var failures := 0


func _initialize() -> void:
	var fb := {}
	PlanPressure.new_round(fb, 1)
	_check(is_equal_approx(PlanPressure.edge(fb), 0.0) and is_equal_approx(PlanPressure.ceiling(fb), PlanPressure.TANK), "a bout opens clean")
	var lv := {"cost": 0.0}
	var r := PlanPressure.after(fb, lv, {"won": true, "landed": [5, 2]}, "best", true)
	_check(float(fb["pressure"]) > 0.0 and int(r["cut"]) == 0, "a right answer that lands builds pressure (none to cut yet)")
	for i in 4:
		PlanPressure.after(fb, lv, {"won": true, "landed": [5, 2]}, "best", true)
	var s := {"won": false, "landed": [3, 6]}
	r = PlanPressure.after(fb, lv, s, "none", true)
	_check(int(s["landed"][1]) < 6 and int(r["cut"]) == 6 - int(s["landed"][1]), "pressure cuts her landed punches")
	var p := float(fb["pressure"])
	PlanPressure.new_round(fb, 2)
	_check(float(fb["pressure"]) > 0.0 and float(fb["pressure"]) < p, "pressure lasts past the bell, eased")
	var cost := float(lv["cost"])
	r = PlanPressure.after(fb, lv, {"won": false, "landed": [2, 5]}, "wrong", true)
	_check(int(r["clean"]) > 0 and PlanPressure.ceiling(fb) < PlanPressure.TANK and float(lv["cost"]) > cost, "a wrong answer punished costs the tank now")
	for i in 40:
		PlanPressure.after(fb, lv, {"won": false, "landed": [1, 6]}, "wrong", true)
	_check(is_equal_approx(PlanPressure.ceiling(fb), PlanPressure.FLOOR), "the ceiling stops at the floor")
	var none := {}
	PlanPressure.new_round(none, 1)
	var lv2 := {"cost": 0.0}
	PlanPressure.after(none, lv2, {"won": true, "landed": [5, 2]}, "best", false)
	PlanPressure.after(none, lv2, {"won": false, "landed": [2, 5]}, "wrong", false)
	_check(is_equal_approx(float(none["pressure"]), 0.0) and is_equal_approx(PlanPressure.ceiling(none), PlanPressure.TANK) and is_equal_approx(float(lv2["cost"]), 0.0),
		"no plan touches neither")
	var x := {"won": false, "landed": [2, 4], "planned": true, "arrow": "1-6-3", "arrow_fit": "wrong", "psit": "loadup", "plan_edge": -8.0,
		"pressure": {"pressure": 0.4, "cut": 2, "clean": 4, "tank": 6.0}}
	var w := FightWhy.read([{"won": false, "exchanges": [x]}], "Lucy", "Maria")
	_check(str(w["plan"]).contains("took 2 landed punches off Maria") and str(w["against"]).contains("cost Lucy 6 of the tank"), "the Why says what lasted")
	print("PLAN_PRESSURE checks=%d failures=%d" % [checks, failures])
	quit(1 if failures > 0 else 0)


func _check(ok: bool, what: String) -> void:
	checks += 1
	if not ok:
		failures += 1
		print("FAIL ", what)
