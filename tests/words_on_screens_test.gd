extends SceneTree
## PRESENT1A: People, Fights, a bout page and the fighter Overview.
## Old bare strings stay gone, and a disabled button shows its reason without a hover.
## Prints WORDS_ON_SCREENS failures=<n>.

var bare_pct := RegEx.create_from_string("^[+\\-]\\d+%$")
var bare_over := RegEx.create_from_string("\\d\\.\\d over")
var bare_gap := RegEx.create_from_string("(^|\\s)Gap [+\\-]?\\d")

var main: Node
var failures := 0


func _initialize() -> void:
	seed(7)
	root.size = Vector2i(1920, 1080)
	main = load("res://scenes/Main.tscn").instantiate()
	root.add_child(main)
	await _settle()
	if DisplayServer.get_name() == "headless":
		main.set_anchors_and_offsets_preset(Control.PRESET_TOP_LEFT)
		main.size = Vector2(1920, 1080)
	await _settle()
	main.act("quick")
	main.act("guideskip")
	main.close_modal()
	main.act("interview")
	for card in ["Jab and move", "Pad rounds", "Hill sprints"]:
		main.act("pickcard", card)
	main.act("sign")
	main.act("go", "gym:1")
	await _settle()
	_page("people", ["Versus no coach", "moves"], [])
	var c: Career = main.career
	_run_until(func() -> bool: return not (c.fighter()["offers"] as Array).is_empty())
	var offer := ""
	for o in c.fighter()["offers"]:
		if not bool(o["answered"]):
			offer = str(o["id"])
			break
	_check(offer != "", "an offer is on the table")
	main.act("go", "fights:0")
	await _settle()
	_page("fights", ["Scouting report", "Strength gap"], [])
	if offer != "":
		main.act("openBout", offer)
		await _settle()
		_page("bout", ["Scouting report"], [])
	main.act("fighter", "lucy")
	await _settle()
	_page("overview", ["OF 100", "kg"], [])
	print("WORDS_ON_SCREENS failures=%d" % failures)
	quit(1 if failures > 0 else 0)


func _page(name: String, need: Array, _unused: Array) -> void:
	var text := _visible_text(main)
	for old in ["File:", " on the file", "found on the opponent", "edge +"]:
		_check(text.find(old) < 0, "%s has no '%s'" % [name, old])
	var bare_num := false
	for node in _walk(main):
		if not node is CanvasItem or not (node as CanvasItem).is_visible_in_tree():
			continue
		var bit := ""
		if node is Label:
			bit = (node as Label).text.strip_edges()
		elif node is Button:
			bit = (node as Button).text.strip_edges()
		if bit == "":
			continue
		if bare_pct.search(bit) != null or bare_over.search(bit) != null or bare_gap.search(bit) != null:
			bare_num = true
			print("  %s bare '%s'" % [name, bit.replace("\n", " ")])
	_check(not bare_num, "%s has no bare percent, kg-less over, or Gap chip" % name)
	for bit in need:
		_check(text.find(str(bit)) >= 0, "%s says '%s'" % [name, bit])
	var bare := 0
	for node in _walk(main):
		if not node is BaseButton:
			continue
		var b: BaseButton = node as BaseButton
		if not b.disabled or not b.is_visible_in_tree():
			continue
		if _reason_ok(b) or ["<", ">"].has(b.text.strip_edges()):   # S417: a grey arrow needs no words; its reason is on hover
			continue
		bare += 1
		print("  %s disabled '%s' tip '%s'" % [name, b.text.replace("\n", " "), str(b.tooltip_text).replace("\n", " ")])
	_check(bare == 0, "%s: every disabled button shows its reason (%d bare)" % [name, bare])


## The tooltip's opening, or the button's own words, must sit in a label on the button or the two parents above it.
func _reason_ok(b: BaseButton) -> bool:
	var tip := str(b.tooltip_text).strip_edges()
	if tip.length() < 12:
		return false
	var blob: String = b.text
	var node: Node = b
	for _depth in 3:
		if node == null:
			break
		for n in node.find_children("*", "Label", true, false):
			if (n as CanvasItem).is_visible_in_tree():
				blob += " " + (n as Label).text
		node = node.get_parent()
	var low: String = blob.to_lower()
	var t: String = tip.to_lower()
	if low.contains(t.substr(0, mini(12, t.length()))):
		return true
	var shown: String = b.text.strip_edges().to_lower()
	return shown.length() >= 6 and t.contains(shown)


func _visible_text(root_node: Node) -> String:
	var parts: PackedStringArray = PackedStringArray()
	for node in _walk(root_node):
		if not node is CanvasItem or not (node as CanvasItem).is_visible_in_tree():
			continue
		if node is Label:
			parts.append((node as Label).text)
		elif node is Button:
			parts.append((node as Button).text)
	return "\n".join(parts)


func _walk(node: Node) -> Array:
	var out: Array = [node]
	for child in node.get_children():
		out.append_array(_walk(child))
	return out


func _run_until(until: Callable) -> void:
	var c: Career = main.career
	for _i in 40:
		if until.call():
			return
		for f in c.fighters:
			for o in f["offers"]:
				if not bool(o["answered"]) and bool(o["mismatch"]):
					main.act("declineOffer", str(o["id"]))
			if bool(f.get("goal_talk", false)):
				main.act("goaltalk", f["id"])
				main.act("pickgoal", "five_round_engine")
				main.act("setgoal")
		if until.call():
			return
		if c.review_pending:
			main.act("review")
			main.act("close")
		main.run_to_stop()


func _settle() -> void:
	for _i in 4:
		await process_frame


func _check(cond: bool, label: String) -> void:
	if cond:
		print("PASS ", label)
	else:
		failures += 1
		print("FAIL ", label)
