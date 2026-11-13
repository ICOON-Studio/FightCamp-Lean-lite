extends SceneTree
## STEPMASTERY1A: pure rules for the 10 step/defence mastery bars.
## At least one case per function; expected values from the brief, not from the code.

const SM := preload("res://scripts/rules/StepMastery.gd")

var failures := 0


func _initialize() -> void:
	_check_start_values()
	_check_from_old_save()
	_check_drillable()
	_check_shadow_gain()
	_check_nights_to_usable()
	_check_grey_reason()
	_check_fire_mastery()
	print("STEP_MASTERY failures=%d" % failures)
	quit(0 if failures == 0 else 1)


func _check_start_values() -> void:
	var sv40: Dictionary = SM.start_values(40.0)
	_check(absf(float(sv40["step_in"]) - 30.0) < 0.0001, "start_values footwork 40 -> step_in 30.0 (floor) (got %.4f)" % float(sv40["step_in"]))
	_check(absf(float(sv40["step_out"]) - 30.0) < 0.0001, "start_values footwork 40 -> step_out 30.0 (floor)")
	_check(float(sv40["step_back"]) == 0.0, "start_values footwork 40 -> step_back 0.0")
	_check(float(sv40["pivot_out"]) == 0.0, "start_values footwork 40 -> pivot_out 0.0")
	var sv80: Dictionary = SM.start_values(80.0)
	_check(absf(float(sv80["step_in"]) - 44.0) < 0.0001, "start_values footwork 80 -> step_in 44.0 (got %.4f)" % float(sv80["step_in"]))
	_check(absf(float(sv80["step_out"]) - 44.0) < 0.0001, "start_values footwork 80 -> step_out 44.0")
	_check(sv40.size() == 10, "start_values has all 10 NODES ids (got %d)" % sv40.size())


func _check_from_old_save() -> void:
	var bars: Dictionary = SM.from_old_save(["step_in", "tie_up@own_ropes"])
	_check(float(bars["step_in"]) == 60.0, "from_old_save step_in in plan -> 60.0 (got %.4f)" % float(bars["step_in"]))
	_check(float(bars["tie_up"]) == 60.0, "from_old_save tie_up@own_ropes strips suffix -> tie_up 60.0 (got %.4f)" % float(bars["tie_up"]))
	_check(float(bars["pivot_out"]) == 30.0, "from_old_save pivot_out not in plan -> 30.0 (got %.4f)" % float(bars["pivot_out"]))
	_check(float(bars["step_out"]) == 30.0, "from_old_save step_out not in plan -> 30.0")
	_check(bars.size() == 10, "from_old_save has all 10 NODES ids (got %d)" % bars.size())


func _check_drillable() -> void:
	_check(SM.drillable("pivot_out", 0.0, "pivot_out") == true, "drillable pivot_out at 0 when it IS the slot -> true")
	_check(SM.drillable("pivot_out", 0.0, "step_in") == false, "drillable pivot_out at 0 when slot is step_in -> false")
	_check(SM.drillable("pivot_out", 30.0, "step_in") == true, "drillable pivot_out at 30 even when slot is step_in -> true")
	_check(SM.drillable("step_in", 29.0, "step_in") == true, "drillable step_in at 29 when it IS the slot -> true")
	_check(SM.drillable("step_in", 29.0, "pivot_out") == false, "drillable step_in at 29 when slot is pivot_out -> false")


func _check_shadow_gain() -> void:
	var g: float = SM.shadow_gain(0.0, 1.0, 0.0, 100.0)
	_check(g >= 1.0, "shadow_gain m=0 1hr coach=0 cap=100 -> at least 1.0 (UNLEARNED floor) (got %.4f)" % g)
	_check(g <= 2.0, "shadow_gain m=0 1hr coach=0 cap=100 -> at most 2.0 (got %.4f)" % g)
	var g2: float = SM.shadow_gain(50.0, 1.0, 0.0, 100.0)
	_check(g2 > 50.0 and g2 < 51.0, "shadow_gain m=50 1hr coach=0 cap=100 -> small gain (got %.4f)" % g2)


func _check_nights_to_usable() -> void:
	_check(SM.nights_to_usable(29.5, 1.0) == 1, "nights_to_usable 29.5 / gain 1 -> 1 (got %d)" % SM.nights_to_usable(29.5, 1.0))
	_check(SM.nights_to_usable(30.0, 1.0) == 0, "nights_to_usable 30+ -> 0 (got %d)" % SM.nights_to_usable(30.0, 1.0))
	_check(SM.nights_to_usable(12.0, 6.0) == 3, "nights_to_usable 12 / gain 6 -> 3 (got %d)" % SM.nights_to_usable(12.0, 6.0))
	_check(SM.nights_to_usable(10.0, 0.0) == -1, "nights_to_usable gain 0 -> -1 (got %d)" % SM.nights_to_usable(10.0, 0.0))
	_check(SM.nights_to_usable(10.0, -1.0) == -1, "nights_to_usable gain negative -> -1 (got %d)" % SM.nights_to_usable(10.0, -1.0))


func _check_grey_reason() -> void:
	_check(SM.grey_reason("pivot_out", 12.0, 6.0) == "Pivot off the ropes: learning, 3 pad nights", "grey_reason pivot_out 12 gain 6 -> 'Pivot off the ropes: learning, 3 pad nights' (got '%s')" % SM.grey_reason("pivot_out", 12.0, 6.0))
	_check(SM.grey_reason("step_in", 35.0, 6.0) == "", "grey_reason at 30+ -> empty (got '%s')" % SM.grey_reason("step_in", 35.0, 6.0))
	_check(SM.grey_reason("tie_up", 20.0, 0.0) == "Tie up: learning, needs pad nights", "grey_reason gain 0 -> needs pad nights (got '%s')" % SM.grey_reason("tie_up", 20.0, 0.0))
	_check(SM.grey_reason("roll_out", 29.0, 1.0) == "Roll under and out: learning, 1 pad night", "grey_reason 1 night singular (got '%s')" % SM.grey_reason("roll_out", 29.0, 1.0))


func _check_fire_mastery() -> void:
	_check(SM.fire_mastery({}, "herd") == 100.0, "fire_mastery empty bars -> 100.0 (got %.4f)" % SM.fire_mastery({}, "herd"))
	_check(SM.fire_mastery({"step_in": 45.0}, "step_in") == 45.0, "fire_mastery bars has step_in -> 45.0 (got %.4f)" % SM.fire_mastery({"step_in": 45.0}, "step_in"))
	_check(SM.fire_mastery({"tie_up": 55.0}, "tie_up@own_ropes") == 55.0, "fire_mastery strips @ suffix (got %.4f)" % SM.fire_mastery({"tie_up": 55.0}, "tie_up@own_ropes"))


func _check(condition: bool, label: String) -> void:
	if condition:
		print("PASS " + label)
	else:
		failures += 1
		print("FAIL " + label)
