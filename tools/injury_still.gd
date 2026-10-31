extends SceneTree
## S325 update 28 stills: TestJump "injury" (in camp, a hand injury pulls her out) -> her fighter page and the roster;
## then TestJump "fight" -> SKIP BOUT -> the result page with an injury on the ribbon (a hand injury is put on her for the
## picture when the bout's own roll left her fit - the caption says so). Run on the never-shown desktop:
##   python tools/hidden_desktop.py run --timeout=300 --log=<f> <godot.exe> --path . --windowed --resolution 1920x1080 \
##       --audio-driver Dummy --script res://tools/injury_still.gd -- <out_dir>
## Prints INJURY_STILL lines.

const TestJump := preload("res://scripts/ui/TestJump.gd")
const Injuries := preload("res://scripts/state/Injuries.gd")

var main: Node
var out_dir := "user://injury_still"


func _initialize() -> void:
	var args := OS.get_cmdline_user_args()
	if not args.is_empty():
		out_dir = str(args[0])
	DirAccess.make_dir_recursive_absolute(out_dir)
	root.size = Vector2i(1920, 1080)
	main = load("res://scenes/Main.tscn").instantiate()
	root.add_child(main)
	await _wait(4)
	print("INJURY_STILL injury jump: ", TestJump.run(main, "injury"))
	main.render()
	await _shot("fighter_page_injured")
	main.act("go", "fighters:0")
	await _shot("roster_injured")
	main.queue_free()
	await _wait(2)
	main = load("res://scenes/Main.tscn").instantiate()
	root.add_child(main)
	await _wait(4)
	print("INJURY_STILL fight jump: ", TestJump.run(main, "fight"))
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
	var f: Dictionary = main.career.fighter()
	var forced: bool = not main.modal.has("injury")
	if forced:
		Injuries._hurt(main.career, f, {"type": "hand", "days_out": 35}, "in the fight")
		main.modal["injury"] = Injuries.line(main.career, f)
	print("INJURY_STILL result injury: %s (forced for the picture: %s)" % [main.modal["injury"], forced])
	main.redraw_modal()
	await _shot("result_page_injury")
	quit(0)


func _shot(name: String) -> void:
	await create_timer(0.6).timeout
	await RenderingServer.frame_post_draw
	var path := out_dir.path_join(name + ".png")
	root.get_texture().get_image().save_png(path)
	print("INJURY_STILL wrote ", path)


func _wait(n: int) -> void:
	for k in n:
		await process_frame


func _until(cond: Callable, max_s: float) -> void:
	var left := max_s
	while left > 0.0 and not cond.call():
		await process_frame
		left -= 1.0 / 30.0
