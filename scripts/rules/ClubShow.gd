extends RefCounted
## S397 money bites (ops/research/MONEY_BITES_S397.md 7.1; all three round-1 critics): the gym hosts its own club show.
## Paid up front, the night sells tickets on turnout, and it can lose money. Real anchors (game dollars, GBP x 1.25): a
## venue ~$2,000, officials + doctor + ambulance ~$1,200, trophies ~$300; tickets ~$25; a raffle ~$1,000 (club owner,
## round 1). The turnout weights are GAME values: a young club's first show is a gamble, a grown club's a payday.
## Pure: the caller rolls `luck` and the raffle and stores the result.

## S541 HOSTLIGHT1: the cheapest hall (Community) booked with its reserves; each hall's own price is cost(hall).
const COST := 2580
const TICKET := 25
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
	return sold_in("community", members, reputation, juniors, home_boxers, luck)


## What the player sees before booking a hall: tickets and the night's net at bad and good luck, with an average raffle.
static func preview(members: int, reputation: int, juniors: int, home_boxers: int, draw_mult: float = 1.0, hall: String = "community") -> Dictionary:
	var lo := sold_in(hall, members, reputation, juniors, home_boxers, LUCK.x * draw_mult)
	var hi := sold_in(hall, members, reputation, juniors, home_boxers, LUCK.y * draw_mult)
	var raffle := (RAFFLE.x + RAFFLE.y) / 2
	return {"lo": lo, "hi": hi, "net_lo": lo * TICKET + RAFFLE.x - cost(hall), "net_hi": hi * TICKET + RAFFLE.y - cost(hall),
		"net_mid": roundi((lo + hi) / 2.0) * TICKET + raffle - cost(hall)}


## The night at Community hall with no pull-out (callers before S541). night_in is the full night.
static func night(members: int, reputation: int, juniors: int, home_boxers: int, luck: float, raffle: int) -> Dictionary:
	return night_in("community", members, reputation, juniors, home_boxers, luck, raffle, 0)


## Whether a show can be booked today: one at a time, EVERY_DAYS apart (from the last show's night).
static func can_book(day: int, booked_day: int, last_day: int) -> bool:
	return booked_day < 0 and (last_day < 0 or day >= last_day + EVERY_DAYS - LEAD_DAYS)


## The Saturday LEAD_DAYS out.
static func show_day(day: int) -> int:
	return day - posmod(day, 7) + 5 + LEAD_DAYS


## ---------- S541 HOSTLIGHT1: the light money night - two halls as a read, two standby reserves, the night's sheet ----------
## Owner Q-S294-318 "Yes, light night": the matchmaking card is cut; the show keeps one row on Club > Money. Numbers from
## ops/research/DESIGN_HOSTSHOW1_V8.md 4.2 (halls) and 4.8 (reserves). The hall's reach scales the CLUB part of the draw
## (BASE + members + reputation); juniors' families and the home boxers' followers come whatever the hall.
const HALLS := {
	"community": {"name": "Community hall", "seats": 250, "rent": 1000, "card": 9, "full": 4, "half": -3},
	"town": {"name": "Town hall", "seats": 400, "rent": 2000, "card": 12, "full": 6, "half": -4},
}
const HALL_ORDER := ["community", "town"]
const FIXED := 1500            ## officials, doctor, ambulance, medals (the old COST's anchors without the venue)
const RESERVES := 2            ## two standby reserves, the default, no toggle (4.8)
const STANDBY := 40            ## $40 each, paid with the hall
const TOWN_REACH := Vector3(0.6, 0.01, 1.25)   ## base, per reputation point, cap (4.2)
const FULL_AT := 0.85
const HALF_AT := 0.5
const SHORT_REP := -2          ## under two-thirds of the card boxed (4.8)
const REP_DOLLARS := 333       ## the read weighs a reputation point at this (v7)
const READ_CLOSE := 300        ## halls within this: "Close - your call"
const READ_LUCKS := 5
const PULL_OUT := 0.35         ## the game's own rate, FightWeekEvents.PULL_OUT_CHANCE (kept equal by club_show_test)
## Members a show can bring stay bounded by the Community hall: the bigger hall raises cash and reputation, not members.
const MEMBER_SEATS := 250


static func hall_name(hall: String) -> String:
	return str(HALLS.get(hall, HALLS["community"])["name"])


static func seats(hall: String) -> int:
	return int(HALLS.get(hall, HALLS["community"])["seats"])


## What the hall costs on booking: rent, the fixed night, the two reserves.
static func cost(hall: String) -> int:
	return int(HALLS.get(hall, HALLS["community"])["rent"]) + FIXED + RESERVES * STANDBY


static func reach(hall: String, reputation: int) -> float:
	if hall == "town":
		return clampf(TOWN_REACH.x + TOWN_REACH.y * reputation, TOWN_REACH.x, TOWN_REACH.z)
	return 1.0


static func demand(hall: String, members: int, reputation: int, juniors: int, home_boxers: int) -> float:
	var club := BASE + PER_MEMBER * members + PER_REPUTATION * reputation
	return club * reach(hall, reputation) + PER_JUNIOR * juniors + PER_HOME_BOXER * home_boxers


static func sold_in(hall: String, members: int, reputation: int, juniors: int, home_boxers: int, luck: float) -> int:
	return clampi(roundi(demand(hall, members, reputation, juniors, home_boxers) * luck), 0, seats(hall))


## The card on the night: `falls` visiting bouts pulled out; the reserves box first.
static func card(hall: String, falls: int) -> Dictionary:
	var n := int(HALLS.get(hall, HALLS["community"])["card"])
	var f := clampi(falls, 0, n)
	var used := mini(f, RESERVES)
	var boxed := n - (f - used)
	return {"card": n, "falls": f, "reserves_used": used, "boxed": boxed, "short": boxed * 3 < n * 2}


## Reputation from the seats: full 85%+, half-empty under 50%.
static func seat_rep(hall: String, sold: int) -> int:
	var cap := seats(hall)
	if sold >= FULL_AT * cap:
		return int(HALLS[hall]["full"])
	if sold < HALF_AT * cap:
		return int(HALLS[hall]["half"])
	return 0


## The night in a hall: {hall, seats, sold, tickets, raffle, cost, net, rep, full, half, card..., members}.
static func night_in(hall: String, members: int, reputation: int, juniors: int, home_boxers: int, luck: float, raffle: int, falls: int) -> Dictionary:
	if not HALLS.has(hall):
		hall = "community"
	var n := sold_in(hall, members, reputation, juniors, home_boxers, luck)
	var out := card(hall, falls)
	var net := n * TICKET + raffle - cost(hall)
	var cap := seats(hall)
	out.merge({"hall": hall, "seats": cap, "sold": n, "tickets": n * TICKET, "raffle": raffle, "cost": cost(hall), "net": net,
		"full": n >= FULL_AT * cap, "half": n < HALF_AT * cap,
		"rep": seat_rep(hall, n) + (SHORT_REP if bool(out["short"]) else 0),
		"members": int(mini(n, MEMBER_SEATS) / TICKETS_PER_MEMBER) if net > 0 else 0})
	return out


## The chance the card falls short with RESERVES standing by (binomial on PULL_OUT).
static func short_chance(hall: String) -> float:
	var n := int(HALLS[hall]["card"])
	var p := 0.0
	for k in n + 1:
		if bool(card(hall, k)["short"]):
			p += _binom(n, k) * pow(PULL_OUT, k) * pow(1.0 - PULL_OUT, n - k)
	return p


static func _binom(n: int, k: int) -> float:
	var r := 1.0
	for i in k:
		r = r * float(n - i) / float(i + 1)
	return r


## The hall's EXPECTED night: five lucks across LUCK, the average raffle, the short-card chance.
static func likely(hall: String, members: int, reputation: int, juniors: int, home_boxers: int, draw_mult: float = 1.0) -> Dictionary:
	var raffle := (RAFFLE.x + RAFFLE.y) / 2
	var sold := 0.0
	var net := 0.0
	var rep := 0.0
	for i in READ_LUCKS:
		var luck := lerpf(LUCK.x, LUCK.y, float(i) / float(READ_LUCKS - 1)) * draw_mult
		var n := sold_in(hall, members, reputation, juniors, home_boxers, luck)
		sold += n
		net += n * TICKET + raffle - cost(hall)
		rep += seat_rep(hall, n)
	sold /= READ_LUCKS
	net /= READ_LUCKS
	rep = rep / READ_LUCKS + SHORT_REP * short_chance(hall)
	return {"hall": hall, "seats": seats(hall), "sold": roundi(sold), "net": roundi(net), "rep": roundi(rep),
		"v": net + rep * REP_DOLLARS, "cost": cost(hall)}


## THE HALL READ: both halls' likely night, the one that pays named (cash + reputation at REP_DOLLARS a point), "close"
## within READ_CLOSE. {hall, close, likely: {hall: {...}}, line}.
static func read(members: int, reputation: int, juniors: int, home_boxers: int, draw_mult: float = 1.0) -> Dictionary:
	var lk := {}
	for h in HALL_ORDER:
		lk[h] = likely(h, members, reputation, juniors, home_boxers, draw_mult)
	var best := "community" if float(lk["community"]["v"]) >= float(lk["town"]["v"]) else "town"
	var close := absf(float(lk["community"]["v"]) - float(lk["town"]["v"])) < READ_CLOSE
	var other := "town" if best == "community" else "community"
	var line := ""
	if close:
		line = "Close - your call. %s %s. %s %s." % [hall_name("community"), _fill(lk["community"], false), hall_name("town"), _fill(lk["town"], false)]
	else:
		line = "Your club %s. %s %s." % [_fill(lk[best], true), hall_name(other), _fill(lk[other], false)]
	# the row's own words: two lines on Club > Money hold about 90 characters, so the read is cut to the halls' facts
	var first: String = "community" if close else best
	var second: String = "town" if close else other
	var short := "%s%s: %s. %s: %s." % ["Close - your call. " if close else "", hall_name(first), _brief(lk[first], true),
		hall_name(second).trim_suffix(" hall"), _brief(lk[second], false)]
	return {"hall": best, "close": close, "likely": lk, "line": line, "short": short}


## "full, likely +$2,300, +4 rep" / "136 of 250, likely +$1,800" / "half-empty, -$900, -4 rep".
static func _brief(l: Dictionary, likely_word: bool) -> String:
	var cap := int(l["seats"])
	var sold := int(l["sold"])
	var state := "full" if sold >= FULL_AT * cap else ("half-empty" if sold < HALF_AT * cap else "%d of %d" % [sold, cap])
	var rep := int(l["rep"])
	return "%s, %s%s%s" % [state, "likely " if likely_word else "", _money(int(l["net"])), "" if rep == 0 else ", %s%d rep" % ["+" if rep > 0 else "", rep]]


## "fills Community hall: likely +$2,300" (ours) / "would be half-empty: likely -$900" (the other).
static func _fill(l: Dictionary, ours: bool) -> String:
	var hall := str(l["hall"])
	var cap := int(l["seats"])
	var sold := int(l["sold"])
	var money := "likely %s" % _money(int(l["net"]))
	var rep := int(l["rep"])
	if rep != 0:
		money += ", %s%d reputation" % ["+" if rep > 0 else "", rep]
	if ours:
		if sold >= FULL_AT * cap:
			return "fills %s: %s" % [hall_name(hall), money]
		if sold < HALF_AT * cap:
			return "would leave %s half-empty: %s" % [hall_name(hall), money]
		return "sells about %d of %d seats in %s: %s" % [sold, cap, hall_name(hall), money]
	if sold >= FULL_AT * cap:
		return "would fill: %s" % money
	if sold < HALF_AT * cap:
		return "would be half-empty: %s" % money
	return "would sell about %d of %d: %s" % [sold, cap, money]


## Rounded to $100, signed: +$2,300 / -$900.
static func _money(n: int) -> String:
	var r := absi(roundi(n / 100.0) * 100)
	var s := str(r)
	if r >= 1000:
		s = "%d,%03d" % [r / 1000, r % 1000]
	return ("-$" if n < 0 and r > 0 else "+$") + s


## The night's sheet, one line for the result message.
static func sheet(n: Dictionary) -> String:
	var seats_word := "a full house" if bool(n["full"]) else ("half-empty" if bool(n["half"]) else "%d of %d seats" % [int(n["sold"]), int(n["seats"])])
	var bouts := "all %d bouts boxed" % int(n["card"])
	if int(n["falls"]) > 0:
		bouts = "%d pulled out, %s, %d of %d bouts boxed" % [int(n["falls"]),
			"both reserves boxed" if int(n["reserves_used"]) == 2 else ("one reserve boxed" if int(n["reserves_used"]) == 1 else "no reserve needed"),
			int(n["boxed"]), int(n["card"])]
	var rep := int(n["rep"])
	return "%s: %d sold (%s); %s%s." % [hall_name(str(n["hall"])), int(n["sold"]), seats_word, bouts,
		"" if rep == 0 else ("; reputation %s%d" % ["+" if rep > 0 else "", rep])]
