extends SceneTree
## S337 a still of the boxing move map (run windowed on the hidden desktop): opens the screen, walks Outside > Step in > 1-2-3,
## saves <out>.png. Usage: python tools/hidden_desktop.py run <godot.exe> --path . --windowed --resolution 1920x1080
##   --script res://tools/strike_still.gd -- <out.png>

const Map := preload("res://scripts/rules/StrikeMap.gd")


func _initialize() -> void:
	var out := "user://strike_still.png"
	if not OS.get_cmdline_user_args().is_empty():
		out = OS.get_cmdline_user_args()[0]
	root.size = Vector2i(1920, 1080)
	var s: Control = load("res://scenes/dev/StrikeBrowser.tscn").instantiate()
	root.add_child(s)
	for i in 4:
		await process_frame
	s._take(Map.move("step_in"), true)
	s._take(Map.move("1-2-3"), true)
	for i in 6:
		await process_frame
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png(out)
	print("STRIKE_STILL ", out)
	quit(0)
