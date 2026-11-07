extends SceneTree
## S397 rank 5: a still of every first-hour screen, played from the title as a player would, for the blind review
## (ops/research/RANK5_FIRST_HOUR_S397.md section 7; the cut_pages_still.gd pattern).
##   python tools/hidden_desktop.py run --timeout=300 --log=<f> <godot.exe> --path . --windowed --resolution 1920x1080 \
##       --audio-driver Dummy --script res://tools/first_hour_still.gd -- <out_dir> no3d
## (S398 round 4: no3d plays fight night in words, so the first fight, its result and the Why are real, not faked.)
## Prints FIRST_STILL lines. Writes 01_title .. 10_second_walkin.

var main: Node
var out_dir := "user://first_hour_still"


func _initialize() -> void:
	var args := OS.get_cmdline_user_args()
	if not args.is_empty():
		out_dir = str(args[0])
	DirAccess.make_dir_recursive_absolute(out_dir)
	root.size = Vector2i(1920, 1080)
	main = load("res://scenes/Main.tscn").instantiate()
	root.add_child(main)
	await _wait(4)
	main.quiet_moments = true
	await _shot("01_title")
	main.act("newcareer")
	main.act("cpick", "coach|oldhand")
	await _shot("02_you")
	main.act("cstep", "1")
	main.act("cpick", "start|fresh")
	await _shot("03_your_club")
	main.act("cstart", "Anvil Street Gym")
	var c: Career = main.career
	c.seed = 1
	main.clear_toast()
	await _shot("04_home_job")
	main.on_go()
	main.act("pickcard", "habit")
	await _shot("05_walkin")
	main.act("sign")
	main.clear_toast()
	main.on_go()
	await _shot("06_people_hire")
	main.act("hire", "reid")
	main.clear_toast()
	main.act("go", "gym:1")
	await _shot("07_people_you")
	main.on_go()
	main.act("diet", "%s|cut" % str(c.fighter()["id"]))   # the guided week 1: start the cut (the coach line's Do it)
	main.on_go()
	main.act("area", "home")
	main.run_to_stop()
	if c.review_pending:
		main.act("review")
		main.act("close")
	main.clear_toast()
	await _shot("08_home_week2_offer")
	main.on_go()
	await _shot("09_show_offer")
	var b: Button = main.find_child("Accept", true, false) as Button
	if b != null:
		b.emit_signal("pressed")
	if not main.modal.is_empty():
		main.act("close")
	main.clear_toast()
	main.nav({"area": "fighters", "tab": 0, "fighter": str(c.fighter()["id"]), "ftab": 5})
	await _shot("10_fight_prep")
	main.act("camp")   # S398 round 3: the camp is set before the plan, as the guide asks
	var sc: Button = main.find_child("StartCamp", true, false) as Button
	if sc != null:
		sc.emit_signal("pressed")
	if not main.modal.is_empty():
		main.act("close")
	main.clear_toast()
	main.nav({"area": "fighters", "tab": 0, "fighter": str(c.fighter()["id"]), "ftab": 7, "ptab": 1})
	await _shot("10b_playbook_plan")
	# To the show: the weeks run, the weigh-in, fight night in words (two corner calls), the result and the Why, then Monday.
	var f: Dictionary = c.fighter()
	for k in 6:
		if load("res://scripts/state/Bouts.gd").weigh_in_today(c, f):
			break
		main.run_to_stop()
		if c.review_pending:
			main.act("review")
			main.act("close")
	main.act("go_btn")
	var scale: Button = main.find_child("Scale", true, false) as Button
	if scale != null:
		scale.emit_signal("pressed")
	await _shot("10c_weigh_in")
	main.act("close")
	main.run_to_stop()
	main.act("go_btn")
	for step in ["Begin", "Corner_long", "Corner_body", "Scorecards"]:
		for k in 6:
			var sb: Button = main.find_child("Shout_*", true, false) as Button
			if sb == null:
				break
			sb.emit_signal("pressed")
		var nb: Button = main.find_child(step, true, false) as Button
		if nb != null:
			nb.emit_signal("pressed")
	await _shot("10d_result_why")
	var home: Button = main.find_child("BackHome", true, false) as Button
	if home != null:
		home.emit_signal("pressed")
	main.run_to_stop()
	if c.review_pending:
		main.act("review")
		main.act("close")
	main.act("area", "home")
	main.clear_toast()
	await _shot("11a_home_after_show")
	main.act("interview")
	await _shot("11_second_walkin")
	quit(0)


func _shot(name: String) -> void:
	main.render()
	await create_timer(0.8).timeout
	await RenderingServer.frame_post_draw
	var path := out_dir.path_join(name + ".png")
	root.get_texture().get_image().save_png(path)
	print("FIRST_STILL wrote ", path)


func _wait(n: int) -> void:
	for k in n:
		await process_frame
