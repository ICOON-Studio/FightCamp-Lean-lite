extends Control
## S442 LOOP corner cards (CornerSwapCards): the hover line from a swap card to the lost line's place on the ring strip
## (the place opens a second line "C → Double jab"), and the cards' worth bar.

const Halo := preload("res://scripts/ui/Halo.gd")
const POOR := Color("#e06060")


var pin_name := ""
var _from: Control = null
var _to: Control = null

func _init() -> void:
	name = "SwapLink"
	top_level = true
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	z_index = 5

func point(from: Control, to: Control, words: String) -> void:
	_from = from
	_to = to
	if to != null and is_instance_valid(to):
		var said := to.find_child("Said", true, false) as Label
		if said != null:
			said.text = words
			said.visible = words != ""
		var sb := to.get_theme_stylebox("panel") as StyleBoxFlat
		if sb != null:
			sb.border_color = Halo.CHALK if words != "" else Color("#3a2e26")
	position = Vector2.ZERO
	size = get_viewport_rect().size if is_inside_tree() else Vector2.ZERO
	queue_redraw()

func _draw() -> void:
	if _from == null or _to == null or not is_instance_valid(_from) or not is_instance_valid(_to):
		return
	var a := _from.get_global_rect()
	var pin := _to.find_child(pin_name, true, false) as Control
	var b := (pin if pin != null else _to).get_global_rect()
	var start := Vector2(a.position.x + 40.0, a.end.y)
	var end := Vector2(b.get_center().x, b.position.y)
	draw_dashed_line(start, end, Halo.CHALK, 3.0, 8.0)
	draw_circle(end, 5.0, Halo.CHALK)


## The worth bar: the plan's own scale (PlanFight.EDGE, -7..+9), filled from the lost line's tick to the option.
class WorthBar extends Control:
	var was := 0.0
	var worth := 0.0
	var fill := Color.WHITE

	func _x(v: float) -> float:
		return clampf((v + 7.0) / 16.0, 0.0, 1.0) * size.x

	func _draw() -> void:
		draw_rect(Rect2(Vector2.ZERO, size), Color("#2e2520"))
		var a := _x(was)
		draw_rect(Rect2(a, 0, maxf(2.0, _x(worth) - a), size.y), fill)
		draw_rect(Rect2(a - 2.0, -5.0, 4.0, size.y + 10.0), POOR)
