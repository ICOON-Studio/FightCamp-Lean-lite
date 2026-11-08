extends RefCounted
## Membership: what the gym lives on (copied from E:\FightCamp\Game\Godot\scripts\Membership.gd, R44 + S66 unfreeze +
## S292 dues, stripped for the lean restart). Members pay dues every week; the count walks toward what the gym can carry,
## a capped step at a time, so a week is never a jump. Deterministic: no RNG.
## Kept: the dues rate, the natural count, the walk, the weekly settle. Dropped: the city market, rivals, crowding,
## kit types, title spikes and the front door (one gym, no floor in week 1). The magnitudes moved from membership.json
## into constants; every one is an authored game rule, not a claim about what a real gym charges.

## S324 update 27 (make-it-a-game plan, operator "Build it"): members pay the real monthly fee, GymBills.FEE_MONTH ($35,
## England Boxing club ~GBP 28), the game keeps it by the week (was $22 a week = 3x the real fee).
const GymBills := preload("res://scripts/rules/GymBills.gd")
## Quick start opens the doors with 30 members on the books.
const OPENING_MEMBERS := 30
## What a gym with no reputation still carries: the neighbourhood walking in.
const BASE_MEMBERS := 48
const MEMBERS_PER_REPUTATION_POINT := 0.6
const MAX_MEMBERS := 400
## S66 "Unfreeze now": the walk closes a quarter of the gap a week, never more than 6 members. 0 on either freezes it.
const WEEKLY_DRIFT_FRACTION := 0.25
## S397 money bites round 2 (both critics: "the player cannot set the dues"): three dues bands. Real: community boxing
## clubs GBP 20-35 a month, premium boxing gyms GBP 50-80 (game dollars x 1.25). How many the band draws is GAME: cheap
## draws 15% more; premium 15% fewer, a gap a famous gym closes (reputation 100 = no gap).
const DUES := {
	"cheap": {"name": "Cheap", "fee": 25, "draw": 1.15},
	"standard": {"name": "Standard", "fee": 35, "draw": 1.0},
	"premium": {"name": "Premium", "fee": 45, "draw": 0.85},
}
const DUES_ORDER := ["cheap", "standard", "premium"]
const MAX_WEEKLY_MEMBER_CHANGE := 6


## A member's MONTHLY fee (what the screens show).
static func weekly_rate() -> int:
	return GymBills.FEE_MONTH


## What the gym as it stands could carry. Reputation is the only input in week 1.
static func natural_members(reputation: int, band: String = "standard") -> int:
	var total := (float(BASE_MEMBERS) + float(reputation) * MEMBERS_PER_REPUTATION_POINT) * draw(band, reputation)
	return clampi(int(round(total)), 0, MAX_MEMBERS)


## One week's movement toward the target: a fraction of the gap, never more than the cap, never past the target,
## and always at least one so a standing gap cannot stall forever.
static func step_members(current: int, target: int, fraction: float = WEEKLY_DRIFT_FRACTION,
		cap: int = MAX_WEEKLY_MEMBER_CHANGE) -> int:
	var gap := target - current
	if gap == 0 or cap <= 0 or fraction <= 0.0:
		return current
	var span := absi(gap)
	var step := int(ceil(float(span) * fraction))
	step = mini(maxi(step, 1), mini(span, cap))
	return current + (step if gap > 0 else -step)


static func draw(band: String, reputation: int) -> float:
	var d := float((DUES.get(band, DUES["standard"]) as Dictionary)["draw"])
	return d + (1.0 - d) * clampf(float(reputation) / 100.0, 0.0, 1.0) if d < 1.0 else d


static func fee(band: String) -> int:
	return int((DUES.get(band, DUES["standard"]) as Dictionary)["fee"])


static func weekly_dues(members: int, band: String = "standard") -> int:
	return roundi(float(maxi(0, members)) * float(fee(band)) / GymBills.WEEKS_A_MONTH)


## The weekly pass: walk the count one step, then bill that count. The caller credits the cash. S397 money bites: the
## premises cap what the gym can hold (GymSpend.member_cap; a full gym needs a bigger place).
static func settle_week(members: int, reputation: int, cap: int = MAX_MEMBERS, band: String = "standard") -> Dictionary:
	var natural := natural_members(reputation, band)
	var target := mini(natural, cap)
	var after := step_members(members, target)
	return {
		"dues": weekly_dues(after, band),
		"members": after,
		"members_before": members,
		"target": target,
		"rate": weekly_rate(),
		"delta": after - members,
		"why": week_cause(members, after, natural, cap, band, natural_members(reputation)),
	}


## R11B: one plain clause for why the count moved. Pure, no rng. `at_standard` is what the same name would draw on
## standard dues: the dues only get the blame when standard dues would have kept these members.
static func week_cause(before: int, after: int, natural: int, cap: int, band: String, at_standard: int = MAX_MEMBERS) -> String:
	if before == after:
		return ""
	if after > before:
		if after >= cap and natural > cap:
			return "the gym is full now"
		return "word is getting round"
	if natural >= cap:
		return "the gym has less room"
	if band == "premium" and at_standard >= before:
		return "the dues are putting people off"
	return "more than the gym's name can hold"
