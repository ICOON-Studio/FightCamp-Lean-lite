extends SceneTree
## S339 stills of the coach's plan on the game's own path: her page (the Fight plan button), her plan board (her punches,
## the coach's limit, one arrow a card), the fight's caption naming the arrow, and the corner card's PLAN row. Plays the
## real game from quick start; windowed on the never-shown desktop:
##   python tools/hidden_desktop.py run --timeout=300 <godot.exe> --path . --windowed --resolution 1920x1080 \
##       --script res://tools/plan_career_still.gd -- <out_dir>

const Bouts := preload("res://scripts/state/Bouts.gd")
const Map := preload("res://scripts/rules/StrikeMap.gd")

var out_dir := "user://plan_career_still"
var main: Node


func _initialize() -> void:
	var args := OS.get_cmdline_user_args()
	if not args.is_empty():
		out_dir = args[0]
	DirAccess.make_dir_recursive_absolute(out_dir)
	root.size = Vector2i(1920, 1080)
	main = load("res://scenes/Main.tscn").instantiate()
	root.add_child(main)
	await _settle(10)
	main.act("quick")
	main.act("interview")
	for card in ["Jab and move", "Pad rounds", "Hill sprints"]:
		main.act("pickcard", card)
	main.act("sign")
	main.act("hire", "reid")
	main.act("fighter", "lucy")
	await _shot("01_her_page")
	main.act("plan", "lucy")
	await _shot("02_plan_board_starter")
	# The coach answers a presser: double jab at long range (replaces the 1-2 there), step back from mid already planned.
	var board: Control = main.get_child(main.get_child_count() - 1)
	board.go("long")
	board._take(Map.move("1-1"), true)
	await _shot("03_plan_board_changed")
	board._save()
	await _settle(10)
	main.act("fighter", "lucy")
	await _shot("04_her_page_saved")
	var c: Career = main.career
	_run_until(func(): return not (c.fighter()["offers"] as Array).is_empty())
	var offers: Array = c.fighter()["offers"]
	var oid := ""
	for o in offers:
		if not bool(o.get("mismatch", false)) and oid == "":
			oid = str(o["id"])
	main.act("accept", oid)
	main.act("camp", "lucy")
	main.act("startcamp")
	_run_until(func(): return Bouts.weigh_in_today(c, c.fighter()))
	main.act("weighin", "lucy")
	main.act("doWeigh")
	main.run_to_stop()
	main.act("area", "home")
	main.act("go_btn")
	main.act("fightstep", "start")
	# The round plays in 3D: catch the first exchanges' captions (the arrow is named 1.6 s into each 30 s).
	for k in 4:
		await _wait_s(2.0 if k == 0 else 4.0)
		await _shot("05_fight_%d" % k)
	main.act("fightwatched", "1")
	await _settle(20)
	await _shot("06_corner_plan_row")
	quit(0)


func _run_until(until: Callable) -> void:
	var guard := 0
	while not until.call() and guard < 120:
		guard += 1
		if main.career.review_pending:
			main.act("review")
			main.act("close")
		main.run_to_stop(1)


func _wait_s(s: float) -> void:
	var t0 := Time.get_ticks_msec()
	while Time.get_ticks_msec() - t0 < int(s * 1000.0):
		await process_frame


func _settle(frames: int = 4) -> void:
	for i in frames:
		await process_frame


func _shot(name: String) -> void:
	await _settle()
	await RenderingServer.frame_post_draw
	var path := out_dir.path_join(name + ".png")
	root.get_texture().get_image().save_png(path)
	print("wrote ", path)
