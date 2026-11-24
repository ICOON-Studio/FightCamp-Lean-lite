extends SceneTree
## OFFICEV2 (S538, owner Q-S294-302 / Q-304 "Yes, build them"): the Fighters and Staff sheets inside the office desktop, on
## the TEST CLUB in the real game. The two icons open the sheets without leaving the office; the test club fills them; a
## click on a heading sorts by it and a second click turns it round; the Columns chooser takes a column off and puts one
## on; a right-click on a name opens the menu, whose lines are only acts the game has - a grey line says why and does
## nothing, every other line opens its screen (or changes the one thing it says). No "release" and no "let the club coach
## go": the game has no such act.
## Prints OFFICE_SHEET failures=<n>.
##   godot --headless --audio-driver Dummy --path . --script res://tests/office_sheet_test.gd

const SHEET_PATH := "res://scripts/ui/OfficeSheet.gd"
const MENU_PATH := "res://scripts/ui/OfficeMenu.gd"

var failures := 0
var main: Node
var sheet: Script
var menu: Script


func _initialize() -> void:
	if not ResourceLoader.exists(SHEET_PATH) or not ResourceLoader.exists(MENU_PATH):
		_check(false, "OfficeSheet.gd and OfficeMenu.gd exist")
		_done()
		return
	sheet = load(SHEET_PATH)
	menu = load(MENU_PATH)
	root.size = Vector2i(1920, 1080)
	main = load("res://scenes/Main.tscn").instantiate()
	root.add_child(main)
	await process_frame
	main.create = {"test_club": "1"}
	main._start_career("Anvil Street Gym", "London")
	await _settle()
	var c: Career = main.career
	await _open_sheets("fighters")
	_check(str(main.route["area"]) == "office", "the Fighters icon stays in the office (%s)" % main.route["area"])
	var fs := main.find_child("Sheet_fighters", true, false) as Control
	var ss := main.find_child("Sheet_staff", true, false) as Control
	_check(fs != null and ss != null, "both sheets are inside the desktop")
	if fs == null or ss == null:
		_done()
		return
	for f in c.fighters + c.grapplers:
		_check(fs.find_child("Row_fighters_" + str(f["id"]), true, false) != null, "the test club's %s has a row" % f["name"])
	_check(ss.find_children("Row_staff_*", "", true, false).size() >= 5, "the staff sheet lists the people and the open jobs")
	_check(main.find_child("NeedsPanel", true, false) == null, "the dashboard's panels make room for the sheets")
	# Sort: a heading sorts low first, the same heading again turns it round.
	await _press("Sort_fighters_stamina")
	var up := _order("fighters", "stamina")
	_check(_rising(up), "a click on Stamina sorts low first %s" % str(up))
	await _press("Sort_fighters_stamina")
	var down := _order("fighters", "stamina")
	down.reverse()
	_check(_rising(down) and bool(sheet.sort["fighters"][1]), "a second click turns it round %s" % str(down))
	await _press("Sort_staff_pay")
	_check(_rising(_order("staff", "pay")), "the staff sheet sorts by pay")
	# Columns: off by default, the chooser puts one on and takes one off; the name always stays.
	_check(main.find_child("Sort_fighters_rating", true, false) == null, "Rating is off until it is picked")
	(main.find_child("Columns_fighters", true, false) as Button).pressed.emit()
	await _settle()
	var chooser := main.find_child("OfficeColumns", true, false) as Control
	_check(chooser != null and chooser.find_child("Col_rating", true, false) != null, "Columns opens the chooser")
	_check(chooser != null and chooser.find_child("Col_fighter", true, false) == null, "the name column cannot be taken off")
	if chooser != null:
		(chooser.find_child("Col_rating", true, false) as CheckBox).button_pressed = true
		(chooser.find_child("Col_weight", true, false) as CheckBox).button_pressed = false
		await _settle()
	_check(main.find_child("Sort_fighters_rating", true, false) != null, "ticking Rating shows the column")
	_check(main.find_child("Sort_fighters_weight", true, false) == null, "unticking Weight hides it")
	menu.close(main)
	sheet.toggle("fighters", "weight")
	sheet.toggle("fighters", "rating")
	await _fighter_menu(c)
	await _staff_menu(c)
	_done()


func _fighter_menu(c: Career) -> void:
	var f: Dictionary = c.fighters[0]
	var id := str(f["id"])
	await _open_sheets("fighters")
	var lines: Array = await _right_click("Row_fighters_" + id)
	var words: Array = lines.map(func(x): return str(x["t"]))
	_check(lines.size() >= 8, "the fighter's menu has its lines %s" % str(words))
	_check(not words.any(func(w): return str(w).to_lower().contains("release")), "no Release line: the game has no such act")
	var pop := main.find_child("OfficeMenu", true, false) as Control
	_check(pop != null and pop.find_child("Item_%d" % (lines.size() - 1), true, false) != null, "the menu is drawn, a button a line")
	for i in lines.size():
		var item: Dictionary = lines[i]
		var what := str(item["t"])
		_check(str(item["opens"]) != "" and (str(item["act"]) != "" or not (item["nav"] as Dictionary).is_empty()), "'%s' runs a real act" % what)
		await _open_sheets("fighters")
		await _right_click("Row_fighters_" + id)
		var btn := main.find_child("Item_%d" % i, true, false) as Button
		var before := _mark(c, f)
		if str(item["why"]) != "":
			_check(btn != null and btn.disabled, "'%s' is grey: %s" % [what, item["why"]])
			_check(not menu.run(main, item) and _mark(c, f) == before, "'%s' does nothing while grey" % what)
			menu.close(main)
			continue
		btn.pressed.emit()
		await _settle()
		_check(main.find_child("OfficeMenu", true, false) == null, "'%s' closes the menu" % what)
		_check(_landed(str(item["opens"]), before, c, f), "'%s' %s (route %s, modal %s)" % [what, item["sub"], main.route["area"], str(main.modal.get("type", ""))])
		_tidy()
		await _settle()


func _staff_menu(c: Career) -> void:
	await _open_sheets("staff")
	var coach := str(c.coach.get("id", ""))
	var lines: Array = await _right_click("Row_staff_" + coach)
	var words: Array = lines.map(func(x): return str(x["t"]))
	_check(words == ["Open the staff page"], "the gym coach: the staff page, and no Let go (%s)" % str(words))
	menu.close(main)
	var other := "hale" if coach != "hale" else "reid"
	lines = await _right_click("Row_staff_" + other)
	_check(str(lines[0]["t"]) == "Hire" and str(lines[0]["why"]) != "", "the other coach: Hire is grey, the place is taken (%s)" % lines[0]["why"])
	menu.close(main)
	lines = await _right_click("Row_staff_physio")
	_check(str(lines[0]["t"]) == "Hire" and str(lines[0]["act"]) == "hirerole", "an open job: Hire")
	(main.find_child("Item_0", true, false) as Button).pressed.emit()
	await _settle()
	_check(c.staff_roles.has("physio"), "Hire on the physio job hires the physio (the Staff page's own act)")
	lines = await _right_click("Row_staff_physio")
	_check(str(lines[0]["t"]) == "Let go" and str(lines[0]["act"]) == "letgorole", "a filled job: Let go")
	(main.find_child("Item_0", true, false) as Button).pressed.emit()
	await _settle()
	_check(not c.staff_roles.has("physio"), "Let go takes the physio off the staff")
	lines = await _right_click("Row_staff_evening")
	_check(str(lines[1]["why"]) != "", "no evening coach to let go: the line is grey")
	(main.find_child("Item_0", true, false) as Button).pressed.emit()
	await _settle()
	_check(c.extra_coaches == 1, "Add an evening coach adds one")
	lines = await _right_click("Row_staff_you")
	(main.find_child("Item_%d" % (lines.size() - 1), true, false) as Button).pressed.emit()
	await _settle()
	_check(str(main.route["area"]) == "gym" and int(main.route["tab"]) == 1, "Open the staff page opens Staff")


## What a line's run must show.
func _landed(opens: String, before: String, c: Career, f: Dictionary) -> bool:
	if opens.begins_with("route:"):
		return str(main.route["area"]) == opens.get_slice(":", 1)
	if opens.begins_with("modal:"):
		return str(main.modal.get("type", "")) == opens.get_slice(":", 1)
	if opens == "board":
		return _boards() > 0 or not main.modal.is_empty() or str(main.route["area"]) != "office"
	return _mark(c, f) != before


func _boards() -> int:
	var n := 0
	for ch in main.get_children():
		if ch.name.begins_with("StrikeBrowser") or ch.name.begins_with("FightAnalysis"):
			n += 1
	return n


func _mark(c: Career, f: Dictionary) -> String:
	return var_to_str([main.route, main.modal.get("type", ""), _boards(), f.get("champ", {}), c.staff_roles, c.extra_coaches, c.cash])


## Back to a clean office after a line ran: modal shut, boards off.
func _tidy() -> void:
	if not main.modal.is_empty():
		main.close_modal()
	for ch in main.get_children():
		if ch.name.begins_with("StrikeBrowser") or ch.name.begins_with("FightAnalysis"):
			main.remove_child(ch)
			ch.queue_free()


func _open_sheets(which: String) -> void:
	if str(main.route["area"]) != "office":
		main.nav({"area": "office", "tab": 0})
		await _settle()
	# S547 STAFFCARDS1: the Staff icon opens the staff cards; the sheets (fighters and staff side by side) open from Fighters
	(main.find_child("App_" + ("fighters" if which == "staff" else which), true, false) as Button).pressed.emit()
	await _settle()


## A right mouse press on the row: the lines the menu shows.
func _right_click(row_name: String) -> Array:
	var row := main.find_child(row_name, true, false) as Control
	if row == null:
		_check(false, "%s is on the sheet" % row_name)
		return []
	var ev := InputEventMouseButton.new()
	ev.button_index = MOUSE_BUTTON_RIGHT
	ev.pressed = true
	ev.global_position = row.get_global_rect().position + Vector2(120, 20)
	ev.position = Vector2(120, 20)
	row.gui_input.emit(ev)
	await _settle()
	var kind := row_name.get_slice("_", 1)
	var id := row_name.substr(("Row_%s_" % kind).length())
	var rows: Array = sheet.OfficeDesk.fighter_sheet(main.career) if kind == "fighters" else sheet.OfficeDesk.staff_sheet(main.career)
	for r in rows:
		if str(r["id"]) == id:
			var lines: Array = sheet.items(main.career, kind, r)
			var pop := main.find_child("OfficeMenu", true, false) as Control
			_check(pop != null and pop.find_children("Item_*", "Button", true, false).size() == lines.size(), "a right-click on %s opens its menu" % row_name)
			return lines
	return []


func _press(node_name: String) -> void:
	var b := main.find_child(node_name, true, false) as Button
	_check(b != null, "%s is on the sheet" % node_name)
	if b != null:
		b.pressed.emit()
	await _settle()


## The sort values of a column, top row first, as the sheet draws them.
func _order(kind: String, col: String) -> Array:
	var values := {}
	var rows: Array = sheet.OfficeDesk.fighter_sheet(main.career) if kind == "fighters" else sheet.OfficeDesk.staff_sheet(main.career)
	for r in rows:
		values["Row_%s_%s" % [kind, r["id"]]] = float(r["cells"][col][1])
	var holder := main.find_child("Row_%s_%s" % [kind, rows[0]["id"]], true, false).get_parent()
	var out: Array = []
	for ch in holder.get_children():
		if values.has(str(ch.name)):
			out.append(values[str(ch.name)])
	return out


func _rising(a: Array) -> bool:
	for i in range(1, a.size()):
		if float(a[i]) < float(a[i - 1]):
			return false
	return a.size() > 1


func _settle() -> void:
	for i in 3:
		await process_frame


func _done() -> void:
	print("OFFICE_SHEET failures=%d" % failures)
	if main != null:
		main.queue_free()
	quit(1 if failures > 0 else 0)


func _check(ok: bool, what: String) -> void:
	print(("  ok: " if ok else "  FAIL: ") + what)
	if not ok:
		failures += 1
