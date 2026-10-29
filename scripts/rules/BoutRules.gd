extends RefCounted
## One amateur bout from camp to scorecards: the camp's cost and edge, the weigh-in, three rounds told in words with a corner
## call between them, the cards and what decided it. Pure static functions: no class_name, no preload, no argument mutation.
## Numbers are the approved prototype's (docs/menu_prototype.html, fightPower / fightAdvance / finishFight); they are
## game-design values, not sport-science measurements. Stat keys: power speed technique defense conditioning fight_iq chin.

## Protocols by index (0 = no camp). cost in $, focus = multiplier on the camp focus's daily gain, edge = fight-night edge.
const PROTOCOLS := [
	{"name": "None", "cost": 0, "focus": 1.0, "edge": 0.0, "blurb": ""},
	{"name": "Light", "cost": 0, "focus": 1.1, "edge": 0.5, "blurb": "free, smaller gains"},
	{"name": "Standard", "cost": 300, "focus": 1.2, "edge": 1.2, "blurb": "$300, solid gains"},
	{"name": "Hard", "cost": 700, "focus": 1.35, "edge": 2.0, "blurb": "$700, biggest gains, more risk"},
]
const CAMP_FOCUSES: Array[String] = ["conditioning", "power", "technique", "defense", "speed"]
const FILM_COST := 150
const FILM_DEPTH_WITH_STUDY := 3
const FILM_DEPTH_DEFAULT := 1
const FILM_EDGE_PER_DEPTH := 0.6
const NO_CAMP_EDGE := -1.5
## A camp is worth setting with at least a week to go.
const CAMP_MIN_DAYS := 7
## Each round both sides roll +/- half of this.
const ROUND_SPREAD := 6.0
const ROUNDS := 3
## Round 3: her engine fades below this conditioning; an opponent who "fades" loses this much.
const FADE_CONDITIONING := 64.0
const OWN_FADE := 1.0
const OPP_FADE := 1.5

const CORNER := {"long": "Stay long, jab and move", "body": "Go to the body", "calm": "Calm her down, breathe"}
## The corner edge: a strong call when she has the tool for it, a small one when she has not.
const CORNER_STRONG := 1.0
const CORNER_WEAK := 0.3
const CORNER_BODY_POWER := 60.0
const CORNER_LONG_TECHNIQUE := 61.0
const CORNER_CALM := 0.6

const WEIGH_TOLERANCE := 0.05
const MISSED_WEIGHT_COST := 300
const TICKET_CUT := 450
const WIN_MEMBERS := 8
const WIN_REPUTATION := 5

## Move mastery on the night: a move at USABLE (mastery 30) or better is a weapon. The first BASE_WEAPONS are what any
## amateur brings; each weapon beyond them is worth WEAPON_EDGE, up to WEAPON_EDGE_CAP (a new weapon every 2-3 weeks).
const WEAPON_MASTERY := 30.0
const BASE_WEAPONS := 4
const WEAPON_EDGE := 0.3
const WEAPON_EDGE_CAP := 0.9


static func camp_cost(protocol: int, film: bool) -> int:
	return int(PROTOCOLS[clampi(protocol, 0, 3)]["cost"]) + (FILM_COST if film else 0)


## The daily-gain multiplier the camp puts on one stat (1.0 off the focus or without a camp).
static func camp_gain_mult(camp: Dictionary, stat: String) -> float:
	if camp.is_empty() or str(camp.get("focus", "")) != stat:
		return 1.0
	return float(PROTOCOLS[clampi(int(camp.get("protocol", 0)), 0, 3)]["focus"])


static func made_weight(weight: float, limit: float) -> bool:
	return weight <= limit + WEIGH_TOLERANCE


## Her strength on the night: the six fighting stats (chin aside), the camp, the film depth and the corner call.
static func fight_power(stats: Dictionary, camp: Dictionary, film_depth: int, corner: String) -> float:
	var p := 0.0
	for k in ["power", "speed", "technique", "defense", "conditioning", "fight_iq"]:
		p += float(stats.get(k, 55.0))
	p /= 6.0
	p += float(PROTOCOLS[clampi(int(camp.get("protocol", 0)), 0, 3)]["edge"]) if not camp.is_empty() else NO_CAMP_EDGE
	p += float(film_depth - 1) * FILM_EDGE_PER_DEPTH
	match corner:
		"body":
			p += CORNER_STRONG if float(stats.get("power", 0.0)) > CORNER_BODY_POWER else CORNER_WEAK
		"long":
			p += CORNER_STRONG if float(stats.get("technique", 0.0)) > CORNER_LONG_TECHNIQUE else CORNER_WEAK
		"calm":
			p += CORNER_CALM
	return p


## One round. roll_a / roll_b are in [0, 1). Returns {n, won, mine, theirs, corner}.
static func play_round(n: int, stats: Dictionary, camp: Dictionary, film_depth: int, corner: String, opp: Dictionary,
		roll_a: float, roll_b: float, weapons_bonus: float = 0.0) -> Dictionary:
	var mine := fight_power(stats, camp, film_depth, corner) + weapons_bonus + (roll_a - 0.5) * ROUND_SPREAD
	if n >= ROUNDS and float(stats.get("conditioning", 0.0)) < FADE_CONDITIONING:
		mine -= OWN_FADE
	var theirs := float(opp.get("rating", 60.0)) + (roll_b - 0.5) * ROUND_SPREAD
	if n >= ROUNDS and str(opp.get("weak", "")).begins_with("Fades"):
		theirs -= OPP_FADE
	return {"n": n, "won": mine >= theirs, "mine": mine, "theirs": theirs, "corner": corner}


## The call the corner makes when the player sims to the result: her better tool.
static func auto_corner(stats: Dictionary) -> String:
	return "long" if float(stats.get("technique", 0.0)) > float(stats.get("power", 0.0)) else "body"


## Three judges' cards for `total` rounds, her score first: two score it round for round, the third gives one round to
## the other side (to her opponent when she won at least half, else to her) - so 3-0 reads 30-27 30-27 29-28.
static func scorecards(rounds_won: int, total: int = ROUNDS) -> Array:
	var won := clampi(rounds_won, 0, total)
	var hers := 10 * won + 9 * (total - won)
	var theirs := 9 * won + 10 * (total - won)
	var exact := "%d-%d" % [hers, theirs]
	var swing := -1 if won * 2 >= total else 1
	if (swing < 0 and won == 0) or (swing > 0 and won == total):
		swing = 0
	return [exact, exact, "%d-%d" % [hers + swing, theirs - swing]]


## "win", "loss" or "draw" from the cards: a majority of judges decides; anything else is a draw.
static func verdict(cards: Array) -> String:
	var her := 0
	var them := 0
	for card in cards:
		var parts := str(card).split("-")
		if int(parts[0]) > int(parts[1]):
			her += 1
		elif int(parts[0]) < int(parts[1]):
			them += 1
	if her >= 2:
		return "win"
	if them >= 2:
		return "loss"
	return "draw"


## Up to three one-line reasons. rounds: the played rounds; camp_focus_label e.g. "Conditioning"; threat in lower case.
static func why(rounds: Array, has_camp: bool, protocol: int, camp_focus_label: String, film_depth: int, threat: String,
		first: String) -> Array:
	var out: Array = []
	if film_depth >= FILM_DEPTH_WITH_STUDY:
		out.append("The film study: she knew the %s was coming." % threat)
	if has_camp and protocol >= 2:
		out.append("The camp: %s held up when it mattered." % camp_focus_label.to_lower())
	if not has_camp:
		out.append("No camp: %s looked a step slow from round 2." % first)
	for r in rounds:
		if bool(r["won"]) and str(r["corner"]) != "":
			out.append("Your corner call before round %d (\"%s\") won that round." % [int(r["n"]), CORNER[r["corner"]]])
			break
	return out.slice(0, 3)


## Her weapons: the moves at USABLE or better, in the order given. moves = {name: mastery}.
static func weapons(moves: Dictionary) -> Array:
	var out: Array = []
	for k in moves.keys():
		if float(moves[k]) >= WEAPON_MASTERY:
			out.append(k)
	return out


static func weapons_edge(weapon_list: Array) -> float:
	return minf(WEAPON_EDGE_CAP, maxf(0.0, float(weapon_list.size() - BASE_WEAPONS) * WEAPON_EDGE))
