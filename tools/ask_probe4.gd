extends SceneTree
## ASKPROBE4 (S511, TASK_ASKPROBE4): does the fight week make the show date a real choice? A NEAR show (10 days out)
## against a FAR one (21 days out), the same boxer and the same opponent, the week played through the game's own code
## (Bouts.accept -> FightWeekPlan.mark -> draft -> partners -> read -> lock, Sim.step_day for every day between, then the
## bout as ask_probe2 plays it: Bouts.fight_step + LiveRound, auto corner). A measurement only: no game file is touched.
## Population: ask_probe2's 60 (seed 4421, Data.lucy re-rated to a target power +-3 a stat, w 0-8 l 0-2, start day 0-42,
## 1 in 5 walking 0.5-1.6 kg over), the opponent ask_probe2's matchmaker books (the wlw sheet name through
## Bouts.legal_index at idx%3). No two fighters identical; no coach hired, as ask_probe2 (the assistant reads rating 50).
## The plan: the game's own opening board (PlanFight.starter: 1-2, step_back, tie_up, pivot_out), written AFTER the booking
## so every line is UNSPARRED (the v9 rule: mark files the plan she has on the booking day). A fresh signing's combo and
## footwork bars read 0, so the lines do not fire yet - the probe measures what the week's pads drill them to.
## Arms: NEAR 10 days, FAR 21 days. ASSIST = the assistant's draft (its stop, its nights) on every seed. BEST = the best of
## the 9 (3 load stops x 0/1/2 FIGHT-WEEK nights on the board's evenings: 1 night = 6 days out, 2 = 6 and 3) picked by win
## rate on the first half of the seeds, reported on the other half; the assistant's week-before night stays as drafted.
## Measured: win rate (of bouts fought), tank at the first bell (bout.stale, BoutNight._peak), share sharp in round 1,
## lines readied / left unsparred, pad mastery (the real mean punch mastery at the bell and its gain over the week, plus
## FightWeek.banked's rule units), injury rate (training rolls in the days run + the bout's roll), pull-outs, missed weight.
## WIRED vs RULE-ONLY (grep, S511): the tank, r1_edge, spar_edge, unsparred and the spar evenings are wired; the week-before
## night's pad-night cost, the late night's x2.5 injury / 3% cut and FightWeek.banked have NO caller in the game - they are
## measured as the rule module states them and named as rule-only in the result.
##   <godot.exe> --headless --audio-driver Dummy --fixed-fps 60 --path . --script res://tools/ask_probe4.gd -- [count=60] [seeds=16] [seed=4421] [near=10] [far=21]
const Data := preload("res://scripts/state/Data.gd")
const Bouts := preload("res://scripts/state/Bouts.gd")
const BoutRules := preload("res://scripts/rules/BoutRules.gd")
const LiveRound := preload("res://scripts/state/LiveRound.gd")
const Sim := preload("res://scripts/state/Sim.gd")
const Injuries := preload("res://scripts/state/Injuries.gd")
const FightWeek := preload("res://scripts/rules/FightWeek.gd")
const FightWeekPlan := preload("res://scripts/state/FightWeekPlan.gd")
const FireLevel := preload("res://scripts/rules/FireLevel.gd")
const PlanFight := preload("res://scripts/rules/PlanFight.gd")
const PadWeek := preload("res://scripts/rules/PadWeek.gd")
const STATS := ["power", "speed", "technique", "defense", "conditioning", "fight_iq"]
const DATES := ["NEAR", "FAR"]
const FW_NIGHTS := [[], [6], [6, 3]]   # 0/1/2 fight-week nights, the board's evenings (2-6 days out)
const TIE := 2.0        # the map's tie band, points of win rate
const MOVE_BAR := 3.0   # the map's bar: a measure moves 3+ points between the dates
const DOM_CAP := 6      # of 10: neither date best for more than this

var seed := 4421
var count := 60
var seeds := 16
var near := 10
var far := 21
var rng := RandomNumberGenerator.new()
var c: Career
var rivals0: Array = []
var cash0 := 0
var bouts := 0
var stepped := 0
var runs := 0
var lock_refused := 0


func _initialize() -> void:
	for a in OS.get_cmdline_user_args():
		var kv := str(a).split("=")
		if kv.size() == 2:
			match kv[0]:
				"count": count = int(kv[1])
				"seeds": seeds = int(kv[1])
				"seed": seed = int(kv[1])
				"near": near = int(kv[1])
				"far": far = int(kv[1])
	rng.seed = seed
	c = Career.quick_start()
	c.seed = seed
	rivals0 = c.rivals.duplicate(true)
	cash0 = c.cash
	var t0 := Time.get_ticks_msec()
	print("ASKPROBE4 seed=%d fighters=%d seeds=%d (half select, half report) NEAR=%d days FAR=%d days" % [seed, count, seeds, near, far])
	print("  Population: ask_probe2's 60 (Data.lucy re-rated, seed 4421), the wlw sheet name at idx%%3. No coach, cash $%d." % cash0)
	print("  Path: Bouts.accept -> FightWeekPlan draft/partners/read/lock -> Sim.step_day every day -> Bouts.fight_step.")
	var pop := _population()
	var pool := {}
	var verdict := {"ASSIST": {"NEAR": 0, "FAR": 0, "TIE": 0}, "BEST": {"NEAR": 0, "FAR": 0, "TIE": 0}}
	for arm in ["ASSIST", "BEST"]:
		for d in DATES: pool[arm + "|" + d] = []
	print("\nPER FIGHTER (win% of bouts fought; ASSIST every seed, BEST the report half; v = NEAR/FAR/tie)")
	for p in pop:
		var fk: Dictionary = p["fk"]
		var base: Dictionary = p["base"]
		var opp := _opp_name(base, fk)
		var got := {}
		var line := "  %s %d-%d d%d p%.1f o%.1f v %s |" % [str(fk["id"]), int(fk["w"]), int(fk["l"]), int(fk["d0"]),
			float(fk["power"]), float(fk["over"]), opp.get_slice(" ", 0)]
		for d in DATES:
			var days := near if d == "NEAR" else far
			got[d] = _date(base, fk, opp, days)
			for arm in ["ASSIST", "BEST"]:
				for r in (got[d][arm] as Array): (pool[arm + "|" + d] as Array).append(r)
			line += " %s A %.0f%% B %.0f%% (%s)" % [d, _win(got[d]["ASSIST"]), _win(got[d]["BEST"]), str(got[d]["best_key"])]
		for arm in ["ASSIST", "BEST"]:
			var diff := _win(got["NEAR"][arm]) - _win(got["FAR"][arm])
			var v := "TIE" if absf(diff) <= TIE else ("NEAR" if diff > 0.0 else "FAR")
			verdict[arm][v] += 1
			line += " %s:%s" % [arm, v]
		print(line)
	_report(pool, verdict, pop.size(), (Time.get_ticks_msec() - t0) / 1000)
	quit(0)


## ask_probe2's spread draw order, one fighter at a time: the fk draws then _make's six stat draws, so the population is
## the same 60 boxers (never two identical).
func _population() -> Array:
	var out: Array = []
	for i in count:
		var over := rng.randf_range(0.5, 1.6) if rng.randf() < 0.2 else 0.0
		var fk := {"id": "g%02d" % i, "idx": 100 + i, "w": i % 9, "l": (i / 9) % 3, "power": 52.0 + rng.randf() * 16.0,
			"over": over, "d0": rng.randi_range(0, 42), "morale": 55.0 + rng.randf() * 10.0}
		c.day = int(fk["d0"])
		out.append({"fk": fk, "base": _make(fk)})
	return out


func _make(fk: Dictionary) -> Dictionary:
	var f: Dictionary = Data.fighter_state(Data.lucy(), c.day)
	var p0 := BoutRules.fight_power(f["stats"], {}, 0, "")
	for s in STATS: f["stats"][s] = float(f["stats"][s]) + float(fk["power"]) - p0 + rng.randf_range(-3.0, 3.0)
	f["w"] = int(fk["w"]); f["l"] = int(fk["l"])
	f["weight"] = float(f["limit"]) + float(fk["over"]); f["morale"] = float(fk["morale"])
	return f


func _opp_name(base: Dictionary, fk: Dictionary) -> String:
	c.rivals = rivals0.duplicate(true)
	c.fighters = [base]
	var names: Array = Data.DIVISIONS["wlw"]["opponents"]
	var own := int(base["w"]) + int(base["l"])
	return str(names[Bouts.legal_index(c, names, int(fk["idx"]) % 3, own)])


## One date arm: the 9 combos on the selection half, the best and the assistant's on the report half.
func _date(base: Dictionary, fk: Dictionary, opp: String, days: int) -> Dictionary:
	var half := maxi(1, seeds / 2)
	var sel := {}
	var asst_stop := FightWeek.DEFAULT_STOP
	var asst_fw := 0
	for ci in FW_NIGHTS.size():
		for stop in FightWeek.STOPS:
			var key := "%s|%d" % [str(stop), ci]
			sel[key] = []
			for s in half:
				var r := _run(base, fk, opp, days, str(stop), FW_NIGHTS[ci], s)
				(sel[key] as Array).append(r)
				asst_stop = str(r["asst_stop"])
				asst_fw = int(r["asst_fw"])
	var asst_key := "%s|%d" % [asst_stop, asst_fw]
	var best_key := _pick(sel)
	var rep := {best_key: [], asst_key: []}
	for s in range(half, seeds):
		var bk := best_key.split("|")
		(rep[best_key] as Array).append(_run(base, fk, opp, days, str(bk[0]), FW_NIGHTS[int(bk[1])], s))
		if asst_key != best_key:
			(rep[asst_key] as Array).append(_run(base, fk, opp, days, asst_stop, FW_NIGHTS[asst_fw], s))
	var assist: Array = (sel[asst_key] as Array) + (rep[asst_key] as Array)
	return {"ASSIST": assist, "BEST": rep[best_key], "best_key": best_key, "asst_key": asst_key}


## The best of the 9 by win rate on the selection half; a tie goes to the lighter week (fewer nights, then the lighter stop).
func _pick(sel: Dictionary) -> String:
	var best := ""
	var top := -1.0
	for ci in FW_NIGHTS.size():
		for stop in FightWeek.STOPS:
			var key := "%s|%d" % [str(stop), ci]
			var w := _win(sel[key])
			if w > top + 1e-9: top = w; best = key
	return best


## One week and one bout through the game's own path. The clock really runs: the week-before night (8 days out) and the
## fight-week nights happen only because the days pass them.
func _run(base: Dictionary, fk: Dictionary, opp_nm: String, days: int, stop: String, nights: Array, s: int) -> Dictionary:
	runs += 1
	c.rivals = rivals0.duplicate(true)
	c.news.clear(); c.results.clear(); c.favours = {}; c.cash = cash0
	c.day = int(fk["d0"])
	var f: Dictionary = base.duplicate(true)
	f["id"] = "a4_%d_s%d" % [int(fk["idx"]), s]
	f["bout"] = {}; f["camp"] = {}; f["injury"] = {}; f["ko_history"] = []; f["offers"] = []
	f["morale"] = float(fk["morale"])
	for k in ["sparred", "arrows", "last_bout_day", "stand_down", "week_nights", "phase", "week_edits"]: f.erase(k)
	c.fighters = [f]
	var out := {"fought": false, "won": false, "pulled": false, "missed": false, "injured": false, "stop": stop,
		"nights": nights.size(), "wb": false, "asst_stop": FightWeek.DEFAULT_STOP, "asst_fw": 0, "tank": 0.0, "sharp": false,
		"readied": 0, "unsparred": 0, "banked": 0, "pad_mean": 0.0, "pad_gain": 0.0, "plan_m": 0.0, "plan_gain": 0.0, "tired": 0.0,
		"spar_edge": 0.0, "r1_edge": 0.0, "r1_won": false, "sw": false, "sl": false, "days": 0}
	var opp: Dictionary = c.rival(opp_nm).duplicate(true)
	var on := c.day + days
	var oid := "%s:o%d" % [str(f["id"]), c.day]
	f["offers"] = [Bouts._offer(oid, opp, on, c.day + Bouts.OFFER_ANSWER_DAYS, int(f["w"]) + int(f["l"]))]
	if not Bouts.accept(c, oid): return out
	f["arrows"] = PlanFight.starter()   # written after the booking: every line unsparred (FightWeekPlan.mark filed none)
	var m0 := _pad_mean(f)
	var pm0 := _plan_mastery(f)
	var plan := FightWeekPlan.draft(c, f)
	out["asst_stop"] = str(plan["stop"])
	var nd: Dictionary = {}
	for dk in (plan["nights"] as Dictionary):
		if int(dk) < FightWeekPlan.WEEK_BEFORE: out["asst_fw"] = int(out["asst_fw"]) + 1
	if (plan["nights"] as Dictionary).has(FightWeekPlan.WEEK_BEFORE):
		nd[FightWeekPlan.WEEK_BEFORE] = ""
		out["wb"] = true
	for d in nights: nd[int(d)] = ""
	plan["stop"] = stop
	plan["nights"] = nd
	_partners(f, plan)
	var r := FightWeekPlan.read(c, f, plan)
	out["readied"] = (r["readied"] as Array).size()
	out["unsparred"] = (r["unsparred"] as Array).size()
	out["sharp"] = str((r["round_one"] as Dictionary)["state"]) == FightWeek.STATE_SHARP
	out["spar_edge"] = float(r["spar_edge"])
	out["r1_edge"] = float(r["edge"])
	if FightWeekPlan.lock(c, f, plan) != "":
		lock_refused += 1
		return out
	var pad_units := 0.0
	for i in days:
		var dow := posmod(c.day, 7)
		var n := PadWeek.nights_of(f)
		if on - c.day <= 7 and (n["pads"] as Array).has(dow): pad_units += PadWeek.night_minutes(n, dow)
		Sim.step_day(c)
		stepped += 1
		out["days"] = int(out["days"]) + 1
		if not (f.get("injury", {}) as Dictionary).is_empty(): out["injured"] = true
		if (f.get("bout", {}) as Dictionary).is_empty():
			out["pulled"] = true
			break
		if Injuries.pending(f):   # the sensible coach's call on an injury that runs past the bell: pull her out
			Injuries.pull_out(c, f)
			out["pulled"] = true
			break
		if c.day == on - 1 and not bool((f["bout"] as Dictionary).get("weighed", false)):
			if not Bouts.weigh(c, f):
				out["missed"] = true
				break
	out["banked"] = FightWeek.banked(stop, roundi(pad_units))   # rule-only: nothing in the game banks these units
	out["pad_mean"] = _pad_mean(f)
	out["pad_gain"] = _pad_mean(f) - m0
	out["plan_m"] = _plan_mastery(f)
	out["plan_gain"] = _plan_mastery(f) - pm0
	out["tired"] = float(f.get("week_fatigue", 20.0))
	if bool(out["pulled"]) or bool(out["missed"]): return out
	var real_day := c.day
	c.day = 200000 + 900000 + s   # the bout's dice (LiveRound._rng reads c.day), paired across the two dates
	var b: Dictionary = f["bout"]
	var m := {"fid": str(f["id"]), "step": "tape", "total": Bouts.rounds_of(f)}
	Bouts.fight_step(c, f, m, "start")
	while true:
		while not LiveRound.live(m).is_empty(): Bouts.fight_step(c, f, m, "shout:")
		if int(m["round"]) >= Bouts.rounds_of(f) or Bouts.stopped(m) != "": break
		Bouts.fight_step(c, f, m, "corner:" + BoutRules.auto_corner(f["stats"]))
	Bouts.fight_step(c, f, m, "end")
	bouts += 1
	out["fought"] = true
	out["won"] = str(m.get("outcome", "")) == "win"
	out["tank"] = float(b.get("stale", 0.0))
	var stopped := Bouts.stopped(m) != ""
	out["sw"] = stopped and bool(out["won"])
	out["sl"] = stopped and not bool(out["won"])
	var ra: Array = m.get("rounds", [])
	out["r1_won"] = not ra.is_empty() and bool((ra[0] as Dictionary).get("won", false))
	if str(m.get("injury", "")) != "" or not (f.get("injury", {}) as Dictionary).is_empty(): out["injured"] = true
	c.day = real_day
	c.results.clear()
	return out


## Every night takes the best-ranked partner still free (the partner screen's own order, FightWeekPlan.partners).
func _partners(f: Dictionary, plan: Dictionary) -> void:
	var plist := FightWeekPlan.partners(c, f)
	var keys: Array = (plan["nights"] as Dictionary).keys()
	keys.sort()
	keys.reverse()
	var used: Array = []
	for k in keys:
		for p in plist:
			if not used.has(str(p["id"])):
				(plan["nights"] as Dictionary)[k] = str(p["id"])
				used.append(str(p["id"]))
				break


func _pad_mean(f: Dictionary) -> float:
	var s := 0.0
	for m in Data.MOVES: s += float((f.get("moves", {}) as Dictionary).get(m, 0.0))
	return s / maxf(1.0, float(Data.MOVES.size()))


func _plan_mastery(f: Dictionary) -> float:
	var arrows: Array = f.get("arrows", [])
	var s := 0.0
	for a in arrows: s += FireLevel.mastery_of(f, str((a as Dictionary)["move"]))
	return s / maxf(1.0, float(arrows.size()))


func _win(runs_list: Array) -> float:
	var fought := 0
	var won := 0
	for r in runs_list:
		if bool(r["fought"]): fought += 1; won += int(bool(r["won"]))
	return 100.0 * float(won) / maxf(1.0, float(fought))


func _mean(runs_list: Array, key: String) -> float:
	var s := 0.0
	for r in runs_list: s += float(r[key])
	return s / maxf(1.0, float(runs_list.size()))


## A bell-time number (the tank, the tiredness, the mastery the week drilled) reads only the weeks that reached a bell:
## a pulled-out or missed-weight week has no first bell, and its mastery stands at the day it ended, not at the show.
func _mean_f(runs_list: Array, key: String) -> float:
	var s := 0.0
	var n := 0
	for r in runs_list:
		if bool(r["fought"]): s += float(r[key]); n += 1
	return s / maxf(1.0, float(n))


func _n_fought(runs_list: Array) -> int:
	var n := 0
	for r in runs_list: n += int(bool(r["fought"]))
	return n


func _share(runs_list: Array, key: String) -> float:
	var n := 0
	for r in runs_list: n += int(bool(r[key]))
	return 100.0 * float(n) / maxf(1.0, float(runs_list.size()))


func _fought_share(runs_list: Array) -> float:
	var n := 0
	for r in runs_list: n += int(bool(r["fought"]))
	return 100.0 * float(n) / maxf(1.0, float(runs_list.size()))


func _stop_n(runs_list: Array, stop: String) -> int:
	var n := 0
	for r in runs_list: n += int(str(r["stop"]) == stop)
	return n


func _report(pool: Dictionary, verdict: Dictionary, n: int, secs: int) -> void:
	var lines: Array = []
	lines.append("# ASKPROBE4 result (S511) - does the fight week make the show date a real choice?")
	lines.append("")
	lines.append("Probe: `tools/ask_probe4.gd`, seed **%d**, %d fighters (ask_probe2's population: Data.lucy re-rated to a target" % [seed, n])
	lines.append("power 52-68 +-3 a stat, w 0-8 l 0-2, start day 0-42, 1 in 5 walking 0.5-1.6 kg over), the wlw sheet name at idx%3,")
	lines.append("no coach hired, cash $%d. %d seeds an arm: the first half selects the best of the 9, the second half reports it." % [cash0, seeds])
	lines.append("Every week runs the game's own days (Sim.step_day) and every bout is the game's own bout (Bouts.fight_step +")
	lines.append("LiveRound, auto corner): **%d bouts, %d days stepped, %d week-runs** in %ds. Lock refused %d weeks." % [bouts, stepped, runs, secs, lock_refused])
	lines.append("")
	lines.append("Reproduce (Git Bash, through the slot):")
	lines.append("`python ops/Tools/godot_slot.py run --who ASKPROBE4 -- \"$LOCALAPPDATA/Programs/Godot/Godot_v4.7.2-stable_win64.exe\" --headless --audio-driver Dummy --fixed-fps 60 --log-file E:/FightCamp/tmp/askprobe4.log --path . --script res://tools/ask_probe4.gd -- count=%d seeds=%d seed=%d near=%d far=%d`" % [count, seeds, seed, near, far])
	lines.append("(levers: `count=60`, `seeds=16`, `seed=4421`, `near=10`, `far=21`; the line above is this run).")
	lines.append("")
	lines.append("## The arms")
	lines.append("")
	lines.append("- **NEAR**: the bout booked %d days out. **FAR**: %d days out. The same boxer, the same opponent, the same dice" % [near, far])
	lines.append("  (c.day = 200000 + 900000 + seed on both), so the only difference is the date and the days it buys.")
	lines.append("- **ASSIST**: FightWeekPlan.draft's own stop and nights, locked with the best-ranked free partner on every night.")
	lines.append("- **BEST**: the best of the 9 (Rest up / Tick over / Train through x 0/1/2 fight-week nights; 1 night = 6 days out,")
	lines.append("  2 = 6 and 3) by win rate on the selection half, reported on the other half. The assistant's week-before night stays.")
	lines.append("- The plan is the game's opening board (PlanFight.starter: 1-2, step_back, tie_up, pivot_out) written AFTER the")
	lines.append("  booking, so all four lines are unsparred until a night readies them (the v9 rule).")
	lines.append("")
	lines.append("## Per arm (the population above; win% is of bouts fought)")
	lines.append("")
	lines.append("| Arm | Date | win% | fought% | tank off | sharp% | readied | unsparred | plan mastery | plan gain | punch mastery | banked units | injury% | pull-out% | miss% |")
	lines.append("|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|")
	var summary := {}
	for arm in ["ASSIST", "BEST"]:
		for d in DATES:
			var rs: Array = pool[arm + "|" + d]
			var row := {"win": _win(rs), "fought": _fought_share(rs), "tank": _mean_f(rs, "tank"), "sharp": _share(rs, "sharp"),
				"readied": _mean(rs, "readied"), "unsparred": _mean(rs, "unsparred"), "pad": _mean_f(rs, "pad_mean"),
				"gain": _mean_f(rs, "pad_gain"), "banked": _mean_f(rs, "banked"), "inj": _share(rs, "injured"),
				"pull": _share(rs, "pulled"), "miss": _share(rs, "missed"), "plan": _mean_f(rs, "plan_m"),
				"plan_gain": _mean_f(rs, "plan_gain"), "tired": _mean_f(rs, "tired"), "spar_edge": _mean(rs, "spar_edge"),
				"r1_edge": _mean(rs, "r1_edge"), "wb": _share(rs, "wb"), "n": rs.size(), "nf": _n_fought(rs)}
			summary[arm + "|" + d] = row
			lines.append("| %s | %s | %.1f | %.1f | %.1f | %.1f | %.2f | %.2f | %.2f | %+.2f | %.2f | %.0f | %.1f | %.1f | %.1f |" % [
				arm, d, row["win"], row["fought"], row["tank"], row["sharp"], row["readied"], row["unsparred"],
				row["plan"], row["plan_gain"], row["pad"], row["banked"], row["inj"], row["pull"], row["miss"]])
			print("ARM %s %s weeks=%d fought=%d win=%.1f%% tank=%.1f sharp=%.1f%% readied=%.2f unsparred=%.2f plan_m=%.2f plan_gain=%+.2f punch_m=%.2f banked=%.0f injury=%.1f%% pull=%.1f%% miss=%.1f%%" % [
				arm, d, int(row["n"]), int(row["nf"]), row["win"], row["tank"], row["sharp"], row["readied"], row["unsparred"],
				row["plan"], row["plan_gain"], row["pad"], row["banked"], row["inj"], row["pull"], row["miss"]])
	lines.append("")
	lines.append("Denominators: win%, tank off, tired at bell, plan/punch mastery, plan gain and banked units read the weeks that REACHED A")
	lines.append("BELL (fought% of the weeks; a pulled-out or missed-weight week has no first bell). Sharp%, readied, unsparred, the edges")
	lines.append("and week-before%% read every LOCKED week, and injury%%/pull-out%%/miss%% every week run. The ASSIST arm runs %d seeds a" % seeds)
	lines.append("fighter, the BEST arm the report half (%d); the per-fighter verdict below uses those same win rates." % maxi(1, seeds / 2))
	lines.append("")
	lines.append("**Plan mastery** = the mean mastery of the plan's four lines at the bell (FireLevel.mastery_of: the combo's drilled")
	lines.append("mastery, each footwork line's bar) - the map's 'pad mastery on the plan's moves'. **Plan gain** = that minus the booking")
	lines.append("day (all four lines start at 0 on a fresh signing). **Punch mastery** = the mean of her six punches (DrillWeek/PadWeek).")
	lines.append("**Banked units** = FightWeek.banked(stop, the fight week's pad minutes) - RULE-ONLY: no game code calls banked(), so")
	lines.append("those units are not written into mastery. **Readied / unsparred** = the plan lines the locked nights ready / leave")
	lines.append("unsparred (an unsparred line fires one level down in rounds 1-2). **Tank off** = bout.stale at the first bell.")
	lines.append("")
	lines.append("| Arm | Date | tired at bell | spar edge (r1-2) | r1 edge | week-before% | Rest up | Tick over | Train through |")
	lines.append("|---|---|---|---|---|---|---|---|---|")
	for arm in ["ASSIST", "BEST"]:
		for d in DATES:
			var rs2: Array = pool[arm + "|" + d]
			var row2: Dictionary = summary[arm + "|" + d]
			lines.append("| %s | %s | %.1f | %+.2f | %+.2f | %.0f | %d | %d | %d |" % [arm, d, row2["tired"],
				row2["spar_edge"], row2["r1_edge"], row2["wb"], _stop_n(rs2, "rest_up"), _stop_n(rs2, "tick_over"), _stop_n(rs2, "train_through")])
	lines.append("")
	lines.append("## NEAR against FAR, fighter by fighter (tie = inside %.0f points of win rate)" % TIE)
	lines.append("")
	lines.append("| Arm | NEAR better | FAR better | tie | of %d |" % n)
	lines.append("|---|---|---|---|---|")
	for arm in ["ASSIST", "BEST"]:
		var v: Dictionary = verdict[arm]
		lines.append("| %s | %d | %d | %d | %d |" % [arm, int(v["NEAR"]), int(v["FAR"]), int(v["TIE"]), n])
		print("VERDICT %s: NEAR better %d, FAR better %d, tie %d (of %d)" % [arm, int(v["NEAR"]), int(v["FAR"]), int(v["TIE"]), n])
	lines.append("")
	var half := maxi(1, seeds / 2)
	lines.append("Granularity, said plainly: the ASSIST arm reads %d seeds a fighter (win rate moves in %.1f-point steps), the BEST arm" % [seeds, 100.0 / float(seeds)])
	lines.append("the report half of %d (%.1f-point steps). The brief's tie band is %.0f points, so at this size a 'tie' is an exact tie of" % [half, 100.0 / float(half), TIE])
	lines.append("the two win rates; a fighter whose dates differ by one seed is counted for the date that won. The pooled arm rows above")
	lines.append("carry %d bouts an arm, so their win rates are the tighter number." % int(summary["ASSIST|NEAR"]["nf"]))
	lines.append("")
	lines.append("## The map's bar")
	lines.append("")
	var a: Dictionary = summary["ASSIST|NEAR"]
	var b: Dictionary = summary["ASSIST|FAR"]
	var dom := maxi(int(verdict["ASSIST"]["NEAR"]), int(verdict["ASSIST"]["FAR"]))
	var cap := int(floor(float(n) * float(DOM_CAP) / 10.0))
	var spread_ok := dom <= cap
	var moves := {"win": absf(float(a["win"]) - float(b["win"])), "mastery": absf(float(a["plan"]) - float(b["plan"])),
		"injury": absf(float(a["inj"]) - float(b["inj"]))}
	var moved: Array = []
	for k in moves:
		if float(moves[k]) >= MOVE_BAR: moved.append("%s %.1f points" % [k, float(moves[k])])
	var move_ok := not moved.is_empty()
	lines.append("- Neither date best for more than %d of 10 (%d of %d): the assistant arm's dominant date is best for %d of %d - **%s**." % [
		DOM_CAP, cap, n, dom, n, "PASS" if spread_ok else "FAIL"])
	lines.append("- At least one of win / mastery / injury moves %.0f+ points between the dates: win %.1f, plan mastery %.2f, injury %.1f - **%s** (%s)." % [
		MOVE_BAR, float(moves["win"]), float(moves["mastery"]), float(moves["injury"]),
		"PASS" if move_ok else "FAIL", "; ".join(moved) if move_ok else "none moves 3"])
	lines.append("  Mastery here is the plan's lines (the map's pad mastery on the plan's moves); the six punches' own mean moves %.2f points." % absf(float(a["pad"]) - float(b["pad"])))
	lines.append("")
	lines.append("A real choice = both bars hold: **%s**." % ("YES" if spread_ok and move_ok else "NO"))
	print("BAR spread: dominant date best for %d of %d (cap %d) -> %s" % [dom, n, cap, "PASS" if spread_ok else "FAIL"])
	print("BAR move: win %.1f plan mastery %.2f injury %.1f (bar %.0f) -> %s" % [float(moves["win"]), float(moves["mastery"]), float(moves["injury"]), MOVE_BAR, "PASS" if move_ok else "FAIL"])
	print("ASKPROBE4 real choice = %s" % ("YES" if spread_ok and move_ok else "NO"))
	lines.append("")
	lines.append("## What the game actually wires (grep, S511) - read the table with this")
	lines.append("")
	lines.append("- Wired: the tank's choice layer (BoutRules.tank_parts_for reads bout.load / spar_days / eat_less), Rest up's flat")
	lines.append("  round (bout.r1_edge), the partner edge in rounds 1-2 (bout.spar_edge), the unsparred fire shift (FireLevel.round_mastery),")
	lines.append("  the fight-week spar evenings and the film night's pad night (WeekPlan.evenings_of), the training injury roll (Injuries.end_week).")
	lines.append("- NOT wired (rule or screen text only): the week-before night's one pad night (FightWeek.spar_night.costs_pad_night has no")
	lines.append("  caller outside the UI), the late night's x2.5 injury and 3% cut stop (SPAR_LATE_INJURY_X / SPAR_LATE_CUT_STOP), and")
	lines.append("  FightWeek.banked's mastery units. A week-before night also never enters bout.spar_days, so it adds no spar evening.")
	lines.append("- The assistant's draft places a week-before night whenever the bout is 8+ days out at the draft (FightWeekPlan.WEEK_BEFORE),")
	lines.append("  so the NEAR arm at %d days gets one too: week-before night placed on %.0f%% of NEAR weeks and %.0f%% of FAR weeks." % [
		near, float(a["wb"]), float(b["wb"])])
	lines.append("  The brief's NEAR label says 'no week-before nights'; the rule's threshold is 8 days, and %d >= 8. Measured as the game does it." % near)
	lines.append("- The probe books exactly %d / %d days out as the brief asks; the club's own show day is a Saturday" % [near, far])
	lines.append("  (AmateurBooking.fight_day), so the bell's weekday varies with the fighter's start day - the same for both arms of a fighter.")
	lines.append("")
	lines.append("## RESULT")
	lines.append("")
	lines.append("`RESULT: tools/ask_probe4.gd -> ASKPROBE4 done`")
	var text := "\n".join(lines) + "\n"
	var fa := FileAccess.open("res://docs/ASKPROBE4_RESULT.md", FileAccess.WRITE)
	if fa != null:
		fa.store_string(text)
		fa.close()
		print("WROTE docs/ASKPROBE4_RESULT.md (%d chars)" % text.length())
	else:
		print("WRITE FAILED docs/ASKPROBE4_RESULT.md")
	print("ASKPROBE4 done")
