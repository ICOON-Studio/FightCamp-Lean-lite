extends SceneTree
## Tie-ups tab in the ground-move browser: six tie-ups, answers, clips, chain links.

const WrestleChains := preload("res://scripts/rules/WrestleChains.gd")

var failures := 0
var browser: Control


func _initialize() -> void:
	root.size = Vector2i(1920, 1080)
	browser = load("res://scenes/dev/GrappleBrowser.tscn").instantiate()
	root.add_child(browser)
	await process_frame
	await process_frame
	await process_frame

	var tie_tab: Button = _button_with_text(browser, "Tie-ups")
	_check(tie_tab != null, "Tie-ups button in top bar")
	if tie_tab == null:
		_finish()
		return
	tie_tab.pressed.emit()
	await process_frame

	var list_btns: Array = _list_buttons()
	_check(list_btns.size() == 6, "lists exactly 6 tie-up buttons (got %d)" % list_btns.size())

	var collar: Button = _list_button_named("Collar tie")
	_check(collar != null, "collar_tie in list")
	if collar == null:
		_finish()
		return
	collar.pressed.emit()
	await process_frame

	var answers: Array = WrestleChains.answers("collar_tie")
	var answer_btns: Array = _answer_buttons()
	_check(answer_btns.size() == answers.size(), "collar_tie shows %d answer buttons (got %d)" % [answers.size(), answer_btns.size()])

	var snap: Button = _answer_button_named("Snapdown")
	_check(snap != null, "Snapdown answer button")
	if snap != null:
		var link: Button = _link_button_named("Front headlock")
		_check(link != null, "Snapdown has link button naming Front headlock")

	var transitions: Array = browser.graph.transitions
	for a in answers:
		var clips: Array = WrestleChains.clip_for(a, transitions)
		var btn: Button = _answer_button_named(str(a["technique"]))
		_check(btn != null, "button for %s" % a["technique"])
		if btn == null:
			continue
		if clips.is_empty():
			_check(btn.disabled, "%s disabled when no clip" % a["technique"])
			_check(btn.tooltip_text == "No clip of this yet", "%s tooltip" % a["technique"])
		else:
			_check(not btn.disabled, "%s enabled when clip exists" % a["technique"])

	var enabled: Button = null
	for b in answer_btns:
		if not (b as Button).disabled:
			enabled = b
			break
	_check(enabled != null, "at least one enabled answer")
	if enabled != null:
		enabled.pressed.emit()
		await process_frame
		_check(not browser.moving.is_empty(), "pressing enabled answer sets moving non-empty")

	_finish()


func _finish() -> void:
	print("FAIL %d" % failures if failures else "PASS tieup_panel_test")
	quit(1 if failures else 0)


func _check(ok: bool, what: String) -> void:
	print(("  ok   " if ok else "  FAIL ") + what)
	if not ok:
		failures += 1


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
		if big == "" or big == "Skip to the end":
			continue
		if big.begins_with("->"):
			continue
		out.append(b)
	return out


func _answer_button_named(technique: String) -> Button:
	for b in _answer_buttons():
		if _button_big_line(b) == technique:
			return b
	return null


func _link_button_named(tie_name: String) -> Button:
	for b in _side_buttons():
		var t := _button_label(b)
		if t.contains("->") and t.contains(tie_name):
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


func _button_label(b: Button) -> String:
	if b.text != "":
		return b.text
	var parts: PackedStringArray = []
	for child in b.get_children():
		_collect_labels(child, parts)
	return " ".join(parts)


func _first_bold_label(node: Node) -> String:
	if node is Label and (node as Label).text != "":
		return (node as Label).text
	for child in node.get_children():
		var t := _first_bold_label(child)
		if t != "":
			return t
	return ""


func _collect_labels(node: Node, parts: PackedStringArray) -> void:
	if node is Label and (node as Label).text != "":
		parts.append((node as Label).text)
	for child in node.get_children():
		_collect_labels(child, parts)
