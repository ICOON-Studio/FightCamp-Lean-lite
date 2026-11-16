extends RefCounted
## The look: B GYM WHITEBOARD (operator S332 Q-S294-52 "B Gym whiteboard") - a light blue gym wall, white boards with a
## grey frame, marker blue/red/green ink, yellow sticky notes - as one Theme, plus small builders every screen uses.
## Mockup: E:/FightCamp/Game/Godot/research/S331_looks/b_whiteboard.png. The fight's graphics keep the dark look (TV.gd).
## Fonts: Permanent Marker for headings ("marker"), Kalam for handwritten notes ("hand"), Barlow for body, IBM Plex Mono
## for numbers (assets/fonts/SOURCE.md). The names below keep their old jobs: GOLD = the primary accent (now marker blue).

const Bar := preload("res://scripts/ui/Bar.gd")
const Plate := preload("res://scripts/ui/Plate.gd")
const WoodKit := preload("res://scripts/ui/WoodKit.gd")   # S417 the approved wood and slate look
const Palette := preload("res://scripts/ui/Palette.gd")   # S493 the one palette (Q-251)
const HouseKit := preload("res://scripts/ui/HouseKit.gd")   # S496 ONELOOK1 the one kit
const GameMoney := preload("res://scripts/rules/GameMoney.gd")
const Sfx := preload("res://scripts/audio/Sfx.gd")

## S496 ONELOOK1 (operator: "Everymenu i loook is designed differently ... the colour pallette should be in effect"): the old
## paper names keep their jobs but every one is a Palette token now - a cream card is the slate, a tan plate dark wood. The
## page-wide ink pass (WoodKit.ink) turns paper ink to chalk on them. The theme itself is HouseKit.gd.
const BG := Palette.PAGE           # the wall behind a page
const PANEL := Palette.CARD        # a card
const TOP_BAR := Palette.PAGE
const TOP_INK := Palette.TEXT
const TOP_SOFT := Palette.MUTED
const PANEL2 := Palette.TILE       # a row or raised tile inside a card
const LINE := Palette.LINE         # card borders, rules
const ROWLINE := Palette.LINE      # the lines between rows
const RAIL := Palette.PAGE
const FRAME := Palette.WOOD        # a frame
const FG := WoodKit.DARK_INK       # paper ink: chalked on every dark surface by WoodKit.ink
const MUTED := WoodKit.PAPER_MUTED
const GOLD := WoodKit.PAPER_BLUE   # the primary accent (your side), chalked to Palette.ACCENT on slate
const GOLD_LIP := Palette.PAGE
const PLATE := Palette.SECOND      # a quiet button: dark wood
const PLATE_LIP := Palette.WOOD
const DARK := Palette.HOVER        # a dark plate: tabs, the main secondary button
const DARK_LIP := Palette.PAGE
const GOLD_INK := Palette.TEXT
const RED := Palette.BAD_FILL
const GREEN := Palette.GOOD_FILL
const AMBER := Palette.WARN
const YELLOW := Palette.HEADER     # a note's mark (was the yellow sticky)
const YELLOW_EDGE := Palette.WARN
const MINT := Palette.GOOD
const SKY := Palette.ACCENT
const PURPLE := Palette.ELITE

const BODY := HouseKit.BODY
const SMALL := HouseKit.SMALL
const TINY := HouseKit.TINY
const MIN_TEXT := HouseKit.MIN_TEXT


static func font(kind: String) -> Font:
	return HouseKit.font(kind)


static func box(bg: Color, border: Color = Palette.CLEAR, radius: int = 8, border_w: int = 1,
		pad_h: int = 12, pad_v: int = 8) -> StyleBoxFlat:
	return HouseKit.box(bg, border, radius, border_w, pad_h, pad_v)


## The one house theme (HouseKit.gd): every card, button, tab, chip, field and hover on every page.
static func theme() -> Theme:
	return HouseKit.theme()


## ---------- builders ----------

static func label(text: String, size: int = BODY, color: Color = FG, kind: String = "body", wrap: bool = false) -> Label:
	var l := Label.new()
	l.text = text
	l.add_theme_font_size_override("font_size", maxi(size, MIN_TEXT))
	l.add_theme_color_override("font_color", color)
	# S398 menus round 6 ("brush font for page titles only"): the brush (Permanent Marker) draws titles of 28 px and up;
	# a smaller "marker" word is the plain bold face.
	l.add_theme_font_override("font", font("bold" if kind == "marker" and size < 28 else kind))
	if wrap:
		l.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		l.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	l.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return l


static func muted(text: String, size: int = SMALL, wrap: bool = false) -> Label:
	return label(text, size, MUTED, "body", wrap)


static func display(text: String, size: int = 52, color: Color = FG) -> Label:
	return label(text, size, color, "display")


static func mono(text: String, size: int = BODY, color: Color = FG) -> Label:
	return label(text, size, color, "mono")


static func caps(text: String) -> Label:
	return label(text, TINY + 1, MUTED, "caps")


static func button(text: String, variation: String, on_press: Callable, disabled: bool = false, why: String = "") -> Button:
	var b := Button.new()
	b.text = text
	b.theme_type_variation = variation
	b.disabled = disabled
	if disabled and why != "":
		b.tooltip_text = why
	elif not disabled:
		b.tooltip_text = ""
	b.focus_mode = Control.FOCUS_NONE
	b.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	b.button_down.connect(Plate.squash.bind(b, 0.95))   # S412 "nothing reacting when pressed"
	b.button_up.connect(Plate.squash.bind(b, 1.0))
	b.pressed.connect(func(): Sfx.play("ui_click"))
	b.pressed.connect(on_press)
	return b


## A button with a big line and a small line under it (title buttons, rail, CONTINUE).
static func button2(big: String, small: String, variation: String, on_press: Callable, min_size: Vector2,
		big_color: Color, small_color: Color, disabled: bool = false, big_size: int = BODY, small_size: int = TINY,
		why: String = "") -> Button:
	var b := button("", variation, on_press, disabled, why)
	b.custom_minimum_size = min_size
	var m := MarginContainer.new()
	m.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	var pad_h := 16
	m.add_theme_constant_override("margin_left", pad_h)
	m.add_theme_constant_override("margin_right", pad_h)
	m.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var v := VBoxContainer.new()
	v.alignment = BoxContainer.ALIGNMENT_CENTER
	v.add_theme_constant_override("separation", 0)
	v.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var bl := label(big, big_size, big_color, "bold")
	v.add_child(bl)
	var small_line := why if disabled and why != "" else small
	var small_col := GOLD if disabled and why != "" else small_color
	if small_line != "":
		v.add_child(label(small_line, small_size, small_col, "body"))
	m.add_child(v)
	b.add_child(m)
	# S429 "text is unreadable and out of limits": a two-line button grows to hold its words, never words over its edge.
	b.ready.connect(func(): b.custom_minimum_size.y = maxf(b.custom_minimum_size.y, v.get_combined_minimum_size().y + 12.0))
	if disabled:
		b.modulate = Color(Palette.FULL, 0.45)
	return b


static func card(title: String = "") -> Array:
	var p := PanelContainer.new()
	p.theme_type_variation = "Card"
	p.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var v := VBoxContainer.new()
	v.add_theme_constant_override("separation", 8)
	p.add_child(v)
	if title != "":
		v.add_child(label(title, 18, WoodKit.HEAD, "caps"))
	return [p, v]


static func hbox(sep: int = 12) -> HBoxContainer:
	var h := HBoxContainer.new()
	h.add_theme_constant_override("separation", sep)
	return h


static func vbox(sep: int = 14) -> VBoxContainer:
	var v := VBoxContainer.new()
	v.add_theme_constant_override("separation", sep)
	return v


static func spacer() -> Control:
	var c := Control.new()
	c.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	c.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return c


static func sep() -> HSeparator:
	return HSeparator.new()


static func dot(color: Color) -> Control:
	var c := ColorRect.new()
	c.color = color
	c.custom_minimum_size = Vector2(12, 12)
	c.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	c.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return c


## A list row: [dot] title / sub line ... [right controls].
static func row(title: String, sub: String = "", dot_color: Color = Color(Palette.PAGE, 0), right: Array = []) -> HBoxContainer:
	var h := hbox(14)
	if dot_color.a > 0.0:
		h.add_child(dot(dot_color))
	var t := VBoxContainer.new()
	t.add_theme_constant_override("separation", 1)
	t.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	t.add_child(label(title, BODY, FG, "body", true))
	if sub != "":
		t.add_child(muted(sub, SMALL, true))
	h.add_child(t)
	for r in right:
		(r as Control).size_flags_vertical = Control.SIZE_SHRINK_CENTER
		h.add_child(r)
	return h


## Adds controls to a card body with a thin line between each.
static func add_rows(parent: Container, items: Array) -> void:
	for i in items.size():
		if i > 0:
			parent.add_child(sep())
		parent.add_child(items[i])


static func kv(key: String, value: String, value_color: Color = FG, value_kind: String = "bold") -> HBoxContainer:
	var h := hbox(10)
	var k := label(key, BODY, FG, "body", true)
	h.add_child(k)
	var v := label(value, BODY, value_color, value_kind)   # S412 the value beside its name, not at the far edge of the card
	v.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	h.add_child(v)
	return h


static func chip(text: String, colour_key: String) -> PanelContainer:
	var colours := {"green": GREEN, "red": RED, "amber": AMBER, "gold": GOLD, "": MUTED}
	var names := {"green": "ChipGreen", "red": "ChipRed", "amber": "ChipAmber", "gold": "ChipGold", "": "Chip"}
	var p := PanelContainer.new()
	p.theme_type_variation = names.get(colour_key, "Chip")
	p.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN   # S412 a tag is as wide as its word
	p.add_child(label(text, TINY, colours.get(colour_key, MUTED), "bold"))
	p.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	p.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return p


static func note(text: String) -> PanelContainer:
	var p := PanelContainer.new()
	p.theme_type_variation = "Note"
	var l := muted(text, SMALL, true)
	l.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	p.add_child(l)
	return p


## Label | bar to the next whole point | whole number. Returns the row; the bar is row.get_meta("bar").
## S375 (operator: "these long line meters do not look good at all in your menus"): the menus' meter - a short row of
## METER_SEGMENTS pips at a fixed METER_W, never stretched across a card; `marks` = threshold fractions (ticks under it).
const METER_W := 200.0
const METER_H := 10.0
const METER_SEGMENTS := 10


static func meter(frac: float, colour: Color = GREEN, marks: Array = [], w: float = METER_W) -> Control:
	var bar: Control = Bar.new()
	bar.segments = METER_SEGMENTS
	bar.marks = marks
	bar.custom_minimum_size = Vector2(w, METER_H + (2.0 if not marks.is_empty() else 0.0))
	bar.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
	bar.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	bar.fill = colour
	bar.frac = frac
	return bar


static func stat_row(name: String, value: float, gold: bool = false, number_color: Color = FG, suffix: String = "") -> HBoxContainer:
	var h := hbox(12)
	var l := label(name, BODY)
	l.custom_minimum_size = Vector2(150, 0)
	h.add_child(l)
	var bar := meter(value - floorf(value), GOLD if gold else GREEN)
	h.add_child(bar)
	var n := hbox(4)
	n.custom_minimum_size = Vector2(96, 0)
	n.alignment = BoxContainer.ALIGNMENT_END
	n.add_child(mono(str(int(floorf(value))), BODY, number_color))
	if suffix != "":
		var s := mono(suffix, TINY, GREEN)
		s.size_flags_vertical = Control.SIZE_SHRINK_END
		n.add_child(s)
	h.add_child(n)
	h.set_meta("bar", bar)
	return h


static func clear(node: Node) -> void:
	for child in node.get_children():
		node.remove_child(child)
		child.queue_free()


static func money(n: int) -> String:
	return GameMoney.text(n)


## A stat gain as the small green suffix: "+0.8", "+0.06"; nothing for no gain.
static func gain_text(g: float) -> String:
	if g < 0.005:
		return ""
	return " +%.1f" % g if g >= 0.1 else " +%.2f" % g


static func signed(n: int) -> String:
	return ("+" if n >= 0 else "-") + money(absi(n))
