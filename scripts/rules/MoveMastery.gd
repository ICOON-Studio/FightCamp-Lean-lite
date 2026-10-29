extends RefCounted
## Per-move mastery (copied from E:/FightCamp/Game/Godot/scripts/rules/MoveMastery.gd, FIGHTLINK2 / Ludo r115 Part 1,
## stripped for the lean restart). Pure static math: no class_name, no preload, no RNG, no state.
## Kept: the five tiers, the cap from technique and ring IQ, drilling gain, weekly decay, the gym's wording.
## Dropped: the performance multipliers and fight_note (they serve the 3D fight engine, which comes back in week 5+).

## Mastery points gained per hour of drilling, by training station (Ludo r115 Part 1).
const GAIN_PER_HOUR := {"pads": 2.1, "heavy_bag": 1.05, "shadowbox": 0.85, "ring_sparring": 1.5, "speed_bag": 0.9, "double_end": 1.2}


## How far the move has come: UNLEARNED (never drilled), RAW (<30), USABLE (<60),
## SHARP (<85), SIGNATURE (>=85) - Ludo r115 Part 1's five tiers.
static func tier(m: float) -> String:
	if m <= 0.0:
		return "UNLEARNED"
	if m < 30.0:
		return "RAW"
	if m < 60.0:
		return "USABLE"
	if m < 85.0:
		return "SHARP"
	return "SIGNATURE"


## The mastery ceiling for a punch thrown by this fighter (Ludo r115 Part 1):
## a TECH 50 / IQ 60 athlete caps any punch at 72.0 - no Signature check-hook
## without raising the foundations first.
static func cap(technique: float, ring_iq: float) -> float:
	return clampf(40.0 + 0.4 * technique + 0.2 * ring_iq, 50.0, 100.0)


## Drills the move for `minutes` at `station` and returns the NEW mastery:
## rate * minutes/60 * station_tier/2 * coach x1.40 * room-left * efficiency.
## Unknown station -> no gain. The result never passes the cap and never drops
## below the mastery that walked in; an UNLEARNED move (m = 0) drilled for any
## positive gain starts at least at 1.0 (Ludo r115 tier table: M = 1 unlocks RAW).
static func gain(m: float, station: String, minutes: float, coach_skill: float, station_tier: int, efficiency: float, cap_value: float) -> float:
	var rate: float = float(GAIN_PER_HOUR.get(station, 0.0))
	if rate <= 0.0:
		return m
	var dm: float = rate * (minutes / 60.0) * (float(station_tier) / 2.0) * (1.0 + 0.40 * coach_skill / 100.0) * maxf(0.0, 1.0 - m / cap_value) * clampf(efficiency, 0.0, 1.0)
	var new_m: float = m + dm
	if m <= 0.0 and dm > 0.0:
		new_m = maxf(new_m, 1.0)
	if new_m > cap_value:
		new_m = cap_value
	if new_m < m:
		new_m = m
	return new_m


## A calendar week without drilling this move costs 0.75 mastery - but USABLE is
## retained indefinitely once earned (floor 30 when m was >= 30) and nothing decays
## below 0. A drilled week leaves the move untouched.
static func decay_week(m: float, drilled_this_week: bool) -> float:
	if drilled_this_week:
		return m
	var out: float = m - 0.75
	if m >= 30.0 and out < 30.0:
		out = 30.0
	return maxf(out, 0.0)


## The move as the gym says it: "Sharp Jab (M88)", "Raw Rear Uppercut (M18)".
## Tier word in Title case, mastery rounded.
static func describe(move_name: String, m: float) -> String:
	var word: String = tier(m)
	word = word.substr(0, 1) + word.substr(1).to_lower()
	return "%s %s (M%d)" % [word, move_name, roundi(m)]
