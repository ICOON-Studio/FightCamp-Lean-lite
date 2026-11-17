extends SceneTree
## S511 stills of the FIGHT ANALYSIS page as the game opens it now (FIGHTFILM1 slices 7-9): the result page's PUNCH BY
## PUNCH on a boxed bout, and Fight prep's Watch the tape on the opponent's films. Windowed, on the hidden desktop:
##   python tools/hidden_desktop.py run --timeout=240 <godot.exe> --path . --windowed --resolution 1920x1080
##     --script res://tools/fight_analysis_still.gd -- <out_dir>
## Writes <out_dir>/own_bout_real.png and watch_tape_real.png.

const TestJump := preload("res://scripts/ui/TestJump.gd")
const PlanTemplates := preload("res://scripts/rules/PlanTemplates.gd")
const Bouts := preload("res://scripts/state/Bouts.gd")
const ResultPage := preload("res://scripts/ui/ResultPage.gd")
const FightAnalysisTape := preload("res://scripts/ui/FightAnalysisTape.gd")

var main: Node


func _initialize() -> void:
	var args := OS.get_cmdline_user_args()
	var out := str(args[0]) if args.size() > 0 else "E:/FightCamp/tmp/fa_still"
	DirAccess.make_dir_recursive_absolute(out)
	root.size = Vector2i(1920, 1080)
	main = load("res://scenes/Main.tscn").instantiate()
	root.add_child(main)
	await process_frame
	var f := _book()
	if f.is_empty():
		print("STILL no bout booked")
		quit(1)
		return
	var c: Career = main.career
	var opp: Dictionary = f["bout"]["opp"]
	opp["w"] = 3
	opp["l"] = 1
	var watch: Node = FightAnalysisTape.watch(main, c, f)
	await _shot(out + "/watch_tape_real.png")
	if watch != null:
		watch.queue_free()
	f["habits"] = ["drops_right_after_jab"]
	f["bout"]["weighed"] = true
	f["bout"]["made"] = true
	var m := {"fid": str(f["id"]), "step": "tape", "round": 0, "rounds": [], "total": 3, "type": "fight"}
	Bouts.fight_step(c, f, m, "start")
	Bouts.fight_step(c, f, m, "rest")
	var page: Node = ResultPage.punches(main, m)
	await _shot(out + "/own_bout_real.png")
	print("STILL done ", page != null)
	quit(0)


func _shot(path: String) -> void:
	for i in 8:
		await process_frame
	var img := root.get_texture().get_image()
	img.save_png(path)
	print("STILL ", path)


func _book() -> Dictionary:
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
			return f
	return {}
