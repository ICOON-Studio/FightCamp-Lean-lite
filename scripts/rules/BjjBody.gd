extends RefCounted
## S397 BJJREAL (ops/research/BJJ_REALISM_S397.md): the grappler's body and mind, read side against side by each move.
## A grappler = technique (mastery per move, BjjTree) + body (strength, cardio, flexibility, explosiveness) + mind
## (composure, aggression; the read's IQ stays in BjjTree) + a game (the style, BjjOpp). Nothing is averaged: a move reads
## only the attributes that matter for its kind, the attacker's against the defender's, and the result shifts the odds on the
## logit scale (v2, critic: a sports-sim veteran - every lever adds the same amount whatever the move's base rate).
## Every value is 0-100 like the boxers' stats; a dict without one reads DEFAULT (old saves keep fighting as before).
## Also MAT TIME (the belt and the classes as one level) and the FINISH GATE; their tuning keys live in BjjTree.T.
## Pure static; preloads BjjTree and BeltRoad (neither preloads this).

const BjjTree := preload("res://scripts/rules/BjjTree.gd")
const BeltRoad := preload("res://scripts/rules/BeltRoad.gd")

const ATTRS := ["strength", "cardio", "flexibility", "explosiveness", "composure", "aggression"]
const DEFAULT := 50.0
## [G] the shape of each game (added to DEFAULT, then the noise): a Wrestler is explosive and strong, a Guard player
## flexible, a Passer heavy, a Half-guard player calm, a Leg locker explosive and all-in. The offsets sum near +10 for every
## style, so no game is simply better: each buys its edge with a weakness.
const SHAPES := {
	"Wrestler": {"strength": 6.0, "explosiveness": 12.0, "flexibility": -10.0, "cardio": 4.0, "aggression": 4.0, "composure": -4.0},
	"Guard player": {"flexibility": 14.0, "cardio": 4.0, "strength": -8.0, "composure": 2.0, "explosiveness": -2.0},
	"Passer": {"strength": 12.0, "cardio": 4.0, "composure": 4.0, "explosiveness": -6.0, "flexibility": -4.0, "aggression": -2.0},
	"Half-guard player": {"composure": 10.0, "strength": 4.0, "flexibility": 4.0, "explosiveness": -4.0, "aggression": -4.0},
	"Leg locker": {"explosiveness": 6.0, "flexibility": 8.0, "aggression": 14.0, "composure": -6.0, "strength": -4.0, "cardio": -6.0}}
## [G] +- NOISE uniform on every attribute: two Wrestlers still differ.
const NOISE := 9.0
## [G] composure grows with mat time (a black belt does not panic under a pin): added at READ time for everyone, Ana too
## (v2, critic: a systems designer - in v1 the field gained it and Ana stayed flat).
const BELT_COMPOSURE := {"white": -6.0, "blue": -2.0, "purple": 1.0, "brown": 4.0, "black": 7.0}

## What a move of each kind reads: [attacker weights, defender weights] (weights sum to 1 a side, so no kind is worth more
## by reading more). "standing" = a takedown, entry or back take off the feet; the submission rows by family.
## v2 (critic: a black belt coach, S397): strength cut on passes, chokes and escapes (position and hand fighting win those,
## not squeeze); flexibility off choke and heel-hook defence (a neck and a knee do not stretch) - kept for guard retention,
## arm locks and the hips in an escape; leg-lock defence is mostly the answer's mastery (knowledge), the body only the calm
## and the speed to clear the knee line.
const READS := {
	"standing": [{"explosiveness": 0.6, "strength": 0.4}, {"explosiveness": 0.6, "strength": 0.4}],
	"pass": [{"strength": 0.45, "explosiveness": 0.35, "composure": 0.2}, {"flexibility": 0.6, "explosiveness": 0.4}],
	"sweep": [{"explosiveness": 0.6, "flexibility": 0.4}, {"strength": 0.4, "composure": 0.3, "explosiveness": 0.3}],
	"escape": [{"explosiveness": 0.5, "flexibility": 0.3, "composure": 0.2}, {"strength": 0.4, "composure": 0.3, "explosiveness": 0.3}],
	"back_take": [{"explosiveness": 0.7, "composure": 0.3}, {"composure": 0.6, "explosiveness": 0.4}],
	"entry": [{"flexibility": 0.6, "explosiveness": 0.4}, {"strength": 0.4, "composure": 0.3, "explosiveness": 0.3}],
	"transition": [{"explosiveness": 0.5, "strength": 0.5}, {"explosiveness": 0.5, "strength": 0.5}],
	"choke": [{"composure": 0.6, "strength": 0.4}, {"composure": 0.7, "explosiveness": 0.3}],
	"arm": [{"explosiveness": 0.6, "strength": 0.4}, {"flexibility": 0.6, "composure": 0.4}],
	"leg": [{"explosiveness": 0.6, "flexibility": 0.4}, {"composure": 0.5, "explosiveness": 0.5}]}
const CHOKES := ["guillotine", "rear_naked_choke", "triangle", "darce", "anaconda", "north_south_choke", "back_triangle",
	"clock_choke", "mounted_triangle", "head_arm_choke"]
const LEGS := ["straight_ankle_lock", "outside_heel_hook", "kneebar", "toe_hold", "inside_heel_hook", "calf_slicer"]
## [G] body = K x edge / 100 on the logit, capped +-CAP: a 20-point edge on what the move reads = +0.2 (a 0.30 move -> 0.34),
## the cap 0.25 (v2, the coach: a body edge is never worth a belt; the wrestler white belt still lands at the cap).
const K := 1.0
const CAP := 0.25

## Gas (the walk's tank, 1.0 = fresh): every non-BASE attempt costs GAS_COST of its kind x drain, a miss MISS_GAS more x drain;
## drain = DRAIN_K - cardio / 100 (cardio 50 = x1.0, 70 = x0.8, 30 = x1.2). Odds x tired(attacker) / tired(defender), with
## GAS_W x (tank - the other's tank) on the logit: equal tanks cancel, so only a cardio gap (or a reckless pace) shows late.
## [G] sized so a 10-minute black bout at cardio 50 ends near half a tank; a 30-cardio grappler near empty.
const GAS_COST := {"takedown": 0.07, "pass": 0.06, "escape": 0.06, "sweep": 0.05, "back_take": 0.05, "submission": 0.05,
	"entry": 0.04, "transition": 0.04}
const MISS_GAS := 0.03
const BREATHE := 0.04
const DRAIN_K := 1.5
const GAS_W := 0.6

## Aggression (a dial): AGGR_W x (aggression - 50) / 50 is added to an attempt's expected value in the chooser (a sub hunter
## takes the marginal shot, a patient grappler holds); at HOLD_AGGR or more a grappler never holds a lead to the bell, at
## CAUTIOUS_AGGR or less it starts holding one twice as early.
const AGGR_W := 0.6
const HOLD_AGGR := 68.0
const CAUTIOUS_AGGR := 35.0
## v2 (critic: a systems designer): the player's call for a bout, f["mat_call"] - it moves the athlete's own aggression.
const CALLS := {"hunt": 25.0, "steady": 0.0, "hold": -20.0}


static func attr(f: Dictionary, key: String) -> float:
	var st: Variant = f.get("stats", {})
	if st is Dictionary and (st as Dictionary).has(key):
		return float(st[key])
	return float(f.get(key, DEFAULT))


## {attr: value} for every ATTRS key, as the mat reads it: composure + the belt's, aggression + the player's call.
static func attrs(f: Dictionary) -> Dictionary:
	var out := {}
	for k in ATTRS:
		out[k] = attr(f, k)
	out["composure"] = clampf(float(out["composure"]) + float(BELT_COMPOSURE.get(str(f.get("belt", "white")), 0.0)), 0.0, 100.0)
	out["aggression"] = clampf(float(out["aggression"]) + float(CALLS.get(str(f.get("mat_call", "steady")), 0.0)), 0.0, 100.0)
	return out


## A seeded body + mind for a game: DEFAULT + the shape + noise, kept in 20-90 (the belt's composure comes at read time).
static func roll(style: String, seed: int) -> Dictionary:
	var rng := RandomNumberGenerator.new()
	rng.seed = hash("%d|body" % seed)
	var shape: Dictionary = SHAPES.get(style, {})
	var out := {}
	for k in ATTRS:
		var v := DEFAULT + float(shape.get(k, 0.0)) + rng.randf_range(-NOISE, NOISE)
		out[k] = snappedf(clampf(v, 20.0, 90.0), 1.0)
	return out


## The row of READS a tree edge uses: standing moves by their start, submissions by family, the rest by kind.
static func read_key(e: Dictionary) -> String:
	var kind := str(e.get("odds", ""))
	if kind == "submission":
		var mv := str(e.get("move", ""))
		if CHOKES.has(mv):
			return "choke"
		return "leg" if LEGS.has(mv) else "arm"
	if str(e.get("from", "")) == "standing" and kind in ["takedown", "entry", "back_take"]:
		return "standing"
	if kind == "takedown":
		return "standing"
	return kind if READS.has(kind) else ""


## The weighted edge of attacker a over defender d for a READS row (attribute points, + = the attacker's).
static func edge_points(key: String, a: Dictionary, d: Dictionary) -> float:
	if not READS.has(key):
		return 0.0
	var row: Array = READS[key]
	var x := 0.0
	for k in row[0]:
		x += float(row[0][k]) * float(a.get(k, DEFAULT))
	for k in row[1]:
		x -= float(row[1][k]) * float(d.get(k, DEFAULT))
	return x


## The body's logit shift for an edge, attacker attrs a vs defender attrs d (0 for an unread kind).
static func shift(e: Dictionary, a: Dictionary, d: Dictionary) -> float:
	var key := read_key(e)
	if key == "":
		return 0.0
	return clampf(K * edge_points(key, a, d) / 100.0, -CAP, CAP)


## The attribute that weighs most in the attacker's edge here (the note names it): [name, points] of the biggest term.
static func decider(e: Dictionary, a: Dictionary, d: Dictionary) -> Array:
	var key := read_key(e)
	if not READS.has(key):
		return ["", 0.0]
	var row: Array = READS[key]
	var best := ["", 0.0]
	for k in row[0]:
		var v := float(row[0][k]) * (float(a.get(k, DEFAULT)) - DEFAULT)
		if absf(v) > absf(float(best[1])):
			best = [k, v]
	for k in row[1]:
		var v2 := -float(row[1][k]) * (float(d.get(k, DEFAULT)) - DEFAULT)
		if absf(v2) > absf(float(best[1])):
			best = ["their " + k, v2]
	return best


static func drain(cardio: float) -> float:
	return DRAIN_K - cardio / 100.0


## The tanks' logit shift for the attacker (gas a) against the defender (gas d).
static func tank(gas_a: float, gas_d: float) -> float:
	return GAS_W * (clampf(gas_a, 0.0, 1.0) - clampf(gas_d, 0.0, 1.0))


## Gas after an attempt of `kind` (hit or miss) at this cardio.
static func spend(gas: float, kind: String, hit: bool, cardio: float) -> float:
	var c := float(GAS_COST.get(kind, 0.0)) + (0.0 if hit else MISS_GAS)
	return maxf(0.0, gas - c * drain(cardio))


static func breathe(gas: float) -> float:
	return minf(1.0, gas + BREATHE)


## The chooser's aggression term for a non-BASE attempt.
static func aggr_bias(aggression: float) -> float:
	return AGGR_W * (aggression - DEFAULT) / DEFAULT


## [G] S397 the mat-time level a belt starts at (mat_time); a black belt gains T.MAT_TOP more over its first 300 classes.
## S398 the levels are [T] keys (BjjTree.T: MAT_BLUE .. MAT_BLACK, MAT_TOP = the black belt's own step), fitted on the probe.
static func level(belt: String) -> float:
	return 0.0 if belt == "white" else float(BjjTree.T.get("MAT_" + belt.to_upper(), 0.0))


## S397 BJJREAL (ops/research/BJJ_REALISM_S397.md 5): MAT TIME - years on the mat as a level, kept apart from the moves
## (critic: a sports-sim veteran; the mastery factor moves a move's odds ~0.6% a point, too little to carry a belt). The
## level of the belt + the share of the classes towards the next one (it builds class by class, so a promotion is no jump);
## the steps shrink up the belts (critic: a black belt coach - white to blue is the biggest gap, brown to black the
## smallest). In the walk each attempt reads the gap on the logit: T.MAT_ATT x gap when the attacker is the senior, T.MAT_DEF
## x gap (bigger) when the defender is - defence counts more (a black belt coach: "higher belts simply do not get tapped").
static func mat_time(f: Dictionary) -> float:
	var belt := str(f.get("belt", "white"))
	var lv := level(belt)
	var nxt := BeltRoad.next_belt(belt)
	var step := level(nxt) - lv if nxt != "" else float(BjjTree.T["MAT_TOP"])
	var need := float(BeltRoad.CLASSES_TO_NEXT.get(belt, BeltRoad.CLASSES_TO_NEXT["brown"]))
	var cls := maxf(0.0, float(f.get("mat_classes", 0)) - float(f.get("mat_debt", 0)))
	return lv + step * clampf(cls / need, 0.0, 1.0)


## The mat-time gap (attacker - defender) on the logit: MAT_ATT a level for a senior attacker, MAT_DEF for a senior defender.
static func mat_shift(gap: float) -> float:
	return gap * float(BjjTree.T["MAT_ATT"] if gap > 0.0 else BjjTree.T["MAT_DEF"])


## A mat-time gap in words for the result card ("half a belt", "a belt", "two belts").
static func mat_words(gap: float) -> String:
	var g := absf(gap)
	if g < 0.35:
		return "a few months"
	if g < 0.75:
		return "half a belt"
	if g < 1.4:
		return "about a belt"
	return "%d belts" % int(round(g))


## S397 the finish gate (critic: a sports-sim veteran): a submission that lands is still escaped before the tap with this
## chance - the tier's base, moved by the defender's mat time over the attacker's (a black belt is hard to finish, a
## white belt rarely gets out of a locked choke). A gated escape is a near submission: an advantage, no tap.
static func escape_chance(rules: Dictionary, mat_gap_def: float) -> float:
	var tier := str(rules.get("tier", "amateur"))
	var base := float(BjjTree.T["ESC_AM"])
	if tier == "pro":
		base = float(BjjTree.T["ESC_PRO"])
	elif tier == "mid":
		base = (float(BjjTree.T["ESC_AM"]) + float(BjjTree.T["ESC_PRO"])) / 2.0
	return clampf(BjjTree.logit_add(base, float(BjjTree.T["ESC_W"]) * mat_gap_def), 0.01, 0.95)
