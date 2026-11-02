extends RefCounted
## PlanBoard: the coach's plan board - arrows on a move map.
## A MAP is an Array of move rows (id, from, to, optional kind, optional reaction).
## A PLAN is an Array of arrows {"move": <row id>, "when": <situation id, optional>}.
## S341 branches (fight flows step 2): a boxing arrow may carry `when` - the opponent's game it answers ("press", "tiring"...;
## "" = any time). A place is from + when (a wrestling row's own `reaction` plays that part), so a card may hold one arrow
## per situation plus one for any time; pick() takes the situation's arrow first, else the any-time one.
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


## `words` names a when in the coach's words for the problem lines ({"press": "she presses"}; boxing: FightFlow.WHEN_WORDS).
static func validate(plan: Array, map: Array, limit: int, words := {}) -> Dictionary:
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
			problems.append("'%s' is done to your fighter - it cannot be planned" % str(r.get("name", move_id)))
			continue

		# Track by place (from + reaction, or from + the arrow's when)
		var place := str(r["from"]) + ":" + when_of(arrow, r)
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
			elif words.has(reaction):
				problems.append("Two arrows from %s when %s - pick one" % [from, str(words[reaction])])
			else:
				problems.append("Two answers when she %s at %s" % [reaction, from])

	return {"ok": problems.is_empty(), "problems": problems}


## The arrow to throw at `at`: a wrestling row's own reaction must match; a boxing arrow for this situation (`when`)
## beats the card's any-time arrow.
static func pick(plan: Array, map: Array, at: String, reaction := "", when := "") -> String:
	var any := ""
	for arrow in plan:
		var move_id := str(arrow["move"])
		var r := row(map, move_id)
		if r.is_empty() or str(r["from"]) != at or str(r.get("reaction", "")) != reaction:
			continue
		var w := str(arrow.get("when", ""))
		if w != "" and w == when:
			return move_id
		if w == "" and any == "":
			any = move_id
	return any


## The arrow's place key beside its card: the row's reaction (wrestling), else the arrow's when (boxing; "" = any time).
static func when_of(arrow: Dictionary, r: Dictionary) -> String:
	var reaction := str(r.get("reaction", ""))
	return reaction if reaction != "" else str(arrow.get("when", ""))


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
			if r.is_empty() or str(arrow.get("when", "")) != "":
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
			# S341: the new move answers the same situation as the arrow it replaces.
			var w := str(plan[i].get("when", ""))
			result.append({"move": move_id, "when": w} if w != "" else {"move": move_id})
		else:
			result.append(plan[i])
	return result


static func rate(move_id: String, drilled: Array) -> float:
	if drilled.has(move_id):
		return 1.0
	return UNDRILLED
