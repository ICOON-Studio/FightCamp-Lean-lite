extends SceneTree
## S382 camp2 final proof stills: SET CAMP (Lucy's offer, idle cursor), the same with the cursor on Hard (the hover ghosts),
## the week whiteboard once the camp runs, and the Playbook's Game plan tab with its spar-night Test it button.
## On the never-shown desktop:
##   python tools/hidden_desktop.py run --timeout=240 <godot.exe> --path . --windowed --resolution 1920x1080 \
##       --log-file <log> --script res://tools/camp2_proof_still.gd -- <out_dir>

const TestJump := preload("res://scripts/ui/TestJump.gd")

var main: Node
var out_dir := "user://camp2_proof"


func _initialize() -> void:
	var args := OS.get_cmdline_user_args()
	if not args.is_empty():
		out_dir = args[0]
	DirAccess.make_dir_recursive_absolute(out_dir)
	root.size = Vector2i(1920, 1080)
	main = load("res://scenes/Main.tscn").instantiate()
	root.add_child(main)
	await _settle(8)
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
	var bout: Dictionary = f.get("bout", {})
	var opp: Dictionary = bout.get("opp", {})
	print("fighter %s vs %s %s, fight day %s, today %d" % [str(f.get("first", f.get("name", ""))), str(opp.get("first", "")),
		str(opp.get("last", "")), str(bout.get("day", "?")), int(c.day)])
	main.act("camp", str(f["id"]))
	_move(Vector2(10, 10))
	await _wait(3.2)   # the "Bout booked" toast (2.6 s) clears off the footer
	await _shot("p1_camp_modal")
	var m: Node = main.modal_node()
	_measure(m)
	var hard := m.find_child("Protocol_3", true, false) as Control
	if hard != null:
		_move(hard.get_global_rect().get_center())
		await _wait(0.6)
		await _shot("p2_camp_hover_hard")
	else:
		print("no Protocol_3 card")
	_move(Vector2(10, 10))
	await _wait(0.3)
	main.act("startcamp")
	if not main.modal.is_empty():
		main.act("close")
	TestJump._tidy(main, c)
	main.act("fighter", str(f["id"]))
	main.act("ftab", "3")
	await _wait(1.0)
	var strips := root.find_children("WeekStrip", "", true, false)
	if not strips.is_empty():
		await _scroll_to(strips[0] as Control, 150.0)
	await _wait(3.0)   # the "camp started" toast clears
	await _shot("p3_week_board")
	if not main.modal.is_empty():
		main.act("close")
	main.act("go", "playbook:1")
	await _wait(1.5)
	var tb := _find_text(root, "Test it")
	print("playbook test button: ", tb.text if tb != null else "NOT FOUND", " disabled=", tb.disabled if tb != null else false)
	if tb != null:
		await _scroll_to(tb, 640.0)
		_move(tb.get_global_rect().get_center())
		await _wait(1.2)
	await _shot("p4_playbook_test")
	quit(0)


## Every card in the protocol row: its height against what its words need (a Button does not grow to its children).
func _measure(m: Node) -> void:
	var row := m.find_child("Protocols", true, false)
	if row == null:
		print("no Protocols row")
		return
	for b in row.get_children():
		var need := 0.0
		for k in b.get_children():
			if k is MarginContainer:
				need = (k as Control).get_combined_minimum_size().y
		print("  %s card %s needs %.0f %s" % [b.name, str((b as Control).size), need,
			"OK" if need <= (b as Control).size.y + 0.5 else "OVERFLOW"])


func _scroll_to(n: Control, y_on_screen: float) -> void:
	var sc := n.get_parent()
	while sc != null and not sc is ScrollContainer:
		sc = sc.get_parent()
	if sc == null:
		print("no scroll above ", n.name)
		return
	var s := sc as ScrollContainer
	s.scroll_vertical += int(n.get_global_rect().position.y - y_on_screen)
	await _wait(0.4)


func _find_text(n: Node, s: String) -> Button:
	if n is Button and (n as Button).text.begins_with(s) and (n as Button).is_visible_in_tree():
		return n
	for k in n.get_children():
		var r := _find_text(k, s)
		if r != null:
			return r
	return null


func _move(p: Vector2) -> void:
	var ev := InputEventMouseMotion.new()
	ev.position = p
	ev.global_position = p
	Input.parse_input_event(ev)


func _wait(s: float) -> void:
	await create_timer(s).timeout


func _settle(frames: int = 6) -> void:
	for i in frames:
		await process_frame


func _shot(name: String) -> void:
	await _settle()
	await RenderingServer.frame_post_draw
	var path := out_dir.path_join(name + ".png")
	root.get_texture().get_image().save_png(path)
	print("wrote ", path)
