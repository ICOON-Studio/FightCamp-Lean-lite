extends VBoxContainer
## MONEY, one page (S396): cash week by week and now, the week in and out, the one-offs in and out, deals, repairs.

const UI := preload("res://scripts/ui/UI.gd")
const AreaHead := preload("res://scripts/ui/AreaHead.gd")
const Sim := preload("res://scripts/state/Sim.gd")
const GameMoney := preload("res://scripts/rules/GameMoney.gd")
const Membership := preload("res://scripts/rules/Membership.gd")
const BoutRules := preload("res://scripts/rules/BoutRules.gd")
const CashChart := preload("res://scripts/ui/CashChart.gd")
const GymBills := preload("res://scripts/rules/GymBills.gd")
const Needs := preload("res://scripts/state/Needs.gd")
const BjjSide := preload("res://scripts/rules/BjjSide.gd")
const Bar := preload("res://scripts/ui/Bar.gd")

## One-offs shown on Income / Bills: the last this many days.
const LEDGER_DAYS := 56
const GYM_AREA := preload("res://scripts/ui/areas/Gym.gd")


func build(main: Node) -> void:
	add_theme_constant_override("separation", 14)
	var c: Career = main.career
	AreaHead.add(self, main, "money")
	# S396 screen cut: Money is one page - cash and the week's in and out (the overview's bars carry the old Income and Bills
	# tables' numbers, so those two would repeat them), deals, then the repairs (from Facilities, Routes.gd).
	_overview(c)
	_ledger("ONE-OFFS IN, LAST 8 WEEKS", c, true, "Ticket cuts from bouts land here.")
	_ledger("PAID OUT, LAST 8 WEEKS", c, false, "Nothing paid out yet.")
	_deals(main, c)
	var kit: VBoxContainer = GYM_AREA.new()
	add_child(kit)
	kit._facilities(main, c)


func _overview(c: Career) -> void:
	var grid := UI.hbox(16)
	add_child(grid)
	var chart_card := UI.card("CASH, WEEK BY WEEK")
	chart_card[0].size_flags_stretch_ratio = 1.6
	var chart: Control = CashChart.new()
	chart.name = "CashChart"
	chart.points = c.cash_history.slice(-12)
	# S396 blind round 3 (the last bar said $11,381, the top bar $11,831): the weeks closed, then the cash now.
	if not chart.points.is_empty() and int(chart.points[-1]["c"]) != c.cash:
		chart.points = chart.points.slice(-11) + [{"w": -1, "c": c.cash}]
	chart_card[1].add_child(chart)
	grid.add_child(chart_card[0])
	var inc: Dictionary = Sim.weekly_income(c)
	var cost: Dictionary = Sim.weekly_costs(c)
	var net := int(inc["total"]) - int(cost["total"])
	var now := UI.card("NOW")
	UI.add_rows(now[1], [
		UI.kv("Cash", UI.money(c.cash), UI.FG, "mono"),
		UI.kv("Weekly in", UI.signed(int(inc["total"])), UI.GREEN, "mono"),
		UI.kv("Weekly costs", UI.signed(-int(cost["total"])), UI.FG, "mono"),
		UI.kv("Weekly net", UI.signed(net), UI.GREEN if net >= 0 else UI.RED, "mono"),
		UI.kv("Owed, billed %s" % Clock.fmt(GameMoney.next_bill_day(c.day)), UI.money(c.accrued), UI.FG, "mono"),
	])
	# S324 update 27: the runway and the close rule, in plain words.
	var ms := Needs.money_status(c)
	var rl := UI.label(GymBills.line(c.cash, net, c.weeks_below), UI.BODY, UI.RED if ms == "red" or ms == "closed" else
		(UI.AMBER if ms == "warn" else UI.GREEN), "bold")
	rl.name = "Runway"
	now[1].add_child(rl)
	now[1].add_child(UI.muted("%d weeks in a row below $0 closes the gym. Break-even: %d members." % [GymBills.CLOSE_AFTER_WEEKS,
		_break_even(c, inc, cost)], UI.SMALL, true))
	now[1].add_child(UI.muted("Bouts add a %s ticket cut each; camps and repairs are one-offs." % UI.money(BoutRules.TICKET_CUT), UI.SMALL, true))
	grid.add_child(now[0])
	for child in grid.get_children():
		(child as Control).size_flags_vertical = Control.SIZE_FILL
	# S369 (S367 critic: "a list in the top fifth of an empty page"): the week's money as a picture under it - each line
	# a bar on one scale for both cards, so the biggest earner and the biggest bill read at a glance. The same lines as
	# the Income and Bills tabs.
	var split := UI.hbox(16)
	split.name = "MoneySplit"
	add_child(split)
	var scale := float(maxi(1, maxi(int(inc["total"]), int(cost["total"]))))
	split.add_child(_split_card("WHERE IT COMES FROM, A WEEK", [
		["Members' dues", int(inc["dues"])], ["Evening classes", int(inc["classes"])],
		["BJJ classes' dues", int(inc.get("bjj", 0))], ["Sponsors", int(inc["sponsors"])]], scale, UI.GREEN, "+"))
	split.add_child(_split_card("WHERE IT GOES, A WEEK", [
		["Rent", int(cost.get("rent", cost["upkeep"]))], ["England Boxing fees", int(cost.get("fees", 0))],
		["Coach", int(cost["staff"])], ["Fighter stipends", int(cost["fighters"])], ["BJJ coach", int(cost.get("bjj", 0))]],
		scale, UI.RED, "-"))


## One side of the week: a row per line with money in it, biggest first - name, a bar to `scale`, the amount.
func _split_card(title: String, lines: Array, scale: float, col: Color, sign: String) -> Control:
	var card := UI.card(title)
	card[0].size_flags_horizontal = Control.SIZE_EXPAND_FILL
	card[0].size_flags_vertical = Control.SIZE_SHRINK_BEGIN
	var rows := lines.filter(func(l): return int(l[1]) > 0)
	rows.sort_custom(func(a, b): return int(a[1]) > int(b[1]))
	if rows.is_empty():
		card[1].add_child(UI.muted("Nothing this week.", UI.SMALL))
	for l in rows:
		var h := UI.hbox(12)
		var name := UI.label(str(l[0]), UI.BODY)
		name.custom_minimum_size = Vector2(210, 0)
		h.add_child(name)
		var bar := Bar.new()   # S375 a chart bar at a fixed full length (260), so amounts still compare by length
		bar.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
		bar.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		bar.custom_minimum_size = Vector2(260, 12)
		bar.fill = col
		var frac := float(l[1]) / scale
		bar.ready.connect(func(): bar.create_tween().tween_property(bar, "frac", frac, 0.5).from(0.0))
		h.add_child(bar)
		var amt := UI.mono(sign + UI.money(int(l[1])).trim_prefix("+"), UI.BODY, col)
		amt.custom_minimum_size = Vector2(90, 0)
		amt.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		h.add_child(amt)
		card[1].add_child(h)
	return card[0]


## Members needed for dues alone to cover this week's costs less the other income.
func _break_even(c: Career, inc: Dictionary, cost: Dictionary) -> int:
	var need := int(cost["total"]) - int(inc["classes"]) - int(inc["sponsors"]) - int(inc.get("bjj", 0))
	return int(ceil(float(maxi(0, need)) / (float(GymBills.FEE_MONTH) / GymBills.WEEKS_A_MONTH)))


func _ledger(title: String, c: Career, incoming: bool, empty: String) -> void:
	var card := UI.card(title)
	add_child(card[0])
	var rows: Array = []
	for e in c.ledger:
		if c.day - int(e["d"]) > LEDGER_DAYS:
			break
		if (int(e["amount"]) > 0) == incoming:
			rows.append(UI.kv("%s   %s" % [Clock.fmt(int(e["d"])), e["t"]], UI.signed(int(e["amount"])),
				UI.GREEN if incoming else UI.FG, "mono"))
	if rows.is_empty():
		rows.append(UI.muted(empty, UI.BODY))
	UI.add_rows(card[1], rows)


func _deals(main: Node, c: Career) -> void:
	var card := UI.card("DEALS")
	add_child(card[0])
	var rows: Array = []
	for d in c.deals:
		var right: Array = []
		var sub := "%s, %s a week" % [d["what"], UI.money(int(d["per"]))]
		match str(d["state"]):
			"signed":
				right.append(UI.chip("signed", "green"))
			"offer":
				var b := UI.button("Sign", "Btn", main.act.bind("deal", d["id"]))
				b.name = "Deal_" + str(d["id"])
				right.append(b)
			"locked":
				sub += ". Comes after the first win."
				right.append(UI.chip("after a win", ""))
		rows.append(UI.row(d["name"], sub, Color(0, 0, 0, 0), right))
	UI.add_rows(card[1], rows)
