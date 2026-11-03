extends SceneTree
## S373 stills of the session's screens: Danny's first offer with the weigh-in forecast, the records walls (Lucy, Danny)
## with the norm words and his force row, PLAYBOOK > Combos with Standard passed (graded jab and cross), the Record tab
## with a bout's plan tally. Quick start, sign the walk-in (Lucy), sign Danny, three Sundays.
## Run on the never-shown desktop:
##   python tools/hidden_desktop.py run --timeout=400 <godot.exe> --path . --windowed --resolution 1920x1080 \
##       --audio-driver Dummy --script res://tools/s373_stills.gd -- <out_dir>

const Roster := preload("res://scripts/state/Roster.gd")
const Bouts := preload("res://scripts/state/Bouts.gd")
const CB := preload("res://scripts/ui/ComboBuilder.gd")
const PlanFight := preload("res://scripts/rules/PlanFight.gd")

var main: Node
var out_dir := "user://s373_stills"


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
	var p := Roster.prospect(c, "danny")
	p["state"] = "invited"
	var danny := Roster.sign_prospect(c, "danny", ["signature"])
	danny["next_offer_day"] = c.day + 999   # his offer comes on the day we film it
	for week in 3:
		if week == 2:
			c.fighters[0]["stats"]["speed"] = float(c.fighters[0]["stats"]["speed"]) + 4.0
		for i in 8:
			main.run_to_stop()
			if c.review_pending:
				main.act("review")
				main.act("close")
				break
			if not main.modal.is_empty():
				main.act("close")
	var lucy: Dictionary = c.fighters[0]
	# 1. Danny's first offer: the weigh-in forecast.
	danny["next_offer_day"] = c.day
	danny["offers"] = []
	danny["bout"] = {}
	Bouts.day_events(c)
	if not (danny["offers"] as Array).is_empty():
		main.nav({"area": "fights", "tab": 0, "bout": str(danny["offers"][0]["id"])})
		await _shot("1_danny_offer_forecast.png")
		danny["offers"][0]["day"] = c.day + 17   # S372: his first offer was ~17 days out and he missed 60.0
		await _shot("1b_danny_offer_short_notice.png")
	# 2-3. The records walls.
	for f in [lucy, danny]:
		main.act("fighter", str(f["id"]))
		main.act("ftab", "3")
		await _shot("2_wall_%s.png" % str(f["id"]))
	# 4. Combos with Standard passed.
	lucy["awards"] = [{"id": "preliminary", "d": 7}, {"id": "standard", "d": 14}]
	CB.chain = ["jab", "cross", "lead_hook"]
	main.act("go", "playbook:2")
	await _shot("4_combos_graded.png")
	# 5. The Record tab with a bout's plan tally.
	var arrows: Array = lucy.get("arrows", [])
	var mid := str((arrows[0] if not arrows.is_empty() else PlanFight.starter()[0])["move"])
	c.results.push_front({"d": c.day - 3, "fid": lucy["id"], "who": lucy["first"], "opp": "Maria Ortega", "win": true, "outcome": "win",
		"pro": false, "cards": "30-27 x3", "why": "the jab kept Maria at range", "plan_rec": {"plan": [mid], "used": 14, "worked": 9,
		"improvised": 4, "lines": {mid: [9, 14]}}})
	main.act("fighter", str(lucy["id"]))
	main.act("ftab", "4")
	await _shot("5_record_plan.png")
	quit(0)


func _shot(name: String) -> void:
	main.render()
	await create_timer(0.8).timeout
	await RenderingServer.frame_post_draw
	var path := out_dir.path_join(name)
	root.get_texture().get_image().save_png(path)
	print("S373_STILL wrote ", path)


func _wait(n: int) -> void:
	for k in n:
		await process_frame
