extends VBoxContainer
## HOME: what needs me. S394 the approved layout (ops/research/MENU_DIRECTION_S393.md) in the game's light cards: needs first, the
## next fight as a matchup, one row per fighter; on the right what happened and why, the club's week, what is coming.

const UI := preload("res://scripts/ui/UI.gd")
const HomeNeeds := preload("res://scripts/ui/HomeNeeds.gd")
const HomeMatch := preload("res://scripts/ui/HomeMatch.gd")
const HomeRows := preload("res://scripts/ui/HomeRows.gd")
const HomeSide := preload("res://scripts/ui/HomeSide.gd")
const Sim := preload("res://scripts/state/Sim.gd")
const GameMoney := preload("res://scripts/rules/GameMoney.gd")
const Champs := preload("res://scripts/state/Champs.gd")
const NoGi := preload("res://scripts/rules/NoGi.gd")

const SIDE_W := 420.0


func build(main: Node) -> void:
	var c: Career = main.career
	var grid := UI.hbox(26)
	add_child(grid)
	var left := UI.vbox(20)
	left.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	grid.add_child(left)
	var right := UI.vbox(20)
	right.custom_minimum_size = Vector2(SIDE_W, 0)
	grid.add_child(right)
	var blocks := [HomeNeeds.build(main, c), HomeMatch.build(main, c), HomeRows.build(main, c)]
	if HomeNeeds.pressing(c).is_empty() and blocks[1] != null:   # nothing pressing: the fight leads the page
		blocks = [blocks[1], blocks[0], blocks[2]]
	for block in blocks:
		if block != null:
			left.add_child(block)
	HomeSide.fill(right, main, c, events(c))


## What happens in the next four weeks, for the strip: her bouts and weigh-ins, the championship dates, the bills.
static func events(c: Career) -> Array:
	var ev: Array = []
	for f in c.fighters:
		var fb: Dictionary = f["bout"]
		if fb.is_empty():
			continue
		if not fb.has("opp") or not fb.has("day"):   # S364 see FightPoster: a bout with no opponent is no event
			push_warning("Home.events: %s's bout has no opponent: %s" % [f.get("first", "?"), fb.keys()])
			continue
		ev.append({"d": int(fb["day"]), "t": "%s vs %s" % [f["first"], fb["opp"]["name"]], "kind": "bout"})
		if not bool(fb["weighed"]):
			ev.append({"d": int(fb["day"]) - 1, "t": "weigh-in", "kind": "weigh"})
	for g in c.grapplers:
		var opens := NoGi.opens_after(c.day, 1)
		if not opens.is_empty():
			ev.append({"d": int(opens[0]["d"]), "t": "%s: %s" % [g["first"], opens[0]["name"]], "kind": "open"})
	for e in Champs.calendar(c):
		if not ev.any(func(x): return int(x["d"]) == int(e["d"]) and str(x["kind"]) == "bout"):
			ev.append({"d": int(e["d"]), "t": str(e["t"]), "kind": "champ"})
	# The month's bills: owed so far plus the weeks still to run at this week's costs.
	var bill := GameMoney.next_bill_day(c.day)
	var due := c.accrued + int(Sim.weekly_costs(c)["total"]) * int(ceil((bill - c.day) / 7.0))
	ev.append({"d": bill, "t": "bills about %s" % UI.money(due), "kind": "bill"})
	return ev
