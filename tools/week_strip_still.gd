extends SceneTree
## S381 G2 the weeks strip's stills: SET CAMP with the strip top right, the same with a week to come clicked (the coach's
## week), and the whiteboard header once the camp runs. On the never-shown desktop:
##   python tools/hidden_desktop.py run --timeout=180 <godot.exe> --path . --windowed --resolution 1920x1080 \
##       --log-file <log> --script res://tools/week_strip_still.gd -- <out_dir>

const TestJump := preload("res://scripts/ui/TestJump.gd")

var main: Node
var out_dir := "user://week_strip"


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
	main.act("camp", str(f["id"]))
	await _shot("g2_camp_strip")
	var s: Node = main.modal_node().find_child("WeekStrip", true, false)
	var b := s.find_child("Week_2", false, false) as Button if s != null else null
	if b != null:
		b.pressed.emit()
	await _shot("g2_camp_peek")
	if s != null:
		(s.find_child("WeekPeek", false, false) as Window).hide()
	main.act("startcamp")
	if not main.modal.is_empty():
		main.act("close")
	TestJump._tidy(main, c)
	main.act("fighter", str(f["id"]))
	main.act("ftab", "3")
	await _shot("g2_board_strip")
	quit(0)


func _settle(frames: int = 6) -> void:
	for i in frames:
		await process_frame


func _shot(name: String) -> void:
	await _settle()
	await RenderingServer.frame_post_draw
	var path := out_dir.path_join(name + ".png")
	root.get_texture().get_image().save_png(path)
	print("wrote ", path)
