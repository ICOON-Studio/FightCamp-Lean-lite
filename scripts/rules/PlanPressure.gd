extends RefCounted
## S397 rank 3, the plan bites, lever 2 (docs/STRUCTURE_DESIGN_S395.md 5.3 change 1; ops/research/BLOOD_CANVAS_STUDY_S392.md
## "What we take": pressure as a score that cuts output, a stamina ceiling that shrinks with clean hits). PlanRead's reads
## reset at every corner minute, so a plan's right or wrong answers never cost anything past the round. These two last
## the whole bout:
## - PRESSURE (on the opponent, 0..1): a planned right answer (PlanFight fit "best") that wins the exchange pushes it up by
##   GAIN of what is left; every other exchange it eases by EX_KEEP, and the corner minute gives her back part (ROUND_KEEP).
##   Pressure cuts her output: CUT x pressure of her landed punches, worth EDGE x pressure power points to our fighter.
##   Blood & Canvas: the AI's attack roll is aggression - pressure, so pressure directly cuts output.
## - CEILING (our fighter's tank, Combos.TANK at the first bell): a planned wrong answer the opponent punishes (fit "wrong",
##   exchange lost) means walking onto clean shots; each one she lands costs CLEAN_HIT of the tank for the rest of the fight
##   (gone now and never refilled by the rest), down to FLOOR. Blood & Canvas: a clean hit lowers the stamina ceiling by
##   0.7% of base, floor 70%; one of our 30-second exchanges lost to a punished answer is several clean hits.
## No plan = no planned answers, so both stay off and a fighter with no plan fights exactly as before.
##   PlanPressure.new_round(fb, n)   PlanPressure.edge(fb) -> float   PlanPressure.after(fb, lv, s, fit, planned) -> Dictionary
##   PlanPressure.ceiling(fb) -> float   PlanPressure.tally(rounds) -> Dictionary

const GAIN := 0.3
const EX_KEEP := 0.85
const ROUND_KEEP := 0.6
const EDGE := 3.0
const CUT := 0.4
const TANK := 100.0
const CLEAN_HIT := 1.5
const FLOOR := 70.0


## The corner minute: she gets part of her output back. n = the round opening (1 starts the bout clean).
static func new_round(fb: Dictionary, n: int) -> void:
	if n == 1 or not fb.has("pressure"):
		fb["pressure"] = 0.0
		fb["ceiling"] = TANK
	else:
		fb["pressure"] = float(fb["pressure"]) * ROUND_KEEP


## Power points the pressure is worth to our fighter this exchange.
static func edge(fb: Dictionary) -> float:
	return EDGE * float(fb.get("pressure", 0.0))


static func ceiling(fb: Dictionary) -> float:
	return float(fb.get("ceiling", TANK))


## After an exchange settled (s = Exchanges.settle, its landed already counted): cuts the opponent's landed punches by her
## pressure, then moves the pressure and the ceiling. A ceiling lost is spent energy now (lv["cost"]). Returns what it did
## for the exchange record: {pressure (before), cut (her punches it took away), clean (shots walked onto), tank (lost)}.
static func after(fb: Dictionary, lv: Dictionary, s: Dictionary, fit: String, planned: bool) -> Dictionary:
	var p := float(fb.get("pressure", 0.0))
	var theirs := int(s["landed"][1])
	var kept := int(round(float(theirs) * (1.0 - CUT * p)))
	s["landed"][1] = kept
	var won := bool(s["won"])
	fb["pressure"] = p + GAIN * (1.0 - p) if planned and fit == "best" and won else p * EX_KEEP
	var clean := kept if planned and fit == "wrong" and not won else 0
	var was := ceiling(fb)
	fb["ceiling"] = maxf(FLOOR, was - CLEAN_HIT * float(clean))
	var tank := was - float(fb["ceiling"])
	lv["cost"] = float(lv.get("cost", 0.0)) + tank
	return {"pressure": snappedf(p, 0.01), "cut": theirs - kept, "clean": clean, "tank": snappedf(tank, 0.1)}


## The bout's totals for the Why screen: {cut (her punches the pressure took away), tank (our tank lost to clean shots),
## peak (highest pressure)}.
static func tally(rounds: Array) -> Dictionary:
	var t := {"cut": 0, "tank": 0.0, "peak": 0.0}
	for r in rounds:
		for x in r.get("exchanges", []):
			var pp: Dictionary = x.get("pressure", {})
			t["cut"] = int(t["cut"]) + int(pp.get("cut", 0))
			t["tank"] = float(t["tank"]) + float(pp.get("tank", 0.0))
			t["peak"] = maxf(float(t["peak"]), float(pp.get("pressure", 0.0)))
	return t
