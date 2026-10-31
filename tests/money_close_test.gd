extends SceneTree
## S324 update 27 money that bites: the weekly clock keeps the weeks below $0 and closes the gym at the fourth, the close
## need and screen take over, the clock stops; the control arm (a rich gym) never closes. Prints MONEY_CLOSE failures=<n>.

const Sim := preload("res://scripts/state/Sim.gd")
const Needs := preload("res://scripts/state/Needs.gd")
const GymBills := preload("res://scripts/rules/GymBills.gd")
const MainScript := preload("res://scripts/ui/Main.gd")

var failures := 0


func _check(ok: bool, what: String) -> void:
	if ok:
		print("  ok: ", what)
	else:
		failures += 1
		print("  FAIL: ", what)


func _initialize() -> void:
	var c := Career.quick_start()
	_check(c.cash == Career.start_cash() and c.cash == 14600, "a new career starts on 3 months of costs: %d" % c.cash)
	_check(not c.closed and c.weeks_below == 0, "a new gym is open, no weeks below $0")
	c.cash = -20000
	var below: Array = []
	for d in 56:
		Sim.step_day(c)
		if c.day % 7 == 0:
			below.append(c.weeks_below)
			c.review_pending = false
	_check(below == [1, 2, 3, 4, 5, 6, 7, 8], "weeks below $0 count up each week end: %s" % str(below))
	_check(c.closed, "the eighth week below $0 closes the gym (S327, was the fourth)")
	_check(c.news.any(func(x): return str(x["t"]).contains("closed its doors")), "the news says it closed")
	var n: Array = Needs.needs(c)
	_check(n.size() == 1 and str(n[0]["act"]) == "closedgym" and bool(n[0]["red"]), "the close is the only need, and it blocks")
	_check(Needs.flags(c).any(func(x): return str(x["t"]) == "GYM CLOSED"), "the top bar flags GYM CLOSED")
	_check(Clock.stop_now(c), "the clock stops on a closed gym")
	var m: Dictionary = MainScript.closed_modal(c)
	_check(bool(m["locked"]) and (m["buttons"] as Array).size() == 3 and str(m["body"]).contains("closed on"), "the close screen: summary, three ways on, cannot be dismissed")

	# One week below $0 warns (red flag) but never blocks time - the player must be able to play out of it.
	var r := Career.quick_start()
	r.cash = -10
	r.weeks_below = 1
	_check(Needs.money_status(r) == "red", "below $0 reads red")
	_check(Needs.blockers(r).filter(func(x): return str(x["act"]) == "closedgym").is_empty() and not Needs.needs(r).filter(func(x): return str(x["t"]).begins_with("Money:")).is_empty(), "red money is a need, not a blocker")
	_check(Needs.flags(r).any(func(x): return str(x["t"]) == "BELOW $0"), "the top bar flags BELOW $0")

	# Control arm: a rich gym runs the same 56 days and never closes.
	var k := Career.quick_start()
	k.cash = 1000000
	for d in 56:
		Sim.step_day(k)
		k.review_pending = false
	_check(not k.closed and k.weeks_below == 0, "control: a rich gym never closes")
	_check(Sim.weekly_costs(k).has("rent") and int(Sim.weekly_costs(k)["rent"]) == int(GymBills.week({})["rent"]), "the bills carry the real rent line")
	# S327: a sponsor on offer is a need (the money the player may not know about); signed, the line goes.
	var sp := Career.quick_start()
	var waiting := Needs.needs(sp).filter(func(x): return str(x["t"]).begins_with("A sponsor is waiting"))
	_check(waiting.size() == 1 and str(waiting[0]["arg"]) == "money:3" and not bool(waiting[0]["red"]), "an open sponsor offer is a need that opens Deals: %s" % str(waiting))
	for d in sp.deals:
		if str(d["state"]) == "offer":
			d["state"] = "signed"
	_check(Needs.needs(sp).filter(func(x): return str(x["t"]).begins_with("A sponsor is waiting")).is_empty(), "control: signed, the sponsor line goes")
	print("MONEY_CLOSE failures=%d" % failures)
	quit(1 if failures > 0 else 0)
