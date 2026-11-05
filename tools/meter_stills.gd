extends SceneTree
## S375 (operator: "these long line meters do not look good at all in your menus"): stills of every menu that carries a
## meter - Danny's Training tab (awards + combo planner), his Attributes tab, the week review, Ana's page, Money.
## Run on the never-shown desktop:
##   python tools/hidden_desktop.py run --timeout=400 <godot.exe> --path . --windowed --resolution 1920x1080 \
##       --audio-driver Dummy --script res://tools/meter_stills.gd -- <out_dir>

const TestJump := preload("res://scripts/ui/TestJump.gd")
const OwnCombos := preload("res://scripts/rules/OwnCombos.gd")

var main: Node
var out_dir := "user://meter_stills"


func _initialize() -> void:
	var args := OS.get_cmdline_user_args()
	if not args.is_empty():
		out_dir = str(args[0])
	DirAccess.make_dir_recursive_absolute(out_dir)
	root.size = Vector2i(1920, 1080)
	main = load("res://scenes/Main.tscn").instantiate()
	root.add_child(main)
	await _wait(4)
	print("JUMP ", TestJump.run(main, "men"))
	var c: Career = main.career
	var f: Dictionary = c.fighter_by_id("danny")
	f["book"] = [{"name": "jab, jab, step in, lead hook", "chain": ["jab", "jab", "step_in", "lead_hook"], "score": 76},
		{"name": "slip, cross, lead hook, step back", "chain": ["slip", "cross", "lead_hook", "step_back"], "score": 80}]
	OwnCombos.ensure_ids(f)
	f["own_combos"] = {"own:1": 88.0, "own:2": 41.0}
	f["combo_learning"] = "own:2"
	if not main.modal.is_empty():
		main.act("close")
	main.act("fighter", "danny")
	main.act("ftab", "3")
	await _shot("m1_training.png", "DrillTray")
	main.act("ftab", "1")
	await _shot("m2_attributes.png", "")
	main.act("ftab", "0")
	await _shot("m3_overview.png", "")
	main.act("fighter", "ana")
	await _shot("m4_ana.png", "")
	main.act("go", "money:0")
	await _shot("m5_money.png", "")
	for i in 14:
		if c.review_pending:
			break
		main.run_to_stop()
		if not main.modal.is_empty() and str(main.modal.get("type", "")) != "review":
			main.act("close")
	main.act("review")
	await create_timer(5.0).timeout
	await _shot("m6_review.png", "")
	quit(0)


func _shot(name: String, focus: String) -> void:
	if name != "m6_review.png":
		main.render()
	await create_timer(0.6).timeout
	if focus != "":
		var card := root.find_child(focus, true, false) as Control
		var p: Node = card.get_parent() if card != null else null
		while p != null and not (p is ScrollContainer):
			p = p.get_parent()
		if p != null:
			(p as ScrollContainer).ensure_control_visible(card)
	main.clear_toast()
	await create_timer(0.8).timeout
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png(out_dir.path_join(name))
	print("STILL ", name)


func _wait(frames: int) -> void:
	for i in frames:
		await process_frame
