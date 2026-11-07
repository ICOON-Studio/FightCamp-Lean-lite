extends SceneTree
## S398 rank 5 probe: the first hour's calendar today - when the first offer comes, its bout day, the weight forecast.

const Sim := preload("res://scripts/state/Sim.gd")
const Data := preload("res://scripts/state/Data.gd")
const WeekPhase := preload("res://scripts/rules/WeekPhase.gd")
const WeekPlan := preload("res://scripts/rules/WeekPlan.gd")
const FirstWeek := preload("res://scripts/rules/FirstWeek.gd")


func _initialize() -> void:
	var c := Career.quick_start()
	c.seed = 1
	FirstWeek.begin(c)
	Sim.sign(c, ["conditioning"])
	Sim.hire(c, "reid")
	var f: Dictionary = c.fighter()
	print("signed: next_offer_day=%d weight=%.2f limit=%.1f" % [int(f["next_offer_day"]), float(f["weight"]), float(f["limit"])])
	for d in [12, 13, 19, 26, 33]:
		var fc := Sim.weigh_forecast(c, f, d)
		print("forecast bout day %d: %.2f ok=%s" % [d, float(fc["day"]), fc["ok"]])
	var g := f.duplicate(true)
	g["diet"] = "cut"
	for d in [19, 26]:
		print("diet cut from today, bout day %d: %.2f" % [d, float(Sim.weigh_forecast(c, g, d)["day"])])
	var h := g.duplicate(true)
	WeekPhase.edit(h, 3, ["intervals", "hard"], WeekPlan.coach_of(h)[3])
	WeekPhase.edit(h, 5, ["roadwork", "hard"], WeekPlan.coach_of(h)[5])
	for d in [19]:
		print("cut + two hard mornings, bout day %d: %.2f" % [d, float(Sim.weigh_forecast(c, h, d)["day"])])
	for i in 60:
		Sim.step_day(c)
		if not (f["offers"] as Array).is_empty():
			for o in f["offers"]:
				print("day %d: offer %s vs %s on day %d (mismatch %s)" % [c.day, o["id"], o["opp"]["name"], int(o["day"]), o["mismatch"]])
			break
	print("start cash %d, week costs %s" % [c.cash, Sim.weekly_costs(c)])
	quit(0)
