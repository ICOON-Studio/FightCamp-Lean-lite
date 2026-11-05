extends SceneTree
## GAMETREE1 (S384) the headless calibration of Ana's game tree: design 10.2 stage-1 bars 1-8, 11, 13, 14 and 16, each
## printed with its value and PASS/FAIL. Seeded: the same arguments print the same table. Every [T] value of design 10.5
## lives in BjjTree.T / BjjOpp.T and can be set from the command line, so a tuning pass needs no code edit:
##   godot --headless --path . --script res://tools/bjj_tree_balance.gd -- [seeds=400] [seeds_1d=2000] [bars=1,3,6] [KEY=v]
##   KEY = a BjjTree.T / BjjOpp.T key; a range as lo:hi (OWNED_M=30:50) or one end (OWNED_M.x=28).
##   sweep=KEY:v1,v2       the table once per value
##   search=N space=KEY:lo:hi,...   N seeded random points in the box, each scored by its summed out-of-band distance
## Populations (tools/bjj_tree_tally.gd): Ana = NoGi.athlete(); the white field = BjjOpp.field(Ana, a plain open, seed)
## (bars 1, 2, 7, 11); the even fields = two BjjOpp.generate athletes of one belt (bars 3-8, 16; "white" in 3 and 4 =
## an even white field, like the brown one). tests/bjj_tree_sim_test.gd asserts the same bars.

const BjjTree := preload("res://scripts/rules/BjjTree.gd")
const BjjOpp := preload("res://scripts/rules/BjjOpp.gd")
const BjjOpen := preload("res://scripts/rules/BjjOpen.gd")
const NoGi := preload("res://scripts/rules/NoGi.gd")
const BeltRoad := preload("res://scripts/rules/BeltRoad.gd")
const Tally := preload("res://tools/bjj_tree_tally.gd")

const SHARES := [0.25, 0.5, 0.64, 1.0]
const SEEDS_1D := 2000


func _initialize() -> void:
	var cfg := {"seeds": 400, "bars": [], "seeds_1d": SEEDS_1D}
	var sweep := ""
	var search := 0
	var space := ""
	for a in OS.get_cmdline_user_args():
		var k := str(a).get_slice("=", 0)
		var v := str(a).get_slice("=", 1)
		match k:
			"seeds":
				cfg["seeds"] = int(v)
			"seeds_1d":
				cfg["seeds_1d"] = int(v)
			"bars":
				cfg["bars"] = Array(v.split(","))
			"sweep":
				sweep = v
			"search":
				search = int(v)
			"space":
				space = v
			_:
				if not set_value(k, v):
					push_error("unknown tuning key %s" % k)
	if search > 0:
		_search(cfg, search, space)
	elif sweep != "":
		for v in sweep.get_slice(":", 1).split(","):
			set_value(sweep.get_slice(":", 0), v)
			print("== %s = %s" % [sweep.get_slice(":", 0), v])
			print_table(run(cfg))
	else:
		print("TUNING %s %s" % [str(BjjTree.T), str(BjjOpp.T)])
		print_table(run(cfg))
	quit(0)


## Sets a BjjTree.T / BjjOpp.T key from text ("30:50" a range, KEY.x / KEY.y one end). False for an unknown key.
static func set_value(k: String, v: String) -> bool:
	var key := k.get_slice(".", 0)
	for t in [BjjTree.T, BjjOpp.T]:
		if not (t as Dictionary).has(key):
			continue
		var old: Variant = t[key]
		if old is Vector2:
			var r: Vector2 = old
			if k.ends_with(".x"):
				r.x = float(v)
			elif k.ends_with(".y"):
				r.y = float(v)
			else:
				r = Vector2(float(v.get_slice(":", 0)), float(v.get_slice(":", 1)))
			t[key] = r
		elif old is int:
			t[key] = int(round(float(v)))
		else:
			t[key] = float(v)
		return true
	return false


static func _search(cfg: Dictionary, n: int, space: String) -> void:
	var dims: Array = []
	for d in space.split(","):
		dims.append([d.get_slice(":", 0), float(d.get_slice(":", 1)), float(d.get_slice(":", 2))])
	var base_t := BjjTree.T.duplicate()
	var base_o := BjjOpp.T.duplicate()
	var r := RandomNumberGenerator.new()
	r.seed = 384
	var best: Array = []
	for i in n:
		BjjTree.T = base_t.duplicate()
		BjjOpp.T = base_o.duplicate()
		var pt: Array = []
		for d in dims:
			var v := snappedf(r.randf_range(float(d[1]), float(d[2])), 0.01)
			set_value(str(d[0]), str(v))
			pt.append("%s=%s" % [d[0], v])
		var rows := run(cfg)
		var tot := 0.0
		var ok := 0
		for row in rows:
			tot += float(row["d"])
			ok += 1 if row["pass"] else 0
		var fails := rows.filter(func(x): return not x["pass"]).map(func(x): return str(x["bar"]))
		var vals := " | ".join(rows.map(func(x): return "%s=%s" % [x["bar"], x["value"]]))
		print("S %3d dist %6.2f pass %d/%d  %s  fails %s  || %s" % [i, tot, ok, rows.size(), " ".join(pt), ",".join(fails), vals])
		best.append([tot, " ".join(pt)])
	best.sort_custom(func(x, y): return float(x[0]) < float(y[0]))
	for b in best.slice(0, 5):
		print("BEST %.2f %s" % [b[0], b[1]])


static func print_table(rows: Array) -> void:
	var fails := 0
	for r in rows:
		print("BAR %-4s %-62s %-30s %s" % [r["bar"], r["name"], r["value"], "PASS" if r["pass"] else "FAIL"])
		fails += 0 if r["pass"] else 1
	print("BJJ_TREE_BALANCE %s (%d of %d bars fail)" % ["PASS" if fails == 0 else "FAIL", fails, rows.size()])


static func _want(cfg: Dictionary, bar: String) -> bool:
	var b: Array = cfg.get("bars", [])
	return b.is_empty() or b.has(bar) or b.has(bar.rstrip("abcd"))


## A bar row; d = how far outside its band (0 inside), in band widths, for the search.
static func _row(bar: String, name: String, value: String, ok: bool, d: float = -1.0) -> Dictionary:
	return {"bar": bar, "name": name, "value": value, "pass": ok, "d": (0.0 if ok else 1.0) if d < 0.0 else d}


static func _in(x: float, lo: float, hi: float) -> bool:
	return x >= lo and x <= hi


static func _d(x: float, lo: float, hi: float) -> float:
	if x < lo:
		return (lo - x) / maxf(0.01, hi - lo)
	return (x - hi) / maxf(0.01, hi - lo) if x > hi else 0.0


## Every stage-1 bar as rows {bar, name, value, pass, d}. cfg: seeds (400), seeds_1d (2,000; 0 skips 1d), bars ([] = all).
static func run(cfg: Dictionary) -> Array:
	var n := int(cfg.get("seeds", 400))
	var rows: Array = []
	var ana := NoGi.athlete()
	var wc := NoGi.win_chance(ana, 0)
	var wf: Array = []
	var wopps: Array = []
	var wt := {}
	if _want(cfg, "1a") or _want(cfg, "1c") or _want(cfg, "7") or _want(cfg, "11"):
		var got := Tally.white_field(ana, n)
		wf = got[0]
		wopps = got[1]
		wt = Tally.tally(wf)
	var p := Tally.win_rate(wf)
	if _want(cfg, "1a"):
		rows.append(_row("1a", "Ana per-bout win vs a white field 0.49-0.59 (win_chance %.3f)" % wc, "%.3f" % p,
			_in(p, 0.49, 0.59) and absf(p - wc) <= 0.05, _d(p, maxf(0.49, wc - 0.05), minf(0.59, wc + 0.05))))
	if _want(cfg, "1c"):
		var hi := ana.duplicate(true)
		hi["morale"] = 100
		var lo := ana.duplicate(true)
		lo["morale"] = 20
		var dh := Tally.win_rate(Tally.white_field(hi, n)[0]) - p
		var dl := Tally.win_rate(Tally.white_field(lo, n)[0]) - p
		rows.append(_row("1c", "morale 100 / 20 moves the win +-0.10 (+-0.03)", "%+.3f / %+.3f" % [dh, dl],
			_in(dh, 0.07, 0.13) and _in(dl, -0.13, -0.07), _d(dh, 0.07, 0.13) + _d(dl, -0.13, -0.07)))
	if _want(cfg, "1b"):
		var wins := 0
		var golds := 0
		for s in n:
			var r := RandomNumberGenerator.new()
			r.seed = s
			var res := BjjOpen.run_open(ana, Tally.plain_open(), 33, r)
			wins += int(res["wins"])
			golds += 1 if str(res["medal"]) == "gold" else 0
		var mean := float(wins) / n
		var g400 := golds * 400.0 / n
		rows.append(_row("1b", "open mean wins 0.7-1.4, golds 40-120 per 400", "%.2f / %.0f" % [mean, g400],
			_in(mean, 0.7, 1.4) and _in(g400, 40, 120), _d(mean, 0.7, 1.4) + _d(g400, 40, 120)))
	if _want(cfg, "1d") and int(cfg.get("seeds_1d", SEEDS_1D)) > 0:
		var worst := 0.0
		var txt: Array = []
		var m := int(cfg.get("seeds_1d", SEEDS_1D))
		for sh in SHARES:
			var f := Tally.ana_at(sh)
			var pt := Tally.win_rate(Tally.white_field(f, m / 3, 5000)[0])
			var c := NoGi.win_chance(f, 0)
			worst = maxf(worst, absf(pt - c))
			txt.append("%.2f:%.3f/%.3f" % [sh, pt, c])
		rows.append(_row("1d", "|tree - win_chance| <= 0.05 (%d bouts a share) %s" % [m - m % 3, " ".join(txt)], "worst %.3f" % worst,
			worst <= 0.05, maxf(0.0, worst - 0.05) / 0.05))
	if _want(cfg, "2"):
		rows.append(bar2())
	var bt := {}
	var we := {}
	if _want(cfg, "3") or _want(cfg, "4") or _want(cfg, "5") or _want(cfg, "6") or _want(cfg, "7"):
		bt = Tally.tally(Tally.even_field("brown", n))
	if _want(cfg, "3") or _want(cfg, "4"):
		we = Tally.tally(Tally.even_field("white", n))
	if _want(cfg, "3"):
		rows.append_array(bar3(bt, we))
	if _want(cfg, "4"):
		var pm := float(bt["sub_att"]) / maxf(1.0, float(bt["secs"]) / 60.0)
		var pb := float(we["sub_att"]) / float(we["bouts"])
		rows.append(_row("4a", "brown sub attempts a minute 0.5-0.75", "%.3f" % pm, _in(pm, 0.5, 0.75), _d(pm, 0.5, 0.75)))
		rows.append(_row("4b", "white even 5 min: sub attempts a bout 2-4", "%.2f" % pb, _in(pb, 2.0, 4.0), _d(pb, 2.0, 4.0)))
	if _want(cfg, "5"):
		var k: Dictionary = bt["kinds"]
		var mp := float(k.get("mount", 0)) / maxf(1.0, float(k.get("pass", 0)))
		var top_ok := Tally.top(k) == "back"
		rows.append(_row("5", "brown scoring: back takes most; mount/pass 0.3-0.7", "%s %.2f" % [Tally.top(k), mp],
			top_ok and _in(mp, 0.3, 0.7), (0.0 if top_ok else 1.0) + _d(mp, 0.3, 0.7)))
	if _want(cfg, "6"):
		var v := [Tally.conv(bt, "back_top"), Tally.conv(bt, "saddle_attack"), Tally.conv(bt, "fifty_fifty"), Tally.conv(bt, "mount_top"),
			Tally.conv(bt, "side_control_top"), Tally.conv(bt, "knee_on_belly_top")]
		var bands := [[0.30, 0.40], [0.14, 0.21], [0.14, 0.21], [0.07, 0.12], [0.02, 0.07], [0.0, 0.03]]
		var d6 := 0.0
		for i in v.size():
			d6 += _d(float(v[i]), float(bands[i][0]), float(bands[i][1]))
		rows.append(_row("6", "conv back .30-.40 saddle,50-50 .14-.21 mount .07-.12 side .02-.07 kob <.03",
			"%.2f %.2f %.2f %.2f %.2f %.2f" % v, d6 == 0.0, d6))
	if _want(cfg, "7"):
		var ln := int(bt["lead_n"]) + int(wt["lead_n"])
		var lt := float(int(bt["lead_tapped"]) + int(wt["lead_tapped"])) / maxf(1.0, ln)
		rows.append(_row("7", "late lead: the leader tapped in the last minute <= 0.15", "%.3f of %d" % [lt, ln], lt <= 0.15, _d(lt, 0.0, 0.15)))
	if _want(cfg, "8"):
		var kt := Tally.tally(Tally.even_field("black", n, 10))
		var ft: Dictionary = kt["fin_t"]
		var legs := float(ft["legs"][0]) / maxf(1.0, float(ft["legs"][1]))
		var chokes := float(ft["chokes"][0]) / maxf(1.0, float(ft["chokes"][1]))
		var all_t := (float(ft["legs"][0]) + float(ft["chokes"][0]) + float(ft["arms"][0])) / maxf(1.0, float(kt["subs"])) / 60.0
		var ratio := legs / maxf(1.0, chokes)
		rows.append(_row("8", "black 10 min: legs/chokes mean time 0.5-0.75, sub mean 6-9 min", "%.2f %.1f min" % [ratio, all_t],
			_in(ratio, 0.5, 0.75) and _in(all_t, 6.0, 9.0), _d(ratio, 0.5, 0.75) + _d(all_t, 6.0, 9.0)))
	if _want(cfg, "11"):
		rows.append_array(bar11(wt, wf, wopps, ana))
	if _want(cfg, "13"):
		rows.append(bar13())
	if _want(cfg, "14"):
		rows.append(bar14())
	if _want(cfg, "16"):
		var bl := Tally.tally(Tally.even_field("blue", n))
		var fw := float(bl["first_won"]) / maxf(1.0, float(bl["first_n"]))
		rows.append(_row("16", "blue even: the first scorer wins 0.80-0.87", "%.3f" % fw, _in(fw, 0.80, 0.87), _d(fw, 0.80, 0.87)))
	return rows


## Bar 2: 200 walks against her next field; holes ranked by points lost + TAP_VALUE x taps.
static func bar2() -> Dictionary:
	var f := NoGi.athlete()
	var rules := BjjTree.rules_for("white")
	var plan := BjjTree.plan_of(f, rules)
	var o: Dictionary = NoGi.opens_after(1, 1)[0]
	var visits := {}
	for s in 200:
		var opp: Dictionary = BjjOpp.field(f, o, 1000 + s)[s % 3]
		var w := Tally.walk(f, opp, [plan, Tally.steps(opp)], int(rules["minutes"]), rules, Tally.rng(s, "leak"))
		for k in w["visits"]:
			var v: Array = visits.get_or_add(k, [0, 0, 0])
			for i in 3:
				v[i] += int(w["visits"][k][i])
	var cost := {}
	var seen := 0
	for h in BjjTree.holes(f, rules):
		if visits.has(h):
			seen += 1
			var c := float(visits[h][1]) + float(BjjTree.T["TAP_VALUE"]) * float(visits[h][2])
			if c > 0.0:
				cost[h] = c
	var ranked: Array = cost.keys()
	ranked.sort_custom(func(x, y): return float(cost[x]) > float(cost[y]))
	var top3 := ranked.slice(0, 3)
	var back := top3.has("back_top") or top3.has("back_bottom")
	return _row("2", "Ana's leaks: top 3 has the back; holes visited 6-14", "%s %d" % [",".join(top3), seen], back and _in(seen, 6, 14),
		(0.0 if back else 1.0) + _d(seen, 6, 14))


## Bar 3: how even brown bouts end (FloGrappling No-Gi Worlds 2022 women brown/black) and even white bouts.
static func bar3(bt: Dictionary, wt: Dictionary) -> Array:
	var rows: Array = []
	var sr := float(bt["subs"]) / float(bt["bouts"])
	var ch := Tally.share(bt, Tally.CHOKES)
	var ar := Tally.share(bt, Tally.ARMS)
	var lg := Tally.share(bt, Tally.LEGS)
	rows.append(_row("3a", "brown even: sub rate 0.45-0.60", "%.3f" % sr, _in(sr, 0.45, 0.60), _d(sr, 0.45, 0.60)))
	var d3 := _d(ch, 0.40, 0.55) + _d(ar, 0.24, 0.36) + _d(lg, 0.19, 0.31)
	rows.append(_row("3b", "brown finishes: chokes .40-.55 arms .24-.36 legs .19-.31", "%.2f/%.2f/%.2f" % [ch, ar, lg], d3 == 0.0, d3))
	var tb := Tally.top(bt["finish"])
	rows.append(_row("3c", "brown top single finish = rear naked choke", tb, tb == "rear_naked_choke"))
	var ws := float(wt["subs"]) / float(wt["bouts"])
	var tw := Tally.top(wt["finish"])
	rows.append(_row("3d", "white even: sub rate 0.30-0.55, RNC the top finish", "%.3f %s" % [ws, tw],
		_in(ws, 0.30, 0.55) and tw == "rear_naked_choke", _d(ws, 0.30, 0.55) + (0.0 if tw == "rear_naked_choke" else 1.0)))
	return rows


## Bar 11: misses rarely land in a 3+ node; variety per opponent; styles open in character; pulls 35-60% and land.
static func bar11(wt: Dictionary, wf: Array, wopps: Array, ana: Dictionary) -> Array:
	var rows: Array = []
	var mb := float(wt["miss_bad"]) / maxf(1.0, float(wt["miss_n"]))
	rows.append(_row("11a", "misses that hand over 3+ points <= 0.25", "%.3f" % mb, mb <= 0.25, _d(mb, 0.0, 0.25)))
	var rules := BjjTree.rules_for("white")
	var plan := BjjTree.plan_of(ana, rules)
	var worst := 0.0
	for s in 10:
		for opp in BjjOpp.field(ana, Tally.plain_open(), 7000 + s):
			var cnt := {}
			var tot := 0
			for k in 20:
				var w := Tally.walk(ana, opp, [plan, Tally.steps(opp)], 5, rules, Tally.rng(s * 100 + k, "var"))
				for p in w["path"]:
					if int(p[1]) == 1 and not BjjTree.is_base(str(BjjTree.edge(str(p[0]))["move"])):
						cnt[p[0]] = int(cnt.get(p[0], 0)) + 1
						tot += 1
			if tot > 0:
				worst = maxf(worst, float(cnt[Tally.top(cnt)]) / tot)
	rows.append(_row("11b", "no edge > 0.50 of one opponent's attempts (30 x 20 bouts)", "max %.3f" % worst, worst <= 0.50, _d(worst, 0.0, 0.5)))
	var st := {}
	for i in wf.size():
		var s: Array = st.get_or_add(str((wopps[i] as Dictionary).get("style", "")), [0, 0, 0])
		for b in Tally.replay(wf[i]):
			if int(b["s"]) == 1 and str(b["from"]) == "standing":
				var mv := str(b["e"]["move"])
				s[0] += 1
				s[1] += 1 if Tally.TAKEDOWNS.has(mv) else 0
				s[2] += 1 if mv == "guard_pull" else 0
				break
	var wr: Array = st.get("Wrestler", [0, 0, 0])
	var gp: Array = st.get("Guard player", [0, 0, 0])
	var wtd := float(wr[1]) / maxf(1.0, float(wr[0]))
	var gpp := float(gp[2]) / maxf(1.0, float(gp[0]))
	var pull := float(wt["open_pull"]) / maxf(1.0, float(wt["open_n"]))
	var land := float(wt["pull_hit"]) / maxf(1.0, float(wt["pull_n"]))
	rows.append(_row("11c", "Wrestler shoots >= .60, Guard player pulls >= .50, pulls .35-.60 of openings, land >= .90",
		"%.2f %.2f %.2f %.2f" % [wtd, gpp, pull, land], wtd >= 0.60 and gpp >= 0.50 and _in(pull, 0.35, 0.60) and land >= 0.90,
		_d(wtd, 0.6, 1.0) + _d(gpp, 0.5, 1.0) + _d(pull, 0.35, 0.60) + _d(land, 0.9, 1.0)))
	return rows


## Bar 13: weeks to gain 3 drill weeks' worth at 0, 1 and 2 belts ahead (exactly 1x / 2x / 4x); readiness untouched.
static func bar13() -> Dictionary:
	var plans := ["", "ahead:de_la_riva", "ahead:kneebar"]
	for id in BjjTree.data()["moves"]:
		var m := BjjTree.move(id)
		if plans[0] == "" and str(m["src"]) == "tree" and str(m["belt"]) == "white":
			plans[0] = "tree:" + str(id)
	var weeks: Array = []
	var same := true
	for plan in plans:
		var f := NoGi.athlete()
		f["drill"] = plan
		var t := BjjTree.drill_target(f, plan)
		var key := str(t["store"])
		var mv := str(t["move"])
		var start := float((f.get_or_add(key, {}) as Dictionary).get(mv, 0.0))
		var r0 := BeltRoad.readiness(f, f["bjj"], 0)
		var k := 0
		while float((f[key] as Dictionary).get(mv, 0.0)) < start + 3.0 * NoGi.DRILL_GAIN - 0.001 and k < 100:
			BjjTree.week(f, 0)
			k += 1
		var g := NoGi.athlete()
		g["mat_classes"] = int(g["mat_classes"]) + k * NoGi.classes_of(g)
		var r1 := BeltRoad.readiness(f, f["bjj"], 0)
		var r2 := BeltRoad.readiness(g, g["bjj"], 0)
		same = same and str(r1["moves"]) == str(r0["moves"]) and is_equal_approx(float(r1["share"]), float(r2["share"]))
		weeks.append(k)
	var ok := int(weeks[1]) == 2 * int(weeks[0]) and int(weeks[2]) == 4 * int(weeks[0]) and same
	return _row("13", "ahead drilling: weeks 1x / 2x / 4x, readiness at her belt unchanged", "%s %s" % [str(weeks), "same" if same else "MOVED"], ok)


## Bar 14: Ana's first 40 weeks, the coach's pick (her belt's move closest to its next step, FELT or 30); a new felt or
## owned arrow every 2-4 weeks on average, no gap over 5 (the tail counts); a gym roll in 15-20 weeks (every open entered).
static func bar14() -> Dictionary:
	var c := Career.new()
	c.seed = 11
	var f := NoGi.athlete()
	var event_weeks: Array = []
	var rolls := 0
	var felt := float(BjjTree.T["FELT"])
	for w in 40:
		c.day = 7 * w + 6
		var lv := BjjTree.levels(f)
		var pick := ""
		var gap := 1e9
		for id in lv:
			var m := float(lv[id])
			if str(BjjTree.move(id)["belt"]) != str(f["belt"]) or m >= BeltRoad.OWNED_AT:
				continue
			var d := (felt if m < felt else BeltRoad.OWNED_AT) - m
			if d < gap:
				gap = d
				pick = id
		if pick != "":
			f["drill"] = ("tree:" if str(BjjTree.move(pick)["src"]) == "tree" else "move:") + pick
		if BjjTree.is_tree_plan(str(f.get("drill", ""))) and not BjjTree.drill_target(f, str(f["drill"])).is_empty():
			BjjTree.week(f, c.day)
		else:
			NoGi.week(f, c.day)
		if not NoGi.open_on(c.day - 1).is_empty():
			f["open_week"] = {}
		if not BjjOpen.roll_week(c, f).is_empty():
			rolls += 1
		f.erase("open_week")
		var now := BjjTree.levels(f)
		for id in now:
			var a := BjjTree.state(float(lv[id]))
			var b := BjjTree.state(float(now[id]))
			if a != b and (b == "felt" or b == "owned"):
				event_weeks.append(w + 1)
				break
	var max_gap := 0
	var prev := 0
	for w in event_weeks:
		max_gap = maxi(max_gap, int(w) - prev)
		prev = int(w)
	max_gap = maxi(max_gap, 40 - prev)
	var mean := 40.0 / maxf(1.0, event_weeks.size())
	return _row("14", "pace: an arrow every 2-4 weeks, gap <= 5; rolls in 15-20 of 40", "%.2f gap %d rolls %d" % [mean, max_gap, rolls],
		_in(mean, 2.0, 4.0) and max_gap <= 5 and _in(rolls, 15, 20), _d(mean, 2.0, 4.0) + _d(max_gap, 0, 5) + _d(rolls, 15, 20))
