extends RefCounted
## COACHDEEP9 (S545, ops/research/TASK_COACHDEEP9.md): v8's GREYBOX rules (tools/coachdeep8_rules.gd, v7 + v6 before it) + v9's
## three changes (map ops/research/DESIGN_COACHDEEP9.md): wage_rule, the careful push line, WARN_DRAIN. Every number is the map's
## (ESTIMATE, reason in the map) unless the line names the game rule it reads. Pure static.
const OwnCombos := preload("res://scripts/rules/OwnCombos.gd")
const PadWeek := preload("res://scripts/rules/PadWeek.gd")
const MoveMastery := preload("res://scripts/rules/MoveMastery.gd")
const Loyalty := preload("res://scripts/rules/Loyalty.gd")
const BoutRules := preload("res://scripts/rules/BoutRules.gd")
const Leaving := preload("res://scripts/state/Leaving.gd")
const Matchmaking := preload("res://scripts/rules/Matchmaking.gd")
const ClubDeal := preload("res://scripts/rules/ClubDeal.gd")
const GymBills := preload("res://scripts/rules/GymBills.gd")
const StaffRoles := preload("res://scripts/rules/StaffRoles.gd")
const Exchanges := preload("res://scripts/rules/Exchanges.gd")
const BoutRead := preload("res://scripts/rules/BoutRead.gd")
const ComboOdds := preload("res://scripts/rules/ComboOdds.gd")
const CardOdds := preload("res://scripts/rules/CardOdds.gd")
const RingDuel := preload("res://scripts/state/RingDuel.gd")
const WorldBout := preload("res://scripts/world/WorldBout.gd")
const COACHES := {
	"YOU": {"name": "You", "pads": 8, "conditioning": 8, "tactics": 8, "cutman": 8, "weight": 8, "film": 8, "motivation": 8, "teaching": 8, "arts": ["boxing"], "playbook": "", "spec": ["Jab", "Cross"], "temper": 10, "patience": 10, "discipline": 10, "ambition": 10, "loyalty": 20, "evenings": 2, "wage": 0},
	"REID": {"name": "Luke Reid", "pads": 15, "conditioning": 10, "tactics": 11, "cutman": 9, "weight": 10, "film": 9, "motivation": 11, "teaching": 11, "arts": ["boxing"], "playbook": "Out-boxer", "spec": ["Jab", "Cross"], "temper": 7, "patience": 14, "discipline": 11, "ambition": 9, "loyalty": 14, "evenings": 5, "wage": 450},
	"L": {"name": "Local pressure man", "pads": 11, "conditioning": 13, "tactics": 8, "cutman": 11, "weight": 12, "film": 6, "motivation": 14, "teaching": 14, "arts": ["boxing"], "playbook": "Pressure fighter", "spec": ["Hook"], "temper": 15, "patience": 6, "discipline": 12, "ambition": 8, "loyalty": 15, "evenings": 5, "wage": 200},
	"M": {"name": "Local mat coach", "pads": 8, "conditioning": 12, "tactics": 9, "cutman": 7, "weight": 11, "film": 10, "motivation": 13, "teaching": 15, "arts": ["boxing", "bjj"], "playbook": "Counter-puncher", "spec": ["Jab"], "temper": 8, "patience": 15, "discipline": 12, "ambition": 6, "loyalty": 16, "evenings": 5, "wage": 450},   # v8 change 2: two arts = the solid band (was $250)
	"S": {"name": "Solid engine room", "pads": 11, "conditioning": 18, "tactics": 13, "cutman": 12, "weight": 16, "film": 10, "motivation": 9, "teaching": 7, "arts": ["boxing"], "playbook": "Pressure fighter", "spec": ["Hook", "Body"], "temper": 15, "patience": 6, "discipline": 17, "ambition": 12, "loyalty": 10, "evenings": 5, "wage": 550},
	"F": {"name": "Solid film room", "pads": 12, "conditioning": 8, "tactics": 17, "cutman": 13, "weight": 8, "film": 18, "motivation": 8, "teaching": 9, "arts": ["boxing"], "playbook": "Counter-puncher", "spec": ["Jab"], "temper": 4, "patience": 16, "discipline": 8, "ambition": 11, "loyalty": 12, "evenings": 5, "wage": 480},
	"K": {"name": "Known name", "pads": 17, "conditioning": 14, "tactics": 16, "cutman": 15, "weight": 13, "film": 14, "motivation": 15, "teaching": 6, "arts": ["boxing"], "playbook": "Boxer-puncher", "spec": ["Jab", "Cross"], "temper": 17, "patience": 6, "discipline": 15, "ambition": 18, "loyalty": 6, "evenings": 5, "wage": 1000},
	"MAT": {"name": "Sessional mat coach", "pads": 6, "conditioning": 10, "tactics": 8, "cutman": 5, "weight": 9, "film": 6, "motivation": 10, "teaching": 10, "arts": ["bjj"], "playbook": "", "spec": [], "temper": 9, "patience": 13, "discipline": 11, "ambition": 6, "loyalty": 15, "evenings": 2, "wage": 150},
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
## v9 change 1 (map s2; grill Q17): ONE WAGE RULE, all five cards: P = the ratings by WAGE_W / 14; wage = $150 + $125 x (P - 9)
## + $150 an art past the first (a sessional mat coach's price) + $350 for a known name; rounded to $10.
const WAGE_W := {"teaching": 4.0, "pads": 3.0, "tactics": 2.0, "conditioning": 2.0, "motivation": 1.0, "film": 1.0, "cutman": 0.5, "weight": 0.5}
static func wage_rule(c: Dictionary, known: bool) -> float:
	var p := 0.0
	for k in WAGE_W: p += float(WAGE_W[k]) * float(c[k]) / 14.0
	return snappedf(150.0 + 125.0 * (p - 9.0) + 150.0 * float((c["arts"] as Array).size() - 1) + (350.0 if known else 0.0), 10.0)
static func coach(id: String) -> Dictionary:
	var c: Dictionary = (COACHES[id] as Dictionary).duplicate(true)
	if CANDIDATES.has(id): c["wage"] = wage_rule(c, id == "K")   # v9: the five cards by the rule; Reid and the sessional mat coach as v8
	c["wage0"] = c["wage"]
	return c
static func r100(c: Dictionary, area: String) -> float:
	return float(c.get(area, 1)) * 5.0 * float(c.get("wf", 1.0))   # v8: a warned coach's ratings count WARN_RATING less
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
	if ct > 60.0 and temper > 60.0: x -= 0.4
	if ct > 60.0 and heart < 45.0: x -= 0.3
	if ct > 60.0 and heart >= 65.0 and temper <= 60.0: x += 0.2
	if cd > 70.0 and disc < 45.0: x += 0.1 if coachable > 70.0 else -0.25
	if cd > 70.0 and disc >= 70.0: x += 0.2
	if cp > 65.0 and conf < 45.0: x += 0.3
	if cp < 40.0 and conf < 45.0: x -= 0.25
	if cp > 65.0 and temper > 60.0: x += 0.15
	if x > 0.0: x *= lerpf(0.6, 1.3, coachable / 100.0)
	return clampf(x, -1.0, 1.0)
## CoachAreas.lift (CoachAreas.gd:63-64) + 1: a coached session's gain against training alone.
static func lift(r: float) -> float:
	return (0.5 + r * 0.7 / 100.0) / 0.6
static func learn_mult(c: Dictionary, style: String, chem: float, morale: float, young: bool, size: float) -> float:
	var m := (1.0 + FIT_LEARN * fit(c, style)) * (1.0 + CHEM_LEARN * size * chem)
	if young: m *= 1.0 + (float(c["teaching"]) * float(c.get("wf", 1.0)) - 10.0) * 0.02   # Q8 teaching beginners: boxers under 21
	return m * trust(morale)
## FighterProfile.TRUST by mood (FighterProfile.gd:39).
static func trust(morale: float) -> float:
	return 1.05 if morale >= 75.0 else (1.0 if morale >= 50.0 else (0.85 if morale >= 30.0 else 0.7))
static func morale_week(morale: float, shares: Dictionary, chems: Dictionary, coaches: Dictionary, size: float) -> float:
	var d := (60.0 - morale) * 0.08
	for id in shares:
		var s := float(shares[id])
		d += s * (CHEM_MORALE * size * float(chems.get(id, 0.0)) + (float(coaches[id]["motivation"]) * float(coaches[id].get("wf", 1.0)) - 10.0) * 0.25)
	return clampf(morale + d, 0.0, 100.0)
static func miss_chance(c: Dictionary, discipline: float) -> float:
	var base := 0.14 - 0.006 * float(c["weight"])
	return clampf(base * lerpf(1.4, 0.6, discipline / 100.0), 0.01, 0.30)
## Tells his film opens (OppFile.tape sessions): 0 under 8, 1 at 8-13, 2 at 14+; one fewer with no film evening.
static func tapes(c: Dictionary, film_evening: bool) -> int:
	var f := int(c["film"])
	var n := 0 if f < 8 else (1 if f < 14 else 2)
	return n if film_evening else maxi(0, n - 1)
static func bjj_chance(own: float, opp: float) -> float:
	return clampf(1.0 / (1.0 + exp(-(own - opp) / 5.0)), 0.03, 0.97)
## V4 CLASS NIGHTS FOLLOW THE MEMBERS (COACHDEEP3_RESULT s5 item 3): one full class night per CLASS_MEMBERS members, then one
static func class_full(members: float) -> int:
	return int(floor(members / CLASS_MEMBERS))
static func class_demand(members: float) -> int:
	return class_full(members) + 1
## The paying share of n class nights run this week at this many members (a full night = 1.0).
static func class_share(n: int, members: float) -> float:
	var full := class_full(members)
	return float(mini(n, full)) + (0.5 if n > full else 0.0)
## A boxer's next year in the game's money, reputation and record (lines: $1,000 / 3 reputation / 0.5 win less loss), at win
static func year_value(p: float, ticket: float, stipend: float, win_rep: float, loss_rep: float) -> Dictionary:
	var cash := 13.0 * ticket - 52.0 * stipend
	var rep := 13.0 * (p * win_rep - (1.0 - p) * loss_rep)
	var wl := 13.0 * (2.0 * p - 1.0)
	return {"cash": cash, "rep": rep, "wl": wl, "lines": cash / 1000.0 + rep / 3.0 + wl / 0.5}
## ---- probe statistics (not rules) ----
static func mean(rs: Array, k: String) -> float:
	var s := 0.0
	for r in rs: s += float(r[k])
	return s / maxf(1.0, rs.size())
static func who(rs: Array) -> Dictionary:
	var out := {}
	for r in rs:
		for n in str(r["who_left"]).split(" ", false): out[n] = int(out.get(n, 0)) + 1
	return out
static func paired(a: Array, b: Array, k: String) -> Array:
	var d: Array = []
	for i in a.size(): d.append(float(a[i][k]) - float(b[i][k]))
	return ms(d)
static func ms(d: Array) -> Array:
	var n := float(d.size())
	var m := 0.0
	for x in d: m += float(x)
	m /= maxf(1.0, n)
	var v := 0.0
	for x in d: v += (float(x) - m) * (float(x) - m)
	return [snappedf(m, 0.001), snappedf(sqrt(v / maxf(1.0, n - 1.0) / maxf(1.0, n)), 0.001)]
static func score(cash: float, rep: float, wl: float, morale: float) -> float:
	return cash / 1000.0 + rep / 3.0 + wl / 0.5 + morale / 5.0
## ---- v3 (DESIGN_COACHDEEP3.md) ----
## M1 BOUT PAY BY RANK (owner Q-S294-311 "Bouts pay by rank"): the club's cut of an amateur bout by her place on the regional
const PAY_BANDS := [[1, 1500], [3, 1200], [99, 1000]]   ## [rank at or better, $ to the club]
static func bout_pay(rank: int, unranked: int) -> int:
	if rank <= 0: return unranked
	for b in PAY_BANDS:
		if rank <= int(b[0]): return int(b[1])
	return unranked
## Her place on the regional table (RankLine order: ladder points, then net wins): 0 = unranked (under min_wins wins).
static func rank(rep: int, w: int, l: int, rows: Array, min_wins: int) -> int:
	if w < min_wins: return 0
	var n := 1
	for r in rows:
		if int(r["w"]) >= min_wins:
			var rr := int(r["rep"])
			if rr > rep or (rr == rep and int(r["w"]) - int(r["l"]) > w - l): n += 1
	return n
## M2 (v3's fixed CLASS_RETURN [1, 1, 1, 0.5]) is replaced in v4 by class_share(n, members) above.
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
static func area_r(c: Dictionary, k: String) -> float:
	match k:
		"technique":
			return r100(c, "pads")
		"defense":
			return (r100(c, "pads") + r100(c, "tactics")) * 0.5
	return r100(c, "conditioning")
## M3 THE COACHED EVENING: each boxer's own combination for her style (OwnCombos book row; the game's PLAYBOOK > Combos),
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
			if spec.has(s) or (s == "Body" and spec.has("Hook")): inn += 1.0
	return lerpf(OFF_SPEC, 1.0, inn / maxf(1.0, n))
## ---- moved from the probe (500-line rule) ----
static func sum(d: Dictionary) -> int:
	var s := 0
	for k in d: s += int(d[k])
	return s
static func knows(c: Dictionary, f: Dictionary) -> bool:
	return (c["arts"] as Array).has("bjj" if str(f.get("sport", "")) == "bjj" else "boxing")
## The game's weekly loyalty moves (Loyalty.MOVES): a short week, a short week running, a full week; a Loyal boxer's
static func loyal_week(f: Dictionary, short: bool, week: int) -> void:
	var n := float(Loyalty.MOVES["full_week"])
	if short:
		if float(f["loy"]) >= float(Loyalty.LOYAL_AT) and week - int(f["short_at"]) >= Loyalty.FREE_DAYS / 7: n = 0.0
		else: n = float(Loyalty.MOVES["short_running"] if bool(f["short_last"]) else Loyalty.MOVES["short"])
		f["short_at"] = week
	f["short_last"] = short
	f["loy"] = clampf(float(f["loy"]) + n, 0.0, 100.0)
## M3: each coached place = a pad night (PadWeek.PAD_NIGHT_MINUTES) at his pads, x his learn mult and specialty share; half on
static func drill(f: Dictionary, ev: Dictionary, coaches: Dictionary, mults: Dictionary, part: float) -> void:
	var chain: Array = f["book"][0]["chain"]
	var weak := ""
	for p in OwnCombos.punches(chain):
		var mv := str(OwnCombos.PUNCH_OF[str(p)])
		if weak == "" or float(f["moves"].get(mv, 0.0)) < float(f["moves"].get(weak, 0.0)): weak = mv
	var cap := MoveMastery.cap(float(f["stats"]["technique"]), float(f["stats"].get("fight_iq", 55.0)))
	for cid in ev:
		var c: Dictionary = coaches[cid]
		var mins := float(PadWeek.PAD_NIGHT_MINUTES) * float(ev[cid]) * part * float(mults[cid]) * spec_mult(c, chain)
		OwnCombos.drill_week(f, "own:1", mins * 0.5, r100(c, "pads"), PadWeek.STATION_TIER)
		f["moves"][weak] = MoveMastery.gain(float(f["moves"].get(weak, 0.0)), "pads", mins * 0.5, r100(c, "pads"), PadWeek.STATION_TIER, 1.0, cap)
	if ev.is_empty(): f["own_combos"]["own:1"] = MoveMastery.decay_week(OwnCombos.mastery(f, "own:1"), false)
## Her next year (the departure price): her last 3 win chances, her band's pay (M1; flat=1 the v2 $450), her stipend.
static func year_of(f: Dictionary, by_rank: bool, stip_v: float) -> Dictionary:
	var ps: Array = f["p"]
	var p := 0.5
	if not ps.is_empty():
		p = 0.0
		for x in ps: p += float(x) / ps.size()
	var pay := float(bout_pay(int(f["rank"]), BoutRules.TICKET_CUT)) if by_rank else float(BoutRules.TICKET_CUT)
	return year_value(p, pay, stip_v * float(f.get("weekly_salary", 0)), float(BoutRules.WIN_REPUTATION), float(BoutRules.LOSS_REPUTATION))
## ---- v5 (DESIGN_COACHDEEP5.md) ----
## V5 CATCHMENT CEILING (COACHDEEP4_RESULT s5 item 1): a boxing club draws from the streets around it. The town's natural members
const CATCH_CLASS := 12.0
static func catchment(natural_at_start: float, add: float) -> float:
	return natural_at_start + add + CATCH_CLASS
## The members target: the game's own (natural at today's reputation + add + the class pull), capped at the catchment.
static func members_target(natural_now: float, add: float, pull: float, catch: float) -> float:
	return minf(natural_now + add + pull, catch)
## She leaves (Leaving._go): reputation, team-mates under SETTLED_AT, the stipend stops (she is skipped from now on).
static func leave(f: Dictionary, fs: Array, acc: Dictionary, by_rank: bool, stip_v: float) -> Dictionary:
	f["left"] = true
	var lr := float(Leaving.REP_LEAVE_RANKED if int(f["rank"]) >= 1 and int(f["rank"]) <= Leaving.RANKED_TOP else Leaving.REP_LEAVE)
	acc["rep"] += lr
	for t in fs:
		if not bool(t["left"]) and float(t["loy"]) < float(Loyalty.SETTLED_AT): t["loy"] = maxf(0.0, float(t["loy"]) + float(Loyalty.MOVES["teammate_left"]))
	var y := year_of(f, by_rank, stip_v)
	return {"lines": float(y["lines"]) - lr / 3.0, "cash": float(y["cash"]) / 1000.0, "rep": float(y["rep"]) / 3.0, "wl": float(y["wl"]) / 0.5, "leave_rep": -lr / 3.0}
## ---- v7 (DESIGN_COACHDEEP7.md) ----
const WORD_AT := 0.15        ## s5: bond at +0.15, clash at -0.15
const NAME_FEE := 0.6        ## s2: the name fee, a share of the pro bout's purse
const NAME_CAP := 4000.0     ## s2 / loop 2: the fee's top a bout
const NAME_REP := 2.0        ## s2: club reputation a pro win with the known name in the corner
const LISTEN := 0.4          ## s7: the call x (1 + LISTEN x chem)
const CALL_BEST := 0.6       ## trial fix: share of best calls at tactics 20 (x tactics / 20); wrong calls 0.3 x (1 - tactics / 20)
const CALL_WRONG := 0.3
const SHOUT_SHARE := 0.333   ## trial fix: a call shapes a third of the next round's exchanges
const SULK := 2              ## trial fix: a refused raise: pads, tactics, teaching, motivation -2 for 26 weeks
const FALL_CHANCE := 0.30    ## s6: a clash pair, 4+ weeks together, falls out 30% a month
const FALL_WEEKS := 4
const RAISE := 0.25          ## s6: a raise / a matched rival offer = wage +25%
const RAISE_WINS := 3
const ASK_AMBITION := 12
const RIVAL_LOYAL := 8
const ASK_GAP := 52          ## trial fix: one ask a season (26 compounded the known name to ~$1,950)
const PUSH_FIT := 0.0
const PUSH_WEEKS := 8
const PUSH_SHAKY := -5.0     ## trial fix: a half-learned style = Exchanges.EDGE "ok" against her each round
const PUSH_BOUTS := 2
const COURSE_COST := 600.0
const COURSE_CASH := 6000.0
const COURSE_WEEKS := 3
const COURSE_EVENINGS := 2
const COURSE_GAIN := 2
const CEIL_ADD := 3          ## grill Q22: the ceiling = rating + 3 (probe)
const LEAVE_AT := 25.0       ## Loyalty.LEAVES_UNDER, coaches too
## v8 change 1 (map s6 v8): a standing warning costs while it stands - ESTIMATES to tune; fades after WARN_FADE weeks if no second
const WARN_LEARN := 0.10     ## a warned boxer learns 10% less
const WARN_UPTAKE := 0.15    ## and takes 15% less of the corner's calls
const WARN_MORALE := 0.5     ## and loses 0.5 morale a week (the drift back to 60 holds her ~6 lower)
const WARN_RATING := 0.10    ## a warned coach's ratings count 10% less
const WARN_FADE := 26
const WARN_DRAIN := 2.0      ## v9 change 3: loyalty lost a week while ONE warning stands (ESTIMATE inside 0.5-2; trial: 1 = a full week's +1)
const WARN_GRACE := 8        ## v9 cap: a warning alone never takes anyone under the line in fewer than 8 weeks
static func warn_tick(x: Dictionary, week: int, cost: bool) -> void:   # the fade, v9's drain, then the cost flags (wf coach, wc boxer)
	if int(x["warn"]) == 1 and week - int(x.get("warn_at", -999)) >= WARN_FADE: x["warn"] = 0
	if cost and int(x["warn"]) == 1:
		var n := float(x["loy"]) - WARN_DRAIN
		if week - int(x.get("warn_at", -999)) < WARN_GRACE: n = maxf(n, minf(float(x["loy"]), LEAVE_AT))
		x["loy"] = maxf(0.0, n)
	x["wf"] = 1.0 - WARN_RATING if cost and int(x["warn"]) >= 1 and x.has("pads") else 1.0
	x["wc"] = cost and int(x["warn"]) >= 1
const HIT := {"back_coach_boxer": -12.0, "back_coach_coach": 5.0, "back_boxer_coach": -15.0, "back_boxer_boxer": 5.0,
	"split": -3.0, "match": 10.0, "refuse": -20.0, "push_refuse": -12.0, "not_now": -3.0}
static func band_top(c: Dictionary) -> float:
	var w := float(COACHES.get(str(c.get("id", "")), c)["wage"]) if c.has("id") else float(c.get("wage0", c["wage"]))
	return 300.0 if w <= 300.0 else (600.0 if w <= 600.0 else 1100.0)
static func word(chem: float) -> String:
	return "bond" if chem >= WORD_AT else ("clash" if chem <= -WORD_AT else "fine")
## s2: the smallest member count at which the class nights his free evenings add (that the members want and nobody runs)
static func val_at(c: Dictionary, m: float, nights_run: int, cap_now: float) -> float:   # v8: his week's worth in members at m
	var nights := mini(int(c["evenings"]), maxi(0, class_demand(m) - nights_run))
	return float(nights) * float(ClubDeal.class_cash(1)) + minf(float(StaffRoles.COACH_MEMBERS), maxf(0.0, m - cap_now)) * float(GymBills.FEE_MONTH) / GymBills.WEEKS_A_MONTH
static func pays_at(c: Dictionary, wage: float, nights_run: int, cap_now: float) -> int:
	for m in range(0, 401):
		if val_at(c, float(m), nights_run, cap_now) >= wage: return m
	return -1
## Matchmaking's purse table (Matchmaking.gd:218) and the club's share.
static func purse(rank: int) -> float:
	return float(Matchmaking.PURSE_UNRANKED + Matchmaking.PURSE_PER_PLACE * maxi(0, 21 - rank)) if rank > 0 else float(Matchmaking.PURSE_UNRANKED)
static func name_fee(p: float) -> float:
	return minf(NAME_CAP, NAME_FEE * p)
## s7 (trial fix): a call between rounds priced by the game's Exchanges.EDGE (best +17, ok +5, wrong -10): his tactics set the
static func corner_edge(c: Dictionary, style: String, chem: float, up: float = 1.0) -> float:   # v8: up = a warned boxer's uptake
	var t := float(c["tactics"]) * float(c.get("wf", 1.0)) / 20.0
	var best := CALL_BEST * t
	var wrong := CALL_WRONG * (1.0 - t)
	var e := best * float(Exchanges.EDGE["best"]) + (1.0 - best - wrong) * float(Exchanges.EDGE["ok"]) + wrong * float(Exchanges.EDGE["wrong"])
	return e * SHOUT_SHARE * (1.0 + FIT_PLAN * fit(c, style)) * (1.0 + LISTEN * chem) * up
## The card's single value the blind player reads (the mean of the eight ratings).
static func card_value(c: Dictionary) -> float:
	var s := 0.0
	for k in ["pads", "conditioning", "tactics", "cutman", "weight", "film", "motivation", "teaching"]: s += float(c[k])
	return s / 8.0
## ---- the four moments (map s6) ----
static func _sulk(c: Dictionary, until: int) -> void:   # trial fix: an unhappy coach works worse (ratings -SULK) until then
	if int(c.get("sulk_to", -1)) <= 0:
		for r in ["pads", "tactics", "teaching", "motivation"]: c[r] = int(c[r]) - SULK
	c["sulk_to"] = maxi(until, int(c.get("sulk_to", -1)))
static func _hit(x: Dictionary, n: float, warn: bool, week: int) -> void:
	x["loy"] = clampf(float(x["loy"]) + n, 0.0, 100.0)
	x["warn"] = int(x["warn"]) + (1 if warn else 0)
	if warn:
		x["warn_at"] = week
		x["warned_n"] = int(x.get("warned_n", 0)) + 1   # v9 loop print: who carries the warnings
## v9: the pop-up's "lasts about N weeks": weeks to the leaving line if this person takes the warning (0 = already warned).
static func last(x: Dictionary, hit: float) -> float:
	var d := WARN_DRAIN - (0.0 if x.has("pads") else float(Loyalty.MOVES["full_week"]))   # a boxer's full week gives 1 back
	return 0.0 if int(x["warn"]) >= 1 else maxf(0.0, float(x["loy"]) + hit - LEAVE_AT) / d
static func forced(kind: String, fs: Array, co: Dictionary, hire: String) -> Dictionary:
	var cid := hire if co.has(hire) else "REID"
	if kind == "raise": return {"kind": "raise", "cid": cid, "rival": int(co[cid]["loyalty"]) <= RIVAL_LOYAL}
	var best := {}
	var low := 9.0
	for x in co:
		if x == "YOU" or (kind == "push" and x != cid): continue
		for i in fs.size():
			var f: Dictionary = fs[i]
			if bool(f["left"]) or not knows(co[x], f) or (kind == "push" and str(f.get("sport", "")) == "bjj"): continue
			var v := fit(co[x], str(f.get("style", ""))) if kind == "push" else chemistry(co[x], f.get("personality", {})) + float(f["bond"].get(x, 0.0)) - (5.0 if int(f["tog"].get(x, 0)) >= FALL_WEEKS else 0.0)
			if v < low:
				low = v
				best = {"kind": kind, "cid": x, "i": i}
	return best
static func due(fs: Array, co: Dictionary, week: int, r: RandomNumberGenerator, cash: float) -> Dictionary:
	var season := week / 52
	for x in co:
		for i in fs.size():
			var f: Dictionary = fs[i]
			var ch := chemistry(co[x], f.get("personality", {})) + float(f["bond"].get(x, 0.0))
			if x != "YOU" and not bool(f["left"]) and word(ch) == "clash" and int(f["tog"].get(x, 0)) >= FALL_WEEKS and not (f["barred"] as Array).has(x) and r.randf() < FALL_CHANCE:
				return {"kind": "fall", "cid": x, "i": i}
	for x in co:
		var c: Dictionary = co[x]
		if x != "YOU" and float(c["wage"]) < band_top(c) and int(c["streak"]) >= RAISE_WINS and week - int(c["ask_at"]) >= ASK_GAP and (int(c["loyalty"]) <= RIVAL_LOYAL or int(c["ambition"]) >= ASK_AMBITION):
			return {"kind": "raise", "cid": x, "rival": int(c["loyalty"]) <= RIVAL_LOYAL}
	for i in fs.size():
		var f: Dictionary = fs[i]
		var x := str(f["main"])
		if x != "" and x != "YOU" and co.has(x) and not bool(f["left"]) and str(f.get("sport", "")) != "bjj" and fit(co[x], str(f.get("style", ""))) <= PUSH_FIT and int(f["tog"].get(x, 0)) >= PUSH_WEEKS and int(f["push_s"]) != season:
			return {"kind": "push", "cid": x, "i": i}
	if cash > COURSE_CASH:
		for x in co:
			var c: Dictionary = co[x]
			if x != "YOU" and int(c["course_s"]) != season and (int(c["pads"]) < int(c["ceil"]["pads"]) or int(c["tactics"]) < int(c["ceil"]["tactics"])):
				return {"kind": "course", "cid": x}
	return {}
## The careless line (always back the coach, refuse every raise, allow every push, no course) and the careful one (map s12).
static func answer(line: String, m: Dictionary, fs: Array, co: Dictionary, members: float, pro: bool, res_ok: bool = false) -> String:
	var careless := line == "careless"
	var c: Dictionary = co[m["cid"]]
	match str(m["kind"]):
		"fall":
			if careless: return "back_coach"
			var f: Dictionary = fs[int(m["i"])]   # v9: back whoever would reach the line sooner; both outlast the fade -> split
			var wb := last(f, HIT["back_coach_boxer"])
			var wc := last(c, HIT["back_boxer_coach"])
			if minf(wb, wc) <= float(WARN_FADE): return "back_boxer" if wb <= wc else "back_coach"
			for x in co:
				if x != m["cid"] and knows(co[x], f): return "split"
			return "back_boxer"
		"raise":
			if careless: return "refuse"
			var n := pays_at(c, float(c["wage"]) * (1.0 + RAISE), 1, float(StaffRoles.VOLUNTEER_MEMBERS + StaffRoles.COACH_MEMBERS * 2))
			return "match" if (str(m["cid"]) == "K" and pro) or (n >= 0 and float(n) <= members) or res_ok else "refuse"   # v8: + the results line
		"push":
			var near := int(c["warn"]) >= 1 or float(c["loy"]) + HIT["push_refuse"] < LEAVE_AT + 10.0   # careful reads the warnings (map s12)
			var mine := 0
			var n := 0
			for f in fs: n += 0 if bool(f["left"]) else 1
			for f in fs: mine += 1 if not bool(f["left"]) and str(f["main"]) == str(m["cid"]) else 0
			return "allow" if careless or near or 2 * mine >= n else "refuse"   # v9 change 2: allow the coach of half the club or more
	return "not_now" if careless else "send"
## Applies the answer; returns the money spent (the course). A rival offer let go leaves in two weeks.
static func apply(m: Dictionary, ans: String, fs: Array, co: Dictionary, week: int) -> float:
	var c: Dictionary = co[m["cid"]]
	var spend := 0.0
	match str(m["kind"]):
		"fall":
			var f: Dictionary = fs[int(m["i"])]
			if ans == "back_coach":
				_hit(f, HIT["back_coach_boxer"], true, week)
				f["morale"] = maxf(0.0, float(f.get("morale", 60.0)) - 15.0)   # trial fix: the boxer not backed sulks
				_hit(c, HIT["back_coach_coach"], false, week)
			elif ans == "back_boxer":
				_hit(c, HIT["back_boxer_coach"], true, week)
				_sulk(c, week + 13)
				_hit(f, HIT["back_boxer_boxer"], false, week)
			else:
				_hit(f, HIT["split"], false, week)
				_hit(c, HIT["split"], false, week)
				(f["barred"] as Array).append(m["cid"])
		"raise":
			c["ask_at"] = week
			if ans == "match":
				c["wage"] = minf(float(c["wage"]) * (1.0 + RAISE), band_top(c))   # trial fix: never past his band's top (grill Q17)
				_hit(c, HIT["match"], false, week)
			elif bool(m["rival"]) or int(c["loyalty"]) <= RIVAL_LOYAL + 2 or int(c["warn"]) >= 1: c["leave_at"] = week + 2   # trial fix: "match it or let him go"
			else:
				_hit(c, HIT["refuse"], true, week)
				_sulk(c, week + 26)
		"push":
			var f: Dictionary = fs[int(m["i"])]
			f["push_s"] = week / 52
			if ans == "allow":
				f["style"] = str(c["playbook"])
				f["book"][0]["chain"] = (BOOK.get(str(c["playbook"]), ["jab", "cross"]) as Array).duplicate()
				f["own_combos"]["own:1"] = OwnCombos.mastery(f, "own:1") * 0.5
				f["shaky"] = PUSH_BOUTS
			else: _hit(c, HIT["push_refuse"], true, week)
		"course":
			c["course_s"] = week / 52
			if ans == "send":
				spend = COURSE_COST
				c["course_to"] = week + COURSE_WEEKS
			elif int(c["ambition"]) >= ASK_AMBITION: _hit(c, HIT["not_now"], false, week)
	if int(c["warn"]) >= 2 and float(c["loy"]) < LEAVE_AT: c["gone"] = true
	return spend
## A pro's next year (the departure / end value): 52 / interval bouts at her last chances, the club's purse share (+ the fee).
static func pro_year(f: Dictionary, k: bool) -> float:
	var ps: Array = f["p"]
	var p: float = 0.5 if ps.is_empty() else float(ps.reduce(func(s, x): return s + float(x), 0.0)) / ps.size()
	var n := 52.0 / (12.0 if bool(f.get("champ", false)) else 8.0)
	var pu := purse(int(f["prank"]))
	var cash := n * (pu * Matchmaking.GYM_SHARE + (name_fee(pu) if k else 0.0))
	var rep := n * (p * BoutRules.WIN_REPUTATION - (1.0 - p) * BoutRules.LOSS_REPUTATION)
	return cash / 1000.0 + rep / 3.0 + n * (2.0 * p - 1.0) / 0.5
## ---- moved from the probe in v8 (500-line rule), unchanged ----
static func shift(g: Dictionary, d: float) -> void:
	var st: Dictionary = g["stats"]
	for k in st:
		if typeof(st[k]) in [TYPE_FLOAT, TYPE_INT]: st[k] = clampf(float(st[k]) + d, 20.0, 95.0)
## The game's read (BoutRead.round_edges, its 3-round integration) + the corner's calls before rounds 2 and 3 (map s7, trial fix:
## BoutRead.chance ignores its coach argument) + a style push's shaky rounds. A clash ignores the first call.
static func chance(f: Dictionary, opp: Dictionary, calls: Array, shaky: float) -> float:
	f["arrows"] = []
	f["bout"] = {}
	var e: Array = (BoutRead.round_edges(f, opp, {}, 0.0) as Array).duplicate()
	for r in e.size(): e[r] = float(e[r]) + shaky + (float(calls[mini(r - 1, calls.size() - 1)]) if r > 0 else 0.0)
	if e.size() != 3: return CardOdds.win(e, RingDuel.FORM_SD)
	var out := 0.0
	for j in WorldBout.GH_X.size():
		var d := float(WorldBout.GH_X[j]) * RingDuel.FORM_SD * sqrt(2.0)
		var a := ComboOdds.round_odds(float(e[0]) + d)
		var b := ComboOdds.round_odds(float(e[1]) + d)
		var c := ComboOdds.round_odds(float(e[2]) + d)
		out += float(WorldBout.GH_W[j]) * (a * b + a * c + b * c - 2.0 * a * b * c)
	return clampf(out, 0.01, 0.99)
