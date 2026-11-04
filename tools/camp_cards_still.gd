extends SceneTree
## S379 CAMPCARDS: stills of the real FIGHT CAMP modal - (a) as it opens on Lucy's first even bout, (b) Power + Hard with
## film study (the golden path's quick-start career, seed 1), (c) Danny's camp (jump=men). Run on the never-shown desktop:
##   python tools/hidden_desktop.py run --timeout=240 <godot.exe> --path . --windowed --resolution 1920x1080 \
##       --audio-driver Dummy --script res://tools/camp_cards_still.gd -- <out_dir>

const TestJump := preload("res://scripts/ui/TestJump.gd")

var main: Node
var out_dir := "user://camp_cards_still"


func _initialize() -> void:
	var args := OS.get_cmdline_user_args()
	if not args.is_empty():
		out_dir = str(args[0])
	DirAccess.make_dir_recursive_absolute(out_dir)
	root.size = Vector2i(1920, 1080)
	root.content_scale_aspect = Window.CONTENT_SCALE_ASPECT_KEEP
	main = load("res://scenes/Main.tscn").instantiate()
	root.add_child(main)
	await _wait(4)
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
	main.clear_toast()
	await _shot("a_camp_open")
	main.act("cfocus", "power")
	main.act("cproto", "3")
	if not bool(main.modal.get("film", false)):
		main.act("cfilm", "")
	await _shot("b_power_hard_film")
	# (c) a man's camp (jump=men: Danny's first even offer) - the station pictures fall back to a baked body.
	main.act("close")
	TestJump.run(main, "men")
	var d: Dictionary = (main.career as Career).fighter_by_id("danny")
	for o in d.get("offers", []):
		if not bool(o["mismatch"]):
			main.act("accept", str(o["id"]))
			break
	main.act("camp", "danny")
	main.clear_toast()
	await _shot("c_men_camp")
	quit(0)


func _shot(name: String) -> void:
	await create_timer(1.0).timeout
	await RenderingServer.frame_post_draw
	var path := out_dir.path_join(name + ".png")
	root.get_texture().get_image().save_png(path)
	print("STILL ", path)


func _wait(frames: int) -> void:
	for i in frames:
		await process_frame
