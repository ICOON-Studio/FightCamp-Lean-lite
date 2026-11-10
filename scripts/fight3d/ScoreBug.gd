extends Control
## The round box: ROUND n / total, the clock, exchanges won this round in red and blue, six dots,
## and the cards strip. The round-edge meter stays in the tree (HudBars still feeds it) but is not drawn:
## the two numbers and the dots are that read now.

const TV := preload("res://scripts/ui/TV.gd")
const WoodKit := preload("res://scripts/ui/WoodKit.gd")

const RED := Color("#e2483d")
const BLUE := Color("#3a7ce0")
const DARK := Color("#3a332c")
const GREY := Color("#2a241e")
const GREY_INK := Color("#7a6e60")

var view: Node
var _red: Label
var _blue: Label
var _dots: Array = []
var _card_row: HBoxContainer
var _chips: Array = []
var _cards_for := -1


static func attach(v: Node) -> Control:
	var bug := new()
	bug.name = "ScoreBug"
	bug.view = v
	v.add_child(bug)
	bug._mount()
	return bug


func _mount() -> void:
	anchor_left = 0.5
	anchor_right = 0.5
	anchor_top = 0.0
	anchor_bottom = 0.0
	offset_left = -320.0
	offset_right = 320.0
	offset_top = 0.0
	offset_bottom = 236.0
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	var wood := Panel.new()
	wood.mouse_filter = Control.MOUSE_FILTER_IGNORE
	wood.add_theme_stylebox_override("panel", WoodKit.slate(8, 8))
	_place(wood, 0, 0, 640, 170)
	add_child(wood)
	_red = _num(RED)
	_place(_red, 28, 16, 120, 136)
	add_child(_red)
	_blue = _num(BLUE)
	_place(_blue, 492, 16, 120, 136)
	add_child(_blue)
	var round_l := TV.label("", 24, WoodKit.SOFT, "bold")
	round_l.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	round_l.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	_place(round_l, 156, 8, 328, 32)
	add_child(round_l)
	view.set("_bug", round_l)
	var clock := TV.mono("", 58, WoodKit.INK)
	clock.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	clock.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	_place(clock, 156, 40, 328, 70)
	add_child(clock)
	view.set("_clock", clock)
	var dots := HBoxContainer.new()
	dots.alignment = BoxContainer.ALIGNMENT_CENTER
	dots.add_theme_constant_override("separation", 16)
	dots.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_place(dots, 196, 114, 248, 36)
	add_child(dots)
	for i in 6:
		var d := Dot.new()
		d.name = "Dot%d" % i
		d.custom_minimum_size = Vector2(28, 28)
		d.mouse_filter = Control.MOUSE_FILTER_IGNORE
		dots.add_child(d)
		_dots.append(d)
	_card_row = HBoxContainer.new()
	_card_row.alignment = BoxContainer.ALIGNMENT_CENTER
	_card_row.add_theme_constant_override("separation", 10)
	_card_row.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_place(_card_row, 80, 178, 480, 48)
	add_child(_card_row)
	var cap := TV.label("CARDS", 22, WoodKit.SOFT, "bold")
	_card_row.add_child(cap)
	view.set("_bug_box", self)


func _num(col: Color) -> Label:
	var l := TV.label("0", 72, col, "bold")
	l.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	l.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	l.mouse_filter = Control.MOUSE_FILTER_STOP
	l.tooltip_text = "Exchanges won this round"
	return l


func _process(_delta: float) -> void:
	if view == null or not is_instance_valid(view) or not visible:
		return
	if view.get("main") == null or int(view.get("round_n")) < 1:
		return
	_paint()


func _paint() -> void:
	var n := int(view.get("round_n"))
	var total := int(view.get("total"))
	var bug: Label = view.get("_bug")
	if bug != null:
		bug.text = "ROUND %d / %d" % [n, total]
	var ex: Array = view.call("_exchanges")
	var scored: Array = load("res://scripts/fight3d/FightHud.gd").scored(ex, float(view.get("t")))
	var red_n := 0
	var blue_n := 0
	for e in scored:
		if bool((e as Dictionary).get("won", false)):
			red_n += 1
		else:
			blue_n += 1
	_red.text = str(red_n)
	_blue.text = str(blue_n)
	for i in 6:
		var d: Dot = _dots[i]
		if i < scored.size():
			d.open = false
			d.fill = RED if bool((scored[i] as Dictionary).get("won", false)) else BLUE
		elif i == scored.size() and scored.size() < 6:
			d.open = true
			d.fill = Color("#f3ead8")
		else:
			d.open = false
			d.fill = DARK
		d.queue_redraw()
	_cards(n, total, red_n, blue_n)


func _cards(n: int, total: int, red_n: int, blue_n: int) -> void:
	if _cards_for != total:
		_cards_for = total
		for c in _chips:
			var old: Node = c
			if old.get_parent() != null:
				old.get_parent().remove_child(old)
			old.queue_free()
		_chips = []
		var wide := 56.0 if total <= 4 else maxf(36.0, 240.0 / float(maxi(total, 1)))
		for i in total:
			var chip := Chip.new()
			chip.custom_minimum_size = Vector2(wide, 40)
			chip.lab = TV.label("R%d" % (i + 1), 24, WoodKit.INK, "bold")
			chip.lab.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
			chip.lab.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
			chip.lab.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
			chip.lab.mouse_filter = Control.MOUSE_FILTER_IGNORE
			chip.add_child(chip.lab)
			_card_row.add_child(chip)
			_chips.append(chip)
	var main: Node = view.get("main")
	var m: Dictionary = main.get("modal")
	var rounds: Array = m.get("rounds", [])
	var lead := WoodKit.HEAD
	if red_n > blue_n:
		lead = RED
	elif blue_n > red_n:
		lead = BLUE
	for i in _chips.size():
		var chip: Chip = _chips[i]
		if i + 1 < n and i < rounds.size():
			var won := bool((rounds[i] as Dictionary).get("won", false))
			chip.kind = "closed"
			chip.col = RED if won else BLUE
			chip.lab.add_theme_color_override("font_color", WoodKit.INK)
		elif i + 1 == n:
			chip.kind = "live"
			chip.col = lead
			chip.lab.add_theme_color_override("font_color", lead)
		else:
			chip.kind = "future"
			chip.col = GREY
			chip.lab.add_theme_color_override("font_color", GREY_INK)
		chip.queue_redraw()


func _place(c: Control, x: float, y: float, w: float, h: float) -> void:
	c.anchor_left = 0.0
	c.anchor_top = 0.0
	c.anchor_right = 0.0
	c.anchor_bottom = 0.0
	c.offset_left = x
	c.offset_top = y
	c.offset_right = x + w
	c.offset_bottom = y + h


class Dot extends Control:
	var fill: Color = Color("#3a332c")
	var open := false

	func _draw() -> void:
		var c := size * 0.5
		var rad := 12.0
		if open:
			draw_arc(c, rad, 0.0, TAU, 32, Color("#f3ead8"), 4.0, true)
		else:
			draw_circle(c, rad, fill)


class Chip extends Control:
	var kind := "future"
	var col: Color = Color("#2a241e")
	var lab: Label

	func _draw() -> void:
		var r := Rect2(Vector2(1, 1), size - Vector2(2, 2))
		if kind == "live":
			draw_dashed_line(r.position, Vector2(r.end.x, r.position.y), col, 3.0, 6.0)
			draw_dashed_line(Vector2(r.end.x, r.position.y), r.end, col, 3.0, 6.0)
			draw_dashed_line(r.end, Vector2(r.position.x, r.end.y), col, 3.0, 6.0)
			draw_dashed_line(Vector2(r.position.x, r.end.y), r.position, col, 3.0, 6.0)
		else:
			draw_rect(r, col)
