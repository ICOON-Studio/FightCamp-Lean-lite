extends SceneTree
## COACHFITPROBE3 (S530 COACHFIT_SHEET phase 3b): re-measure coach fit where the design uses it.
## Repairs COACHFITPROBE2's three misses (critic Arena 10/10 items 1-3):
## 1. DOSE CONTROL: Does +1 stat move wins at all? Three arms (untouched, +0.95, +5) at even odds.
## 2. SLOPE ON THE WIRED LEVER: Scale CoachedMornings.day_mult and drill nights by 1+k*(fit-50)/100.
## 3. TIREDNESS IN CAMP: Read week_peak, mornings past 80, fatigue_mult, PeakCamp.met.

const CoachFit := preload("res://scripts/rules/CoachFit.gd")
const CoachedMornings := preload("res://scripts/rules/CoachedMornings.gd")
const Data := preload("res://scripts/state/Data.gd")
const Sim := preload("res://scripts/state/Sim.gd")
const Bouts := preload("res://scripts/state/Bouts.gd")
const BoutRules := preload("res://scripts/rules/BoutRules.gd")
const LiveRound := preload("res://scripts/state/LiveRound.gd")
const InjuryRoll := preload("res://scripts/rules/InjuryRoll.gd")
const PeakCamp := preload("res://scripts/rules/PeakCamp.gd")
const FireLevel := preload("res://scripts/rules/FireLevel.gd")
const RivalPast := preload("res://scripts/rules/RivalPast.gd")
const FirstWeek := preload("res://scripts/rules/FirstWeek.gd")
const WeekPlan := preload("res://scripts/rules/WeekPlan.gd")
const PadWeek := preload("res://scripts/rules/PadWeek.gd")
const MorningWire := preload("res://scripts/state/MorningWire.gd")
const HeadCoach := preload("res://scripts/rules/HeadCoach.gd")
const Attrs := preload("res://scripts/rules/Attrs.gd")

const WEEKS := 26
const COUNT := 60
const BOUT_N := 40
const SEED_START := 6100
const SHARP := FireLevel.SHARP_AT
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
const K_ARMS := [1.0, 1.5, 2.0]
const FIT_ARMS := {"AVERAGE": 50, "TOP": 82, "RISKY": 34}

var weeks := WEEKS
var count := COUNT
var bout_n := BOUT_N
var pilot_only := false
var top_fit: int = CoachFit.NEUTRAL
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
	_say("COACHFITPROBE3 (S530 COACHFIT_SHEET phase 3b): re-measure coach fit where the design uses it.")
	_say("TOP fit %d, AVERAGE 50, RISKY 34. Scale CoachedMornings.day_mult and drill nights by 1+k*(fit-50)/100." % top_fit)
	_say("Population: %d boxers, seeds %d..%d. %d weeks. %d bouts a boxer." % [count, SEED_START, SEED_START + count - 1, weeks, bout_n])
	var _train_ms := _pilot(t0)
	if pilot_only:
		print("COACHFITPROBE3 pilot only")
		quit(0)
		return
	_say("--- PART 1: DOSE CONTROL ---")
	var dose_result := _dose_control(t0)
	_say("COACHFITPROBE3 dose=%s plus5_even=%d" % [dose_result["verdict"], int(dose_result["plus5_delta"])])
	_say("--- PART 2: SLOPE ON THE WIRED LEVER ---")
	var slope_result := _slope_probe(t0)
	_say("COACHFITPROBE3 slope=%s" % slope_result)
	_say("--- PART 3: TIREDNESS IN CAMP ---")
	var camp_result := _camp_probe(t0)
	_say("COACHFITPROBE3 camp=%s" % camp_result)
	_write_doc(dose_result, slope_result, camp_result, float(Time.get_ticks_msec() - t0) / 1000.0)
	quit(0)


func _say(s: String) -> void:
	print(s)
	doc.append(s)


func _pilot(_t0: int) -> float:
	var train_ms := 0.0
	for i in PILOT_N:
		var t1 := Time.get_ticks_msec()
		_train(SEED_START + i, "TOP", 1.0)
		train_ms += float(Time.get_ticks_msec() - t1)
	train_ms /= float(PILOT_N)
	_say("Pilot: %.0f ms/run -> projected %.1f min (budget %.0f min)." % [train_ms, (train_ms * count * 3.0 * K_ARMS.size() + train_ms * count * 3.0) / 60000.0, BUDGET_MIN])
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


func _week_ctx(career: Career, f: Dictionary, dow: int) -> Dictionary:
	var cutting := (str(f["diet"]) == "cut" or not (f.get("camp", {}) as Dictionary).is_empty()) and float(f["weight"]) > float(f["limit"]) - 0.15
	var ev := BoutRules.camp_evening(f.get("camp", {}))
	return {"stats": f["stats"], "pot": int(f["pot"]), "coach": career.coach.duplicate(true), "weight": float(f["weight"]),
		"diet": "cut" if cutting else "hold", "fatigue": float(f.get("week_fatigue", 20.0)), "phase": str(f.get("phase", "base")),
		"recovery": float(Attrs.of(f).get("recovery", 55.0)),
		"camp_stat": str(ev["stat"]), "eve_drill": float(ev["drill"]), "eve_load": float(ev["load"]), "camp_on": PadWeek.in_camp(f),
		"camp_mult": BoutRules.camp_gain_mult(f.get("camp", {}), str(ev["stat"])), "dow": dow, "coached": MorningWire.of(career, f)}.merged(HeadCoach.ctx(career.head))


func _train(seed_val: int, arm: String, k: float) -> Dictionary:
	var c := _career(seed_val)
	# Add a second boxer so coached mornings work (MorningWire needs 2+ boxers)
	var raw2 := _raw(seed_val + 1000)
	c.fighters.append(Data.fighter_state(raw2, c.day))
	var f := c.fighter()
	var focus := Sim.focus_of(c, f)
	var s0: Dictionary = (f["stats"] as Dictionary).duplicate()
	var fit_val: int = FIT_ARMS[arm] if arm != "CONTROL" else 50
	var scale_factor: float = 1.0 + k * (fit_val - 50) / 100.0 if arm != "CONTROL" else 1.0
	var sharp_week: int = weeks + 1
	for m in Data.MOVES:
		if float(f["moves"][m]) >= SHARP:
			sharp_week = 0
			break
	for w in weeks:
		for _d in 7:
			var dow := posmod(c.day, 7)
			var before_focus := float(f["stats"][focus])
			c.cash = maxi(c.cash, CASH_FLOOR)
			var ctx := _week_ctx(c, f, dow)
			var coached_mult: float = CoachedMornings.day_mult(ctx.get("coached", {}), dow, focus)
			var is_drill: bool = str(ctx.get("camp_stat", "")) == focus and str(PadWeek.evenings(f)[dow]) == "pads" and float(ctx.get("eve_drill", 0.0)) > 0.0
			Sim.step_day(c)
			if coached_mult > 1.0 and arm != "CONTROL":
				var after_focus: float = float(f["stats"][focus])
				var gain: float = after_focus - before_focus
				if gain > 0.0:
					var extra: float = gain * (1.0 - 1.0 / coached_mult)
					var scaled_extra: float = extra * (scale_factor - 1.0)
					f["stats"][focus] = minf(Sim.STAT_CAP, after_focus + scaled_extra)
			if is_drill and arm != "CONTROL":
				var after_focus2: float = float(f["stats"][focus])
				var gain2: float = after_focus2 - before_focus
				if gain2 > 0.0:
					var drill_share: float = gain2 * 0.3
					var scaled_drill: float = drill_share * (scale_factor - 1.0)
					f["stats"][focus] = minf(Sim.STAT_CAP, after_focus2 + scaled_drill)
			if posmod(c.day, 7) == 0:
				if sharp_week > weeks:
					for m in Data.MOVES:
						if float(f["moves"][m]) >= SHARP:
							sharp_week = w + 1
							break
	return {"seed": seed_val, "arm": arm, "k": k, "gain": float(f["stats"][focus]) - float(s0[focus]), "sharp_week": sharp_week, "stats": (f["stats"] as Dictionary).duplicate(), "moves": (f["moves"] as Dictionary).duplicate(), "f26": f.duplicate(true)}


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


func _dose_control(t0: int) -> Dictionary:
	var arms := ["untouched", "plus095", "plus5"]
	var runs := {}
	for arm in arms:
		var arr := []
		for i in count:
			if float(Time.get_ticks_msec() - t0) > BUDGET_MIN * 60000.0:
				quit(1)
				return {"verdict": "blind", "plus5_delta": 0}
			var r := _train(SEED_START + i, "CONTROL", 1.0)
			if arm == "plus095":
				var foc: String = str(r["f26"]["focus"])
				r["f26"]["stats"][foc] = minf(Sim.STAT_CAP, float(r["f26"]["stats"][foc]) + 0.95)
			elif arm == "plus5":
				var foc: String = str(r["f26"]["focus"])
				r["f26"]["stats"][foc] = minf(Sim.STAT_CAP, float(r["f26"]["stats"][foc]) + 5.0)
			arr.append(r)
		runs[arm] = arr
	var wins_even := {}
	var paper := []
	for i in count:
		paper.append(BoutRules.fight_power((runs["untouched"][i] as Dictionary)["f26"]["stats"], {}, 0, ""))
	for arm in arms:
		var tot := 0
		for i in count:
			var r := _bouts((runs[arm][i] as Dictionary)["f26"], SEED_START + i, bout_n, float(paper[i]))
			tot += int(r["wins"])
		wins_even[arm] = tot
		_say("DOSE even %s wins=%d/%d = %.2f in 100" % [arm, tot, count * bout_n, float(tot) * 100.0 / float(count * bout_n)])
	var plus5_delta: float = float(int(wins_even["plus5"]) - int(wins_even["untouched"])) * 100.0 / float(count * bout_n)
	var verdict: String = "ok" if plus5_delta >= 10.0 else "blind"
	_say("DOSE: +5 even delta = %.2f in 100 (need 10+: %s)" % [plus5_delta, verdict])
	return {"verdict": verdict, "plus5_delta": plus5_delta}


func _slope_probe(t0: int) -> String:
	var result := "NONE"
	for k in K_ARMS:
		if float(Time.get_ticks_msec() - t0) > BUDGET_MIN * 60000.0:
			_say("COACHFITPROBE3 stopped at budget.")
			quit(1)
			return "NONE"
		_say("--- k=%.1f ---" % k)
		var runs := {}
		for arm in ["AVERAGE", "TOP", "RISKY", "CONTROL"]:
			var arr := []
			for i in count:
				if float(Time.get_ticks_msec() - t0) > BUDGET_MIN * 60000.0:
					quit(1)
					return "NONE"
				arr.append(_train(SEED_START + i, arm, k))
			runs[arm] = arr
			_arm_line(arm, arr, k)
		var ctl := _control(runs["AVERAGE"], runs["CONTROL"])
		_say("CONTROL: %s" % ctl)
		if ctl != "match":
			quit(1)
			return "NONE"
		var paper := []
		for i in count:
			paper.append(BoutRules.fight_power((runs["AVERAGE"][i] as Dictionary)["f26"]["stats"], {}, 0, ""))
		var wins := {}
		for arm in ["AVERAGE", "TOP", "RISKY"]:
			var tot := 0
			for i in count:
				var r := _bouts((runs[arm][i] as Dictionary)["f26"], SEED_START + i, bout_n, float(paper[i]))
				tot += int(r["wins"])
			wins[arm] = tot
			_say("SLOPE %s k=%.1f wins=%d/%d = %.2f in 100" % [arm, k, tot, count * bout_n, float(tot) * 100.0 / float(count * bout_n)])
		var sa := []
		var st := []
		for i in count:
			sa.append(float((runs["AVERAGE"][i] as Dictionary)["sharp_week"]))
			st.append(float((runs["TOP"][i] as Dictionary)["sharp_week"]))
		var sharp_diff: float = _mean(sa) - _mean(st)
		var win_diff: float = float(int(wins["TOP"]) - int(wins["AVERAGE"])) * 100.0 / float(count * bout_n)
		_say("k=%.1f: Sharp %+.2f weeks | wins %+.2f in 100" % [k, sharp_diff, win_diff])
		var sharp_ok: bool = sharp_diff >= 2.0 and sharp_diff <= 4.0
		var win_ok: bool = win_diff >= 4.0 and win_diff <= 8.0
		if (sharp_ok or win_ok) and result == "NONE":
			result = "%.1f" % k
	return result


func _arm_line(arm: String, arr: Array, k: float) -> void:
	var sharp := []
	var gains := []
	var tiers := []
	for r in arr:
		sharp.append(float(r["sharp_week"]))
		gains.append(float(r["gain"]))
		var max_m := 0.0
		for m in Data.MOVES:
			max_m = maxf(max_m, float((r["moves"] as Dictionary)[m]))
		var tier := "Usable" if max_m >= FireLevel.USABLE_AT else "below"
		if max_m >= SHARP:
			tier = "Sharp"
		if max_m >= FireLevel.SIGNATURE_AT:
			tier = "Signature"
		tiers.append(tier)
	var tier_count := {}
	for t in tiers:
		tier_count[t] = tier_count.get(t, 0) + 1
	_say("  %s k=%.1f Sharp=%.2f gain=%+.3f tiers=%s" % [arm, k, _mean(sharp), _mean(gains), str(tier_count)])


func _control(avg: Array, ctl: Array) -> String:
	for i in avg.size():
		var d := _same(avg[i], ctl[i])
		if d != "match":
			return "DIFF at %d: %s" % [i, d]
	return "match"


func _same(a: Dictionary, b: Dictionary) -> String:
	for key in ["gain", "sharp_week"]:
		if a[key] != b[key]:
			return "%s %s vs %s" % [key, str(a[key]), str(b[key])]
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


func _camp_probe(t0: int) -> String:
	var fits := [82, 50, 34]
	var protocols := [2, 3]
	var results := {}
	for fit_val in fits:
		results[fit_val] = {}
		for proto in protocols:
			var peak_sum := 0.0
			var mornings_past_80 := 0
			var peak_met := 0
			var total_weeks := 0
			for i in mini(count, 20):
				if float(Time.get_ticks_msec() - t0) > BUDGET_MIN * 60000.0:
					quit(1)
					return "fail"
				var r := _train(SEED_START + i, "CONTROL", 1.0)
				var f26 := (r["f26"] as Dictionary).duplicate(true)
				var c := _career(SEED_START + i)
				var f := f26
				f["camp"] = {"protocol": proto, "days": 5, "focus": str(f["focus"]), "peak": 0.0}
				c.fighters = [f]
				var tm: float = CoachFit.tired_mult(fit_val)
				var week_peak := 0.0
				var mornings_over := 0
				for _d in 7:
					var dow := posmod(c.day, 7)
					var fat0: float = float(f.get("week_fatigue", 20.0))
					if fat0 > 80.0:
						mornings_over += 1
					c.cash = maxi(c.cash, CASH_FLOOR)
					Sim.step_day(c)
					var fat_after: float = float(f.get("week_fatigue", 20.0))
					if tm != 1.0:
						var keep: float = WeekPlan.fatigue_keep(_week_ctx(c, f, dow))
						fat_after = clampf(fat_after - (1.0 - tm) * maxf(0.0, fat_after - keep * fat0), 0.0, 100.0)
						f["week_fatigue"] = fat_after
					week_peak = maxf(week_peak, fat_after)
				peak_sum += week_peak
				var lines: Array = PeakCamp.lines(f["camp"], f)
				if PeakCamp.met(lines):
					peak_met += 1
				total_weeks += 1
				mornings_past_80 += mornings_over
			var proto_name: String = "Standard" if proto == 2 else "Hard"
			var avg_peak: float = peak_sum / float(total_weeks)
			var fat_mult: float = InjuryRoll.fatigue_mult(avg_peak)
			_say("CAMP fit=%d %s: avg_peak=%.1f mornings_past_80=%d fatigue_mult=%.2f peak_met=%d/%d" % [fit_val, proto_name, avg_peak, mornings_past_80, fat_mult, peak_met, total_weeks])
			results[fit_val][proto] = {"avg_peak": avg_peak, "mornings_past_80": mornings_past_80, "fatigue_mult": fat_mult, "peak_met": peak_met, "total": total_weeks}
	var avg_hard_peak: float = float(results[50][3]["avg_peak"])
	var top_hard_peak: float = float(results[82][3]["avg_peak"])
	var avg_hard_fat_mult: float = float(results[50][3]["fatigue_mult"])
	var top_hard_fat_mult: float = float(results[82][3]["fatigue_mult"])
	var peak_ok: bool = avg_hard_peak >= 80.0 and top_hard_peak < 80.0
	var fat_mult_ratio: float = avg_hard_fat_mult / maxf(0.01, top_hard_fat_mult)
	var fat_mult_ok: bool = fat_mult_ratio >= 1.25
	_say("CAMP verdict: avg_hard=%.1f top_hard=%.1f (%s) | avg_fm=%.2f top_fm=%.2f ratio=%.2f (%s)" % [avg_hard_peak, top_hard_peak, "pass" if peak_ok else "fail", avg_hard_fat_mult, top_hard_fat_mult, fat_mult_ratio, "pass" if fat_mult_ok else "fail"])
	return "pass" if (peak_ok or fat_mult_ok) else "fail"


func _write_doc(dose: Dictionary, slope: String, camp: String, secs: float) -> void:
	var fh := FileAccess.open("res://docs/COACHFITPROBE3_RESULT.md", FileAccess.WRITE)
	if fh == null:
		return
	fh.store_string("# COACHFITPROBE3 Result\n\nProbe run: %s. S530 COACHFIT_SHEET phase 3b.\n\n" % Time.get_datetime_string_from_system())
	fh.store_string("## Question\n\nRe-measure coach fit where the design uses it (dose control, coached-morning slope, camp tiredness).\n\n")
	fh.store_string("## Method\n\n")
	fh.store_string("1. DOSE CONTROL: Three arms (untouched, +0.95, +5 on focus stat) at even odds.\n")
	fh.store_string("2. SLOPE ON THE WIRED LEVER: Scale CoachedMornings.day_mult and drill nights by 1 + k*(fit-50)/100 for k in [1.0, 1.5, 2.0].\n")
	fh.store_string("3. TIREDNESS IN CAMP: Standard and Hard camp weeks from week-26 state at tired_mult(82), tired_mult(50), tired_mult(34).\n\n")
	fh.store_string("## Measured\n\n```text\n")
	for line in doc:
		fh.store_line(str(line))
	fh.store_string("```\n\n")
	fh.store_string("## Verdict\n\n")
	fh.store_string("- **COACHFITPROBE3 dose=%s plus5_even=%d**\n" % [str(dose["verdict"]), int(dose["plus5_delta"])])
	fh.store_string("- **COACHFITPROBE3 slope=%s**\n" % slope)
	fh.store_string("- **COACHFITPROBE3 camp=%s**\n\nElapsed: %.0f s.\n" % [camp, secs])
	fh.close()
	print("Result doc written to docs/COACHFITPROBE3_RESULT.md")
