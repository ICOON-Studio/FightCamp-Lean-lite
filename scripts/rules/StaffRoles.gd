extends RefCounted
## S397 money bites (ops/research/MONEY_BITES_S397.md 7.1, STRUCTURE_DESIGN_S395 P5): four staff jobs beside the coach, each
## changing ONE number the player can see. Sessional staff on a weekly wage (the cutman by the pro night); letting one go
## costs a week's pay. Wages are real rates in game dollars (GBP x 1.25: club coach GBP 22/h, S&C GBP 40-60 a session,
## sports physio GBP 55-90 a session, small-hall cutman $100-190 a night); effect sizes are GAME values. Pure.

const LIST: Array[Dictionary] = [
	{"id": "assistant", "name": "Second club coach, 10 hours", "wage": 280, "per_bout": 0,
		"effect": "One more place on the roster; carries 40 more members; runs the fitness classes"},
	{"id": "strength", "name": "Strength and conditioning coach, 2 sessions", "wage": 100, "per_bout": 0,
		"effect": "Training injury risk down 15%; a pro camp's bill halved"},
	{"id": "physio", "name": "Physio on call, a session a week", "wage": 75, "per_bout": 0,
		"effect": "Injured boxers back a quarter sooner"},
	{"id": "cutman", "name": "Cutman, by the pro night", "wage": 0, "per_bout": 150,
		"effect": "Half the cut layoffs after a pro bout"},
]
## S397 round 2 (critic A: S&C plus the floor already hit the floor, so Good kit did nothing): S&C -15%, not -25%.
const STRENGTH_RISK := 0.85
const PHYSIO_DAYS := 0.75
const CUTMAN_KEEP := 0.5
## Every training-risk cut together never takes the risk below this (MONEY_BITES 7: stacked multipliers floor).
const RISK_FLOOR := 0.65


static func role(id: String) -> Dictionary:
	for r in LIST:
		if str(r["id"]) == id:
			return r
	return {}


static func wages(staff: Array) -> int:
	var total := 0
	for id in staff:
		total += int(role(str(id)).get("wage", 0))
	return total


static func per_bout(staff: Array) -> int:
	var total := 0
	for id in staff:
		total += int(role(str(id)).get("per_bout", 0))
	return total


## Letting go: a week's pay (the cutman, paid by the night, costs nothing to let go).
static func notice(id: String) -> int:
	return int(role(id).get("wage", 0))


## S397 round 2 (critic A: one sessional coach ran 250 members): every coach carries COACH_MEMBERS members on the books,
## the club's volunteers VOLUNTEER_MEMBERS more. Real: England Boxing session ratios ~1:10-12, a club runs several sessions
## a week; the per-coach number is GAME. Evening coaches beyond the jobs: EVENING_WAGE each (10 h at $28).
const COACH_MEMBERS := 40
const VOLUNTEER_MEMBERS := 30
const EVENING_WAGE := 280


## `hired`: the sessional coach hired at the start (Career.coach; the player is the head coach and always counts).
static func coaching_cap(hired: bool, staff: Array, evening: int) -> int:
	return VOLUNTEER_MEMBERS + COACH_MEMBERS * (1 + (1 if hired else 0) + (1 if staff.has("assistant") else 0) + maxi(0, evening))


static func places(staff: Array) -> int:
	return 1 if staff.has("assistant") else 0
