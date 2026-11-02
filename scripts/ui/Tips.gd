extends Node
## S359 the whiteboard's index cards (J90 tier 2; operator: "see how the best games make tooltips, what they were praised
## for and do better than those"; research Game/Godot/research/J90_TOOLTIPS_PRAISED.md). The engine's tooltip cannot be
## hovered, locked or kept (it passes the mouse through and dies on a click), so the cards live on their own layer:
## - an opaque index card BESIDE the control, never over it or the cursor, flipped to the side with room (J90 6d);
## - a magnet on top fills over LOCK_S: then the card is locked and the pointer can travel onto it (CK3's praised lock,
##   made visible); Shift or a middle click pins it, Esc or a click elsewhere closes it;
## - every number with its change in colour and a "Means:" line - what the number does to her (Into the Breach / Civ VII);
## - sweeping across controls swaps cards at once, no fade (J90 6c).
##   Tips.card(control, spec: Callable)   spec.call() -> {title, rows: [[label, value, delta, tone]], means, hint: [[key, words]]}
##   tone: "good" | "bad" | "watch" | "".   Tips.close_all()

const UI := preload("res://scripts/ui/UI.gd")

const LOCK_S := 0.7
const FADE_IN_S := 0.12
const FADE_OUT_S := 0.08
const SLIDE_PX := 6.0
const CLOSE_S := 0.15
const CLOSE_LOCKED_S := 0.3
const SWEEP_S := 0.4
const MARGIN := 16.0
const GAP := 10.0
const TEXT_W := 330.0
## J90 section 4: text inks that pass 4.5:1 on the card (the house amber / green / red do not).
const CARD_BG := Color("#fffdf6")
const CARD_EDGE := Color("#d8d4cb")
const INK := Color("#1f2a44")
const RED := Color("#c8312a")
const GOOD := Color("#1c6e43")
const BAD := Color("#a8261f")
const WATCH := Color("#8f5100")
const MUTED := Color("#5e6773")
const RULE := Color("#e2ded4")

static var _inst = null   # the one Tips node (untyped: its members are this script's)

var _layer: CanvasLayer
var _card: Control
var _ring: _Magnet
var _trigger: Control
var _spec: Callable
var _state := "hidden"   # hidden | pending | shown | locked | pinned
var _t := 0.0
var _away := 0.0
var _clock := 0.0
var _last_close := -9.0


## Gives `c` an index card instead of the engine's tooltip.
static func card(c: Control, spec: Callable) -> void:
	c.tooltip_text = ""
	if c.mouse_filter == Control.MOUSE_FILTER_IGNORE:
		c.mouse_filter = Control.MOUSE_FILTER_PASS
	c.mouse_entered.connect(func(): _one(c).hover(c, spec))
	c.tree_exiting.connect(func():
		if _inst != null and is_instance_valid(_inst) and _inst._trigger == c:
			_inst.close(true))


static func close_all() -> void:
	if _inst != null and is_instance_valid(_inst):
		_inst.close(true)


## The open card's state and node (tests and stills).
static func state() -> String:
	return str(_inst._state) if _inst != null and is_instance_valid(_inst) else "hidden"


static func open_card() -> Control:
	return _inst._card if _inst != null and is_instance_valid(_inst) else null


static func _one(c: Control) -> Variant:
	if _inst == null or not is_instance_valid(_inst):
		_inst = new()
		_inst.name = "Tips"
		c.get_tree().root.add_child(_inst)
	return _inst


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	_layer = CanvasLayer.new()
	_layer.layer = 100
	add_child(_layer)


func hover(c: Control, spec: Callable) -> void:
	if c == _trigger and _state != "hidden":
		return
	if _state == "pinned":
		return
	var sweep := _state in ["shown", "locked"] or _clock - _last_close < SWEEP_S
	close(true)
	_trigger = c
	_spec = spec
	_state = "pending"
	_t = 0.0
	if sweep:
		_show(true)


func _process(delta: float) -> void:
	_clock += delta
	if _state == "hidden":
		return
	if not is_instance_valid(_trigger) or not _trigger.is_visible_in_tree():
		close(true)
		return
	var on_trigger := _trigger.get_global_rect().grow(2.0).has_point(_trigger.get_global_mouse_position())
	var on_card := _card != null and _card.get_global_rect().grow(GAP).has_point(_card.get_global_mouse_position())
	match _state:
		"pending":
			if not on_trigger:
				close(true)
				return
			_t += delta
			if _t >= float(ProjectSettings.get_setting("gui/timers/tooltip_delay_sec", 0.3)):
				_show(false)
			return
		"shown":
			_t += delta
			_ring.fill = clampf(_t / LOCK_S, 0.0, 1.0)
			_ring.queue_redraw()
			if _t >= LOCK_S or (on_card and not on_trigger):
				_set_state("locked")
	if _state == "pinned":
		return
	_away = 0.0 if on_trigger or on_card else _away + delta
	if _away > (CLOSE_S if _state == "shown" else CLOSE_LOCKED_S):
		close(false)


func _input(e: InputEvent) -> void:
	if _state in ["hidden", "pending"]:
		return
	if e is InputEventKey and e.pressed and not e.echo:
		if e.keycode == KEY_ESCAPE:
			close(false)
			get_viewport().set_input_as_handled()
		elif e.keycode == KEY_SHIFT:
			_set_state("pinned")
	elif e is InputEventMouseButton and e.pressed:
		var inside := _card != null and _card.get_global_rect().has_point(_card.get_global_mouse_position())
		if e.button_index == MOUSE_BUTTON_MIDDLE and not inside:
			_set_state("pinned")
			get_viewport().set_input_as_handled()
		elif not inside:
			close(true)   # a click on the control does its job; the card goes (as the engine's tooltip does)


func close(instant: bool) -> void:
	if _card != null and is_instance_valid(_card):
		var old := _card
		if instant:
			old.queue_free()
		else:
			var tw := old.create_tween()
			tw.tween_property(old, "modulate:a", 0.0, FADE_OUT_S)
			tw.tween_callback(old.queue_free)
	if _state in ["shown", "locked", "pinned"]:
		_last_close = _clock
	_card = null
	_ring = null
	_trigger = null
	_state = "hidden"


func _set_state(s: String) -> void:
	_state = s
	if _ring != null:
		_ring.fill = 1.0
		_ring.locked = true
		_ring.pinned = s == "pinned"
		_ring.queue_redraw()


func _show(instant: bool) -> void:
	var s: Variant = _spec.call()
	if not (s is Dictionary) or (s as Dictionary).is_empty():
		_state = "hidden"
		return
	_card = _build(s)
	_layer.add_child(_card)
	var size := _card.get_combined_minimum_size()
	_card.size = size
	var r := place(size, _trigger.get_global_rect(), Rect2(Vector2.ZERO, get_viewport().get_visible_rect().size))
	_card.position = r.position
	_state = "shown"
	_t = 0.0
	_away = 0.0
	if instant:
		return
	var from := (r.position + r.size * 0.5 - _trigger.get_global_rect().get_center()).normalized() * -SLIDE_PX
	_card.modulate.a = 0.0
	_card.position = r.position + from
	var tw := _card.create_tween().set_parallel().set_ease(Tween.EASE_OUT)
	tw.tween_property(_card, "modulate:a", 1.0, FADE_IN_S)
	tw.tween_property(_card, "position", r.position, FADE_IN_S)


## Beside the anchor (J90 6d): right or left (whichever has more room) top-aligned, then below, then above; inside the
## screen less MARGIN and never over the anchor.
static func place(size: Vector2, anchor: Rect2, screen: Rect2) -> Rect2:
	var room := screen.grow(-MARGIN)
	var right_free := room.end.x - anchor.end.x
	var left_free := anchor.position.x - room.position.x
	var sides := ["right", "left"] if right_free >= left_free else ["left", "right"]
	sides.append_array(["below", "above"])
	var r := Rect2()
	for side in sides:
		match side:
			"right": r = Rect2(Vector2(anchor.end.x + GAP, anchor.position.y), size)
			"left": r = Rect2(Vector2(anchor.position.x - GAP - size.x, anchor.position.y), size)
			"below": r = Rect2(Vector2(anchor.position.x, anchor.end.y + GAP), size)
			"above": r = Rect2(Vector2(anchor.position.x, anchor.position.y - GAP - size.y), size)
		# Slide along the side's free axis to fit.
		if side in ["right", "left"]:
			r.position.y = clampf(r.position.y, room.position.y, room.end.y - size.y)
		else:
			r.position.x = clampf(r.position.x, room.position.x, room.end.x - size.x)
		if room.encloses(r) and not r.intersects(anchor.grow(4.0)):
			return r
	r.position = r.position.clamp(room.position, room.end - size)
	return r


func _build(s: Dictionary) -> Control:
	var root := Control.new()
	root.name = "TipCard"
	root.mouse_filter = Control.MOUSE_FILTER_STOP
	var panel := PanelContainer.new()
	var st := UI.box(CARD_BG, CARD_EDGE, 4, 1, 18, 14)
	st.content_margin_top = 22
	st.shadow_color = Color(0, 0, 0, 0.22)
	st.shadow_size = 6
	st.shadow_offset = Vector2(2, 4)
	panel.add_theme_stylebox_override("panel", st)
	panel.position = Vector2(0, 8)
	panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	root.add_child(panel)
	var v := VBoxContainer.new()
	v.add_theme_constant_override("separation", 6)
	v.mouse_filter = Control.MOUSE_FILTER_IGNORE
	panel.add_child(v)
	if str(s.get("title", "")) != "":
		v.add_child(_text(str(s["title"]), "marker", 22, INK))
		var rule := ColorRect.new()
		rule.color = RED
		rule.custom_minimum_size = Vector2(0, 2)
		rule.mouse_filter = Control.MOUSE_FILTER_IGNORE
		v.add_child(rule)
	var rows: Array = s.get("rows", [])
	if not rows.is_empty():
		var g := GridContainer.new()
		g.columns = 3
		g.add_theme_constant_override("h_separation", 14)
		g.add_theme_constant_override("v_separation", 2)
		g.mouse_filter = Control.MOUSE_FILTER_IGNORE
		for row in rows:
			g.add_child(_text(str(row[0]), "hand", 19, INK))
			var val := _text(str(row[1]), "semi", 19, INK)
			val.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
			g.add_child(val)
			var tone := str(row[3]) if row.size() > 3 else ""
			g.add_child(_text(str(row[2]) if row.size() > 2 else "", "semi", 19,
				{"good": GOOD, "bad": BAD, "watch": WATCH}.get(tone, MUTED)))
		v.add_child(g)
	if str(s.get("means", "")) != "":
		v.add_child(_text("Means: " + str(s["means"]), "hand", 19, INK, true))
	var hint: Array = s.get("hint", [])
	if not hint.is_empty():
		var sep := ColorRect.new()
		sep.color = RULE
		sep.custom_minimum_size = Vector2(0, 1)
		sep.mouse_filter = Control.MOUSE_FILTER_IGNORE
		v.add_child(sep)
		var h := HBoxContainer.new()
		h.add_theme_constant_override("separation", 6)
		h.mouse_filter = Control.MOUSE_FILTER_IGNORE
		for k in hint:
			var chip := PanelContainer.new()
			chip.add_theme_stylebox_override("panel", UI.box(Color(0, 0, 0, 0), INK, 3, 1, 6, 1))
			chip.mouse_filter = Control.MOUSE_FILTER_IGNORE
			chip.add_child(_text(str(k[0]).to_upper(), "semi", 15, INK))
			h.add_child(chip)
			h.add_child(_text(str(k[1]) + "   ", "body", 18, MUTED))
		v.add_child(h)
	var size := panel.get_combined_minimum_size()
	_ring = _Magnet.new()
	_ring.position = Vector2(size.x * 0.5 - 8.0, 0.0)
	root.add_child(_ring)
	root.custom_minimum_size = size + Vector2(0, 8)
	return root


## A label on the card. Wrapped text gets a fixed width (an autowrapped Label's minimum width is ~0 - J90 trap 2).
static func _text(t: String, kind: String, size: int, colour: Color, wrap := false) -> Label:
	var l := Label.new()
	l.text = t
	l.add_theme_font_override("font", UI.font(kind))
	l.add_theme_font_size_override("font_size", size)
	l.add_theme_color_override("font_color", colour)
	l.mouse_filter = Control.MOUSE_FILTER_IGNORE
	if wrap:
		l.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		l.custom_minimum_size = Vector2(TEXT_W, 0)
	return l


## The magnet on the card's top edge: its ring fills while the lock timer runs; solid red once locked; a glint when pinned.
class _Magnet extends Control:
	var fill := 0.0
	var locked := false
	var pinned := false

	func _init() -> void:
		custom_minimum_size = Vector2(16, 16)
		size = Vector2(16, 16)
		mouse_filter = Control.MOUSE_FILTER_IGNORE

	func _draw() -> void:
		var c := Vector2(8, 8)
		if locked:
			draw_circle(c, 8.0, RED)
			if pinned:
				draw_circle(c + Vector2(-2.5, -2.5), 2.0, Color.WHITE)
			return
		draw_circle(c, 8.0, CARD_BG)
		draw_arc(c, 7.0, 0.0, TAU, 32, INK, 2.0, true)
		if fill > 0.0:
			draw_arc(c, 4.0, -PI * 0.5, -PI * 0.5 + TAU * fill, 32, RED, 4.0, true)
