extends RefCounted
## S375 COMBOPLAN1 - the fighter's own combinations, planned on his profile and trained on the pads (operator S375: "a
## planner should be in each fighters profile to plan his training combos (grappleflow format) 1-1 / step in / hook etc the
## longer the combination the better to become a signature move (good success rate), but long combos cost energy (can be
## thrown limited times)"). A chain saved in PLAYBOOK > Combos (ComboBuilder, f["book"]: {name, chain, score}) is his OWN
## combination: it gets an id ("own:1"), its own pad mastery (f["own_combos"]), and DrillWeek trains it when it is
## the combination he drills. Its steps and slips are the coach's cues; the ring throws its punches.
## - Usable at Combos.LEARN_AT (every punch in it a weapon too), a SIGNATURE at ComboWords.SIGNATURE_AT: drilling, not
##   length, makes the signature. A signature may run ONE punch past his hand-speed cap in the ring (Combos.pick), so a long
##   signature is the only way a 4-punch run is ever thrown whole; tiredness still shortens it (Combos.max_len).
## - Longer chains need more pad time (minutes split over every move, like Combos.drill) and cost more gas a throw
##   (ComboFlow.energy); whole_by_round says in which rounds his tank still throws it whole.
## - lands_whole: how often it lands whole in an even exchange - ComboOdds' own dice (win_odds) on the worth of a drilled
##   combination (PlanFight.EDGE "ok" x its pad rate), a flowing chain (ComboFlow) worth more, a signature more again.
##   A long signature (4+ punches) is the GAMBLE: +LONG_EXTRA when it lands, but lands whole at LONG_ODDS_WORTH (0.58)
##   vs a short signature's 0.64 (Kalli K_COMBOPLAN1, S376).
## - worth is capped at COMBO_CAP (10); use_share: NAMED_SHARE (0.40) when the plan names it, TIRED_SHARE (0.25) under
##   TIRED_AT (40), else USE_SHARE (0.33) - never above 0.40. ring_edge replaces Combos.energy_scale with use_share.
##   ensure_ids(f)  entries(f) -> [{id, name, chain, score}]  row(entry) -> {id, moves, beats, counter, sig}
##   mastery(f, id)  usable(f, e)  signature(f, e)  long_signature(f, e)  drill_week(f, id, minutes, skill, tier)
##   rows_for_ring(f)  all_mastery(f) -> book + own {id: mastery}   lands_whole(f, e)   use_share(energy, named)
##   ring_edge(f, energy, whole_energy)   gas(f, e)   whole_by_round(f, e) -> [bool x3]   whole_at(f, e, energy)
## - S378 PLANCOMBO1 the plan NAMES one (f["plan_combo"], PLAYBOOK > Game plan's GO-TO COMBINATION): named(f) is that entry
##   while usable; it decides NAMED_SHARE of his combination exchanges while his tank still throws it whole (whole_at), and
##   the ring picks it NAMED_SHARE / USE_SHARE as often (its row's "weight", Combos.pick). A long go-to wins the fresh rounds
##   and stops paying once he is too tired to finish it - the choice is the trade.
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
const Attrs := preload("res://scripts/rules/Attrs.gd")

## ComboFlow punch id -> Data.MOVES name (the punch he must have as a weapon).
const PUNCH_OF := {"jab": "Jab", "cross": "Cross", "lead_hook": "Lead hook", "body_hook": "Body hook", "rear_uppercut": "Uppercut"}
const DEFENCES := ["slip", "roll"]
## Power points over a plain drilled combination: a chain that flows (ComboFlow score FLOWS_AT+) and a signature (ESTIMATE).
const FLOW_EDGE := 2.0
const SIG_EDGE := 5.0
## The share of a round's exchanges his best own combination decides (ESTIMATE, ~2 of 6): the round edge the bout adds is
## that share of the flow + signature worth, so the lab's "lands whole" and the ring agree on average.
const USE_SHARE := 0.33
## S376 Kalli K_COMBOPLAN1: the worth a combination's part is capped at, and the long-signature gamble numbers.
const COMBO_CAP := 10.0
const LONG_AT := 4
const LONG_EXTRA := 1.0
const LONG_ODDS_WORTH := 5.5
## Tired / named shares (Kalli K_COMBOPLAN1, S376): drops to TIRED_SHARE under TIRED_AT, rises to NAMED_SHARE when the
## fight plan names the combination, never above NAMED_SHARE.
const TIRED_SHARE := 0.25
const TIRED_AT := 40.0
const NAMED_SHARE := 0.40
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
static func row(e: Dictionary, sig := false, go_to := false) -> Dictionary:
	var p := punches(e.get("chain", []))
	return {"id": str(e["id"]), "moves": p.map(func(x): return PUNCH_OF[str(x)]), "beats": p,
		"counter": not (e.get("chain", []) as Array).is_empty() and DEFENCES.has(str(e["chain"][0])), "sig": sig,
		"weight": NAMED_SHARE / USE_SHARE if go_to else 1.0}


## S378 PLANCOMBO1 the plan's go-to combination: the entry f["plan_combo"] names while he can use it, else {}.
static func named(f: Dictionary) -> Dictionary:
	var e := entry(f, str(f.get("plan_combo", "")))
	return e if not e.is_empty() and usable(f, e) else {}


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
## S382 PADWEEK1: PadWeek calls it a night at a time (minutes = that night's share); station "ring_sparring" on a spar night.
static func drill_week(f: Dictionary, id: String, minutes: float, skill: float, tier: float, station := "pads") -> float:
	var e := entry(f, id)
	if e.is_empty():
		return 0.0
	if not f.has("own_combos"):
		f["own_combos"] = {}
	var n := float(maxi(1, (e["chain"] as Array).size()))
	var after := MoveMastery.gain(mastery(f, id), station, minutes * 2.0 / n, skill, tier, 1.0, cap(f, e))
	f["own_combos"][id] = after
	return after


## His own usable combinations as ring rows (Combos.pick's own pool).
static func rows_for_ring(f: Dictionary) -> Array:
	var out: Array = []
	var go_to := str(named(f).get("id", ""))
	for e in entries(f):
		if usable(f, e):
			out.append(row(e, signature(f, e), str(e["id"]) == go_to))
	return out


## Book and own masteries in one dict: what the bout's combo edge, uses and gas read.
static func all_mastery(f: Dictionary) -> Dictionary:
	var out: Dictionary = (f.get("combos", {}) as Dictionary).duplicate()
	for e in entries(f):
		if usable(f, e):
			out[str(e["id"])] = mastery(f, str(e["id"]))
	return out


## Its worth in an even exchange (power points): a drilled combination works (PlanFight.EDGE ok) at its pad rate, more when
## it flows, more again as a signature. Capped at COMBO_CAP (Kalli K_COMBOPLAN1, S376).
static func worth(f: Dictionary, e: Dictionary) -> float:
	var m := mastery(f, str(e["id"]))
	var rate := 1.0 if m >= Combos.LEARN_AT else PlanBoard.UNDRILLED
	var w := float(PlanFight.EDGE["ok"]) * rate
	if int(e.get("score", ComboFlow.rate(e.get("chain", []))["score"])) >= ComboFlow.FLOWS_AT:
		w += FLOW_EDGE
	if signature(f, e):
		w += SIG_EDGE
	return minf(w, COMBO_CAP)


## The power points his best own combination adds to a round (BoutNight._energy's bonus): per usable combination the edge
## is (worth - EDGE ok); for a long signature (4+ punches) the gamble adds LONG_EXTRA but lands at LONG_ODDS_WORTH odds
## divided by win_odds(COMBO_CAP). Best of them x use_share - NAMED for the plan's go-to while whole_at(whole_energy)
## (BoutNight: the round's mid energy, as whole_by_round reads it; < 0 = `energy`). Replaces Combos.energy_scale (Kalli S376).
static func ring_edge(f: Dictionary, energy: float, whole_energy := -1.0) -> float:
	var best := 0.0
	var go_to := str(named(f).get("id", ""))
	for e in entries(f):
		if not usable(f, e):
			continue
		var edge := worth(f, e) - float(PlanFight.EDGE["ok"])
		if long_signature(f, e):
			edge = (worth(f, e) - float(PlanFight.EDGE["ok"]) + LONG_EXTRA) * lands_whole(f, e) / ComboOdds.win_odds(COMBO_CAP)
		var go := str(e["id"]) == go_to and whole_at(f, e, whole_energy if whole_energy >= 0.0 else energy)
		best = maxf(best, edge * use_share(energy, go))
	return best


## Whether his tank still throws it whole at this energy, by the ring's own rule (Combos.pick): his hand-speed cap shortened
## as he tires, plus one for a signature.
static func whole_at(f: Dictionary, e: Dictionary, energy: float) -> bool:
	var run := Combos.max_len(energy, RoundStyle.combo_cap(RoundStyle.of_fighter(f))) + (1 if signature(f, e) else 0)
	return run >= punches(e.get("chain", [])).size()

## How often it lands whole in an even exchange (ComboOdds' dice on its worth). A long signature lands at LONG_ODDS_WORTH
## (the gamble: it counts +1 when it lands whole, but 4-punch chains land less often than 2-3 punch ones, Kalli S376).
static func lands_whole(f: Dictionary, e: Dictionary) -> float:
	if long_signature(f, e):
		return ComboOdds.win_odds(LONG_ODDS_WORTH)
	return ComboOdds.win_odds(worth(f, e))

## A long signature: a signature chain of LONG_AT (4) punches or more - the only way a 4-punch run is thrown whole.
static func long_signature(f: Dictionary, e: Dictionary) -> bool:
	return signature(f, e) and punches(e.get("chain", [])).size() >= LONG_AT

## The share of a round's exchanges his best combination decides: NAMED_SHARE when the plan names it, TIRED_SHARE when
## energy is under TIRED_AT, else USE_SHARE. Never above NAMED_SHARE (Kalli K_COMBOPLAN1, S376).
static func use_share(energy: float, named: bool = false) -> float:
	if named:
		return NAMED_SHARE
	if energy < TIRED_AT:
		return TIRED_SHARE
	return USE_SHARE


## Gas a throw (ComboFlow.energy, his graded punches cheaper).
static func gas(f: Dictionary, e: Dictionary) -> float:
	return ComboFlow.energy(e.get("chain", []), SkillAwards.economy_ids(f))


## Rounds 1..3 his tank still throws it whole mid-round: his hand-speed cap (+1 for a signature) at the mid-round energy of
## a bout at his Stamina and Recovery (Combos' own round spend and rest; S433 CARDIO1).
static func whole_by_round(f: Dictionary, e: Dictionary) -> Array:
	var own := Attrs.of(f)
	var mine := all_mastery(f)
	var energy := Combos.TANK
	var debt := 0.0
	var out: Array = []
	for r in ROUNDS:
		var a := Combos.after_round(energy, debt, Combos.round_spend(mine, "", float(own["stamina"])), float(own["recovery"]))
		out.append(whole_at(f, e, (energy + float(a["bell"])) / 2.0))
		energy = float(a["next"])
		debt = float(a["debt"])
	return out
