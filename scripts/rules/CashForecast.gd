extends RefCounted
## Eight weeks of cash if the gym changes nothing. Income lands every week. Costs only leave the tin on the
## month bill (GameMoney.settle_week): a week that is not a bill day adds the income and accrues the costs,
## and a bill day pays the accrual once. Counting the week's costs in the cash as well would charge them twice.
## Each step lands on a week end (a multiple of 7), which is when Sim closes the week. From a Saturday (day 40)
## the first close is day 42, not day 47, so the month bill on day 56 is in the run. The run grows past `weeks`
## until that bill is in it.

const Sim := preload("res://scripts/state/Sim.gd")
const GameMoney := preload("res://scripts/rules/GameMoney.gd")
const Membership := preload("res://scripts/rules/Membership.gd")
const GymBonus := preload("res://scripts/rules/GymBonus.gd")
const GymSpend := preload("res://scripts/state/GymSpend.gd")
const GymBills := preload("res://scripts/rules/GymBills.gd")
const BjjSide := preload("res://scripts/rules/BjjSide.gd")
const Overdraft := preload("res://scripts/rules/Overdraft.gd")
const FirstWeek := preload("res://scripts/rules/FirstWeek.gd")
const BoutRules := preload("res://scripts/rules/BoutRules.gd")

const WEEKS := 8


## [{w, day, cash, accrued, billed, income, costs, extra, cash_before, accrued_before, rent, coach, staff, stipends, other, members}]
## Does not change `c`.
static func project(c: Career, weeks: int = WEEKS) -> Array:
	var n := maxi(1, weeks)
	var out := _project(c, n)
	var extra := 0
	while extra < 16 and not _has_bill(out):
		extra += 1
		n += 1
		out = _project(c, n)
	return out


static func _project(c: Career, weeks: int) -> Array:
	var copy := _copy(c)
	var out: Array = []
	for i in weeks:
		var cash_before := copy.cash
		var accrued_before := copy.accrued
		copy.day = _week_end(c.day, i + 1)
		var roll: Dictionary = Membership.settle_week(copy.members, copy.reputation, GymSpend.member_cap(copy), copy.dues_band, GymBonus.members(copy.gym_plan))
		copy.members = int(roll["members"])
		var income: Dictionary = Sim.weekly_income(copy)
		var costs: Dictionary = Sim.weekly_costs(copy)
		if copy.bjj_on():
			BjjSide.week(copy.bjj_side, copy.bjj_teaches())
		var settled: Dictionary = GameMoney.settle_week(copy.cash, copy.accrued, int(income["total"]), int(costs["total"]), copy.day)
		copy.loan_weeks = maxi(0, copy.loan_weeks - 1)
		copy.cash = int(settled["cash"])
		copy.accrued = int(settled["accrued"])
		var extra := 0
		if copy.overdraft_on and copy.cash < 0:
			var interest := Overdraft.weekly_interest(copy.cash)
			copy.cash -= interest
			extra -= interest
		_overdraft(copy, int(income["total"]))
		var before_course := copy.cash
		GymSpend.end_week(copy)
		extra += copy.cash - before_course
		var week_n := int(floor(float(copy.day - 1) / 7.0)) + 1
		FirstWeek.end_of_week(copy, week_n)
		var rent := int(costs.get("rent", 0))
		var coach := int(costs.get("staff", 0))
		var staff := int(costs.get("staff_roles", 0))
		var stip := int(costs.get("fighters", 0))
		var other := int(costs["total"]) - rent - coach - staff - stip
		out.append({
			"w": Clock.week_of(c.day) + i + 1,
			"day": copy.day,
			"cash": copy.cash,
			"accrued": copy.accrued,
			"billed": int(settled["billed"]),
			"income": int(income["total"]),
			"costs": int(costs["total"]),
			"extra": extra,
			"cash_before": cash_before,
			"accrued_before": accrued_before,
			"rent": rent,
			"coach": coach,
			"staff": staff,
			"stipends": stip,
			"other": other,
			"members": copy.members,
		})
	return out


## 1-based. On a week-end day this is `day + 7 * w`, the same step as a call made on that day used to take.
static func _week_end(day: int, w: int) -> int:
	if day % 7 == 0:
		return day + 7 * w
	return day + (7 - day % 7) + 7 * (w - 1)


static func _has_bill(ahead: Array) -> bool:
	for w in ahead:
		if int(w["billed"]) > 0:
			return true
	return false


## The next month bill in `ahead`, split so the lines add up to the amount paid.
static func bill_split(ahead: Array) -> Dictionary:
	var rent := 0
	var coach := 0
	var staff := 0
	var stip := 0
	var other := 0
	var ran := 0
	var amount := 0
	var day := 0
	for w in ahead:
		rent += int(w["rent"])
		coach += int(w["coach"])
		staff += int(w["staff"])
		stip += int(w["stipends"])
		other += int(w["other"])
		ran += int(w["costs"])
		if int(w["billed"]) > 0:
			amount = int(w["billed"])
			day = int(w["day"])
			break
	if amount > ran:
		other += amount - ran
	return {"day": day, "amount": amount, "rent": rent, "coach": coach, "staff": staff, "stipends": stip, "other": other}


## Numbered marks on the dotted weeks: bill days, and a booked fight's ticket cut (paid on fight night, not in the tin yet).
static func markers(c: Career, past_n: int, ahead: Array) -> Array:
	var out: Array = []
	var n := 1
	var end_day := c.day
	for i in ahead.size():
		var w: Dictionary = ahead[i]
		end_day = int(w["day"])
		if int(w["billed"]) <= 0:
			continue
		out.append({
			"n": n,
			"i": past_n + i,
			"bill": true,
			"text": "Bills %s, -%s" % [Clock.fmt(int(w["day"])), GameMoney.text(int(w["billed"]))],
		})
		n += 1
	for f in c.fighters:
		var b: Dictionary = f.get("bout", {})
		if b.is_empty() or bool(b.get("done", false)):
			continue
		var day := int(b.get("day", -1))
		if day <= c.day or day > end_day:
			continue
		var idx := past_n
		for i in ahead.size():
			if int(ahead[i]["day"]) >= day:
				idx = past_n + i
				break
		var cut := 0 if b.has("champ") else BoutRules.TICKET_CUT
		var bit := "no ticket cut" if cut == 0 else "+%s on fight night" % GameMoney.text(cut)
		out.append({
			"n": n,
			"i": idx,
			"bill": false,
			"text": "%s, %s, %s" % [str(f.get("first", f.get("name", ""))), Clock.fmt(day), bit],
		})
		n += 1
	return out


static func _overdraft(c: Career, week_income: int) -> void:
	c.income_history = Overdraft.trail(c.income_history, week_income)
	var sum4 := 0
	for x in c.income_history.slice(-4):
		sum4 += int(x)
	var traded := int(floor(float(c.day) / 7.0))
	var lim := Overdraft.limit(sum4, traded) if c.overdraft_on else 0
	c.overdraft_drawn_weeks = Overdraft.next_drawn(c.cash, c.overdraft_drawn_weeks)
	if c.overdraft_on and Overdraft.should_pull(c.overdraft_drawn_weeks):
		c.overdraft_on = false
		c.overdraft_drawn_weeks = 0
		lim = 0
	c.weeks_below = GymBills.next_below(c.cash, c.weeks_below, lim)


static func _copy(c: Career) -> Career:
	var d := Career.new()
	d.gym_name = c.gym_name
	d.day = c.day
	d.cash = c.cash
	d.accrued = c.accrued
	d.members = c.members
	d.reputation = c.reputation
	d.dues_band = c.dues_band
	d.seed = c.seed
	d.start = c.start
	d.guide = c.guide
	d.loan_weeks = c.loan_weeks
	d.premises = c.premises
	d.kit_level = c.kit_level
	d.extra_coaches = c.extra_coaches
	d.weeks_below = c.weeks_below
	d.overdraft_on = c.overdraft_on
	d.overdraft_drawn_weeks = c.overdraft_drawn_weeks
	d.coach = c.coach.duplicate(true) as Dictionary
	d.fighters = c.fighters.duplicate(true) as Array
	d.grapplers = c.grapplers.duplicate(true) as Array
	d.bjj_side = c.bjj_side.duplicate(true) as Dictionary
	d.deals = c.deals.duplicate(true) as Array
	d.upgrades = c.upgrades.duplicate(true) as Array
	d.staff_roles = c.staff_roles.duplicate()
	d.prospects = c.prospects.duplicate(true) as Array
	d.income_history = c.income_history.duplicate()
	d.first_hour = c.first_hour.duplicate(true) as Dictionary
	d.show = c.show.duplicate(true) as Dictionary
	d.grant = c.grant.duplicate(true) as Dictionary
	d.applicant = c.applicant.duplicate(true) as Dictionary
	d.week_money = {"in": 0, "out": 0}
	return d
