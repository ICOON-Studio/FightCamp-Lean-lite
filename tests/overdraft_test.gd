extends SceneTree
## S399 the arranged overdraft: limit maths (100 % of 4 weeks' income, $100-rounded, 12-week gate), the 1 % arrangement
## fee, the weekly interest (16 % a year on the drawn balance, rounded up to $1), the close-clock with and without the
## facility, the 12-week pull, and the default-off path identical to main for a 52-week scripted career.

const Overdraft := preload("res://scripts/rules/Overdraft.gd")
const GymBills := preload("res://scripts/rules/GymBills.gd")
const Sim := preload("res://scripts/state/Sim.gd")

var failures := 0
var checks := 0


func _check(ok: bool, label: String) -> void:
	checks += 1
	if ok:
		print("  ok: ", label)
	else:
		failures += 1
		print("  FAIL: ", label)


func _initialize() -> void:
	# 1. Limit maths.
	_check(Overdraft.limit(5000, 20) == 5000, "limit: $5,000 income over 20 weeks -> $5,000")
	_check(Overdraft.limit(5050, 20) == 5000, "limit: $5,050 rounds down to $5,000")
	_check(Overdraft.limit(50, 20) == 0, "limit: $50 rounds to $0 (floor to $100)")
	_check(Overdraft.limit(150, 20) == 100, "limit: $150 rounds to $100")
	_check(Overdraft.limit(-100, 20) == 0, "limit: negative income -> $0")
	_check(Overdraft.limit(5000, 11) == 0, "limit: 11 weeks traded -> no overdraft yet")
	_check(Overdraft.limit(5000, 12) == 5000, "limit: 12 weeks traded -> offered")
	_check(Overdraft.limit(0, 20) == 0, "limit: $0 income -> $0")

	# 2. Arrangement fee.
	_check(Overdraft.fee(5000) == 50, "fee: 1 % of $5,000 = $50")
	_check(Overdraft.fee(100) == 1, "fee: 1 % of $100 = $1")
	_check(Overdraft.fee(0) == 0, "fee: no limit, no fee")

	# 3. Weekly interest.
	_check(Overdraft.weekly_interest(-1000) == 4, "interest: $1,000 drawn -> ceil($1000*0.16/52) = $4")
	_check(Overdraft.weekly_interest(-5000) == 16, "interest: $5,000 drawn -> ceil($5000*0.16/52) = $16")
	_check(Overdraft.weekly_interest(-10) == 1, "interest: tiny drawn -> $1 minimum")
	_check(Overdraft.weekly_interest(0) == 0, "interest: $0 cash -> no interest")
	_check(Overdraft.weekly_interest(1000) == 0, "interest: positive cash -> no interest")

	# 4. The close-clock without the overdraft (limit 0) matches GymBills.next_below exactly.
	_check(Overdraft.next_below(-100, 3, 0) == 4, "clock off: below $0 counts up")
	_check(Overdraft.next_below(100, 3, 0) == 0, "clock off: above $0 resets")
	_check(Overdraft.next_below(-100, 3, 0) == GymBills.next_below(-100, 3), "clock off: matches GymBills")
	# 5. The close-clock with the overdraft: within the limit the counter resets (like above $0 without it).
	_check(Overdraft.next_below(-500, 3, 2000) == 0, "clock on: -$500 within $2,000 limit -> resets (safe)")
	_check(Overdraft.next_below(-2500, 3, 2000) == 4, "clock on: -$2,500 beyond $2,000 limit -> counted")
	_check(Overdraft.next_below(100, 3, 2000) == 0, "clock on: positive cash -> reset")
	_check(Overdraft.next_below(-100, 0, 100) == 0, "clock on: -$100 at exact limit -> not counted")
	_check(Overdraft.next_below(-101, 0, 100) == 1, "clock on: -$101 beyond $100 limit -> counted")

	# 6. The drawn counter and the 12-week pull.
	_check(Overdraft.next_drawn(-100, 0) == 1, "drawn: first negative week -> 1")
	_check(Overdraft.next_drawn(-100, 11) == 12, "drawn: 11 -> 12 consecutive negative weeks")
	_check(Overdraft.next_drawn(100, 5) == 0, "drawn: positive week resets")
	_check(Overdraft.should_pull(12) == true, "pull: 12 weeks drawn -> bank pulls")
	_check(Overdraft.should_pull(11) == false, "pull: 11 weeks -> not yet")

	# 7. The 12-week pull through the real weekly step: day must advance so weeks_traded >= 12 and the limit is valid.
	var c := Career.quick_start()
	c.members = 0
	c.cash = -500
	c.overdraft_on = true
	c.income_history = [2000, 2000, 2000, 2000, 2000, 2000, 2000, 2000, 2000, 2000, 2000, 2000]
	for w in 16:
		c.day = (w + 1) * 7
		Sim.end_week(c)
	_check(c.overdraft_on == false, "pull: after 12 negative weeks the bank pulls the facility")
	_check(c.overdraft_drawn_weeks < Overdraft.PULL_AFTER_WEEKS, "pull: the drawn counter was reset (now %d)" % c.overdraft_drawn_weeks)
	_check(c.closed, "pull: the gym closes (weeks_below reached 8 after the pull)")

	# 8. Interest charges through the weekly step and the ledger entry.
	var c2 := Career.quick_start()
	c2.members = 0
	c2.cash = -1000
	c2.overdraft_on = true
	c2.income_history = [2000, 2000, 2000, 2000, 2000, 2000, 2000, 2000, 2000, 2000, 2000, 2000]
	c2.day = 7
	var before := c2.cash
	Sim.end_week(c2)
	var interest := Overdraft.weekly_interest(before)
	_check(c2.ledger.any(func(e): return str(e["t"]).begins_with("Overdraft interest")), "interest: on the ledger")
	_check(interest == 4, "interest: $1,000 drawn at 16 % / 52 = $4 charged")

	# 9. Default-off path: same cash every week for 52 weeks as a career with the flag explicitly off.
	var a := Career.quick_start()
	var b := Career.quick_start()
	b.overdraft_on = false
	for w in 52:
		a.day = (w + 1) * 7
		b.day = (w + 1) * 7
		Sim.end_week(a)
		Sim.end_week(b)
		_check(a.cash == b.cash, "default-off week %d: cash matches (%d vs %d)" % [w + 1, a.cash, b.cash])

	print("OVERDRAFT failures=%d checks=%d" % [failures, checks])
	quit(1 if failures > 0 else 0)
