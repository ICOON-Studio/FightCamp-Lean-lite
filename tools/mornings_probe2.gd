extends SceneTree
## MORNINGSPROBE2 (S520, ops/research/TASK_MORNINGSPROBE2.md): on the BUILT club week (S519), is each boxer's WEEK PLAN a real
## choice? The coach deals the mornings himself (CoachedMornings.week_deal through MorningWire, read by Sim.week_ctx ->
## WeekPlan.day); the player's only lever is WHICH ability each morning trains. Same ability, same morning, two boxers = one
## SHARED slot; different = SOLO turns. MORNINGSPROBE1 found the multiplier is not the lever (S513: SHARED x1.35 moved points,
## not the record); this measures the plans on the real game. No rule or constant changed. TEST CLUB (Lucy wlw, Kira wfw, Josh
## mww; Ana on the mats, no mornings), Reid sessional AND full time, 40 seeds off 4421, 112 days (16 weeks) through Sim.step_day,
## sheet offers accepted and bouts fought as tools/ladder_probe.gd does (_career/_answer/_week copied, never edited; rival calls
## by ladder_probe_offers.gd). Policies set on day 0 and each Monday through the game's own setter (WeekPhase.edit, the Training
## screen's "wday" act, after WeekPhase.ensure as WeekData.plan_of reads it): ALIGNED (all on the club's most common default
## week), WEAKEST (each boxer's training mornings on her own lowest fight ability a morning can train), DEFAULT (untouched),
## CONTROL (DEFAULT, no deal - the game's own one-boxer rule, each boxer run alone; the doc names what that confounds).
## Bar (map 3.5): each best on 30-70% of seeds = a real choice; over 70% = dominant.
## Usage: python ops/Tools/godot_slot.py run --who morningsprobe2 -- <godot> --headless --audio-driver Dummy --fixed-fps 60
##          --log-file E:/FightCamp/tmp/morningsprobe2.log --path . --script res://tools/mornings_probe2.gd -- [seeds=40] [seed=4421] [days=112] [control=3]

const Sim := preload("res://scripts/state/Sim.gd")
const Bouts := preload("res://scripts/state/Bouts.gd")
const Roster := preload("res://scripts/state/Roster.gd")
const Injuries := preload("res://scripts/state/Injuries.gd")
const OppFile := preload("res://scripts/rules/OppFile.gd")
const FirstWeek := preload("res://scripts/rules/FirstWeek.gd")
const RivalPast := preload("res://scripts/rules/RivalPast.gd")
const TestClub := preload("res://scripts/state/TestClub.gd")
const LateAskWire := preload("res://scripts/state/LateAskWire.gd")
const PullOutWire := preload("res://scripts/state/PullOutWire.gd")
const ApproachWire := preload("res://scripts/state/ApproachWire.gd")
const FightWeekPlan := preload("res://scripts/state/FightWeekPlan.gd")
const RankLine := preload("res://scripts/rules/RankLine.gd")
const BoutRules := preload("res://scripts/rules/BoutRules.gd")
const WeekPlan := preload("res://scripts/rules/WeekPlan.gd")
const WeekPhase := preload("res://scripts/rules/WeekPhase.gd")
const MorningWire := preload("res://scripts/state/MorningWire.gd")
const CoachedMornings := preload("res://scripts/rules/CoachedMornings.gd")
const Offers := preload("res://tools/ladder_probe_offers.gd")

const POLICIES := ["ALIGNED", "WEAKEST", "DEFAULT"]
const KINDS := ["sessional", "full_time"]
const CASH_FLOOR := 20000
const DOC := "res://docs/MORNINGSPROBE2_RESULT.md"
const BAR_LOW := 30.0
const BAR_HIGH := 70.0
const SUMS := ["pts", "weak", "power", "bouts", "w", "l", "d", "rep"]

var n_seeds := 40
var base_seed := 4421
var n_days := 112
var n_control := 3
var runs: Array = []
var idx: Dictionary = {}
var lock_refused := 0

func _initialize() -> void:
	for a in OS.get_cmdline_user_args():
		var kv := str(a).split("=")
		if kv.size() == 2:
			match kv[0]:
				"seeds": n_seeds = int(kv[1])
				"seed": base_seed = int(kv[1])
				"days": n_days = int(kv[1])
				"control": n_control = int(kv[1])
	var t0 := Time.get_ticks_msec()
	print("MORNINGSPROBE2 %d seeds off %d (seeds %d..%d), %d days a run; TEST CLUB, Reid sessional + full time; %s + CONTROL (a boxer alone, %d of the three)" % [
		n_seeds, base_seed, base_seed, base_seed + n_seeds - 1, n_days, str(POLICIES), n_control])
	for kind in KINDS:
		for pol in POLICIES:
			for s in n_seeds:
				_run(str(kind), str(pol), -1, base_seed + s)
		for i in mini(n_control, 3):
			for s in n_seeds:
				_run(str(kind), "CONTROL", i, base_seed + s)
	var L := _lines(int((Time.get_ticks_msec() - t0) / 1000))
	for line in L: print(line)
	var fh := FileAccess.open(DOC, FileAccess.WRITE)
	if fh == null:
		print("WARNING: could not write %s" % DOC)
	else:
		fh.store_string("\n".join(L) + "\n"); fh.close(); print("wrote %s" % DOC)
	print("MORNINGSPROBE2 done")
	quit(0)

## The TEST CLUB as tools/ladder_probe.gd sets it up (copied, never edited): past the guide and the first hour, rivals' pasts
## re-seeded to the run seed. seed() first: quick_start draws randi() before c.seed is set, so the setup must replay too.
## keep >= 0 leaves only that boxer on the books - the game's own one-boxer rule (MorningWire.deal = {} below two boxers).
func _career(seed_n: int, keep: int) -> Career:
	seed(seed_n)
	var c := Career.quick_start()
	c.seed = seed_n; c.first_hour = {}; FirstWeek.skip(c)
	for r in c.rivals:
		var others: Array = c.rivals.filter(func(o): return str(o.get("div", "")) == str(r.get("div", ""))).map(func(o): return [o["name"], o["club"]])
		r["bouts"] = RivalPast.seed(r, others, c.seed, c.day)
	TestClub.make(c)
	if keep >= 0:
		for j in range(c.fighters.size() - 1, -1, -1):
			if j != keep:
				c.fighters.remove_at(j)
	return c

func _run(kind: String, pol: String, keep: int, seed_n: int) -> void:
	var c := _career(seed_n, keep)
	c.coach["full_time"] = kind == "full_time"
	var r := {"kind": kind, "policy": pol, "seed": seed_n, "keep": keep, "club": "TEST", "days": 0, "closed": false,
		"booked": 0, "fought": 0, "weeks": 0, "shared": 0, "solo": 0, "bm": 0, "boxers": {}, "start": {}, "last": {},
		"aim": {}, "sh_ab": {}, "so_ab": {}, "left": 0}
	for f in c.fighters:
		(r["start"] as Dictionary)[str(f["id"])] = {"stats": (f["stats"] as Dictionary).duplicate(true), "name": str(f["name"]),
			"div": str(f["div"]), "pot": int(f["pot"]), "weak0": _lowest(f["stats"], CoachedMornings.FIGHT_ABILITIES)}
	Offers.begin(c, r, seed_n)
	for _d in n_days:
		if c.closed:
			r["closed"] = true; break
		c.cash = maxi(c.cash, CASH_FLOOR)
		var monday := posmod(c.day, 7) == 0
		if monday: _apply(c, r, pol)
		Sim.step_day(c)
		r["days"] = c.day
		_deal(c, r, posmod(c.day - 1, 7))   # after the step: twist drawn, phase synced - the deal the sim ran that day
		_answer(c, r)
		Offers.observe(c, r)
	_finish(c, r)
	runs.append(r)
	idx["%s|%s|%d" % [kind, pol, seed_n]] = r
	print("  %s %s%s seed %d: day %d, %d weeks, %d shared + %d solo slots, %d bouts, %.1f pts, %.1f%% wins%s" % [kind, pol,
		" keep%d" % keep if keep >= 0 else "", seed_n, int(r["days"]), int(r["weeks"]), int(int(r["shared"]) / 2), int(r["solo"]),
		int(r["fought"]), _tot(r, "pts"), 100.0 * _tot(r, "w") / maxf(1.0, _tot(r, "bouts")), " CLOSED" if bool(r["closed"]) else ""])

## Monday before the day runs: the phase brought current as the Training screen reads it, then the policy through the game's
## own setter. DEFAULT and CONTROL are never edited.
func _apply(c: Career, r: Dictionary, pol: String) -> void:
	for f in c.fighters:
		WeekPhase.ensure(f, c.day)
		(r["last"] as Dictionary)[str(f["id"])] = (f["stats"] as Dictionary).duplicate(true)
	if pol == "ALIGNED":
		_align(c)
	elif pol == "WEAKEST":
		_weakest(c, r)

## ALIGNED: the most common default week in the club (WeekPlan.coach_of, exact cards, a tie takes the first boxer's), laid on
## every boxer - the same ability on the same morning is what lets the coach pair them.
func _align(c: Career) -> void:
	var weeks: Array = []
	var keys: Array = []
	for f in c.fighters:
		var w := WeekPlan.coach_of(f)
		weeks.append(w); keys.append(str(w))
	var best: Array = weeks[0]; var best_n := 0
	for i in weeks.size():
		if keys.count(keys[i]) > best_n:
			best_n = keys.count(keys[i]); best = weeks[i]
	for f in c.fighters:
		var coach := WeekPlan.coach_of(f)
		for dow in 7: WeekPhase.edit(f, dow, (best[dow] as Array).duplicate(), coach)

## WEAKEST: every training morning on the session that trains her own lowest fight ability (the game's own WeekPhase.FOCUS
## map), the coach's intensity and rest days kept. The aim is the lowest ability a MORNING can train: fight_iq has no morning
## session (WeekPlan.SESSIONS), so it is skipped - the aim table still counts it as the true hole when it is one.
func _weakest(c: Career, r: Dictionary) -> void:
	var can := _trainable()
	for f in c.fighters:
		_count(r["aim"], _lowest(f["stats"], CoachedMornings.FIGHT_ABILITIES))
		var sid := str(WeekPhase.FOCUS.get(_lowest(f["stats"], can), "heavy_bag"))
		var coach := WeekPlan.coach_of(f)
		for dow in 7:
			var card: Array = coach[dow]
			if str(card[0]) != "rest": WeekPhase.edit(f, dow, [sid, str(card[1])], coach)

## The fight abilities some morning session actually trains, read from WeekPlan.SESSIONS (nothing hardcoded).
func _trainable() -> Array:
	var out: Array = []
	for a in CoachedMornings.FIGHT_ABILITIES:
		for s in WeekPlan.SESSIONS.values():
			if str(s["stat"]) == str(a) and not out.has(a): out.append(a)
	return out

func _lowest(stats: Dictionary, among: Array) -> String:
	var low := INF
	var id := ""
	for a in among:
		var v := float(stats.get(a, 0.0))
		if v < low:
			low = v; id = str(a)
	return id

func _count(bag: Dictionary, key: String) -> void:
	bag[key] = int(bag.get(key, 0)) + 1

## The slots the coach dealt on the day that ran (MorningWire.deal, the same call Sim.week_ctx makes): a shared slot is ONE
## slot for two boxer-mornings (halved when pooled), a solo slot one boxer's. Mid-week re-deals counted too.
func _deal(c: Career, r: Dictionary, dow: int) -> void:
	if dow == 0: r["weeks"] = int(r["weeks"]) + 1
	var dd := MorningWire.deal(c)
	for fid in dd:
		var m: Dictionary = (dd[fid] as Dictionary).get(str(dow), {})
		if m.is_empty(): continue
		var use := str(m["use"])
		if use == "shared":
			r["shared"] = int(r["shared"]) + 1; _count(r["sh_ab"], str(m.get("ability", "")))
		elif use == "solo":
			r["solo"] = int(r["solo"]) + 1; _count(r["so_ab"], str(m.get("ability", "")))
		r["bm"] = int(r["bm"]) + 1

## Everything open, answered as the player would at the clock stop (tools/ladder_probe.gd's own pass, copied not edited).
func _answer(c: Career, r: Dictionary) -> void:
	for _pass in 6:
		var did := false
		c.review_pending = false
		if not c.pro_offer.is_empty():
			Roster.decline_pro(c); did = true
		for f in c.fighters:
			if bool(f.get("goal_talk", false)):
				Bouts.set_goal(c, f, "five_round_engine"); did = true
			if ApproachWire.is_open(f): ApproachWire.answer(c, str(f["id"]), "match"); did = true
			if LateAskWire.is_open(f): LateAskWire.answer(c, str(f["id"]), false); did = true
			if Offers.answer(c, f, r): did = true
			if PullOutWire.is_open(f):
				if PullOutWire.answer(c, str(f["id"]), "take_replacement") != "": PullOutWire.answer(c, str(f["id"]), "go_home")
				did = true
			if Injuries.pending(f): Injuries.pull_out(c, f); did = true
			for o in (f["offers"] as Array).duplicate():
				if bool(o["answered"]) or bool(o["mismatch"]): continue
				if not (f["bout"] as Dictionary).is_empty():
					Bouts.decline(c, str(o["id"])); did = true
				elif Bouts.accept(c, str(o["id"])):
					r["booked"] = int(r["booked"]) + 1; did = true
			if FightWeekPlan.is_open(f): _week(c, f); did = true
			if Bouts.camp_due(c, f):
				Bouts.start_camp(c, f, Sim.focus_of(c, f), 2, OppFile.has_tape((f["bout"] as Dictionary)["opp"]), false); did = true
			if Bouts.weigh_in_today(c, f): Bouts.weigh(c, f); did = true
		while true:
			var g := Bouts.fighting_today(c)
			if g.is_empty(): break
			Bouts.fight_step(c, g, Bouts.fight_modal(g), "sim"); Bouts.after_fight(c, g)
			r["fought"] = int(r["fought"]) + 1; did = true
		if not did: break

## The fight week as the assistant drafts it, every night on the best-ranked free partner (ladder_probe's own week).
func _week(c: Career, f: Dictionary) -> void:
	var plan := FightWeekPlan.draft(c, f)
	var keys: Array = (plan["nights"] as Dictionary).keys()
	keys.sort(); keys.reverse()
	var used: Array = []
	for k in keys:
		for p in FightWeekPlan.partners(c, f):
			if not used.has(str(p["id"])):
				(plan["nights"] as Dictionary)[k] = str(p["id"]); used.append(str(p["id"])); break
	plan["ask_kilo"] = false
	if FightWeekPlan.lock(c, f, plan) != "":
		lock_refused += 1

## Per boxer at the run's end: points gained (every stat key), points on the ability weakest at day 0, fight power gained, the
## sim's amateur bouts (the career's results), ladder points at the last day. A boxer who left keeps her last Monday's stats.
func _finish(c: Career, r: Dictionary) -> void:
	for fid in (r["start"] as Dictionary).keys():
		var s: Dictionary = (r["start"] as Dictionary)[fid]
		var f := c.fighter_by_id(str(fid))
		var was: Dictionary = s["stats"]
		var now: Dictionary = (f["stats"] as Dictionary) if not f.is_empty() else ((r["last"] as Dictionary).get(str(fid), was) as Dictionary)
		var pts := 0.0
		for k in now: pts += float(now[k]) - float(was.get(k, 0.0))
		var ab := str(s["weak0"])
		var mine: Array = c.results.filter(func(x): return str(x["fid"]) == str(fid) and not bool(x.get("pro", false)))
		var w := mine.filter(func(x): return bool(x["win"])).size(); var d := mine.filter(func(x): return str(x["outcome"]) == "draw").size()
		(r["boxers"] as Dictionary)[str(fid)] = {"name": str(s["name"]), "div": str(s["div"]), "pot": int(s["pot"]),
			"weak0": ab, "left": f.is_empty(), "pts": pts, "weak": float(now.get(ab, 0.0)) - float(was.get(ab, 0.0)),
			"power": BoutRules.fight_power(now, {}, 0, "") - BoutRules.fight_power(was, {}, 0, ""),
			"bouts": mine.size(), "w": w, "l": mine.size() - w - d, "d": d, "rep": RankLine.rep(f) if not f.is_empty() else 0,
			"nights": str(mine.map(func(x): return int(x["d"])))}
		r["left"] = int(r["left"]) + int(f.is_empty())

func _tot(r: Dictionary, key: String) -> float:
	return (r["boxers"] as Dictionary).values().reduce(func(acc, b): return float(acc) + float(b[key]), 0.0)

func _grp(kind: String, pol: String) -> Array:
	return runs.filter(func(r): return str(r["kind"]) == kind and str(r["policy"]) == pol)

func _mean(rs: Array, key: String) -> float:
	var t := 0.0
	for r in rs: t += _tot(r, key)
	return t / maxf(1.0, float(rs.size()))

func _per_week(rs: Array, key: String) -> float:
	var t := 0.0
	var w := 0
	for r in rs: t += float(r[key]); w += int(r["weeks"])
	return t / maxf(1.0, float(w))

func _bag(rs: Array, fid: String) -> Array:
	var out: Array = []
	for r in rs:
		var b: Dictionary = (r["boxers"] as Dictionary).get(fid, {})
		if not b.is_empty(): out.append(b)
	return out

func _mean_box(bag: Array) -> Dictionary:
	var out := {}
	for b in bag:
		for k in SUMS: out[k] = float(out.get(k, 0.0)) + float(b[k])
		out["name"] = str(b["name"])
	for k2 in out.keys():
		if str(k2) != "name": out[k2] = float(out[k2]) / float(maxi(1, bag.size()))
	return out

func _wr(b: Dictionary) -> float:
	return float(b.get("w", 0)) / maxf(1.0, float(b.get("bouts", 0)))

func _pct(n: float, d: float) -> String:
	return "%.1f%%" % (100.0 * n / d) if d > 0.0 else "-"

## Best by win rate on each seed (the club's wins / its bouts), ties split - the map 3.5 bar. CONTROL is not in the race.
func _best(kind: String) -> Dictionary:
	var out := {"ties": 0}
	for p in POLICIES: out[p] = {"best": 0.0, "joint": 0, "outright": 0}
	for s in n_seeds:
		var rates := {}
		for p2 in POLICIES:
			var r: Dictionary = idx.get("%s|%s|%d" % [kind, str(p2), base_seed + s], {})
			rates[p2] = _wr({"w": _tot(r, "w"), "bouts": _tot(r, "bouts")})
		var top := -1.0
		var tied: Array = []
		for p3 in POLICIES:
			if float(rates[p3]) > top:
				top = float(rates[p3]); tied = [p3]
			elif float(rates[p3]) == top: tied.append(p3)
		if tied.size() > 1: out["ties"] = int(out["ties"]) + 1
		for p4 in tied:
			out[p4]["best"] = float(out[p4]["best"]) + 1.0 / float(tied.size())
			out[p4]["joint"] = int(out[p4]["joint"]) + 1
			if tied.size() == 1: out[p4]["outright"] = int(out[p4]["outright"]) + 1
	return out

func _row_main(kind: String, pol: String, b: Dictionary) -> String:
	var rs := _grp(kind, pol)
	return "| %s | %s | %.2f | %.2f | %.2f | %.1f | %.1f | %.1f | %.2f | %.2f-%.2f-%.2f | %s | %.1f | %s |" % [kind, pol,
		_per_week(rs, "shared") / 2.0, _per_week(rs, "solo"), _per_week(rs, "bm"), _mean(rs, "pts"), _mean(rs, "weak"),
		_mean(rs, "power"), _mean(rs, "bouts"), _mean(rs, "w"), _mean(rs, "l"), _mean(rs, "d"),
		_pct(_mean(rs, "w"), _mean(rs, "bouts")), _mean(rs, "rep"),
		_pct(float((b[pol] as Dictionary)["best"]), float(maxi(1, rs.size())))]

func _row_boxer(kind: String, pol: String, fid: String) -> String:
	var bag := _bag(_grp(kind, pol), fid)
	if bag.is_empty(): return ""
	var m := _mean_box(bag)
	var s: Dictionary = bag[0]
	return "| %s | %s | %s | %s | %d | %s | %.1f | %.1f | %.1f | %.2f-%.2f-%.2f | %s | %.1f |" % [kind, pol, str(s["name"]),
		str(s["div"]), int(s["pot"]), str(s["weak0"]), float(m["pts"]), float(m["weak"]), float(m["power"]), float(m["w"]),
		float(m["l"]), float(m["d"]), _pct(float(m["w"]), float(m["bouts"])), float(m["rep"])]

## CONTROL vs DEFAULT on the SAME boxer and seed: the one-boxer club is the game's own no-coached-mornings state.
func _ctrl_bags(kind: String, i: int) -> Array:
	var dflt := _grp(kind, "DEFAULT")
	if dflt.is_empty() or i >= (dflt[0]["start"] as Dictionary).size(): return []
	var fid := str((dflt[0]["start"] as Dictionary).keys()[i])
	return [_mean_box(_bag(dflt, fid)), _mean_box(_bag(_grp(kind, "CONTROL").filter(func(r): return int(r["keep"]) == i), fid)), fid]

func _row_ctrl(kind: String, i: int) -> String:
	var pair := _ctrl_bags(kind, i)
	if pair.is_empty() or (pair[0] as Dictionary).is_empty() or (pair[1] as Dictionary).is_empty(): return ""
	var da: Dictionary = pair[0]; var db: Dictionary = pair[1]
	var lower := 0; var same := 0
	for r in _grp(kind, "CONTROL").filter(func(r): return int(r["keep"]) == i):
		var r2: Dictionary = idx.get("%s|DEFAULT|%d" % [kind, int(r["seed"])], {})
		var x: Dictionary = (r["boxers"] as Dictionary).get(str(pair[2]), {})
		var y: Dictionary = (r2["boxers"] as Dictionary).get(str(pair[2]), {})
		if _wr(x) < _wr(y): lower += 1
		if str(x.get("nights", "")) == str(y.get("nights", "")): same += 1
	return "| %s | %s | %.1f | %.1f | %+.1f | %.1f | %.1f | %+.1f | %s | %s | %.1f | %.1f | %+.1f | %d/%d | %d/%d |" % [kind,
		str(da["name"]), float(da["pts"]), float(db["pts"]), float(db["pts"]) - float(da["pts"]), float(da["weak"]),
		float(db["weak"]), float(db["weak"]) - float(da["weak"]), _pct(float(da["w"]), float(da["bouts"])),
		_pct(float(db["w"]), float(db["bouts"])), float(da["rep"]), float(db["rep"]), float(db["rep"]) - float(da["rep"]),
		lower, n_seeds, same, n_seeds]

func _row_ab(kind: String, pol: String, use: String) -> String:
	var bag := {}
	var weeks := 0
	for r in _grp(kind, pol):
		weeks += int(r["weeks"])
		var src: Dictionary = (r["sh_ab"] if use == "shared" else r["so_ab"]) as Dictionary
		for k in src: bag[k] = int(bag.get(k, 0)) + int(src[k])
	var cells: Array = []
	var tot := 0
	for a in CoachedMornings.FIGHT_ABILITIES:
		tot += int(bag.get(a, 0)); cells.append("%.2f" % (float(bag.get(a, 0)) / maxf(1.0, float(weeks))))
	return "| %s | %s | %s | %s | %.2f |" % [kind, pol, use, " | ".join(cells), float(tot) / maxf(1.0, float(weeks))]

func _verdicts() -> Array:
	var out: Array = []
	for kind in KINDS:
		var b := _best(str(kind))
		var parts: Array = []
		var slots: Array = []
		var outside: Array = []
		var dom := ""
		for p in POLICIES:
			var sh := 100.0 * float((b[str(p)] as Dictionary)["best"]) / float(maxi(1, n_seeds))
			parts.append("%s %.1f%% (%d outright, %d joint)" % [str(p), sh, int((b[str(p)] as Dictionary)["outright"]), int((b[str(p)] as Dictionary)["joint"])])
			var rs := _grp(str(kind), str(p))
			slots.append("%s %.2f shared + %.2f solo" % [str(p), _per_week(rs, "shared") / 2.0, _per_week(rs, "solo")])
			if sh < BAR_LOW or sh > BAR_HIGH: outside.append(str(p))
			if sh > BAR_HIGH: dom = str(p)
		var verdict := "A REAL CHOICE" if outside.is_empty() else ("DOMINANT: %s" % dom if dom != "" else "NOT A REAL CHOICE (%s outside %.0f-%.0f%%)" % [", ".join(outside), BAR_LOW, BAR_HIGH])
		if int(b["ties"]) * 2 >= n_seeds: verdict += " - BUT %d of %d seeds TIED on the record: most seeds had no win to move, so the band is met by ties, not by a choice (only %d seeds had an outright winner)" % [int(b["ties"]), n_seeds, n_seeds - int(b["ties"])]
		out.append("**%s: %s** - best by win rate on %d seeds, ties split (%d seeds tied): %s. Slots a week: %s. The built deal caps a boxer at ONE shared morning a week (week_deal's shared_n), so with three boxers at most ONE pair can share: ALIGNED cannot buy \"many shared mornings\", and in a base week the club's default weeks are already identical (WEEKS.base carries no camp focus), so ALIGNED and DEFAULT differ only where a fight week writes a different week. What would move it: NOT a multiplier - MORNINGSPROBE1's S513 control raised SHARED to x1.35 and the record did not move. The lever is WHICH ability the shared slot trains: the ability table above shows what each policy's pairs actually drill, and CoachedMornings.shared_focus only picks the pair's lowest-ranked ability among the mornings they BOTH already train - a plan that never matches cannot be paired at any multiplier." % [
			str(kind), verdict, n_seeds, int(b["ties"]), "; ".join(parts), "; ".join(slots)])
	for kind in KINDS:
		var rows: Array = []
		for i in mini(n_control, 3):
			var pair := _ctrl_bags(str(kind), i)
			if pair.is_empty() or (pair[0] as Dictionary).is_empty() or (pair[1] as Dictionary).is_empty(): continue
			var da: Dictionary = pair[0]
			var db: Dictionary = pair[1]
			rows.append("%s: %+.1f pts, %+.1f on the hole, win %s -> %s, ladder %+.1f" % [str(da["name"]),
				float(db["pts"]) - float(da["pts"]), float(db["weak"]) - float(da["weak"]),
				_pct(float(da["w"]), float(da["bouts"])), _pct(float(db["w"]), float(db["bouts"])), float(db["rep"]) - float(da["rep"])])
		out.append("**What coached mornings are worth at all (%s, CONTROL - DEFAULT, same boxer and seed):** %s. **Read only the paired row** - the boxer whose nights, record and ladder read identical in both arms (the first division in Data.DIVISIONS keeps its opponents when the club is reduced to one): hers is the only difference that can be laid at the coaching's door. The other rows are NOT the value of coaching: Region.day_events draws every division's rival bouts off one shared RNG (rng.seed = c.day * 97 + 11, the busy list built from our booked boxers), so dropping two boxers re-deals the later divisions' opponents, and their win rates swing far beyond anything a morning multiplier does. A clean whole-club control of three boxers needs a game edit (a no-deal flag in MorningWire); this probe does not make one." % [str(kind), "; ".join(rows) if not rows.is_empty() else "not run (control=0)"])
	for kind in KINDS:
		var m := {}
		for p in POLICIES:
			var rs := _grp(str(kind), str(p))
			m[str(p)] = {"pts": _mean(rs, "pts"), "weak": _mean(rs, "weak"), "win": _pct(_mean(rs, "w"), _mean(rs, "bouts")),
				"rate": _mean(rs, "w") / maxf(1.0, _mean(rs, "bouts"))}
		var w: Dictionary = m["WEAKEST"]
		var d: Dictionary = m["DEFAULT"]
		var a: Dictionary = m["ALIGNED"]
		out.append("**The headroom trap (%s):** WEAKEST gains %.1f pts against DEFAULT's %.1f and ALIGNED's %.1f, and %.1f on the starting holes against DEFAULT's %.1f - the clamp (potential - stat) pays the hole more per morning, so WEAKEST gains more points anyway. Beside it the record: WEAKEST %s, DEFAULT %s, ALIGNED %s. %s" % [
			str(kind), float(w["pts"]), float(d["pts"]), float(a["pts"]), float(w["weak"]), float(d["weak"]),
			str(w["win"]), str(d["win"]), str(a["win"]),
			"Points moved and the record did not follow - MORNINGSPROBE1's lesson repeats on the built code." if float(w["pts"]) > float(d["pts"]) + 1.0 and absf(float(w["rate"]) - float(d["rate"])) < 0.02 else "Read the win rate beside the points: the gap in points is not the gap in wins."])
	return out

func _lines(secs: int) -> Array:
	var L: Array = []
	var best := {}
	for kind in KINDS: best[kind] = _best(str(kind))
	L.append("# MORNINGSPROBE2 - coached mornings on the BUILT club week: does the week plan make a real choice?")
	L.append("")
	L.append("Probe run: %s. %d seeds off %d (seeds %d..%d), %d days (16 weeks) a run, %d runs, %ds. A measurement only: no rule or constant was changed." % [
		Time.get_datetime_string_from_system(), n_seeds, base_seed, base_seed, base_seed + n_seeds - 1, n_days, runs.size(), secs])
	L.append("## Population")
	L.append("The **TEST CLUB** (scripts/state/TestClub.gd): three boxers in three weight classes - **Lucy** (women's lightweight), **Kira** (women's featherweight), **Josh** (men's welterweight) - and **Ana** the no-gi grappler on the mats, who takes no mornings (MorningWire deals over c.fighters only). Coach **Reid** hired, run **sessional** (You 4 + coach 2 = 6 slots) and **full time** (4 + 3 = 7). Past the first-week guide and the first hour, on the classic calendar; cash floored at $%d so money never binds. No two fighters in a measurement are identical: three distinct boxers against the game's own named rivals. The club is the SAME on every seed and in every arm - the paired comparison the brief's trap asks for. What the seed varies is the world around it: the rivals' invented pasts (RivalPast.seed), the bout dice (LiveRound / Injuries read c.seed), the week's twist card, the sheet and the rival gyms' calls. Starting abilities and potential as the game writes them:" % CASH_FLOOR)
	var club: Array = []
	var first := _grp("sessional", "DEFAULT")
	if not first.is_empty():
		for fid in (first[0]["start"] as Dictionary).keys():
			var s: Dictionary = (first[0]["start"] as Dictionary)[fid]
			var cells: Array = []
			for a in CoachedMornings.FIGHT_ABILITIES:
				cells.append("%.1f" % float((s["stats"] as Dictionary).get(a, 0.0)))
			club.append("| %s | %s | %d | %s | %s |" % [str(s["name"]), str(s["div"]), int(s["pot"]), " | ".join(cells), str(s["weak0"])])
	Offers._table(L, "| boxer | division | potential | power | speed | technique | defense | conditioning | fight_iq | weakest at day 0 |", club)
	L.append("## Method\n- 112 days through **Sim.step_day**, every sheet offer accepted and every bout fought by the sim, the fight week drafted and locked, the camp started, the weigh-in taken, pro offers declined, the rival gyms' calls answered by the run seed's policy - tools/ladder_probe.gd's own loop (_career / _answer / _week copied, that file never edited; tools/ladder_probe_offers.gd preloaded). The four policies are set on day 0 and again each Monday through the game's own plan setter **WeekPhase.edit** (the Training screen's `wday` act, scripts/ui/BoutActs.gd), after **WeekPhase.ensure** as WeekData.plan_of reads the week; a phase change drops the exceptions as the game does and the next Monday lays the policy again.")
	L.append("- **ALIGNED**: every boxer on the club's most common default week (WeekPlan.coach_of, exact cards, a tie takes the first boxer's) - the same ability on the same morning, so the coach can pair them. **WEAKEST**: each boxer's training mornings on the session that trains her own lowest fight ability (WeekPhase.FOCUS, the game's own camp map), the coach's intensity and rest days kept. **DEFAULT**: the plans the club starts with, untouched. **CONTROL**: DEFAULT plans, no coached mornings. **fight_iq has no morning session** (WeekPlan.SESSIONS trains only power, speed, technique, defense, conditioning and chin): WEAKEST aims at the lowest ability a morning CAN train, and the aim table still counts fight_iq as the true hole whenever it is one - the game's own FOCUS map would send that hole to shadow, which trains technique instead.")
	L.append("- **CONTROL needs no game edit, but it cannot hold the other two boxers.** CoachedMornings.owned() is at least YOU_OWNED (4) for every coach kind - no \"none\" the career can reach - and MorningWire.deal returns {} only below two boxers. So CONTROL runs each boxer ALONE on the books (the game's own one-boxer rule, v11 section 2, asserted by morning_deal_test), same seed, same DEFAULT plan, deal empty (0 shared + 0 solo slots in every CONTROL run). Confounds named: alone she never shares a fight-week film night (FilmSeats.owned), so her tape read can be fuller than in the three-boxer club, and a different bout result knocks on into rest, injury and morale. **The big one: the region's show-day rival bouts are drawn with ONE shared RNG walked division by division (Region.day_events, rng.seed = c.day * 97 + 11, the busy list built from our booked boxers), so with two boxers absent the draw sequence shifts for every later division and those boxers face different opponents' records and ratings.** Only the first division in Data.DIVISIONS keeps its paired world; the table below shows which boxer that is (identical nights, record and ladder in both arms). The **same nights** column counts the seeds where her bout nights matched DEFAULT's exactly; it does NOT promise the same opponents. A whole-club CONTROL of three boxers with no deal would need a game file change; that arm is not run.")
	L.append("- Slots are counted from **MorningWire.deal** after each day's step (the twist drawn, the phase synced): the entry for the day that ran, so a mid-week re-deal is counted too. A SHARED slot is ONE slot for two boxer-mornings; the tables halve the shared boxer-mornings. pts = every stat key gained over the 112 days (as MORNINGSPROBE1 summed them); weak = points on the ability weakest at day 0; power = BoutRules.fight_power gained; win%% = the sim's amateur bouts (the career's results), draws counted as bouts not wins; rep = RankLine.rep at day %d, the club's sum in the main table and per boxer elsewhere." % n_days)
	L.append("## The choice: slots, points, record and ladder, per policy and coach kind\nPer-seed means over %d seeds. slots/wk = shared slots (one for a pair) and solo slots dealt a week; morns/wk = coached boxer-mornings; best = the share of seeds this policy had the best win rate, ties split." % n_seeds)
	var main_rows: Array = []
	for kind in KINDS:
		for pol in POLICIES:
			main_rows.append(_row_main(str(kind), str(pol), best[kind]))
	Offers._table(L, "| coach | policy | shared slots/wk | solo slots/wk | morns/wk | pts | weak | power | bouts | W-L-D | win%% | rep (club) | best of %d |" % n_seeds, main_rows)
	L.append("## Per boxer (the same club in every arm)")
	var box_rows: Array = []
	for kind in KINDS:
		for pol in POLICIES:
			var rs := _grp(str(kind), str(pol))
			if not rs.is_empty():
				for fid in (rs[0]["start"] as Dictionary).keys():
					box_rows.append(_row_boxer(str(kind), str(pol), str(fid)))
	Offers._table(L, "| coach | policy | boxer | division | pot | weakest at 0 | pts | weak | power | W-L-D | win% | rep |", box_rows)
	L.append("## CONTROL vs DEFAULT - what coached mornings are worth at all\nEach boxer alone on the books (the game's own no-deal state), DEFAULT plan, same seed. d = CONTROL - DEFAULT; lower = seeds where her CONTROL win rate was below her DEFAULT win rate; same nights = seeds where her bout nights matched DEFAULT's exactly (the clean pairs).")
	var ctrl_rows: Array = []
	for kind in KINDS:
		for i in mini(n_control, 3):
			ctrl_rows.append(_row_ctrl(str(kind), i))
	Offers._table(L, "| coach | boxer | DEFAULT pts | CONTROL pts | d pts | DEFAULT weak | CONTROL weak | d weak | DEFAULT win% | CONTROL win% | DEFAULT rep | CONTROL rep | d rep | lower | same nights |", ctrl_rows)
	L.append("## Which ability the deal trains (slots a week, by ability)\nThe lever MORNINGSPROBE1's S513 reading named: not the multiplier but WHICH ability a slot trains. shared = the pair's slot (counted once for the pair), solo = a 1-to-1 turn. The aim table below it counts the TRUE lowest ability on each WEAKEST Monday (fight_iq included, though no morning can train it).")
	var ab_rows: Array = []
	for kind in KINDS:
		for pol in POLICIES:
			ab_rows.append(_row_ab(str(kind), str(pol), "shared"))
			ab_rows.append(_row_ab(str(kind), str(pol), "solo"))
	Offers._table(L, "| coach | policy | use | power | speed | technique | defense | conditioning | fight_iq | total/wk |", ab_rows)
	var aim_rows: Array = []
	for kind in KINDS:
		var bag := {}
		var tot := 0
		for r in _grp(str(kind), "WEAKEST"):
			for k in (r["aim"] as Dictionary):
				bag[k] = int(bag.get(k, 0)) + int((r["aim"] as Dictionary)[k]); tot += int((r["aim"] as Dictionary)[k])
		for a in CoachedMornings.FIGHT_ABILITIES:
			aim_rows.append("| %s | %s | %d | %s |" % [str(kind), str(a), int(bag.get(a, 0)), _pct(float(bag.get(a, 0)), float(tot))])
	Offers._table(L, "| coach | WEAKEST aimed at | boxer-Mondays | share |", aim_rows)
	L.append("## Reading")
	for v in _verdicts():
		L.append(v); L.append("")
	L.append("Fight-week locks refused: %d. Boxers who left mid-run: %d. Runs that closed early: %d." % [lock_refused,
		int(runs.reduce(func(acc, r): return int(acc) + int(r["left"]), 0)), runs.filter(func(r): return bool(r["closed"])).size()])
	L.append("Reproduce: `python ops/Tools/godot_slot.py run --who morningsprobe2 -- \"$LOCALAPPDATA/Programs/Godot/Godot_v4.7.2-stable_win64.exe\" --headless --audio-driver Dummy --fixed-fps 60 --log-file E:/FightCamp/tmp/morningsprobe2.log --path . --script res://tools/mornings_probe2.gd -- seeds=%d seed=%d days=%d control=%d`" % [n_seeds, base_seed, n_days, n_control])
	return L
