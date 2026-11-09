extends RefCounted
## S408 operator: "you need to make the gym make sense ... make a tool to properly design the gym and maybe use the tool for
## player too design his own", "should each hub be a module with few different variables?". A gym is data: a grid, an entrance,
## zones and items (assets/data/gym_plans.json). problems(plan) says in plain words what makes no sense, so a preset or a
## player's own gym can only be used when it reads like a real building. Pure: no nodes, no art.
##   plan = {id, name, bonus: {kind, pct, words}, w, h, door: [x, y], zones: [{id, kind, x, y, w, h, door?: [x, y]}],
##           items: [{kind, x, y, n?, dx?, dy?}]}   x runs right, y runs down the floor; n/dx/dy repeat an item in a row.

const PATH := "res://assets/data/gym_plans.json"
## Size in floor tiles (about a metre), the zone kinds it may stand in, and the clear floor it needs all round.
const ITEMS := {
	"ring": {"w": 6, "h": 6, "in": ["ring"], "clear": 1},
	"bag": {"w": 1, "h": 1, "in": ["bags"]},
	"rack": {"w": 2, "h": 1, "in": ["weights"]},
	"bench": {"w": 2, "h": 1, "in": ["weights"]},
	"mat": {"w": 3, "h": 2, "in": ["mats"]},
	"desk": {"w": 3, "h": 1, "in": ["reception"]},
	"sofa": {"w": 2, "h": 1, "in": ["reception"]},
	"office_desk": {"w": 2, "h": 1, "in": ["office"]},
	"lockers": {"w": 3, "h": 1, "in": ["lockers"]},
	"treatment": {"w": 2, "h": 1, "in": ["physio"]},
}
const NEEDED := ["reception", "ring", "bags", "weights", "mats", "office", "lockers"]
const WALLED := ["office", "lockers", "physio"]   # a room with walls: in and out only through its own door
const WORD := {"reception": "reception", "ring": "the ring", "bags": "the bags", "weights": "the weights", "mats": "the mats",
	"office": "the office", "lockers": "the lockers", "physio": "the physio room"}


static func load_all() -> Array:
	var data: Variant = JSON.parse_string(FileAccess.get_file_as_string(PATH))
	return (data as Dictionary).get("plans", []) if data is Dictionary else []


## The plan's items with every row written out, each with its size.
static func expand(plan: Dictionary) -> Array:
	var out: Array = []
	for it in plan.get("items", []):
		var spec: Dictionary = ITEMS.get(str(it["kind"]), {})
		for i in int(it.get("n", 1)):
			out.append({"kind": str(it["kind"]), "x": int(it["x"]) + i * int(it.get("dx", 0)), "y": int(it["y"]) + i * int(it.get("dy", 0)),
				"w": int(spec.get("w", 1)), "h": int(spec.get("h", 1)), "clear": int(spec.get("clear", 0)), "in": spec.get("in", [])})
	return out


static func zone_at(plan: Dictionary, x: int, y: int) -> Dictionary:
	for z in plan["zones"]:
		if x >= int(z["x"]) and x < int(z["x"]) + int(z["w"]) and y >= int(z["y"]) and y < int(z["y"]) + int(z["h"]):
			return z
	return {}


static func _inside(plan: Dictionary, x: int, y: int) -> bool:
	return x >= 0 and y >= 0 and x < int(plan["w"]) and y < int(plan["h"])


## Everything that makes this plan not read like a real gym; [] = it is sound.
static func problems(plan: Dictionary) -> Array:
	var out: Array = []
	_zones(plan, out)
	_entrance(plan, out)
	var taken := _items(plan, out)
	_clearance(plan, taken, out)
	if out.is_empty():
		_reach(plan, taken, out)
	return out


static func _zones(plan: Dictionary, out: Array) -> void:
	var kinds := {}
	var seen := {}
	for z in plan["zones"]:
		kinds[str(z["kind"])] = true
		for y in range(int(z["y"]), int(z["y"]) + int(z["h"])):
			for x in range(int(z["x"]), int(z["x"]) + int(z["w"])):
				if not _inside(plan, x, y):
					out.append("%s runs outside the building" % str(WORD.get(str(z["kind"]), z["kind"])).capitalize())
					return
				if seen.has(Vector2i(x, y)):
					out.append("%s overlaps another zone" % str(WORD.get(str(z["kind"]), z["kind"])).capitalize())
					return
				seen[Vector2i(x, y)] = true
		if str(z["kind"]) in WALLED and not _good_room_door(plan, z):
			out.append("%s needs a door in its own wall" % str(WORD.get(str(z["kind"]), z["kind"])).capitalize())
	for k in NEEDED:
		if not kinds.has(k):
			out.append("The gym has no %s" % str(WORD[k]).replace("the ", ""))


static func _good_room_door(plan: Dictionary, z: Dictionary) -> bool:
	if not z.has("door"):
		return false
	var x := int(z["door"][0])
	var y := int(z["door"][1])
	if zone_at(plan, x, y) != z:
		return false
	for d in [Vector2i.LEFT, Vector2i.RIGHT, Vector2i.UP, Vector2i.DOWN]:
		var n: Vector2i = Vector2i(x, y) + d
		if _inside(plan, n.x, n.y) and zone_at(plan, n.x, n.y) != z:
			return true
	return false


static func _entrance(plan: Dictionary, out: Array) -> void:
	var x := int(plan["door"][0])
	var y := int(plan["door"][1])
	if not _inside(plan, x, y) or not (x == 0 or y == 0 or x == int(plan["w"]) - 1 or y == int(plan["h"]) - 1):
		out.append("The entrance must be in an outside wall")
		return
	if str(zone_at(plan, x, y).get("kind", "")) != "reception":
		out.append("The entrance must open into reception")


## Tile -> item kind; complains about items outside their zone or on top of each other.
static func _items(plan: Dictionary, out: Array) -> Dictionary:
	var taken := {}
	for it in expand(plan):
		if (it["in"] as Array).is_empty():
			out.append("Unknown item: %s" % it["kind"])
			continue
		for y in range(int(it["y"]), int(it["y"]) + int(it["h"])):
			for x in range(int(it["x"]), int(it["x"]) + int(it["w"])):
				var at := Vector2i(x, y)
				if not _inside(plan, x, y) or not (it["in"] as Array).has(str(zone_at(plan, x, y).get("kind", ""))):
					out.append("A %s stands outside its zone" % str(it["kind"]).replace("_", " "))
					return taken
				if taken.has(at):
					out.append("A %s stands on top of something" % str(it["kind"]).replace("_", " "))
					return taken
				taken[at] = str(it["kind"])
	return taken


## A ring needs a clear walkway all round, inside the building.
static func _clearance(plan: Dictionary, taken: Dictionary, out: Array) -> void:
	for it in expand(plan):
		var c := int(it["clear"])
		if c <= 0:
			continue
		for y in range(int(it["y"]) - c, int(it["y"]) + int(it["h"]) + c):
			for x in range(int(it["x"]) - c, int(it["x"]) + int(it["w"]) + c):
				var within := x >= int(it["x"]) and x < int(it["x"]) + int(it["w"]) and y >= int(it["y"]) and y < int(it["y"]) + int(it["h"])
				if within:
					continue
				if not _inside(plan, x, y) or taken.has(Vector2i(x, y)):
					out.append("The %s needs clear floor all round" % str(it["kind"]))
					return


## Can a person walk from the front door to every zone? Rooms with walls open only at their own door.
static func _reach(plan: Dictionary, taken: Dictionary, out: Array) -> void:
	var start := Vector2i(int(plan["door"][0]), int(plan["door"][1]))
	if taken.has(start):
		out.append("The entrance is blocked")
		return
	var seen := {start: true}
	var queue: Array = [start]
	while not queue.is_empty():
		var a: Vector2i = queue.pop_back()
		for d in [Vector2i.LEFT, Vector2i.RIGHT, Vector2i.UP, Vector2i.DOWN]:
			var b: Vector2i = a + d
			if not _inside(plan, b.x, b.y) or taken.has(b) or seen.has(b) or not _can_step(plan, a, b):
				continue
			seen[b] = true
			queue.append(b)
	for z in plan["zones"]:
		var reached := false
		for y in range(int(z["y"]), int(z["y"]) + int(z["h"])):
			for x in range(int(z["x"]), int(z["x"]) + int(z["w"])):
				reached = reached or seen.has(Vector2i(x, y))
		if not reached:
			out.append("You cannot walk to %s" % str(WORD.get(str(z["kind"]), z["kind"])))


static func _can_step(plan: Dictionary, a: Vector2i, b: Vector2i) -> bool:
	var za := zone_at(plan, a.x, a.y)
	var zb := zone_at(plan, b.x, b.y)
	if za == zb:
		return true
	return _may_cross(za, a) and _may_cross(zb, b)


static func _may_cross(z: Dictionary, t: Vector2i) -> bool:
	if z.is_empty() or not (str(z["kind"]) in WALLED):
		return true
	return z.has("door") and Vector2i(int(z["door"][0]), int(z["door"][1])) == t
