extends SceneTree
## S349 the training board's stills (Q-S294-72): her week on FIGHTERS > Training, as the player first sees it (main session
## conditioning) and after a click on "Make it her main" on the heavy bag (power). Real pictures only, on the never-shown
## desktop:
##   python tools/hidden_desktop.py run --timeout=180 <godot.exe> --path . --windowed --resolution 1920x1080 \
##       --log-file <log> --script res://tools/training_still.gd -- <out_dir>

const W := 1920
const H := 1080

var main: Node
var out_dir := "user://training"


func _initialize() -> void:
	var args := OS.get_cmdline_user_args()
	if not args.is_empty():
		out_dir = args[0]
	DirAccess.make_dir_recursive_absolute(out_dir)
	root.size = Vector2i(W, H)
	main = load("res://scenes/Main.tscn").instantiate()
	root.add_child(main)
	await _settle(8)
	main.act("newcareer")
	main.act("quick")
	main.act("interview")
	for card in ["Jab and move", "Pad rounds", "Hill sprints"]:
		main.act("pickcard", card)
	main.act("sign")
	main.act("hire", "reid")
	main.act("go", "fighters:1")
	await _shot("t1_training_week")
	var b := main.find_child("Main_heavy_bag_lucy", true, false) as Button
	print("TRAINING_STILL main button: %s" % (b != null))
	if b != null:
		b.pressed.emit()
	await _shot("t2_heavy_bag_main")
	quit(0)


func _settle(frames: int = 6) -> void:
	for i in frames:
		await process_frame


func _shot(name: String) -> void:
	await _settle()
	await RenderingServer.frame_post_draw
	var path := out_dir.path_join(name + ".png")
	root.get_texture().get_image().save_png(path)
	print("wrote ", path)
