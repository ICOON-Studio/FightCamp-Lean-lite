extends RefCounted
## S397 rank 5, P12 (docs/STRUCTURE_DESIGN_S395.md 5.8; operator Q-S294-121 "Yes"): the player is the club's head coach and
## picks one of four backgrounds on photo cards at the start. Each gives ONE clear edge, small enough not to decide a career,
## and every card has one (no option without a bonus). Career.head = {"name", "bg"}; {} on a save from before this = no edge.
## Plan: ops/research/RANK5_FIRST_HOUR_S397.md section 3. Pure static; zero preloads.
##   card(id) -> {id, title, past, edge, chip, plain, felt, photo, first}   ctx(head) -> the week's sums' keys   ids()   of(head) -> id ("" = none)
##   free_tells(head) -> int          the ex-pro: tells opened on the opponent's file at the start of every camp
##   sees_potential(head) -> bool     the amateur coach: a prospect's potential shows exact, not a range
##   gain_mult(head, stat) -> float   the strength coach: engine mornings gain more, craft mornings less
##   cut_kcal(head) -> float          the old hand: extra kcal a day off while she cuts
## S397 critics (RANK5 doc section 8): every edge is written as a result with the moment it is first felt; the strength
## coach pays for the engines with the craft (no card dominates); the old hand has one edge, not two.

const DEFAULT_NAME := "Sam Carter"
## The ex-pro's file: tells opened when a camp starts (OppFile.tape, the same order tape study opens them).
const EXPRO_TELLS := 1
## The strength coach's engines: a morning session on one of these stats gains this much more (WeekPlan.day), and one on the
## craft stats this much less.
const STRENGTH_STATS := ["conditioning", "power", "speed"]
const STRENGTH_GAIN := 1.10
const CRAFT_STATS := ["technique", "defense"]
const CRAFT_GAIN := 0.90
## The old hand: the cut 120 kcal a day deeper (about 0.11 kg a week; a real corner's tricks with food and water timing).
const OLDHAND_CUT_KCAL := 120.0

## The four cards, in the order shown. photo = the studio headshot (tools/bake_promo.gd stems=mh_staff_*).
## first = the card a first career is pointed to (the critic S397: "mark one card as good for a first career").
const CARDS := [
	{"id": "oldhand", "title": "Old hand", "past": "Has worked corners since before most of your boxers were born.",
		"edge": "Easier weight cuts", "chip": "-120 kcal a day on every cut", "plain": "Every cut burns 120 kcal a day more, so boxers make weight with room to spare.",
		"felt": "at the first weigh-in", "photo": "mh_staff_coach", "first": true},
	{"id": "expro", "title": "Ex-pro", "past": "Twelve years as a pro. Never a champion, never stopped.",
		"edge": "Reads opponents", "chip": "1 tell on file at booking", "plain": "The day a bout is booked, the opponent's best weapon is already on file.",
		"felt": "on the first bout offer you accept", "photo": "mh_staff_trainer", "first": false},
	{"id": "amateur", "title": "Amateur coach", "past": "Twenty years at a club like this one, and the national squad's trials.",
		"edge": "Eye for talent", "chip": "Exact potential, no range", "plain": "A prospect's true potential shows at first look, not a guess between two numbers.",
		"felt": "when the second boxer walks in", "photo": "mh_staff_coach_2", "first": false},
	{"id": "strength", "title": "Strength coach", "past": "Ran conditioning for a national team before boxing.",
		"edge": "Builds engines, not craft", "chip": "+10% body, -10% craft mornings", "plain": "Conditioning, power and speed mornings gain 10% more; technique and defence mornings 10% less.",
		"felt": "in the first week's Monday report", "photo": "mh_staff_cutman_1", "first": false},
]


static func ids() -> Array:
	return CARDS.map(func(c): return str(c["id"]))


static func card(id: String) -> Dictionary:
	for c in CARDS:
		if str(c["id"]) == id:
			return (c as Dictionary).duplicate()
	return {}


## The quick start's card and any unknown id fall back to the first card.
static func make(name: String, id: String) -> Dictionary:
	var bg := id if ids().has(id) else str(CARDS[0]["id"])
	return {"name": name.strip_edges() if name.strip_edges() != "" else DEFAULT_NAME, "bg": bg}


static func of(head: Dictionary) -> String:
	return str(head.get("bg", ""))


static func free_tells(head: Dictionary) -> int:
	return EXPRO_TELLS if of(head) == "expro" else 0


static func sees_potential(head: Dictionary) -> bool:
	return of(head) == "amateur"


static func gain_mult(head: Dictionary, stat: String) -> float:
	if of(head) != "strength":
		return 1.0
	return STRENGTH_GAIN if STRENGTH_STATS.has(stat) else (CRAFT_GAIN if CRAFT_STATS.has(stat) else 1.0)


static func cut_kcal(head: Dictionary) -> float:
	return OLDHAND_CUT_KCAL if of(head) == "oldhand" else 0.0


## What the week's sums read (Sim.week_ctx -> WeekPlan.day): per-stat morning gain multipliers and the cut's extra kcal.
static func ctx(head: Dictionary) -> Dictionary:
	var g := {}
	for st in STRENGTH_STATS + CRAFT_STATS:
		if gain_mult(head, st) != 1.0:
			g[st] = gain_mult(head, st)
	return {"head_gain": g, "head_cut": cut_kcal(head)}


## The edge in one line for People and the Handbook: "Old hand: cheaper camps, easier weight cuts".
static func line(head: Dictionary) -> String:
	var c := card(of(head))
	return "" if c.is_empty() else "%s: %s" % [c["title"], str(c["edge"]).to_lower()]
