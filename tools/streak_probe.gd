extends SceneTree
## STREAKPROBE1 (S518, ops/research/TASK_STREAKPROBE1.md): how often a boxer is ON A RUN (HotStreak: the last 3 bouts won
## AND +15 ladder points in the last 8 weeks), and how often a corner 0-8 points above her DUCKS the ask or comes to OWE
## her the bout (AskLadder.lines, AskFlow.book, RivalOffer.DUCK_WINDOW / OWED_SCORE). A measurement only: no rule or
## constant is changed. 30 seeds x 2 clubs (a quick-start club with Lucy, and the TEST CLUB scripts/state/TestClub.gd),
## each stepped 735 days through Sim.step_day. The career set-up and the open-needs answering are tools/ladder_probe.gd's
## own (_career, _answer, _week - that file is not edited), rival calls included, so the population is LADDERPROBE4's.
## EXCEPT: each Monday, when AskFlow.open(c, f) is open and our boxer is on a run, the probe asks (AskFlow.book, kind
## "name", the soonest show AskFlow.shows would let her ask on) for the highest-points name on AskFlow.answers(c, f)
## ["cards"] whose ladder points are 0-8 above hers, and records the lean, the booking, ducks_of / is_owed after it.
## The brief's trap: the share of weeks ON A RUN is read over the weeks she had fought 3+ bouts, never over every week.
## Usage: python ops/Tools/godot_slot.py run --who streakprobe1 -- <godot> --headless --audio-driver Dummy --fixed-fps 60
##          --path . --log-file E:/FightCamp/tmp/streakprobe1.log --script res://tools/streak_probe.gd -- [seeds=30] [seed=4421] [days=735]

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
const HotStreak := preload("res://scripts/state/HotStreak.gd")
const AskFlow := preload("res://scripts/state/AskFlow.gd")
const AskLadder := preload("res://scripts/state/AskLadder.gd")
const RivalOffer := preload("res://scripts/rules/RivalOffer.gd")
const Offers := preload("res://tools/ladder_probe_offers.gd")

const CLUBS := ["QUICK", "TEST"]
const CASH_FLOOR := 20000
const PICKS := ["Jab and move", "Pad rounds", "Hill sprints"]
const DOC := "res://docs/STREAKPROBE1_RESULT.md"
const PRIOR := "res://docs/LADDERPROBE4_RESULT.md"
const MARKS := [0, 364, 728]
const FULL_WEEKS := 43   # a calendar year the run actually played (300 days, as ladder_probe_offers.FULL_DAYS)
const SUMS := ["weeks", "active", "hot", "hot_mon", "open_mon", "no_name", "no_show", "asks", "yes", "no", "booked", "fail", "ducks", "owed", "owed_booked", "owed_open", "ask_w", "ask_l", "ask_d", "ask_off", "owed_w", "owed_l", "owed_d", "bouts", "w", "l"]
const LISTS := ["longest", "win_longest"]
const SWEEP := [[3, 5], [3, 8], [3, 10], [3, 12], [3, 15], [3, 20], [2, 15], [4, 15]]

var n_seeds := 30
var base_seed := 4421
var n_days := 735
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
	var t0 := Time.get_ticks_msec()
	print("STREAKPROBE1 %d seeds x 2 clubs, %d days a run, seeds %d..%d; ON A RUN read every Monday over the weeks with %d+ bouts, the ask made on a hot Monday the door is open" % [n_seeds, n_days, base_seed, base_seed + n_seeds - 1, HotStreak.WINS])
	for club in CLUBS:
		for s in n_seeds:
			_run(str(club), base_seed + s)
	var L := _lines(int((Time.get_ticks_msec() - t0) / 1000))
	for line in L: print(line)
	var fh := FileAccess.open(DOC, FileAccess.WRITE)
	if fh == null:
		print("WARNING: could not write %s" % DOC)
	else:
		fh.store_string("\n".join(L) + "\n"); fh.close(); print("wrote %s" % DOC)
	print("STREAKPROBE1 done")
	quit(0)

## One club: quick-start with Lucy signed and Reid hired, or the TEST CLUB (Lucy, Kira, Josh + Ana, Reid). Past the first-week guide and the first hour; rivals' invented pasts re-seeded to the run seed (ladder_probe's own set-up).
func _career(club: String, seed_n: int) -> Career:
	var c := Career.quick_start()
	c.seed = seed_n; c.first_hour = {}; FirstWeek.skip(c)
	for r in c.rivals:
		var others: Array = c.rivals.filter(func(o): return str(o.get("div", "")) == str(r.get("div", ""))).map(func(o): return [o["name"], o["club"]])
		r["bouts"] = RivalPast.seed(r, others, c.seed, c.day)
	if club == "TEST":
		TestClub.make(c)
	else:
		Sim.sign(c, PICKS.duplicate()); Sim.hire(c, "reid")
	return c

func _run(club: String, seed_n: int) -> void:
	var c := _career(club, seed_n)
	var r := {"club": club, "seed": seed_n, "days": 0, "closed": false, "booked": 0, "fought": 0, "boxers": {}, "gates": {}, "pend": []}
	_mark(c, r); Offers.begin(c, r, seed_n)
	for _d in n_days:
		if c.closed:
			r["closed"] = true; break
		c.cash = maxi(c.cash, CASH_FLOOR)
		Sim.step_day(c)
		r["days"] = c.day
		if c.day % 7 == 0:
			_asks(c, r)   # the Monday ask, on the state the day opened with (before the sheet is answered)
		_answer(c, r); Offers.observe(c, r)
		if c.day % 7 == 0: _sample(c, r)
		if MARKS.has(c.day): _mark(c, r)
	_finish(c, r)
	runs.append(r)
	var asks := 0; var ducks := 0; var owed := 0; var hot := 0; var act := 0
	for b in (r["boxers"] as Dictionary).values():
		asks += int(b["asks"]); ducks += int(b["ducks"]); owed += int(b["owed"]); hot += int(b["hot"]); act += int(b["active"])
	print("  %s seed %d: day %d, %d bouts fought, ON A RUN %d/%d active weeks, %d asks, %d ducks, %d OWED%s" % [club, seed_n, int(r["days"]), int(r["fought"]), hot, act, asks, ducks, owed, " CLOSED" if bool(r["closed"]) else ""])

## The boxer's bag, created on first sight. readings = [win streak, points in 8 weeks, year] on every active week - the threshold sweep re-reads those same weeks, nothing is replayed.
func _bag(r: Dictionary, f: Dictionary) -> Dictionary:
	var b: Dictionary = (r["boxers"] as Dictionary).get(str(f["id"]), {})
	if b.is_empty():
		b = {"fid": str(f["id"]), "name": str(f["name"]), "div": str(f["div"]), "club": str(r["club"]), "stretch": 0, "readings": [], "wk_year": {}, "ep_year": {}, "owed_gap": [], "kinds": {}, "rep": {}, "left": false}
		for k in SUMS:
			b[k] = 0
		for k2 in LISTS:
			b[k2] = 0
		(r["boxers"] as Dictionary)[str(f["id"])] = b
	return b

func _mark(c: Career, r: Dictionary) -> void:
	for f in c.fighters:
		(_bag(r, f)["rep"] as Dictionary)[c.day] = RankLine.rep(f)

## Monday, the day's needs answered: the week's reading. Active = she had fought HotStreak.WINS bouts or more by now.
func _sample(c: Career, r: Dictionary) -> void:
	var yr := Offers.year(c.day)
	for f in c.fighters:
		var b := _bag(r, f)
		var rd := HotStreak._read(c, f)
		var wy: Dictionary = b["wk_year"]
		b["weeks"] = int(b["weeks"]) + 1; wy[yr] = int(wy.get(yr, 0)) + 1
		if HotStreak._mine(c, f).size() < HotStreak.WINS:
			b["stretch"] = 0
			continue
		b["active"] = int(b["active"]) + 1; (b["readings"] as Array).append([int(rd["run"]), int(rd["pts"]), yr])
		if not HotStreak.hot(c, f):
			b["stretch"] = 0
			continue
		b["hot"] = int(b["hot"]) + 1; b["stretch"] = int(b["stretch"]) + 1
		b["longest"] = maxi(int(b["longest"]), int(b["stretch"]))
		if int(b["stretch"]) == 1:
			var ey: Dictionary = b["ep_year"]
			ey[yr] = int(ey.get(yr, 0)) + 1

## The hot Monday's ask: the door as the game reads it, the highest-points name 0-8 above her on the panel's own cards, the soonest show she may ask on. The lean is read before the book (AskFlow.book reads it again and logs the duck).
func _asks(c: Career, r: Dictionary) -> void:
	for f in c.fighters:
		if bool(f.get("pro", false)) or not HotStreak.hot(c, f):
			continue
		var b := _bag(r, f)
		b["hot_mon"] = int(b["hot_mon"]) + 1
		var door := AskFlow.open(c, f)
		if not bool(door["open"]):
			var g: Dictionary = r["gates"]
			var lb := Offers._door(str(door["why"]))
			g[lb] = int(g.get(lb, 0)) + 1
			continue
		b["open_mon"] = int(b["open_mon"]) + 1
		var pick := _pick(c, f)
		if pick.is_empty():
			b["no_name"] = int(b["no_name"]) + 1; continue
		var day := _show(c, f)
		if day < 0:
			b["no_show"] = int(b["no_show"]) + 1; continue
		var opp: Dictionary = pick["opp"]
		var nm := str(opp["name"])
		var lad := AskLadder.lines(c, f, opp)
		var was_owed := bool(lad["owed"])
		var d0 := HotStreak.ducks_of(c, f, nm).size()
		b["asks"] = int(b["asks"]) + 1
		b["yes"] = int(b["yes"]) + int(bool(lad["yes"])); b["no"] = int(b["no"]) + int(not bool(lad["yes"]))
		var kd: Dictionary = b["kinds"]
		kd[str(pick["kind"])] = int(kd.get(str(pick["kind"]), 0)) + 1
		if AskFlow.book(c, f, "name", nm, day):
			b["booked"] = int(b["booked"]) + 1
			(r["pend"] as Array).append({"fid": str(f["id"]), "day": int((f["bout"] as Dictionary)["day"]), "owed": was_owed})
			if was_owed:
				b["owed_booked"] = int(b["owed_booked"]) + 1
		elif bool(lad["yes"]):
			b["fail"] = int(b["fail"]) + 1
		var d1 := HotStreak.ducks_of(c, f, nm)
		if d1.size() > d0:
			b["ducks"] = int(b["ducks"]) + 1
		if HotStreak.is_owed(c, f, nm) and not was_owed:
			b["owed"] = int(b["owed"]) + 1
			var first := int(c.day / 7)
			for w in d1:
				first = mini(first, int(w))
			(b["owed_gap"] as Array).append(int(c.day / 7) - first)

## The highest-points card 0-8 ladder points above her (RivalOffer.DUCK_RANK_GAP), ties by name. Every kind counts: the brief's pick is the panel's own cards, and the book is kind "name" (the host keeps the gate).
## S521: a corner that OWES her comes first (the card says OWED; a player asks them) - in S520's run Josh reached OWED 10 times
## and booked none, because this pick only ever took the highest name.
func _pick(c: Career, f: Dictionary) -> Dictionary:
	var cards: Array = AskFlow.answers(c, f)["cards"]
	for card in cards:
		if HotStreak.is_owed(c, f, str(card["opp"]["name"])):
			return card
	var mine := RankLine.rep(f)
	var best := {}; var best_rep := -1; var best_name := ""
	for card in cards:
		var opp: Dictionary = card["opp"]
		var rp := RankLine.rep(opp)
		if rp - mine < 0 or rp - mine > RivalOffer.DUCK_RANK_GAP: continue
		if rp > best_rep or (rp == best_rep and str(opp["name"]) < best_name):
			best = card; best_rep = rp; best_name = str(opp["name"])
	return best

## The soonest show the panel would let her ask on: the scale makes the class (or the gap) and none of ours holds it.
func _show(c: Career, f: Dictionary) -> int:
	for s in AskFlow.shows(c, f):
		if bool(s["can_ask"]):
			return int(s["day"])
	return -1

## Everything open, answered as the player would at the clock stop (ladder_probe's own pass, rival calls included).
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
				if PullOutWire.answer(c, str(f["id"]), "take_replacement") != "":
					PullOutWire.answer(c, str(f["id"]), "go_home")
				did = true
			if Injuries.pending(f): Injuries.pull_out(c, f); did = true
			for o in (f["offers"] as Array).duplicate():
				if bool(o["answered"]) or bool(o["mismatch"]):
					continue
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
			if g.is_empty():
				break
			Bouts.fight_step(c, g, Bouts.fight_modal(g), "sim"); Bouts.after_fight(c, g)
			r["fought"] = int(r["fought"]) + 1; did = true
		if not did:
			break

## The fight week as the assistant drafts it, every night on the best-ranked free partner (ladder_probe's own week).
func _week(c: Career, f: Dictionary) -> void:
	var plan := FightWeekPlan.draft(c, f)
	var plist := FightWeekPlan.partners(c, f)
	var keys: Array = (plan["nights"] as Dictionary).keys()
	keys.sort(); keys.reverse()
	var used: Array = []
	for k in keys:
		for p in plist:
			if not used.has(str(p["id"])):
				(plan["nights"] as Dictionary)[k] = str(p["id"]); used.append(str(p["id"])); break
	plan["ask_kilo"] = false
	if FightWeekPlan.lock(c, f, plan) != "":
		lock_refused += 1

## The run's end: the record, the longest win streak over every bout (not only the Mondays), the ducks still owed, and the w-l of the bouts the asks booked (an owed ask's bout clears the slate, so it is flagged when it was made).
func _finish(c: Career, r: Dictionary) -> void:
	for f in c.fighters:
		var b := _bag(r, f)
		var mine := HotStreak._mine(c, f)
		b["bouts"] = mine.size(); b["w"] = int(f["w"]); b["l"] = int(f["l"]); b["win_longest"] = _longest_wins(mine)
		b["left"] = c.fighter_by_id(str(f["id"])).is_empty()
		for nm in (f.get("ducks", {}) as Dictionary).keys():
			if HotStreak.is_owed(c, f, str(nm)):
				b["owed_open"] = int(b["owed_open"]) + 1
	for p in (r["pend"] as Array):
		var b2: Dictionary = (r["boxers"] as Dictionary).get(str(p["fid"]), {})
		if b2.is_empty():
			continue
		var row := {}
		for x in c.results:
			if str(x["fid"]) == str(p["fid"]) and int(x["d"]) == int(p["day"]) and not bool(x.get("pro", false)):
				row = x; break
		if row.is_empty():
			b2["ask_off"] = int(b2["ask_off"]) + 1; continue
		var key := "ask_w" if bool(row["win"]) else ("ask_d" if str(row["outcome"]) == "draw" else "ask_l")
		b2[key] = int(b2[key]) + 1
		if bool(p["owed"]):
			var k2 := "owed_w" if bool(row["win"]) else ("owed_d" if str(row["outcome"]) == "draw" else "owed_l")
			b2[k2] = int(b2[k2]) + 1

func _longest_wins(mine: Array) -> int:
	var best := 0
	var run := 0
	for x in mine:
		run = run + 1 if bool(x.get("win", false)) else 0
		best = maxi(best, run)
	return best

## Pooled by club and boxer over the runs: the counters summed, the stretches and the owed gaps kept as lists, the points at the marks, and the full calendar years (a season the run played) for the runs-a-season mean.
func _pool() -> Array:
	var bag := {}
	for r in runs:
		for b in (r["boxers"] as Dictionary).values():
			var key := str(b["club"]) + "|" + str(b["name"])
			var a: Dictionary = bag.get(key, {})
			if a.is_empty():
				a = {"club": str(b["club"]), "name": str(b["name"]), "div": str(b["div"]), "n": 0, "left": 0, "full_years": 0, "ep_full": 0, "gap": [], "rep": {}, "kinds": {}}
				for k in SUMS:
					a[k] = 0
				for k2 in LISTS:
					a[k2] = []
				bag[key] = a
			a["n"] = int(a["n"]) + 1; a["left"] = int(a["left"]) + int(bool(b["left"]))
			for k3 in SUMS:
				a[k3] = int(a[k3]) + int(b[k3])
			for k4 in LISTS:
				(a[k4] as Array).append(int(b[k4]))
			(a["gap"] as Array).append_array(b["owed_gap"] as Array)
			for day in MARKS:
				if (b["rep"] as Dictionary).has(day):
					var lst: Array = (a["rep"] as Dictionary).get(day, [])
					lst.append(int((b["rep"] as Dictionary)[day])); (a["rep"] as Dictionary)[day] = lst
			for kd in (b["kinds"] as Dictionary).keys():
				(a["kinds"] as Dictionary)[kd] = int((a["kinds"] as Dictionary).get(kd, 0)) + int(b["kinds"][kd])
			for yr in (b["wk_year"] as Dictionary).keys():
				if int((b["wk_year"] as Dictionary)[yr]) >= FULL_WEEKS:
					a["full_years"] = int(a["full_years"]) + 1; a["ep_full"] = int(a["ep_full"]) + int((b["ep_year"] as Dictionary).get(yr, 0))
	var out: Array = bag.values()
	out.sort_custom(func(x, y): return str(x["club"]) + str(x["name"]) < str(y["club"]) + str(y["name"]))
	return out

## The threshold sweep: the same active weeks re-read at other numbers (nothing changed, nothing replayed). The denominator stays the weeks with 3+ bouts fought, the brief's trap, so every row compares with the shipped one.
func _sweep(wins: int, pts: int) -> Dictionary:
	var out := {"active": 0, "hot": 0, "ep_full": 0, "years": 0}
	for r in runs:
		for b in (r["boxers"] as Dictionary).values():
			var wk := {}; var ep := {}; var stretch := 0
			for rd in (b["readings"] as Array):
				var y := int(rd[2])
				wk[y] = int(wk.get(y, 0)) + 1; out["active"] = int(out["active"]) + 1
				if int(rd[0]) < wins or int(rd[1]) < pts:
					stretch = 0
					continue
				out["hot"] = int(out["hot"]) + 1; stretch += 1
				if stretch == 1: ep[y] = int(ep.get(y, 0)) + 1
			for y2 in wk.keys():
				if int(wk[y2]) >= FULL_WEEKS:
					out["years"] = int(out["years"]) + 1; out["ep_full"] = int(out["ep_full"]) + int(ep.get(y2, 0))
	return out

## LADDERPROBE4's own published points, read from its result doc: the "Our boxers' points" table's two "middle (min-max)" cells a row, day 364 then day 728. {} when the doc is not there.
func _prior() -> Dictionary:
	var out := {}
	var fh := FileAccess.open(PRIOR, FileAccess.READ)
	if fh == null:
		return out
	var txt := fh.get_as_text()
	fh.close()
	var sec := txt.split("## Our boxers' points")
	if sec.size() < 2:
		return out
	for line in str(sec[1]).split("\n## ")[0].split("\n"):
		var t := str(line).strip_edges()
		if not t.begins_with("| QUICK |") and not t.begins_with("| TEST |"):
			continue
		var cells := t.split("|")
		var nums: Array = []
		for cell in cells:
			var v := str(cell).strip_edges()
			var head := v.get_slice("(", 0).strip_edges()
			if v.contains("(") and head.is_valid_float(): nums.append(float(head))
		if nums.size() >= 2:
			out["%s|%s" % [str(cells[1]).strip_edges(), str(cells[2]).strip_edges()]] = nums
	return out

func _median(vals: Array) -> float:
	if vals.is_empty(): return 0.0
	var mid := int(vals.size() / 2)
	return float(vals[mid]) if vals.size() % 2 == 1 else (float(vals[mid - 1]) + float(vals[mid])) / 2.0

func _cell(vals: Array) -> String:
	if vals.is_empty(): return "-"
	var v: Array = vals.duplicate()
	v.sort()
	return "%.1f (%d-%d)" % [_median(v), int(v[0]), int(v[v.size() - 1])]

func _pct(n: int, d: int) -> String:
	return "%.1f%%" % (100.0 * float(n) / float(d)) if d > 0 else "-"

func _table(L: Array, head: String, rows: Array) -> void:
	L.append(""); L.append(head); L.append("|" + "---|".repeat(head.count("|") - 1))
	for row in rows:
		if str(row) != "":
			L.append(str(row))
	L.append("")

func _tot(pool: Array, key: String) -> int:
	return int(pool.reduce(func(acc, a): return int(acc) + int(a[key]), 0))

func _all(pool: Array, key: String) -> Array:
	var out: Array = []
	for a in pool:
		out.append_array(a[key] as Array)
	return out

func _gates() -> Dictionary:
	var g := {}
	for r in runs:
		for k in (r["gates"] as Dictionary).keys():
			g[k] = int(g.get(k, 0)) + int((r["gates"] as Dictionary)[k])
	return g

func _row_run(a: Dictionary) -> String:
	var n := maxi(1, int(a["n"]))
	return "| %s | %s | %s | %d | %d | %d | %s | %s | %.2f | %s | %.1f | %.1f-%.1f |" % [str(a["club"]), str(a["name"]), str(a["div"]), n, int(a["active"]), int(a["hot"]), _pct(int(a["hot"]), int(a["active"])), _cell(a["longest"] as Array), float(a["ep_full"]) / maxi(1, int(a["full_years"])), _cell(a["win_longest"] as Array), float(a["bouts"]) / n, float(a["w"]) / n, float(a["l"]) / n]

func _row_ask(a: Dictionary) -> String:
	return "| %s | %s | %d | %d | %d | %d | %d | %d | %d | %d | %d | %s | %d | %d-%d |" % [str(a["club"]), str(a["name"]), int(a["hot_mon"]), int(a["open_mon"]), int(a["no_name"]) + int(a["no_show"]), int(a["asks"]), int(a["yes"]), int(a["no"]), int(a["booked"]), int(a["ducks"]), int(a["owed"]), _cell(a["gap"] as Array), int(a["owed_booked"]), int(a["owed_w"]), int(a["owed_l"])]

func _row_rep(a: Dictionary, prior: Dictionary) -> String:
	var p: Array = prior.get("%s|%s" % [str(a["club"]), str(a["name"])], [])
	var c1: Array = (a["rep"] as Dictionary).get(int(MARKS[1]), [])
	var c2: Array = (a["rep"] as Dictionary).get(int(MARKS[2]), [])
	var had := p.size() >= 2
	var was := float(p[1]) if had else 0.0
	var delta := "%+.1f" % (_median(c2) - was) if had and not c2.is_empty() else "-"
	return "| %s | %s | %d | %s | %s | %s | %s | %s |" % [str(a["club"]), str(a["name"]), int(a["n"]), _cell(c1), "%.1f" % float(p[0]) if had else "-", _cell(c2), "%.1f" % was if had else "-", delta]

## The three lines the brief asks for, read off the pooled numbers. No threshold is changed: where one is off, the sweep names the number that would land in the target band, and the gate table names what kept the ask from being made.
func _verdicts(pool: Array, sweep: Array) -> Array:
	var act := _tot(pool, "active"); var hot := _tot(pool, "hot"); var asks := _tot(pool, "asks")
	var ducks := _tot(pool, "ducks"); var owed := _tot(pool, "owed"); var years := _tot(pool, "full_years")
	var share := 100.0 * float(hot) / float(maxi(1, act))
	var band := share >= 10.0 and share <= 30.0
	var named := ""; var best := 99.0
	for s in sweep:
		var sh := 100.0 * float(s["hot"]) / float(maxi(1, int(s["active"])))
		if sh >= 10.0 and sh <= 30.0 and absf(sh - 20.0) < best:
			best = absf(sh - 20.0); named = "%d wins in a row and +%d points in %d weeks would read %.1f%%" % [int(s["wins"]), int(s["pts"]), HotStreak.WEEKS, sh]
	var fix := "The shipped numbers sit in the band: nothing to name." if band else ("The number that would hit the target: %s (a read of the same weeks, not a change)." % named if named != "" else "No number in the sweep lands in 10-30%: the band is out of reach of these two thresholds alone.")
	var dseason := float(ducks) / float(maxi(1, years))
	var dver := "NO - never" if ducks == 0 else ("YES - a few" if dseason <= 8.0 else "NO - near weekly")
	var gate := _gates()
	var shut := 0
	for k in gate.keys(): shut += int(gate[k])
	var why := ""
	if asks == 0:
		why = " **Not one ask was made: the door was shut on every hot Monday** (%d of them). The sheet's next offer lands on the very day the rest after a bout ends (Bouts.AFTER_FIGHT %d is both after_fight's next_offer_day and AskBout.open's due), so a gym that answers its own sheet at once has no open day between bouts: a next-offer gap of %d (the rest plus a week) would leave a free Monday to ask on. The duck window itself was never reached." % [shut, Bouts.AFTER_FIGHT, Bouts.AFTER_FIGHT + 7]
	elif ducks == 0:
		why = " The %d asks all leaned Yes, so no No was a duck." % asks
	var gaps := _all(pool, "gap")
	var over := "**Does OWED ever fire? %s** - %d OWED reached over the %d runs (%d ducks in all), %s weeks from the first duck to the owed ask; %d owed bouts booked (w-l %d-%d), %d still owed at day %d." % ["YES" if owed > 0 else "NO", owed, runs.size(), ducks, _cell(gaps), _tot(pool, "owed_booked"), _tot(pool, "owed_w"), _tot(pool, "owed_l"), _tot(pool, "owed_open"), n_days]
	if owed == 0: over += " Two ducks inside %d weeks (RivalOffer.DUCK_WINDOW) are needed, and a duck is logged once a week at most: the ask has to come round again while the boxer is still on a run." % RivalOffer.DUCK_WINDOW
	return ["**Is ON A RUN rare enough to feel earned (10-30%% of active weeks)? %s** - %d of %d active weeks (%.1f%%), over the weeks she had fought %d+ bouts; longest run %s weeks, %.2f runs a full season. %s" % ["YES" if band else "NO", hot, act, share, HotStreak.WINS, _cell(_all(pool, "longest")), float(_tot(pool, "ep_full")) / float(maxi(1, years)), fix],
		"**Do ducks happen a few times a season (not never, not weekly)? %s** - %d ducks over %d full boxer-seasons (%.2f a season), from %d asks made while on a run (%d Leans No, %d Leans Yes).%s" % [dver, ducks, years, dseason, asks, _tot(pool, "no"), _tot(pool, "yes"), why],
		over]

func _lines(secs: int) -> Array:
	var L: Array = []
	var pool := _pool()
	var prior := _prior()
	var sweep: Array = []
	for s in SWEEP:
		var t := _sweep(int(s[0]), int(s[1]))
		sweep.append({"wins": int(s[0]), "pts": int(s[1]), "active": int(t["active"]), "hot": int(t["hot"]), "season": float(t["ep_full"]) / float(maxi(1, int(t["years"])))})
	L.append("# STREAKPROBE1 - how often a boxer is ON A RUN, and how often corners DUCK her or come to OWE her the bout")
	L.append(""); L.append("Probe run: %s. %d seeds x 2 clubs = %d runs of %d days (seeds %d..%d), %ds. A measurement only: no rule or constant was changed." % [Time.get_datetime_string_from_system(), n_seeds, n_seeds * CLUBS.size(), n_days, base_seed, base_seed + n_seeds - 1, secs])
	L.append(""); L.append("The map (ops/research/DESIGN_LADDER1_V6_DOLA.md R6) puts a boxer ON A RUN when she has won her last %d bouts AND gained %d+ ladder points in the last %d weeks (HotStreak.WINS / POINTS / WEEKS, read from c.results' \"pts\"). A corner 0-%d ladder points above her then leans No (-20 on the yes score, LadderRep.yes_score); such a No is DUCKED (once a week at most), two ducks inside %d weeks make the next ask to that corner OWED (score %d, a Yes), and booking the owed bout clears the slate. Those numbers are the map's estimates: this probe plays two seasons and counts how often each of them happens." % [HotStreak.WINS, HotStreak.POINTS, HotStreak.WEEKS, RivalOffer.DUCK_RANK_GAP, RivalOffer.DUCK_WINDOW, RivalOffer.OWED_SCORE])
	L.append("## Population")
	L.append(""); L.append("- **QUICK**: a quick-start career, Lucy signed at reception, Reid hired. **TEST**: the TEST CLUB (scripts/state/TestClub.gd): Lucy (wlw), Kira (wfw), Josh (mww), Ana on the mats, Reid hired. Both past the first-week guide and the first hour, rivals' invented pasts re-seeded to the run seed. The clubs' own distinct boxers against the game's own named rivals; no two fighters in a measurement are identical. %d seeds a club, %d days each through Sim.step_day, cash floored at $%d. The career set-up and the open-needs answering are tools/ladder_probe.gd's own (_career, _answer, _week), copied not edited: every sheet offer accepted, the fight week drafted and locked, the camp started, the weigh-in taken, the bout fought by the sim, pro offers declined, the nationals never entered, and the rival gyms' calls answered by the run seed's policy (tools/ladder_probe_offers.gd) - so the population is LADDERPROBE4's and the points below compare with it." % [n_seeds, n_days, CASH_FLOOR])
	L.append("- **The one exception**: each Monday, before the day's needs are answered, every boxer on a run (HotStreak.hot) whose Ask door (AskFlow.open) is open asks a corner that OWES her first (S521), else the highest-points name on AskFlow.answers(c, f)[\"cards\"] whose ladder points are 0-%d above hers (ties by name), at the soonest show AskFlow.shows would let her ask on (can_ask: the scale makes the class or the gap, and none of ours holds the night), through AskFlow.book kind \"name\" (the host keeps the gate). The lean is read before the book; the ducks and OWED after it. A hot Monday whose door is shut is counted in the gate table below, never as an ask." % RivalOffer.DUCK_RANK_GAP)
	L.append("## How it is read")
	L.append(""); L.append("- **Active week** = a Monday (day %% 7 == 0, day 0 is Mon 5 Jan 2026) on which she had fought %d or more amateur bouts in this career. The share ON A RUN is hot weeks / active weeks - the brief's trap: a 0-0 boxer is never on a run and says nothing about the threshold. The reading is taken at the day's end, after every open need is answered. **Longest run** = the longest stretch of consecutive active Mondays ON A RUN (weeks); **runs a season** = the separate stretches that start in a full calendar year (a year the run played %d+ weeks), averaged over those years. The longest win streak (bouts) is read beside it over every bout of the run, not only the Mondays." % [HotStreak.WINS, FULL_WEEKS])
	L.append("- **Ducks** = a No logged by AskFlow.book while she was on a run from a name 0-%d points above (HotStreak.duck, once a week). **OWED reached** = is_owed turning true after an ask; the weeks from the first duck to that ask are kept. **Owed bouts booked** = an ask that booked while the card already read OWED (AskFlow.book clears the slate); its w-l is the career's own result on that night. A booked ask that never came off (missed weight, a pull-out, the run's end) is counted apart." % RivalOffer.DUCK_RANK_GAP)
	_table(L, "| club | boxer | division | runs | active weeks | ON A RUN weeks | share | longest run (weeks) | runs a season | longest win streak (bouts) | bouts a run | w-l a run |", pool.map(func(a): return _row_run(a)))
	_table(L, "| club | boxer | hot Mondays | door open | no name / no show | asks | Leans Yes | Leans No | booked | ducks | OWED reached | first duck to owed (weeks) | owed bouts booked | owed w-l |", pool.map(func(a): return _row_ask(a)))
	var gate := _gates()
	var gk: Array = gate.keys()
	gk.sort_custom(func(x, y): return int(gate[x]) > int(gate[y]))
	var gt := 0
	for kg in gk: gt += int(gate[kg])
	_table(L, "| the gate that stopped the ask on a hot Monday | Mondays | share |", gk.map(func(k): return "| %s | %d | %s |" % [str(k), int(gate[k]), _pct(int(gate[k]), gt)]))
	_table(L, "| club | boxer | runs | day %d | LADDERPROBE4 day %d | day %d | LADDERPROBE4 day %d | change at day %d |" % [int(MARKS[1]), int(MARKS[1]), int(MARKS[2]), int(MARKS[2]), int(MARKS[2])], pool.map(func(a): return _row_rep(a, prior)))
	L.append("The points are the same marks LADDERPROBE4 printed (docs/LADDERPROBE4_RESULT.md, \"Our boxers' points\"), read from that doc's own table. The only difference in the day loop is the hot Monday's ask: where it booked a night the sheet would have had, the points move with it.")
	_table(L, "| wins in a row | points in %d weeks | ON A RUN weeks | share of active weeks | runs a season | note |" % HotStreak.WEEKS, sweep.map(func(q): return "| %d | %d | %d | %s | %.2f | %s |" % [int(q["wins"]), int(q["pts"]), int(q["hot"]), _pct(int(q["hot"]), int(q["active"])), float(q["season"]), "the shipped threshold" if int(q["wins"]) == HotStreak.WINS and int(q["pts"]) == HotStreak.POINTS else ""]))
	L.append("A read of the same active weeks at other numbers - nothing changed, nothing replayed. The denominator stays the weeks with %d+ bouts fought, so every row compares with the shipped one." % HotStreak.WINS)
	L.append("## The three lines")
	L.append("")
	for v in _verdicts(pool, sweep):
		L.append(v); L.append("")
	var kinds := {}
	for pa in pool:
		for kk in (pa["kinds"] as Dictionary).keys():
			kinds[kk] = int(kinds.get(kk, 0)) + int((pa["kinds"] as Dictionary)[kk])
	var ktxt: Array = kinds.keys().map(func(k): return "%s %d" % [str(k), int(kinds[k])])
	L.append("Read: %d runs, %d boxer-Mondays, %d active weeks pooled, %d of them ON A RUN (%s). %d hot Mondays: the door open on %d, shut on %d; %d asks made (%s), %d booked, %d refused by the corner, %d leaned Yes but would not book. The asks booked %d bouts: %d-%d (%d drawn, %d never came off). %d ducks, %d OWED reached, %d owed bouts booked, %d still owed at the run's end. The fight week lock refused %d weeks; runs closed early: %d; boxers left mid-run: %d." % [runs.size(), _tot(pool, "weeks"), _tot(pool, "active"), _tot(pool, "hot"), _pct(_tot(pool, "hot"), _tot(pool, "active")), _tot(pool, "hot_mon"), _tot(pool, "open_mon"), gt, _tot(pool, "asks"), "; ".join(ktxt) if not ktxt.is_empty() else "no card kind", _tot(pool, "booked"), _tot(pool, "no"), _tot(pool, "fail"), _tot(pool, "ask_w") + _tot(pool, "ask_l") + _tot(pool, "ask_d"), _tot(pool, "ask_w"), _tot(pool, "ask_l"), _tot(pool, "ask_d"), _tot(pool, "ask_off"), _tot(pool, "ducks"), _tot(pool, "owed"), _tot(pool, "owed_booked"), _tot(pool, "owed_open"), lock_refused, runs.filter(func(x): return bool(x["closed"])).size(), _tot(pool, "left")])
	L.append(""); L.append("Reproduce: `python ops/Tools/godot_slot.py run --who streakprobe1 -- \"$LOCALAPPDATA/Programs/Godot/Godot_v4.7.2-stable_win64.exe\" --headless --audio-driver Dummy --fixed-fps 60 --log-file E:/FightCamp/tmp/streakprobe1.log --path . --script res://tools/streak_probe.gd -- seeds=%d seed=%d days=%d`" % [n_seeds, base_seed, n_days])
	return L
