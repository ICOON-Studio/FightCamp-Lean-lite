extends RefCounted
## One amateur bout from camp to scorecards: the camp's cost and edge, the weigh-in, three rounds told in words with a corner
## call between them, the cards and what decided it. Pure static functions: no class_name, no preload, no argument mutation.
## Numbers are the approved prototype's (docs/menu_prototype.html, fightPower / fightAdvance / finishFight); they are
## game-design values, not sport-science measurements. Stat keys: power speed technique defense conditioning fight_iq chin.

## Protocols by index (0 = no camp). cost in $, focus = multiplier on the camp focus's daily gain, edge = fight-night edge.
## S380 (S379: Hard vs Standard moved the camp stat 60.12 vs 59.98 and changed no fatigue - the multiplier only touched
## ~1 point of focus mornings): the protocol also sets the camp's EVENINGS. drill = the pads night's share of a session
## on the camp's stat (a morning is WeekPlan.SESSION_SHARE 0.2); load = how hard those evenings go (fatigue, hours and so
## injury risk); level = the TrainingLoad setting it mirrors into f["load_setting"]. S381 C229 nights = club nights a week
## the card states (design value, a label only - an amateur with a day job: 3 / 4 / 5). S381 C229 stage 2: cost 0 / 0 / 0 -
## the club's own nights cost coach evenings and risk, not cash (a club coach does not bill his own boxer). S381 C229
## stage 4: the flat edges halved (0.5 / 1.2 / 2.0 -> 0.25 / 0.6 / 1.0; NO_CAMP_EDGE stays -1.5) - the value moved into the
## matchup (film answers, the southpaw mate, the stat thresholds the focus card crosses); tools/camp_film_balance.gd.
const PROTOCOLS := [
	{"name": "None", "cost": 0, "focus": 1.0, "edge": 0.0, "drill": 0.0, "load": 1.0, "level": "normal", "nights": 0, "blurb": ""},
	{"name": "Light", "cost": 0, "focus": 1.1, "edge": 0.25, "drill": 0.0, "load": 0.75, "level": "light", "nights": 3, "blurb": "3 nights, spar 1 a week"},
	{"name": "Standard", "cost": 0, "focus": 1.2, "edge": 0.6, "drill": 0.05, "load": 1.0, "level": "normal", "nights": 4, "blurb": "4 nights, spar 2 a week"},
	{"name": "Hard", "cost": 0, "focus": 1.35, "edge": 1.0, "drill": 0.09, "load": 1.2, "level": "hard", "nights": 5, "blurb": "5 nights a week"},
]
## S380 fight night: camp fatigue still carried into the ring empties the tank at the first bell (Halperin, Hughes &
## Chapman 2016: punch impact -4 to -7 % when camp fatigue had not cleared). Under FRESH_FATIGUE reads FRESH
## (WhiteboardKit.fatigue_word); STALE_PER_POINT energy a point over it, at most STALE_MAX (= Injuries.HURT_ENERGY serious).
const FRESH_FATIGUE := 50.0
const STALE_PER_POINT := 2.0
const STALE_MAX := 20.0
const CAMP_FOCUSES: Array[String] = ["conditioning", "power", "technique", "defense", "speed"]
## S381 C229 stage 2: film is a phone video of her at a club show - free; it takes one Build-week pad night (WeekPhase.film_night).
## The only camp cash is the outside sparring partner from another club: travel and a favour, $40 a visit, 4 visits (design
## values: the Peak week's 2 sparring nights plus one in each Build week).
const PARTNER_FEE := 40
const PARTNER_VISITS := 4
## S381 C229 stage 3: an orthodox boxer who never sparred a southpaw in camp is lost for the first round against one (design
## value, power points, round 1 only): "never faced a southpaw". The southpaw mate (or a WeekTwist lefty week) takes it
## away; there is no plus edge for having one. The mirror never bites: a southpaw spars orthodox club mates every night.
const NEVER_FACED := 0.6
## The film depth (OppFile.film_depth: 1 nothing found, 3 her whole file) still drives what the corner reads in the ring
## (THE READ, the coach's pick); it no longer adds power.
const FILM_DEPTH_WITH_STUDY := 3
const FILM_DEPTH_DEFAULT := 1
## S381 C229 stage 4: film is earned - tape is only worth what the coach turns into a plan. Each found tell a Playbook plan
## line or a drilled combination answers (FilmEdge.answered, PlanLines.answers) is worth FILM_PER_ANSWER on the night, up
## to FILM_EDGE_MAX (design values; the old flat film edge was the same +1.2 for anyone).
const FILM_PER_ANSWER := 0.4
const FILM_EDGE_MAX := 1.2
const NO_CAMP_EDGE := -1.5
## A camp is worth setting with at least a week to go.
const CAMP_MIN_DAYS := 7
## Each round both sides roll +/- half of this. S305 J-UPSETS1: pro favourites win 86% of decided fights; target ~60% at
## slight edge, ~75% clear, ~88% big, ~95% at +13 (tools/balance_targets.gd measured spread 27).
const ROUND_SPREAD := 27.0
const ROUNDS := 3
## Round 3: her engine fades below this conditioning; an opponent who "fades" loses this much.
const FADE_CONDITIONING := 64.0
const OWN_FADE := 1.0
const OPP_FADE := 1.5

## S308: the eight corner calls (Exchanges.CALLS has what each does); the labels the corner card and the result show.
const CORNER := {"long": "Jab and move", "body": "Go to the body", "lead": "Draw the lead", "hands": "Hands up, move your head",
	"let_go": "Let your hands go", "calm": "Breathe, pick your shots", "tie": "Tie up", "finish": "Go for the finish"}
## The corner edge: a strong call when she has the tool for it, a small one when she has not.
const CORNER_STRONG := 1.0
const CORNER_WEAK := 0.3
const CORNER_BODY_POWER := 60.0
const CORNER_LONG_TECHNIQUE := 61.0
const CORNER_CALM := 0.6
## S381 G1 (gym idea 5, the threshold bar on each camp card): the stat number that changes the night, one per stat that has
## one - the body call goes strong past CORNER_BODY_POWER, "Jab and move" past CORNER_LONG_TECHNIQUE, no round-3 fade from
## FADE_CONDITIONING. above = strictly past it (fight_power's >), else at it or past (play_round's fade is < it). word = the
## card's caption. Defence and hand speed have no line. fight_power and play_round read clears_night_line, so they never drift.
const NIGHT_LINES := {
	"power": {"at": CORNER_BODY_POWER, "word": "body call", "above": true},
	"technique": {"at": CORNER_LONG_TECHNIQUE, "word": "jab and move", "above": true},
	"conditioning": {"at": FADE_CONDITIONING, "word": "no round-3 fade", "above": false},
}

const WEIGH_TOLERANCE := 0.05
const MISSED_WEIGHT_COST := 300
const TICKET_CUT := 450
const WIN_MEMBERS := 8
const WIN_REPUTATION := 5
## S324 update 27 "losses cost" (make-it-a-game plan decision 4): a loss loses members after the news and some reputation
## (the natural member count follows reputation, so a loss also lowers where the gym settles); a stoppage loss costs more.
## S327 (operator "Money too harsh"): 1 and 2 members, was 3 and 5 - club members train for themselves; one bout lost
## does not empty a gym (the reputation loss still lowers where the member count settles).
const LOSS_MEMBERS := 1
const LOSS_REPUTATION := 2
const STOPPED_LOSS_MEMBERS := 2
const STOPPED_LOSS_REPUTATION := 4

## Move mastery on the night: a move at USABLE (mastery 30) or better is a weapon. The first BASE_WEAPONS are what any
## amateur brings; each weapon beyond them is worth WEAPON_EDGE, up to WEAPON_EDGE_CAP (a new weapon every 2-3 weeks).
const WEAPON_MASTERY := 30.0
const BASE_WEAPONS := 4
const WEAPON_EDGE := 0.3
const WEAPON_EDGE_CAP := 0.9


## The camp's cash: the protocol (the club's own nights, $0) + the outside sparring partner's visits when one is booked.
static func camp_cost(protocol: int, partner: bool) -> int:
	return int(PROTOCOLS[clampi(protocol, 0, 3)]["cost"]) + (partner_fee() if partner else 0)


static func partner_fee() -> int:
	return PARTNER_FEE * PARTNER_VISITS


## Who the outside partner copies: "southpaw mate" for a southpaw, "pressure mate" for a pressure fighter, else "sparring mate".
static func partner_word(opp: Dictionary) -> String:
	if str(opp.get("stance", "")).to_lower() == "southpaw":
		return "southpaw mate"
	return "pressure mate" if str(opp.get("style", "")).to_lower().begins_with("pressure") else "sparring mate"


## True when the outside partner copies the opponent's free stance or style (the card's "MATCHES <HER>").
static func partner_matches(opp: Dictionary) -> bool:
	return partner_word(opp) != "sparring mate"


## S381 C229 stage 3: an orthodox boxer facing a southpaw with no southpaw in her camp (no partner, no lefty week).
## stance = hers ("" reads orthodox, the club default); a southpaw herself is never caught out (her club mates are orthodox).
static func never_faced(stance: String, opp: Dictionary, camp: Dictionary, lefty: bool = false) -> bool:
	if stance.to_lower() == "southpaw" or str(opp.get("stance", "")).to_lower() != "southpaw":
		return false
	return not (bool(camp.get("partner", false)) or lefty)


## The stance's cost in round n: -NEVER_FACED in round 1 when she never faced a southpaw, else 0.
static func stance_edge(n: int, stance: String, opp: Dictionary, camp: Dictionary, lefty: bool = false) -> float:
	return -NEVER_FACED if n == 1 and never_faced(stance, opp, camp, lefty) else 0.0


## The daily-gain multiplier the camp puts on one stat (1.0 off the focus or without a camp).
static func camp_gain_mult(camp: Dictionary, stat: String) -> float:
	if camp.is_empty() or str(camp.get("focus", "")) != stat:
		return 1.0
	return float(PROTOCOLS[clampi(int(camp.get("protocol", 0)), 0, 3)]["focus"])


## S380 the camp's evenings: {stat (the camp focus the pads drill), drill (the pads share), load (evening fatigue x)}.
static func camp_evening(camp: Dictionary) -> Dictionary:
	if camp.is_empty():
		return {"stat": "", "drill": 0.0, "load": 1.0}
	var p: Dictionary = PROTOCOLS[clampi(int(camp.get("protocol", 0)), 0, 3)]
	return {"stat": str(camp.get("focus", "")), "drill": float(p["drill"]), "load": float(p["load"])}


## The TrainingLoad setting a protocol stands for (Bouts.start_camp mirrors it into f["load_setting"]).
static func camp_level(protocol: int) -> String:
	return str(PROTOCOLS[clampi(protocol, 0, 3)]["level"])


## Energy lost at the first bell to the fatigue she carries in (0 when fresh). Only after a camp (protocol >= 1): a
## normal week settles near 60, and a fight without a camp is not taxed for the club's usual training.
static func stale_energy(fatigue: float, camp: Dictionary = {"protocol": 1}) -> float:
	if int(camp.get("protocol", 0)) < 1:
		return 0.0
	return clampf((fatigue - FRESH_FATIGUE) * STALE_PER_POINT, 0.0, STALE_MAX)


static func made_weight(weight: float, limit: float) -> bool:
	return weight <= limit + WEIGH_TOLERANCE


## Power points the film is worth: FILM_PER_ANSWER a found tell her plan answers, at most FILM_EDGE_MAX.
static func film_edge(answered: int) -> float:
	return clampf(float(answered) * FILM_PER_ANSWER, 0.0, FILM_EDGE_MAX)


## Her strength on the night: the six fighting stats (chin aside), the camp, the film (answered = found tells her plan or
## drilled combos answer, FilmEdge.answered) and the corner call.
static func fight_power(stats: Dictionary, camp: Dictionary, answered: int, corner: String) -> float:
	var p := 0.0
	for k in ["power", "speed", "technique", "defense", "conditioning", "fight_iq"]:
		p += float(stats.get(k, 55.0))
	p /= 6.0
	p += float(PROTOCOLS[clampi(int(camp.get("protocol", 0)), 0, 3)]["edge"]) if not camp.is_empty() else NO_CAMP_EDGE
	p += film_edge(answered)
	match corner:
		"body":
			p += CORNER_STRONG if clears_night_line("power", float(stats.get("power", 0.0))) else CORNER_WEAK
		"long":
			p += CORNER_STRONG if clears_night_line("technique", float(stats.get("technique", 0.0))) else CORNER_WEAK
		"calm":
			p += CORNER_CALM
	return p


## One round. roll_a / roll_b are in [0, 1). Returns {n, won, mine, theirs, corner}.
static func play_round(n: int, stats: Dictionary, camp: Dictionary, answered: int, corner: String, opp: Dictionary,
		roll_a: float, roll_b: float, weapons_bonus: float = 0.0) -> Dictionary:
	var mine := fight_power(stats, camp, answered, corner) + weapons_bonus + (roll_a - 0.5) * ROUND_SPREAD
	if n >= ROUNDS and not clears_night_line("conditioning", float(stats.get("conditioning", 0.0))):
		mine -= OWN_FADE
	var theirs := float(opp.get("rating", 60.0)) + (roll_b - 0.5) * ROUND_SPREAD
	if n >= ROUNDS and str(opp.get("weak", "")).begins_with("Fades"):
		theirs -= OPP_FADE
	return {"n": n, "won": mine >= theirs, "mine": mine, "theirs": theirs, "corner": corner}


## S381 G1 the stat's night line ({at, word, above}, NIGHT_LINES) or {} when the stat has none.
static func night_line(stat: String) -> Dictionary:
	return NIGHT_LINES.get(stat, {})


## True when `value` is over the stat's night line (false for a stat with no line).
static func clears_night_line(stat: String, value: float) -> bool:
	var l := night_line(stat)
	if l.is_empty():
		return false
	return value > float(l["at"]) if bool(l["above"]) else value >= float(l["at"])


## The card's caption: "past 60: body call", "at 64: no round-3 fade" ("" for a stat with no line).
static func night_line_words(stat: String) -> String:
	var l := night_line(stat)
	if l.is_empty():
		return ""
	return "%s %d: %s" % ["past" if bool(l["above"]) else "at", int(l["at"]), str(l["word"])]


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
## answered: the found tells her plan answered (S381 C229 stage 4: the film counts only when the plan used it).
static func why(rounds: Array, has_camp: bool, protocol: int, camp_focus_label: String, answered: int, threat: String,
		first: String) -> Array:
	var out: Array = []
	if answered >= 1:
		out.append("The film study: %s knew the %s was coming." % [first, threat])
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
