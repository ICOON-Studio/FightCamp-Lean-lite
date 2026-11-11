extends RefCounted
## DuesLevers: the sums that give each price a club where it wins.
## Pure module, static functions only. No RNG - expected values.
## The levers beyond dues that real cheap clubs live on: grants, volunteer coaches,
## home shows, and premium's real draw at low reputation.
## DUESSUMS2: grant payout is one number (median award); volunteer shares capped at 0.15;
## two new levers - steady (standard keeps adults longest) and classes (evening class income).

const Membership := preload("res://scripts/rules/Membership.gd")

const BANDS := ["cheap", "standard", "premium"]
const WEEKS_IN_YEAR := 52
const YEARS := 5
const TOTAL_WEEKS := 260
const INTAKES_PER_YEAR := 2
const COACH_WEEKLY := 450
const BOXER_VALUE := 6500
const SHOW_FLOOR := 1000
const SHOW_CEIL := 14336
const CLASS_WEEKLY := 350

## Candidate levers for the search.
const GRANT_CHANCES := [0.20, 0.33, 0.50]
const GRANT_PAYOUT := 12345
const VOLUNTEER_SHARES := [0.0, 0.05, 0.10, 0.15]
const SHOW_PER_BOXERS := [1000, 2000, 3000]
const LOW_REP_DRAWS := [0.85, 0.75, 0.65]
const STEADY_CANDIDATES := [1.0, 1.05, 1.10]
const CHEAP_SHARE_CANDIDATES := [1.0, 0.75, 0.5]

## A yearly grant: chance x payout for cheap; half the chance for standard; 0 for premium.
## youth_open gates whether the club has a youth section (needed for most grants).
static func grant_year(band: String, chance: float, youth_open: bool) -> float:
	if not youth_open:
		return 0.0
	if band == "cheap":
		return chance * float(GRANT_PAYOUT)
	if band == "standard":
		return 0.5 * chance * float(GRANT_PAYOUT)
	return 0.0


## Volunteer coaching saving: share x $450 x 52 for cheap; half the share for standard; 0 for premium.
static func volunteer_saving_year(band: String, share: float) -> float:
	if band == "cheap":
		return share * float(COACH_WEEKLY) * float(WEEKS_IN_YEAR)
	if band == "standard":
		return 0.5 * share * float(COACH_WEEKLY) * float(WEEKS_IN_YEAR)
	return 0.0


## Home show income: min(1000 + per_boxer x boxers, 14336).
static func show_year(home_grown_boxers: float, per_boxer: int) -> float:
	return minf(float(SHOW_FLOOR) + float(per_boxer) * home_grown_boxers, float(SHOW_CEIL))


## Premium's real draw: linear from low_rep_draw at reputation 0 to 1.0 at reputation 100.
static func premium_draw(reputation: int, low_rep_draw: float) -> float:
	var t: float = clampf(float(reputation) / 100.0, 0.0, 1.0)
	return low_rep_draw + (1.0 - low_rep_draw) * t


## Steady draw: standard keeps its adults longest, so its draw is multiplied by steady;
## cheap and premium by 1.0. Candidates 1.0 / 1.05 / 1.10.
static func steady_draw(band: String, steady: float) -> float:
	if band == "standard":
		return steady
	return 1.0


## Class income for a year: 350 x 52 for standard and premium; cheap_share x 350 x 52 for cheap
## (a club of juniors sells fewer adult classes).
static func class_year(band: String, cheap_share: float) -> float:
	if band == "cheap":
		return cheap_share * float(CLASS_WEEKLY) * float(WEEKS_IN_YEAR)
	if band == "standard" or band == "premium":
		return float(CLASS_WEEKLY) * float(WEEKS_IN_YEAR)
	return 0.0


## Five-year total for one band in one case (reputation, cap).
## levers keys: grant_chance, youth_open, volunteer_share, show_per_boxer, low_rep_draw, steady, cheap_share.
## Returns {dues, grant, volunteer, show, boxers, steady, classes, total}.
static func five_year_total(reputation: int, cap: int, band: String, levers: Dictionary) -> Dictionary:
	var grant_chance: float = float(levers.get("grant_chance", 0.0))
	var youth_open: bool = levers.get("youth_open", true)
	var vol_share: float = float(levers.get("volunteer_share", 0.0))
	var per_boxer: int = int(levers.get("show_per_boxer", 0))
	var low_rep_draw: float = float(levers.get("low_rep_draw", 0.85))
	var steady: float = float(levers.get("steady", 1.0))
	var cheap_share: float = float(levers.get("cheap_share", 1.0))

	## Determine draw_mult for settle_week.
	## For premium: replace the built-in draw with the lever's premium_draw.
	## For standard: multiply by steady.
	## For cheap: draw_mult = 1.0.
	var draw_mult: float = 1.0
	if band == "premium":
		var base_draw: float = Membership.draw("premium", reputation)
		var new_draw: float = premium_draw(reputation, low_rep_draw)
		if base_draw > 0.0:
			draw_mult = new_draw / base_draw
	elif band == "standard":
		draw_mult = steady_draw(band, steady)

	var members: int = 40
	var total_dues: float = 0.0
	var total_grant: float = 0.0
	var total_volunteer: float = 0.0
	var total_show: float = 0.0
	var total_classes: float = 0.0

	var intake: float = Membership.intake_chance(band)

	for week_idx in range(TOTAL_WEEKS):
		var result: Dictionary = Membership.settle_week(members, reputation, cap, band, draw_mult)
		members = int(result["members"])
		total_dues += float(result["dues"])

		## Yearly levers at the end of each year (every 52 weeks).
		if (week_idx + 1) % WEEKS_IN_YEAR == 0:
			var year_num: int = (week_idx + 1) / WEEKS_IN_YEAR
			total_grant += grant_year(band, grant_chance, youth_open)
			total_volunteer += volunteer_saving_year(band, vol_share)
			var boxers_so_far: float = intake * float(INTAKES_PER_YEAR * year_num)
			total_show += show_year(boxers_so_far, per_boxer)
			total_classes += class_year(band, cheap_share)

	var total_boxers: float = intake * float(INTAKES_PER_YEAR * YEARS)
	var boxer_value: float = float(BOXER_VALUE) * total_boxers

	var total: float = total_dues + total_grant + total_volunteer + total_show + boxer_value + total_classes

	return {
		"dues": total_dues,
		"grant": total_grant,
		"volunteer": total_volunteer,
		"show": total_show,
		"boxers": boxer_value,
		"classes": total_classes,
		"total": total,
	}
