extends Control
## Cash at the end of each week as gold bars, the newest brightest, a week label under each, and a line at $0 when the
## cash has gone below it. points: [{w, c}].

const UI := preload("res://scripts/ui/UI.gd")

var points: Array = []
## S330: HOME shows a shorter chart than MONEY.
var height := 230.0


func _ready() -> void:
	custom_minimum_size = Vector2(0, height)
	size_flags_horizontal = Control.SIZE_EXPAND_FILL


func _draw() -> void:
	if points.is_empty():
		return
	var font := UI.font("mono")
	var top := 14.0
	var bottom := size.y - 28.0
	var hi := 30000.0
	var lo := 0.0
	for p in points:
		hi = maxf(hi, float(p["c"]))
		lo = minf(lo, float(p["c"]))
	var span := maxf(1.0, hi - lo)
	var zero_y := bottom - (0.0 - lo) / span * (bottom - top)
	var bw := size.x / points.size()
	for i in points.size():
		var p: Dictionary = points[i]
		var y := bottom - (float(p["c"]) - lo) / span * (bottom - top)
		var x := i * bw + bw * 0.15
		var r := Rect2(x, minf(y, zero_y), bw * 0.7, absf(zero_y - y))
		var col := UI.GOLD if float(p["c"]) >= 0.0 else UI.RED
		draw_rect(r, Color(col, 1.0 if i == points.size() - 1 else 0.55))
		var label := "W%d" % int(p["w"])
		var tw := font.get_string_size(label, HORIZONTAL_ALIGNMENT_LEFT, -1, UI.TINY).x
		draw_string(font, Vector2(i * bw + (bw - tw) / 2.0, size.y - 6), label, HORIZONTAL_ALIGNMENT_LEFT, -1, UI.TINY, UI.MUTED)
	if lo < 0.0:
		draw_line(Vector2(0, zero_y), Vector2(size.x, zero_y), UI.LINE, 1.0)
	var top_label := UI.money(int(hi))
	draw_string(font, Vector2(4, top + 2), top_label, HORIZONTAL_ALIGNMENT_LEFT, -1, UI.TINY, UI.MUTED)
