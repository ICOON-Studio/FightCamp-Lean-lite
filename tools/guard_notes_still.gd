extends SceneTree
## S527: the guard notes (GuardNotes, S526 guard v4 step 6) under THIS CAMP's "vs" line on the fighter's whiteboard, seen
## in the real build. Same quick-start career as camp_cards_still (seed 1, Lucy's first even bout, Power + Hard + film),
## then Start the camp and open the whiteboard tab. Run on the never-shown desktop:
##   python tools/hidden_desktop.py run --timeout=240 <godot.exe> --path . --windowed --resolution 1920x1080 \
##       --audio-driver Dummy --script res://tools/guard_notes_still.gd -- <out_dir>

const TestJump := preload("res://scripts/ui/TestJump.gd")

var main: Node
var out_dir := "user://guard_notes_still"


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
	main.act("cfocus", "power")
	main.act("cproto", "3")
	if not bool(main.modal.get("film", false)):
		main.act("cfilm", "")
	main.act("startcamp")
	main.clear_toast()
	main.act("fighter", str(f["id"]))
	main.act("ftab", "3")
	await _wait(6)
	var notes := root.find_children("GuardNote", "", true, false)
	print("GUARD_NOTES shown=%d" % notes.size())
	for n in notes:
		print("  NOTE ", (n as Label).text if n is Label else str(n))
	await _shot("guard_notes_whiteboard")
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
