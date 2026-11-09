extends SceneTree
## S411 the floor's places: each piece of equipment holds a certain number of people training.
## The four plans for the bigger unit (140 members) should each have about 47 places.

const GymPlan := preload("res://scripts/rules/GymPlan.gd")
const GymPlaces := preload("res://scripts/rules/GymPlaces.gd")

var failures := 0


func _initialize() -> void:
	var plans: Array = GymPlan.load_all()
	_check(plans.size() == 4, "four preset gyms (%d)" % plans.size())
	print("Population: 140 members, 47 places target")
	_totals(plans)
	_busy()
	_fighters_add()
	_fill()
	_free()
	_edge()
	print("GYM_PLACES failures=%d" % failures)
	quit(1 if failures > 0 else 0)


## Each plan's total places should be reasonable (within ±10 of 47 given the different compositions).
func _totals(plans: Array) -> void:
	for plan in plans:
		var result: Dictionary = GymPlaces.places(plan)
		var total: int = int(result["total"])
		var dev: int = absi(total - 47)
		_check(dev <= 10, "%s total %d is within 10 of 47 (dev %d)" % [plan["id"], total, dev])


## 140 members at the busy hour: busy(140) = ceil(140/3) = 47, should fill a 47-place floor.
func _busy() -> void:
	var busy_140: int = GymPlaces.busy(140)
	_check(busy_140 == 47, "140 members -> 47 at busy hour (%d)" % busy_140)
	var busy_30: int = GymPlaces.busy(30)
	_check(busy_30 == 10, "30 members -> 10 at busy hour (%d)" % busy_30)
	var busy_0: int = GymPlaces.busy(0)
	_check(busy_0 == 0, "0 members -> 0 at busy hour (%d)" % busy_0)


## Fill: fighters take places first, then members spread by share.
func _fill() -> void:
	var plans: Array = GymPlan.load_all()
	var plan: Dictionary = plans[0]  # front_of_house
	var total_places: int = int(GymPlaces.places(plan)["total"])
	
	## 140 members fills the floor (within 3).
	var fill_140: Dictionary = GymPlaces.fill(plan, 140, [])
	var taken_140: int = 0
	for kind in fill_140:
		if kind != "waiting":
			taken_140 += int((fill_140[kind] as Dictionary).get("taken", 0))
	var waiting_140: int = int(fill_140.get("waiting", 0))
	var busy_140: int = GymPlaces.busy(140)
	_check(absi(taken_140 - total_places) <= 3, "140 members fills floor: taken %d, places %d" % [taken_140, total_places])
	_check(taken_140 + waiting_140 == busy_140, "taken + waiting = busy: %d + %d = %d" % [taken_140, waiting_140, busy_140])
	
	## 30 members leaves most free.
	var fill_30: Dictionary = GymPlaces.fill(plan, 30, [])
	var taken_30: int = 0
	for kind in fill_30:
		if kind != "waiting":
			taken_30 += int((fill_30[kind] as Dictionary).get("taken", 0))
	_check(taken_30 < total_places / 2, "30 members leaves most free: taken %d, places %d" % [taken_30, total_places])
	
	## A fighter at the bags takes a bag place before any member.
	var fighters := [{"id": "f1", "station_kind": "bag"}]
	var fill_fighter: Dictionary = GymPlaces.fill(plan, 0, fighters)
	var bag_taken: int = int((fill_fighter.get("bag", {}) as Dictionary).get("taken", 0))
	_check(bag_taken >= 1, "fighter at bags takes a bag place (%d)" % bag_taken)
	
	## Taken never exceeds places for members 0 to 400.
	for members in [0, 50, 100, 200, 400]:
		var fill: Dictionary = GymPlaces.fill(plan, members, [])
		for kind in fill:
			if kind == "waiting":
				continue
			var places: int = int((fill[kind] as Dictionary).get("places", 0))
			var taken: int = int((fill[kind] as Dictionary).get("taken", 0))
			_check(taken <= places, "%s: taken %d <= places %d (members=%d)" % [kind, taken, places, members])


## Free places.
func _free() -> void:
	var plans: Array = GymPlan.load_all()
	var plan: Dictionary = plans[0]
	var fill_empty: Dictionary = GymPlaces.fill(plan, 0, [])
	var free_empty: int = GymPlaces.free_places(fill_empty)
	var total_places: int = int(GymPlaces.places(plan)["total"])
	_check(free_empty == total_places, "empty floor: free %d = places %d" % [free_empty, total_places])
	
	var fill_140: Dictionary = GymPlaces.fill(plan, 140, [])
	var free_140: int = GymPlaces.free_places(fill_140)
	_check(free_140 >= 0 and free_140 <= 3, "140 members: free %d is small" % free_140)


## Edge cases.
func _edge() -> void:
	## A plan with no training items returns total 0 without error.
	var empty_plan := {"id": "empty", "zones": [], "items": []}
	var result: Dictionary = GymPlaces.places(empty_plan)
	_check(int(result["total"]) == 0, "empty plan has 0 places (%d)" % int(result["total"]))


## S411 found on review: fighters are on top of the members in, so an empty floor leaves nobody waiting.
func _fighters_add() -> void:
	var plan: Dictionary = GymPlan.load_all()[0]
	var r: Dictionary = GymPlaces.fill(plan, 30, [{"id": "a", "station_kind": "bag"}, {"id": "b", "station_kind": "ring"}])
	var taken := 0
	for kind in r:
		if kind != "waiting":
			taken += int((r[kind] as Dictionary)["taken"])
	_check(int(r["waiting"]) == 0, "room to spare: nobody waits (%d)" % int(r["waiting"]))
	_check(taken == GymPlaces.busy(30) + 2, "two fighters and the members in all have places (%d)" % taken)


func _check(ok: bool, what: String) -> void:
	if not ok:
		failures += 1
		print("FAIL: ", what)
