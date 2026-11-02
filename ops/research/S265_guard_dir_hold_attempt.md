extends SceneTree
## S265 #1 - THE DIRECTION-HELD HAND-OVER: BUILT, MEASURED, REVERTED. **Do not re-try this blind.**
##
## The idea (Claude approved it): the remaining contract violations are the correction VECTOR SWINGING under the hand, not
## the ramp's speed - halving the return's rate moved the worst window's second difference only 157.0 -> 146.0
## (76df4f90). So a hand-over should keep the direction the correction started with and blend only its magnitude, which
## `hold_dir_target` below does exactly, preserving the hand->target distance so every rate cap above it is untouched. It
## passed all of these unit properties.
##
## MEASURED, seed 94301, tools/guard_pop_compare.gd, against the rate-capped build (76df4f90):
##     over_clip_punch    3 -> 5      (WORSE)
##     over_clip_ramp_strict 38 -> 44 (WORSE)
##     reversed           3 -> 4      (WORSE)
##     POP_ADDED worst  81.3 -> 119.9 mm  (worse than the red arm's own 118.4)
##     POP_LAG worst   204.8 -> 205.8 mm
##
## WHY it fails, and the lesson: the correction's swing is NOT an artifact to be suppressed - it is the layer KEEPING UP
## with a moving target. Freezing the direction stops the correction following the take, so the held line diverges from
## where the guard target actually is; when the hold releases, the layer has to cover the whole accumulated divergence at
## once. Suppressing the swing moves the problem to the hand-over's end and makes it bigger. The measured violations are
## therefore the price of a layer that is still tracking, and any fix has to reduce what it must track (the correction's
## SIZE) or accept the residue - not freeze the tracking.
##
## The unit tests are kept because they pin the geometry if anyone ever wants to hold a direction for another reason: they
## are properties of `hold_dir_target`, which is where the code lived (FightStagePlayer.gd, reverted).
## Prints DIR_HOLD failures=<n>.

const Player := preload("res://scripts/FightStagePlayer.gd")
const Switches := preload("res://scripts/GameSwitches.gd")

var failures := 0


func _check(ok: bool, label: String) -> void:
	if not ok:
		failures += 1
		print("FAIL ", label)


func _initialize() -> void:
	var hand := Vector3(0.0, 1.4, 0.0)
	var target := Vector3(0.30, 1.5, -0.10)
	var dir := (target - hand).normalized()
	var held: Vector3 = Player.hold_dir_target(hand, target, dir, true)
	## THE PROPERTY THAT MAKES IT SAFE: the correction's MAGNITUDE is untouched, so `hold`, the slew cap and every gain
	## above this function behave exactly as before - only the line the hand travels changed.
	_check(absf(held.distance_to(hand) - hand.distance_to(target)) < 1e-6,
		"the hand->target distance is preserved exactly (%.4f m)" % held.distance_to(hand))
	_check((held - hand).normalized().distance_to(dir.normalized()) < 1e-6, "and the direction is the held one")
	## The swing this exists to stop: the take moves the wrist so the RAW correction would aim 60 deg away, while the held
	## one still aims where the hand-over began - the hand no longer gets dragged around by the swing.
	var moved_hand := hand + Vector3(0.18, -0.06, 0.0)
	var live := target - moved_hand
	_check(live.normalized().distance_to(dir) > 0.5, "the live correction really would have swung (>%.1f deg)" % rad_to_deg(live.normalized().angle_to(dir)))
	var kept: Vector3 = Player.hold_dir_target(moved_hand, target, dir, true)
	_check((kept - moved_hand).normalized().distance_to(dir) < 1e-6, "the held one did not swing")
	_check(absf(kept.distance_to(moved_hand) - live.length()) < 1e-6, "and still hands over the same distance")
	## Outside a hand-over the target is the pass's own, which is what re-seeds the direction each time one starts.
	_check(Player.hold_dir_target(hand, target, dir, false).distance_to(target) < 1e-9, "inactive: the target is untouched")
	_check(Player.hold_dir_target(hand, target, Vector3.ZERO, true).distance_to(target) < 1e-9, "no seed yet: untouched")
	## A degenerate hand-over (the hand already on its target) stays put instead of manufacturing a direction.
	_check(Player.hold_dir_target(hand, hand, dir, true).distance_to(hand) < 1e-9, "a hand on its target stays on it")
	## The feature SHIPS ON, and the red arm exists.
	_check(Switches.GAME_ON.has("guard_hold_dir"), "guard_hold_dir is in GameSwitches.GAME_ON (a shipped feature is ON)")
	_check(Switches.GAME_ON.has("guard_ramp_clip"), "the rate cap it sits on top of is still on")
	print("DIR_HOLD failures=%d" % failures)
	quit(1 if failures > 0 else 0)