extends Control
## The week's tiredness, labelled. Fourteen points, morning then evening, 0-100. Each evening number sits on
## that day's tile (the tile rects, not a hard-coded column). The line at 80 is named. Hover a column for both numbers.
##   setup(points, selected_day, gap)   column_center(i) -> global x   night(dow)   danger_y() -> global y of the line
##   peak   line_80

const UI := preload("res://scripts/ui/UI.gd")
const WoodKit := preload("res://scripts/ui/WoodKit.gd")
const Icons := preload("res://scripts/ui/Icons.gd")
const WeekPlan := preload("res://scripts/rules/WeekPlan.gd")
## The tiredness rule's own line (WeekPlan.OVERREACHED, an estimate to playtest) and what it does to a morning.
const LINE := WeekPlan.OVERREACHED
const PLATE := Color(0.08, 0.07, 0.06, 0.92)

const DAYS := ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
const TOP := 50.0

var gap := 12.0
var points: Array = []
var peak := 0.0
var peak_at := 0
var selected := 0
var line_80 := false
var _title: Label
var _peak: Label
var _danger: Label
var _under: Label
var _hover: Label
var _nums: Array = []
var _passes := 0
var _spins := 0


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
	if is_node_ready():
		_sync_text()
		_place()
	queue_redraw()


func column_center(i: int) -> float:
	var t := _day_tile(i)
	if t != null and t.size.x > 2.0:
		return t.get_global_rect().get_center().x
	var col := _col()
	return global_position.x + float(i) * (col + gap) + col * 0.5


func night(dow: int) -> float:
	var i := dow * 2 + 1
	return float(points[i]) if i >= 0 and i < points.size() else 0.0


func danger_y() -> float:
	return global_position.y + _y(LINE)


func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_STOP
	mouse_default_cursor_shape = Control.CURSOR_ARROW
	size_flags_vertical = Control.SIZE_SHRINK_BEGIN
	if custom_minimum_size.y < 2.0:
		custom_minimum_size.y = 220
	custom_minimum_size.y = minf(custom_minimum_size.y, 230)
	_title = _lab("Tiredness this week", 28, WoodKit.HEAD, "TiredTitle")
	_peak = _lab("", 26, WoodKit.INK, "TiredPeak")
	_danger = _lab("%d: too tired, injuries rise" % int(LINE), 22, UI.RED, "DangerLine")
	_under = _lab("", 22, WoodKit.SOFT, "UnderLine")
	_hover = _lab("", 22, WoodKit.INK, "HoverRead")
	_hover.visible = false
	for i in 7:
		var n := _lab("0", 22, WoodKit.INK, "DayNum_%d" % i)
		_nums.append(n)
	var warn := Icons.icon("shield-alert", 26, UI.RED, "")
	warn.name = "Warn80"
	warn.mouse_filter = Control.MOUSE_FILTER_IGNORE
	warn.size = Vector2(26, 26)
	add_child(warn)
	_sync_text()
	resized.connect(_on_resized)
	set_process(true)


func _lab(text: String, px: int, color: Color, node_name: String) -> Label:
	var l := UI.label(text, px, color, "bold")
	l.name = node_name
	l.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(l)
	return l


func _on_resized() -> void:
	_passes = 0
	_spins = 0
	set_process(true)


func _process(_dt: float) -> void:
	_spins += 1
	if _spins > 30:
		set_process(false)
		return
	if size.y < 2.0:
		return
	var tile := _day_tile(0)
	if tile == null or tile.size.x < 2.0:
		return
	_place()
	_passes += 1
	if _passes >= 2:
		set_process(false)


func _sync_text() -> void:
	if _title == null:
		return
	_peak.text = _peak_line()
	var gap_n := ceili(LINE - peak)
	_under.text = "%d under the line" % maxi(gap_n, 0)
	_under.visible = not _reaches_80()
	for i in 7:
		var l := _nums[i] as Label
		var v := night(i)
		l.text = str(floori(v))
		l.add_theme_color_override("font_color", UI.RED if v >= LINE else WoodKit.INK)


func _peak_line() -> String:
	if points.is_empty():
		return "peaks at 0"
	var day := clampi(int(peak_at / 2), 0, 6)
	var when := "evening" if peak_at % 2 == 1 else "morning"
	return "peaks %s %s at %d" % [DAYS[day], when, floori(peak)]


func _reaches_80() -> bool:
	for p in points:
		if float(p) >= LINE:
			return true
	return false


func _read(i: int) -> String:
	var am := 0
	var idx := i * 2
	if idx >= 0 and idx < points.size():
		am = floori(float(points[idx]))
	return "Morning %d, evening %d
From %d a morning trains at %d%%" % [am, floori(night(i)), int(LINE), roundi(WeekPlan.TIRED_GAIN * 100.0)]


func _place() -> void:
	if _title == null or size.y < 2.0:
		return
	_sync_text()
	_fit(_title)
	_title.position = Vector2(8, 4)
	_fit(_peak)
	_peak.position = Vector2(_title.position.x + _title.size.x + 16, _title.position.y + (_title.size.y - _peak.size.y) * 0.5)
	var y := _y(LINE)
	var warn := get_node_or_null("Warn80") as Control
	if warn != null:
		warn.size = Vector2(26, 26)
		warn.position = Vector2(8, y - 13.0)
	_fit(_danger)
	_danger.position = Vector2(40, y - _danger.size.y - 4.0)   # just over the dashes: never struck through, never over the curve
	if _under.visible:
		_fit(_under)
		_under.position = Vector2(size.x - _under.size.x - 10, y - _under.size.y - 4.0)
		if _hits(_under, [_danger, _title, _peak]):
			_under.position = Vector2(size.x - _under.size.x - 10, 4)
	var blockers: Array = [_title, _peak, _danger, _under]   # plated labels still keep numbers off them
	var placed: Array = []
	for i in 7:
		_place_num(i, blockers + placed)
		placed.append(_nums[i])
	_hover.visible = false
	queue_redraw()


func _place_num(i: int, blocks: Array) -> void:
	var l := _nums[i] as Label
	_fit(l)
	var box := _col_box(i)
	var cx := box.position.x + box.size.x * 0.5
	var cy := _y(night(i))
	l.position = Vector2(cx - l.size.x * 0.5, cy - l.size.y - 8.0)
	var above := night(i) >= LINE
	var y80 := _y(LINE)
	if not above and l.position.y + l.size.y * 0.5 < y80:
		l.position.y = cy + 8.0   # just under the line: above the dot would read as over it
	if not _hits(l, blocks):
		return
	var home := l.position.y
	for dir in [-1.0, 1.0]:
		for step in 18:
			l.position.y = home + dir * float(step + 1) * 4.0
			if l.position.y < 2.0 or l.position.y + l.size.y > size.y - 2.0:
				continue
			if (l.position.y + l.size.y * 0.5 < y80) != above and absf(cy - y80) > 2.0:
				continue   # a number never crosses the 80 line to the wrong side of it
			if not _hits(l, blocks):
				return
	l.position.y = home


func _fit(l: Label) -> void:
	var s := l.get_minimum_size()
	if s.x < 4.0 or s.y < 4.0:
		var font := l.get_theme_font("font")
		var px := l.get_theme_font_size("font_size")
		var ts := font.get_string_size(l.text, HORIZONTAL_ALIGNMENT_LEFT, -1, px)
		s = Vector2(ceil(ts.x) + 2.0, ceil(maxf(ts.y, float(px))) + 4.0)
	l.custom_minimum_size = s
	l.size = s


func _hits(a: Control, nodes: Array) -> bool:
	if a == null or not a.visible:
		return false
	var ra := a.get_rect()
	for n in nodes:
		var b := n as Control
		if b == null or b == a or not b.visible:
			continue
		var rb := b.get_rect()
		if not ra.intersects(rb):
			continue
		var inter := ra.intersection(rb)
		if inter.size.x > 3.0 and inter.size.y > 3.0:
			return true
	return false


func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and points.size() >= 2:
		_show_hover(_day_at(event.position.x), event.position)


func _notification(what: int) -> void:
	if what == NOTIFICATION_RESIZED:
		queue_redraw()
	elif what == NOTIFICATION_MOUSE_EXIT and _hover != null:
		_hover.visible = false
		queue_redraw()


func _show_hover(i: int, at: Vector2) -> void:
	_hover.text = _read(i)
	_hover.visible = true
	_fit(_hover)
	var x := clampf(at.x + 12.0, 4.0, maxf(4.0, size.x - _hover.size.x - 4.0))
	var y := clampf(at.y - _hover.size.y - 8.0, _title.size.y + 6.0, maxf(_title.size.y + 6.0, size.y - _hover.size.y - 4.0))
	_hover.position = Vector2(x, y)
	if _hits(_hover, [_title, _peak, _danger, _under] + _nums):
		_hover.position.y = size.y - _hover.size.y - 4.0
	queue_redraw()


func _day_at(x: float) -> int:
	var best := 0
	var bd := 100000.0
	for i in 7:
		var d := absf(x - _col_box(i).get_center().x)
		if d < bd:
			bd = d
			best = i
	return best


func _day_tile(i: int) -> Control:
	var node_name := "DayTile_%d" % i
	var n: Node = self
	while n != null:
		var hit := n.find_child(node_name, true, false) as Control
		if hit != null and hit != self and hit.is_visible_in_tree():
			return hit
		n = n.get_parent()
	return null


func _col_box(i: int) -> Rect2:
	var t := _day_tile(i)
	if t != null and t.size.x > 2.0 and size.x > 2.0:
		var g := t.get_global_rect()
		return Rect2(g.position.x - global_position.x, 0, g.size.x, size.y)
	var col := _col()
	return Rect2(float(i) * (col + gap), 0, col, size.y)


func _col() -> float:
	return maxf(1.0, (size.x - gap * 6.0) / 7.0)


func _y(v: float) -> float:
	var bot := maxf(TOP + 10.0, size.y - 12.0)
	return bot - clampf(v, 0.0, 100.0) / 100.0 * (bot - TOP)


func _px(k: int) -> float:
	var box := _col_box(int(k / 2))
	var at := 0.32 if k % 2 == 0 else 0.50
	return box.position.x + box.size.x * at


func _draw() -> void:
	line_80 = true
	if size.x < 2.0 or points.size() < 2:
		return
	var lit := _col_box(selected)
	draw_rect(Rect2(lit.position.x, 0, lit.size.x, size.y), Color(WoodKit.HEAD, 0.16), true)
	for i in 7:
		var mid := _col_box(i).get_center().x
		draw_line(Vector2(mid, TOP), Vector2(mid, size.y - 6), Color(WoodKit.SOFT, 0.18), 1.0)
	var y80 := _y(LINE)
	var y_top := _y(100.0)
	for n in range(0, int(size.x / 14.0) + 4):
		var x0 := float(n) * 14.0 - 20.0
		draw_line(Vector2(x0, y80), Vector2(x0 + 18.0, y_top), Color(UI.RED, 0.28), 2.0)
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
		var hot := float(points[k]) >= LINE
		draw_circle(raw[k], 5.5 if hot else 4.5, UI.RED if hot else WoodKit.INK)
	# dark plates under every word the curve or the dashes cross (labels draw over the parent's _draw)
	for l in [_danger, _under, _hover] + _nums:
		var c := l as Control
		if c != null and c.visible:
			draw_rect(c.get_rect().grow(3.0), PLATE, true)


func _catmull(p0: Vector2, p1: Vector2, p2: Vector2, p3: Vector2, t: float) -> Vector2:
	var t2 := t * t
	var t3 := t2 * t
	return 0.5 * ((2.0 * p1) + (-p0 + p2) * t + (2.0 * p0 - 5.0 * p1 + 4.0 * p2 - p3) * t2 + (-p0 + 3.0 * p1 - 3.0 * p2 + p3) * t3)
