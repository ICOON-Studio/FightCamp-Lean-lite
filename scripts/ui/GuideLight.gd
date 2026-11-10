extends Control
## S413 the guide's light (concept docs/mockups/s412/guide_concept_words.png): the page dims and a warm ring marks the thing to touch.
## It only shows when the thing is on the open page, never blocks a click, and goes away under a pop-up: the player can still do
## anything in any order (operator S275, nothing interrupts).

const MenuFx := preload("res://scripts/ui/MenuFx.gd")
const Halo := preload("res://scripts/ui/Halo.gd")

const DIM := Color(0.05, 0.03, 0.02, 0.38)
const GOLD := Color("#f4c56a")
const PAD := 10.0
const LOOK_EVERY := 12   # frames between searches for the target: the whole page is a big tree

var names: Array = []
var main: Node
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
	_count += 1
	if _target == null or not is_instance_valid(_target) or _count >= LOOK_EVERY:
		_count = 0
		_target = _find()
	queue_redraw()


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
	_ring.visible = t != null
	if t == null:
		return
	var full := Rect2(Vector2.ZERO, size)
	var hole := t.get_global_rect().grow(PAD).intersection(full)
	draw_rect(Rect2(0, 0, full.size.x, hole.position.y), DIM)
	draw_rect(Rect2(0, hole.end.y, full.size.x, full.size.y - hole.end.y), DIM)
	draw_rect(Rect2(0, hole.position.y, hole.position.x, hole.size.y), DIM)
	draw_rect(Rect2(hole.end.x, hole.position.y, full.size.x - hole.end.x, hole.size.y), DIM)
	var room := Vector2.ONE * Halo.MARGIN
	_ring.position = hole.position - room
	_ring.size = hole.size + room * 2.0
