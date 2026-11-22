extends RefCounted
## S443 the fight result as a SUMMARY with TABS (operator Q-S294-199: "Yes, summary + tabs"; four critic rounds stuck at 6
## while one page held everything, ops/research/RESULT_ROUND3_S442.md + RESULT_R4_CRITIC_A/B_S442.md). The result is the fight
## only (operator S440 "Yes, fight only"): goals, tiredness and morale are not on it.
##   header   - both boxers with their portraits, the verdict and how, the three judges round by round with the colour
##              key, the rank the bout earned (WhyRank)
##   SUMMARY  - S538 RESULTV2 (owner Q-S294-303 "more graphics, use tooltips/modals to shorten things"; the approved picture
##              ops/previews/s538_look/result_v2.png): WHY (ResultTiles.why: icon, one headline, dots, the fix as bars),
##              ROUND BY ROUND and WHAT IT COST (ResultRounds), the row of icon tiles (ResultTiles.row); every sentence
##              is a hover away and in the modal THE WHOLE READ (ResultRead)
##   SCORECARD - ResultScorecard (S504, the three judges' sheets, a hover a score)
##   THE EXCHANGES / THE NUMBERS / THE PLAN - ResultTabs
##   footer   - the night's take-home, the plan lit up, Back home
## The open tab rides on the moment (m["result_tab"]), so a redraw (a button that sets a focus) keeps it.
##   build(main, v, m)

const Palette := preload("res://scripts/ui/Palette.gd")
const UI := preload("res://scripts/ui/TV.gd")
const Broadcast := preload("res://scripts/ui/Broadcast.gd")
const BoutRules := preload("res://scripts/rules/BoutRules.gd")
const FightWhy := preload("res://scripts/rules/FightWhy.gd")
const FightFlow := preload("res://scripts/rules/FightFlow.gd")
const PlanLines := preload("res://scripts/rules/PlanLines.gd")
const StrikeMap := preload("res://scripts/rules/StrikeMap.gd")
const ResultTiles := preload("res://scripts/ui/ResultTiles.gd")     # S538 RESULTV2 the why card and the icon tiles
const ResultRounds := preload("res://scripts/ui/ResultRounds.gd")   # round by round, what it cost
const ResultRead := preload("res://scripts/ui/ResultRead.gd")       # the modal: the whole read
const Faces := preload("res://scripts/rules/Faces.gd")
const PromoShot := preload("res://scripts/ui/PromoShot.gd")
const FixLab := preload("res://scripts/state/FixLab.gd")
const ResultTabs := preload("res://scripts/ui/ResultTabs.gd")
const ResultCause := preload("res://scripts/ui/ResultCause.gd")
const ResultScorecard := preload("res://scripts/ui/ResultScorecard.gd")   # S504 Q-265 the judges' sheets

## The judges' verdict words (JudgeNight.verdict_words reads the same m["judges"]).
const VERDICT := {"unanimous": "unanimous decision", "split": "split decision", "majority": "majority decision", "draw": "a draw"}
const TABS := [["summary", "SUMMARY"], ["scorecard", "SCORECARD"], ["exchanges", "THE EXCHANGES"], ["numbers", "THE NUMBERS"], ["plan", "THE PLAN"],
	["punches", "PUNCH BY PUNCH"]]   # S511 FIGHTFILM1 map 5: opens the FIGHT ANALYSIS page on the whole fight
const FightAnalysisOwn := preload("res://scripts/ui/FightAnalysisOwn.gd")
const FightWeekEvents := preload("res://scripts/rules/FightWeekEvents.gd")
const WIDE := 1800.0
const TEXT := 20


static func build(main: Node, v: VBoxContainer, m: Dictionary) -> void:
	var c: Career = main.career
	var f: Dictionary = c.fighter_by_id(str(m["fid"]))
	var opp: Dictionary = f["bout"]["opp"]
	var names := [str(f["first"]), str(opp["first"])]
	if not m.has("fixlab"):   # measured once a bout, on the first draw; the first-bell copy is not needed after
		m["fixlab"] = FixLab.run(c, m)
		m.erase("lab_from")
	v.add_theme_constant_override("separation", 10)
	var panel := v.get_parent().get_parent().get_parent() as Control
	if panel != null:
		panel.custom_minimum_size = Vector2(WIDE, 0)
	v.add_child(header(c, f, m, names))
	var tab := str(m.get("result_tab", "summary"))
	v.add_child(_tab_bar(main, m, tab))
	var body: Control
	match tab:
		"scorecard": body = ResultScorecard.tab(main, m, f, names)
		"exchanges": body = ResultTabs.exchanges(m, names)
		"numbers": body = ResultTabs.numbers(main, m, f, opp, names)
		"plan": body = ResultTabs.plan(m, names)
		_: body = summary(main, m, f, names)
	body.name = "Tab_" + tab
	v.add_child(body)
	v.add_child(footer(main, m, f, opp, tab == "summary"))


## Both boxers either side of the verdict and the judges.
static func header(c: Career, f: Dictionary, m: Dictionary, names: Array) -> HBoxContainer:
	var opp: Dictionary = f["bout"]["opp"]
	var outcome := str(m.get("outcome", "win" if bool(m["win"]) else "loss"))
	var h := UI.hbox(24)
	h.name = "ResultHead"
	var rec := "pro_" if bool(m.get("pro", false)) else ""
	var w := int(f.get(rec + "w", 0))
	var l := int(f.get(rec + "l", 0))
	var was := "%d-%d" % [w - int(outcome == "win"), l - int(outcome == "loss")]
	var stems: Array = Faces.pair(f, opp)
	var mine := _side(str(f.get("name", names[0])), "Your fighter · %s · %s" % [str(f.get("style", "")), str(f.get("stance", "")).to_lower()],
		"Record %s → %d-%d" % [was, w, l], Broadcast.HERS, false, str(stems[0]))
	var rank := UI.hbox(8)
	rank.mouse_filter = Control.MOUSE_FILTER_PASS
	for t in m.get("aftermath", []):   # the rank tile's lines (where the bout left the ladder) are this line's hover
		if str((t as Dictionary).get("id", "")) == "rank":
			rank.tooltip_text = "\n".join(PackedStringArray(t.get("lines", [])))
	if str(m.get("rank_words", "")) != "":
		rank.add_child(ResultTiles.icon("ladder", 24, UI.MUTED))
	var why := UI.label(str(m.get("rank_words", "")), TEXT, UI.FG, "body", true)
	why.name = "WhyRank"   # the rank the bout earned (S428: every fight shows it), the rank tile's first line
	why.custom_minimum_size = Vector2(280, 0)
	why.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	rank.add_child(why)
	mine.find_child("Words", true, false).add_child(rank)
	h.add_child(mine)
	var mid := UI.hbox(30)
	mid.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var word := {"win": "WON", "loss": "LOST", "draw": "A DRAW"}.get(outcome, "") as String
	var col: Color = UI.GREEN if outcome == "win" else (UI.RED if outcome == "loss" else UI.GOLD)
	var top := UI.vbox(0)
	top.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	top.add_child(UI.display(word, 96, col))
	top.add_child(UI.label(_how(m), 24, UI.FG, "bold"))
	mid.add_child(top)
	if str(m.get("stopped", "")) == "":
		var cards := UI.vbox(8)
		cards.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		cards.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		var grid := _judges(m)
		grid.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
		cards.add_child(grid)
		var key := UI.hbox(8)
		key.name = "JudgesKey"
		key.alignment = BoxContainer.ALIGNMENT_CENTER
		for k in [[Broadcast.HERS, "your boxer's round"], [Broadcast.THEIRS, "the opponent's round"]]:
			var sq := ColorRect.new()
			sq.color = k[0]
			sq.custom_minimum_size = Vector2(14, 14)
			sq.size_flags_vertical = Control.SIZE_SHRINK_CENTER
			key.add_child(sq)
			key.add_child(UI.label(str(k[1]) + "   ", 16, UI.MUTED))
		cards.add_child(key)
		var swing := _swing(m, names)
		if swing != "":   # the one round the judges did not all score alike, under their cards
			var sw := UI.label(swing, 17, UI.MUTED)
			sw.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
			cards.add_child(sw)
		mid.add_child(cards)
	h.add_child(mid)
	var rival := c.rival(str(opp["name"]))
	var orec := "Record %d-%d" % [int(rival.get("w", 0)), int(rival.get("l", 0))] if not rival.is_empty() else ""
	h.add_child(_side(str(opp.get("name", names[1])), str(opp.get("style", "")), orec, Broadcast.THEIRS, true, str(stems[1])))
	return h


static func _side(name: String, sub: String, rec: String, colour: Color, right: bool, stem: String = "") -> PanelContainer:
	var p := PanelContainer.new()
	var sb := UI.box(Color(colour.r, colour.g, colour.b, 0.14), Color(Palette.PAGE, 0), 2, 0, 16, 10)
	sb.border_color = colour
	sb.border_width_left = 0 if right else 5
	sb.border_width_right = 5 if right else 0
	p.add_theme_stylebox_override("panel", sb)
	p.custom_minimum_size = Vector2(440, 0)
	var row := UI.hbox(16)
	p.add_child(row)
	var v := UI.vbox(2)
	v.name = "Words"
	v.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	v.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	row.add_child(v)
	var pic := PromoShot.picture(stem, Vector2(104, 104)) if stem != "" else null
	if pic != null:   # S538 RESULTV2: the boxer's portrait in the corner's colour
		var frame := PanelContainer.new()
		frame.name = "Portrait"
		frame.add_theme_stylebox_override("panel", UI.box(Palette.PAGE, colour, 6, 3, 0, 0))
		frame.clip_contents = true
		frame.custom_minimum_size = Vector2(110, 110)
		frame.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		frame.add_child(pic)
		row.add_child(frame)
		if not right:
			row.move_child(frame, 0)
	var al := HORIZONTAL_ALIGNMENT_RIGHT if right else HORIZONTAL_ALIGNMENT_LEFT
	for ln in [[name.to_upper(), 34, Palette.TEXT, "display"], [sub, TEXT, UI.MUTED, "body"], [rec, TEXT, UI.FG, "bold"]]:
		if str(ln[0]) == "":
			continue
		var lb := UI.label(str(ln[0]), int(ln[1]), ln[2], str(ln[3]))
		lb.horizontal_alignment = al
		v.add_child(lb)
	return p


static func _how(m: Dictionary) -> String:
	var stop := str(m.get("stopped", ""))
	var rounds: Array = m["rounds"]
	if stop != "":
		return "%s in round %d of %d" % ["Knockout" if stop == "KO" else ("Retired on the stool" if stop.begins_with("RTD") else "Referee stops it"), rounds.size(), int(m.get("total", BoutRules.ROUNDS))]
	var said := str(VERDICT.get(str((m.get("judges", {}) as Dictionary).get("verdict", "")), "")) if _judged(m) else ""   # S443 R29
	if said != "":
		return "On points: " + said
	var cards: Array = m["cards"]
	var ours := cards.filter(func(cd): return int(str(cd).get_slice("-", 0)) > int(str(cd).get_slice("-", 1))).size()
	var theirs := cards.filter(func(cd): return int(str(cd).get_slice("-", 0)) < int(str(cd).get_slice("-", 1))).size()
	if ours == cards.size() or theirs == cards.size():
		return "On points, all three judges"
	return "On points, split" if ours > 0 and theirs > 0 else "On points, majority"


## "Round 2 swung it: 2 judges gave it to Priya." - on a split card, the one round the judges did not all score alike.
static func _swing(m: Dictionary, names: Array) -> String:
	if str(m.get("stopped", "")) != "" or (m["cards"] as Array).size() < 3:
		return ""
	var split: Array = []
	for i in (m["rounds"] as Array).size():
		var w := [0, 0]
		for j in 3:
			var sc := _score(m, j, i)
			if sc[0] != sc[1]:
				w[0 if sc[0] > sc[1] else 1] += 1
		if w[0] > 0 and w[1] > 0:
			split.append([i, w])
	if split.size() != 1:
		return ""
	var ww: Array = split[0][1]
	var ours := int(ww[0]) > int(ww[1])
	return "Round %d swung it: %d judges gave it to %s." % [int(split[0][0]) + 1, maxi(int(ww[0]), int(ww[1])), "your boxer" if ours else "the opponent"]   # S448: roles


## True when the three judges (m["judges"], S443 R29) gave the cards that decided the bout. Until their calibration
## (JUDGES1) today's cards decide and the judges ride alongside: a page that showed both would add up two ways.
static func _judged(m: Dictionary) -> bool:
	var j: Dictionary = m.get("judges", {})
	if j.is_empty() or not j.has("cards"):
		return false
	var theirs: Array = (j["cards"] as Array).map(func(c): return "%d-%d" % [int(c[0]), int(c[1])])
	return theirs == (m.get("cards", []) as Array).map(func(c): return str(c))


## One judge's score of one round, ours first: the judges' own (JudgeNight, S443 R29), else 10-9 to the round's side.
static func _score(m: Dictionary, j: int, i: int) -> Array:
	var r: Dictionary = (m["rounds"] as Array)[i]
	if r.has("judges") and _judged(m):
		var s: Dictionary = (r["judges"] as Array)[j]
		return [int(s["a"]), int(s["b"])]
	var ours := bool(Broadcast.judge_rounds(m["rounds"], m["cards"])[j][i])
	return [10, 9] if ours else [9, 10]


## Three judges, a cell a round with the judge's score in the colour of the boxer it went to (grey when level), the total.
static func _judges(m: Dictionary) -> GridContainer:
	var g := GridContainer.new()
	g.name = "Judges"
	var rounds: Array = m["rounds"]
	g.columns = rounds.size() + 2
	g.add_theme_constant_override("h_separation", 8)
	g.add_theme_constant_override("v_separation", 4)
	var leans: Array = (m.get("judges", {}) as Dictionary).get("leans", []) if _judged(m) else []
	for hd in [""] + range(rounds.size()).map(func(i): return "ROUND %d" % (i + 1)) + ["CARD"]:
		var hl := UI.caps(str(hd))
		hl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		g.add_child(hl)
	for j in (m["cards"] as Array).size():
		var jl := UI.label("Judge %d" % (j + 1), TEXT, UI.MUTED)
		if j < leans.size():
			jl.mouse_filter = Control.MOUSE_FILTER_PASS
			jl.tooltip_text = _lean_tip(str(leans[j]))
		g.add_child(jl)
		for i in rounds.size():
			var sc := _score(m, j, i)
			var cell := UI.label("%d-%d" % [sc[0], sc[1]], 18, Palette.TEXT, "bold")
			cell.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
			cell.custom_minimum_size = Vector2(92, 26)
			var bg := PanelContainer.new()
			var col: Color = Broadcast.HERS if sc[0] > sc[1] else (Broadcast.THEIRS if sc[0] < sc[1] else Palette.LINE)
			bg.add_theme_stylebox_override("panel", UI.box(col.darkened(0.35), col, 3, 1, 4, 0))
			bg.mouse_filter = Control.MOUSE_FILTER_PASS
			bg.tooltip_text = "Judge %d, round %d: %d-%d." % [j + 1, i + 1, sc[0], sc[1]]
			bg.add_child(cell)
			g.add_child(bg)
		var card := str(m["cards"][j])
		var a := int(card.get_slice("-", 0))
		var b := int(card.get_slice("-", 1))
		g.add_child(UI.label(card, 26, (Broadcast.HERS if a > b else Broadcast.THEIRS).lightened(0.3) if a != b else UI.FG, "display"))
	return g


## What a judge's lean counts double (JudgeNight.LEAN_WORD / LEAN_TIP, loaded when the judges are in the game).
static func _lean_tip(lean: String) -> String:
	var path := "res://scripts/state/JudgeNight.gd"
	if not ResourceLoader.exists(path):
		return ""
	var consts: Dictionary = (load(path) as Script).get_script_constant_map()
	var words: Dictionary = consts.get("LEAN_WORD", {})
	var tips: Dictionary = consts.get("LEAN_TIP", {})
	return "%s: %s" % [str(words.get(lean, lean)), str(tips.get(lean, ""))]


static func _tab_bar(main: Node, m: Dictionary, open: String) -> HBoxContainer:
	var bar := UI.hbox(8)
	bar.name = "ResultTabs"
	for t in TABS:
		var on := str(t[0]) == open
		var b := UI.button(str(t[1]), "Btn" if on else "BtnQuiet", func():
			if str(t[0]) == "punches":
				punches(main, m)
				return
			m["result_tab"] = str(t[0])
			main.redraw_modal())
		b.name = "ResultTab_" + str(t[0])
		b.add_theme_font_size_override("font_size", TEXT)
		if on:   # the open tab reads at once: gold words, a gold bar under it
			for k in ["font_color", "font_hover_color", "font_pressed_color"]:
				b.add_theme_color_override(k, UI.GOLD)
			var bar_line := ColorRect.new()
			bar_line.color = UI.GOLD
			bar_line.set_anchors_and_offsets_preset(Control.PRESET_BOTTOM_WIDE)
			bar_line.offset_top = -4
			bar_line.mouse_filter = Control.MOUSE_FILTER_IGNORE
			b.add_child(bar_line)
		b.custom_minimum_size = Vector2(220, 46)
		bar.add_child(b)
	return bar


## PUNCH BY PUNCH: the FIGHT ANALYSIS page on this bout - its results row (tape, FightWhy lines, cards), else the moment.
static func punches(main: Node, m: Dictionary) -> Control:
	var c: Career = main.career
	var f: Dictionary = c.fighter_by_id(str(m["fid"]))
	var row: Dictionary = {}
	for r in c.results:
		if str(r.get("fid", "")) == str(m["fid"]) and (r as Dictionary).has("tape"):
			row = r
			break
	if row.is_empty():
		row = {"tape": m.get("tape", []), "why3": m.get("why3", []), "d": c.day, "outcome": str(m.get("outcome", "")),
			"opp": str(((f.get("bout", {}) as Dictionary).get("opp", {}) as Dictionary).get("name", ""))}
	return FightAnalysisOwn.open(main, f, row)


## THE SUMMARY (S538 RESULTV2): why, round by round and what it cost side by side, then the row of icon tiles.
static func summary(main: Node, m: Dictionary, f: Dictionary, names: Array) -> VBoxContainer:
	var v := UI.vbox(10)
	var row := UI.hbox(14)
	var cause := ResultTiles.why(main, m, f, names)
	var rounds := ResultRounds.card(m, names, m.get("fixlab", {}), scores(m))
	var cost := ResultRounds.cost(main, m, f)
	for part in [[cause, 1.0], [rounds, 1.12], [cost, 0.88]]:
		(part[0] as Control).size_flags_horizontal = Control.SIZE_EXPAND_FILL
		(part[0] as Control).size_flags_stretch_ratio = float(part[1])
		(part[0] as Control).custom_minimum_size = Vector2(440, 0)
		row.add_child(part[0])
	v.add_child(row)
	v.add_child(ResultTiles.row(m))   # the night's take-home and the plan's clue (S533 the corner's eye), a tile each
	return v


## Every judge's score of every round: scores[round][judge] = [ours, theirs]; [] on a stopped bout (no cards).
static func scores(m: Dictionary) -> Array:
	var out: Array = []
	if str(m.get("stopped", "")) != "":
		return out
	for i in (m["rounds"] as Array).size():
		var row: Array = []
		for j in (m["cards"] as Array).size():
			row.append(_score(m, j, i))
		out.append(row)
	return out


## What the modal needs from the header: the verdict's words, the swing round, the record's move.
static func read_ctx(f: Dictionary, m: Dictionary, names: Array) -> Dictionary:
	var outcome := str(m.get("outcome", "win" if bool(m["win"]) else "loss"))
	var rec := "pro_" if bool(m.get("pro", false)) else ""
	var w := int(f.get(rec + "w", 0))
	var l := int(f.get(rec + "l", 0))
	return {"names": names, "how": "%s. %s" % [{"win": "Won", "loss": "Lost", "draw": "A draw"}.get(outcome, ""), _how(m)], "swing": _swing(m, names),
		"record": "Record %d-%d → %d-%d" % [w - int(outcome == "win"), l - int(outcome == "loss"), w, l], "scores": scores(m)}


## The foot: on the summary the tiles carry the numbers, so the foot holds the hint (or the night's one line: the boxer who
## asked about the gym, the work that was seen) and "More: the whole read"; the other
## tabs keep the night's take-home as a line of numbers. The plan lit up (FightNight) and Back home close it.
static func footer(main: Node, m: Dictionary, f: Dictionary, _opp: Dictionary, on_summary: bool = false) -> HBoxContainer:
	var foot := UI.hbox(14)
	foot.name = "ResultFoot"
	if on_summary:
		var hint := UI.label("Every tile and bar has its words one hover away.", 18, UI.MUTED, "body", true)
		if str(m.get("card_ask", "")) != "":   # S531 "she asked about your gym" (CardAsk): the boxer chose the gym
			hint = UI.label(str(m["card_ask"]), 19, UI.GREEN, "semi", true)
			hint.name = "CardAsk"
		elif str(m.get("visit_note", "")) != "":   # S533 the work was seen though nobody came: coaching and luck told apart
			hint = UI.label(str(m["visit_note"]), 17, UI.MUTED, "body", true)
			hint.name = "VisitNote"
		hint.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		hint.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		foot.add_child(hint)
	else:
		var rib := UI.hbox(44)
		for it in ResultTiles.take(m):
			var cell := UI.vbox(0)
			cell.add_child(UI.display(str(it["big"]), 30, it["col"]))
			cell.add_child(UI.caps(str(it["label"]).get_slice(" · ", 0) + (", " + str(it["side"]) if str(it.get("side", "")) != "" else "")))
			rib.add_child(cell)
		foot.add_child(rib)
	if not on_summary:
		foot.add_child(UI.spacer())
	if on_summary:
		var names := [str(f["first"]), str(f["bout"]["opp"]["first"])]
		var more := UI.button("More: the whole read", "Btn", func(): ResultRead.open(main, m, f, read_ctx(f, m, names)))
		more.name = "WholeRead"
		more.tooltip_text = "Opens every fact of this page in plain sentences: the cause, the fix, the cost, the rank, the cards."
		more.add_theme_font_size_override("font_size", 20)
		more.custom_minimum_size = Vector2(250, 56)
		more.size_flags_vertical = Control.SIZE_SHRINK_END
		foot.add_child(more)
	var home := UI.button("Back home", "Btn", main.act.bind("afterfight", ""))
	home.name = "BackHome"
	home.add_theme_font_size_override("font_size", 24)
	home.custom_minimum_size = Vector2(240, 56)
	home.size_flags_vertical = Control.SIZE_SHRINK_END
	foot.add_child(home)
	return foot
