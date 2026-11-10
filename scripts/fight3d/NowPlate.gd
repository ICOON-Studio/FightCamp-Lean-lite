extends Button
## The gold NOW plate beside the opponent, only while a set-up gap is open. A click is the shout "now".
## The countdown reads the shout window's real-seconds counter (ShoutBar._left) so it stays with the bar at 2x.

const TV := preload("res://scripts/ui/TV.gd")
const WoodKit := preload("res://scripts/ui/WoodKit.gd")
const Halo := preload("res://scripts/ui/Halo.gd")
const Combos := preload("res://scripts/rules/Combos.gd")

const DIGIT := {
	"jab": "1", "cross": "2", "lead hook": "3", "rear hook": "4",
	"lead uppercut": "5", "rear uppercut": "6", "uppercut": "6",
}

var view: Node
var _title: Label
var _gap: Label
var _count: Label
var _cost: Label
var _left := -1.0
var _window := false
var _real := 0.0


func setup(v: Node) -> void:
	view = v
	name = "NowPlate"
	focus_mode = Control.FOCUS_NONE
	mouse_filter = Control.MOUSE_FILTER_STOP
	z_index = 20
	anchor_left = 0.0
	anchor_top = 0.0
	anchor_right = 0.0
	anchor_bottom = 0.0
	offset_left = 1180.0
	offset_top = 640.0
	offset_right = 1510.0
	offset_bottom = 760.0
	var plate := StyleBoxFlat.new()
	plate.bg_color = Color("#3e2a12")
	plate.border_color = Color("#6b5338")
	plate.set_border_width_all(3)
	plate.set_corner_radius_all(14)
	plate.content_margin_left = 12
	plate.content_margin_right = 12
	plate.content_margin_top = 8
	plate.content_margin_bottom = 8
	add_theme_stylebox_override("normal", plate)
	add_theme_stylebox_override("hover", plate)
	add_theme_stylebox_override("pressed", plate)
	add_theme_stylebox_override("focus", StyleBoxEmpty.new())
	add_theme_font_size_override("font_size", 22)
	Halo.ring(self, WoodKit.HEAD, 14.0)
	var box := VBoxContainer.new()
	box.mouse_filter = Control.MOUSE_FILTER_IGNORE
	box.alignment = BoxContainer.ALIGNMENT_CENTER
	box.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(box)
	_title = TV.label("NOW!", 40, WoodKit.HEAD, "bold")
	_title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	box.add_child(_title)
	var row := HBoxContainer.new()
	row.alignment = BoxContainer.ALIGNMENT_CENTER
	row.add_theme_constant_override("separation", 10)
	row.mouse_filter = Control.MOUSE_FILTER_IGNORE
	box.add_child(row)
	_gap = TV.label("gap open", 22, WoodKit.INK, "bold")
	row.add_child(_gap)
	_count = TV.label("", 22, WoodKit.HEAD, "bold")
	row.add_child(_count)
	_cost = TV.label("", 22, WoodKit.HEAD, "bold")
	row.add_child(_cost)
	visible = false
	pressed.connect(_fire)


## now = preview()["now"]. left is the pick window's seconds, or -1 when the window is shut.
func show_offer(now: Dictionary, left: float, window: bool) -> void:
	_left = left
	_window = window
	visible = not now.is_empty()
	if now.is_empty():
		return
	var id := str(now.get("combo", ""))
	_title.text = "NOW! " + digits(id)
	_gap.text = "gap open"
	if window and left >= 0.0:
		var secs := int(ceil(maxf(0.0, left)))
		_count.text = "%d:%02d" % [secs / 60, secs % 60]
	else:
		_count.text = ""
	_cost.text = arrows(cost_of(id))


func _fire() -> void:
	if view == null:
		return
	var w: Node = view.get("_shouting")
	if w == null or bool(w.get("_done")):
		return
	w.call("_pick", "now")


func _process(delta: float) -> void:
	if not visible:
		return
	_real += delta / maxf(0.05, Engine.time_scale)
	var phase := _left if _window else _real
	modulate.a = 0.82 + 0.18 * sin(phase * TAU)


static func digits(id: String) -> String:
	var moves: Array = Combos.row(id).get("moves", [])
	if moves.is_empty():
		return id
	var parts: PackedStringArray = PackedStringArray()
	for m in moves:
		var key := str(m).to_lower()
		if DIGIT.has(key):
			parts.append(str(DIGIT[key]))
		else:
			parts.append(str(m))
	return "-".join(parts)


## Energy the combination costs (Combos.combo_cost). preview()["now"] has no cost of its own.
static func cost_of(id: String) -> float:
	var moves: Array = Combos.row(id).get("moves", [])
	return Combos.combo_cost(maxi(moves.size(), 1))


## What the combination costs her, in words (operator S426 on the bolt and arrows: "what are these symbols ??").
## One step per 0.75 of cost, at most three.
static func arrows(cost: float) -> String:
	if cost <= 0.0:
		return "Rests"
	var n := clampi(int(floor(cost / 0.75 + 0.001)), 1, 3)
	return ["Tires a little", "Tires", "Tires a lot"][n - 1]
