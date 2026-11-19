extends SceneTree
## S527: the guard notes (GuardNotes, S526) were built into THIS CAMP, which sits in the Training tab's hidden "Legacy" box,
## so the player never saw them (guard_notes_test checks the words only). They now show under COACH'S PICK on the Training
## tab whenever a bout is booked. Red before S527: no VISIBLE GuardNote. Last line: GUARD_NOTES_SHOWN failures=0.

const TestJump := preload("res://scripts/ui/TestJump.gd")
const GuardNotes := preload("res://scripts/rules/GuardNotes.gd")
const WeekOpp := preload("res://scripts/rules/WeekOpp.gd")

var failures := 0
var main: Node


func _initialize() -> void:
	root.size = Vector2i(1920, 1080)
	main = load("res://scenes/Main.tscn").instantiate()
	root.add_child(main)
	await process_frame
	main.act("quick")
	var c: Career = main.career
	c.seed = 1
	main.act("interview")
	for card in ["Jab and move", "Pad rounds", "Hill sprints"]:
		main.act("pickcard", card)
	main.act("sign")
	main.act("hire", "reid")
	var f: Dictionary = c.fighter()
	for i in 60:
		if not (f["offers"] as Array).is_empty():
			break
		TestJump._tidy(main, c)
		main.run_to_stop()
	for o in f["offers"]:
		if not bool(o["mismatch"]):
			main.act("accept", str(o["id"]))
			break
	main.clear_toast()
	main.act("fighter", str(f["id"]))
	main.act("ftab", "3")
	for i in 4:
		await process_frame
	var shown: Array = []
	for n in root.find_children("GuardNote", "", true, false):
		if (n as CanvasItem).is_visible_in_tree():
			shown.append(n)
	_check(not shown.is_empty(), "a guard note is VISIBLE on the Training tab with a bout booked (found %d)" % shown.size())
	var am := GuardNotes.amateur_note(true)
	var has_am := false
	for n in shown:
		has_am = has_am or (n is Label and (n as Label).text == am)
	_check(has_am, "the amateur guard note is among them")
	# The tape's prep line in words (it shows under COACH'S PICK when the opponent's game asks for mornings).
	var ln := WeekOpp.line({"style": "Pressure fighter", "first": "Priya"}, [["slip_rope", "normal"], ["roadwork", "normal"]], "build")
	_check(not ln.is_empty() and WeekOpp.words(ln) == "The opponent walks you down: 2 slip rope mornings a week (this week 1).",
		"the prep line in words: %s" % WeekOpp.words(ln))
	_check(WeekOpp.words({}) == "", "no line, no words")
	print("OPP_PREP labels=%d" % root.find_children("OppPrep", "", true, false).size())
	print("GUARD_NOTES_SHOWN failures=%d" % failures)
	quit(0 if failures == 0 else 1)


func _check(ok: bool, label: String) -> void:
	if not ok:
		failures += 1
		print("FAIL " + label)
