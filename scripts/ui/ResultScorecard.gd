extends RefCounted
## S504 the result page's SCORECARD tab (operator's S503 idea, Q-265 mockup docs/mockups/s504/scorecard/scorecard.png,
## his "Yes, build it"): the three judges' sheets on paper (ScoreSheet.build: a row a round, the running score, the total
## ringed, the corner stamp), a hover on a score = that judge's reason for the round, the rounds one card each (what
## decided it), and what the result means (the cards, the close round, the body report's one action).
## The scores are the ones the header's judge grid shows: the judges' own when they decided the bout, else 10-9 to the
## round's winner with the third judge's close round flipped (BoutRules.cards_of) - so the sheets always add up to the cards.
##   tab(main, m, f, names) -> VBoxContainer      sheet_input(m) -> ScoreSheet's input, or {} before a round is complete

const Palette := preload("res://scripts/ui/Palette.gd")
const UI := preload("res://scripts/ui/TV.gd")
const Broadcast := preload("res://scripts/ui/Broadcast.gd")
const BoutRules := preload("res://scripts/rules/BoutRules.gd")
const ScoreSheet := preload("res://scripts/rules/ScoreSheet.gd")
const FightStats := preload("res://scripts/rules/FightStats.gd")
const ResultCause := preload("res://scripts/ui/ResultCause.gd")
const ResultTabs := preload("res://scripts/ui/ResultTabs.gd")

const TEXT := 20
const PAPER := Palette.TEXT
const PAPER_LINE := Palette.MUTED
const RED_INK := Palette.ACTION
const BLUE_INK := Palette.PAPER_BLUE


static func tab(main: Node, m: Dictionary, f: Dictionary, names: Array) -> VBoxContainer:
	var v := UI.vbox(10)
	var rounds: Array = m["rounds"]
	var stop := str(m.get("stopped", ""))
	var j := sheet_input(m)
	var cards := ResultCause.panel("")
	cards.name = "JudgesCards"
	var cv: VBoxContainer = cards.get_child(0)
	var head := UI.hbox(14)
	head.add_child(_title("THE JUDGES' CARDS"))
	var sub := "10-point must: every round 10 to its winner, 9 to the other. Hover a score for the round."
	if stop != "":
		sub = "Stopped in round %d: the cards up to then, never needed." % rounds.size()
	var sl := UI.label(sub, 16, UI.MUTED)
	sl.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	head.add_child(sl)
	cv.add_child(head)
	if j.is_empty():
		cv.add_child(UI.label("Stopped in the first round: no round was scored.", TEXT, UI.FG))
	else:
		var sheet := ScoreSheet.build(j, {"a_corner": "red", "judge_seed": _seed(m), "leans": _leans(m)})
		var row := UI.hbox(18)
		row.name = "Sheets"
		for ji in (sheet["judges"] as Array).size():
			row.add_child(_sheet(ji, sheet["judges"][ji], j, m))
		cv.add_child(row)
	v.add_child(cards)
	var low := UI.hbox(14)
	var rr := _rounds(m, j)
	rr.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	rr.size_flags_stretch_ratio = 2.0
	low.add_child(rr)
	var means := _means(main, m, f, j)
	means.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	low.add_child(means)
	v.add_child(low)
	return v


## ScoreSheet's input from the bout: {cards, by_round, verdict, winner}. Only rounds that went the distance are scored.
static func sheet_input(m: Dictionary) -> Dictionary:
	var rounds: Array = m["rounds"]
	if str(m.get("stopped", "")) != "":
		rounds = rounds.slice(0, rounds.size() - 1)
	if rounds.is_empty():
		return {}
	var cards: Array = m.get("cards", [])
	if _judged(m) and rounds.all(func(r): return (r as Dictionary).has("judges")):
		var by_round: Array = []
		var tot := [[0, 0], [0, 0], [0, 0]]
		for r in rounds:
			var row: Array = []
			for ji in 3:
				var s: Dictionary = (r["judges"] as Array)[ji]
				row.append({"a": int(s["a"]), "b": int(s["b"]), "reason": "", "part": ""})
				tot[ji][0] += int(s["a"])
				tot[ji][1] += int(s["b"])
			by_round.append(row)
		var jd: Dictionary = m["judges"]
		return {"cards": tot, "by_round": by_round, "running": [], "verdict": str(jd.get("verdict", "draw")), "winner": str(jd.get("winner", ""))}
	var flip := BoutRules.flip_round(rounds) if cards.size() >= 3 and str(cards[2]) != str(cards[0]) else -1
	return ScoreSheet.from_rounds(rounds.map(func(r): return {"won": bool((r as Dictionary)["won"])}), flip)


## The judges' own cards decided the bout (ResultPage._judged, the same test).
static func _judged(m: Dictionary) -> bool:
	var j: Dictionary = m.get("judges", {})
	if j.is_empty() or not j.has("cards"):
		return false
	var theirs: Array = (j["cards"] as Array).map(func(c): return "%d-%d" % [int(c[0]), int(c[1])])
	return theirs == (m.get("cards", []) as Array).map(func(c): return str(c))


static func _leans(m: Dictionary) -> Array:
	return (m.get("judges", {}) as Dictionary).get("leans", []) if _judged(m) else []


## The panel's names come from the bout itself, so a redraw keeps the same three judges.
static func _seed(m: Dictionary) -> int:
	return absi(hash("%s|%s|%d" % [str(m.get("fid", "")), str(m.get("cards", [])), (m["rounds"] as Array).size()]))


static func _title(text: String) -> Label:
	var t := UI.caps(text)
	t.add_theme_color_override("font_color", UI.GOLD)
	t.add_theme_font_size_override("font_size", 18)
	return t


## One judge's paper: name and lean, RED / BLUE / SO FAR columns, a row a round, the total ringed in the winner's ink.
static func _sheet(ji: int, jd: Dictionary, j: Dictionary, m: Dictionary) -> PanelContainer:
	var p := PanelContainer.new()
	p.name = "Sheet%d" % (ji + 1)
	p.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	p.add_theme_stylebox_override("panel", UI.box(PAPER, PAPER_LINE, 3, 1, 16, 8))
	var v := UI.vbox(3)
	p.add_child(v)
	var top := UI.hbox(8)
	top.add_child(UI.label("JUDGE %d · %s" % [ji + 1, str(jd["name"])], 22, Palette.PAPER_INK, "bold"))
	top.add_child(UI.spacer())
	var lean := str(jd.get("lean", ""))
	if lean != "":
		var lw := UI.label("counts %s double" % _lean_word(lean).to_lower(), 16, Palette.PAPER_MUTED)
		lw.size_flags_vertical = Control.SIZE_SHRINK_END
		top.add_child(lw)
	v.add_child(top)
	v.add_child(_rule(2))
	var g := GridContainer.new()
	g.columns = 4
	g.add_theme_constant_override("h_separation", 10)
	g.add_theme_constant_override("v_separation", 0)
	for hd in ["", "RED · YOURS", "BLUE", "SO FAR"]:
		var hl := UI.label(hd, 15, RED_INK if hd.begins_with("RED") else (BLUE_INK if hd == "BLUE" else Palette.PAPER_MUTED), "bold")
		hl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		g.add_child(hl)
	var run := [0, 0]
	for row in jd["rows"]:
		var ri := int(row["round"]) - 1
		var a := int(row["red"])
		var b := int(row["blue"])
		run[0] += a
		run[1] += b
		var rl := UI.label("ROUND %d" % (ri + 1), 17, Palette.PAPER_INK, "bold")
		rl.custom_minimum_size = Vector2(110, 0)
		g.add_child(rl)
		var tip := reason(m, j, ji, ri)
		g.add_child(_score(a, RED_INK, a > b, tip, "Score%d_%d_a" % [ji + 1, ri + 1]))
		g.add_child(_score(b, BLUE_INK, b > a, tip, "Score%d_%d_b" % [ji + 1, ri + 1]))
		var so := UI.label("%d-%d" % [run[0], run[1]], 18, Palette.PAPER_MUTED, "mono")
		so.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		g.add_child(so)
	v.add_child(g)
	v.add_child(_rule(2))
	var tot := UI.hbox(10)
	var tl := UI.label("TOTAL", 20, Palette.PAPER_INK, "bold")
	tl.custom_minimum_size = Vector2(110, 0)
	tot.add_child(tl)
	var ta := int(jd["total_red"])
	var tb := int(jd["total_blue"])
	tot.add_child(_total(ta, RED_INK, ta > tb))
	tot.add_child(_total(tb, BLUE_INK, tb > ta))
	var stamp := str(jd["card_winner"])
	var st := UI.label("RED" if stamp == "red" else ("BLUE" if stamp == "blue" else "EVEN"), 22,
		RED_INK if stamp == "red" else (BLUE_INK if stamp == "blue" else Palette.PAPER_MUTED), "display")
	st.name = "Stamp%d" % (ji + 1)
	var sp := PanelContainer.new()
	var sb := UI.box(Palette.CLEAR, st.get_theme_color("font_color"), 4, 3, 10, 2)
	sp.add_theme_stylebox_override("panel", sb)
	sp.rotation_degrees = -6.0
	sp.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	sp.add_child(st)
	tot.add_child(sp)
	v.add_child(tot)
	return p


static func _rule(h: int) -> ColorRect:
	var r := ColorRect.new()
	r.color = Palette.PAPER_INK
	r.custom_minimum_size = Vector2(0, h)
	r.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return r


## A judge's score in the corner's ink, big; the round's winner reads larger. The hover is the judge's reason.
static func _score(n: int, ink: Color, won: bool, tip: String, nm: String) -> PanelContainer:
	var p := PanelContainer.new()
	p.name = nm
	p.add_theme_stylebox_override("panel", UI.box(Palette.CLEAR, Palette.CLEAR, 4, 0, 6, 0))
	p.mouse_filter = Control.MOUSE_FILTER_STOP
	p.tooltip_text = tip
	p.custom_minimum_size = Vector2(0, 30)
	p.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var l := UI.label(str(n), 30 if won else 24, ink if won else ink.lerp(PAPER, 0.25), "display")
	l.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	l.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	l.mouse_filter = Control.MOUSE_FILTER_IGNORE
	p.add_child(l)
	return p


static func _total(n: int, ink: Color, won: bool) -> PanelContainer:
	var p := PanelContainer.new()
	p.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	p.add_theme_stylebox_override("panel", UI.box(Palette.CLEAR, ink if won else Palette.CLEAR, 24, 3 if won else 0, 12, 0))
	var l := UI.label(str(n), 30, ink, "display")
	l.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	p.add_child(l)
	return p


static func _lean_word(lean: String) -> String:
	var path := "res://scripts/state/JudgeNight.gd"
	if not ResourceLoader.exists(path):
		return lean
	var words: Dictionary = (load(path) as Script).get_script_constant_map().get("LEAN_WORD", {})
	return str(words.get(lean, lean))


## One judge's reason for one round, from the round's own records: who the judge gave it to, the exchanges won, the
## punches landed, counts and hurt, the ropes, and why this card went with or against the other two.
static func reason(m: Dictionary, j: Dictionary, ji: int, ri: int) -> String:
	var r: Dictionary = (m["rounds"] as Array)[ri]
	var row: Array = (j["by_round"] as Array)[ri]
	var sc: Dictionary = row[ji]
	var mine := int(sc["a"]) > int(sc["b"])
	var lines: PackedStringArray = []
	lines.append("Round %d · Judge %d gave it to %s" % [ri + 1, ji + 1, "red, your boxer" if mine else "blue"])
	var f := _facts(r)
	lines.append("Exchanges won: red %d · blue %d" % [f["won"][0], f["won"][1]])
	lines.append("Punches landed: red %d · blue %d" % [f["landed"][0], f["landed"][1]])
	if int(f["hurt"][0]) + int(f["hurt"][1]) > 0:
		lines.append("Hurt: red %d · blue %d" % [f["hurt"][0], f["hurt"][1]])
	var down := str(r.get("down", ""))
	if down != "":
		lines.append("Count: %s took a standing count" % ("red" if down == "a" else "blue"))
	if int(f["pinned"]) > 0:
		lines.append("Red on the ropes: %d of %d exchanges" % [f["pinned"], f["n"]])
	var others := 0
	for k in row.size():
		if k != ji and (int(row[k]["a"]) > int(row[k]["b"])) == mine:
			others += 1
	var who := "red" if mine else "blue"
	if others == row.size() - 1:
		if int(f["won"][0]) == int(f["won"][1]):
			lines.append("Level on exchanges: %s did more in them. All three judges agreed." % who)
		else:
			lines.append("%s won more of the exchanges. All three judges agreed." % who.capitalize())
	else:
		lines.append("A close round: this judge saw it the other way. The other two scored it for %s." % ("blue" if mine else "red"))
	var lean := str(_leans(m)[ji]) if ji < _leans(m).size() else ""
	if lean != "":
		lines.append("This judge counts %s double." % _lean_word(lean).to_lower())
	return "\n".join(lines)


## A round's facts from its exchange records, ours first: exchanges won, punches landed, hurt, exchanges on the ropes.
static func _facts(r: Dictionary) -> Dictionary:
	var exs: Array = r.get("exchanges", [])
	var out := {"won": [0, 0], "landed": [0, 0], "hurt": [0, 0], "pinned": 0, "n": exs.size()}
	for x in exs:
		var won := bool(x.get("won", false))
		out["won"][0 if won else 1] += 1
		var l: Array = x.get("landed", [0, 0])
		for k in 2:
			out["landed"][k] += int(l[k]) if l.size() > k else 0
		var h: Array = ((x.get("after", {}) as Dictionary).get("hurt", [false, false]) as Array)
		for k in 2:
			out["hurt"][k] += int(h.size() > k and bool(h[k]))
		out["pinned"] += int(bool(x.get("pinned", false)))
	if exs.is_empty() and r.has("landed"):
		out["landed"] = [int(r["landed"][0]), int(r["landed"][1])]
	return out


## ROUND BY ROUND: a card a round - how many judges it went to, landed, exchanges won, the ropes, the corner's call, a
## bar of the punches landed, and the one line that decided it.
static func _rounds(m: Dictionary, j: Dictionary) -> PanelContainer:
	var p := ResultCause.panel("")
	p.name = "RoundByRound"
	var v: VBoxContainer = p.get_child(0)
	var head := UI.hbox(14)
	head.add_child(_title("ROUND BY ROUND"))
	var hs := UI.label("what decided each round", 16, UI.MUTED)
	hs.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	head.add_child(hs)
	v.add_child(head)
	var row := UI.hbox(12)
	var rounds: Array = m["rounds"]
	for ri in rounds.size():
		var r: Dictionary = rounds[ri]
		var f := _facts(r)
		var c := PanelContainer.new()
		c.name = "RoundCard%d" % (ri + 1)
		c.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		c.add_theme_stylebox_override("panel", UI.box(Palette.TILE, Palette.LINE, 6, 1, 14, 8))
		var cv := UI.vbox(2)
		c.add_child(cv)
		var top := UI.hbox(8)
		top.add_child(UI.label("Round %d" % (ri + 1), 22, Palette.TEXT, "bold"))
		top.add_child(UI.spacer())
		var verdict := _round_word(m, j, ri)
		top.add_child(UI.label(verdict[0], 20, verdict[1], "bold"))
		cv.add_child(top)
		cv.add_child(_kv("Exchanges won", "%d - %d" % [f["won"][0], f["won"][1]]))
		cv.add_child(_kv("Punches landed", "%d - %d" % [f["landed"][0], f["landed"][1]]))
		if int(f["pinned"]) > 0:
			cv.add_child(_kv("Red on the ropes", "%d of %d exchanges" % [f["pinned"], f["n"]]))
		var call := str(r.get("corner", ""))
		if call != "":
			cv.add_child(_kv("Corner call", FightStats.call_word(call)))
		cv.add_child(_share(int(f["landed"][0]), int(f["landed"][1])))
		cv.add_child(UI.label(_decided(r, f, verdict[2]), 16, UI.MUTED, "body", true))
		row.add_child(c)
	v.add_child(row)
	return p


static func _kv(key: String, value: String) -> HBoxContainer:
	var h := UI.hbox(8)
	h.add_child(UI.label(key, 17, UI.FG))
	h.add_child(UI.spacer())
	h.add_child(UI.label(value, 17, UI.FG, "bold"))
	return h


## "red, 3 of 3" in the side's colour; a stopped round reads as the stoppage.
static func _round_word(m: Dictionary, j: Dictionary, ri: int) -> Array:
	var stop := str(m.get("stopped", ""))
	var by: Array = j.get("by_round", [])
	if ri >= by.size():
		return ["stopped" if stop != "" else "", UI.GOLD, false]
	var row: Array = by[ri]
	var ours := row.filter(func(s): return int(s["a"]) > int(s["b"])).size()
	var split := ours > 0 and ours < row.size()
	if ours * 2 > row.size():
		return ["red, %d of %d" % [ours, row.size()], Broadcast.HERS.lightened(0.25), split]
	return ["blue, %d of %d" % [row.size() - ours, row.size()], Broadcast.THEIRS.lightened(0.15), split]


## The punches landed as one bar, red's share from the left.
static func _share(a: int, b: int) -> HBoxContainer:
	var h := UI.hbox(0)
	h.custom_minimum_size = Vector2(0, 8)
	var tot := maxi(1, a + b)
	for k in 2:
		var cr := ColorRect.new()
		cr.color = Broadcast.HERS if k == 0 else Broadcast.THEIRS
		cr.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		cr.size_flags_stretch_ratio = maxf(0.02, float(a if k == 0 else b) / float(tot))
		cr.custom_minimum_size = Vector2(0, 8)
		h.add_child(cr)
	return h


## The one line that decided the round: a count, the ropes, or the exchanges and punches.
static func _decided(r: Dictionary, f: Dictionary, split: bool) -> String:
	var won := bool(r.get("won", false))
	var who := "Your boxer" if won else "The opponent"
	var down := str(r.get("down", ""))
	if down != "":
		return "%s put the other down for a count." % who if (down == "b") == won else "%s took the round despite a count." % who
	var w: Array = f["won"]
	if int(w[0]) == int(w[1]):
		if split:
			return "Level on exchanges, %d each: close enough for the judges to split on it." % int(w[0])
		return "Level on exchanges, %d each: %s did more in them, and all three judges saw it." % [int(w[0]), who.to_lower()]
	if int(f["pinned"]) * 2 >= int(f["n"]) and not won:
		return "Your boxer spent the round on the ropes; the opponent won %d of %d exchanges." % [w[1], f["n"]]
	return "%s won %d of %d exchanges and landed %d to %d." % [who, w[0] if won else w[1], f["n"],
		f["landed"][0] if won else f["landed"][1], f["landed"][1] if won else f["landed"][0]]


## WHAT IT MEANS: the cards in one line, the close round, and the body report's one action. The rank the bout earned
## stays in the header only (operator C425: "same info on the card twice").
static func _means(main: Node, m: Dictionary, f: Dictionary, j: Dictionary) -> PanelContainer:
	var p := ResultCause.panel("")
	p.name = "WhatItMeans"
	var v: VBoxContainer = p.get_child(0)
	v.add_child(_title("WHAT IT MEANS"))
	var stop := str(m.get("stopped", ""))
	var cards: Array = m.get("cards", [])
	if stop != "":
		v.add_child(UI.label("A stoppage: the cards were never needed.", TEXT, UI.FG, "body", true))
	elif not cards.is_empty():
		v.add_child(UI.label("The cards: %s." % ", ".join(PackedStringArray(cards.map(func(c): return str(c)))), TEXT, UI.FG, "body", true))
	var close := _close_round(j)
	if close >= 0 and stop == "":
		var cl := UI.label("Round %d was the close one: one judge had it the other way." % (close + 1), TEXT, UI.FG, "body", true)
		cl.name = "CloseRound"
		v.add_child(cl)
	var focus := ResultTabs.body_focus(main, m, f)
	if focus != null:
		v.add_child(UI.sep())
		v.add_child(focus)
	return p


## The one round the judges did not all score alike (-1 when none or more than one).
static func _close_round(j: Dictionary) -> int:
	var found := -1
	var by: Array = j.get("by_round", [])
	for ri in by.size():
		var row: Array = by[ri]
		var ours := row.filter(func(s): return int(s["a"]) > int(s["b"])).size()
		if ours > 0 and ours < row.size():
			if found >= 0:
				return -1
			found = ri
	return found
