extends Control
## S379 the Grappling theatre's timeline: one block per move (width = its time, its name inside), a small amber tick on
## every join between two moves (where a pop would show - the operator can jump straight there), the playhead, and a
## click or drag anywhere seeks. `seek` is emitted with theatre seconds.

signal seek(t: float)

const BG := Color("#171b21")
const BLOCK := [Color("#232a33"), Color("#2b333d")]
const NOW := Color("#2f6fdb")
const TEXT := Color("#d9e0e7")
const DIM := Color("#8f9aa6")
const TICK := Color("#ffb020")
const HEAD := Color("#ffffff")

var steps: Array = []   # [{name, t0, t1}] theatre seconds
var joins: Array = []   # theatre seconds
var total := 1.0
var now := 0.0
var current := -1
var font: Font
var font_size := 15


func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_STOP
	if custom_minimum_size.y < 1.0:
		custom_minimum_size = Vector2(0, 46)


func setup(step_rows: Array, join_times: Array, total_s: float) -> void:
	steps = step_rows
	joins = join_times
	total = maxf(0.01, total_s)
	queue_redraw()


func set_now(t: float, step_index: int) -> void:
	now = t
	current = step_index
	queue_redraw()


func x_of(t: float) -> float:
	return clampf(t / total, 0.0, 1.0) * size.x


func _gui_input(event: InputEvent) -> void:
	var press := event is InputEventMouseButton and (event as InputEventMouseButton).pressed \
		and (event as InputEventMouseButton).button_index == MOUSE_BUTTON_LEFT
	var drag := event is InputEventMouseMotion and ((event as InputEventMouseMotion).button_mask & MOUSE_BUTTON_MASK_LEFT) != 0
	if press or drag:
		seek.emit(clampf((event as InputEventMouse).position.x / maxf(1.0, size.x), 0.0, 1.0) * total)
		accept_event()


func _draw() -> void:
	var h := size.y
	draw_rect(Rect2(Vector2.ZERO, size), BG)
	var top := 10.0
	for i in steps.size():
		var x0 := x_of(float(steps[i]["t0"]))
		var x1 := x_of(float(steps[i]["t1"]))
		var r := Rect2(x0 + 1.0, top, maxf(1.0, x1 - x0 - 2.0), h - top - 4.0)
		draw_rect(r, NOW.darkened(0.35) if i == current else BLOCK[i % 2])
		if font != null and r.size.x > 24.0:
			var label := str(steps[i]["name"])
			var w := r.size.x - 10.0
			while label.length() > 1 and font.get_string_size(label, HORIZONTAL_ALIGNMENT_LEFT, -1, font_size).x > w:
				label = label.substr(0, label.length() - 2) + "."
			draw_string(font, Vector2(r.position.x + 5.0, r.position.y + r.size.y * 0.5 + font_size * 0.35), label,
				HORIZONTAL_ALIGNMENT_LEFT, -1, font_size, TEXT if i == current else DIM)
	# Joins: a tick through the strip and a small triangle on top.
	for t in joins:
		var x := x_of(float(t))
		draw_line(Vector2(x, top - 2.0), Vector2(x, h - 2.0), TICK, 2.0)
		draw_colored_polygon(PackedVector2Array([Vector2(x - 5.0, 1.0), Vector2(x + 5.0, 1.0), Vector2(x, top - 1.0)]), TICK)
	var px := x_of(now)
	draw_line(Vector2(px, 0.0), Vector2(px, h), HEAD, 2.0)
	draw_circle(Vector2(px, h - 3.0), 4.0, HEAD)
