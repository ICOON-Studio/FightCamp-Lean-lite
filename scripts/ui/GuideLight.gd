extends Control
## S413 the guide's light (concept docs/mockups/s412/guide_concept_words.png): the page dims and a warm ring marks the thing to touch.
## S532 GUIDETIPS1 (owner: "should the guide be structured a bit better like give the player time to explore the tabs"):
## EXPLORE FIRST. Nothing dims and nothing is ringed until the player presses SHOW ME on the bubble (show_step); stuck on a
## page that holds the next job for GUIDE_IDLE_PULSE_S with no click, the ring alone pulses softly, with no dim.
## It only shows when the thing is on the open page, never blocks a click, and goes away under a pop-up: the player can still do
## anything in any order (operator S275, nothing interrupts).

const Palette := preload("res://scripts/ui/Palette.gd")
const MenuFx := preload("res://scripts/ui/MenuFx.gd")
const Halo := preload("res://scripts/ui/Halo.gd")

const DIM := Color(Palette.PAGE, 0.38)
const GOLD := Palette.HEADER
const PAD := 10.0
const LOOK_EVERY := 12   # frames between searches for the target: the whole page is a big tree
const GUIDE_IDLE_PULSE_S := 20.0   # the stuck wait before the soft pulse: one named number, to tune on the owner's play

static var show_step := ""   # SHOW ME was pressed for this guide step (the light is rebuilt with every page)
static var idle_s := 0.0     # seconds since the last click or key

var names: Array = []
var main: Node
var step := ""   # the guide step this light is for
var _target: Control
var _count := 0
var _ring: ColorRect   # the shared halo (Halo.gd), moved onto the thing to touch


func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	_ring = Halo.ring(self, GOLD, 14.0)
	_ring.set_anchors_preset(Control.PRESET_TOP_LEFT)
	_ring.visible = false


func _process(delta: float) -> void:
	global_position = Vector2.ZERO   # the shell gives this a zero-size slot: it covers the whole window
	size = get_viewport_rect().size
	idle_s += delta
	_count += 1
	if _target == null or not is_instance_valid(_target) or _count >= LOOK_EVERY:
		_count = 0
		_target = _find()
	queue_redraw()


func _input(e: InputEvent) -> void:
	if (e is InputEventMouseButton or e is InputEventKey) and e.is_pressed():
		idle_s = 0.0


## SHOW ME is on for this step: the page dims and the ring is steady.
func lit() -> bool:
	return step != "" and show_step == step


## Stuck: no click for a while and nobody asked. The ring breathes, nothing dims.
func pulsing() -> bool:
	return not lit() and idle_s >= GUIDE_IDLE_PULSE_S


## The first named control that is really on show; none under a pop-up.
func _find() -> Control:
	if main == null or not (main.modal as Dictionary).is_empty():
		return null
	for n in names:
		var found := main.find_child(str(n), true, false) as Control
		if found != null and found.is_visible_in_tree() and found.size.x > 0.0 and _clear(found.get_global_rect()):
			return found
	return null


## On the screen and not under the old trainer: a light nobody can see would only dim the page.
func _clear(r: Rect2) -> bool:
	var corner := find_child("GuideCorner", false, false) as Control
	return get_viewport_rect().encloses(r) and (corner == null or not corner.get_global_rect().intersects(r))


func target() -> Control:
	return _target if _target != null and is_instance_valid(_target) else null


func _draw() -> void:
	var t := target()
	var on := t != null and (lit() or pulsing())
	_ring.visible = on
	if not on:
		return
	var full := Rect2(Vector2.ZERO, size)
	var hole := t.get_global_rect().grow(PAD).intersection(full)
	if lit():
		draw_rect(Rect2(0, 0, full.size.x, hole.position.y), DIM)
		draw_rect(Rect2(0, hole.end.y, full.size.x, full.size.y - hole.end.y), DIM)
		draw_rect(Rect2(0, hole.position.y, hole.position.x, hole.size.y), DIM)
		draw_rect(Rect2(hole.end.x, hole.position.y, full.size.x - hole.end.x, hole.size.y), DIM)
	_ring.set("power", 1.0 if lit() else 0.5 + 0.3 * sin(float(Time.get_ticks_msec()) / 450.0))
	var room := Vector2.ONE * Halo.MARGIN
	_ring.position = hole.position - room
	_ring.size = hole.size + room * 2.0
