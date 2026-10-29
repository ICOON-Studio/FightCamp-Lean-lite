extends Control
## A thin rounded bar: `frac` of it filled. Tween `frac` to make it grow.

var frac: float = 0.0:
	set(value):
		frac = clampf(value, 0.0, 1.0)
		queue_redraw()
var fill: Color = Color("#6cc27a"):
	set(value):
		fill = value
		queue_redraw()
var track: Color = Color("#3a2e26")


func _init() -> void:
	custom_minimum_size = Vector2(60, 12)
	mouse_filter = Control.MOUSE_FILTER_IGNORE


func _draw() -> void:
	var r := Rect2(Vector2.ZERO, size)
	draw_style_box(_rounded(track), r)
	if frac > 0.0:
		draw_style_box(_rounded(fill), Rect2(Vector2.ZERO, Vector2(maxf(size.y, size.x * frac), size.y)))


func _rounded(c: Color) -> StyleBoxFlat:
	var s := StyleBoxFlat.new()
	s.bg_color = c
	s.set_corner_radius_all(int(size.y / 2.0))
	s.anti_aliasing = true
	return s
