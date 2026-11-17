extends SceneTree
## MORNINGSPROBE1 (S511, club week map DESIGN_CLUBWEEK1_V9_REVISE_KALLI_KALLI.md 3.5 + 9): is the coached-morning deal
## worth a screen? SOLO 1.25, SOLO_WEAK 1.4, SHARED 1.15 are ESTIMATES no probe ever measured. The same gym of three
## boxers gets 12 weeks of mornings three ways, then 10 even bouts each through the game's real bout. Bar from the map:
## each policy best on 30-70 of 100 seeds = a real choice; over 70 = dominant.
## HOW THE BRIEF IS READ (full prose in the result doc): a coached morning is a normal morning with a multiplier AND an
## ability (the ask names it); every UNFUNDED morning runs exactly as the coach wrote it (map 3.5: "a bonus, not a cut").
## Its session's minutes, load, kcal and fatigue are unchanged, so the fatigue trace is IDENTICAL across policies. Asks
## are laid day-major so the budget spreads across the week. No bout in the 12 weeks: the coach's BASE week gives all
## three the same ability on a day, so ALL SHARED can pair; the deal pairs across days and a lone shared becomes solo.
## The hole is re-read every week. Bouts at BoutRules.FRESH_FATIGUE as ask_probe2's are; the 12-week fatigue trace is
## identical across policies (the sessions' load never changes), so that condition cannot bias the comparison.
## POPULATION: the TEST CLUB's three boxers, 100 seeds off 4421, each fight ability jittered +/-4.0; the SAME club faces
## all three policies and both coach kinds. Opponents: the ten nearest-rated DISTINCT amateurs of the same sex in the
## region's population, fixed on PRE-TRAINING fight power. Both named in full in the result doc.
## Usage: python ops/Tools/godot_slot.py run --who morningsprobe1 -- <godot> --headless --audio-driver Dummy --fixed-fps 60
##          --path . --log-file E:/FightCamp/tmp/morningsprobe1.log --script res://tools/mornings_probe1.gd -- seeds=100

const Data := preload("res://scripts/state/Data.gd")
const Bouts := preload("res://scripts/state/Bouts.gd")
const BoutRules := preload("res://scripts/rules/BoutRules.gd")
const LiveRound := preload("res://scripts/state/LiveRound.gd")
const Sim := preload("res://scripts/state/Sim.gd")
const WeekPlan := preload("res://scripts/rules/WeekPlan.gd")
const PadWeek := preload("res://scripts/rules/PadWeek.gd")
const TrainingPreview := preload("res://scripts/rules/TrainingPreview.gd")
const CoachedMornings := preload("res://scripts/rules/CoachedMornings.gd")
const TestClub := preload("res://scripts/state/TestClub.gd")
const FightWeekPlan := preload("res://scripts/state/FightWeekPlan.gd")
const POLICIES := ["ALL_SHARED", "ALL_SOLO", "WEAK_FIRST"]
const KINDS := ["sessional", "full_time"]
const DOC := "res://docs/MORNINGSPROBE1_RESULT.md"
const BAR_LOW := 30.0
const BAR_HIGH := 70.0
const KEYS := ["pts", "weak", "power", "wins", "losses", "best", "outright", "joint", "sess", "gain"]

var n_seeds := 100
var n_weeks := 12
var n_bouts := 10
var base_seed := 4421
var jitter := 4.0
var c: Career
var bouts_played := 0
var sum_own := 0.0
var sum_opp := 0.0
var n_opp := 0

func _initialize() -> void:
	for a in OS.get_cmdline_user_args():
		var kv := str(a).split("=")
		if kv.size() == 2:
			match kv[0]:
				"seeds": n_seeds = int(kv[1])
				"weeks": n_weeks = int(kv[1])
				"bouts": n_bouts = int(kv[1])
				"seed": base_seed = int(kv[1])
				"jitter": jitter = float(kv[1])
	var t0 := Time.get_ticks_msec()
	print("MORNINGSPROBE1 seeds=%d weeks=%d bouts=%d seed=%d jitter=%.1f" % [n_seeds, n_weeks, n_bouts, base_seed, jitter])
	print("  TEST CLUB: Lucy (wlw), Kira (wfw), Josh (mww); Ana the grappler takes no mornings.")
	print("  ALL_SHARED pairs on the session's ability; ALL_SOLO on the lowest ability; WEAK_FIRST solo on the hole else shared.")
	var tables := {}
	for kind in KINDS:
		tables[kind] = _kind(kind)
	var rows := _rows(tables)
	_report(rows, tables)
	_doc(rows, tables)
	print("MORNINGSPROBE1 bouts: %d in %ds" % [bouts_played, (Time.get_ticks_msec() - t0) / 1000])
	print("MORNINGSPROBE1 done")
	quit(0)

## One coach kind over all seeds: the paired club, the three policies, and which policy won the seed.
func _kind(kind: String) -> Dictionary:
	var acc := {}
	for p in POLICIES:
		var z := {}
		for k in KEYS:
			z[k] = 0.0
		acc[p] = z
	var ties := 0
	for s in n_seeds:
		var club := _club(s, kind)
		var opps := _opponents(club)
		var weak0: Array = []
		for f in club:
			weak0.append(_lowest(f["stats"]))
		var per := {}
		for p in POLICIES:
			var fs: Array = club.duplicate(true)
			var cm := _train(fs, p)
			var bt := _bout_set(fs, opps, s)
			per[p] = {"pts": _pts(club, fs), "weak": _weak_pts(club, fs, weak0), "power": _power(club, fs),
				"wins": float(bt["wins"]), "losses": float(bt["losses"]), "sess": float(cm["n"]), "gain": float(cm["gain"])}
		for p in POLICIES:
			for k in KEYS:
				if k != "best" and k != "outright" and k != "joint":
					acc[p][k] = float(acc[p][k]) + float(per[p][k])
		var top := -1.0
		var tied: Array = []
		for p in POLICIES:
			var w: float = float(per[p]["wins"])
			if w > top:
				top = w
				tied = [p]
			elif w == top:
				tied.append(p)
		if tied.size() > 1:
			ties += 1
		for p in tied:
			acc[p]["best"] = float(acc[p]["best"]) + 1.0 / float(tied.size())
			acc[p]["joint"] = float(acc[p]["joint"]) + 1.0
			if tied.size() == 1:
				acc[p]["outright"] = float(acc[p]["outright"]) + 1.0
	return {"acc": acc, "ties": ties}

## The seed's club: the TEST CLUB's three boxers, each fight ability jittered by a per-seed RNG (the same club for every
## policy and both coach kinds), no bout and no camp, so the coach's BASE week is what they run.
func _club(s: int, kind: String) -> Array:
	c = Career.quick_start()
	c.seed = base_seed + s
	TestClub.make(c)
	c.coach["full_time"] = kind == "full_time"
	var jr := RandomNumberGenerator.new()
	jr.seed = base_seed * 7919 + s
	var out: Array = []
	for f in c.fighters:
		var g: Dictionary = f.duplicate(true)
		for a in CoachedMornings.FIGHT_ABILITIES:
			g["stats"][a] = float(g["stats"][a]) + jr.randf_range(-jitter, jitter)
		g["week_fatigue"] = 20.0
		g["phase"] = "base"
		g["phase_day"] = 0
		g["bout"] = {}
		g["camp"] = {}
		out.append(g)
	return out

## Ten distinct even opponents per boxer: the nearest-rated amateurs of the same sex, fixed on PRE-TRAINING power.
func _opponents(club: Array) -> Array:
	var out: Array = []
	for f in club:
		var own := BoutRules.fight_power(f["stats"], {}, 0, "")
		var pool: Array = []
		for r in c.rivals:
			if Data.sex_of(r) == Data.sex_of(f):
				pool.append(r)
		pool.sort_custom(func(x, y): return absf(float(x["rating"]) - own) < absf(float(y["rating"]) - own))
		var names: Array = []
		for i in mini(n_bouts, pool.size()):
			names.append(str((pool[i] as Dictionary)["name"]))
		out.append(names)
		var rs := 0.0
		for nm in names:
			rs += float(c.rival(str(nm))["rating"])
		sum_own += own
		sum_opp += rs / maxf(1.0, float(names.size()))
		n_opp += 1
	return out

## The lowest of the six fight abilities, in the module's own order (its tie rule).
func _lowest(stats: Dictionary) -> String:
	var low := INF
	var id := ""
	for a in CoachedMornings.FIGHT_ABILITIES:
		var v := float(stats.get(a, 0.0))
		if v < low:
			low = v
			id = a
	return id

## 12 weeks: the week's asks dealt club-wide by the real rule, then each boxer's week run morning by morning.
func _train(fs: Array, policy: String) -> Dictionary:
	var kind := FightWeekPlan.coach_kind(c)
	var sess := 0.0
	var gain := 0.0
	for w in n_weeks:
		var plan := {}
		var asks: Array = []
		for f in fs:
			f["phase_day"] = w * 7
			plan[str(f["id"])] = {}
		for d in 7:
			for f in fs:
				var days := WeekPlan.days_of(f)
				var sid := str((days[d] as Array)[0])
				var stat := str(WeekPlan.session(sid)["stat"])
				if stat == "" or not (f["stats"] as Dictionary).has(stat):
					continue
				var target := _target(f, policy, stat)
				asks.append({"id": str(f["id"]), "dow": d, "ability": target, "use": _use(f, policy),
					"weak": target == CoachedMornings.weak_spot(f["stats"])})
		var dealt := CoachedMornings.deal(asks, kind)
		for i in asks.size():
			var a: Dictionary = asks[i]
			var r: Dictionary = dealt[i]
			if str(r["use"]) == "solo" or str(r["use"]) == "shared":
				sess += 1.0
			(plan[str(a["id"])] as Dictionary)[int(a["dow"])] = r
		for f in fs:
			gain += _week(f, plan[str(f["id"])])
	return {"n": sess, "gain": gain}

## One boxer's week, exactly WeekPlan.week's day loop (full_day, the fatigue carry, the evening, rest's attribute gain)
## with ONE change: a funded morning trains the ask's ability at the normal morning rate x CoachedMornings' multiplier.
## Returns the stat gain those coached mornings delivered.
func _week(f: Dictionary, plan: Dictionary) -> float:
	var ctx := Sim.week_ctx(c, f)
	var days := WeekPlan.days_of(f)
	var evs := PadWeek.evenings(f)
	var stats: Dictionary = (ctx["stats"] as Dictionary).duplicate()
	var weight := float(ctx["weight"])
	var fat := float(ctx["fatigue"])
	var gains := {}
	var coached := 0.0
	for i in 7:
		var cc := ctx.duplicate()
		cc["stats"] = stats
		cc["weight"] = weight
		var sid := str((days[i] as Array)[0])
		var it := str((days[i] as Array)[1])
		var r := WeekPlan.full_day(sid, it, str(evs[i]), cc, fat)
		var st := str(r["stat"])
		var g := float(r["gain"])
		var p: Dictionary = plan.get(i, {})
		var muse := str(p.get("use", "none"))
		if muse == "solo" or muse == "shared":
			st = str(p["ability"])
			g = _morning(stats, ctx, sid, it, fat, st) * float(p["mult"])
			coached += g
		if st != "" and stats.has(st):
			if st == str(ctx.get("camp_stat", "")):
				g *= float(ctx.get("camp_mult", 1.0))
			stats[st] = float(stats[st]) + g
			gains[st] = float(gains.get(st, 0.0)) + g
		var st2 := str(r["stat2"])
		if st2 != "" and stats.has(st2):
			var g2 := float(r["gain2"])
			if st2 == str(ctx.get("camp_stat", "")):
				g2 *= float(ctx.get("camp_mult", 1.0))
			stats[st2] = float(stats[st2]) + g2
			gains[st2] = float(gains.get(st2, 0.0)) + g2
		WeekPlan._attr_to_old(stats, gains, sid, float(r.get("attr_gain", 0.0)))   # rest/mobility, as week() applies it
		weight += float(r["kg"])
		fat = float(r["fatigue"])
	f["stats"] = stats
	f["weight"] = weight
	f["week_fatigue"] = fat
	return coached

## WeekPlan.day's own morning rate on another ability: a fifth of the week's pace x the intensity x the coach factor x headroom.
func _morning(stats: Dictionary, ctx: Dictionary, sid: String, it: String, fat: float, ability: String) -> float:
	var itg := float((WeekPlan.INTENSITY.get(it, WeekPlan.INTENSITY["normal"]) as Dictionary)["gain"])
	var share := WeekPlan.SESSION_SHARE * itg * (WeekPlan.TIRED_GAIN if fat >= WeekPlan.OVERREACHED else 1.0)
	var one := TrainingPreview.preview_gain(stats, int(ctx.get("pot", 70)), {"training_modifiers": [ability]},
		WeekPlan.coach_for(ctx, sid), 1.0, share)
	return float(one.get(ability, 0.0)) * float((ctx.get("head_gain", {}) as Dictionary).get(ability, 1.0))

func _target(f: Dictionary, policy: String, session_stat: String) -> String:
	if policy == "ALL_SOLO":
		return _lowest(f["stats"])
	if policy == "WEAK_FIRST":
		var hole := CoachedMornings.weak_spot(f["stats"])
		return hole if hole != "" else session_stat
	return session_stat

func _use(f: Dictionary, policy: String) -> String:
	if policy == "ALL_SOLO":
		return "solo"
	if policy == "WEAK_FIRST":
		return "solo" if CoachedMornings.weak_spot(f["stats"]) != "" else "shared"
	return "shared"

## 10 even bouts a boxer, the same ten opponents and the same dice for every policy.
func _bout_set(fs: Array, opps: Array, s: int) -> Dictionary:
	var wins := 0
	var losses := 0
	var day0 := c.day
	for bi in fs.size():
		var names: Array = opps[bi]
		for k in names.size():
			var r := _fight(fs[bi], str(names[k]), base_seed * 104729 + s * 1000 + bi * 100 + k)
			if bool(r["won"]):
				wins += 1
			else:
				losses += 1
	c.day = day0
	return {"wins": wins, "losses": losses}

## The game's real bout, the loop ask_probe2 runs: tape, every live shout, the auto corner, the end. FRESH_FATIGUE at the
## bell as ask_probe2's boxers carry, so the tank penalty does not mask the stat difference the probe is measuring.
func _fight(base: Dictionary, nm: String, dice: int) -> Dictionary:
	var keep: Array = c.fighters
	var g: Dictionary = base.duplicate(true)
	var opp: Dictionary = c.rival(nm).duplicate(true)
	c.day = 200000 + dice
	c.fighters = [g]
	c.results.clear()
	g["camp"] = {}
	g["notes_seen"] = []
	g["injury"] = {}
	g["ko_history"] = []
	g["offers"] = []
	g["week_fatigue"] = BoutRules.FRESH_FATIGUE
	g["bout"] = {"opp": opp, "day": c.day, "weighed": true, "made": true, "done": false, "film": 1}
	var m := {"fid": g["id"], "step": "tape", "total": 3}
	Bouts.fight_step(c, g, m, "start")
	while true:
		while not LiveRound.live(m).is_empty():
			Bouts.fight_step(c, g, m, "shout:")
		if int(m["round"]) >= Bouts.rounds_of(g) or Bouts.stopped(m) != "":
			break
		Bouts.fight_step(c, g, m, "corner:" + BoutRules.auto_corner(g["stats"]))
	Bouts.fight_step(c, g, m, "end")
	bouts_played += 1
	var won := str(m.get("outcome", "")) == "win"
	c.results.clear()
	c.news.clear()
	c.fighters = keep
	return {"won": won}

func _pts(before: Array, after: Array) -> float:
	var total := 0.0
	for i in before.size():
		var b: Dictionary = (before[i] as Dictionary)["stats"]
		var a: Dictionary = (after[i] as Dictionary)["stats"]
		for k in a:
			total += float(a[k]) - float(b.get(k, 0.0))
	return total

func _weak_pts(before: Array, after: Array, weak0: Array) -> float:
	var total := 0.0
	for i in before.size():
		var ab := str(weak0[i])
		total += float((after[i]["stats"] as Dictionary).get(ab, 0.0)) - float((before[i]["stats"] as Dictionary).get(ab, 0.0))
	return total

func _power(before: Array, after: Array) -> float:
	var total := 0.0
	for i in before.size():
		total += BoutRules.fight_power(after[i]["stats"], {}, 0, "") - BoutRules.fight_power(before[i]["stats"], {}, 0, "")
	return total

## Per seed averages: points, points on the starting weakest ability, fight power, the 30-bout record, best-of-100.
func _rows(tables: Dictionary) -> Array:
	var out: Array = []
	var n := maxf(1.0, float(n_seeds))
	for kind in KINDS:
		var acc: Dictionary = tables[kind]["acc"]
		for p in POLICIES:
			var a: Dictionary = acc[p]
			out.append({"kind": kind, "policy": p, "pts": float(a["pts"]) / n, "weak": float(a["weak"]) / n,
				"power": float(a["power"]) / n, "wins": float(a["wins"]) / n, "losses": float(a["losses"]) / n,
				"win": float(a["wins"]) / maxf(1.0, float(a["wins"]) + float(a["losses"])), "best": float(a["best"]),
				"outright": float(a["outright"]), "sess": float(a["sess"]) / n / maxf(1.0, float(n_weeks)),
				"rate": float(a["gain"]) / maxf(1.0, float(a["sess"]))})
	return out

func _head() -> String:
	return "  policy      pts    weak   power    W     L    win%  best/100 outright  sess/wk  gain/morn"

func _line(r: Dictionary) -> String:
	return "  %-10s %6.2f %6.2f %6.2f %5.2f %5.2f %5.1f %8.1f %8.0f %8.2f %9.3f" % [r["policy"], r["pts"], r["weak"],
		r["power"], r["wins"], r["losses"], r["win"] * 100.0, r["best"], r["outright"], r["sess"], r["rate"]]

func _even() -> String:
	var n := maxf(1.0, float(n_opp))
	return "evenness: boxer fight power %.2f before training, the ten opponents' mean rating %.2f (%d samples)" % [sum_own / n, sum_opp / n, n_opp]

func _joint(t: Dictionary) -> String:
	var parts: Array = []
	for p in POLICIES:
		parts.append("%s %.0f" % [p, float(t["acc"][p]["joint"])])
	return ", ".join(parts)

## The headline the table carries: which policy gains the bigger total, and what one funded morning pays on each.
func _finding(rows: Array, kind: String) -> String:
	var by := {}
	for r in rows:
		if str(r["kind"]) == kind:
			by[str(r["policy"])] = r
	var sh: Dictionary = by["ALL_SHARED"]
	var so: Dictionary = by["ALL_SOLO"]
	var more := float(so["pts"]) > float(sh["pts"])
	return "ALL SOLO gains %s total points than ALL SHARED (%.2f vs %.2f) and %s on the weakest ability (%.2f vs %.2f). The map's 'shared is the bigger total and solo is the focus' %s: headroom pays the hole %.3f a morning against shared's %.3f, so %.0f solo mornings a week out-gain %.0f shared ones." % [
		"MORE" if more else "less", so["pts"], sh["pts"], "more" if float(so["weak"]) > float(sh["weak"]) else "less",
		so["weak"], sh["weak"], "does NOT hold" if more else "holds", so["rate"], sh["rate"], so["sess"], sh["sess"]]

func _report(rows: Array, tables: Dictionary) -> void:
	print("\n" + _even())
	for kind in KINDS:
		print("\n%s (%d coached mornings a week) - %d seeds x 3 boxers x %d weeks, %d even bouts a seed" % [
			kind.to_upper(), CoachedMornings.owned(kind), n_seeds, n_weeks, n_bouts])
		print(_head())
		for r in rows:
			if str(r["kind"]) == kind:
				print(_line(r))
		print("  seeds tied on wins: %d of %d (a tie splits the best credit); joint best, ties counted for each: %s" % [
			int(tables[kind]["ties"]), n_seeds, _joint(tables[kind])])
		print("  " + _finding(rows, kind))
		print("  " + _verdict(kind, tables[kind]["acc"]))

## The map's bar, scaled to the run: 30-70 of 100 seeds each = a real choice. Over 70 = dominant, name the multiplier.
func _verdict(kind: String, acc: Dictionary) -> String:
	var lo := BAR_LOW * float(n_seeds) / 100.0
	var hi := BAR_HIGH * float(n_seeds) / 100.0
	var parts: Array = []
	var over := ""
	var worst := ""
	var dist := -1.0
	for p in POLICIES:
		var b := float(acc[p]["best"])
		parts.append("%s %.1f" % [p, b])
		var d := maxf(lo - b, b - hi)
		if d > dist:
			dist = d
			worst = p
		if b > hi:
			over = p
	var say := "%s: %s" % [kind.to_upper(), ", ".join(parts)]
	if over != "":
		return say + " -> DOMINANT: %s. %s" % [over, _lever(over, true)]
	if dist <= 0.0:
		return say + " -> A REAL CHOICE: every policy best on %.0f-%.0f of %d seeds (map 3.5)." % [lo, hi, n_seeds]
	return say + " -> NOT A REAL CHOICE: %s sits outside %.0f-%.0f of %d seeds. %s" % [worst, lo, hi, n_seeds, _lever(worst, false)]

## The estimate to move, named with its value read from the module. strong = over the bar, so its own rate comes down.
func _lever(policy: String, strong: bool) -> String:
	var own: Array = {"ALL_SHARED": ["SHARED", CoachedMornings.SHARED], "ALL_SOLO": ["SOLO", CoachedMornings.SOLO],
		"WEAK_FIRST": ["SOLO_WEAK", CoachedMornings.SOLO_WEAK]}[policy]
	var alt := ("SHARED (x%.2f)" % CoachedMornings.SHARED) if policy != "ALL_SHARED" else ("SOLO (x%.2f)" % CoachedMornings.SOLO)
	return "Move %s (now x%.2f) %s, or %s %s." % [own[0], own[1], "down toward 1.0" if strong else "up", alt, "up" if strong else "down"]

const DOC_HEAD := """# MORNINGSPROBE1 Result

Probe run: %s. %d seeds off %d, %d weeks, %d even bouts a boxer, ability jitter +/-%.1f.

Is the coached-morning deal (map 3.5) worth a screen? Solo x%.2f, solo on the WEAK SPOT x%.2f, shared x%.2f are ESTIMATES. Bar: each policy best on %d-%d of %d seeds is a real choice; over %d is dominant.

## Population

The TEST CLUB (scripts/state/TestClub.gd): **Lucy** (women's lightweight), **Kira** (women's featherweight), **Josh** (men's welterweight). Ana the no-gi athlete takes no mornings. Each seed jitters all six fight abilities +/-%.1f (per-seed RNG off %d); potential as written (Lucy 84, Kira 86, Josh 79). The SAME club faces all three policies and both coach kinds, so the headroom difference is the policy's, not the population's.

Opponents: the ten nearest-rated **distinct** amateurs of the same sex in the region's population (Data.OPPONENTS + MISMATCH + RIVALS + DIVISION_RIVALS), fixed on the boxer's PRE-TRAINING fight power so all three policies face the identical ten. A division's own pool holds only 4-11 fighters. %s.

## Method

- No bout during the %d weeks: the coach's BASE week (roadwork, heavy bag, intervals, speed bag light, roadwork, strength, rest) - the SAME ability for all three boxers on a day, so ALL SHARED can pair on it.
- Asks laid day-major (Monday's three boxers in club row order, then Tuesday's), dealt club-wide by CoachedMornings.deal (%d sessional, %d full-time). It pairs across days; a lone shared becomes solo.
- A FUNDED morning trains the ask's ability at WeekPlan's normal morning rate x CoachedMornings.mult; every unfunded morning runs exactly as the coach wrote it. Minutes, load, kcal and fatigue are unchanged, so the fatigue trace is identical across policies - a control.
- ALL SOLO asks the lowest of the six abilities; WEAK FIRST asks the WEAK SPOT (3+ under the mean) and falls back to shared once the hole closes. The hole is re-read every week.
- Then %d even bouts a boxer through Bouts.fight_step (ask_probe2's loop), the same dice for every policy, at BoutRules.FRESH_FATIGUE (%.0f) as ask_probe2's boxers are. The %d weeks' fatigue trace is identical across policies (the sessions' load never changes), so that condition cannot bias the comparison. Best-of-seed is by wins out of %d; a tie splits the best credit.

## Table (per-seed averages over %d seeds)

pts = all stat points the three boxers gained; weak = points on the ability weakest at the start; power = fight power gained; W/L = the %d-bout record; sess/wk = funded boxer-mornings a week; gain/morn = one funded morning's stat gain.
"""

func _doc(rows: Array, tables: Dictionary) -> void:
	var f := FileAccess.open(DOC, FileAccess.WRITE)
	if f == null:
		print("WARNING: could not write %s" % DOC)
		return
	f.store_string(DOC_HEAD % [Time.get_datetime_string_from_system(), n_seeds, base_seed, n_weeks, n_bouts, jitter,
		CoachedMornings.SOLO, CoachedMornings.SOLO_WEAK, CoachedMornings.SHARED, int(BAR_LOW), int(BAR_HIGH), n_seeds,
		int(BAR_HIGH), jitter, base_seed, _even(), n_weeks, CoachedMornings.owned("sessional"),
		CoachedMornings.owned("full_time"), n_bouts, BoutRules.FRESH_FATIGUE, n_weeks, n_bouts * 3, n_seeds, n_bouts * 3])
	for kind in KINDS:
		f.store_line("")
		f.store_line("### %s - %d coached mornings a week" % [kind.to_upper(), CoachedMornings.owned(kind)])
		f.store_line("")
		f.store_line("```")
		f.store_line(_head())
		for r in rows:
			if str(r["kind"]) == kind:
				f.store_line(_line(r))
		f.store_line("```")
		f.store_line("")
		f.store_line("Seeds tied on wins: %d of %d. Joint best (a tie counted for each): %s." % [int(tables[kind]["ties"]), n_seeds, _joint(tables[kind])])
		f.store_line("")
		f.store_line("**%s**" % _verdict(kind, tables[kind]["acc"]))
	f.store_line("")
	f.store_line("## Finding")
	f.store_line("")
	for kind in KINDS:
		f.store_line("- %s: %s" % [kind.to_upper(), _finding(rows, kind)])
	f.store_line("")
	f.store_line("## The trap")
	f.store_line("")
	f.store_line("The morning gain is clamped by headroom (potential - stat, /25, 0.10-1.25): a weak spot far under potential gains more per morning anyway. gain/morn is that read - compare it against the shared row on the week's own abilities.")
	f.store_line("")
	f.store_line("Reproduce: `python ops/Tools/godot_slot.py run --who morningsprobe1 -- <godot> --headless --audio-driver Dummy --fixed-fps 60 --path . --log-file E:/FightCamp/tmp/morningsprobe1.log --script res://tools/mornings_probe1.gd`")
	f.close()
