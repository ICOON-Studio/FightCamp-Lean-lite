extends SceneTree
## S382 G5 the hover ghosts' stills: SET CAMP with the cursor on Hard (the ghost needles and +N / -N on the gauge row), on
## another focus card, then the whiteboard with a morning's picker open and the cursor on Hard roadwork. The cursor moves by
## real mouse events (Input.parse_input_event), so the button hover runs as in play; the picker's hovered item is set by the
## tool (the list gets no synthetic motion on the hidden desktop). Prints what each dial ghosted. On the never-shown desktop:
##   python tools/hidden_desktop.py run --timeout=240 <godot.exe> --path . --windowed --resolution 1920x1080 \
##       --log-file <log> --script res://tools/ghosts_still.gd -- <out_dir>

const TestJump := preload("res://scripts/ui/TestJump.gd")
const WeekPlan := preload("res://scripts/rules/WeekPlan.gd")
const WeekPhase := preload("res://scripts/rules/WeekPhase.gd")

var main: Node
var out_dir := "user://ghosts"


func _initialize() -> void:
	var args := OS.get_cmdline_user_args()
	if not args.is_empty():
		out_dir = args[0]
	DirAccess.make_dir_recursive_absolute(out_dir)
	root.size = Vector2i(1920, 1080)
	main = load("res://scenes/Main.tscn").instantiate()
	root.add_child(main)
	await _settle(8)
	if not TestJump.run(main, "camp"):
		print("jump=camp failed")
		quit(1)
		return
	var c: Career = main.career
	var f: Dictionary = c.fighter()
	f["board_taught"] = true
	# The whiteboard: a training morning left this week, its picker open, the cursor on Hard roadwork.
	main.act("fighter", str(f["id"]))
	main.act("ftab", "3")
	await _wait(1.0)
	var days := WeekPlan.days_of(f)
	var dow := -1
	for d in range(posmod(c.day, 7), 7):
		if str((days[d] as Array)[0]) != "rest":
			dow = d
	var mag := main.find_child("Session_%d" % dow, true, false) as MenuButton if dow >= 0 else null
	if mag != null:
		var sc := mag.get_parent()
		while sc != null and not sc is ScrollContainer:
			sc = sc.get_parent()
		if sc != null:
			(sc as ScrollContainer).scroll_vertical = int(mag.get_global_rect().position.y - 300.0)
			await _wait(0.3)
		_move(mag.get_global_rect().get_center())
		await _wait(0.3)
		mag.show_popup()
		await _wait(0.3)
		var pop := mag.get_popup()
		var cards := WeekPhase.cards()
		var k := cards.find(["roadwork", "hard"])   # near the list's top: its bottom runs past a 1009-px desktop
		if k < 0 or cards[k] == days[dow]:
			k = 0
		var row_h := float(pop.size.y) / float(maxi(1, pop.item_count))
		var at := Vector2(pop.position) + Vector2(pop.size.x * 0.5, row_h * (k + 0.5))
		_move(at - Vector2(0, row_h))
		await _wait(0.1)
		_move(at)
		# A synthetic motion does not reach the open list on the hidden desktop, so the tool sets its hover item itself.
		pop.set_focused_item(k)
		await _wait(0.06)
		await _shot("g5_board_pick_sweep")
		await _wait(0.4)
		await _shot("g5_board_pick")
		print("board: day %d picker focused %d (hovered %d) embedded %s" % [dow, pop.get_focused_item(), k, str(root.gui_embed_subwindows)])
		_report(main.find_child("Goal", true, false))
		pop.hide()
		await _wait(0.3)
		_report(main.find_child("Goal", true, false))
	else:
		print("board: no training morning left this week")
	# SET CAMP: the cursor on Hard, then on another focus card.
	main.act("camp", str(f["id"]))
	await _wait(1.0)
	var m: Node = main.modal_node()
	_move(Vector2(10, 10))
	await _wait(0.2)
	await _shot("g5_camp_idle")
	var hard := m.find_child("Protocol_3", true, false) as Control
	_move(hard.get_global_rect().get_center())
	await _wait(0.06)
	await _shot("g5_camp_hard_sweep")
	await _wait(0.4)
	await _shot("g5_camp_hard")
	print("camp, cursor on Hard:")
	_report(m)
	var other := "conditioning" if str(main.modal["focus"]) != "conditioning" else "power"
	_move((m.find_child("Focus_" + other, true, false) as Control).get_global_rect().get_center())
	await _wait(0.4)
	await _shot("g5_camp_focus_" + other)
	print("camp, cursor on %s:" % other)
	_report(m)
	quit(0)


func _report(n: Node) -> void:
	var g := n.find_child("Gauges", true, false) if n != null else null
	if g == null:
		print("  no gauge row")
		return
	for id in ["legs", "scale", "risk"]:
		var dial: Node = g.find_child("Gauge_" + id, true, false).find_child("Dial", true, false)
		print("  %s v=%.2f ghost=%s lit=%d ghost_lit=%d delta='%s'" % [id, float(dial.get("v")), str(dial.get("ghost")),
			int(dial.get("lit")), int(dial.get("ghost_lit")), (g.deltas[id] as Label).text])


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
	await _settle(2)
	await RenderingServer.frame_post_draw
	var path := out_dir.path_join(name + ".png")
	root.get_texture().get_image().save_png(path)
	print("wrote ", path)
