extends Control
## The week's tiredness as one line (approach A, on the B page). Fourteen points: each morning and each
## night, 0-100. WeekBoard owns the column gap and passes it in, so the columns share x with the day tiles.
##   setup(points, selected_day, gap)   column_center(i) -> global x   night(dow) -> that night's point
##   peak   line_80 (the dashed line at 80 is drawn)

const UI := preload("res://scripts/ui/UI.gd")
const WoodKit := preload("res://scripts/ui/WoodKit.gd")
const Icons := preload("res://scripts/ui/Icons.gd")

var gap := 12.0
var points: Array = []
var peak := 0.0
var peak_at := 0
var selected := 0
var line_80 := false
var _tag: Label


func setup(pts: Array, sel: int, col_gap: float) -> void:
	points = pts
	selected = sel
	gap = col_gap
	peak = 0.0
	peak_at = 0
	for i in pts.size():
		var v := float(pts[i])
		if v >= peak:
			peak = v
			peak_at = i
	line_80 = true
	queue_redraw()


func column_center(i: int) -> float:
	var col := _col()
	return global_position.x + float(i) * (col + gap) + col * 0.5


func night(dow: int) -> float:
	var i := dow * 2 + 1
	return float(points[i]) if i >= 0 and i < points.size() else 0.0


func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	_tag = UI.label("80", 26, UI.RED, "bold")
	_tag.name = "Line80"
	_tag.tooltip_text = "From 80 a morning trains at 60%."
	var need := _tag.get_minimum_size()
	_tag.custom_minimum_size = need
	_tag.size = need
	add_child(_tag)
	var warn := Icons.icon("shield-alert", 26, UI.RED, "From 80 a morning trains at 60%.")
	warn.name = "Warn80"
	warn.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(warn)
	resized.connect(_place_tag)
	call_deferred("_place_tag")


func _place_tag() -> void:
	if _tag == null or size.y < 2.0:
		return
	var y := _y(80.0) - 16.0
	_tag.position = Vector2(34, y)
	var need := _tag.get_minimum_size()
	_tag.size = Vector2(maxf(need.x, 28.0), maxf(need.y, 28.0))
	var warn := get_node_or_null("Warn80") as Control
	if warn != null:
		warn.position = Vector2(4, y + 2.0)


func _notification(what: int) -> void:
	if what == NOTIFICATION_RESIZED:
		queue_redraw()


func _col() -> float:
	return maxf(1.0, (size.x - gap * 6.0) / 7.0)


func _y(v: float) -> float:
	var top := 28.0
	var bot := maxf(top + 10.0, size.y - 18.0)
	return bot - clampf(v, 0.0, 100.0) / 100.0 * (bot - top)


func _px(k: int) -> float:
	var col := _col()
	var day := float(k / 2)
	var at := 0.30 if k % 2 == 0 else 0.72
	return day * (col + gap) + col * at


func _draw() -> void:
	line_80 = true
	if size.x < 2.0 or points.size() < 2:
		return
	var col := _col()
	draw_rect(Rect2(float(selected) * (col + gap), 0, col, size.y), Color(WoodKit.HEAD, 0.10), true)
	for i in 7:
		var x := float(i) * (col + gap) + col * 0.5
		draw_line(Vector2(x, 8), Vector2(x, size.y - 4), Color(WoodKit.SOFT, 0.18), 1.0)
	var y80 := _y(80.0)
	var y_top := _y(100.0)
	for n in range(0, int(size.x / 12.0) + 6):
		var x0 := float(n) * 12.0 - 24.0
		draw_line(Vector2(x0, y80), Vector2(x0 + 22.0, y_top), Color(UI.RED, 0.40), 2.0)
	var x := 0.0
	while x < size.x:
		draw_line(Vector2(x, y80), Vector2(minf(x + 10.0, size.x), y80), UI.RED, 2.5)
		x += 16.0
	var raw: Array = []
	for k in points.size():
		raw.append(Vector2(_px(k), _y(float(points[k]))))
	var smooth := PackedVector2Array()
	for i in raw.size() - 1:
		var p0: Vector2 = raw[maxi(i - 1, 0)]
		var p1: Vector2 = raw[i]
		var p2: Vector2 = raw[i + 1]
		var p3: Vector2 = raw[mini(i + 2, raw.size() - 1)]
		for s in 8:
			smooth.append(_catmull(p0, p1, p2, p3, float(s) / 8.0))
	smooth.append(raw[raw.size() - 1])
	var fill := smooth.duplicate()
	var base := _y(0.0)
	fill.append(Vector2(smooth[smooth.size() - 1].x, base))
	fill.append(Vector2(smooth[0].x, base))
	draw_colored_polygon(fill, Color(UI.AMBER, 0.30))
	draw_polyline(smooth, WoodKit.INK, 3.5, true)
	for k in points.size():
		draw_circle(raw[k], 4.5, WoodKit.INK)
	_peak_box(raw[peak_at])


func _peak_box(at: Vector2) -> void:
	var font := UI.font("bold")
	var txt := str(roundi(peak))
	var ts := font.get_string_size(txt, HORIZONTAL_ALIGNMENT_LEFT, -1, 28)
	var box := Rect2(at + Vector2(10, -ts.y - 10), ts + Vector2(14, 10))
	if box.end.x > size.x - 4.0:
		box.position.x = at.x - box.size.x - 8.0
	draw_rect(box, Color(0.08, 0.07, 0.06, 0.92), true)
	draw_rect(box, WoodKit.HEAD, false, 2.0)
	draw_string(font, Vector2(box.position.x + 7.0, box.position.y + ts.y + 1.0), txt, HORIZONTAL_ALIGNMENT_LEFT, -1, 28, WoodKit.INK)


func _catmull(p0: Vector2, p1: Vector2, p2: Vector2, p3: Vector2, t: float) -> Vector2:
	var t2 := t * t
	var t3 := t2 * t
	return 0.5 * ((2.0 * p1) + (-p0 + p2) * t + (2.0 * p0 - 5.0 * p1 + 4.0 * p2 - p3) * t2 + (-p0 + 3.0 * p1 - 3.0 * p2 + p3) * t3)
