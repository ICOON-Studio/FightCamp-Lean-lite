extends SceneTree
## S485 CLUBWEEK1: loyalty moves in the game (LoyaltyWire): the sponsorship given +5 / pulled -8 through the Money act
## (GymSpend.set_stipend), the Monday drift +1 up to 60, and wants_sponsor -3 for a top prospect 8+ weeks on a day job.

const Data := preload("res://scripts/state/Data.gd")
const Sim := preload("res://scripts/state/Sim.gd")
const GymSpend := preload("res://scripts/state/GymSpend.gd")
const Loyalty := preload("res://scripts/rules/Loyalty.gd")
const LoyaltyWire := preload("res://scripts/state/LoyaltyWire.gd")

var failures := 0


func _check(ok: bool, what: String) -> void:
	print("%s %s" % ["ok  " if ok else "FAIL", what])
	if not ok:
		failures += 1


func _initialize() -> void:
	var c := Career.quick_start()
	c.seed = 7
	if c.fighters.is_empty():
		c.fighters.append(Data.fighter_state(Data.lucy(), c.day))
	var f: Dictionary = c.fighter()
	f["loyalty"] = 55
	f["day_job"] = false
	var why := GymSpend.set_stipend(c, f, false)
	_check(why == "", "the stipend comes off (%s)" % why)
	_check(Loyalty.value(f) == 47, "sponsorship pulled: 55 -> 47 (%d)" % Loyalty.value(f))
	GymSpend.set_stipend(c, f, true)
	_check(Loyalty.value(f) == 52, "sponsorship given: 47 -> 52 (%d)" % Loyalty.value(f))
	# The Monday drift through the real day loop.
	var before := Loyalty.value(f)
	var start := c.day
	while c.day < start + 7 or c.day % 7 != 1:
		Sim.step_day(c)
		c.review_pending = false
	var drifted := Loyalty.reasons(f, start + 1).any(func(m): return str(m["why"]) == "full_week")
	_check(drifted, "a Monday in the day loop logs the full week (%d -> %d)" % [before, Loyalty.value(f)])
	# Never past 60.
	var g := {"loyalty": 60, "pot": 50}
	c.fighters.append(g)
	LoyaltyWire.week(c)
	_check(Loyalty.value(g) == 60, "the drift stops at 60 (%d)" % Loyalty.value(g))
	# wants_sponsor: pot 84 on a day job 8 weeks.
	var p := {"loyalty": 70, "pot": 84, "day_job": true, "day_job_since": c.day - 56}
	_check(LoyaltyWire.wants_sponsor(p, c.day), "a pot-84 boxer on a day job 8 weeks wants the sponsorship")
	_check(not LoyaltyWire.wants_sponsor({"pot": 84, "day_job": true, "day_job_since": c.day - 49}, c.day), "not at 7 weeks")
	_check(not LoyaltyWire.wants_sponsor({"pot": 70, "day_job": true, "day_job_since": 0}, c.day), "not at pot 70")
	c.fighters.append(p)
	LoyaltyWire.week(c)
	_check(Loyalty.value(p) == 67, "wants_sponsor costs 3 a week (70 -> %d)" % Loyalty.value(p))
	_check(Loyalty.value({"pro": true, "loyalty": 40}) == 40, "a pro is not moved")
	print("LOYALTY_WIRE %s fails=%d" % ["PASS" if failures == 0 else "FAIL", failures])
	quit(0 if failures == 0 else 1)
