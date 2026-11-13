extends SceneTree
## MOVETREE1 - the boxing move tree: 16 nodes, rows, row locks, day 0, old saves, styles.

const MoveTree := preload("res://scripts/rules/MoveTree.gd")
const Data := preload("res://scripts/state/Data.gd")
const StrikeMap := preload("res://scripts/rules/StrikeMap.gd")
const PunchStart := preload("res://scripts/rules/PunchStart.gd")

var failures := 0


func _initialize() -> void:
	_check_nodes()
	_check_styles()
	_check_day0()
	_check_tech45()
	_check_locked_row_known()
	_check_styles_held()
	_check_old_save()
	print("MOVE_TREE failures=%d" % failures)
	quit(0 if failures == 0 else 1)


## 16 nodes; every punch id is in Data.MOVES; every step/defence id is a StrikeMap move.
func _check_nodes() -> void:
	_check(MoveTree.NODES.size() == 16, "16 nodes")
	for n in MoveTree.NODES:
		var id: String = str(n["id"])
		if MoveTree.PUNCH_IDS.has(id):
			_check(Data.MOVES.has(id), "punch %s is in Data.MOVES" % id)
		else:
			var found := false
			for m in StrikeMap.MOVES:
				if str(m["id"]) == id:
					found = true
					break
			_check(found, "step/defence %s is a StrikeMap move" % id)


## Each row-1 punch/step in exactly two style sets; every third move in at most one set;
## no node in three sets.
func _check_styles() -> void:
	var row1 := ["Jab", "Lead hook", "Cross", "Body hook", "step_in", "step_out"]
	for id in row1:
		var count: int = 0
		for sname in MoveTree.STYLES:
			if (MoveTree.STYLES[sname] as Array).has(id):
				count += 1
		_check(count == 2, "%s in exactly 2 style sets (got %d)" % [id, count])
	var third := ["Check hook", "Uppercut", "step_back", "pivot_out", "tie_up", "roll_out",
		"feint", "cut_off", "herd", "push_off"]
	for id in third:
		var count: int = 0
		for sname in MoveTree.STYLES:
			if (MoveTree.STYLES[sname] as Array).has(id):
				count += 1
		_check(count <= 1, "%s in at most 1 style set (got %d)" % [id, count])
	for n in MoveTree.NODES:
		var id: String = str(n["id"])
		var count: int = 0
		for sname in MoveTree.STYLES:
			if (MoveTree.STYLES[sname] as Array).has(id):
				count += 1
		_check(count < 3, "%s not in 3 sets (got %d)" % [id, count])


## Day 0 at Technique 60, Footwork 55: 6 known, row 2 open, row 3 closed,
## open_nodes contains Uppercut and step_back but not pivot_out or cut_off.
func _check_day0() -> void:
	var f := {"moves": {}, "steps": MoveTree.day0_steps(55.0)}
	for m in Data.MOVES:
		f["moves"][m] = PunchStart.mastery(60.0, m)
	var uc: int = MoveTree.usable_count(f)
	_check(uc == 6, "day0 tech60 fw55: 6 known (got %d)" % uc)
	_check(MoveTree.row_open(f, 2), "day0: row 2 open")
	_check(not MoveTree.row_open(f, 3), "day0: row 3 closed")
	var on: Array = MoveTree.open_nodes(f)
	_check(on.has("Uppercut"), "day0: Uppercut in open_nodes")
	_check(on.has("step_back"), "day0: step_back in open_nodes")
	_check(not on.has("pivot_out"), "day0: pivot_out not in open_nodes")
	_check(not on.has("cut_off"), "day0: cut_off not in open_nodes")


## Technique 45: Lead hook under 30 -> row 2 closed.
func _check_tech45() -> void:
	var f := {"moves": {}, "steps": MoveTree.day0_steps(55.0)}
	for m in Data.MOVES:
		f["moves"][m] = PunchStart.mastery(45.0, m)
	_check(not MoveTree.row_open(f, 2), "tech45: row 2 closed (Lead hook under 30)")


## A locked-row node at 30+ reads "known" (row lock stops learning only).
func _check_locked_row_known() -> void:
	var f := {"moves": {"Jab": 35.0}, "steps": {"step_in": 35.0, "tie_up": 35.0}}
	_check(not MoveTree.row_open(f, 2), "locked-row: row 2 closed (3 known)")
	_check(MoveTree.state(f, "tie_up") == "known", "locked-row node at 35 reads known")


## styles_held: Jab 61, step_out 60, step_back 60 -> ["Out-boxer"]; drop step_back to 59 -> [].
func _check_styles_held() -> void:
	var f := {"moves": {"Jab": 61.0}, "steps": {"step_out": 60.0, "step_back": 60.0}}
	var held: Array = MoveTree.styles_held(f)
	_check(held == ["Out-boxer"], "styles_held: Out-boxer (got %s)" % str(held))
	f["steps"]["step_back"] = 59.0
	held = MoveTree.styles_held(f)
	_check(held.is_empty(), "styles_held: drop step_back to 59 -> empty (got %s)" % str(held))


## old_save_steps(["step_back"]) -> step_back 60, pivot_out 30.
func _check_old_save() -> void:
	var d: Dictionary = MoveTree.old_save_steps(["step_back"])
	_check(float(d["step_back"]) == 60.0, "old_save: step_back in plan -> 60")
	_check(float(d["pivot_out"]) == 30.0, "old_save: pivot_out not in plan -> 30")


func _check(cond: bool, label: String) -> void:
	if cond:
		print("OK  " + label)
	else:
		failures += 1
		print("FAIL " + label)
