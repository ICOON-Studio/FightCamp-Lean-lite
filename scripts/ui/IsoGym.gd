extends Control
## S408 the gym drawn from its plan (GymPlan), never from one painting: floors, walls and doors are drawn where the data says, the
## equipment is separate isometric pictures (assets/ui/art/gym/<kind>.png; a plain block until a picture exists).
##   var g := IsoGym.new(); g.plan = plan   g.centre_of(zone) -> local point   g.tile(Vector2(x, y)) -> local point   g.hot = zone id

const GymPlan := preload("res://scripts/rules/GymPlan.gd")

const TW := 64.0     # a floor tile's width on screen, before fitting
const TH := 32.0
const WALL := 86.0   # back walls
const LOW := 12.0    # front walls, cut away so the room shows
const ROOM := 34.0   # the walls of a room inside the building
const ART := "res://assets/ui/art/gym/%s.png"
const FLOOR := {"reception": "#ecd9bb", "ring": "#2f5fc4", "bags": "#c8362f", "weights": "#3b414d", "mats": "#3f8fd9",
	"office": "#e8d3ae", "lockers": "#d8c5a4", "physio": "#bfe2dc"}
## The pictures' scale on their footprint, so a locker is not taller than the ceiling.
const SIZE := {"lockers": 0.55, "bag": 0.85, "desk": 0.8, "office_desk": 0.8, "sofa": 0.75, "treatment": 0.8, "rack": 0.85, "bench": 0.85}
const PLAIN := Color("#e9c998")
const WALL_COL := Color("#f4f1ec")
const WALL_SIDE := Color("#dcd6cf")
const EDGE := Color("#5a6172")
const BLUE := Color("#2f6fdb")
const RED := Color("#d9412f")

var plan: Dictionary = {}:
	set(v):
		plan = v
		queue_redraw()
var hot := "":
	set(v):
		hot = v
		queue_redraw()

var _scale := 1.0
var _origin := Vector2.ZERO
var _pics := {}


func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	resized.connect(queue_redraw)


func _notification(what: int) -> void:
	if what == NOTIFICATION_RESIZED:
		_fit()


## The building, fitted and centred in this control.
func _fit() -> void:
	if plan.is_empty():
		return
	var w := float(plan["w"])
	var h := float(plan["h"])
	var box_w := (w + h) * TW * 0.5
	var box_h := (w + h) * TH * 0.5 + WALL
	_scale = minf(size.x / box_w, size.y / box_h) * 0.97
	_origin = Vector2((size.x - box_w * _scale) * 0.5 + h * TW * 0.5 * _scale, (size.y - box_h * _scale) * 0.5 + WALL * _scale)


## A floor point (tiles) on screen.
func tile(p: Vector2) -> Vector2:
	return _origin + Vector2((p.x - p.y) * TW * 0.5, (p.x + p.y) * TH * 0.5) * _scale


func centre_of(z: Dictionary) -> Vector2:
	return tile(Vector2(float(z["x"]) + float(z["w"]) * 0.5, float(z["y"]) + float(z["h"]) * 0.5))


func _draw() -> void:
	if plan.is_empty():
		return
	_fit()
	_floors()
	_back_walls()
	for z in plan["zones"]:
		if str(z["kind"]) in GymPlan.WALLED:
			_room(z)
	_board()
	var items: Array = GymPlan.expand(plan)
	items.sort_custom(func(a, b): return int(a["x"]) + int(a["w"]) + int(a["y"]) + int(a["h"]) < int(b["x"]) + int(b["w"]) + int(b["y"]) + int(b["h"]))
	for it in items:
		_item(it)
	_front_walls()
	_front_door()


func _diamond(x: float, y: float, w: float, h: float) -> PackedVector2Array:
	return PackedVector2Array([tile(Vector2(x, y)), tile(Vector2(x + w, y)), tile(Vector2(x + w, y + h)), tile(Vector2(x, y + h))])


func _floors() -> void:
	var w := float(plan["w"])
	var h := float(plan["h"])
	draw_colored_polygon(_diamond(0, 0, w, h), PLAIN)
	for i in range(1, int(w)):   # floor boards
		draw_line(tile(Vector2(i, 0)), tile(Vector2(i, h)), Color(0.55, 0.38, 0.2, 0.12), 1.0)
	for z in plan["zones"]:
		var col := Color(str(FLOOR.get(str(z["kind"]), "#cccccc")))
		if str(z["id"]) == hot:
			col = col.lightened(0.28)
		draw_colored_polygon(_diamond(float(z["x"]), float(z["y"]), float(z["w"]), float(z["h"])), col)
	# the entrance: a mat just inside the door
	var d: Array = plan["door"]
	draw_colored_polygon(_diamond(float(d[0]), float(d[1]), 1, 1), Color("#37404f"))


## A wall from floor point a to b, `high` tall.
func _wall(a: Vector2, b: Vector2, high: float, col: Color) -> void:
	var up := Vector2(0, -high * _scale)
	var pa := tile(a)
	var pb := tile(b)
	draw_colored_polygon(PackedVector2Array([pa, pb, pb + up, pa + up]), col)
	draw_polyline(PackedVector2Array([pa + up, pb + up]), EDGE, maxf(1.5, 2.5 * _scale))


func _door_on(side: String) -> int:
	var d: Array = plan["door"]
	match side:
		"north":
			return int(d[0]) if int(d[1]) == 0 else -1
		"west":
			return int(d[1]) if int(d[0]) == 0 else -1
		"south":
			return int(d[0]) if int(d[1]) == int(plan["h"]) - 1 else -1
		"east":
			return int(d[1]) if int(d[0]) == int(plan["w"]) - 1 else -1
	return -1


func _back_walls() -> void:
	var w := int(plan["w"])
	var h := int(plan["h"])
	var north := _door_on("north")
	for x in w:
		_wall(Vector2(x, 0), Vector2(x + 1, 0), WALL, _glass() if x == north else WALL_COL)
		if x % 4 == 1 and x + 2 < w and x != north:
			_window(Vector2(x, 0), Vector2(x + 2, 0))
	var west := _door_on("west")
	for y in h:
		_wall(Vector2(0, y), Vector2(0, y + 1), WALL, _glass() if y == west else WALL_SIDE)
		if y % 4 == 1 and y + 2 < h and y != west:
			_window(Vector2(0, y), Vector2(0, y + 2))
	_stripe(Vector2(0, 0), Vector2(w, 0))
	_stripe(Vector2(0, 0), Vector2(0, h))


func _glass() -> Color:
	return Color("#a8d8ec")


func _window(a: Vector2, b: Vector2) -> void:
	var low := Vector2(0, -34.0 * _scale)
	var high := Vector2(0, -74.0 * _scale)
	var pa := tile(a)
	var pb := tile(b)
	draw_colored_polygon(PackedVector2Array([pa + low, pb + low, pb + high, pa + high]), Color("#bfe6f5"))


func _stripe(a: Vector2, b: Vector2) -> void:
	for band in [[12.0, BLUE], [18.0, RED]]:
		var up := Vector2(0, -float(band[0]) * _scale)
		var thick := Vector2(0, -5.0 * _scale)
		var pa := tile(a) + up
		var pb := tile(b) + up
		draw_colored_polygon(PackedVector2Array([pa, pb, pb + thick, pa + thick]), band[1])


func _front_walls() -> void:
	var w := int(plan["w"])
	var h := int(plan["h"])
	var south := _door_on("south")
	for x in w:
		if x != south:
			_wall(Vector2(x, h), Vector2(x + 1, h), LOW, WALL_COL)
	var east := _door_on("east")
	for y in h:
		if y != east:
			_wall(Vector2(w, y), Vector2(w, y + 1), LOW, WALL_SIDE)


## The glass doors stand in the gap the plan's entrance leaves in the wall.
func _front_door() -> void:
	var tex := _pic("door")
	if tex == null:
		return
	var d: Array = plan["door"]
	var x := float(d[0])
	var y := float(d[1])
	var foot: Vector2
	if _door_on("south") >= 0:
		foot = tile(Vector2(x + 0.5, y + 1.0))
	elif _door_on("east") >= 0:
		foot = tile(Vector2(x + 1.0, y + 0.5))
	elif _door_on("west") >= 0:
		foot = tile(Vector2(x, y + 0.5))
	else:
		foot = tile(Vector2(x + 0.5, y))
	var high := 86.0 * _scale
	var wide := high * float(tex.get_width()) / float(tex.get_height())
	draw_texture_rect(tex, Rect2(foot.x - wide * 0.5, foot.y - high, wide, high), false)


## A room's walls, broken at its door tile.
func _room(z: Dictionary) -> void:
	var x0 := int(z["x"])
	var y0 := int(z["y"])
	var x1 := x0 + int(z["w"])
	var y1 := y0 + int(z["h"])
	var door := Vector2i(int(z["door"][0]), int(z["door"][1]))
	for x in range(x0, x1):
		if y0 > 0 and not (door.x == x and door.y == y0):
			_wall(Vector2(x, y0), Vector2(x + 1, y0), ROOM, WALL_COL)
		if y1 < int(plan["h"]) and not (door.x == x and door.y == y1 - 1):
			_wall(Vector2(x, y1), Vector2(x + 1, y1), ROOM * 0.5, WALL_COL)
	for y in range(y0, y1):
		if x0 > 0 and not (door.x == x0 and door.y == y):
			_wall(Vector2(x0, y), Vector2(x0, y + 1), ROOM, WALL_SIDE)
		if x1 < int(plan["w"]) and not (door.x == x1 - 1 and door.y == y):
			_wall(Vector2(x1, y), Vector2(x1, y + 1), ROOM * 0.5, WALL_SIDE)


## The noticeboard on the back wall.
func _board() -> void:
	if not plan.has("board"):
		return
	var x := float(plan["board"][0])
	var low := Vector2(0, -36.0 * _scale)
	var high := Vector2(0, -72.0 * _scale)
	var a := tile(Vector2(x, 0))
	var b := tile(Vector2(x + 3.0, 0))
	draw_colored_polygon(PackedVector2Array([a + low, b + low, b + high, a + high]), Color("#c79a5e"))


func _pic(kind: String) -> Texture2D:
	if not _pics.has(kind):
		var path := ART % kind
		_pics[kind] = load(path) if ResourceLoader.exists(path) else null
	return _pics[kind]


## An item stands on its footprint: the picture's bottom sits at the footprint's front corner.
func _item(it: Dictionary) -> void:
	var x := float(it["x"])
	var y := float(it["y"])
	var w := float(it["w"])
	var h := float(it["h"])
	var tex := _pic(str(it["kind"]))
	if tex != null:
		var wide := (w + h) * TW * 0.5 * _scale * 1.06 * float(SIZE.get(str(it["kind"]), 1.0))
		var high := wide * float(tex.get_height()) / float(tex.get_width())
		var foot := tile(Vector2(x + w, y + h))
		var mid := tile(Vector2(x + w * 0.5, y + h * 0.5))
		draw_texture_rect(tex, Rect2(mid.x - wide * 0.5, foot.y - high, wide, high), false)
		return
	_block(x, y, w, h, 18.0 if str(it["kind"]) == "mat" else 40.0)


## Until a picture exists: a plain block the size of the item.
func _block(x: float, y: float, w: float, h: float, high: float) -> void:
	var up := Vector2(0, -high * _scale)
	var d := _diamond(x, y, w, h)
	draw_colored_polygon(PackedVector2Array([d[3], d[2], d[2] + up, d[3] + up]), Color("#6d7482"))
	draw_colored_polygon(PackedVector2Array([d[2], d[1], d[1] + up, d[2] + up]), Color("#565d6b"))
	draw_colored_polygon(PackedVector2Array([d[0] + up, d[1] + up, d[2] + up, d[3] + up]), Color("#8a92a1"))
