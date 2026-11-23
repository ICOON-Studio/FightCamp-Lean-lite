extends RefCounted
## COACHDEEP3 (S540, ops/research/TASK_COACHDEEP3.md): the GREYBOX rules of deep coaches v3 = v2 (tools/coachdeep2_rules.gd)
## + the v3 section at the end (bout pay by rank, class nights with falling returns, the coached evening's combination, area
## weights by style). Map: ops/research/DESIGN_COACHDEEP3.md. Copied here for the probe only.
## The owner's 24 answers (ops/research/COACHDEEP_GRILL_S539.md) set the shape; every number is a PROBE value (ESTIMATE)
## unless the line names the game rule it reads. Nothing under scripts/ uses this file. Pure static.

## Eight ratings 1-20 (Q8), personality five traits 1-20 (Q11), a playbook = one of the six styles (Q10), 2-3 specialties
## (Q9: the moves he teaches at full pads), evenings a week (Q13: 5; YOU 2, Q19), a weekly wage by band (Q17).
const OwnCombos := preload("res://scripts/rules/OwnCombos.gd")
const PadWeek := preload("res://scripts/rules/PadWeek.gd")
const MoveMastery := preload("res://scripts/rules/MoveMastery.gd")
const Loyalty := preload("res://scripts/rules/Loyalty.gd")
const BoutRules := preload("res://scripts/rules/BoutRules.gd")

const COACHES := {
	"YOU": {"name": "You", "pads": 8, "conditioning": 8, "tactics": 8, "cutman": 8, "weight": 8, "film": 8, "motivation": 8,
		"teaching": 8, "arts": ["boxing"], "playbook": "", "spec": ["Jab", "Cross"], "temper": 10, "patience": 10,
		"discipline": 10, "ambition": 10, "loyalty": 20, "evenings": 2, "wage": 0},
	"REID": {"name": "Luke Reid", "pads": 15, "conditioning": 10, "tactics": 11, "cutman": 9, "weight": 10, "film": 9,
		"motivation": 11, "teaching": 11, "arts": ["boxing"], "playbook": "Out-boxer", "spec": ["Jab", "Cross"], "temper": 7,
		"patience": 14, "discipline": 11, "ambition": 9, "loyalty": 14, "evenings": 5, "wage": 450},
	"L": {"name": "Local pressure man", "pads": 11, "conditioning": 13, "tactics": 8, "cutman": 11, "weight": 12, "film": 6,
		"motivation": 14, "teaching": 14, "arts": ["boxing"], "playbook": "Pressure fighter", "spec": ["Hook"], "temper": 15,
		"patience": 6, "discipline": 12, "ambition": 8, "loyalty": 15, "evenings": 5, "wage": 200},
	"M": {"name": "Local mat coach", "pads": 8, "conditioning": 12, "tactics": 9, "cutman": 7, "weight": 11, "film": 10,
		"motivation": 13, "teaching": 15, "arts": ["boxing", "bjj"], "playbook": "Counter-puncher", "spec": ["Jab"], "temper": 8,
		"patience": 15, "discipline": 12, "ambition": 6, "loyalty": 16, "evenings": 5, "wage": 250},
	"S": {"name": "Solid engine room", "pads": 11, "conditioning": 18, "tactics": 13, "cutman": 12, "weight": 16, "film": 10,
		"motivation": 9, "teaching": 7, "arts": ["boxing"], "playbook": "Pressure fighter", "spec": ["Hook", "Body"], "temper": 15,
		"patience": 6, "discipline": 17, "ambition": 12, "loyalty": 10, "evenings": 5, "wage": 550},
	"F": {"name": "Solid film room", "pads": 12, "conditioning": 8, "tactics": 17, "cutman": 13, "weight": 8, "film": 18,
		"motivation": 8, "teaching": 9, "arts": ["boxing"], "playbook": "Counter-puncher", "spec": ["Jab"], "temper": 4,
		"patience": 16, "discipline": 8, "ambition": 11, "loyalty": 12, "evenings": 5, "wage": 480},
	"K": {"name": "Known name", "pads": 17, "conditioning": 14, "tactics": 16, "cutman": 15, "weight": 13, "film": 14,
		"motivation": 15, "teaching": 6, "arts": ["boxing"], "playbook": "Boxer-puncher", "spec": ["Jab", "Cross"], "temper": 17,
		"patience": 6, "discipline": 15, "ambition": 18, "loyalty": 6, "evenings": 5, "wage": 1000},
}
const CANDIDATES := ["L", "M", "S", "F", "K"]
const PLACES_AN_EVENING := 2      ## Q13 / ClubDeal.deal: a pad evening = 2 places
const ORDINARY := 3               ## ClubDeal.ASK ordinary: the places that make her week of pads
const CLASS_MEMBERS := 12.0       ## a class night needs this many members on the books (StaffRoles 1:10-12 note) - ESTIMATE
const CLASS_TARGET := 1.5         ## members' target + this a weekly class night at teaching 10 - ESTIMATE
const OFF_SPEC := 0.85            ## a move outside his specialties drills at this share (Q9) - ESTIMATE

## His playbook v her style (Q10): +1 his own style, the neighbours half, the opposite -1 - ESTIMATE.
const FIT := {
	"Out-boxer": {"Out-boxer": 1.0, "Boxer-puncher": 0.5, "Counter-puncher": 0.5, "Pressure fighter": -1.0, "Slugger": -1.0, "Volume puncher": 0.0},
	"Boxer-puncher": {"Out-boxer": 0.5, "Boxer-puncher": 1.0, "Counter-puncher": 0.5, "Pressure fighter": 0.0, "Slugger": 0.5, "Volume puncher": 0.0},
	"Counter-puncher": {"Out-boxer": 0.5, "Boxer-puncher": 0.5, "Counter-puncher": 1.0, "Pressure fighter": -0.5, "Slugger": -0.5, "Volume puncher": -0.5},
	"Pressure fighter": {"Out-boxer": -1.0, "Boxer-puncher": 0.0, "Counter-puncher": -0.5, "Pressure fighter": 1.0, "Slugger": 0.5, "Volume puncher": 0.5},
	"Slugger": {"Out-boxer": -1.0, "Boxer-puncher": 0.5, "Counter-puncher": -0.5, "Pressure fighter": 0.5, "Slugger": 1.0, "Volume puncher": 0.0},
	"Volume puncher": {"Out-boxer": 0.0, "Boxer-puncher": 0.0, "Counter-puncher": -0.5, "Pressure fighter": 0.5, "Slugger": 0.0, "Volume puncher": 1.0},
}
const FIT_LEARN := 0.15
const FIT_PLAN := 0.20
## Chemistry's three effects at size 1.0 (v1's numbers); the probe multiplies them by the swept size (bar g).
const CHEM_LEARN := 0.30
const CHEM_MORALE := 3.0
const CHEM_LOYAL := 1.0           ## loyalty a fully coached week, x chemistry (Q12 "moves loyalty") - ESTIMATE
const BOND_WEEK := 0.01
const BOND_CAP := 0.25
const BOND_FADE := 0.005


static func coach(id: String) -> Dictionary:
	return (COACHES[id] as Dictionary).duplicate(true)


static func r100(c: Dictionary, area: String) -> float:
	return float(c.get(area, 1)) * 5.0


static func fit(c: Dictionary, style: String) -> float:
	return float((FIT.get(str(c.get("playbook", "")), {}) as Dictionary).get(style, 0.0))


## Chemistry -1..1 (Q12): his traits (1-20, x5) v hers (FighterProfile.TRAITS 0-100); v1's rules, before the bond.
static func chemistry(c: Dictionary, p: Dictionary) -> float:
	var temper := float(p.get("temper", 50.0))
	var heart := float(p.get("heart", 50.0))
	var disc := float(p.get("discipline", 50.0))
	var conf := float(p.get("confidence", 50.0))
	var coachable := float(p.get("coachability", 50.0))
	var ct := float(c["temper"]) * 5.0
	var cd := float(c["discipline"]) * 5.0
	var cp := float(c["patience"]) * 5.0
	var x := 0.0
	if ct > 60.0 and temper > 60.0:
		x -= 0.4
	if ct > 60.0 and heart < 45.0:
		x -= 0.3
	if ct > 60.0 and heart >= 65.0 and temper <= 60.0:
		x += 0.2
	if cd > 70.0 and disc < 45.0:
		x += 0.1 if coachable > 70.0 else -0.25
	if cd > 70.0 and disc >= 70.0:
		x += 0.2
	if cp > 65.0 and conf < 45.0:
		x += 0.3
	if cp < 40.0 and conf < 45.0:
		x -= 0.25
	if cp > 65.0 and temper > 60.0:
		x += 0.15
	if x > 0.0:
		x *= lerpf(0.6, 1.3, coachable / 100.0)
	return clampf(x, -1.0, 1.0)


## CoachAreas.lift (CoachAreas.gd:63-64) + 1: a coached session's gain against training alone.
static func lift(r: float) -> float:
	return (0.5 + r * 0.7 / 100.0) / 0.6


static func learn_mult(c: Dictionary, style: String, chem: float, morale: float, young: bool, size: float) -> float:
	var m := (1.0 + FIT_LEARN * fit(c, style)) * (1.0 + CHEM_LEARN * size * chem)
	if young:
		m *= 1.0 + (float(c["teaching"]) - 10.0) * 0.02   # Q8 teaching beginners: boxers under 21
	return m * trust(morale)


## FighterProfile.TRUST by mood (FighterProfile.gd:39).
static func trust(morale: float) -> float:
	if morale >= 75.0:
		return 1.05
	if morale >= 50.0:
		return 1.0
	if morale >= 30.0:
		return 0.85
	return 0.7


static func morale_week(morale: float, shares: Dictionary, chems: Dictionary, coaches: Dictionary, size: float) -> float:
	var d := (60.0 - morale) * 0.08
	for id in shares:
		var s := float(shares[id])
		d += s * (CHEM_MORALE * size * float(chems.get(id, 0.0)) + (float(coaches[id]["motivation"]) - 10.0) * 0.25)
	return clampf(morale + d, 0.0, 100.0)


static func miss_chance(c: Dictionary, discipline: float) -> float:
	var base := 0.14 - 0.006 * float(c["weight"])
	return clampf(base * lerpf(1.4, 0.6, discipline / 100.0), 0.01, 0.30)


## Tells his film opens (OppFile.tape sessions): 0 under 8, 1 at 8-13, 2 at 14+; one fewer with no film evening.
static func tapes(c: Dictionary, film_evening: bool) -> int:
	var f := int(c["film"])
	var n := 0 if f < 8 else (1 if f < 14 else 2)
	return n if film_evening else maxi(0, n - 1)


static func plan_rating(c: Dictionary, style: String) -> float:
	return r100(c, "tactics") * (1.0 + FIT_PLAN * fit(c, style))


static func bjj_chance(own: float, opp: float) -> float:
	return clampf(1.0 / (1.0 + exp(-(own - opp) / 5.0)), 0.03, 0.97)


## Class nights the members fill this week.
static func class_demand(members: float) -> int:
	return int(floor(members / CLASS_MEMBERS))


## A boxer's next year in the game's money and reputation (lines: $1,000 / 3 reputation), at win chance p:
## 13 bouts x (BoutRules.TICKET_CUT, WIN_REPUTATION / LOSS_REPUTATION), 52 weeks of her stipend.
## Returns {cash, rep, lines}. The departure price = this + Leaving's reputation (the probe adds it).
static func year_value(p: float, ticket: float, stipend: float, win_rep: float, loss_rep: float) -> Dictionary:
	var cash := 13.0 * ticket - 52.0 * stipend
	var rep := 13.0 * (p * win_rep - (1.0 - p) * loss_rep)
	return {"cash": cash, "rep": rep, "lines": cash / 1000.0 + rep / 3.0}


## ---- probe statistics (not rules) ----

static func mean(rs: Array, k: String) -> float:
	var s := 0.0
	for r in rs:
		s += float(r[k])
	return s / maxf(1.0, rs.size())


static func who(rs: Array) -> Dictionary:
	var out := {}
	for r in rs:
		for n in str(r["who_left"]).split(" ", false):
			out[n] = int(out.get(n, 0)) + 1
	return out


## Mean price of a departure and its parts (lines), over every departure in the arm.
static func price(rs: Array) -> Dictionary:
	var n := 0.0
	var acc := {"lines": 0.0, "cash": 0.0, "rep": 0.0, "leave_rep": 0.0}
	for r in rs:
		for p in r["prices"]:
			n += 1.0
			for k in acc:
				acc[k] += float(p[k])
	for k in acc:
		acc[k] = snappedf(acc[k] / maxf(1.0, n), 0.01)
	acc["n"] = n
	return acc


static func per_mean(rs: Array, names: Array) -> Dictionary:
	var out := {}
	for i in names.size():
		var s := 0.0
		for r in rs:
			s += float(r["per"][i])
		out[str(names[i])] = s / maxf(1.0, rs.size())
	return out


static func paired(a: Array, b: Array, k: String) -> Array:
	var d: Array = []
	for i in a.size():
		d.append(float(a[i][k]) - float(b[i][k]))
	return ms(d)


static func paired_per(a: Array, b: Array, fi: int, k := "per") -> Array:
	var d: Array = []
	for i in a.size():
		d.append(float(a[i][k][fi]) - float(b[i][k][fi]))
	return ms(d)


static func ms(d: Array) -> Array:
	var n := float(d.size())
	var m := 0.0
	for x in d:
		m += float(x)
	m /= maxf(1.0, n)
	var v := 0.0
	for x in d:
		v += (float(x) - m) * (float(x) - m)
	return [snappedf(m, 0.001), snappedf(sqrt(v / maxf(1.0, n - 1.0) / maxf(1.0, n)), 0.001)]


static func score(cash: float, rep: float, wl: float, morale: float) -> float:
	return cash / 1000.0 + rep / 3.0 + wl / 0.5 + morale / 5.0


## ---- v3 (DESIGN_COACHDEEP3.md) ----

## M1 BOUT PAY BY RANK (owner Q-S294-311 "Bouts pay by rank"): the club's cut of an amateur bout by her place on the regional
## table at the bout. Unranked = today's BoutRules.TICKET_CUT ($450, ~24 tickets). Ranked: tickets her name sells, at the
## club-show price (map s1: GBP 12-20 a seat x 1.25, 200-500 a show; a known amateur sells 40-60) - ESTIMATE, sourced in the map.
const PAY_BANDS := [[1, 1200], [3, 950], [99, 700]]   ## [rank at or better, $ to the club]

static func bout_pay(rank: int, unranked: int) -> int:
	if rank <= 0:
		return unranked
	for b in PAY_BANDS:
		if rank <= int(b[0]):
			return int(b[1])
	return unranked


## Her place on the regional table (RankLine order: ladder points, then net wins): 0 = unranked (under min_wins wins).
static func rank(rep: int, w: int, l: int, rows: Array, min_wins: int) -> int:
	if w < min_wins:
		return 0
	var n := 1
	for r in rows:
		if int(r["w"]) >= min_wins:
			var rr := int(r["rep"])
			if rr > rep or (rr == rep and int(r["w"]) - int(r["l"]) > w - l):
				n += 1
	return n


## M2 CLASS NIGHTS WITH FALLING RETURNS: the nth class night of a week pays and pulls members at this share (a club timetable:
## three full nights, a fourth half full, a fifth and later bring nobody new) - ESTIMATE, map s2.
const CLASS_RETURN := [1.0, 1.0, 1.0, 0.5]

static func class_share(n: int) -> float:
	var s := 0.0
	for i in n:
		s += float(CLASS_RETURN[i]) if i < CLASS_RETURN.size() else 0.0
	return s


## M4 AREA WEIGHTS FOLLOW THE BOXER: the week's stat pace (sums to 1.0 as v2's 0.4/0.3/0.3) by her style - ESTIMATE, map s4.
const STYLE_PACE := {
	"Out-boxer": {"technique": 0.45, "defense": 0.35, "conditioning": 0.20},
	"Counter-puncher": {"technique": 0.35, "defense": 0.45, "conditioning": 0.20},
	"Boxer-puncher": {"technique": 0.40, "defense": 0.30, "conditioning": 0.30},
	"Pressure fighter": {"technique": 0.25, "defense": 0.25, "conditioning": 0.50},
	"Slugger": {"technique": 0.30, "defense": 0.20, "conditioning": 0.50},
	"Volume puncher": {"technique": 0.30, "defense": 0.20, "conditioning": 0.50},
}

static func pace(style: String) -> Dictionary:
	return STYLE_PACE.get(style, {"technique": 0.4, "defense": 0.3, "conditioning": 0.3})


## The coach rating (0-100) that coaches a stat: technique on the pads, defence half pads half tactics (slips are drilled on
## the pads and read in the corner), conditioning his conditioning.
static func area_r(c: Dictionary, k: String) -> float:
	match k:
		"technique":
			return r100(c, "pads")
		"defense":
			return (r100(c, "pads") + r100(c, "tactics")) * 0.5
	return r100(c, "conditioning")


## M3 THE COACHED EVENING: each boxer's own combination for her style (OwnCombos book row; the game's PLAYBOOK > Combos),
## drilled ONLY on a coached pad place (he holds the pads) - half the place on the chain, half on its weakest punch.
const BOOK := {
	"Out-boxer": ["jab", "jab", "cross"],
	"Counter-puncher": ["slip", "cross", "lead_hook"],
	"Boxer-puncher": ["jab", "cross", "lead_hook"],
	"Pressure fighter": ["jab", "lead_hook", "body_hook"],
	"Slugger": ["lead_hook", "rear_uppercut"],
	"Volume puncher": ["jab", "cross", "jab", "cross"],
}
const SPEC_OF := {"jab": "Jab", "cross": "Cross", "lead_hook": "Hook", "body_hook": "Body", "rear_uppercut": "Uppercut"}

## Share of the chain's punches inside his specialties (Q9); a body hook counts for a "Hook" man too.
static func spec_mult(c: Dictionary, chain: Array) -> float:
	var n := 0.0
	var inn := 0.0
	var spec: Array = c["spec"]
	for p in chain:
		if SPEC_OF.has(str(p)):
			n += 1.0
			var s := str(SPEC_OF[str(p)])
			if spec.has(s) or (s == "Body" and spec.has("Hook")):
				inn += 1.0
	return lerpf(OFF_SPEC, 1.0, inn / maxf(1.0, n))

## ---- moved from the probe (500-line rule) ----

static func sum(d: Dictionary) -> int:
	var s := 0
	for k in d:
		s += int(d[k])
	return s


static func knows(c: Dictionary, f: Dictionary) -> bool:
	return (c["arts"] as Array).has("bjj" if str(f.get("sport", "")) == "bjj" else "boxing")


## The game's weekly loyalty moves (Loyalty.MOVES): a short week, a short week running, a full week; a Loyal boxer's
## first short in FREE_DAYS is free (Loyalty.gd:124-125).
static func loyal_week(f: Dictionary, short: bool, week: int) -> void:
	var n := float(Loyalty.MOVES["full_week"])
	if short:
		if float(f["loy"]) >= float(Loyalty.LOYAL_AT) and week - int(f["short_at"]) >= Loyalty.FREE_DAYS / 7:
			n = 0.0
		else:
			n = float(Loyalty.MOVES["short_running"] if bool(f["short_last"]) else Loyalty.MOVES["short"])
		f["short_at"] = week
	f["short_last"] = short
	f["loy"] = clampf(float(f["loy"]) + n, 0.0, 100.0)


## M3: each coached place = a pad night (PadWeek.PAD_NIGHT_MINUTES) at his pads, x his learn mult and specialty share; half on
## her combination (OwnCombos.drill_week), half on its weakest punch. No coach = no pads: the combination fades (decay_week).
static func drill(f: Dictionary, ev: Dictionary, coaches: Dictionary, mults: Dictionary, part: float) -> void:
	var chain: Array = f["book"][0]["chain"]
	var weak := ""
	for p in OwnCombos.punches(chain):
		var mv := str(OwnCombos.PUNCH_OF[str(p)])
		if weak == "" or float(f["moves"].get(mv, 0.0)) < float(f["moves"].get(weak, 0.0)):
			weak = mv
	var cap := MoveMastery.cap(float(f["stats"]["technique"]), float(f["stats"].get("fight_iq", 55.0)))
	for cid in ev:
		var c: Dictionary = coaches[cid]
		var mins := float(PadWeek.PAD_NIGHT_MINUTES) * float(ev[cid]) * part * float(mults[cid]) * spec_mult(c, chain)
		OwnCombos.drill_week(f, "own:1", mins * 0.5, r100(c, "pads"), PadWeek.STATION_TIER)
		f["moves"][weak] = MoveMastery.gain(float(f["moves"].get(weak, 0.0)), "pads", mins * 0.5, r100(c, "pads"), PadWeek.STATION_TIER, 1.0, cap)
	if ev.is_empty():
		f["own_combos"]["own:1"] = MoveMastery.decay_week(OwnCombos.mastery(f, "own:1"), false)


## A class night handed back: 2 places to the boxers most short, from a coach running a class who can teach them.
static func give_back(pl: Dictionary, coaches: Dictionary, fs: Array, asks: Array) -> bool:
	var given := 0
	for cid in coaches:
		for i in fs.size():
			while given < PLACES_AN_EVENING and sum(pl["places"][i]) < int(asks[i]) and knows(coaches[cid], fs[i]):
				pl["places"][i][cid] = int(pl["places"][i].get(cid, 0)) + 1
				given += 1
		if given > 0:
			return true
	return false


## v2's drill (DIAGNOSTIC combo=0): Jab and Cross on the pads, alone too.
static func drill_v2(f: Dictionary, shares: Dictionary, coaches: Dictionary, mults: Dictionary, alone: float, morale: float) -> void:
	var stats: Dictionary = f["stats"]
	for mv in ["Jab", "Cross"]:
		var cap := MoveMastery.cap(float(stats["technique"]), float(stats.get("fight_iq", 55.0)))
		var mm := float(f["moves"].get(mv, 0.0))
		var dm := MoveMastery.gain(mm, "pads", 75.0 * maxf(0.0, alone), 0.0, 2.0, trust(morale), cap) - mm
		for cid in shares:
			var sp := 1.0 if (coaches[cid]["spec"] as Array).has(mv) else OFF_SPEC
			dm += (MoveMastery.gain(mm, "pads", 75.0 * float(shares[cid]), r100(coaches[cid], "pads"), 2.0, 1.0, cap) - mm) * float(mults[cid]) * sp
		f["moves"][mv] = minf(cap, mm + dm * 0.5)


## Her next year (the departure price): her last 3 win chances, her band's pay (M1; flat=1 the v2 $450), her stipend.
static func year_of(f: Dictionary, by_rank: bool, stip_v: float) -> Dictionary:
	var ps: Array = f["p"]
	var p := 0.5
	if not ps.is_empty():
		p = 0.0
		for x in ps:
			p += float(x) / ps.size()
	var pay := float(bout_pay(int(f["rank"]), BoutRules.TICKET_CUT)) if by_rank else float(BoutRules.TICKET_CUT)
	return year_value(p, pay, stip_v * float(f.get("weekly_salary", 0)), float(BoutRules.WIN_REPUTATION), float(BoutRules.LOSS_REPUTATION))
