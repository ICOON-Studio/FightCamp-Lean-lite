extends RefCounted
## S356 the coach's whiteboard (operator Q-S294-84 "Yes, build it", the Miro "Whiteboard planner" mockup): the pieces the
## fighter's Training tab is drawn with - the board in its frame, marker and hand-written words, the magnets a session is,
## the fight date circled in red, the sticky note, a day's fatigue bar. Colour only means risk: ink by default, amber near
## the line, red over it.
##   board_style() -> the board in its frame   ink(text, size, kind, colour) -> Label   magnet(text, roman, dark, tip) -> PanelContainer
##   pick_magnet(text, roman, dark, tip, items, on_pick) -> MenuButton   circled(top, under) -> Control   sticky() -> PanelContainer
##   tape_chip(text) -> PanelContainer   Fatigue (bar)   roman(intensity)   risk_colour(v)

const UI := preload("res://scripts/ui/UI.gd")

const BOARD := Color("#f4f2ec")      # the whiteboard
const FRAME := Color("#3b3430")      # its frame
const INK := Color("#1f2a44")        # navy marker
const PENCIL := Color("#6b7280")     # the lighter hand
const RED := Color("#c8312a")        # the red marker: the date, risk
const MAGNET := Color("#ffffff")
const DOT_DARK := Color("#1f2a44")
const DOT_LIGHT := Color("#9fb3dc")
const AMBER_AT := 70.0
const RED_AT := 80.0


static func board_style() -> StyleBoxFlat:
	var s := UI.box(BOARD, FRAME, 6, 12, 28, 22)
	s.shadow_color = Color(0, 0, 0, 0.25)
	s.shadow_size = 6
	return s


## Words on the board: kind "marker" (Permanent Marker) or "hand" / "handbold" (Kalam).
static func ink(text: String, size: int, kind: String = "hand", colour: Color = INK, wrap: bool = false) -> Label:
	var l := UI.label(text, size, colour, kind, wrap)
	return l


static func roman(intensity: String) -> String:
	return {"light": "I", "normal": "II", "hard": "III"}.get(intensity, "II")


static func risk_colour(v: float) -> Color:
	return RED if v >= RED_AT else (UI.AMBER if v >= AMBER_AT else INK)


static func _pill(dark: bool) -> StyleBoxFlat:
	var s := UI.box(MAGNET, Color("#d8d4cb"), 18, 1, 10, 6)
	s.shadow_color = Color(0, 0, 0, 0.18)
	s.shadow_size = 3
	s.shadow_offset = Vector2(0, 2)
	return s


## A magnet that is only shown (the evening): a dot, the words, the intensity in roman numerals.
static func magnet(text: String, rom: String, dark: bool, tip: String) -> PanelContainer:
	var p := PanelContainer.new()
	p.add_theme_stylebox_override("panel", _pill(dark))
	p.tooltip_text = tip
	var h := UI.hbox(6)
	h.mouse_filter = Control.MOUSE_FILTER_IGNORE
	p.add_child(h)
	h.add_child(_Dot.new(dark))
	var w := ink(text, UI.SMALL, "hand", INK, true)
	w.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	w.mouse_filter = Control.MOUSE_FILTER_IGNORE
	h.add_child(w)
	if rom != "":
		var r := ink(rom, UI.SMALL, "handbold", INK)
		r.mouse_filter = Control.MOUSE_FILTER_IGNORE
		h.add_child(r)
	return p


## A magnet you move (the morning): click it for every card ([label, arg] items); on_pick gets the item's arg.
static func pick_magnet(text: String, rom: String, dark: bool, tip: String, items: Array, current: int, on_pick: Callable) -> MenuButton:
	var b := MenuButton.new()
	b.flat = false
	b.text = ""
	b.tooltip_text = tip
	for k in ["normal", "hover", "pressed", "focus"]:
		var s := _pill(dark)
		if k == "hover" or k == "pressed":
			s.border_color = UI.GOLD
			s.set_border_width_all(2)
		b.add_theme_stylebox_override(k, s)
	var inner := magnet(text, rom, dark, tip)
	inner.add_theme_stylebox_override("panel", StyleBoxEmpty.new())
	inner.mouse_filter = Control.MOUSE_FILTER_IGNORE
	inner.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	b.add_child(inner)
	b.custom_minimum_size = Vector2(0, 40)
	var pop := b.get_popup()
	for i in items.size():
		pop.add_radio_check_item(str(items[i][0]), i)
		pop.set_item_checked(i, i == current)
	pop.id_pressed.connect(func(id): on_pick.call(items[id][1]))
	return b


## The fight date, circled in red marker; `under` in hand below it.
static func circled(top: String, under: String) -> Control:
	var c := _Circle.new()
	var v := UI.vbox(0)
	v.alignment = BoxContainer.ALIGNMENT_CENTER
	v.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	var t := ink(top, 30, "marker", RED)
	t.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	v.add_child(t)
	var u := ink(under, UI.SMALL + 2, "hand", INK)
	u.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	v.add_child(u)
	c.add_child(v)
	c.custom_minimum_size = Vector2(300, 104)
	return c


static func sticky() -> PanelContainer:
	var p := PanelContainer.new()
	var s := UI.box(Color("#fbe7a1"), Color("#e2c770"), 2, 1, 18, 16)
	s.shadow_color = Color(0, 0, 0, 0.22)
	s.shadow_size = 5
	s.shadow_offset = Vector2(2, 4)
	p.add_theme_stylebox_override("panel", s)
	return p


## A dark chip with white caps (the phase: "BUILD WEEK").
static func tape_chip(text: String) -> PanelContainer:
	var p := PanelContainer.new()
	p.add_theme_stylebox_override("panel", UI.box(INK, Color(0, 0, 0, 0), 2, 0, 12, 4))
	p.add_child(UI.label(text, UI.SMALL, Color.WHITE, "caps"))
	p.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	return p


class _Dot extends Control:
	var dark := false

	func _init(d: bool) -> void:
		dark = d
		custom_minimum_size = Vector2(16, 16)
		size_flags_vertical = Control.SIZE_SHRINK_CENTER
		mouse_filter = Control.MOUSE_FILTER_IGNORE

	func _draw() -> void:
		draw_circle(size * 0.5, 8.0, DOT_DARK if dark else DOT_LIGHT)


class _Circle extends Control:
	func _draw() -> void:
		var c := size * 0.5
		var pts := PackedVector2Array()
		for i in 49:
			var a := TAU * float(i) / 48.0 - 0.3
			var wob := 1.0 + 0.02 * sin(a * 3.0)
			pts.append(c + Vector2(cos(a) * (size.x * 0.5 - 4.0) * wob, sin(a) * (size.y * 0.5 - 4.0) * wob))
		draw_polyline(pts, RED, 3.5, true)


## A day's fatigue on the board: a thin ink bar, amber near the line, red over it; the 80 line ticked.
class Fatigue extends Control:
	var value := 0.0

	func _init() -> void:
		custom_minimum_size = Vector2(0, 10)
		mouse_filter = Control.MOUSE_FILTER_IGNORE

	func _draw() -> void:
		draw_rect(Rect2(Vector2.ZERO, size), Color("#e2ded4"))
		var col := RED if value >= RED_AT else (UI.AMBER if value >= AMBER_AT else Color("#3f8f5a"))
		draw_rect(Rect2(Vector2.ZERO, Vector2(size.x * clampf(value / 100.0, 0.0, 1.0), size.y)), col)
		draw_line(Vector2(size.x * 0.8, -2), Vector2(size.x * 0.8, size.y + 2), INK, 2.0)
