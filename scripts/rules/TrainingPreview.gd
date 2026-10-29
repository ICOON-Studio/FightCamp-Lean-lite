extends RefCounted
## THE GAIN RULE (copied from E:\FightCamp\Game\Godot\scripts\TrainingPreview.gd, S292 pace, stripped for the lean restart).
## Stats are floats and every screen shows whole numbers, so training must be legible: the planner's forecast, the daily
## step and the week review all read this one rule. Kept: preview_gain, headroom, progress_to_next, deltas. Dropped:
## lived-day gains, stat history and trends, sparklines, injury risk (no floor, no history screen in week 1).

## S292 PACE (operator: "you make the decision"): a focused week moves the primary stat 1.0 x coach x headroom.
## Headroom (potential - stat) / 25 clamped 0.10 - 1.25: a fresh amateur far below potential gets the rookie surge.
const PROGRAM_RATE := 1.0
const HEADROOM_SPAN := 25.0
const HEADROOM_MIN := 0.10
const HEADROOM_MAX := 1.25

## The old repo resolved equipment tags through AthleteStatModel; the lean game trains stat keys directly.
## One alias is kept so a tag and its stat still count once.
const MODIFIER_ALIASES := {"strength": "power"}

## A week's plan: the focus stat trains fully, its partner a little, everything else barely.
const FOCUS_SHARE := 1.0
const PARTNER_SHARE := 0.4
const OTHER_SHARE := 0.06
const PARTNER := {
	"power": "technique", "speed": "technique", "technique": "speed", "defense": "fight_iq",
	"conditioning": "chin", "fight_iq": "defense", "chin": "conditioning",
}


static func headroom(potential: int, current: float) -> float:
	return clampf((float(potential) - current) / HEADROOM_SPAN, HEADROOM_MIN, HEADROOM_MAX)


static func coach_factor(coach_rating: float) -> float:
	return 0.5 + (coach_rating / 100.0) * 0.7


## {stat_key: gain} for every stat the station trains that the fighter has (a stat counts once).
static func preview_gain(stats: Dictionary, potential: int, station: Dictionary,
		coach_rating: float, crowd_factor: float, fraction: float) -> Dictionary:
	var out: Dictionary = {}
	if station.is_empty() or fraction <= 0.0:
		return out
	var quality_factor: float = 0.7 + 0.3 * int(station.get("quality_tier", 1))
	var condition_factor: float = int(station.get("condition", 100)) / 100.0
	for modifier in station.get("training_modifiers", []):
		var stat_key: String = str(MODIFIER_ALIASES.get(str(modifier), str(modifier)))
		if stat_key == "" or not stats.has(stat_key) or out.has(stat_key):
			continue
		var current: float = float(stats[stat_key])
		out[stat_key] = PROGRAM_RATE * quality_factor * condition_factor * coach_factor(coach_rating) \
			* headroom(potential, current) * fraction * crowd_factor
	return out


## The whole week's gain for a plan with `focus`: {stat_key: gain} for every stat the fighter has.
static func plan_gain(stats: Dictionary, potential: int, focus: String, coach_rating: float) -> Dictionary:
	var out: Dictionary = {}
	var partner := str(PARTNER.get(focus, ""))
	for key in stats.keys():
		var share := OTHER_SHARE
		if key == focus:
			share = FOCUS_SHARE
		elif key == partner:
			share = PARTNER_SHARE
		var one: Dictionary = preview_gain(stats, potential, {"training_modifiers": [key]}, coach_rating, 1.0, share)
		out[key] = float(one.get(key, 0.0))
	return out


## How far a stat is toward its next whole point, in [0, 1).
static func progress_to_next(value: float) -> float:
	return value - floorf(value)


## True when a change carried the stat over a whole point (the bar turns gold).
static func crossed_point(before: float, after: float) -> bool:
	return floorf(after) > floorf(before)


## Per-stat change between two stat blocks (after - before), every shared key.
static func deltas(before: Dictionary, after: Dictionary) -> Dictionary:
	var out: Dictionary = {}
	for key in after.keys():
		if before.has(key):
			out[str(key)] = float(after[key]) - float(before[key])
	return out
