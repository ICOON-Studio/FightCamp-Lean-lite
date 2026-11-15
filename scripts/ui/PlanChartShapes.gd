extends RefCounted
## S482 PLANFLOW1: the plan chart's drawn shapes (PlanChart), kept apart for the 500-line rule.
##   Shapes.Wires.new() - curves from the bell box to each diamond, arrows from a diamond to its answer
##   Shapes.steps() - the SET IT UP panel: four clicks a line
##   Shapes.stamp(fighter, move_id) - the FireLevel chip (combinations and steps), or null
##   Shapes.Diamond.new() - an IF (dashed = the "+ Add an IF" slot); on_click is called on a left click


const UI := preload("res://scripts/ui/UI.gd")
const SM := preload("res://scripts/rules/StrikeMap.gd")
const FireLevel := preload("res://scripts/rules/FireLevel.gd")
const StepMastery := preload("res://scripts/rules/StepMastery.gd")


## The SET IT UP panel's four steps (his Q-240: the setup in four clicks).
static func steps() -> Control:
	var v := UI.vbox(12)
	v.add_child(UI.caps("SET IT UP: FOUR CLICKS A LINE"))
	var rows := [["The bell box first.", "Pick what your boxer does at each range when nothing special is happening. Most of the fight runs on it."],
		["+ Add an IF.", "The list is the opponent's file: what film found comes first."],
		["Click the empty answer", "beside the new diamond: the answers that beat that moment come first, each with how well it is drilled."],
		["Test it", "on a sparring night, or just box. Clear a line from its answer list."]]
	for n in rows.size():
		var row := UI.hbox(10)
		var num := UI.label(str(n + 1), UI.BODY, UI.GOLD, "bold")
		num.custom_minimum_size = Vector2(22, 0)
		row.add_child(num)
		var words := UI.vbox(0)
		words.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		words.add_child(UI.label(str(rows[n][0]), UI.SMALL, UI.FG, "bold", true))
		words.add_child(UI.muted(str(rows[n][1]), UI.TINY, true))
		row.add_child(words)
		v.add_child(row)
	v.add_child(UI.muted("Or start from Your coach rewrites it or Start from last bout, then change one line.", UI.TINY, true))
	return v


## Whether a planned line can fire at all (FireLevel: under Usable it never does).
static func fires(f: Dictionary, mid: String) -> bool:
	return FireLevel.mastery_of(f, mid) >= FireLevel.USABLE_AT


## How drilled the answer is, the fire rule's words (FireLevel): combinations and steps only - a single punch always fires.
static func stamp(f: Dictionary, mid: String) -> Control:
	if mid == "":
		return null
	var row := SM.move(mid)
	if str(row.get("kind", "")) != "combo" and not StepMastery.NODES.has(mid.split("@")[0]):
		return null
	var m := FireLevel.mastery_of(f, mid)
	if m >= FireLevel.SIGNATURE_AT:
		return UI.chip("SIGNATURE", "green")
	if m >= FireLevel.SHARP_AT:
		return UI.chip("SHARP", "green")
	if m >= FireLevel.USABLE_AT:
		return UI.chip("USABLE", "")
	return UI.chip("LEARNING", "amber")


## The chart's wires: a curve from the bell box to each diamond, an arrow from each diamond to its answer.
class Wires extends Control:
	var colour := Color.BLUE
	var curves: Array = []   # [from, to, dashed]
	var arrows: Array = []   # [from, to]

	func _ready() -> void:
		mouse_filter = Control.MOUSE_FILTER_IGNORE

	func _draw() -> void:
		for c in curves:
			var a: Vector2 = c[0]
			var b: Vector2 = c[1]
			var pts := PackedVector2Array()
			for k in 25:
				var t := k / 24.0
				var c1 := Vector2(a.x + (b.x - a.x) * 0.5, a.y)
				var c2 := Vector2(a.x + (b.x - a.x) * 0.5, b.y)
				pts.append(a.bezier_interpolate(c1, c2, b, t))
			var col := colour
			if bool(c[2]):
				col.a = 0.45
			draw_polyline(pts, col, 2.5, true)
			_head(b, col)
		for w in arrows:
			draw_line(w[0], w[1] - Vector2(4, 0), colour, 2.5, true)
			_head(w[1], colour)

	func _head(tip: Vector2, col: Color) -> void:
		draw_colored_polygon(PackedVector2Array([tip, tip + Vector2(-14, -8), tip + Vector2(-14, 8)]), col)


## A diamond (the IF). Dashed = the "+ Add an IF" slot. Clicking it calls on_click.
class Diamond extends Control:
	var fill := Color.WHITE
	var edge := Color.BLUE
	var dashed := false
	var on_click: Callable

	func _ready() -> void:
		mouse_filter = Control.MOUSE_FILTER_STOP
		mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND

	func _gui_input(e: InputEvent) -> void:
		if e is InputEventMouseButton and e.pressed and e.button_index == MOUSE_BUTTON_LEFT and on_click.is_valid():
			on_click.call()
			accept_event()

	func _draw() -> void:
		var s := size
		var pts := PackedVector2Array([Vector2(s.x / 2, 0), Vector2(s.x, s.y / 2), Vector2(s.x / 2, s.y), Vector2(0, s.y / 2)])
		draw_colored_polygon(pts, Color.WHITE if not dashed else fill)
		pts.append(pts[0])
		if dashed:
			for k in 4:
				draw_dashed_line(pts[k], pts[k + 1], edge, 2.0, 8.0, true)
		else:
			draw_polyline(pts, edge, 2.5, true)
