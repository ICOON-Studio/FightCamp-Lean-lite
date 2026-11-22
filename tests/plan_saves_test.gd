extends SceneTree
## S538 PLANFLOW2 (owner Q-S294-301 "yes add those"): a plan saved under a name, loaded onto a boxer; the main bet.
## Pure rules, no screen (the screen walk is tests/plan_chart_test.gd):
## 1) save: a name, the same name replaced, an empty name numbered, an empty chart and a full list refused;
## 2) the bet rides on its arrow (PlanBet.stamp) and is saved with the plan;
## 3) fit: a boxer who has drilled every line gets them all; one who has not gets the lines she can fire and is told
##    which were dropped and why; a coach who holds fewer lines drops the rest;
## 4) the saved plans go to disk with the career and come back (SaveGame);
## 5) the result page's word on the bet: paid / broke even / lost / never fired / no bet.
## Population: Lucy Jackson (Data.lucy) with the plan's combinations at Sharp, and Nell Okoro - a second boxer made here
## with other stats and no combination drilled. The plan: 1-2 any time at long range (the bet), step back when the
## opponent presses, 1-2-3 when the opponent counters.

const Data := preload("res://scripts/state/Data.gd")
const SM := preload("res://scripts/rules/StrikeMap.gd")
const SaveGame := preload("res://scripts/state/SaveGame.gd")
const PlanBet := preload("res://scripts/ui/PlanBet.gd")
const PlanSaves := preload("res://scripts/ui/PlanSaves.gd")

const PLAN := [{"move": "1-2"}, {"move": "step_back", "when": "press"}, {"move": "1-2-3", "when": "counter"}]

var _fails := 0
var _checks := 0


func _initialize() -> void:
	var c := Career.quick_start("Plan Saves Gym", "London")
	var lucy: Dictionary = Data.fighter_state(Data.lucy(), c.day)
	var combos: Dictionary = lucy.get_or_add("combos", {})
	for a in PLAN:
		var row := SM.move(str(a["move"]))
		if str(row.get("kind", "")) == "combo":
			combos[str(row["combo"])] = 60.0
	(lucy.get_or_add("steps", {}) as Dictionary)["step_back"] = 60.0   # her step back is drilled too
	var nell: Dictionary = lucy.duplicate(true)
	nell["id"] = "nell"
	nell["first"] = "Nell"
	nell["name"] = "Nell Okoro"
	nell["combos"] = {}
	nell["steps"]["step_back"] = 10.0
	for k in (nell.get("stats", {}) as Dictionary):
		nell["stats"][k] = float(nell["stats"][k]) - 4.0
	c.fighters = [lucy, nell]

	# 1) save
	_check(c.saved_plans.is_empty(), "a new career has no saved plan")
	_check(not bool(PlanSaves.save(c, "x", [], lucy)["ok"]), "an empty chart is not saved")
	lucy[PlanBet.KEY] = "long|"
	var plan: Array = PlanBet.stamp(PLAN.duplicate(true), lucy)
	var r := PlanSaves.save(c, "  Box the counter  ", plan, lucy)
	_check(bool(r["ok"]) and str(r["name"]) == "Box the counter" and c.saved_plans.size() == 1, "a plan is saved under its trimmed name (%s)" % str(r))
	plan[0].erase("bet")   # the saved copy is its own: changing the chart after does not change it
	_check(bool(c.saved_plans[0]["arrows"][0].get("bet", false)), "2) the saved plan keeps the main bet on its line")
	_check(str(c.saved_plans[0]["by"]) == "Lucy", "the plan says whose it was (%s)" % str(c.saved_plans[0]["by"]))
	PlanSaves.save(c, "Box the counter", [{"move": "1-2"}], lucy)
	_check(c.saved_plans.size() == 1 and (c.saved_plans[0]["arrows"] as Array).size() == 1, "the same name replaces the plan")
	var numbered := PlanSaves.save(c, "", PLAN, lucy)
	_check(str(numbered["name"]) == "Plan 2" and c.saved_plans.size() == 2, "an empty name is numbered (%s)" % str(numbered["name"]))
	PlanSaves.remove(c, "Plan 2")
	_check(c.saved_plans.size() == 1, "a plan is deleted by name")
	PlanSaves.save(c, "Box the counter", PlanBet.stamp(PLAN.duplicate(true), lucy), lucy)
	for i in PlanSaves.MAX - 1:
		PlanSaves.save(c, "Filler %d" % i, PLAN, lucy)
	_check(c.saved_plans.size() == PlanSaves.MAX and not bool(PlanSaves.save(c, "One too many", PLAN, lucy)["ok"]), "the list is full at %d" % PlanSaves.MAX)
	_check(bool(PlanSaves.save(c, "Filler 0", PLAN, lucy)["ok"]), "a full list still takes a save under a name it has")

	# 2) the bet: one line, moved, forgotten with its line
	var two: Array = PlanBet.stamp(PLAN.duplicate(true), {PlanBet.KEY: "mid|press"})
	_check(two.filter(func(a): return bool(a.get("bet", false))).map(func(a): return str(a["move"])) == ["step_back"], "the bet sits on one line only (%s)" % str(two))
	var gone := {PlanBet.KEY: "inside|"}
	PlanBet.stamp(PLAN.duplicate(true), gone)
	_check(not gone.has(PlanBet.KEY), "a bet whose line is not on the plan is forgotten")

	# 3) fit
	var saved: Dictionary = c.saved_plans[0]
	var all := PlanSaves.fit(saved, lucy, 5)
	_check((all["arrows"] as Array).size() == 3 and (all["dropped"] as Array).is_empty(), "Lucy has drilled every line: all 3 load (%s)" % str(all["dropped"]))
	var some := PlanSaves.fit(saved, nell, 5)
	var names: Array = (some["dropped"] as Array).map(func(d): return str(d["move"]))
	_check((some["arrows"] as Array).size() < 3 and names.has("1-2-3"), "Nell has not drilled the 1-2-3: it is dropped (%s)" % str(some["dropped"]))
	_check((some["dropped"] as Array).all(func(d): return str(d["why"]) != "" and str(d["name"]) != ""), "every dropped line says why")
	_check((some["arrows"] as Array).all(func(a): return not names.has(str(a["move"]))), "a dropped line is not loaded")
	var few := PlanSaves.fit(saved, lucy, 1)
	_check((few["arrows"] as Array).size() == 1 and (few["dropped"] as Array).size() == 2 and str(few["dropped"][0]["why"]).contains("holds 1 line,"),
		"a coach who holds 1 line loads 1 and says so (%s)" % str(few["dropped"]))

	# 4) the saved plans are part of the career's save
	var back := SaveGame.from_dict(SaveGame.to_dict(c))
	_check(back.saved_plans.size() == c.saved_plans.size() and str(back.saved_plans[0]["name"]) == "Box the counter"
		and bool(back.saved_plans[0]["arrows"][0].get("bet", false)), "the saved plans and the bet survive a save and load")
	var old: Dictionary = SaveGame.to_dict(c)
	(old["props"] as Dictionary).erase("saved_plans")
	_check(SaveGame.from_dict(old).saved_plans.is_empty(), "a save from before this build loads with no saved plan")

	# 5) the result page's word on the bet
	var bet_plan: Array = c.saved_plans[0]["arrows"]
	_check(PlanBet.verdict(PLAN, {"1-2": [true]}).is_empty(), "no bet marked: the result page says nothing")
	for case in [["paid", [true, true, false]], ["even", [true, false]], ["lost", [true, false, false]], ["never", []]]:
		var v := PlanBet.verdict(bet_plan, {"1-2": case[1], "step_back": [true]})
		_check(str(v.get("word", "")) == str(case[0]) and int(v["i"]) == 0 and int(v["fired"]) == (case[1] as Array).size(),
			"the bet %s: \"%s\"" % [case[0], str(v.get("text", ""))])
	print("PLAN_SAVES %s checks=%d fails=%d" % ["PASS" if _fails == 0 else "FAIL", _checks, _fails])
	quit(0 if _fails == 0 else 1)


func _check(ok: bool, what: String) -> void:
	_checks += 1
	if not ok:
		_fails += 1
	print(("ok   " if ok else "FAIL ") + what)
