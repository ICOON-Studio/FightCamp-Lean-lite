extends SceneTree
## S349 PLAYBOOK > Combos stills: her book's 1-2 plus a slip (flows), her body mid-chain; then an uppercut she has not
## learned added (the amber "pad time first"). Real pictures on the never-shown desktop:
##   python tools/hidden_desktop.py run --timeout=200 <godot.exe> --path . --windowed --resolution 1920x1080 \
##       --log-file <log> --script res://tools/combos_still.gd -- <out_dir>

const CB := preload("res://scripts/ui/ComboBuilder.gd")
var main: Node
var out_dir := "user://combos"


func _initialize() -> void:
	var args := OS.get_cmdline_user_args()
	if not args.is_empty():
		out_dir = args[0]
	DirAccess.make_dir_recursive_absolute(out_dir)
	root.size = Vector2i(1920, 1080)
	main = load("res://scenes/Main.tscn").instantiate()
	root.add_child(main)
	await _settle(8)
	main.act("newcareer")
	main.act("quick")
	main.act("interview")
	for card in ["Jab and move", "Pad rounds", "Hill sprints"]:
		main.act("pickcard", card)
	main.act("sign")
	CB.chain = []
	main.act("go", "playbook:2")
	await _settle(10)
	(main.find_child("Book_1-2", true, false) as Button).pressed.emit()
	(main.find_child("Try_slip", true, false) as Button).pressed.emit()
	await _wait(0.75)
	await _shot("c1_one_two_slip")
	(main.find_child("Try_rear_uppercut", true, false) as Button).pressed.emit()
	await _wait(1.1)
	await _shot("c2_uppercut_not_learned")
	quit(0)


func _settle(frames: int) -> void:
	for i in frames:
		await process_frame


func _wait(s: float) -> void:
	await create_timer(s).timeout


func _shot(n: String) -> void:
	await RenderingServer.frame_post_draw
	var p := out_dir.path_join(n + ".png")
	root.get_texture().get_image().save_png(p)
	print("wrote ", p)
