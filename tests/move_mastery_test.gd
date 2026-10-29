extends SceneTree
## MoveMastery (copied from E:/FightCamp/Game/Godot/tests/move_mastery_test.gd, FIGHTLINK2, trimmed with the module):
##   1. the five tiers land on their exact boundaries, 2. the cap is the r115 clamp, 3. drilling pays the r115 rate,
##   4. an undrilled week costs 0.75 with the 30/0 floors, 5. describe() gives the gym wording.
## The fight-multiplier and fight_note checks went with those functions (they return with the 3D fight).

const MM := preload("res://scripts/rules/MoveMastery.gd")

var failures := 0


func _initialize() -> void:
	_check_tiers()
	_check_cap()
	_check_gain()
	_check_decay()
	_check_words()
	print("MOVE_MASTERY failures=%d" % failures)
	quit(0 if failures == 0 else 1)


func _check_tiers() -> void:
	_check(MM.tier(0.0) == "UNLEARNED", "tier 0 -> UNLEARNED (m <= 0)")
	_check(MM.tier(1.0) == "RAW", "tier 1 -> RAW")
	_check(MM.tier(29.9) == "RAW", "tier 29.9 -> RAW (<30)")
	_check(MM.tier(30.0) == "USABLE", "tier 30 -> USABLE")
	_check(MM.tier(59.9) == "USABLE", "tier 59.9 -> USABLE (<60)")
	_check(MM.tier(60.0) == "SHARP", "tier 60 -> SHARP")
	_check(MM.tier(84.9) == "SHARP", "tier 84.9 -> SHARP (<85)")
	_check(MM.tier(85.0) == "SIGNATURE", "tier 85 -> SIGNATURE")
	_check(MM.tier(100.0) == "SIGNATURE", "tier 100 -> SIGNATURE")


func _check_cap() -> void:
	_check(absf(MM.cap(50.0, 60.0) - 72.0) < 0.0001, "cap tech 50 iq 60 -> 72.0 (%.4f)" % MM.cap(50.0, 60.0))
	_check(MM.cap(0.0, 0.0) == 50.0, "cap clamps at 50: tech 0 iq 0 raw 40 -> 50 (%.4f)" % MM.cap(0.0, 0.0))
	_check(MM.cap(100.0, 100.0) == 100.0, "cap clamps at 100: tech 100 iq 100 -> 100 (%.4f)" % MM.cap(100.0, 100.0))
	_check(MM.cap(150.0, 100.0) == 100.0, "cap never passes 100 (%.4f)" % MM.cap(150.0, 100.0))


func _check_gain() -> void:
	var base: float = MM.gain(0.0, "pads", 60.0, 0.0, 2, 1.0, 100.0)
	_check(absf(base - 2.1) <= 0.01, "60 min pads, tier 2, coach 0, efficiency 1, m 0 -> 2.1 (+-0.01, got %.4f)" % base)
	_check(absf(MM.gain(0.0, "pads", 60.0, 100.0, 2, 1.0, 100.0) - 2.94) <= 0.01, "coach 100 pays x1.40 -> 2.94 (got %.4f)" % MM.gain(0.0, "pads", 60.0, 100.0, 2, 1.0, 100.0))
	var tier4: float = MM.gain(0.0, "pads", 60.0, 0.0, 4, 1.0, 100.0)
	_check(absf(tier4 - 2.0 * base) <= 0.01, "station tier 4 doubles the gain (%.4f = 2 x %.4f)" % [tier4, base])
	var half: float = MM.gain(0.0, "pads", 60.0, 0.0, 2, 0.5, 100.0)
	_check(absf(half - 0.5 * base) <= 0.01, "efficiency 0.5 halves the gain (%.4f)" % half)
	var capped: float = MM.gain(95.0, "pads", 600.0, 100.0, 4, 1.0, 100.0)
	_check(capped <= 100.0 and capped >= 95.0, "a ten-hour signature session never passes the cap (%.4f)" % capped)
	var low_cap: float = MM.gain(60.0, "pads", 600.0, 100.0, 4, 1.0, 72.0)
	_check(low_cap <= 72.0 and low_cap >= 60.0, "a ten-hour session never passes the tech 50 / iq 60 cap of 72 (%.4f)" % low_cap)
	var flat: float = MM.gain(42.0, "heavy_bag", 240.0, 100.0, 4, 0.0, 100.0)
	_check(flat == 42.0, "efficiency 0 gains nothing and never decreases mastery (%.4f)" % flat)
	_check(MM.gain(33.0, "yoga", 60.0, 100.0, 4, 1.0, 100.0) == 33.0, "an unknown station leaves mastery unchanged")
	var tiny: float = MM.gain(0.0, "shadowbox", 1.0, 0.0, 1, 0.01, 100.0)
	_check(tiny >= 1.0, "an UNLEARNED move drilled for any positive gain starts at least at 1.0 (%.6f)" % tiny)
	var never_less := true
	for m in [0.0, 10.0, 29.9, 45.0, 60.0, 84.9, 99.0]:
		var g: float = MM.gain(float(m), "ring_sparring", 90.0, 50.0, 3, 1.0, MM.cap(50.0, 50.0))
		if g < float(m) - 0.0001:
			never_less = false
	_check(never_less, "gain never decreases mastery across a sweep of m (even past the cap)")


func _check_decay() -> void:
	_check(absf(MM.decay_week(50.0, false) - 49.25) < 0.0001, "a week off: 50 -> 49.25 (%.4f)" % MM.decay_week(50.0, false))
	_check(MM.decay_week(30.5, false) == 30.0, "a week off floors at 30 when m was >= 30 (30.5 -> 30.0)")
	_check(MM.decay_week(30.0, false) == 30.0, "the 30 floor holds at exactly 30")
	_check(absf(MM.decay_week(20.0, false) - 19.25) < 0.0001, "a week off below the floor: 20 -> 19.25 (%.4f)" % MM.decay_week(20.0, false))
	_check(MM.decay_week(0.2, false) == 0.0, "decay never passes 0 (0.2 -> 0.0)")
	_check(MM.decay_week(37.0, true) == 37.0 and MM.decay_week(0.0, true) == 0.0, "a drilled week leaves mastery untouched")


func _check_words() -> void:
	# The brief's prose examples pair "Sharp" with M88, but its normative tier spec - API
	# boundaries (SHARP <85, SIGNATURE >=85, probed at 84.9/85) and Ludo r115's table -
	# puts 88 in SIGNATURE. The exact example lines are asserted with the tier word the
	# spec assigns to that mastery, at both tiers, so no check is weakened.
	_check(MM.describe("Jab", 88.0) == "Signature Jab (M88)", "the brief's example at its spec tier: describe 88 -> \"Signature Jab (M88)\"")
	_check(MM.describe("Jab", 78.0) == "Sharp Jab (M78)", "the brief's wording at a SHARP mastery: describe 78 -> \"Sharp Jab (M78)\"")
	_check(MM.describe("Rear Uppercut", 18.0) == "Raw Rear Uppercut (M18)", "describe 18 -> \"Raw Rear Uppercut (M18)\"")
	_check(MM.describe("Cross", 87.6) == "Signature Cross (M88)", "mastery is rounded (87.6 -> M88)")
	_check(MM.describe("Hook", 45.0) == "Usable Hook (M45)", "the tier word is Title case (Usable)")
	_check(MM.describe("Jab", 0.0) == "Unlearned Jab (M0)", "Unlearned is Title case too")
	_check(MM.describe("Overhand", 92.4) == "Signature Overhand (M92)", "Signature is Title case (92.4 -> M92)")


func _check(condition: bool, label: String) -> void:
	if condition:
		print("OK  " + label)
	else:
		failures += 1
		print("FAIL " + label)
