extends SceneTree
## S369 the fight HUD as a picture (operator: "also add numbers here?" on the ring of arcs): TestJump "fight" -> start ->
## the ring entrance skipped -> SECONDS of live fighting -> a shot of the whole screen and a crop of each corner's rings.
##   python tools/hidden_desktop.py run --timeout=200 --log=<f> <godot.exe> --path . --windowed --resolution 1920x1080 \
##       --audio-driver Dummy --script res://tools/hud_still.gd -- <out_dir>
## Prints HUD_STILL lines.

const TestJump := preload("res://scripts/ui/TestJump.gd")
const SECONDS := 40.0

var main: Node
var out_dir := "user://hud_still"


func _initialize() -> void:
	var args := OS.get_cmdline_user_args()
	if not args.is_empty():
		out_dir = str(args[0])
	DirAccess.make_dir_recursive_absolute(out_dir)
	root.size = Vector2i(1920, 1080)
	main = load("res://scenes/Main.tscn").instantiate()
	root.add_child(main)
	await _wait(4)
	print("HUD_STILL fight jump: ", TestJump.run(main, "fight"))
	await _wait(4)
	main.act("fightstep", "start")
	var view: Node = main._fight_layer.get_child(0)
	await _wait(2)
	for ch in view.get_children():
		if ch.has_method("cue_touch"):
			ch.finish()
	await create_timer(SECONDS).timeout
	await RenderingServer.frame_post_draw
	var img := root.get_texture().get_image()
	img.save_png(out_dir.path_join("hud_full.png"))
	img.get_region(Rect2i(0, 0, 260, 260)).save_png(out_dir.path_join("hud_red_rings.png"))
	img.get_region(Rect2i(1660, 0, 260, 260)).save_png(out_dir.path_join("hud_blue_rings.png"))
	print("HUD_STILL wrote ", out_dir)
	quit(0)


func _wait(n: int) -> void:
	for k in n:
		await process_frame
