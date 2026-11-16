extends SceneTree
## S497 ArmHome: the punching arm's clip time runs ahead of the body after the contact (pure rule).
## Run: <godot> --headless --audio-driver Dummy --path . --script res://tests/arm_home_test.gd

const ArmHome := preload("res://scripts/fight3d/ArmHome.gd")

var failures := 0


func _check(ok: bool, what: String) -> void:
	if not ok:
		failures += 1
	print(("PASS " if ok else "FAIL ") + what)


func _initialize() -> void:
	var c := 0.20
	var back := 0.60
	_check(is_equal_approx(ArmHome.arm_time(0.10, c, back, 1.8), 0.10), "before the contact the arm is on the body's time")
	_check(is_equal_approx(ArmHome.arm_time(c, c, back, 1.8), c), "on the contact the arm is on the body's time (no step)")
	_check(is_equal_approx(ArmHome.arm_time(0.30, c, back, 1.8), 0.38), "0.10 s past the contact the arm is 0.18 s past it")
	_check(is_equal_approx(ArmHome.arm_time(0.50, c, back, 1.8), back), "the arm never passes the clip's back-in-guard time")
	_check(is_equal_approx(ArmHome.arm_time(0.70, c, back, 1.8), 0.70), "past back-in-guard the arm is on the body's time again")
	_check(is_equal_approx(ArmHome.arm_time(0.30, c, 0.10, 1.8), 0.30), "a clip with no way back measured is left alone")
	var last := -1.0
	var mono := true
	var step_max := 0.0
	for i in 61:
		var t := 0.01 * i
		var ta := ArmHome.arm_time(t, c, back, 1.8)
		mono = mono and ta >= last - 1e-6 and ta >= t - 1e-6
		step_max = maxf(step_max, ta - last if last >= 0.0 else 0.0)
		last = ta
	_check(mono, "the arm's time never runs backwards and is never behind the body")
	_check(step_max <= 0.01 * 1.8 + 1e-6, "the arm's time never jumps: at most AHEAD times the body's step (%.4f s)" % step_max)
	print("ARM_HOME failures=%d" % failures)
	quit(failures)
