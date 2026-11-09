extends SceneTree
## S409 people on the gym floor keep to GymPlan's rules, on every preset: every place to stand is real floor, reachable from
## the door, and a walk never crosses equipment or a wall.

const GymPlan := preload("res://scripts/rules/GymPlan.gd")
const GymPeople := preload("res://scripts/rules/GymPeople.gd")

var failures := 0


func _initialize() -> void:
	var plans: Array = GymPlan.load_all()
	_check(plans.size() >= 4, "four presets load (%d)" % plans.size())
	for plan in plans:
		_plan(plan)
	_blocked_walk()
	_crowd()
	print("GYM_PEOPLE failures=%d" % failures)
	quit(1 if failures > 0 else 0)


func _plan(plan: Dictionary) -> void:
	var name_: String = str(plan["id"])
	var spots := GymPeople.spots(plan)
	_check(spots.size() >= GymPeople.MAX_PEOPLE, "%s has room for a full gym (%d places)" % [name_, spots.size()])
	var blocked := GymPlan.taken(plan)
	var door := Vector2i(int(plan["door"][0]), int(plan["door"][1]))
	var seen := {}
	var kinds := {}
	for s in spots:
		var at: Vector2i = s["at"]
		_check(not blocked.has(at), "%s: place %s is clear floor" % [name_, at])
		_check(not seen.has(at), "%s: place %s is used once" % [name_, at])
		seen[at] = true
		kinds[str(s["kind"])] = true
		var path := GymPeople.route(plan, door, at)
		_check(path.size() >= 1 and path[0] == door and path[-1] == at, "%s: the door reaches %s" % [name_, at])
		for i in range(1, path.size()):
			var a: Vector2i = path[i - 1]
			var b: Vector2i = path[i]
			_check(absi(a.x - b.x) + absi(a.y - b.y) == 1, "%s: one tile at a time" % name_)
			_check(GymPlan.can_walk(plan, blocked, a, b), "%s: step %s to %s is allowed" % [name_, a, b])
	_check(kinds.has("bag"), "%s: someone can work a bag" % name_)


## A made-up room split by a wall of equipment: no way through means no route, and a figure never gets one.
func _blocked_walk() -> void:
	var plan := {"w": 5, "h": 3, "door": [0, 1], "zones": [{"id": "a", "kind": "bags", "x": 0, "y": 0, "w": 5, "h": 3}],
		"items": [{"kind": "bag", "x": 2, "y": 0}, {"kind": "bag", "x": 2, "y": 1}, {"kind": "bag", "x": 2, "y": 2}]}
	_check(GymPeople.route(plan, Vector2i(0, 1), Vector2i(4, 1)).is_empty(), "no route through a row of bags")
	_check(GymPeople.route(plan, Vector2i(0, 1), Vector2i(0, 2)).size() == 2, "a route next door is one step")


func _crowd() -> void:
	_check(GymPeople.crowd(0, []).size() == GymPeople.MIN_PEOPLE, "an empty club still has two people in")
	_check(GymPeople.crowd(30, []).size() == 8, "30 members bring 8 people (%d)" % GymPeople.crowd(30, []).size())
	_check(GymPeople.crowd(500, []).size() == GymPeople.MAX_PEOPLE, "a huge club stops at the cap")
	_check(GymPeople.crowd(500, [], 0).size() == 6 and GymPeople.crowd(500, [], 1).size() == 9 and GymPeople.crowd(500, [], 2).size() == 12, "the most on the floor at once scales with the premises (S416)")
	var mine := GymPeople.crowd(30, ["mh_boxer_20", "mh_boxer_12"])
	_check(mine[0] == "mh_boxer_20" and mine[1] == "mh_boxer_12", "the club's own fighters are in first")
	var dupes := {}
	for s in mine:
		dupes[s] = true
	_check(dupes.size() == mine.size(), "nobody is in twice")


func _check(ok: bool, what: String) -> void:
	if not ok:
		failures += 1
		print("FAIL: ", what)
