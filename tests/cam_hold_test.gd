extends SceneTree
## CAMHOLD1: the camera never cuts while a punch is in flight. Pure module (CamHold.gd), headless.
##  1. may_cut truth table: each reason x punching.
##  2. punching: before contact / inside the 0.35 s / after it / no contact / empty clip.
##  3. boxer_punching({}) false.
## Prints CAM_HOLD failures=<n>.

const CamHold := preload("res://scripts/fight3d/CamHold.gd")

var failures := 0


func _initialize() -> void:
	_may_cut_table()
	_punching_window()
	_boxer_punching_empty()
	print("CAM_HOLD failures=%d" % failures)
	quit(0 if failures == 0 else 1)


func _check(label: String, got: bool, want: bool) -> void:
	if got != want:
		print("FAIL: %s got=%s want=%s" % [label, str(got), str(want)])
		failures += 1
	else:
		print("PASS: %s" % label)


## 1. The truth table of may_cut: each reason x punching.
func _may_cut_table() -> void:
	# "start", "jump", "emergency" always true (a blocked lens must still be left at once).
	_check("may_cut(start, false)", CamHold.may_cut("start", false), true)
	_check("may_cut(start, true)", CamHold.may_cut("start", true), true)
	_check("may_cut(jump, false)", CamHold.may_cut("jump", false), true)
	_check("may_cut(jump, true)", CamHold.may_cut("jump", true), true)
	_check("may_cut(emergency, false)", CamHold.may_cut("emergency", false), true)
	_check("may_cut(emergency, true)", CamHold.may_cut("emergency", true), true)
	# Every other reason: true only when not punching.
	_check("may_cut(hidden, false)", CamHold.may_cut("hidden", false), true)
	_check("may_cut(hidden, true)", CamHold.may_cut("hidden", true), false)
	_check("may_cut(behind, false)", CamHold.may_cut("behind", false), true)
	_check("may_cut(behind, true)", CamHold.may_cut("behind", true), false)
	_check("may_cut(close, false)", CamHold.may_cut("close", false), true)
	_check("may_cut(close, true)", CamHold.may_cut("close", true), false)
	_check("may_cut(frame, false)", CamHold.may_cut("frame", false), true)
	_check("may_cut(frame, true)", CamHold.may_cut("frame", true), false)
	_check("may_cut(clinch, false)", CamHold.may_cut("clinch", false), true)
	_check("may_cut(clinch, true)", CamHold.may_cut("clinch", true), false)
	_check("may_cut(hold, false)", CamHold.may_cut("hold", false), true)
	_check("may_cut(hold, true)", CamHold.may_cut("hold", true), false)


## 2. punching: before contact / inside the 0.35 s / after it / no contact / empty clip.
func _punching_window() -> void:
	var contact_s := 0.5  # the glove lands at 0.5 s
	# Before contact: still punching.
	_check("punching(before contact)", CamHold.punching("jab", 0.3, contact_s), true)
	# Inside the 0.35 s after contact: still punching (the head's answer).
	_check("punching(inside after_hit)", CamHold.punching("jab", 0.5 + 0.2, contact_s), true)
	# After the 0.35 s: not punching.
	_check("punching(after after_hit)", CamHold.punching("jab", 0.5 + 0.4, contact_s), false)
	# No contact (contact_s < 0): not punching.
	_check("punching(no contact)", CamHold.punching("jab", 0.3, -1.0), false)
	# Empty clip: not punching.
	_check("punching(empty clip)", CamHold.punching("", 0.3, contact_s), false)


## 3. boxer_punching({}) false.
func _boxer_punching_empty() -> void:
	_check("boxer_punching({})", CamHold.boxer_punching({}), false)
