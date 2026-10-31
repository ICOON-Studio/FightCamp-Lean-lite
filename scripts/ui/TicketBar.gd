extends Control
## S329 update 31: her debut tickets as a picture - one cell per ticket, filled by who buys it (family, members, her
## record, her titles), empty cells unsold, a line where the promoter's night is paid; her half starts right of it.
## parts: [{n, col}]; total and break_even from ProDebut.

const UI := preload("res://scripts/ui/UI.gd")

var parts: Array = []
var total := 100
var break_even := 60


func _ready() -> void:
	custom_minimum_size = Vector2(0, 74)
	size_flags_horizontal = Control.SIZE_EXPAND_FILL


func _draw() -> void:
	var cell := size.x / total
	var top := 24.0
	var h := 30.0
	var cols: Array = []
	for p in parts:
		for k in int(p["n"]):
			cols.append(p["col"])
	for i in total:
		var r := Rect2(i * cell + 1.0, top, cell - 2.0, h)
		if i < cols.size():
			draw_rect(r, Color(cols[i], 1.0 if i >= break_even else 0.55))
		else:
			draw_rect(r, UI.PANEL2)
	var x := break_even * cell
	draw_line(Vector2(x, 4), Vector2(x, top + h + 6), UI.FG, 2.0)
	var font := UI.font("bold")
	var left := "%d pay the promoter's night" % break_even
	var lw := font.get_string_size(left, HORIZONTAL_ALIGNMENT_LEFT, -1, UI.TINY).x
	draw_string(font, Vector2(x - lw - 8, 16), left, HORIZONTAL_ALIGNMENT_LEFT, -1, UI.TINY, UI.MUTED)
	draw_string(font, Vector2(x + 8, 16), "half of these are hers", HORIZONTAL_ALIGNMENT_LEFT, -1, UI.TINY, UI.GREEN)
	var sold := cols.size()
	var tag := "%d sold" % sold
	var tw := font.get_string_size(tag, HORIZONTAL_ALIGNMENT_LEFT, -1, UI.TINY).x
	var tx := clampf(sold * cell - tw / 2.0, 0.0, size.x - tw)
	draw_string(font, Vector2(tx, top + h + 20), tag, HORIZONTAL_ALIGNMENT_LEFT, -1, UI.TINY, UI.FG)
