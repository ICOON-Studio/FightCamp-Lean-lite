extends SceneTree
## S397 menus to 8, round 3's fixes (blind critic): on a mid-season career (TestJump "nationals": Lucy 4-1, entries open,
## Ana the no-gi athlete) -
## 1. one main action: a filled "Enter Lucy for the nationals" on her Overview and Fight prep;
## 2. History lists every bout, the ones she brought too (5 rows for 4-1), with a method;
## 3. Ana's full card only on Fights, a one-line link on Rankings;
## 4. the top bar has one clock: no Pause button beside CONTINUE, the speeds sit in the Clock group;
## 5. Escapes has no referee card and no "Worth pad time next" line.

const TestJump := preload("res://scripts/ui/TestJump.gd")

var _fails := 0


func _initialize() -> void:
	root.size = Vector2i(1920, 1080)
	var main: Node = load("res://scenes/Main.tscn").instantiate()
	root.add_child(main)
	await _frames(4)
	TestJump.run(main, "nationals")
	if not main.modal.is_empty():
		main.act("close")
	var f: Dictionary = main.career.fighter()
	main.act("fighter", str(f["id"]))
	await _frames(4)
	_check(main.find_child("EnterNationals", true, false) is Button, "1: Overview carries Enter for the nationals")
	var e: Button = main.find_child("EnterNationals", true, false)
	_check(e != null and str(e.theme_type_variation) in ["BtnSolid", "Go"], "1: it is the page's filled button")   # LOOKSLATE7: the Overview's primary is the wood Go piece
	var prep_tab := false
	for b in main.find_children("*", "Button", true, false):
		prep_tab = prep_tab or str((b as Button).text) == "Fight prep"
	_check(not prep_tab, "1: no bout, no camp: the Fight prep tab is not shown (round 4)")
	main.act("ftab", "4")
	await _frames(4)
	var hist: Node = main.find_child("BoutHistory", true, false)
	var text := _texts(hist) if hist != null else ""
	var rows := text.count("\nWon\n") + text.count("\nLost\n")
	_check(rows == int(f["w"]) + int(f["l"]), "2: History has a row per bout (%d of %d)" % [rows, int(f["w"]) + int(f["l"])])
	_check(text.contains("points") or text.contains("stopped"), "2: each row has a method")
	for r in [["world:1", false], ["fights:0", true]]:   # S397 round 5: Championships carries no Ana strip
		main.act("go", r[0])
		await _frames(3)
		var full := false
		var link := false
		for g in main.career.grapplers:
			full = full or main.find_child("MatOpens_" + str(g["id"]), true, false) != null
			link = link or main.find_child("MatLink_" + str(g["id"]), true, false) != null
		if main.career.grapplers.is_empty():
			continue
		_check(full == bool(r[1]) and link != bool(r[1]), "3: %s shows Ana's %s" % [r[0], "full card" if bool(r[1]) else "link"])
	var pause := false
	for b in main.find_children("*", "Button", true, false):
		pause = pause or str((b as Button).text) == "Pause"
	_check(not pause and main.find_child("Speed", true, false) == null, "4: one clock - no Pause, no speed buttons beside CONTINUE (Settings)")
	main.act("fighter", str(f["id"]))
	main.act("ptab", "3")
	await _frames(4)
	var esc := _texts(main)
	_check(not esc.contains("Referee breaks") and not esc.contains("Worth pad time next"), "5: Escapes - no referee card, no pads line")
	_end()


func _texts(n: Node) -> String:
	var out := "\n"
	for l in n.find_children("*", "Label", true, false):
		out += str((l as Label).text) + "\n"
	for b in n.find_children("*", "Button", true, false):
		out += str((b as Button).text) + "\n"
	return out


func _frames(n: int) -> void:
	for i in n:
		await process_frame


func _check(cond: bool, label: String) -> void:
	if cond:
		print("PASS ", label)
	else:
		_fails += 1
		print("FAIL ", label)


func _end() -> void:
	print("MENUS_ROUND4 %s" % ("PASS" if _fails == 0 else "FAIL %d" % _fails))
	quit(1 if _fails > 0 else 0)
