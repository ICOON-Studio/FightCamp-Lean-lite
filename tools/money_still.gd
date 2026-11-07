extends SceneTree
## S397 money bites stills (ops/research/MONEY_BITES_S397.md): Club > Money and Club > People for a gym in its first year
## (week 31: two boxers, the fitness classes and the floor bought, an assistant and an S&C coach, a club show behind it,
## the first pro at the top-10 contract talks). The career is played to week 1 through Main.act, then set to that state
## (the state a sensible harness gym reaches by about week 30). Writes <out>/money_<n>_real.png at scroll steps.
##   python tools/hidden_desktop.py run --timeout=180 <godot.exe> --path . --windowed --resolution 1920x1080 \
##       --audio-driver Dummy --script res://tools/money_still.gd -- <out_dir>

const W := 1920
const H := 1080
const Roster := preload("res://scripts/state/Roster.gd")
const Data := preload("res://scripts/state/Data.gd")
const GymSpend := preload("res://scripts/state/GymSpend.gd")

var main: Node
var out_dir := "user://money_stills"


func _initialize() -> void:
	var args := OS.get_cmdline_user_args()
	if not args.is_empty():
		out_dir = args[0]
	DirAccess.make_dir_recursive_absolute(out_dir)
	root.size = Vector2i(W, H)
	main = load("res://scenes/Main.tscn").instantiate()
	main.save_path = "user://money_still.save"
	root.add_child(main)
	await _settle(6)
	main.act("quick")
	main.act("interview")
	main.act("pickcard", "signature")
	main.act("sign")
	main.act("hire", "reid")
	var c: Career = main.career
	c.guide = ""
	c.day = 210
	c.members = 68
	c.reputation = 41
	c.cash = 14820
	c.accrued = 3960
	c.cash_history = []
	var hist := [17200, 16400, 15100, 15900, 14300, 13800, 15200, 16900, 15600, 14100, 13400, 14820]
	for i in hist.size():
		c.cash_history.append({"w": 20 + i, "c": hist[i]})
	c.upgrades = [{"id": "fitkit", "day": 21}, {"id": "mats", "day": 120}]
	c.staff_roles = ["assistant", "strength"]
	c.show = {"day": -1, "last": 182, "night": {"sold": 151, "tickets": 3775, "raffle": 1040, "net": 1315, "members": 3}}
	for d in c.deals:
		d["state"] = "signed"
	var danny := {}
	for p in c.prospects:
		if str(p["id"]) == "danny":
			danny = p
	var raw: Dictionary = danny.duplicate(true)
	for k in ["state", "trial_day", "note"]:
		raw.erase(k)
	danny["state"] = "signed"
	var f2 := Roster.sign_fighter(c, raw, [])
	GymSpend.set_stipend(c, f2, false)
	var lucy := c.fighter()
	lucy["pro"] = true
	lucy["weekly_salary"] = 0
	lucy["talks"] = {"step": "top10", "until": c.day + 9, "take": 0}
	c.ledger.push_front({"d": 120, "t": "Upgrade: matted floor and new ring canvas", "amount": -2400})
	c.ledger.push_front({"d": 154, "t": "Club show: hall, officials, doctor and ambulance, trophies", "amount": -3500})
	c.ledger.push_front({"d": 182, "t": "Club show: 151 tickets and the raffle", "amount": 4815})
	c.ledger.push_front({"d": 189, "t": "Ticket cut: Danny vs Ryan Cole", "amount": 450})
	c.ledger.push_front({"d": 196, "t": "Purse share (25%): Lucy vs Kayleigh Doran", "amount": 1875})
	c.ledger.push_front({"d": 203, "t": "Pro camp for Lucy: sparring partners and meals", "amount": -375})
	main.modal = {}
	main.clear_toast()   # the hire's toast is not part of the page
	main.act("go", "money:0")
	await _settle(30)
	await _shots("money")
	main.act("go", "gym:1")
	await _settle(30)
	await _shots("people")
	quit(0)


func _shots(prefix: String) -> void:
	var sc: ScrollContainer = main._shell._scroll
	var step := 0
	var y := 0
	while step < 6:
		sc.scroll_vertical = y
		await _settle(8)
		await RenderingServer.frame_post_draw
		var path := out_dir.path_join("%s_%d_real.png" % [prefix, step])
		root.get_texture().get_image().save_png(path)
		print("wrote ", path)
		var max_y := int(sc.get_v_scroll_bar().max_value - sc.size.y)
		if y >= max_y:
			break
		y = mini(y + 820, max_y)
		step += 1


func _settle(frames: int = 4) -> void:
	for i in frames:
		await process_frame
