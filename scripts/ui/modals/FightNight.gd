extends PanelContainer
## Fight night in words: the tale of the tape, three rounds with a corner call between them, then the scorecards and what
## decided it. Bouts.fight_step moves it on; this draws whichever step the moment is at.

const UI := preload("res://scripts/ui/UI.gd")
const Data := preload("res://scripts/state/Data.gd")
const Tape := preload("res://scripts/ui/Tape.gd")
const BoutRules := preload("res://scripts/rules/BoutRules.gd")
const ComboWords := preload("res://scripts/rules/ComboWords.gd")
const CornerCard := preload("res://scripts/rules/CornerCard.gd")


func build(main: Node, m: Dictionary) -> void:
	theme_type_variation = "Modal"
	custom_minimum_size = Vector2(1040, 0)
	var v := UI.vbox(12)
	add_child(v)
	match str(m["step"]):
		"tape":
			_tape(main, v, m)
		"round":
			_round(main, v, m)
		"result":
			_result(main, v, m)


func _tape(main: Node, v: VBoxContainer, m: Dictionary) -> void:
	var c: Career = main.career
	var f: Dictionary = c.fighter_by_id(str(m["fid"]))
	var opp: Dictionary = f["bout"]["opp"]
	v.add_child(UI.caps("FIGHT NIGHT, %s" % Clock.fmt(c.day).to_upper()))
	v.add_child(UI.display("TALE OF THE TAPE", 48))
	var camp := "none"
	var fc: Dictionary = f["camp"]
	if not fc.is_empty():
		camp = "%s, %s" % [Data.LABEL[fc["focus"]], str(BoutRules.PROTOCOLS[int(fc["protocol"])]["name"]).to_lower()]
	v.add_child(Tape.make(f["name"], "red corner", [
		["Record", "%d-%d" % [f["w"], f["l"]]], ["Weight", "%.1f kg" % f["weight"]], ["Camp", camp],
		["Film on her", "depth %d of 3" % int(f["bout"]["film"])],
	], opp["name"], "blue corner, %s" % opp["club"], [
		["Record", "%d-%d" % [opp["w"], opp["l"]]], ["Style", opp["style"]], ["Threat", opp["threat"]],
		["Weakness", opp["weak"] if int(f["bout"]["film"]) >= BoutRules.FILM_DEPTH_WITH_STUDY else "unknown: no film study"],
	]))
	var total := int(m.get("total", BoutRules.ROUNDS))
	v.add_child(UI.note("%s rounds of three minutes%s. You talk to her in the corner between rounds." % [
		"Three" if total == 3 else "Four", ", her pro debut" if total > BoutRules.ROUNDS else ""]))
	var foot := UI.hbox(10)
	foot.add_child(UI.spacer())
	foot.add_child(UI.button("Sim to result", "BtnQuiet", main.act.bind("fightstep", "sim")))
	var begin := UI.button("Begin fight", "BtnSolid", main.act.bind("fightstep", "start"))
	begin.name = "Begin"
	foot.add_child(begin)
	v.add_child(foot)


static func _energy_word(e: float) -> String:
	var band := ComboWords.band(e)
	if band == "fresh":
		return "fresh (%d)" % int(e)
	return ("tiring (%d)" if band == "tiring" else "nearly empty (%d)") % int(e)


func _round(main: Node, v: VBoxContainer, m: Dictionary) -> void:
	var rounds: Array = m["rounds"]
	var last: Dictionary = rounds[rounds.size() - 1]
	var n := int(m["round"])
	var total := int(m.get("total", BoutRules.ROUNDS))
	v.add_child(UI.caps("ROUND %d OF %d" % [n, total]))
	v.add_child(UI.display("HER ROUND" if bool(last["won"]) else "THEIR ROUND", 48, UI.GREEN if bool(last["won"]) else UI.RED))
	if str(last["corner"]) != "":
		v.add_child(UI.muted("Your call: \"%s\"" % BoutRules.CORNER[last["corner"]], UI.SMALL))
	var beats := UI.vbox(6)
	for line in last["lines"]:
		beats.add_child(UI.label(line, 22, UI.FG, "body", true))
	v.add_child(beats)
	var so_far: Array = []
	for r in rounds:
		so_far.append("red" if bool(r["won"]) else "blue")
	v.add_child(UI.muted("Rounds so far: " + ", ".join(so_far), UI.SMALL))
	# S302 energy: what each has left at the bell (the minute's rest gives some back; combos and the call spend it).
	var en: Dictionary = last.get("energy", {})
	if not en.is_empty():
		var opp: Dictionary = main.career.fighter_by_id(str(m["fid"]))["bout"]["opp"]
		v.add_child(UI.muted("Energy at the bell: %s %s, %s %s. The minute's rest gives some back." % [
			main.career.fighter_by_id(str(m["fid"]))["first"], _energy_word(float(en.get("a_end", 100.0))),
			opp["first"], _energy_word(float(en.get("b_end", 100.0)))], UI.SMALL, true))
		# S303 Kalli K-COMBOWORDS1: the corner reads her tank in a line.
		var said := ComboWords.energy_line(float(en.get("a_end", 100.0)), str(main.career.fighter_by_id(str(m["fid"]))["first"]), n * 7 + main.career.day)
		if said != "":
			v.add_child(UI.label(said, 20, UI.FG, "body", true))
	var stop := str(last.get("stopped", ""))
	if stop != "":
		v.add_child(UI.display("STOPPED: %s" % ("KNOCKOUT" if stop == "KO" else "REFEREE STOPS IT"), 32, UI.AMBER))
	# S303 corner card (watched rounds only: the 3D view reads it off the beats it played).
	var advice := ""
	if last.has("card") and stop == "":
		var fname := str(main.career.fighter_by_id(str(m["fid"]))["first"])
		var oname := str(main.career.fighter_by_id(str(m["fid"]))["bout"]["opp"]["first"])
		var cc := CornerCard.card(last["card"], float(en.get("a_end", 100.0)), [fname, oname])
		var grid := UI.vbox(2)
		for row in [["WORKED", cc["worked"], UI.GREEN], ["HURT", cc["hurt"], UI.RED], ["COACH", "\"%s.\" %s" % [BoutRules.CORNER[cc["call"]], cc["why"]], UI.AMBER]]:
			var line := UI.hbox(10)
			var tag := UI.caps(str(row[0]))
			tag.custom_minimum_size = Vector2(90, 0)
			tag.add_theme_color_override("font_color", row[2])
			line.add_child(tag)
			var said_row := UI.label(str(row[1]), 20, UI.FG, "body", true)
			said_row.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			line.add_child(said_row)
			grid.add_child(line)
		v.add_child(grid)
		advice = str(cc["call"]) if n < total else ""
	if n < total and stop == "":
		v.add_child(UI.caps("IN THE CORNER: WHAT DO YOU TELL HER?"))
		var calls := UI.hbox(8)
		for k in BoutRules.CORNER.keys():
			var b := UI.button(BoutRules.CORNER[k] + ("  (coach)" if str(k) == advice else ""), "Choice", main.act.bind("fightstep", "corner:" + str(k)))
			b.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			b.name = "Corner_" + str(k)
			b.tooltip_text = {"calm": "She throws fewer combinations: saves her energy.", "body": "More combinations to the body: spends more energy.",
				"long": "Her usual work rate."}.get(str(k), "")
			calls.add_child(b)
		v.add_child(calls)
	else:
		var foot := UI.hbox(10)
		foot.add_child(UI.spacer())
		var cards := UI.button("To the scorecards" if stop == "" else "To the result", "BtnSolid", main.act.bind("fightstep", "end"))
		cards.name = "Scorecards"
		foot.add_child(cards)
		v.add_child(foot)


func _result(main: Node, v: VBoxContainer, m: Dictionary) -> void:
	var c: Career = main.career
	var f: Dictionary = c.fighter_by_id(str(m["fid"]))
	var opp: Dictionary = f["bout"]["opp"]
	var win := bool(m["win"])
	var outcome := str(m.get("outcome", "win" if win else "loss"))
	v.add_child(UI.caps("THE RESULT" + (": HER PRO DEBUT" if bool(m.get("pro", false)) else "")))
	var stop := str(m.get("stopped", ""))
	var by := "ON POINTS" if stop == "" else ("BY KNOCKOUT" if stop == "KO" else "BY STOPPAGE")
	var head := "A DRAW" if outcome == "draw" else "%s WINS %s" % [(str(f["first"]) if win else str(opp["first"])).to_upper(), by]
	v.add_child(UI.display(head, 48, UI.GREEN if win else (UI.AMBER if outcome == "draw" else UI.RED)))
	if stop == "":
		v.add_child(UI.mono("Scorecards: " + ", ".join(m["cards"]), UI.BODY))
	else:
		v.add_child(UI.mono("Stopped in round %d of %d" % [(m["rounds"] as Array).size(), int(m.get("total", BoutRules.ROUNDS))], UI.BODY))
	var why := UI.card("WHAT DECIDED IT")
	var rows: Array = []
	for w in m["why"]:
		rows.append(UI.label(w, UI.BODY, UI.FG, "body", true))
	if rows.is_empty():
		rows.append(UI.muted("A close night: the rolls of the rounds decided it.", UI.BODY))
	UI.add_rows(why[1], rows)
	v.add_child(why[0])
	var money := UI.hbox(16)
	var cut := UI.card()
	if bool(m.get("pro", false)):
		cut[1].add_child(UI.kv("The gym's purse share", UI.signed(int(m.get("gym_cut", 0))), UI.GREEN, "mono"))
	else:
		cut[1].add_child(UI.kv("Club ticket cut", UI.signed(BoutRules.TICKET_CUT), UI.GREEN, "mono"))
	money.add_child(cut[0])
	var members := UI.card()
	members[1].add_child(UI.kv("Members after the news", "+%d" % BoutRules.WIN_MEMBERS if win else "no change"))
	money.add_child(members[0])
	v.add_child(money)
	var foot := UI.hbox(10)
	foot.add_child(UI.spacer())
	var home := UI.button("Back home", "BtnSolid", main.act.bind("afterfight", ""))
	home.name = "BackHome"
	foot.add_child(home)
	v.add_child(foot)
