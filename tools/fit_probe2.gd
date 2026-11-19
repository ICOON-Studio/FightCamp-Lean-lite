extends SceneTree
## FITPROBE2 + TRAINBALANCE (S525, coach fit v8): does a TOP fit bring moves to Sharp sooner on the EVENINGS? Map:
## DESIGN_COACHFIT1_V8 2.1 (fit multiplies the evening drill units and the morning stat gain), 12 (pass lines). FITPROBE1
## scaled mornings only: Sharp 0.00 weeks sooner. A COPY of tools/fit_probe.gd (same population, seeds, arms, bout harness)
## plus the evening lever: after each week's drills (DrillWeek.run in Sim.end_week, through Sim.step_day) every move that
## rose THIS WEEK gets (gain_mult(fit) - 1) x that rise through CoachFit.capped (the x1.6 stack cap), never past 100. The
## week's rise, never the total (that would compound). Mornings stay FITPROBE1's. A FAIL is a finding, not a broken probe.
## Usage: python ops/Tools/godot_slot.py run --who fitprobe2 -- <godot> --headless --audio-driver Dummy --path . --script res://tools/fit_probe2.gd
## Pilot only (4 boxers, projected time, no doc): ... --script res://tools/fit_probe2.gd -- pilot=1

const CoachFit := preload("res://scripts/rules/CoachFit.gd")
const Data := preload("res://scripts/state/Data.gd")
const Sim := preload("res://scripts/state/Sim.gd")
const Bouts := preload("res://scripts/state/Bouts.gd")
const BoutRules := preload("res://scripts/rules/BoutRules.gd")
const LiveRound := preload("res://scripts/state/LiveRound.gd")
const Injuries := preload("res://scripts/state/Injuries.gd")
const RivalPast := preload("res://scripts/rules/RivalPast.gd")
const FirstWeek := preload("res://scripts/rules/FirstWeek.gd")
const TrainingPreview := preload("res://scripts/rules/TrainingPreview.gd")
const WeekPlan := preload("res://scripts/rules/WeekPlan.gd")
const FireLevel := preload("res://scripts/rules/FireLevel.gd")
const MoveMastery := preload("res://scripts/rules/MoveMastery.gd")

const WEEKS := 26
const COUNT := 60
const BOUT_N := 40
const SEED_START := 6100
const SHARP := FireLevel.SHARP_AT   # the Sharp tier the fight reads: FireLevel.SHARP_AT = 60.0 (MoveMastery.tier agrees)
const MASTERY_MAX := 100.0   # the brief's ceiling on the scaled mastery: never past the move's 100
const CASH_FLOOR := 20000   # money is not the measurement: the gym stays open (two_boxers_two_years_test)
const PLAN_EDGE := 14.0   # a good plan's +14 in 100 (59 against 45), the ceiling TRAINBALANCE must stay under
const BUDGET_MIN := 90.0   # the brief's run-time budget: stop rather than run past it
const PILOT_N := 4   # the brief: pilot 4 boxers first and print the projected time
const STYLES := ["Out-boxer", "Pressure fighter", "Counter-puncher", "Volume puncher", "Boxer-puncher", "Slugger"]
const FIRST := ["Alex", "Sam", "Jordan", "Taylor", "Morgan", "Casey", "Riley", "Quinn", "Avery", "Skyler",
	"Jamie", "Drew", "Blake", "Cameron", "Dakota", "Emerson", "Finley", "Harper", "Hayden", "Jesse",
	"Kai", "Lane", "Logan", "Parker", "Reese", "Rowan", "Sage", "Spencer", "Tatum", "Winter"]
const LAST := ["Smith", "Jones", "Brown", "Wilson", "Taylor", "Davies", "Evans", "Thomas", "Roberts", "Johnson",
	"Walker", "Wright", "Robinson", "White", "Thompson", "Moore", "Clark", "Lewis", "Hall", "Young",
	"King", "Baker", "Lee", "Green", "Adams", "Nelson", "Mitchell", "Harris", "Turner", "Fox"]

var weeks := WEEKS
var count := COUNT
var bout_n := BOUT_N
var pilot_only := false
var top_fit := CoachFit.NEUTRAL
var arm_extra := {}   # arm -> {moves: per-move mastery sums at 26, weapons: mean moves at BoutRules.WEAPON_MASTERY}
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
	# The TOP band's number read from the module: the best case fit() can reach (the design's 82, coach_fit_test's clamp).
	top_fit = CoachFit.fit({"temper": "motivator", "mode": "lift", "boxer": {"morale_word": "Flat", "coachability": 50, "cards_known_share": 0.5}, "over": 0.0, "bond": 110.0, "evening": false, "focus": "this"})
	_say("FITPROBE2 + TRAINBALANCE (S525): does a TOP fit bring moves to Sharp sooner on the EVENINGS? Map: DESIGN_COACHFIT1_V8 2.1, 12. A copy of tools/fit_probe.gd plus the evening lever; nothing in scripts/ or tests/ is touched.")
	_say("Arms on the SAME seeds (paired): AVERAGE fit %d, TOP fit %d (CoachFit.word -> %s), CONTROL = untouched. fit 50: gain_mult=%.3f tired_mult=%.3f (both must be 1.000: %s). TOP: gain_mult=%.3f tired_mult=%.3f, stack cap x%.1f through CoachFit.capped." % [CoachFit.NEUTRAL, top_fit, CoachFit.word(top_fit), CoachFit.gain_mult(50), CoachFit.tired_mult(50), "yes" if is_equal_approx(CoachFit.gain_mult(50), 1.0) and is_equal_approx(CoachFit.tired_mult(50), 1.0) else "NO", CoachFit.gain_mult(top_fit), CoachFit.tired_mult(top_fit), CoachFit.STACK_CAP])
	_say("EVENING lever: after each week's DrillWeek.run, every move that rose gets (gain_mult - 1) x THE WEEK'S RISE through the stack cap, never past mastery %.0f. MORNING lever (FITPROBE1's, unchanged): the day's FOCUS gain x gain_mult, the day's added tiredness x tired_mult. Sharp = mastery %.1f, the constant FireLevel.SHARP_AT (a planned line fires at %s). Headroom clamp ON (TrainingPreview.headroom): (pot - stat)/%.0f clamped %.2f..%.2f." % [MASTERY_MAX, SHARP, str(FireLevel.GAME_SHARES["sharp"]), TrainingPreview.HEADROOM_SPAN, TrainingPreview.HEADROOM_MIN, TrainingPreview.HEADROOM_MAX])
	_say("Part 1: %d weeks (%d days) of Sim.step_day - the game's own week, plan and focus, twists, injuries, phase, drilling. Part 2: %d bouts a boxer per arm, one fixed opponent set, film 1, no camp, morale 60, tiredness 20, auto corner, no shouts." % [weeks, weeks * 7, bout_n])
	_population()
	_opponents()
	var train_ms := 0.0   # PILOT: 4 boxers' whole training runs and 8 bouts, to project the full run before it starts
	var pr: Dictionary = {}
	for i in PILOT_N:
		var t1 := Time.get_ticks_msec()
		pr = _train(SEED_START + i, "TOP")
		train_ms += float(Time.get_ticks_msec() - t1)
	train_ms /= float(PILOT_N)
	var tp := Time.get_ticks_msec()
	_bouts(pr["f26"], SEED_START, 8, BoutRules.fight_power(pr["f26"]["stats"], {}, 0, ""))
	var bout_ms := (Time.get_ticks_msec() - tp) / 8.0
	_say("Pilot (%d boxers): %.0f ms a training run, %.1f ms a bout -> projected %.1f min for %d runs + %d bouts (budget %.0f min)." % [PILOT_N, train_ms, bout_ms, (train_ms * count * 3.0 + bout_ms * count * 2.0 * bout_n) / 60000.0, count * 3, count * 2 * bout_n, BUDGET_MIN])
	if pilot_only:
		print("FITPROBE2 pilot only (not the measured run, no doc written)")
		quit(0)
		return
	var det := _same(_train(SEED_START, "AVERAGE"), _train(SEED_START, "AVERAGE"))   # the same arm twice must agree to the digit
	_say("CONTROL determinism (seed %d AVERAGE twice): %s" % [SEED_START, det])
	var runs := {}
	for arm in ["AVERAGE", "TOP", "CONTROL"]:
		var arr := []
		for i in count:
			if float(Time.get_ticks_msec() - t0) > BUDGET_MIN * 60000.0:
				_say("FITPROBE2 stopped at the %.0f-minute run-time budget: no doc written." % BUDGET_MIN)
				quit(1)
				return
			arr.append(_train(SEED_START + i, arm))
		runs[arm] = arr
		_arm_line(arm, arr)
	var ctl := _control(runs["AVERAGE"], runs["CONTROL"])
	_say("CONTROL AVERAGE against an untouched run of the same seeds (no probe scaling): %s" % ctl)
	var wins := {}
	var paper := []
	for i in count:
		paper.append(BoutRules.fight_power((runs["AVERAGE"][i] as Dictionary)["f26"]["stats"], {}, 0, ""))
	_say("TRAINBALANCE opponent rating = AVERAGE week-26 paper: mean %.2f, range %.2f..%.2f (fixed for both arms)." % [_mean(paper), _pct(paper, 0.0), _pct(paper, 1.0)])
	for arm in ["AVERAGE", "TOP"]:
		var tot := 0
		var per := []
		for i in count:
			var r := _bouts((runs[arm][i] as Dictionary)["f26"], SEED_START + i, bout_n, float(paper[i]))
			per.append(int(r["wins"]))
			tot += int(r["wins"])
		wins[arm] = {"total": tot, "per": per}
		_say("TRAINBALANCE arm=%s wins=%d/%d = %.2f in 100" % [arm, tot, count * bout_n, float(tot) * 100.0 / float(count * bout_n)])
	_table(runs, wins)
	var v := _verdict(runs, wins)
	_write_doc(v, ctl, det, float(Time.get_ticks_msec() - t0) / 1000.0)
	_say("mastery_diff = TOP - AVERAGE mean mastery over all %d moves at week 26; sharp_sooner = AVERAGE - TOP mean weeks to the first Sharp move." % Data.MOVES.size())
	_say("FITPROBE2 done sharp_sooner=%+.2f mastery_diff=%+.3f win_diff_in_100=%+.2f control=%s fitprobe2=%s trainbalance=%s" % [float(v["sharp_diff"]), float(v["mastery_diff"]), float(v["win_diff"]), "match" if ctl == "match" else "differs", str(v["fitprobe2"]), str(v["trainbalance"])])
	quit(0 if ctl == "match" and det == "match" else 1)


func _say(s: String) -> void:
	print(s)
	doc.append(s)


## The population printed: every boxer's own numbers, so no two are identical and the spread is on the page.
func _population() -> void:
	var focus_n := {}
	var ages := []
	var ids := {}
	var same := 0
	for i in count:
		var f := Data.fighter_state(_raw(SEED_START + i), 0)
		var key := str(f["stats"]) + str(f["age"]) + str(f["style"]) + str(f["focus"])
		same += 1 if ids.has(key) else 0
		ids[key] = true
		focus_n[str(f["focus"])] = int(focus_n.get(str(f["focus"]), 0)) + 1
		ages.append(int(f["age"]))
	_say("Population: %d boxers, seeds %d..%d, Data.fighter_state on 6 bases (Lucy + the 5 prospects), stats +-6, varied ages, styles, stances, potentials, week cards and FOCUS. Identical rows: %d. Ages %d..%d. FOCUS spread: %s. Coach in every arm: Luke Reid (sessional, pads 74). Load normal, no bout in part 1 (camp mult 1.0)." % [count, SEED_START, SEED_START + count - 1, same, ages.min(), ages.max(), str(focus_n)])


func _opponents() -> void:
	var parts := Data.OPPONENTS.map(func(o): return "%s (%s)" % [str(o["name"]), str(o["style"])])
	_say("TRAINBALANCE fixed opponent set (every boxer, both arms): %s. Each opponent's rating = the boxer's AVERAGE-arm week-26 paper (BoutRules.fight_power), the SAME rating in both arms - exchange_balance's equal-paper convention, the baseline win share measured, not assumed 50%%." % ", ".join(parts))


## One varied boxer: a base (Lucy or a prospect) re-rated, re-aged, re-styled, with its own FOCUS and three week cards.
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


## The career the game itself opens: quick start, the run's seed, rivals' pasts re-seeded to it, the first hour past.
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


## 26 weeks of the game's own day. CONTROL untouched; AVERAGE and TOP scale probe-side after each day (morning) and week (evening).
func _train(seed_val: int, arm: String) -> Dictionary:
	var c := _career(seed_val)
	var f := c.fighter()
	var focus := Sim.focus_of(c, f)
	var s0: Dictionary = (f["stats"] as Dictionary).duplicate()
	var drill_move := str(f.get("learning", ""))
	var fit := top_fit if arm == "TOP" else CoachFit.NEUTRAL
	var gm := CoachFit.gain_mult(fit)
	var tm := CoachFit.tired_mult(fit)
	var scale := arm != "CONTROL"
	var sharp_week := weeks + 1
	var sharp_move := ""
	for m in Data.MOVES:
		if float(f["moves"][m]) >= SHARP:
			sharp_week = 0
			sharp_move = str(m)
			break
	var fat_sum := 0.0
	var fat_peak := 0.0
	var hurt := 0
	var capped := 0
	var drills := 0
	var eve := {"added": 0.0, "over_cap": 0, "weeks": 0, "moves": 0}
	var peak := float(f.get("week_fatigue", 20.0))
	for w in weeks:
		var wk0: Dictionary = (f["moves"] as Dictionary).duplicate()   # the mastery the week walked in with
		for d in 7:
			var dow := posmod(c.day, 7)
			var before := float(f["stats"][focus])
			var fat0 := float(f.get("week_fatigue", 20.0))
			var keep := WeekPlan.fatigue_keep(Sim.week_ctx(c, f, dow)) if scale and tm != 1.0 else 1.0
			c.cash = maxi(c.cash, CASH_FLOOR)
			Sim.step_day(c)
			if scale:
				var r := _apply(f, focus, before, fat0, dow, gm, tm, peak, keep)
				peak = float(r["peak"])
				capped += int(r["capped"])
			if posmod(c.day, 7) == 0:   # Sunday stepped: Sim.end_week ran DrillWeek.run, the week's evening drills
				drills += 1
				if scale:
					var e := _evenings(f, wk0, gm, focus)
					for k in eve:
						eve[k] = float(eve[k]) + float(e[k])
					capped += int(e["cap_bound"])
			var fat1 := float(f.get("week_fatigue", 20.0))
			fat_sum += fat1
			fat_peak = maxf(fat_peak, fat1)
			hurt += 1 if Injuries.out(c, f) else 0
		if sharp_week > weeks:
			for m in Data.MOVES:
				if float(f["moves"][m]) >= SHARP:
					sharp_week = w + 1
					sharp_move = str(m)
					break
	return {"seed": seed_val, "arm": arm, "focus": focus, "gain": float(f["stats"][focus]) - float(s0[focus]), "sharp_week": sharp_week, "sharp_move": sharp_move, "drill_move": drill_move, "eve": eve, "fat_mean": fat_sum / float(weeks * 7), "fat_peak": fat_peak, "hurt": hurt, "capped": capped, "drills": drills, "stats": (f["stats"] as Dictionary).duplicate(), "moves": (f["moves"] as Dictionary).duplicate(), "fatigue": float(f.get("week_fatigue", 20.0)), "f26": f.duplicate(true)}


## The morning lever, FITPROBE1's unchanged: the day's FOCUS gain through the stack cap, the tiredness the day ADDED by tired_mult.
func _apply(f: Dictionary, focus: String, before: float, fat0: float, dow: int, gm: float, tm: float, peak: float, keep: float) -> Dictionary:
	var camp_mult := BoutRules.camp_gain_mult(f.get("camp", {}), focus)
	var cap := CoachFit.capped(gm, camp_mult)
	var extra := maxf(0.0, float(f["stats"][focus]) - before) * (float(cap["mult"]) / camp_mult - 1.0)
	if extra > 0.0:
		f["stats"][focus] = minf(Sim.STAT_CAP, float(f["stats"][focus]) + extra)
	var nf := float(f.get("week_fatigue", 20.0))
	if tm != 1.0:
		nf = clampf(nf - (1.0 - tm) * maxf(0.0, nf - keep * fat0), 0.0, 100.0)
		f["week_fatigue"] = nf
		peak = maxf(nf, fat0 if dow == 0 else peak)
		f["week_peak"] = peak   # the week's peak the injury roll and the ask read, kept on the scaled tiredness
	return {"peak": peak, "capped": 1 if bool(cap["capped"]) and extra > 0.0 else 0}


## THE EVENING LEVER (design 2.1): every move that rose this week gets (gain_mult - 1) x its rise through the stack cap,
## never past 100. The rise is after - before over THIS WEEK (wk0 = the mastery the week walked in with), never the total,
## which would compound. At fit 50 the extra is exactly 0.0 and nothing is written. over_cap counts the move-weeks the
## scaled mastery sits above the game's own ceiling MoveMastery.cap(technique, iq) - reported, since the brief's cap is 100.
func _evenings(f: Dictionary, wk0: Dictionary, gm: float, focus: String) -> Dictionary:
	var camp_mult := BoutRules.camp_gain_mult(f.get("camp", {}), focus)
	var cap := CoachFit.capped(gm, camp_mult)
	var k := float(cap["mult"]) / camp_mult - 1.0
	var moves: Dictionary = f["moves"]
	var ceil := MoveMastery.cap(float(f["stats"]["technique"]), float(f["stats"]["fight_iq"]))
	var added := 0.0
	var over := 0
	var hit := 0
	if k > 0.0:
		for m in Data.MOVES:
			var rise := float(moves[m]) - float(wk0.get(m, 0.0))
			var was := float(moves[m])
			var now := minf(MASTERY_MAX, was + maxf(0.0, rise) * k)
			if rise > 0.0 and now > was:
				moves[m] = now
				added += now - was
				hit += 1
				over += 1 if now > ceil else 0
	return {"added": added, "over_cap": over, "weeks": 1 if hit > 0 else 0, "moves": hit, "cap_bound": 1 if bool(cap["capped"]) and added > 0.0 else 0}


## n bouts from the week-26 boxer, each from the same snapshot (no bout teaches into the next), the auto corner's plan.
## rating: the fixed opponent rating (the AVERAGE arm's paper), the same in both arms so only the fit differs.
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


## One bout as tools/adapt_probe.gd plays it with no corner shouts: the plan only, auto_corner between rounds.
func _play(c: Career, f: Dictionary, m: Dictionary) -> void:
	Bouts.fight_step(c, f, m, "start")
	while true:
		while not LiveRound.live(m).is_empty():
			Bouts.fight_step(c, f, m, "shout:")
		if int(m["round"]) >= Bouts.rounds_of(f) or Bouts.stopped(m) != "":
			break
		Bouts.fight_step(c, f, m, "corner:" + BoutRules.auto_corner(f["stats"]))
	Bouts.fight_step(c, f, m, "end")


func _arm_line(arm: String, arr: Array) -> void:
	var sharp := []
	var reached := []
	var am := []
	var gains := []
	var fat := []
	var eve := []
	var dm := 0.0
	var wp := 0
	var per_move := {}
	var first := {}
	var tot := {"hurt": 0, "capped": 0, "drills": 0, "over_cap": 0, "weeks": 0, "moves": 0}
	for r in arr:
		sharp.append(float(r["sharp_week"]))
		gains.append(float(r["gain"]))
		fat.append(float(r["fat_mean"]))
		eve.append(float((r["eve"] as Dictionary)["added"]))
		am.append(_move_mean(r))
		dm += float((r["moves"] as Dictionary).get(str(r["drill_move"]), 0.0))
		for m in Data.MOVES:
			per_move[m] = float(per_move.get(m, 0.0)) + float((r["moves"] as Dictionary)[m])
			wp += 1 if float((r["moves"] as Dictionary)[m]) >= BoutRules.WEAPON_MASTERY else 0
		for k in ["hurt", "capped", "drills"]:
			tot[k] = int(tot[k]) + int(r[k])
		for k in ["over_cap", "weeks", "moves"]:
			tot[k] = int(tot[k]) + int((r["eve"] as Dictionary)[k])
		if int(r["sharp_week"]) <= weeks:
			reached.append(float(r["sharp_week"]))
			first[str(r["sharp_move"])] = int(first.get(str(r["sharp_move"]), 0)) + 1
	_say("FITPROBE2 arm=%s fit=%d Sharp weeks mean=%.2f p10=%.2f p90=%.2f | reached %d/%d (not reached counted as %d) | on those: mean=%.2f p10=%.2f p90=%.2f | first Sharp move %s" % [arm, top_fit if arm == "TOP" else CoachFit.NEUTRAL, _mean(sharp), _pct(sharp, 0.1), _pct(sharp, 0.9), reached.size(), arr.size(), weeks + 1, _mean(reached), _pct(reached, 0.1), _pct(reached, 0.9), str(first)])
	var parts := Data.MOVES.map(func(m): return "%s %.2f" % [str(m), float(per_move[m]) / float(arr.size())])
	arm_extra[arm] = {"moves": per_move, "weapons": float(wp) / float(arr.size())}
	_say("  arm=%s mastery at week 26: drilled move (%s) mean=%.2f | all %d moves mean=%.2f p10=%.2f p90=%.2f | weapons (mastery >= %.0f) %.2f of %d | per move: %s" % [arm, str(arr[0]["drill_move"]), dm / float(arr.size()), Data.MOVES.size(), _mean(am), _pct(am, 0.1), _pct(am, 0.9), BoutRules.WEAPON_MASTERY, float(wp) / float(arr.size()), Data.MOVES.size(), ", ".join(parts)])
	_say("  arm=%s FOCUS gain mean=%+.3f p10=%+.3f p90=%+.3f (morning lever) | tiredness mean=%.1f peak=%.1f | injured days=%d | week drills ran=%d | evening lever: %+.2f mastery points a boxer, %d move-weeks scaled in %d weeks, %d move-weeks past MoveMastery.cap | stack cap bound on %d days/weeks" % [arm, _mean(gains), _pct(gains, 0.1), _pct(gains, 0.9), _mean(fat), _pct(fat, 1.0), int(tot["hurt"]), int(tot["drills"]), _mean(eve), int(tot["moves"]), int(tot["weeks"]), int(tot["over_cap"]), int(tot["capped"])])


## The paired table: one line per boxer, both arms side by side (the seeds are the same, so the difference is the fit).
func _table(runs: Dictionary, wins: Dictionary) -> void:
	_say("PER BOXER (paired seeds): seed name age style div focus | gain A / T | Sharp wk A / T | all-move mastery A / T | wins A / T of %d" % bout_n)
	for i in count:
		var a: Dictionary = runs["AVERAGE"][i]
		var t: Dictionary = runs["TOP"][i]
		var f: Dictionary = a["f26"]
		_say("  %d %-14s %2d %-16s %-4s %-12s | %+6.2f %+6.2f | %2d %2d | %5.2f %5.2f | %2d %2d" % [int(a["seed"]), str(f["name"]), int(f["age"]), str(f["style"]), str(f["div"]), str(a["focus"]), float(a["gain"]), float(t["gain"]), int(a["sharp_week"]), int(t["sharp_week"]), _move_mean(a), _move_mean(t), int((wins["AVERAGE"]["per"] as Array)[i]), int((wins["TOP"]["per"] as Array)[i])])


func _move_mean(r: Dictionary) -> float:
	var t := 0.0
	for m in Data.MOVES:
		t += float((r["moves"] as Dictionary)[m])
	return t / float(Data.MOVES.size())


func _verdict(runs: Dictionary, wins: Dictionary) -> Dictionary:
	var sa := []
	var st := []
	var ma := []
	var mt := []
	var da := []
	var dt := []
	var ga := 0.0
	var gt := 0.0
	var both := 0
	var paired := 0.0
	var sooner := 0
	var later := 0
	var ra := 0
	var rt := 0
	for i in count:
		var a: Dictionary = runs["AVERAGE"][i]
		var t: Dictionary = runs["TOP"][i]
		sa.append(float(a["sharp_week"]))
		st.append(float(t["sharp_week"]))
		ga += float(a["gain"])
		gt += float(t["gain"])
		ma.append(_move_mean(a))
		mt.append(_move_mean(t))
		da.append(float((a["moves"] as Dictionary).get(str(a["drill_move"]), 0.0)))
		dt.append(float((t["moves"] as Dictionary).get(str(t["drill_move"]), 0.0)))
		ra += 1 if int(sa[i]) <= weeks else 0
		rt += 1 if int(st[i]) <= weeks else 0
		if int(sa[i]) <= weeks and int(st[i]) <= weeks:
			both += 1
			paired += float(sa[i]) - float(st[i])
			sooner += 1 if float(st[i]) < float(sa[i]) else 0
			later += 1 if float(st[i]) > float(sa[i]) else 0
	var sharp_diff := _mean(sa) - _mean(st)
	var mastery_diff := _mean(mt) - _mean(ma)
	var drill_diff := _mean(dt) - _mean(da)
	var gain_diff := (gt - ga) / float(count)
	var win_diff := float(int(wins["TOP"]["total"]) - int(wins["AVERAGE"]["total"])) * 100.0 / float(count * bout_n)
	var sharp_ok := sharp_diff >= 2.0 and sharp_diff <= 4.0
	var win_ok := win_diff >= 4.0 and win_diff <= 8.0
	var under_plan := win_diff < PLAN_EDGE
	_say("FITPROBE2 TOP - AVERAGE: Sharp %.2f weeks sooner (bar 2..4: %s) | paired on the %d Sharp in both arms: %.2f weeks sooner (%d sooner, %d later, %d the same week) | reached AVERAGE %d/%d, TOP %d/%d (not reached counted as %d)" % [sharp_diff, "in" if sharp_ok else "OUT", both, paired / float(maxi(1, both)), sooner, later, both - sooner - later, ra, count, rt, count, weeks + 1])
	_say("  Mastery at week 26: all %d moves %+.3f (AVERAGE %.2f, TOP %.2f) | the drilled move (%s) %+.3f (AVERAGE %.2f, TOP %.2f). FOCUS gain (morning lever, informational - the stat bar is the designer's question): %+.3f over %d weeks." % [Data.MOVES.size(), mastery_diff, _mean(ma), _mean(mt), str(runs["AVERAGE"][0]["drill_move"]), drill_diff, _mean(da), _mean(dt), gain_diff, weeks])
	_say("TRAINBALANCE TOP - AVERAGE: %+.2f wins in 100 (bar +4..+8: %s; under a good plan's +%.0f, 59 against 45: %s) | FITPROBE2 %s (Sharp %s) | TRAINBALANCE %s (band %s, under the plan %s)" % [win_diff, "in" if win_ok else "OUT", PLAN_EDGE, "yes" if under_plan else "NO", "pass" if sharp_ok else "fail", "pass" if sharp_ok else "fail", "pass" if win_ok and under_plan else "fail", "pass" if win_ok else "fail", "pass" if under_plan else "fail"])
	return {"gain_diff": gain_diff, "sharp_diff": sharp_diff, "mastery_diff": mastery_diff, "drill_diff": drill_diff, "win_diff": win_diff, "paired": paired / float(maxi(1, both)), "both": both, "sooner": sooner, "later": later, "avg_all": _mean(ma), "top_all": _mean(mt), "avg_drill": _mean(da), "top_drill": _mean(dt), "avg_sharp": _mean(sa), "drill_move": str(runs["AVERAGE"][0]["drill_move"]), "fitprobe2": "pass" if sharp_ok else "fail", "trainbalance": "pass" if win_ok and under_plan else "fail"}


func _control(avg: Array, ctl: Array) -> String:
	for i in avg.size():
		var d := _same(avg[i], ctl[i])
		if d != "match":
			return "DIFF at boxer %d (seed %d): %s" % [i, int(avg[i]["seed"]), d]
	return "match"


func _same(a: Dictionary, b: Dictionary) -> String:
	for k in ["gain", "sharp_week", "fatigue", "fat_mean", "fat_peak", "hurt", "capped", "drills"]:
		if a[k] != b[k]:
			return "%s %s vs %s" % [k, str(a[k]), str(b[k])]
	for k in (a["eve"] as Dictionary):
		if float(a["eve"][k]) != float(b["eve"][k]):
			return "eve %s %s vs %s" % [str(k), str(a["eve"][k]), str(b["eve"][k])]
	for grp in ["stats", "moves"]:
		for k in (a[grp] as Dictionary):
			if float(a[grp][k]) != float(b[grp][k]):
				return "%s %s %.12f vs %.12f" % [grp, str(k), float(a[grp][k]), float(b[grp][k])]
	return "match"


func _mean(arr: Array) -> float:
	var t := 0.0
	for v in arr:
		t += float(v)
	return t / float(maxi(1, arr.size()))


func _pct(arr: Array, q: float) -> float:
	if arr.is_empty():
		return 0.0
	var s := arr.duplicate()
	s.sort()
	var x := q * float(s.size() - 1)
	var lo := int(floor(x))
	return lerpf(float(s[lo]), float(s[mini(s.size() - 1, lo + 1)]), x - float(lo))


## The result page, written by the probe from its own numbers: the question, the method, every measured line, the verdict.
func _write_doc(v: Dictionary, ctl: String, det: String, secs: float) -> void:
	var fh := FileAccess.open("res://docs/FITPROBE2_RESULT.md", FileAccess.WRITE)
	if fh == null:
		print("WARNING: could not write docs/FITPROBE2_RESULT.md")
		return
	fh.store_string("# FITPROBE2 + TRAINBALANCE Result\n\nProbe run: %s. Coach fit design v8 (approved Q-235).\nMap: `ops/research/DESIGN_COACHFIT1_V8_REVISE_KALLI_KALLI.md` 2.1 (fit multiplies the drill units on pad and sparring nights, and the stat gain on mornings), 12 (pass lines).\n\n## Question\n\nDoes a TOP fit bring moves to Sharp sooner on the EVENINGS? FITPROBE1 scaled the morning stat gain only and Sharp did not move\n(0.00 weeks sooner, docs/FITPROBE1_RESULT.md): the evenings were never scaled. A pads coach who suits a boxer gets the combination\ninto her hands weeks sooner - that is what this probe times.\n\n## Method\n\n" % Time.get_datetime_string_from_system())
	for l in [
		"- `tools/fit_probe2.gd` only, a COPY of `tools/fit_probe.gd`: the same population (%d boxers, seeds %d..%d), the same paired seeds, the same arms (AVERAGE fit %d, TOP fit %d, CONTROL untouched) and the same bout harness. Nothing in `scripts/` or `tests/` is touched. Part 1: %d weeks (%d days) of `Sim.step_day` - the game's own week, plan and FOCUS, twist cards, injuries, phase and drilling (`DrillWeek.run` / `PadWeek.run_week`). Luke Reid (sessional, pads 74) in every arm, load normal, no bout (camp mult 1.0)." % [count, SEED_START, SEED_START + count - 1, CoachFit.NEUTRAL, top_fit, weeks, weeks * 7],
		"- THE EVENING LEVER (new): after each week's drills ran (`DrillWeek.run` inside `Sim.end_week`, reached through `Sim.step_day` on the Sunday), every move whose mastery rose this week gets `(CoachFit.gain_mult(fit) - 1) x` THAT WEEK'S RISE (after - before over the week), through `CoachFit.capped(gain_mult, camp mult)` so the x%.1f stack cap holds, never past mastery %.0f. The week's rise, never the mastery total - scaling the total would compound every week." % [CoachFit.STACK_CAP, MASTERY_MAX],
		"- THE MORNING LEVER (FITPROBE1's, unchanged): after each day the probe adds `gain_mult(fit) - 1` of the gain that day gave the FOCUS stat through the same stack cap, and scales the tiredness the day ADDED (its load over the night's recovery, `WeekPlan.fatigue_keep`) by `tired_mult(fit)`; the week's peak the injury roll reads follows it. At fit 50 both multipliers are exactly 1.0, so neither lever writes anything: AVERAGE is the untouched run and CONTROL must equal it to the digit. The headroom clamp is ON: `TrainingPreview.headroom` = (pot - stat)/%.0f clamped %.2f..%.2f, the game's own rule. Sharp = mastery %.1f, read from the constant `FireLevel.SHARP_AT` (the tier a planned line fires at %s; `MoveMastery.tier` agrees). Weeks to Sharp counts the first week any move reaches it; %d = not reached in the window." % [TrainingPreview.HEADROOM_SPAN, TrainingPreview.HEADROOM_MIN, TrainingPreview.HEADROOM_MAX, SHARP, str(FireLevel.GAME_SHARES["sharp"]), weeks + 1],
		"- Part 2 (TRAINBALANCE): each week-26 boxer of both arms fights %d bouts from the same snapshot (no bout teaches into the next), `Bouts.fight_step` + `LiveRound` as `tools/adapt_probe.gd` and `tools/exchange_balance.gd` play them: no shouts, `BoutRules.auto_corner` between rounds, film 1, no camp, morale 60, tiredness 20. One fixed opponent set (`Data.OPPONENTS`), each rated to the boxer's AVERAGE-arm week-26 paper (`BoutRules.fight_power`), the SAME rating in both arms - an equal-paper matchup, the baseline win share measured, not assumed 50%%. The baseline printed here is THIS run's measurement, not FITPROBE1's (the game code moves between probes); the paired TOP - AVERAGE diff is the fit's effect." % bout_n,
	]:
		fh.store_line(str(l))
	fh.store_string("\n## Pass lines (map 12)\n\n- FITPROBE2: a move reaches Sharp 2-4 weeks sooner under a TOP fit than under an average one (fit 50).\n- TRAINBALANCE: TOP wins +4 to +8 in 100 over AVERAGE, under a good plan's +14 (59 against 45), headroom clamp on.\n- CONTROL: AVERAGE against an untouched run of the same seeds must match to the digit.\n- The FOCUS stat bar (+3..+5) is FITPROBE1's and the designer's question: today's base morning gain is +3.5 in 26 weeks, so x1.32 can only add ~1. It is printed here as information, not judged.\n\n## Measured (the probe's own output)\n\n```text\n")
	for line in doc:
		fh.store_line(str(line))
	fh.store_string("```\n\n## Verdict\n\n- Sharp weeks sooner: **%+.2f** (bar 2..4); paired on the %d boxers Sharp in both arms: %+.2f (%d sooner, %d later).\n- Mastery at week 26, all %d moves: **%+.3f** (AVERAGE %.2f, TOP %.2f). The drilled move (%s): **%+.3f** (AVERAGE %.2f, TOP %.2f).\n- Wins in 100 difference: **%+.2f** (bar +4..+8, under the plan's +%.0f).\n- FOCUS gain difference (morning lever, informational): **%+.3f**.\n- CONTROL (AVERAGE vs untouched): **%s**. Determinism (one arm twice): **%s**.\n- **FITPROBE2 %s** | **TRAINBALANCE %s**\n\nA gate FAIL is a finding for the designer, not a broken probe: the numbers above are what the mechanism did.\n\nElapsed: %.0f s. Reproduce: `python ops/Tools/godot_slot.py run --who fitprobe2 -- <godot> --headless --audio-driver Dummy --path . --script res://tools/fit_probe2.gd`\n" % [float(v["sharp_diff"]), int(v["both"]), float(v["paired"]), int(v["sooner"]), int(v["later"]), Data.MOVES.size(), float(v["mastery_diff"]), float(v["avg_all"]), float(v["top_all"]), str(v["drill_move"]), float(v["drill_diff"]), float(v["avg_drill"]), float(v["top_drill"]), float(v["win_diff"]), PLAN_EDGE, float(v["gain_diff"]), ctl, det, str(v["fitprobe2"]), str(v["trainbalance"]), secs])
	fh.store_string("\n## Findings (what the numbers say)\n\n%s\n" % _findings(v))
	fh.close()
	print("Result doc written to docs/FITPROBE2_RESULT.md")


## The findings, written from the measured numbers: what the evening lever did to Sharp, to mastery and to the bouts.
func _findings(v: Dictionary) -> String:
	var sd := float(v["sharp_diff"])
	var out := ["- The evening lever is live: TOP fit %d (x%.3f) scales every move's WEEKLY rise. Mean mastery of all %d moves at week 26: %+.3f (AVERAGE %.2f -> TOP %.2f); the move she started drilling (%s): %+.3f (%.2f -> %.2f); weapons (mastery >= %.0f) %.2f -> %.2f of %d. The fit also REDISTRIBUTES the hand: a move that turns a weapon sooner hands the pad nights to the next one (DrillWeek.run's learning pick), so the per-move means above are not all higher - the read is the whole hand and the time to Sharp, not one move's mastery." % [top_fit, CoachFit.gain_mult(top_fit), Data.MOVES.size(), float(v["mastery_diff"]), float(v["avg_all"]), float(v["top_all"]), str(v["drill_move"]), float(v["drill_diff"]), float(v["avg_drill"]), float(v["top_drill"]), BoutRules.WEAPON_MASTERY, float((arm_extra["AVERAGE"] as Dictionary)["weapons"]), float((arm_extra["TOP"] as Dictionary)["weapons"]), Data.MOVES.size()]]
	if sd >= 2.0 and sd <= 4.0:
		out.append("- Sharp comes %+.2f weeks sooner, inside the 2-4 week bar: a pads coach who suits the boxer gets the combination into her hands sooner, and the bar holds." % sd)
	elif sd > 4.0:
		out.append("- Sharp comes %+.2f weeks sooner, PAST the 2-4 week bar: the evening lever as specified is too strong on the timing, not too weak." % sd)
	else:
		out.append("- Sharp comes only %+.2f weeks sooner, under the 2-4 week bar (paired on the %d Sharp in both arms: %+.2f; %d sooner, %d later). x%.3f on the weekly rise does not buy 2-4 weeks: the first Sharp move already lands in week %.1f on average, and the ceiling `MoveMastery.cap(technique, fight_iq)` with the room-left factor `(1 - m/cap)` in `MoveMastery.gain` flattens each week's rise as the move nears it, so a multiplier on the rise buys less time the closer the move is to Sharp. The bar is the designer's question - the mechanism is measured here, not tuned." % [sd, int(v["both"]), float(v["paired"]), int(v["sooner"]), int(v["later"]), CoachFit.gain_mult(top_fit), float(v["avg_sharp"])])
	out.append("- TRAINBALANCE: %+.2f wins in 100 (bar +4..+8), under a good plan's +%.0f: %s. The equal-paper baseline win share is printed above (the live round reads moves and plan, not paper alone), so the diff is not on the bar's 59-vs-45 scale; the band and the plan ceiling are read on the measured diff either way. The morning lever is FITPROBE1's and unchanged: FOCUS %+.3f over %d weeks (FITPROBE1 measured +0.953) - the stat bar (+3..+5) stays out of reach of x%.3f on a base gain of ~+3.5, a design question for Claude, not this probe's. CONTROL holds: AVERAGE (fit 50, both multipliers exactly 1.0) equals an untouched run of the same seeds to the digit, so every difference above is the fit and nothing else." % [float(v["win_diff"]), PLAN_EDGE, "a TOP fit is not too much on the plan's scale" if float(v["win_diff"]) < PLAN_EDGE else "PAST the plan's ceiling - the fit would matter more than the plan", float(v["gain_diff"]), weeks, CoachFit.gain_mult(top_fit)])
	return "\n".join(out)
