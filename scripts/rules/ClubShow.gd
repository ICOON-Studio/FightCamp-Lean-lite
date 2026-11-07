extends RefCounted
## S397 money bites (ops/research/MONEY_BITES_S397.md 7.1; all three round-1 critics): the gym hosts its own club show.
## Paid up front, the night sells tickets on turnout, and it can lose money. Real anchors (game dollars, GBP x 1.25): a
## venue ~$2,000, officials + doctor + ambulance ~$1,200, trophies ~$300; tickets ~$25; a raffle ~$1,000 (club owner,
## round 1). The turnout weights are GAME values: a young club's first show is a gamble, a grown club's a payday.
## Pure: the caller rolls `luck` and the raffle and stores the result.

const COST := 3500
const TICKET := 25
const HALL := 400
## S397 round 2 (critic A: a grown club's show every 12 weeks was a cash machine; real clubs run 1-3 a year): 16 weeks apart.
const EVERY_DAYS := 112
const LEAD_DAYS := 28
const BASE := 40.0
const PER_MEMBER := 0.7
const PER_REPUTATION := 1.0
const PER_JUNIOR := 2.5
const PER_HOME_BOXER := 25.0
const LUCK := Vector2(0.7, 1.15)
const RAFFLE := Vector2i(600, 1400)
## A night that pays brings members in: one per this many tickets sold.
const TICKETS_PER_MEMBER := 40


## Tickets sold before the roll: members, reputation, juniors' skills bouts (their families come) and the gym's own boxers.
static func draw(members: int, reputation: int, juniors: int, home_boxers: int) -> float:
	return BASE + PER_MEMBER * members + PER_REPUTATION * reputation + PER_JUNIOR * juniors + PER_HOME_BOXER * home_boxers


static func sold(members: int, reputation: int, juniors: int, home_boxers: int, luck: float) -> int:
	return clampi(roundi(draw(members, reputation, juniors, home_boxers) * luck), 0, HALL)


## What the player sees before booking: tickets and the night's net at bad and good luck, with an average raffle.
static func preview(members: int, reputation: int, juniors: int, home_boxers: int) -> Dictionary:
	var lo := sold(members, reputation, juniors, home_boxers, LUCK.x)
	var hi := sold(members, reputation, juniors, home_boxers, LUCK.y)
	var raffle := (RAFFLE.x + RAFFLE.y) / 2
	return {"lo": lo, "hi": hi, "net_lo": lo * TICKET + RAFFLE.x - COST, "net_hi": hi * TICKET + RAFFLE.y - COST,
		"net_mid": roundi((lo + hi) / 2.0) * TICKET + raffle - COST}


## The night: {sold, tickets, raffle, net, members}. `luck` in LUCK, `raffle` in RAFFLE.
static func night(members: int, reputation: int, juniors: int, home_boxers: int, luck: float, raffle: int) -> Dictionary:
	var n := sold(members, reputation, juniors, home_boxers, luck)
	var tickets := n * TICKET
	var net := tickets + raffle - COST
	return {"sold": n, "tickets": tickets, "raffle": raffle, "net": net,
		"members": int(n / TICKETS_PER_MEMBER) if net > 0 else 0}


## Whether a show can be booked today: one at a time, EVERY_DAYS apart (from the last show's night).
static func can_book(day: int, booked_day: int, last_day: int) -> bool:
	return booked_day < 0 and (last_day < 0 or day >= last_day + EVERY_DAYS - LEAD_DAYS)


## The Saturday LEAD_DAYS out.
static func show_day(day: int) -> int:
	return day - posmod(day, 7) + 5 + LEAD_DAYS
