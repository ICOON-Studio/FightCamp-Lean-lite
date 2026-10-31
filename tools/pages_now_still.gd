extends SceneTree
## S329b: HOME and FIGHTERS stills from a mid-season career (TestJump "nationals": 5 bouts in, day 91), for the
## management-screens-as-pictures work. Run on the never-shown desktop:
##   python tools/hidden_desktop.py run --timeout=300 --log=<f> <godot.exe> --path . --windowed --resolution 1920x1080 \
##       --audio-driver Dummy --script res://tools/pages_now_still.gd -- <out_dir> [prefix]
## Prints PAGES_STILL lines.

const TestJump := preload("res://scripts/ui/TestJump.gd")

var main: Node
var out_dir := "user://pages_now_still"
var prefix := "now"


func _initialize() -> void:
	var args := OS.get_cmdline_user_args()
	if not args.is_empty():
		out_dir = str(args[0])
	if args.size() > 1:
		prefix = str(args[1])
	DirAccess.make_dir_recursive_absolute(out_dir)
	root.size = Vector2i(1920, 1080)
	main = load("res://scenes/Main.tscn").instantiate()
	root.add_child(main)
	await _wait(4)
	print("PAGES_STILL jump: ", TestJump.run(main, "nationals"))
	if not main.modal.is_empty():
		main.act("close")
	main.clear_toast()
	var f: Dictionary = main.career.fighter()
	for route in [["home:0", "home"], ["fighters:0", "fighters"], ["fighters:1", "fighters_training"]]:
		main.act("go", route[0])
		await _shot(prefix + "_" + route[1])
	main.act("fighter", str(f["id"]))
	await _shot(prefix + "_fighter_page")
	quit(0)


func _shot(name: String) -> void:
	main.render()
	await create_timer(0.6).timeout
	await RenderingServer.frame_post_draw
	var path := out_dir.path_join(name + ".png")
	root.get_texture().get_image().save_png(path)
	print("PAGES_STILL wrote ", path)


func _wait(n: int) -> void:
	for k in n:
		await process_frame
