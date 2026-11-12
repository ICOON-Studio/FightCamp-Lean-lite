extends SceneTree
## S388 C236: FIGHTERS > Roster is a summary page; Home keeps the short tile. S440 (PAGES2B): the Roster's rows are the
## painted ones (RosterRows), so "every column shows on her row" reads the row's own columns, each a visible Label with the
## value RosterRow gives, instead of counting the old table's nine Labels.

const MAIN := preload("res://scenes/Main.tscn")
const Data := preload("res://scripts/state/Data.gd")
const Sim := preload("res://scripts/state/Sim.gd")
const FirstWeek := preload("res://scripts/rules/FirstWeek.gd")
const RosterSummary := preload("res://scripts/ui/RosterSummary.gd")
const RosterRow := preload("res://scripts/rules/RosterRow.gd")
const FighterProfile := preload("res://scripts/rules/FighterProfile.gd")
const RosterCards := preload("res://scripts/ui/RosterCards.gd")

var failures := 0
var main: Node


func _initialize() -> void:
	main = MAIN.instantiate()
	root.add_child(main)
	await process_frame
	main.act("quick")
	var c: Career = main.career
	Sim.sign(c, ["Jab and move", "Pad rounds", "Hill sprints"])
	FirstWeek.ana_joins(c)
	main.act("go", "fighters:0")   # S440 the painted rows are the Roster's default view
	await process_frame
	_check(RosterCards.view == "rows", "the Roster opens on the painted rows")
	for id in ["lucy", "ana"]:
		var row: Node = main.find_child("Row_" + id, true, false)
		_check(row != null, "%s has a row on the Roster" % id)
		if row != null:
			_columns(c, row, id)
	_check(RosterSummary.weapons({"moves": {"Jab": 51.0, "Cross": 30.0, "Hook": 12.0}}) == "2 of 3 moves", "weapons counts moves at 30 and up")
	main.act("area", "home")
	await process_frame
	_check(main.find_child("Summary_lucy", true, false) == null, "Home keeps the short tile")
	print("ROSTER_SUMMARY failures=%d" % failures)
	print("PASS roster_summary_test" if failures == 0 else "FAIL roster_summary_test")
	quit(failures)


## Every RosterRow column has its cell on the row; the name, the tiredness and the mood read the game's own values.
func _columns(c: Career, row: Node, id: String) -> void:
	var data: Dictionary = RosterRow.row(c, id)
	var f: Dictionary = c.fighter_by_id(id)
	if f.is_empty():
		f = c.grappler_by_id(id)
	for key in data.keys():
		if str(key) == "needs_you":
			continue
		_check(row.find_child("Col_" + str(key), true, false) != null, "%s: the %s column shows on the row" % [id, key])
	_check(_shown(row, "Col_fighter", "Name") == str(f["name"]), "%s: the name" % id)
	_check(_shown(row, "Col_tiredness", "Big") == str(int(round(FighterProfile.fatigue(f)))), "%s: the tiredness" % id)
	_check(_shown(row, "Col_mood", "Word") == FighterProfile.mood(float(f.get("morale", FighterProfile.MORALE_START))), "%s: the mood" % id)
	var blank := 0
	for l in row.find_children("*", "Label", true, false):
		if not (l as Label).is_visible_in_tree() or (l as Label).text.strip_edges() == "":
			blank += 1
	_check(blank == 0, "%s: every Label on the row is a visible word (%d blank or hidden)" % [id, blank])


func _shown(row: Node, cell: String, child: String) -> String:
	var col: Node = row.find_child(cell, true, false)
	var l: Label = col.find_child(child, true, false) as Label if col != null else null
	return l.text if l != null and l.is_visible_in_tree() else ""


func _check(ok: bool, label: String) -> void:
	if not ok:
		failures += 1
	print(("  ok: " if ok else "  FAIL: ") + label)
