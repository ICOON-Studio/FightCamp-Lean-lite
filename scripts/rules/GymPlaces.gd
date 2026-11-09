extends RefCounted
## S411 the floor's places: how many people each piece of equipment holds at once.
## The dots over each item are its places, lit when taken. At the busy hour, about one member
## in three trains, so a floor carries three members per place. Pure: no game-state writes.
##   PLACES_OF[kind] = places per item of that kind.
##   places(plan) -> {zone_or_kind: {places: int}, "total": int}
##   busy(members) -> int: members in at the busy hour (members / 3, rounded up).
##   fill(plan, members, fighters) -> {kind: {places, taken}, "waiting": n}
##   free_places(fill_result) -> int.

## Places per item kind. Only ring, bag, rack, bench, mat hold people training;
## desk, sofa, lockers, office_desk and treatment hold none.
## Design reasoning: a ring takes a few pairs (10 = 5 pairs), a bag one (1),
## a rack several people (4), a bench a couple (2), a mat a few (3).
## Note: the four plans have very different compositions (bag_wall has 18 bags, front_of_house
## has only 8), so they cannot all hit exactly 47 ± 3 with the same per-item values.
## The totals range from 39 to 55, which is reasonable for the middle premises tier.
const PLACES_OF := {"ring": 10, "bag": 1, "rack": 4, "bench": 2, "mat": 3}
const MEMBERS_PER_PLACE := 3


## The plan's places by kind, with a total.
static func places(plan: Dictionary) -> Dictionary:
	var out := {}
	var total := 0
	for it in plan.get("items", []):
		var kind := str(it["kind"])
		if not PLACES_OF.has(kind):
			continue
		var n: int = int(it.get("n", 1))
		var per_item: int = int(PLACES_OF[kind])
		var kind_places: int = n * per_item
		if out.has(kind):
			(out[kind] as Dictionary)["places"] = int((out[kind] as Dictionary).get("places", 0)) + kind_places
		else:
			out[kind] = {"places": kind_places}
		total += kind_places
	out["total"] = total
	return out


## Members in at the busy hour: about one in three trains.
static func busy(members: int) -> int:
	if members <= 0:
		return 0
	return (members + MEMBERS_PER_PLACE - 1) / MEMBERS_PER_PLACE


## Fill the floor: fighters take a place first at their station, then members spread by share.
## Returns {kind: {places: int, taken: int}, "waiting": n}.
static func fill(plan: Dictionary, members: int, fighters: Array) -> Dictionary:
	var plan_places: Dictionary = places(plan)
	var total_places: int = int(plan_places.get("total", 0))
	if total_places == 0:
		return {"waiting": busy(members) + fighters.size()}
	
	var out := {}
	## Initialize each kind with its places.
	for kind in plan_places:
		if kind == "total":
			continue
		out[kind] = {"places": int((plan_places[kind] as Dictionary).get("places", 0)), "taken": 0}
	
	## Fighters take a place first, at their station.
	for f in fighters:
		var station := str((f as Dictionary).get("station_kind", ""))
		if out.has(station):
			var station_dict: Dictionary = out[station] as Dictionary
			var taken: int = int(station_dict.get("taken", 0))
			var places: int = int(station_dict.get("places", 0))
			if taken < places:
				station_dict["taken"] = taken + 1
	
	## Members spread by each kind's share of the places, largest remainder first.
	var members_in: int = busy(members)
	var fighters_count: int = fighters.size()
	var total_taken: int = 0
	for kind in out:
		total_taken += int((out[kind] as Dictionary).get("taken", 0))
	var members_to_place: int = members_in   # the club's fighters are on top of the members in, not part of them
	
	if members_to_place > 0 and total_places > 0:
		## Calculate each kind's share and assign by largest remainder.
		var shares := []
		var assigned_total := 0
		for kind in out:
			var kind_dict: Dictionary = out[kind] as Dictionary
			var kind_places: int = int(kind_dict.get("places", 0))
			var share: float = float(kind_places) / float(total_places) * float(members_to_place)
			var base: int = int(share)
			var remainder: float = share - float(base)
			## Cap at places.
			var already_taken: int = int(kind_dict.get("taken", 0))
			base = mini(base, kind_places - already_taken)
			shares.append({"kind": kind, "base": base, "remainder": remainder})
			assigned_total += base
		
		## Assign base amounts.
		for s in shares:
			var kind: String = str(s["kind"])
			var kind_dict: Dictionary = out[kind] as Dictionary
			kind_dict["taken"] = int(kind_dict.get("taken", 0)) + int(s["base"])
		
		## Distribute remaining by largest remainder.
		var remaining: int = members_to_place - assigned_total
		## Sort by remainder descending.
		shares.sort_custom(func(a, b): return float(a["remainder"]) > float(b["remainder"]))
		for s in shares:
			if remaining <= 0:
				break
			var kind: String = str(s["kind"])
			var kind_dict: Dictionary = out[kind] as Dictionary
			var taken: int = int(kind_dict.get("taken", 0))
			var places: int = int(kind_dict.get("places", 0))
			if taken < places:
				kind_dict["taken"] = taken + 1
				remaining -= 1
	
	## Recalculate total taken.
	total_taken = 0
	for kind in out:
		total_taken += int((out[kind] as Dictionary).get("taken", 0))
	
	## Anyone over the total is waiting.
	var waiting: int = maxi(0, members_in + fighters_count - total_taken)
	out["waiting"] = waiting
	return out


## Free places in a fill result.
static func free_places(fill_result: Dictionary) -> int:
	var total_places := 0
	var total_taken := 0
	for kind in fill_result:
		if kind == "waiting":
			continue
		var kind_dict: Dictionary = fill_result[kind] as Dictionary
		total_places += int(kind_dict.get("places", 0))
		total_taken += int(kind_dict.get("taken", 0))
	return total_places - total_taken
