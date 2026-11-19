extends PanelContainer
## A promoter's offer to turn her pro: the debut's money (S329 update 31: the tickets she would sell as a picture, her
## share, what the gym pays now), what the gym gives up, sign or stay amateur.
## S523 TURNPRO1B (design TURNPRO1 v2, his Q-227 yes): one or two houses side by side (who calls by the ticket forecast),
## each with its terms, the one ask and its answer shown before it is pressed, the gym's money and the boxer's apart, the
## pays-back line, morale on each button, the age line, declines left and the days the offer stands.

const Palette := preload("res://scripts/ui/Palette.gd")
const UI := preload("res://scripts/ui/UI.gd")
const Roster := preload("res://scripts/state/Roster.gd")
const BoutRules := preload("res://scripts/rules/BoutRules.gd")
const GameMoney := preload("res://scripts/rules/GameMoney.gd")
const ProDebut := preload("res://scripts/rules/ProDebut.gd")
const ProCall := preload("res://scripts/rules/ProCall.gd")
const ProOfferWire := preload("res://scripts/state/ProOfferWire.gd")
const GymBills := preload("res://scripts/rules/GymBills.gd")
const Needs := preload("res://scripts/state/Needs.gd")
const Champs := preload("res://scripts/state/Champs.gd")
const TicketBar := preload("res://scripts/ui/TicketBar.gd")


func build(main: Node, m: Dictionary) -> void:
	theme_type_variation = "Modal"
	var c: Career = main.career
	var o := c.pro_offer
	var f: Dictionary = c.fighter_by_id(str(m["fid"]))
	var offers: Array = o.get("offers", [])
	custom_minimum_size = Vector2(1240 if offers.size() > 1 else 960, 0)
	var sheet := Roster.debut_sheet(c, f, float(o["terms"]))
	var v := UI.vbox(8)
	add_child(v)
	v.add_child(UI.caps("A CALL FROM %s" % (" AND ".join(offers.map(func(t): return str(t["name"]).to_upper())) if not offers.is_empty() else str(o["promoter"]).to_upper())))
	v.add_child(UI.display("TURN %s PRO?" % str(f["first"]).to_upper(), 40 if not offers.is_empty() else 48))
	var record := "Amateur %d-%d, number %d in the %s rankings." % [f["w"], f["l"], int(f.get("rank", 0)), str(f["wc"]).to_lower()] if int(f.get("rank", 0)) > 0 else "Amateur %d-%d." % [f["w"], f["l"]]
	var facts: Array = [record]   # S448: the name is in the title
	if o.has("expires"):
		facts.append("The offer stands %d more days; only Stay amateur turns it down." % ProOfferWire.days_left(c))
	var age_line := ProCall.age_line(int(f.get("age", 22)))
	if age_line != "":
		facts.append(age_line)
	facts.append("Declines left before the door closes: %d." % maxi(0, 3 - int(f.get("pro_declines", 0))))
	v.add_child(UI.muted(" ".join(facts), UI.BODY, true))
	_tickets(v, c, f)
	if offers.is_empty():
		_legacy(v, c, f, sheet)
	else:
		var row := UI.hbox(16)
		v.add_child(row)
		var runway := GymBills.runway_weeks(c.cash, Needs.money_net(c))
		var nat := bool(Champs.check(c, f).get("ok", false))
		for i in offers.size():
			row.add_child(_house(main, c, f, offers[i], int(sheet["costs"]), runway, nat, i == 0))
	# S523: one line each (two houses side by side left no room for two cards on a 1080 screen)
	var pays := UI.hbox(8)
	pays.name = "PaysNow"
	var parts: Array = ["BBBofC licence %s" % UI.money(ProDebut.LICENCE)]
	if not bool(f.get("licensed", false)):
		parts.append("scans, medical, bloods %s" % UI.money(ProDebut.MEDICALS))
	if not Roster.trainer_licensed(c):
		parts.append("your coach's trainer licence %s" % UI.money(ProDebut.CORNER_LICENCE))
	pays.add_child(UI.label("THE GYM PAYS AT SIGNING:", UI.SMALL, UI.GOLD, "bold"))
	pays.add_child(UI.label("%s = -%s" % [", ".join(parts), UI.money(int(sheet["costs"]))], UI.SMALL, UI.RED, "bold"))
	v.add_child(pays)
	v.add_child(UI.muted("WHAT ENDS: the club stipend (%s a week), amateur bouts and rankings for good, the club ticket cut (%s a bout, about %s a week). A pro loss costs more than an amateur one." % [
		UI.money(GameMoney.FIGHTER_STIPEND), UI.money(BoutRules.TICKET_CUT), UI.money(ProCall.LOST_CUT_A_WEEK)], UI.SMALL, true))
	if Roster.signing_share(f) < Roster.GYM_SHARE:
		v.add_child(UI.muted("Loyalty under 50: an outside manager signs the boxer and the club keeps only the trainer's %d%%." % int(round(Roster.signing_share(f) * 100)), UI.SMALL, true))
	var foot := UI.hbox(10)
	foot.add_child(UI.spacer())
	var stay_d := ProOfferWire.morale(f, true, bool(Champs.check(c, f).get("ok", false)))
	var stay := UI.button("Stay amateur" + _mood(stay_d), "BtnQuiet", main.act.bind("declinepro", ""))
	stay.name = "DeclinePro"
	stay.tooltip_text = "The same house calls again after %d more wins, on 0.9x terms unless a title comes first." % Roster.PRO_RETURN_WINS
	foot.add_child(stay)
	if offers.is_empty():
		var go := UI.button("Turn pro", "BtnSolid", main.act.bind("turnpro", ""))
		go.name = "TurnPro"
		foot.add_child(go)
	v.add_child(foot)


## The tickets picture: who would buy them today, against the ticket house's break-even.
func _tickets(v: VBoxContainer, c: Career, f: Dictionary) -> void:
	var debut := UI.card("THE DEBUT: %d ROUNDS, %d TICKETS AT %s TO SELL" % [Roster.PRO_ROUNDS, ProDebut.TICKETS, UI.money(ProDebut.TICKET_PRICE)])
	debut[0].name = "Debut"
	v.add_child(debut[0])
	var bar := TicketBar.new()
	bar.name = "Tickets"
	bar.total = ProDebut.TICKETS
	bar.break_even = ProDebut.BREAK_EVEN
	bar.parts = ticket_parts(c, f)
	debut[1].add_child(bar)
	var legend := UI.hbox(14)
	for p in bar.parts:
		var item := UI.hbox(6)
		item.add_child(UI.dot(p["col"]))
		item.add_child(UI.label("%s %d" % [p["t"], int(p["n"])], UI.SMALL, UI.FG))
		legend.add_child(item)
	debut[1].add_child(legend)


## One house's column: terms, the ask, the money apart, the pays-back line, sign.
func _house(main: Node, c: Career, f: Dictionary, t: Dictionary, costs: int, runway: int, nat: bool, first: bool) -> Control:
	var key := str(t["key"])
	var card := UI.card()
	card[0].name = "House_" + key
	card[0].size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var b: VBoxContainer = card[1]
	var head := UI.hbox(12)   # S523: the house's badge (Ludo, assets/ui/art/promoters) beside its name
	var logo_path := "res://assets/ui/art/promoters/%s.png" % key
	if ResourceLoader.exists(logo_path):
		var logo := TextureRect.new()
		logo.name = "Logo"
		logo.texture = load(logo_path)
		logo.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		logo.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		logo.custom_minimum_size = Vector2(40, 40)
		head.add_child(logo)
	var name_l := UI.caps(str(t["name"]).to_upper())
	name_l.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	head.add_child(name_l)
	b.add_child(head)
	var be := int(t["break_even"])
	var purse_v := UI.money(int(t["purse"])) + (" guaranteed" if bool(t["guaranteed"]) else ", $%d less a ticket under %d (floor %s)" % [ProCall.SHORT_TICKET, be, UI.money(ProCall.PURSE_FLOOR)])
	UI.add_rows(b, [
		UI.kv("Debut purse", purse_v),
		UI.kv("Ticket share past %d sold" % be, "%d%% (%d sold today)" % [int(round(float(t["share"]) * 100)), int(ProOfferWire.money(c, f, t, costs, Roster.signing_share(f))["sold"])]),
		UI.kv("Debut", "%d weeks out, a debutant %.1f under" % [int(t["debut_weeks"]), float(t["opp_gap"])]),
		UI.kv("After the debut", "+%s a win, up to %s" % [UI.money(int(t["step"])), UI.money(int(t["top"]))]),
	])
	if float(t.get("factor", 1.0)) < 1.0:
		b.add_child(UI.muted("Second call: %d%% of the first terms." % int(round(float(t["factor"]) * 100)), UI.SMALL, true))
	var mon := ProOfferWire.money(c, f, t, costs, Roster.signing_share(f))
	UI.add_rows(b, [
		UI.kv("The gym at signing", UI.money(int(mon["gym_at_signing"])), UI.GREEN if int(mon["gym_at_signing"]) >= 0 else UI.RED),
		UI.kv("The gym each week after", UI.money(int(mon["weekly_after"])), UI.GREEN if int(mon["weekly_after"]) >= 0 else UI.RED),
		UI.kv("The boxer from the debut", UI.money(int(mon["boxer"])), UI.GREEN),
	])
	b.add_child(UI.label(ProCall.pays_back_line(mon), UI.SMALL, UI.FG, "body", true))
	_ask(main, c, b, key, runway)
	var d := ProOfferWire.morale(f, false, nat)
	var go := UI.button("Turn pro with %s%s" % [str(t["name"]), _mood(d)], "BtnSolid", main.act.bind("turnpro", key))
	go.name = "TurnPro" if first else "TurnPro_" + key
	b.add_child(go)
	return card[0]


## The one ask: spent (its answer, and Back to the plain offer after a counter) or the six with their answers.
func _ask(main: Node, c: Career, b: VBoxContainer, key: String, runway: int) -> void:
	var asked: Dictionary = (c.pro_offer.get("asked", {}) as Dictionary).get(key, {})
	if not asked.is_empty():
		b.add_child(UI.label("YOUR ASK: %s. %s" % [str(asked["label"]), str(asked["words"])], UI.SMALL, UI.GREEN, "body", true))
		if str(asked["answer"]) == "counter":
			var back := UI.button("Back to the plain offer", "BtnQuiet", main.act.bind("proplain", key))
			back.name = "Plain_" + key
			b.add_child(back)
		elif str(asked["answer"]) == "back":
			b.add_child(UI.muted("Back on the plain offer; the one ask is spent.", UI.SMALL, true))
		return
	b.add_child(UI.caps("ONE ASK (pick one)"))
	var grid := GridContainer.new()
	grid.columns = 2
	for e in ProOfferWire.answers(c, key, runway):
		var wont := str(e["answer"]) == "wont"
		var tag := "won't" if wont else ("counters" if str(e["answer"]) == "counter" else "will take it")
		var btn := UI.button("%s - %s" % [str(e["label"]), tag], "BtnQuiet", main.act.bind("proask", "%s|%s" % [key, e["kind"]]), wont, str(e["words"]))
		btn.name = "Ask_%s_%s" % [key, e["kind"]]
		btn.tooltip_text = str(e["words"])
		grid.add_child(btn)
	b.add_child(grid)


static func _mood(d: int) -> String:
	return "" if d == 0 else " (morale %+d)" % d


## No v2 offer (an old save): the S329 sheet.
func _legacy(v: VBoxContainer, c: Career, f: Dictionary, sheet: Dictionary) -> void:
	var night: Dictionary = sheet["night"]
	var o := c.pro_offer
	UI.add_rows(v, [
		UI.kv("Fighter's half of the %d past %d" % [int(night["above"]), ProDebut.BREAK_EVEN], UI.money(int(night["share"]))),
		UI.kv("The gym's %d%% of it" % int(Roster.GYM_SHARE * 100), UI.money(int(night["gym"])), UI.GREEN),
	])
	v.add_child(UI.muted("After the debut: %s a bout, +%s a win, up to %s." % [UI.money(int(o["purse"])), UI.money(int(o["step"])), UI.money(int(o["top"]))], UI.SMALL, true))


## Who buys her tickets, in ProDebut's order, trimmed to the tickets she has: [{t, n, col}].
static func ticket_parts(c: Career, f: Dictionary) -> Array:
	var raw := [
		{"t": "Family and friends", "n": ProDebut.FAMILY, "col": UI.MUTED},
		{"t": "Gym members", "n": int(floor(maxi(0, c.members) * ProDebut.PER_MEMBER)), "col": UI.GOLD},
		{"t": "%d wins" % int(f["w"]), "n": ProDebut.PER_WIN * maxi(0, int(f["w"])), "col": Palette.ACCENT},
		{"t": "Titles", "n": ProDebut.PER_TITLE * Roster.titles(f), "col": UI.GREEN},
	]
	var left := ProDebut.TICKETS
	var out: Array = []
	for p in raw:
		var n := mini(int(p["n"]), left)
		left -= n
		if n > 0:
			out.append({"t": p["t"], "n": n, "col": p["col"]})
	return out
