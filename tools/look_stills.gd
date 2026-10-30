extends SceneTree
## S317 look stills (operator, on a reference boxing game's video: "look how much better their game looks", "can you
## reach their level"): plays the build to fight night (TestJump "fight", the game's own camera) and saves a still at
## each of AT_S round-1 times, so a lighting / camera change is judged before and after on the same moments.
##   python tools/hidden_desktop.py run --timeout=400 <godot.exe> --path . --windowed --resolution 1920x1080 \
##       --audio-driver Dummy --fixed-fps 30 --script res://tools/look_stills.gd -- <out_dir> [<prefix>]

const TestJump := preload("res://scripts/ui/TestJump.gd")
const AT_S := [6.0, 14.0, 23.0, 37.0, 52.0, 68.0]

var main: Node
var view: Node


func _initialize() -> void:
	var args := OS.get_cmdline_user_args()
	var out_dir: String = args[0] if args.size() > 0 else "user://look"
	var prefix: String = args[1] if args.size() > 1 else "look"
	DirAccess.make_dir_recursive_absolute(out_dir)
	root.size = Vector2i(1920, 1080)
	main = load("res://scenes/Main.tscn").instantiate()
	root.add_child(main)
	await _wait(4)
	print("LOOK reached fight night: ", TestJump.run(main, "fight"))
	await _wait(4)
	main.act("fightstep", "start")
	view = main._fight_layer.get_child(0)
	await _until(func(): return bool(view.playing), 120.0)
	for at in AT_S:
		await _until(func(): return not bool(view.playing) or float(view.t) >= float(at), 120.0)
		await RenderingServer.frame_post_draw
		var path := out_dir.path_join("%s_%02d.png" % [prefix, int(at)])
		root.get_texture().get_image().save_png(path)
		print("LOOK wrote ", path)
	quit(0)


func _wait(n: int) -> void:
	for k in n:
		await process_frame


func _until(cond: Callable, max_s: float) -> void:
	var left := max_s
	while left > 0.0 and not cond.call():
		await process_frame
		left -= 1.0 / 30.0
