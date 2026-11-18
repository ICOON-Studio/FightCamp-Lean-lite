extends RefCounted
## COACHROLES1 (S515): coach roles r6, the pure rules - class nights against pad minutes, the hire runway, the BJJ
## promotion ceiling and the held pad night. Owner's yes on the board (Q-S294-271: "Yes, build it").
## Map: ops/research/DESIGN_COACHSPEC1_R6_DOLA.md lines 1066-1208 (summary APPROVE_COACHSPEC1_R6_S514.md).
## Pure static module - ZERO preloads, no career, no UI. R14's Week Priority switch is NOT here: it changes
## CoachedMornings' deal, and Claude wires it with the Staff cards, the Week board and the no-gi page.
## why: every number is the map's own, at the lines named here -
##   class_week, class_pill: R13, map 1092-1105 (the four rows; 1 pad min = 3.2 drill units, the CODE conversion)
##   runway, hire_line: R5, map 1131-1150 (cash / weekly net burn, GymBills.runway_weeks' own read; warn under 8)
##   can_promote, academy_month: R8, map 1120-1130 (a coach signs below their own belt; Academy Month $450, 4 weeks)
##   held_night, held_allowed: R4 + R15, map 1151-1177 (2 mornings, max 1 a week, never in a fight week)

## R13: one class = 60 paid minutes = $175 (CLAUDE.md "Decided numbers": evening classes +$350/week with a coach = 2).
const CLASS_PAY := 175
const CLASS_MIN := 60
## R13: a pad night is 75 min at the default 2 class nights; no pad night goes under 45. Sparring Thursday is untouched.
const PAD_BASE_MIN := 75
const PAD_MIN_FLOOR := 45
## The CODE conversion (map 1095): pad minutes x 3.2 = drill units, so 75 min = 240 units.
const UNITS_PER_MIN := 3.2
const CLASS_DEFAULT := 2
const CLASS_MAX := 3
## R5's warning line is the game's own (GymBills.WARN_RUNWAY_WEEKS 8); the page kit (map 1195) adds red under 6.
## Both edges are exclusive, as GymBills.status reads them: 8 weeks still ok, 7 amber, 6 amber, 5 red.
const RUNWAY_WARN := 8
const RUNWAY_RED := 6
## GymBills.runway_weeks' sentinel for a week that earns its keep: the cash never runs out.
const RUNWAY_SAFE := 999
## R8: the belt road's order (BeltRoad.BELTS, kept here because this module preloads nothing).
const BELTS := ["white", "blue", "purple", "brown", "black"]
## R8's Academy Month: a flat fee, one month away at an affiliated academy whose professor signs the promotion.
const ACADEMY_FEE := 450
const ACADEMY_WEEKS := 4
## R4 + R15. minutes and mornings_cost are the map's decided costs; the load ratios, the risk multipliers and the half
## night's mastery share are ESTIMATE (map 1155-1160 and 1171-1176) - the balance probe confirms them, not this module.
const HELD := {
	"full": {"minutes": 75, "mornings_cost": 2, "load_mult": 1.38, "ratio": "1.3 -> 1.38",
		"risk_mult": 1.4, "mastery_share": 1.0},
	"half": {"minutes": 40, "mornings_cost": 1, "load_mult": 1.34, "ratio": "1.3 -> 1.34",
		"risk_mult": 1.2, "mastery_share": 0.53},
}
const HELD_MAX_A_WEEK := 1
const TAPER_WHY := "Taper week: athlete needs rest"
const HELD_WHY := "One held night a week: this week's is already held"


## R13's table, row for row: {nights: [Mon, Wed, Fri pad minutes], pad_min, pad_units, class_pay}.
## The minutes move BY NIGHT, not evenly: a dropped class puts half its paid minutes (30) back on one night, Monday
## first then Wednesday (75 -> 105); the third class takes its 60 off Friday alone and Friday stops at the 45 floor
## (75 -> 45, so -30). The map's own notes and pill quote the class's 60 paid minutes, the rows quote what lands on
## the pads: 0 -> 285 min, 1 -> 255, 2 -> 225, 3 -> 195.
static func class_week(class_nights: int) -> Dictionary:
	var n: int = clampi(class_nights, 0, CLASS_MAX)
	var nights: Array = [PAD_BASE_MIN, PAD_BASE_MIN, PAD_BASE_MIN]
	for i in range(CLASS_DEFAULT - n):
		nights[i] = int(nights[i]) + int(CLASS_MIN / 2.0)
	if n > CLASS_DEFAULT:
		nights[2] = maxi(PAD_MIN_FLOOR, PAD_BASE_MIN - CLASS_MIN * (n - CLASS_DEFAULT))
	var pad_min: int = 0
	for raw in nights:
		pad_min += int(raw)
	return {"nights": nights, "pad_min": pad_min, "pad_units": roundi(float(pad_min) * UNITS_PER_MIN),
		"class_pay": n * CLASS_PAY}


## R13's pill on the coach card, only when there is a class to drop ($175 / 60 min = $2.9 a minute).
static func class_pill(class_nights: int) -> String:
	if class_nights <= 0:
		return ""
	return "-1 class -> +%d pad min · -$%d/wk ($%.1f/min)" % [CLASS_MIN, CLASS_PAY, float(CLASS_PAY) / float(CLASS_MIN)]


## R5: weeks of money left at this week's net (all income - all costs). GymBills.runway_weeks' own read: a net that
## earns its keep is safe (999), cash already gone is 0, otherwise whole weeks floored - never rounded up.
static func runway(cash: float, weekly_net: float) -> int:
	if weekly_net >= 0.0:
		return RUNWAY_SAFE
	if cash <= 0.0:
		return 0
	return int(floor(cash / -weekly_net))


## R5: what a hire does to the runway, before any member growth. wage_change is the gross wage added, income_added the
## classes and stipend offset it brings (R7's second coach: $380 wage, $350 classes + $100 offset). The line WARNS, it
## never blocks a hire - the game lets a full-time coach be hired day 0 (map 1149).
static func hire_line(cash: float, weekly_net: float, wage_change: float, income_added: float) -> Dictionary:
	var before: int = runway(cash, weekly_net)
	var after: int = runway(cash, weekly_net - wage_change + income_added)
	var band: String = "ok"
	if after < RUNWAY_RED:
		band = "red"
	elif after < RUNWAY_WARN:
		band = "amber"
	return {"before": before, "after": after, "band": band, "text": "Runway: %d weeks -> %d weeks" % [before, after]}


## The belt's place on the road, -1 for a belt that is not one.
static func belt_rank(belt: String) -> int:
	return BELTS.find(belt.to_lower())


## R8: a coach signs a promotion below their own belt - brown up to purple, black 1st degree up to brown, black 2nd
## degree+ up to black. A white, blue or purple coach signs nobody above their own belt.
static func can_promote(coach_belt: String, coach_degree: int, to_belt: String) -> bool:
	var belt: String = coach_belt.to_lower()
	var coach: int = belt_rank(belt)
	var to: int = belt_rank(to_belt)
	if coach < 0 or to < 0:
		return false
	var ceiling: int = coach
	match belt:
		"brown":
			ceiling = coach - 1
		"black":
			ceiling = coach if coach_degree >= 2 else coach - 1
	return to <= ceiling


## R8's Academy Month: the athlete is away 4 weeks, no classes, no bouts, no training on the board; the academy's
## professor signs the promotion if time-in-grade is met (BeltRoad's own floor).
static func academy_month() -> Dictionary:
	return {"fee": ACADEMY_FEE, "weeks": ACADEMY_WEEKS,
		"label": "Academy Month - get promoted · $%d · away %d weeks" % [ACADEMY_FEE, ACADEMY_WEEKS]}


## R4's full held night and R15's half night: {minutes, mornings_cost, load_mult, ratio, risk_mult, mastery_share}.
## An unknown kind holds nothing ({}). The row is a copy: the caller's edits never reach the next week.
static func held_night(kind: String) -> Dictionary:
	var row: Dictionary = HELD.get(kind.to_lower(), {})
	return row.duplicate(true)


## R4: never in a fight week (the button greys with the taper line), and only one held night a week.
static func held_allowed(fight_week: bool, held_this_week: int) -> Dictionary:
	if fight_week:
		return {"ok": false, "why": TAPER_WHY}
	if held_this_week >= HELD_MAX_A_WEEK:
		return {"ok": false, "why": HELD_WHY}
	return {"ok": true, "why": ""}
