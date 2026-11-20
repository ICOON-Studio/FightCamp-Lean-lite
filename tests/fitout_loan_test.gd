extends SceneTree
## S531 GROWTH_SCOPE (owner: "Yes, build the loan"): a gym too poor for the $12,000 move moves on the fit-out loan, pays it
## by the week with the bills for 52 weeks through the game's own day loop, and the line stops. Control arm: the cash move
## stays refused at the same cash, and a second loan is refused while one runs.

const Sim := preload("res://scripts/state/Sim.gd")
const GymSpend := preload("res://scripts/state/GymSpend.gd")
const GymUpgrades := preload("res://scripts/rules/GymUpgrades.gd")
const CashForecast := preload("res://scripts/rules/CashForecast.gd")

var failures := 0


func _check(ok: bool, what: String) -> void:
	print("%s %s" % ["ok  " if ok else "FAIL", what])
	if not ok:
		failures += 1


func _initialize() -> void:
	var c := Career.quick_start()
	c.cash = 6000
	c.reputation = 120   # a name that draws past the 70-member unit
	c.members = GymSpend.member_cap(c)
	_check(GymSpend.room_line(c).begins_with("Your name draws"), "the members line says the room holds them back (%s)" % GymSpend.room_line(c))
	_check(GymUpgrades.move_blocked(c.premises, c.cash) != "", "control: $6,000 cannot pay the $12,000 move")
	_check(GymSpend.move(c) != "" and c.premises == 0, "control: the cash move is refused")
	var before := c.cash
	var costs0 := int(Sim.weekly_costs(c)["total"])
	_check(GymSpend.move(c, true) == "", "the move on the loan goes through")
	_check(c.premises == 1 and c.cash == before - 3000 and c.fitout_weeks == 52, "moved, $3,000 down, 52 weeks to pay (cash %d)" % c.cash)
	_check(str(c.ledger[0]["t"]).begins_with("Fit-out loan deposit") and int(c.ledger[0]["amount"]) == -3000, "deposit on the ledger")
	_check(c.deals.any(func(d): return str(d["id"]) == "thamesgate"), "the size sponsor comes to the table")
	var w := Sim.weekly_costs(c)
	_check(int(w["fitout"]) == 173, "a week of the loan: $173 ($750 a month)")
	_check(int(w["total"]) - costs0 >= 173, "the week's costs carry the loan and the new rent")
	_check(GymSpend.move(c, true) != "", "a second loan is refused while one runs")
	var ahead: Array = CashForecast.project(c, 8)
	_check(ahead.size() >= 8 and c.fitout_weeks == 52, "the forecast counts the loan without changing the career")
	c.cash = 200000   # keep the gym open: this walks the loan, not survival
	var paid_weeks := 0
	for d in 52 * 7 + 14:
		var had := c.fitout_weeks
		Sim.step_day(c)
		if c.fitout_weeks < had:
			paid_weeks += 1
	_check(paid_weeks == 52 and c.fitout_weeks == 0, "52 weeks paid, then the loan is done (%d)" % paid_weeks)
	_check(int(Sim.weekly_costs(c)["fitout"]) == 0, "no loan line after the last week")
	_check(GymUpgrades.loan_blocked(c.premises, c.cash, c.fitout_weeks) == "", "a paid-off gym may borrow for the next move")
	print("FITOUT_LOAN failures=%d" % failures)
	quit(0 if failures == 0 else 1)
