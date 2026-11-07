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


## The year-end review (a sanctioning body's committee): neighbours swap where the lower-ranked boxer is clearly better
## (REVIEW_GAP rating points), REVIEW_PASSES passes. Take-their-place still decides the year; this keeps a place meaning a
## level as boxers age (without it the table drifted to a 0.55-0.72 rank-rating correlation by year 20).
const REVIEW_GAP := 3.0
const REVIEW_PASSES := 3


static func review(boxers: Array) -> int:
	var ranked: Array = boxers.filter(func(b): return int(b.get("rank", 0)) > 0 and not b.get("retired", false))
	ranked.sort_custom(func(a, b): return int(a["rank"]) < int(b["rank"]))
	var swaps := 0
	for p in REVIEW_PASSES:
		for i in range(ranked.size() - 1):
			var hi: Dictionary = ranked[i]
			var lo: Dictionary = ranked[i + 1]
			if float(lo["rating"]) - float(hi["rating"]) >= REVIEW_GAP and not lo.get("player", false) and not hi.get("player", false):
				var r := int(hi["rank"])
				hi["rank"] = r + 1
				lo["rank"] = r
				ranked[i] = lo
				ranked[i + 1] = hi
				swaps += 1
	# a clearly better unranked boxer takes the last place (the newcomer who never got a ranked fight)
	var table_size := ranked.size()
	while table_size > 0:
		var last: Dictionary = ranked[table_size - 1]
		var best: Dictionary = {}
		for b in boxers:
			if int(b.get("rank", 0)) == 0 and not b.get("retired", false) and not b.get("player", false):
				if best.is_empty() or float(b["rating"]) > float(best["rating"]):
					best = b
		if best.is_empty() or last.get("player", false) or float(best["rating"]) - float(last["rating"]) < REVIEW_GAP:
			break
		best["rank"] = int(last["rank"])
		last["rank"] = 0
		ranked[table_size - 1] = best
		swaps += 1
		# the newcomer climbs past anyone clearly worse
		var i := table_size - 1
		while i > 0 and float(ranked[i]["rating"]) - float(ranked[i - 1]["rating"]) >= REVIEW_GAP and not ranked[i - 1].get("player", false):
			var r := int(ranked[i - 1]["rank"])
			ranked[i - 1]["rank"] = r + 1
			ranked[i]["rank"] = r
			var t: Dictionary = ranked[i - 1]
			ranked[i - 1] = ranked[i]
			ranked[i] = t
			i -= 1
	return swaps


static func level_of(belt: String) -> String:
	var parts := belt.split("_")
	return parts[parts.size() - 1] if parts.size() >= 2 else ""


static func level_index(belt: String) -> int:
	return BELT_LEVELS.find(level_of(belt))


## Take their place: beat someone above you (or anyone ranked while you are unranked) and you take their spot, they and
## everyone between drop one, and whoever falls past the table's end is unranked. Beat someone below you: nothing moves.
static func apply_result_in(winner: Dictionary, loser: Dictionary, division_boxers: Array) -> Dictionary:
	var w_rank := int(winner.get("rank", 0))
	var l_rank := int(loser.get("rank", 0))
	if l_rank <= 0:
		return {"moved": false}
	if w_rank > 0 and w_rank < l_rank:
		return {"moved": false}
	var size := 0
	for b in division_boxers:
		size = maxi(size, int(b.get("rank", 0)))
	var bottom := w_rank if w_rank > 0 else size + 1
	for b in division_boxers:
		if b == winner:
			continue
		var r := int(b.get("rank", 0))
		if r >= l_rank and r < bottom:
			b["rank"] = r + 1 if r + 1 <= size else 0
	winner["rank"] = l_rank
	return {"moved": true, "winner_new": l_rank, "loser_new": int(loser["rank"])}


## A ranked boxer beaten by someone above loses one place: the boxer below steps up (the sanctioning body's table, not
## take-their-place, which only moves a winner from below).
static func drop_one(loser: Dictionary, division_boxers: Array) -> void:
	var r := int(loser.get("rank", 0))
	if r <= 0:
		return
	for b in division_boxers:
		if b != loser and not b.get("retired", false) and int(b.get("rank", 0)) == r + 1:
			b["rank"] = r
			loser["rank"] = r + 1
			return


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
