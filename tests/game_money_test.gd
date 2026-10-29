extends SceneTree
## GameMoney: the old repo tested these sums through FinanceLedger (tests/finance_ledger_test.gd). Its fixtures are kept
## here against GameMoney directly, plus the lean game's weekly settle and 28-day bill.

const GameMoney := preload("res://scripts/rules/GameMoney.gd")

var failures := 0
var checks := 0


func _initialize() -> void:
	_fixture_fresh_gym()
	_fixture_coach_and_boxers()
	_fixture_two_staff()
	_quick_start_month()
	print("GAME_MONEY failures=%d checks=%d" % [failures, checks])
	quit(1 if failures > 0 else 0)


func _check(condition: bool, label: String) -> void:
	checks += 1
	if not condition:
		failures += 1
		print("  FAIL: %s" % label)


## Fixture 1 (finance ledger): no staff, no roster, no upkeep -> nothing a week.
func _fixture_fresh_gym() -> void:
	var costs := GameMoney.weekly_costs([], [], 0)
	_check(int(costs["total"]) == 0, "fresh: no weekly costs")
	_check(GameMoney.weekly_projection(0, 0, 0, 0) == 0, "fresh: net weekly 0")


## Fixture 2 (finance ledger): one coach 900 + boxers 300 and 400, upkeep 50 -> net -1650.
func _fixture_coach_and_boxers() -> void:
	var staff := [{"salary": 900}]
	var roster := [{"weekly_salary": 300}, {"weekly_salary": 400}]
	var costs := GameMoney.weekly_costs(staff, roster, 50)
	_check(int(costs["upkeep"]) == 50 and int(costs["staff"]) == 900 and int(costs["fighters"]) == 700, "coach: three cost rows")
	_check(GameMoney.weekly_projection(0, 700, 900, 50) == -1650, "coach: net weekly -1650")


## Fixture 3 (finance ledger, front desk dropped): staff 500 + 600, one boxer 350, upkeep 70.
func _fixture_two_staff() -> void:
	var costs := GameMoney.weekly_costs([{"salary": 500}, {"salary": 600}], [{"weekly_salary": 350}], 70)
	_check(int(costs["staff"]) == 1100 and int(costs["total"]) == 1520, "staff: payroll 1100, total 1520")


## The decided numbers over the quick start's first month: Lucy ($250), Luke Reid ($450), upkeep $500 a week,
## 30 members at $22 plus $350 classes. Income lands weekly; the bill falls on day 28 and clears the accrual.
func _quick_start_month() -> void:
	var costs := GameMoney.weekly_costs([{"salary": 450}], [{"weekly_salary": 250}])
	_check(int(costs["total"]) == 1200, "quick start: $1,200 of costs a week")
	var income := GameMoney.weekly_income(30 * 22, true)
	_check(int(income["total"]) == 1010, "quick start: $660 dues + $350 classes")
	_check(int(GameMoney.weekly_income(660, false)["classes"]) == 0, "no coach, no classes")
	var cash := 25000
	var accrued := 0
	for week in range(1, 5):
		var r := GameMoney.settle_week(cash, accrued, 1010, 1200, week * 7)
		cash = int(r["cash"])
		accrued = int(r["accrued"])
		if week < 4:
			_check(int(r["billed"]) == 0, "week %d: nothing billed yet" % week)
	_check(accrued == 0, "day 28: the accrual is cleared")
	_check(cash == 25000 + 4 * 1010 - 4 * 1200, "day 28: cash is the month's income less the month's bill")
	_check(GameMoney.next_bill_day(0) == 28 and GameMoney.next_bill_day(28) == 56, "the next bill is every 28 days")
	_check(not GameMoney.is_bill_day(0) and GameMoney.is_bill_day(56), "day 0 is not a bill day; day 56 is")
