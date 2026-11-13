extends RefCounted
## S443 the fight result as a SUMMARY with TABS (operator Q-S294-199: "Yes, summary + tabs"; four critic rounds stuck at 6
## while one page held everything, ops/research/RESULT_ROUND3_S442.md + RESULT_R4_CRITIC_A/B_S442.md). The result is the fight
## only (operator S440 "Yes, fight only"): goals, tiredness and morale are not on it.
##   header   - both boxers, the verdict and how, the three judges round by round, the rank the bout earned (WhyRank)
##   SUMMARY  - the ONE cause with its measured fix (FixLab: the plan as written against the best change, "even the best plan
##              makes it an even fight" when the numbers say so), what the bout cost, the rounds strip
##   THE EXCHANGES / THE NUMBERS / THE PLAN - ResultTabs
##   footer   - the night's take-home, the plan lit up, Back home
## The open tab rides on the moment (m["result_tab"]), so a redraw (a button that sets a focus) keeps it.
##   build(main, v, m)

const UI := preload("res://scripts/ui/TV.gd")
const Broadcast := preload("res://scripts/ui/Broadcast.gd")
const BoutRules := preload("res://scripts/rules/BoutRules.gd")
const FightWhy := preload("res://scripts/rules/FightWhy.gd")
const FightFlow := preload("res://scripts/rules/FightFlow.gd")
const PlanLines := preload("res://scripts/rules/PlanLines.gd")
const StrikeMap := preload("res://scripts/rules/StrikeMap.gd")
const AftermathTiles := preload("res://scripts/ui/AftermathTiles.gd")
const FixLab := preload("res://scripts/state/FixLab.gd")
const ResultTabs := preload("res://scripts/ui/ResultTabs.gd")
const ResultCause := preload("res://scripts/ui/ResultCause.gd")

## The judges' verdict words (JudgeNight.verdict_words reads the same m["judges"]).
const VERDICT := {"unanimous": "unanimous decision", "split": "split decision", "majority": "majority decision", "draw": "a draw"}
const TABS := [["summary", "SUMMARY"], ["exchanges", "THE EXCHANGES"], ["numbers", "THE NUMBERS"], ["plan", "THE PLAN"]]
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
	v.add_theme_constant_override("separation", 12)
	var panel := v.get_parent().get_parent().get_parent() as Control
	if panel != null:
		panel.custom_minimum_size = Vector2(WIDE, 0)
	v.add_child(header(c, f, m, names))
	var tab := str(m.get("result_tab", "summary"))
	v.add_child(_tab_bar(main, m, tab))
	var body: Control
	match tab:
		"exchanges": body = ResultTabs.exchanges(m, names)
		"numbers": body = ResultTabs.numbers(main, m, f, opp, names)
		"plan": body = ResultTabs.plan(m, names)
		_: body = summary(main, m, f, names)
	body.name = "Tab_" + tab
	v.add_child(body)
	v.add_child(footer(main, m, f, opp))


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
	var mine := _side(str(f.get("name", names[0])), "Your fighter · %s · %s" % [str(f.get("style", "")), str(f.get("stance", "")).to_lower()],
		"Record %s → %d-%d" % [was, w, l], Broadcast.HERS, false)
	var why := UI.label(str(m.get("rank_words", "")), TEXT, UI.FG, "body", true)
	why.name = "WhyRank"   # the rank the bout earned (S428: every fight shows it), the rank tile's first line
	why.custom_minimum_size = Vector2(420, 0)
	mine.get_child(0).add_child(why)
	h.add_child(mine)
	var mid := UI.vbox(2)
	mid.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var word := {"win": "WON", "loss": "LOST", "draw": "A DRAW"}.get(outcome, "") as String
	var col: Color = UI.GREEN if outcome == "win" else (UI.RED if outcome == "loss" else UI.GOLD)
	var top := UI.hbox(22)
	top.add_child(UI.display(word, 72, col))
	var how := UI.vbox(0)
	how.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	how.add_child(UI.label(_how(m), 24, UI.FG, "bold"))
	var swing := _swing(m, names)
	if swing != "":
		how.add_child(UI.label(swing, TEXT, UI.MUTED))
	top.add_child(how)
	mid.add_child(top)
	if str(m.get("stopped", "")) == "":
		mid.add_child(_judges(m))
	h.add_child(mid)
	var rival := c.rival(str(opp["name"]))
	var orec := "Record %d-%d" % [int(rival.get("w", 0)), int(rival.get("l", 0))] if not rival.is_empty() else ""
	h.add_child(_side(str(opp.get("name", names[1])), str(opp.get("style", "")), orec, Broadcast.THEIRS, true))
	return h


static func _side(name: String, sub: String, rec: String, colour: Color, right: bool) -> PanelContainer:
	var p := PanelContainer.new()
	var sb := UI.box(Color(colour.r, colour.g, colour.b, 0.14), Color(0, 0, 0, 0), 2, 0, 16, 10)
	sb.border_color = colour
	sb.border_width_left = 0 if right else 5
	sb.border_width_right = 5 if right else 0
	p.add_theme_stylebox_override("panel", sb)
	p.custom_minimum_size = Vector2(440, 0)
	var v := UI.vbox(2)
	p.add_child(v)
	var al := HORIZONTAL_ALIGNMENT_RIGHT if right else HORIZONTAL_ALIGNMENT_LEFT
	for row in [[name.to_upper(), 34, Color.WHITE, "display"], [sub, TEXT, UI.MUTED, "body"], [rec, TEXT, UI.FG, "bold"]]:
		if str(row[0]) == "":
			continue
		var lb := UI.label(str(row[0]), int(row[1]), row[2], str(row[3]))
		lb.horizontal_alignment = al
		v.add_child(lb)
	return p


static func _how(m: Dictionary) -> String:
	var stop := str(m.get("stopped", ""))
	var rounds: Array = m["rounds"]
	if stop != "":
		return "%s in round %d of %d" % ["Knockout" if stop == "KO" else "Referee stops it", rounds.size(), int(m.get("total", BoutRules.ROUNDS))]
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
	for j in (m["cards"] as Array).size():
		var jl := UI.label("Judge %d" % (j + 1), TEXT, UI.MUTED)
		if j < leans.size():
			jl.mouse_filter = Control.MOUSE_FILTER_PASS
			jl.tooltip_text = _lean_tip(str(leans[j]))
		g.add_child(jl)
		for i in rounds.size():
			var sc := _score(m, j, i)
			var cell := UI.label("%d-%d" % [sc[0], sc[1]], 18, Color.WHITE, "bold")
			cell.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
			cell.custom_minimum_size = Vector2(64, 26)
			var bg := PanelContainer.new()
			var col: Color = Broadcast.HERS if sc[0] > sc[1] else (Broadcast.THEIRS if sc[0] < sc[1] else Color(0.5, 0.5, 0.5))
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


## THE SUMMARY: the one cause and its fix beside what the bout cost, then the rounds.
static func summary(main: Node, m: Dictionary, f: Dictionary, names: Array) -> VBoxContainer:
	var v := UI.vbox(12)
	var row := UI.hbox(14)
	var cause := ResultCause.cause_card(main, m, f, names)
	cause.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	cause.size_flags_stretch_ratio = 1.9
	row.add_child(cause)
	var cost := cost_card(main, m, f, names)
	cost.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	row.add_child(cost)
	v.add_child(row)
	v.add_child(ResultTabs.round_strip(m, names, (m.get("fixlab", {}) as Dictionary)))
	return v


## What the bout cost: hurt, counts, the damage tile (the stand-down's head) and the rank tile, as tiles with hovers.
static func cost_card(main: Node, m: Dictionary, f: Dictionary, names: Array) -> PanelContainer:
	var p := ResultCause.panel("WHAT IT COST %s" % str(names[0]).to_upper())
	p.name = "Cost"
	var v: VBoxContainer = p.get_child(0)
	var hurt := 0
	for r in m["rounds"]:
		for x in (r as Dictionary).get("exchanges", []):
			hurt += int(bool(((x as Dictionary).get("after", {}) as Dictionary).get("hurt", [false, false])[0]))
	var dealt := 0
	for r in m["rounds"]:
		for x in (r as Dictionary).get("exchanges", []):
			dealt += int(bool(((x as Dictionary).get("after", {}) as Dictionary).get("hurt", [false, false])[1]))
	var counts := int((m.get("counts", {}) as Dictionary).get("a", 0))
	var facts := UI.hbox(26)
	for fact in [["%d" % hurt, "times hurt", UI.AMBER if hurt > 0 else UI.GREEN, "Exchanges your boxer finished hurt (the opponent won one big)."],
			["%d" % dealt, "times the opponent was hurt", UI.FG, "Exchanges the opponent finished hurt: the same count the other way."],
			["%d" % counts, "standing counts", UI.RED if counts > 0 else UI.GREEN, "Counts from the referee in the bout."]]:
		var cell := UI.vbox(0)
		cell.mouse_filter = Control.MOUSE_FILTER_PASS
		cell.tooltip_text = str(fact[3])
		cell.add_child(UI.display(str(fact[0]), 40, fact[2]))
		cell.add_child(UI.label(str(fact[1]), TEXT, UI.MUTED))
		facts.add_child(cell)
	v.add_child(facts)
	for t in m.get("aftermath", []):
		if ["damage", "rank"].has(str((t as Dictionary).get("id", ""))):
			var tile := AftermathTiles.tile(t)
			tile.custom_minimum_size = Vector2(0, 104)
			v.add_child(tile)
	var focus := ResultTabs.body_focus(main, m, f)   # the body report's one action: train the part that went first
	if focus != null:
		v.add_child(focus)
	return p


static func footer(main: Node, m: Dictionary, f: Dictionary, opp: Dictionary) -> HBoxContainer:
	var foot := UI.hbox(14)
	foot.name = "ResultFoot"
	var take := []
	if m.has("tickets"):
		take.append(["%d SOLD" % int(m["tickets"]["sold"]), "DEBUT TICKETS", UI.GOLD])
		take.append([UI.signed(int(m.get("gym_cut", 0))), "THE GYM'S SHARE", UI.GREEN if int(m.get("gym_cut", 0)) > 0 else UI.MUTED])
	elif bool(m.get("pro", false)):
		take.append([UI.signed(int(m.get("gym_cut", 0))), "THE GYM'S PURSE SHARE", UI.GREEN])
	else:
		var cut := int(m.get("club_cut", BoutRules.TICKET_CUT))
		take.append([UI.signed(cut), "CLUB TICKET CUT" if cut > 0 else "NO TICKET CUT AT THE CHAMPIONSHIPS", UI.GREEN if cut > 0 else UI.MUTED])
	var lost := int(m.get("members_lost", 0))
	var win := bool(m["win"])
	take.append(["+%d" % BoutRules.WIN_MEMBERS if win else ("-%d" % lost if lost > 0 else "NO CHANGE"), "MEMBERS AFTER THE NEWS", UI.GOLD if lost == 0 else UI.RED])
	if m.has("injury"):
		take.append([str(m["injury"]).to_upper(), "INJURY REPORT", UI.RED])
	var rib := UI.hbox(44)
	for it in take:
		var cell := UI.vbox(0)
		cell.add_child(UI.display(str(it[0]), 30, it[2]))
		cell.add_child(UI.caps(str(it[1])))
		rib.add_child(cell)
	foot.add_child(rib)
	foot.add_child(UI.spacer())
	var home := UI.button("Back home", "Btn", main.act.bind("afterfight", ""))
	home.name = "BackHome"
	home.add_theme_font_size_override("font_size", 24)
	home.custom_minimum_size = Vector2(240, 56)
	home.size_flags_vertical = Control.SIZE_SHRINK_END
	foot.add_child(home)
	return foot
