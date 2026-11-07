extends RefCounted
## S397 money bites round 2 (both blind critics: "grants are in your anchors but never used"): a small club grant, bid for
## once a year. Real: Sport England's Together Fund gives England Boxing clubs GBP 250-5,000; bids need a safeguarding
## officer and participation work (a youth section) and many are turned down. The odds and the second-coach condition are
## GAME. Pure.

const ANSWER_DAYS := 42
const EVERY_DAYS := 364
const BASE_CHANCE := 0.40
const MAX_CHANCE := 0.60
const AMOUNT := Vector2i(1500, 5000)


## "" = a bid can go in today; else why not.
static func blocked(day: int, grant: Dictionary, youth_on: bool, second_coach: bool) -> String:
	if grant.has("due"):
		return "a bid is already waiting for its answer"
	if grant.has("last") and day < int(grant["last"]) + EVERY_DAYS:
		return "one bid a year"
	if not youth_on:
		return "grants fund juniors' work: run a youth section first"
	if not second_coach:
		return "the bid needs a second coach for the juniors' nights"
	return ""


## A known club wins more often (reputation 100 = the top chance).
static func chance(reputation: int) -> float:
	return clampf(BASE_CHANCE + float(reputation) / 500.0, BASE_CHANCE, MAX_CHANCE)


static func amount(roll: float) -> int:
	return roundi(lerpf(float(AMOUNT.x), float(AMOUNT.y), clampf(roll, 0.0, 1.0)) / 100.0) * 100
