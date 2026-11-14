extends SceneTree
## LEARNPICK1 (S463) walked through the real scenes: quick start -> sign a fighter -> her page shows WHAT TO LEARN NEXT with
## the coach's cards -> click a Study button for a step -> it sits in her study slot -> weeks of CONTINUE raise it ->
## at 30 the slot frees, the news says so, and the move book stops calling it not learned.

const MoveTree := preload("res://scripts/rules/MoveTree.gd")
const StudyWeek := preload("res://scripts/rules/StudyWeek.gd")

var failures := 0
var main: Node


func _initialize() -> void:
	main = load("res://scenes/Main.tscn").instantiate()
	root.add_child(main)
	await process_frame
	main.act("quick")
	main.career.seed = 1
	main.act("go_btn")
	for card in ["Jab and move", "Pad rounds", "Hill sprints"]:
		main.act("pickcard", card)
	main.act("sign")
	await process_frame
	var c: Career = main.career
	var f: Dictionary = c.fighter()
	main.act("fighter", str(f["id"]))
	main.act("ftab", "0")
	await process_frame
	var page: Node = main._shell.find_child("FighterPage", true, false)
	_check(page != null, "fighter page open")
	if page == null:
		_end()
		return
	var labels := page.find_children("*", "Label", true, false).map(func(n): return str((n as Label).text))
	_check(labels.has("WHAT TO LEARN NEXT"), "the card shows on her page")
	var studies: Array = page.find_children("*", "Button", true, false).filter(func(b): return str((b as Button).text).begins_with("Study "))
	_check(studies.size() >= 1 and studies.size() <= 3, "1-3 Study buttons (%d)" % studies.size())
	var step_btn: Button = null
	var step_id := ""
	for b in studies:
		for id in StudyWeek.cards(f).map(func(x): return str(x["id"])):
			if not MoveTree.PUNCH_IDS.has(id) and str((b as Button).text) == "Study " + StudyWeek.name_of(id) and not (b as Button).disabled:
				step_btn = b
				step_id = id
	_check(step_btn != null, "a step card to click (%s)" % step_id)
	if step_btn == null:
		_end()
		return
	step_btn.emit_signal("pressed")
	await process_frame
	_check((f.get("learning_slots", []) as Array).has(step_id), "clicked: %s is in her study slot" % step_id)
	var m0 := MoveTree.mastery(f, step_id)
	var n0 := c.news.size()
	var d0 := c.day
	for i in 120:   # CONTINUE stops on events too: count weeks by the date, cap at 16
		if not (f.get("learning_slots", []) as Array).has(step_id) or c.day - d0 > 16 * 7:
			break
		main.run_to_stop()
		if c.review_pending:
			main.act("review")
			main.act("close")
	var m1 := MoveTree.mastery(f, step_id)
	print("WALK %s %.1f -> %.1f in %d days, pad nights now %d" % [step_id, m0, m1, c.day - d0, (load("res://scripts/rules/PadWeek.gd").nights_of(f).get("pads", []) as Array).size()])
	_check(m1 > m0, "the weeks raised it (%.1f -> %.1f)" % [m0, m1])
	_check(m1 >= 30.0 and not (f.get("learning_slots", []) as Array).has(step_id), "usable and the slot is free")
	var said := false
	for i in maxi(0, c.news.size() - n0):
		if str((c.news[i] as Dictionary).get("t", "")).find(StudyWeek.name_of(step_id).to_lower()) >= 0:
			said = true
	_check(said, "the news says it")
	_end()


func _end() -> void:
	print("STUDY_PICK_WALK failures=%d" % failures)
	quit(1 if failures > 0 else 0)


func _check(ok: bool, label: String) -> void:
	print(("  ok   " if ok else "  FAIL ") + label)
	if not ok:
		failures += 1
