extends SceneTree
## S415 a still of what waits under the gym on Home. On the hidden desktop: --script res://tools/home_below_still.gd -- <out.png>

const MAIN := preload("res://scenes/Main.tscn")


func _initialize() -> void:
	var args := OS.get_cmdline_user_args()
	var main := MAIN.instantiate()
	root.add_child(main)
	await process_frame
	main.act("quick")
	for i in 30:
		await process_frame
	(main.find_child("HomeMore", true, false) as Button).pressed.emit()
	for i in 30:
		await process_frame
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png(args[0] if args.size() > 0 else "user://home_below.png")
	quit(0)
