extends Control
## S329: a championship draw as a bracket - a column per round (title and date on top), a box per bout with both names,
## the winner bright and the loser dim, lines from each bout to the next round, her name in gold, and the champion at
## the end. rounds: [{title, date, pairs: [[a, b], ...], winners: [w, ...] or []}]; names are display names ("" = not
## known yet, "bye" = a bye). Set rounds, her and champion_title, then queue_redraw.

const UI := preload("res://scripts/ui/UI.gd")

const HEAD := 46.0
const ROW := 27.0
const GAP := 14.0
const COL_MAX := 290.0

var rounds: Array = []
var her := ""
var champion_title := "Champion"


func _ready() -> void:
	size_flags_horizontal = Control.SIZE_EXPAND_FILL


func set_rounds(r: Array) -> void:
	rounds = r
	var n := 1 if r.is_empty() else maxi(1, (r[0]["pairs"] as Array).size())
	custom_minimum_size = Vector2(0, HEAD + n * (ROW * 2.0 + GAP) + 8.0)
	queue_redraw()


func _draw() -> void:
	if rounds.is_empty():
		return
	var cols := rounds.size() + 1
	var colw := minf(size.x / cols, COL_MAX)
	var boxw := colw - 34.0
	var slot := ROW * 2.0 + GAP
	var caps := UI.font("caps")
	var bold := UI.font("bold")
	var body := UI.font("body")
	var final_winner := ""
	for j in rounds.size():
		var r: Dictionary = rounds[j]
		var x := j * colw
		draw_string(caps, Vector2(x, 16), str(r["title"]).to_upper(), HORIZONTAL_ALIGNMENT_LEFT, colw - 8.0, UI.TINY, UI.MUTED)
		draw_string(bold, Vector2(x, 36), str(r["date"]), HORIZONTAL_ALIGNMENT_LEFT, colw - 8.0, UI.SMALL, UI.FG)
		var pairs: Array = r["pairs"]
		var wins: Array = r.get("winners", [])
		var span := slot * pow(2.0, j)
		for i in pairs.size():
			var cy := HEAD + (i + 0.5) * span
			var top := cy - ROW
			var p: Array = pairs[i]
			var w := str(wins[i]) if i < wins.size() else ""
			var ours := p.has(her)
			draw_style_box(UI.box(UI.PANEL2 if not ours else Color(UI.GOLD, 0.14), UI.GOLD if ours else UI.LINE, 6, 1), Rect2(x, top, boxw, ROW * 2.0))
			draw_line(Vector2(x + 6, cy), Vector2(x + boxw - 6, cy), UI.ROWLINE, 1.0)
			for k in 2:
				var name := str(p[k])
				var shown := "-" if name == "" else name
				var col := UI.FG
				var font := body
				if name == her:
					col = UI.GOLD
					font = bold
				if w != "" and name != w:
					col = Color(col, 0.38)
				elif w != "" and name == w:
					font = bold
				if name == "bye" or name == "":
					col = UI.MUTED
				draw_string(font, Vector2(x + 10, top + ROW * k + 19), shown, HORIZONTAL_ALIGNMENT_LEFT, boxw - 34.0, UI.SMALL, col)
				if w != "" and name == w and name != "bye":
					draw_string(bold, Vector2(x + boxw - 22, top + ROW * k + 19), "W", HORIZONTAL_ALIGNMENT_LEFT, -1, UI.TINY, UI.GREEN)
			var nx := (j + 1) * colw
			var ny := cy if pairs.size() == 1 else HEAD + (floori(i / 2.0) + 0.5) * span * 2.0
			var mid := x + boxw + (colw - boxw) / 2.0
			var lc := UI.GOLD if (ours and w == her) else UI.LINE
			draw_polyline(PackedVector2Array([Vector2(x + boxw, cy), Vector2(mid, cy), Vector2(mid, ny), Vector2(nx, ny)]), lc, 2.0)
			if pairs.size() == 1:
				final_winner = w
	var cx := rounds.size() * colw
	var champ_y := HEAD + 0.5 * slot * pow(2.0, rounds.size() - 1)
	draw_string(caps, Vector2(cx, 16), champion_title.to_upper(), HORIZONTAL_ALIGNMENT_LEFT, colw - 8.0, UI.TINY, UI.GOLD)
	var won := final_winner == her and her != ""
	draw_style_box(UI.box(Color(UI.GOLD, 0.22) if won else UI.PANEL, UI.GOLD, 6, 2), Rect2(cx, champ_y - ROW * 0.75, boxw, ROW * 1.5))
	var champ := final_winner if final_winner != "" else "?"
	draw_string(bold, Vector2(cx + 10, champ_y + 6), champ, HORIZONTAL_ALIGNMENT_LEFT, boxw - 16.0, UI.BODY, UI.GOLD if won else UI.FG)
