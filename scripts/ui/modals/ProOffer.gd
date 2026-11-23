extends PanelContainer
## The promoter's offer to turn the boxer pro. S543 TURNPROBUILD17 step 4 (turning pro v17, owner Q-S294-320 / Q-S294-323;
## map DESIGN_TURNPRO1_V17.md section 7): ONE promoter, one offer - the purse; pro fight 1's two bouts (the promoter's
## tune-up and a step up) with today's chance and the same two chances four weeks on (four weeks of the club's training on
## the current focus, ProPair.trained, read the same way); the three patience marks; Turn pro now / Not yet. With no mark
## left the call is a rival gym's: Turn pro now / Let the boxer go. The debut's tickets and what the gym pays at signing
## stay (S329 update 31). The two houses, the asks and the counter-offers are gone (v2, cut by the owner).

const Palette := preload("res://scripts/ui/Palette.gd")
const UI := preload("res://scripts/ui/UI.gd")
const Roster := preload("res://scripts/state/Roster.gd")
const BoutRules := preload("res://scripts/rules/BoutRules.gd")
const GameMoney := preload("res://scripts/rules/GameMoney.gd")
const ProDebut := preload("res://scripts/rules/ProDebut.gd")
const ProCall := preload("res://scripts/rules/ProCall.gd")
const ProOfferWire := preload("res://scripts/state/ProOfferWire.gd")
const ProStart := preload("res://scripts/rules/ProStart.gd")
const Data := preload("res://scripts/state/Data.gd")
const Champs := preload("res://scripts/state/Champs.gd")
const TicketBar := preload("res://scripts/ui/TicketBar.gd")


func build(main: Node, m: Dictionary) -> void:
	theme_type_variation = "Modal"
	var c: Career = main.career
	var o := c.pro_offer
	var f: Dictionary = c.fighter_by_id(str(m["fid"]))
	var rival := bool(o.get("rival", false))
	custom_minimum_size = Vector2(1100, 0)
	var sheet := Roster.debut_sheet(c, f, 1.0)
	var v := UI.vbox(8)
	add_child(v)
	v.add_child(UI.caps("A RIVAL GYM CALLS" if rival else "A CALL FROM %s" % str(o["promoter"]).to_upper()))
	v.add_child(UI.display("TURN %s PRO?" % str(f["first"]).to_upper(), 44))
	var record := "Amateur %d-%d, number %d in the %s rankings." % [f["w"], f["l"], int(f.get("rank", 0)), str(f["wc"]).to_lower()] if int(f.get("rank", 0)) > 0 else "Amateur %d-%d." % [f["w"], f["l"]]
	var facts: Array = [record, "Purse %s, +%s a win up to %s." % [UI.money(int(o["purse"])), UI.money(int(o["step"])), UI.money(int(o["top"]))]]   # S448: the name is in the title
	var age_line := ProCall.age_line(int(f.get("age", 22)))
	if age_line != "":
		facts.append(age_line)
	v.add_child(UI.muted(" ".join(facts), UI.BODY, true))
	if rival:
		var rl := UI.label("No patience left: a rival gym wants the boxer now. Turn pro now, or the boxer leaves the club for good.", UI.BODY, UI.RED, "bold", true)
		rl.name = "RivalCall"
		v.add_child(rl)
	v.add_child(patience_row(f.get("pro_start", {})))
	v.add_child(_pair_card(o, f))
	_tickets(v, c, f)
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
	v.add_child(UI.muted("WHAT ENDS: the club stipend (%s a week), amateur bouts and rankings for good, the club ticket cut (%s a bout, about %s a week). The gym keeps %d%% of each pro purse." % [
		UI.money(GameMoney.FIGHTER_STIPEND), UI.money(BoutRules.TICKET_CUT), UI.money(ProCall.LOST_CUT_A_WEEK), roundi(Roster.signing_share(f) * 100)], UI.SMALL, true))
	if Roster.signing_share(f) < Roster.GYM_SHARE:
		v.add_child(UI.muted("Loyalty under 50: an outside manager signs the boxer and the club keeps only the trainer's %d%%." % int(round(Roster.signing_share(f) * 100)), UI.SMALL, true))
	var why := ProOfferWire.morale_line(f, bool(Champs.check(c, f).get("ok", false)))   # S534 (owner C442 "why morale drops")
	if why != "":
		var ml := UI.label(why, UI.SMALL, UI.RED, "bold", true)
		ml.name = "ProMorale"
		v.add_child(ml)
	var foot := UI.hbox(10)
	foot.add_child(UI.spacer())
	if rival:
		var go_away := UI.button("Let the boxer go", "BtnQuiet", main.act.bind("rivalgo", ""))
		go_away.name = "LetGo"
		go_away.tooltip_text = "The boxer leaves for the rival gym for good: the place on the roster frees, the club loses a little reputation."
		foot.add_child(go_away)
	else:
		var wait := UI.button("Not yet", "BtnQuiet", main.act.bind("declinepro", ""))
		wait.name = "DeclinePro"
		wait.tooltip_text = "Spends a patience mark and %d hunger; the promoter calls again in %d weeks. With no mark left a rival gym calls instead." % [
			-ProStart.NOT_YET_HUNGER, ProStart.NOT_YET_WEEKS]
		foot.add_child(wait)
	var go := UI.button("Turn pro now", "BtnSolid", main.act.bind("turnpro", ""))
	go.name = "TurnPro"
	go.tooltip_text = "Signs today: the debut is %d weeks out, picked on Fights from the promoter's tune-up or a step up." % Roster.PRO_DEBUT_WEEKS
	foot.add_child(go)
	v.add_child(foot)


## The three patience marks: gold = a Not yet still open, grey = spent. The third mark is the rival gym's call.
static func patience_row(s: Dictionary) -> Control:
	var h := UI.hbox(8)
	h.name = "Patience"
	h.mouse_filter = Control.MOUSE_FILTER_STOP
	h.tooltip_text = "How long the boxer waits for the move. Each Not yet spends a mark and %d hunger; with one mark left the next call is a rival gym's." % -ProStart.NOT_YET_HUNGER
	h.add_child(UI.label("PATIENCE", UI.SMALL, UI.MUTED, "caps"))
	var left := int(s.get("patience", ProStart.PATIENCE))
	for i in ProStart.PATIENCE:
		h.add_child(UI.dot(UI.GOLD if i < left else UI.MUTED))
	h.add_child(UI.label("%d Not yet left" % maxi(0, left - 1), UI.SMALL, UI.FG))
	return h


## Pro fight 1's two bouts side by side: today's chance and purse, and the trainer's read four weeks on.
static func _pair_card(o: Dictionary, f: Dictionary) -> Control:
	var card := UI.card("PRO FIGHT 1: TWO BOUTS, PICKED AFTER SIGNING")
	card[0].name = "Pair"
	var row := UI.hbox(16)
	card[1].add_child(row)
	var now: Dictionary = o.get("pair_now", {})
	var later: Dictionary = o.get("pair_later", {})
	for kind in ProStart.KINDS:
		if not now.has(kind):
			continue
		var b: Dictionary = now[kind]
		var col := UI.vbox(4)
		col.name = "Pair_" + kind
		col.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		col.add_child(UI.label(str(ProStart.KIND_NAMES[kind]).to_upper(), UI.BODY + 2, UI.GREEN if kind == "safe" else UI.AMBER, "bold"))
		var is_line := str(ProStart.KIND_IS[kind])
		col.add_child(UI.muted(is_line.left(1).to_upper() + is_line.substr(1), UI.SMALL))
		var ch := UI.kv("Win chance today", "about %d%%" % roundi(float(b["chance"]) * 100.0))
		ch.name = "Chance_" + kind
		ch.mouse_filter = Control.MOUSE_FILTER_STOP
		ch.tooltip_text = "The game's read of the bout, the boxer as today; the same number the fight is fought at."
		col.add_child(ch)
		if later.has(kind):
			var lt := UI.kv("In four weeks", "about %d%%" % roundi(float(later[kind]["chance"]) * 100.0), UI.GREEN if float(later[kind]["chance"]) > float(b["chance"]) + 0.005 else UI.FG)
			lt.name = "Later_" + kind
			lt.mouse_filter = Control.MOUSE_FILTER_STOP
			lt.tooltip_text = "Four more weeks of %s training, read the same way: what a Not yet would buy." % str(Data.LABEL.get(str(f.get("focus", "")), "the current")).to_lower()
			col.add_child(lt)
		col.add_child(UI.kv("Purse", UI.money(int(b["purse"]))))
		col.add_child(UI.kv("Name on a win", "+%d" % int(b["name"])))
		row.add_child(col)
	return card[0]


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


## Who buys her tickets, in ProDebut's order, trimmed to the tickets she has: [{t, n, col}].
static func ticket_parts(c: Career, f: Dictionary) -> Array:
	var raw := [
		{"t": "Family and friends", "n": ProDebut.FAMILY, "col": UI.MUTED},
		{"t": "Gym members", "n": int(floor(maxi(0, c.members) * ProDebut.PER_MEMBER)), "col": UI.GOLD},
		{"t": "%d wins" % int(f["w"]), "n": ProDebut.PER_WIN * maxi(0, int(f["w"])), "col": Palette.ACCENT},
		{"t": "Titles", "n": ProDebut.PER_TITLE * Roster.titles(f), "col": UI.GREEN},
		{"t": "Club show crowd", "n": int(f.get("followers", 0)), "col": UI.AMBER},   # S523 map M9: topping our own show
	]
	var left := ProDebut.TICKETS
	var out: Array = []
	for p in raw:
		var n := mini(int(p["n"]), left)
		left -= n
		if n > 0:
			out.append({"t": p["t"], "n": n, "col": p["col"]})
	return out
