extends SceneTree
## PLAYBOOK > Combos (ComboBuilder, S349): moves to try add rows, ComboFlow's verdict and lessons show, a locked punch
## says why, Save puts the chain in her book, a book combination offers the pads. 6 tests.

const CB := preload("res://scripts/ui/ComboBuilder.gd")

var failures := 0
var main: Node


func _initialize() -> void:
	main = load("res://scenes/Main.tscn").instantiate()
	root.add_child(main)
	await process_frame
	main.act("newcareer")
	main.act("quick")
	main.act("interview")
	for card in ["Jab and move", "Pad rounds", "Hill sprints"]:
		main.act("pickcard", card)
	main.act("sign")
	CB.chain = []
	main.act("go", "playbook:2")
	await process_frame
	var f: Dictionary = main.career.fighters[0]
	var b := main.find_child("ComboBuilder", true, false)
	_check(b != null, "test 1: PLAYBOOK > Combos opens the builder")
	if b == null:
		_end()
		return
	for id in ["jab", "cross", "slip"]:
		(main.find_child("Try_" + id, true, false) as Button).pressed.emit()
	await process_frame
	_check(main.find_child("Step_3", true, false) != null and CB.chain == ["jab", "cross", "slip"], "test 2: three moves to try make three numbered rows")
	var verdict := main.find_child("Verdict", true, false)
	var lessons := main.find_child("Lessons", true, false)
	_check(verdict != null and lessons != null and _text(verdict).contains("FLOWS"), "test 3: 1-2 then slip FLOWS, with key lessons (%s)" % (_text(verdict) if verdict else "none"))
	var why := CB.locked_why(f, "rear_uppercut")
	var up := float((f["moves"] as Dictionary)["Uppercut"])
	_check((up < 30.0) == (why != "") and CB.locked_why(f, "slip") == "", "test 4: a punch under 30 says why (uppercut %d: '%s'); a slip never locks" % [int(up), why])
	(main.find_child("SaveCombo", true, false) as Button).pressed.emit()
	await process_frame
	var book: Array = f.get("book", [])
	_check(book.size() == 1 and book[0]["chain"] == ["jab", "cross", "slip"], "test 5: Save puts the chain in her book (%d)" % book.size())
	(main.find_child("Book_1-2", true, false) as Button).pressed.emit()
	await process_frame
	_check(CB.book_id(CB.chain) == "1-2" and main.find_child("DrillCombo", true, false) != null, "test 6: a book combination offers Drill it on the pads")
	_end()


func _text(n: Node) -> String:
	var out := ""
	for c in n.get_children():
		if c is Label:
			out += (c as Label).text + " "
	return out


func _check(cond: bool, label: String) -> void:
	if cond:
		print("PASS ", label)
	else:
		failures += 1
		print("FAIL ", label)


func _end() -> void:
	print("COMBO_BUILDER failures=%d" % failures)
	quit(1 if failures > 0 else 0)
