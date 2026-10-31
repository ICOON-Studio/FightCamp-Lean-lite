extends Control
## S330 (MENULOOK1): HOME's next four weeks as a picture - a line of days from today, a band per week with its Monday's
## date, and a marker on each day something happens: her bouts (gold), weigh-ins (amber), the championships (green),
## the month's bills (red). Labels stack so they never overlap. events: [{d, t, kind}].

const UI := preload("res://scripts/ui/UI.gd")

const DAYS := 28
const LINE_Y := 96.0
const LEVEL_H := 22.0

var today := 0
var events: Array = []


func _ready() -> void:
	custom_minimum_size = Vector2(0, 142)
	size_flags_horizontal = Control.SIZE_EXPAND_FILL


func _draw() -> void:
	var dw := size.x / DAYS
	var small := UI.font("body")
	var bold := UI.font("bold")
	for k in DAYS:
		var d := today + k
		if posmod(d, 7) == 0 or k == 0:
			var wk := int(floor(d / 7.0))
			if wk % 2 == 0:
				var end := mini(DAYS, k + 7 - posmod(d, 7))
				draw_rect(Rect2(k * dw, LINE_Y - 8.0, (end - k) * dw, 16.0), Color(UI.PANEL2, 0.8))
			draw_string(small, Vector2(k * dw + 3.0, LINE_Y + 34.0), "Today" if k == 0 else Clock.fmt(d), HORIZONTAL_ALIGNMENT_LEFT, -1,
				UI.TINY, UI.FG if k == 0 else UI.MUTED)
			draw_line(Vector2(k * dw, LINE_Y - 8.0), Vector2(k * dw, LINE_Y + 18.0), UI.LINE, 1.0)
	draw_line(Vector2(0, LINE_Y), Vector2(size.x, LINE_Y), UI.LINE, 2.0)
	draw_circle(Vector2(dw * 0.5, LINE_Y), 5.0, UI.FG)
	var cols := {"bout": UI.GOLD, "weigh": UI.AMBER, "champ": UI.GREEN, "bill": UI.RED, "review": UI.MUTED}
	var ends: Array = [-1e9, -1e9, -1e9, -1e9]
	var list := events.filter(func(e): return int(e["d"]) >= today and int(e["d"]) < today + DAYS)
	list.sort_custom(func(a, b): return int(a["d"]) < int(b["d"]) or (int(a["d"]) == int(b["d"]) and str(a["kind"]) == "bout"))
	# Place every label first, draw the stems and markers, then the labels on a backing so no stem runs through a word.
	var labels: Array = []
	for e in list:
		var x := (int(e["d"]) - today + 0.5) * dw
		var kind := str(e["kind"])
		var big := kind == "bout"
		var font := bold if big or kind == "champ" else small
		var fs := UI.SMALL if big else UI.TINY
		var text := str(e["t"])
		var tw := font.get_string_size(text, HORIZONTAL_ALIGNMENT_LEFT, -1, fs).x
		var tx := clampf(x - 6.0, 0.0, maxf(0.0, size.x - tw))
		var level := 0
		while level < ends.size() - 1 and float(ends[level]) > tx - 10.0:
			level += 1
		ends[level] = tx + tw
		labels.append({"x": x, "tx": tx, "tw": tw, "ty": LINE_Y - 22.0 - level * LEVEL_H, "font": font, "fs": fs, "text": text,
			"col": cols.get(kind, UI.FG), "big": big})
	for l in labels:
		draw_line(Vector2(l["x"], float(l["ty"]) + 4.0), Vector2(l["x"], LINE_Y), Color(l["col"], 0.6), 1.0)
		draw_circle(Vector2(l["x"], LINE_Y), 8.0 if bool(l["big"]) else 5.0, l["col"])
	for l in labels:
		var fs: int = l["fs"]
		draw_rect(Rect2(float(l["tx"]) - 3.0, float(l["ty"]) - fs, float(l["tw"]) + 6.0, fs + 5.0), UI.PANEL)
		draw_string(l["font"], Vector2(l["tx"], l["ty"]), l["text"], HORIZONTAL_ALIGNMENT_LEFT, -1, fs, l["col"])
