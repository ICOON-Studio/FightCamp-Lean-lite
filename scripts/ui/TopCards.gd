## The index cards on the top bar and the gym page (S362, J90 6g: "Money: T2 with income / costs / net rows (Two Point's
## praised money hover)"; the date; members and each piece of kit). Each returns a Tips spec; the game terms on it open
## their sticky notes (Glossary).
##   TopCards.money(c) / date(c) / members(c) / kit(c, piece) / go(c, go_state, running) -> {title, rows, means, keys}

const Sim := preload("res://scripts/state/Sim.gd")
const GameMoney := preload("res://scripts/rules/GameMoney.gd")
const GymBills := preload("res://scripts/rules/GymBills.gd")
const GymSpend := preload("res://scripts/state/GymSpend.gd")
const Membership := preload("res://scripts/rules/Membership.gd")
const Data := preload("res://scripts/state/Data.gd")


## TIPFIX1 (the standard, section 2: at most four rows, two linked words): the week's money in, out and the net; the
## Club page's Money tab keeps every line.
static func money(c: Career) -> Dictionary:
	var inc := int(Sim.weekly_income(c)["total"])
	var out := int(Sim.weekly_costs(c)["total"])
	var net := inc - out
	var rows: Array = [["Comes in", "+" + GameMoney.text(inc), "", "good"], ["Goes out", "-" + GameMoney.text(out), "", "bad"],
		["Net a week", ("+" if net >= 0 else "-") + GameMoney.text(absi(net)), "▲" if net >= 0 else "▼", "good" if net >= 0 else "bad"]]
	var now := "The cash grows by %s a week." % GameMoney.text(net) if net >= 0 else \
		"At this net the cash lasts about %d weeks." % GymBills.runway_weeks(c.cash, net)
	return {"kind": "full", "title": "Money a week", "what": "What the gym takes in and pays out in a normal week.",
		"rows": rows, "now": now, "moves": "Dues, classes and sponsors bring money in; staff, stipends and bills take it out.",
		"do": "Open the Club page, Money tab, to see every line.", "keys": ["runway", "dues"]}


static func date(c: Career) -> Dictionary:
	var ns := Clock.next_stop(c)
	var bill := GameMoney.next_bill_day(c.day)
	return {"title": "Week %d" % Clock.week_of(c.day),
		"rows": [["Next stop", Clock.fmt(int(ns["d"])), str(ns["r"]), ""], ["Month-end bill", Clock.fmt(bill), "in %d days" % (bill - c.day), ""]],
		"means": "CONTINUE runs the days to the next stop.", "keys": ["bill"]}


static func members(c: Career) -> Dictionary:
	var target := GymSpend.member_target(c)   # S397 the dues band and the room (premises, coaches) hold it
	var gap := target - c.members
	return {"title": "Members", "rows": [["On the books", str(c.members), "", ""],
		["The gym can carry", str(target), ("▲ +%d" % gap) if gap > 0 else (("▼ %d" % gap) if gap < 0 else ""), "good" if gap > 0 else ("bad" if gap < 0 else "")],
		["Dues a week", GameMoney.text(Membership.weekly_dues(c.members, c.dues_band)), "", ""]],
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


## S532 GUIDETIPS1 (owner on the clock: "keep as is but explain all these things in the guide how they work"): CONTINUE's
## own card. g = Needs.go_state. A blocked button's label already names the job, so the card says only what to do.
static func go(c: Career, g: Dictionary, running: bool) -> Dictionary:
	var blocked := str(g.get("cls", "")) == "GoBlock"
	var ns := Clock.next_stop(c)
	var d := {"kind": "full", "title": "The days wait" if blocked else "Continue",
		"what": "The days cannot run until this job is done." if blocked else "Plays the days one by one until something needs you.",
		"moves": "The days stop for week's end, bills, weigh-ins, fights and offers.",
		"do": "Click to go to the job." if blocked else ("Click to pause. Change anything, then carry on." if running else "Click to start. Click again while it runs to pause."),
		"hint": [["Menu", "Settings: how fast the days run"]]}
	if not blocked:
		d["now"] = "Next stop: %s, %s." % [Clock.fmt(int(ns["d"])), str(ns["r"])]
	return d
