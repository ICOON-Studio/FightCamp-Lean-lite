extends RefCounted
## S532 GUIDETIPS1: the drawing half of the index cards (split out of Tips.gd, which was at 497 lines): where a card and a
## sticky note sit, the card itself, the note, the magnet and a keyword's underline. Tips.gd keeps the hover, lock and pin.
## The card follows ops/research/GUIDETIPS1_STANDARD.md section 2: title, then WHAT (what), NOW (now, or rows when there
## are two or more causes), MOVES IT (moves, quiet) and YOUR MOVE (do, bold); every sentence wraps at TEXT_W.
##   TipParts.build(spec, keys_out) -> [card, magnet]   spec = {title, what, now, rows: [[label, value, delta, tone]],
##       meter, means, moves, do, lines: [plain wrapped lines], keys: [term id], hint: [[key, words]]}
##   TipParts.note(term) -> the sticky note   place(size, anchor, screen)   place_note(size, card, screen, away_right)
## S533 owner "fix the tooltip design to reach 10" (Claude rated it 6/10): the body reads in Barlow (the hand font only for the
## title), rows are a receipt (label left, value right-aligned in one column, unit after), YOUR MOVE sits on its own band with a
## red edge, a spec "band" draws a 0-100 value as a bar with its limits instead of rows, the magnet sits in the top-right
## corner, and the "What is" link is a chip.

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
const HEAD := Palette.HEADER   # S533: the title in the house title colour
const DO_BG := Palette.CARD    # YOUR MOVE's band
const RED_EDGE := Palette.ACTION


## S533: a 0-100 value drawn as a bar - the zones coloured, the limits marked, a tick at the value. spec {value, max = 100,
## zones: [[from, to, tone, word]]}; tone good / watch / bad.
class Band extends Control:
	var value := 0.0
	var top := 100.0
	var zones: Array = []

	static func make(spec: Dictionary) -> Band:
		var b := Band.new()
		b.value = float(spec.get("value", 0.0))
		b.top = float(spec.get("max", 100.0))
		b.zones = spec.get("zones", [])
		b.name = "Band"
		var fx := TipMeter.TextScale.factor()
		b.custom_minimum_size = Vector2(TEXT_W * fx, 52.0 * fx)
		b.mouse_filter = Control.MOUSE_FILTER_IGNORE
		return b

	func _draw() -> void:
		var fx := TipMeter.TextScale.factor()
		var bar_y := 8.0 * fx
		var bar_h := 12.0 * fx
		var font := UI.font("body")
		var fs := int(14 * fx)
		for z in zones:
			var x0 := size.x * float(z[0]) / top
			var x1 := size.x * float(z[1]) / top
			var col: Color = {"good": Palette.GOOD, "watch": Palette.WARN, "bad": Palette.BAD}.get(str(z[2]), Palette.MUTED)
			draw_rect(Rect2(x0, bar_y, x1 - x0, bar_h), Color(col, 0.55))
			draw_string(font, Vector2(x0 + 2.0, bar_y + bar_h + 17.0 * fx), str(z[3]), HORIZONTAL_ALIGNMENT_LEFT, x1 - x0 - 2.0, fs, Palette.TEXT)
			if float(z[0]) > 0.0:
				draw_line(Vector2(x0, bar_y), Vector2(x0, bar_y + bar_h + 4.0 * fx), Palette.TEXT, 1.0)
				draw_string(font, Vector2(x0 - 7.0 * fx, bar_y - 1.0), str(int(z[0])), HORIZONTAL_ALIGNMENT_LEFT, -1, int(12 * fx), Palette.MUTED)
		var vx := clampf(size.x * value / top, 2.0, size.x - 2.0)
		draw_rect(Rect2(vx - 2.0, bar_y - 4.0 * fx, 4.0, bar_h + 8.0 * fx), Palette.TEXT)


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
	v.add_theme_constant_override("separation", 7)
	v.mouse_filter = Control.MOUSE_FILTER_IGNORE
	panel.add_child(v)
	if str(s.get("title", "")) != "":
		var head := _text(str(s["title"]), "marker", 22, HEAD, true)
		head.name = "Title"
		v.add_child(head)
		var rule := ColorRect.new()
		rule.color = RED
		rule.custom_minimum_size = Vector2(0, 2)
		rule.mouse_filter = Control.MOUSE_FILTER_IGNORE
		v.add_child(rule)
	for k in ["what", "now"]:   # WHAT it is, then why it has this value (one cause; more causes are rows)
		if str(s.get(k, "")) != "":
			var l := _text(str(s[k]), "body", 18, INK, true)
			l.name = k.capitalize()
			v.add_child(l)
	var rows: Array = s.get("rows", [])
	if s.get("band") is Dictionary:   # S533: a 0-100 value drawn with its limits; the rows stay in the spec for the checks
		v.add_child(Band.make(s["band"]))
		rows = []
	if not rows.is_empty():
		var g := GridContainer.new()
		g.columns = 3
		g.add_theme_constant_override("h_separation", 12)
		g.add_theme_constant_override("v_separation", 3)
		g.mouse_filter = Control.MOUSE_FILTER_IGNORE
		var fx := TipMeter.TextScale.factor()
		for row in rows:   # a receipt: the label takes the room, the value is right-aligned in one column
			var tone := str(row[3]) if row.size() > 3 else ""
			var ink: Color = {"good": GOOD, "bad": BAD, "watch": WATCH}.get(tone, INK)
			var lab := _text(str(row[0]), "body", 18, MUTED)
			lab.custom_minimum_size = Vector2((TEXT_W - 170.0) * fx, 0)
			g.add_child(lab)
			var val := _text(str(row[1]), "semi", 18, ink)
			val.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
			val.custom_minimum_size = Vector2(95.0 * fx, 0)
			g.add_child(val)
			var unit_word := str(row[2]) if row.size() > 2 else ""
			var unit := _text(unit_word, "body", 16, ink if unit_word == "now" else MUTED)
			unit.custom_minimum_size = Vector2(60.0 * fx, 0)
			g.add_child(unit)
		v.add_child(g)
	if s.get("meter") is Dictionary:   # S491: odds drawn, not written
		v.add_child(TipMeter.make(s["meter"]))
	if str(s.get("means", "")) != "":
		v.add_child(_text("Means: " + str(s["means"]), "body", 18, INK, true))
	if str(s.get("moves", "")) != "":   # what makes it go up and down, quiet
		var mv := _text(str(s["moves"]), "body", 17, MUTED, true)
		mv.name = "Moves"
		v.add_child(mv)
	if str(s.get("do", "")) != "":   # YOUR MOVE, in the title's ink and weight
		var d := _text(str(s["do"]), "semi", 18, INK, true)
		d.name = "Do"
		d.custom_minimum_size.x -= 18.0
		var band := PanelContainer.new()   # S533: the action stands apart - its own band with a red edge
		var bst := UI.box(DO_BG, Palette.CLEAR, 3, 0, 10, 6)
		bst.border_width_left = 4
		bst.border_color = RED_EDGE
		band.add_theme_stylebox_override("panel", bst)
		band.mouse_filter = Control.MOUSE_FILTER_IGNORE
		band.add_child(d)
		v.add_child(band)
	for line in s.get("lines", []):   # a plain tooltip: the same card, its sentences wrapped
		v.add_child(_text(str(line), "body", 18, INK, true))
	var keys: Array = (s.get("keys", []) as Array).filter(func(k): return not Glossary.term(str(k)).is_empty())
	if not keys.is_empty():
		var kh := HBoxContainer.new()
		kh.add_theme_constant_override("separation", 12)
		kh.mouse_filter = Control.MOUSE_FILTER_IGNORE
		for k in keys:   # S533: a chip that says what it does (owner mark "whats is this for?"); rest on it for the note
			var chip := PanelContainer.new()
			chip.add_theme_stylebox_override("panel", UI.box(Palette.CLEAR, MUTED, 10, 1, 8, 1))
			chip.mouse_filter = Control.MOUSE_FILTER_IGNORE
			var kl := _text("What is %s?" % str(Glossary.term(str(k))["name"]), "body", 15, MUTED)
			kl.name = "Key_" + str(k)
			chip.add_child(kl)
			kh.add_child(chip)
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
	ring.position = Vector2(size.x - 26.0, 0.0)   # S533: the corner, not the middle of the title
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
