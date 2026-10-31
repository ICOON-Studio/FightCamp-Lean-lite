extends PanelContainer
## Fight night in words: the tale of the tape, three rounds with a corner call between them, then the scorecards and what
## decided it. Bouts.fight_step moves it on; this draws whichever step the moment is at.

const RoundGraphics := preload("res://scripts/ui/RoundGraphics.gd")
const UI := preload("res://scripts/ui/UI.gd")
const Data := preload("res://scripts/state/Data.gd")
const Tape := preload("res://scripts/ui/Tape.gd")
const BoutRules := preload("res://scripts/rules/BoutRules.gd")
const ComboWords := preload("res://scripts/rules/ComboWords.gd")
const CornerCard := preload("res://scripts/rules/CornerCard.gd")
const Exchanges := preload("res://scripts/rules/Exchanges.gd")
const LiveRound := preload("res://scripts/state/LiveRound.gd")
const CallButtons := preload("res://scripts/ui/CallButtons.gd")
const CornerJobsRow := preload("res://scripts/ui/CornerJobsRow.gd")
const ShoutBar := preload("res://scripts/fight3d/ShoutBar.gd")


func build(main: Node, m: Dictionary) -> void:
	theme_type_variation = "Modal"
	custom_minimum_size = Vector2(1040, 0)
	var v := UI.vbox(12)
	add_child(v)
	match str(m["step"]):
		"tape":
			_tape(main, v, m)
		"round":
			if LiveRound.live(m).is_empty():
				_round(main, v, m)
			else:
				_live(main, v, m)
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
	v.add_child(UI.note("%s rounds of three minutes%s. Every 30 seconds you can shout a call; read the clue, pick what fits, watch it work. In the corner between rounds you set her plan." % [
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


## S308: the round being fought. The clock, the exchanges so far, the clue the corner reads and the shout bar.
func _live(main: Node, v: VBoxContainer, m: Dictionary) -> void:
	var f: Dictionary = main.career.fighter_by_id(str(m["fid"]))
	var lv := LiveRound.live(m)
	var pv := LiveRound.preview(f, m)
	var exs: Array = lv["ex"]
	var left := int(Exchanges.EXCHANGES * Exchanges.EX_SECONDS - float(pv["at"]))
	v.add_child(UI.caps("ROUND %d OF %d   %d:%02d LEFT" % [int(lv["n"]), int(m.get("total", BoutRules.ROUNDS)), left / 60, left % 60]))
	var won := exs.filter(func(x): return bool(x["won"])).size()
	var la := 0
	var lb := 0
	for x in exs:
		la += int(x["landed"][0])
		lb += int(x["landed"][1])
	var names: Array = pv["names"]
	v.add_child(UI.display("EXCHANGES WON %d-%d" % [won, exs.size() - won], 40, UI.GREEN if won * 2 > exs.size() else (UI.RED if won * 2 < exs.size() else UI.FG)))
	# S310: both boxers' energy, body shots taken and hurt, as the 3D fight display shows them.
	var st := LiveRound.state(lv, exs.size())
	v.add_child(UI.muted("Punches landed: %s %d, %s %d." % [names[0], la, names[1], lb], UI.SMALL))
	for side in 2:
		v.add_child(UI.label("%s: energy %d, body shots taken %d%s" % [names[side], int(round(float(st["a" if side == 0 else "b"]))),
			int(st["body"][side]), ", HURT" if bool(st["hurt"][side]) else ""], UI.SMALL, UI.FG if float(st["a" if side == 0 else "b"]) >= 35.0 else UI.AMBER))
	var last: Dictionary = exs[-1]
	v.add_child(UI.label(str(last["verdict"]), 20, UI.GREEN if bool(last["won"]) else UI.RED, "body", true))
	if str(last.get("habit_line", "")) != "":
		v.add_child(UI.label(str(last["habit_line"]), 18, UI.AMBER, "body", true))
	v.add_child(UI.caps("WHAT YOU SEE"))
	v.add_child(UI.label(str(pv["clue"]), 24, UI.AMBER, "bold", true))
	v.add_child(UI.caps("WHAT DO YOU SHOUT TO %s?" % str(names[0]).to_upper()))
	v.add_child(UI.muted(ShoutBar.shout_note(int(pv["shouts"]), str(names[0])), UI.SMALL))
	var row := CallButtons.shout_row(pv["offers"], pv["grades"], str(pv["mark"]), names, func(k: String): main.act("fightstep", "shout:" + k))
	var now := CallButtons.now_button(pv.get("now", {}), names, func(k: String): main.act("fightstep", "shout:" + k))
	if now != null:
		row.add_child(now)
		row.move_child(now, 0)
	v.add_child(row)
	var foot := UI.hbox(10)
	foot.add_child(UI.spacer())
	var sim := UI.button("Sim the round", "BtnQuiet", main.act.bind("fightstep", "round_out"))
	sim.name = "SimRound"
	foot.add_child(sim)
	v.add_child(foot)


func _round(main: Node, v: VBoxContainer, m: Dictionary) -> void:
	var rounds: Array = m["rounds"]
	var last: Dictionary = rounds[rounds.size() - 1]
	var n := int(m["round"])
	var total := int(m.get("total", BoutRules.ROUNDS))
	var fname := str(main.career.fighter_by_id(str(m["fid"]))["first"])
	var oname := str(main.career.fighter_by_id(str(m["fid"]))["bout"]["opp"]["first"])
	v.add_child(UI.caps("ROUND %d OF %d" % [n, total]))
	v.add_child(UI.display("%s'S ROUND" % (fname if bool(last["won"]) else oname).to_upper(), 48, UI.GREEN if bool(last["won"]) else UI.RED))
	var ex_won := RoundGraphics.totals(last.get("exchanges", []))["won"] as Array
	if int(ex_won[0]) == int(ex_won[1]) and int(ex_won[0]) > 0:
		# S320: level on the 30-second exchanges, the round goes to whoever did more in them.
		v.add_child(UI.muted("Level on exchanges %d-%d: %s took it on the work done in them." % [ex_won[0], ex_won[1],
			fname if bool(last["won"]) else oname], UI.SMALL))
	if str(last["corner"]) != "":
		v.add_child(UI.muted("Your call: \"%s\"" % BoutRules.CORNER[last["corner"]], UI.SMALL))
	# S320 (operator: "these needs much better visuals for the player to understand what happenned"): the round as
	# pictures - who won each 30 seconds, the punches side by side between the two body maps, the energy left.
	var exs: Array = last.get("exchanges", [])
	var en: Dictionary = last.get("energy", {})
	if not exs.is_empty():
		v.add_child(UI.muted("Every 30 seconds: who won it", UI.TINY))
		v.add_child(RoundGraphics.strip(exs))
		var tot := RoundGraphics.totals(exs)
		var mid := UI.hbox(18)
		var bodies: Array = m.get("bodies", ["", ""])
		var fig_a := RoundGraphics.body(m.get("body_map", {}), "a", str(bodies[0]), "red")
		if fig_a != null:
			mid.add_child(fig_a)
		var bars := UI.vbox(10)
		bars.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		var names_row := UI.hbox(8)
		names_row.add_child(UI.label(fname.to_upper(), UI.SMALL, RoundGraphics.HERS.lightened(0.3), "bold"))
		names_row.add_child(UI.spacer())
		names_row.add_child(UI.label(oname.to_upper(), UI.SMALL, RoundGraphics.THEIRS.lightened(0.3), "bold"))
		bars.add_child(names_row)
		bars.add_child(RoundGraphics.versus([["Exchanges won", tot["won"][0], tot["won"][1]],
			["Punches landed", tot["landed"][0], tot["landed"][1]], ["To the body", tot["body"][0], tot["body"][1]]]))
		if not en.is_empty():
			bars.add_child(RoundGraphics.energy(float(en.get("a_end", 100.0)), float(en.get("b_end", 100.0))))
		mid.add_child(bars)
		var fig_b := RoundGraphics.body(m.get("body_map", {}), "b", str(bodies[1]), "blue")
		if fig_b != null:
			mid.add_child(fig_b)
		v.add_child(mid)
	else:
		var beats := UI.vbox(6)
		for line in last["lines"]:
			beats.add_child(UI.label(line, 22, UI.FG, "body", true))
		v.add_child(beats)
	var foot_row := UI.hbox(12)
	foot_row.add_child(RoundGraphics.rounds(rounds))
	foot_row.add_child(UI.spacer())
	if not en.is_empty():
		# S303 Kalli K-COMBOWORDS1: the corner reads her tank in a line.
		var said := ComboWords.energy_line(float(en.get("a_end", 100.0)), fname, n * 7 + main.career.day)
		if said != "":
			foot_row.add_child(UI.label(said, UI.SMALL, UI.FG, "body"))
	v.add_child(foot_row)
	var stop := str(last.get("stopped", ""))
	if stop != "":
		v.add_child(UI.display("STOPPED: %s" % ("KNOCKOUT" if stop == "KO" else "REFEREE STOPS IT"), 32, UI.AMBER))
	# S303 corner card (watched rounds only: the 3D view reads it off the beats it played).
	var advice := ""
	if (last.has("card") or last.has("exchanges")) and stop == "":
		var cc := CornerCard.card(last.get("card", CornerCard.summarize([])), float(en.get("a_end", 100.0)), [fname, oname])
		# S309: the exchanges' read already says the call in the coach's words.
		if not last.has("card") and not exs.is_empty():
			# S320: a skipped round has no punch-by-punch card - say what its exchanges landed (it read "nothing clean").
			var tt := RoundGraphics.totals(exs)
			cc["worked"] = "%s landed %d punches, %d to the body." % [fname, tt["landed"][0], tt["body"][0]]
			cc["hurt"] = "%s landed %d punches, %d to the body." % [oname, tt["landed"][1], tt["body"][1]]
		var coach_says := "\"%s\"" % cc["why"]
		if last.has("exchanges"):
			cc.merge(Exchanges.read(last["exchanges"], [fname, oname]), true)
			coach_says = "\"%s\"" % cc["why"]
		else:
			coach_says = "\"%s. %s\"" % [BoutRules.CORNER[cc["call"]], cc["why"]]
		var grid := HFlowContainer.new()   # S320: the corner card as three tiles
		grid.add_theme_constant_override("h_separation", 10)
		for row in [["WORKED", cc["worked"], UI.GREEN], ["HURT", cc["hurt"], UI.RED], ["COACH", coach_says, UI.AMBER]]:
			grid.add_child(RoundGraphics.tile(str(row[0]), str(row[1]), row[2]))
		v.add_child(grid)
		advice = str(cc["call"]) if n < total else ""
	if n < total and stop == "":
		v.add_child(UI.caps("IN THE CORNER: WHAT DO YOU TELL %s?" % fname.to_upper()))
		# S309: one fix for a habit the coach has seen (kept on the moment until the call is made).
		var fixes := LiveRound.fixes(main.career.fighter_by_id(str(m["fid"])), last)
		if not fixes.is_empty():
			v.add_child(UI.muted("Fix one habit for next round? (optional)", UI.SMALL))
			v.add_child(CallButtons.fix_row(fixes, [fname, oname], str(m.get("fix_pick", "")), func(h: String):
				m["fix_pick"] = h
				main.redraw_modal()))
		# S310 the other corner jobs: recover points, a combination set-up, the talk (CornerJobsRow).
		var fj: Dictionary = main.career.fighter_by_id(str(m["fid"]))
		var mn := CornerJobsRow.menu(fj, last)
		if not m.has("jobs_sel"):
			m["jobs_sel"] = CornerJobsRow.defaults(mn)
		v.add_child(CornerJobsRow.build(mn, m["jobs_sel"], [fname, oname], main.redraw_modal))
		var grades := {}
		for k in Exchanges.CALLS.keys():
			grades[k] = Exchanges.grade(str(k), LiveRound.values(fj))["word"]
		v.add_child(CallButtons.corner_grid(grades, advice, [fname, oname], func(k: String):
			var fx := str(m.get("fix_pick", ""))
			var jobs := CornerJobsRow.suffix(m.get("jobs_sel", {}))
			m.erase("fix_pick")
			m.erase("jobs_sel")
			main.act("fightstep", "corner:" + k + ("|fix=" + fx if fx != "" else "") + jobs)))
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
		v.add_child(RoundGraphics.judges(m["rounds"], m["cards"]))   # S320: each judge's card, round by round
	else:
		v.add_child(UI.mono("Stopped in round %d of %d" % [(m["rounds"] as Array).size(), int(m.get("total", BoutRules.ROUNDS))], UI.BODY))
	v.add_child(UI.caps("WHAT DECIDED IT"))
	var why: Array = m["why"]
	v.add_child(RoundGraphics.decided(why if not why.is_empty() else ["A close night: the rolls of the rounds decided it."]))
	var money := UI.hbox(10)
	if bool(m.get("pro", false)):
		money.add_child(RoundGraphics.tile("THE GYM'S PURSE SHARE", UI.signed(int(m.get("gym_cut", 0))), UI.GREEN, true))
	else:
		money.add_child(RoundGraphics.tile("CLUB TICKET CUT", UI.signed(BoutRules.TICKET_CUT), UI.GREEN, true))
	money.add_child(RoundGraphics.tile("MEMBERS AFTER THE NEWS", "+%d" % BoutRules.WIN_MEMBERS if win else "no change", UI.GOLD, true))
	v.add_child(money)
	var foot := UI.hbox(10)
	foot.add_child(UI.spacer())
	var home := UI.button("Back home", "BtnSolid", main.act.bind("afterfight", ""))
	home.name = "BackHome"
	foot.add_child(home)
	v.add_child(foot)
