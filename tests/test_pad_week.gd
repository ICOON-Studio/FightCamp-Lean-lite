extends SceneTree
## S382 PADWEEK1 (TRAINING_SCREEN_S381.md 5.2-5.5, section 9 item 1): pad nights replace the fixed 420 / 240 lumps.
##   1. the coach's default week reproduces today's pace for Lucy (coach Luke 58): a new move usable in week 2 (Wednesday),
##      the 1-1 in week 4 - checked against the old lumps run side by side;
##   2. PadWeek.project equals the run (DrillWeek) night by night;
##   3. combo punches no-fade: Lucy's Jab-Jab-Step-Lead hook reaches 30 in ~11 pad nights, the Lead hook holds at 37.3;
##   4. a sparring night shares only cards already >= 30;
##   5. Light / Standard / Hard nights per mode, film, taper, pads_factor;
##   6. float pad tier, technique_for, held_by, the AM block sum, the old-save migration.

const Data := preload("res://scripts/state/Data.gd")
const PadWeek := preload("res://scripts/rules/PadWeek.gd")
const DrillWeek := preload("res://scripts/state/DrillWeek.gd")
const MoveMastery := preload("res://scripts/rules/MoveMastery.gd")
const Combos := preload("res://scripts/rules/Combos.gd")
const TrainingPlan := preload("res://scripts/rules/TrainingPlan.gd")
const WeekPhase := preload("res://scripts/rules/WeekPhase.gd")
const WeekPlan := preload("res://scripts/rules/WeekPlan.gd")

var failures := 0


func _initialize() -> void:
	_default_week_is_todays_pace()
	_project_equals_run()
	_own_combo_no_fade()
	_spar_share()
	_nights()
	_bits()
	print("PAD_WEEK failures=%d" % failures)
	quit(0 if failures == 0 else 1)


func _lucy() -> Array:
	var c := Career.quick_start()
	c.coach = Data.coach("reid")   # Luke Reid, rated 58
	c.fighters.append(Data.fighter_state(Data.lucy(), c.day))
	return [c, c.fighter()]


func _default_week_is_todays_pace() -> void:
	var cf := _lucy()
	var c: Career = cf[0]
	var f: Dictionary = cf[1]
	var nights := PadWeek.nights_of(f)
	var week := PadWeek.week_of(f, nights)
	_check(nights["pads"] == [0, 2, 4] and nights["spar"] == [3], "Standard between fights: pads Mon/Wed/Fri, spar Thu (%s)" % [nights])
	_check(week["mon"][0]["card"] == "move:Uppercut" and week["wed"][0]["card"] == "move:Uppercut" and str(week["fri"][0]["card"]) == "combo:1-1",
		"the coach: the new move Mon + Wed, the 1-1 Fri (%s)" % [week])
	# Today's lumps, side by side: 420 a week on the new move, 240 on the combo (the Jab fading under it as it did).
	var cap := MoveMastery.cap(60.1, 59.0)
	var old_up := 0.0
	var old_11 := 0.0
	var old_11_fixed := 0.0
	var old_jab := float(f["moves"]["Jab"])
	var old_up_week := -1
	var old_11_week := -1
	var old_fixed_week := -1
	var learning_after_2 := ""
	var up_week := -1
	var c11_week := -1
	var up_path: Array = []
	var c11_path: Array = []
	for w in range(1, 7):
		old_up = MoveMastery.gain(old_up, "pads", 420.0, 58.0, 2, 1.0, cap)
		old_jab = MoveMastery.decay_week(old_jab, false)   # the old order: the moves' week, then the combo on what is left
		old_11 = Combos.drill(old_11, "1-1", 240.0, 58.0, 2, minf(cap, old_jab))
		old_11_fixed = Combos.drill(old_11_fixed, "1-1", 240.0, 58.0, 2, minf(cap, 51.1))   # the design's table: the Jab held
		if old_up >= 30.0 and old_up_week < 0:
			old_up_week = w
		if old_11 >= 30.0 and old_11_week < 0:
			old_11_week = w
		if old_11_fixed >= 30.0 and old_fixed_week < 0:
			old_fixed_week = w
		var r := DrillWeek.run(c, f)
		if w == 2:
			learning_after_2 = str(f["learning"])
		if up_week < 0:
			for row in r["pads"]:
				if str(row[1]) == "move:Uppercut":
					up_path.append(float(row[3]))
					if float(row[3]) >= 30.0 and up_week < 0:
						up_week = w
						_check(int(row[0]) == 2, "the Uppercut turns usable on Wednesday (dow %d)" % int(row[0]))
		c11_path.append(float(f["combos"].get("1-1", 0.0)))
		if float(f["combos"].get("1-1", 0.0)) >= 30.0 and c11_week < 0:
			c11_week = w
	_check(up_week == 2 and old_up_week == 2, "new move usable in week 2, today week 2 (new %d, old %d)" % [up_week, old_up_week])
	_check(absf(float(up_path[1]) - 19.3) < 0.1 and absf(float(up_path[3]) - 33.7) < 0.1,
		"Uppercut 19.3 after week 1, 33.7 on Wednesday of week 2 (%.1f, %.1f)" % [up_path[1], up_path[3]])
	# Today's code fades the Jab under the 1-1 (0.75 a week), so the lump really lands in week 5; the design's week 4 holds the
	# Jab - which the no-fade rule now does for real.
	_check(c11_week == 4 and old_fixed_week == 4 and old_11_week == 5,
		"1-1 usable in week 4 = the design's lump week 4 (today's code with the Jab fading: week %d; %s)" % [old_11_week, c11_path])
	_check(learning_after_2 == "Check hook", "the coach moves on to the next move once the Uppercut lands (%s)" % learning_after_2)
	_check(float(f["moves"]["Jab"]) >= 51.0, "the Jab holds under the drilled 1-1 (no fade: %.2f)" % float(f["moves"]["Jab"]))


func _project_equals_run() -> void:
	var cf := _lucy()
	var c: Career = cf[0]
	var f: Dictionary = cf[1]
	var nights := PadWeek.nights_of(f)
	var week := PadWeek.week_of(f, nights)
	var p := PadWeek.project(f, nights, week, 58.0, PadWeek.STATION_TIER, 2)
	var run_log: Array = []
	for w in 2:
		for row in DrillWeek.run(c, f)["pads"]:
			run_log.append([w, int(row[0]), str(row[1]), float(row[3])])
	var same := true
	var n := 0
	for row in run_log:
		var path: Array = p[row[2]]["path"]
		var hit := false
		for q in path:
			if int(q[0]) == int(row[0]) and int(q[1]) == int(row[1]) and is_equal_approx(float(q[2]), float(row[3])):
				hit = true
		same = same and hit
		n += 1
	# 6 pad nights + Thursday of week 2: the Uppercut, usable since Wednesday, gets the sparring share.
	_check(same and n == 7, "project == the run, night by night (%d nights)" % n)
	_check(int(p["move:Uppercut"]["day30"]) == -1 and int(p["move:Uppercut"]["weeks30"]) == 2, "card: Uppercut usable in 2 weeks")
	var p2 := PadWeek.project(f, nights, PadWeek.week_of(f, nights), 58.0, PadWeek.STATION_TIER, 8)
	_check(int(p2["combo:1-1"]["weeks30"]) == 2, "card: 1-1 usable in 2 more weeks after 2 drilled (%d)" % int(p2["combo:1-1"]["weeks30"]))
	_check(_held_is(p2["combo:1-1"]["held_by"], "Jab", 51.1), "1-1 held under SHARP by the Jab (%s)" % [p2["combo:1-1"]["held_by"]])
	_check(is_equal_approx(float(p2["combo:1-1"]["sig_needs_t"]), 83.0), "signature needs Technique 83 (%.2f)" % float(p2["combo:1-1"]["sig_needs_t"]))


func _own_combo_no_fade() -> void:
	var cf := _lucy()
	var f: Dictionary = cf[1]
	f["book"] = [{"name": "jab, jab, step in, lead hook", "chain": ["jab", "jab", "step_in", "lead_hook"], "score": 70}]
	var all3 := [{"card": "own:1", "share": 1.0}]
	f["pad_week"] = {"mon": all3, "wed": all3, "fri": all3}
	var nights := PadWeek.nights_of(f)
	var week := PadWeek.week_of(f, nights)
	_check(PadWeek.cards_in(week) == ["own:1"], "the player's nights replace the coach's")
	var p: Dictionary = PadWeek.project(f, nights, week, 58.0, PadWeek.STATION_TIER, 8)["own:1"]
	var k := 0
	for q in p["path"]:
		k += 1
		if float(q[2]) >= 30.0:
			break
	_check(k >= 10 and k <= 12, "Jab-Jab-Step-Lead hook usable in ~11 pad nights (%d)" % k)
	_check(_held_is(p["held_by"], "Lead hook", 37.3), "its card: held at 37 by the Lead hook (%s)" % [p["held_by"]])
	var cf2 := _lucy()
	var c2: Career = cf2[0]
	var f2: Dictionary = cf2[1]
	f2["book"] = f["book"].duplicate(true)
	f2["pad_week"] = f["pad_week"].duplicate(true)
	for w in 4:
		DrillWeek.run(c2, f2)
	_check(is_equal_approx(float(f2["moves"]["Lead hook"]), 37.3), "the Lead hook holds at 37.3 under the drilled combo (%.2f)" % float(f2["moves"]["Lead hook"]))
	_check(float(f2["moves"]["Cross"]) < 45.1, "an un-drilled punch still fades (Cross %.2f)" % float(f2["moves"]["Cross"]))


func _spar_share() -> void:
	var cf := _lucy()
	var f: Dictionary = cf[1]
	f["combos"] = {"1-1": 40.0, "1-2": 10.0}
	f["tray"] = ["combo:1-1", "combo:1-2", "move:Jab", "move:Uppercut"]
	var r := PadWeek.run_week(f, {"pads": [], "spar": [3], "minutes": 240.0}, {}, 58.0, 2.0)
	_check((r["log"] as Array).size() == 2 and is_equal_approx(float(r["drilled"]["combo:1-1"]), 90.0),
		"a sparring night: 180 min over the 2 cards >= 30 (%s)" % [r["drilled"]])
	_check(float(f["combos"]["1-1"]) > 40.0 and float(f["moves"]["Jab"]) > 51.1, "1-1 and Jab gain from sparring")
	_check(is_equal_approx(float(f["combos"]["1-2"]), 9.25) and float(f["moves"]["Uppercut"]) == 0.0,
		"not in her hands yet: nothing from sparring (1-2 fades to %.2f)" % float(f["combos"]["1-2"]))
	var gain := float(f["combos"]["1-1"]) - 40.0
	_check(gain > 0.3 and gain < 3.0, "the share is small (+%.2f)" % gain)


func _nights() -> void:
	var expect := {"between": [[2, 1], [3, 1], [4, 1]], "camp": [[2, 1], [2, 2], [3, 2]]}
	for mode in expect:
		for s in 3:
			var n := PadWeek.nights_for(s, mode == "camp")
			_check((n["pads"] as Array).size() == int(expect[mode][s][0]) and (n["spar"] as Array).size() == int(expect[mode][s][1]),
				"%s %s: %d pads + %d spar (%s)" % [mode, PadWeek.STEPS[s], expect[mode][s][0], expect[mode][s][1], n])
	var std := PadWeek.nights_for(1, true)
	_check(std["pads"] == [0, 2] and std["spar"] == [1, 3], "camp Standard: pads Mon/Wed, spar Tue/Thu (%s)" % [std])
	var film := PadWeek.nights_for(1, true, true)
	_check(film["pads"] == [0] and int(film["film"]) == 2, "film takes a pad night (%s)" % [film])
	var taper := PadWeek.nights_for(1, true, false, true)
	_check((taper["spar"] as Array).is_empty() and is_equal_approx(float(taper["minutes"]), 120.0), "taper: no sparring, half minutes")
	_check(is_equal_approx(PadWeek.pads_factor(PadWeek.nights_for(1, false)), 1.0) and is_equal_approx(PadWeek.pads_factor(PadWeek.nights_for(2, false)), 4.0 / 3.0),
		"pads_factor = pad nights / 3")
	_check(PadWeek.step_of({"load_setting": "hard"}) == 2 and PadWeek.step_of({"load_setting": "light"}) == 0 and PadWeek.step_of({}) == 1,
		"between fights the load setting picks the step")
	_check(PadWeek.step_of({"camp": {"protocol": 3}, "load_setting": "light"}) == 2, "in camp the protocol picks it")
	# The nights sit on the evenings she really runs (WeekPlan.evenings_of + the twist): the board's spar pills, film's night.
	var g := Data.fighter_state(Data.lucy(), 1)
	g["phase"] = "base"
	WeekPhase.edit_spar(g, 0)
	var n0 := PadWeek.nights_of(g)
	_check((n0["spar"] as Array).is_empty() and n0["pads"] == [0, 2, 4], "spar set to 0 on the board: no sparring share (%s)" % [n0])
	WeekPhase.edit_spar(g, 2)
	var n2 := PadWeek.nights_of(g)
	_check(n2["spar"] == [1, 3] and n2["pads"] == [0, 2, 4], "spar 2: Tue + Thu, pads stay Mon/Wed/Fri (%s)" % [n2])
	var cmp := Data.fighter_state(Data.lucy(), 1)
	cmp["camp"] = {"protocol": 2, "focus": "technique", "film": true}
	cmp["phase"] = "build"
	var evs := WeekPlan.evenings_of(cmp)
	var nb := PadWeek.nights_of(cmp)
	var clash := false
	for d in nb["pads"]:
		clash = clash or str(evs[d]) != "pads"
	_check(not clash and (nb["pads"] as Array).size() == 1 and int(nb["film"]) == evs.find("film") and nb["spar"] == [3],
		"camp Build + film: 1 pad night on a pads evening, film and sparring where the week has them (%s vs %s)" % [nb, evs])
	var lucy := Data.fighter_state(Data.lucy(), 1)
	var hard := PadWeek.defaults(lucy, PadWeek.nights_for(2, false))
	var light := PadWeek.defaults(lucy, PadWeek.nights_for(0, false))
	_check(PadWeek.minutes_for("move:Uppercut", hard, PadWeek.nights_for(2, false)) == 480.0
		and PadWeek.minutes_for("combo:1-1", hard, PadWeek.nights_for(2, false)) == 480.0,
		"Hard: the move keeps its 2 nights, the extra night goes to the combo (%s)" % [hard])
	_check(PadWeek.minutes_for("move:Uppercut", light, PadWeek.nights_for(0, false)) == 240.0
		and PadWeek.minutes_for("combo:1-1", light, PadWeek.nights_for(0, false)) == 240.0, "Light: one night each (%s)" % [light])


func _bits() -> void:
	var g2 := MoveMastery.gain(0.0, "pads", 240.0, 58.0, 2.0, 1.0, 75.8)
	var g24 := MoveMastery.gain(0.0, "pads", 240.0, 58.0, 2.4, 1.0, 75.8)
	_check(is_equal_approx(g24 / g2, 1.2), "pad tier 2.4 pays x1.2 (%.3f)" % (g24 / g2))
	_check(is_equal_approx(MoveMastery.technique_for(85.0, 59.0), 83.0), "technique_for(85, IQ 59) = 83")
	_check(_held_is(Combos.held_by({"Jab": 51.1, "Lead hook": 37.3}, ["Jab", "Jab", "Lead hook"]), "Lead hook", 37.3), "held_by names the weakest punch")
	var coach_week := WeekPhase.week("base", "conditioning")
	_check(PadWeek.intensity(coach_week, 3, 1) == TrainingPlan.DEFAULT_TOTAL, "the coach's week = 16 blocks (%d)" % PadWeek.intensity(coach_week, 3, 1))
	_check(PadWeek.intensity(coach_week, 4, 1) == 17 and PadWeek.blocks(coach_week, 3, 1)["pads"] == 3, "Hard adds a pads block")
	var old := {"moves": {"Jab": 50.0, "Cross": 20.0}, "combos": {}, "learning": "Cross", "combo_learning": "1-1", "stats": {"technique": 60.0, "fight_iq": 60.0}}
	var w := PadWeek.week_of(old, PadWeek.nights_for(1, false))
	_check(w["mon"][0]["card"] == "move:Cross" and w["wed"][0]["card"] == "move:Cross" and w["fri"][0]["card"] == "combo:1-1",
		"an old save: learning on Mon + Wed, combo_learning on Fri (%s)" % [w])


func _held_is(h: Array, mv: String, m: float) -> bool:
	return h.size() == 2 and str(h[0]) == mv and absf(float(h[1]) - m) < 0.001


func _check(ok: bool, label: String) -> void:
	if ok:
		print("  PASS  ", label)
	else:
		failures += 1
		print("  FAIL  ", label)
