extends SceneTree
## S382 G4 the gauge row's stills: SET CAMP (Standard), the same on Hard (the dials moved), and the whiteboard's THIS CAMP
## column once the camp runs. On the never-shown desktop:
##   python tools/hidden_desktop.py run --timeout=180 <godot.exe> --path . --windowed --resolution 1920x1080 \
##       --log-file <log> --script res://tools/gauges_still.gd -- <out_dir>

const TestJump := preload("res://scripts/ui/TestJump.gd")

var main: Node
var out_dir := "user://gauges"


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
	await _wait(1.0)
	await _shot("g4_camp_standard")
	main.act("cproto", "3")
	await _wait(0.2)
	await _shot("g4_camp_hard_moving")
	await _wait(1.2)
	await _shot("g4_camp_hard")
	main.act("startcamp")
	if not main.modal.is_empty():
		main.act("close")
	TestJump._tidy(main, c)
	main.act("fighter", str(f["id"]))
	main.act("ftab", "3")
	await _wait(1.0)
	await _shot("g4_board")
	quit(0)


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
