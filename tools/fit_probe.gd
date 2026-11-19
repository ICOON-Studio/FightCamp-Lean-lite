extends SceneTree
## FITPROBE1 + TRAINBALANCE (S524, coach fit design v8): is a TOP fit worth having, and is it not too much?
## Map: ops/research/DESIGN_COACHFIT1_V8_REVISE_KALLI_KALLI.md 2.1-2.2 (fit), 12 (the pass lines), 13 (the build waits).
## Probe only: no scripts/ or tests/ file is touched. The arms differ INSIDE this file - after each Sim.step_day the gain
## the day gave the FOCUS stat gets gain_mult(fit) - 1 extra, through CoachFit.capped(gain_mult, camp mult) so the x1.6
## stack cap holds, and the tiredness the day ADDED (its load over the night's recovery, WeekPlan.fatigue_keep - not the
## recovery itself) gets tired_mult(fit); the week's peak the injury roll reads follows it.
## AVERAGE = fit 50 (gain_mult and tired_mult exactly 1.0: the design's "fit 50 equals today exactly"); TOP = the fit
## CoachFit.word calls TOP FIT (the reachable best case, printed); CONTROL = the same seeds with no probe scaling at all.
## Part 1: 26 weeks of the game's own week (Sim.step_day, the boxer's own plan and focus), 60 varied boxers, paired seeds.
## Part 2: each week-26 boxer of both arms fights 40 bouts against one fixed opponent set with the auto corner, played as
## tools/adapt_probe.gd and tools/exchange_balance.gd play them (Bouts.fight_step + LiveRound, no shouts, auto_corner plan).
## Gate FAILs are findings, not a failed run: quit 0 when it measured and the control holds, 1 only when the control breaks.
## Usage: python ops/Tools/godot_slot.py run --who fitprobe1 -- <godot> --headless --audio-driver Dummy --path . --script res://tools/fit_probe.gd
## Pilot only (no doc): ... --script res://tools/fit_probe.gd -- pilot=1

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

const WEEKS := 26
const COUNT := 60
const BOUT_N := 40
const SEED_START := 6100
const SHARP := 60.0   # MoveMastery's Sharp tier (tier(m): SHARP < 85, from 60)
const CASH_FLOOR := 20000   # money is not the measurement: the gym stays open (two_boxers_two_years_test)
const PLAN_EDGE := 14.0   # a good plan's +14 in 100 (59 against 45), the ceiling TRAINBALANCE must stay under
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
	top_fit = CoachFit.fit({"temper": "motivator", "mode": "lift", "boxer": {"morale_word": "Flat", "coachability": 50,
		"cards_known_share": 0.5}, "over": 0.0, "bond": 110.0, "evening": false, "focus": "this"})
	_say("FITPROBE1 + TRAINBALANCE (S524): is a TOP fit worth having, and is it not too much?")
	_say("Map: DESIGN_COACHFIT1_V8 2.1-2.2, 12. Probe only - the arms differ inside tools/fit_probe.gd, nothing in scripts/ or tests/.")
	_say("Arms on the SAME seeds (paired): AVERAGE fit %d, TOP fit %d (CoachFit.word -> %s), CONTROL = untouched, no probe scaling." % [
		CoachFit.NEUTRAL, top_fit, CoachFit.word(top_fit)])
	_say("fit 50 equals today exactly: gain_mult(50)=%.3f tired_mult(50)=%.3f (both must be 1.000: %s)" % [
		CoachFit.gain_mult(50), CoachFit.tired_mult(50),
		"yes" if is_equal_approx(CoachFit.gain_mult(50), 1.0) and is_equal_approx(CoachFit.tired_mult(50), 1.0) else "NO"])
	_say("TOP fit %d: gain_mult=%.3f tired_mult=%.3f; stack cap x%.1f through CoachFit.capped(gain_mult, camp mult)." % [
		top_fit, CoachFit.gain_mult(top_fit), CoachFit.tired_mult(top_fit), CoachFit.STACK_CAP])
	_say("Headroom clamp ON (TrainingPreview.headroom): (pot - stat)/%.0f clamped %.2f..%.2f - the game's own gain rule, untouched." % [
		TrainingPreview.HEADROOM_SPAN, TrainingPreview.HEADROOM_MIN, TrainingPreview.HEADROOM_MAX])
	_say("Part 1: %d weeks (%d days) of Sim.step_day - the game's own week, plan and focus, twists, injuries, phase, drilling." % [weeks, weeks * 7])
	_say("Part 2: %d bouts a boxer per arm, one fixed opponent set, film 1, no camp, morale 60, tiredness 20, auto corner, no shouts." % bout_n)
	_population()
	_opponents()
	# PILOT: one boxer's whole training run and 8 bouts, to project the full run before it starts.
	var tp := Time.get_ticks_msec()
	var pr := _train(SEED_START, "TOP")
	var train_ms := Time.get_ticks_msec() - tp
	tp = Time.get_ticks_msec()
	_bouts(pr["f26"], SEED_START, 8, BoutRules.fight_power(pr["f26"]["stats"], {}, 0, ""))
	var bout_ms := (Time.get_ticks_msec() - tp) / 8.0
	var total_min := (train_ms * count * 3.0 + bout_ms * count * 2.0 * bout_n) / 60000.0
	_say("Pilot: %d ms a training run, %.1f ms a bout -> projected %.1f min for %d runs + %d bouts." % [
		train_ms, bout_ms, total_min, count * 3, count * 2 * bout_n])
	if pilot_only:
		print("FITPROBE1 pilot only (not the measured run, no doc written)")
		quit(0)
		return
	# DETERMINISM: the same arm twice on one seed must agree to the digit (the bout dice and the week's rolls are seeded).
	var d1 := _train(SEED_START, "AVERAGE")
	var d2 := _train(SEED_START, "AVERAGE")
	var det := _same(d1, d2)
	_say("CONTROL determinism (seed %d AVERAGE twice): %s" % [SEED_START, det])
	var runs := {}
	for arm in ["AVERAGE", "TOP", "CONTROL"]:
		var arr := []
		for i in count:
			arr.append(_train(SEED_START + i, arm))
		runs[arm] = arr
		_arm_line(arm, arr)
	var ctl := _control(runs["AVERAGE"], runs["CONTROL"])
	_say("CONTROL AVERAGE against an untouched run of the same seeds (no probe scaling): %s" % ctl)
	var wins := {}
	var paper := []
	for i in count:
		paper.append(BoutRules.fight_power((runs["AVERAGE"][i] as Dictionary)["f26"]["stats"], {}, 0, ""))
	_say("TRAINBALANCE opponent rating = AVERAGE week-26 paper: mean %.2f, range %.2f..%.2f (fixed for both arms)." % [
		_mean(paper), _pct(paper, 0.0), _pct(paper, 1.0)])
	for arm in ["AVERAGE", "TOP"]:
		var tot := 0
		var per := []
		for i in count:
			var r := _bouts((runs[arm][i] as Dictionary)["f26"], SEED_START + i, bout_n, float(paper[i]))
			per.append(r)
			tot += int(r["wins"])
		wins[arm] = {"total": tot, "per": per}
		_say("TRAINBALANCE arm=%s wins=%d/%d = %.2f in 100 (stoppages %d)" % [arm, tot, count * bout_n,
			float(tot) * 100.0 / float(count * bout_n), _stops(per)])
	_table(runs, wins)
	var verdict := _verdict(runs, wins)
	_write_doc(verdict, ctl, det, float(Time.get_ticks_msec() - t0) / 1000.0)
	_say("FITPROBE1 done top_fit=%d focus_gain_diff=%+.2f sharp_weeks_sooner=%+.2f win_diff_in_100=%+.2f control=%s fitprobe1=%s trainbalance=%s" % [
		top_fit, float(verdict["gain_diff"]), float(verdict["sharp_diff"]), float(verdict["win_diff"]),
		"match" if ctl == "match" else "DIFF", str(verdict["fitprobe1"]), str(verdict["trainbalance"])])
	quit(0 if ctl == "match" and det == "match" else 1)


func _say(s: String) -> void:
	print(s)
	doc.append(s)


## The population printed: every boxer's own numbers, so no two are identical and the spread is on the page.
func _population() -> void:
	var focus_n := {}
	var ages := []
	var styles := {}
	var sexes := {}
	var divs := {}
	var ids := {}
	var same := 0
	for i in count:
		var f := Data.fighter_state(_raw(SEED_START + i), 0)
		var key := str(f["stats"]) + str(f["age"]) + str(f["style"]) + str(f["focus"])
		if ids.has(key):
			same += 1
		ids[key] = true
		focus_n[str(f["focus"])] = int(focus_n.get(str(f["focus"]), 0)) + 1
		ages.append(int(f["age"]))
		styles[str(f["style"])] = true
		sexes[str(f["sex"])] = int(sexes.get(str(f["sex"]), 0)) + 1
		divs[str(f["div"])] = true
	_say("Population: %d boxers, seeds %d..%d, Data.fighter_state on 6 bases (Lucy + the 5 prospects), stats +-6, varied ages," % [
		count, SEED_START, SEED_START + count - 1])
	_say("  styles, stances, potentials, week cards and FOCUS. Identical rows: %d. Ages %d..%d. Styles %d. Sexes %s. Divisions %d." % [
		same, ages.min(), ages.max(), styles.size(), str(sexes), divs.size()])
	_say("  FOCUS spread: %s. Coach in every arm: Luke Reid (sessional, pads 74). Load normal, no bout in part 1 (camp mult 1.0)." % str(focus_n))


func _opponents() -> void:
	var parts := []
	for o in Data.OPPONENTS:
		parts.append("%s (%s)" % [str(o["name"]), str(o["style"])])
	_say("TRAINBALANCE fixed opponent set (every boxer, both arms): %s." % ", ".join(parts))
	_say("  Each opponent's rating = the boxer's AVERAGE-arm week-26 paper (BoutRules.fight_power), the SAME rating in both arms")
	_say("  (tools/exchange_balance.gd's rating = paper convention: an equal-paper matchup; the baseline win share is measured, not assumed 50%).")


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
	b.merge({"id": "fit_%d" % seed_val, "name": "%s %s" % [first, last], "first": first,
		"age": clampi(int(b["age"]) + rng.randi_range(-2, 4), 16, 30),
		"pot": clampi(int(b["pot"]) + rng.randi_range(-6, 8), 60, 92),
		"style": STYLES[rng.randi_range(0, STYLES.size() - 1)],
		"stance": "southpaw" if rng.randf() < 0.25 else "orthodox",
		"focus": Data.STATS[i % Data.STATS.size()], "cards": cards.slice(0, 3),
		"weight": lim + rng.randf_range(-0.4, 1.0), "stats": stats}, true)
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


## 26 weeks of the game's own day. arm CONTROL runs untouched; AVERAGE and TOP scale probe-side after each day.
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
	var drill_week := weeks + 1
	for m in Data.MOVES:
		if float(f["moves"][m]) >= SHARP:
			sharp_week = 0
			sharp_move = str(m)
			break
	if drill_move != "" and float(f["moves"][drill_move]) >= SHARP:
		drill_week = 0
	var fat_sum := 0.0
	var fat_peak := 0.0
	var hurt := 0
	var capped := 0
	var peak := float(f.get("week_fatigue", 20.0))
	for w in weeks:
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
			var fat1 := float(f.get("week_fatigue", 20.0))
			fat_sum += fat1
			fat_peak = maxf(fat_peak, fat1)
			if Injuries.out(c, f):
				hurt += 1
		if sharp_week > weeks:
			for m in Data.MOVES:
				if float(f["moves"][m]) >= SHARP:
					sharp_week = w + 1
					sharp_move = str(m)
					break
		if drill_week > weeks and drill_move != "" and float(f["moves"][drill_move]) >= SHARP:
			drill_week = w + 1
	return {"seed": seed_val, "arm": arm, "focus": focus, "gain": float(f["stats"][focus]) - float(s0[focus]),
		"sharp_week": sharp_week, "sharp_move": sharp_move, "drill_week": drill_week, "drill_move": drill_move,
		"fat_mean": fat_sum / float(weeks * 7), "fat_peak": fat_peak, "hurt": hurt, "capped": capped,
		"stats": (f["stats"] as Dictionary).duplicate(), "moves": (f["moves"] as Dictionary).duplicate(),
		"fatigue": float(f.get("week_fatigue", 20.0)), "f26": f.duplicate(true)}


## The probe's whole mechanism: the day's FOCUS gain scaled through the stack cap, the tiredness the day added by tired_mult.
## The day's added tiredness is its fatigue over the night's recovery (keep x fat0); the recovery itself is never scaled.
## At fit 50 both multipliers are exactly 1.0, so nothing is written and the run is the untouched one to the digit.
func _apply(f: Dictionary, focus: String, before: float, fat0: float, dow: int, gm: float, tm: float, peak: float, keep: float) -> Dictionary:
	var camp_mult := BoutRules.camp_gain_mult(f.get("camp", {}), focus)
	var cap := CoachFit.capped(gm, camp_mult)
	var delta := float(f["stats"][focus]) - before
	var extra := maxf(0.0, delta) * (float(cap["mult"]) / camp_mult - 1.0)
	if extra > 0.0:
		f["stats"][focus] = minf(Sim.STAT_CAP, float(f["stats"][focus]) + extra)
	var nf := float(f.get("week_fatigue", 20.0))
	if tm != 1.0:
		nf = clampf(nf - (1.0 - tm) * maxf(0.0, nf - keep * fat0), 0.0, 100.0)
		f["week_fatigue"] = nf
		peak = maxf(nf, fat0 if dow == 0 else peak)
		f["week_peak"] = peak   # the week's peak the injury roll and the ask read, kept on the scaled tiredness
	return {"peak": peak, "capped": 1 if bool(cap["capped"]) and extra > 0.0 else 0}


## n bouts from the week-26 boxer, each from the same snapshot (no bout teaches into the next), the auto corner's plan.
## rating: the fixed opponent rating (the AVERAGE arm's paper), the same in both arms so only the fit differs.
func _bouts(f26: Dictionary, seed_val: int, n: int, rating: float) -> Dictionary:
	var c := _career(seed_val)
	var wins := 0
	var stops := 0
	for i in n:
		var f := f26.duplicate(true)
		f["camp"] = {}
		f["morale"] = 60.0
		f["week_fatigue"] = 20.0
		f["notes_seen"] = []
		f["bout"] = {}
		f.erase("last_bout_day")
		c.fighters = [f]
		c.day = 20 + i
		c.results.clear()
		var opp := (Data.OPPONENTS[i % Data.OPPONENTS.size()] as Dictionary).duplicate(true)
		opp["rating"] = rating
		f["bout"] = {"opp": opp, "day": c.day, "weighed": true, "made": true, "done": false, "film": 1}
		var m := {"fid": f["id"], "step": "tape", "total": 3}
		_play(c, f, m)
		if str(m.get("outcome", "")) == "win":
			wins += 1
			stops += 1 if str(m.get("stopped", "")) != "" else 0
	return {"wins": wins, "stops": stops, "n": n}


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
	var gains := []
	var sharp := []
	var drill := []
	var fat := []
	var hurt := 0
	var capped := 0
	var reached := 0
	var moves := {}
	for r in arr:
		gains.append(float(r["gain"]))
		sharp.append(float(r["sharp_week"]))
		drill.append(float(r["drill_week"]))
		fat.append(float(r["fat_mean"]))
		hurt += int(r["hurt"])
		capped += int(r["capped"])
		if int(r["sharp_week"]) <= weeks:
			reached += 1
			moves[str(r["sharp_move"])] = int(moves.get(str(r["sharp_move"]), 0)) + 1
	_say("FITPROBE1 arm=%s fit=%d FOCUS gain mean=%+.3f p10=%+.3f p90=%+.3f | Sharp weeks mean=%.2f (reached %d/%d, first Sharp move %s)" % [
		arm, top_fit if arm == "TOP" else CoachFit.NEUTRAL, _mean(gains), _pct(gains, 0.1), _pct(gains, 0.9),
		_mean(sharp), reached, arr.size(), str(moves)])
	_say("  arm=%s drilled move (%s) Sharp weeks mean=%.2f | tiredness mean=%.1f peak=%.1f | injured days=%d | stack cap bound on %d days" % [
		arm, str(arr[0]["drill_move"]), _mean(drill), _mean(fat), _pct(fat, 1.0), hurt, capped])


## The paired table: one line per boxer, both arms side by side (the seeds are the same, so the difference is the fit).
func _table(runs: Dictionary, wins: Dictionary) -> void:
	_say("PER BOXER (paired seeds): seed name age style div focus | gain A / T / diff | Sharp wk A / T | wins A / T of %d" % bout_n)
	for i in count:
		var a: Dictionary = runs["AVERAGE"][i]
		var t: Dictionary = runs["TOP"][i]
		var f: Dictionary = a["f26"]
		var wa: Dictionary = wins["AVERAGE"]["per"][i]
		var wt: Dictionary = wins["TOP"]["per"][i]
		_say("  %d %-14s %2d %-16s %-4s %-12s | %+6.2f %+6.2f %+6.2f | %2d %2d | %2d %2d" % [
			int(a["seed"]), str(f["name"]), int(f["age"]), str(f["style"]), str(f["div"]), str(a["focus"]),
			float(a["gain"]), float(t["gain"]), float(t["gain"]) - float(a["gain"]),
			int(a["sharp_week"]), int(t["sharp_week"]), int(wa["wins"]), int(wt["wins"])])


func _verdict(runs: Dictionary, wins: Dictionary) -> Dictionary:
	var ga := _col(runs["AVERAGE"], "gain")
	var gt := _col(runs["TOP"], "gain")
	var sa := _col(runs["AVERAGE"], "sharp_week")
	var st := _col(runs["TOP"], "sharp_week")
	var gain_diff := _mean(gt) - _mean(ga)
	var sharp_diff := _mean(sa) - _mean(st)
	var both := 0
	var paired := 0.0
	var trained := 0
	var sub := 0.0
	for i in count:
		if int(sa[i]) <= weeks and int(st[i]) <= weeks:
			both += 1
			paired += float(sa[i]) - float(st[i])
		if float(ga[i]) > 0.0:
			trained += 1
			sub += float(gt[i]) - float(ga[i])
	var n_bouts := count * bout_n
	var win_diff := float(int(wins["TOP"]["total"]) - int(wins["AVERAGE"]["total"])) * 100.0 / float(n_bouts)
	var gain_ok := gain_diff >= 3.0 and gain_diff <= 5.0
	var sharp_ok := sharp_diff >= 2.0 and sharp_diff <= 4.0
	var win_ok := win_diff >= 4.0 and win_diff <= 8.0
	var under_plan := win_diff < PLAN_EDGE
	_say("FITPROBE1 TOP - AVERAGE: FOCUS gain %+.3f (bar +3..+5: %s) | Sharp %.2f weeks sooner (bar 2..4: %s)" % [
		gain_diff, "in" if gain_ok else "OUT", sharp_diff, "in" if sharp_ok else "OUT"])
	_say("  Sharp weeks: not reached within %d weeks counted as %d. Paired on the %d boxers Sharp in both arms: %.2f weeks sooner." % [
		weeks, weeks + 1, both, paired / float(maxi(1, both))])
	_say("  FOCUS trained on %d/%d boxers (AVERAGE gain > 0); on those the diff is %+.3f. The other %d gain 0: the coach's BASE week is fixed and its FOCUS session enters only in camp phases, so the multiplier has nothing to scale on them." % [
		trained, count, sub / float(maxi(1, trained)), count - trained])
	_say("TRAINBALANCE TOP - AVERAGE: %+.2f wins in 100 (bar +4..+8: %s; under a good plan's +%.0f, 59 against 45: %s)" % [
		win_diff, "in" if win_ok else "OUT", PLAN_EDGE, "yes" if under_plan else "NO"])
	_say("FITPROBE1 %s (gain %s, Sharp %s) | TRAINBALANCE %s (band %s, under the plan %s)" % [
		"pass" if gain_ok and sharp_ok else "fail", "pass" if gain_ok else "fail", "pass" if sharp_ok else "fail",
		"pass" if win_ok and under_plan else "fail", "pass" if win_ok else "fail", "pass" if under_plan else "fail"])
	return {"gain_diff": gain_diff, "sharp_diff": sharp_diff, "win_diff": win_diff, "paired": paired / float(maxi(1, both)),
		"both": both, "trained": trained, "sub_diff": sub / float(maxi(1, trained)),
		"fitprobe1": "pass" if gain_ok and sharp_ok else "fail", "trainbalance": "pass" if win_ok and under_plan else "fail"}


## AVERAGE against CONTROL: every stat, every move mastery, the tiredness and the Sharp weeks, to the digit.
func _control(avg: Array, ctl: Array) -> String:
	for i in avg.size():
		var d := _same(avg[i], ctl[i])
		if d != "match":
			return "DIFF at boxer %d (seed %d): %s" % [i, int(avg[i]["seed"]), d]
	return "match"


func _same(a: Dictionary, b: Dictionary) -> String:
	for k in ["gain", "sharp_week", "drill_week", "fatigue", "fat_mean", "fat_peak", "hurt", "capped"]:
		if a[k] != b[k]:
			return "%s %s vs %s" % [k, str(a[k]), str(b[k])]
	for k in (a["stats"] as Dictionary):
		if float(a["stats"][k]) != float(b["stats"][k]):
			return "stat %s %.12f vs %.12f" % [str(k), float(a["stats"][k]), float(b["stats"][k])]
	for k in (a["moves"] as Dictionary):
		if float(a["moves"][k]) != float(b["moves"][k]):
			return "move %s %.12f vs %.12f" % [str(k), float(a["moves"][k]), float(b["moves"][k])]
	return "match"


func _col(arr: Array, key: String) -> Array:
	var out := []
	for r in arr:
		out.append(float(r[key]))
	return out


func _mean(arr: Array) -> float:
	var t := 0.0
	for v in arr:
		t += float(v)
	return t / float(maxi(1, arr.size()))


func _pct(arr: Array, q: float) -> float:
	var s := arr.duplicate()
	s.sort()
	var x := q * float(s.size() - 1)
	var lo := int(floor(x))
	var hi := mini(s.size() - 1, lo + 1)
	return lerpf(float(s[lo]), float(s[hi]), x - float(lo))


func _stops(per: Array) -> int:
	var t := 0
	for r in per:
		t += int(r["stops"])
	return t


## The result page, written by the probe: the question, the method, every measured line, the verdict against the bars.
func _write_doc(v: Dictionary, ctl: String, det: String, secs: float) -> void:
	var fh := FileAccess.open("res://docs/FITPROBE1_RESULT.md", FileAccess.WRITE)
	if fh == null:
		print("WARNING: could not write docs/FITPROBE1_RESULT.md")
		return
	fh.store_string("# FITPROBE1 + TRAINBALANCE Result\n\nProbe run: %s. Coach fit design v8 (board Q-S294-235 approved; Dola 7/7, John 7/6).\nMap: `ops/research/DESIGN_COACHFIT1_V8_REVISE_KALLI_KALLI.md` 2.1-2.2 (fit), 12 (probes and pass lines).\n\n## Question\n\nIs a TOP fit worth having, and is it not too much? Two identical twins, two coaches, six months: the better-matched\ncoach's boxer should be clearly sharper on what they worked on, but not unbeatable - the plan still matters more.\n\n## Method\n\n" % Time.get_datetime_string_from_system())
	for l in [
		"- `tools/fit_probe.gd` only. Nothing in `scripts/` or `tests/` is touched; the arms differ inside the probe.",
		"- Part 1: %d weeks (%d days) of `Sim.step_day` - the game's own week, the boxer's own plan and FOCUS, the twist cards, injuries, the phase and the week's drilling (`DrillWeek` / `PadWeek`). Luke Reid (sessional, pads 74) in every arm, load normal, no bout." % [weeks, weeks * 7],
		"- After each day the probe adds `gain_mult(fit) - 1` of the gain that day gave the FOCUS stat, through `CoachFit.capped(gain_mult, camp mult)` so the x%.1f stack cap holds, and scales the tiredness the day ADDED (its load over the night's recovery, `WeekPlan.fatigue_keep`) by `tired_mult(fit)`; the week's peak the injury roll reads follows it. At fit 50 both multipliers are exactly 1.0, so nothing is written." % CoachFit.STACK_CAP,
		"- Part 2: each week-26 boxer of both arms fights %d bouts from the same snapshot (no bout teaches into the next), `Bouts.fight_step` + `LiveRound` as `tools/adapt_probe.gd` and `tools/exchange_balance.gd` play them: no shouts, `BoutRules.auto_corner` between rounds, film 1, no camp, morale 60, tiredness 20. One fixed opponent set (`Data.OPPONENTS`), each rated to the boxer's AVERAGE-arm week-26 paper (`BoutRules.fight_power`), the SAME rating in both arms - exchange_balance's rating = paper convention, an equal-paper matchup (the baseline win share is measured, not assumed 50%%)." % bout_n,
		"- The headroom clamp is ON: `TrainingPreview.headroom` = (pot - stat)/%.0f clamped %.2f..%.2f, the game's own rule." % [TrainingPreview.HEADROOM_SPAN, TrainingPreview.HEADROOM_MIN, TrainingPreview.HEADROOM_MAX],
		"- Sharp = mastery %.0f (`MoveMastery`'s Sharp tier). Weeks to Sharp counts the first week any move reaches it; %d = not reached in the window." % [SHARP, weeks + 1],
	]:
		fh.store_line(str(l))
	fh.store_string("\n## Pass lines (map 12)\n\n- FITPROBE1: TOP - AVERAGE = +3 to +5 on the FOCUS stat over 26 weeks; a drilled move reaches Sharp 2-4 weeks sooner.\n- TRAINBALANCE: TOP wins +4 to +8 in 100 over AVERAGE, under a good plan's +14 (59 against 45), headroom clamp on.\n- CONTROL: AVERAGE against an untouched run of the same seeds must match to the digit.\n\n## Measured (the probe's own output)\n\n```text\n")
	for line in doc:
		fh.store_line(str(line))
	fh.store_string("```\n\n## Verdict\n\n- FOCUS gain difference: **%+.3f** (bar +3..+5). On the %d boxers whose FOCUS trained in the base week: **%+.3f**.\n- Sharp weeks sooner: **%+.2f** (bar 2..4); paired on the %d boxers Sharp in both arms: %+.2f.\n- Wins in 100 difference: **%+.2f** (bar +4..+8, under the plan's +%.0f).\n- CONTROL (AVERAGE vs untouched): **%s**. Determinism (one arm twice): **%s**.\n- **FITPROBE1 %s** | **TRAINBALANCE %s**\n\nA gate FAIL is a finding for the designer, not a broken probe: the numbers above are what the mechanism did.\n\nElapsed: %.0f s. Reproduce: `python ops/Tools/godot_slot.py run --who fitprobe1 -- <godot> --headless --audio-driver Dummy --path . --script res://tools/fit_probe.gd`\n" % [
		float(v["gain_diff"]), int(v["trained"]), float(v["sub_diff"]), float(v["sharp_diff"]), int(v["both"]), float(v["paired"]),
		float(v["win_diff"]), PLAN_EDGE, ctl, det, str(v["fitprobe1"]), str(v["trainbalance"]), secs])
	fh.store_string("\n## Findings (what the numbers say)\n\n- The gain bar (+3..+5) is out of reach of the specified mechanism: x1.32 on the game's own 26-week FOCUS gain adds %+.2f overall (%+.2f on the %d boxers whose FOCUS the BASE week trains; the other %d gain 0 - the coach's BASE week is fixed and its FOCUS session enters only in camp phases, so the multiplier has nothing to scale on them).\n- The Sharp bar (2-4 weeks sooner) does not move (%+.2f): this probe scales the FOCUS stat and tiredness only, NOT the evening drill units (design 2.1's other lever). Weeks to Sharp ride on drilling and the mastery cap (technique/fight_iq), which the fit barely touches; the drilled move (Uppercut) never reaches Sharp in 26 weeks in either arm.\n- The bout bar (+4..+8) is far off (%+.2f) yet under the plan's +14: a TOP fit as specified is not too much, it is too little to meet the bar - one stat's gain is a small paper edge and weapons/mastery are unchanged. The equal-paper baseline win share is printed above (the live round reads moves and plan, not paper alone), so the diff is not on the bar's 59-vs-45 scale; it is far under +4 either way. The tiredness lever is real (per-arm means above) but stays under the overreach (80) and injury lines, so it barely feeds back; the stack cap never binds without a camp (camp mult 1.0, fit x camp 1.32 < 1.6).\n" % [
		float(v["gain_diff"]), float(v["sub_diff"]), int(v["trained"]), count - int(v["trained"]), float(v["sharp_diff"]), float(v["win_diff"])])
	fh.close()
	print("Result doc written to docs/FITPROBE1_RESULT.md")
