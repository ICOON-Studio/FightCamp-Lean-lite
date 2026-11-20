extends SceneTree
## TASK LOANCONTRACT1: blind contract test of the gym fit-out loan (S531 GROWTH_SCOPE: $3,000 down, premises +1,
## fitout_weeks 52, then $173 a week for 52 weeks, paid with the bills).
## Expectations come from ops/research/TASK_LOANCONTRACT1.md; the implementation's own test was not read.
## Prints ok/FAIL per check, ends with "LOAN_CONTRACT failures=<n>", exits 0 only when every check passes.

const Sim := preload("res://scripts/state/Sim.gd")
const GymSpend := preload("res://scripts/state/GymSpend.gd")
const GymUpgrades := preload("res://scripts/rules/GymUpgrades.gd")
const CashForecast := preload("res://scripts/rules/CashForecast.gd")

var failures: int = 0


func _initialize() -> void:
	_loan_move()
	_refused_below_deposit()
	_refused_while_paying()
	_refused_at_biggest()
	_fitout_line()
	_forecast_is_read_only()
	_charges_52_weeks()
	_cash_move_refused()
	var boundary := _career()
	boundary.cash = 3000
	_check(GymSpend.move(boundary, true) == "", "exactly $3,000 is enough for the deposit")
	_check(boundary.cash == 0 and boundary.fitout_weeks == 52 and boundary.premises == 1,
		"the exact-deposit move applies all loan terms")
	print("LOAN_CONTRACT failures=%d" % failures)
	quit(0 if failures == 0 else 1)


func _check(ok: bool, label: String) -> void:
	if ok:
		print("ok  " + label)
	else:
		failures += 1
		print("FAIL " + label)


## A quick-start career with the contract's knobs set by hand; everything else left as quick_start makes it.
func _career() -> Career:
	var c := Career.quick_start()
	c.cash = 5000
	c.reputation = 50
	c.members = 80
	c.premises = 0
	c.fitout_weeks = 0
	return c


func _snapshot(c: Career) -> Dictionary:
	return {"cash": c.cash, "premises": c.premises, "fitout_weeks": c.fitout_weeks, "ledger": c.ledger.size()}


func _untouched(c: Career, before: Dictionary, label: String) -> void:
	_check(c.premises == int(before["premises"]), label + ": premises unchanged")
	_check(c.cash == int(before["cash"]), label + ": cash unchanged")
	_check(c.fitout_weeks == int(before["fitout_weeks"]), label + ": fitout_weeks unchanged")
	_check(c.ledger.size() == int(before["ledger"]), label + ": the ledger is unchanged")


## 1. move(c, true) with cash >= $3,000: "" and the whole promise lands at once.
func _loan_move() -> void:
	var c := _career()
	c.cash = 5000
	var ledger_before := c.ledger.size()
	var reason := GymSpend.move(c, true)
	_check(reason == "", "move(c, true) with cash >= $3,000 returns \"\"")
	_check(c.premises == 1, "premises goes up by one")
	_check(c.cash == 5000 - 3000, "cash drops by exactly $3,000")
	_check(c.fitout_weeks == 52, "fitout_weeks becomes 52")
	_check(c.ledger.size() == ledger_before + 1, "the deposit adds exactly one ledger line")
	if not c.ledger.is_empty():
		_check(int(c.ledger[0]["amount"]) == -3000, "the newest ledger line is the deposit (-3000)")
	else:
		_check(false, "the newest ledger line is the deposit (-3000)")


## 2. Below the $3,000 deposit the loan move is refused and nothing changes.
func _refused_below_deposit() -> void:
	var c := _career()
	c.cash = 2999
	var before := _snapshot(c)
	var reason := GymSpend.move(c, true)
	_check(reason != "", "move(c, true) below $3,000 is refused (non-empty reason)")
	_untouched(c, before, "refused below the deposit")


## 3. While a loan runs (fitout_weeks > 0) a second move on a loan is refused and nothing changes.
func _refused_while_paying() -> void:
	var c := _career()
	c.cash = 50000
	c.fitout_weeks = 17
	var before := _snapshot(c)
	var reason := GymSpend.move(c, true)
	_check(reason != "", "move(c, true) while the loan runs is refused (non-empty reason)")
	_untouched(c, before, "refused while the loan runs")


## 4. At the biggest premises the loan move is refused.
func _refused_at_biggest() -> void:
	var c := _career()
	c.cash = 50000
	c.premises = GymUpgrades.PREMISES.size() - 1
	var before := _snapshot(c)
	var reason := GymSpend.move(c, true)
	_check(reason != "", "move(c, true) at the biggest premises is refused (non-empty reason)")
	_untouched(c, before, "refused at the biggest premises")


## 5. The fit-out line: $173 a week while the loan runs, 0 when none runs, counted in the total.
func _fitout_line() -> void:
	var c := _career()
	c.fitout_weeks = 9
	var with_loan := Sim.weekly_costs(c)
	_check(int(with_loan["fitout"]) == 173, "weekly_costs: fitout is 173 while a loan runs")
	c.fitout_weeks = 0
	var without_loan := Sim.weekly_costs(c)
	_check(int(without_loan["fitout"]) == 0, "weekly_costs: fitout is 0 when no loan runs")
	_check(int(with_loan["total"]) - int(without_loan["total"]) == 173, "weekly_costs: total includes the $173 fit-out line")


## 6. CashForecast.project is a read: it never moves the loan's weeks or the cash.
func _forecast_is_read_only() -> void:
	var c := _career()
	c.cash = 4321
	c.fitout_weeks = 25
	CashForecast.project(c, 8)
	_check(c.fitout_weeks == 25, "CashForecast.project leaves fitout_weeks alone")
	_check(c.cash == 4321, "CashForecast.project leaves cash alone")


## 7. Played day by day through Sim.step_day (cash kept high so the gym stays open): the loan is charged for
## exactly 52 weeks and then stops; a new loan is allowed afterwards (premises can still grow).
func _charges_52_weeks() -> void:
	var c := _career()
	c.cash = 100_000_000
	GymSpend.move(c, true)
	_check(c.fitout_weeks == 52, "the loan starts with 52 weeks to pay")
	var charged := 0
	var paid := 0
	var one_per_week := true
	for w in 52:
		var weeks_before := c.fitout_weeks
		var line := int(Sim.weekly_costs(c)["fitout"])
		paid += line
		if line == 173 or (weeks_before == 1 and line == 177):   # S531 contract change: the last week pays the rest
			charged += 1
		for d in 7:
			Sim.step_day(c)
		if c.fitout_weeks != weeks_before - 1:
			one_per_week = false
	_check(one_per_week, "step_day runs the loan down by exactly one week per week played")
	_check(charged == 52, "the fit-out line reads 173 for 51 weeks and 177 in the last")
	_check(paid == 9000, "the 52 payments total exactly $9,000 ($750 x 12) (%d)" % paid)
	_check(c.fitout_weeks == 0, "after 52 weeks the loan is paid off (fitout_weeks == 0)")
	_check(int(Sim.weekly_costs(c)["fitout"]) == 0, "the fit-out line is 0 once the loan is paid")
	for d in 14:
		Sim.step_day(c)
	_check(c.fitout_weeks == 0, "two more played weeks leave the paid loan at zero")
	_check(int(Sim.weekly_costs(c)["fitout"]) == 0, "no fit-out charge returns after payoff")
	var again := GymSpend.move(c, true)
	_check(again == "", "a new loan is allowed once the old one is paid (premises can still grow)")
	_check(c.fitout_weeks == 52, "the new loan runs for 52 weeks again")


## 8. The plain cash move (no loan) below $12,000 is refused and changes nothing.
func _cash_move_refused() -> void:
	var c := _career()
	c.cash = 11999
	var before := _snapshot(c)
	var reason := GymSpend.move(c)
	_check(reason != "", "move(c) below $12,000 is refused (non-empty reason)")
	_untouched(c, before, "refused cash move")
