extends RefCounted
## S496 split out of WeekCards.gd (552 lines, over the 500-line rule): the week popovers' parts - the segment row
## (Light | Normal | Hard, Rest | Pads | Sparring), a popover row, and the floating popover frame (Pop).
##   segments(...)  pop_row(...)  pop(name, title, body, on_close) -> Pop

const Palette := preload("res://scripts/ui/Palette.gd")
const UI := preload("res://scripts/ui/UI.gd")
const WoodKit := preload("res://scripts/ui/WoodKit.gd")
const WeekCards := preload("res://scripts/ui/WeekCards.gd")

const BLUE := WeekCards.BLUE


## A segment row (Light | Normal | Hard, Rest | Pads | Sparring): the chosen one filled blue; one click sets it.
static func segments(prefix: String, words: Array, keys: Array, on: String, pick: Callable, ghost := Callable(), off := false) -> HBoxContainer:
	var row := UI.hbox(0)
	row.name = prefix + "Row"
	for n in words.size():
		var b := Button.new()
		b.name = "%s_%s" % [prefix, str(keys[n])]
		b.text = str(words[n])
		b.focus_mode = Control.FOCUS_NONE
		b.disabled = off
		b.custom_minimum_size = Vector2(0, 32)
		b.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		b.add_theme_font_override("font", UI.font("semi"))
		b.add_theme_font_size_override("font_size", 16)
		var lit := str(keys[n]) == on
		for c in ["font_color", "font_hover_color", "font_pressed_color"]:
			b.add_theme_color_override(c, WoodKit.INK)
		b.add_theme_color_override("font_disabled_color", WoodKit.SOFT)
		for st in ["normal", "hover", "pressed", "focus", "disabled"]:
			var hot: bool = st == "hover" and not lit
			var bg := Color(BLUE, 0.95) if lit else Color(Palette.TEXT, 0.08 if hot else 0.04)
			var edge := Color(WoodKit.HEAD if lit else (WoodKit.BLUE if hot else WoodKit.SOFT), 1.0 if lit or hot else 0.35)
			b.add_theme_stylebox_override(st, UI.box(bg, edge, 0, 2 if lit else 1, 0, 0))
		var key := str(keys[n])
		b.pressed.connect(func(): pick.call(key))
		if ghost.is_valid():
			b.mouse_entered.connect(func(): ghost.call(key))
			b.mouse_exited.connect(func(): ghost.call(""))
		row.add_child(b)
	return row


## A popover row: tile, name, and on the right its gain over its tiredness.
static func pop_row(name: String, key: String, title: String, gain: String, cost: String, on: bool, pick: Callable,
		ghost := Callable(), goal_key := "") -> Button:
	var b := Button.new()
	b.name = name
	b.focus_mode = Control.FOCUS_NONE
	b.custom_minimum_size = Vector2(0, 44)
	for st in ["normal", "hover", "pressed", "focus"]:
		var hot: bool = st == "hover" and not on
		var edge := Color(WoodKit.HEAD if on else (WoodKit.BLUE if hot else WoodKit.SOFT), 1.0 if on or hot else 0.35)
		b.add_theme_stylebox_override(st, UI.box(Color(Palette.TEXT, 0.04), edge, 4, 2 if on else 1, 0, 0))
	b.pressed.connect(pick)
	if ghost.is_valid():
		b.mouse_entered.connect(func(): ghost.call(true))
		b.mouse_exited.connect(func(): ghost.call(false))
	var h := UI.hbox(10)
	h.mouse_filter = Control.MOUSE_FILTER_IGNORE
	WeekCards.fill(b, h)
	h.add_child(tile(key, 30))
	var t := UI.label(title, 16, UI.FG, "bold")
	t.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	t.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	h.add_child(t)
	if goal_key != "" and key == goal_key:   # S398 critics: the goal's mark in the popover too
		var dot := ColorRect.new()
		dot.color = Palette.HEADER
		dot.custom_minimum_size = Vector2(9, 9)
		dot.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		dot.mouse_filter = Control.MOUSE_FILTER_IGNORE
		h.add_child(dot)
	var r := UI.vbox(0)
	r.mouse_filter = Control.MOUSE_FILTER_IGNORE
	r.add_child(UI.label(gain, 14, UI.FG, "body"))
	r.add_child(UI.label(cost, 13, UI.MUTED, "body"))
	for l in r.get_children():
		(l as Label).horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	h.add_child(r)
	return b


## The popover's frame: a title ("Wednesday morning"), "Esc to close", then the body. Floats over the board (top_level),
## placed beside its card by WeekBoard once the page is laid out.
static func pop(name: String, title: String, body: Control, on_close: Callable) -> Pop:
	var p := Pop.new()
	p.name = name
	p.on_close = on_close
	var v := UI.vbox(8)
	p.add_child(v)
	var h := UI.hbox(8)
	h.add_child(UI.label(title, 17, UI.FG, "bold"))
	h.add_child(UI.spacer())
	h.add_child(UI.label("Esc to close", 13, UI.MUTED, "body"))
	v.add_child(h)
	v.add_child(body)
	return p


## The floating popover: Esc or a click outside closes it.
class Pop extends PanelContainer:
	var on_close := Callable()
	var anchor: Control = null
	var left := false

	func _init() -> void:
		top_level = true
		z_index = 50
		custom_minimum_size = Vector2(360, 0)
		mouse_filter = Control.MOUSE_FILTER_STOP
		add_theme_stylebox_override("panel", WoodKit.slate(26, 18))

	func _ready() -> void:
		_place.call_deferred()

	func _place() -> void:
		if anchor == null or not is_instance_valid(anchor):
			return
		var r := anchor.get_global_rect()
		var w := maxf(size.x, custom_minimum_size.x)
		var x := r.position.x - w - 10.0 if left else r.end.x + 10.0
		var vp := get_viewport_rect().size
		global_position = Vector2(clampf(x, 8.0, vp.x - w - 8.0), clampf(r.position.y, 8.0, maxf(8.0, vp.y - size.y - 8.0)))

	func _unhandled_input(ev: InputEvent) -> void:
		if ev.is_action_pressed("ui_cancel") and on_close.is_valid():
			on_close.call()
			get_viewport().set_input_as_handled()

	func _input(ev: InputEvent) -> void:
		var mb := ev as InputEventMouseButton
		if mb != null and mb.pressed and not get_global_rect().has_point(mb.global_position) and on_close.is_valid():
			if anchor != null and is_instance_valid(anchor) and anchor.get_global_rect().has_point(mb.global_position):
				return   # the card's own click toggles it
			on_close.call_deferred()
