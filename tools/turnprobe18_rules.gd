extends RefCounted
## TURNPROBE18 (S543) GREYBOX - NOT GAME CODE. Turning pro v18 (ops/research/DESIGN_TURNPRO1_V18.md) on top of v17
## (tools/turnprobe17_rules.gd, copied, not edited). Pure static. The game's numbers are READ from its modules (preloaded for
## their constants and rules only); every v18 number below is an ESTIMATE with its reason in the map, section 4.
## The probe stopped at rule 1's measure-first gate, so no career ran on these rules; the measure stage prints the card's
## bar line and the name tiers' worth from them (the parts that need no career).

const Roster := preload("res://scripts/state/Roster.gd")
const ProLadder := preload("res://scripts/state/ProLadder.gd")
const MM := preload("res://scripts/rules/Matchmaking.gd")
const Loyalty := preload("res://scripts/rules/Loyalty.gd")
const TrainingPreview := preload("res://scripts/rules/TrainingPreview.gd")

## --- WHEN (v17) ---
const PATIENCE := 3
const NOT_YET_WEEKS := 4
const NOT_YET_HUNGER := -15
## --- HOW (v17 bands = where the promoter aims; v18 prints the read itself, no squeeze) ---
const TUNE_BAND := Vector2(0.75, 0.90)
const STEP_BAND := Vector2(0.40, 0.55)
const NAME_TUNE := 1
const NAME_STEP := 3
const STEP_PURSE := 1.75
const OPP_RISE := 0.3
## --- CONFIDENCE (0-100): v17's steps; v18: the knockout hit by the confidence trait ---
const CONF_START := 50
const CONF := {"tune_win": 4, "step_win": 12, "points_loss": -10}
const KO_HIT_FRAGILE := -40     ## trait 35 or less (Recruit shows "Fragile")
const KO_HIT_CONFIDENT := -20   ## trait 65 or more (Recruit shows "Confident"); linear between
const TRAIT_LO := 35.0
const TRAIT_HI := 65.0
const CONF_SHIFT_MAX := 0.05
## --- HUNGER (0-100): v18 steps by ambition (Recruit.ambition: potential 78+ chases a title) ---
const HUNGER_START := 70
const TITLE_POT := 78
const HUNGER_TITLE := {"tune_win": -14, "step": 12}
const HUNGER_STEADY := {"tune_win": -6, "step": 8}
const HUNGER_IDLE_4W := -5      ## only EXTRA weeks: fights 1-6 are a fixed 8 weeks apart at no cost
const WARNINGS := 2
## --- v18 rule 5 (a SWITCH in the probe): hunger in the ring at the ends; one cap shared with confidence ---
const FLAT_AT := 20
const FLAT := -0.03
const FIRED_AT := 90
const FIRED := 0.02
const SHARED_CAP := 0.05
## --- rule 2: the name after fight 6 sets where the normal booking starts ---
const TIER_AT := [6, 12]
const TIER_WORDS := ["unranked reach as today", "offers reach five places higher", "starts ranked with a step up on the first card"]
## --- the score (written before any run; map section 8) ---
const SCORE_W := 10.0
const SCORE_L := -5.0
const SCORE_CONF := 0.2
const SCORE_GYM := 0.01


static func title_chaser(pot: int) -> bool:
	return pot >= TITLE_POT


static func hunger_steps(pot: int) -> Dictionary:
	return HUNGER_TITLE if title_chaser(pot) else HUNGER_STEADY


## The knockout hit on CONFIDENCE from the boxer's confidence trait (FighterProfile TRAITS "confidence").
static func ko_hit(trait_value: float) -> int:
	var t := clampf((trait_value - TRAIT_LO) / (TRAIT_HI - TRAIT_LO), 0.0, 1.0)
	return roundi(lerpf(float(KO_HIT_FRAGILE), float(KO_HIT_CONFIDENT), t))


static func conf_shift(conf: int) -> float:
	return clampf(float(conf - 50) / 50.0 * CONF_SHIFT_MAX, -CONF_SHIFT_MAX, CONF_SHIFT_MAX)


static func hunger_shift(hunger: int, ring: bool) -> float:
	if not ring:
		return 0.0
	return FLAT if hunger <= FLAT_AT else (FIRED if hunger >= FIRED_AT else 0.0)


## The printed chance: the game's read (plan included) + the two bars, one shared cap. The number the fight uses.
static func shown(read: float, conf: int, hunger: int, ring: bool) -> float:
	var s := clampf(conf_shift(conf) + hunger_shift(hunger, ring), -SHARED_CAP, SHARED_CAP)
	return clampf(read + s, 0.01, 0.99)


## The card's bar line: "Confidence 66: +1.6 -> 84%" (and the hunger part when it moves the number).
static func bar_line(read: float, conf: int, hunger: int, ring: bool) -> String:
	var line := "Confidence %d: %+.1f" % [conf, 100.0 * conf_shift(conf)]
	var h := hunger_shift(hunger, ring)
	if h != 0.0:
		line += ", hunger %d: %+.0f" % [hunger, 100.0 * h]
	return "%s -> %d%%" % [line, roundi(100.0 * shown(read, conf, hunger, ring))]


static func tier(name: int) -> int:
	return 2 if name >= TIER_AT[1] else (1 if name >= TIER_AT[0] else 0)


## What a tier is worth, read from the game's own purse rule (Matchmaking.pay_of) on the first normal card's best offer:
## tier 0 unranked, reach Matchmaking.UNRANKED_REACH; tier 1 unranked, reach five places higher; tier 2 enters the board's
## bottom seat (as ProLadder REVIEW_WINS) and its first card's step up is BAND_UP places above. Purse only (tickets need fans).
static func tier_purse(t: int, rating: float) -> Dictionary:
	var you := {"rank": 20 if t == 2 else 0, "rating": rating, "fans": 0}
	var reach := 20 - MM.BAND_UP if t == 2 else (MM.UNRANKED_REACH - 5 if t == 1 else MM.UNRANKED_REACH)
	var opp := {"rank": reach, "rating": rating + 3.0}
	var rounds := ProLadder.ROUNDS_TOP10 if reach <= 10 else ProLadder.ROUNDS_RANKED
	return {"tier": t, "words": TIER_WORDS[t], "opp_rank": reach, "purse": int(MM.pay_of(you, opp)["purse"]), "rounds": rounds}


## The tier's worth in score points: the gym's real cut (Roster.signing_share: 10% under loyalty 50) of that purse.
static func tier_points(t: int, rating: float, f: Dictionary) -> float:
	return SCORE_GYM * Roster.signing_share(f) * float(tier_purse(t, rating)["purse"])


## Rule 4: the stats four more weeks of the boxer's current focus give (TrainingPreview.plan_gain, the coach's rating).
static func four_weeks(stats: Dictionary, pot: int, focus: Array, week: int, coach: float) -> Dictionary:
	var st := stats.duplicate()
	for i in NOT_YET_WEEKS:
		var g := TrainingPreview.plan_gain(st, pot, str(focus[(week + i) % focus.size()]), coach)
		for k in g:
			st[k] = float(st[k]) + float(g[k])
	return st


## v18 decline path: "Not yet" costs a mark and hunger only (no morale, loyalty or door). During a live nationals run
## (Champs.active) it costs nothing: the offer waits for the final. Returns false when no mark is left (the rival gym).
static func not_yet(s: Dictionary, nationals_live: bool) -> bool:
	if nationals_live:
		s["week"] = int(s["week"]) + NOT_YET_WEEKS
		return true
	if int(s["patience"]) <= 1:
		return false
	s["patience"] = int(s["patience"]) - 1
	s["hunger"] = clampi(int(s["hunger"]) + NOT_YET_HUNGER, 0, 100)
	s["week"] = int(s["week"]) + NOT_YET_WEEKS
	return true
