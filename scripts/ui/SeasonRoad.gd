extends Control
## S329 (operator C150 on the update 30 Nationals page: "can be improved" - a wall of rows): her season as a road, left to
## right. A stop per step - ready, entered, each round she boxes or will box - a green dot done, a red cross out, a gold
## ring the next one, a dim dot ahead; the road is lit up to where she is. Title above each stop, date and words below.
## stops: [{label, date, sub, state: done|out|next|ahead}].

const UI := preload("res://scripts/ui/UI.gd")

const R := 13.0

var stops: Array = []


func _ready() -> void:
	custom_minimum_size = Vector2(0, 178)
	size_flags_horizontal = Control.SIZE_EXPAND_FILL


func _draw() -> void:
	if stops.is_empty():
		return
	var n := stops.size()
	var step := size.x / n
	var y := 74.0
	var cols := {"done": UI.GREEN, "out": UI.RED, "next": UI.GOLD, "ahead": UI.LINE}
	var lit := -1
	for i in n:
		if ["done", "out", "next"].has(str(stops[i]["state"])):
			lit = i
	var x0 := step * 0.5
	var x1 := step * (n - 0.5)
	draw_line(Vector2(x0, y), Vector2(x1, y), UI.LINE, 4.0)
	if lit > 0:
		draw_line(Vector2(x0, y), Vector2(step * (lit + 0.5), y), Color(UI.GOLD, 0.8), 4.0)
	var caps := UI.font("caps")
	var bold := UI.font("bold")
	var body := UI.font("body")
	for i in n:
		var s: Dictionary = stops[i]
		var x := step * (i + 0.5)
		var st := str(s["state"])
		var col: Color = cols.get(st, UI.LINE)
		if st == "next":
			draw_circle(Vector2(x, y), R + 6.0, Color(UI.GOLD, 0.22))
			draw_circle(Vector2(x, y), R, UI.BG)
			draw_arc(Vector2(x, y), R, 0.0, TAU, 40, UI.GOLD, 4.0, true)
		elif st == "ahead":
			draw_circle(Vector2(x, y), R - 3.0, UI.PANEL2)
			draw_arc(Vector2(x, y), R - 3.0, 0.0, TAU, 32, UI.LINE, 2.0, true)
		else:
			draw_circle(Vector2(x, y), R, col)
			if st == "done":
				draw_polyline(PackedVector2Array([Vector2(x - 6, y), Vector2(x - 2, y + 5), Vector2(x + 7, y - 6)]), UI.GOLD_INK, 3.0, true)
			else:
				draw_line(Vector2(x - 5, y - 5), Vector2(x + 5, y + 5), UI.GOLD_INK, 3.0, true)
				draw_line(Vector2(x - 5, y + 5), Vector2(x + 5, y - 5), UI.GOLD_INK, 3.0, true)
		var words := str(s["label"]).split(" ", true, 1)
		var top_col := UI.FG if st != "ahead" else UI.MUTED
		_centred(caps, words[0].to_upper(), x, 22.0, UI.TINY, UI.MUTED, step)
		if words.size() > 1:
			_centred(bold, words[1], x, 42.0, UI.SMALL, top_col, step)
		_centred(bold, str(s["date"]), x, y + R + 26.0, UI.SMALL, col if st != "ahead" else UI.MUTED, step)
		var sub := str(s.get("sub", ""))
		if sub != "":
			_centred(body, sub, x, y + R + 48.0, UI.TINY, UI.FG if st == "next" else UI.MUTED, step)
		var sub2 := str(s.get("sub2", ""))
		if sub2 != "":
			_centred(body, sub2, x, y + R + 67.0, UI.TINY, UI.MUTED, step)


## One line centred on x, cut with "..." to the stop's width.
func _centred(font: Font, text: String, x: float, baseline: float, fsize: int, col: Color, width: float) -> void:
	var t := text
	var room := width - 12.0
	while t.length() > 3 and font.get_string_size(t, HORIZONTAL_ALIGNMENT_LEFT, -1, fsize).x > room:
		t = t.substr(0, t.length() - 4) + "..."
	var w := font.get_string_size(t, HORIZONTAL_ALIGNMENT_LEFT, -1, fsize).x
	draw_string(font, Vector2(x - w / 2.0, baseline), t, HORIZONTAL_ALIGNMENT_LEFT, -1, fsize, col)
