extends PanelContainer
## A promoter's offer to turn her pro: the terms, what the gym gains and gives up, sign or stay amateur.

const UI := preload("res://scripts/ui/UI.gd")
const Roster := preload("res://scripts/state/Roster.gd")
const BoutRules := preload("res://scripts/rules/BoutRules.gd")
const GameMoney := preload("res://scripts/rules/GameMoney.gd")


func build(main: Node, m: Dictionary) -> void:
	theme_type_variation = "Modal"
	custom_minimum_size = Vector2(900, 0)
	var c: Career = main.career
	var o := c.pro_offer
	var f: Dictionary = c.fighter_by_id(str(m["fid"]))
	var v := UI.vbox(10)
	add_child(v)
	v.add_child(UI.caps("A CALL FROM %s" % str(o["promoter"]).to_upper()))
	v.add_child(UI.display("TURN %s PRO?" % str(f["first"]).to_upper(), 48))
	v.add_child(UI.muted("%s, amateur %d-%d, number %d in the %s rankings." % [f["name"], f["w"], f["l"], int(f.get("rank", 0)),
		str(f["wc"]).to_lower()] if int(f.get("rank", 0)) > 0 else "%s, amateur %d-%d." % [f["name"], f["w"], f["l"]], UI.BODY, true))
	var grid := UI.hbox(16)
	v.add_child(grid)
	var gain := UI.card("THE CONTRACT")
	UI.add_rows(gain[1], [
		UI.kv("Debut", "%d rounds, in %d weeks" % [Roster.PRO_ROUNDS, Roster.PRO_DEBUT_WEEKS]),
		UI.kv("Her purse", "%s, +%s a win, up to %s" % [UI.money(int(o["purse"])), UI.money(int(o["step"])), UI.money(int(o["top"]))]),
		UI.kv("The gym's share (manager + trainer)", "%d%%: %s on the debut" % [int(Roster.GYM_SHARE * 100), UI.money(Roster.gym_cut(int(o["purse"])))], UI.GREEN),
		UI.kv("Her signing fee", "paid by the promoter"),
	])
	grid.add_child(gain[0])
	var lose := UI.card("WHAT ENDS")
	UI.add_rows(lose[1], [
		UI.kv("Club stipend", "%s a week stops" % UI.money(GameMoney.FIGHTER_STIPEND)),
		UI.kv("Amateur bouts and rankings", "end for good"),
		UI.kv("Club ticket cut", "%s a bout ends" % UI.money(BoutRules.TICKET_CUT), UI.RED),
		UI.kv("A pro loss", "costs more than an amateur one"),
	])
	grid.add_child(lose[0])
	v.add_child(UI.muted("Stay amateur and the promoters come back after %d more wins (the second time on worse terms)." % Roster.PRO_RETURN_WINS, UI.SMALL, true))
	var foot := UI.hbox(10)
	foot.add_child(UI.spacer())
	var stay := UI.button("Stay amateur", "BtnQuiet", main.act.bind("declinepro", ""))
	stay.name = "DeclinePro"
	foot.add_child(stay)
	var go := UI.button("Turn %s pro" % f["first"], "BtnSolid", main.act.bind("turnpro", ""))
	go.name = "TurnPro"
	foot.add_child(go)
	v.add_child(foot)
