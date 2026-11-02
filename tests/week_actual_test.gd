extends SceneTree
## S355 CORE3 step 2: planned vs actual at the week review (WeekActual) and the week's twist card (WeekTwist), in the rule
## modules and in real weeks of the sim (Sim.step_day / end_week):
##   1. the twist card is seeded, never the same twice running, and changes exactly the mornings/evenings it names,
##   2. the review's lines: the stats the plan trains, the weight, the fatigue peak; the reason; the coach's one change,
##   3. a week run as planned reads on plan with "Every session went as planned.", and a twist and a mid-week change are
##      named in the next review.
## Population: Lucy (Data.lucy: out-boxer, conditioning focus) in the quick-start gym, on the coach's week and on a
## bag-heavy week of her own.

const Data := preload("res://scripts/state/Data.gd")
const Sim := preload("res://scripts/state/Sim.gd")
const WT := preload("res://scripts/rules/WeekTwist.gd")
const WA := preload("res://scripts/rules/WeekActual.gd")
const WeekPlan := preload("res://scripts/rules/WeekPlan.gd")

var _fails := 0


func _initialize() -> void:
	_twist()
	_actual()
	_weeks()
	print("FAILURES %d" % _fails)
	quit(1 if _fails > 0 else 0)


func _twist() -> void:
	_check(WT.draw(5) == WT.draw(5), "the card is seeded by the week")
	var ok := true
	for w in 60:
		ok = ok and str(WT.draw(w, str(WT.draw(w)["id"]))["id"]) != str(WT.draw(w)["id"])
	_check(ok, "never the same card twice running")
	var seen := {}
	for w in 200:
		seen[WT.draw(w)["id"]] = true
	_check(seen.size() == WT.TWISTS.size(), "every card comes up (%d of %d)" % [seen.size(), WT.TWISTS.size()])
	var fight_ok := true
	for w in 200:
		fight_ok = fight_ok and not WT.draw(w, "", true).has("rest_day")
	_check(fight_ok, "fight week never draws a card that takes a session away")
	var days := [["heavy_bag", "hard"], ["roadwork", "normal"], ["speed_bag", "light"], ["strength", "normal"], ["shadow", "normal"],
		["roadwork", "light"], ["rest", "normal"]]
	var evs := ["pads", "pads", "pads", "sparring", "pads", "pads", "rest"]
	var wrist := WT.days(WT.card("sore_wrist"), days)
	_check(wrist[0] == ["shadow", "hard"] and wrist[2] == ["shadow", "light"] and wrist[1] == days[1], "sore wrist: bag mornings -> shadow, intensity kept")
	_check(WT.days(WT.card("rain"), days)[1] == ["intervals", "normal"], "rain: roadwork -> intervals")
	var cold := WT.card("head_cold")
	_check(WT.days(cold, days)[2] == ["rest", "normal"] and WT.evenings(cold, evs)[2] == "rest", "head cold: Wednesday morning and evening rest")
	_check(WT.evenings(WT.card("partner_ill"), evs)[3] == "pads" and WT.evenings(WT.card("visiting_pro"), evs)[5] == "sparring", "sparring off / an extra night")
	_check(WT.days(WT.card("quiet"), days) == days and not WT.touches(WT.card("quiet"), days, evs), "a quiet week changes nothing")
	var no_bags := [["roadwork", "normal"], ["shadow", "normal"], ["roadwork", "normal"], ["neck", "normal"], ["shadow", "normal"], ["rest", "normal"], ["rest", "normal"]]
	_check(not WT.touches(WT.card("sore_wrist"), no_bags, evs) and WT.touches(WT.card("sore_wrist"), days, evs), "a sore wrist touches only a week with bag work")


func _actual() -> void:
	var planned := WA.snapshot({"gains": {"power": 0.4, "conditioning": 0.3, "technique": 0.02}, "kg": -0.4, "peak": 55.0}, [], 62.6, 14)
	var st0 := {"power": 58.0, "conditioning": 61.0, "technique": 60.0}
	var rws := WA.rows(planned, st0, {"power": 58.38, "conditioning": 61.1, "technique": 60.02}, 62.3, 58.0)
	var ids := rws.map(func(r): return str(r["id"]))
	_check(ids == ["power", "conditioning", "weight", "fatigue"], "lines: the trained stats, weight, fatigue peak (%s)" % str(ids))
	_check(bool(rws[0]["ok"]) and not bool(rws[1]["ok"]), "power +0.38 of +0.40 on plan; conditioning +0.10 of +0.30 off")
	_check(bool(rws[2]["ok"]) and is_equal_approx(float(rws[2]["actual"]), -0.3), "weight -0.30 of -0.40 planned: within 0.15, on plan")
	var slow := WA.rows(planned, st0, st0, 62.5, 50.0)
	_check(not bool(slow[2]["ok"]), "weight -0.10 of -0.40 planned: off plan")
	_check(bool(rws[3]["ok"]), "fatigue peak 58 vs 55: within 5")
	_check(WA.reason([], {}) == "Every session went as planned." and WA.reason([], WT.card("quiet")) == "Every session went as planned.", "nothing in the way: as planned")
	var log := [WA.log_entry(1, ["roadwork", "normal"], ["rest", "normal"], "injured"), WA.log_entry(4, ["shadow", "normal"], ["rest", "normal"], "injured"),
		WA.log_entry(2, ["roadwork", "normal"], ["intervals", "hard"], "changed")]
	var why := WA.reason(log, WT.card("rain"), "power")
	_check(why == "2 days lost to injury; the plan changed on Wednesday; the twist: rain all week; camp focus on power trained it harder.", "the reason: %s" % why)
	var ctx := {"stats": st0, "pot": 80, "coach": 50.0, "weight": 62.6, "diet": "cut", "fatigue": 30.0}
	var tired := WA.rows(planned, st0, st0, 62.2, 86.0)
	_check(WA.suggest(tired, [], ctx, true).begins_with("Make one HARD morning NORMAL"), "overreached: ease one morning first")
	var heavy := WA.rows(planned, st0, {"power": 58.4, "conditioning": 61.3}, 62.6, 50.0)
	var hold := ctx.duplicate()
	hold["diet"] = "hold"
	_check(WA.suggest(heavy, [], hold, true).begins_with("Switch to the cut diet: about 0.45 kg"), "over the limit on HOLD: the diet first (%s)" % WA.suggest(heavy, [], hold, true))
	_check(WA.suggest(heavy, [], ctx, true).begins_with("Swap a light morning for HARD roadwork: about"), "already cutting: a hard run (%s)" % WA.suggest(heavy, [], ctx, true))
	_check(WA.suggest(rws, [], ctx, false) == "Add a roadwork morning: conditioning came in under the plan.", "a stat short: the session that trains it")
	var fine := WA.rows(planned, st0, {"power": 58.4, "conditioning": 61.3}, 62.2, 50.0)
	_check(WA.suggest(fine, [], ctx, false).begins_with("Keep the week"), "all on plan: keep it")


func _weeks() -> void:
	var c := Career.quick_start()
	var f: Dictionary = Data.fighter_state(Data.lucy(), c.day)
	c.fighters.append(f)
	c.day = 14   # a Monday (Clock: day 0 is a Monday)
	f.erase("twist")
	for i in 7:
		Sim.step_day(c)
	var rep := _report(c, f)
	var plan: Dictionary = rep.get("plan", {})
	_check(not plan.is_empty() and (plan["rows"] as Array).size() >= 3, "week 1: the review carries planned vs actual (%d lines)" % (plan.get("rows", []) as Array).size())
	var hurt := (f.get("week_log", []) as Array).any(func(x): return str(x["why"]) == "injured")
	var close := true
	for r in plan.get("rows", []):
		if str(r["unit"]) == "stat":
			close = close and absf(float(r["actual"]) - float(r["plan"])) < 0.05
	print("  week 1: %s | %s | coach: %s" % [str((plan.get("rows", []) as Array).map(func(r): return "%s %.2f/%.2f" % [r["id"], r["plan"], r["actual"]])), plan.get("reason", ""), plan.get("change", "")])
	if not hurt:
		_check(close and str(plan["reason"]) == "Every session went as planned.", "week 1 run as planned: the stats land on the plan, the reason says so")
	_check(str(f.get("twist", "")) != "" and not WT.card(str(f["twist"])).is_empty(), "the next week's twist card is drawn (%s)" % str(f.get("twist", "")))
	# Week 2: a bag-heavy week of her own under a sore wrist, and Wednesday changed after Monday.
	f["week_days"] = [["heavy_bag", "normal"], ["roadwork", "normal"], ["heavy_bag", "hard"], ["speed_bag", "normal"], ["roadwork", "normal"],
		["shadow", "light"], ["rest", "normal"]]
	f["twist"] = "sore_wrist"
	Sim.step_day(c)   # Monday: the plan is kept with the card applied
	var kept: Dictionary = f["week_planned"]
	_check(float((kept["gains"] as Dictionary).get("power", 0.0)) < 0.05 and float((kept["gains"] as Dictionary).get("technique", 0.0)) > 0.0,
		"a sore wrist: the plan projects shadow boxing, not bag work (%s)" % str(kept["gains"]))
	f["week_days"][2] = ["roadwork", "hard"]
	for i in 6:
		Sim.step_day(c)
	var p2: Dictionary = _report(c, f).get("plan", {})
	print("  week 2: %s | coach: %s" % [p2.get("reason", ""), p2.get("change", "")])
	var why2 := str(p2.get("reason", "")).to_lower()
	_check(str(p2.get("twist", "")) == "Sore wrist" and why2.contains("the plan changed on wednesday") and why2.contains("sore wrist"),
		"week 2's review names the twist and the mid-week change")
	_check(str(p2.get("change", "")) != "", "the coach suggests one change")


func _report(c: Career, f: Dictionary) -> Dictionary:
	for r in (c.last_report.get("fighters", []) as Array):
		if str(r["id"]) == str(f["id"]):
			return r
	return {}


func _check(ok: bool, what: String) -> void:
	print(("PASS " if ok else "FAIL ") + what)
	if not ok:
		_fails += 1
