extends RefCounted
## S496 ONELOOK1 - THE HOUSE KIT (operator 2026-11-16: "Everymenu i loook is designed differently we need a proper UI
## consistent through scenes that meake sens. Also the colour pallette should be in effect"). One theme for every page:
## S498 round 2 ("i do not like the wooden panels"): ONE plain panel (WoodKit.slate: CARD, 1 px LINE edge, 6 px corners)
## for every card, flat plates for every button, and every other piece - chips, notes, fields, menus, hovers - on Palette
## tokens only. No picture-drawn piece anywhere; scripts/ui/LookCheck.gd + tests/one_look_test.gd fail one. Split out of UI.gd (the 500-line rule); UI.theme() / UI.font() / UI.box() call here.
##   theme() -> Theme   font(kind) -> Font   box(bg, border, radius, border_w, pad_h, pad_v) -> StyleBoxFlat
## Variations a page may use (and nothing else): Card, Tin, Board, Modal (the house panel); Polaroid (a picture's dark
## mount); Sticky / StickyRed / StickyGreen / StickyBlue (a note: a tile with a coloured edge); Toast; Note; Badge;
## Chip / ChipGreen / ChipRed / ChipAmber / ChipGold (a tag); TopBar; RailPanel; the WoodKit.PIECE buttons; Flag; Link.

const Plate := preload("res://scripts/ui/Plate.gd")
const WoodKit := preload("res://scripts/ui/WoodKit.gd")
const Palette := preload("res://scripts/ui/Palette.gd")

## Type sizes: body, small, the floor no word goes under (S413; S442 UX audit 15 -> 16, "fonts are small").
const BODY := 19
const SMALL := 16
const TINY := 16
const MIN_TEXT := 16
## Fonts by job: "display"/"marker" = the brush, page titles of 28 px and up only (S398); "body", "semi", "bold" = Barlow;
## "caps" = spaced bold for small headings; "hand" = Kalam, the coach's handwriting; "mono" = Barlow with table figures.

static var _fonts: Dictionary = {}
static var _theme: Theme


static func font(kind: String) -> Font:
	if _fonts.is_empty():
		var regular: FontFile = load("res://assets/fonts/Barlow-Regular.ttf")
		var semi: FontFile = load("res://assets/fonts/Barlow-SemiBold.ttf")
		var bold: FontFile = load("res://assets/fonts/Barlow-Bold.ttf")
		var bebas: FontFile = load("res://assets/fonts/BebasNeue-Regular.ttf")
		var mono: FontFile = load("res://assets/fonts/IBMPlexMono-Medium.ttf")
		for sharp: FontFile in [regular, semi, bold]:   # S408 operator's close-ups: small text was soft (glyphs on fractions of a pixel, no hinting)
			sharp.hinting = TextServer.HINTING_NORMAL
			sharp.subpixel_positioning = TextServer.SUBPIXEL_POSITIONING_DISABLED
		_fonts["marker"] = _load_or("res://assets/fonts/PermanentMarker-Regular.ttf", bebas)
		_fonts["hand"] = _load_or("res://assets/fonts/Kalam-Regular.ttf", regular)
		_fonts["handbold"] = _load_or("res://assets/fonts/Kalam-Bold.ttf", bold)
		_fonts["body"] = regular
		_fonts["semi"] = semi
		_fonts["bold"] = bold
		_fonts["caps"] = _spaced(bold, 2)
		_fonts["italic"] = _italic(regular)
		_fonts["display"] = _fonts["marker"]
		# S396 blind review: Plex Mono read as debug output; numbers keep their columns with the body font's tnum figures.
		var tab := FontVariation.new()
		tab.base_font = semi
		tab.opentype_features = {TextServerManager.get_primary_interface().name_to_tag("tnum"): 1}
		_fonts["mono"] = tab if mono != null else semi
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


static func box(bg: Color, border: Color = Palette.CLEAR, radius: int = 8, border_w: int = 1,
		pad_h: int = 12, pad_v: int = 8) -> StyleBoxFlat:
	if bg == Palette.CARD and border == Palette.LINE:   # S498 a hand-made card IS the house panel (one look, LookCheck)
		return WoodKit.slate(pad_h, pad_v)
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
	t.set_color("font_color", "Label", WoodKit.DARK_INK)
	# Buttons: every name but Flag and Link is a WoodKit plate (plain, on, act); [name, pad_h, pad_v, font, size].
	for b in [["Button", 12, 8, "semi", SMALL], ["TBtn", 18, 14, "semi", 21], ["TBtnPrimary", 18, 14, "semi", 21],
			["Ghost", 12, 8, "semi", SMALL], ["GhostDark", 12, 8, "semi", SMALL], ["Btn", 14, 8, "bold", SMALL],
			["BtnSolid", 14, 8, "bold", SMALL], ["BtnQuiet", 14, 8, "bold", SMALL], ["Rail", 14, 10, "bold", 17],
			["RailOn", 14, 10, "bold", 17], ["Tab", 16, 10, "bold", 17], ["TabOn", 16, 10, "bold", 17],
			["Choice", 14, 12, "semi", BODY], ["ChoiceOn", 14, 12, "semi", BODY], ["Pill", 9, 3, "semi", TINY],
			["PillOn", 9, 3, "semi", TINY], ["FlagRed", 14, 6, "bold", SMALL], ["Go", 16, 8, "bold", BODY],
			["GoBlock", 16, 8, "bold", BODY], ["GoFight", 16, 8, "bold", BODY], ["Speed", 4, 6, "mono", TINY],
			["SpeedOn", 4, 6, "mono", TINY], ["Ink", 16, 7, "bold", SMALL]]:
		_wood_button(t, b[0], b[1], b[2], b[3], b[4])
	_flat_button(t, "Flag", Palette.WARN, Palette.SECOND, Palette.ON_LIGHT, 4, 14, 6, "bold", SMALL)   # a warning button
	_flat_button(t, "Link", Palette.CLEAR, Palette.CLEAR, WoodKit.PAPER_BLUE, 0, 0, 0, "bold", BODY)   # chalked to ACCENT on slate
	# Panels: the house panel for every card; flat pieces on tokens.
	_panel(t, "Card", WoodKit.slate())
	_panel(t, "Board", WoodKit.slate(34, 26))
	_panel(t, "Tin", WoodKit.slate(34, 30))
	_panel(t, "Modal", WoodKit.slate(38, 34))
	_panel(t, "TopBar", WoodKit.bar(18, 12))
	var pol := box(Palette.CARD, Palette.LINE, 2, 1, 14, 14)   # a picture's mount (was a white polaroid)
	pol.content_margin_bottom = 8
	pol.shadow_color = Palette.shadow()
	pol.shadow_size = 8
	pol.shadow_offset = Vector2(2, 4)
	_panel(t, "Polaroid", pol)
	for sticky in [["Sticky", Palette.HEADER], ["StickyRed", Palette.BAD_FILL], ["StickyGreen", Palette.GOOD_FILL],
			["StickyBlue", Palette.ACCENT]]:   # a note: a tile with its colour on the left edge (was a yellow paper sticky)
		var sb := box(Palette.TILE, sticky[1], 2, 0, 22, 16)
		sb.border_width_left = 6
		_panel(t, sticky[0], sb)
	_panel(t, "RailPanel", box(Palette.PAGE, Palette.CLEAR, 0, 0, 10, 14))
	_panel(t, "Toast", box(Palette.HOVER, Palette.LINE, 4, 2, 18, 12))
	_panel(t, "Note", box(Palette.alpha(Palette.PAGE, 0.3), Palette.CLEAR, 3, 0, 14, 12))
	_panel(t, "Badge", box(Palette.BAD_FILL, Palette.CLEAR, 9, 0, 6, 0))
	for chip in [["Chip", Palette.MUTED], ["ChipGreen", Palette.GOOD_FILL], ["ChipRed", Palette.BAD_FILL],
			["ChipAmber", Palette.WARN], ["ChipGold", Palette.ACCENT]]:   # S419 a see-through dark tag, its colour on the left edge
		var tag := box(Palette.alpha(Palette.PAGE, 0.35), chip[1], 2, 0, 10, 3)
		tag.border_width_left = 4
		_panel(t, chip[0], tag)
	var thumb := box(Palette.alpha(Palette.TEXT, 0.38), Palette.CLEAR, 3, 0, 0, 0)   # S412 the page's scroll bar: a sliver
	var gutter := StyleBoxEmpty.new()
	gutter.content_margin_left = 6
	t.set_stylebox("scroll", "VScrollBar", gutter)
	for state in ["grabber", "grabber_highlight", "grabber_pressed"]:
		t.set_stylebox(state, "VScrollBar", thumb)
	var sep := StyleBoxLine.new()
	sep.color = Palette.LINE
	sep.thickness = 1
	t.set_stylebox("separator", "HSeparator", sep)
	t.set_constant("separation", "HSeparator", 1)
	_menus_and_fields(t)
	_theme = t
	return t


## Drop-down menus, pickers, text boxes and the hover card: dark plates, chalk words, the tan edge for "you are on it".
static func _menus_and_fields(t: Theme) -> void:
	t.set_stylebox("panel", "PopupMenu", box(Palette.HOVER, Palette.LINE, 10, 1, 6, 6))
	t.set_stylebox("hover", "PopupMenu", box(Palette.TILE, Palette.CLEAR, 6, 0, 10, 8))
	for key in ["font_color", "font_hover_color"]:
		t.set_color(key, "PopupMenu", Palette.TEXT)
	t.set_font("font", "PopupMenu", font("body"))
	t.set_font_size("font_size", "PopupMenu", BODY)
	t.set_constant("v_separation", "PopupMenu", 14)
	t.set_stylebox("normal", "OptionButton", box(Palette.PAGE, Palette.LINE, 8, 1, 10, 7))
	t.set_stylebox("hover", "OptionButton", box(Palette.PAGE, Palette.MUTED, 8, 1, 10, 7))
	t.set_stylebox("pressed", "OptionButton", box(Palette.PAGE, Palette.CHOSEN, 8, 1, 10, 7))
	t.set_stylebox("disabled", "OptionButton", box(Palette.PAGE, Palette.LINE, 8, 1, 10, 7))
	t.set_stylebox("focus", "OptionButton", StyleBoxEmpty.new())
	for key in ["font_color", "font_hover_color", "font_pressed_color", "font_focus_color"]:
		t.set_color(key, "OptionButton", Palette.TEXT)
	t.set_color("font_disabled_color", "OptionButton", Palette.disabled(Palette.TEXT))
	t.set_stylebox("normal", "LineEdit", box(Palette.PAGE, Palette.LINE, 8, 1, 12, 10))
	t.set_stylebox("focus", "LineEdit", box(Palette.PAGE, Palette.CHOSEN, 8, 1, 12, 10))
	t.set_color("font_color", "LineEdit", Palette.TEXT)
	t.set_color("font_placeholder_color", "LineEdit", Palette.MUTED)
	t.set_stylebox("panel", "ScrollContainer", StyleBoxEmpty.new())
	# S491 (operator: "we need to have a cohesive interface"): the engine's tooltip wears the house card (Tips.gd colours).
	var tip := box(Palette.HOVER, Palette.LINE, 4, 1, 14, 10)
	tip.shadow_color = Palette.alpha(Palette.PAGE, 0.22)
	tip.shadow_size = 6
	t.set_stylebox("panel", "TooltipPanel", tip)
	t.set_color("font_color", "TooltipLabel", Palette.TEXT)
	t.set_font("font", "TooltipLabel", font("body"))
	t.set_font_size("font_size", "TooltipLabel", BODY)


static func _panel(t: Theme, name: String, sb: StyleBox) -> void:
	t.set_type_variation(name, "PanelContainer")
	t.set_stylebox("panel", name, sb)


static func _wood_button(t: Theme, name: String, pad_h: int, pad_v: int, font_kind: String, size: int) -> void:
	if name != "Button":
		t.set_type_variation(name, "Button")
	_button_inks(t, name, WoodKit.plates(t, name, pad_h, pad_v), font_kind, size)


static func _flat_button(t: Theme, name: String, bg: Color, border: Color, fg: Color, radius: int, pad_h: int, pad_v: int,
		font_kind: String, size: int) -> void:
	t.set_type_variation(name, "Button")
	t.set_stylebox("normal", name, Plate.style(bg, border, radius, pad_h, pad_v, 3))
	t.set_stylebox("hover", name, Plate.style(Palette.hovered(bg), border, radius, pad_h, pad_v, 3))
	t.set_stylebox("pressed", name, Plate.style(Palette.pressed(bg), border, radius, pad_h, pad_v, 0))
	t.set_stylebox("disabled", name, Plate.style(Palette.disabled(bg), Palette.disabled(border), radius, pad_h, pad_v, 0))
	_button_inks(t, name, fg, font_kind, size)


static func _button_inks(t: Theme, name: String, fg: Color, font_kind: String, size: int) -> void:
	t.set_stylebox("focus", name, StyleBoxEmpty.new())
	for key in ["font_color", "font_pressed_color", "font_focus_color", "font_hover_pressed_color"]:
		t.set_color(key, name, fg)
	t.set_color("font_hover_color", name, WoodKit.INK if fg == WoodKit.SOFT else fg)
	t.set_color("font_disabled_color", name, Palette.disabled(fg))
	t.set_font("font", name, font(font_kind))
	t.set_font_size("font_size", name, size)
