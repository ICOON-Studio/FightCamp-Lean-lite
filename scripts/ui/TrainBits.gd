extends RefCounted
## S496 TRAININGK1: the small pieces the Training screen (Training K v6c) is drawn with - words, panels, a session's picture,
## a round face, the mastery bar (she had / tonight / the night still missing / the Usable flag) and the tiredness sparkline.
## Colours from Palette only.
##   lab(text, px, colour, kind)  panel(bg, edge, radius, pad)  icon(id, px, edge)  face(stem, px, ring)  MBar  Spark

const UI := preload("res://scripts/ui/UI.gd")
const Palette := preload("res://scripts/ui/Palette.gd")
const PromoShot := preload("res://scripts/ui/PromoShot.gd")
const FaceFrame := preload("res://scripts/ui/FaceFrame.gd")
const Data := preload("res://scripts/state/Data.gd")

const ICONS := "res://assets/ui/sessions/%s.png"
## The mastery a move is Usable from (MoveMastery tiers; BoutRules.WEAPON_MASTERY).
const USABLE := 30.0


static func lab(text: String, px: int = 16, colour: Color = Palette.TEXT, kind: String = "bold") -> Label:
	var l := UI.label(text, px, colour, kind)
	l.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return l


static func caps(text: String, px: int = 18) -> Label:
	return lab(text, px, Palette.HEADER, "display")


static func panel(bg: Color = Palette.CARD, edge: Color = Palette.LINE, radius: int = 10, pad: int = 10, w: int = 1) -> StyleBoxFlat:
	return UI.box(bg, edge, radius, w, pad, pad)


static func wrap(child: Control, bg: Color = Palette.CARD, edge: Color = Palette.LINE, radius: int = 10, pad: int = 10, w: int = 1) -> PanelContainer:
	var p := PanelContainer.new()
	p.add_theme_stylebox_override("panel", panel(bg, edge, radius, pad, w))
	p.add_child(child)
	return p


## The word an attribute key shows (Data.LABEL), "" for none.
static func stat_word(key: String) -> String:
	return str(Data.LABEL.get(key, key.capitalize())) if key != "" else ""


## A session's painted picture in a rounded frame of `edge`; a missing picture leaves the frame empty.
static func icon(id: String, px: int, edge: Color) -> PanelContainer:
	var p := PanelContainer.new()
	p.name = "Pic"
	p.custom_minimum_size = Vector2(px, px)
	p.add_theme_stylebox_override("panel", UI.box(Palette.PAGE, edge, 10, 3, 2, 2))
	p.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var path := ICONS % id
	if ResourceLoader.exists(path):
		var t := TextureRect.new()
		t.texture = load(path)
		t.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		t.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		t.mouse_filter = Control.MOUSE_FILTER_IGNORE
		p.add_child(t)
	return p


## A round face (the head kept whole by FaceFrame) in a ring of `ring`.
static func face(stem: String, px: int, ring: Color = Palette.WOOD) -> PanelContainer:
	var p := PanelContainer.new()
	p.name = "Face"
	p.custom_minimum_size = Vector2(px, px)
	p.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	p.add_theme_stylebox_override("panel", UI.box(Palette.PAGE, ring, px / 2, 2, 0, 0))
	p.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var tex := PromoShot.source(stem) if stem != "" else null
	if tex != null:
		var t := TextureRect.new()
		t.texture = tex
		t.mouse_filter = Control.MOUSE_FILTER_IGNORE
		FaceFrame.fit(t, FaceFrame.box_for(tex), Vector2(px - 4, px - 4), true)
		p.add_child(t)
	return p


class MBar extends Control:
	var had := 0.0
	var now := 0.0
	var ghost := 0.0
	var span := 36.0
	var flag := 30.0

	func _ready() -> void:
		mouse_filter = Control.MOUSE_FILTER_IGNORE
		resized.connect(queue_redraw)

	func _x(v: float) -> float:
		return clampf(v / span, 0.0, 1.0) * size.x

	func _draw() -> void:
		var top := 6.0
		var h := maxf(6.0, size.y - top)
		draw_rect(Rect2(0, top, size.x, h), Palette.PAGE)
		draw_rect(Rect2(0, top, _x(had), h), Palette.sunk(Palette.ELITE))
		if now > had:
			var r := Rect2(_x(had), top, _x(now) - _x(had), h)
			draw_rect(r, Palette.ELITE)
			draw_rect(r, Palette.TEXT, false, 1.5)
		if ghost > now:
			var g := Rect2(_x(now) + 2, top + 1, _x(ghost) - _x(now) - 2, h - 2)
			var x := g.position.x
			while x < g.end.x:   # a dashed outline: the night still missing
				draw_line(Vector2(x, g.position.y), Vector2(minf(x + 4, g.end.x), g.position.y), Palette.ELITE, 2)
				draw_line(Vector2(x, g.end.y), Vector2(minf(x + 4, g.end.x), g.end.y), Palette.ELITE, 2)
				x += 7
			draw_line(g.position, Vector2(g.position.x, g.end.y), Palette.ELITE, 2)
			draw_line(Vector2(g.end.x, g.position.y), g.end, Palette.ELITE, 2)
		var fx := _x(flag)
		if flag < span:
			draw_line(Vector2(fx, 0), Vector2(fx, top + h), Palette.GOOD_FILL, 2)
			draw_colored_polygon(PackedVector2Array([Vector2(fx, 0), Vector2(fx + 9, 3), Vector2(fx, 6)]), Palette.GOOD_FILL)


## The week's tiredness, day by day, as a small line (the fighter card's sparkline).
class Spark extends Control:
	var pts: Array = []

	func _ready() -> void:
		mouse_filter = Control.MOUSE_FILTER_IGNORE
		resized.connect(queue_redraw)

	func _draw() -> void:
		if pts.size() < 2:
			return
		var line := PackedVector2Array()
		for i in pts.size():
			line.append(Vector2(size.x * float(i) / float(pts.size() - 1), size.y * (1.0 - clampf(float(pts[i]) / 100.0, 0.0, 1.0))))
		draw_polyline(line, Palette.ACCENT, 2.0, true)
