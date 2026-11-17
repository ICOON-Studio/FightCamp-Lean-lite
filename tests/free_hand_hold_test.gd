extends SceneTree
## S506 FREEHAND: GuardTuck.free_of picks the hand that is NOT punching (the one GuardTuck holds at the chin while the
## other throws). Orthodox and southpaw (mirrored clips), the measured contact row's hand, captured rk_ takes, and the
## clips that are no punch (reactions, dodges, the guard) hold nothing.

const GuardTuck := preload("res://scripts/fight3d/GuardTuck.gd")

var failures := 0


func _check(got: String, want: String, what: String) -> void:
	if got != want:
		failures += 1
		print("FREE_HAND_HOLD FAIL %s: got '%s' want '%s'" % [what, got, want])


func _init() -> void:
	# Orthodox: the lead is the left.
	_check(GuardTuck.free_of("pro_left_jab", "LeftHand"), "RightHand", "orthodox jab")
	_check(GuardTuck.free_of("pro_right_cross_hard", "LeftHand"), "LeftHand", "orthodox cross")
	_check(GuardTuck.free_of("pro_left_hook_v2", "LeftHand"), "RightHand", "orthodox lead hook")
	_check(GuardTuck.free_of("pro_right_uppercut", "LeftHand"), "LeftHand", "orthodox rear uppercut")
	_check(GuardTuck.free_of("pro_body_shot", "LeftHand"), "LeftHand", "body shot (contact row: RightHand)")
	_check(GuardTuck.free_of("rk_jab", "LeftHand"), "RightHand", "captured jab")
	_check(GuardTuck.free_of("rk_cross", "LeftHand"), "LeftHand", "captured cross")
	# Southpaw: her clips are mirrored, the lead is the right.
	_check(GuardTuck.free_of("pro_left_jab", "RightHand"), "LeftHand", "southpaw jab")
	_check(GuardTuck.free_of("pro_right_cross", "RightHand"), "RightHand", "southpaw cross")
	# No punch: nothing held.
	for clip in ["pro_idle", "pro_hit_by_jab", "pro_dodge_left", "pro_weave", "advance", ""]:
		_check(GuardTuck.free_of(clip, "LeftHand"), "", "no punch " + clip)
	print("FREE_HAND_HOLD_TEST failures=%d" % failures)
	quit(1 if failures > 0 else 0)
