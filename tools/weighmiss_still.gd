extends SceneTree
## S539 the pro weigh-in miss pop-up, from the real game: quick start, sign, make her a pro 0.4 kg over with a weigh-in today,
## Weigh in -> Step on the scale -> the other corner's answer.
##   python tools/hidden_desktop.py run --timeout=180 <godot.exe> --path . --windowed --resolution 1920x1080 \
##       --audio-driver Dummy --script res://tools/weighmiss_still.gd -- <out_dir>

const Data := preload("res://scripts/state/Data.gd")

var main: Node
var out_dir := "user://weighmiss"


func _initialize() -> void:
	load("res://scripts/ui/MenuFx.gd").instant = true
	var args := OS.get_cmdline_user_args()
	if not args.is_empty():
		out_dir = str(args[0])
	DirAccess.make_dir_recursive_absolute(out_dir)
	root.size = Vector2i(1920, 1080)
	main = load("res://scenes/Main.tscn").instantiate()
	root.add_child(main)
	await _wait(4)
	main.act("quick")
	main.act("interview")
	for card in ["Jab and move", "Pad rounds", "Hill sprints"]:
		main.act("pickcard", card)
	main.act("sign")
	var c: Career = main.career
	c.guide = ""
	var f: Dictionary = c.fighters[0]
	f["pro"] = true
	f["weight"] = float(f["limit"]) + 0.4
	f["bout"] = {"opp": (Data.OPPONENTS[1] as Dictionary).duplicate(true), "day": c.day + 1, "weighed": false, "made": false,
		"done": false, "purse": 1800}
	main.act("weighin", str(f["id"]))
	await _shot("weighmiss_1_scale")
	main.act("doWeigh")
	await _shot("weighmiss_2_answer")
	main.act("missBox")
	await _shot("weighmiss_3_boxed")
	print("WEIGHMISS bout purse ", f["bout"].get("purse", -1), " missed_weight ", f["bout"].get("missed_weight", false))
	quit(0)


func _shot(name: String) -> void:
	await _wait(8)
	await create_timer(0.6).timeout
	if DisplayServer.get_name() == "headless":
		print("WEIGHMISS_STILL (headless, no picture) ", name)
		return
	await RenderingServer.frame_post_draw
	var p := out_dir.path_join(name + ".png")
	root.get_texture().get_image().save_png(p)
	print("WEIGHMISS_STILL wrote ", p)


func _wait(n: int) -> void:
	for k in n:
		await process_frame
