extends VBoxContainer
## MONEY: Overview (cash week by week, now), Income, Bills (weekly lines paid at the month end, one-offs), Deals.

const UI := preload("res://scripts/ui/UI.gd")
const AreaHead := preload("res://scripts/ui/AreaHead.gd")
const Sim := preload("res://scripts/state/Sim.gd")
const GameMoney := preload("res://scripts/rules/GameMoney.gd")
const Membership := preload("res://scripts/rules/Membership.gd")
const BoutRules := preload("res://scripts/rules/BoutRules.gd")
const CashChart := preload("res://scripts/ui/CashChart.gd")
const GymBills := preload("res://scripts/rules/GymBills.gd")
const Needs := preload("res://scripts/state/Needs.gd")

## One-offs shown on Income / Bills: the last this many days.
const LEDGER_DAYS := 56


func build(main: Node) -> void:
	add_theme_constant_override("separation", 14)
	var c: Career = main.career
	AreaHead.add(self, main, "money")
	match int(main.route["tab"]):
		0:
			_overview(c)
		1:
			_income(c)
		2:
			_bills(c)
		3:
			_deals(main, c)


func _overview(c: Career) -> void:
	var grid := UI.hbox(16)
	add_child(grid)
	var chart_card := UI.card("CASH, WEEK BY WEEK")
	chart_card[0].size_flags_stretch_ratio = 1.6
	var chart: Control = CashChart.new()
	chart.name = "CashChart"
	chart.points = c.cash_history.slice(-12)
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


## Members needed for dues alone to cover this week's costs less the other income.
func _break_even(c: Career, inc: Dictionary, cost: Dictionary) -> int:
	var need := int(cost["total"]) - int(inc["classes"]) - int(inc["sponsors"])
	return int(ceil(float(maxi(0, need)) / (float(GymBills.FEE_MONTH) / GymBills.WEEKS_A_MONTH)))


func _income(c: Career) -> void:
	var inc: Dictionary = Sim.weekly_income(c)
	var card := UI.card("INCOME, PER WEEK")
	UI.add_rows(card[1], [
		UI.kv("Members' dues (%d x %s a month)" % [c.members, UI.money(Membership.weekly_rate())], UI.money(int(inc["dues"])), UI.FG, "mono"),
		UI.kv("Evening classes" + ("" if not c.coach.is_empty() else " (need a coach)"), UI.money(int(inc["classes"])), UI.FG, "mono"),
		UI.kv("Sponsors", UI.money(int(inc["sponsors"])), UI.FG, "mono"),
		UI.kv("Total a week", UI.money(int(inc["total"])), UI.GREEN, "mono"),
	])
	add_child(card[0])
	_ledger("ONE-OFFS IN, LAST 8 WEEKS", c, true, "Ticket cuts from bouts land here.")


func _bills(c: Career) -> void:
	var cost: Dictionary = Sim.weekly_costs(c)
	var card := UI.card("BILLS, PER WEEK, PAID AT THE MONTH END")
	UI.add_rows(card[1], [
		UI.kv("Rent (%s a month)" % UI.money(GymBills.RENT_MONTH), UI.money(int(cost.get("rent", cost["upkeep"]))), UI.FG, "mono"),
		UI.kv("England Boxing fees (yearly, by the week)", UI.money(int(cost.get("fees", 0))), UI.FG, "mono"),
		UI.kv("Coach" if not c.coach.is_empty() else "Coach (none yet)", UI.money(int(cost["staff"])), UI.FG, "mono"),
		UI.kv("Fighter stipends (%d)" % c.fighters.size(), UI.money(int(cost["fighters"])), UI.FG, "mono"),
		UI.kv("Total a week", UI.money(int(cost["total"])), UI.FG, "mono"),
		UI.kv("Owed so far, billed %s" % Clock.fmt(GameMoney.next_bill_day(c.day)), UI.money(c.accrued), UI.AMBER, "mono"),
	])
	add_child(card[0])
	_ledger("PAID OUT, LAST 8 WEEKS", c, false, "Nothing paid out yet.")


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
				sub += ". Comes after her first win."
				right.append(UI.chip("after a win", ""))
		rows.append(UI.row(d["name"], sub, Color(0, 0, 0, 0), right))
	UI.add_rows(card[1], rows)
