extends SceneTree
## The dotted cash uses the game's own bill: income every week, costs accrued, the month bill once.
## Playing 8 weeks with no buys must land on the same cash. A normal week must not subtract costs as well.

const CashForecast := preload("res://scripts/rules/CashForecast.gd")
const Sim := preload("res://scripts/state/Sim.gd")
const GameMoney := preload("res://scripts/rules/GameMoney.gd")
const FirstWeek := preload("res://scripts/rules/FirstWeek.gd")
const WeekRead := preload("res://scripts/rules/WeekRead.gd")
const GymBills := preload("res://scripts/rules/GymBills.gd")

var failures := 0


func _initialize() -> void:
	var mid: Dictionary = GameMoney.settle_week(10000, 500, 800, 200, 7)
	_check(int(mid["cash"]) == 10800 and int(mid["accrued"]) == 700 and int(mid["billed"]) == 0,
		"a normal week adds the income and accrues the costs")
	var bill: Dictionary = GameMoney.settle_week(10000, 500, 800, 200, 28)
	_check(int(bill["cash"]) == 10100 and int(bill["accrued"]) == 0 and int(bill["billed"]) == 700,
		"a bill day pays the accrual once (500 already run up + 200 this week)")
	_play(Career.quick_start(), "quiet")
	var guided := Career.quick_start()
	FirstWeek.begin(guided)
	_play(guided, "first hour")
	_mid_bill(40)
	_mid_bill(41)
	_runway_days()
	print("CASH_FORECAST failures=%d" % failures)
	quit(1 if failures > 0 else 0)


func _check(ok: bool, what: String) -> void:
	if not ok:
		failures += 1
		print("FAIL: ", what)


func _play(c: Career, label: String) -> void:
	c.seed = 1
	var cash0 := c.cash
	var members0 := c.members
	var day0 := c.day
	var grap0 := c.grapplers.size()
	var pred: Array = CashForecast.project(c, 8)
	_check(c.cash == cash0 and c.members == members0 and c.day == day0 and c.grapplers.size() == grap0,
		label + " forecast changes nothing")
	_check(pred.size() == 8, label + " eight weeks")
	_no_double(pred, label)
	var hist := c.cash_history.size()
	for _i in 56:
		Sim.step_day(c)
	_check(c.cash_history.size() == hist + 8, label + " played eight weeks")
	for i in mini(8, pred.size()):
		var got := int(c.cash_history[hist + i]["c"]) if hist + i < c.cash_history.size() else -1
		_check(got == int(pred[i]["cash"]), "%s week %d cash %d vs forecast %d" % [label, i + 1, got, int(pred[i]["cash"])])
	if pred.size() == 8:
		_check(c.accrued == int(pred[7]["accrued"]), "%s accrued %d vs %d" % [label, c.accrued, int(pred[7]["accrued"])])


func _no_double(pred: Array, label: String) -> void:
	for i in pred.size():
		var w: Dictionary = pred[i]
		var before := int(w["cash_before"])
		var income := int(w["income"])
		var costs := int(w["costs"])
		var extra := int(w["extra"])
		var billed := int(w["billed"])
		var acc0 := int(w["accrued_before"])
		var parts := int(w["rent"]) + int(w["coach"]) + int(w["staff"]) + int(w["stipends"]) + int(w["other"])
		_check(parts == costs, "%s week %d cost lines add up (%d vs %d)" % [label, i + 1, parts, costs])
		if billed == 0:
			_check(int(w["cash"]) == before + income + extra, "%s week %d cash is the income, costs stay on the bill" % [label, i + 1])
			_check(int(w["accrued"]) == acc0 + costs, "%s week %d accrues the costs" % [label, i + 1])
		else:
			_check(billed == acc0 + costs, "%s week %d bill is the accrual once" % [label, i + 1])
			_check(int(w["cash"]) == before + income - billed + extra, "%s week %d pays that bill once" % [label, i + 1])
			_check(int(w["accrued"]) == 0, "%s week %d clears the accrual" % [label, i + 1])


## Day 40 is a Saturday. The next week Sim closes is day 42, then 49, then the bill on day 56.
func _mid_bill(start_day: int) -> void:
	var c := Career.quick_start()
	c.seed = 1
	while c.day < start_day:
		Sim.step_day(c)
	_check(c.day == start_day, "reached day %d" % start_day)
	var pred: Array = CashForecast.project(c, 8)
	var bill: Dictionary = {}
	for w in pred:
		if int(w["day"]) == 56 and int(w["billed"]) > 0:
			bill = w
	_check(not bill.is_empty(), "day %d forecast holds a bill on day 56" % start_day)
	var expect := int(bill.get("cash", -1))
	while c.day < 56:
		Sim.step_day(c)
	_check(c.day == 56 and c.cash == expect, "day %d cash on day 56 is %d, forecast %d" % [start_day, c.cash, expect])
	var split: Dictionary = CashForecast.bill_split(pred)
	_check(int(split["day"]) > start_day and int(split["amount"]) > 0, "day %d bill split is a real bill (%s, %d)" % [start_day, str(split["day"]), int(split["amount"])])


## A losing week opened mid-week must count the month bill. A week-end day stays on the old step.
func _runway_days() -> void:
	var mid: Dictionary = WeekRead.runway(2000, 0, 800, 1000, 40, 0)
	_check(int(mid["net"]) < 0 and int(mid["weeks"]) >= 0, "day 40 with a loss returns weeks, not an open end: %s" % str(mid["text"]))
	_check(str(mid["text"]).find("grows") < 0, "day 40 does not say the cash grows: %s" % str(mid["text"]))
	var sat: Dictionary = WeekRead.runway(2000, 0, 800, 1000, 41, 0)
	_check(int(sat["net"]) < 0 and int(sat["weeks"]) >= 0 and str(sat["text"]).find("grows") < 0, "day 41 counts the bill: %s" % str(sat["text"]))
	for day in [21, 28, 35, 42]:
		var got: Dictionary = WeekRead.runway(2000, 0, 800, 1000, day, 0)
		var old := _old_weeks(2000, 0, 800, 1000, day, 0)
		_check(int(got["weeks"]) == old, "boundary day %d runway is unchanged (%d vs %d)" % [day, int(got["weeks"]), old])


func _old_weeks(cash: int, accrued: int, income: int, costs: int, day: int, weeks_below: int) -> int:
	var now := cash
	var owed := accrued
	var below := weeks_below
	var dry := 0 if cash < 0 else -1
	var close := 0 if weeks_below >= GymBills.CLOSE_AFTER_WEEKS else -1
	for w in range(1, WeekRead.RUNWAY_WEEKS + 1):
		if close >= 0:
			break
		var s: Dictionary = GameMoney.settle_week(now, owed, income, costs, day + 7 * w)
		now = int(s["cash"])
		owed = int(s["accrued"])
		below = GymBills.next_below(now, below)
		if now < 0 and dry < 0:
			dry = w
		if below >= GymBills.CLOSE_AFTER_WEEKS:
			close = w
	return dry
