extends SceneTree
## S490: stills of the TEST CLUB's menus (TestJump club4: Lucy, Kira, Josh + Ana, Reid hired) - Home, the Fighters list,
## each boxer's Overview and Training tab, the office, money, fights, the gym. For the operator to see every menu populated
## (his Q-246) and for the colour-palette sweep. Run on the never-shown desktop:
##   python tools/hidden_desktop.py run --timeout=400 --log=<file> <godot.exe> --path . --windowed --resolution 1920x1080 \
##       --audio-driver Dummy --script res://tools/club4_still.gd -- <out_dir>

const TestJump := preload("res://scripts/ui/TestJump.gd")

var main: Node
var out_dir := "user://club4_still"


func _initialize() -> void:
	var args := OS.get_cmdline_user_args()
	if not args.is_empty():
		out_dir = str(args[0])
	DirAccess.make_dir_recursive_absolute(out_dir)
	root.size = Vector2i(1920, 1080)
	main = load("res://scenes/Main.tscn").instantiate()
	root.add_child(main)
	await _wait(4)
	var ok := TestJump.run(main, "club4")
	var c: Career = main.career
	main.modal = {}
	for page in [["home", "home:0"], ["fighters", "fighters:0"], ["office", "office:0"], ["money", "money:0"], ["fights", "fights:0"], ["gym", "gym:1"]]:
		main.act("go", str(page[1]))
		await _shot(str(page[0]))
	for f in c.fighters:
		var fid := str((f as Dictionary)["id"])
		main.act("fighter", fid)
		main.act("ftab", "0")
		await _shot("%s_overview" % fid)
		main.act("ftab", "3")
		await _shot("%s_training" % fid)
	print("CLUB4_STILL wrote ", out_dir, " ok=", ok, " fighters=", c.fighters.size())
	quit(0)


func _shot(name: String) -> void:
	main.render()
	await create_timer(0.8).timeout
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png(out_dir.path_join(name + ".png"))


func _wait(frames: int) -> void:
	for i in frames:
		await process_frame
