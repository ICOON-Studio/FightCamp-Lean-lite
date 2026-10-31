extends RefCounted
## Real-world gym bills: a small boxing club's weekly money.
## England Boxing club ~33 members; fee GBP 28/month; 1,500 sq ft unit GBP 1,450/month;
## coach GBP 22/h (Level 1); registration GBP 250 club + 14/boxer + 28/coach per year.
## All dollar amounts are GBP x 1.25, rounded.

const FEE_MONTH := 35
const RENT_MONTH := 1800
const COACH_HOUR := 28
const CLUB_YEAR := 315
const BOXER_YEAR := 18
const COACH_YEAR := 35
const WEEKS_A_MONTH := 4.33
## S327 (operator Q-S294-45 "Money too harsh"): 8 weeks, was 4 - a landlord or bank gives about two months of arrears
## before it acts, and the player needs the time to play out of it (book a bout, sign a sponsor, cut the coach).
const CLOSE_AFTER_WEEKS := 8
const WARN_RUNWAY_WEEKS := 8
const START_MONTHS := 3


static func week(g: Dictionary) -> Dictionary:
	var m: int = int(g.get("members", 0))
	var ch: float = float(g.get("coach_hours_week", 0.0))
	var co: int = int(g.get("coaches", 0))
	var bx: int = int(g.get("boxers", 0))
	var income: int = roundi(float(m) * float(FEE_MONTH) / WEEKS_A_MONTH)
	var rent: int = roundi(float(RENT_MONTH) / WEEKS_A_MONTH)
	var coaching: int = roundi(ch * float(COACH_HOUR))
	var fees: int = roundi((float(CLUB_YEAR) + float(bx) * float(BOXER_YEAR) + float(co) * float(COACH_YEAR)) / 52.0)
	var costs: int = rent + coaching + fees
	var net: int = income - costs
	return {"income": income, "rent": rent, "coaching": coaching, "fees": fees, "costs": costs, "net": net}


static func runway_weeks(cash: int, net: int) -> int:
	if net >= 0:
		return 999
	if cash <= 0:
		return 0
	return int(floor(float(cash) / float(-net)))


static func status(cash: int, net: int, weeks_below: int) -> String:
	if weeks_below >= CLOSE_AFTER_WEEKS:
		return "closed"
	if cash < 0:
		return "red"
	var rw: int = runway_weeks(cash, net)
	if rw < WARN_RUNWAY_WEEKS:
		return "warn"
	return "ok"


static func next_below(cash: int, weeks_below: int) -> int:
	if cash < 0:
		return weeks_below + 1
	return 0


static func start_cash(g: Dictionary) -> int:
	var w: Dictionary = week(g)
	var raw: float = float(w["costs"]) * WEEKS_A_MONTH * float(START_MONTHS)
	return roundi(raw / 100.0) * 100


static func break_even_members(g: Dictionary) -> int:
	var w: Dictionary = week(g)
	var per_member: float = float(FEE_MONTH) / WEEKS_A_MONTH
	return int(ceil(float(w["costs"]) / per_member))


static func line(cash: int, net: int, weeks_below: int) -> String:
	var st: String = status(cash, net, weeks_below)
	if st == "closed":
		return "The gym has closed"
	if st == "red":
		var left: int = CLOSE_AFTER_WEEKS - weeks_below
		return "The gym closes in %d weeks" % left
	if net >= 0:
		return "Runway: safe"
	var rw: int = runway_weeks(cash, net)
	return "Runway: %d weeks" % rw
