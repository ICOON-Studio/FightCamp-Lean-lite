extends SceneTree
## S414 Q-S294-143: the fighter Overview after one played week, cream and dark, the same save. Real pictures, on the hidden desktop:
##   python tools/hidden_desktop.py run --timeout=180 <godot.exe> --path . --windowed --resolution 1920x1080 --script res://tools/dark_overview_still.gd -- <out_dir>

const FighterPage := preload("res://scripts/ui/areas/FighterPage.gd")

var main: Node
var out_dir := "user://dark_still"


func _initialize() -> void:
	load("res://scripts/ui/MenuFx.gd").instant = true
	var args := OS.get_cmdline_user_args()
	if not args.is_empty():
		out_dir = args[0]
	DirAccess.make_dir_recursive_absolute(out_dir)
	root.size = Vector2i(1920, 1080)
	main = load("res://scenes/Main.tscn").instantiate()
	root.add_child(main)
	await _settle(8)
	main.act("newcareer")
	main.act("quick")
	await _settle(4)
	main.act("interview")
	main.act("pickcard", "signature")
	main.act("sign")
	main.act("go", "gym:1")
	main.act("hire", "reid")
	await process_frame
	main.act("go", "fighters:1")
	await _settle(4)
	main.on_go()
	main.on_go()
	main.run_to_stop()
	main.act("area", "home")
	await _settle(4)
	main.act("review")
	await _settle(80)
	main.act("close")
	main.act("fighter", "lucy")
	await _shot("overview_dark")
	FighterPage.dark_overview = false
	main.act("ftab", "0")
	await _shot("overview_cream")
	FighterPage.dark_overview = true
	print("DARK_STILL DONE")
	quit(0)


func _settle(frames: int) -> void:
	for i in frames:
		await process_frame


func _shot(name: String) -> void:
	await _settle(30)
	await RenderingServer.frame_post_draw
	var p := out_dir.path_join(name + ".png")
	root.get_texture().get_image().save_png(p)
	print("wrote ", p)
