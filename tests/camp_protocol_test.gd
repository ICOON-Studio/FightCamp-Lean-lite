extends SceneTree
## S380 CAMPPROTO1 (S379: Hard vs Standard moved the camp stat 60.12 vs 59.98 and changed no fatigue): the protocol sets
## the camp's evenings (BoutRules.camp_evening - pads drill the camp's stat, their load scales fatigue and hours), the
## week-end injury rolls read the week's peak fatigue (InjuryRoll.fatigue_mult) and fatigue still carried on fight night
## costs energy at the first bell (S433: BoutRules.tank_for, the Tank). Population: the golden path's quick-start career (seed 1) -
## Lucy signed, Luke Reid hired, her first even offer accepted; CampForecast.run for Light / Standard / Hard.
##   1. The gains spread: Hard - Standard and Standard - Light each >= 0.025 power a camp day (power and technique).
##   2. Fatigue spreads: Hard ends the camp >= 8 more tired than Light; Light is fresh on the night; the coach's Hard
##      camp never overreaches (peak < WeekPlan.OVERREACHED) and peaks >= 4 over Standard.
##   3. The weigh-in does not depend on the protocol (mornings unchanged).
##   4. Injury: Hard > 1.5x Standard's camp risk on power (> Standard on technique), Light <= Standard.
##   5. Bouts.start_camp mirrors the protocol into load_setting (light / normal / hard).
##   6. The real days: stepping the Hard camp to fight night lands on the forecast's fatigue, and the first bell opens
##      with Combos.TANK - the forecast's heavy legs.

const TestJump := preload("res://scripts/ui/TestJump.gd")
const Bouts := preload("res://scripts/state/Bouts.gd")
const Sim := preload("res://scripts/state/Sim.gd")
const BoutRules := preload("res://scripts/rules/BoutRules.gd")
const BoutNight := preload("res://scripts/state/BoutNight.gd")
const Combos := preload("res://scripts/rules/Combos.gd")
const WeekPlan := preload("res://scripts/rules/WeekPlan.gd")
const CampForecast := preload("res://scripts/state/CampForecast.gd")

var failures := 0
var main: Node


func _initialize() -> void:
	root.size = Vector2i(1920, 1080)
	main = load("res://scenes/Main.tscn").instantiate()
	root.add_child(main)
	await process_frame
	var f := _book()
	_check(not f.is_empty(), "Lucy has an even bout booked")
	if f.is_empty():
		_done()
		return
	var c: Career = main.career
	var days := int(f["bout"]["day"]) - c.day
	for focus in ["power", "technique"]:
		var fc := {}
		var g := {}
		for p in [1, 2, 3]:
			fc[p] = CampForecast.run(c, f, focus, p)
			g[p] = float(fc[p]["stats"][focus]) - float(f["stats"][focus])
			print("  %s %s: +%.2f %s, peak %.1f, fight night %.1f, heavy legs %.1f, injury %.1f%%, weigh-in %.2f kg" % [focus,
				BoutRules.PROTOCOLS[p]["name"], g[p], focus, float(fc[p]["peak"]), float(fc[p]["fatigue_end"]), float(fc[p]["stale"]),
				float(fc[p]["injury"]) * 100.0, float(fc[p]["kg"])])
		var need := 0.025 * days
		_check(g[3] - g[2] >= need and g[2] - g[1] >= need,
			"%s over %d days: Hard - Standard %.2f, Standard - Light %.2f (>= %.2f each)" % [focus, days, g[3] - g[2], g[2] - g[1], need])
		_check(float(fc[3]["fatigue_end"]) - float(fc[1]["fatigue_end"]) >= 8.0,
			"%s: Hard ends %.1f more tired than Light (>= 8)" % [focus, float(fc[3]["fatigue_end"]) - float(fc[1]["fatigue_end"])])
		_check(float(fc[1]["fatigue_end"]) < BoutRules.FRESH_FATIGUE and float(fc[1]["stale"]) == 0.0,
			"%s: Light is fresh on the night (%.1f)" % [focus, float(fc[1]["fatigue_end"])])
		_check(float(fc[3]["peak"]) < WeekPlan.OVERREACHED and float(fc[3]["peak"]) - float(fc[2]["peak"]) >= 4.0,
			"%s: Hard peaks %.1f (< %d, >= 4 over Standard's %.1f)" % [focus, float(fc[3]["peak"]), int(WeekPlan.OVERREACHED), float(fc[2]["peak"])])
		_check(absf(float(fc[3]["kg"]) - float(fc[1]["kg"])) < 0.001, "%s: the weigh-in kg is the same for every protocol" % focus)
		# a Hard technique camp is mostly light sessions: it peaks under InjuryRoll.FATIGUE_RISK_FROM, only its hours add risk
		var mult := 1.5 if focus == "power" else 1.0
		_check(float(fc[3]["injury"]) > mult * float(fc[2]["injury"]) and float(fc[1]["injury"]) <= float(fc[2]["injury"]),
			"%s: injury Hard %.1f%% > %.1fx Standard %.1f%%, Light %.1f%% <= Standard" % [focus, float(fc[3]["injury"]) * 100.0, mult,
				float(fc[2]["injury"]) * 100.0, float(fc[1]["injury"]) * 100.0])
	# 5. load_setting mirrors the protocol.
	for p in [1, 2, 3]:
		var twin := f.duplicate(true)
		twin["camp"] = {}
		Bouts.start_camp(c, twin, "power", p, false)
		_check(str(twin["load_setting"]) == ["", "light", "normal", "hard"][p], "%s sets load_setting %s" % [BoutRules.PROTOCOLS[p]["name"], twin["load_setting"]])
	# 6. The real Hard camp to fight night.
	var hard := CampForecast.run(c, f, "power", 3)
	Bouts.start_camp(c, f, "power", 3, false)
	var bd := int(f["bout"]["day"])
	while c.day < bd:
		Sim.step_day(c)
	_check(absf(float(f["week_fatigue"]) - float(hard["fatigue_end"])) < 1.5,
		"fight night as forecast: fatigue %.1f (forecast %.1f)" % [float(f["week_fatigue"]), float(hard["fatigue_end"])])
	var m := {}
	# S431: read the tiredness and the camp BEFORE the bell: since S430 the fight itself leaves tiredness (Aftermath.toll),
	# so after fight_step week_fatigue is the fight's toll, not what she carried in.
	var fat_in := float(f["week_fatigue"])
	var res_in: Array = c.results.duplicate(true)
	var f_in: Dictionary = f.duplicate(true)   # S434 the bout writes her last_bout_day (BoutRules.tank_read): read the Tank's inputs before it
	BoutNight.fight_step(c, f, m, "sim")
	var stale := float(f["bout"].get("stale", 0.0))
	var en: Dictionary = (m["rounds"][0] as Dictionary).get("energy", {}) if not (m.get("rounds", []) as Array).is_empty() else {}
	_check(absf(stale - BoutRules.tank_for(res_in, f_in, fat_in, bd)) < 0.001 and not en.is_empty()
		and absf(float(en["a"]) - (Combos.TANK - float(f["bout"].get("hurt", 0.0)) - stale)) < 0.001,
		"the first bell opens with %.1f energy (tank %.0f, the Tank off %.1f)" % [float(en.get("a", -1.0)), Combos.TANK, stale])
	_done()


## The golden path's first weeks: quick start, Lucy signed with three cards, Luke Reid hired, her first even offer taken.
func _book() -> Dictionary:
	main.act("quick")
	var c: Career = main.career
	c.seed = 1
	c.first_hour = {}   # S397 rank 5: this camp is measured against the classic offer (Maria, 2-4 weeks); first_hour_test has the show
	main.act("interview")
	for card in ["Jab and move", "Pad rounds", "Hill sprints"]:
		main.act("pickcard", card)
	main.act("sign")
	main.act("hire", "reid")
	var f: Dictionary = c.fighter()
	for i in 60:
		if not (f["offers"] as Array).is_empty():
			break
		TestJump._tidy(main, c)
		main.run_to_stop()
	for o in f["offers"]:
		if not bool(o["mismatch"]):
			main.act("accept", str(o["id"]))
			return f
	return {}


func _check(ok: bool, label: String) -> void:
	if not ok:
		failures += 1
		print("  FAIL: " + label)
	else:
		print("  ok: " + label)


func _done() -> void:
	print("CAMP_PROTOCOL failures=%d" % failures)
	quit(1 if failures > 0 else 0)
