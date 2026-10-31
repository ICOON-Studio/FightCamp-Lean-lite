extends RefCounted
## Championship draw: seeds, byes, bracket order, simulated winners.


const BYE := "BYE"
const RATING_SCALE := 8.0


## Entrants' ids best first: rating high to low, ties by id A-Z.
static func seeds(entrants: Array) -> Array:
	var sorted: Array = entrants.duplicate()
	sorted.sort_custom(func(a, b):
		if a["rating"] != b["rating"]:
			return a["rating"] > b["rating"]
		return a["id"] < b["id"]
	)
	var result: Array = []
	for e in sorted:
		result.append(e["id"])
	return result


## Standard seed order for a draw of P slots (P a power of two).
static func order(p: int) -> Array:
	if p <= 1:
		return [1]
	var half: Array = order(p / 2)
	var result: Array = []
	for s in half:
		result.append(s)
		result.append(p + 1 - s)
	return result


## First-round pairs: P = smallest power of two >= entrants.size() (at least 2).
static func first_round(entrants: Array) -> Array:
	var n: int = entrants.size()
	if n == 0:
		return []
	var p: int = 1
	while p < n:
		p *= 2
	if p < 2:
		p = 2
	var sorted: Array = entrants.duplicate()
	sorted.sort_custom(func(a, b):
		if a["rating"] != b["rating"]:
			return a["rating"] > b["rating"]
		return a["id"] < b["id"]
	)
	var ord: Array = order(p)
	var result: Array = []
	for i in range(0, p, 2):
		var a_idx: int = ord[i] - 1
		var b_idx: int = ord[i + 1] - 1
		var a_id: String = sorted[a_idx]["id"] if a_idx < n else BYE
		var b_id: String = sorted[b_idx]["id"] if b_idx < n else BYE
		result.append([a_id, b_id])
	return result


## Chance a beats b: logistic curve over rating difference.
static func win_chance(ra: float, rb: float) -> float:
	return 1.0 / (1.0 + exp(-(ra - rb) / RATING_SCALE))


## Her opponent in this round's pairs: the other id in her pair, "" when absent.
static func opponent(pairs: Array, her_id: String) -> String:
	for pair in pairs:
		if pair[0] == her_id:
			return pair[1]
		if pair[1] == her_id:
			return pair[0]
	return ""


## Simulated round winners. BYE loses to anyone; her pair decided by her_won;
## every other contested pair by win_chance with one seeded RNG.
static func winners(pairs: Array, ratings: Dictionary, her_id: String, her_won: bool, seed: int) -> Array:
	var rng := RandomNumberGenerator.new()
	rng.randomize()
	rng.seed = seed
	var result: Array = []
	for pair in pairs:
		var a: String = pair[0]
		var b: String = pair[1]
		if a == BYE and b == BYE:
			result.append(BYE)
		elif a == BYE:
			result.append(b)
		elif b == BYE:
			result.append(a)
		elif a == her_id or b == her_id:
			result.append(her_id if her_won else (b if a == her_id else a))
		else:
			var ra: float = float(ratings[a])
			var rb: float = float(ratings[b])
			var wc: float = win_chance(ra, rb)
			var r: float = rng.randf()
			result.append(a if r < wc else b)
	return result


## Next round's pairs from this round's winners: [w0,w1], [w2,w3], ...
static func next_round(winners: Array) -> Array:
	var result: Array = []
	for i in range(0, winners.size() - 1, 2):
		result.append([winners[i], winners[i + 1]])
	return result
