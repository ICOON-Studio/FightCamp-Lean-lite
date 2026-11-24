extends SceneTree
## S519 club week v11 3.3 (his Q-S294-272 "Yes, build it"): the coach deals the club's coached mornings.
## Pure: shared focus = the ability both boxers rank lowest; a pair training the same ability shares ONE slot (x1.15 each),
## the rest go 1-to-1 on each boxer's lowest-ranked morning (x1.40 on a weak spot, else x1.25); slots = You 4 + coach 2/3;
## one boxer = no deal. Wired: the test club (Lucy, Kira, Josh - three boxers, different stats and classes) gets a deal, the
## Training model tags the tile, the week plan's gain on a coached morning is the plain gain x the multiplier, and a club of
## one boxer reads exactly as before.
## Prints MORNING_DEAL failures=N.

const CoachedMornings := preload("res://scripts/rules/CoachedMornings.gd")
const MorningWire := preload("res://scripts/state/MorningWire.gd")
const TestClub := preload("res://scripts/state/TestClub.gd")
const ClubWeek := preload("res://scripts/state/ClubWeek.gd")
const WeekPlan := preload("res://scripts/rules/WeekPlan.gd")
const WeekTwist := preload("res://scripts/rules/WeekTwist.gd")
const Sim := preload("res://scripts/state/Sim.gd")

var _fails := 0


func _initialize() -> void:
	# --- pure: shared focus
	var a := {"power": 60.0, "speed": 55.0, "technique": 58.0, "defense": 40.0, "conditioning": 50.0, "fight_iq": 62.0}
	var b := {"power": 45.0, "speed": 70.0, "technique": 64.0, "defense": 52.0, "conditioning": 48.0, "fight_iq": 66.0}
	var sf := CoachedMornings.shared_focus(a, b)
	# ranks a: defense 0, conditioning 1; b: power 0, conditioning 1, defense 2 -> conditioning 2, defense 2 -> tie by value: defense 92 < conditioning 98
	_check(str(sf["ability"]) == "defense" and float(sf["a"]) == 40.0 and float(sf["b"]) == 52.0, "shared focus: %s" % sf)
	_check(CoachedMornings.shared_focus(a, {}).is_empty(), "no stats, no focus")
	# --- pure: the deal
	var d1 := ["conditioning", "power", "conditioning", "speed", "conditioning", "power", ""]
	var d2 := ["conditioning", "technique", "conditioning", "defense", "conditioning", "power", ""]
	var rows := [{"id": "a", "stats": a, "days": d1}, {"id": "b", "stats": b, "days": d2}]
	var deal := CoachedMornings.week_deal(rows, "sessional")
	_check(CoachedMornings.week_deal([rows[0]], "sessional").is_empty(), "one boxer: no deal")
	var used := 0
	var shared_days := []
	for fid in deal:
		for k in deal[fid]:
			var m: Dictionary = deal[fid][k]
			used += 1
			if str(m["use"]) == "shared":
				shared_days.append(k)
	_check(shared_days.size() == 2 and shared_days[0] == shared_days[1], "one shared morning, both boxers the same day: %s" % [shared_days])
	var sd: Dictionary = deal["a"][shared_days[0]] if shared_days.size() > 0 else {}
	_check(float(sd.get("mult", 0)) == CoachedMornings.SHARED and str(sd.get("mate", "")) == "b", "shared x1.15 with the team-mate: %s" % sd)
	# slots: 6 sessional; shared takes ONE slot for two boxers -> 7 boxer-mornings at most
	_check(used <= CoachedMornings.owned("sessional") + 1, "slots respected: %d boxer-mornings" % used)
	var all_solo_ok := true
	for fid in deal:
		for k in deal[fid]:
			var m: Dictionary = deal[fid][k]
			if str(m["use"]) == "solo":
				var st: Dictionary = a if fid == "a" else b
				var want := CoachedMornings.SOLO_WEAK if str(m["ability"]) == CoachedMornings.weak_spot(st) else CoachedMornings.SOLO
				all_solo_ok = all_solo_ok and is_equal_approx(float(m["mult"]), want)
	_check(all_solo_ok, "1-to-1 multipliers follow the weak spot")
	_check(str(deal["a"].get("6", {}).get("use", "")) == "", "no coaching on a rest morning")
	var full := CoachedMornings.week_deal(rows, "full_time")
	var used_ft := 0
	for fid in full:
		used_ft += (full[fid] as Dictionary).size()
	_check(used_ft >= used, "a full-time coach deals at least as many: %d vs %d" % [used_ft, used])
	_check(CoachedMornings.day_mult(deal["a"], int(shared_days[0]) if shared_days.size() > 0 else 0, "speed") == 1.0, "a changed morning (other ability) loses the coaching")
	# --- wired: the test club
	var c := Career.quick_start()
	c.seed = 7
	TestClub.make(c)
	_check(c.fighters.size() >= 3, "test club has %d boxers" % c.fighters.size())
	var cd := MorningWire.deal(c)
	var tagged := 0
	for f in c.fighters:
		tagged += (cd.get(str(f["id"]), {}) as Dictionary).size()
	_check(tagged >= 4, "the club's week has coached mornings dealt: %d" % tagged)
	var f0: Dictionary = c.fighters[0]
	var mine: Dictionary = MorningWire.of(c, f0)
	_check(not mine.is_empty(), "the first boxer has a coached morning: %s" % mine)
	if not mine.is_empty():
		var dk: String = str(mine.keys()[0])
		var m0: Dictionary = mine[dk]
		var days := WeekTwist.days(WeekTwist.active(f0), WeekPlan.days_of(f0))
		var ctx := Sim.week_ctx(c, f0)
		var w := WeekPlan.week(days, ctx)
		var bare := ctx.duplicate()
		bare["coached"] = {}
		var w0 := WeekPlan.week(days, bare)
		var g1 := float((w["days"] as Array)[int(dk)]["gain"])
		var g0 := float((w0["days"] as Array)[int(dk)]["gain"])
		_check(g0 > 0.0 and is_equal_approx(g1, g0 * float(m0["mult"])), "coached morning gain %.4f = %.4f x %.2f" % [g1, g0, float(m0["mult"])])
		if not WeekPhase_weekend(c.day):
			var model := ClubWeek.model(c, str(f0["id"]), 0)
			var tile: Dictionary = (model["days"] as Array)[int(dk)]["am"]
			_check(not (tile.get("coach", {}) as Dictionary).is_empty() and str(tile["coach"]["short"]).contains("x"), "the Training tile shows it: %s" % tile.get("coach", {}))
	# --- one boxer: nothing changes
	var solo := Career.quick_start()
	solo.seed = 7
	TestClub.make(solo)
	while solo.fighters.size() > 1:
		solo.fighters.pop_back()
	_check(MorningWire.of(solo, solo.fighters[0]).is_empty(), "one boxer at the gym: no coached mornings, the week as before")
	_done()


func WeekPhase_weekend(day: int) -> bool:
	return posmod(day, 7) >= 5


func _done() -> void:
	print("MORNING_DEAL failures=%d" % _fails)
	quit(1 if _fails > 0 else 0)


func _check(ok: bool, what: String) -> void:
	if not ok:
		_fails += 1
		print("FAIL ", what)
	else:
		print("ok   ", what)
