extends Control
## Cash as one line: the weeks already closed, then the forecast dotted. events: [{i, n, bill, text}] numbered
## on the line, one circle per event. Gridlines carry $ labels. The $0 line is red and dashed. Today is marked.
## points: [{w, c}] the past, including today. future: the weeks CashForecast projected.

const UI := preload("res://scripts/ui/UI.gd")

var points: Array = []
var future: Array = []
var events: Array = []:
	set(value):
		events = value
		_rebuild_marks()
		queue_redraw()
var height := 112.0


func _ready() -> void:
	custom_minimum_size = Vector2(0, height)
	size_flags_horizontal = Control.SIZE_EXPAND_FILL
	mouse_filter = Control.MOUSE_FILTER_IGNORE


func _notification(what: int) -> void:
	if what == NOTIFICATION_RESIZED:
		queue_redraw()


func _rebuild_marks() -> void:
	var old: Array = []
	for c in get_children():
		if str(c.name).begins_with("Mark"):
			old.append(c)
	for c in old:
		remove_child(c)
		(c as Node).free()
	for e in events:
		var n := int(e["n"])
		var lab := Label.new()
		lab.name = "Mark%d" % n
		lab.text = str(n)
		lab.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		lab.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		lab.add_theme_font_override("font", UI.font("bold"))
		lab.add_theme_font_size_override("font_size", 11)
		lab.add_theme_color_override("font_color", Color.WHITE)
		lab.custom_minimum_size = Vector2(16, 16)
		lab.size = Vector2(16, 16)
		lab.mouse_filter = Control.MOUSE_FILTER_IGNORE
		add_child(lab)


func _draw() -> void:
	var g := _geom()
	if g.is_empty():
		return
	var font := UI.font("hand")
	var top: float = g["top"]
	var bottom: float = g["bottom"]
	var left: float = g["left"]
	var right: float = g["right"]
	var lo: float = g["lo"]
	var hi: float = g["hi"]
	var span := maxf(1.0, hi - lo)
	var xs: PackedFloat32Array = g["xs"]
	var ys: PackedFloat32Array = g["ys"]
	var n: int = g["n"]
	var pts: Array = g["pts"]
	for tick in _ticks(lo, hi):
		var tv: float = tick
		if absf(tv) < 0.5:
			continue
		var y: float = bottom - (tv - lo) / span * (bottom - top)
		draw_dashed_line(Vector2(left, y), Vector2(right, y), Color(UI.MUTED, 0.45), 1.0, 4.0)
		draw_string(font, Vector2(2, y + 4), _tick_text(tv), HORIZONTAL_ALIGNMENT_LEFT, -1, 12, UI.MUTED)
	var zy := bottom - (0.0 - lo) / span * (bottom - top)
	draw_dashed_line(Vector2(left, zy), Vector2(right, zy), UI.RED, 1.5, 6.0)
	draw_string(font, Vector2(2, zy + 4), "$0", HORIZONTAL_ALIGNMENT_LEFT, -1, 12, UI.RED)
	for i in n - 1:
		var a := Vector2(xs[i], ys[i])
		var b := Vector2(xs[i + 1], ys[i + 1])
		if bool(pts[i + 1]["ahead"]):
			draw_dashed_line(a, b, UI.GOLD, 3.0, 5.0)
		else:
			draw_line(a, b, UI.GOLD, 3.0, true)
	var today: int = g["today"]
	for i in n:
		draw_circle(Vector2(xs[i], ys[i]), 3.0 if i == today else 2.0, UI.GREEN if i == today else UI.GOLD)
	if today >= 0:
		draw_dashed_line(Vector2(xs[today], top), Vector2(xs[today], bottom), UI.FG, 1.0, 3.0)
		draw_arc(Vector2(xs[today], ys[today]), 8.0, 0, TAU, 24, UI.GREEN, 2.0)
		draw_circle(Vector2(xs[today], ys[today]), 3.5, UI.GREEN)
	for e in events:
		var i := int(e.get("i", -1))
		if i < 0 or i >= n:
			continue
		var at := Vector2(xs[i], ys[i])
		draw_circle(at, 8.0, UI.RED if bool(e.get("bill", false)) else UI.GREEN)
		var lab := get_node_or_null("Mark%d" % int(e["n"])) as Control
		if lab != null:
			lab.position = at - Vector2(8, 8)
	if today == 0:
		_week(font, xs[0], "W%d today" % int(pts[0]["w"]))
	elif today > 0:
		_week(font, xs[0], "W%d" % int(pts[0]["w"]))
		_week(font, xs[today], "W%d today" % int(pts[today]["w"]))
	if n > 1 and bool(pts[n - 1]["ahead"]):
		_week(font, xs[n - 1], "W%d" % int(pts[n - 1]["w"]))


func _geom() -> Dictionary:
	var pts: Array = []
	for p in points:
		pts.append({"c": int(p["c"]), "w": int(p["w"]), "ahead": false})
	for p in future:
		pts.append({"c": int(p.get("cash", p.get("c", 0))), "w": int(p["w"]), "ahead": true})
	if pts.is_empty() or size.x < 40.0 or size.y < 36.0:
		return {}
	var top := 14.0
	var bottom := size.y - 18.0
	var left := 46.0
	var right := size.x - 6.0
	var hi := 1000.0
	var lo := 0.0
	for p in pts:
		hi = maxf(hi, float(p["c"]))
		lo = minf(lo, float(p["c"]))
	var span := maxf(1.0, hi - lo)
	var n := pts.size()
	var xs := PackedFloat32Array()
	var ys := PackedFloat32Array()
	xs.resize(n)
	ys.resize(n)
	for i in n:
		xs[i] = left if n == 1 else left + (right - left) * float(i) / float(n - 1)
		ys[i] = bottom - (float(pts[i]["c"]) - lo) / span * (bottom - top)
	var today := -1
	for i in n:
		if not bool(pts[i]["ahead"]):
			today = i
	return {"pts": pts, "xs": xs, "ys": ys, "n": n, "top": top, "bottom": bottom, "left": left, "right": right,
		"lo": lo, "hi": hi, "today": today}


func _ticks(lo: float, hi: float) -> Array:
	var rough := maxf(hi - lo, 1.0) / 2.0
	var mag := pow(10.0, floor(log(rough) / log(10.0)))
	var err := rough / mag
	var nice := mag
	if err > 5.0:
		nice *= 5.0
	elif err > 2.0:
		nice *= 2.0
	var out: Array = []
	var v: float = floor(lo / nice) * nice
	var guard := 0
	while v <= hi + nice * 0.01 and guard < 6:
		if v >= lo - nice * 0.01 and absf(v) >= 0.5:
			out.append(v)
		v += nice
		guard += 1
	return out


func _tick_text(v: float) -> String:
	var n := int(round(v))
	if n == 0:
		return "$0"
	var sign := "-" if n < 0 else ""
	var a := absi(n)
	if a >= 1000 and a % 1000 == 0:
		return "%s$%dk" % [sign, a / 1000]
	return UI.money(n)


func _week(font: Font, x: float, text: String) -> void:
	draw_string(font, Vector2(x - 22.0, size.y - 2.0), text, HORIZONTAL_ALIGNMENT_LEFT, -1, 12, UI.MUTED)
