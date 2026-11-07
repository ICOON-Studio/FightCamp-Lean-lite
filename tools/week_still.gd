extends SceneTree
## S398 Week v8: stills of the Week tab for the blind re-score - the Saturday board (TestJump "nationals", no fight booked),
## the same with Wednesday morning's popover open, with Thursday evening's popover open, and a camp week (TestJump "camp").
##   python tools/hidden_desktop.py run --timeout=300 --log=<f> <godot.exe> --path . --windowed --resolution 1920x1080 \
##       --audio-driver Dummy --script res://tools/week_still.gd -- <out_dir>
## Prints WEEK_STILL lines.

const TestJump := preload("res://scripts/ui/TestJump.gd")
const WeekBoard := preload("res://scripts/ui/WeekBoard.gd")

var main: Node
var out_dir := "user://week_still"


func _initialize() -> void:
	var args := OS.get_cmdline_user_args()
	if not args.is_empty():
		out_dir = str(args[0])
	DirAccess.make_dir_recursive_absolute(out_dir)
	root.size = Vector2i(1920, 1080)
	main = load("res://scenes/Main.tscn").instantiate()
	root.add_child(main)
	await _wait(4)
	for jump in ["nationals", "camp"]:
		print("WEEK_STILL jump %s: %s" % [jump, TestJump.run(main, jump)])
		if not main.modal.is_empty():
			main.act("close")
		main.clear_toast()
		var f: Dictionary = main.career.fighter()
		main.act("fighter", str(f["id"]))
		main.act("ftab", "3")
		await _shot("week_" + jump)
		if jump == "nationals":
			WeekBoard.picking = "%s|2" % str(f["id"])
			await _shot("week_pop_morning")
			WeekBoard.picking = ""
			WeekBoard.picking_eve = "%s|3" % str(f["id"])
			await _shot("week_pop_evening")
			WeekBoard.picking_eve = ""
		else:
			main.act("ftab", "5")
			await _shot("prep_" + jump)
	quit(0)


func _shot(name: String) -> void:
	main.render()
	await create_timer(0.6).timeout
	await RenderingServer.frame_post_draw
	var path := out_dir.path_join(name + ".png")
	root.get_texture().get_image().save_png(path)
	print("WEEK_STILL wrote ", path)


func _wait(n: int) -> void:
	for k in n:
		await process_frame
