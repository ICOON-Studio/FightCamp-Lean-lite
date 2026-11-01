extends SceneTree
## TrainingPlan (S351, her week as blocks per session): 8 tests.

const TP := preload("res://scripts/rules/TrainingPlan.gd")
const TW := preload("res://scripts/rules/TrainingWeek.gd")
const Data := preload("res://scripts/state/Data.gd")
const TrainingPreview := preload("res://scripts/rules/TrainingPreview.gd")

var failures := 0


func _initialize() -> void:
	_test1()
	_test2()
	_test3()
	_test4()
	_test5()
	_test6()
	_test7()
	_test8()
	print("TRAINING_PLAN failures=%d" % failures)
	quit(1 if failures > 0 else 0)


func _check(cond: bool, label: String) -> void:
	if cond:
		print("PASS ", label)
	else:
		failures += 1
		print("FAIL ", label)


func _stats() -> Dictionary:
	return {"power": 58.0, "speed": 63.0, "technique": 60.0, "defense": 57.0, "conditioning": 61.0, "fight_iq": 59.0, "chin": 66.0}


## 1. The plan's sessions are the board's sessions, each stat built by exactly one.
func _test1() -> void:
	var ok := TP.IDS.size() == TW.SESSIONS.size()
	for i in TW.SESSIONS.size():
		var s: Dictionary = TW.SESSIONS[i]
		ok = ok and TP.IDS[i] == s["id"] and str(TP.STAT_OF.get(s["id"], "")) == str(s["stat"])
	_check(ok, "plan ids and stats match TrainingWeek.SESSIONS")


## 2. The default week reproduces the old focus rule exactly, for every focus (no balance change until she plans).
func _test2() -> void:
	var ok := true
	for focus in Data.STATS:
		var partner := str(TrainingPreview.PARTNER[focus])
		var plan := TP.default_plan(focus, partner)
		var old := TrainingPreview.plan_gain(_stats(), 84, focus, 60.0)
		var now := TrainingPreview.fractions_gain(_stats(), 84, TP.fractions(plan), 60.0)
		ok = ok and TP.total(plan) == TP.DEFAULT_TOTAL and TP.main_stat(plan) == focus
		for k in Data.STATS:
			ok = ok and absf(float(old[k]) - float(now[k])) < 0.000001
	_check(ok, "default week = old focus/partner/other gains for all 7 foci")


## 3. Blocks clamp to 0..6 and the week can never be empty.
func _test3() -> void:
	var plan := TP.default_plan("power", "technique")
	var up := plan
	for i in 10:
		up = TP.step(up, "heavy_bag", 1)
	var empty := {}
	for id in TP.IDS:
		empty[id] = 0
	empty["roadwork"] = 1
	var still := TP.step(empty, "roadwork", -1)
	_check(int(up["heavy_bag"]) == TP.MAX_BLOCKS and int(still["roadwork"]) == 1 and not TP.can_step(empty, "roadwork", -1)
		and TP.can_step(empty, "sparring", 1), "blocks clamp at %d; the last block cannot go" % TP.MAX_BLOCKS)


## 4. Hours split the load by blocks and sum to it; the card units read real amounts.
func _test4() -> void:
	var plan := TP.default_plan("conditioning", "chin")
	var h := TP.hours(plan, 10.0)
	var sum := 0.0
	for id in TP.IDS:
		sum += float(h[id])
	var road := TP.amount_text("roadwork", float(h["roadwork"]))   # 3.125 h at 6 min/km = 31 km
	var spar := TP.amount_text("sparring", float(h["sparring"]))   # 37.5 min at 4 min/round = 9 rounds
	var neck := TP.amount_text("neck", float(h["neck"]))            # 3/16 x 10 h = 112.5 min
	_check(absf(sum - 10.0) < 0.0001 and road == "31 km" and spar == "9 rounds" and neck == "113 min"
		and TP.amount_text("pads", 0.0) == "off", "hours sum to the load; %s / %s / %s" % [road, spar, neck])


## 5. More time on a session builds its stat faster, and the curve never falls.
func _test5() -> void:
	var plan := TP.default_plan("technique", "speed")
	var more := TP.step(plan, "heavy_bag", 2)
	var ok := float(TP.fractions(more)["power"]) > float(TP.fractions(plan)["power"])
	var last := -1.0
	for i in 101:
		var v := TP.curve(i / 100.0)
		ok = ok and v >= last
		last = v
	_check(ok, "two more bag blocks: power %.3f -> %.3f; curve monotone" % [TP.fractions(plan)["power"], TP.fractions(more)["power"]])


## 6. No plan builds more in total than the default week (moving time reshapes, never creates).
func _test6() -> void:
	var ok := true
	var worst := 0.0
	var plans: Array = []
	for a in TP.IDS:
		for b in TP.IDS:
			var p := {}
			for id in TP.IDS:
				p[id] = 0
			p[a] = TP.MAX_BLOCKS
			p[b] = TP.MAX_BLOCKS if a != b else TP.MAX_BLOCKS
			plans.append(p)
			var q := TP.default_plan("power", "technique")
			q[a] = TP.MAX_BLOCKS
			q[b] = 0 if a != b else q[b]
			plans.append(q)
	for p in plans:
		if not TP.valid(p):
			continue
		var s := 0.0
		for v in TP.fractions(p).values():
			s += float(v)
		worst = maxf(worst, s)
		ok = ok and s <= TP.TOTAL_CAP + 0.0001
	_check(ok, "no plan passes the default week's total (max %.3f <= %.2f)" % [worst, TP.TOTAL_CAP])


## 7. The main is the biggest non-pads session; the pads set the new move's pace (0 = none, x2 at most).
func _test7() -> void:
	var plan := TP.default_plan("power", "technique")
	var p2 := TP.step(TP.step(plan, "roadwork", 1), "roadwork", 1)
	p2 = TP.step(TP.step(p2, "roadwork", 1), "roadwork", 1)
	p2 = TP.step(p2, "roadwork", 1)   # 6 > the bag's 5
	var no_pads := plan.duplicate()
	no_pads["pads"] = 0
	var lots := {}
	for id in TP.IDS:
		lots[id] = 0
	lots["pads"] = 6
	lots["shadow"] = 1
	_check(TP.main_of(plan) == "heavy_bag" and TP.main_of(p2) == "roadwork" and is_equal_approx(TP.pads_factor(plan), 1.0)
		and TP.pads_factor(no_pads) == 0.0 and TP.pads_factor(lots) == 2.0, "main follows the biggest session; pads factor 1 / 0 / 2")


## 8. A broken or missing saved plan falls back to the coach's week for her focus.
func _test8() -> void:
	var bad := {"sparring": 2}
	var zero := {}
	for id in TP.IDS:
		zero[id] = 0
	var a := TP.plan_of(null, "defense", "fight_iq")
	var b := TP.plan_of(bad, "defense", "fight_iq")
	var c := TP.plan_of(zero, "defense", "fight_iq")
	var mine := TP.step(a, "neck", 2)
	var d := TP.plan_of(mine, "defense", "fight_iq")
	_check(a == TP.default_plan("defense", "fight_iq") and b == a and c == a and int(d["neck"]) == 3,
		"missing / partial / empty plans fall back; a whole plan is kept")
