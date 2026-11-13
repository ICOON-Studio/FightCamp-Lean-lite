extends RefCounted
## The corner bar's drawn icons (split from CornerBar.gd at S459 for the 500-line rule): the exchange clock ring and
## the glove that marks a call's chance to win its 30 seconds.


class Ring extends Control:
	var frac := 1.0
	var hot := false
	var caption := "0:30"

	func _draw() -> void:
		var c := size * 0.5
		var rad := minf(size.x, size.y) * 0.5 - 8.0
		draw_arc(c, rad, 0.0, TAU, 40, Color("#3a3028"), 8.0, true)
		var col := Color("#f2c14e") if hot else Color("#cdbb9c")
		if frac > 0.02:
			draw_arc(c, rad, -PI * 0.5, -PI * 0.5 + TAU * frac, 40, col, 8.0, true)
		var font := ThemeDB.fallback_font
		var px := 28
		var ts := font.get_string_size(caption, HORIZONTAL_ALIGNMENT_LEFT, -1, px)
		draw_string(font, c + Vector2(-ts.x * 0.5, px * 0.35), caption, HORIZONTAL_ALIGNMENT_LEFT, -1, px, col)


## A small boxing glove (the icon for "wins the exchange").
class Glove extends Control:
	var col := Color.WHITE

	func _draw() -> void:
		var k := Color(0, 0, 0, 0.7)
		draw_circle(Vector2(12, 9), 8.5, k)
		draw_rect(Rect2(5, 15, 14, 8), k)
		draw_circle(Vector2(12, 9), 7.0, col)
		draw_circle(Vector2(5.5, 12), 3.2, col)
		draw_rect(Rect2(6.5, 16, 11, 6), col)
		draw_line(Vector2(6.5, 16), Vector2(17.5, 16), k, 1.5)
