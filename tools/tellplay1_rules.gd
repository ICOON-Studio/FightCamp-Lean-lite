extends RefCounted
## TELLPLAY1 (S543, ops/research/TASK_TELLPLAY1.md, ops/research/DESIGN_TELLPLAY1.md): the two FLAGGED rules as local copies.
## Nothing under scripts/ changes. The population is TURNPROBE18's (tools/turnprobe18.gd, copied, not edited).
##   A "THE TELL PLAYS": each tell (weapon, weakness) OppFile maps to press / range / counter / loadup multiplies that game's
##     weight in Exchanges.next_mode's mix (the same bias dict the read's _games and the live bout's mode_bias pass), sized so
##     its share of the mix becomes max(A_MULT x share, share + A_ADD). A situation two tells name is raised once.
##   B "THE FADE ANSWER UNDER THE CAP": the opponent-tiring situation reads a plan line at B_FACTOR of its edge (today
##     BoutRead.PLAN_REACH x PLAN_CARRY = 1.425, no fire share). b_mode "off" = today, "carry:<x>" = x instead of 1.425,
##     "chain" = the line walked on the card chain at its fire share, like the other situations.
## The read copies: round_edges / chance below are BoutRead._round_edges / chance with those two hooks; every other step
## calls BoutRead's own statics.

const BoutRead := preload("res://scripts/rules/BoutRead.gd")
const OppFile := preload("res://scripts/rules/OppFile.gd")
const Exchanges := preload("res://scripts/rules/Exchanges.gd")
const BoutRules := preload("res://scripts/rules/BoutRules.gd")
const ComboOdds := preload("res://scripts/rules/ComboOdds.gd")
const CardOdds := preload("res://scripts/rules/CardOdds.gd")
const PlanChain := preload("res://scripts/rules/PlanChain.gd")
const PlanFight := preload("res://scripts/rules/PlanFight.gd")
const PlanFile := preload("res://scripts/rules/PlanFile.gd")
const LineGrade := preload("res://scripts/rules/LineGrade.gd")
const RingDuel := preload("res://scripts/state/RingDuel.gd")
const Data := preload("res://scripts/state/Data.gd")
const Sim := preload("res://scripts/state/Sim.gd")
const FirstWeek := preload("res://scripts/rules/FirstWeek.gd")
const TrainingPreview := preload("res://scripts/rules/TrainingPreview.gd")
const DebutOpp := preload("res://scripts/rules/DebutOpp.gd")

## Rule A start size (ESTIMATE, the brief's): x1.5 of the share and at least +10 points of share.
static var A_MULT := 1.5
static var A_ADD := 0.10
const A_CAP := 0.85
const MIX_SITS := ["press", "range", "counter", "loadup"]
const TODAY_TIRING := BoutRead.PLAN_REACH * BoutRead.PLAN_CARRY

static var _mult := {}
static var _ge := {}


## {sit: [tell ids]} for the weapon and the weakness (OppFile's fourth column); "" situations are left out.
static func tell_sits(opp: Dictionary) -> Dictionary:
	var out := {}
	var w: Array = OppFile._answer(str(opp.get("threat", "")), OppFile.WEAPON_ANSWERS)
	var k: Array = OppFile._answer(str(opp.get("weak", "")), OppFile.WEAKNESS_ANSWERS)
	if str(w[2]) != "":
		out.get_or_add(str(w[2]), []).append("weapon")
	if str(k[2]) != "":
		out.get_or_add(str(k[2]), []).append("weakness")
	return out


## The weak word next_mode reads in the read's mix (BoutRead._games).
static func _weak_word(opp: Dictionary) -> String:
	return "walks in" if str(opp.get("weak", "")).to_lower().contains("walks in") else ""


## Rule A: the bias dict (mode_bias of this pair, x the tell multipliers). on = false: the game's own.
static func bias(f: Dictionary, opp: Dictionary, on: bool) -> Dictionary:
	var fx := f.duplicate()
	fx["bout"] = {}
	var b: Dictionary = RingDuel.mode_bias(fx, opp).duplicate()
	if not on:
		return b
	for sit in tell_sits(opp):
		if not MIX_SITS.has(sit):
			continue   # tiring: next_mode already plays the fade (FADE_ODDS late, OPP_TIRED_ODDS on an empty tank); rule B
		var m := mult(str(opp.get("style", "")), _weak_word(opp), b, str(sit))
		b[sit] = float(b.get(sit, 1.0)) * m
	return b


## The multiplier on sit's weight that takes its share of the mix (BoutRead._games, next_mode's own dice) to the target.
static func mult(style: String, weak: String, base: Dictionary, sit: String) -> float:
	var key := "%s|%s|%s|%s|%.3f|%.3f" % [style, weak, str(base), sit, A_MULT, A_ADD]
	if _mult.has(key):
		return float(_mult[key])
	var opp := {"style": style, "weak": weak}
	var s0 := float(BoutRead._games(opp, base).get(sit, 0.0))
	var want := minf(A_CAP, maxf(A_MULT * s0, s0 + A_ADD))
	var lo := 1.0
	var hi := 40.0
	for _i in 18:
		var mid := sqrt(lo * hi)
		var b := base.duplicate()
		b[sit] = float(base.get(sit, 1.0)) * mid
		if float(BoutRead._games(opp, b).get(sit, 0.0)) < want:
			lo = mid
		else:
			hi = mid
	var m := snappedf(sqrt(lo * hi), 0.001)
	_mult[key] = m
	return m


## The mix the read plays (rule A on or off), whole, for the print.
static func mix(f: Dictionary, opp: Dictionary, on: bool) -> Dictionary:
	var fx := f.duplicate()
	fx["bout"] = {}
	return BoutRead._games(opp, bias(fx, opp, on))


## The line term of the tiring situation (BoutRead._game_edge_of line 248) at factor k.
static func _tiring_line(fx: Dictionary, n: int, k: float) -> float:
	var sit := "tiring"
	var at := str(PlanFight.GAME_CARD.get(sit, "long"))
	var moves: Dictionary = fx.get("moves", {})
	var combos: Dictionary = fx.get("combos", {})
	var pick := PlanFight.choose(PlanFile.arrows_for(fx.get("arrows", []), fx.get("late", {}), n, BoutRules.ROUNDS), at, moves, sit)
	return k * LineGrade.edge(pick, sit, PlanFight.rate(str(pick["move"]), combos), PlanFight.card_mean(at, sit, moves, combos), LineGrade.attrs_for(fx))


## BoutRead._game_edge with rule B on the tiring situation.
static func game_edge(fx: Dictionary, sit: String, n: int, b_mode: String) -> float:
	var e := BoutRead._game_edge(fx, sit, n)
	if sit != "tiring" or b_mode == "off":
		return e
	var today := _tiring_line(fx, n, TODAY_TIRING)
	if b_mode == "chain":
		return e - today
	return e - today + _tiring_line(fx, n, float(b_mode.trim_prefix("carry:")))


## BoutRead._round_edges (lines 322-380) with rule A's mix and rule B's tiring line. The rest is BoutRead's own.
static func round_edges(f: Dictionary, opp: Dictionary, camp: Dictionary, coach: float, a_on: bool, b_mode: String) -> Array:
	var fx := BoutRead._read_copy(f, opp, camp, coach)
	var base := ComboOdds.night_gap(fx)
	var tanks := BoutRead._energy(fx, opp, BoutRules.tank_read(f), int((f.get("bout", {}) as Dictionary).get("rounds", BoutRules.ROUNDS)))
	var mx := BoutRead._games(opp, bias(fx, opp, a_on))
	var own_attrs := RingDuel.Attrs.of(fx)
	var opp_attrs := RingDuel.opp(opp)
	var body_a := BoutRead.MEAN_LANDED * Exchanges.body_cost(float(own_attrs.get("body", 55.0))) \
		* (Exchanges.BODY_THREAT_SHARE if str(opp.get("threat", "")).to_lower().contains("body") else Exchanges.BODY_SHARE)
	var out: Array = []
	var states: Dictionary = {}
	var skip := ["she_tired"] if b_mode == "chain" else ["she_tired", "tiring"]
	for n in range(1, tanks.size() + 1):
		var t: Dictionary = tanks[n - 1]
		var e := base + float(t["edge"]) + BoutRules.stance_edge(n, str(f.get("stance", "orthodox")), opp, camp)
		e += BoutRules.first_round_edge(n, f.get("bout", {})) + BoutRules.spar_edge(n, f.get("bout", {}))
		if n >= BoutRules.ROUNDS:
			e -= BoutRules.own_fade(float(own_attrs["stamina"]))
		if n >= BoutRules.ROUNDS and str(opp.get("weak", "")).begins_with("Fades"):
			e += BoutRules.OPP_FADE
		var worth := {}
		for sit in mx.keys() + ["tiring", "she_tired"]:
			worth[sit] = game_edge(fx, str(sit), n, b_mode)
		var body_b := BoutRead.MEAN_LANDED * Exchanges.body_cost(float(opp_attrs.get("body", 55.0))) \
			* (Exchanges.BODY_CALL_SHARE if BoutRead._call(f, n) == "body" else Exchanges.BODY_SHARE)
		var eas: Array = []; var ebs: Array = []; var wbs: Array = []; var steps: Array = []
		var mixw := RingDuel.wants_of_mix(mx)
		for i in Exchanges.EXCHANGES:
			var at := float(i) / float(Exchanges.EXCHANGES)
			var done := float((n - 1) * Exchanges.EXCHANGES + i)
			eas.append(lerpf(float(t["a"]), float(t["a_end"]), at) - done * body_a)
			var eb := lerpf(float(t["b"]), float(t["b_end"]), at) - done * body_b
			ebs.append(eb)
			var tr := BoutRead._tiring(opp, n, eb)
			wbs.append([(1.0 - tr) * float(mixw[0]) + tr, (1.0 - tr) * float(mixw[1]), (1.0 - tr) * float(mixw[2])])
		var duel_read := RingDuel.mean_edges(fx, opp, n, eas, ebs, BoutRead._call(f, n), wbs, states, true)
		states = duel_read["states"]
		var duels: Array = duel_read["edges"]
		for i in Exchanges.EXCHANGES:
			e += float(duels[i]) / float(Exchanges.EXCHANGES)
		for i in Exchanges.EXCHANGES:
			var ex := 0.0
			if float(eas[i]) < Exchanges.SHE_TIRED:
				ex = float(worth["she_tired"])
				steps.append({"she_tired": 1.0})
			else:
				var tiring := BoutRead._tiring(opp, n, float(ebs[i]))
				ex = tiring * float(worth["tiring"])
				var st := {"tiring": tiring}
				for sit in mx:
					ex += (1.0 - tiring) * float(mx[sit]) * float(worth[sit])
					st[sit] = (1.0 - tiring) * float(mx[sit])
				steps.append(st)
			e += ex / float(Exchanges.EXCHANGES)
		e += BoutRead.PLAN_CARRY * PlanChain.walk(fx.get("arrows", []), fx.get("moves", {}), fx.get("combos", {}), steps, ComboOdds.win_odds(e), skip, fx.get("steps", {}))
		out.append(e)
	return out


## The 4-round card's win chance (as turnprobe18.read: CardOdds.result on the round edges).
static func chance(f: Dictionary, opp: Dictionary, camp: Dictionary, coach: float, a_on: bool, b_mode: String) -> float:
	return float(CardOdds.result(round_edges(f, opp, camp, coach, a_on, b_mode), RingDuel.FORM_SD)["win"])


# ---- TURNPROBE18's ten types (copied from tools/turnprobe18.gd, unchanged numbers) ----
const CONF_TRAIT := [30.0, 58.0, 66.0, 70.0, 82.0, 38.0, 25.0, 75.0, 45.0, 33.0]
const LOYALTY := [60.0, 60.0, 82.0, 66.0, 44.0, 70.0, 60.0, 40.0, 60.0, 60.0]
const TECH := {
	"Out-boxer": [{"Jab": 70, "Cross": 58, "Lead hook": 45, "Body hook": 32, "Uppercut": 20, "Check hook": 15},
		{"1-1": 60, "1-2": 62, "1-1-2": 45, "2-3": 35}, {"step_in": 50, "step_out": 60, "step_back": 55, "pivot_out": 45, "feint": 40}],
	"Slugger": [{"Jab": 50, "Cross": 68, "Lead hook": 62, "Body hook": 50, "Uppercut": 45, "Check hook": 10},
		{"1-2": 45, "2-3": 55, "3b-3": 50, "1-6-3": 40, "1-2-3": 35}, {"step_in": 55, "cut_off": 40, "herd": 35, "tie_up": 45, "push_off": 45}],
	"Pressure fighter": [{"Jab": 52, "Cross": 58, "Lead hook": 64, "Body hook": 66, "Uppercut": 40, "Check hook": 10},
		{"3b-3": 60, "1-2-3b": 50, "1-2": 40, "1-2-3-2": 35, "1-6-3": 35}, {"cut_off": 55, "herd": 50, "step_in": 55, "tie_up": 40, "push_off": 40}],
	"Boxer-puncher": [{"Jab": 62, "Cross": 62, "Lead hook": 55, "Body hook": 45, "Uppercut": 35, "Check hook": 20},
		{"1-2": 58, "1-2-3": 48, "2-3": 40, "slip 2-3": 35, "1-2-3b": 35}, {"step_in": 45, "step_out": 45, "step_back": 45, "pivot_out": 40, "feint": 35}],
	"Counter-puncher": [{"Jab": 60, "Cross": 62, "Lead hook": 55, "Body hook": 38, "Uppercut": 30, "Check hook": 50},
		{"slip 2-3": 58, "1-2": 50, "2-3": 45, "1-1": 40}, {"step_back": 60, "pivot_out": 55, "roll_out": 50, "feint": 45, "step_out": 45}],
	"Volume puncher": [{"Jab": 62, "Cross": 58, "Lead hook": 56, "Body hook": 50, "Uppercut": 32, "Check hook": 10},
		{"1-2-3-2": 55, "1-2": 58, "1-2-3": 50, "3b-3": 40, "1-1": 45}, {"step_in": 50, "cut_off": 40, "herd": 35, "tie_up": 30}],
}
const TECH_FACTOR := [1.0, 0.92, 1.05, 1.0, 1.0, 0.9, 1.08, 0.85, 1.0, 0.95]
const STEP_FLOOR := 20.0
const PLANS := [["speed", "technique", "defense"], ["speed", "conditioning"], ["power", "defense"], ["conditioning", "power"],
	["technique", "speed"], ["conditioning", "power"], ["fight_iq", "defense"], ["technique", "defense"], ["power"], ["conditioning", "speed"]]
const FRAMES := [[168, 170], [163, 168], [172, 171], [176, 178], [173, 176], [178, 182], [174, 177], [167, 172], [182, 185], [175, 175]]
const RECORDS := [[8, 2], [9, 1], [7, 3], [9, 4], [8, 1], [7, 2], [10, 3], [7, 1], [9, 2], [8, 3]]


static func _person(base: Dictionary, over: Dictionary) -> Dictionary:
	var p := base.duplicate(true)
	p.merge(over, true)
	return p


static func _people() -> Array:
	var tpl: Dictionary = Data.PROSPECTS[0]
	var lucy := Data.lucy()
	lucy["personality"] = (tpl["personality"] as Dictionary).duplicate()
	var ps: Array = [lucy]
	for p in Data.PROSPECTS:
		ps.append(p.duplicate(true))
	ps.append(_person(tpl, {"id": "nell", "name": "Nell Ward", "first": "Nell", "sex": "f", "age": 27, "wc": "Light middleweight", "div": "wlm", "weight": 70.8,
		"stance": "southpaw", "style": "Counter-puncher", "pot": 72, "note": "near the ceiling",
		"stats": {"power": 60.0, "speed": 61.0, "technique": 66.0, "defense": 65.0, "conditioning": 60.0, "fight_iq": 66.0, "chin": 60.0}}))
	ps.append(_person(tpl, {"id": "reece", "name": "Reece Doyle", "first": "Reece", "sex": "m", "age": 19, "wc": "Featherweight", "div": "mfw", "weight": 55.8,
		"stance": "orthodox", "style": "Out-boxer", "pot": 90, "note": "raw, fast learner",
		"stats": {"power": 52.0, "speed": 63.0, "technique": 56.0, "defense": 55.0, "conditioning": 57.0, "fight_iq": 54.0, "chin": 58.0}}))
	ps.append(_person(tpl, {"id": "bayo", "name": "Bayo Adams", "first": "Bayo", "sex": "m", "age": 29, "wc": "Middleweight", "div": "mmw", "weight": 75.9,
		"stance": "orthodox", "style": "Slugger", "pot": 70, "note": "hits hard, old for a debut",
		"stats": {"power": 70.0, "speed": 54.0, "technique": 57.0, "defense": 53.0, "conditioning": 58.0, "fight_iq": 57.0, "chin": 70.0}}))
	ps.append(_person(tpl, {"id": "kai", "name": "Kai Turner", "first": "Kai", "sex": "m", "age": 22, "wc": "Light welterweight", "div": "mlm", "weight": 65.8,
		"stance": "orthodox", "style": "Volume puncher", "pot": 80, "note": "busy, thin chin",
		"stats": {"power": 57.0, "speed": 62.0, "technique": 60.0, "defense": 58.0, "conditioning": 66.0, "fight_iq": 58.0, "chin": 55.0}}))
	for i in ps.size():
		var pe: Dictionary = (ps[i]["personality"] as Dictionary).duplicate()
		pe["confidence"] = CONF_TRAIT[i]
		pe["loyalty"] = LOYALTY[i]
		ps[i]["personality"] = pe
	return ps


static func _book(i: int, style: String) -> Array:
	var t: Array = TECH.get(style, TECH["Boxer-puncher"])
	var k := float(TECH_FACTOR[i])
	var mv := {}
	for m in t[0]:
		mv[m] = snappedf(float(t[0][m]) * k, 0.1)
	var co := {}
	for c in t[1]:
		co[c] = snappedf(float(t[1][c]) * k, 0.1)
	var stp := {}
	for s in ["step_in", "step_out", "step_back", "pivot_out", "cut_off", "herd", "feint", "tie_up", "roll_out", "push_off"]:
		stp[s] = snappedf(float(t[2].get(s, STEP_FLOOR)) * (k if t[2].has(s) else 1.0), 0.1)
	return [mv, co, stp]


## The ten types at week wk of their plan (TURNPROBE18 measured the debut week, 4). Returns [{name, sex, style, f, night0}], coach.
static func build_types(wk: int) -> Array:
	var ps := _people()
	var out: Array = []
	var coach := 0.0
	for i in ps.size():
		var c := Career.quick_start()
		c.seed = 9100 + i * 37; c.first_hour = {}; FirstWeek.skip(c)
		c.applicant = (ps[i] as Dictionary).duplicate(true)
		Sim.sign(c, ["Jab and move", "Pad rounds", "Hill sprints"]); Sim.hire(c, "reid")
		coach = float(c.coach.get("rating", 0.0))
		var f: Dictionary = c.fighter().duplicate(true)
		f["w"] = RECORDS[i][0]; f["l"] = RECORDS[i][1]
		f["height"] = FRAMES[i][0]; f["reach"] = FRAMES[i][1]
		f["personality"] = (ps[i]["personality"] as Dictionary).duplicate()
		f.erase("loyalty")
		var bk := _book(i, str(f.get("style", "")))
		f["moves"] = bk[0]; f["combos"] = bk[1]; f["steps"] = bk[2]
		f["arrows"] = []
		var night0 := DebutOpp.night(f["stats"])
		var st: Dictionary = (f["stats"] as Dictionary).duplicate()
		var plan: Array = PLANS[i]
		for w in wk:
			var gain := TrainingPreview.plan_gain(st, int(f.get("pot", 75)), str(plan[w % plan.size()]), coach)
			for k in gain:
				st[k] = float(st[k]) + float(gain[k])
		f["stats"] = st
		out.append({"name": str(f["name"]), "sex": str(f.get("sex", "f")), "style": str(f.get("style", "")), "f": f, "night0": night0})
	return [out, coach]
