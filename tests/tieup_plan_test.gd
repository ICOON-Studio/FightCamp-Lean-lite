extends SceneTree
## Tie-ups tab plan mode: arrows by reaction, limit, remove, TIEUPS1 clip play when plan off.

const PlanBoard := preload("res://scripts/rules/PlanBoard.gd")
const TieUpPanel := preload("res://scripts/grapple/TieUpPanel.gd")

var failures := 0
var browser: Control


func _initialize() -> void:
	root.size = Vector2i(1920, 1080)
	browser = load("res://scenes/dev/GrappleBrowser.tscn").instantiate()
	root.add_child(browser)
	await process_frame
	await process_frame
	await process_frame

	var limit := PlanBoard.arrow_limit(browser.coach_skill)

	var tie_tab: Button = _button_with_text(browser, "Tie-ups")
	_check(tie_tab != null, "Tie-ups button in top bar")
	if tie_tab == null:
		_finish(limit)
		return
	tie_tab.pressed.emit()
	await process_frame

	var russian: Button = _list_button_named("Russian tie")
	_check(russian != null, "Russian tie in list")
	if russian == null:
		_finish(limit)
		return
	russian.pressed.emit()
	await process_frame

	var build := _find_button(browser, "Build plan")
	_check(build != null, "Build plan button while tie-up open")
	if build == null:
		_finish(limit)
		return
	build.pressed.emit()
	await process_frame
	await process_frame

	var first := _answer_button_named("Double leg")
	var second := _answer_button_named("Attack the far leg")
	_check(first != null and second != null, "two russian_tie answers with clips")
	if first == null or second == null:
		_finish(limit)
		return
	first.pressed.emit()
	await process_frame
	await process_frame
	second = _answer_button_named("Attack the far leg")
	_check(second != null, "second answer button after first plan add")
	if second == null:
		_finish(limit)
		return
	second.pressed.emit()
	await process_frame
	await process_frame

	_check(browser.plan.size() == 2, "plan holds 2 arrows (got %d)" % browser.plan.size())
	_check(_arrows_label_text() == "Arrows 2 / %d" % limit, "panel reads Arrows 2 / %d" % limit)
	_check(not _validate_problem_shown(), "no validate problem line after two different reactions")

	first = _answer_button_named("Double leg")
	_check(first != null, "first answer button for duplicate press")
	if first != null:
		first.pressed.emit()
		await process_frame
	_check(browser.plan.size() == 2, "pressing same answer again still 2 arrows")

	# Fill to limit (switch tie-ups if this tie runs out of new reactions).
	while browser.plan.size() < limit:
		var before: int = browser.plan.size()
		var added := await _add_one_unplanned_answer()
		_check(added and browser.plan.size() > before, "added arrow toward limit %d (now %d)" % [limit, browser.plan.size()])
		if not added or browser.plan.size() == before:
			break
		await process_frame

	_check(browser.plan.size() == limit, "plan filled to limit %d (got %d)" % [limit, browser.plan.size()])
	_check(_all_answers_full_or_planned(limit), "full plan greys unplanned answers, planned stay enabled")

	var remove := _find_button(browser._side, "Remove")
	_check(remove != null, "Remove button on an arrow row")
	if remove != null:
		remove.pressed.emit()
		await process_frame
		await process_frame
		_check(browser.plan.size() == limit - 1, "remove drops count to %d" % (limit - 1))
		_check(_arrows_label_text() == "Arrows %d / %d" % [limit - 1, limit], "count drops on panel")

	# Plan mode off -> clip answer sets moving (TIEUPS1).
	var done := _find_button(browser._side, "Done")
	if done == null:
		done = _find_button(browser, "Done")
	_check(done != null, "Done button leaves plan mode")
	if done != null:
		done.pressed.emit()
		await process_frame
		await process_frame
		var enabled: Button = null
		for b in _answer_buttons():
			if not (b as Button).disabled:
				enabled = b
				break
		_check(enabled != null, "at least one enabled answer outside plan mode")
		if enabled != null:
			browser.moving = {}
			enabled.pressed.emit()
			await process_frame
			await process_frame
			_check(not browser.moving.is_empty(), "pressing enabled answer sets moving non-empty")

	_finish(limit)


func _finish(limit: int) -> void:
	if failures == 0:
		print("PASS tieup_plan_test (limit %d)" % limit)
	else:
		print("FAIL %d" % failures)
	quit(1 if failures else 0)


func _check(ok: bool, what: String) -> void:
	print(("  ok   " if ok else "  FAIL ") + what)
	if not ok:
		failures += 1


func _add_one_unplanned_answer() -> bool:
	var map: Array = TieUpPanel.plan_map()
	for b in _answer_buttons():
		var btn: Button = b
		var tech := _button_big_line(btn)
		if btn.disabled:
			continue
		if _answer_on_plan(tech, map):
			continue
		btn.pressed.emit()
		return true
	# Try another tie-up from the list.
	for lb in _list_buttons():
		var name := _button_big_line(lb)
		if name == "Russian tie":
			continue
		(lb as Button).pressed.emit()
		await process_frame
		for b2 in _answer_buttons():
			var btn2: Button = b2
			if btn2.disabled:
				continue
			if _answer_on_plan(_button_big_line(btn2), map):
				continue
			btn2.pressed.emit()
			return true
	return false


func _answer_on_plan(technique: String, map: Array) -> bool:
	for a in browser.plan:
		var row := PlanBoard.row(map, str(a["move"]))
		if str(row.get("name", "")) == technique:
			return true
	return false


func _all_answers_full_or_planned(limit: int) -> bool:
	var reason := "The plan is full (%d arrows for this coach)" % limit
	var map: Array = TieUpPanel.plan_map()
	var planned_names := {}
	for a in browser.plan:
		var row := PlanBoard.row(map, str(a["move"]))
		if not row.is_empty():
			planned_names[str(row.get("name", ""))] = true
	var any_grey := false
	for b in _answer_buttons():
		var btn: Button = b
		var tech := _button_big_line(btn)
		if planned_names.has(tech):
			if btn.disabled:
				print("  planned answer greyed: ", tech)
				return false
			continue
		if not btn.disabled:
			print("  unplanned answer still enabled: ", tech)
			return false
		if _shows_reason(btn, reason):
			any_grey = true
	return any_grey


func _shows_reason(b: Button, reason: String) -> bool:
	if b.tooltip_text == reason:
		return true
	for l in b.find_children("*", "Label", true, false):
		if str(l.text) == reason:
			return true
	return false


func _validate_problem_shown() -> bool:
	for l in browser._side.find_children("*", "Label", true, false):
		var t := str(l.text)
		if t.begins_with("Arrows ") or t.begins_with("Covers "):
			continue
		if t == "THE PLAN" or t.begins_with("if she "):
			continue
		if t.contains(" -> ") and not t.contains("Two "):
			continue
		# PlanPanel validate problems use UI.GOLD tiny labels - heuristic: problem phrases
		if t.contains("arrows") or t.contains("Two answers") or t.contains("No move"):
			return true
	return false


func _arrows_label_text() -> String:
	for l in browser._side.find_children("*", "Label", true, false):
		var t := str(l.text)
		if t.begins_with("Arrows "):
			return t
	return ""


func _find_button(from: Node, big: String) -> Button:
	for b in from.find_children("*", "Button", true, false):
		var btn: Button = b
		if btn.text == big or _button_big_line(btn) == big:
			return btn
	return null


func _list_buttons() -> Array:
	return browser._list.find_children("*", "Button", true, false)


func _list_button_named(name: String) -> Button:
	for b in _list_buttons():
		if _button_big_line(b) == name:
			return b
	return null


func _side_buttons() -> Array:
	return browser._side.find_children("*", "Button", true, false)


func _answer_buttons() -> Array:
	var out: Array = []
	for b in _side_buttons():
		var big := _button_big_line(b)
		if big == "" or big == "Skip to the end" or big == "Build plan" or big == "Done" or big == "Start again":
			continue
		if big.begins_with("->") or big == "Remove":
			continue
		out.append(b)
	return out


func _answer_button_named(technique: String) -> Button:
	for b in _answer_buttons():
		if _button_big_line(b) == technique:
			return b
	return null


func _button_with_text(root: Node, text: String) -> Button:
	for b in root.find_children("*", "Button", true, false):
		if (b as Button).text == text:
			return b
	return null


func _button_big_line(b: Button) -> String:
	for child in b.get_children():
		var t := _first_bold_label(child)
		if t != "":
			return t
	return b.text


func _first_bold_label(node: Node) -> String:
	if node is Label and (node as Label).text != "":
		return (node as Label).text
	for child in node.get_children():
		var t := _first_bold_label(child)
		if t != "":
			return t
	return ""
