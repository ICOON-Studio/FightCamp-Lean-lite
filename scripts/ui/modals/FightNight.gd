extends PanelContainer
## Fight night in words: the tale of the tape, three rounds with a corner call between them, then the scorecards and what
## decided it. Bouts.fight_step moves it on; this draws whichever step the moment is at.

const RoundGraphics := preload("res://scripts/ui/RoundGraphics.gd")
const Broadcast := preload("res://scripts/ui/Broadcast.gd")
const UI := preload("res://scripts/ui/UI.gd")
const Data := preload("res://scripts/state/Data.gd")
const Tape := preload("res://scripts/ui/Tape.gd")
const BoutRules := preload("res://scripts/rules/BoutRules.gd")
const ComboWords := preload("res://scripts/rules/ComboWords.gd")
const CornerCard := preload("res://scripts/rules/CornerCard.gd")
const Exchanges := preload("res://scripts/rules/Exchanges.gd")
const LiveRound := preload("res://scripts/state/LiveRound.gd")
const ReadPanel := preload("res://scripts/ui/ReadPanel.gd")
const CallButtons := preload("res://scripts/ui/CallButtons.gd")
const CornerJobsRow := preload("res://scripts/ui/CornerJobsRow.gd")
const PlanFight := preload("res://scripts/rules/PlanFight.gd")
const FightFlow := preload("res://scripts/rules/FightFlow.gd")
const FlowView := preload("res://scripts/ui/FlowView.gd")
const StrikeMap := preload("res://scripts/rules/StrikeMap.gd")
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
				# S323 (Q-S294-40 "Layout looks cheap / like a spreadsheet"): the round and result pages as broadcast graphics.
				remove_child(v)
				v.queue_free()
				_round(main, Broadcast.frame(self), m)
			else:
				_live(main, v, m)
		"result":
			remove_child(v)
			v.queue_free()
			_result(main, Broadcast.frame(self), m)


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
	var arrow_line := PlanFight.arrow_line(last, names)   # S339 the coach's arrow she used (or none on that card)
	if arrow_line != "":
		v.add_child(UI.label(arrow_line, 18, UI.GREEN if bool(last.get("planned", false)) and bool(last["won"]) else UI.MUTED, "body", true))
	if str(last.get("clinch_line", "")) != "":   # S340 the clinch: a breather, and what it cost her
		v.add_child(UI.label(str(last["clinch_line"]), 18, UI.AMBER if bool((last.get("clinch", {}) as Dictionary).get("hit", false)) else UI.MUTED, "body", true))
	if str(last.get("habit_line", "")) != "":
		v.add_child(UI.label(str(last["habit_line"]), 18, UI.AMBER, "body", true))
	v.add_child(UI.caps("WHAT YOU SEE"))
	v.add_child(UI.label(str(pv["clue"]), 24, UI.AMBER, "bold", true))
	if not (pv.get("read", {}) as Dictionary).is_empty():   # S333 THE READ
		v.add_child(ReadPanel.build(pv["read"], str(pv.get("read_call", "")), names, func(k: String): main.act("fightstep", "shout:" + k)))
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
	var won := bool(last["won"])
	var en: Dictionary = last.get("energy", {})
	var exs: Array = last.get("exchanges", [])
	var head := UI.hbox(16)
	var title := UI.vbox(0)
	title.add_child(UI.caps("ROUND %d OF %d" % [n, total]))
	title.add_child(UI.display("%s'S ROUND" % (fname if won else oname).to_upper(), 64, (Broadcast.HERS if won else Broadcast.THEIRS).lightened(0.25)))
	head.add_child(title)
	head.add_child(UI.spacer())
	var chips := RoundGraphics.rounds(rounds)
	chips.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	head.add_child(chips)
	v.add_child(head)
	var sub := []
	var ex_won := RoundGraphics.totals(exs)["won"] as Array
	if int(ex_won[0]) == int(ex_won[1]) and int(ex_won[0]) > 0:
		# S320: level on the 30-second exchanges, the round goes to whoever did more in them.
		sub.append("Level %d-%d on exchanges: %s took it on the work done in them." % [ex_won[0], ex_won[1], fname if won else oname])
	if str(last["corner"]) != "":
		sub.append("Your call: \"%s\"" % BoutRules.CORNER[last["corner"]])
	if not sub.is_empty():
		v.add_child(UI.muted("   ".join(sub), UI.SMALL))
	# S320 (operator: "these needs much better visuals for the player to understand what happenned"): who won each 30
	# seconds, then both fighters in their corners' light with the round's numbers between them.
	if not exs.is_empty():
		v.add_child(Broadcast.timeline(exs))
		var tot := RoundGraphics.totals(exs)
		var mid := UI.hbox(28)
		var bodies: Array = m.get("bodies", ["", ""])
		var fr: Dictionary = main.career.fighter_by_id(str(m["fid"]))
		mid.add_child(Broadcast.corner(RoundGraphics.body(m.get("body_map", {}), "a", str(bodies[0]), "red", m.get("body_track", {})), str(fr.get("name", fname)), Broadcast.HERS, false))
		var centre := UI.vbox(18)
		centre.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		centre.alignment = BoxContainer.ALIGNMENT_CENTER
		centre.add_child(Broadcast.compubox([["Exchanges won", tot["won"][0], tot["won"][1]],
			["Punches landed", tot["landed"][0], tot["landed"][1]], ["To the body", tot["body"][0], tot["body"][1]]]))
		if not en.is_empty():
			centre.add_child(Broadcast.tank(float(en.get("a_end", 100.0)), float(en.get("b_end", 100.0))))
			# S303 Kalli K-COMBOWORDS1: the corner reads her tank in a line.
			var said := ComboWords.energy_line(float(en.get("a_end", 100.0)), fname, n * 7 + main.career.day)
			if said != "":
				var sl := UI.label(said, UI.SMALL, UI.MUTED, "italic")
				sl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
				centre.add_child(sl)
		mid.add_child(centre)
		mid.add_child(Broadcast.corner(RoundGraphics.body(m.get("body_map", {}), "b", str(bodies[1]), "blue", m.get("body_track", {})), str(fr["bout"]["opp"].get("name", oname)), Broadcast.THEIRS, true))
		v.add_child(mid)
	else:
		var beats := UI.vbox(6)
		for line in last["lines"]:
			beats.add_child(UI.label(line, 22, UI.FG, "body", true))
		v.add_child(beats)
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
		# S323: what worked and what hurt are the numbers above; the coach speaks once, as a quote.
		v.add_child(Broadcast.quote(coach_says, "YOUR COACH"))
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


## S327 update 29 part B: which part of her went first, the change since her last bout, and one click to train it next week.
func _body_report(main: Node, m: Dictionary) -> HBoxContainer:
	var row := UI.hbox(18)
	var rep: Dictionary = m.get("body_report", {})
	if rep.is_empty():
		return row
	var col := UI.vbox(4)
	col.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var t := UI.caps("BODY REPORT")
	t.add_theme_color_override("font_color", UI.GOLD)
	col.add_child(t)
	col.add_child(UI.label(str(rep["line"]) + ("" if str(rep["advice"]) == "" else ". " + str(rep["advice"]) + "."), 20, UI.FG, "body", true))
	if str(m.get("body_change", "")) != "":
		col.add_child(UI.muted(str(m["body_change"]), UI.SMALL, true))
	row.add_child(col)
	var focus := str(rep.get("focus", ""))
	if focus != "":
		var f: Dictionary = main.career.fighter_by_id(str(m["fid"]))
		var set_now := str(f.get("focus", "")) == focus
		var btn := UI.button("Training %s next week" % str(Data.LABEL.get(focus, focus)).to_lower() if set_now else "Train %s next week" % str(Data.LABEL.get(focus, focus)).to_lower(),
			"Btn", main.act.bind("bodyfocus", "%s|%s" % [m["fid"], focus]), set_now)
		btn.name = "BodyFocus"
		btn.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		row.add_child(btn)
	return row


func _result(main: Node, v: VBoxContainer, m: Dictionary) -> void:
	var c: Career = main.career
	var f: Dictionary = c.fighter_by_id(str(m["fid"]))
	var opp: Dictionary = f["bout"]["opp"]
	var win := bool(m["win"])
	var outcome := str(m.get("outcome", "win" if win else "loss"))
	var stop := str(m.get("stopped", ""))
	var by := "ON POINTS" if stop == "" else ("BY KNOCKOUT" if stop == "KO" else "BY STOPPAGE")
	var colour: Color = (Broadcast.HERS if win else Broadcast.THEIRS) if outcome != "draw" else UI.GOLD
	v.add_child(UI.caps("THE RESULT" + (": HER PRO DEBUT" if bool(m.get("pro", false)) else "")))
	# S323 (Q-S294-40): the verdict as the ring announcer reads it - both fighters in their corners, the winner's name and
	# the three cards in very large type between them.
	var hero := UI.hbox(28)
	var bodies: Array = m.get("bodies", ["", ""])
	hero.add_child(Broadcast.corner(RoundGraphics.body(m.get("body_map", {}), "a", str(bodies[0]), "red", m.get("body_track", {})), str(f.get("name", f["first"])), Broadcast.HERS, false))
	var centre := UI.vbox(10)
	centre.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	centre.alignment = BoxContainer.ALIGNMENT_CENTER
	var winner := str(f.get("name", f["first"])) if win else str(opp.get("name", opp["first"]))
	var who := UI.display("A DRAW" if outcome == "draw" else winner.to_upper(), 72, colour.lightened(0.25))
	who.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	centre.add_child(who)
	if outcome != "draw":
		var how := UI.display("WINS " + by, 40, UI.GOLD)
		how.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		centre.add_child(how)
	if stop == "":
		var cards := UI.hbox(12)
		var per := Broadcast.judge_rounds(m["rounds"], m["cards"])
		for j in (m["cards"] as Array).size():
			cards.add_child(Broadcast.verdict_card(str(m["cards"][j]), per[j], j + 1))
		centre.add_child(cards)
	else:
		var when := UI.mono("Stopped in round %d of %d" % [(m["rounds"] as Array).size(), int(m.get("total", BoutRules.ROUNDS))], 22, UI.FG)
		when.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		centre.add_child(when)
	hero.add_child(centre)
	hero.add_child(Broadcast.corner(RoundGraphics.body(m.get("body_map", {}), "b", str(bodies[1]), "blue", m.get("body_track", {})), str(opp.get("name", opp["first"])), Broadcast.THEIRS, true))
	v.add_child(hero)
	var why: Array = m["why"]
	v.add_child(Broadcast.reasons(why if not why.is_empty() else ["A close night: the rolls of the rounds decided it."]))
	v.add_child(_body_report(main, m))
	var foot := UI.hbox(10)
	var take := []
	if m.has("tickets"):
		# S329 update 31: the debut pays from her tickets.
		take.append(["%d SOLD" % int(m["tickets"]["sold"]), "DEBUT TICKETS", UI.GOLD])
		take.append([UI.signed(int(m.get("gym_cut", 0))), "THE GYM'S SHARE OF HER HALF", UI.GREEN if int(m.get("gym_cut", 0)) > 0 else UI.MUTED])
	elif bool(m.get("pro", false)):
		take.append([UI.signed(int(m.get("gym_cut", 0))), "THE GYM'S PURSE SHARE", UI.GREEN])
	else:
		# S329: a championship bout pays the club nothing (the ribbon said +$450 at the nationals).
		var cut := int(m.get("club_cut", BoutRules.TICKET_CUT))
		take.append([UI.signed(cut), "CLUB TICKET CUT" if cut > 0 else "NO TICKET CUT AT THE CHAMPIONSHIPS", UI.GREEN if cut > 0 else UI.MUTED])
	# S325: a loss shows the members it cost (update 27 took them, the ribbon still said NO CHANGE); an injury shows red.
	var lost := int(m.get("members_lost", 0))
	take.append(["+%d" % BoutRules.WIN_MEMBERS if win else ("-%d" % lost if lost > 0 else "NO CHANGE"), "MEMBERS AFTER THE NEWS", UI.GOLD if lost == 0 else UI.RED])
	if m.has("injury"):
		take.append([str(m["injury"]).to_upper(), "INJURY REPORT", UI.RED])
	foot.add_child(Broadcast.ribbon(take))
	foot.add_child(UI.spacer())
	var lit := lit_flow(m)
	if not lit.is_empty():   # S340 her plan as a flow, lit with what fired and what worked (Q-S294-64)
		var see := UI.button("Her plan, lit up", "Btn", _open_lit.bind(main, lit, "THE FLOW: %s vs %s" % [str(f["first"]).to_upper(), str(opp["first"]).to_upper()]))
		see.name = "PlanLit"
		see.size_flags_vertical = Control.SIZE_SHRINK_END
		foot.add_child(see)
	var home := UI.button("Back home", "BtnSolid", main.act.bind("afterfight", ""))
	home.name = "BackHome"
	home.size_flags_vertical = Control.SIZE_SHRINK_END
	foot.add_child(home)
	v.add_child(foot)


func _open_lit(main: Node, lit: Dictionary, title: String) -> void:
	var fv := FlowView.new()
	fv.setup(lit, {"title": title, "lit": true, "sub": "each arrow: won / tried",
		"place_name": func(id: String) -> String: return str(StrikeMap.card(id).get("name", id)),
		"move_name": func(id: String) -> String: return str(StrikeMap.move(id).get("name", id))})
	main.add_child(fv)


## The bout's plan as a lit flow: every arrow she walked out with or the corner added, from the card the bout opened on,
## each with its won / tried over the bout ({} when she had no plan).
static func lit_flow(m: Dictionary) -> Dictionary:
	var plan: Array = []
	var seen := {}
	for r in m.get("rounds", []):
		for a in (r as Dictionary).get("plan", []):
			if not seen.has(str(a["move"])):
				seen[str(a["move"])] = true
				plan.append(a)
	if plan.is_empty():
		return {}
	var exs: Array = ((m["rounds"] as Array)[0] as Dictionary).get("exchanges", [])
	var start := str((exs[0] as Dictionary).get("at", "long")) if not exs.is_empty() else "long"
	var flow := FightFlow.build(plan, StrikeMap.MOVES, start)
	flow["edges"] = FightFlow.lit(flow["edges"], FightFlow.bout_moves(m["rounds"]))
	return flow
