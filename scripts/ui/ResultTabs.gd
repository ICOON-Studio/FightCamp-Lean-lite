extends RefCounted
## S443 the result page's rounds strip (on the summary) and its three tabs (ResultPage): the 18 exchanges, the numbers and
## the plan. Every cell comes from the bout's exchange records; nothing is written here.
##   round_strip(m, names, lab)   exchanges(m, names)   numbers(main, m, f, opp, names)   plan(m, names)

const UI := preload("res://scripts/ui/TV.gd")
const Broadcast := preload("res://scripts/ui/Broadcast.gd")
const BoutRules := preload("res://scripts/rules/BoutRules.gd")
const Exchanges := preload("res://scripts/rules/Exchanges.gd")
const FightStats := preload("res://scripts/rules/FightStats.gd")
const FightFlow := preload("res://scripts/rules/FightFlow.gd")
const PlanLines := preload("res://scripts/rules/PlanLines.gd")
const StrikeMap := preload("res://scripts/rules/StrikeMap.gd")
const PlanFight := preload("res://scripts/rules/PlanFight.gd")
const RingDuel := preload("res://scripts/state/RingDuel.gd")
const Data := preload("res://scripts/state/Data.gd")
const MatchStats := preload("res://scripts/ui/MatchStats.gd")
const AftermathTiles := preload("res://scripts/ui/AftermathTiles.gd")
const WhyCard := preload("res://scripts/ui/WhyCard.gd")
const ResultMarks := preload("res://scripts/ui/ResultMarks.gd")
const ResultCause := preload("res://scripts/ui/ResultCause.gd")

const TEXT := 20
const FIT_COL := {"best": Color("#6cc27a"), "ok": Color("#6cc27a"), "wrong": Color("#e0503c"), "none": Color("#b5a595")}


## Three rounds side by side: who took it and how the judges saw it, a square an exchange in its winner's colour with the
## punches landed, the plan line used (its letter, green when it fit, red when it walked into it), hurt, energy at the bell.
static func round_strip(m: Dictionary, names: Array, lab: Dictionary) -> HBoxContainer:
	var h := UI.hbox(14)
	h.name = "RoundStrip"
	var per := Broadcast.judge_rounds(m["rounds"], m["cards"]) if str(m.get("stopped", "")) == "" else []
	var cause := str(((lab.get("changes", {}) as Dictionary).get("rewrite", {}) as Dictionary).get("move", ""))
	var rounds: Array = m["rounds"]
	for i in rounds.size():
		var r: Dictionary = rounds[i]
		var p := ResultCause.panel("")
		p.name = "Round%d" % (i + 1)
		p.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		var v: VBoxContainer = p.get_child(0)
		var exs: Array = r.get("exchanges", [])
		var won := exs.filter(func(x): return bool(x["won"])).size()
		var top := UI.hbox(12)
		top.add_child(UI.label("ROUND %d" % (i + 1), 24, Color.WHITE, "display"))
		top.add_child(UI.label("%d-%d" % [won, exs.size() - won], 24, (Broadcast.HERS if bool(r["won"]) else Broadcast.THEIRS).lightened(0.3), "display"))
		top.add_child(UI.spacer())
		top.add_child(UI.label(_judges_word(per, i, names), TEXT, UI.MUTED))
		v.add_child(top)
		var row := UI.hbox(6)
		for x in exs:
			row.add_child(_square(x, r, names, cause))
		v.add_child(row)
		var en: Dictionary = r.get("energy", {})
		if not en.is_empty():
			v.add_child(UI.label("Energy at the bell: %s %d, %s %d" % [names[0], roundi(float(en.get("a_end", 0))), names[1],
				roundi(float(en.get("b_end", 0)))], 18, UI.MUTED))
		h.add_child(p)
	return h


static func _judges_word(per: Array, i: int, names: Array) -> String:
	if per.is_empty():
		return ""
	var ours := per.filter(func(j): return bool(j[i])).size()
	if ours == per.size():
		return "all 3 judges %s" % names[0]
	if ours == 0:
		return "all 3 judges %s" % names[1]
	return "%d judges %s, %d %s" % [per.size() - ours, names[1], ours, names[0]] if ours < per.size() - ours else "%d judges %s, %d %s" % [ours, names[0], per.size() - ours, names[1]]


static func _square(x: Dictionary, r: Dictionary, names: Array, cause: String) -> VBoxContainer:
	var won := bool(x["won"])
	var col: Color = Broadcast.HERS if won else Broadcast.THEIRS
	var v := UI.vbox(3)
	v.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var sq := PanelContainer.new()
	var sb := UI.box(col.darkened(0.25), col.lightened(0.2), 3, 1, 2, 4)
	if bool(x.get("planned", false)) and str(x.get("arrow", "")) == cause and cause != "":
		sb.border_color = UI.GOLD
		sb.set_border_width_all(3)
	sq.add_theme_stylebox_override("panel", sb)
	sq.custom_minimum_size = Vector2(0, 40)
	sq.mouse_filter = Control.MOUSE_FILTER_PASS
	sq.tooltip_text = _tip(x, names)
	var l: Array = x.get("landed", [0, 0])
	var t := UI.label("%d-%d" % [int(l[0]), int(l[1])], 20, Color.WHITE, "bold")
	t.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	sq.add_child(t)
	v.add_child(sq)
	var marks := UI.hbox(4)
	marks.alignment = BoxContainer.ALIGNMENT_CENTER
	var letter := _letter(r, str(x.get("arrow", ""))) if bool(x.get("planned", false)) else ""
	if letter != "":
		marks.add_child(_tag(letter + (" ✓" if won else " ✕"), FIT_COL.get(str(x.get("arrow_fit", "none")), UI.MUTED)))
	if bool(((x.get("after", {}) as Dictionary).get("hurt", [false, false]) as Array)[0]):
		marks.add_child(_tag("HURT", UI.AMBER))
	v.add_child(marks)
	return v


static func _tag(text: String, col: Color) -> Label:
	var l := UI.label(text, 16, col, "bold")
	l.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	return l


## The plan line's letter as the round held the plan (the corner can change a line between rounds).
static func _letter(r: Dictionary, move: String) -> String:
	var plan: Array = r.get("plan", [])
	for i in plan.size():
		if str((plan[i] as Dictionary).get("move", "")) == move:
			return "ABCDEFGHI"[i] if i < 9 else ""
	return ""


static func _tip(x: Dictionary, names: Array) -> String:
	var lines: PackedStringArray = []
	lines.append(str(x.get("verdict", "")))
	var game := FightStats.game_word(str(x.get("mode", "")))
	if game != "":
		lines.append("%s's game: %s." % [names[1], game])
	for k in ["duel_line", "habit_line", "clinch_line", "perk_line"]:
		if str(x.get(k, "")) != "":
			lines.append(str(x[k]))
	return "\n".join(lines)


## THE EXCHANGES: a row a round, a card an exchange: the clock, the opponent's game, the punches landed in the winner's
## colour, the plan line used and its fit, a shout, the place in the ring, hurt.
static func exchanges(m: Dictionary, names: Array) -> VBoxContainer:
	var v := UI.vbox(10)
	var key := UI.label("Each card: 30 seconds. Colour = who won it (%s red, %s blue); punches landed %s first. Hover a card for what happened." % [names[0], names[1], names[0]],
		18, UI.MUTED, "body", true)
	v.add_child(key)
	for r in m["rounds"]:
		var row := UI.hbox(8)
		var head := UI.vbox(0)
		head.custom_minimum_size = Vector2(150, 0)
		head.add_child(UI.label("ROUND %d" % int(r["n"]), 24, Color.WHITE, "display"))
		var call := str(r.get("corner", ""))
		head.add_child(UI.label("Call: %s" % FightStats.call_word(call) if call != "" else "No call", 18, UI.MUTED, "body", true))
		row.add_child(head)
		for x in r.get("exchanges", []):
			row.add_child(_ex_card(x, r, names))
		v.add_child(row)
	return v


static func _ex_card(x: Dictionary, r: Dictionary, names: Array) -> PanelContainer:
	var won := bool(x["won"])
	var col: Color = Broadcast.HERS if won else Broadcast.THEIRS
	var p := PanelContainer.new()
	var sb := UI.box(Color(col.r, col.g, col.b, 0.16), col, 4, 0, 10, 6)
	sb.border_width_top = 4
	p.add_theme_stylebox_override("panel", sb)
	p.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	p.mouse_filter = Control.MOUSE_FILTER_PASS
	p.tooltip_text = _tip(x, names)
	var v := UI.vbox(1)
	v.mouse_filter = Control.MOUSE_FILTER_IGNORE
	p.add_child(v)
	var secs := (int(x.get("i", 0)) + 1) * int(Exchanges.EX_SECONDS)
	var top := UI.hbox(6)
	top.add_child(UI.label("%d:%02d" % [secs / 60, secs % 60], 16, UI.MUTED, "mono"))
	top.add_child(UI.spacer())
	var l: Array = x.get("landed", [0, 0])
	top.add_child(UI.label("%d-%d" % [int(l[0]), int(l[1])], 24, col.lightened(0.35), "display"))
	v.add_child(top)
	v.add_child(UI.label(FightStats.game_word(str(x.get("mode", ""))), 18, Color.WHITE, "bold"))
	var place := int(x.get("place", -1))
	if place >= 0 and place < RingDuel.PLACE_WORD_CAP.size():
		v.add_child(UI.label(str(RingDuel.PLACE_WORD_CAP[place]) + (", on the ropes" if bool(x.get("pinned", false)) else ""), 16, UI.MUTED))
	var tags := UI.hbox(6)
	var letter := _letter(r, str(x.get("arrow", ""))) if bool(x.get("planned", false)) else ""
	if letter != "":
		tags.add_child(_tag("%s %s" % [letter, _move(str(x["arrow"]))], FIT_COL.get(str(x.get("arrow_fit", "none")), UI.MUTED)))
	if bool(x.get("shout", false)):
		tags.add_child(_tag("Shout: %s" % FightStats.call_word(str(x.get("call", ""))), UI.GOLD))
	if bool(((x.get("after", {}) as Dictionary).get("hurt", [false, false]) as Array)[0]):
		tags.add_child(_tag("HURT", UI.AMBER))
	v.add_child(tags)
	return p


static func _move(id: String) -> String:
	return str(StrikeMap.move(id).get("name", id))


## THE NUMBERS: both figures with the marks the bout left, the fight's numbers between them, the games and the calls
static func numbers(_main: Node, m: Dictionary, f: Dictionary, opp: Dictionary, names: Array) -> VBoxContainer:
	var v := UI.vbox(10)
	var hero := UI.hbox(24)
	var bodies: Array = m.get("bodies", ["", ""])
	hero.add_child(_marked(ResultMarks.figure(m.get("body_map", {}), "a", str(bodies[0]), "red", m.get("body_track", {})), str(f.get("name", names[0])), Broadcast.HERS, false))
	var mid := UI.vbox(12)
	mid.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var st := FightStats.of(m["rounds"])
	var bars := MatchStats.bars(st, names)
	bars.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	mid.add_child(bars)
	mid.alignment = BoxContainer.ALIGNMENT_CENTER
	hero.add_child(mid)
	hero.add_child(_marked(ResultMarks.figure(m.get("body_map", {}), "b", str(bodies[1]), "blue", m.get("body_track", {})), str(opp.get("name", names[1])), Broadcast.THEIRS, true))
	v.add_child(hero)
	v.add_child(MatchStats.lists(st, names))   # the games and the calls under the figures: side by side they ran past 1920
	return v


## The body report's line and its button (sets next week's focus), or null when the report names no part.
static func body_focus(main: Node, m: Dictionary, f: Dictionary) -> Control:
	var rep: Dictionary = m.get("body_report", {})
	var focus := str(rep.get("focus", ""))
	if focus == "":
		return null
	var row := UI.vbox(6)
	row.add_child(UI.label(str(rep.get("line", "")), 18, UI.FG, "body", true))
	var set_now := str(f.get("focus", "")) == focus
	var btn := UI.button(("Training %s next week" if set_now else "Train %s next week") % str(Data.LABEL.get(focus, focus)).to_lower(),
		"Btn", main.act.bind("bodyfocus", "%s|%s" % [m["fid"], focus]), set_now, "Already set as next week's focus" if set_now else "")
	btn.name = "BodyFocus"
	btn.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
	if not set_now:
		btn.tooltip_text = "%s. %s" % [str(rep.get("advice", "")), str(m.get("body_change", ""))]
	row.add_child(btn)
	return row


static func _marked(fig: Control, name: String, colour: Color, right: bool) -> PanelContainer:
	var p := Broadcast.corner(fig, name, colour, right)
	if fig != null and fig.has_meta("result_size"):
		fig.custom_minimum_size = fig.get_meta("result_size")
	return p


## THE PLAN: every line with its fit and a square a use (won / lost), the lines that never fired, the corner's calls a
## round, the shouts, the plan's grade (WhyCard) and the corner tile.
static func plan(m: Dictionary, names: Array) -> HBoxContainer:
	var h := UI.hbox(16)
	var left := ResultCause.panel("THE PLAN %s WALKED OUT WITH" % str(names[0]).to_upper())
	left.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	left.size_flags_stretch_ratio = 1.5
	var lv: VBoxContainer = left.get_child(0)
	var rounds: Array = m["rounds"]
	var arrows: Array = (rounds[0] as Dictionary).get("plan", []) if not rounds.is_empty() else []
	var uses := {}
	var game := ""
	for r in rounds:
		for x in r.get("exchanges", []):
			if game == "":
				game = str(x.get("mode", ""))
			if bool(x.get("planned", false)):
				var u: Array = uses.get(str(x["arrow"]), [])
				u.append(bool(x["won"]))
				uses[str(x["arrow"])] = u
	if arrows.is_empty():
		lv.add_child(UI.label("No plan was written: the coach boxed it from the tape.", TEXT, UI.MUTED, "body", true))
	for i in arrows.size():
		var a: Dictionary = arrows[i]
		var row := StrikeMap.move(str(a["move"]))
		var when := str(a.get("when", ""))
		var place := str(PlanLines.PLACE_WORDS.get(str(row.get("from", "")), ""))
		var cond := "any time" if when == "" else "when " + str(FightFlow.WHEN_WORDS.get(when, when))
		var sit := PlanLines.sit_for(when, game)
		var fit := "none" if sit == "" else PlanFight.fit(str(a["move"]), sit)
		var line := UI.hbox(10)
		line.add_child(_tag("ABCDEFGHI"[i] if i < 9 else "", UI.GOLD))
		var words := UI.label("%s, %s → %s" % [place, cond, _move(str(a["move"]))], TEXT, Color.WHITE, "body", true)
		line.add_child(words)
		line.add_child(UI.label(str(PlanLines.FIT_WORDS.get(fit, "")), TEXT, FIT_COL.get(fit, UI.MUTED), "bold"))
		var u: Array = uses.get(str(a["move"]), [])
		var res := UI.label("never used" if u.is_empty() else "won %d of %d" % [u.filter(func(w): return w).size(), u.size()], TEXT,
			UI.MUTED if u.is_empty() else Color.WHITE)
		res.custom_minimum_size = Vector2(150, 0)
		line.add_child(res)
		lv.add_child(line)
	lv.add_child(UI.sep())
	var calls := UI.hbox(18)
	for r in rounds:
		var c := str(r.get("corner", ""))
		var exs: Array = r.get("exchanges", [])
		var w := exs.filter(func(x): return bool(x["won"])).size()
		calls.add_child(UI.label("R%d %s: won %d of %d" % [int(r["n"]), FightStats.call_word(c) if c != "" else "no call", w, exs.size()], 18, UI.FG))
	lv.add_child(UI.caps("THE CORNER'S CALL EACH ROUND"))
	lv.add_child(calls)
	h.add_child(left)
	var right := UI.vbox(12)
	right.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	right.add_child(WhyCard.build(rounds, str(names[0]), str(names[1])))
	for t in m.get("aftermath", []):
		if str((t as Dictionary).get("id", "")) == "corner":
			right.add_child(AftermathTiles.tile(t))
	h.add_child(right)
	return h

