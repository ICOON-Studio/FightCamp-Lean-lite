extends RefCounted
## COACHDEEP1 (S539, ops/research/TASK_COACHDEEP1.md): the GREYBOX rules of coaches as people, copied here for the probe only.
## Nothing under scripts/ uses this file. Every number below is a PROBE value (ESTIMATE) unless a line names the game rule it
## reads; the design map ops/research/DESIGN_COACHDEEP1.md says which game file each attribute would change once built.
## Pure static; zero preloads.

## Five coaches (the cells are the 10 pairs). Attributes 1-20 (Football Manager's scale); x5 = the game's 0-100 ratings.
## hours = coached evenings a week (sessional 3, as Data.COACHES reid "three evenings a week").
const COACHES := {
	"A": {"name": "Pad man", "pads": 15, "conditioning": 9, "tactics": 11, "film": 8, "weight": 10, "motivation": 12, "youth": 14,
		"arts": ["boxing"], "playbook": "outbox", "temper": 30.0, "discipline": 50.0, "patience": 75.0, "hours": 3.0},
	"B": {"name": "Engine room", "pads": 11, "conditioning": 18, "tactics": 13, "film": 10, "weight": 16, "motivation": 9, "youth": 7,
		"arts": ["boxing"], "playbook": "pressure", "temper": 75.0, "discipline": 85.0, "patience": 30.0, "hours": 3.0},
	"C": {"name": "Mat and gloves", "pads": 9, "conditioning": 12, "tactics": 10, "film": 14, "weight": 12, "motivation": 14, "youth": 10,
		"arts": ["boxing", "bjj"], "playbook": "counter", "temper": 45.0, "discipline": 60.0, "patience": 60.0, "hours": 3.0},
	"D": {"name": "Film room", "pads": 12, "conditioning": 8, "tactics": 17, "film": 18, "weight": 8, "motivation": 8, "youth": 9,
		"arts": ["boxing"], "playbook": "counter", "temper": 20.0, "discipline": 40.0, "patience": 80.0, "hours": 3.0},
	"E": {"name": "Fire starter", "pads": 13, "conditioning": 14, "tactics": 9, "film": 6, "weight": 11, "motivation": 18, "youth": 15,
		"arts": ["boxing"], "playbook": "pressure", "temper": 85.0, "discipline": 35.0, "patience": 40.0, "hours": 3.0},
}

## Evenings a boxer wants coached a week: her three pad nights (PadWeek's default nights Mon/Wed/Fri; sparring Thursday).
const WANT := 3.0
## A pad night's minutes (CoachRoles.PAD_BASE_MIN 75).
const PAD_MIN := 75.0

## How a coach's way of boxing sits with a boxer's style: +1 his way, -1 against it.
const FIT := {
	"outbox": {"Out-boxer": 1.0, "Boxer-puncher": 0.5, "Counter-puncher": 0.5, "Pressure fighter": -1.0, "Slugger": -1.0, "Volume puncher": 0.0},
	"pressure": {"Out-boxer": -1.0, "Boxer-puncher": 0.0, "Counter-puncher": -0.5, "Pressure fighter": 1.0, "Slugger": 1.0, "Volume puncher": 0.5},
	"counter": {"Out-boxer": 0.5, "Boxer-puncher": 0.5, "Counter-puncher": 1.0, "Pressure fighter": -0.5, "Slugger": -0.5, "Volume puncher": -0.5},
}
const FIT_LEARN := 0.15   ## learning x (1 + 0.15 x fit)
const FIT_PLAN := 0.20    ## his plan (CoachPlan rating) x (1 + 0.20 x fit)
const CHEM_LEARN := 0.30  ## learning x (1 + 0.30 x chemistry)
const CHEM_MORALE := 3.0  ## morale a fully coached week, x chemistry
const BOND_WEEK := 0.01   ## chemistry grows this a week together ...
const BOND_CAP := 0.25    ## ... up to this
const BOND_FADE := 0.005  ## and fades this a week apart
const LEAVE_LOW_WEEKS := 6   ## morale under 30 (FighterProfile.mood "Low") this many weeks in a row: the boxer leaves


static func coach(id: String) -> Dictionary:
	return (COACHES[id] as Dictionary).duplicate(true)


static func r100(c: Dictionary, area: String) -> float:
	return float(c.get(area, 1)) * 5.0


static func fit(c: Dictionary, style: String) -> float:
	return float((FIT.get(str(c.get("playbook", "")), {}) as Dictionary).get(style, 0.0))


## Chemistry -1..1 from the two personalities (FighterProfile.TRAITS for the boxer), before the bond.
static func chemistry(c: Dictionary, p: Dictionary) -> float:
	var temper := float(p.get("temper", 50.0))
	var heart := float(p.get("heart", 50.0))
	var disc := float(p.get("discipline", 50.0))
	var conf := float(p.get("confidence", 50.0))
	var coachable := float(p.get("coachability", 50.0))
	var ct := float(c["temper"])
	var cd := float(c["discipline"])
	var cp := float(c["patience"])
	var x := 0.0
	if ct > 60.0 and temper > 60.0:
		x -= 0.4   # two short fuses
	if ct > 60.0 and heart < 45.0:
		x -= 0.3   # shouting folds a soft heart
	if ct > 60.0 and heart >= 65.0 and temper <= 60.0:
		x += 0.2   # a hard heart likes a hard voice
	if cd > 70.0 and disc < 45.0:
		x += 0.1 if coachable > 70.0 else -0.25
	if cd > 70.0 and disc >= 70.0:
		x += 0.2   # both live by the clock
	if cp > 65.0 and conf < 45.0:
		x += 0.3   # patience builds a doubter
	if cp < 40.0 and conf < 45.0:
		x -= 0.25
	if cp > 65.0 and temper > 60.0:
		x += 0.15  # a calm voice cools a hothead
	if x > 0.0:
		x *= lerpf(0.6, 1.3, coachable / 100.0)
	return clampf(x, -1.0, 1.0)


## The stat a coached week lifts (CoachAreas.lift: 0.5 + r x 0.7 / 100 against training alone's 0.6).
static func lift(r: float) -> float:
	return (0.5 + r * 0.7 / 100.0) / 0.6


## Learning multiplier for one coach on one boxer (chem = chemistry + bond; chem_on false = the control arm).
static func learn_mult(c: Dictionary, style: String, chem: float, morale: float, young: bool, knows_art: bool) -> float:
	if not knows_art:
		return 0.0   # he cannot teach an art he does not know: the evening is training alone
	var m := (1.0 + FIT_LEARN * fit(c, style)) * (1.0 + CHEM_LEARN * chem)
	if young:
		m *= 1.0 + (float(c["youth"]) - 10.0) * 0.02
	return m * trust(morale)


## FighterProfile.TRUST by mood: how much of the coach's word she takes in.
static func trust(morale: float) -> float:
	if morale >= 75.0:
		return 1.05
	if morale >= 50.0:
		return 1.0
	if morale >= 30.0:
		return 0.85
	return 0.7


## Weekly morale move from coaching: chemistry and his motivation, by the share of her week he coached; drift to 60.
static func morale_week(morale: float, shares: Dictionary, chems: Dictionary, coaches: Dictionary) -> float:
	var d := (60.0 - morale) * 0.08
	for id in shares:
		var s := float(shares[id])
		d += s * (CHEM_MORALE * float(chems.get(id, 0.0)) + (float(coaches[id]["motivation"]) - 10.0) * 0.25)
	return clampf(morale + d, 0.0, 100.0)


## Chance she misses weight for a bout: the corner's weight attribute and her discipline (WeighMiss / Bouts.weigh downstream).
static func miss_chance(c: Dictionary, discipline: float) -> float:
	var base := 0.14 - 0.006 * float(c["weight"])
	return clampf(base * lerpf(1.4, 0.6, discipline / 100.0), 0.01, 0.30)


## Tells his film opens before a bout (OppFile.tape sessions): 0 under 8, 1 at 8-13, 2 at 14+.
static func tapes(c: Dictionary) -> int:
	var f := int(c["film"])
	return 0 if f < 8 else (1 if f < 14 else 2)


## The plan rating his corner writes with (CoachPlan.write reads 1 card at 50, 2 at 70).
static func plan_rating(c: Dictionary, style: String) -> float:
	return r100(c, "tactics") * (1.0 + FIT_PLAN * fit(c, style))


## The no-gi athlete's chance on a match (greybox: no BJJ read in BoutRead): logistic on the gap.
static func bjj_chance(own: float, opp: float) -> float:
	return clampf(1.0 / (1.0 + exp(-(own - opp) / 5.0)), 0.03, 0.97)
