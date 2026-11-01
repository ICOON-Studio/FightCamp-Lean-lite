extends RefCounted
## PlanBoard: the coach's plan board - arrows on a move map.
## A MAP is an Array of move rows (id, from, to, optional kind, optional reaction).
## A PLAN is an Array of arrows {"move": <row id>}.
## Pure static lookups; preloads nothing (sport-free).

const NEW_COACH := 4
const TOP_COACH := 9
const UNDRILLED := 0.8


static func arrow_limit(coach_skill: float) -> int:
	return clampi(4 + roundi((coach_skill - 30) / 12), NEW_COACH, TOP_COACH)


static func row(map: Array, id: String) -> Dictionary:
	for m in map:
		if str(m["id"]) == id:
			return m
	return {}


static func validate(plan: Array, map: Array, limit: int) -> Dictionary:
	var problems: Array = []

	# Check count
	if plan.size() > limit:
		problems.append("%d arrows - this coach can hold %d" % [plan.size(), limit])

	# Check each arrow
	var by_place: Dictionary = {}
	for arrow in plan:
		var move_id := str(arrow["move"])
		var r := row(map, move_id)

		# Unknown move
		if r.is_empty():
			problems.append("No move '%s' on this map" % move_id)
			continue

		# Forced move
		if str(r.get("kind", "")) == "forced":
			problems.append("'%s' happens to her - it cannot be planned" % str(r.get("name", move_id)))
			continue

		# Track by place (from + reaction)
		var place := str(r["from"]) + ":" + str(r.get("reaction", ""))
		if not by_place.has(place):
			by_place[place] = []
		by_place[place].append(move_id)

	# Check for duplicate places
	for place in by_place:
		if by_place[place].size() > 1:
			var parts: PackedStringArray = place.split(":")
			var from: String = str(parts[0])
			var reaction: String = str(parts[1]) if parts.size() > 1 else ""
			if reaction == "":
				problems.append("Two arrows from %s - pick one" % from)
			else:
				problems.append("Two answers when she %s at %s" % [reaction, from])

	return {"ok": problems.is_empty(), "problems": problems}


static func pick(plan: Array, map: Array, at: String, reaction := "") -> String:
	for arrow in plan:
		var move_id := str(arrow["move"])
		var r := row(map, move_id)
		if r.is_empty():
			continue
		if str(r["from"]) == at and str(r.get("reaction", "")) == reaction:
			return move_id
	return ""


static func coverage(plan: Array, map: Array) -> float:
	# Count plannable places (distinct from+reaction among non-forced rows)
	var plannable: Dictionary = {}
	for m in map:
		if str(m.get("kind", "")) == "forced":
			continue
		var key := str(m["from"]) + ":" + str(m.get("reaction", ""))
		plannable[key] = true

	if plannable.is_empty():
		return 0.0

	# Count planned places
	var planned: Dictionary = {}
	for arrow in plan:
		var move_id := str(arrow["move"])
		var r := row(map, move_id)
		if r.is_empty():
			continue
		if str(r.get("kind", "")) == "forced":
			continue
		var key := str(r["from"]) + ":" + str(r.get("reaction", ""))
		planned[key] = true

	return float(planned.size()) / float(plannable.size())


static func chains(plan: Array, map: Array, start: String, steps: int) -> Array:
	var result: Array = []
	var at := start
	var seen: Dictionary = {}

	for i in steps:
		# Find arrow at this place
		var move_id := ""
		for arrow in plan:
			var mid := str(arrow["move"])
			var r := row(map, mid)
			if r.is_empty():
				continue
			if str(r["from"]) == at:
				move_id = mid
				break

		if move_id == "":
			break

		# Check for repeat
		if seen.has(move_id):
			break
		seen[move_id] = true

		result.append(move_id)
		var r := row(map, move_id)
		at = str(r["to"])

	return result


static func change_one(plan: Array, index: int, move_id: String) -> Array:
	var result: Array = []
	for i in plan.size():
		if i == index:
			result.append({"move": move_id})
		else:
			result.append(plan[i])
	return result


static func rate(move_id: String, drilled: Array) -> float:
	if drilled.has(move_id):
		return 1.0
	return UNDRILLED
