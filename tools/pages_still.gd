extends SceneTree
## S323 the round and result pages (operator Q-S294-40 "Layout looks cheap / like a spreadsheet"): plays to fight night
## (TestJump "fight"), starts the bout, SKIP BOUT, then saves the result page and the last round's page over the ring.
## Run on the never-shown desktop:
##   python tools/hidden_desktop.py run --timeout=300 --log=<f> <godot.exe> --path . --windowed --resolution 1920x1080 \
##       --audio-driver Dummy --script res://tools/pages_still.gd -- <out_dir>
## Prints PAGES lines.

const TestJump := preload("res://scripts/ui/TestJump.gd")

var main: Node
var out_dir := "user://pages_still"


func _initialize() -> void:
	var args := OS.get_cmdline_user_args()
	if not args.is_empty():
		out_dir = str(args[0])
	DirAccess.make_dir_recursive_absolute(out_dir)
	root.size = Vector2i(1920, 1080)
	main = load("res://scenes/Main.tscn").instantiate()
	root.add_child(main)
	await _wait(4)
	print("PAGES reached fight night: ", TestJump.run(main, "fight"))
	await _wait(4)
	main.act("fightstep", "start")
	var view: Node = main._fight_layer.get_child(0)
	await _wait(2)
	for ch in view.get_children():
		if ch.has_method("cue_touch"):
			ch.finish()
	await _until(func(): return bool(view.playing), 60.0)
	view.skip_bout()
	await _until(func(): return str(main.modal.get("step", "")) == "result", 30.0)
	print("PAGES step ", main.modal.get("step", ""))
	await _shot("result_page")
	main.modal["step"] = "round"
	main.redraw_modal()
	await _shot("round_page")
	quit(0)


func _shot(name: String) -> void:
	await create_timer(0.5).timeout
	await RenderingServer.frame_post_draw
	var path := out_dir.path_join(name + ".png")
	root.get_texture().get_image().save_png(path)
	print("PAGES wrote ", path)


func _wait(n: int) -> void:
	for k in n:
		await process_frame


func _until(cond: Callable, max_s: float) -> void:
	var left := max_s
	while left > 0.0 and not cond.call():
		await process_frame
		left -= 1.0 / 30.0
