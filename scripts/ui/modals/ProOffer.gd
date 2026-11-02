extends PanelContainer
## A promoter's offer to turn her pro: the debut's money (S329 update 31: the tickets she would sell as a picture, her
## share, what the gym pays now), what the gym gives up, sign or stay amateur.

const UI := preload("res://scripts/ui/UI.gd")
const Roster := preload("res://scripts/state/Roster.gd")
const BoutRules := preload("res://scripts/rules/BoutRules.gd")
const GameMoney := preload("res://scripts/rules/GameMoney.gd")
const ProDebut := preload("res://scripts/rules/ProDebut.gd")
const TicketBar := preload("res://scripts/ui/TicketBar.gd")


func build(main: Node, m: Dictionary) -> void:
	theme_type_variation = "Modal"
	custom_minimum_size = Vector2(960, 0)
	var c: Career = main.career
	var o := c.pro_offer
	var f: Dictionary = c.fighter_by_id(str(m["fid"]))
	var sheet := Roster.debut_sheet(c, f, float(o["terms"]))
	var night: Dictionary = sheet["night"]
	var v := UI.vbox(10)
	add_child(v)
	v.add_child(UI.caps("A CALL FROM %s" % str(o["promoter"]).to_upper()))
	v.add_child(UI.display("TURN %s PRO?" % str(f["first"]).to_upper(), 48))
	v.add_child(UI.muted("%s, amateur %d-%d, number %d in the %s rankings." % [f["name"], f["w"], f["l"], int(f.get("rank", 0)),
		str(f["wc"]).to_lower()] if int(f.get("rank", 0)) > 0 else "%s, amateur %d-%d." % [f["name"], f["w"], f["l"]], UI.BODY, true))
	var debut := UI.card("THE DEBUT: %d ROUNDS IN %d WEEKS, %d TICKETS AT %s TO SELL" % [Roster.PRO_ROUNDS, Roster.PRO_DEBUT_WEEKS,
		ProDebut.TICKETS, UI.money(ProDebut.TICKET_PRICE)])
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
	UI.add_rows(debut[1], [
		UI.kv("Fighter's half of the %d past %d" % [int(night["above"]), ProDebut.BREAK_EVEN], UI.money(int(night["share"])),
			UI.GREEN if int(night["share"]) > 0 else UI.AMBER),
		UI.kv("The gym's %d%% of it (manager + trainer)" % int(Roster.GYM_SHARE * 100), UI.money(int(night["gym"])), UI.GREEN),
	])
	if int(night["above"]) == 0:
		debut[1].add_child(UI.muted("Under %d sold, the debut pays nothing. More members, more wins and titles sell more tickets." % ProDebut.BREAK_EVEN, UI.SMALL, true))
	var grid := UI.hbox(16)
	v.add_child(grid)
	var now := UI.card("THE GYM PAYS NOW")
	now[0].name = "PaysNow"
	var rows: Array = [UI.kv("BBBofC licence", UI.money(ProDebut.LICENCE))]
	if not bool(f.get("licensed", false)):
		rows.append(UI.kv("Brain scans, medical, bloods", UI.money(ProDebut.MEDICALS)))
	if not Roster.trainer_licensed(c):
		rows.append(UI.kv("%s's trainer licence" % str(c.coach.get("name", "Your coach")), UI.money(ProDebut.CORNER_LICENCE)))
	rows.append(UI.kv("Total", "-" + UI.money(int(sheet["costs"])), UI.RED))
	UI.add_rows(now[1], rows)
	grid.add_child(now[0])
	var lose := UI.card("WHAT ENDS")
	UI.add_rows(lose[1], [
		UI.kv("Club stipend", "%s a week stops" % UI.money(GameMoney.FIGHTER_STIPEND)),
		UI.kv("Amateur bouts and rankings", "end for good"),
		UI.kv("Club ticket cut", "%s a bout ends" % UI.money(BoutRules.TICKET_CUT), UI.RED),
		UI.kv("A pro loss", "costs more than an amateur one"),
	])
	grid.add_child(lose[0])
	v.add_child(UI.muted("After the debut: %s a bout, +%s a win, up to %s; the gym keeps %d%%. Stay amateur and the promoters come back after %d more wins (the second time on worse terms)." % [
		UI.money(int(o["purse"])), UI.money(int(o["step"])), UI.money(int(o["top"])), int(Roster.GYM_SHARE * 100), Roster.PRO_RETURN_WINS], UI.SMALL, true))
	var foot := UI.hbox(10)
	foot.add_child(UI.spacer())
	var stay := UI.button("Stay amateur", "BtnQuiet", main.act.bind("declinepro", ""))
	stay.name = "DeclinePro"
	foot.add_child(stay)
	var go := UI.button("Turn %s pro" % f["first"], "BtnSolid", main.act.bind("turnpro", ""))
	go.name = "TurnPro"
	foot.add_child(go)
	v.add_child(foot)


## Who buys her tickets, in ProDebut's order, trimmed to the tickets she has: [{t, n, col}].
static func ticket_parts(c: Career, f: Dictionary) -> Array:
	var raw := [
		{"t": "Family and friends", "n": ProDebut.FAMILY, "col": UI.MUTED},
		{"t": "Gym members", "n": int(floor(maxi(0, c.members) * ProDebut.PER_MEMBER)), "col": UI.GOLD},
		{"t": "%d wins" % int(f["w"]), "n": ProDebut.PER_WIN * maxi(0, int(f["w"])), "col": Color("#7fb3e6")},
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
