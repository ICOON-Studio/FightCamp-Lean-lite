## The index cards on the top bar and the gym page (S362, J90 6g: "Money: T2 with income / costs / net rows (Two Point's
## praised money hover)"; the date; members and each piece of kit). Each returns a Tips spec; the game terms on it open
## their sticky notes (Glossary).
##   TopCards.money(c) / date(c) / members(c) / kit(c, piece) -> {title, rows, means, keys}

const Sim := preload("res://scripts/state/Sim.gd")
const GameMoney := preload("res://scripts/rules/GameMoney.gd")
const GymBills := preload("res://scripts/rules/GymBills.gd")
const Membership := preload("res://scripts/rules/Membership.gd")
const Data := preload("res://scripts/state/Data.gd")


static func money(c: Career) -> Dictionary:
	var inc := Sim.weekly_income(c)
	var out := Sim.weekly_costs(c)
	var rows: Array = [["Dues", "+" + GameMoney.text(int(inc["dues"])), "", ""]]
	if int(inc["classes"]) > 0:
		rows.append(["Evening classes", "+" + GameMoney.text(int(inc["classes"])), "", ""])
	if int(inc["sponsors"]) > 0:
		rows.append(["Sponsors", "+" + GameMoney.text(int(inc["sponsors"])), "", ""])
	if int(inc.get("bjj", 0)) > 0:
		rows.append(["BJJ dues", "+" + GameMoney.text(int(inc["bjj"])), "", ""])
	rows.append(["Rent and fees", "-" + GameMoney.text(int(out["upkeep"])), "", ""])
	if int(out["staff"]) > 0:
		rows.append(["Coach", "-" + GameMoney.text(int(out["staff"])), "", ""])
	if int(out["fighters"]) > 0:
		rows.append(["Stipends", "-" + GameMoney.text(int(out["fighters"])), "", ""])
	if int(out.get("bjj", 0)) > 0:
		rows.append(["No-gi classes' coach", "-" + GameMoney.text(int(out["bjj"])), "", ""])
	var net := int(inc["total"]) - int(out["total"])
	rows.append(["Net a week", ("+" if net >= 0 else "-") + GameMoney.text(absi(net)), "▲" if net >= 0 else "▼", "good" if net >= 0 else "bad"])
	var means := "the cash grows by %s a week." % GameMoney.text(net) if net >= 0 else \
		"the cash lasts about %d weeks at this net." % GymBills.runway_weeks(c.cash, net)
	return {"title": "Money a week", "rows": rows, "means": means, "keys": ["runway", "dues", "bill"]}


static func date(c: Career) -> Dictionary:
	var ns := Clock.next_stop(c)
	var bill := GameMoney.next_bill_day(c.day)
	return {"title": "Week %d" % Clock.week_of(c.day),
		"rows": [["Next stop", Clock.fmt(int(ns["d"])), str(ns["r"]), ""], ["Month-end bill", Clock.fmt(bill), "in %d days" % (bill - c.day), ""]],
		"means": "CONTINUE runs the days to the next stop.", "keys": ["bill"]}


static func members(c: Career) -> Dictionary:
	var target := Membership.natural_members(c.reputation)
	var gap := target - c.members
	return {"title": "Members", "rows": [["On the books", str(c.members), "", ""],
		["The gym can carry", str(target), ("▲ +%d" % gap) if gap > 0 else (("▼ %d" % gap) if gap < 0 else ""), "good" if gap > 0 else ("bad" if gap < 0 else "")],
		["Dues a week", GameMoney.text(Membership.weekly_dues(c.members)), "", ""]],
		"means": "the count walks a few a week toward what the gym can carry." if gap != 0 else "the count holds where it is.",
		"keys": ["reputation", "dues"]}


static func kit(_c: Career, piece: Dictionary) -> Dictionary:
	var worn := str(piece["state"]) == "worn"
	var rows: Array = [["State", str(piece["state"]), "", "watch" if worn else "good"]]
	if worn:
		rows.append(["Repair", GameMoney.text(int(piece["repair"])), "+%d rep" % Data.REPAIR_REPUTATION, "good"])
	return {"title": str(piece["name"]), "rows": rows,
		"means": ("members notice a repair: +%d reputation, once." % Data.REPAIR_REPUTATION) if worn else "nothing to do.",
		"keys": ["reputation"] if worn else []}
