extends VBoxContainer
## HOME: what needs me. S333 look B (Q-S294-52 "B Gym whiteboard"): the coach's whiteboard about her next bout (polaroid,
## marker notes, the next 4 weeks), the squad's other tiles | the needs as sticky notes, the cash tin, news and mail.

const UI := preload("res://scripts/ui/UI.gd")
const HomeBoard := preload("res://scripts/ui/HomeBoard.gd")
const Needs := preload("res://scripts/state/Needs.gd")
const Sim := preload("res://scripts/state/Sim.gd")
const GameMoney := preload("res://scripts/rules/GameMoney.gd")
const Champs := preload("res://scripts/state/Champs.gd")
const FighterTile := preload("res://scripts/ui/FighterTile.gd")


func build(main: Node) -> void:
	add_theme_constant_override("separation", 18)
	var c: Career = main.career
	var grid := UI.hbox(26)
	add_child(grid)
	var left := UI.vbox(18)
	left.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	left.size_flags_stretch_ratio = 2.6
	var right := UI.vbox(18)
	right.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	grid.add_child(left)
	grid.add_child(right)

	# S333 look B: the coach's whiteboard about her (the soonest bout), then the rest of the squad as tiles.
	left.add_child(HomeBoard.board(main, c, events(c)))
	var hero := HomeBoard.hero(c)
	for f in c.fighters:
		if f != hero:
			left.add_child(FighterTile.build(main, c, f))

	var n := Needs.needs(c)
	var stickies := UI.vbox(14)
	stickies.name = "Needs"
	for i in mini(n.size(), 5):
		stickies.add_child(HomeBoard.sticky(main, n[i], i))
	if n.is_empty():
		stickies.add_child(HomeBoard.sticky(main, {"t": "Nothing needs you", "s": "Press Continue.", "red": false,
			"label": "Mail", "act": "mail", "arg": ""}, 2))
	right.add_child(stickies)
	right.add_child(HomeBoard.cash_tin(c))

	var news := UI.card("NEWS AND MAIL")
	var rows: Array = []
	for x in c.news.slice(0, 2):
		rows.append(UI.row(x["t"], Clock.fmt(int(x["d"]))))
	UI.add_rows(news[1], rows)
	var all := UI.button("All news", "BtnQuiet", main.act.bind("mail", ""))
	all.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
	news[1].add_child(all)
	right.add_child(news[0])


## What happens in the next four weeks, for the strip: her bouts and weigh-ins, the championship dates, the bills.
static func events(c: Career) -> Array:
	var ev: Array = []
	for f in c.fighters:
		var fb: Dictionary = f["bout"]
		if fb.is_empty():
			continue
		ev.append({"d": int(fb["day"]), "t": "%s vs %s" % [f["first"], fb["opp"]["name"]], "kind": "bout"})
		if not bool(fb["weighed"]):
			ev.append({"d": int(fb["day"]) - 1, "t": "weigh-in", "kind": "weigh"})
	for e in Champs.calendar(c):
		if not ev.any(func(x): return int(x["d"]) == int(e["d"]) and str(x["kind"]) == "bout"):
			ev.append({"d": int(e["d"]), "t": str(e["t"]), "kind": "champ"})
	# The month's bills: owed so far plus the weeks still to run at this week's costs.
	var bill := GameMoney.next_bill_day(c.day)
	var due := c.accrued + int(Sim.weekly_costs(c)["total"]) * int(ceil((bill - c.day) / 7.0))
	ev.append({"d": bill, "t": "bills about %s" % UI.money(due), "kind": "bill"})
	return ev
