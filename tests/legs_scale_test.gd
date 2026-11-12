extends SceneTree
## S433 NOCAMP1 + TANK1 (CORE_LOOP_MAP_S432 C4, F5; FIGHT_LINK defect 1): ONE Tank scale on every bout, camp or not.
## The energy off at the first bell = tiredness over 50 at 2 a point (that part at most 20) + weight left to the day + the
## boxer's own last bout (7 days -8, 14 days -4), all added, at most 25 off. NO_CAMP_EDGE is for a professional with no
## camp only. Population: Lucy Jackson (Data.lucy, amateur) vs Maria Ortega (Data.OPPONENTS[0]), fight night today.
##   1. The same amateur at tiredness 60 starts 20 down with or without a camp (main: 0 without one).
##   2. The Training tab's Tank (WeekBoard's tooltip: GaugeRow.read of WeekCamp.forecast) equals the bout's first bell, the
##      hurt she fights with included (S434); and ACROSS DAYS: a no-camp forecast on Tuesday for Saturday's bout equals the
##      Tank the bout opens on after Sim.step_day ran the real days (S434: the forecast ran a protocol-0 "camp").
##   3. The last bout: boxed 7 days ago costs about 8, 14 days about 4, 20 days nothing; everything together caps at 25.
##   4. NO_CAMP_EDGE: a professional with no camp pays it, an amateur with no camp does not - on the PLAYED path (the
##      base LiveRound.open holds for round 1 of a real bout, S434) and on ComboOdds.night_gap (the read).
##   5. The result's reasons: no canned "No camp ... a step slow" line; the Tank line names what it cost.

const Data := preload("res://scripts/state/Data.gd")
const BoutNight := preload("res://scripts/state/BoutNight.gd")
const BoutRules := preload("res://scripts/rules/BoutRules.gd")
const ComboOdds := preload("res://scripts/rules/ComboOdds.gd")
const WeekCamp := preload("res://scripts/ui/WeekCamp.gd")
const GaugeRow := preload("res://scripts/ui/GaugeRow.gd")
const LiveRound := preload("res://scripts/state/LiveRound.gd")
const Sim := preload("res://scripts/state/Sim.gd")

var failures := 0


func _initialize() -> void:
	var bare := _bout(60.0, {}, -1)
	var camped := _bout(60.0, {"focus": "technique", "protocol": 2, "film": false, "start": 9}, -1)
	print("  tiredness 60: no camp %.1f off, Standard camp %.1f off; first bell %.1f / %.1f" % [bare["stale"], camped["stale"],
		bare["bell"], camped["bell"]])
	_check(absf(float(bare["stale"]) - 20.0) < 0.1 and absf(float(camped["stale"]) - 20.0) < 0.1,
		"the same amateur at tiredness 60 starts 20 down with or without a camp (%.1f / %.1f)" % [bare["stale"], camped["stale"]])
	_check(absf(float(bare["bell"]) - (100.0 - float(bare["hurt"]) - float(bare["stale"]))) < 0.001,
		"the first bell opens on that Tank (%.1f)" % float(bare["bell"]))
	var hurt := _bout(60.0, {}, -1, 15.0)
	for r in [bare, camped, hurt]:
		_check(absf(float(r["tab"]) - float(r["bell"])) < 0.001,
			"the Training tab's Tank %s is the bout's first bell %.1f (hurt %.0f)" % [str(r["tab"]), r["bell"], r["hurt"]])
	_across_days()
	# 3. The boxer's own last bout, on a fresh week (tiredness 40 costs nothing).
	var d7 := _bout(40.0, {}, 7)
	var d14 := _bout(40.0, {}, 14)
	var d20 := _bout(40.0, {}, 20)
	print("  last bout 7 / 14 / 20 days ago: %.1f / %.1f / %.1f off" % [d7["stale"], d14["stale"], d20["stale"]])
	_check(float(d7["stale"]) >= 7.0 and float(d7["stale"]) <= 9.0 and float(d14["stale"]) >= 3.0 and float(d14["stale"]) <= 5.0
		and float(d20["stale"]) < 0.5, "boxed 7 days ago about 8 off, 14 days about 4, 20 days none")
	_check(absf(float(d7["tab"]) - float(d7["bell"])) < 0.001, "the Training tab reads the last bout too (%s)" % str(d7["tab"]))
	var all := _bout(80.0, {}, 5)
	_check(float(all["stale"]) <= 25.0 + 0.001 and float(all["stale"]) >= 24.0, "everything together caps at 25 off (%.1f)" % float(all["stale"]))
	# 4. NO_CAMP_EDGE for a professional with no camp only.
	var am := _fighter(30)
	am["camp"] = {}
	var pro := am.duplicate(true)
	pro["pro"] = true
	var g_am := ComboOdds.night_gap(am)
	var g_pro := ComboOdds.night_gap(pro)
	_check(is_equal_approx(g_pro - g_am, BoutRules.NO_CAMP_EDGE),
		"the read: the professional pays NO_CAMP_EDGE, the amateur does not (pro %.2f, amateur %.2f)" % [g_pro, g_am])
	var b_am := _base(false)
	var b_pro := _base(true)
	_check(is_equal_approx(b_pro - b_am, BoutRules.NO_CAMP_EDGE),
		"played (LiveRound.open's round-1 base): the professional pays NO_CAMP_EDGE, the amateur does not (pro %.2f, amateur %.2f)" % [b_pro, b_am])
	# 5. The reasons.
	var why: Array = bare["why"]
	var canned := why.filter(func(w): return str(w).contains("step slow") or str(w).begins_with("No camp"))
	_check(canned.is_empty(), "no canned no-camp line in the reasons (%s)" % str(why))
	var tank_line := why.filter(func(w): return str(w).contains("20") and str(w).to_lower().contains("tank"))
	_check(not tank_line.is_empty(), "the Tank line names the 20 it cost (%s)" % str(why))
	print("LEGS_SCALE failures=%d" % failures)
	quit(1 if failures > 0 else 0)


func _fighter(day: int) -> Dictionary:
	var f: Dictionary = Data.fighter_state(Data.lucy(), day)
	f["weight"] = float(f["limit"])
	return f


## Lucy's bout tonight at this tiredness and camp, her last bout `ago` days back (-1 none): {stale (energy off at the first
## bell), bell (round 1's energy), hurt, tab (the Training tab's Tank for the same inputs), why}.
func _bout(fatigue: float, camp: Dictionary, ago: int, hurt := 0.0) -> Dictionary:
	var c := Career.quick_start()
	c.day = 30
	var f := _fighter(c.day)
	c.fighters = [f]
	c.results = []
	if ago >= 0:
		c.results.push_front({"d": c.day - ago, "fid": f["id"], "who": f["first"], "opp": "Old Rival", "win": true, "outcome": "win"})
	f["week_fatigue"] = fatigue
	f["camp"] = camp.duplicate(true)
	f["bout"] = {"opp": (Data.OPPONENTS[0] as Dictionary).duplicate(true), "day": c.day, "weighed": true, "made": true, "done": false, "film": 1}
	if hurt > 0.0:
		f["bout"]["hurt"] = hurt   # Injuries.fight_hurt's number
	# the Training tab, read before the bell (the bout itself leaves tiredness, Aftermath.toll)
	var d: Dictionary = GaugeRow.read(WeekCamp.forecast(c, f, {"stat": "technique"}), f, c.day)
	var m := {"fid": f["id"], "step": "tape", "total": 3}
	BoutNight.fight_step(c, f, m, "start")
	var stale := float(f["bout"].get("stale", 0.0))
	BoutNight.fight_step(c, f, m, "rest")
	var rounds: Array = m.get("rounds", [])
	var en: Dictionary = (rounds[0] as Dictionary).get("energy", {}) if not rounds.is_empty() else {}
	return {"stale": stale, "bell": float(en.get("a", -1.0)), "hurt": float(f["bout"].get("hurt", 0.0)), "tab": d.get("tank", "none"),
		"why": m.get("why", [])}


## Round 1's base (LiveRound.open: camp, film, weapons, combinations) of Lucy's bout tonight with no camp, as an amateur or
## a professional - the same fighter, film and opponent otherwise.
func _base(pro: bool) -> float:
	var c := Career.quick_start()
	c.day = 30
	var f := _fighter(c.day)
	c.fighters = [f]
	c.results = []
	f["pro"] = pro
	f["camp"] = {}
	f["bout"] = {"opp": (Data.OPPONENTS[0] as Dictionary).duplicate(true), "day": c.day, "weighed": true, "made": true, "done": false, "film": 1}
	var m := {"fid": f["id"], "step": "tape", "total": 3}
	BoutNight.fight_step(c, f, m, "start")
	return float(LiveRound.live(m).get("base", 999.0))


## 2b. Across days: Lucy, no camp, a bout on Saturday (day 33) booked on Tuesday (day 29), tired (70) and boxed 10 days
## ago. The Training tab's forecast on Tuesday against the bout's first bell after Sim.step_day ran Tue-Fri for real.
func _across_days() -> void:
	var c := Career.quick_start()
	c.day = 29
	c.cash = 1000000
	var f := _fighter(c.day)
	c.fighters = [f]
	c.results = [{"d": c.day - 10, "fid": f["id"], "who": f["first"], "opp": "Old Rival", "win": true, "outcome": "win"}]
	f["week_fatigue"] = 70.0
	f["weight"] = float(f["limit"]) + 0.3   # a fight week a little over: only a camp's cut (Sim.week_ctx) would move it
	f["camp"] = {}
	f["offers"] = []
	f["next_offer_day"] = 999
	f["bout"] = {"opp": (Data.OPPONENTS[0] as Dictionary).duplicate(true), "day": 33, "weighed": false, "made": false, "done": false, "film": 1}
	var fc: Dictionary = WeekCamp.forecast(c, f, {"stat": "technique"})
	var tab := float(GaugeRow.read(fc, f, c.day)["tank"])
	var weigh_kg := 0.0
	while c.day < 33:
		Sim.step_day(c)
		if c.day == 32:
			weigh_kg = float(f["weight"])   # the weigh-in morning (CampForecast's kg)
	f["bout"]["weighed"] = true
	f["bout"]["made"] = true
	var m := {"fid": f["id"], "step": "tape", "total": 3}
	BoutNight.fight_step(c, f, m, "start")
	BoutNight.fight_step(c, f, m, "rest")
	var bell := float(((m["rounds"] as Array)[0] as Dictionary).get("energy", {}).get("a", -1.0)) if not (m["rounds"] as Array).is_empty() else -1.0
	print("  across days (Tue -> Sat, no camp): forecast tiredness %.2f, real %.2f; Training tab Tank %.2f, first bell %.2f (%s)" % [
		float(fc["fatigue_end"]), float(f["week_fatigue"]), tab, bell, str(f["bout"].get("tank_why", ""))])
	_check(bell < 100.0 and absf(tab - bell) < 0.01, "across days: Tuesday's Training tab Tank %.2f is Saturday's first bell %.2f" % [tab, bell])
	_check(absf(float(fc["kg"]) - weigh_kg) < 0.01, "across days: the forecast weigh-in %.2f kg is the real one %.2f kg (no camp, no cut)" % [float(fc["kg"]), weigh_kg])


func _check(cond: bool, label: String) -> void:
	print(("ok   " if cond else "FAIL ") + label)
	if not cond:
		failures += 1
