extends SceneTree
## S408 a gym has to read like a real building: every preset is sound, and each way of breaking one is caught by name.

const GymPlan := preload("res://scripts/rules/GymPlan.gd")

var failures := 0


func _initialize() -> void:
	var plans: Array = GymPlan.load_all()
	_check(plans.size() == 4, "four preset gyms (%d)" % plans.size())
	var bonuses := {}
	for p in plans:
		var bad: Array = GymPlan.problems(p)
		_check(bad.is_empty(), "%s is sound: %s" % [p["id"], str(bad)])
		_check(str(p["bonus"]["words"]) != "", "%s says its bonus" % p["id"])
		bonuses[str(p["bonus"]["kind"])] = true
	_check(bonuses.size() == 4, "each gym has its own kind of bonus")
	var base: Dictionary = plans[0]
	_breaks(base, func(p): p["door"] = [12, 2], "outside wall")
	_breaks(base, func(p): p["door"] = [23, 15], "open into reception")
	_breaks(base, func(p): p["items"][0]["x"] = 18, "outside its zone")
	_breaks(base, _overlap, "overlaps")
	_breaks(base, func(p): p["zones"][1].erase("door"), "needs a door")
	_breaks(base, func(p): p["items"].append({"kind": "desk", "x": 2, "y": 13}), "on top of")
	_breaks(base, func(p): p["items"].append({"kind": "desk", "x": 2, "y": 17}), "entrance is blocked")
	_breaks(base, _no_mats, "no mats")
	_breaks(base, func(p): p["items"].append({"kind": "bag", "x": 10, "y": 12}), "outside its zone")
	_breaks(base, _ring_on_edge, "clear floor")
	print("GYM_PLAN failures=%d" % failures)
	quit(1 if failures > 0 else 0)


func _overlap(p: Dictionary) -> void:
	p["zones"][5]["x"] = 12
	p["zones"][5]["w"] = 9
	p["items"][0]["x"] = 13


func _no_mats(p: Dictionary) -> void:
	p["zones"].remove_at(6)
	p["items"].remove_at(8)


## The ring pushed up against the building's north wall, its zone with it.
func _ring_on_edge(p: Dictionary) -> void:
	p["zones"][3]["w"] = 1
	p["zones"][5]["y"] = 0
	p["items"][0]["y"] = 0


func _breaks(base: Dictionary, change: Callable, want: String) -> void:
	var p: Dictionary = base.duplicate(true)
	change.call(p)
	var bad := str(GymPlan.problems(p))
	_check(bad.find(want) >= 0, "breaking it says '%s': %s" % [want, bad])


func _check(ok: bool, what: String) -> void:
	if not ok:
		failures += 1
		print("FAIL: ", what)
