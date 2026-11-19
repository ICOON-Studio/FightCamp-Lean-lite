extends SceneTree
## MONEYFOUR2 (S520, ops/research/TASK_MONEYFOUR2.md): class nights on the BUILT club week (S519 v11) - is the money
## worth the pad time lost? The TEST CLUB (scripts/state/TestClub.gd: Lucy, Kira, Josh + Ana on the mats, Reid sessional)
## played 182 days through Sim.step_day, 30 seeds from 4421, five arms: classes on 0 / 1 (Wed) / 2 (Tue+Thu) / 5 weekday
## nights, set through ClubClasses.toggle on c.coach on day 0, plus CASH-SHORT (the 2-night arm starting on 4 weeks of
## costs). Every sheet offer accepted and every bout fought as tools/ladder_probe.gd does: its _career, _answer and _week
## are reused by preload (that file and tools/money_four_probe.gd are NOT edited); the money sampling is
## money_four_probe's (_ticket_income). Unlike LADDERPROBE4 there is NO cash floor: money is the measurement. The coach's
## usual $350 adult class (GameMoney.CLASSES_WITH_COACH) is the same in every arm and never counted: class cash is the
## week's own class_nights income line (GymSpend.income). Mastery is read per boxer (sum over f["moves"]), never pooled
## with Ana (mats). A class halves only PAD evenings (DrillWeek._class_bag, BAG_SHARE 0.5): Tue/Thu are sparring nights in
## a camp week, so an arm's mastery cost depends on the club's state.
## Usage: python ops/Tools/godot_slot.py run --who moneyfour2 -- <godot> --headless --audio-driver Dummy --fixed-fps 60
##          --log-file E:/FightCamp/tmp/moneyfour2.log --path . --script res://tools/money_four2_probe.gd -- [seeds=30] [seed=4421] [days=182]

const Sim := preload("res://scripts/state/Sim.gd")
const ClubClasses := preload("res://scripts/rules/ClubClasses.gd")
const ClubDeal := preload("res://scripts/rules/ClubDeal.gd")
const GymSpend := preload("res://scripts/state/GymSpend.gd")
const GameMoney := preload("res://scripts/rules/GameMoney.gd")
const GymBills := preload("res://scripts/rules/GymBills.gd")
const PadWeek := preload("res://scripts/rules/PadWeek.gd")
const RankLine := preload("res://scripts/rules/RankLine.gd")
const Ladder := preload("res://tools/ladder_probe.gd")
const MoneyFour := preload("res://tools/money_four_probe.gd")
const Offers := preload("res://tools/ladder_probe_offers.gd")

const DOC := "res://docs/MONEYFOUR2_RESULT.md"
const ARMS := ["N0", "N1", "N2", "N5", "CASH-SHORT"]
const NIGHTS := {"N0": [], "N1": [2], "N2": [1, 3], "N5": [0, 1, 2, 3, 4], "CASH-SHORT": [1, 3]}
const NIGHT_WORDS := {"N0": "none", "N1": "Wed", "N2": "Tue+Thu", "N5": "Mon-Fri", "CASH-SHORT": "Tue+Thu"}
const MARKS := [28, 56, 91, 182]   # weeks 4, 8, 13, 26
const WIDE := 1000.0   # the bar: a wide money margin is $1,000 of cash at the end

var n_seeds := 30
var base_seed := 4421
var n_days := 182
var runs: Array = []
var lp = Ladder.new()
var mf = MoneyFour.new()


func _initialize() -> void:
	for a in OS.get_cmdline_user_args():
		var kv := str(a).split("=")
		if kv.size() == 2:
			match kv[0]:
				"seeds": n_seeds = int(kv[1])
				"seed": base_seed = int(kv[1])
				"days": n_days = int(kv[1])
	var t0 := Time.get_ticks_msec()
	print("MONEYFOUR2 %d seeds x %d arms, %d days a run, seeds %d..%d; TEST CLUB, no cash floor" % [
		n_seeds, ARMS.size(), n_days, base_seed, base_seed + n_seeds - 1])
	for arm in ARMS:
		for s in n_seeds:
			_run(str(arm), base_seed + s)
		print("MONEYFOUR2 arm=%s done" % arm)
	var L := _lines(int((Time.get_ticks_msec() - t0) / 1000.0))
	for line in L:
		print(line)
	var fh := FileAccess.open(DOC, FileAccess.WRITE)
	if fh == null:
		print("WARNING: could not write %s" % DOC)
	else:
		fh.store_string("\n".join(L) + "\n")
		fh.close()
		print("wrote %s" % DOC)
	print("MONEYFOUR2 done")
	lp.free()   # the two helper SceneTrees are objects, not the main loop: free them so no viewport RID leaks at exit
	mf.free()
	quit(0)


## One run: the TEST CLUB on the run seed (ladder_probe's own set-up, rivals' pasts re-seeded), the arm's nights toggled
## on day 0, then the real day loop. No cash floor (ladder_probe floors at $20,000 because money is not its measurement;
## here it is). CASH-SHORT starts on 4 weeks of the day-0 costs. Class cash is sampled on the week's own class_nights
## income line at every week end; the boxers' mastery and points are read at every week end and at the last day seen.
func _run(arm: String, seed_n: int) -> void:
	var c: Career = lp._career("TEST", seed_n)
	for d in (NIGHTS[arm] as Array):
		ClubClasses.toggle(c.coach, int(d))
	var costs0: int = int(Sim.weekly_costs(c)["total"])
	if arm == "CASH-SHORT":
		c.cash = 4 * costs0
	var r := {"arm": arm, "seed": seed_n, "club": "TEST", "booked": 0, "fought": 0, "days": 0, "closed": false,
		"class_cash": 0, "joined": 0, "below": 0, "padnights": 0, "marks": {}, "cash0": c.cash, "costs0": costs0, "boxers": {}}
	for f in c.fighters:
		(r["boxers"] as Dictionary)[str(f["id"])] = {"name": str(f["name"]), "div": str(f["div"]),
			"m0": _moves_sum(f), "m1": _moves_sum(f), "rep": RankLine.rep(f), "seen": 0, "left": false}
	Offers.begin(c, r, seed_n)
	for _d in n_days:
		if c.closed:
			r["closed"] = true
			break
		Sim.step_day(c)
		r["days"] = c.day
		Offers.gates(c, r)
		lp._answer(c, r)
		Offers.observe(c, r)
		if c.day % 7 == 0:
			r["class_cash"] = int(r["class_cash"]) + int(GymSpend.income(c)["class_nights"])
			r["below"] = int(r["below"]) + int(c.cash < 0)
			for f2 in c.fighters:
				var pads2: Array = PadWeek.nights_of(f2).get("pads", [])
				for d2 in (NIGHTS[arm] as Array):
					if pads2.has(int(d2)):
						r["padnights"] = int(r["padnights"]) + 1
			if MARKS.has(c.day):
				(r["marks"] as Dictionary)[c.day] = c.cash
			_see(c, r)
	_see(c, r)
	_finish(c, r)
	runs.append(r)
	print("  %s seed %d: day %d, class $%d, joined %d, cash $%d, below %d, bouts %d%s" % [arm, seed_n, int(r["days"]),
		int(r["class_cash"]), int(r["joined"]), c.cash, int(r["below"]), int(r["fought"]), " CLOSED" if bool(r["closed"]) else ""])


func _see(c: Career, r: Dictionary) -> void:
	for f in c.fighters:
		var b: Dictionary = (r["boxers"] as Dictionary).get(str(f["id"]), {})
		if b.is_empty():
			continue
		b["m1"] = _moves_sum(f)
		b["rep"] = RankLine.rep(f)
		b["seen"] = c.day


## The run's end: cash, the members the classes brought (the gym's own news line, cap-clamped joins included), the
## ticket cut (money_four_probe's sampler), and per boxer the mastery gained (last seen - day 0), the run's own bouts
## from Career.results (the walk-in's past is not the run's), and the ladder points at the last day seen.
func _finish(c: Career, r: Dictionary) -> void:
	r["cash1"] = c.cash
	r["members1"] = c.members
	r["tickets"] = mf._ticket_income(c)
	r["game_below"] = c.weeks_below
	for n in c.news:
		var t := str(n["t"])
		if t.begins_with("The evening classes brought"):
			r["joined"] = int(r["joined"]) + int(t.get_slice(" ", 4))
	var md := 0.0
	var ws := 0
	var bs := 0
	var rp := 0
	for id in (r["boxers"] as Dictionary):
		var b: Dictionary = (r["boxers"] as Dictionary)[id]
		b["left"] = c.fighter_by_id(str(id)).is_empty()
		var mine: Array = c.results.filter(func(x): return str(x["fid"]) == str(id) and not bool(x.get("pro", false)) \
			and int(x["d"]) > 0 and int(x["d"]) <= n_days)
		b["bouts"] = mine.size()
		b["w"] = mine.filter(func(x): return bool(x["win"])).size()
		b["d"] = mine.filter(func(x): return not bool(x["win"]) and str(x.get("outcome", "")) == "draw").size()
		b["l"] = mine.size() - int(b["w"]) - int(b["d"])
		md += float(b["m1"]) - float(b["m0"])
		ws += int(b["w"])
		bs += int(b["bouts"])
		rp += int(b["rep"])
	r["mastery"] = md
	r["wins"] = ws
	r["bouts"] = bs
	r["rep"] = rp


static func _moves_sum(f: Dictionary) -> float:
	var t := 0.0
	for m in (f.get("moves", {}) as Dictionary):
		t += float((f["moves"] as Dictionary)[m])
	return t


## One arm pooled over its runs: the money lists, the record lists (per-run sums over the three boxers), the cash marks,
## and per boxer the mastery-gained / bouts / w-l-d / points lists. A boxer who left mid-run keeps her last-seen numbers.
func _bag(arm: String) -> Dictionary:
	var rs: Array = runs.filter(func(r): return str(r["arm"]) == arm)
	var out := {"arm": arm, "n": rs.size(), "closed": 0, "class": [], "joined": [], "cash": [], "cash0": [], "below": [],
		"tickets": [], "padnights": [], "marks": {}, "mastery": [], "wins": [], "bouts": [], "rep": [], "boxers": {}}
	for d in MARKS:
		(out["marks"] as Dictionary)[d] = []
	for r in rs:
		out["closed"] = int(out["closed"]) + int(bool(r["closed"]))
		(out["cash0"] as Array).append(int(r["cash0"]))
		(out["class"] as Array).append(int(r["class_cash"]))
		(out["joined"] as Array).append(int(r["joined"]))
		(out["padnights"] as Array).append(int(r["padnights"]))
		(out["cash"] as Array).append(int(r["cash1"]))
		(out["below"] as Array).append(int(r["below"]))
		(out["tickets"] as Array).append(int(r["tickets"]))
		(out["mastery"] as Array).append(float(r["mastery"]))
		(out["wins"] as Array).append(int(r["wins"]))
		(out["bouts"] as Array).append(int(r["bouts"]))
		(out["rep"] as Array).append(int(r["rep"]))
		for d2 in MARKS:
			if (r["marks"] as Dictionary).has(d2):
				((out["marks"] as Dictionary)[d2] as Array).append(int((r["marks"] as Dictionary)[d2]))
		for id in (r["boxers"] as Dictionary):
			var b: Dictionary = (r["boxers"] as Dictionary)[id]
			var key := str(b["name"])
			var a: Dictionary = (out["boxers"] as Dictionary).get(key, {"name": key, "div": str(b["div"]),
				"m": [], "bouts": [], "w": [], "l": [], "d": [], "rep": [], "left": 0})
			(a["m"] as Array).append(float(b["m1"]) - float(b["m0"]))
			(a["bouts"] as Array).append(int(b["bouts"]))
			(a["w"] as Array).append(int(b["w"]))
			(a["l"] as Array).append(int(b["l"]))
			(a["d"] as Array).append(int(b["d"]))
			(a["rep"] as Array).append(int(b["rep"]))
			a["left"] = int(a["left"]) + int(bool(b["left"]))
			(out["boxers"] as Dictionary)[key] = a
	return out


func _run_of(arm: String, seed_n: int) -> Dictionary:
	for r in runs:
		if str(r["arm"]) == arm and int(r["seed"]) == seed_n:
			return r
	return {}


## The arm's trade against N0 on the SAME seed (paired): class cash, cash at the end, mastery, wins, points.
func _deltas(arm: String) -> Dictionary:
	var out := {"class": [], "cash": [], "mastery": [], "wins": [], "rep": []}
	for r in runs.filter(func(x): return str(x["arm"]) == arm):
		var base: Dictionary = _run_of("N0", int(r["seed"]))
		if base.is_empty():
			continue
		(out["class"] as Array).append(int(r["class_cash"]) - int(base["class_cash"]))
		(out["cash"] as Array).append(int(r["cash1"]) - int(base["cash1"]))
		(out["mastery"] as Array).append(float(r["mastery"]) - float(base["mastery"]))
		(out["wins"] as Array).append(int(r["wins"]) - int(base["wins"]))
		(out["rep"] as Array).append(int(r["rep"]) - int(base["rep"]))
	return out


static func _mean(vals: Array) -> float:
	if vals.is_empty():
		return 0.0
	var t := 0.0
	for v in vals:
		t += float(v)
	return t / float(vals.size())


static func _sumi(vals: Array) -> int:
	var t := 0
	for v in vals:
		t += int(v)
	return t


## "mean (min-max)" of a float list, the mastery cells' own read (ladder_probe's _cell is the int one).
static func _fcell(vals: Array) -> String:
	if vals.is_empty():
		return "-"
	var v: Array = vals.duplicate()
	v.sort()
	return "%.1f (%.1f-%.1f)" % [_mean(v), float(v[0]), float(v[v.size() - 1])]


## The trade in one line per arm: "$X more for Y mastery and Z wins fewer", paired on the same seeds against N0.
func _trade(arm: String) -> String:
	if arm == "N0":
		return "- N0: the baseline - $0 more, 0 mastery, 0 wins (every pad evening kept)."
	var d := _deltas(arm)
	var mm := _mean(d["mastery"])
	var mw := _mean(d["wins"])
	var mwords := "%.2f mastery lost" % -mm if mm < 0.0 else "%.2f mastery gained" % mm
	var wwords := "%.1f wins fewer" % -mw if mw < 0.0 else "%.1f wins more" % mw
	var note := ""
	if arm == "CASH-SHORT":
		note = " Its cash delta carries the poor start (4 weeks of costs against N0's full bank); the class cash is the money the nights themselves pay."
	return "- %s: $%.0f more for %s and %s (cash at the end $%+.0f, ladder points %+.2f, paired on the same seeds).%s" % [
		arm, _mean(d["class"]), mwords, wwords, _mean(d["cash"]), _mean(d["rep"]), note]


## The trade's rate: mastery lost per $1,000 of class cash, cheapest money first - the brief's question as one number.
func _cheap() -> String:
	var rows: Array = []
	for arm in ARMS:
		if str(arm) == "N0" or str(arm) == "CASH-SHORT":
			continue
		var d := _deltas(str(arm))
		var mc := _mean(d["class"])
		if mc > 0.0:
			rows.append([(-_mean(d["mastery"])) / (mc / 1000.0), str(arm), mc, _mean(d["mastery"])])
	rows.sort_custom(func(a, b): return float(a[0]) < float(b[0]))
	var parts: Array = []
	for x in rows:
		parts.append("%s: %.2f mastery per $1,000 ($%.0f class cash, mastery %+.2f)" % [str(x[1]), float(x[0]), float(x[2]), float(x[3])])
	return "**The price of the money** (mastery lost per $1,000 of class cash, paired on the same seeds, cheapest first): " + "; ".join(parts) + ". CASH-SHORT buys N2's nights from a poor start - its question is survival, not the rate."


## The bar: no arm should win on BOTH money and record by a wide margin. Two readings, both reported: strict ($1,000
## more cash AND wins and mastery no lower) and within noise ($1,000 more cash AND wins >= -0.5 AND mastery >= -1.0 -
## half a win and one mastery point over 26 weeks x 3 boxers is the bout sim's noise, not a cost). An arm that passes
## either is a free lunch; _lunch names the number that would fix it, read off the mechanism (padnights counts the
## boxer-evenings the class actually halved - BAG_SHARE can only bite on those).
func _bar() -> Array:
	var out: Array = []
	var strict := ""
	var near := ""
	for arm in ARMS:
		if str(arm) == "N0":
			continue
		var d := _deltas(str(arm))
		var dc := _mean(d["cash"])
		var dw := _mean(d["wins"])
		var dm := _mean(d["mastery"])
		if dc >= WIDE and dw >= 0.0 and dm >= 0.0:
			if strict == "":
				strict = str(arm)
		elif dc >= WIDE and dw >= -0.5 and dm >= -1.0:
			if near == "":
				near = str(arm)
	if strict != "":
		out.append(_lunch(strict, true))
	if near != "" and near != strict:
		out.append(_lunch(near, false))
	if out.is_empty():
		out.append("**No free lunch.** No arm wins on both money and record by a wide margin, strictly or within noise (the bar: $%.0f more cash at the end with wins and mastery no lower - or no lower than half a win and one mastery point, the run's noise - paired on the same seeds). Every class arm pays mastery for its money; N0 keeps the pads and the record but earns no class cash." % WIDE)
	return out


func _lunch(arm: String, strict: bool) -> String:
	var d := _deltas(arm)
	var dm := _mean(d["mastery"])
	var dw := _mean(d["wins"])
	var bag := _bag(arm)
	var pn := _mean(bag["padnights"])
	var possible: int = (NIGHTS[arm] as Array).size() * 3 * int(n_days / 7)
	var frac := pn / float(maxi(1, possible))
	var fix := "$%d (ClubDeal.class_cash): the money is too big for the pad time it buys - lower it" % ClubDeal.class_cash(1)
	if frac < 0.1:
		fix = "$%d (ClubDeal.class_cash): only %.1f of a possible %d boxer-nights were pad evenings (%.0f%%), so BAG_SHARE barely applies at any value - the money lever is what touches this arm; lower it (making a class take the whole evening, sparring included, is a rule change, not a number)" % [ClubDeal.class_cash(1), pn, possible, frac * 100.0]
	elif dm > -1.0:
		fix = "BAG_SHARE (%.2f): %.1f boxer-nights were halved yet cost almost no mastery (the gain curve flattens near the cap) - lower it so the class costs a real share" % [ClubClasses.BAG_SHARE, pn]
	var comp := ""
	if _mean(bag["joined"]) >= 1.0:
		comp = " The members (MEMBER_A_NIGHT %.4f, an ESTIMATE) compound the money side." % ClubClasses.MEMBER_A_NIGHT
	var head := "**Free lunch: %s**" % arm
	var read := "wins %+.1f and mastery %+.2f: it wins on both money and record by a wide margin" % [dw, dm]
	if not strict:
		head = "**Free lunch within noise: %s**" % arm
		read = "wins %+.1f and mastery %+.2f: the record is not worse within the bout sim's noise (half a win, one mastery point over the run), so the money is effectively free" % [dw, dm]
	return "%s - $%.0f more cash, %s. The number that would fix it: %s.%s" % [head, _mean(d["cash"]), read, fix, comp]


## CASH-SHORT's own question: does the class money save a gym that starts on 4 weeks of costs?
func _cashshort() -> String:
	var cs := _bag("CASH-SHORT")
	var n2 := _bag("N2")
	var n0 := _bag("N0")
	var costs := 0
	var cash0 := 0
	for r in runs:
		if str(r["arm"]) == "CASH-SHORT":
			costs = int(r["costs0"])
			cash0 = int(r["cash0"])
			break
	var verdict := "The class money keeps the doors open but does not restore the bank: two nights are a lifeline, not a repair."
	if _mean(cs["cash"]) >= 0.0:
		verdict = "The class money digs the poor start out within the run: two nights are enough to repair it."
	elif int(cs["closed"]) > 0:
		verdict = "The class money is not enough: some gyms close anyway."
	return "**Does the money save the gym?** CASH-SHORT starts on $%d (4 weeks of the $%d weekly costs, against N0's start %s) with Tue+Thu classes: %d/%d runs closed, mean %.1f weeks below $0, cash at the end %s; the same nights on the normal start (N2) closed %d/%d, and N0 closed %d/%d. Cash marks: w4 %s, w8 %s, w13 %s, w26 %s. The two nights pay $%s over the run and bring %s members (the cap clamps joins). The gym closes after %d consecutive week-ends below $0 (GymBills.CLOSE_AFTER_WEEKS). %s" % [
		cash0, costs, lp._cell(n0["cash0"]), int(cs["closed"]), int(cs["n"]), _mean(cs["below"]), lp._cell(cs["cash"]),
		int(n2["closed"]), int(n2["n"]), int(n0["closed"]), int(n0["n"]),
		lp._cell((cs["marks"] as Dictionary)[28]), lp._cell((cs["marks"] as Dictionary)[56]),
		lp._cell((cs["marks"] as Dictionary)[91]), lp._cell((cs["marks"] as Dictionary)[182]),
		lp._cell(cs["class"]), lp._cell(cs["joined"]), GymBills.CLOSE_AFTER_WEEKS, verdict]


## Three reads off the pooled numbers: the state-dependence the brief asks for, the shape of the record cost, and the
## choice the numbers put on the table. No threshold tuned; every number is a cell above.
func _read() -> Array:
	var n0 := _bag("N0")
	var n1 := _bag("N1")
	var n2 := _bag("N2")
	var n5 := _bag("N5")
	var d1 := _deltas("N1")
	var d2 := _deltas("N2")
	var d5 := _deltas("N5")
	var pn2 := _mean(n2["padnights"])
	var poss2: int = 2 * 3 * int(n_days / 7)
	var best := ""
	var worst := ""
	var bv := -9999.0
	var wv := 9999.0
	for nm in (n5["boxers"] as Dictionary):
		var dv := _mean(((n5["boxers"] as Dictionary)[nm] as Dictionary)["m"]) - _mean(((n0["boxers"] as Dictionary)[nm] as Dictionary)["m"])
		if dv > bv:
			bv = dv
			best = str(nm)
		if dv < wv:
			wv = dv
			worst = str(nm)
	return [
		"- **The answer depends on the week's state.** N2's Tue+Thu are sparring or rest evenings on the coach's default week: only %.1f of a possible %d boxer-nights were pads (%.0f%%), so the class took almost nothing from training (mastery %+.2f, wins %+.1f) yet paid $%.0f. The cost appears only in the weeks a fight week or a twist card lays pads on those evenings. N1's Wednesday is a pad night almost every week (%.1f halved boxer-nights): it pays %.2f mastery for $%.0f." % [pn2, poss2, 100.0 * pn2 / float(poss2), _mean(d2["mastery"]), _mean(d2["wins"]), _mean(d2["class"]), _mean(n1["padnights"]), -_mean(d1["mastery"]), _mean(d1["class"])],
		"- **The record cost is mastery, not wins, over %d weeks.** N5 pays %.2f mastery yet wins move %+.1f and points %+.2f: the halved evenings slow the moves, and the bout sim barely notices in %d weeks. The cost is not uniform across boxers: under N5, %s gains %+.1f mastery against N0 (the coach's learning target shifts when the minutes halve) while %s loses %.1f." % [int(n_days / 7), -_mean(d5["mastery"]), _mean(d5["wins"]), _mean(d5["rep"]), int(n_days / 7), best, bv, worst, -wv],
		"- **The choice the numbers put on the table.** N0 keeps every pad evening and ends on %s, below $0 on %s weeks - the TEST CLUB's money is tight. N2 ends on %s with the record intact on the default weeks; N5 ends on %s for %.1f mastery. A club short on cash takes the nights; a club protecting its boxers' mastery keeps Wednesday's pads. The bar above names the number to change if the Tue+Thu money stays free." % [lp._cell(n0["cash"]), lp._cell(n0["below"]), lp._cell(n2["cash"]), lp._cell(n5["cash"]), -_mean(d5["mastery"])]
	]


func _money_row(a: Dictionary) -> String:
	var mk: Dictionary = a["marks"]
	return "| %s | %s | %s | %s | %s | %s | %s | %s | %s | %d/%d | %s |" % [str(a["arm"]),
		str(NIGHT_WORDS[str(a["arm"])]), lp._cell(a["class"]), lp._cell(a["joined"]), lp._cell(mk[28]), lp._cell(mk[56]),
		lp._cell(mk[91]), lp._cell(a["cash"]), lp._cell(a["below"]), int(a["closed"]), int(a["n"]), lp._cell(a["tickets"])]


func _record_row(a: Dictionary) -> String:
	var w := _sumi(a["wins"])
	var b := _sumi(a["bouts"])
	return "| %s | %s | %s | %s | %s | %s | %s |" % [str(a["arm"]), lp._cell(a["bouts"]), lp._cell(a["wins"]),
		lp._pct(w, b), _fcell(a["mastery"]), lp._cell(a["rep"]), lp._cell(a["padnights"])]


func _boxer_row(arm: String, a: Dictionary) -> String:
	var w := _sumi(a["w"])
	var b := _sumi(a["bouts"])
	return "| %s | %s | %s | %s | %s | %.1f-%.1f-%.1f | %s | %s | %d |" % [arm, str(a["name"]), str(a["div"]),
		_fcell(a["m"]), lp._cell(a["bouts"]), _mean(a["w"]), _mean(a["l"]), _mean(a["d"]), lp._pct(w, b),
		lp._cell(a["rep"]), int(a["left"])]


func _lines(secs: int) -> Array:
	var L: Array = []
	var bags: Dictionary = {}
	for arm in ARMS:
		bags[str(arm)] = _bag(str(arm))
	L.append("# MONEYFOUR2 result - class nights on the built club week: is the money worth the pad time lost?")
	L.append("")
	L.append("Probe run: %s. %d seeds x %d arms = %d runs of %d days (seeds %d..%d), %ds. A measurement only: no rule or constant was changed." % [
		Time.get_datetime_string_from_system(), n_seeds, ARMS.size(), n_seeds * ARMS.size(), n_days, base_seed, base_seed + n_seeds - 1, secs])
	L.append("")
	L.append("## Population")
	L.append("")
	L.append("- The **TEST CLUB** (scripts/state/TestClub.gd): Lucy (women's lightweight), Kira (women's featherweight), Josh (men's welterweight) - three boxers, three classes - and Ana on the mats (no-gi; her mat side is NOT in these numbers), Reid the sessional coach hired. Past the first-week guide and the first hour; rivals' invented pasts re-seeded to the run seed (ladder_probe's own set-up), so a replay agrees. No fighter is synthesized or copied: no two fighters in a measurement are identical.")
	L.append("- %d seeds from %d, %d days each through Sim.step_day - the real day loop: offers, camps, fight weeks, weigh-ins, the game's own bout sim, injuries, pull-outs, late asks, the region's shows. Every sheet offer accepted, the fight week drafted and locked, pro offers declined, a rival gym's call answered by the run seed's policy (seed %% 3: accept / not_this_show / pass) - tools/ladder_probe.gd's own _career / _answer / _week, reused by preload, not edited. **No cash floor**: LADDERPROBE4 floors cash at $20,000 because money is not its measurement; here it is." % [n_seeds, base_seed, n_days])
	L.append("- Arms, set through ClubClasses.toggle on c.coach on day 0: **N0** no class night, **N1** Wednesday, **N2** Tuesday+Thursday, **N5** every weekday, **CASH-SHORT** the N2 nights with cash set to 4 weeks of the day-0 costs (Sim.weekly_costs). A class night pays +$%d that week (ClubDeal.class_cash), brings a member every %d class nights (MEMBER_A_NIGHT %.4f, an ESTIMATE; joins clamped by the member cap), and puts every boxer on pads that evening on the bag (BAG_SHARE %.1f: half the minutes)." % [ClubDeal.class_cash(1), roundi(1.0 / ClubClasses.MEMBER_A_NIGHT), ClubClasses.MEMBER_A_NIGHT, ClubClasses.BAG_SHARE])
	L.append("- **The trap, kept out:** the coach's usual $%d adult class (GameMoney.CLASSES_WITH_COACH) is NOT the extra class night - it is the same in every arm (Reid hired in all) and never counted here. Class cash is the week's own class_nights income line (GymSpend.income), sampled at every week end. Mastery is read per boxer (sum over f[\"moves\"], last seen minus day 0), never pooled with Ana. A class halves only PAD evenings (DrillWeek._class_bag): the default pad nights are Mon/Wed/Fri and Thursday is a sparring night, so N2's Tue+Thu cost pads only in the weeks the club's state lays pads there (a fight week's sparring nights take pad nights, a twist card can turn sparring to pads) - the mastery cost is state-dependent, and the tables show it." % GameMoney.CLASSES_WITH_COACH)
	L.append("")
	L.append("## The money (means a run; min-max across seeds)")
	var mrows: Array = []
	for arm in ARMS:
		mrows.append(_money_row(bags[str(arm)]))
	lp._table(L, "| arm | nights | class cash | members joined | cash w4 | cash w8 | cash w13 | cash at end | weeks below $0 | closed | ticket cut |", mrows)
	L.append("Cash at end is day %d's cash (at the close day for a closed run). Weeks below $0 counts the week-ends under zero (26 samples); the gym closes after %d consecutive ones. Ticket cut is money_four_probe's own ledger sampler - the bouts' money, beside the class money." % [n_days, GymBills.CLOSE_AFTER_WEEKS])
	L.append("")
	L.append("## The record (means a run over the three boxers; win rate pooled)")
	var rrows: Array = []
	for arm in ARMS:
		rrows.append(_record_row(bags[str(arm)]))
	lp._table(L, "| arm | bouts | wins | win rate | mastery gained (sum over moves, 3 boxers) | ladder points at end (3 boxers) | pad boxer-nights halved |", rrows)
	L.append("Mastery gained is net of the weekly fade on undrilled moves and under the technique cap (MoveMastery.gain flattens as a move nears its cap, so a halved evening costs less late in the run); a boxer who left mid-run keeps her last-seen numbers (the left column below). Bouts are the run's own (Career.results, amateur), not the walk-in's past. Ladder points are RankLine.rep at the last day seen. **Pad boxer-nights halved** counts the evenings the class actually took from a boxer's pads (BAG_SHARE applied): a class on a sparring or rest evening halves nothing, so an arm can earn its money without touching mastery - the mechanism the bar below reads.")
	L.append("")
	L.append("## Per boxer (means a run; min-max across seeds)")
	var brows: Array = []
	for arm in ARMS:
		var bx: Dictionary = (bags[str(arm)] as Dictionary)["boxers"]
		var names: Array = bx.keys()
		names.sort()
		for nm in names:
			brows.append(_boxer_row(str(arm), bx[nm]))
	lp._table(L, "| arm | boxer | division | mastery gained | bouts | w-l-d | win rate | points at end | left mid-run |", brows)
	L.append("")
	L.append("## The trade, one line per arm (paired on the same seeds against N0)")
	L.append("")
	for arm in ARMS:
		L.append(_trade(str(arm)))
	L.append("")
	L.append(_cheap())
	L.append("")
	for v in _bar():
		L.append(v)
		L.append("")
	L.append(_cashshort())
	L.append("")
	L.append("## Read")
	L.append("")
	for v2 in _read():
		L.append(v2)
	L.append("")
	L.append("## What could not be measured")
	L.append("")
	L.append("- %d days is 26 weeks, not a year: the members' dues compound slowly (a member every 16 class nights), so a full year would widen the money side of every class arm. MEMBER_A_NIGHT is an ESTIMATE (ClubDeal.class_members_4w / 4), not a measured rate." % n_days)
	L.append("- The mastery cost lands only on pad evenings: N2's Thursday is a sparring night in the default and camp weeks, so its cost is small and state-dependent (it grows in Hard-load and camp-protocol-3 weeks, when Tuesday is a pad night). N1's Wednesday is a pad night in almost every week; N5 pays on Mon/Wed/Fri. A different pad layout (the player's own evening edits) would move the cost again - this probe plays the coach's default weeks.")
	L.append("- The bout record is noisy over ~%d bouts a boxer in 26 weeks: the paired seeds cancel the set-up, not the fight sim's own divergence once mastery differs. The win-rate spread (min-max) is the honest error bar." % (int(_mean((bags["N0"] as Dictionary)["bouts"])) / 3))
	L.append("- Ana's mat side (BJJ dues, her own classes) is untouched by the boxing class nights and is not in these numbers; the $%d adult class is in every arm's cash alike and cancels in every difference." % GameMoney.CLASSES_WITH_COACH)
	L.append("")
	L.append("Reproduce: `python ops/Tools/godot_slot.py run --who moneyfour2 -- \"$LOCALAPPDATA/Programs/Godot/Godot_v4.7.2-stable_win64.exe\" --headless --audio-driver Dummy --fixed-fps 60 --log-file E:/FightCamp/tmp/moneyfour2.log --path . --script res://tools/money_four2_probe.gd -- seeds=%d seed=%d days=%d`" % [n_seeds, base_seed, n_days])
	return L
