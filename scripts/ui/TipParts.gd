extends RefCounted
## S532 GUIDETIPS1: the drawing half of the index cards (split out of Tips.gd, which was at 497 lines): where a card and a
## sticky note sit, the card itself, the note, the magnet and a keyword's underline. Tips.gd keeps the hover, lock and pin.
## The card follows ops/research/GUIDETIPS1_STANDARD.md section 2: title, then WHAT (what), NOW (now, or rows when there
## are two or more causes), MOVES IT (moves, quiet) and YOUR MOVE (do, bold); every sentence wraps at TEXT_W.
##   TipParts.build(spec, keys_out) -> [card, magnet]   spec = {title, what, now, rows: [[label, value, delta, tone]],
##       meter, means, moves, do, lines: [plain wrapped lines], keys: [term id], hint: [[key, words]]}
##   TipParts.note(term) -> the sticky note   place(size, anchor, screen)   place_note(size, card, screen, away_right)

const Palette := preload("res://scripts/ui/Palette.gd")
const UI := preload("res://scripts/ui/UI.gd")
const Glossary := preload("res://scripts/rules/Glossary.gd")
const TipMeter := preload("res://scripts/ui/TipMeter.gd")

const MARGIN := 16.0
const GAP := 10.0
const TEXT_W := 330.0
const NOTE_W := 290.0
## J90 section 4: text inks that pass 4.5:1 on the card (the house amber / green / red do not).
const CARD_BG := Palette.HOVER
const CARD_EDGE := Palette.LINE
const INK := Palette.TEXT
const RED := Palette.BAD
const GOOD := Palette.GOOD
const BAD := Palette.BAD
const WATCH := Palette.WARN
const MUTED := Palette.MUTED
const RULE := Palette.LINE
const NOTE_BG := Palette.TILE
const NOTE_EDGE := Palette.HEADER


## Beside the anchor (J90 6d): right or left (whichever has more room) top-aligned, then below, then above; inside the
## screen less MARGIN and never over the anchor.
static func place(size: Vector2, anchor: Rect2, screen: Rect2) -> Rect2:
	var room := screen.grow(-MARGIN)
	var right_free := room.end.x - anchor.end.x
	var left_free := anchor.position.x - room.position.x
	var sides := ["right", "left"] if right_free >= left_free else ["left", "right"]
	sides.append_array(["below", "above"])
	var r := Rect2()
	for side in sides:
		match side:
			"right": r = Rect2(Vector2(anchor.end.x + GAP, anchor.position.y), size)
			"left": r = Rect2(Vector2(anchor.position.x - GAP - size.x, anchor.position.y), size)
			"below": r = Rect2(Vector2(anchor.position.x, anchor.end.y + GAP), size)
			"above": r = Rect2(Vector2(anchor.position.x, anchor.position.y - GAP - size.y), size)
		# Slide along the side's free axis to fit.
		if side in ["right", "left"]:
			r.position.y = clampf(r.position.y, room.position.y, room.end.y - size.y)
		else:
			r.position.x = clampf(r.position.x, room.position.x, room.end.x - size.x)
		if room.encloses(r) and not r.intersects(anchor.grow(4.0)):
			return r
	r.position = r.position.clamp(room.position, room.end - size)
	return r


## The card and its magnet. `keys_out` gets [[Label, term id]] for each underlined game word.
static func build(s: Dictionary, keys_out: Array) -> Array:
	var root := Control.new()
	root.name = "TipCard"
	root.mouse_filter = Control.MOUSE_FILTER_STOP
	var panel := PanelContainer.new()
	var st := UI.box(CARD_BG, CARD_EDGE, 4, 1, 18, 14)
	st.content_margin_top = 22
	st.shadow_color = Palette.shadow()
	st.shadow_size = 6
	st.shadow_offset = Vector2(2, 4)
	panel.add_theme_stylebox_override("panel", st)
	panel.position = Vector2(0, 8)
	panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	root.add_child(panel)
	var v := VBoxContainer.new()
	v.add_theme_constant_override("separation", 6)
	v.mouse_filter = Control.MOUSE_FILTER_IGNORE
	panel.add_child(v)
	if str(s.get("title", "")) != "":
		var head := _text(str(s["title"]), "marker", 22, INK, true)
		head.name = "Title"
		v.add_child(head)
		var rule := ColorRect.new()
		rule.color = RED
		rule.custom_minimum_size = Vector2(0, 2)
		rule.mouse_filter = Control.MOUSE_FILTER_IGNORE
		v.add_child(rule)
	for k in ["what", "now"]:   # WHAT it is, then why it has this value (one cause; more causes are rows)
		if str(s.get(k, "")) != "":
			var l := _text(str(s[k]), "hand", 19, INK, true)
			l.name = k.capitalize()
			v.add_child(l)
	var rows: Array = s.get("rows", [])
	if not rows.is_empty():
		var g := GridContainer.new()
		g.columns = 3
		g.add_theme_constant_override("h_separation", 14)
		g.add_theme_constant_override("v_separation", 2)
		g.mouse_filter = Control.MOUSE_FILTER_IGNORE
		for row in rows:
			g.add_child(_text(str(row[0]), "hand", 19, INK))
			var val := _text(str(row[1]), "semi", 19, INK)
			val.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
			g.add_child(val)
			var tone := str(row[3]) if row.size() > 3 else ""
			g.add_child(_text(str(row[2]) if row.size() > 2 else "", "semi", 19,
				{"good": GOOD, "bad": BAD, "watch": WATCH}.get(tone, MUTED)))
		v.add_child(g)
	if s.get("meter") is Dictionary:   # S491: odds drawn, not written
		v.add_child(TipMeter.make(s["meter"]))
	if str(s.get("means", "")) != "":
		v.add_child(_text("Means: " + str(s["means"]), "hand", 19, INK, true))
	if str(s.get("moves", "")) != "":   # what makes it go up and down, quiet
		var mv := _text(str(s["moves"]), "hand", 19, MUTED, true)
		mv.name = "Moves"
		v.add_child(mv)
	if str(s.get("do", "")) != "":   # YOUR MOVE, in the title's ink and weight
		var d := _text(str(s["do"]), "handbold", 19, INK, true)
		d.name = "Do"
		v.add_child(d)
	for line in s.get("lines", []):   # a plain tooltip: the same card, its sentences wrapped
		v.add_child(_text(str(line), "hand", 19, INK, true))
	var keys: Array = (s.get("keys", []) as Array).filter(func(k): return not Glossary.term(str(k)).is_empty())
	if not keys.is_empty():
		var kh := HBoxContainer.new()
		kh.add_theme_constant_override("separation", 12)
		kh.mouse_filter = Control.MOUSE_FILTER_IGNORE
		kh.add_child(_text("Terms:", "hand", 19, MUTED))
		for k in keys:
			var kl := _text(str(Glossary.term(str(k))["name"]), "handbold", 19, INK)
			kl.name = "Key_" + str(k)
			var dash := Dash.new()
			kl.add_child(dash)
			kh.add_child(kl)
			keys_out.append([kl, str(k)])
		v.add_child(kh)
	var hint: Array = s.get("hint", [])
	if not hint.is_empty():
		var sep := ColorRect.new()
		sep.color = RULE
		sep.custom_minimum_size = Vector2(0, 1)
		sep.mouse_filter = Control.MOUSE_FILTER_IGNORE
		v.add_child(sep)
		var h := HBoxContainer.new()
		h.add_theme_constant_override("separation", 6)
		h.mouse_filter = Control.MOUSE_FILTER_IGNORE
		for k in hint:
			var chip := PanelContainer.new()
			chip.add_theme_stylebox_override("panel", UI.box(Palette.CLEAR, INK, 3, 1, 6, 1))
			chip.mouse_filter = Control.MOUSE_FILTER_IGNORE
			chip.add_child(_text(str(k[0]).to_upper(), "semi", 15, INK))
			h.add_child(chip)
			h.add_child(_text(str(k[1]) + "   ", "body", 18, MUTED))
		v.add_child(h)
	var size := panel.get_combined_minimum_size()
	var ring := Magnet.new()
	ring.position = Vector2(size.x * 0.5 - 8.0, 0.0)
	root.add_child(ring)
	root.custom_minimum_size = size + Vector2(0, 8)
	return [root, ring]


## A label on the card. Wrapped text gets a fixed width (an autowrapped Label's minimum width is ~0 - J90 trap 2).
static func _text(t: String, kind: String, size: int, colour: Color, wrap := false) -> Label:
	var l := Label.new()
	l.text = t
	l.add_theme_font_override("font", UI.font(kind))
	var px := TipMeter.TextScale.scaled(size, TipMeter.TextScale.factor())   # S491: at the final size, so the card is measured right
	l.add_theme_font_size_override("font_size", px)
	l.set_meta(TipMeter.TextScale.META, px)
	l.add_theme_color_override("font_color", colour)
	l.mouse_filter = Control.MOUSE_FILTER_IGNORE
	if wrap:
		l.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		l.custom_minimum_size = Vector2(TEXT_W * TipMeter.TextScale.factor(), 0)
	return l


## The magnet on the card's top edge: its ring fills while the lock timer runs; solid red once locked; a glint when pinned.
class Magnet extends Control:
	var fill := 0.0
	var locked := false
	var pinned := false

	func _init() -> void:
		custom_minimum_size = Vector2(16, 16)
		size = Vector2(16, 16)
		mouse_filter = Control.MOUSE_FILTER_IGNORE

	func _draw() -> void:
		var c := Vector2(8, 8)
		if locked:
			draw_circle(c, 8.0, RED)
			if pinned:
				draw_circle(c + Vector2(-2.5, -2.5), 2.0, Palette.TEXT)
			return
		draw_circle(c, 8.0, CARD_BG)
		draw_arc(c, 7.0, 0.0, TAU, 32, INK, 2.0, true)
		if fill > 0.0:
			draw_arc(c, 4.0, -PI * 0.5, -PI * 0.5 + TAU * fill, 32, RED, 4.0, true)


## A game word's sticky note: the word, a short definition, Why. Plain text: a note has no words of its own to hover.
static func note(t: Dictionary) -> PanelContainer:
	var panel := PanelContainer.new()
	panel.name = "TipNote"
	var st := UI.box(NOTE_BG, NOTE_EDGE, 2, 1, 16, 12)
	st.shadow_color = Palette.shadow()
	st.shadow_size = 5
	st.shadow_offset = Vector2(2, 4)
	panel.add_theme_stylebox_override("panel", st)
	panel.mouse_filter = Control.MOUSE_FILTER_STOP
	var v := VBoxContainer.new()
	v.add_theme_constant_override("separation", 4)
	v.mouse_filter = Control.MOUSE_FILTER_IGNORE
	panel.add_child(v)
	v.add_child(_text(str(t["name"]), "marker", 20, INK))
	var d := _text(str(t["def"]), "hand", 19, INK, true)
	d.custom_minimum_size.x = NOTE_W
	v.add_child(d)
	var w := _text("Why: " + str(t["why"]), "hand", 19, INK, true)
	w.custom_minimum_size.x = NOTE_W
	v.add_child(w)
	return panel


## Beside the card (J90 6d T3): the side away from the control first, then the other side, below, above; never over it.
static func place_note(size: Vector2, card: Rect2, screen: Rect2, away_right: bool) -> Rect2:
	var room := screen.grow(-MARGIN)
	var r := Rect2()
	for side in (["right", "left"] if away_right else ["left", "right"]) + ["below", "above"]:
		match side:
			"right": r = Rect2(Vector2(card.end.x + GAP, card.position.y), size)
			"left": r = Rect2(Vector2(card.position.x - GAP - size.x, card.position.y), size)
			"below": r = Rect2(Vector2(card.position.x, card.end.y + GAP), size)
			"above": r = Rect2(Vector2(card.position.x, card.position.y - GAP - size.y), size)
		if side in ["right", "left"]:
			r.position.y = clampf(r.position.y, room.position.y, room.end.y - size.y)
		else:
			r.position.x = clampf(r.position.x, room.position.x, room.end.x - size.x)
		if room.encloses(r) and not r.intersects(card):
			return r
	r.position = r.position.clamp(room.position, room.end - size)
	return r


## A keyword's dashed red underline, 3 px under the text (J90 6c).
class Dash extends Control:
	func _init() -> void:
		mouse_filter = Control.MOUSE_FILTER_IGNORE
		anchor_top = 1.0
		anchor_bottom = 1.0
		anchor_right = 1.0
		offset_top = -1.0
		offset_bottom = 2.0

	func _draw() -> void:
		draw_dashed_line(Vector2(0, 1), Vector2(size.x, 1), RED, 2.0, 5.0)
