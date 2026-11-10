extends RefCounted
## FIRELEVEL1: a planned line fires more reliably the better it is drilled.
## Pure static. The bout key `fire_level` ({"usable": 0.6, "sharp": 0.8, "signature": 1.0})
## sets the share of uses on which a planned line counts as planned, by its mastery tier:
##   - under 30: cannot be planned (share 0.0)
##   - 30 to 59: usable (share = fire_level.usable, default 1.0)
##   - 60 to 84: sharp (share = fire_level.sharp, default 1.0)
##   - 85+: signature (share = fire_level.signature, default 1.0)
## Absent key = 1.0 at every mastery, under 30 too = today's game. A line that does not fire falls back to
## what the bout does today with no planned answer at that moment.

const StrikeMap := preload("res://scripts/rules/StrikeMap.gd")

## The mastery tiers and their default shares (1.0 = always fires = today's behavior).
const USABLE_AT := 30.0
const SHARP_AT := 60.0
const SIGNATURE_AT := 85.0


## The share of uses on which a planned line counts as planned, by its mastery tier.
## level_shares = {"usable": 0.6, "sharp": 0.8, "signature": 1.0} (or any subset; missing = 1.0).
## mastery = the move's mastery (combo mastery for combos, 100.0 for steps/defences).
static func share(level_shares: Dictionary, mastery: float) -> float:
	# S427: no key = today's game at EVERY mastery. Today a combination is planned once its punches are learned
	# (PlanFight.can_do), drilled or not, so an undrilled one (combo mastery 0) must still fire.
	if level_shares.is_empty():
		return 1.0
	if mastery < USABLE_AT:
		return 0.0
	if mastery < SHARP_AT:
		return float(level_shares.get("usable", 1.0))
	if mastery < SIGNATURE_AT:
		return float(level_shares.get("sharp", 1.0))
	return float(level_shares.get("signature", 1.0))


## Whether the planned line fires on this use. roll = the bout's own seeded dice (0..1).
## Returns true if roll < share(level_shares, mastery).
static func fires(level_shares: Dictionary, mastery: float, roll: float) -> bool:
	return roll < share(level_shares, mastery)


## The mastery for an arrow: combo mastery for combos, 100.0 for steps/defences.
static func mastery_of(f: Dictionary, arrow: String) -> float:
	var row := StrikeMap.move(arrow)
	if str(row.get("kind", "")) != "combo":
		return 100.0
	return float((f.get("combos", {}) as Dictionary).get(str(row.get("combo", "")), 0.0))
