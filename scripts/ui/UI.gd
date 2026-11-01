extends RefCounted
## The look: B GYM WHITEBOARD (operator S332 Q-S294-52 "B Gym whiteboard") - a light blue gym wall, white boards with a
## grey frame, marker blue/red/green ink, yellow sticky notes - as one Theme, plus small builders every screen uses.
## Mockup: E:/FightCamp/Game/Godot/research/S331_looks/b_whiteboard.png. The fight's graphics keep the dark look (TV.gd).
## Fonts: Permanent Marker for headings ("marker"), Kalam for handwritten notes ("hand"), Barlow for body, IBM Plex Mono
## for numbers (assets/fonts/SOURCE.md). The names below keep their old jobs: GOLD = the primary accent (now marker blue).

const Bar := preload("res://scripts/ui/Bar.gd")
const GameMoney := preload("res://scripts/rules/GameMoney.gd")

const BG := Color("#cfe0ea")       # the gym wall
const PANEL := Color("#fdfefe")    # a board / card
const PANEL2 := Color("#e9eef2")   # a pressed or raised card
const LINE := Color("#c9d1d8")     # card borders, rules
const ROWLINE := Color("#d3dce3")  # the dotted lines between rows
const RAIL := Color("#cfe0ea")
const FRAME := Color("#aeb8c0")    # the board's aluminium frame
const FG := Color("#22262e")       # marker ink
const MUTED := Color("#5e6773")
const GOLD := Color("#2f6fdb")     # marker blue (primary)
const GOLD_INK := Color("#ffffff")
const RED := Color("#e2483d")
const GREEN := Color("#23935d")
const AMBER := Color("#d97a00")
const YELLOW := Color("#ffd54a")   # sticky notes
const YELLOW_EDGE := Color("#d9b235")
const MINT := Color("#9fe0c0")
const SKY := Color("#bfd8ff")
const PURPLE := Color("#8a5cf0")

const BODY := 19
const SMALL := 16
const TINY := 14

static var _fonts: Dictionary = {}
static var _theme: Theme


static func font(kind: String) -> Font:
	if _fonts.is_empty():
		var regular: FontFile = load("res://assets/fonts/Barlow-Regular.ttf")
		var semi: FontFile = load("res://assets/fonts/Barlow-SemiBold.ttf")
		var bold: FontFile = load("res://assets/fonts/Barlow-Bold.ttf")
		var bebas: FontFile = load("res://assets/fonts/BebasNeue-Regular.ttf")
		var mono: FontFile = load("res://assets/fonts/IBMPlexMono-Medium.ttf")
		_fonts["marker"] = _load_or("res://assets/fonts/PermanentMarker-Regular.ttf", bebas)
		_fonts["hand"] = _load_or("res://assets/fonts/Kalam-Regular.ttf", regular)
		_fonts["handbold"] = _load_or("res://assets/fonts/Kalam-Bold.ttf", bold)
		_fonts["body"] = regular
		_fonts["semi"] = semi
		_fonts["bold"] = bold
		_fonts["caps"] = _spaced(bold, 2)
		_fonts["italic"] = _italic(regular)
		_fonts["display"] = _fonts["marker"]
		_fonts["mono"] = mono
	return _fonts.get(kind, _fonts["body"])


static func _load_or(path: String, fallback: Font) -> Font:
	return load(path) if ResourceLoader.exists(path) else fallback


static func _spaced(base: FontFile, spacing: int) -> FontVariation:
	var v := FontVariation.new()
	v.base_font = base
	v.spacing_glyph = spacing
	return v


static func _italic(base: FontFile) -> FontVariation:
	var v := FontVariation.new()
	v.base_font = base
	v.variation_transform = Transform2D(Vector2(1, 0), Vector2(0.2, 1), Vector2.ZERO)
	return v


static func box(bg: Color, border: Color = Color(0, 0, 0, 0), radius: int = 8, border_w: int = 1,
		pad_h: int = 12, pad_v: int = 8) -> StyleBoxFlat:
	var s := StyleBoxFlat.new()
	s.bg_color = bg
	s.border_color = border
	s.set_border_width_all(border_w if border.a > 0.0 else 0)
	s.set_corner_radius_all(radius)
	s.content_margin_left = pad_h
	s.content_margin_right = pad_h
	s.content_margin_top = pad_v
	s.content_margin_bottom = pad_v
	s.anti_aliasing = true
	return s


static func theme() -> Theme:
	if _theme != null:
		return _theme
	var t := Theme.new()
	t.default_font = font("body")
	t.default_font_size = BODY
	t.set_color("font_color", "Label", FG)
	var clear := Color(0, 0, 0, 0)
	_button(t, "Button", PANEL, LINE, FG, GOLD, 8, 12, 8, "semi", SMALL)
	_button(t, "TBtn", PANEL, LINE, FG, GOLD, 10, 18, 14, "semi", 21)
	_button(t, "TBtnPrimary", GOLD, GOLD, GOLD_INK, GOLD, 10, 18, 14, "semi", 21)
	_button(t, "Ghost", clear, LINE, MUTED, MUTED, 8, 12, 8, "semi", SMALL)
	_button(t, "Btn", clear, GOLD, GOLD, GOLD, 8, 14, 8, "bold", SMALL, Color(GOLD, 0.12))
	_button(t, "BtnSolid", GOLD, GOLD, GOLD_INK, GOLD, 8, 14, 8, "bold", SMALL)
	_button(t, "BtnQuiet", clear, LINE, MUTED, MUTED, 8, 14, 8, "bold", SMALL)
	_button(t, "Rail", clear, clear, MUTED, clear, 8, 14, 10, "bold", 17)
	_button(t, "RailOn", PANEL2, clear, GOLD, clear, 8, 14, 10, "bold", 17)
	_button(t, "Tab", clear, clear, MUTED, clear, 8, 16, 10, "bold", 17)
	_button(t, "TabOn", PANEL, clear, GOLD, clear, 8, 16, 10, "bold", 17)
	_button(t, "Choice", PANEL, LINE, FG, MUTED, 10, 14, 12, "semi", BODY)
	_button(t, "ChoiceOn", PANEL2, GOLD, FG, GOLD, 10, 14, 12, "semi", BODY)
	# S342 small pill choices (the WHEN row): one line of chips instead of a wall of big buttons.
	_button(t, "Pill", PANEL, LINE, MUTED, MUTED, 12, 9, 3, "semi", TINY)
	_button(t, "PillOn", GOLD, GOLD, GOLD_INK, GOLD, 12, 9, 3, "semi", TINY)
	_button(t, "Flag", YELLOW, YELLOW, FG, YELLOW_EDGE, 999, 14, 6, "bold", SMALL)
	_button(t, "FlagRed", RED, RED, Color.WHITE, Color("#b8332a"), 999, 14, 6, "bold", SMALL)
	_button(t, "Go", GOLD, GOLD, GOLD_INK, GOLD, 10, 16, 8, "bold", BODY)
	_button(t, "GoBlock", RED, RED, Color.WHITE, RED, 10, 16, 8, "bold", BODY)
	_button(t, "GoFight", FG, FG, BG, FG, 10, 16, 8, "bold", BODY)
	_button(t, "Speed", clear, LINE, MUTED, MUTED, 6, 4, 6, "mono", TINY)
	_button(t, "SpeedOn", LINE, LINE, FG, MUTED, 6, 4, 6, "mono", TINY)
	_button(t, "Link", clear, clear, GOLD, clear, 0, 0, 0, "bold", BODY)
	for tab_name in ["Tab", "TabOn"]:
		for state in ["normal", "hover", "pressed", "disabled", "focus"]:
			var sb := t.get_stylebox(state, tab_name) as StyleBoxFlat
			if sb != null:
				sb.corner_radius_bottom_left = 0
				sb.corner_radius_bottom_right = 0
	# S333 look B: the rail is white tabs with a frame-grey left edge (red when on); the board, polaroid and sticky notes.
	for rail in [["Rail", FRAME], ["RailOn", RED]]:
		for state in ["normal", "hover", "pressed", "disabled"]:
			var rb := box(PANEL, rail[1], 10, 0, 16, 10)
			rb.border_width_left = 8
			if state == "hover":
				rb.bg_color = PANEL2
			t.set_stylebox(state, rail[0], rb)
		t.set_color("font_color", rail[0], FG)
		t.set_color("font_hover_color", rail[0], FG)
	_button(t, "Ink", FG, FG, Color.WHITE, FG, 999, 16, 7, "bold", SMALL)
	for go in ["Go", "GoBlock"]:
		for state in ["normal", "hover", "pressed", "disabled"]:
			(t.get_stylebox(state, go) as StyleBoxFlat).set_corner_radius_all(30)
	var board := box(PANEL, FRAME, 4, 14, 34, 26)
	board.shadow_color = Color(0, 0, 0, 0.12)
	board.shadow_size = 6
	_panel(t, "Board", board)
	var pol := box(Color.WHITE, Color("#e3e7ea"), 2, 1, 14, 14)
	pol.content_margin_bottom = 8
	pol.shadow_color = Color(0, 0, 0, 0.22)
	pol.shadow_size = 8
	pol.shadow_offset = Vector2(2, 4)
	_panel(t, "Polaroid", pol)
	for sticky in [["Sticky", YELLOW, YELLOW_EDGE], ["StickyRed", Color("#ffc7bf"), Color("#e2958a")],
			["StickyGreen", MINT, Color("#6fbf97")], ["StickyBlue", SKY, Color("#8fb0e0")]]:
		var sb := box(sticky[1], sticky[2], 2, 0, 22, 16)
		sb.border_width_bottom = 6
		_panel(t, sticky[0], sb)
	var tin := box(PANEL, LINE, 16, 1, 26, 22)
	tin.shadow_color = Color(0, 0, 0, 0.10)
	tin.shadow_size = 5
	_panel(t, "Tin", tin)
	_panel(t, "Card", box(PANEL, LINE, 12, 1, 18, 16))
	_panel(t, "TopBar", _edge(PANEL, 0, 0, 0, 1, 18, 12))
	_panel(t, "RailPanel", _edge(RAIL, 0, 0, 1, 0, 10, 14))
	_panel(t, "Modal", box(PANEL, GOLD, 14, 1, 26, 22))
	_panel(t, "Toast", box(PANEL2, GOLD, 10, 1, 18, 12))
	_panel(t, "Note", box(clear, LINE, 10, 1, 14, 12))
	_panel(t, "Badge", box(RED, clear, 9, 0, 6, 0))
	for chip in [["Chip", MUTED], ["ChipGreen", GREEN], ["ChipRed", RED], ["ChipAmber", AMBER], ["ChipGold", GOLD]]:
		_panel(t, chip[0], box(clear, chip[1], 999, 1, 10, 3))
	var sep := StyleBoxLine.new()
	sep.color = ROWLINE
	sep.thickness = 1
	t.set_stylebox("separator", "HSeparator", sep)
	t.set_constant("separation", "HSeparator", 1)
	t.set_stylebox("panel", "PopupMenu", box(PANEL2, LINE, 10, 1, 6, 6))
	t.set_stylebox("hover", "PopupMenu", box(LINE, clear, 6, 0, 10, 8))
	t.set_color("font_color", "PopupMenu", FG)
	t.set_color("font_hover_color", "PopupMenu", FG)
	t.set_font("font", "PopupMenu", font("body"))
	t.set_font_size("font_size", "PopupMenu", BODY)
	t.set_constant("v_separation", "PopupMenu", 14)
	t.set_stylebox("normal", "OptionButton", box(PANEL2, LINE, 8, 1, 10, 7))
	t.set_stylebox("hover", "OptionButton", box(PANEL2, MUTED, 8, 1, 10, 7))
	t.set_stylebox("pressed", "OptionButton", box(PANEL2, GOLD, 8, 1, 10, 7))
	t.set_stylebox("disabled", "OptionButton", box(PANEL2, LINE, 8, 1, 10, 7))
	t.set_stylebox("focus", "OptionButton", StyleBoxEmpty.new())
	t.set_color("font_color", "OptionButton", FG)
	t.set_color("font_disabled_color", "OptionButton", Color(FG, 0.4))
	t.set_stylebox("normal", "LineEdit", box(PANEL, LINE, 8, 1, 12, 10))
	t.set_stylebox("focus", "LineEdit", box(PANEL, GOLD, 8, 1, 12, 10))
	t.set_color("font_color", "LineEdit", FG)
	t.set_color("font_placeholder_color", "LineEdit", Color(MUTED, 0.7))
	t.set_stylebox("panel", "ScrollContainer", StyleBoxEmpty.new())
	_theme = t
	return t


static func _edge(bg: Color, left: int, top: int, right: int, bottom: int, pad_h: int, pad_v: int) -> StyleBoxFlat:
	var s := box(bg, LINE, 0, 0, pad_h, pad_v)
	s.border_color = LINE
	s.border_width_left = left
	s.border_width_top = top
	s.border_width_right = right
	s.border_width_bottom = bottom
	return s


static func _panel(t: Theme, name: String, sb: StyleBox) -> void:
	t.set_type_variation(name, "PanelContainer")
	t.set_stylebox("panel", name, sb)


static func _button(t: Theme, name: String, bg: Color, border: Color, fg: Color, hover_border: Color, radius: int,
		pad_h: int, pad_v: int, font_kind: String, size: int, hover_bg: Color = Color(-1, 0, 0, 0)) -> void:
	if name != "Button":
		t.set_type_variation(name, "Button")
	var hb := bg if hover_bg.r < 0.0 else hover_bg
	t.set_stylebox("normal", name, box(bg, border, radius, 1, pad_h, pad_v))
	t.set_stylebox("hover", name, box(hb, hover_border, radius, 1, pad_h, pad_v))
	t.set_stylebox("pressed", name, box(hb, hover_border, radius, 1, pad_h, pad_v))
	t.set_stylebox("disabled", name, box(Color(bg, bg.a * 0.45), Color(border, border.a * 0.45), radius, 1, pad_h, pad_v))
	t.set_stylebox("focus", name, StyleBoxEmpty.new())
	t.set_color("font_color", name, fg)
	t.set_color("font_hover_color", name, FG if fg == MUTED else fg)
	t.set_color("font_pressed_color", name, fg)
	t.set_color("font_focus_color", name, fg)
	t.set_color("font_hover_pressed_color", name, fg)
	t.set_color("font_disabled_color", name, Color(fg, 0.4))
	t.set_font("font", name, font(font_kind))
	t.set_font_size("font_size", name, size)


## ---------- builders ----------

static func label(text: String, size: int = BODY, color: Color = FG, kind: String = "body", wrap: bool = false) -> Label:
	var l := Label.new()
	l.text = text
	l.add_theme_font_size_override("font_size", size)
	l.add_theme_color_override("font_color", color)
	l.add_theme_font_override("font", font(kind))
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
	if disabled:
		b.modulate = Color(1, 1, 1, 0.45)
	return b


static func card(title: String = "") -> Array:
	var p := PanelContainer.new()
	p.theme_type_variation = "Card"
	p.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var v := VBoxContainer.new()
	v.add_theme_constant_override("separation", 8)
	p.add_child(v)
	if title != "":
		v.add_child(caps(title))
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
static func row(title: String, sub: String = "", dot_color: Color = Color(0, 0, 0, 0), right: Array = []) -> HBoxContainer:
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
	var v := label(value, BODY, value_color, value_kind)
	v.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	h.add_child(v)
	return h


static func chip(text: String, colour_key: String) -> PanelContainer:
	var colours := {"green": GREEN, "red": RED, "amber": AMBER, "gold": GOLD, "": MUTED}
	var names := {"green": "ChipGreen", "red": "ChipRed", "amber": "ChipAmber", "gold": "ChipGold", "": "Chip"}
	var p := PanelContainer.new()
	p.theme_type_variation = names.get(colour_key, "Chip")
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
static func stat_row(name: String, value: float, gold: bool = false, number_color: Color = FG, suffix: String = "") -> HBoxContainer:
	var h := hbox(12)
	var l := label(name, BODY)
	l.custom_minimum_size = Vector2(150, 0)
	h.add_child(l)
	var bar: Control = Bar.new()
	bar.frac = value - floorf(value)
	bar.fill = GOLD if gold else GREEN
	bar.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	bar.size_flags_vertical = Control.SIZE_SHRINK_CENTER
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
