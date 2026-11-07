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
## S397 money bites (MONEY_BITES_S397 7.1, the club owner critic): heating and power by the season, and public liability
## insurance. Real: $300-750 a month in winter, about half in summer; insurance ~$1,000-1,500 a year (game dollars).
const POWER_WINTER := 560
const POWER_SUMMER := 280
const WINTER_MONTHS := [10, 11, 12, 1, 2, 3]
const INSURANCE_YEAR := 1250
## The kit budget a week (round 1: club kit is $2,000-3,500 a year: gloves, headguards, pads, bags). Low wears the kit:
## more training injuries; Good keeps it fresh and a few more stay. GAME effect sizes; GymSpend applies them. S397 round 2
## (critic A: Low saved $25 and lost $26 of dues, a dead choice): Low now spends nothing and only raises the risk.
const KIT_BUDGET := {
	"low": {"name": "Low", "week": 0, "risk": 1.25, "members": 0},
	"standard": {"name": "Standard", "week": 45, "risk": 1.0, "members": 0},
	"good": {"name": "Good", "week": 80, "risk": 0.90, "members": 2},
}
const KIT_ORDER := ["low", "standard", "good"]


static func week(g: Dictionary) -> Dictionary:
	var m: int = int(g.get("members", 0))
	var ch: float = float(g.get("coach_hours_week", 0.0))
	var co: int = int(g.get("coaches", 0))
	var bx: int = int(g.get("boxers", 0))
	var income: int = roundi(float(m) * float(FEE_MONTH) / WEEKS_A_MONTH)
	# S397: the premises' rent (money bites: GymSpend.premises) times the start's room (rank 5: ClubStart).
	var rent: int = roundi(float(g.get("rent_month", RENT_MONTH)) * float(g.get("rent_mult", 1.0)) / WEEKS_A_MONTH)
	var coaching: int = roundi(ch * float(COACH_HOUR))
	var fees: int = roundi((float(CLUB_YEAR) + float(bx) * float(BOXER_YEAR) + float(co) * float(COACH_YEAR)) / 52.0)
	# S397: a setup without a month (an old caller) pays the year's average power; insurance always.
	var power: int = roundi(float(power_month(int(g.get("month", 0)))) / WEEKS_A_MONTH)
	var insurance: int = roundi(float(INSURANCE_YEAR) / 52.0)
	var costs: int = rent + coaching + fees + power + insurance
	var net: int = income - costs
	return {"income": income, "rent": rent, "coaching": coaching, "fees": fees, "power": power, "insurance": insurance,
		"costs": costs, "net": net}


## Heating and power for a month (1-12); 0 = the year's average.
static func power_month(month: int) -> int:
	if month <= 0:
		return roundi((POWER_WINTER + POWER_SUMMER) / 2.0)
	return POWER_WINTER if WINTER_MONTHS.has(month) else POWER_SUMMER


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
