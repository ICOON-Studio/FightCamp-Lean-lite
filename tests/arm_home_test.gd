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
	# S510: the arm's own clock - out to the peak in OUT_S, home over RETURN_S real seconds, whatever the clip's hold.
	var pk := 0.30
	_check(is_equal_approx(ArmHome.arm_time_real(0.10, -1.0, c, pk, back), 0.10), "real: before the contact, the body's time")
	_check(is_equal_approx(ArmHome.arm_time_real(0.21, 0.0, c, pk, back), 0.21), "real: on the contact, no step")
	_check(is_equal_approx(ArmHome.arm_time_real(0.22, ArmHome.OUT_S, c, pk, back), pk), "real: at OUT_S the arm is at its peak")
	_check(is_equal_approx(ArmHome.arm_time_real(0.25, ArmHome.OUT_S + ArmHome.RETURN_S, c, pk, back), back),
		"real: OUT_S + RETURN_S after the contact the arm is home")
	_check(is_equal_approx(ArmHome.arm_time_real(0.70, 0.5, c, pk, back), 0.70), "real: past back-in-guard, the body's time")
	_check(is_equal_approx(ArmHome.arm_time_real(0.55, 0.01, c, pk, back), 0.55), "real: never behind the body")
	_check(is_equal_approx(ArmHome.arm_time_real(0.25, ArmHome.RETURN_S * 0.5, c, 0.10, back), (c + back) * 0.5),
		"real: no further point (a landed punch) goes straight home from the contact")
	var lr := -1.0
	var mono_r := true
	for i in 40:
		var r := 0.005 * i
		var ta := ArmHome.arm_time_real(c + 0.001 + r * 0.5, r, c, pk, back)
		mono_r = mono_r and ta >= lr - 1e-6
		lr = ta
	_check(mono_r, "real: the arm's time never runs backwards")
	# A cross at 1.5x recovery: home within 5 frames of 30 a second after the contact (critics: 3-4, never held over 2).
	var frames := 0
	var r2 := 0.0
	while ArmHome.arm_time_real(c + r2 * 1.5 + 1e-4, r2, c, pk, back) < back - 1e-4 and frames < 30:
		r2 += 1.0 / 30.0
		frames += 1
	_check(frames <= 6, "real: the arm is home %d frames (30 fps) after the contact (bar 6)" % frames)
	print("ARM_HOME failures=%d" % failures)
	quit(failures)
