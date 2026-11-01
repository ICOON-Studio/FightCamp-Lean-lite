extends RefCounted
## S341 her record, bout by bout (operator: "the records should always keep all information available for the other
## opponents (history)"; "use some imaginary scenarios for the fighters past victories to see ... on the fighters card
## history panel"). Every rival starts the career with a past that matches her W-L: one invented bout per win and loss,
## against the other women in her division and boxers from real clubs, at club shows over the months before day 0, on
## points or stopped (a puncher stops more). From then on every real bout is added: rival against rival at a club show
## (Region), and against our gym (BoutNight). Newest first in r["bouts"]: {d, vs, vs_club, win, how, ours}.
##   seed(r, others, seed, day0) -> Array   add(r, d, vs, vs_club, win, how, ours)   shown(r, n) -> the newest n
## Pure static; zero preloads.

## Boxers from real London-region clubs for the bouts against women outside our rankings (fictional names).
const OTHERS := [["Jess Hardy", "Repton ABC"], ["Mia Doyle", "Fitzroy Lodge ABC"], ["Tara Quinn", "Lynn AC"],
	["Leah Moss", "Islington BC"], ["Nia Okafor", "Haringey Police CABC"], ["Grace Hale", "Double Jab ABC"],
	["Kayla Benn", "All Stars ABC"], ["Zara Lewis", "Dale Youth ABC"]]
## Share of wins and losses that ended inside the distance (England Boxing women's amateur bouts mostly go the distance).
const STOP_WIN := 0.22
const STOP_WIN_PUNCHER := 0.4
const STOP_LOSS := 0.15
## Days between her past bouts.
const GAP := Vector2i(21, 56)
const DECISIONS := ["on points, 3-0", "on points, 2-1", "on points, 3-0", "on a split, 2-1"]


## Her past: w + l bouts before `day0`, newest first. `others` = [[name, club], ...] of the women she could have met.
static func seed(r: Dictionary, others: Array, career_seed: int, day0: int) -> Array:
	var rng := RandomNumberGenerator.new()
	rng.seed = hash(str(r.get("name", "")) + str(career_seed))
	var results: Array = []
	for i in int(r.get("w", 0)):
		results.append(true)
	for i in int(r.get("l", 0)):
		results.append(false)
	_shuffle(results, rng)
	var pool: Array = others.filter(func(o): return str(o[0]) != str(r.get("name", ""))) + OTHERS
	var puncher := str(r.get("style", "")) in ["Slugger", "Boxer-puncher"] or str(r.get("threat", "")).to_lower().contains("right")
	var out: Array = []
	var d := day0
	for won in results:
		d -= rng.randi_range(GAP.x, GAP.y)
		var o: Array = pool[rng.randi_range(0, pool.size() - 1)]
		var stop := rng.randf() < (STOP_WIN_PUNCHER if puncher else STOP_WIN) if won else rng.randf() < STOP_LOSS
		var how := ("stopped in round %d" % rng.randi_range(1, 3)) if stop else str(DECISIONS[rng.randi_range(0, DECISIONS.size() - 1)])
		out.append({"d": d, "vs": str(o[0]), "vs_club": str(o[1]), "win": won, "how": how, "ours": false})
	return out


## Books one bout on her record (newest first).
static func add(r: Dictionary, d: int, vs: String, vs_club: String, win: bool, how: String, ours := false) -> void:
	if r.is_empty():
		return
	if not r.has("bouts"):
		r["bouts"] = []
	(r["bouts"] as Array).push_front({"d": d, "vs": vs, "vs_club": vs_club, "win": win, "how": how, "ours": ours})


static func shown(r: Dictionary, n: int) -> Array:
	return (r.get("bouts", []) as Array).slice(0, n)


static func _shuffle(a: Array, rng: RandomNumberGenerator) -> void:
	for i in range(a.size() - 1, 0, -1):
		var j := rng.randi_range(0, i)
		var t = a[i]
		a[i] = a[j]
		a[j] = t
