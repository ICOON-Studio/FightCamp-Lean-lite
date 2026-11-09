extends RefCounted
## The buys on the books (S403 money mockup). Numbers come from the running gym. A tag is grey, with a reason and no
## pin, when it cannot be bought or would not help. The cage is drawn and not built.

const UI := preload("res://scripts/ui/UI.gd")
const Sim := preload("res://scripts/state/Sim.gd")
const GymSpend := preload("res://scripts/state/GymSpend.gd")
const GymUpgrades := preload("res://scripts/rules/GymUpgrades.gd")
const ClubShow := preload("res://scripts/rules/ClubShow.gd")
const Membership := preload("res://scripts/rules/Membership.gd")
const StaffRoles := preload("res://scripts/rules/StaffRoles.gd")
const Grants := preload("res://scripts/rules/Grants.gd")
const GymBills := preload("res://scripts/rules/GymBills.gd")
const StarDeal := preload("res://scripts/rules/StarDeal.gd")

const LEDGER_DAYS := 56
const ICONS := {"mats": "mat", "strength": "weights", "fitkit": "fresh", "youth": "members"}
const SHORT := {"mats": "Mats", "strength": "Strength corner", "fitkit": "Fitness class kit", "youth": "Youth section"}


static func why_tip(why: String) -> String:
	if why == "":
		return ""
	if why.length() >= 12:
		return why
	return "Not yet: " + why


static func items(main: Node, c: Career) -> Array:
	var net := int(Sim.weekly_income(c)["total"]) - int(Sim.weekly_costs(c)["total"])
	var out: Array = []
	for u in GymUpgrades.LIST:
		out.append(_upgrade(main, c, u, net))
	out.append(_evening(main, c, net))
	out.append(_show(main, c, net))
	out.append(_grant(main, c, net))
	var move := _move(main, c, net)
	if not move.is_empty():
		out.append(move)
	out.append(_cage())
	return out


static func cashbook(main: Node, c: Career) -> Control:
	var page := UI.vbox(8)
	page.name = "CashbookPage"
	page.add_child(_ledger("ONE-OFFS IN, LAST 8 WEEKS", c, true, "Ticket cuts from bouts land here."))
	page.add_child(_ledger("PAID OUT, LAST 8 WEEKS", c, false, "Nothing paid out yet."))
	page.add_child(_repairs(main, c))
	page.add_child(_answers(main, c))
	return page


static func _upgrade(main: Node, c: Career, u: Dictionary, net: int) -> Dictionary:
	var id := str(u["id"])
	var price := int(u["price"])
	var owned := GymUpgrades.has(c.upgrades, id)
	var upkeep := int(u["upkeep"])
	var added := 0
	var delta := -upkeep
	var grey := false
	var reason := ""
	if id == "youth":
		added = GymSpend.juniors_dues()
		delta = added - GymSpend.JUNIORS_COACH
	elif id == "fitkit":
		added = int(u["value"]) if c.staff_roles.has("assistant") else 0
		delta = added - upkeep
		if not owned and not c.staff_roles.has("assistant"):
			grey = true
			reason = "Needs a second club coach before these classes bring any money."
	var why := "" if owned else GymUpgrades.blocked(id, c.upgrades, c.cash)
	if not owned and why != "":
		grey = true
		reason = why_tip(why)
	var effect := str(u["effect"])
	if id == "youth":
		effect = "20 juniors bring %s a week. The juniors' coach is %s." % [UI.money(GymSpend.juniors_dues()), UI.money(GymSpend.JUNIORS_COACH)]
	elif id == "fitkit" and not owned:
		effect = "Fitness classes, %s a week, once a second club coach runs them." % UI.money(int(u["value"]))
	if owned:
		effect = "Ours. " + effect
	if grey and reason != "":
		effect = reason
	var buttons: Array = []
	if not owned:
		buttons.append(_btn(main, "Buy", "Buy_" + id, "buyup", id, why))
	return _pack(id, str(SHORT.get(id, u["name"])), price, "ours" if owned else UI.money(price), str(ICONS.get(id, "money")),
		effect, added, delta, grey, reason, owned, false, false, price, buttons, c, net)


static func _evening(main: Node, c: Career, net: int) -> Dictionary:
	var helps := GymSpend.member_limit(c) == "coaches"
	var grey := not helps
	var reason := "The coaches already have room, so another coach carries nobody yet." if grey else ""
	var added := 0
	var delta := -StaffRoles.EVENING_WAGE
	if helps:
		added = StaffRoles.COACH_MEMBERS * roundi(float(Membership.fee(c.dues_band)) / GymBills.WEEKS_A_MONTH)
		delta = added - StaffRoles.EVENING_WAGE
	var effect := "Carries %d more members, %s a week." % [StaffRoles.COACH_MEMBERS, UI.money(StaffRoles.EVENING_WAGE)]
	if grey:
		effect = reason
	var buttons: Array = [_btn(main, "Hire", "EveningAdd", "eveningcoach", "add", "")]
	if c.extra_coaches > 0:
		buttons.append(_btn(main, "Let one go", "EveningLess", "eveningcoach", "less", ""))
	return _pack("evening", "Second evening coach", StaffRoles.EVENING_WAGE, "%s a week" % UI.money(StaffRoles.EVENING_WAGE),
		"coach", effect, added, delta, grey, reason, false, false, false, 0, buttons, c, net)


static func _show(main: Node, c: Career, net: int) -> Dictionary:
	var booked := int(c.show.get("day", -1))
	if booked >= 0:
		return _pack("show", "Club show", ClubShow.COST, "booked", "booked",
			"Booked for %s." % Clock.fmt(booked), 0, 0, false, "", false, false, true, 0, [], c, net)
	var why := ""
	if not ClubShow.can_book(c.day, booked, int(c.show.get("last", -1))):
		why = "the next show can be booked from %s" % Clock.fmt(int(c.show.get("last", 0)) + ClubShow.EVERY_DAYS - ClubShow.LEAD_DAYS)
	elif c.cash < ClubShow.COST:
		why = "not enough cash"
	var pv := GymSpend.show_preview(c)
	var effect := "The night: %s to %s. One show every %d weeks." % [UI.signed(int(pv["net_lo"])), UI.signed(int(pv["net_hi"])), ClubShow.EVERY_DAYS / 7]
	var grey := why != ""
	if grey:
		effect = why_tip(why)
	var label := "Book"
	if why != "" and why != "not enough cash":
		label = Clock.fmt(int(c.show.get("last", 0)) + ClubShow.EVERY_DAYS - ClubShow.LEAD_DAYS)
	return _pack("show", "Club show", ClubShow.COST, UI.money(ClubShow.COST), "booked", effect, 0, 0, grey, effect if grey else "",
		false, false, false, ClubShow.COST, [_btn(main, label, "BookShow", "bookshow", "", why)], c, net)


static func _grant(main: Node, c: Career, net: int) -> Dictionary:
	var why := ""
	var effect := ""
	var held := c.grant.has("due")
	if held:
		why = "A bid is already in and the answer is on its way."
		effect = "A bid is in. The answer comes on %s." % Clock.fmt(int(c.grant["due"]))
	else:
		why = Grants.blocked(c.day, c.grant, GymSpend.youth_on(c), c.staff_roles.has("assistant") or c.extra_coaches > 0)
		effect = "Once a year. Odds follow the gym's name." if why == "" else why_tip(why)
	var grey := why != "" and not held
	return _pack("grant", "Club grant bid", 0, "free", "money", effect, 0, 0, grey, effect if grey else "",
		false, false, held, 0, [_btn(main, "Bid", "GrantBid", "grantbid", "", why)], c, net)


static func _move(main: Node, c: Career, net: int) -> Dictionary:
	if c.premises >= GymUpgrades.PREMISES.size() - 1:
		return {}
	var now: Dictionary = GymSpend.premises(c)
	var nx: Dictionary = GymUpgrades.premises(c.premises + 1)
	var price := int(nx["move"])
	var why := GymUpgrades.move_blocked(c.premises, c.cash)
	var helps := GymSpend.member_limit(c) == "premises"
	var extra := roundi(float(int(nx["rent"]) - int(now["rent"])) / GymBills.WEEKS_A_MONTH)
	var grey := why != "" or not helps
	var reason := why_tip(why) if why != "" else "Not needed yet: your gym still has room for more members."
	var effect := "Holds %d members. Rent up %s a week." % [int(nx["cap"]), UI.money(extra)]
	if grey:
		effect = reason
	return _pack("move", _no_area(str(nx["name"])), price, UI.money(price), "members", effect, 0, -extra, grey, reason if grey else "",
		false, false, false, price, [_btn(main, "Move", "MovePremises", "movepremises", "", why)], c, net)


static func _cage() -> Dictionary:
	var b := UI.button("Build", "Btn", func(): pass, true, "Not built yet")
	b.name = "CageBuild"
	return {
		"id": "cage", "title": "Cage", "price": 0, "price_text": "price not set", "icon": "cage",
		"effect": "MMA bouts in the gym, wall and takedown drills. Needs MMA rules.", "runway": "after: price not set", "payback": "",
		"earn": 0, "grey": false, "reason": "Not built yet", "owned": false, "unbuilt": true, "held": false,
		"affordable": false, "buttons": [b],
	}


static func _pack(id: String, title: String, price: int, price_text: String, icon: String, effect: String, added: int, delta: int,
		grey: bool, reason: String, owned: bool, unbuilt: bool, held: bool, lump: int, buttons: Array, c: Career, net: int) -> Dictionary:
	var afford := not grey and not owned and not unbuilt and not held and (lump <= 0 or c.cash >= lump)
	var earn := added if afford else 0
	var payback := ""
	if afford and delta > 0 and lump > 0:
		payback = "payback %d wks" % int(ceil(float(lump) / float(delta)))
	var runway := "bought, no change" if owned or held else _runway(c, net, lump, delta)
	return {
		"id": id, "title": title, "price": price, "price_text": price_text, "icon": icon, "effect": effect,
		"runway": runway, "payback": payback, "net_from": net, "net_to": net + delta if delta != 0 and not owned and not held else net, "earn": earn, "grey": grey, "reason": reason, "owned": owned,
		"unbuilt": unbuilt, "held": held, "affordable": afford, "buttons": buttons,
	}


## "Bigger unit, 3,000 sq ft, a second ring" is too long for a price tag: the floor area goes.
static func _no_area(unit: String) -> String:
	var keep: Array[String] = []
	for bit in unit.split(", "):
		if not bit.ends_with("sq ft"):
			keep.append(bit)
	return ", ".join(keep)


static func _runway(c: Career, net: int, price: int, delta: int) -> String:
	var left := c.cash - price
	var after := net + delta
	if left < 0:
		return "cash would fall short"
	if after >= 0:
		return "grows after"
	return "%d wks in hand after" % GymBills.runway_weeks(left, after)


static func _btn(main: Node, text: String, bname: String, action: String, arg: String, why: String) -> Button:
	var b := UI.button(text, "Btn", main.act.bind(action, arg), why != "", why_tip(why))
	b.name = bname
	return b


static func _ledger(title: String, c: Career, incoming: bool, empty: String) -> Control:
	var card := UI.vbox(4)
	card.add_child(UI.label(title, 16, UI.GOLD, "handbold"))
	var any := false
	for e in c.ledger:
		if c.day - int(e["d"]) > LEDGER_DAYS:
			break
		if (int(e["amount"]) > 0) != incoming:
			continue
		any = true
		var row := UI.hbox(12)
		row.add_child(UI.label("%s  %s" % [Clock.fmt(int(e["d"])), str(e["t"])], 15, UI.FG, "hand"))
		row.add_child(UI.label(UI.signed(int(e["amount"])), 15, UI.GREEN if incoming else UI.RED, "bold"))
		card.add_child(row)
	if not any:
		card.add_child(UI.label(empty, 15, UI.MUTED, "body"))
	return card


static func _repairs(main: Node, c: Career) -> Control:
	var box := UI.vbox(4)
	box.name = "Repairs"
	box.add_child(UI.label("REPAIRS", 16, UI.GOLD, "handbold"))
	for f in c.facilities:
		var row := UI.hbox(8)
		row.name = "Kit_" + str(f["id"])
		row.add_child(UI.label(str(f["name"]), 15, UI.FG, "body"))
		if str(f["state"]) == "worn":
			row.add_child(UI.label("worn", 14, UI.AMBER, "bold"))
			var b := UI.button("Repair, %s" % UI.money(int(f["repair"])), "Btn", main.act.bind("repair", f["id"]))
			b.name = "Repair_" + str(f["id"])
			row.add_child(b)
		else:
			row.add_child(UI.label("good", 14, UI.GREEN, "bold"))
		box.add_child(row)
	return box


static func _answers(main: Node, c: Career) -> Control:
	var box := UI.vbox(4)
	box.name = "TalkAnswers"
	box.add_child(UI.label("CONTRACT ANSWERS", 16, UI.GOLD, "handbold"))
	var any := false
	for f in c.fighters:
		var t: Dictionary = f.get("talks", {})
		if t.is_empty():
			continue
		any = true
		var terms: Dictionary = StarDeal.terms(f, str(t["step"]), int(t.get("take", 0)))
		var row := UI.hbox(8)
		row.add_child(UI.label(str(f["name"]), 15, UI.FG, "bold"))
		var keep := _btn(main, "Keep %d%%" % roundi(float(terms["keep"]) * 100), "TalkKeep_" + str(f["id"]), "talks",
			"%s|keep" % f["id"], "" if c.cash >= int(terms["bonus"]) else "not enough cash")
		var lower := _btn(main, "Drop to %d%%" % roundi(float(terms["lower"]) * 100), "TalkLower_" + str(f["id"]), "talks",
			"%s|lower" % f["id"], "")
		row.add_child(keep)
		row.add_child(lower)
		box.add_child(row)
	if not any:
		box.add_child(UI.label("No contract to answer.", 15, UI.MUTED, "body"))
	return box
