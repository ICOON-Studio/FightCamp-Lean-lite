extends RefCounted
## S382 G4 (gym idea 1, without Peak): the fight-night gauge row's rules - three dials, one word each, all read from one
## CampForecast.run (the camp modal's left column and the whiteboard's THIS CAMP column draw it with GaugeRow.gd):
## - LEGS = her fatigue on fight night: green under BoutRules.FRESH_FATIGUE "fresh", amber to WeekPlan.OVERREACHED
##   "heavy legs -N" (N = the energy BoutRules.stale_energy takes at the first bell), red from it "overreached".
## - SCALE = the class window (the next class down to the limit, at most WINDOW_KG of it) as a band, the needle the
##   weigh-in forecast, a ghost tick for today: green at or under limit + BoutRules.WEIGH_TOLERANCE, amber to limit + SCALE_NEAR, red beyond.
## - RISK = three pips, cut / hand / head: 1 lit under RISK_TWO camp injury chance, 2 to RISK_THREE, 3 from it (the camp
##   modal's old red line); while she is injured the pip of her injury goes solid red with the days left.
##   legs(fatigue, stale) -> {band, word}   scale(kg, limit) -> {band, word}   pips(chance) -> 1..3   slot(type) -> cut|hand|head
##   class_floor(limit, limits) -> kg   read(fc, f, day, limits) -> the row's numbers
## Pure static.

const GREEN := "green"
const AMBER := "amber"
const RED := "red"
## BoutRules.FRESH_FATIGUE: over it the camp's fatigue costs energy at the first bell.
const LEGS_HEAVY := 50.0
## WeekPlan.OVERREACHED.
const LEGS_OVER := 80.0
## BoutRules.WEIGH_TOLERANCE: the scale's own tolerance.
const SCALE_OK := 0.05
## Up to half a kilo over on the forecast is a sauna and a skipped breakfast away: amber, not red.
const SCALE_NEAR := 0.5
const RISK_TWO := 0.04
const RISK_THREE := 0.08
const SLOTS := ["cut", "hand", "head"]
## InjuryRoll's injury types on the three pips: the face, the body and hands, the head.
const SLOT_OF := {"cut": "cut", "nose": "cut", "hand": "hand", "ribs": "hand", "strain": "hand", "head": "head", "ko": "head"}
## The most of the class window the dial draws (a class 10 kg down would squeeze the needle), and the window when no class
## sits under hers.
const WINDOW_KG := 3.0


static func legs(fatigue: float, stale: float) -> Dictionary:
	if fatigue >= LEGS_OVER:
		return {"band": RED, "word": "overreached"}
	if fatigue >= LEGS_HEAVY:
		return {"band": AMBER, "word": "heavy legs -%d" % int(round(stale))}
	return {"band": GREEN, "word": "fresh"}


static func scale(kg: float, limit: float) -> Dictionary:
	var band := GREEN if kg <= limit + SCALE_OK else (AMBER if kg <= limit + SCALE_NEAR else RED)
	return {"band": band, "word": "%.1f kg" % kg}


static func pips(chance: float) -> int:
	return 3 if chance >= RISK_THREE else (2 if chance >= RISK_TWO else 1)


static func slot(type: String) -> String:
	return str(SLOT_OF.get(type, "hand"))


## The next class down's limit (the window's floor), never more than WINDOW_KG under hers.
static func class_floor(limit: float, limits: Array) -> float:
	var lo := limit - WINDOW_KG
	for x in limits:
		if float(x) < limit - 0.001:
			lo = maxf(lo, float(x))
	return lo


## The row's numbers: fc = CampForecast.run, f = the fighter (today's weight, her injury), day = today, limits = the class
## limits of her sex (Data.DIVISIONS).
static func read(fc: Dictionary, f: Dictionary, day: int, limits: Array) -> Dictionary:
	var lim := float(fc["limit"])
	var inj: Dictionary = f.get("injury", {})
	var left := 0
	if inj != null and not inj.is_empty():
		left = maxi(0, int(inj.get("until_day", day)) - day)
	var fat := float(fc["fatigue_end"])
	var st := float(fc.get("stale", 0.0))
	var kg := float(fc["kg"])
	var ch := float(fc["injury"])
	return {"legs": fat, "legs_now": float(fc.get("fatigue_now", fat)), "peak": float(fc.get("peak", fat)), "stale": st,
		"legs_band": legs(fat, st), "kg": kg, "kg_now": float(f.get("weight", kg)), "limit": lim,
		"floor": class_floor(lim, limits), "scale_band": scale(kg, lim), "injury": ch, "pips": pips(ch),
		"out": slot(str(inj.get("type", ""))) if left > 0 else "", "out_days": left}
