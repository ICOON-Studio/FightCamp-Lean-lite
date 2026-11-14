extends PanelContainer
## Fight night in words: the tale of the tape, three rounds with a corner call between them, then the scorecards and what
## decided it. Bouts.fight_step moves it on; this draws whichever step the moment is at.

const RoundGraphics := preload("res://scripts/ui/RoundGraphics.gd")
const Broadcast := preload("res://scripts/ui/Broadcast.gd")
const UI := preload("res://scripts/ui/UI.gd")
const TowelStrip := preload("res://scripts/ui/TowelStrip.gd")
const CrackStrip := preload("res://scripts/ui/CrackStrip.gd")
const CrackWire := preload("res://scripts/state/CrackWire.gd")
const TapeVersus := preload("res://scripts/ui/TapeVersus.gd")
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
const FightVoice := preload("res://scripts/audio/FightVoice.gd")
const HeadlineCard := preload("res://scripts/ui/modals/HeadlineCard.gd")
const ResultPage := preload("res://scripts/ui/ResultPage.gd")


func build(main: Node, m: Dictionary) -> void:
	if str(m["step"]) == "tape":
		TapeVersus.mount(self, main, m)
		return
	theme_type_variation = "Modal"
	custom_minimum_size = Vector2(1040, 0)
	var v := UI.vbox(12)
	add_child(v)
	match str(m["step"]):
		"round":
			if LiveRound.live(m).is_empty():
				# S323 (Q-S294-40 "Layout looks cheap / like a spreadsheet"): the round and result pages as broadcast graphics.
				remove_child(v)
				v.queue_free()
				_round(main, Broadcast.frame(_scroll_if_asking(m)), m)
			else:
				_live(main, v, m)
		"result":
			remove_child(v)
			v.queue_free()
			if HeadlineCard.wanted(m):   # S442 LOOP: the headline first, once, for the bout just booked; See the fight -> here
				add_theme_stylebox_override("panel", StyleBoxEmpty.new())
				add_child(HeadlineCard.make(main, m))
				return
			_result(main, Broadcast.frame(self), m)


## S442 UX audit: with the corner's questions under the round's numbers the page ran past 1080 and the calls - the only
## way on - sat below the screen. While the corner asks, the page scrolls inside a 1040 px frame; other pages stay as built.
func _scroll_if_asking(m: Dictionary) -> PanelContainer:
	var rounds: Array = m["rounds"]
	var last: Dictionary = rounds[rounds.size() - 1]
	if int(m["round"]) >= int(m.get("total", BoutRules.ROUNDS)) or str(last.get("stopped", "")) != "":
		return self
	add_theme_stylebox_override("panel", StyleBoxEmpty.new())
	var sc := ScrollContainer.new()
	sc.name = "CornerScroll"
	sc.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	sc.custom_minimum_size = Vector2(1440, 1040)
	add_child(sc)
	var inner := PanelContainer.new()
	inner.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	sc.add_child(inner)
	return inner


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
	# S373 (operator S369 "what is exchanges won ?"): the headline says what an exchange is and why it counts.
	v.add_child(UI.display("EXCHANGES WON %d OF %d" % [won, exs.size()], 40, UI.GREEN if won * 2 > exs.size() else (UI.RED if won * 2 < exs.size() else UI.FG)))
	v.add_child(UI.muted("A round is %d exchanges of %d seconds; the boxer who wins more of them takes the round." % [
		Exchanges.EXCHANGES, int(Exchanges.EX_SECONDS)], UI.SMALL))
	# S310: both boxers' energy, body shots taken and hurt, as the 3D fight display shows them.
	var st := LiveRound.state(lv, exs.size())
	v.add_child(UI.muted("Punches landed: yours %d, theirs %d." % [la, lb], UI.SMALL))   # S448: names only in the header
	for side in 2:
		v.add_child(UI.label("%s: energy %d, body shots taken %d%s" % ["Yours" if side == 0 else "Theirs", int(round(float(st["a" if side == 0 else "b"]))),
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
	if str(last.get("perk_line", "")) != "":   # S355 a perk at work (PerkFight)
		v.add_child(UI.label(str(last["perk_line"]), 18, UI.GREEN, "body", true))
	v.add_child(UI.caps("WHAT YOU SEE"))
	v.add_child(UI.label(str(pv["clue"]), 24, UI.AMBER, "bold", true))
	if not (pv.get("read", {}) as Dictionary).is_empty():   # S333 THE READ
		v.add_child(ReadPanel.build(pv["read"], str(pv.get("read_call", "")), names, func(k: String): main.act("fightstep", "shout:" + k)))
	v.add_child(UI.caps("WHAT DO YOU SHOUT?"))
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
		sub.append("Level %d-%d on exchanges: %s took it on the work done in them." % [ex_won[0], ex_won[1], "your boxer" if won else "the opponent"])
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
		centre.add_child(Broadcast.compubox([["Exchanges won (%d s each)" % int(Exchanges.EX_SECONDS), tot["won"][0], tot["won"][1]],
			["Punches landed", tot["landed"][0], tot["landed"][1]], ["To the body", tot["body"][0], tot["body"][1]]]))
		if not en.is_empty():
			centre.add_child(Broadcast.tank(float(en.get("a_end", 100.0)), float(en.get("b_end", 100.0))))
			# S303 Kalli K-COMBOWORDS1: the corner reads her tank in a line.
			var said := ComboWords.energy_line(float(en.get("a_end", 100.0)), "your boxer", n * 7 + main.career.day)
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
		v.add_child(UI.display("STOPPED: %s" % {"KO": "KNOCKOUT", "RTD": "RETIRED ON THE STOOL", "RTD_B": "THE OPPONENT IS RETIRED ON THE STOOL"}.get(stop, "REFEREE STOPS IT"), 32, UI.AMBER))
	# S303 corner card (watched rounds only: the 3D view reads it off the beats it played).
	var advice := ""
	if (last.has("card") or last.has("exchanges")) and stop == "":
		var cc := CornerCard.card(last.get("card", CornerCard.summarize([])), float(en.get("a_end", 100.0)), [fname, oname])
		# S309: the exchanges' read already says the call in the coach's words.
		if not last.has("card") and not exs.is_empty():
			# S320: a skipped round has no punch-by-punch card - say what its exchanges landed (it read "nothing clean").
			var tt := RoundGraphics.totals(exs)
			cc["worked"] = "Your boxer landed %d punches, %d to the body." % [tt["landed"][0], tt["body"][0]]
			cc["hurt"] = "The opponent landed %d punches, %d to the body." % [tt["landed"][1], tt["body"][1]]
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
		v.add_child(UI.caps("IN THE CORNER: WHAT DO YOU TELL YOUR BOXER?"))
		_towel(main, v, m)   # S461 INTEGRATE1 #4 the towel card (TowelWire), only when it comes
		_crack(main, v, m, total)   # S470 the crack card (CrackWire), only when your boxer's rib cracked
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
			var tw := "|towel=" + str(m["towel_pick"]) if m.has("towel_pick") else ""
			m.erase("towel_pick")
			tw += "|crack=" + str(m["crack_pick"]) if m.has("crack_pick") else ""
			m.erase("crack_pick")
			main.act("fightstep", "corner:" + k + ("|fix=" + fx if fx != "" else "") + jobs + tw)))
	else:
		var foot := UI.hbox(10)
		foot.add_child(UI.spacer())
		var cards := UI.button("To the scorecards" if stop == "" else "To the result", "BtnSolid", main.act.bind("fightstep", "end"))
		cards.name = "Scorecards"
		foot.add_child(cards)
		v.add_child(foot)


## S443 the result as a summary with tabs (ResultPage; operator Q-S294-199 "Yes, summary + tabs"). The ring announcer reads
## it once (VOICEWIRE1: the modal redraws on every click; m is main.modal, so the flag survives).
func _result(main: Node, v: VBoxContainer, m: Dictionary) -> void:
	var f: Dictionary = main.career.fighter_by_id(str(m["fid"]))
	var opp: Dictionary = f["bout"]["opp"]
	var outcome := str(m.get("outcome", "win" if bool(m["win"]) else "loss"))
	var stop := str(m.get("stopped", ""))
	if not bool(m.get("_announced", false)):
		m["_announced"] = true
		if outcome == "draw":
			FightVoice.intro_result("draw", "")
		else:
			FightVoice.intro_result("decision" if stop == "" else ("ko" if stop == "KO" else "stoppage"), "red" if bool(m["win"]) else "blue")
	ResultPage.build(main, v, m)
	var lit := lit_flow(m)
	var foot := v.find_child("ResultFoot", true, false)
	if not lit.is_empty() and foot != null:   # S340 her plan as a flow, lit with what fired and what worked (Q-S294-64)
		var see := UI.button("The plan, lit up", "Btn", _open_lit.bind(main, lit, "THE FLOW: %s vs %s" % [str(f["first"]).to_upper(), str(opp["first"]).to_upper()]))
		see.name = "PlanLit"
		see.size_flags_vertical = Control.SIZE_SHRINK_END
		foot.add_child(see)
		foot.move_child(see, foot.get_child_count() - 2)


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


## S461 R26 the towel card in the corner minute (TowelStrip): Pull and Box safe start the corner at once, One more hides it.
func _towel(main: Node, v: VBoxContainer, m: Dictionary) -> void:
	var tc: Dictionary = m.get("towel", {})
	if not bool(tc.get("comes", false)) or str(m.get("towel_pick", "")) == "one_more":
		return
	v.add_child(TowelStrip.build(tc, func(kind: String):
		if kind == "one_more":
			m["towel_pick"] = kind
			main.redraw_modal()
		else:
			main.act("fightstep", "corner:hands|towel=" + kind)))


## S470 the crack card in the corner minute (CrackStrip): Pull out ends it at once; the other two ride on the corner call.
func _crack(main: Node, v: VBoxContainer, m: Dictionary, total: int) -> void:
	var cc: Dictionary = CrackWire.card(main.career.fighter_by_id(str(m["fid"])), m, total)
	if cc.is_empty():
		return
	v.add_child(CrackStrip.build(cc, func(kind: String):
		if kind == "pull":
			main.act("fightstep", "corner:hands|crack=pull")
		else:
			m["crack_pick"] = kind
			main.redraw_modal(), UI, str(m.get("crack_pick", ""))))
