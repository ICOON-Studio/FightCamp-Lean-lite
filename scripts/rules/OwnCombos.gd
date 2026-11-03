extends RefCounted
## S375 COMBOPLAN1 - the fighter's own combinations, planned on his profile and trained on the pads (operator S375: "a
## planner should be in each fighters profile to plan his training combos (grappleflow format) 1-1 / step in / hook etc the
## longer the combination the better to become a signature move (good success rate), but long combos cost energy (can be
## thrown limited times)"). A chain saved in PLAYBOOK > Combos (ComboBuilder, f["book"]: {name, chain, score}) is his OWN
## combination: it gets an id ("own:1"), its own pad mastery (f["own_combos"]), and Sim.drill_combos trains it when it is
## the combination he drills. Its steps and slips are the coach's cues; the ring throws its punches.
## - Usable at Combos.LEARN_AT (every punch in it a weapon too), a SIGNATURE at ComboWords.SIGNATURE_AT: drilling, not
##   length, makes the signature. A signature may run ONE punch past his hand-speed cap in the ring (Combos.pick), so a long
##   signature is the only way a 4-punch run is ever thrown whole; tiredness still shortens it (Combos.max_len).
## - Longer chains need more pad time (minutes split over every move, like Combos.drill) and cost more gas a throw
##   (ComboFlow.energy); whole_by_round says in which rounds his tank still throws it whole.
## - lands_whole: how often it lands whole in an even exchange - ComboOdds' own dice (win_odds) on the worth of a drilled
##   combination (PlanFight.EDGE "ok" x its pad rate), a flowing chain (ComboFlow) worth more, a signature more again.
##   ESTIMATE weights FLOW_EDGE / SIG_EDGE for Kalli's review.
##   ensure_ids(f)  entries(f) -> [{id, name, chain, score}]  row(entry) -> {id, moves, beats, counter, sig}
##   mastery(f, id)  usable(f, e)  signature(f, e)  drill_week(f, id, minutes, skill, tier)  rows_for_ring(f)
##   all_mastery(f) -> book + own {id: mastery}   lands_whole(f, e)   gas(f, e)   whole_by_round(f, e) -> [bool x3]
## Pure static.

const Combos := preload("res://scripts/rules/Combos.gd")
const ComboFlow := preload("res://scripts/rules/ComboFlow.gd")
const ComboWords := preload("res://scripts/rules/ComboWords.gd")
const ComboOdds := preload("res://scripts/rules/ComboOdds.gd")
const MoveMastery := preload("res://scripts/rules/MoveMastery.gd")
const PlanFight := preload("res://scripts/rules/PlanFight.gd")
const PlanBoard := preload("res://scripts/rules/PlanBoard.gd")
const RoundStyle := preload("res://scripts/rules/RoundStyle.gd")
const SkillAwards := preload("res://scripts/rules/SkillAwards.gd")

## ComboFlow punch id -> Data.MOVES name (the punch he must have as a weapon).
const PUNCH_OF := {"jab": "Jab", "cross": "Cross", "lead_hook": "Lead hook", "body_hook": "Body hook", "rear_uppercut": "Uppercut"}
const DEFENCES := ["slip", "roll"]
## Power points over a plain drilled combination: a chain that flows (ComboFlow score FLOWS_AT+) and a signature (ESTIMATE).
const FLOW_EDGE := 2.0
const SIG_EDGE := 5.0
## The share of a round's exchanges his best own combination decides (ESTIMATE, ~2 of 6): the round edge the bout adds is
## that share of the flow + signature worth, so the lab's "lands whole" and the ring agree on average.
const USE_SHARE := 0.33
const ROUNDS := 3


static func ensure_ids(f: Dictionary) -> void:
	var n := 0
	for e in f.get("book", []):
		if str(e.get("id", "")) != "":
			n = maxi(n, int(str(e["id"]).trim_prefix("own:")))
	for e in f.get("book", []):
		if str(e.get("id", "")) == "":
			n += 1
			e["id"] = "own:%d" % n


static func entries(f: Dictionary) -> Array:
	ensure_ids(f)
	return f.get("book", [])


static func entry(f: Dictionary, id: String) -> Dictionary:
	for e in entries(f):
		if str(e["id"]) == id:
			return e
	return {}


static func punches(chain: Array) -> Array:
	return chain.filter(func(x): return PUNCH_OF.has(str(x)))


## The combination as the ring knows a book row: its punches as beats and moves; a slip or roll first makes it a counter.
static func row(e: Dictionary, sig := false) -> Dictionary:
	var p := punches(e.get("chain", []))
	return {"id": str(e["id"]), "moves": p.map(func(x): return PUNCH_OF[str(x)]), "beats": p,
		"counter": not (e.get("chain", []) as Array).is_empty() and DEFENCES.has(str(e["chain"][0])), "sig": sig}


static func mastery(f: Dictionary, id: String) -> float:
	return float((f.get("own_combos", {}) as Dictionary).get(id, 0.0))


## Every punch in it a weapon (Combos.LEARN_AT) - he can drill it; "" or the punch he must learn first.
static func missing(f: Dictionary, e: Dictionary) -> String:
	var moves: Dictionary = f.get("moves", {})
	for p in punches(e.get("chain", [])):
		if float(moves.get(PUNCH_OF[str(p)], 0.0)) < Combos.LEARN_AT:
			return str(PUNCH_OF[str(p)])
	return ""


static func usable(f: Dictionary, e: Dictionary) -> bool:
	return punches(e.get("chain", [])).size() >= 2 and missing(f, e) == "" and mastery(f, str(e["id"])) >= Combos.LEARN_AT


static func signature(f: Dictionary, e: Dictionary) -> bool:
	return usable(f, e) and mastery(f, str(e["id"])) >= ComboWords.SIGNATURE_AT


## Never sharper than his weakest punch in it, nor past what his technique and ring IQ hold (Combos.cap).
static func cap(f: Dictionary, e: Dictionary) -> float:
	var moves: Dictionary = f.get("moves", {})
	var lowest := 100.0
	for p in punches(e.get("chain", [])):
		lowest = minf(lowest, float(moves.get(PUNCH_OF[str(p)], 0.0)))
	var st: Dictionary = f.get("stats", {})
	return minf(MoveMastery.cap(float(st.get("technique", 55.0)), float(st.get("fight_iq", 55.0))), lowest)


## One week's pad time on it: minutes split over every move in the chain (steps too: a longer chain takes longer to own).
static func drill_week(f: Dictionary, id: String, minutes: float, skill: float, tier: int) -> float:
	var e := entry(f, id)
	if e.is_empty():
		return 0.0
	if not f.has("own_combos"):
		f["own_combos"] = {}
	var n := float(maxi(1, (e["chain"] as Array).size()))
	var after := MoveMastery.gain(mastery(f, id), "pads", minutes * 2.0 / n, skill, tier, 1.0, cap(f, e))
	f["own_combos"][id] = after
	return after


## His own usable combinations as ring rows (Combos.pick's own pool).
static func rows_for_ring(f: Dictionary) -> Array:
	var out: Array = []
	for e in entries(f):
		if usable(f, e):
			out.append(row(e, signature(f, e)))
	return out


## Book and own masteries in one dict: what the bout's combo edge, uses and gas read.
static func all_mastery(f: Dictionary) -> Dictionary:
	var out: Dictionary = (f.get("combos", {}) as Dictionary).duplicate()
	for e in entries(f):
		if usable(f, e):
			out[str(e["id"])] = mastery(f, str(e["id"]))
	return out


## Its worth in an even exchange (power points): a drilled combination works (PlanFight.EDGE ok) at its pad rate, more when
## it flows, more again as a signature.
static func worth(f: Dictionary, e: Dictionary) -> float:
	var m := mastery(f, str(e["id"]))
	var rate := 1.0 if m >= Combos.LEARN_AT else PlanBoard.UNDRILLED
	var w := float(PlanFight.EDGE["ok"]) * rate
	if int(e.get("score", ComboFlow.rate(e.get("chain", []))["score"])) >= ComboFlow.FLOWS_AT:
		w += FLOW_EDGE
	if signature(f, e):
		w += SIG_EDGE
	return w


## The power points his best own combination adds to a round (BoutNight._energy's bonus): its flow + signature worth x
## USE_SHARE, shrinking as he tires (Combos.energy_scale) - 0 with none usable.
static func ring_edge(f: Dictionary, energy: float) -> float:
	var best := 0.0
	for e in entries(f):
		if usable(f, e):
			best = maxf(best, worth(f, e) - float(PlanFight.EDGE["ok"]))
	return best * USE_SHARE * Combos.energy_scale(energy)


## How often it lands whole in an even exchange (ComboOdds' dice on its worth).
static func lands_whole(f: Dictionary, e: Dictionary) -> float:
	return ComboOdds.win_odds(worth(f, e))


## Gas a throw (ComboFlow.energy, his graded punches cheaper).
static func gas(f: Dictionary, e: Dictionary) -> float:
	return ComboFlow.energy(e.get("chain", []), SkillAwards.economy_ids(f))


## Rounds 1..3 his tank still throws it whole mid-round: his hand-speed cap (+1 for a signature) at the mid-round energy of
## a bout at his conditioning (Combos' own round spend and rest).
static func whole_by_round(f: Dictionary, e: Dictionary) -> Array:
	var n := punches(e.get("chain", [])).size()
	var cap_len := RoundStyle.combo_cap(RoundStyle.of_fighter(f)) + (1 if signature(f, e) else 0)
	var cond := float((f.get("stats", {}) as Dictionary).get("conditioning", 55.0))
	var mine := all_mastery(f)
	var energy := Combos.TANK
	var debt := 0.0
	var out: Array = []
	for r in ROUNDS:
		var a := Combos.after_round(energy, debt, Combos.round_spend(mine, "", cond), cond)
		var mid := (energy + float(a["bell"])) / 2.0
		out.append(Combos.max_len(mid, cap_len) >= n)
		energy = float(a["next"])
		debt = float(a["debt"])
	return out
