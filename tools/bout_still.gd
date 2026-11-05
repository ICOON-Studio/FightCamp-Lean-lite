extends SceneTree
## S387 MENUBOUT stills: the offers rows, the bout page with nothing found, the same page with the whole file open (a rematch
## reads this way), the unsafe offer. Real pictures only, so run it on the never-shown desktop:
##   python tools/hidden_desktop.py run --timeout=180 <godot.exe> --path . --windowed --resolution 1920x1080 \
##       --script res://tools/bout_still.gd -- <out_dir>

const Bouts := preload("res://scripts/state/Bouts.gd")
const OppFile := preload("res://scripts/rules/OppFile.gd")

var main: Node
var out_dir := "user://bout_still"


func _initialize() -> void:
	var args := OS.get_cmdline_user_args()
	if not args.is_empty():
		out_dir = args[0]
	DirAccess.make_dir_recursive_absolute(out_dir)
	root.size = Vector2i(1920, 1080)
	main = load("res://scenes/Main.tscn").instantiate()
	root.add_child(main)
	await _frames(4)
	main.act("newcareer")
	main.act("quick")
	main.act("guideskip")
	main.close_modal()
	main.act("interview")
	main.act("pickcard", "signature")
	main.act("sign")
	main.act("go", "gym:1")
	main.act("hire", "reid")
	await process_frame
	var c: Career = main.career
	var f: Dictionary = c.fighter()
	for i in 40:
		if not (f["offers"] as Array).is_empty():
			break
		main.run_to_stop()
		main.act("close")
	var even := ""
	var unsafe := ""
	for o in f["offers"]:
		if bool(o["mismatch"]):
			unsafe = str(o["id"])
		else:
			even = str(o["id"])
	main.act("go", "fights:0")
	await _shot("offers_rows")
	main.act("openBout", even)
	await _shot("bout_0_found")
	OppFile.tape(Bouts.offer(c, even)["opp"])
	OppFile.tape(Bouts.offer(c, even)["opp"])
	main.render()
	await _shot("bout_2_found")
	OppFile.open_all(Bouts.offer(c, even)["opp"])
	main.render()
	await _shot("bout_all_found")
	main.act("openBout", unsafe)
	await _shot("bout_unsafe")
	quit(0)


func _frames(n: int) -> void:
	for i in n:
		await process_frame


func _shot(name: String) -> void:
	await create_timer(1.0).timeout   # every bar has finished its tween
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png(out_dir.path_join(name + ".png"))
	print("wrote ", name)
