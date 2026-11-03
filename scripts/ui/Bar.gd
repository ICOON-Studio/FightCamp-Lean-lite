extends Control
## A thin rounded bar: `frac` of it filled. Tween `frac` to make it grow.
## S375 (operator: "these long line meters do not look good at all in your menus"): `segments` > 0 draws it as a short row
## of pips (the menus' meter, UI.meter / UI.stat_row: a fixed width, never stretched across a card), the last pip filled
## in part; `marks` = fractions where a threshold sits (a weapon at 30, a signature at 85), drawn as a small tick under it.

var frac: float = 0.0:
	set(value):
		frac = clampf(value, 0.0, 1.0)
		queue_redraw()
var fill: Color = Color("#6cc27a"):
	set(value):
		fill = value
		queue_redraw()
var track: Color = Color("#dfe6eb")   # S333 look B: a light track on the white boards
var segments := 0
var gap := 3.0
var marks: Array = []
var mark_color := Color("#55626b")


func _init() -> void:
	custom_minimum_size = Vector2(60, 12)
	mouse_filter = Control.MOUSE_FILTER_IGNORE


func _draw() -> void:
	var h := size.y - (2.0 if not marks.is_empty() else 0.0)
	if segments <= 0:
		var r := Rect2(Vector2.ZERO, Vector2(size.x, h))
		draw_style_box(_rounded(track, h), r)
		if frac > 0.0:
			draw_style_box(_rounded(fill, h), Rect2(Vector2.ZERO, Vector2(maxf(h, size.x * frac), h)))
	else:
		var w := (size.x - gap * float(segments - 1)) / float(segments)
		var filled := frac * float(segments)
		for i in segments:
			var r := Rect2(Vector2(float(i) * (w + gap), 0.0), Vector2(w, h))
			draw_style_box(_rounded(track, 3.0), r)
			var part := clampf(filled - float(i), 0.0, 1.0)
			if part > 0.0:
				draw_style_box(_rounded(fill, 3.0), Rect2(r.position, Vector2(maxf(3.0, w * part), h)))
	for m in marks:   # a dark notch through the meter, standing 2 px proud above and below
		var x := clampf(float(m), 0.0, 1.0) * size.x
		draw_rect(Rect2(Vector2(x - 1.0, -2.0), Vector2(2.0, size.y + 2.0)), mark_color)


func _rounded(c: Color, h: float) -> StyleBoxFlat:
	var s := StyleBoxFlat.new()
	s.bg_color = c
	s.set_corner_radius_all(int(minf(h, size.y) / 2.0))
	s.anti_aliasing = true
	return s
