extends SceneTree
## S373 the offer's weigh-in forecast (Sim.weigh_forecast): Danny walks at 61.6 kg for the men's 60.0 kg and missed weight
## on his first offer with no warning. Population: Danny signed on a quick start, his first even offer; the same boxer
## already at the limit. The forecast must match the days as they really run (accept, camp from tomorrow, step to the
## weigh-in). S374: the offer is dated where his camp cut makes the scale (Bouts.makeable_day) - he makes weight.

const Bouts := preload("res://scripts/state/Bouts.gd")
const Roster := preload("res://scripts/state/Roster.gd")
const Sim := preload("res://scripts/state/Sim.gd")
const BoutRules := preload("res://scripts/rules/BoutRules.gd")
const AmateurBooking := preload("res://scripts/rules/AmateurBooking.gd")

var failures := 0


func _initialize() -> void:
	_matches_the_real_days()
	_at_the_limit()
	_dated_to_make_weight()
	print("WEIGH_FORECAST failures=%d" % failures)
	quit(1 if failures > 0 else 0)


func _check(cond: bool, label: String) -> void:
	if cond:
		print("PASS ", label)
	else:
		failures += 1
		print("FAIL ", label)


func _danny(c: Career) -> Dictionary:
	var p := Roster.prospect(c, "danny")
	p["state"] = "invited"
	var f := Roster.sign_prospect(c, "danny", ["signature"])
	c.day = int(f["next_offer_day"])
	Bouts.day_events(c)
	return f


func _matches_the_real_days() -> void:
	var c := Career.quick_start()
	var f := _danny(c)
	var o: Dictionary = f["offers"][0]
	var wf := Sim.weigh_forecast(c, f, int(o["day"]))
	_check(is_equal_approx(float(wf["now"]), 61.6) and float(wf["day"]) < 61.6 and int(wf["days"]) == int(o["day"]) - 1 - c.day,
		"the forecast cuts from 61.6 to the weigh-in (%.2f kg after %d days)" % [float(wf["day"]), int(wf["days"])])
	_check(float(f["weight"]) == 61.6 and f["bout"].is_empty(), "a forecast changes nothing on the fighter")
	Bouts.accept(c, str(o["id"]))
	Bouts.start_camp(c, f, Sim.focus_of(c, f), 0, false)
	while not Bouts.weigh_in_today(c, f):
		Sim.step_day(c)
	var real := float(f["weight"])
	_check(absf(real - float(wf["day"])) <= 0.25, "the scale reads what the offer forecast (%.2f real vs %.2f forecast)" % [real, float(wf["day"])])
	_check(bool(wf["ok"]) == BoutRules.made_weight(real, float(f["limit"])), "made or missed as forecast (%s)" % str(wf["ok"]))


func _at_the_limit() -> void:
	var c := Career.quick_start()
	var f := _danny(c)
	f["weight"] = float(f["limit"]) - 0.3
	var wf := Sim.weigh_forecast(c, f, int(f["offers"][0]["day"]))
	_check(bool(wf["ok"]) and is_equal_approx(float(wf["over"]), 0.0), "a boxer already under the limit is forecast to make it (%.2f)" % float(wf["day"]))
	var far := Sim.weigh_forecast(c, f, c.day + 1)
	_check(int(far["days"]) == 0 and is_equal_approx(float(far["day"]), float(f["weight"])), "a weigh-in tomorrow leaves no days to cut")


## S374 (operator "Yes, fix it"): Danny's first even offer is dated where the forecast makes the scale, no more than
## WEIGHT_WEEKS_MAX weeks past the usual 2-4; accepted and boxed as dated, he makes weight. At the limit: the usual date.
func _dated_to_make_weight() -> void:
	var c := Career.quick_start()
	var f := _danny(c)
	var o: Dictionary = f["offers"][0]
	var usual := AmateurBooking.fight_day(c.day, AmateurBooking.lead_weeks(str(o["id"])))
	var wf := Sim.weigh_forecast(c, f, int(o["day"]))
	_check(float(wf["day"]) <= float(f["limit"]) and int(o["day"]) > usual and int(o["day"]) <= usual + 7 * Bouts.WEIGHT_WEEKS_MAX,
		"his first offer waits for his cut (%d days out, usual %d; %.2f kg on the day)" % [int(o["day"]) - c.day, usual - c.day, float(wf["day"])])
	_check(int(f["offers"][1]["day"]) == int(o["day"]) + 7, "the mismatch offer keeps its week after")
	Bouts.accept(c, str(o["id"]))
	Bouts.start_camp(c, f, Sim.focus_of(c, f), 0, false)
	while not Bouts.weigh_in_today(c, f):
		Sim.step_day(c)
	_check(Bouts.weigh(c, f), "on the scale he makes weight (%.2f kg, limit %.1f)" % [float(f["weight"]), float(f["limit"])])
	var c2 := Career.quick_start()
	var p := Roster.prospect(c2, "danny")
	p["state"] = "invited"
	var g := Roster.sign_prospect(c2, "danny", ["signature"])
	g["weight"] = float(g["limit"]) - 0.4
	c2.day = int(g["next_offer_day"])
	Bouts.day_events(c2)
	var o2: Dictionary = g["offers"][0]
	_check(int(o2["day"]) == AmateurBooking.fight_day(c2.day, AmateurBooking.lead_weeks(str(o2["id"]))), "a boxer at his limit keeps the usual date")
