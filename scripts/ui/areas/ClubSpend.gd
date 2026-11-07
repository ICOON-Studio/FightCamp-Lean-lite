extends RefCounted
## S397 money bites (ops/research/MONEY_BITES_S397.md 7.1, STRUCTURE_DESIGN_S395 5.4 "Club > Money: bills, income, deals,
## repairs, upgrades"): the cards on Money where the gym spends - premises, upgrades, the kit budget, the club show and a
## pro's contract talks. Every row says the price, what it costs a week, the one number it moves, and the cash left after
## (round 1, the FM critic: "leaves $9,200, 7 weeks of costs" is what makes buying a decision). Rules: GymSpend.

const UI := preload("res://scripts/ui/UI.gd")
const Sim := preload("res://scripts/state/Sim.gd")
const GymSpend := preload("res://scripts/state/GymSpend.gd")
const GymUpgrades := preload("res://scripts/rules/GymUpgrades.gd")
const ClubShow := preload("res://scripts/rules/ClubShow.gd")
const StarDeal := preload("res://scripts/rules/StarDeal.gd")
const HomeJuniors := preload("res://scripts/state/HomeJuniors.gd")
const GameMoney := preload("res://scripts/rules/GameMoney.gd")
const Membership := preload("res://scripts/rules/Membership.gd")
const StaffRoles := preload("res://scripts/rules/StaffRoles.gd")
const Grants := preload("res://scripts/rules/Grants.gd")


static func add(parent: Container, main: Node, c: Career) -> void:
	_talks(parent, main, c)
	_stipends(parent, main, c)
	_premises(parent, main, c)
	_upgrades(parent, main, c)
	var pair := UI.hbox(16)
	parent.add_child(pair)
	_kit(pair, main, c)
	_show(pair, main, c)


## "leaves $9,200, about 7 weeks of costs"
static func leaves(c: Career, price: int) -> String:
	var left := c.cash - price
	var week := maxi(1, int(Sim.weekly_costs(c)["total"]))
	var n := maxi(0, int(floor(float(left) / week)))
	return "leaves %s, about %d week%s of costs" % [UI.money(left), n, "" if n == 1 else "s"]


static func _talks(parent: Container, main: Node, c: Career) -> void:
	for f in c.fighters:
		var t: Dictionary = f.get("talks", {})
		if t.is_empty():
			continue
		var terms := StarDeal.terms(f, str(t["step"]), int(t.get("take", 0)))
		var card := UI.card("CONTRACT TALKS: %s" % str(f["name"]).to_upper())
		card[0].name = "Talks_" + str(f["id"])
		parent.add_child(card[0])
		card[1].add_child(UI.label("%s has reached %s. A bigger management firm has called; answer by %s, or the lower share stands." % [
			f["first"], terms["words"], Clock.fmt(int(t["until"]))], UI.BODY, UI.FG, "body", true))
		var keep := UI.button("Keep %d%%: pay a %s bonus" % [roundi(float(terms["keep"]) * 100), UI.money(int(terms["bonus"]))], "BtnPrimary",
			main.act.bind("talks", "%s|keep" % f["id"]), c.cash < int(terms["bonus"]), "not enough cash")
		var lower := UI.button("Drop to %d%%" % roundi(float(terms["lower"]) * 100), "Btn", main.act.bind("talks", "%s|lower" % f["id"]))
		var h := UI.hbox(12)
		h.add_child(keep)
		h.add_child(lower)
		card[1].add_child(h)
		card[1].add_child(UI.muted("The bonus %s. The gym's share of each purse and ticket sale: %d%% kept or %d%% after." % [
			leaves(c, int(terms["bonus"])), roundi(float(terms["keep"]) * 100), roundi(float(terms["lower"]) * 100)], UI.SMALL, true))


## Who is on the club stipend (STRUCTURE_DESIGN_S395 5.3b): full time for the money, or a day job and evenings only.
static func _stipends(parent: Container, main: Node, c: Career) -> void:
	var ams := c.fighters.filter(func(f): return not bool(f.get("pro", false)))
	if ams.is_empty():
		return
	var card := UI.card("STIPENDS")
	card[0].name = "Stipends"
	parent.add_child(card[0])
	var rows: Array = []
	for f in ams:
		var job := bool(f.get("day_job", false))
		var b := UI.button("Pay the stipend, %s a week" % UI.money(GameMoney.FIGHTER_STIPEND) if job else "Stop the stipend", "Btn",
			main.act.bind("stipend", "%s|%s" % [f["id"], "on" if job else "off"]))
		b.name = "Stipend_" + str(f["id"])
		var sub := "Day job: trains evenings, gains 15% less; the gym pays nothing" if job else 			"On the club stipend, %s a week: trains full time" % UI.money(int(f["weekly_salary"]))
		rows.append(UI.row(str(f["name"]), sub, UI.GREEN if not job else Color(0, 0, 0, 0), [b]))
	UI.add_rows(card[1], rows)
	card[1].add_child(UI.muted("Most amateurs work or study. A stipend lets a top prospect train full time.", UI.SMALL, true))


static func _premises(parent: Container, main: Node, c: Career) -> void:
	var card := UI.card("PREMISES")
	card[0].name = "Premises"
	parent.add_child(card[0])
	var p := GymSpend.premises(c)
	var rows: Array = [UI.kv(str(p["name"]), "rent %s a month" % UI.money(int(p["rent"])), UI.FG, "mono"),
		UI.kv("Members", _room_words(c, p), UI.AMBER if GymSpend.member_limit(c) != "" else UI.FG, "mono"),
		UI.kv("Roster places", "%d of %d used" % [GymSpend.used(c), GymSpend.places(c)], UI.FG, "mono")]
	if c.premises < GymUpgrades.PREMISES.size() - 1:
		var nx := GymUpgrades.premises(c.premises + 1)
		var why := GymUpgrades.move_blocked(c.premises, c.cash)
		var b := UI.button("Move, %s" % UI.money(int(nx["move"])), "Btn", main.act.bind("movepremises", ""), why != "", why)
		b.name = "MovePremises"
		rows.append(UI.row("Next: %s" % str(nx["name"]).to_lower(), "Holds %d members, %d roster places; rent %s a month (+%s a week for good). The move %s." % [
			int(nx["cap"]), int(nx["places"]), UI.money(int(nx["rent"])),
			UI.money(roundi(float(int(nx["rent"]) - int(p["rent"])) / 4.33)), leaves(c, int(nx["move"]))], Color(0, 0, 0, 0), [b]))
	rows.append(_dues_row(main, c))
	rows.append(_evening_row(main, c))
	UI.add_rows(card[1], rows)
	var lim := GymSpend.member_limit(c)
	if lim != "":
		card[1].add_child(UI.label("%s: %s." % ["Full" if c.members >= GymSpend.member_cap(c) else "Nearly full",
			"hire an evening coach, or a second club coach, to carry more members" if lim == "coaches"
			else "move to a bigger place, or raise the dues for the members you have"], UI.BODY, UI.AMBER, "bold", true))


## "68 of 70: the place is the limit (the coaches could carry 150)"
static func _room_words(c: Career, p: Dictionary) -> String:
	var place := int(p["cap"]) - GymUpgrades.room(c.upgrades)
	var coaches := GymSpend.coaching_cap(c)
	if place <= coaches:
		return "%d of %d: the place is the limit (the coaches could carry %d)" % [c.members, GymSpend.member_cap(c), coaches]
	return "%d of %d: the coaches are the limit (the place holds %d)" % [c.members, GymSpend.member_cap(c), place]


static func _dues_row(main: Node, c: Career) -> Control:
	var h := UI.hbox(8)
	for band in Membership.DUES_ORDER:
		var d: Dictionary = Membership.DUES[band]
		var b := UI.button("%s %s" % [d["name"], UI.money(int(d["fee"]))], "BtnPrimary" if c.dues_band == band else "Btn", main.act.bind("dues", band))
		b.name = "Dues_" + str(band)
		h.add_child(b)
	var words := {"cheap": "draws 15% more members", "standard": "the usual club rate",
		"premium": "draws %d%% fewer members (a famous gym closes the gap)" % roundi((1.0 - Membership.draw("premium", c.reputation)) * 100)}
	return UI.row("Dues a month", "Now %s: %s. Real clubs charge $25-45; premium gyms more." % [UI.money(Membership.fee(c.dues_band)),
		words.get(c.dues_band, "")], Color(0, 0, 0, 0), [h])


static func _evening_row(main: Node, c: Career) -> Control:
	var add := UI.button("Hire one, %s a week" % UI.money(StaffRoles.EVENING_WAGE), "Btn", main.act.bind("eveningcoach", "add"))
	add.name = "EveningAdd"
	var right: Array = [add]
	if c.extra_coaches > 0:
		var less := UI.button("Let one go, a week's pay", "Btn", main.act.bind("eveningcoach", "less"))
		less.name = "EveningLess"
		right.append(less)
	return UI.row("Evening coaches: %d" % c.extra_coaches, "Each carries %d more members (every coach does, you too; the volunteers %d)." % [
		StaffRoles.COACH_MEMBERS, StaffRoles.VOLUNTEER_MEMBERS], Color(0, 0, 0, 0), right)


static func _upgrades(parent: Container, main: Node, c: Career) -> void:
	var card := UI.card("UPGRADES")
	card[0].name = "Upgrades"
	parent.add_child(card[0])
	var rows: Array = []
	for u in GymUpgrades.LIST:
		var id := str(u["id"])
		var right: Array = []
		var sub := "%s. %s%s" % [u["effect"], UI.money(int(u["price"])), (" + %s a week upkeep" % UI.money(int(u["upkeep"]))) if int(u["upkeep"]) > 0 else ""]
		if id == "youth":
			sub += ", juniors' coach %s a week, juniors' dues +%s a week" % [UI.money(GymSpend.JUNIORS_COACH), UI.money(GymSpend.juniors_dues())]
		if GymUpgrades.has(c.upgrades, id):
			if not GymUpgrades.ready(c.upgrades, id, c.day):
				right.append(UI.chip("fitters in", "amber"))
			elif not GymUpgrades.working(id, c.staff_roles):
				right.append(UI.chip("idle: needs a second club coach", "amber"))
			else:
				right.append(UI.chip("working", "green"))
			sub = _since(c, id)
		else:
			var why := GymUpgrades.blocked(id, c.upgrades, c.cash)
			var b := UI.button("Buy, %s" % UI.money(int(u["price"])), "Btn", main.act.bind("buyup", id), why != "", why)
			b.name = "Buy_" + id
			right.append(b)
			sub += ". Buying %s" % leaves(c, int(u["price"]))
		var r := UI.row(str(u["name"]), sub, Color(0, 0, 0, 0), right)
		r.name = "Up_" + id
		rows.append(r)
	UI.add_rows(card[1], rows)


## What an owned upgrade has done so far, in one line.
static func _since(c: Career, id: String) -> String:
	var day := 0
	for o in c.upgrades:
		if str(o["id"]) == id:
			day = int(o["day"]) + GymUpgrades.FIT_DAYS
	var weeks := maxi(0, int(floor((c.day - day) / 7.0)))
	match id:
		"fitkit":
			return "Working %d weeks; the classes bring %s a week while the second club coach runs them." % [weeks, UI.money(int(GymSpend.income(c)["fitness"]))]
		"youth":
			var home := c.prospects.filter(func(p): return bool(p.get("home", false))).size()
			return "%d juniors on the books for %d weeks; %d home-grown prospect%s so far. Intakes at the January and September terms." % [
				GymSpend.JUNIORS, weeks, home, "" if home == 1 else "s"]
		"mats":
			return "Working %d weeks: training injury risk down 15%%." % weeks
		"strength":
			return "Working %d weeks: power and conditioning sessions gain 10%% more; the racks take room for 10 members." % weeks
	return ""


static func _kit(parent: Container, main: Node, c: Career) -> void:
	var card := UI.card("KIT BUDGET")
	card[0].name = "KitBudget"
	card[0].size_flags_horizontal = Control.SIZE_EXPAND_FILL
	parent.add_child(card[0])
	card[1].add_child(UI.muted("Gloves, headguards, pads and bags wear out: a club spends $2,000-3,500 a year on them.", UI.SMALL, true))
	var h := UI.hbox(8)
	for k in GymSpend.KIT_ORDER:
		var kb: Dictionary = GymSpend.KIT[k]
		var b := UI.button("%s, %s a week" % [kb["name"], UI.money(int(kb["week"]))], "BtnPrimary" if c.kit_level == k else "Btn",
			main.act.bind("kitbudget", k))
		b.name = "Kit_" + str(k)
		h.add_child(b)
	card[1].add_child(h)
	var words := {}
	for k in GymSpend.KIT_ORDER:   # the words follow GymBills.KIT_BUDGET, so they cannot drift from what is applied
		var kb: Dictionary = GymSpend.KIT[k]
		var risk := roundi((float(kb["risk"]) - 1.0) * 100)
		words[k] = "Kit kept up: no effect either way." if k == "standard" else "%s: training injury risk %+d%%%s." % [
			"Worn kit" if risk > 0 else "Fresh kit", risk, (", %d more members stay" % int(kb["members"])) if int(kb["members"]) > 0 else ""]
	card[1].add_child(UI.label(str(words.get(c.kit_level, words["standard"])), UI.BODY, UI.FG, "body", true))
	# Round 2 (critic B: one risk line with its reasons, not five percentages).
	var r := GymSpend.train_risk(c)
	var level := "low" if r <= 0.8 else ("high" if r > 1.05 else "normal")
	var why: Array = []
	if GymUpgrades.ready(c.upgrades, "mats", c.day):
		why.append("the matted floor")
	if c.staff_roles.has("strength"):
		why.append("the S&C coach")
	if c.kit_level != "standard":
		why.append("%s kit" % str(GymSpend.kit(c)["name"]).to_lower())
	var rl := UI.label("Training injury risk: %s%s." % [level, (" (" + ", ".join(why) + ")") if not why.is_empty() else ""], UI.BODY,
		UI.GREEN if level == "low" else (UI.RED if level == "high" else UI.FG), "bold", true)
	rl.name = "RiskLine"
	card[1].add_child(rl)


static func _grant(body: Container, main: Node, c: Career) -> void:
	body.add_child(UI.caps("CLUB GRANT"))
	if c.grant.has("due"):
		body.add_child(UI.muted("A bid is in: the answer comes on %s." % Clock.fmt(int(c.grant["due"])), UI.SMALL, true))
		return
	var why := Grants.blocked(c.day, c.grant, GymSpend.youth_on(c), c.staff_roles.has("assistant") or c.extra_coaches > 0)
	var b := UI.button("Bid for a grant", "Btn", main.act.bind("grantbid", ""), why != "", why)
	b.name = "GrantBid"
	body.add_child(UI.row("A small club grant, %s-%s, once a year" % [UI.money(Grants.AMOUNT.x), UI.money(Grants.AMOUNT.y)],
		"About %d%% of bids win; it needs a youth section and a second coach. %s" % [roundi(Grants.chance(c.reputation) * 100),
			"" if why == "" else "Now: " + why + "."], Color(0, 0, 0, 0), [b]))


static func _show(parent: Container, main: Node, c: Career) -> void:
	var card := UI.card("CLUB SHOW")
	card[0].name = "ClubShow"
	card[0].size_flags_horizontal = Control.SIZE_EXPAND_FILL
	parent.add_child(card[0])
	var booked := int(c.show.get("day", -1))
	if booked >= 0:
		card[1].add_child(UI.label("Booked for %s. Paid %s for the hall, officials, doctor and ambulance, trophies." % [Clock.fmt(booked), UI.money(ClubShow.COST)],
			UI.BODY, UI.FG, "body", true))
	else:
		var pv := GymSpend.show_preview(c)
		card[1].add_child(UI.label("Host a show: %s up front. Expect %d-%d tickets at %s and a raffle of %s-%s: the night %s to %s after the hall." % [
			UI.money(ClubShow.COST), int(pv["lo"]), int(pv["hi"]), UI.money(ClubShow.TICKET), UI.money(ClubShow.RAFFLE.x), UI.money(ClubShow.RAFFLE.y),
			UI.signed(int(pv["net_lo"])), UI.signed(int(pv["net_hi"]))],
			UI.BODY, UI.FG, "body", true))
		card[1].add_child(UI.muted("Tickets follow the members, the gym's name, its own amateurs on the bill and, with a youth section, the juniors' families.",
			UI.SMALL, true))
		var ok := ClubShow.can_book(c.day, booked, int(c.show.get("last", -1)))
		var why := "" if ok else "the next show can be booked from %s" % Clock.fmt(int(c.show.get("last", 0)) + ClubShow.EVERY_DAYS - ClubShow.LEAD_DAYS)
		if why == "" and c.cash < ClubShow.COST:
			why = "not enough cash"
		var b := UI.button("Book the show, %s" % UI.money(ClubShow.COST), "Btn", main.act.bind("bookshow", ""), why != "", why)
		b.name = "BookShow"
		card[1].add_child(b)
		if why != "":
			card[1].add_child(UI.muted("Not yet: %s." % why, UI.SMALL, true))
	_grant(card[1], main, c)
	var last: Dictionary = c.show.get("night", {})
	if not last.is_empty():
		card[1].add_child(UI.kv("Last show, %s" % Clock.fmt(int(c.show.get("last", 0))), "%d sold, %s after the hall" % [int(last["sold"]), UI.signed(int(last["net"]))],
			UI.GREEN if int(last["net"]) > 0 else UI.RED, "mono"))
