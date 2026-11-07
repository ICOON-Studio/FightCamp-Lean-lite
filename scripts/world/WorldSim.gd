extends RefCounted
## Simulates bouts the player is not in: rating gap + luck, stoppages more likely at big gaps.
## Records, ranks and belts move every month. Rival boxers improve too.

const WA := preload("res://scripts/world/WorldAge.gd")
const WR := preload("res://scripts/world/WorldRank.gd")
const WG := preload("res://scripts/world/WorldGen.gd")

const LUCK_SPREAD := 8.0
const STOPPAGE_GAP_THRESHOLD := 6.0
const STOPPAGE_CHANCE_PER_POINT := 0.04
const UPSET_BONUS := 0.3


static func simulate_month(divisions: Dictionary, rng: RandomNumberGenerator) -> Dictionary:
	var results: Array = []
	var belt_changes: Array = []
	for div_id in divisions:
		var div: Dictionary = divisions[div_id]
		var div_results := _simulate_division_month(div["boxers"], rng)
		results.append_array(div_results)
	return {"results": results, "belt_changes": belt_changes}


static func _simulate_division_month(boxers: Array, rng: RandomNumberGenerator) -> Array:
	var active: Array = []
	for b in boxers:
		if not b.get("retired", false) and int(b.get("rank", 0)) > 0:
			active.append(b)
	if active.size() < 2:
		return []
	var fights_this_month := maxi(1, active.size() / 6)
	var results: Array = []
	var fought: Dictionary = {}
	for i in fights_this_month:
		var a_idx := _pick_fighter(active, fought, rng)
		if a_idx < 0:
			break
		var b_idx := _pick_opponent(active, a_idx, fought, rng)
		if b_idx < 0:
			continue
		var a: Dictionary = active[a_idx]
		var b: Dictionary = active[b_idx]
		var result := simulate_bout(a, b, boxers, rng)
		results.append(result)
		fought[a_idx] = true
		fought[b_idx] = true
	return results


static func _pick_fighter(active: Array, fought: Dictionary, rng: RandomNumberGenerator) -> int:
	var candidates: Array = []
	for i in active.size():
		if not fought.has(i):
			candidates.append(i)
	if candidates.is_empty():
		return -1
	return candidates[rng.randi_range(0, candidates.size() - 1)]


static func _pick_opponent(active: Array, a_idx: int, fought: Dictionary, rng: RandomNumberGenerator) -> int:
	var a_rank := int(active[a_idx]["rank"])
	var candidates: Array = []
	for i in active.size():
		if i == a_idx or fought.has(i):
			continue
		var b_rank := int(active[i]["rank"])
		if absi(a_rank - b_rank) <= 5:
			candidates.append(i)
	if candidates.is_empty():
		for i in active.size():
			if i != a_idx and not fought.has(i):
				candidates.append(i)
	if candidates.is_empty():
		return -1
	return candidates[rng.randi_range(0, candidates.size() - 1)]


static func simulate_bout(a: Dictionary, b: Dictionary, division_boxers: Array, rng: RandomNumberGenerator) -> Dictionary:
	var a_power := float(a["rating"]) + (rng.randf() - 0.5) * LUCK_SPREAD
	var b_power := float(b["rating"]) + (rng.randf() - 0.5) * LUCK_SPREAD
	var winner: Dictionary
	var loser: Dictionary
	if a_power >= b_power:
		winner = a
		loser = b
	else:
		winner = b
		loser = a
	var gap := absf(float(winner["rating"]) - float(loser["rating"]))
	var stoppage := _roll_stoppage(gap, rng)
	_apply_bout_result(winner, loser, stoppage, division_boxers)
	return {
		"winner": winner["name"],
		"loser": loser["name"],
		"winner_rank": int(winner["rank"]),
		"loser_rank": int(loser["rank"]),
		"winner_id": int(winner.get("id", 0)),
		"stoppage": stoppage,
		"gap": gap,
	}


static func _roll_stoppage(gap: float, rng: RandomNumberGenerator) -> bool:
	if gap < STOPPAGE_GAP_THRESHOLD:
		return false
	var chance := (gap - STOPPAGE_GAP_THRESHOLD) * STOPPAGE_CHANCE_PER_POINT
	return rng.randf() < minf(0.5, chance)


static func _apply_bout_result(winner: Dictionary, loser: Dictionary, stoppage: bool, division_boxers: Array) -> void:
	winner["w"] = int(winner.get("w", 0)) + 1
	if stoppage:
		winner["ko"] = int(winner.get("ko", 0)) + 1
	loser["l"] = int(loser.get("l", 0)) + 1
	var gap := absf(float(winner["rating"]) - float(loser["rating"]))
	WA.record_bout(winner, gap)
	WA.record_bout(loser, gap)
	if stoppage:
		WA.record_stoppage_loss(loser)
	WR.apply_result_in(winner, loser, division_boxers)
	_check_belt(winner, loser, division_boxers)


## Beating a champion takes the belt, unless the winner already holds a higher one (then it was not a title bout).
## A winner who moves up leaves the lower belt vacant; the year end fills it.
static func _check_belt(winner: Dictionary, loser: Dictionary, _division_boxers: Array) -> void:
	var lb: String = loser.get("belt", "")
	if lb == "":
		return
	var wb: String = winner.get("belt", "")
	if wb != "" and WR.level_index(wb) >= WR.level_index(lb):
		return
	loser["belt"] = ""
	winner["belt"] = lb


static func simulate_year(divisions: Dictionary, rng: RandomNumberGenerator) -> Dictionary:
	var all_results: Array = []
	for month in 12:
		var month_result := simulate_month(divisions, rng)
		all_results.append_array(month_result["results"])
	var age_result := {"retired": [], "arrived": [], "crowned": []}
	var gen := preload("res://scripts/world/WorldGen.gd").new()
	gen._load_data()
	gen._next_id = _next_id(divisions)
	for div_id in divisions:
		var div: Dictionary = divisions[div_id]
		var tick: Dictionary = WA.tick_year(div["boxers"], rng)
		age_result["retired"].append_array(tick["retired"])
		for b in tick["retired"]:
			WR.vacate_belt(b, div["boxers"])
		var new_boxers := _generate_arrivals(gen, div, tick["retired"].size(), rng)
		age_result["arrived"].append_array(new_boxers)
		div["boxers"].append_array(new_boxers)
		WR.refresh_ranks(div["boxers"], WG.RANKED_PER_DIVISION)
		age_result["crowned"].append_array(_fill_vacant_belts(div, rng))
	return {"results": all_results, "age": age_result}


static func _next_id(divisions: Dictionary) -> int:
	var top := 0
	for div_id in divisions:
		for b in divisions[div_id]["boxers"]:
			top = maxi(top, int(b.get("id", 0)))
	return top + 1


## Each empty belt goes to the winner of the two best-ranked boxers below that level, top belt first,
## so a contender who steps up leaves a lower belt that the next pass fills.
static func _fill_vacant_belts(div: Dictionary, rng: RandomNumberGenerator) -> Array:
	var boxers: Array = div["boxers"]
	var orgs: Dictionary = div.get("belt_orgs", {})
	var crowned: Array = []
	var levels: Array = WR.BELT_LEVELS.duplicate()
	levels.reverse()
	for level in levels:
		if not orgs.has(level) or not WR.champion_of(boxers, level).is_empty():
			continue
		var below: Array = boxers.filter(func(b): return not b.get("retired", false) and int(b.get("rank", 0)) > 0 			and WR.level_index(str(b.get("belt", ""))) < WR.BELT_LEVELS.find(level))
		below.sort_custom(func(a, b): return int(a["rank"]) < int(b["rank"]))
		if below.size() < 2:
			continue
		var res := simulate_bout(below[0], below[1], boxers, rng)
		var champ: Dictionary = below[0] if int(res["winner_id"]) == int(below[0]["id"]) else below[1]
		WR.award_belt(champ, level, str(orgs[level]))
		crowned.append({"level": level, "name": champ["name"], "id": int(champ["id"])})
	return crowned


static func _generate_arrivals(gen: RefCounted, div: Dictionary, retire_count: int, rng: RandomNumberGenerator) -> Array:
	var arrivals: Array = []
	var to_generate := maxi(1, retire_count)
	for i in to_generate:
		var sex: String = div["info"]["sex"]
		var firsts: Array = gen._pick_names(rng, sex, 1)
		var lasts: Array = gen._pick_surnames(rng, 1)
		var clubs: Array = gen._pick_clubs(rng, 1)
		var b: Dictionary = gen._make_boxer(rng, firsts[0], lasts[0], clubs[0], sex, div["info"]["id"], false, rng.randi())
		b["rank"] = 0
		arrivals.append(b)
	return arrivals
