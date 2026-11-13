extends RefCounted
## STYLENAME1 - the named style: which one a fighter holds, when it goes, what it changes, the extra plan line.
## Pure static; preloads MoveTree only. S457: a coach names a boxer by what the boxer holds; lose the hold and the style goes next Monday.

const MoveTree := preload("res://scripts/rules/MoveTree.gd")

const MAX_LINES := 7

const EFFECTS := {
	"Out-boxer": {"lever": "range_open", "add": 0.1},
	"Volume puncher": {"lever": "combo_energy", "mult": 0.9},
	"Boxer-puncher": {"lever": "mid_edge", "add": 0.1},
	"Pressure fighter": {"lever": "pressure_answers", "mult": 1.2},
	"Slugger": {"lever": "knockdown", "mult": 1.1},
	"Counter-puncher": {"lever": "counter_edge", "add": 0.15, "when": ["loadup", "press"]},
}


## The fighter's named style when still held, else "".
static func named(f: Dictionary) -> String:
	var s: String = str(f.get("style", ""))
	if s == "":
		return ""
	if not MoveTree.styles_held(f).has(s):
		return ""
	return s


## True when the style's three moves are all 60+.
static func can_name(f: Dictionary, style: String) -> bool:
	return MoveTree.styles_held(f).has(style)


## The Monday check: returns new values, never mutates f.
## {style: String, lost: String, auto: bool}.
static func monday(f: Dictionary) -> Dictionary:
	var cur: String = str(f.get("style", ""))
	var held: Array = MoveTree.styles_held(f)
	var style: String = ""
	var lost: String = ""
	if cur != "":
		if held.has(cur):
			style = cur
		else:
			lost = cur
	var auto := false
	if style == "" and held.size() == 1:
		style = str(held[0])
		auto = true
	return {"style": style, "lost": lost, "auto": auto}


## The named style's value for a lever. add -> neutral 0.0; mult -> neutral 1.0; unknown lever 0.0.
## A row with "when" counts only when opp_mode is in its list, else neutral.
static func effect(f: Dictionary, lever: String, opp_mode: String = "") -> float:
	var s: String = named(f)
	if s == "":
		return _neutral(lever)
	var row: Dictionary = EFFECTS.get(s, {}) as Dictionary
	if row.is_empty():
		return _neutral(lever)
	if str(row.get("lever", "")) != lever:
		return _neutral(lever)
	if row.has("when"):
		if not (row["when"] as Array).has(opp_mode):
			return _neutral(lever)
	if row.has("add"):
		return float(row["add"])
	if row.has("mult"):
		return float(row["mult"])
	return _neutral(lever)


static func _neutral(lever: String) -> float:
	for sname in EFFECTS:
		var row: Dictionary = EFFECTS[sname]
		if str(row.get("lever", "")) == lever:
			if row.has("mult"):
				return 1.0
			if row.has("add"):
				return 0.0
	return 0.0


## coach_cap + 1 when a style is named, never above MAX_LINES; else min(coach_cap, MAX_LINES).
static func plan_cap(f: Dictionary, coach_cap: int) -> int:
	if named(f) != "":
		return mini(coach_cap + 1, MAX_LINES)
	return mini(coach_cap, MAX_LINES)


## Two or more styles held at once.
static func two_held(f: Dictionary) -> bool:
	return MoveTree.styles_held(f).size() >= 2
