extends RefCounted
## S433 PUNCHSTART1 (FIGHT_LINK_MAP_S432 M8, "one punch rule for both corners"). Every punch starts at
## max(Technique x its start share, RAW FLOOR); RAW FLOOR = 0.4 x the mean of Accuracy and Timing: a punch never drilled is
## raw, not missing. Our fighter's MASTERY stays Technique x share (plans and fire shares read it); only the duel's punch
## level (Attrs) reads the floor. An opponent starts on the same rule from its rating and grows each punch to its full
## level (rating + shape + age) with its bouts: the start (+ its shape) at 0 bouts, full at FULL_AT_BOUTS, linear. So a
## novice opponent has the gaps a new signing has, and a 20-bout opponent does not.
## Pure static; zero preloads.

## Starting mastery as a share of Technique: the jab is the best, the last two never drilled.
const START_SHARE := {"Jab": 0.85, "Cross": 0.75, "Lead hook": 0.62, "Body hook": 0.5, "Uppercut": 0.0, "Check hook": 0.0}
## The raw floor's share of mean(Accuracy, Timing) (ESTIMATE, M8).
const RAW_FLOOR := 0.4
## Bouts by which an opponent's punches reach its full level (ESTIMATE, M8).
const FULL_AT_BOUTS := 12
## The duel's four punches and the moves each reads (the hooks are the mean of the two hooks; Attrs._punches).
const PUNCH_MOVES := {"jab": ["Jab"], "straight": ["Cross"], "hooks": ["Lead hook", "Body hook"], "uppercuts": ["Uppercut"]}


## A move's starting mastery for a Technique (the number on the plan and the fire share).
static func mastery(technique: float, move: String) -> float:
	return snappedf(technique * float(START_SHARE.get(move, 0.0)), 0.1)


static func floor_of(accuracy: float, timing: float) -> float:
	return RAW_FLOOR * 0.5 * (accuracy + timing)


## The raw floor of an attributes dict (accuracy and timing; 55 for a missing one).
static func raw_floor(a: Dictionary) -> float:
	return floor_of(float(a.get("accuracy", 55.0)), float(a.get("timing", 55.0)))


## A move's level in the duel: its mastery, never under the raw floor.
static func level(move_mastery: float, raw: float) -> float:
	return maxf(move_mastery, raw)


## The duel's four punches from move mastery ({move: mastery}); a punch with none of its moves reads `fallback`.
static func from_moves(moves: Dictionary, fallback: float, raw: float) -> Dictionary:
	var out := {}
	for k in PUNCH_MOVES:
		var n := 0
		var s := 0.0
		for m in PUNCH_MOVES[k]:
			if moves.has(m):
				s += level(float(moves[m]), raw)
				n += 1
		out[k] = s / float(n) if n > 0 else level(fallback, raw)
	return out


## The four punches a starter has: every move at its starting mastery for this Technique, through the floor.
static func start_levels(technique: float, raw: float) -> Dictionary:
	var moves := {}
	for m in START_SHARE:
		moves[m] = mastery(technique, m)
	return from_moves(moves, technique, raw)


## An opponent's punch after `bouts`: from its start to its full level, linear. Both carry her shape (AttrGen); a start
## over the full level is the full level, so no punch falls as the record grows.
static func grown(start: float, full: float, bouts: int) -> float:
	var s := minf(start, full)
	return lerpf(s, full, clampf(float(bouts) / float(FULL_AT_BOUTS), 0.0, 1.0))


## The bouts an opponent's punches have grown with: w + l + d. A professional (pro, or a pro table row: peak_age) has an
## amateur career behind the pro record, and a dict with no record (a level read, a fixture) is read at its rating.
static func bouts_of(b: Dictionary) -> int:
	if bool(b.get("pro", false)) or b.has("peak_age"):
		return FULL_AT_BOUTS
	if not (b.has("w") or b.has("l") or b.has("d")):
		return FULL_AT_BOUTS
	return int(b.get("w", 0)) + int(b.get("l", 0)) + int(b.get("d", 0))
