extends SceneTree
## S496 TRAININGK1: the coach's 75 pad minutes shared between the boxers on pads that night (CoachNights), and the week's
## drilling reading it (DrillWeek.inputs -> nights.per). Population: ids "a", "b", "c" (rule part); the walk-in alone and the
## TEST CLUB's three boxers (wiring part).

const CN := preload("res://scripts/rules/CoachNights.gd")
const PadWeek := preload("res://scripts/rules/PadWeek.gd")
const DrillWeek := preload("res://scripts/state/DrillWeek.gd")
const TestClub := preload("res://scripts/state/TestClub.gd")

var _fails := 0


func _initialize() -> void:
	var one := CN.split(["a"])
	_check(is_equal_approx(float(one["a"]), 75.0), "alone on the pads: the whole 75 (%s)" % str(one))
	var two := CN.split(["a", "b"])
	_check(is_equal_approx(float(two["a"]) + float(two["b"]), 75.0) and is_equal_approx(float(two["a"]), 37.5), "two: an even split (%s)" % str(two))
	var set := CN.split(["a", "b", "c"], {"a": 45.0})
	_check(is_equal_approx(float(set["a"]), 45.0) and is_equal_approx(float(set["b"]), 15.0), "one fixed at 45: the other two share 30 (%s)" % str(set))
	var greedy := CN.split(["a", "b", "c"], {"a": 90.0})
	_check(float(greedy["b"]) >= CN.MIN_SHARE and _sum(greedy) <= 75.01, "a share past the night gives way (%s)" % str(greedy))
	var d := CN.drag(["a", "b"], {}, 0, 63.0)
	_check(is_equal_approx(float(d["a"]), 65.0) and is_equal_approx(float(d["b"]), 10.0), "the line dragged to 63 snaps to 65 / 10 (%s)" % str(d))
	var far := CN.drag(["a", "b"], {}, 0, 200.0)
	_check(is_equal_approx(float(far["b"]), CN.MIN_SHARE), "dragged past the end: the other keeps %d (%s)" % [int(CN.MIN_SHARE), str(far)])
	var mid := CN.drag(["a", "b", "c"], {}, 1, 50.0)
	_check(is_equal_approx(float(mid["a"]), 25.0) and is_equal_approx(float(mid["b"]), 25.0) and is_equal_approx(float(mid["c"]), 25.0),
		"the second line at 50: only b and c change (%s)" % str(mid))
	_check(is_equal_approx(CN.factor(75.0), 1.0) and is_equal_approx(CN.factor(37.5), 0.5) and is_equal_approx(CN.factor(150.0), 1.0),
		"factor: a full night 1.0, half 0.5, never past one night")
	_check(is_equal_approx(_sum(CN.split(["a", "b"], {}, 2)), 150.0), "two coaches: 150 a night")
	_wired()
	print("COACH_NIGHTS failures=%d" % _fails)
	quit(1 if _fails > 0 else 0)


## The walk-in alone keeps whole nights; three boxers on Monday's pads drill a third each, as the screen shows.
func _wired() -> void:
	var c := Career.quick_start("Anvil Street Gym", "London")
	TestClub.make(c)
	var boxers: Array = c.fighters
	_check(boxers.size() >= 3, "the test club has three boxers (%d)" % boxers.size())
	var f: Dictionary = boxers[0]
	var inp := DrillWeek.inputs(c, f)
	var pads: Array = (inp["nights"] as Dictionary).get("pads", [])
	_check(not pads.is_empty(), "the first boxer has pad nights %s" % str(pads))
	if pads.is_empty():
		return
	var d0 := int(pads[0])
	var on := 0
	for g in boxers:
		if (PadWeek.nights_of(g).get("pads", []) as Array).has(d0):
			on += 1
	var mins := PadWeek.night_minutes(inp["nights"], d0)
	var want := PadWeek.PAD_NIGHT_MINUTES * CN.factor(CN.NIGHT_MIN / float(on))
	_check(absf(mins - want) < 0.5, "%d boxers on night %d: each drills %.0f of %.0f (want %.0f)" % [on, d0, mins, PadWeek.PAD_NIGHT_MINUTES, want])
	f["coach_min"] = {str(d0): 65.0}
	var mins2 := PadWeek.night_minutes(DrillWeek.inputs(c, f)["nights"], d0)
	_check(mins2 > mins + 1.0, "the line dragged her way: more drilling (%.0f -> %.0f)" % [mins, mins2])
	var solo := Career.quick_start("Anvil Street Gym", "London")
	load("res://scripts/state/Sim.gd").sign(solo, TestClub.PICKS.duplicate())
	_check(solo.fighters.size() == 1, "the walk-in signed alone")
	if solo.fighters.is_empty():
		return
	var s: Dictionary = solo.fighters[0]
	var sp: Array = PadWeek.nights_of(s).get("pads", [])
	if not sp.is_empty():
		_check(is_equal_approx(PadWeek.night_minutes(DrillWeek.inputs(solo, s)["nights"], int(sp[0])), PadWeek.PAD_NIGHT_MINUTES), "one boxer: a whole night")


func _sum(d: Dictionary) -> float:
	var t := 0.0
	for k in d:
		t += float(d[k])
	return t


func _check(ok: bool, what: String) -> void:
	if ok:
		print("  ok   " + what)
	else:
		_fails += 1
		print("  FAIL " + what)
