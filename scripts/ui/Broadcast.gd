extends RefCounted
## S323 (operator on the round and result pages, Q-S294-40: "Layout looks cheap / like a spreadsheet"). What a fight
## broadcast shows between rounds and at the verdict (CompuBox graphics on DAZN / Sky / ESPN): the two fighters big on
## their corner's colour, few numbers in very large type with a thin split bar, the leader's number bright and the other
## dim, the coach as a quote, the verdict as the ring announcer reads it. No boxes inside boxes.
## Builders only; FightNight lays them out.
##   frame(panel) -> VBoxContainer   corner(fig, name, colour, right)   compubox(rows)   tank(a, b)   timeline(exchanges)
##   quote(text, who)   verdict_card(card, won_rounds, colour)   reasons(lines)   ribbon(items)

const UI := preload("res://scripts/ui/TV.gd")  # S333: fight graphics keep the dark TV look

const HERS := Color(0.86, 0.26, 0.22)
const THEIRS := Color(0.26, 0.47, 0.88)
const INK := Color(0.045, 0.04, 0.04, 0.96)
const DIM := Color(1, 1, 1, 0.38)
const TRACK := Color(1, 1, 1, 0.07)


## Restyles the modal as a broadcast graphic: flat ink, square edges, the two corners' colours as a strip on top. Returns
## the padded column to build into.
static func frame(panel: PanelContainer) -> VBoxContainer:
	panel.add_theme_stylebox_override("panel", UI.box(INK, Color(0, 0, 0, 0), 3, 0, 0, 0))
	panel.custom_minimum_size = Vector2(1440, 0)
	var outer := UI.vbox(0)
	panel.add_child(outer)
	var strip := HBoxContainer.new()
	strip.add_theme_constant_override("separation", 0)
	strip.custom_minimum_size = Vector2(0, 6)
	for c in [HERS, THEIRS]:
		var r := ColorRect.new()
		r.color = c
		r.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		strip.add_child(r)
	outer.add_child(strip)
	var pad := MarginContainer.new()
	for side in ["left", "right"]:
		pad.add_theme_constant_override("margin_" + side, 36)
	pad.add_theme_constant_override("margin_top", 24)
	pad.add_theme_constant_override("margin_bottom", 26)
	outer.add_child(pad)
	var v := UI.vbox(18)
	pad.add_child(v)
	return v


## A fighter standing in her corner's light: her body picture, her name in large type, the corner under it.
static func corner(fig: Control, name: String, colour: Color, right: bool) -> PanelContainer:
	var p := PanelContainer.new()
	var sb := UI.box(Color(colour.r, colour.g, colour.b, 0.16), Color(0, 0, 0, 0), 2, 0, 16, 14)
	sb.border_color = colour
	sb.border_width_bottom = 5
	p.add_theme_stylebox_override("panel", sb)
	p.custom_minimum_size = Vector2(260, 0)
	var v := UI.vbox(4)
	p.add_child(v)
	if fig != null:
		fig.custom_minimum_size = Vector2(228, 300)
		fig.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
		v.add_child(fig)
	var n := UI.display(name.to_upper(), 36, Color.WHITE)
	n.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT if right else HORIZONTAL_ALIGNMENT_LEFT
	v.add_child(n)
	var c := UI.caps("BLUE CORNER" if right else "RED CORNER")
	c.add_theme_color_override("font_color", colour.lightened(0.35))
	c.horizontal_alignment = n.horizontal_alignment
	v.add_child(c)
	return p


## The CompuBox rows: [[label, hers, theirs], ...] - big numbers either side (the bigger one bright), the label between,
## a thin bar split by share under it.
static func compubox(rows: Array) -> VBoxContainer:
	var v := UI.vbox(16)
	for r in rows:
		var a := float(r[1])
		var b := float(r[2])
		v.add_child(_numbers_row(str(r[0]), str(int(a)), str(int(b)), a >= b, b >= a))
		v.add_child(_split(0.5 if a + b <= 0.0 else a / (a + b), 6))
	return v


## Energy at the bell as the tank each side has left, filling from her own edge, coloured by how much is left.
static func tank(a: float, b: float) -> VBoxContainer:
	var v := UI.vbox(8)
	v.add_child(_numbers_row("ENERGY AT THE BELL", "%d" % int(a), "%d" % int(b), a >= b, b >= a))
	var row := UI.hbox(14)
	for side in 2:
		var e := clampf(a if side == 0 else b, 0.0, 100.0)
		var bar := HBoxContainer.new()
		bar.add_theme_constant_override("separation", 0)
		bar.custom_minimum_size = Vector2(0, 6)
		bar.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		var fill := _rect(UI.GREEN if e >= 60.0 else (UI.AMBER if e >= 30.0 else UI.RED), maxf(0.01, e))
		var rest := _rect(TRACK, maxf(0.01, 100.0 - e))
		bar.add_child(fill if side == 0 else rest)
		bar.add_child(rest if side == 0 else fill)
		row.add_child(bar)
	v.add_child(row)
	return v


## The round in six 30-second slices on one thin line, each in its winner's colour; the clock under it and the shout
## (or the set-up) over it.
static func timeline(exchanges: Array) -> VBoxContainer:
	var v := UI.vbox(6)
	v.add_child(UI.caps("EVERY 30 SECONDS"))
	var marks := UI.hbox(4)
	var line := UI.hbox(4)
	var times := UI.hbox(4)
	for x in exchanges:
		var won := bool(x["won"])
		var said := ""
		var said_c := DIM
		if bool(x.get("shout", false)):
			var worked := won and str(x.get("fit", "")) in ["best", "ok"]
			said = "YOUR SHOUT WORKED" if worked else "YOUR SHOUT"
			said_c = UI.GREEN if worked else UI.MUTED
		elif str(x.get("setup", "")) != "":
			said = "SET-UP"
			said_c = UI.GOLD
		elif not (x.get("read", {}) as Dictionary).is_empty():   # S333 THE READ
			said = "READ IT" if str(x["read"]["result"]) == "landed" else "WENT EARLY"
			said_c = UI.GOLD if said == "READ IT" else UI.RED
		var m := UI.label(said if said != "" else " ", 12, said_c, "caps")
		m.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		m.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		marks.add_child(m)
		var seg := _rect(HERS if won else THEIRS, 1.0)
		seg.custom_minimum_size = Vector2(0, 12)
		line.add_child(seg)
		var t := UI.mono("%d:%02d" % [((int(x["i"]) + 1) * 30) / 60, ((int(x["i"]) + 1) * 30) % 60], 13, DIM)
		t.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		t.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		times.add_child(t)
	v.add_child(marks)
	v.add_child(line)
	v.add_child(times)
	return v


## The coach's words as a quote: a gold rule down the left, the words large, who said it under them.
static func quote(text: String, who: String) -> HBoxContainer:
	var row := UI.hbox(16)
	var rule := ColorRect.new()
	rule.color = UI.GOLD
	rule.custom_minimum_size = Vector2(4, 0)
	row.add_child(rule)
	var v := UI.vbox(4)
	v.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	v.add_child(UI.label(text, 22, UI.FG, "italic", true))
	var w := UI.caps(who)
	w.add_theme_color_override("font_color", UI.GOLD)
	v.add_child(w)
	row.add_child(v)
	return row


## One judge as the announcer reads it: the total in very large type in the colour of the boxer it favours, the judge
## under it, a small chip per round in its winner's colour.
static func verdict_card(card: String, won_rounds: Array, judge: int) -> VBoxContainer:
	var parts := card.split("-")
	var hers := int(parts[0]) > int(parts[1])
	var v := UI.vbox(4)
	v.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var big := UI.display(card, 64, (HERS if hers else THEIRS).lightened(0.3) if int(parts[0]) != int(parts[1]) else UI.FG)
	big.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	v.add_child(big)
	var j := UI.caps("JUDGE %d" % judge)
	j.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	v.add_child(j)
	var chips := UI.hbox(4)
	chips.alignment = BoxContainer.ALIGNMENT_CENTER
	for w in won_rounds:
		var c := _rect(HERS if bool(w) else THEIRS, 1.0)
		c.custom_minimum_size = Vector2(34, 6)
		c.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
		chips.add_child(c)
	v.add_child(chips)
	return v


## "What decided it" as columns under one thin rule: a gold title over its line ("The film study: ..." -> FILM STUDY).
static func reasons(lines: Array) -> VBoxContainer:
	var v := UI.vbox(10)
	v.add_child(_rect(TRACK, 1.0, Vector2(0, 1)))
	v.add_child(UI.caps("WHAT DECIDED IT"))
	var row := UI.hbox(28)
	for line in lines:
		var s := str(line)
		var title := "WHY"
		var body := s
		if s.contains(": "):
			title = s.get_slice(": ", 0).trim_prefix("The ").to_upper()
			body = s.substr(s.find(": ") + 2)
			body = body.substr(0, 1).to_upper() + body.substr(1)
		elif s.begins_with("Your corner call"):
			title = "YOUR CORNER"
		var col := UI.vbox(4)
		col.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		var t := UI.caps(title)
		t.add_theme_color_override("font_color", UI.GOLD)
		col.add_child(t)
		col.add_child(UI.label(body, 18, UI.FG, "body", true))
		row.add_child(col)
	v.add_child(row)
	return v


## The night's take-home along the bottom: [[value, label, colour], ...] as large figures with a small label under each.
static func ribbon(items: Array) -> HBoxContainer:
	var row := UI.hbox(56)
	for it in items:
		var v := UI.vbox(0)
		v.add_child(UI.display(str(it[0]), 44, it[2]))
		v.add_child(UI.caps(str(it[1])))
		row.add_child(v)
	return row


static func _numbers_row(label: String, a: String, b: String, a_lead: bool, b_lead: bool) -> HBoxContainer:
	var row := UI.hbox(12)
	var na := UI.display(a, 46, Color.WHITE if a_lead else DIM)
	na.custom_minimum_size = Vector2(90, 0)
	row.add_child(na)
	var l := UI.caps(label.to_upper())
	l.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	l.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	l.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	l.size_flags_vertical = Control.SIZE_FILL
	row.add_child(l)
	var nb := UI.display(b, 46, Color.WHITE if b_lead else DIM)
	nb.custom_minimum_size = Vector2(90, 0)
	nb.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	row.add_child(nb)
	return row


static func _split(share: float, h: int) -> HBoxContainer:
	var bar := HBoxContainer.new()
	bar.add_theme_constant_override("separation", 3)
	bar.custom_minimum_size = Vector2(0, h)
	bar.add_child(_rect(HERS, maxf(0.02, share)))
	bar.add_child(_rect(THEIRS, maxf(0.02, 1.0 - share)))
	return bar


static func _rect(c: Color, ratio: float, min_size: Vector2 = Vector2.ZERO) -> ColorRect:
	var r := ColorRect.new()
	r.color = c
	r.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	r.size_flags_stretch_ratio = ratio
	r.custom_minimum_size = min_size
	r.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return r


## Each judge's rounds as won (true = hers), following BoutRules.scorecards: two judges score every round to its winner;
## the third gives the closest round of the majority the other way (as RoundGraphics.judges reads it).
static func judge_rounds(all: Array, cards: Array) -> Array:
	var won: Array = all.map(func(r): return bool(r["won"]))
	var her := won.count(true)
	var flip := -1
	if cards.size() >= 3 and str(cards[2]) != str(cards[0]):
		var best := INF
		for i in all.size():
			if bool(won[i]) == (her * 2 >= all.size()) and absf(float(all[i].get("mine", 0.0))) < best:
				best = absf(float(all[i].get("mine", 0.0)))
				flip = i
	var out := []
	for j in cards.size():
		var row := []
		for i in all.size():
			row.append(bool(won[i]) != (j == 2 and i == flip))
		out.append(row)
	return out
