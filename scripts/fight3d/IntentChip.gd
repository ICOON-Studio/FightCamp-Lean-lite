extends Control
## A word over each boxer's head while the scorebug is up (S405: the same rule as the side holos).
## The opponent: her game in the coming exchange, Exchanges.MODES[sit]["label"] from LiveRound.preview.
## His boxer: "Hurt" / "Tired" when Exchanges.situation says so, else the call in force, else nothing.
## Follows the head bone. Kept out of the scoreboard and the top strips. Never takes a click.

const TV := preload("res://scripts/ui/TV.gd")
const WoodKit := preload("res://scripts/ui/WoodKit.gd")
const Halo := preload("res://scripts/ui/Halo.gd")
const Exchanges := preload("res://scripts/rules/Exchanges.gd")
const LiveRound := preload("res://scripts/state/LiveRound.gd")

const RED := Color("#e2483d")
const CLEAR_Y := 268.0
const KEEP_CLEAR := [Rect2(640, 0, 640, 240), Rect2(20, 20, 600, 180), Rect2(1300, 20, 600, 180)]

var view: Control
var side := 0
var _plate: Panel
var _word: Label
var _halo := 0.0


static func attach(v: Control) -> void:
	for s in 2:
		var c := new()
		c.name = "IntentChip%d" % s
		c.view = v
		c.side = s
		v.add_child(c)


static func opp_words(sit: String) -> String:
	if sit == "":
		return ""
	return str((Exchanges.MODES.get(sit, {}) as Dictionary).get("label", ""))


## Hurt and Tired come from Exchanges.situation (the game's own hurt and energy lines). Else the call's label.
static func own_words(hurt: bool, energy: float, call_id: String) -> String:
	var sit := Exchanges.situation("press", energy, hurt)
	if sit == "she_hurt":
		return "Hurt"
	if sit == "she_tired":
		return "Tired"
	if call_id == "" or not Exchanges.CALLS.has(call_id):
		return ""
	return str((Exchanges.CALLS[call_id] as Dictionary).get("label", ""))


static func shown(bug_on: bool, word: String, on_screen: bool) -> bool:
	return bug_on and word.strip_edges() != "" and on_screen


## Screen point of a world position. ok is false when the point is behind the lens or outside the view.
static func screen_of(cam: Camera3D, world: Vector3, view_size: Vector2) -> Dictionary:
	if cam == null or not cam.is_inside_tree() or cam.is_position_behind(world):
		return {"ok": false, "pos": Vector2.ZERO}
	if view_size.x < 2.0 or view_size.y < 2.0:
		return {"ok": false, "pos": Vector2.ZERO}
	var raw := cam.unproject_position(world)
	var vp := cam.get_viewport()
	var vp_size := view_size
	if vp != null:
		vp_size = vp.get_visible_rect().size
	var pos := raw
	if vp_size.x > 1.0 and vp_size.y > 1.0:
		pos = Vector2(raw.x * view_size.x / vp_size.x, raw.y * view_size.y / vp_size.y)
	if pos.x < 0.0 or pos.y < 0.0 or pos.x > view_size.x or pos.y > view_size.y:
		return {"ok": false, "pos": pos}
	return {"ok": true, "pos": pos}


## The chip's top-left, sitting over the head and kept inside the open middle between the panels.
static func clamp_box(head: Vector2, chip: Vector2, open_l: float, open_r: float, view_size: Vector2) -> Vector2:
	var x := head.x - chip.x * 0.5
	var y := head.y - chip.y - 8.0
	x = clampf(x, open_l, maxf(open_l, open_r - chip.x))
	y = clampf(y, 0.0, maxf(0.0, view_size.y - chip.y))
	return Vector2(x, y)


func _ready() -> void:
	if _word == null:
		_mount()


func _process(delta: float) -> void:
	_tick(delta)
	if view == null:
		return
	var bug: Node = view.get("_bug_box")
	var bug_on := bug != null and bool(bug.get("visible"))
	var word := _state_word() if bug_on else ""
	var open := _open()
	place(_camera(), _head(), open.x, open.y, view.size, bug_on, word)


func place(cam: Camera3D, world: Vector3, open_l: float, open_r: float, view_size: Vector2, bug_on: bool, word: String) -> void:
	if _word == null:
		_mount()
	_set_word(word if bug_on else "")
	var hit: Dictionary = screen_of(cam, world, view_size)
	var on_screen := bool(hit.get("ok", false))
	visible = shown(bug_on, _word.text, on_screen)
	if not visible:
		return
	position = _off_board(clamp_box(hit["pos"], size, open_l, open_r, view_size))


## Drop a chip that would cover the scoreboard or a top strip to just under that band.
func _off_board(pos: Vector2) -> Vector2:
	var origin := Vector2.ZERO
	var parent := get_parent() as Control
	if parent != null:
		origin = parent.get_global_rect().position
	var r := Rect2(origin + pos, size)
	var hit := false
	for box in KEEP_CLEAR:
		if r.intersects(box as Rect2):
			hit = true
			break
	if not hit:
		return pos
	return Vector2(pos.x, CLEAR_Y - origin.y)


func _mount() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	visible = false
	_plate = Panel.new()
	_plate.name = "Plate"
	_plate.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_plate.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(_plate)
	var sb := StyleBoxFlat.new()
	sb.bg_color = TV.BG
	sb.border_color = RED if side == 0 else WoodKit.BLUE
	sb.set_border_width_all(3)
	sb.set_corner_radius_all(8)
	_plate.add_theme_stylebox_override("panel", sb)
	_word = TV.label("", 22, WoodKit.INK, "bold")
	_word.name = "ChipWord"
	_word.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_word.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	_word.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_plate.add_child(_word)


func _set_word(next: String) -> void:
	if _word.text == next:
		return
	_word.text = next
	if next == "":
		_drop_halo()
		return
	var wide := clampf(_word.get_minimum_size().x + 36.0, 108.0, 360.0)
	size = Vector2(wide, 44.0)
	_drop_halo()
	Halo.ring(_plate, RED if side == 0 else WoodKit.BLUE, 8.0)
	_halo = 1.0


func _tick(delta: float) -> void:
	if _halo <= 0.0:
		return
	_halo -= delta
	if _halo <= 0.0:
		_drop_halo()


func _drop_halo() -> void:
	_halo = 0.0
	if _plate == null:
		return
	var old := _plate.get_node_or_null("Halo")
	if old != null:
		old.queue_free()


func _state_word() -> String:
	var main: Node = view.get("main")
	if main == null:
		return ""
	var modal: Variant = main.get("modal")
	if not (modal is Dictionary):
		return ""
	var m: Dictionary = modal
	var career: Object = main.get("career")
	if career == null:
		return ""
	var f: Dictionary = career.call("fighter_by_id", str(view.get("fid")))
	if side == 1:
		return opp_words(str(LiveRound.preview(f, m).get("sit", "")))
	var lv: Dictionary = LiveRound.live(m)
	if lv.is_empty():
		return ""
	var exs: Array = lv.get("ex", [])
	var call := str(lv.get("plan", ""))
	if view.has_method("_exchanges"):
		var watched: Array = view.call("_exchanges")
		if not watched.is_empty() and watched[-1] is Dictionary:
			call = str((watched[-1] as Dictionary).get("call", ""))
	return own_words(bool(lv.get("her_hurt", false)), LiveRound.her_energy(lv, exs.size()), call)


func _camera() -> Camera3D:
	var stage: Node = view.get("stage")
	if stage == null:
		return null
	return stage.get("camera") as Camera3D


func _head() -> Vector3:
	var stage: Node = view.get("stage")
	if stage == null:
		return Vector3(0, 1.65, 0)
	var boxers: Variant = stage.get("boxers")
	if not (boxers is Array) or (boxers as Array).size() <= side:
		return Vector3(0, 1.65, 0)
	var bx: Dictionary = (boxers as Array)[side]
	var pos := Vector3.ZERO
	if bx.get("pos") is Vector3:
		pos = bx["pos"]
	var skel: Skeleton3D = bx.get("skel") as Skeleton3D
	if skel == null:
		return pos + Vector3(0, 1.65, 0)
	var id := skel.find_bone("Head")
	if id < 0:
		return pos + Vector3(0, 1.65, 0)
	return skel.global_transform * skel.get_bone_global_pose(id).origin


func _open() -> Vector2:
	return Vector2(8.0, maxf(16.0, view.size.x - 8.0))
