extends Control
## S329: one entry need of the nationals as a ring - filled to value / goal, the number in the middle, green when met,
## amber while she is on the way, red when it blocks her this year (age, injury).

const UI := preload("res://scripts/ui/UI.gd")

var value := 0.0
var goal := 1.0
var big := ""
var colour := UI.GREEN


func _ready() -> void:
	custom_minimum_size = Vector2(84, 84)


func _draw() -> void:
	var c := size / 2.0
	var r := minf(size.x, size.y) / 2.0 - 6.0
	draw_arc(c, r, 0.0, TAU, 64, UI.PANEL2, 8.0, true)
	var part := clampf(value / maxf(goal, 0.001), 0.0, 1.0)
	if part > 0.0:
		draw_arc(c, r, -PI / 2.0, -PI / 2.0 + TAU * part, 64, colour, 8.0, true)
	var font := UI.font("display")
	var fs := 34 if big.length() <= 3 else 26
	var ts := font.get_string_size(big, HORIZONTAL_ALIGNMENT_LEFT, -1, fs)
	draw_string(font, Vector2(c.x - ts.x / 2.0, c.y + fs * 0.36), big, HORIZONTAL_ALIGNMENT_LEFT, -1, fs, UI.FG)
