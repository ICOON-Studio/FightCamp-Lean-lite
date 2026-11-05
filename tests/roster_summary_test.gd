extends SceneTree
## S388 C236: FIGHTERS > Roster is a summary page. Each boxer row shows all seven attributes and the five facts; the no-gi athlete's
## card shows the syllabus and the facts; Home keeps the short tile.

const MAIN := preload("res://scenes/Main.tscn")
const Data := preload("res://scripts/state/Data.gd")
const Sim := preload("res://scripts/state/Sim.gd")
const FirstWeek := preload("res://scripts/rules/FirstWeek.gd")
const RosterSummary := preload("res://scripts/ui/RosterSummary.gd")

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
	main.act("go", "fighters:0")
	await process_frame
	var lucy: Node = main.find_child("Summary_lucy", true, false)
	_check(lucy != null, "Lucy's row has a summary")
	if lucy != null:
		_check(lucy.find_child("Attributes", true, false).get_child_count() == Data.STATS.size(), "all seven attributes show")
		_check(lucy.find_child("Facts", true, false).get_child_count() == 5, "style, session, learning, weapons and pay show")
	var ana: Node = main.find_child("Summary_ana", true, false)
	_check(ana != null, "Ana's card has a summary")
	if ana != null:
		_check(ana.find_child("Syllabus", true, false).get_child_count() > 0, "Ana's syllabus shows")
		_check(ana.find_child("Facts", true, false).get_child_count() >= 4, "mood, open, chance and best at show")
	_check(RosterSummary.weapons({"moves": {"Jab": 51.0, "Cross": 30.0, "Hook": 12.0}}) == "2 of 3 moves", "weapons counts moves at 30 and up")
	main.act("area", "home")
	await process_frame
	_check(main.find_child("Summary_lucy", true, false) == null, "Home keeps the short tile")
	print("ROSTER_SUMMARY failures=%d" % failures)
	print("PASS roster_summary_test" if failures == 0 else "FAIL roster_summary_test")
	quit(failures)


func _check(ok: bool, label: String) -> void:
	if not ok:
		failures += 1
	print(("  ok: " if ok else "  FAIL: ") + label)
