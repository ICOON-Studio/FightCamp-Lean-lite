extends VBoxContainer
## HOME: what needs me. Needs you, your fighters (tiles), the next 4 weeks (a picture) | next up, money this week (with its
## cash chart), news and mail. S330 MENULOOK1: the rows became pictures after the operator's C150 note on a page of rows.

const UI := preload("res://scripts/ui/UI.gd")
const AreaHead := preload("res://scripts/ui/AreaHead.gd")
const Needs := preload("res://scripts/state/Needs.gd")
const Sim := preload("res://scripts/state/Sim.gd")
const GameMoney := preload("res://scripts/rules/GameMoney.gd")
const Champs := preload("res://scripts/state/Champs.gd")
const FighterTile := preload("res://scripts/ui/FighterTile.gd")
const WeekStrip := preload("res://scripts/ui/WeekStrip.gd")
const CashChart := preload("res://scripts/ui/CashChart.gd")


func build(main: Node) -> void:
	add_theme_constant_override("separation", 14)
	var c: Career = main.career
	AreaHead.add(self, main, "home", [UI.muted("%s, %s" % [c.gym_name, Clock.fmt_long(c.day)], UI.BODY)])
	var grid := UI.hbox(16)
	add_child(grid)
	var left := UI.vbox(16)
	left.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	left.size_flags_stretch_ratio = 1.6
	var right := UI.vbox(16)
	right.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	grid.add_child(left)
	grid.add_child(right)

	var n := Needs.needs(c)
	var needs_card := UI.card("NEEDS YOU (%d)" % n.size())
	var items: Array = []
	for x in n.slice(0, 5):
		items.append(UI.row(x["t"], x["s"], UI.RED if x["red"] else UI.AMBER,
			[UI.button(x["label"], "Btn", main.act.bind(x["act"], x["arg"]))]))
	if items.is_empty():
		items.append(UI.muted("Nothing needs you. Press CONTINUE.", UI.BODY))
	UI.add_rows(needs_card[1], items)
	left.add_child(needs_card[0])

	var fighters_card := UI.card("YOUR FIGHTERS")
	if c.fighters.is_empty():
		fighters_card[1].add_child(UI.muted("No fighters yet. Someone is waiting at reception.", UI.BODY))
	# S330 (MENULOOK1): each fighter as a tile - record, mood, rings for weight, condition, goal and her next bout.
	for f in c.fighters:
		fighters_card[1].add_child(FighterTile.build(main, c, f))
	left.add_child(fighters_card[0])

	var weeks := UI.card("THE NEXT 4 WEEKS")
	weeks[0].name = "NextWeeks"
	var strip := WeekStrip.new()
	strip.name = "WeekStrip"
	strip.today = c.day
	strip.events = events(c)
	weeks[1].add_child(strip)
	left.add_child(weeks[0])

	var next := UI.card("NEXT UP")
	var stop: Dictionary = Clock.next_stop(c)
	next[1].add_child(UI.display(Clock.fmt(int(stop["d"])), 38))
	next[1].add_child(UI.muted(stop["r"], UI.BODY))
	right.add_child(next[0])

	var money := UI.card("MONEY THIS WEEK")
	if c.cash_history.size() >= 2:
		var chart: Control = CashChart.new()
		chart.name = "HomeCash"
		chart.points = c.cash_history.slice(-8)
		chart.height = 120.0
		money[1].add_child(chart)
	var inc: Dictionary = Sim.weekly_income(c)
	var cost: Dictionary = Sim.weekly_costs(c)
	UI.add_rows(money[1], [
		UI.kv("Cash", UI.money(c.cash), UI.FG, "mono"),
		UI.kv("Weekly in", UI.signed(int(inc["total"])), UI.GREEN, "mono"),
		UI.kv("Weekly costs, billed monthly", UI.signed(-int(cost["total"])), UI.FG, "mono"),
		UI.kv("Owed so far, billed %s" % Clock.fmt(GameMoney.next_bill_day(c.day)), UI.money(c.accrued), UI.FG, "mono"),
	])
	right.add_child(money[0])

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
