extends RefCounted
## S416 where a boxer stands on the gym picture. One spot per owned piece of kit, in picture pixels.
## Feet sit in the middle of the piece and 6 px below its bottom edge, kept 20 px inside the picture.
## Nearer spots (larger y) come last so the figure there draws in front.
##   spots(rows, day) -> [{id, kind, at: Vector2, job}]

const GymSlots := preload("res://scripts/rules/GymSlots.gd")
const GymPeople := preload("res://scripts/rules/GymPeople.gd")

const PICTURE := Vector2(1672, 941)
const MARGIN := 20.0
const BELOW := 6.0
const ON_BELT := 0.78   # how far down a cardio piece its belt is, as a share of its height
const KINDS := ["bag", "mat", "rack", "bench", "cardio"]


static func spots(rows: Array, day: int) -> Array:
	var out: Array = []
	var seen := {}
	for id in GymSlots.owned(rows, day):
		var key := str(id)
		if seen.has(key):
			continue
		var item: Dictionary = GymSlots.item(key)
		if item.is_empty():
			continue
		var kind := str(item["kind"])
		if not KINDS.has(kind):
			continue
		seen[key] = true
		out.append({"id": key, "kind": kind, "at": _feet(item), "job": _job(kind)})
	out.sort_custom(func(a, b): return _key(a) < _key(b))
	return out


static func _feet(item: Dictionary) -> Vector2:
	var x: float = float(item["x"]) + float(item["w"]) * 0.5
	var y: float = float(item["y"]) + float(item["h"]) + BELOW
	if str(item.get("kind", "")) == "cardio":
		y = float(item["y"]) + float(item["h"]) * ON_BELT   # S419: on the treadmill's belt, not on the floor in front of it
	var lo := Vector2(MARGIN, MARGIN)
	var hi := PICTURE - lo
	return Vector2(clampf(x, lo.x, hi.x), clampf(y, lo.y, hi.y))


## Bag work, a mat is idle, every other kind stands.
static func _job(kind: String) -> String:
	if kind == "bag":
		return "jab_back"
	if kind == "mat":
		return "idle"
	return "stand"


## Picture points of a plan route. A similarity sends the first tile to `start` and the last tile to `end`,
## so each tile, including every bend, keeps its place and a straight route stays the line between the spots.
static func route_px(route: Array, start: Vector2, end: Vector2) -> Array:
	if route.size() < 2:
		return []
	var a := Vector2(route[0])
	var b := Vector2(route[route.size() - 1])
	var d := b - a
	var len2 := d.length_squared()
	if len2 < 0.0001:
		return []
	var w := end - start
	var sx := (w.x * d.x + w.y * d.y) / len2
	var sy := (w.y * d.x - w.x * d.y) / len2
	var out: Array = []
	for t in route:
		var v := Vector2(t) - a
		out.append(start + Vector2(sx * v.x - sy * v.y, sy * v.x + sx * v.y))
	return out


## The plan tile a picture spot walks from. Stamina has none, so that change fades.
static func plan_tile(spot_id: String, kind: String, plan: Dictionary) -> Vector2i:
	if kind == "" or kind == "cardio":
		return Vector2i(-999, -999)
	var hits: Array = []
	for s in GymPeople.spots(plan):
		if str(s["kind"]) == kind:
			hits.append(s["at"])
	if hits.is_empty():
		return Vector2i(-999, -999)
	return hits[absi(hash(spot_id)) % hits.size()]


## Drawn height of a figure whose feet sit at picture y, in screen pixels. Same curve as the floor.
static func fig_h(y: float, k: float) -> float:
	return lerpf(0.12, 0.16, (y / PICTURE.y - 0.40) / 0.60) * PICTURE.y * k


## Hub button rectangles (icon plus label), read from GymHub's own pin table and tag size.
static func pin_rects(host: Node, corner: Vector2, k: float) -> Array:
	if k <= 0.0 or host == null:
		return []
	var hub := host.get_parent() as Control
	if hub == null or hub.get_node_or_null("Place_training") == null:
		return []
	var g = load("res://scripts/ui/GymHub.gd")
	var tag: Vector2 = g.TAG
	var cap := (hub.size - tag).max(Vector2.ZERO)
	var out: Array = []
	for row in g.PLACES:
		var at: Vector2 = corner + (g.PIN_AT[str(row[0])] as Vector2) * (g.PICTURE_SIZE as Vector2) * k
		out.append(Rect2((at - tag * 0.5).clamp(Vector2.ZERO, cap), tag))
	return out


## True when the drawn frame around `at` covers more than a tenth of itself with a button.
static func covered(at: Vector2, corner: Vector2, k: float, pins: Array) -> bool:
	if k <= 0.0 or pins.is_empty():
		return false
	var sc := fig_h(at.y, k) / 128.0
	var body := Rect2(corner + at * k - Vector2(48.0, 107.0) * sc, Vector2(96.0, 128.0) * sc)
	for pin in pins:
		var hit: Rect2 = body.intersection(pin)
		if body.get_area() > 0.0 and hit.size.x > 0.0 and hit.size.y > 0.0 and hit.get_area() > body.get_area() * 0.10:
			return true
	return false


## y, then x, then id, so a redraw keeps the same order.
static func _key(s: Dictionary) -> String:
	var at: Vector2 = s["at"]
	return "%09d|%09d|%s" % [int(round(at.y * 10.0)), int(round(at.x * 10.0)), str(s["id"])]
