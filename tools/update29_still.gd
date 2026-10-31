extends SceneTree
## S327 update 29 stills: TestJump "injury" -> the pull-out-or-fight-hurt choice; TestJump "fight" -> HOME (the needs list,
## a waiting sponsor) and her Training page (the load row in camp), then SKIP BOUT -> the result page with the body report.
## Run on the never-shown desktop:
##   python tools/hidden_desktop.py run --timeout=300 --log=<f> <godot.exe> --path . --windowed --resolution 1920x1080 \
##       --audio-driver Dummy --script res://tools/update29_still.gd -- <out_dir>
## Prints UPDATE29_STILL lines.

const TestJump := preload("res://scripts/ui/TestJump.gd")
const Needs := preload("res://scripts/state/Needs.gd")

var main: Node
var out_dir := "user://update29_still"


func _initialize() -> void:
	var args := OS.get_cmdline_user_args()
	if not args.is_empty():
		out_dir = str(args[0])
	DirAccess.make_dir_recursive_absolute(out_dir)
	root.size = Vector2i(1920, 1080)
	main = load("res://scenes/Main.tscn").instantiate()
	root.add_child(main)
	await _wait(4)
	print("UPDATE29_STILL injury jump: ", TestJump.run(main, "injury"))
	print("UPDATE29_STILL choice: ", str(main.modal.get("body", "")).replace("\n", " | "))
	await _shot("injury_choice")
	main.queue_free()
	await _wait(2)
	main = load("res://scenes/Main.tscn").instantiate()
	main.save_path = "user://update29_still.save"   # never the player's own save
	root.add_child(main)
	await _wait(4)
	main.act("quick")
	main.act("interview")
	for card in ["Jab and move", "Pad rounds", "Hill sprints"]:
		main.act("pickcard", card)
	main.act("sign")
	main.act("hire", "reid")
	if not main.modal.is_empty():
		main.act("close")
	print("UPDATE29_STILL needs: ", str(Needs.needs(main.career).map(func(x): return x["t"])))
	main.act("go", "home:0")
	await _shot("home_needs")
	main.act("go", "fighters:1")
	await _shot("training_load")
	main.queue_free()
	await _wait(2)
	main = load("res://scenes/Main.tscn").instantiate()
	root.add_child(main)
	await _wait(4)
	print("UPDATE29_STILL fight jump: ", TestJump.run(main, "fight"))
	await _wait(4)
	main.act("fightstep", "start")
	var view: Node = main._fight_layer.get_child(0) if main._fight_layer.get_child_count() > 0 else null
	if view != null:
		await _wait(2)
		for ch in view.get_children():
			if ch.has_method("cue_touch"):
				ch.finish()
		await _until(func(): return bool(view.playing), 60.0)
		view.skip_bout()
	else:
		main.act("fightstep", "sim")
	await _until(func(): return str(main.modal.get("step", "")) == "result", 30.0)
	print("UPDATE29_STILL body report: %s | %s" % [str(main.modal.get("body_report", {})), str(main.modal.get("body_change", ""))])
	print("UPDATE29_STILL track: %s | map keys %s" % [str(main.modal.get("body_track", {})), str((main.modal.get("body_map", {}) as Dictionary).keys())])
	main.redraw_modal()
	await _shot("result_body_report")
	quit(0)


func _shot(name: String) -> void:
	await create_timer(0.6).timeout
	await RenderingServer.frame_post_draw
	var path := out_dir.path_join(name + ".png")
	root.get_texture().get_image().save_png(path)
	print("UPDATE29_STILL wrote ", path)


func _wait(n: int) -> void:
	for k in n:
		await process_frame


func _until(cond: Callable, max_s: float) -> void:
	var left := max_s
	while left > 0.0 and not cond.call():
		await process_frame
		left -= 1.0 / 30.0
