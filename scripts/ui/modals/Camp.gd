extends PanelContainer
## SET CAMP: pick what the camp builds (focus), how hard (protocol) and film study on the opponent. The camp also cuts
## her to the limit.

const UI := preload("res://scripts/ui/UI.gd")
const Data := preload("res://scripts/state/Data.gd")
const BoutRules := preload("res://scripts/rules/BoutRules.gd")


func build(main: Node, m: Dictionary) -> void:
	theme_type_variation = "Modal"
	custom_minimum_size = Vector2(980, 0)
	var c: Career = main.career
	var f: Dictionary = c.fighter_by_id(str(m["fid"]))
	var opp: Dictionary = f["bout"]["opp"]
	var v := UI.vbox(10)
	add_child(v)
	v.add_child(UI.caps("%s VS %s, %s" % [str(f["name"]).to_upper(), str(opp["name"]).to_upper(), Clock.fmt(int(f["bout"]["day"])).to_upper()]))
	v.add_child(UI.display("FIGHT CAMP", 48))
	v.add_child(UI.muted("Pick what the camp builds. It also cuts her to %.1f kg (she is %.1f kg now)." % [f["limit"], f["weight"]], UI.BODY, true))
	v.add_child(UI.caps("FOCUS"))
	var focus_row := UI.hbox(8)
	for key in BoutRules.CAMP_FOCUSES:
		var b := UI.button(Data.LABEL[key], "ChoiceOn" if str(m["focus"]) == key else "Choice", main.act.bind("cfocus", key))
		b.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		b.name = "Focus_" + key
		focus_row.add_child(b)
	v.add_child(focus_row)
	v.add_child(UI.caps("PROTOCOL"))
	var proto_row := UI.hbox(8)
	for i in [1, 2, 3]:
		var p: Dictionary = BoutRules.PROTOCOLS[i]
		var on: bool = int(m["protocol"]) == int(i)
		var b := UI.button2(p["name"], p["blurb"], "ChoiceOn" if on else "Choice", main.act.bind("cproto", str(i)),
			Vector2(0, 64), UI.FG, UI.MUTED)
		b.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		b.name = "Protocol_%d" % i
		proto_row.add_child(b)
	v.add_child(proto_row)
	var film := UI.button2("Film study on %s: %s" % [opp["name"], "yes, %s" % UI.money(BoutRules.FILM_COST) if bool(m["film"]) else "no"],
		"her threat and her weakness, depth 3 of 3 (click to switch)",
		"ChoiceOn" if bool(m["film"]) else "Choice", main.act.bind("cfilm", ""), Vector2(0, 64), UI.FG, UI.MUTED)
	film.name = "Film"
	v.add_child(film)
	var cost := BoutRules.camp_cost(int(m["protocol"]), bool(m["film"]))
	var foot := UI.hbox(10)
	foot.add_child(UI.spacer())
	foot.add_child(UI.button("Later", "BtnQuiet", main.act.bind("close", "")))
	var start := UI.button("Start the camp" + (", " + UI.money(cost) if cost > 0 else ""), "BtnSolid", main.act.bind("startcamp", ""))
	start.name = "StartCamp"
	foot.add_child(start)
	v.add_child(foot)
