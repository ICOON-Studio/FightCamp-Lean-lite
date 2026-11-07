extends RefCounted
## Rankings that move by taking places: beat someone above you and you take their spot, beat someone below and nothing moves.
## Champions per belt level, mandatory challengers, vacated belts when a champion retires.

const BELT_LEVELS := ["area", "national", "continental", "world"]


## A new world's first table: everyone active, best rating first. Used once at generation.
static func rank_division(boxers: Array) -> Array:
	var active: Array = []
	for b in boxers:
		if not b.get("retired", false):
			active.append(b)
	active.sort_custom(func(a, b): return float(a["rating"]) > float(b["rating"]))
	for i in active.size():
		active[i]["rank"] = i + 1
	return active


## The year-end table: the ranked keep the order they fought for (retired drop out, the gaps close),
## then the open places go to the best-rated unranked. Everyone past `size` is unranked (rank 0).
static func refresh_ranks(boxers: Array, size: int) -> void:
	var ranked: Array = []
	var waiting: Array = []
	for b in boxers:
		if b.get("retired", false):
			b["rank"] = 0
		elif int(b.get("rank", 0)) > 0:
			ranked.append(b)
		else:
			waiting.append(b)
	ranked.sort_custom(func(a, b): return int(a["rank"]) < int(b["rank"]))
	waiting.sort_custom(func(a, b): return float(a["rating"]) > float(b["rating"]))
	var table: Array = ranked.slice(0, size)
	for b in ranked.slice(size):
		b["rank"] = 0
	for b in waiting:
		if table.size() >= size:
			b["rank"] = 0
		else:
			table.append(b)
	for i in table.size():
		table[i]["rank"] = i + 1


static func level_of(belt: String) -> String:
	var parts := belt.split("_")
	return parts[parts.size() - 1] if parts.size() >= 2 else ""


static func level_index(belt: String) -> int:
	return BELT_LEVELS.find(level_of(belt))


static func apply_result_in(winner: Dictionary, loser: Dictionary, division_boxers: Array) -> Dictionary:
	var w_rank := int(winner.get("rank", 0))
	var l_rank := int(loser.get("rank", 0))
	if w_rank <= 0 or l_rank <= 0:
		return {"moved": false}
	if w_rank < l_rank:
		return {"moved": false}
	winner["rank"] = l_rank
	loser["rank"] = l_rank + 1
	for b in division_boxers:
		if b == winner or b == loser:
			continue
		var r := int(b.get("rank", 0))
		if r > l_rank and r < w_rank:
			b["rank"] = r + 1
	return {"moved": true, "winner_new": l_rank, "loser_new": l_rank + 1}


static func vacate_belt(champion: Dictionary, division_boxers: Array) -> Dictionary:
	var belt: String = champion.get("belt", "")
	if belt == "":
		return {"vacated": false}
	champion["belt"] = ""
	var best_challenger: Dictionary = {}
	var best_rank := 999
	for b in division_boxers:
		if b == champion or b.get("retired", false):
			continue
		var r := int(b.get("rank", 0))
		if r > 0 and r < best_rank:
			best_rank = r
			best_challenger = b
	if not best_challenger.is_empty():
		return {"vacated": true, "belt": belt, "mandatory": best_challenger}
	return {"vacated": true, "belt": belt, "mandatory": {}}


static func award_belt(boxer: Dictionary, belt_level: String, org_abbr: String) -> void:
	boxer["belt"] = "%s_%s" % [org_abbr, belt_level]


static func champion_of(division_boxers: Array, belt_level: String) -> Dictionary:
	for b in division_boxers:
		if not b.get("retired", false) and level_of(str(b.get("belt", ""))) == belt_level:
			return b
	return {}


static func mandatory_challenger(division_boxers: Array, champion: Dictionary) -> Dictionary:
	var champ_rank := int(champion.get("rank", 0))
	var best: Dictionary = {}
	var best_rank := 999
	for b in division_boxers:
		if b == champion or b.get("retired", false):
			continue
		var r := int(b.get("rank", 0))
		if r > 0 and r < best_rank and r != champ_rank:
			best_rank = r
			best = b
	return best


static func ranking_snapshot(division_boxers: Array) -> Array:
	var active: Array = []
	for b in division_boxers:
		if not b.get("retired", false) and int(b.get("rank", 0)) > 0:
			active.append({"name": b["name"], "rank": int(b["rank"]), "rating": float(b["rating"]),
				"age": int(b["age"]), "belt": b.get("belt", "")})
	active.sort_custom(func(a, b): return int(a["rank"]) < int(b["rank"]))
	return active
