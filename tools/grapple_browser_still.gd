extends SceneTree
## S335 stills of the ground-move browser as the player sees it: mount with its moves in/out, a move OUT half way, the
## position it lands on, then a move IN. Real pictures only (the never-shown desktop):
##   python tools/hidden_desktop.py run --timeout=240 <godot.exe> --path . --windowed --resolution 1920x1080 \
##       --script res://tools/grapple_browser_still.gd -- <out_dir>

var out_dir := "user://grapple_browser"


func _initialize() -> void:
	var args := OS.get_cmdline_user_args()
	if not args.is_empty():
		out_dir = args[0]
	DirAccess.make_dir_recursive_absolute(out_dir)
	root.size = Vector2i(1920, 1080)
	var b: Control = load("res://scenes/dev/GrappleBrowser.tscn").instantiate()
	root.add_child(b)
	for i in 30:
		await process_frame
	await _shot("b01_mount")
	var outs: Array = b.graph.outs(b.current)
	print("BROWSER mount outs=%d ins=%d" % [outs.size(), b.graph.ins(b.current).size()])
	b.play_out(outs[0])
	await _wait(b.player.length_s() * 0.5)
	await _shot("b02_move_out_half")
	await _wait(b.player.length_s() * 0.5 + 0.5)
	await _shot("b03_landed")
	var ins: Array = b.graph.ins(b.current)
	if not ins.is_empty():
		b.play_in(ins[0])
		await _wait(b.player.length_s() * 0.5)
		await _shot("b04_move_in_half")
	quit(0)


func _wait(s: float) -> void:
	var t := 0.0
	while t < s:
		t += await _frame_dt()


func _frame_dt() -> float:
	var a := Time.get_ticks_msec()
	await process_frame
	return (Time.get_ticks_msec() - a) / 1000.0


func _shot(name: String) -> void:
	for i in 4:
		await process_frame
	await RenderingServer.frame_post_draw
	var path := out_dir.path_join(name + ".png")
	root.get_texture().get_image().save_png(path)
	print("wrote ", path)
