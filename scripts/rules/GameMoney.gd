extends RefCounted
## Pure money rules (copied from E:\FightCamp\Game\Godot\scripts\state\GameMoney.gd, stripped for the lean restart).
## Income lands every week; wages and upkeep accrue every week and are billed at the month end, every 28 days (the
## prototype's calendar). Kept: payroll sums, the weekly projection, accrual and the bill. Dropped: the front desk, floor
## items, pay tiers, camp spend, manager shares and calendar-month keys (not in week 1).

## Decided numbers (CLAUDE.md, S293).
const UPKEEP_PER_WEEK := 500
const FIGHTER_STIPEND := 250
const CLASSES_WITH_COACH := 350
const COACH_SIGNING_FEE := 1000
const BILL_EVERY_DAYS := 28


## Staff wages a week: every staff row's "salary".
static func staff_payroll(staff: Array) -> int:
	var payroll := 0
	for member_value in staff:
		payroll += int((member_value as Dictionary).get("salary", 0))
	return payroll


## Fighter stipends a week: every roster row's "weekly_salary".
static func athlete_payroll(roster: Array) -> int:
	var payroll := 0
	for athlete_value in roster:
		payroll += int((athlete_value as Dictionary).get("weekly_salary", 0))
	return payroll


static func weekly_projection(membership_dues: int, athlete_wages: int, staff_wages: int, upkeep: int) -> int:
	return membership_dues - (athlete_wages + staff_wages + upkeep)


## {upkeep, staff, fighters, total} a week.
static func weekly_costs(staff: Array, roster: Array, upkeep: int = UPKEEP_PER_WEEK) -> Dictionary:
	var staff_pay := staff_payroll(staff)
	var fighter_pay := athlete_payroll(roster)
	return {"upkeep": upkeep, "staff": staff_pay, "fighters": fighter_pay, "total": upkeep + staff_pay + fighter_pay}


## {dues, classes, sponsors, total} a week. Evening classes run only with a coach.
static func weekly_income(dues: int, has_coach: bool, sponsors: int = 0) -> Dictionary:
	var classes := CLASSES_WITH_COACH if has_coach else 0
	return {"dues": dues, "classes": classes, "sponsors": sponsors, "total": dues + classes + sponsors}


## The day the next bill falls on, strictly after `day` (day 0 is the opening Monday).
static func next_bill_day(day: int) -> int:
	return (int(floor(float(day) / BILL_EVERY_DAYS)) + 1) * BILL_EVERY_DAYS


static func is_bill_day(day: int) -> bool:
	return day > 0 and day % BILL_EVERY_DAYS == 0


## Settles one finished week: income in, costs accrued, and on a bill day the whole accrual paid.
## Returns {cash, accrued, income, billed}. Pure: the caller stores the numbers.
static func settle_week(cash: int, accrued: int, income: int, week_costs: int, day: int) -> Dictionary:
	var new_cash := cash + income
	var new_accrued := accrued + week_costs
	var billed := 0
	if is_bill_day(day):
		billed = new_accrued
		new_cash -= billed
		new_accrued = 0
	return {"cash": new_cash, "accrued": new_accrued, "income": income, "billed": billed}


## "$25,000", "-$1,200".
static func text(n: int) -> String:
	var s := str(absi(n))
	var out := ""
	while s.length() > 3:
		out = "," + s.substr(s.length() - 3) + out
		s = s.substr(0, s.length() - 3)
	return ("-$" if n < 0 else "$") + s + out
