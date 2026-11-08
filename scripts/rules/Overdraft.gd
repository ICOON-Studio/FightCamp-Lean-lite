extends RefCounted
## S399 the gym's arranged overdraft: a small-business credit line the bank offers after a year of trading,
## 100 % of the last 4 weeks' income capped to the most recent $100-rounded figure, 16 % a year on the drawn
## (negative) balance charged weekly, the bank pulling the facility after 12 consecutive weeks in the red.
## Pure static functions - the career holds the flag (overdraft_on), the drawn-weeks counter and the income
## history; this module only knows the maths.

const INTEREST_RATE := 0.16
const WEEKS_PER_YEAR := 52
const PULL_AFTER_WEEKS := 12


## The overdraft limit: 100 % of the last 4 weeks' income, rounded down to the nearest $100, at least $0.
## Offered only after the gym has traded 12 weeks (no history = no overdraft).
static func limit(income_4w: int, weeks_traded: int) -> int:
	if weeks_traded < 12:
		return 0
	if income_4w <= 0:
		return 0
	return int(floor(float(income_4w) / 100.0)) * 100


## The income trail the limit reads: this week's income added, only the last 4 weeks kept (the save never grows).
static func trail(history: Array, week_income: int) -> Array:
	var out := history.duplicate()
	out.append(week_income)
	return out.slice(-4) if out.size() > 4 else out


## The arrangement fee: 1 % of the limit, charged on the day the player switches the facility on.
static func fee(lim: int) -> int:
	if lim <= 0:
		return 0
	return ceili(float(lim) * 0.01)


## Weekly interest on the drawn (negative) balance: drawn_abs * 0.16 / 52, rounded up to $1.
static func weekly_interest(cash: int) -> int:
	if cash >= 0:
		return 0
	var raw := float(-cash) * INTEREST_RATE / float(WEEKS_PER_YEAR)
	return maxi(1, ceili(raw))


## The close-clock tick: weeks below minus-the-limit when the facility is on, weeks below $0 when it is off.
static func next_below(cash: int, weeks_below: int, lim: int) -> int:
	var threshold := -lim
	if cash < threshold:
		return weeks_below + 1
	return 0


## The drawn counter: consecutive weeks the cash has ended negative (for the 12-week pull).
static func next_drawn(cash: int, drawn_weeks: int) -> int:
	if cash < 0:
		return drawn_weeks + 1
	return 0


## True when the bank pulls the facility: 12 consecutive weeks drawn.
static func should_pull(drawn_weeks: int) -> bool:
	return drawn_weeks >= PULL_AFTER_WEEKS
