extends SceneTree
## S510 GuardBox: the free glove's top over the crown line is cut on a soft knee (never more than SOFT_M left over,
## nothing cut under the line, the cut grows smoothly with the excess).
## Run: <godot> --headless --audio-driver Dummy --fixed-fps 60 --path . --script res://tests/guard_box_test.gd

const GuardBox := preload("res://scripts/fight3d/GuardBox.gd")

var failures := 0


func _check(ok: bool, what: String) -> void:
	if not ok:
		failures += 1
	print(("PASS " if ok else "FAIL ") + what)


func _initialize() -> void:
	var s := GuardBox.SOFT_M
	_check(is_equal_approx(GuardBox.keep(-0.05, s), -0.05), "under the line nothing is cut")
	_check(is_equal_approx(GuardBox.keep(0.0, s), 0.0), "on the line nothing is cut")
	_check(GuardBox.keep(0.30, s) < s, "a glove 30 cm over the line keeps under SOFT_M (%.3f)" % GuardBox.keep(0.30, s))
	_check(GuardBox.keep(0.005, s) > 0.0045, "a glove just over the line is barely touched (%.4f of 0.005)" % GuardBox.keep(0.005, s))
	var last := 0.0
	var mono := true
	for i in 60:
		var v := GuardBox.keep(0.005 * i, s)
		mono = mono and v >= last - 1e-7
		last = v
	_check(mono, "what is kept never falls as the glove rises (no flip)")
	_check(GuardBox.TOP_M > 0.04 and GuardBox.TOP_M < 0.12, "the line sits about the brow (%.2f m over the head bone)" % GuardBox.TOP_M)
	# cap_up: a push up past the line goes out to the hand's own side instead
	var out := Vector3(1.0, 0.0, 0.0)
	_check(GuardBox.cap_up(Vector3(0.0, 0.05, 0.0), 1.30, 1.50, 1.0, out).is_equal_approx(Vector3(0.0, 0.05, 0.0)), "a push up with room under the line is left alone")
	var line := 1.50 + GuardBox.WRIST_UP_M
	var capped := GuardBox.cap_up(Vector3(0.0, 0.10, 0.02), line - 0.04, 1.50, 1.0, out)
	_check(is_equal_approx(capped.y, 0.04) and is_equal_approx(capped.x, 0.0) and is_equal_approx(capped.z, 0.02), "over the line the push goes up only to it, the rest is dropped (%s)" % str(capped))
	_check(capped.length() <= Vector3(0.0, 0.10, 0.02).length(), "a capped push is never longer than the push it came from (no runaway)")
	_check(GuardBox.cap_up(Vector3(0.0, -0.05, 0.0), 1.60, 1.50, 1.0, out).is_equal_approx(Vector3(0.0, -0.05, 0.0)), "a push down is never touched")
	print("GUARD_BOX failures=%d" % failures)
	quit(failures)
