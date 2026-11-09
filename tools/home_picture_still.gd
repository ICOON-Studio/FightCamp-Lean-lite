extends SceneTree
## S414: Home with the owner's gym picture as the main screen, on the real route. Real pictures, on the hidden desktop:
##   python tools/hidden_desktop.py run --timeout=120 <godot.exe> --path . --windowed --resolution 1920x1080 --script res://tools/home_picture_still.gd -- <out_dir>


func _initialize() -> void:
	load("res://scripts/ui/MenuFx.gd").instant = true
	var out_dir := "user://home_picture"
	var args := OS.get_cmdline_user_args()
	if not args.is_empty():
		out_dir = args[0]
	DirAccess.make_dir_recursive_absolute(out_dir)
	root.size = Vector2i(1920, 1080)
	var main: Node = load("res://scenes/Main.tscn").instantiate()
	root.add_child(main)
	for i in 8:
		await process_frame
	main.act("newcareer")
	main.act("quick")
	for i in 40:
		await process_frame
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png(out_dir.path_join("home.png"))
	print("HOME_STILL DONE")
	quit(0)
