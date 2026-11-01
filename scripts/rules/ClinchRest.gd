extends RefCounted
## S340 the clinch's price (operator: "during clinch a small stamina refill but risk of getting hit"). When she ties up in
## an exchange - the corner's "Tie her up", the plan's tie-up arrow, or an exchange fought on the clinch card - she leans
## on the other woman and gets a little breath back (a real tie-up lasts ~4 s, 2023 women's World Championships, and the
## holder rests her legs on her opponent). But the other woman's free hand works: short digs to the ribs while they are tied,
## and now and then one on the break. Pressure fighters and sluggers live in there; out-boxers want out. Her technique (a
## tight tie: both arms controlled) keeps the free hand quiet.
## Pure static; preloads nothing.

## Energy back when she ties up from the plan or the clinch card (the corner's tie call already pays its own -2).
const REFILL := 1.5
## The chance the other woman lands in the clinch: BASE + her style + (her rating - our technique) / 100, clamped.
const BASE := 0.30
const STYLE := {"Pressure fighter": 0.15, "Slugger": 0.10, "Volume puncher": 0.10, "Boxer-puncher": 0.0,
	"Counter-puncher": -0.05, "Out-boxer": -0.10}
const CHANCE_MIN := 0.10
const CHANCE_MAX := 0.65
## Each short dig that lands costs her this much of the exchange (power points, as Exchanges' margins; a best call is 15).
const HIT_EDGE := 2.5
## A shot on the break lands on the head: damage the knockdown roll reads (a corner set-up that lands is 30).
const BREAK_DAMAGE := 8.0
const BREAK_SHARE := 0.25
const TWO_SHARE := 0.4


## Whether she ties up this exchange: the corner's call, her arrow (any card's tie-up), or the clinch card itself.
static func tied(call: String, arrow: String, at: String) -> bool:
	return call == "tie" or arrow.get_slice("@", 0) == "tie_up" or at == "clinch"


## Energy she gets back (subtracted from the exchange's cost); none on top of the corner's own tie call.
static func refill(call: String) -> float:
	return 0.0 if call == "tie" else REFILL


static func chance(opp_style: String, opp_rating: float, technique: float) -> float:
	return clampf(BASE + float(STYLE.get(opp_style, 0.0)) + (opp_rating - technique) / 100.0, CHANCE_MIN, CHANCE_MAX)


## {hit, shots, head, edge, damage}: rolls r1 (does she land), r2 (one or two), r3 (one on the break, to the head).
static func roll(p: float, r1: float, r2: float, r3: float) -> Dictionary:
	if r1 >= p:
		return {"hit": false, "shots": 0, "head": false, "edge": 0.0, "damage": 0.0}
	var shots := 2 if r2 < TWO_SHARE else 1
	var head := r3 < BREAK_SHARE
	return {"hit": true, "shots": shots, "head": head, "edge": HIT_EDGE * shots, "damage": BREAK_DAMAGE if head else 0.0}


## The words for it ("" when she did not tie up). names = [hers, the opponent's].
static func line(c: Dictionary, names: Array) -> String:
	if c.is_empty():
		return ""
	var out := "%s ties her up and gets a breather" % names[0]
	if not bool(c.get("hit", false)):
		return out + "."
	var ribs := "two short ones to the ribs" if int(c["shots"]) == 2 else "a short one to the ribs"
	var what := "digs " + ribs
	if bool(c.get("head", false)):
		what = ("digs one to the ribs and " if int(c["shots"]) == 2 else "") + "lands one on the break"
	return "%s, but %s %s." % [out, names[1], what]
