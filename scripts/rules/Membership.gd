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
const MAX_WEEKLY_MEMBER_CHANGE := 6


## A member's MONTHLY fee (what the screens show).
static func weekly_rate() -> int:
	return GymBills.FEE_MONTH


## What the gym as it stands could carry. Reputation is the only input in week 1.
static func natural_members(reputation: int) -> int:
	var total := float(BASE_MEMBERS) + float(reputation) * MEMBERS_PER_REPUTATION_POINT
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


static func weekly_dues(members: int) -> int:
	return int(GymBills.week({"members": maxi(0, members)})["income"])


## The weekly pass: walk the count one step, then bill that count. The caller credits the cash.
static func settle_week(members: int, reputation: int) -> Dictionary:
	var target := natural_members(reputation)
	var after := step_members(members, target)
	return {
		"dues": weekly_dues(after),
		"members": after,
		"members_before": members,
		"target": target,
		"rate": weekly_rate(),
		"delta": after - members,
	}
