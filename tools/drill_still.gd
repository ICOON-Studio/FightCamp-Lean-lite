extends SceneTree
## S382 DRILLCARD1 stills of the Training tab (TRAINING_SCREEN_S381.md, the approved mockup training_mockup.png): Lucy in
## camp (jump=camp) with an own combination held by her Lead hook (37.3) and a split pad night; t1 the tab as it opens,
## t2 scrolled to the board, t3 a tray card clicked (the click-click hint, the pad nights lit), t4 a morning's picker open.
## On the never-shown desktop:
##   python tools/hidden_desktop.py run --timeout=240 <godot.exe> --path . --windowed --resolution 1920x1080 \
##       --audio-driver Dummy --script res://tools/drill_still.gd -- <out_dir>

const TestJump := preload("res://scripts/ui/TestJump.gd")
const OwnCombos := preload("res://scripts/rules/OwnCombos.gd")
const PadWeek := preload("res://scripts/rules/PadWeek.gd")

var main: Node
var out_dir := "user://training_still"


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
	var fid := str(f["id"])
	f["board_taught"] = true
	f["book"] = [{"name": "jab, jab, step in, lead hook", "chain": ["jab", "jab", "step_in", "lead_hook"], "score": 70}]
	OwnCombos.ensure_ids(f)
	f["moves"]["Lead hook"] = 37.3
	var nights := PadWeek.nights_of(f)
	var pads: Array = nights["pads"]
	if not pads.is_empty():
		main.act("drill", "%s|%d|own:1" % [fid, int(pads[-1])])
	f["moves"]["Uppercut"] = 27.5   # a card that turns usable on Monday's pads: its gold face
	main.act("fighter", fid)
	main.act("ftab", "3")
	await _wait(1.2)
	if args.has("film"):
		# The bars tween (animated meters): the split night cycles 50/50 -> 70/30 -> 30/70 under --write-movie.
		_scroll_to(main.find_child("WeekBoard", true, false) as Control, 8.0)
		await _wait(1.0)
		for i in 2:
			main.act("padsplit", "%s|%d" % [fid, int(pads[-1])])
			_scroll_to(main.find_child("WeekBoard", true, false) as Control, 8.0)
			await _wait(1.2)
		quit(0)
		return
	await _shot("t1_training_open")
	var board := main.find_child("WeekBoard", true, false) as Control
	_scroll_to(board, 8.0)
	await _wait(0.8)
	await _shot("t2_training_board")
	var card := main.find_child("TrayCards", true, false).get_child(0) as Button
	card.pressed.emit()
	await _wait(0.5)
	_scroll_to(main.find_child("WeekBoard", true, false) as Control, 8.0)
	await _wait(0.6)
	await _shot("t3_picked")
	card = main.find_child("TrayCards", true, false).get_child(0) as Button
	card.pressed.emit()
	await _wait(0.3)
	(main.find_child("Session_%d" % posmod(c.day, 7), true, false) as Button).pressed.emit()
	await _wait(0.5)
	var pk := main.find_child("Picker", true, false) as Control
	_scroll_to(pk, 420.0)
	await _wait(0.6)
	await _shot("t4_picker")
	print("nights ", nights, " tray ", f.get("tray", []), " pad_week ", f.get("pad_week", {}))
	quit(0)


func _scroll_to(n: Control, above: float) -> void:
	if n == null:
		return
	var sc := n.get_parent()
	while sc != null and not sc is ScrollContainer:
		sc = sc.get_parent()
	if sc != null:
		var s := sc as ScrollContainer
		s.scroll_vertical = int(s.scroll_vertical + n.get_global_rect().position.y - s.get_global_rect().position.y - above)


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
