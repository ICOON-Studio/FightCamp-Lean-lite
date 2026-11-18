extends SceneTree
## S519 club week v11 play-check: the Training screen on the TEST CLUB (TestJump club4) with the coach's coached-morning
## deal (1-TO-1 / SHARED tags on the morning tiles) and one class night (the coach row CLASS NIGHT, the boxer's evening
## BAG · class night, the evening panel's toggle), then the Money page's Class nights line. Run on the never-shown desktop:
##   python tools/hidden_desktop.py run --timeout=300 <godot.exe> --path . --windowed --resolution 1920x1080 \
##       --audio-driver Dummy --script res://tools/club_week_still.gd -- <out_dir>

const TestJump := preload("res://scripts/ui/TestJump.gd")
const PadWeek := preload("res://scripts/rules/PadWeek.gd")

var main: Node
var out_dir := "user://club_week_still"


func _initialize() -> void:
	var args := OS.get_cmdline_user_args()
	if not args.is_empty():
		out_dir = str(args[0])
	DirAccess.make_dir_recursive_absolute(out_dir)
	root.size = Vector2i(1920, 1080)
	main = load("res://scenes/Main.tscn").instantiate()
	root.add_child(main)
	await _wait(4)
	TestJump.run(main, "club4")
	var c: Career = main.career
	main.modal = {}
	if posmod(c.day, 7) >= 5:
		c.day += 7 - posmod(c.day, 7)   # a weekday: the board is this week's
	var f: Dictionary = c.fighters[0]
	main.nav({"area": "training", "fighter": str(f["id"])})
	await _shot("training_deal")
	var d := int((PadWeek.nights_of(f).get("pads", [0]) as Array)[0])
	main.act("tkday", str(d))
	main.act("tkclass", str(d))
	await _shot("training_class_night")
	var Loyalty: GDScript = load("res://scripts/rules/Loyalty.gd")
	Loyalty.apply(f, "short", c.day - 6)
	Loyalty.apply(f, "short", c.day - 1)
	main.act("fighter", str(f["id"]))
	main.act("ftab", "0")
	await _shot("overview_loyalty_trend")
	main.act("stipend", "%s|half" % str(f["id"]))   # S519 half the sponsorship on the Money row
	main.act("go", "money:0")
	await _shot("money_class_line")
	# S519 3.7: two bouts booked in an offer's week, then that offer (the third boxer's) shows the clash before Accept
	for g in c.fighters:
		g["next_offer_day"] = c.day
	load("res://scripts/state/Bouts.gd").day_events(c)   # the game's own matchmaker writes the offers
	var pick := []
	for g in c.fighters:
		for o in g.get("offers", []):
			if pick.is_empty() and not bool(o["mismatch"]):
				pick = [g, o]
	if not pick.is_empty():
		var od := int(pick[1]["day"])
		var others := c.fighters.filter(func(x): return str(x["id"]) != str(pick[0]["id"]))
		for k in mini(2, others.size()):   # their own real offers, dated to the same week, accepted
			for o in others[k].get("offers", []):
				if not bool(o["mismatch"]):
					o["day"] = od
					load("res://scripts/state/Bouts.gd").accept(c, str(o["id"]))
					break
		main.nav({"area": "training", "fighter": str(f["id"])})
		await _shot("training_forecast")
		main.act("go", "fights:0")
		main.nav({"area": "fights", "tab": 0, "bout": str(pick[1]["id"])})
		await _shot("bout_clash")
	print("CLUB_WEEK_STILL wrote ", out_dir, " class_dow=", d, " offer=", not pick.is_empty())
	quit(0)


func _shot(name: String) -> void:
	main.render()
	await create_timer(0.8).timeout
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png(out_dir.path_join(name + ".png"))


func _wait(n: int) -> void:
	for k in n:
		await process_frame
