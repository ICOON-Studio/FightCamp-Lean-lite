extends SceneTree
## LEAN_EASE (S499): the puncher's chest lean changes at most a step a frame, in and out (ReachLimit.ease_q).

const RL := preload("res://scripts/fight3d/ReachLimit.gd")
const PR := preload("res://scripts/fight3d/PunchReach.gd")

var failures := 0


func _check(cond: bool, label: String) -> void:
	print(("PASS " if cond else "FAIL ") + label)
	if not cond:
		failures += 1


func _lean(angle: float, axis := Vector3.RIGHT) -> Quaternion:
	return Quaternion(axis, angle)


func _initialize() -> void:
	var step: float = PR.LEAN_RATE / 30.0
	var none := Quaternion.IDENTITY
	# the contact frame: the whole lean is asked at once, the frame takes one step
	_check(absf(RL.ease_q(none, _lean(PR.LEAN_MAX), step).get_angle() - step) < 1e-4, "a whole lean asked at once takes one step")
	# it arrives in about a tenth of a second, never faster than the step, and stays
	var lean := none
	var frames := 0
	var worst := 0.0
	while lean.angle_to(_lean(PR.LEAN_MAX)) > 1e-4 and frames < 60:
		var nxt: Quaternion = RL.ease_q(lean, _lean(PR.LEAN_MAX), step)
		worst = maxf(worst, lean.angle_to(nxt))
		lean = nxt
		frames += 1
	_check(frames >= 3 and frames <= 4, "the full lean arrives in 3-4 frames at 30 fps (got %d)" % frames)
	_check(worst <= step + 1e-4, "no frame turns more than the step (worst %.4f, step %.4f)" % [worst, step])
	_check(RL.ease_q(lean, _lean(PR.LEAN_MAX), step).angle_to(_lean(PR.LEAN_MAX)) < 1e-4, "a held lean stays where it is")
	# a small lean (under the step) is not slowed
	_check(RL.ease_q(none, _lean(0.04), step).angle_to(_lean(0.04)) < 1e-4, "a small lean arrives whole")
	# the second solve of a frame is held to the same room: a step from LAST frame's lean, whatever the first solve did
	_check(absf(RL.ease_q(_lean(0.10), _lean(0.60), step).get_angle() - (0.10 + step)) < 1e-4, "two solves that ask 0.6 together still draw one step")
	# opposite asks do not add up: lean in 0.3, then the shoulder back 0.3 = no lean, drawn as one step back toward none
	_check(absf(RL.ease_q(_lean(0.25), _lean(0.3) * _lean(-0.3), step).get_angle() - (0.25 - step)) < 1e-4, "in then back out is no lean, not a double one")
	# the way out: nothing asked any more, the lean leaves a step a frame and ends at none
	_check(absf(RL.ease_q(_lean(0.30), none, step).get_angle() - (0.30 - step)) < 1e-4, "letting go takes one step back")
	_check(RL.ease_q(_lean(0.05), none, step).get_angle() < 1e-4, "the way out ends at none")
	# a lean about another axis is reached by the short way, a step at a time
	var side := RL.ease_q(_lean(0.2), _lean(0.2, Vector3.UP), step)
	_check(absf(_lean(0.2).angle_to(side) - step) < 1e-4, "a change of axis also moves one step")
	# the head's speed from the lean alone stays under the film ruler's jump (12 cm a frame) with a 0.75 m lever
	_check(step * 0.75 < 0.12, "head moves %.3f m a frame from the lean, under the 0.12 m jump" % (step * 0.75))
	print("LEAN_EASE failures=%d" % failures)
	quit(1 if failures > 0 else 0)
