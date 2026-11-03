extends SceneTree
## S371 GOALTESTS1 phase 2: a still of her Training tab with the award road and the records wall - quick start, sign
## the walk-in, three Sundays (the first writes the wall, a faster week beats a best), then her page's Training tab.
## Run on the never-shown desktop:
##   python tools/hidden_desktop.py run --timeout=300 <godot.exe> --path . --windowed --resolution 1920x1080 \
##       --audio-driver Dummy --script res://tools/award_still.gd -- <out_dir>

const TRAINING_TAB := "3"

var main: Node
var out_dir := "user://award_still"


func _initialize() -> void:
	var args := OS.get_cmdline_user_args()
	if not args.is_empty():
		out_dir = str(args[0])
	DirAccess.make_dir_recursive_absolute(out_dir)
	root.size = Vector2i(1920, 1080)
	main = load("res://scenes/Main.tscn").instantiate()
	root.add_child(main)
	await _wait(4)
	main.act("quick")
	main.career.seed = 1
	main.act("go_btn")
	for card in ["Jab and move", "Pad rounds", "Hill sprints"]:
		main.act("pickcard", card)
	var m: Node = main.modal_node()
	var sign: Button = null if m == null else m.find_child("Sign", true, false) as Button
	if sign != null:
		sign.emit_signal("pressed")
	var c: Career = main.career
	for week in 3:
		if week == 2:
			c.fighters[0]["stats"]["speed"] = float(c.fighters[0]["stats"]["speed"]) + 4.0   # a sharper week: a best falls
		for i in 8:
			main.run_to_stop()
			if c.review_pending:
				main.act("review")
				main.act("close")
				break
			if not main.modal.is_empty():
				main.act("close")
	main.act("fighter", str(c.fighters[0]["id"]))
	main.act("ftab", TRAINING_TAB)
	main.render()
	await create_timer(0.8).timeout
	await RenderingServer.frame_post_draw
	var p := out_dir.path_join("award_training_tab.png")
	root.get_texture().get_image().save_png(p)
	print("AWARD_STILL wrote ", p, " bests=", c.fighters[0].get("bests", {}))
	quit(0)


func _wait(n: int) -> void:
	for k in n:
		await process_frame
