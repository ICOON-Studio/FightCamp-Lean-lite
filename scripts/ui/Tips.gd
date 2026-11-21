extends Node
## S359 the whiteboard's index cards (J90 tier 2; operator: "see how the best games make tooltips, what they were praised
## for and do better than those"; research Game/Godot/research/J90_TOOLTIPS_PRAISED.md). The engine's tooltip cannot be
## hovered, locked or kept (it passes the mouse through and dies on a click), so the cards live on their own layer:
## - an opaque index card BESIDE the control, never over it or the cursor, flipped to the side with room (J90 6d);
## - a magnet on top fills over LOCK_S: then the card is locked and the pointer can travel onto it (CK3's praised lock,
##   made visible); Shift or a middle click pins it, Esc or a click elsewhere closes it;
## - every number with its change in colour and a "Means:" line - what the number does to her (Into the Breach / Civ VII);
## - sweeping across controls swaps cards at once, no fade (J90 6c).
## - S362 (J90 6c T3): a card's "keys" are game terms underlined in dashed red; resting on one for NOTE_DELAY opens its
##   yellow sticky note (Glossary: the term, a short definition, Why:) beside the card on the side away from the control.
##   Two levels only: a note has no keywords of its own.
##   Tips.card(control, spec: Callable)   spec.call() -> {title, rows: [[label, value, delta, tone]], means, keys: [term id],
##   hint: [[key, words]]}  + what / now / moves / do / lines (S532 GUIDETIPS1, drawn by TipParts; written with Tip.gd)
## S532: a control's plain tooltip_text is shown as the same wrapped card (the engine's grey box never wraps: one line ran
## across the whole screen). boot(tree) starts it; the text moves to the control's META_TEXT.
##   tone: "good" | "bad" | "watch" | "".   Tips.close_all()   S491 meter: {shift, caption} = TipMeter's odds bar.

const Palette := preload("res://scripts/ui/Palette.gd")   # S493 Q-251 the one palette
const UI := preload("res://scripts/ui/UI.gd")
const Glossary := preload("res://scripts/rules/Glossary.gd")
const Parts := preload("res://scripts/ui/TipParts.gd")

const LOCK_S := 0.7
const FADE_IN_S := 0.12
const FADE_OUT_S := 0.08
const SLIDE_PX := 6.0
const CLOSE_S := 0.15
const CLOSE_LOCKED_S := 0.3
const SWEEP_S := 0.4
const MARGIN := Parts.MARGIN
const GAP := Parts.GAP
const TEXT_W := Parts.TEXT_W
const META_TEXT := "tip_text"   # a plain tooltip's words, once Tips has taken it over
const META_SPEC := "tip_spec"   # a card's spec Callable (tests read what a control says)
const NOTE_BG := Parts.NOTE_BG
const NOTE_DELAY := 0.25

static var _inst = null   # the one Tips node (untyped: its members are this script's)
static var _own := {}   # script -> it writes its own tooltip (_get_tooltip / _make_custom_tooltip)

var _layer: CanvasLayer
var _card: Control
var _ring: Parts.Magnet
var _dismissed: Control   # a plain tooltip closed by a click or Esc stays closed until the pointer leaves
var _trigger: Control
var _spec: Callable
var _state := "hidden"   # hidden | pending | shown | locked | pinned
var _t := 0.0
var _away := 0.0
var _clock := 0.0
var _last_close := -9.0
var _keys: Array = []   # [[Label, term id]] on the open card
var _note: Control
var _note_key := ""
var _hover_key := ""
var _note_t := 0.0


## Gives `c` an index card instead of the engine's tooltip.
static func card(c: Control, spec: Callable) -> void:
	c.tooltip_text = ""
	c.set_meta(META_SPEC, spec)
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


## Opens `c`'s card at once, pinned (stills; the same state Shift gives). pin_note(id) opens a term's note on it.
static func pin(c: Control, spec: Callable) -> void:
	var t: Variant = _one(c)
	t.hover(c, spec)
	if t._state != "shown":   # S532: a sweep had already shown it - a second _show left the first card on screen for good
		t._show(true)
	t._set_state("pinned")


static func pin_note(id: String) -> void:
	if _inst != null and is_instance_valid(_inst) and _inst._card != null:
		_inst._open_note(id, _inst._card.find_child("Key_" + id, true, false))


static func open_note() -> Control:
	return _inst._note if _inst != null and is_instance_valid(_inst) and is_instance_valid(_inst._note) else null


## Starts the one Tips node so plain tooltips are shown as cards from the first screen (Main calls it).
static func boot(tree: SceneTree) -> void:
	if _inst == null or not is_instance_valid(_inst):
		_inst = new()
		_inst.name = "Tips"
		tree.root.add_child.call_deferred(_inst)


## The control whose plain tooltip the pointer is on (itself or a parent, as the engine reads it), its words moved to
## META_TEXT so the engine's grey box never opens. null over a card of its own, a move card, or a control that writes
## its tooltip as the pointer moves (_get_tooltip: the body figure) - those keep their own.
static func plain_under(n: Control) -> Control:
	while n != null:
		if n.has_meta(META_SPEC) or n.has_meta("move_tip") or _writes_own(n):
			return null
		if n.tooltip_text != "":
			n.set_meta(META_TEXT, n.tooltip_text)
			n.tooltip_text = ""
			return n
		if n.has_meta(META_TEXT):
			return n
		n = n.get_parent() as Control
	return null


## True when the control's script writes its own tooltip (asked of the script itself, once per script).
static func _writes_own(n: Control) -> bool:
	var sc: Script = n.get_script()
	if sc == null:
		return false
	if not _own.has(sc):
		var has := false
		for m in sc.get_script_method_list():
			if str(m["name"]) in ["_get_tooltip", "_make_custom_tooltip"]:
				has = true
		_own[sc] = has
	return bool(_own[sc])


static func plain_spec(c: Control) -> Dictionary:
	if not is_instance_valid(c):
		return {}
	var t := str(c.get_meta(META_TEXT, c.tooltip_text)).strip_edges()
	return {} if t == "" else {"lines": Array(t.split("\n", false)), "kind": "plain"}


func _adopt() -> void:
	var c := plain_under(get_viewport().gui_get_hovered_control())
	if c != _dismissed:
		_dismissed = null
	if c == null or c == _dismissed or (c == _trigger and _state != "hidden"):
		return
	hover(c, func(): return plain_spec(c))


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
	_adopt()
	if _state == "hidden":
		return
	if not is_instance_valid(_trigger) or not _trigger.is_visible_in_tree():
		close(true)
		return
	var on_trigger := _trigger.get_global_rect().grow(2.0).has_point(_trigger.get_global_mouse_position())
	var on_card := _card != null and _card.get_global_rect().grow(GAP).has_point(_card.get_global_mouse_position())
	if _card != null and _state != "pending":
		_tick_keys(delta)
		on_card = on_card or (_note != null and _note.get_global_rect().grow(GAP).has_point(_note.get_global_mouse_position()))
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
			_dismissed = _trigger
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
			_dismissed = _trigger
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
	_close_note()
	_keys = []
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
	var built := Parts.build(s, _keys)
	_card = built[0]
	_ring = built[1]
	_layer.add_child(_card)
	# S362: measured once on screen - off the tree its labels measure 0, so the card was placed as a 0-wide box (it ran
	# off the right edge; a note beside it landed on it).
	var size := (_card.get_child(0) as Control).get_combined_minimum_size() + Vector2(0, 8)
	_card.custom_minimum_size = size
	_card.size = size
	_ring.position = Vector2(size.x - 26.0, 0.0)   # S533 "reach 10": the corner, not the middle of the title
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


## Beside the anchor, inside the screen, never over it (TipParts).
static func place(size: Vector2, anchor: Rect2, screen: Rect2) -> Rect2:
	return Parts.place(size, anchor, screen)


static func place_note(size: Vector2, card: Rect2, screen: Rect2, away_right: bool) -> Rect2:
	return Parts.place_note(size, card, screen, away_right)


## The keyword under the pointer opens its note after NOTE_DELAY (at once when a note is already open: a sweep); off the
## keywords and off the note, the note closes.
func _tick_keys(delta: float) -> void:
	var over := ""
	var at: Control = null
	for k in _keys:
		var l: Control = k[0]
		if is_instance_valid(l) and l.get_global_rect().grow(4.0).has_point(l.get_global_mouse_position()):
			over = str(k[1])
			at = l
	if over == "":
		_hover_key = ""
		if _note != null and _state != "pinned" and not _note.get_global_rect().grow(GAP).has_point(_note.get_global_mouse_position()):
			_close_note()
		return
	if over == _note_key:
		return
	if over != _hover_key:
		_hover_key = over
		_note_t = 0.0
	_note_t += delta
	if _note_t >= NOTE_DELAY or _note != null:
		_open_note(over, at)


func _open_note(id: String, _at: Control) -> void:
	_close_note()
	var panel := Parts.note(Glossary.term(id))
	_layer.add_child(panel)
	var size := panel.get_combined_minimum_size()
	panel.size = size
	var card := _card.get_global_rect()
	var away_right := card.get_center().x >= _trigger.get_global_rect().get_center().x
	panel.position = place_note(size, card, Rect2(Vector2.ZERO, get_viewport().get_visible_rect().size), away_right).position
	panel.modulate.a = 0.0
	panel.create_tween().tween_property(panel, "modulate:a", 1.0, 0.1)
	_note = panel
	_note_key = id


func _close_note() -> void:
	if _note != null and is_instance_valid(_note):
		_note.queue_free()
	_note = null
	_note_key = ""
	_note_t = 0.0
