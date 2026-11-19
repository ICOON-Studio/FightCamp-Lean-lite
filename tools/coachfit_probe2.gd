extends SceneTree
## COACHFITPROBE2 (S529 COACHFIT_SHEET phase 2): can a coach fit be felt inside the cap?
## A COPY of tools/fit_probe2.gd (same 60 boxers, seeds 6100..6159, paired arms, same levers) changed in two places:
## 1. SLOPE: Replace CoachFit.gain_mult(fit) by `1.0 + k * (fit - 50) / 100.0` for k in [1.0, 1.5, 2.0, 3.0].
##    k=1.0 = today's gain_mult (check it equals CoachFit.gain_mult(82) = 1.32). Every lift through CoachFit.capped().
##    Arms per k: AVERAGE fit 50, TOP fit 82, CONTROL untouched.
## 2. TIREDNESS: After part 1, take each boxer's week-26 state twice: one camp week at tired_mult(80) and one at
##    tired_mult(35), then the same 4-round bout from each. Print energy at the last bell and at the end of round 3.
## Pass lines:
## - SLOPE: smallest k with TOP - AVERAGE = +4..+8 wins in 100 AND Sharp 2..4 weeks sooner. Print COACHFITPROBE2 slope=<k|NONE>.
## - TIREDNESS: fit 80 ends 8..12 energy ahead at the last bell; fit 35 is 15..20 down by the end of round 3.
##   Print COACHFITPROBE2 tired=<pass|fail> ahead=<x> r3_down=<y>.
## - CONTROL: AVERAGE (fit 50) equals CONTROL to the digit for every k (both multipliers are exactly 1.0 at fit 50).

const CoachFit := preload("res://scripts/rules/CoachFit.gd")
const Data := preload("res://scripts/state/Data.gd")
const Sim := preload("res://scripts/state/Sim.gd")
const Bouts := preload("res://scripts/state/Bouts.gd")
const BoutRules := preload("res://scripts/rules/BoutRules.gd")
const LiveRound := preload("res://scripts/state/LiveRound.gd")
const Injuries := preload("res://scripts/state/Injuries.gd")
const RivalPast := preload("res://scripts/rules/RivalPast.gd")
const FirstWeek := preload("res://scripts/rules/FirstWeek.gd")
const WeekPlan := preload("res://scripts/rules/WeekPlan.gd")
const FireLevel := preload("res://scripts/rules/FireLevel.gd")
const MoveMastery := preload("res://scripts/rules/MoveMastery.gd")

const WEEKS := 26
const COUNT := 60
const BOUT_N := 40
const SEED_START := 6100
const SHARP := FireLevel.SHARP_AT
const MASTERY_MAX := 100.0
const CASH_FLOOR := 20000
const BUDGET_MIN := 90.0
const PILOT_N := 6
const STYLES := ["Out-boxer", "Pressure fighter", "Counter-puncher", "Volume puncher", "Boxer-puncher", "Slugger"]
const FIRST := ["Alex", "Sam", "Jordan", "Taylor", "Morgan", "Casey", "Riley", "Quinn", "Avery", "Skyler",
	"Jamie", "Drew", "Blake", "Cameron", "Dakota", "Emerson", "Finley", "Harper", "Hayden", "Jesse",
	"Kai", "Lane", "Logan", "Parker", "Reese", "Rowan", "Sage", "Spencer", "Tatum", "Winter"]
const LAST := ["Smith", "Jones", "Brown", "Wilson", "Taylor", "Davies", "Evans", "Thomas", "Roberts", "Johnson",
	"Walker", "Wright", "Robinson", "White", "Thompson", "Moore", "Clark", "Lewis", "Hall", "Young",
	"King", "Baker", "Lee", "Green", "Adams", "Nelson", "Mitchell", "Harris", "Turner", "Fox"]
const K_ARMS := [1.0, 1.5, 2.0, 3.0]

var weeks := WEEKS
var count := COUNT
var bout_n := BOUT_N
var pilot_only := false
var top_fit := CoachFit.NEUTRAL
var doc: Array = []


func _initialize() -> void:
	var t0 := Time.get_ticks_msec()
	for a in OS.get_cmdline_user_args():
		var kv := str(a).split("=")
		if kv.size() == 2:
			match kv[0]:
				"count": count = int(kv[1])
				"bouts": bout_n = int(kv[1])
				"weeks": weeks = int(kv[1])
				"pilot": pilot_only = int(kv[1]) == 1
	top_fit = CoachFit.fit({"temper": "motivator", "mode": "lift", "boxer": {"morale_word": "Flat", "coachability": 50, "cards_known_share": 0.5}, "over": 0.0, "bond": 110.0, "evening": false, "focus": "this"})
	_say("COACHFITPROBE2 (S529 COACHFIT_SHEET phase 2): can a coach fit be felt inside the cap?")
	_say("TOP fit %d: CoachFit.gain_mult(%d)=%.3f (must equal 1.32: %s). Probe gain at fit %d for k in %s: %s." % [top_fit, top_fit, CoachFit.gain_mult(top_fit), "yes" if is_equal_approx(CoachFit.gain_mult(top_fit), 1.32) else "NO", top_fit, str(K_ARMS), str(K_ARMS.map(func(k): return 1.0 + k * (top_fit - 50) / 100.0))])
	_say("fit 50: gain_mult=%.3f tired_mult=%.3f (both must be 1.000: %s). tired_mult(80)=%.3f tired_mult(35)=%.3f." % [CoachFit.gain_mult(50), CoachFit.tired_mult(50), "yes" if is_equal_approx(CoachFit.gain_mult(50), 1.0) and is_equal_approx(CoachFit.tired_mult(50), 1.0) else "NO", CoachFit.tired_mult(80), CoachFit.tired_mult(35)])
	_say("Population: %d boxers, seeds %d..%d. Part 1: %d weeks. Part 2: %d bouts a boxer per arm." % [count, SEED_START, SEED_START + count - 1, weeks, bout_n])
	var train_ms := _pilot(t0)
	if pilot_only:
		print("COACHFITPROBE2 pilot only")
		quit(0)
		return
	var slope_result := "NONE"
	for k in K_ARMS:
		if float(Time.get_ticks_msec() - t0) > BUDGET_MIN * 60000.0:
			_say("COACHFITPROBE2 stopped at budget.")
			quit(1)
			return
		_say("--- k=%.1f ---" % k)
		var det := _same(_train(SEED_START, "AVERAGE", k), _train(SEED_START, "AVERAGE", k))
		_say("CONTROL determinism: %s" % det)
		var runs := {}
		for arm in ["AVERAGE", "TOP", "CONTROL"]:
			var arr := []
			for i in count:
				if float(Time.get_ticks_msec() - t0) > BUDGET_MIN * 60000.0:
					quit(1)
					return
				arr.append(_train(SEED_START + i, arm, k))
			runs[arm] = arr
			_arm_line(arm, arr, k)
		var ctl := _control(runs["AVERAGE"], runs["CONTROL"])
		_say("CONTROL: %s" % ctl)
		if ctl != "match":
			quit(1)
			return
		var wins := _run_bouts(runs)
		var v := _verdict(runs, wins, k)
		var sharp_ok := float(v["sharp_diff"]) >= 2.0 and float(v["sharp_diff"]) <= 4.0
		var win_ok := float(v["win_diff"]) >= 4.0 and float(v["win_diff"]) <= 8.0
		_say("k=%.1f: Sharp %+.2f weeks (%s) | wins %+.2f in 100 (%s)" % [k, float(v["sharp_diff"]), "in" if sharp_ok else "OUT", float(v["win_diff"]), "in" if win_ok else "OUT"])
		if sharp_ok and win_ok and slope_result == "NONE":
			slope_result = "%.1f" % k
	_say("COACHFITPROBE2 slope=%s" % slope_result)
	var tired := _tiredness_probe()
	_say("COACHFITPROBE2 tired=%s ahead=%.1f r3_down=%.1f" % [tired["result"], float(tired["ahead"]), float(tired["r3_down"])])
	_write_doc(slope_result, tired, float(Time.get_ticks_msec() - t0) / 1000.0)
	quit(0)


func _say(s: String) -> void:
	print(s)
	doc.append(s)


func _pilot(t0: int) -> float:
	var train_ms := 0.0
	var pr: Dictionary = {}
	for i in PILOT_N:
		var t1 := Time.get_ticks_msec()
		pr = _train(SEED_START + i, "TOP", 1.0)
		train_ms += float(Time.get_ticks_msec() - t1)
	train_ms /= float(PILOT_N)
	var tp := Time.get_ticks_msec()
	_bouts(pr["f26"], SEED_START, 8, BoutRules.fight_power(pr["f26"]["stats"], {}, 0, ""))
	var bout_ms := (Time.get_ticks_msec() - tp) / 8.0
	_say("Pilot: %.0f ms/run, %.1f ms/bout -> projected %.1f min (budget %.0f min)." % [train_ms, bout_ms, (train_ms * count * 3.0 * K_ARMS.size() + bout_ms * count * 2.0 * bout_n * K_ARMS.size()) / 60000.0, BUDGET_MIN])
	return train_ms


func _raw(seed_val: int) -> Dictionary:
	var i := seed_val - SEED_START
	var rng := RandomNumberGenerator.new()
	rng.seed = seed_val * 7919 + 11
	var bases: Array = [Data.lucy()]
	for p in Data.PROSPECTS:
		bases.append((p as Dictionary).duplicate(true))
	var b: Dictionary = (bases[i % bases.size()] as Dictionary).duplicate(true)
	var stats := {}
	for k in Data.STATS:
		stats[k] = clampf(float(b["stats"][k]) + rng.randf_range(-6.0, 6.0), 35.0, 80.0)
	var cards: Array = Data.CARDS.duplicate()
	for j in range(cards.size() - 1, 0, -1):
		var k2 := rng.randi_range(0, j)
		var tmp: Variant = cards[j]
		cards[j] = cards[k2]
		cards[k2] = tmp
	var first: String = FIRST[i % FIRST.size()]
	var last: String = LAST[(i + int(i / FIRST.size())) % LAST.size()]
	var lim := float(Data.DIVISIONS[str(b["div"])]["limit"])
	b.merge({"id": "fit_%d" % seed_val, "name": "%s %s" % [first, last], "first": first, "age": clampi(int(b["age"]) + rng.randi_range(-2, 4), 16, 30), "pot": clampi(int(b["pot"]) + rng.randi_range(-6, 8), 60, 92), "style": STYLES[rng.randi_range(0, STYLES.size() - 1)], "stance": "southpaw" if rng.randf() < 0.25 else "orthodox", "focus": Data.STATS[i % Data.STATS.size()], "cards": cards.slice(0, 3), "weight": lim + rng.randf_range(-0.4, 1.0), "stats": stats}, true)
	return b


func _career(seed_val: int) -> Career:
	var c := Career.quick_start()
	c.seed = seed_val
	c.first_hour = {}
	FirstWeek.skip(c)
	for r in c.rivals:
		var others: Array = c.rivals.filter(func(o): return str(o.get("div", "")) == str(r.get("div", ""))).map(func(o): return [o["name"], o["club"]])
		r["bouts"] = RivalPast.seed(r, others, c.seed, c.day)
	c.coach = Data.coach("reid")
	c.fighters.clear()
	c.fighters.append(Data.fighter_state(_raw(seed_val), c.day))
	c.cash = maxi(c.cash, CASH_FLOOR)
	return c


func _train(seed_val: int, arm: String, k: float) -> Dictionary:
	var c := _career(seed_val)
	var f := c.fighter()
	var focus := Sim.focus_of(c, f)
	var s0: Dictionary = (f["stats"] as Dictionary).duplicate()
	var fit := top_fit if arm == "TOP" else CoachFit.NEUTRAL
	var gm := 1.0 + k * (fit - 50) / 100.0 if arm != "CONTROL" else 1.0
	var tm := CoachFit.tired_mult(fit) if arm != "CONTROL" else 1.0
	var scale := arm != "CONTROL"
	var sharp_week := weeks + 1
	for m in Data.MOVES:
		if float(f["moves"][m]) >= SHARP:
			sharp_week = 0
			break
	var fat_sum := 0.0
	var capped := 0
	var eve := {"added": 0.0, "weeks": 0, "moves": 0}
	for w in weeks:
		var wk0: Dictionary = (f["moves"] as Dictionary).duplicate()
		for d in 7:
			var dow := posmod(c.day, 7)
			var before := float(f["stats"][focus])
			var fat0 := float(f.get("week_fatigue", 20.0))
			var keep := WeekPlan.fatigue_keep(Sim.week_ctx(c, f, dow)) if scale and tm != 1.0 else 1.0
			c.cash = maxi(c.cash, CASH_FLOOR)
			Sim.step_day(c)
			if scale:
				var r := _apply(f, focus, before, fat0, dow, gm, tm, keep)
				capped += int(r["capped"])
			if posmod(c.day, 7) == 0:
				if scale:
					var e := _evenings(f, wk0, gm)
					for key in eve:
						eve[key] = float(eve[key]) + float(e[key])
					capped += int(e["cap_bound"])
			fat_sum += float(f.get("week_fatigue", 20.0))
		if sharp_week > weeks:
			for m in Data.MOVES:
				if float(f["moves"][m]) >= SHARP:
					sharp_week = w + 1
					break
	return {"seed": seed_val, "arm": arm, "k": k, "gain": float(f["stats"][focus]) - float(s0[focus]), "sharp_week": sharp_week, "eve": eve, "fat_mean": fat_sum / float(weeks * 7), "capped": capped, "stats": (f["stats"] as Dictionary).duplicate(), "moves": (f["moves"] as Dictionary).duplicate(), "f26": f.duplicate(true)}


func _apply(f: Dictionary, focus: String, before: float, fat0: float, dow: int, gm: float, tm: float, keep: float) -> Dictionary:
	var camp_mult := BoutRules.camp_gain_mult(f.get("camp", {}), focus)
	var cap := CoachFit.capped(gm, camp_mult)
	var extra := maxf(0.0, float(f["stats"][focus]) - before) * (float(cap["mult"]) / camp_mult - 1.0)
	if extra > 0.0:
		f["stats"][focus] = minf(Sim.STAT_CAP, float(f["stats"][focus]) + extra)
	if tm != 1.0:
		var nf := float(f.get("week_fatigue", 20.0))
		nf = clampf(nf - (1.0 - tm) * maxf(0.0, nf - keep * fat0), 0.0, 100.0)
		f["week_fatigue"] = nf
	return {"capped": 1 if bool(cap["capped"]) and extra > 0.0 else 0}


func _evenings(f: Dictionary, wk0: Dictionary, gm: float) -> Dictionary:
	var focus := str(f.get("focus", ""))
	var camp_mult := BoutRules.camp_gain_mult(f.get("camp", {}), focus)
	var cap := CoachFit.capped(gm, camp_mult)
	var mult := float(cap["mult"]) / camp_mult - 1.0
	var moves: Dictionary = f["moves"]
	var added := 0.0
	var hit := 0
	if mult > 0.0:
		for m in Data.MOVES:
			var rise := float(moves[m]) - float(wk0.get(m, 0.0))
			var was := float(moves[m])
			var now := minf(MASTERY_MAX, was + maxf(0.0, rise) * mult)
			if rise > 0.0 and now > was:
				moves[m] = now
				added += now - was
				hit += 1
	return {"added": added, "weeks": 1 if hit > 0 else 0, "moves": hit, "cap_bound": 1 if bool(cap["capped"]) and added > 0.0 else 0}


func _bouts(f26: Dictionary, seed_val: int, n: int, rating: float) -> Dictionary:
	var c := _career(seed_val)
	var wins := 0
	for i in n:
		var f := f26.duplicate(true)
		f["camp"] = {}
		f["morale"] = 60.0
		f["week_fatigue"] = 20.0
		f["notes_seen"] = []
		f.erase("last_bout_day")
		c.fighters = [f]
		c.day = 20 + i
		c.results.clear()
		var opp := (Data.OPPONENTS[i % Data.OPPONENTS.size()] as Dictionary).duplicate(true)
		opp["rating"] = rating
		f["bout"] = {"opp": opp, "day": c.day, "weighed": true, "made": true, "done": false, "film": 1}
		var m := {"fid": f["id"], "step": "tape", "total": 3}
		_play(c, f, m)
		wins += 1 if str(m.get("outcome", "")) == "win" else 0
	return {"wins": wins, "n": n}


func _play(c: Career, f: Dictionary, m: Dictionary) -> void:
	Bouts.fight_step(c, f, m, "start")
	while true:
		while not LiveRound.live(m).is_empty():
			Bouts.fight_step(c, f, m, "shout:")
		if int(m["round"]) >= Bouts.rounds_of(f) or Bouts.stopped(m) != "":
			break
		Bouts.fight_step(c, f, m, "corner:" + BoutRules.auto_corner(f["stats"]))
	Bouts.fight_step(c, f, m, "end")


func _run_bouts(runs: Dictionary) -> Dictionary:
	var paper := []
	for i in count:
		paper.append(BoutRules.fight_power((runs["AVERAGE"][i] as Dictionary)["f26"]["stats"], {}, 0, ""))
	var wins := {}
	for arm in ["AVERAGE", "TOP"]:
		var tot := 0
		for i in count:
			var r := _bouts((runs[arm][i] as Dictionary)["f26"], SEED_START + i, bout_n, float(paper[i]))
			tot += int(r["wins"])
		wins[arm] = tot
		_say("TRAINBALANCE %s wins=%d/%d = %.2f in 100" % [arm, tot, count * bout_n, float(tot) * 100.0 / float(count * bout_n)])
	return wins


func _arm_line(arm: String, arr: Array, k: float) -> void:
	var sharp := []
	var gains := []
	var eve := []
	var capped_total := 0
	for r in arr:
		sharp.append(float(r["sharp_week"]))
		gains.append(float(r["gain"]))
		eve.append(float((r["eve"] as Dictionary)["added"]))
		capped_total += int(r["capped"])
	_say("  %s k=%.1f Sharp=%.2f gain=%+.3f eve+=%.2f capped=%d" % [arm, k, _mean(sharp), _mean(gains), _mean(eve), capped_total])


func _verdict(runs: Dictionary, wins: Dictionary, k: float) -> Dictionary:
	var sa := []
	var st := []
	for i in count:
		sa.append(float((runs["AVERAGE"][i] as Dictionary)["sharp_week"]))
		st.append(float((runs["TOP"][i] as Dictionary)["sharp_week"]))
	var sharp_diff := _mean(sa) - _mean(st)
	var win_diff := float(int(wins["TOP"]) - int(wins["AVERAGE"])) * 100.0 / float(count * bout_n)
	return {"sharp_diff": sharp_diff, "win_diff": win_diff}


func _control(avg: Array, ctl: Array) -> String:
	for i in avg.size():
		var d := _same(avg[i], ctl[i])
		if d != "match":
			return "DIFF at %d: %s" % [i, d]
	return "match"


func _same(a: Dictionary, b: Dictionary) -> String:
	for k in ["gain", "sharp_week", "capped"]:
		if a[k] != b[k]:
			return "%s %s vs %s" % [k, str(a[k]), str(b[k])]
	for key in (a["eve"] as Dictionary):
		if float(a["eve"][key]) != float(b["eve"][key]):
			return "eve %s %s vs %s" % [str(key), str(a["eve"][key]), str(b["eve"][key])]
	for grp in ["stats", "moves"]:
		for key in (a[grp] as Dictionary):
			if float(a[grp][key]) != float(b[grp][key]):
				return "%s %s diff" % [grp, str(key)]
	return "match"


func _mean(arr: Array) -> float:
	var t := 0.0
	for v in arr:
		t += float(v)
	return t / float(maxi(1, arr.size()))


func _tiredness_probe() -> Dictionary:
	_say("--- TIREDNESS ---")
	var ahead_sum := 0.0
	var r3_down_sum := 0.0
	var n := mini(count, 20)
	for i in n:
		var seed_val := SEED_START + i
		var c := _career(seed_val)
		var f := c.fighter()
		for w in weeks:
			for d in 7:
				c.cash = maxi(c.cash, CASH_FLOOR)
				Sim.step_day(c)
		var f26 := f.duplicate(true)
		var fat_start := float(f26.get("week_fatigue", 20.0))
		var e80 := _tiredness_bout(f26.duplicate(true), 80, seed_val)
		var e35 := _tiredness_bout(f26.duplicate(true), 35, seed_val)
		var ahead := float(e80["last_bell"]) - float(e35["last_bell"])
		var r3_down := float(e80["r3_end"]) - float(e35["r3_end"])
		ahead_sum += ahead
		r3_down_sum += r3_down
		if i < 3:
			_say("  boxer %d: fat_start=%.1f | fit80 fat_end=%.1f last_bell=%.1f r3=%.1f | fit35 fat_end=%.1f last_bell=%.1f r3=%.1f | ahead=%.1f r3_down=%.1f" % [i, fat_start, float(e80["fat_end"]), float(e80["last_bell"]), float(e80["r3_end"]), float(e35["fat_end"]), float(e35["last_bell"]), float(e35["r3_end"]), ahead, r3_down])
	var ahead_mean := ahead_sum / float(n)
	var r3_down_mean := r3_down_sum / float(n)
	var ahead_ok := ahead_mean >= 8.0 and ahead_mean <= 12.0
	var r3_ok := r3_down_mean >= 15.0 and r3_down_mean <= 20.0
	_say("TIREDNESS n=%d: ahead=%.1f (8..12: %s) r3_down=%.1f (15..20: %s)" % [n, ahead_mean, "in" if ahead_ok else "OUT", r3_down_mean, "in" if r3_ok else "OUT"])
	return {"result": "pass" if ahead_ok and r3_ok else "fail", "ahead": ahead_mean, "r3_down": r3_down_mean}


func _tiredness_bout(f26: Dictionary, fit: int, seed_val: int) -> Dictionary:
	var c := _career(seed_val)
	var f := f26.duplicate(true)
	var tm := CoachFit.tired_mult(fit)
	var fat0 := float(f.get("week_fatigue", 20.0))
	var days := WeekPlan.days_of(f)
	var evenings := WeekPlan.evenings_of(f)
	var ctx := Sim.week_ctx(c, f, 0)
	ctx["fatigue"] = fat0
	for d in 7:
		var day_spec := (days[d] as Array)
		var day_id := str(day_spec[0])
		var intensity := str(day_spec[1])
		var eve_id := str(evenings[d])
		var before := float(f.get("week_fatigue", 20.0))
		var keep := WeekPlan.fatigue_keep(ctx)
		var r := WeekPlan.full_day(day_id, intensity, eve_id, ctx, before)
		var after := float(r["fatigue"])
		if tm != 1.0:
			after = clampf(after - (1.0 - tm) * maxf(0.0, after - keep * before), 0.0, 100.0)
		f["week_fatigue"] = after
		ctx["fatigue"] = after
	f["week_fatigue"] = float(f.get("week_fatigue", 20.0))
	f["camp"] = {"protocol": "normal", "days": 5}
	f["morale"] = 60.0
	f["notes_seen"] = []
	f.erase("last_bout_day")
	c.fighters = [f]
	c.day = 20
	c.results.clear()
	var opp := (Data.OPPONENTS[0] as Dictionary).duplicate(true)
	opp["rating"] = BoutRules.fight_power(f["stats"], {}, 0, "")
	f["bout"] = {"opp": opp, "day": c.day, "weighed": true, "made": true, "done": false, "film": 1}
	var m := {"fid": f["id"], "step": "tape", "total": 3}
	var energy_at_round := []
	Bouts.fight_step(c, f, m, "start")
	energy_at_round.append(float(f["bout"]["energy"]["a"]))
	while true:
		while not LiveRound.live(m).is_empty():
			Bouts.fight_step(c, f, m, "shout:")
		if int(m["round"]) >= Bouts.rounds_of(f) or Bouts.stopped(m) != "":
			break
		Bouts.fight_step(c, f, m, "corner:" + BoutRules.auto_corner(f["stats"]))
		energy_at_round.append(float(f["bout"]["energy"]["a"]))
	Bouts.fight_step(c, f, m, "end")
	var last_bell := float(f["bout"]["energy"]["a"])
	var r3_end := float(energy_at_round[3]) if energy_at_round.size() > 3 else last_bell
	return {"last_bell": last_bell, "r3_end": r3_end, "fat_end": f["week_fatigue"]}


func _write_doc(slope_result: String, tired: Dictionary, secs: float) -> void:
	var fh := FileAccess.open("res://docs/COACHFITPROBE2_RESULT.md", FileAccess.WRITE)
	if fh == null:
		return
	fh.store_string("# COACHFITPROBE2 Result\n\nProbe run: %s. S529 COACHFIT_SHEET phase 2.\n\n" % Time.get_datetime_string_from_system())
	fh.store_string("## Question\n\nCan a coach fit be felt inside the cap?\n\n")
	fh.store_string("## Method\n\n- SLOPE: `1.0 + k * (fit - 50) / 100.0` for k in [1.0, 1.5, 2.0, 3.0], through `CoachFit.capped()`.\n- TIREDNESS: camp week at tired_mult(80) vs tired_mult(35), then 4-round bout.\n\n")
	fh.store_string("## Measured\n\n```text\n")
	for line in doc:
		fh.store_line(str(line))
	fh.store_string("```\n\n")
	fh.store_string("## Verdict\n\n- **COACHFITPROBE2 slope=%s**\n" % slope_result)
	fh.store_string("- **COACHFITPROBE2 tired=%s ahead=%.1f r3_down=%.1f**\n\nElapsed: %.0f s.\n" % [str(tired["result"]), float(tired["ahead"]), float(tired["r3_down"]), secs])
	fh.close()
	print("Result doc written to docs/COACHFITPROBE2_RESULT.md")
