extends SceneTree
## S356 the camp's phase writes the week (WeekPhase, operator Q-S294-82 "Yes, build it"):
##   1. the phase counts back from fight night: base (no bout), build (3+ weeks), peak (2), taper (fight week),
##   2. each phase's coach week: build pushes the camp's stat Hard, peak spars twice, taper halves the volume, no sparring
##      (John S354: taper 40-60 % down, stop sparring 7-10 days out),
##   3. the coach's 4-week camp never overreaches, so the peak-camp bonus is in reach without a single pick,
##   4. exceptions: one card a day; the coach's own card undoes it; a new phase drops last week's,
##   5. the goal lines project through the coming phases, not this week repeated; fight week on a cut drops 0.05 kg a day.
## Population: a 61.0 kg amateur lightweight, conditioning 58, potential 80, coach 60, technique camp.

const WP := preload("res://scripts/rules/WeekPlan.gd")
const PH := preload("res://scripts/rules/WeekPhase.gd")

var _fails := 0


func _ctx(fatigue: float = 20.0) -> Dictionary:
	return {"stats": {"power": 55.0, "speed": 57.0, "technique": 60.0, "defense": 52.0, "conditioning": 58.0, "fight_iq": 50.0,
		"chin": 62.0}, "pot": 80, "coach": 60.0, "weight": 61.0, "diet": "cut", "fatigue": fatigue}


func _initialize() -> void:
	var bout := {"day": 28, "done": false}
	_check(PH.phase({}, 0) == "base" and PH.phase(bout, 0) == "build" and PH.phase(bout, 14) == "peak" and PH.phase(bout, 21) == "taper"
		and PH.phase(bout, 28) == "taper" and PH.phase({"day": 28, "done": true}, 21) == "base", "base / build / peak / taper counted back from day 28")
	var build := PH.week("build", "technique")
	var peak := PH.week("peak", "technique")
	var taper := PH.week("taper", "technique")
	_check(build.has(["shadow", "hard"]) and PH.week("build", "power").has(["heavy_bag", "hard"]), "build: the camp's stat gets a Hard morning")
	_check(PH.spar("peak") == 2 and PH.spar("taper") == 0 and taper.filter(func(d): return str(d[0]) == "rest").size() == 3, "peak spars twice; fight week rests 3 days, no sparring")
	var h_peak := WP.hours(peak, WP.evenings_for(PH.spar("peak")))
	var h_taper := WP.hours(taper, WP.evenings_for(PH.spar("taper"), PH.pads("taper")))
	_check(h_taper <= 0.6 * h_peak and h_taper >= 0.25 * h_peak, "taper volume %.1f h vs peak %.1f h (down 40-75 %%)" % [h_taper, h_peak])
	# 3. The coach's camp, no picks: build, build, peak, taper.
	var c := _ctx()
	var top := 0.0
	var fat := []
	for p in ["build", "build", "peak", "taper"]:
		var w := WP.week(PH.week(p, "technique"), c, WP.evenings_for(PH.spar(p), PH.pads(p)))
		top = maxf(top, float(w["peak"]))
		fat.append(int(round(float(w["fatigue_end"]))))
		c["stats"] = w["stats_end"]
		c["weight"] = w["weight_end"]
		c["fatigue"] = w["fatigue_end"]
	print("coach camp: fatigue at each Sunday %s, peak %.1f, technique %.2f, weight %.2f kg" % [str(fat), top, float(c["stats"]["technique"]), float(c["weight"])])
	_check(top < WP.OVERREACHED and int(fat[3]) < int(fat[2]), "the coach's camp never overreaches (%.1f) and fight week freshens her (%d -> %d)" % [top, fat[2], fat[3]])
	# 4. Exceptions.
	var f := {"phase": "build", "camp": {"focus": "technique"}, "bout": bout}
	_check(WP.days_of(f) == build and PH.edits(f).is_empty(), "the coach's week with no picks")
	PH.edit(f, 3, ["intervals", "hard"], WP.coach_of(f))
	_check(WP.days_of(f)[3] == ["intervals", "hard"] and (PH.edits(f)["days"] as Dictionary).size() == 1, "one card changed, one exception")
	PH.edit(f, 3, build[3], WP.coach_of(f))
	_check(WP.days_of(f) == build and (PH.edits(f)["days"] as Dictionary).is_empty(), "the coach's card again undoes it")
	PH.edit_spar(f, 2)
	_check(WP.evenings_of(f).count("sparring") == 2, "sparring nights changed to 2")
	PH.edit(f, 0, ["rest", "normal"], WP.coach_of(f))
	PH.sync(f, 14)
	_check(str(f["phase"]) == "peak" and WP.days_of(f) == peak and WP.evenings_of(f).count("sparring") == 2 and PH.edits(f).is_empty(),
		"a new phase writes a new week: last week's exceptions are gone")
	_check(PH.card(["intervals", "hard"]) == "Hard intervals" and PH.card(["rest", "normal"]) == "Rest" and PH.cards().size() == 25, "one card a day: 'Hard intervals' (25 cards)")
	# 5. The goal lines walk the coming phases.
	f["phase"] = "build"
	var later := WP.ahead(f, 0, 4)
	_check(later.size() == 3 and later[1][0] == peak and later[2][0] == taper and (later[2][1] as Array).count("pads") == 3, "ahead: build, then peak, then taper (3 pad nights)")
	var walked := WP.project(build, _ctx(), 4, WP.evenings_for(1), later)
	var repeated := WP.project(build, _ctx(), 4, WP.evenings_for(1))
	_check(absf(float(walked["weight"]) - float(repeated["weight"])) > 0.05,
		"the projection walks the phases (%.2f kg vs %.2f repeating the build week)" % [walked["weight"], repeated["weight"]])
	# Fight week on a cut: the low-residue diet's drop (Reale 2017), none on a hold diet or before fight week.
	var cut := _ctx()
	var base_kg := float(WP.day("rest", "normal", cut, 20.0)["kg"])
	cut["phase"] = "taper"
	var taper_kg := float(WP.day("rest", "normal", cut, 20.0)["kg"])
	cut["diet"] = "hold"
	_check(is_equal_approx(base_kg - taper_kg, WP.TAPER_KG) and is_equal_approx(float(WP.day("rest", "normal", cut, 20.0)["kg"]) - WP.CUT_DEFICIT / WP.KCAL_PER_KG, base_kg),
		"fight week on a cut drops %.2f kg a day more; a hold diet does not" % WP.TAPER_KG)
	print("WEEK_PHASE %s" % ("PASS" if _fails == 0 else "FAIL %d" % _fails))
	quit(0 if _fails == 0 else 1)


func _check(ok: bool, what: String) -> void:
	print(("ok   " if ok else "FAIL ") + what)
	if not ok:
		_fails += 1
