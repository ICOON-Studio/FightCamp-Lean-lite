extends RefCounted
## S415 operator: "Yes, start small", "Yes, new picture". The club opens with part of the owner's gym picture and buys the rest, piece
## by piece, on the picture. A piece is data (assets/data/gym_slots.json, baked by tools/gym_slots_bake.py); a career holds rows
## {id, day}. A piece works, and shows, once the fitters have had their week. Each piece adds places, and three members fit per place.
## An empty rows array is a save from before this: everything is owned, so nothing shrinks. Pure: no nodes, no game-state writes.
##   item(id) / all() / start_rows()
##   owned(rows, day) -> ids standing on the floor   fitting(rows, day) -> ids with the fitters in
##   places(rows, day) -> int   member_room(rows, day) -> int   blocked(id, rows, cash) -> "" or why not

const GymPlaces := preload("res://scripts/rules/GymPlaces.gd")

const PATH := "res://assets/data/gym_slots.json"
const FIT_DAYS := 7

static var _cache: Array = []


## Every piece the player can have, floor pieces first. A locked piece (the cage, S415) is not on sale and is not drawn.
static func all() -> Array:
	if _cache.is_empty():
		var data: Variant = JSON.parse_string(FileAccess.get_file_as_string(PATH))
		_cache = (data["slots"] as Array).filter(func(s): return not bool(s.get("locked", false)))
	return _cache


static func item(id: String) -> Dictionary:
	for s in all():
		if str(s["id"]) == id:
			return s
	return {}


## What a new club opens with: already fitted.
static func start_rows() -> Array:
	var out: Array = []
	for s in all():
		if bool(s["start"]):
			out.append({"id": str(s["id"]), "day": -FIT_DAYS})
	return out


static func owned(rows: Array, day: int) -> Array:
	if rows.is_empty():
		return all().map(func(s): return str(s["id"]))
	var out: Array = []
	for r in rows:
		if day >= int(r["day"]) + FIT_DAYS:
			out.append(str(r["id"]))
	return out


static func fitting(rows: Array, day: int) -> Array:
	var out: Array = []
	for r in rows:
		if day < int(r["day"]) + FIT_DAYS:
			out.append(str(r["id"]))
	return out


static func places(rows: Array, day: int) -> int:
	var n := 0
	for id in owned(rows, day):
		n += int(item(str(id)).get("places", 0))
	return n


static func member_room(rows: Array, day: int) -> int:
	return places(rows, day) * GymPlaces.MEMBERS_PER_PLACE


## "" when the piece can be bought now, else what stops it, in words for a tooltip.
static func blocked(id: String, rows: Array, cash: int) -> String:
	var s := item(id)
	if s.is_empty():
		return "not for sale"
	if rows.is_empty() or rows.any(func(r): return str(r["id"]) == id):
		return "already bought"
	if cash < int(s["price"]):
		return "$%d short of the price" % (int(s["price"]) - cash)
	return ""
