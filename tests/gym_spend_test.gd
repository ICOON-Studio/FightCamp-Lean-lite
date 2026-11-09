extends SceneTree
## S397 money bites (ops/research/MONEY_BITES_S397.md 7.1): the pure rules (GymUpgrades, StaffRoles, ClubShow, StarDeal,
## GymBills' new bills, Membership's cap) and the career glue (GymSpend, HomeJuniors). Each effect is checked against a
## control arm that cannot share it. Prints GYM_SPEND failures=<n>.

const GymUpgrades := preload("res://scripts/rules/GymUpgrades.gd")
const StaffRoles := preload("res://scripts/rules/StaffRoles.gd")
const ClubShow := preload("res://scripts/rules/ClubShow.gd")
const StarDeal := preload("res://scripts/rules/StarDeal.gd")
const GymBills := preload("res://scripts/rules/GymBills.gd")
const Membership := preload("res://scripts/rules/Membership.gd")
const InjuryRoll := preload("res://scripts/rules/InjuryRoll.gd")
const GymSpend := preload("res://scripts/state/GymSpend.gd")
const HomeJuniors := preload("res://scripts/state/HomeJuniors.gd")
const Roster := preload("res://scripts/state/Roster.gd")
const Sim := preload("res://scripts/state/Sim.gd")
const Grants := preload("res://scripts/rules/Grants.gd")

var failures := 0


func _check(ok: bool, what: String) -> void:
	if ok:
		print("  ok: ", what)
	else:
		failures += 1
		print("  FAIL: ", what)


func _initialize() -> void:
	_upgrades()
	_staff()
	_show()
	_star()
	_bills()
	_career()
	_juniors()
	_stipend()
	_dues_and_grants()
	print("GYM_SPEND failures=%d" % failures)
	quit(1 if failures > 0 else 0)


func _upgrades() -> void:
	var owned := [{"id": "mats", "day": 10}]
	_check(not GymUpgrades.ready(owned, "mats", 16) and GymUpgrades.ready(owned, "mats", 17), "an upgrade works a week after it is bought")
	_check(is_equal_approx(GymUpgrades.mult(owned, "train_risk", 16), 1.0) and is_equal_approx(GymUpgrades.mult(owned, "train_risk", 20), 0.85),
		"the floor cuts training risk only once fitted (x1.0 then x0.85)")
	_check(GymUpgrades.blocked("mats", owned, 99999) == "owned" and GymUpgrades.blocked("strength", owned, 100) != "" and GymUpgrades.blocked("strength", owned, 3600) == "",
		"bought once; not without the cash; yes with it")
	var st := [{"id": "strength", "day": 0}]
	_check(is_equal_approx(GymUpgrades.gain_mult(st, "power", 30), 1.1) and is_equal_approx(GymUpgrades.gain_mult(st, "speed", 30), 1.0),
		"the strength corner lifts power, not speed (control)")
	_check(GymUpgrades.upkeep([{"id": "mats", "day": 0}, {"id": "strength", "day": 0}]) == 37, "upkeeps add up: 15 + 22")
	_check(GymUpgrades.move_blocked(0, 11999) != "" and GymUpgrades.move_blocked(0, 12000) == "" and GymUpgrades.move_blocked(2, 999999) != "",
		"a move needs its cost; the top premises has no move")
	var caps: Array = GymUpgrades.PREMISES.map(func(p): return int(p["cap"]))
	var rents: Array = GymUpgrades.PREMISES.map(func(p): return int(p["rent"]))
	_check(caps[0] < caps[1] and caps[1] < caps[2] and rents[0] < rents[1] and rents[1] < rents[2], "bigger premises hold more and cost more rent")
	# Round 1 (economist): the fitness classes are the one investment that earns; with their assistant coach about +$130.
	var fit := int(GymUpgrades.item("fitkit")["value"]) - int(GymUpgrades.item("fitkit")["upkeep"]) - int(StaffRoles.role("assistant")["wage"])
	_check(fit > 0 and fit < 200, "fitness classes net of kit and assistant: +%d a week, not a money press" % fit)


func _staff() -> void:
	_check(StaffRoles.wages(["assistant", "strength", "physio", "cutman"]) == 455 and StaffRoles.per_bout(["cutman"]) == 150, "wages a week 455; the cutman by the night")
	_check(StaffRoles.notice("assistant") == 280 and StaffRoles.notice("cutman") == 0, "letting go costs a week's pay (the cutman nothing)")
	_check(StaffRoles.places(["assistant"]) == 1 and StaffRoles.places(["physio"]) == 0, "the assistant coach opens a place, the physio does not")


func _show() -> void:
	var small := ClubShow.preview(40, 10, 0, 1)
	var grown := ClubShow.preview(120, 80, 20, 3)
	_check(small["net_lo"] < 0, "a young club's show can lose money: %d" % int(small["net_lo"]))
	_check(grown["net_lo"] > 0 and grown["net_mid"] > small["net_mid"], "a grown club's show pays: %d > %d" % [int(grown["net_mid"]), int(small["net_mid"])])
	var with_juniors := ClubShow.sold(60, 20, 20, 1, 1.0)
	var without := ClubShow.sold(60, 20, 0, 1, 1.0)
	_check(with_juniors > without, "juniors' families sell tickets: %d > %d" % [with_juniors, without])
	var bad := ClubShow.night(40, 10, 0, 0, ClubShow.LUCK.x, ClubShow.RAFFLE.x)
	_check(int(bad["net"]) < 0 and int(bad["members"]) == 0, "a thin night loses money and brings nobody in")
	_check(ClubShow.can_book(0, -1, -1) and not ClubShow.can_book(10, 33, -1) and not ClubShow.can_book(60, -1, 33)
		and ClubShow.can_book(33 + ClubShow.EVERY_DAYS - ClubShow.LEAD_DAYS, -1, 33), "one show at a time, EVERY_DAYS apart")
	_check(posmod(ClubShow.show_day(3), 7) == 5 and ClubShow.show_day(3) >= 3 + ClubShow.LEAD_DAYS - 6, "the show is on a Saturday about four weeks out")


func _star() -> void:
	# Success is never punished (round 1, economist): on one share the gym's net a bout rises with the rank.
	var last := -999999
	var rising := true
	for rank in [20, 15, 10, 5, 1]:
		var purse: int = 1500 + 400 * (21 - int(rank))
		var net := StarDeal.gym_net(purse, 2000, StarDeal.START)
		rising = rising and net > last
		last = net
	_check(rising, "the gym's net a bout rises with the rank on one share")
	var lower_top := StarDeal.gym_net(1500 + 400 * 16, 2500, 0.20)
	var start_15 := StarDeal.gym_net(1500 + 400 * 6, 2000, StarDeal.START)
	_check(lower_top > start_15, "even on the lower share a rank-5 pro pays more than a rank-15 one: %d > %d" % [lower_top, start_15])
	var f := {}
	_check(StarDeal.due(f, 12, "") == "" and StarDeal.due(f, 9, "") == "top10" and StarDeal.due(f, 3, "wbc") == "belt", "talks at the top 10 and at a belt")
	f["renewed"] = ["top10"]
	_check(StarDeal.due(f, 4, "") == "", "the top-10 talks happen once")
	_check(StarDeal.camp_bill(10000, true) * 2 == StarDeal.camp_bill(10000, false), "the S&C coach halves the camp bill")


func _bills() -> void:
	var jan := GymBills.week({"members": 50, "month": 1})
	var jul := GymBills.week({"members": 50, "month": 7})
	_check(int(jan["power"]) > int(jul["power"]) and int(jan["costs"]) > int(jul["costs"]), "winter heating costs more than summer: %d > %d" % [int(jan["power"]), int(jul["power"])])
	_check(int(jan["insurance"]) == 24, "insurance by the week: $1,250 a year")
	var big := GymBills.week({"members": 50, "month": 7, "rent_month": 3400})
	_check(int(big["rent"]) > int(jul["rent"]), "bigger premises' rent is billed")
	_check(int(Membership.settle_week(70, 200, 70)["target"]) == 70 and int(Membership.settle_week(70, 200)["target"]) > 70,
		"the premises cap the members (control: no cap, more)")
	_check(InjuryRoll.training_chance(12.0, 1.0, 0.0, 0.75) < InjuryRoll.training_chance(12.0, 1.0, 0.0), "the gym's risk multiplier lowers the training chance")


func _career() -> void:
	var c := Career.quick_start()
	c.gym_slots = []   # S415 this test is about premises and coaches; the floor's own limit is gym_slots_test
	_check(c.cash == Career.start_cash(), "a new career starts on the start cash: %d" % c.cash)
	var base_cost := int(Sim.weekly_costs(c)["total"])
	c.cash = 50000
	_check(GymSpend.buy(c, "mats") == "" and c.cash == 47600 and GymUpgrades.has(c.upgrades, "mats"), "buying pays the price")
	_check(int(Sim.weekly_costs(c)["total"]) == base_cost + 15, "its upkeep joins the week's costs")
	_check(GymSpend.hire(c, "strength") == "" and int(Sim.weekly_costs(c)["total"]) == base_cost + 115, "a staff wage joins the week's costs")
	c.day = 30
	_check(is_equal_approx(GymSpend.train_risk(c), 0.85 * 0.85), "floor and S&C cut the risk together: x%.2f" % GymSpend.train_risk(c))
	GymSpend.set_kit(c, "good")
	_check(is_equal_approx(GymSpend.train_risk(c), maxf(0.85 * 0.85 * 0.9, StaffRoles.RISK_FLOOR)) and GymSpend.train_risk(c) >= StaffRoles.RISK_FLOOR,
		"with Good kit too: all three cuts together, never below the floor (x%.3f)" % GymSpend.train_risk(c))
	GymSpend.set_kit(c, "low")
	_check(GymSpend.train_risk(c) > 0.85 * 0.85 and int(GymSpend.costs(c)["kit"]) == 0, "Low kit spends nothing and adds risk")
	GymSpend.set_kit(c, "standard")
	# Round 2: coaches carry members. No coach: the volunteers only; a coach and an evening coach carry more, at a wage.
	_check(GymSpend.coaching_cap(c) == 70, "no coach hired: you and the volunteers carry 70")
	c.coach = {"name": "Luke Reid", "salary": 450}
	_check(GymSpend.coaching_cap(c) == 110 and GymSpend.member_cap(c) == 70, "a hired coach: 110 carried, the unit's room 70 holds")
	var w0 := int(Sim.weekly_costs(c)["total"])
	GymSpend.evening_coach(c, 1)
	_check(GymSpend.coaching_cap(c) == 150 and int(Sim.weekly_costs(c)["total"]) == w0 + StaffRoles.EVENING_WAGE,
		"an evening coach carries 40 more at $280 a week")
	var cash0 := c.cash
	_check(GymSpend.evening_coach(c, -1) == "" and c.cash == cash0 - StaffRoles.EVENING_WAGE and c.extra_coaches == 0, "letting the evening coach go: a week's pay")
	c.coach = {}
	var cash := c.cash
	_check(GymSpend.let_go(c, "strength") == "" and c.cash == cash - 100 and not c.staff_roles.has("strength"), "letting go costs a week's pay")
	# Places: 3 at the start; boxers and no-gi athletes both take one.
	c.grapplers = [{"id": "g1"}]
	c.fighters = [{"id": "a"}, {"id": "b"}]
	_check(GymSpend.place_blocked(c) != "" and not Roster.invite(c, str(c.prospects[0]["id"])), "a full roster turns a trial away")
	GymSpend.hire(c, "assistant")
	_check(GymSpend.place_blocked(c) == "", "an assistant coach opens a place")
	_check(GymSpend.move(c) == "" and c.premises == 1 and GymSpend.places(c) == 6 and int(GymSpend.premises(c)["cap"]) == 140, "a move opens places and room")
	_check(c.deals.any(func(d): return str(d["id"]) == "thamesgate" and str(d["state"]) == "offer"), "a bigger place brings a bigger sponsor")
	# Fitness classes need the kit AND the assistant coach.
	GymSpend.buy(c, "fitkit")
	c.day += 7
	_check(int(Sim.weekly_income(c)["fitness"]) == 420, "fitness classes with kit and assistant: +420")
	GymSpend.let_go(c, "assistant")
	_check(int(Sim.weekly_income(c)["fitness"]) == 0, "control: no assistant, no classes")
	# A club show: paid now, the night pays (or not) on the day.
	var before := c.cash
	_check(GymSpend.book_show(c) == "" and c.cash == before - ClubShow.COST, "booking a show pays the hall")
	_check(GymSpend.book_show(c) != "", "one show at a time")
	c.day = int(c.show["day"])
	var at := c.cash
	GymSpend.day_events(c)
	_check(c.cash > at and int(c.show["day"]) == -1 and not (c.show["night"] as Dictionary).is_empty(), "the night's tickets and raffle come in")
	# Contract talks: keep the share for the bonus, or take the lower one.
	var f := {"id": "p", "first": "Lucy", "pro": true}
	c.fighters = [f]
	GymSpend.check_talks(c, f, 8, "")
	_check(not (f["talks"] as Dictionary).is_empty(), "a top-10 pro opens talks")
	var pre := c.cash
	_check(GymSpend.answer_talks(c, f, true) == "" and c.cash == pre - 2500 and is_equal_approx(StarDeal.share(f), 0.25), "keep: the bonus is paid, the share stays")
	GymSpend.check_talks(c, f, 2, "wbc")
	_check(GymSpend.answer_talks(c, f, false) == "" and is_equal_approx(StarDeal.share(f), 0.17) and Roster.gym_cut(10000, f) == 1700, "lower: the belt share is 17% of the purse")
	_check(Roster.gym_cut(10000) == 2500, "control: without a fighter the cut is the start share")


func _dues_and_grants() -> void:
	_check(Membership.natural_members(30, "cheap") > Membership.natural_members(30) and Membership.natural_members(30, "premium") < Membership.natural_members(30),
		"cheap dues draw more members, premium fewer")
	_check(Membership.natural_members(100, "premium") == Membership.natural_members(100), "a famous gym (reputation 100) charges premium without losing members")
	_check(Membership.weekly_dues(60, "premium") > Membership.weekly_dues(60) and Membership.weekly_dues(60) == Membership.weekly_dues(60, "standard"),
		"premium dues bring more a member")
	_check(Grants.blocked(0, {}, false, true) != "" and Grants.blocked(0, {}, true, false) != "" and Grants.blocked(0, {}, true, true) == "",
		"a grant bid needs a youth section and a second coach")
	_check(Grants.blocked(100, {"last": 0}, true, true) != "" and Grants.blocked(400, {"last": 0}, true, true) == "", "one bid a year")
	var c := Career.quick_start()
	c.cash = 50000
	c.staff_roles = ["assistant"]
	c.upgrades = [{"id": "youth", "day": -30}]
	var cash := c.cash
	_check(GymSpend.grant_bid(c) == "" and c.cash == cash and c.grant.has("due"), "a bid goes in, free")
	c.day = int(c.grant["due"])
	var won := bool(c.grant["won"])
	GymSpend.day_events(c)
	_check((c.cash > cash) == won and not c.grant.has("due"), "the answer: the money if it won, nothing if not")
	# Yearly contract talks priced on last year's take.
	var f := {"id": "p", "first": "Lucy", "pro": true, "renewed": ["top10"], "talks_day": 0, "gym_share": 0.25}
	_check(StarDeal.due(f, 8, "", 100) == "" and StarDeal.due(f, 8, "", 364) == "year", "after the first talks, the contract comes up each year")
	var t := StarDeal.terms(f, "year", 10000)
	_check(int(t["bonus"]) == 4000 and is_equal_approx(float(t["lower"]), 0.23), "the yearly ask: 40% of last year's take, or two points off")


func _stipend() -> void:
	var c := Career.quick_start()
	var f := {"id": "x", "first": "Mia", "weekly_salary": 250, "stats": {}}
	c.fighters = [f]
	_check(GymSpend.set_stipend(c, f, false) == "" and int(f["weekly_salary"]) == 0 and bool(f["day_job"]), "off the stipend: a day job, nothing paid")
	_check(is_equal_approx(GymSpend.gain(c, "power", f), GymSpend.DAY_JOB_GAIN) and is_equal_approx(GymSpend.gain(c, "power", {}), 1.0),
		"a day job trains evenings: 15% less gain (control: full time)")
	_check(GymSpend.set_stipend(c, f, true) == "" and int(f["weekly_salary"]) == 250 and not bool(f["day_job"]), "back on the stipend: $250, full time")
	_check(GymSpend.set_stipend(c, {"pro": true}, false) != "", "a pro has no stipend to stop")


func _juniors() -> void:
	var total := 0
	var home_ok := true
	var last: Career = null
	for sd in 10:
		var c := Career.quick_start()
		c.seed = 1000 + sd
		c.cash = 50000
		GymSpend.buy(c, "youth")
		for d in 728:   # two years of week ends (intakes at weeks 35, 53, 87: three rolls)
			c.day = d
			if d % 7 == 0 and d > 0:
				HomeJuniors.end_week(c, GymSpend.youth_on(c), true)
		var home: Array = c.prospects.filter(func(p): return bool(p.get("home", false)))
		total += home.size()
		home_ok = home_ok and home.all(func(p): return int(p["pot"]) >= 84)
		if not home.is_empty():
			last = c
	_check(total >= 5 and total <= 25, "home-grown prospects at the term intakes: %d in 10 two-year careers (expect ~13)" % total)
	_check(home_ok, "each has the potential bonus")
	var none := Career.quick_start()
	for d in 728:
		none.day = d
		if d % 7 == 0 and d > 0:
			HomeJuniors.end_week(none, GymSpend.youth_on(none), true)
	_check(none.prospects.filter(func(p): return bool(p.get("home", false))).is_empty(), "control: no youth section, no home-grown prospect")
	if last != null:
		var raw: Dictionary = last.prospects.filter(func(p): return bool(p.get("home", false)))[0]
		var f := {"weekly_salary": 250}
		HomeJuniors.on_sign(last, raw, f)
		_check(int(f["weekly_salary"]) == 125 and bool(f["home"]), "a home-grown signing starts on half the stipend")
