extends SceneTree
## S533 P4PBUILD1 stage 3 stills, THE COACH'S READ: the offer card, the bout's versus, the bout's report, and a pro row.
## Run on the never-shown desktop:
##   python tools/hidden_desktop.py run --timeout=300 <godot.exe> --path . --windowed --resolution 1920x1080 \
##       --audio-driver Dummy --script res://tools/p4p_coach_read_still.gd -- <out_dir>

const Sim := preload("res://scripts/state/Sim.gd")
const VersusPanel := preload("res://scripts/ui/VersusPanel.gd")
const TestJump := preload("res://scripts/ui/TestJump.gd")

var main: Node
var out_dir := "user://p4p_coach_read_still"


func _initialize() -> void:
	var args := OS.get_cmdline_user_args()
	if not args.is_empty():
		out_dir = str(args[0])
	DirAccess.make_dir_recursive_absolute(out_dir)
	root.size = Vector2i(1920, 1080)
	main = load("res://scenes/Main.tscn").instantiate()
	root.add_child(main)
	for k in 4:
		await process_frame
	main.act("quick")
	main.act("interview")
	main.act("pickcard", "signature")
	main.act("sign")
	main.act("hire", "reid")
	await process_frame
	var c: Career = main.career
	c.guide = ""
	c.first_hour = {}
	var id := ""
	for i in 120:
		for f in c.fighters:
			for o in f.get("offers", []):
				if not bool(o["answered"]) and not bool(o["mismatch"]) and id == "":
					id = str(o["id"])
		if id != "":
			break
		Sim.step_day(c)
		c.review_pending = false
	main.clear_toast()
	main.act("go", "fights:0")
	await _shot("read_1_offer_card")
	main.act("openBout", id)
	await _shot("read_2_versus")
	VersusPanel.show_report(main, id)
	await _shot("read_3_report")
	VersusPanel.show_report(main, "")
	main.queue_free()
	await process_frame
	main = load("res://scenes/Main.tscn").instantiate()
	root.add_child(main)
	for k in 4:
		await process_frame
	TestJump.run(main, "proladder")
	main.act("go", "fights:0")
	await _shot("read_4_pro_rows")
	quit(0)

func _shot(name: String) -> void:
	await create_timer(0.8).timeout
	await RenderingServer.frame_post_draw
	var p := out_dir.path_join(name + ".png")
	root.get_texture().get_image().save_png(p)
	print("P4P_VISIT_STILL wrote ", p)
