extends Control
## S340 C157: her fight attributes as a marker shape on the whiteboard - one spoke per attribute, her values filled in the
## coach's blue, her potential as a dashed outline (the room she has to grow). The shape grows in when it is shown.
##   values = [{name, value}], pot = her potential (Data "pot")

const UI := preload("res://scripts/ui/UI.gd")
## The spokes run from FLOOR at the centre to TOP at the rim: amateurs sit 55-65, so a 0-100 scale would draw a dot.
const FLOOR := 25.0
const TOP := 90.0
const RINGS := [40.0, 55.0, 70.0, 85.0]
const LABEL_GAP := 18.0
## Room beside the rim for a spoke's label (the longest, "Conditioning 62", is ~95 px at TINY).
const LABEL_W := 100.0
const GROW_S := 0.45

var values: Array = []
var pot := 0.0
var grow := 1.0:
	set(v):
		grow = v
		queue_redraw()


func _init() -> void:
	custom_minimum_size = Vector2(500, 340)
	mouse_filter = Control.MOUSE_FILTER_IGNORE


func _ready() -> void:
	grow = 0.0
	create_tween().tween_property(self, "grow", 1.0, GROW_S).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)


static func frac(v: float) -> float:
	return clampf((v - FLOOR) / (TOP - FLOOR), 0.0, 1.0)


func _point(i: int, r: float) -> Vector2:
	var a := -PI * 0.5 + TAU * float(i) / float(values.size())
	return size * 0.5 + Vector2(cos(a), sin(a)) * r


func _ring(r: float) -> PackedVector2Array:
	var pts := PackedVector2Array()
	for i in values.size():
		pts.append(_point(i, r))
	pts.append(pts[0])
	return pts


func _draw() -> void:
	var n := values.size()
	if n < 3:
		return
	var font := UI.font("semi")
	var r := minf(size.x * 0.5 - LABEL_W, size.y * 0.5 - 30.0)
	for ring in RINGS:
		draw_polyline(_ring(r * frac(float(ring))), UI.ROWLINE, 1.0, true)
	for i in n:
		draw_line(size * 0.5, _point(i, r), UI.ROWLINE, 1.0, true)
	if pot > 0.0:
		var p := _ring(r * frac(pot))
		for i in n:
			draw_dashed_line(p[i], p[i + 1], UI.MUTED, 2.0, 7.0, true, true)
	var shape := PackedVector2Array()
	for i in n:
		shape.append(_point(i, r * frac(float(values[i]["value"])) * grow))
	var fill := UI.GOLD
	fill.a = 0.22
	draw_colored_polygon(shape, fill)
	shape.append(shape[0])
	draw_polyline(shape, UI.GOLD, 3.0, true)
	for i in n:
		draw_circle(shape[i], 4.0, UI.GOLD)
		var text := "%s %d" % [values[i]["name"], int(floorf(float(values[i]["value"])))]
		var ts := font.get_string_size(text, HORIZONTAL_ALIGNMENT_LEFT, -1, UI.TINY)
		var at := _point(i, r + LABEL_GAP)
		var dir := at - size * 0.5
		# Labels sit outside the rim: left of the centre they end at the spoke, right of it they start there.
		var x := at.x - ts.x * 0.5
		if dir.x > 4.0:
			x = at.x - 6.0
		elif dir.x < -4.0:
			x = at.x - ts.x + 6.0
		draw_string(font, Vector2(x, at.y + ts.y * 0.3), text, HORIZONTAL_ALIGNMENT_LEFT, -1, UI.TINY, UI.FG)
