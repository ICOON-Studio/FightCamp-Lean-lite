extends RefCounted
## S488 STYLE5: one points lever per named style, real counters the game increments.
## Pure static; preloads StyleName, MoveTree, Duels, PaceAim.

const StyleName := preload("res://scripts/rules/StyleName.gd")
const MoveTree := preload("res://scripts/rules/MoveTree.gd")
const Duels := preload("res://scripts/rules/Duels.gd")
const PaceAim := preload("res://scripts/rules/PaceAim.gd")

const POWER_PUNCHES := ["Lead hook", "Body hook", "Check hook", "Uppercut"]

## Real counters: {style_name: [reads, applied]}. reads += 1 every exchange of a named fighter;
## applied += 1 when points() returns > 0.
static var COUNTS := {}


## The named style's points for this exchange. Returns the "pts" value when the style's situation
## is true, else 0.0. Counts every exchange of a named fighter (reads); counts applied when > 0.
## f = the fighter dict, place = int(duel["place"]), opp_mode = str(lv["mode"]) before RingDuel.step,
## pace = the push/steady/save word, arrow = the planned move id.
static func points(f: Dictionary, place: int, opp_mode: String, pace: String, arrow: String) -> float:
	var style: String = StyleName.named(f)
	if style == "":
		return 0.0
	var row: Dictionary = StyleName.EFFECTS.get(style, {})
	var pts: float = float(row.get("pts", 0.0))
	var hit := false
	match style:
		"Out-boxer":
			hit = place == Duels.LONG
		"Boxer-puncher":
			hit = place == Duels.POCKET
		"Pressure fighter":
			hit = place == Duels.INSIDE
		"Slugger":
			hit = place != Duels.LONG and (_arrow_has_power_punch(arrow) or arrow == "")
		"Counter-puncher":
			hit = opp_mode == "press" or opp_mode == "loadup"
		"Volume puncher":
			hit = pace == "push"   # S490: the push pace (PaceAim.PACES), as the brief set it
	if not hit:
		_count(style, false)
		return 0.0
	_count(style, true)
	return pts


## Increment the counter for this style. reads += 1 always; applied += 1 when applied is true.
static func _count(style: String, applied: bool) -> void:
	if not COUNTS.has(style):
		COUNTS[style] = [0, 0]
	COUNTS[style][0] += 1
	if applied:
		COUNTS[style][1] += 1


## Reset all counters (the probe calls this before each cell).
static func reset_counts() -> void:
	COUNTS = {}


## True when the arrow (a combo id or a single move) includes a hook or uppercut.
static func _arrow_has_power_punch(arrow: String) -> bool:
	if arrow == "":
		return false
	if MoveTree.COMBO_PUNCHES.has(arrow):
		var punches: Array = MoveTree.COMBO_PUNCHES[arrow]
		for p in punches:
			if POWER_PUNCHES.has(str(p)):
				return true
	if POWER_PUNCHES.has(arrow):
		return true
	return false
