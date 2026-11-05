extends RefCounted
## S356 the coach's whiteboard (operator Q-S294-84 "Yes, build it", the Miro "Whiteboard planner" mockup): the pieces the
## fighter's Training tab is drawn with - the board in its frame, marker and hand-written words, the magnets a session is,
## the fight date circled in red, the sticky note, a day's fatigue bar. Colour only means risk: ink by default, amber near
## the line, red over it.
##   board_style() -> the board in its frame   ink(text, size, kind, colour) -> Label   circled(top, under) -> Control
##   sticky() -> PanelContainer   (S382 DRILLCARD1: the magnets and their 25-card pick list went with the old week grid)
##   tape_chip(text) -> PanelContainer   Fatigue (bar)   roman(intensity)   risk_colour(v)
##   level(intensity) -> LIGHT|NORMAL|HARD   fatigue_word(v, red) -> [word, tip, colour]

const UI := preload("res://scripts/ui/UI.gd")

const BOARD := Color("#f4f2ec")      # the whiteboard
const FRAME := Color("#3b3430")      # its frame
const INK := Color("#1f2a44")        # navy marker
const PENCIL := Color("#6b7280")     # the lighter hand
const RED := Color("#c8312a")        # the red marker: the date, risk
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


## S359 (Kalli SQ25: "Roman numerals mean nothing to a boxing coach") the intensity as the word on the magnet.
static func level(intensity: String) -> String:
	return {"light": "LIGHT", "normal": "NORMAL", "hard": "HARD"}.get(intensity, "NORMAL")


## S359 (Kalli SQ25: "a red bar with a number shows a problem, not a consequence") a day's fatigue as a word, its cost on
## the hover: [word, tooltip, colour]. red = the second Hard morning in a row (WeekPlan.week). The costs are the ones the
## maths runs: a morning started at 80+ trains at 60 % (WeekPlan.TIRED_GAIN); a camp peaking at 80+ fails its fatigue line.
static func fatigue_word(v: float, red: bool) -> Array:
	var n := int(round(v))
	if v >= RED_AT:
		return ["OVERCOOKED", "Overcooked (fatigue %d of 100): the next morning trains at 60%% - gains cut by 40%% - and a camp that peaks over 80 fails its fatigue line." % n, RED]
	if red:
		return ["RED DAY", "Red day (fatigue %d of 100): the second Hard morning in a row - the coach wants it Light or off." % n, RED]
	# S359 (operator: "what is worked showing ??" - every day read WORKED): the word stands out only when it matters.
	if v >= AMBER_AT:
		return ["TIRED", "Tired (fatigue %d of 100): near the line. Over 80 the next morning's training counts only 60%%." % n, UI.AMBER]
	if v >= 50.0:
		return ["OK", "OK (fatigue %d of 100): normal camp tiredness." % n, PENCIL]
	return ["FRESH", "Fresh (fatigue %d of 100): room for a Hard morning." % n, UI.GREEN]


static func risk_colour(v: float) -> Color:
	return RED if v >= RED_AT else (UI.AMBER if v >= AMBER_AT else INK)


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
