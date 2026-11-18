extends SceneTree
## LADDERPROBE1 (S516, ops/research/TASK_LADDERPROBE1.md): does the season ladder's table stay sane over two years of real
## play? A measurement only - no rule or constant is changed. 30 seeds x 2 clubs (a quick-start club with Lucy, and the
## TEST CLUB scripts/state/TestClub.gd), each stepped 728 days through Sim.step_day: every sheet offer accepted, every
## other open need answered in code as TestJump._tidy / _to_nationals answer them at the state level (no UI). Every 28
## days, for every division that has rivals, Region.rankings(c, div) is read and each row's points recorded.
## The brief's trap: a row with no "rep" yet reads at its seed (RankLine.rep), so a rival who never boxes keeps a seed
## that never moves - "stuck" is counted ONLY for rows with at least one bout in the last 84 days (RivalPast, newest
## first; our boxers from Career.results), and never-boxing rivals are reported separately.
## Usage: python ops/Tools/godot_slot.py run --who ladderprobe1 -- <godot> --headless --audio-driver Dummy --fixed-fps 60
##          --path . --log-file E:/FightCamp/tmp/ladderprobe1.log --script res://tools/ladder_probe.gd -- [seeds=30] [seed=4421] [days=728]

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
const Region := preload("res://scripts/state/Region.gd")
const RankLine := preload("res://scripts/rules/RankLine.gd")
const Data := preload("res://scripts/state/Data.gd")
const AmateurBooking := preload("res://scripts/rules/AmateurBooking.gd")

const CLUBS := ["QUICK", "TEST"]
const CASH_FLOOR := 20000
const PICKS := ["Jab and move", "Pad rounds", "Hill sprints"]
const DOC := "res://docs/LADDERPROBE1_RESULT.md"
const EVERY := 28
const WINDOW := 84
const TOP := 3
const KEYS := ["rows", "active", "stuck", "cap", "idle"]

var n_seeds := 30
var base_seed := 4421
var n_days := 728
var marks: Array = []
var runs: Array = []
var lock_refused := 0

func _initialize() -> void:
	for a in OS.get_cmdline_user_args():
		var kv := str(a).split("=")
		if kv.size() == 2:
			match kv[0]:
				"seeds": n_seeds = int(kv[1])
				"seed": base_seed = int(kv[1])
				"days": n_days = int(kv[1])
	var n_snap := int(n_days / EVERY) + 1
	marks = [0, EVERY * int(n_snap / 2), EVERY * (n_snap - 1)]
	var t0 := Time.get_ticks_msec()
	print("LADDERPROBE1 %d seeds x 2 clubs, %d days a run, seeds %d..%d; the table read every %d days (days %s)" % [
		n_seeds, n_days, base_seed, base_seed + n_seeds - 1, EVERY, str(marks)])
	for club in CLUBS:
		for s in n_seeds:
			_run(str(club), base_seed + s)
	var L := _lines(int((Time.get_ticks_msec() - t0) / 1000))
	for line in L:
		print(line)
	var fh := FileAccess.open(DOC, FileAccess.WRITE)
	if fh == null:
		print("WARNING: could not write %s" % DOC)
	else:
		fh.store_string("\n".join(L) + "\n")
		fh.close()
		print("wrote %s" % DOC)
	print("LADDERPROBE1 done")
	quit(0)

## One club: quick-start with Lucy signed and Reid hired, or the TEST CLUB (Lucy, Kira, Josh + Ana, Reid). Past the
## first-week guide and the first hour (TestJump's classic calendar). Rivals' invented pasts re-seeded to the run seed:
## quick_start draws randi() before the probe sets its seed, and a replay must agree.
func _career(club: String, seed_n: int) -> Career:
	var c := Career.quick_start()
	c.seed = seed_n
	c.first_hour = {}
	FirstWeek.skip(c)
	for r in c.rivals:
		var others: Array = c.rivals.filter(func(o): return str(o.get("div", "")) == str(r.get("div", ""))).map(func(o): return [o["name"], o["club"]])
		r["bouts"] = RivalPast.seed(r, others, c.seed, c.day)
	if club == "TEST":
		TestClub.make(c)
	else:
		Sim.sign(c, PICKS.duplicate())
		Sim.hire(c, "reid")
	return c

func _run(club: String, seed_n: int) -> void:
	var c := _career(club, seed_n)
	var divs: Array = []
	for dv in Data.DIVISIONS.keys():
		if not c.rivals.filter(func(rv): return str(rv["div"]) == str(dv)).is_empty():
			divs.append(str(dv))
	var r := {"club": club, "seed": seed_n, "days": 0, "closed": false, "divs": divs, "snap": {}, "top3": {},
		"stuck": {}, "ours": {}, "never": {}, "booked": 0, "fought": 0}
	for dv2 in divs:
		(r["snap"] as Dictionary)[dv2] = []
		(r["top3"] as Dictionary)[dv2] = {}
		(r["stuck"] as Dictionary)[dv2] = {}
		(r["never"] as Dictionary)[dv2] = 0
	_sample(c, r)
	for _d in n_days:
		if c.closed:
			r["closed"] = true
			break
		c.cash = maxi(c.cash, CASH_FLOOR)
		Sim.step_day(c)
		r["days"] = c.day
		_answer(c, r)
		if c.day % EVERY == 0:
			_sample(c, r)
	_finish(c, r)
	runs.append(r)
	print("  %s seed %d: day %d, %d divisions, %d offers taken, %d bouts fought%s" % [club, seed_n, int(r["days"]),
		divs.size(), int(r["booked"]), int(r["fought"]), " CLOSED" if bool(r["closed"]) else ""])

## The table as the game sorts it (Region.rankings: ladder points first, RankLine._before). A snapshot is the ordered
## [name, rep, fid] rows; fid "" is a rival, else one of ours. Top-3 names are kept for the turnover read.
func _sample(c: Career, r: Dictionary) -> void:
	var i := int(c.day / EVERY)
	for dv in (r["divs"] as Array):
		var rows := Region.rankings(c, str(dv))
		var snap: Array = []
		for row in rows:
			snap.append([str(row["name"]), int(row["rep"]), str(row["fid"])])
			if snap.size() <= TOP:
				(r["top3"][dv] as Dictionary)[str(row["name"])] = true
		(r["snap"][dv] as Array).append(snap)
		if i >= int(WINDOW / EVERY):
			_stuck(c, r, str(dv), i)
	for f in c.fighters:
		var o: Dictionary = (r["ours"] as Dictionary).get(str(f["id"]), {})
		if o.is_empty():
			o = {"name": str(f["name"]), "div": str(f["div"]), "rep": {}, "seen": 0, "w": 0, "l": 0, "bouts": 0, "rank": 0, "left": false}
			(r["ours"] as Dictionary)[str(f["id"])] = o
		o["seen"] = c.day
		if marks.has(c.day):
			(o["rep"] as Dictionary)[c.day] = RankLine.rep(f)

## Stuck = a row that boxed in the last 84 days and whose points are exactly where they were 84 days ago. A row with no
## bout in the window is idle, not stuck (the brief's trap: a never-boxing rival keeps her seed). Cap-stuck = stuck at 0
## or 100. Counted at every sample from day 84 on, and pooled ("all").
func _stuck(c: Career, r: Dictionary, dv: String, i: int) -> void:
	var now: Array = (r["snap"][dv] as Array)[i]
	var old: Array = (r["snap"][dv] as Array)[i - int(WINDOW / EVERY)]
	var was: Dictionary = {}
	for row in old:
		was[str(row[0])] = int(row[1])
	var day := i * EVERY
	var t := {"rows": now.size(), "active": 0, "stuck": 0, "cap": 0, "idle": 0}
	for row2 in now:
		var nm := str(row2[0])
		var rep := int(row2[1])
		if _bouts_between(c, nm, str(row2[2]), day - WINDOW, day) <= 0:
			t["idle"] = int(t["idle"]) + 1
			continue
		t["active"] = int(t["active"]) + 1
		if was.has(nm) and int(was[nm]) == rep:
			t["stuck"] = int(t["stuck"]) + 1
			if rep == 0 or rep == 100:
				t["cap"] = int(t["cap"]) + 1
	for key in [str(day), "all"]:
		var bag: Dictionary = (r["stuck"][dv] as Dictionary)
		var acc: Dictionary = bag.get(key, {"rows": 0, "active": 0, "stuck": 0, "cap": 0, "idle": 0})
		for k in KEYS:
			acc[k] = int(acc[k]) + int(t[k])
		bag[key] = acc

## Her bouts in (from_day, to_day]: a rival's own file (RivalPast, newest first, the invented past all before day 0), or
## one of ours from the career's results (amateur only - a pro bout does not move the amateur ladder).
func _bouts_between(c: Career, nm: String, fid: String, from_day: int, to_day: int) -> int:
	if fid == "":
		return (c.rival(nm).get("bouts", []) as Array).filter(func(b): return int(b["d"]) > from_day and int(b["d"]) <= to_day).size()
	return c.results.filter(func(x): return str(x["fid"]) == fid and not bool(x.get("pro", false)) \
		and int(x["d"]) > from_day and int(x["d"]) <= to_day).size()

func _finish(c: Career, r: Dictionary) -> void:
	for rival in c.rivals:
		var dv := str(rival["div"])
		if (r["never"] as Dictionary).has(dv) and (rival.get("bouts", []) as Array).filter(func(b): return int(b["d"]) > 0).is_empty():
			r["never"][dv] = int(r["never"][dv]) + 1
	for o in (r["ours"] as Dictionary).values():
		o["left"] = int(o["seen"]) < int(r["days"])
	for f in c.fighters:
		var mine: Dictionary = (r["ours"] as Dictionary).get(str(f["id"]), {})
		if mine.is_empty():
			continue
		mine["w"] = int(f["w"])
		mine["l"] = int(f["l"])
		mine["bouts"] = _bouts_between(c, str(f["name"]), str(f["id"]), 0, n_days)
		mine["rank"] = Region.our_rank(c, f)
		var names: Array = Data.DIVISIONS[str(f["div"])]["opponents"]
		var open_n := names.filter(func(n): return AmateurBooking.bouts_of(int(c.rival(str(n)).get("w", 0)), int(c.rival(str(n)).get("l", 0))) > AmateurBooking.NOVICE_MAX_BOUTS).size()
		mine["blocked"] = int(AmateurBooking.bouts_of(int(f["w"]), int(f["l"])) <= AmateurBooking.NOVICE_MAX_BOUTS and open_n == names.size())

## Everything open, answered as the player would at the clock stop; a pass can open new needs (an accepted offer opens
## the fight week or the camp), so passes repeat until quiet.
func _answer(c: Career, r: Dictionary) -> void:
	for _pass in 6:
		var did := false
		c.review_pending = false
		if not c.pro_offer.is_empty():
			Roster.decline_pro(c)
			did = true
		for f in c.fighters:
			if bool(f.get("goal_talk", false)):
				Bouts.set_goal(c, f, "five_round_engine")
				did = true
			if ApproachWire.is_open(f):
				ApproachWire.answer(c, str(f["id"]), "match")
				did = true
			if LateAskWire.is_open(f):
				LateAskWire.answer(c, str(f["id"]), false)
				did = true
			if PullOutWire.is_open(f):
				if PullOutWire.answer(c, str(f["id"]), "take_replacement") != "":
					PullOutWire.answer(c, str(f["id"]), "go_home")
				did = true
			if Injuries.pending(f):
				Injuries.pull_out(c, f)
				did = true
			for o in (f["offers"] as Array).duplicate():
				if bool(o["answered"]) or bool(o["mismatch"]):
					continue
				if (f["bout"] as Dictionary).is_empty():
					if Bouts.accept(c, str(o["id"])):
						r["booked"] = int(r["booked"]) + 1
						did = true
				else:
					Bouts.decline(c, str(o["id"]))
					did = true
			if FightWeekPlan.is_open(f):
				_week(c, f)
				did = true
			if Bouts.camp_due(c, f):
				Bouts.start_camp(c, f, Sim.focus_of(c, f), 2, OppFile.has_tape((f["bout"] as Dictionary)["opp"]), false)
				did = true
			if Bouts.weigh_in_today(c, f):
				Bouts.weigh(c, f)
				did = true
		while true:
			var g := Bouts.fighting_today(c)
			if g.is_empty():
				break
			Bouts.fight_step(c, g, Bouts.fight_modal(g), "sim")
			Bouts.after_fight(c, g)
			r["fought"] = int(r["fought"]) + 1
			did = true
		if not did:
			break

## The fight week as the assistant drafts it, every night on the best-ranked free partner (ask_probe4's pick). The kilo
## is never asked: no favour is spent, so the scale is the camp's own cut.
func _week(c: Career, f: Dictionary) -> void:
	var plan := FightWeekPlan.draft(c, f)
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
	plan["ask_kilo"] = false
	if FightWeekPlan.lock(c, f, plan) != "":
		lock_refused += 1

func _median(vals: Array) -> float:
	if vals.is_empty():
		return 0.0
	var mid := int(vals.size() / 2)
	return float(vals[mid]) if vals.size() % 2 == 1 else (float(vals[mid - 1]) + float(vals[mid])) / 2.0

## Every row's points in one division ("" = all) at one sampled day, pooled over the runs of one club ("" = both).
func _points(dv: String, day: int, club: String) -> Dictionary:
	var i := int(day / EVERY)
	var vals: Array = []
	var out := {"runs": 0, "rows": 0, "min": 0, "med": 0.0, "max": 0, "at0": 0, "at100": 0}
	for r in runs:
		if club != "" and str(r["club"]) != club:
			continue
		var divs: Array = [dv] if dv != "" else (r["divs"] as Array)
		for d2 in divs:
			var snaps: Array = (r["snap"] as Dictionary).get(d2, [])
			if i >= snaps.size():
				continue
			out["runs"] = int(out["runs"]) + 1
			for row in snaps[i]:
				var rep := int(row[1])
				vals.append(rep)
				out["at0"] = int(out["at0"]) + int(rep == 0)
				out["at100"] = int(out["at100"]) + int(rep == 100)
	vals.sort()
	out["rows"] = vals.size()
	if not vals.is_empty():
		out["min"] = int(vals[0])
		out["max"] = int(vals[vals.size() - 1])
	out["med"] = _median(vals)
	return out

func _stuck_agg(dv: String, key: String, club: String) -> Dictionary:
	var acc := {"rows": 0, "active": 0, "stuck": 0, "cap": 0, "idle": 0}
	for r in runs:
		if club != "" and str(r["club"]) != club:
			continue
		var divs: Array = [dv] if dv != "" else (r["divs"] as Array)
		for d2 in divs:
			var t: Dictionary = ((r["stuck"] as Dictionary).get(d2, {}) as Dictionary).get(key, {})
			for k in KEYS:
				acc[k] = int(acc[k]) + int(t.get(k, 0))
	return acc

## Top-3 turnover over the two years: distinct names that held a top-3 place at any sample, how many of them started in
## the bottom half of the day-0 table (rank > rows/2), how many were not in it at all, and how many of the day-0 top 3
## still hold a top-3 place at the last sample. Never-boxed rivals counted beside them.
func _turn(dv: String, club: String) -> Dictionary:
	var acc := {"runs": 0, "names": 0, "bottom": 0, "new": 0, "kept": 0, "never": 0, "rows0": 0}
	for r in runs:
		if club != "" and str(r["club"]) != club:
			continue
		var divs: Array = [dv] if dv != "" else (r["divs"] as Array)
		for d2 in divs:
			var snaps: Array = (r["snap"] as Dictionary).get(d2, [])
			if snaps.size() < 2:
				continue
			acc["runs"] = int(acc["runs"]) + 1
			var first: Array = snaps[0]
			var last: Array = snaps[snaps.size() - 1]
			var rank0: Dictionary = {}
			for j1 in first.size():
				rank0[str(first[j1][0])] = j1 + 1
			var held: Dictionary = (r["top3"] as Dictionary).get(d2, {})
			acc["names"] = int(acc["names"]) + held.size()
			acc["rows0"] = int(acc["rows0"]) + first.size()
			acc["never"] = int(acc["never"]) + int((r["never"] as Dictionary).get(d2, 0))
			for nm in held.keys():
				if not rank0.has(nm):
					acc["new"] = int(acc["new"]) + 1
				elif int(rank0[nm]) > float(first.size()) / 2.0:
					acc["bottom"] = int(acc["bottom"]) + 1
			var top_last: Array = last.slice(0, TOP).map(func(x1): return str(x1[0]))
			acc["kept"] = int(acc["kept"]) + first.slice(0, TOP).filter(func(x2): return top_last.has(str(x2[0]))).size()
	return acc

## Our boxers' points at the mark days, pooled by club and name (a boxer who left mid-run is counted as left).
func _ours() -> Array:
	var bag: Dictionary = {}
	for r in runs:
		for o in (r["ours"] as Dictionary).values():
			var key := str(r["club"]) + "|" + str(o["name"])
			var a: Dictionary = bag.get(key, {"club": str(r["club"]), "name": str(o["name"]), "div": str(o["div"]),
				"n": 0, "left": 0, "rep": {}, "w": 0, "l": 0, "bouts": 0, "rank": 0, "blocked": 0, "frozen": 0})
			a["n"] = int(a["n"]) + 1
			a["left"] = int(a["left"]) + int(bool(o["left"]))
			a["w"] = int(a["w"]) + int(o["w"])
			a["l"] = int(a["l"]) + int(o["l"])
			a["bouts"] = int(a["bouts"]) + int(o["bouts"])
			a["rank"] = int(a["rank"]) + int(o["rank"])
			var rp: Dictionary = o["rep"]
			a["blocked"] = int(a["blocked"]) + int(o.get("blocked", 0))
			a["frozen"] = int(a["frozen"]) + int(rp.has(int(marks[1])) and rp.has(int(marks[2])) and int(rp[int(marks[1])]) == int(rp[int(marks[2])]))
			for day in marks:
				if (o["rep"] as Dictionary).has(day):
					var lst: Array = (a["rep"] as Dictionary).get(day, [])
					lst.append(int(o["rep"][day]))
					(a["rep"] as Dictionary)[day] = lst
			bag[key] = a
	var out: Array = bag.values()
	out.sort_custom(func(x, y): return str(x["club"]) + str(x["name"]) < str(y["club"]) + str(y["name"]))
	return out

func _pct(n: int, d: int) -> String:
	return "%.1f%%" % (100.0 * float(n) / float(d)) if d > 0 else "-"

func _div_row(dv: String, day: int) -> String:
	var p := _points(dv, day, "")
	var s := _stuck_agg(dv, str(day), "")
	var act := int(s["active"])
	var stuck := "%s (%d/%d)" % [_pct(int(s["stuck"]), act), int(s["stuck"]), act] if act > 0 else "-"
	return "| %s | %d | %d | %d | %.1f | %d | %d (%s) | %d (%s) | %s | %d | %s |" % [
		dv, day, int(p["rows"]), int(p["min"]), float(p["med"]), int(p["max"]),
		int(p["at0"]), _pct(int(p["at0"]), int(p["rows"])), int(p["at100"]), _pct(int(p["at100"]), int(p["rows"])),
		stuck, int(s["cap"]), _pct(int(s["idle"]), int(s["rows"]))]

func _turn_row(dv: String) -> String:
	var t := _turn(dv, "")
	var n := maxi(1, int(t["runs"]))
	return "| %s | %d | %.1f | %.2f | %.2f | %.2f | %.2f | %.2f |" % [dv, int(t["runs"]),
		float(t["names"]) / n, float(t["bottom"]) / n, float(t["new"]) / n, float(t["kept"]) / n,
		float(t["never"]) / n, float(t["rows0"]) / n]

func _our_row(a: Dictionary) -> String:
	var cells: Array = []
	for day in marks.slice(1):
		var vals: Array = ((a["rep"] as Dictionary).get(day, []) as Array).duplicate()
		vals.sort()
		cells.append("%.1f (%d-%d)" % [_median(vals), int(vals[0]), int(vals[vals.size() - 1])] if not vals.is_empty() else "-")
	var n := maxi(1, int(a["n"]))
	return "| %s | %s | %s | %d | %d | %s | %s | %.1f | %.1f-%.1f | %.1f | %d | %d |" % [str(a["club"]), str(a["name"]),
		str(a["div"]), int(a["n"]), int(a["left"]), str(cells[0]), str(cells[1]),
		float(a["bouts"]) / n, float(a["w"]) / n, float(a["l"]) / n, float(a["rank"]) / n, int(a["blocked"]), int(a["frozen"])]

## The three lines the brief asks for, read off the pooled numbers (no threshold tuned: the counts say it).
func _verdicts() -> Array:
	var last := int(marks[marks.size() - 1])
	var p := _points("", last, "")
	var s := _stuck_agg("", "all", "")
	var t := _turn("", "")
	var n := maxi(1, int(t["runs"]))
	var spread := int(p["min"]) < int(p["max"]) and float(p["med"]) > float(p["min"]) and float(p["med"]) < float(p["max"])
	return ["**Points spread 0-100? %s** - at day %d, %d rows pooled: min %d, median %.1f, max %d; %d rows at 0 (%s), %d at 100 (%s)." % [
			"YES" if spread else "NO", last, int(p["rows"]), int(p["min"]), float(p["med"]), int(p["max"]),
			int(p["at0"]), _pct(int(p["at0"]), int(p["rows"])), int(p["at100"]), _pct(int(p["at100"]), int(p["rows"]))],
		"**Anyone stuck at a cap? %s** - %d rows sat at 0 or 100 with a bout in the window and no points moved in %d days (%d stuck rows of %d active, all windows day %d-%d)." % [
			"YES" if int(s["cap"]) > 0 else "NO", int(s["cap"]), WINDOW, int(s["stuck"]), int(s["active"]), WINDOW, last],
		"**Does the top 3 turn over? %s** - %.2f different names held a top-3 place over the two years (%d seats), %.2f of them started in the bottom half, %.2f were not in the day-0 table; %.2f of the day-0 top 3 still hold a seat at day %d." % [
			"YES" if float(t["names"]) / n > float(TOP) else "NO", float(t["names"]) / n, TOP, float(t["bottom"]) / n,
			float(t["new"]) / n, float(t["kept"]) / n, last]]

func _lines(secs: int) -> Array:
	var L: Array = []
	var last := int(marks[marks.size() - 1])
	L.append("# LADDERPROBE1 result - does the season ladder's table stay sane over two years of real play?")
	L.append("")
	L.append("Probe run: %s. %d seeds x 2 clubs = %d runs of %d days (seeds %d..%d), %ds. A measurement only: no rule or constant was changed." % [
		Time.get_datetime_string_from_system(), n_seeds, n_seeds * 2, n_days, base_seed, base_seed + n_seeds - 1, secs])
	L.append("")
	L.append("The scope (LADDERWIRE_SCOPE_S515) asks of every ladder stage: **a season's table stays sane - points spread 0-100, no boxer stuck at a cap, ranked top 3 turns over.** This probe plays two seasons and reads the table the game sorts (Region.rankings, ladder points first since S516) every %d days." % EVERY)
	L.append("")
	L.append("## Population")
	L.append("")
	L.append("- **QUICK**: a quick-start career, Lucy signed at reception (Sim.sign, the interview's three cards), Reid hired. One boxer (wlw).")
	L.append("- **TEST**: the TEST CLUB (scripts/state/TestClub.gd): Lucy (wlw), Kira (wfw), Josh (mww) and Ana on the mats, Reid hired. Three boxers, three classes.")
	L.append("- Both past the first-week guide and the first hour. Rivals' invented pasts re-seeded to the run seed, so a replay agrees. No fighter is synthesized or copied: the clubs' own distinct boxers against the game's own named rivals; no two fighters in a measurement are identical.")
	L.append("- %d seeds a club, %d days each through Sim.step_day - the real day loop: offers, camps, fight weeks, weigh-ins, the game's own bout sim, injuries, pull-outs, late asks, the region's own club shows (Region._rival_bout moves both rivals' points). Cash floored at $%d as two_boxers_two_years_test does; money is not the measurement." % [n_seeds, n_days, CASH_FLOOR])
	L.append("- Decisions in code, every open need answered as TestJump._tidy / _to_nationals answer them: every sheet offer accepted (Bouts.accept; the unsafe mismatch pair is left as the game leaves it), the fight week drafted and locked on the best-ranked free partners, the camp started, the weigh-in taken, the bout fought by the sim, the week review closed, the office goal five_round_engine, an injury past the bell pulled out, a fall-through answered with the replacement (else go home), a host's late ask declined (_tidy's NO), a rival club's approach matched so the boxer stays. Pro offers declined (Roster.decline_pro): the two years stay on the amateur ladder the probe measures. The nationals are never entered.")
	L.append("")
	L.append("## How the table is read")
	L.append("")
	L.append("- Every %d days, for every division that has rivals, Region.rankings(c, div) is read and each row's points recorded (a row with no \"rep\" yet reads at its seed, RankLine.rep). Our boxers enter the table at %d wins (Region.RANK_MIN_WINS) and leave it if they turn pro." % [EVERY, Region.RANK_MIN_WINS])
	L.append("- **Stuck** = a row whose points are exactly where they were %d days ago AND that had at least one bout in that window (a rival's RivalPast file, newest first; one of ours from Career.results, amateur bouts only). A row with no bout in the window is **idle**, not stuck: a never-boxing rival keeps a seed that cannot move (the brief's trap). **Cap-stuck** = stuck at 0 or 100. Stuck is counted at every sample from day %d on; the day-0 column has no window yet. A row that was not in the table 84 days earlier (one of ours entering at %d wins) counts as active, not stuck: there is no earlier reading to compare. **Never boxed** = a rival with no bout at all in the %d days (her invented past is all before day 0), reported separately, never counted as stuck." % [WINDOW, WINDOW, Region.RANK_MIN_WINS, n_days])
	L.append("- **Top-3 turnover** = the different names that held a top-3 place at any sample over the two years; **bottom half** = a day-0 rank below the middle of that day's table (rank > rows/2); **new** = not in the day-0 table at all (our boxers enter at %d wins); **kept** = of the day-0 top 3, still in the top 3 at the last sample." % Region.RANK_MIN_WINS)
	L.append("")
	L.append("## Per division: the points at day %s" % str(marks))
	L.append("")
	L.append("| division | day | rows | min | median | max | at 0 | at 100 | stuck (of active) | cap-stuck | idle |")
	L.append("|---|---|---|---|---|---|---|---|---|---|---|")
	for dv in Data.DIVISIONS.keys():
		if int(_points(str(dv), 0, "")["rows"]) == 0:
			continue
		for day in marks:
			L.append(_div_row(str(dv), int(day)))
	L.append("")
	L.append("## Per division: the top 3 over two years (means a run)")
	L.append("")
	L.append("| division | runs | distinct top-3 names | from bottom half | new to the table | day-0 top 3 kept | never boxed | rows at day 0 |")
	L.append("|---|---|---|---|---|---|---|---|")
	for dv2 in Data.DIVISIONS.keys():
		if int(_turn(str(dv2), "")["runs"]) > 0:
			L.append(_turn_row(str(dv2)))
	L.append("")
	L.append("## Our boxers' points (means a run; min-max across seeds)")
	L.append("")
	L.append("| club | boxer | division | runs | left mid-run | day %d | day %d | bouts fought | w | l | rank | no legal name at end | same points at both marks |" % [int(marks[1]), last])
	L.append("|---|---|---|---|---|---|---|---|---|---|---|---|---|")
	for a in _ours():
		L.append(_our_row(a))
	L.append("")
	L.append("**Bouts fought** counts only the bouts of the run; **w-l** is the whole record, the walk-in's past included. **No legal name at end** = at day %d our boxer was still a novice (AmateurBooking.NOVICE_MAX_BOUTS %d) while every name on her division's sheet (Data.DIVISIONS.opponents) had graduated past %d bouts at the region's own shows: Bouts.legal_index falls back to the next name in turn, _offer flags it mismatch and Bouts.accept refuses a mismatch, so the clock runs on with no bout to take. **Same points at both marks** = the identical reading at day %d and day %d - the freeze that follows. This is the shipped novice rule measured, not changed: the wall FAVOURPROBE1 reported late in its year, here seen from the ladder's side." % [last, AmateurBooking.NOVICE_MAX_BOUTS, AmateurBooking.NOVICE_MAX_BOUTS, int(marks[1]), last])
	L.append("")
	L.append("## The three lines")
	L.append("")
	for v in _verdicts():
		L.append(v)
		L.append("")
	var allwin := _stuck_agg("", "all", "")
	var t_all := _turn("", "")
	var nrun := maxi(1, int(t_all["runs"]))
	var capd: Array = Data.DIVISIONS.keys().map(func(dv3): return [100.0 * (int(_points(str(dv3), last, "")["at0"]) + int(_points(str(dv3), last, "")["at100"])) / float(maxi(1, int(_points(str(dv3), last, "")["rows"]))), str(dv3)])
	capd.sort()
	L.append("Read: %d division-runs, %.2f rows a table at day 0. Over every %d-day window from day %d to %d, %d of %d active rows did not move (%s), %d of them at a cap; %d of %d rows were idle (no bout in the window). %.2f rivals a division never boxed at all in the two years - their seed is the order they keep, and they are not counted as stuck. The bunching is uneven: at day %d the rows sitting at a cap run from %.1f%% (%s) to %.1f%% (%s). The fight week lock refused %d weeks; runs closed early: %d." % [
		int(t_all["runs"]), float(t_all["rows0"]) / nrun, WINDOW, WINDOW, last, int(allwin["stuck"]), int(allwin["active"]),
		_pct(int(allwin["stuck"]), int(allwin["active"])), int(allwin["cap"]), int(allwin["idle"]), int(allwin["rows"]),
		float(t_all["never"]) / nrun, last, float(capd[0][0]), str(capd[0][1]), float(capd[capd.size() - 1][0]), str(capd[capd.size() - 1][1]),
		lock_refused, runs.filter(func(x): return bool(x["closed"])).size()])
	L.append("")
	L.append("Reproduce: `python ops/Tools/godot_slot.py run --who ladderprobe1 -- \"$LOCALAPPDATA/Programs/Godot/Godot_v4.7.2-stable_win64.exe\" --headless --audio-driver Dummy --fixed-fps 60 --log-file E:/FightCamp/tmp/ladderprobe1.log --path . --script res://tools/ladder_probe.gd -- seeds=%d seed=%d days=%d`" % [n_seeds, base_seed, n_days])
	return L
