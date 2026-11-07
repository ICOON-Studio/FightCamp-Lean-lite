extends SceneTree
## S396 truth pass: stills of the Settings page and the Handbook (all words, then a search) from a mid-season career.
##   python tools/hidden_desktop.py run --timeout=300 --log=<f> <godot.exe> --path . --windowed --resolution 1920x1080 \
##       --audio-driver Dummy --script res://tools/settings_handbook_still.gd -- <out_dir>
## Prints SH_STILL lines.

const TestJump := preload("res://scripts/ui/TestJump.gd")

var main: Node
var out_dir := "user://settings_handbook_still"


func _initialize() -> void:
	var args := OS.get_cmdline_user_args()
	if not args.is_empty():
		out_dir = str(args[0])
	DirAccess.make_dir_recursive_absolute(out_dir)
	root.size = Vector2i(1920, 1080)
	main = load("res://scenes/Main.tscn").instantiate()
	root.add_child(main)
	await _wait(4)
	print("SH_STILL jump: ", TestJump.run(main, "nationals"))
	if not main.modal.is_empty():
		main.act("close")
	main.clear_toast()
	main.act("settings")
	await _shot("settings")
	main.act("close")
	main.act("handbook")
	await _shot("handbook")
	var search: LineEdit = main.modal_node().find_child("Search", true, false)
	if search != null:
		search.text = "camp"
		search.text_changed.emit("camp")
	await _shot("handbook_search")
	quit(0)


func _shot(name: String) -> void:
	await create_timer(0.6).timeout
	await RenderingServer.frame_post_draw
	var path := out_dir.path_join(name + ".png")
	root.get_texture().get_image().save_png(path)
	print("SH_STILL wrote ", path)


func _wait(n: int) -> void:
	for k in n:
		await process_frame
