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
const STRENGTH_CANDIDATES := [0.0, 0.25, 0.50]
const UPLIFT_CANDIDATES := [0.0, 0.10, 0.20]

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


## Waitlist keep: a multiplier on the band's member-loss (churn). 1.0 when the club is NOT at
## capacity or reputation < 40. When full: 1.0 - strength * (rep - 40) / 60. Premium gets the
## full effect; Standard half; Cheap none (juniors, not payers).
static func waitlist_keep(band: String, reputation: int, cap_full: bool, strength: float) -> float:
	if not cap_full or reputation < 40:
		return 1.0
	var base: float = 1.0 - strength * (float(reputation) - 40.0) / 60.0
	if band == "premium":
		return base
	elif band == "standard":
		return 1.0 - (1.0 - base) * 0.5
	return 1.0


## Waitlist fee: dues multiplier. 1.0 unless the club is full and reputation >= 60,
## then 1.0 + uplift for Premium only.
static func waitlist_fee(band: String, reputation: int, cap_full: bool, uplift: float) -> float:
	if not cap_full or reputation < 60 or band != "premium":
		return 1.0
	return 1.0 + uplift


## Five-year total for one band in one case (reputation, cap).
## levers keys: grant_chance, youth_open, volunteer_share, show_per_boxer, low_rep_draw, steady,
## cheap_share, strength, uplift.
## Returns {dues, grant, volunteer, show, boxers, classes, waitlist_kept, waitlist_fee_extra, total}.
static func five_year_total(reputation: int, cap: int, band: String, levers: Dictionary) -> Dictionary:
	var grant_chance: float = float(levers.get("grant_chance", 0.0))
	var youth_open: bool = levers.get("youth_open", true)
	var vol_share: float = float(levers.get("volunteer_share", 0.0))
	var per_boxer: int = int(levers.get("show_per_boxer", 0))
	var low_rep_draw: float = float(levers.get("low_rep_draw", 0.85))
	var steady: float = float(levers.get("steady", 1.0))
	var cheap_share: float = float(levers.get("cheap_share", 1.0))
	var strength: float = float(levers.get("strength", 0.0))
	var uplift: float = float(levers.get("uplift", 0.0))

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
	var total_wl_kept: float = 0.0
	var total_wl_fee: float = 0.0

	var intake: float = Membership.intake_chance(band)

	for week_idx in range(TOTAL_WEEKS):
		var before: int = members
		var result: Dictionary = Membership.settle_week(members, reputation, cap, band, draw_mult)
		var after: int = int(result["members"])
		var cap_full: bool = before >= cap

		var wk: float = waitlist_keep(band, reputation, cap_full, strength)
		var adjusted: int = after
		if wk < 1.0 and after < before:
			var loss: int = before - after
			var kept: int = loss - int(round(float(loss) * wk))
			adjusted = mini(after + kept, cap)

		var wf: float = waitlist_fee(band, reputation, cap_full, uplift)
		var adj_dues: float = float(Membership.weekly_dues(adjusted, band))
		var base_dues: float = float(Membership.weekly_dues(after, band))
		var week_dues: float = adj_dues * wf
		var kept_dues: float = adj_dues - base_dues
		var fee_extra: float = adj_dues * (wf - 1.0)

		members = adjusted
		total_dues += week_dues
		total_wl_kept += kept_dues
		total_wl_fee += fee_extra

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
		"waitlist_kept": total_wl_kept,
		"waitlist_fee_extra": total_wl_fee,
		"total": total,
	}
