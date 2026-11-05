extends "res://scripts/ui/Bar.gd"
## S387 a Bar with a range on it: the pips show our number, the box over them what the coach estimates of the other side
## (lo..hi as fractions). Where the pips end against the box is the read. `open` 0..1 tweens the box out from its middle.

var lo := 0.0
var hi := 0.0
var box := Color("#e2483d")
var open := 1.0:
	set(value):
		open = value
		queue_redraw()


func _draw() -> void:
	super()
	var mid := (lo + hi) / 2.0
	var a := lerpf(mid, lo, open) * size.x
	var b := lerpf(mid, hi, open) * size.x
	var s := StyleBoxFlat.new()
	s.bg_color = Color(box, 0.22)
	s.border_color = box
	s.set_border_width_all(2)
	s.set_corner_radius_all(3)
	draw_style_box(s, Rect2(Vector2(a, -3.0), Vector2(maxf(4.0, b - a), size.y + 6.0)))
