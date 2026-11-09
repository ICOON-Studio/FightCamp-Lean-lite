extends RefCounted
## S416 where a boxer stands on the gym picture. One spot per owned piece of kit, in picture pixels.
## Feet sit in the middle of the piece and 6 px below its bottom edge, kept 20 px inside the picture.
## Nearer spots (larger y) come last so the figure there draws in front.
##   spots(rows, day) -> [{id, kind, at: Vector2, job}]

const GymSlots := preload("res://scripts/rules/GymSlots.gd")

const PICTURE := Vector2(1672, 941)
const MARGIN := 20.0
const BELOW := 6.0
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


## y, then x, then id, so a redraw keeps the same order.
static func _key(s: Dictionary) -> String:
	var at: Vector2 = s["at"]
	return "%09d|%09d|%s" % [int(round(at.y * 10.0)), int(round(at.x * 10.0)), str(s["id"])]
