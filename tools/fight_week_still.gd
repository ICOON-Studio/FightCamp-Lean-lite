extends SceneTree
## S481 FIGHTWEEK2: stills of the two fight week screens as the game draws them - quick start, sign, coach, the first even
## club-show bout booked with a preset plan plus one line written after the booking, then the FIGHT WEEK screen (Frame A,
## the assistant's pick) and the sparring partner screen for a 6-days-out night (Frame B).
## Run on the never-shown desktop:
##   python tools/hidden_desktop.py run --timeout=300 <godot.exe> --path . --windowed --resolution 1920x1080 \
##       --audio-driver Dummy --script res://tools/fight_week_still.gd -- <out_dir>

const TestJump := preload("res://scripts/ui/TestJump.gd")
const PlanTemplates := preload("res://scripts/rules/PlanTemplates.gd")

var main: Node
var out_dir := "user://fight_week_still"


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
	var c: Career = main.career
	c.seed = 1
	c.first_hour = {}
	main.act("interview")
	for card in ["Jab and move", "Pad rounds", "Hill sprints"]:
		main.act("pickcard", card)
	main.act("sign")
	main.act("hire", "reid")
	var f: Dictionary = c.fighter()
	for i in 60:
		if not (f["offers"] as Array).is_empty():
			break
		TestJump._tidy(main, c)
		main.run_to_stop()
	for o in f["offers"]:
		if not bool(o["mismatch"]):
			f["arrows"] = PlanTemplates.load(PlanTemplates.BOXING[0], 6)
			main.act("accept", str(o["id"]))
			break
	if not main.modal.is_empty():
		main.act("close")
	var fresh: Dictionary = (f["arrows"][0] as Dictionary).duplicate()
	fresh["when"] = "press"
	(f["arrows"] as Array).append(fresh)
	main.act("fightweek", str(f["id"]))
	await _shot("fight_week_frame_a_real.png")
	if (main.modal["plan"]["nights"] as Dictionary).has(6):
		main.act("fwpartnerof", "6")
	else:
		main.act("fwnight", "6")
	await _shot("fight_week_frame_b_real.png")
	print("FIGHT_WEEK_STILL wrote ", out_dir)
	quit(0)


func _shot(name: String) -> void:
	await create_timer(0.8).timeout
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png(out_dir.path_join(name))


func _wait(n: int) -> void:
	for k in n:
		await process_frame
