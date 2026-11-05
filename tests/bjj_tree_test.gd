extends SceneTree
## GAMETREE1 (S384) Ana's game tree, stage 1 (design 10.1). Population: the shipped graph (assets/data/bjj_tree.json), Ana
## (NoGi.athlete(): white, 130 classes) and seeded white fields from BjjOpp.
##   1. the map: 47 positions + 2 endings, mirror an involution, every edge's nodes exist, all reachable from standing, no
##      dead end; 42 syllabus ids on edges; every contested edge answered by moves; film ids are graph.json transitions;
##      routes chain; frozen edge ids e001-e135; pronoun-clean; a legality row per move.
##   2. Ana's start (golden): 9 owned moves / 22 edges, 23 felt / 33, 2 learning / 6, 28 holes; white tree moves at 19.5.
##   3. the walk: same seed = same walk; a miss against nobody's answer never leaves the node; how strings in NoGi's format;
##      no illegal edge at a white open; learning moves never tried; rows keep d/open/win/opp/how; old rows read.
##   4. the field: seeded, white bands 8-12, go-to routes legal at the belt, iq by belt, Marta is on neither name list.
##   5. the week: tree:/ahead: drill on the tree at the FLOW rate (one belt ahead x0.5, two x0.25), move: still NoGi.week,
##      mat_classes still grows; ahead drilling leaves readiness at her belt untouched.
##   6. the gym roll: every 2nd Sunday, not in an open week; never morale / w-l / opens / film; the partner gains class time
##      only; a newly felt move is tried once and named; 6 rolls kept. The week report row carries the tree's keys.

const FirstWeek := preload("res://scripts/rules/FirstWeek.gd")
const BjjTree := preload("res://scripts/rules/BjjTree.gd")
const BjjWalk := preload("res://scripts/rules/BjjWalk.gd")
const BjjOpp := preload("res://scripts/rules/BjjOpp.gd")
const BjjOpen := preload("res://scripts/rules/BjjOpen.gd")
const NoGi := preload("res://scripts/rules/NoGi.gd")
const BeltRoad := preload("res://scripts/rules/BeltRoad.gd")
const Grapplers := preload("res://scripts/state/Grapplers.gd")
const Graph := preload("res://scripts/grapple/GrappleGraph.gd")

const HOW := "^(submission \\([a-z' -]+\\) \\d+:\\d\\d|points \\d+-\\d+(, advantages \\d+-\\d+(, referee decision)?)?)$"
const PRONOUN := "(?i)\\b(she|her|hers|herself)\\b"

var _fails := 0
var _pron := RegEx.create_from_string(PRONOUN)


func _initialize() -> void:
	BjjTree.reset_tuning()
	BjjOpp.reset_tuning()
	_map()
	_start()
	_walks()
	_field()
	_week()
	_rolls()
	_report()
	print("BJJ_TREE %s failures=%d" % ["PASS" if _fails == 0 else "FAIL", _fails])
	quit(0 if _fails == 0 else 1)


func _map() -> void:
	var d := BjjTree.data()
	var nodes: Dictionary = d["nodes"]
	var positions := nodes.keys().filter(func(id): return not BjjTree.is_ending(id))
	_check(positions.size() == 47 and nodes.has("tap_win") and nodes.has("tap_loss"), "47 positions + 2 endings (%d)" % positions.size())
	_check(nodes.keys().all(func(id): return BjjTree.mirror(BjjTree.mirror(id)) == id and nodes.has(BjjTree.mirror(id))), "mirror is an involution")
	var bad_refs: Array = []
	for id in d["edge_ids"]:
		var e := BjjTree.edge(id)
		for k in ["from", "ok", "bad"]:
			if not nodes.has(str(e[k])):
				bad_refs.append("%s.%s" % [id, k])
		if BjjTree.move(str(e["move"])).is_empty():
			bad_refs.append("%s.move" % id)
	_check(bad_refs.is_empty(), "every edge's from/ok/bad/move exists %s" % str(bad_refs))
	var seen := {"standing": true}
	var q: Array = ["standing"]
	while not q.is_empty():
		var x: String = q.pop_front()
		var nxt: Array = [BjjTree.mirror(x)]
		for e in BjjTree.edges_from(x):
			nxt.append(str(e["ok"]))
			nxt.append(str(e["bad"]))
		for n in nxt:
			if not seen.has(n):
				seen[n] = true
				q.append(n)
	_check(nodes.keys().all(func(id): return seen.has(id)), "every node reachable from standing (%d of %d)" % [seen.size(), nodes.size()])
	var dead := positions.filter(func(id): return BjjTree.edges_from(id).is_empty())
	_check(dead.is_empty(), "no dead end: every position has an out-edge %s" % str(dead))
	var syl: Array = []
	for b in BeltRoad.BELTS:
		syl.append_array(BeltRoad.moves_for(b))
	var on_edge := {}
	for id in d["edge_ids"]:
		on_edge[str(BjjTree.edge(id)["move"])] = true
	var missing := syl.filter(func(m): return not on_edge.has(m))
	_check(syl.size() == 42 and missing.is_empty(), "all 42 syllabus ids sit on an edge %s" % str(missing))
	var unanswered: Array = []
	for id in d["edge_ids"]:
		var e := BjjTree.edge(id)
		if BjjTree.is_base(str(e["move"])):
			continue
		if (e["answers"] as Array).is_empty() or not (e["answers"] as Array).all(func(a): return not BjjTree.move(str(a)).is_empty()):
			unanswered.append(id)
	_check(unanswered.is_empty(), "every contested edge has answers, every answer a move %s" % str(unanswered))
	var g := Graph.new()
	var bad_film: Array = []
	var filmed := 0
	for id in d["edge_ids"]:
		var fm: Variant = BjjTree.edge(id).get("film")
		if fm == null or (fm as Dictionary).get("transition") == null:
			continue
		filmed += 1
		var t := g.get_entry(int(fm["transition"]))
		if not t.has("frames") or not t.has("from"):
			bad_film.append(id)
	_check(filmed > 90 and bad_film.is_empty(), "every edge film id is a graph.json transition (%d filmed) %s" % [filmed, str(bad_film)])
	_check((d["routes"] as Dictionary).size() == 8 and (d["routes"] as Dictionary).keys().all(func(r): return BjjTree.route_ok(BjjTree.route(r)["steps"])),
		"8 routes, each step starts where the last landed")
	var frozen := true
	for i in range(1, 136):
		frozen = frozen and not BjjTree.edge("e%03d" % i).is_empty()
	_check(frozen, "edge ids are a superset of the frozen e001-e135")
	var hits: Array = []
	_scan(JSON.parse_string(FileAccess.get_file_as_string(BjjTree.PATH)), "", hits)
	_check(hits.is_empty(), "every string and key of bjj_tree.json is pronoun-clean %s" % str(hits))
	_check((d["moves"] as Dictionary).values().all(func(m): return BeltRoad.BELTS.has(str(m.get("ibjjf_min", "")))), "every move has its IBJJF row")


func _scan(x: Variant, path: String, hits: Array) -> void:
	if x is Dictionary:
		for k in x:
			if _pron.search(str(k)) != null:
				hits.append(path + "/" + str(k))
			_scan(x[k], path + "/" + str(k), hits)
	elif x is Array:
		for i in (x as Array).size():
			_scan(x[i], "%s[%d]" % [path, i], hits)
	elif x is String and _pron.search(x) != null:
		hits.append("%s: %s" % [path, x])


func _start() -> void:
	var f := NoGi.athlete()
	var lv := BjjTree.levels(f)
	var by := {"learning": [], "felt": [], "owned": []}
	for id in lv:
		var s := BjjTree.state(float(lv[id]))
		if s == "signature":
			s = "owned"
		var on: int = (BjjTree.data()["edge_ids"] as Array).filter(func(e): return str(BjjTree.edge(e)["move"]) == id).size()
		if on > 0 and str(BjjTree.move(id)["belt"]) == "white":   # Ana's belt; higher belts are not hers yet
			(by[s] as Array).append([id, on])
	var cnt := func(k): return [(by[k] as Array).size(), (by[k] as Array).reduce(func(a, b): return a + int(b[1]), 0)]
	_check(cnt.call("owned") == [9, 22], "Ana owns 9 moves = 22 edges %s" % str(cnt.call("owned")))
	_check(cnt.call("felt") == [23, 33], "Ana has 23 felt moves = 33 edges %s" % str(cnt.call("felt")))
	var learn: Array = (by["learning"] as Array).map(func(r): return r[0])
	learn.sort()
	_check(learn == ["guillotine", "rear_naked_choke"] and cnt.call("learning")[1] == 6, "2 learning (rear naked choke, guillotine) = 6 edges %s" % str(cnt.call("learning")))
	_check(BjjTree.holes(f, BjjTree.rules_for("white")).size() == 28, "28 of 47 positions are holes (%d)" % BjjTree.holes(f, BjjTree.rules_for("white")).size())
	var tw: Array = BjjTree.data()["moves"].keys().filter(func(id): return BjjTree.move(id)["src"] == "tree" and BjjTree.move(id)["belt"] == "white")
	_check(tw.size() == 20 and tw.all(func(id): return is_equal_approx(BjjTree.mastery(f, id), 19.5)), "every white tree move at 19.5 (30 x 130/200), %d moves" % tw.size())
	_check(is_equal_approx(BjjTree.mastery(f, "granby_roll"), 0.0) and BjjTree.mastery(f, "guard_pull") == 100.0, "a blue tree move 0 at white; BASE 100")


## A plain seeded white opponent (style by index).
func _opp(i: int) -> Dictionary:
	return BjjOpp.generate("white", str(BjjOpp.STYLE_ORDER[i % 5]), 1000 + i)


func _walk(f: Dictionary, o: Dictionary, seed: int, rules: Dictionary = {}) -> Dictionary:
	if rules.is_empty():
		rules = BjjTree.rules_for("white")
	var rng := RandomNumberGenerator.new()
	rng.seed = seed
	return BjjWalk.walk(f, o, [BjjTree.plan_of(f, rules), BjjTree.route(str(o.get("route", ""))).get("steps", [])], int(rules["minutes"]), rules, rng)


func _walks() -> void:
	var f := NoGi.athlete()
	var a := _walk(f, _opp(1), 7)
	var b := _walk(f, _opp(1), 7)
	_check(str(a["how"]) == str(b["how"]) and str(a["path"]) == str(b["path"]), "the same seed walks the same path (%s)" % a["how"])
	# Against nobody's answers (an opponent with nothing at all): a miss is always a reset, never a slide.
	var nobody := {"id": "nobody", "first": "Nobody", "belt": "white", "mat_classes": 0, "bjj": {}, "tree": {}, "route": ""}
	var slides := 0
	var tries := 0
	for s in 120:
		var w := _walk(f, nobody, 500 + s)
		for p in w["path"]:
			if int(p[1]) == 0 and not BjjTree.is_base(str(BjjTree.edge(str(p[0]))["move"])):
				tries += 1
				slides += 1 if str(p[2]) == "miss" else 0
	_check(tries >= 300 and slides == 0, "a miss against an answer at 0 never leaves the node (%d attempts, %d slides)" % [tries, slides])
	var re := RegEx.create_from_string(HOW)
	var bad_how: Array = []
	var illegal := 0
	var learning := 0
	var t0 := Time.get_ticks_usec()
	var g := f.duplicate(true)
	g["bjj"]["kneebar"] = 60.0
	g["bjj"]["toe_hold"] = 60.0
	g["bjj"]["straight_ankle_lock"] = 60.0
	var wins := 0
	var n := 2000
	for s in n:
		var w := _walk(g, _opp(s), 9000 + s)
		wins += 1 if bool(w["win"]) else 0
		if re.search(str(w["how"])) == null:
			bad_how.append(str(w["how"]))
		for p in w["path"]:
			var mv := str(BjjTree.edge(str(p[0]))["move"])
			if not BjjTree.legal(mv, BjjTree.rules_for("white")):
				illegal += 1
			if int(p[1]) == 0 and not BjjTree.is_base(mv) and not BjjTree.usable(BjjTree.mastery(g, mv)):
				learning += 1
	var ms := float(Time.get_ticks_usec() - t0) / 1000.0 / n
	print("  info %d white walks: %.2f ms a walk, Ana won %d (%.2f)" % [n, ms, wins, float(wins) / n])
	_check(bad_how.is_empty(), "every how reads like NoGi's rows %s" % str(bad_how.slice(0, 3)))
	_check(illegal == 0, "no edge above the IBJJF white table fires at a white open (kneebar and toe hold at 60): %d" % illegal)
	_check(learning == 0, "a learning move (rear naked choke 12, guillotine 9) is never tried: %d" % learning)
	var ten := BjjTree.rules_for("black")
	t0 = Time.get_ticks_usec()
	for s in 200:
		_walk(BjjOpp.generate("black", "Leg locker", s), BjjOpp.generate("black", "Wrestler", 77 + s), s, ten)
	print("  info 200 black 10-minute walks: %.2f ms a walk" % (float(Time.get_ticks_usec() - t0) / 1000.0 / 200))
	var leg := 0
	for s in 200:
		var w := _walk(BjjOpp.generate("brown", "Leg locker", s), BjjOpp.generate("brown", "Leg locker", 900 + s), s, BjjTree.rules_for("brown"))
		leg += (w["path"] as Array).filter(func(p): return BjjTree.edge(str(p[0]))["move"] in ["inside_heel_hook", "saddle_entry", "kneebar", "toe_hold"]).size()
	_check(leg > 0, "at brown the leg locks fire (%d attempts in 200 bouts)" % leg)
	# run_open: NoGi's shape, rows true.
	var o: Dictionary = NoGi.opens_after(1, 1)[0]
	var rng := RandomNumberGenerator.new()
	rng.seed = 42
	var res := BjjOpen.run_open(f, o, int(o["d"]), rng)
	var rows: Array = res["matches"]
	_check(rows.size() >= 1 and rows.size() <= 3 and int(res["wins"]) == rows.filter(func(r): return bool(r["win"])).size()
		and ["gold", "silver", "bronze", ""].has(str(res["medal"])), "run_open returns {matches, wins, medal} (%d-%d %s)" % [res["wins"], rows.size() - int(res["wins"]), res["medal"]])
	_check(rows.all(func(r): return r.has("d") and r.has("open") and r.has("win") and r.has("opp") and r.has("how") and r.has("path") and r.has("lines")),
		"rows keep d/open/win/opp/how and add path/lines")
	_check(rows.slice(0, rows.size() - 1).all(func(r): return bool(r["win"])), "the open stops at the first loss")
	var old := {"d": -16, "open": "London No-Gi Open", "win": true, "opp": "Kim Patel", "how": "points 6-2"}
	_check(BjjOpen.path_line(old, 0).contains("no attack landed"), "an old row without a path reads (%s)" % BjjOpen.path_line(old, 0))
	var all_lines: Array = []
	for s in 300:
		all_lines.append_array(BjjWalk.rule_lines(_walk(f, _opp(s), 300 + s)))
	var rules_seen := {}
	for l in all_lines:
		if _pron.search(str(l)) != null:
			_check(false, "rule line has a pronoun: %s" % l)
		for k in ["held the", "straight off", "had seen", "Morale", "felt,", "went for", "times in"]:
			if str(l).contains(k):
				rules_seen[k] = true
	print("  info rule lines seen: %s" % str(rules_seen.keys()))
	_check(rules_seen.has("felt,") and rules_seen.has("went for"), "the walk writes its rule lines (felt, EPS ...)")


func _field() -> void:
	var a := BjjOpp.generate("white", "Guard player", 5)
	_check(str(a) == str(BjjOpp.generate("white", "Guard player", 5)), "the same seed draws the same opponent")
	var lo := 99
	var hi := 0
	var routes := {}
	var out_of_range := 0
	var pron := 0
	for s in 200:
		var o := BjjOpp.generate("white", str(BjjOpp.STYLE_ORDER[s % 5]), s)
		var n := BjjOpp.count_owned(o)
		lo = mini(lo, n)
		hi = maxi(hi, n)
		routes[o["route"]] = true
		for id in BjjTree.levels(o):
			var m := BjjTree.mastery(o, id)
			if m < 0.0 or m > 100.0:
				out_of_range += 1
		pron += 1 if _pron.search(str(o)) != null else 0
	_check(lo >= 8 and hi <= 12, "white opponents own 8-12 moves (%d-%d over 200 seeds)" % [lo, hi])
	var rk := routes.keys()
	rk.sort()
	_check(rk == ["closed_guard_basics", "wrestler"], "white go-to routes are the two legal at white %s" % str(rk))
	_check(out_of_range == 0 and pron == 0, "masteries inside 0-100, no pronoun in any opponent")
	var blue := BjjOpp.generate("blue", "Passer", 3)
	print("  info a blue opponent owns %d (band count) and %d class-taught white tree moves" % [BjjOpp.count_owned(blue),
		BjjTree.data()["moves"].keys().filter(func(id): return BjjTree.move(id)["src"] == "tree" and BjjTree.move(id)["belt"] == "white").size()])
	_check(BjjOpp.count_owned(blue) >= 25 and BjjOpp.count_owned(blue) <= 36, "a blue opponent in the 25-36 band (%d)" % BjjOpp.count_owned(blue))
	_check(float(a["iq"]) == 40.0 and float(blue["iq"]) == 55.0 and float(BjjOpp.generate("brown", "Wrestler", 1)["iq"]) == 85.0, "iq by belt 40 / 55 / 85")
	var f := NoGi.athlete()
	var p := BjjOpp.partner(f, 12345)
	_check(str(p["name"]) == "Marta Kowal" and not NoGi.OPP_FIRST.has("Marta") and not NoGi.OPP_LAST.has("Kowal"), "the partner is Marta Kowal, on neither name list")
	var pb := BjjOpp.partner_at(int(p["seed"]), "blue")
	_check(int(pb["seed"]) == int(p["seed"]) and str(pb["belt"]) == "blue" and str(pb["name"]) == "Marta Kowal", "the partner at blue keeps the seed")
	var o0: Dictionary = NoGi.opens_after(1, 1)[0]
	var fl := BjjOpp.field(f, o0, 99)
	_check(fl.size() == 3 and str(fl[0]["name"]) != str(fl[1]["name"]) and str(fl[1]["name"]) != str(fl[2]["name"]) and str(fl[0]["name"]) != str(fl[2]["name"]),
		"the bracket path: 3 opponents, distinct names")
	var passers := 0
	for s in 200:
		var rng := RandomNumberGenerator.new()
		rng.seed = s
		passers += 1 if BjjOpp.pick_style(f, o0, rng) == "Passer" else 0
	_check(int(o0["lean"]) == 0 and passers > 40, "an escapes-lean open draws Passers more than 1 in 5 (%d of 200)" % passers)


func _week() -> void:
	var c := Career.quick_start()
	FirstWeek.ana_joins(c)
	var f := c.grappler_by_id("ana")
	var bjj0: Dictionary = (f["bjj"] as Dictionary).duplicate()
	f["drill"] = "tree:sprawl"
	c.day = 6
	Grapplers.day(c)
	_check(is_equal_approx(float((f.get("tree", {}) as Dictionary).get("sprawl", 0.0)), 3.2) and str(f["bjj"]) == str(bjj0)
		and int(f["mat_classes"]) == 133, "tree:sprawl on a Sunday: sprawl +3.2, the syllabus untouched, 3 classes")
	_check(str((f["mat_week"] as Dictionary).get("move", "")) == "sprawl" and (f["mat_week"] as Dictionary).has("levels_before"), "the week mark names the tree move")
	f["drill"] = "ahead:de_la_riva"
	c.day = 13
	Grapplers.day(c)
	_check(is_equal_approx(float(f["bjj"].get("de_la_riva", 0.0)), 1.6), "ahead:de_la_riva at white: +1.6 (half rate)")
	f["drill"] = "move:kimura"
	var k0 := float(f["bjj"]["kimura"])
	c.day = 20
	Grapplers.day(c)
	_check(is_equal_approx(float(f["bjj"]["kimura"]), k0 + 3.2) and int(f["mat_classes"]) == 139, "move:kimura still runs NoGi.week (+3.2)")
	_check(BjjTree.drill_target(f, "tree:junk").is_empty() and BjjTree.drill_target(f, "tree:kimura").is_empty()
		and BjjTree.drill_target(f, "ahead:kimura").is_empty() and not BjjTree.drill_target(f, "route:kimura_to_back").is_empty(),
		"a junk or wrong-kind tree plan is refused; a route plan finds its next move")
	_check(BjjTree.is_tree_plan("tree:sprawl") and BjjTree.is_tree_plan("route:wrestler") and not BjjTree.is_tree_plan("move:kimura")
		and not BjjTree.is_tree_plan("coach"), "tree:/route:/ahead: are tree plans; move:/coach are not")
	# Bar 13, exact: one belt ahead takes 2x the weeks, two belts 4x.
	var a := NoGi.athlete()
	_check(is_equal_approx(BjjTree.gain(a, 1) * 2.0, BjjTree.gain(a, 0)) and is_equal_approx(BjjTree.gain(a, 2) * 4.0, BjjTree.gain(a, 0)),
		"bar 13: one belt ahead x0.5, two belts x0.25 (%.2f / %.2f / %.2f)" % [BjjTree.gain(a, 0), BjjTree.gain(a, 1), BjjTree.gain(a, 2)])
	var t := BjjTree.drill_target(a, "tree:kimura_trap_roll")
	_check(int(t.get("n", -1)) == 1 and str(t.get("store", "")) == "tree", "a blue tree move at white: one belt ahead")
	_check(int(BjjTree.drill_target(a, "ahead:kneebar").get("n", -1)) == 2, "a purple move at white: two belts ahead, still drillable (never locked)")
	var x := NoGi.athlete()
	var y := NoGi.athlete()
	x["drill"] = "ahead:de_la_riva"
	for i in 20:
		BjjTree.week(x)
		y["mat_classes"] = int(y["mat_classes"]) + NoGi.classes_of(y)
	_check(str(BeltRoad.readiness(x, x["bjj"], 140)) == str(BeltRoad.readiness(y, y["bjj"], 140)) and float(x["bjj"]["de_la_riva"]) > 30.0,
		"20 weeks ahead: readiness at white unchanged (de la Riva %.1f)" % float(x["bjj"]["de_la_riva"]))
	var old := NoGi.athlete()
	old.erase("tree")
	_check(BjjTree.mastery(old, "sprawl") == 19.5 and BjjTree.levels(old).size() == 70, "an old save without tree keys reads (70 non-BASE moves)")


func _run(c: Career, to: int) -> void:
	for d in range(c.day + 1, to + 1):
		c.day = d
		Grapplers.day(c)
		if d % 7 == 0:
			Grapplers.week_report(c)


func _rolls() -> void:
	var c := Career.quick_start()
	FirstWeek.ana_joins(c)
	var f := c.grappler_by_id("ana")
	var before := [int(f["morale"]), int(f["w"]), int(f["l"]), (f["opens"] as Array).size()]
	var days: Array = []
	var p_cls := -1
	var p_skill := ""
	for d in range(1, 41):
		c.day = d
		Grapplers.day(c)
		if f.has("roll_week"):
			days.append(d)
			f.erase("roll_week")
		if d == 6:
			p_cls = int(f["partner"]["mat_classes"])
			p_skill = str([f["partner"]["bjj"], f["partner"]["tree"]])
	_check(days == [6, 20, 34], "a roll every 2nd Sunday %s" % str(days))
	_check([int(f["morale"]), int(f["w"]), int(f["l"]), (f["opens"] as Array).size()] == before, "rolls leave morale, w-l and opens alone")
	_check(int(f["partner"]["mat_classes"]) == p_cls + 12 and str([f["partner"]["bjj"], f["partner"]["tree"]]) == p_skill,
		"the partner gains class time every Sunday, never a drill (%d -> %d classes)" % [p_cls, int(f["partner"]["mat_classes"])])
	_check(not f.has("bjj_film") and (f["bjj_rolls"] as Array).size() == 3, "no film key; 3 rolls kept")
	var line := str((f["bjj_rolls"] as Array).back()["line"])
	_check(line.begins_with("Rolling with Marta: ") and line.contains("(last roll: ") and _pron.search(line) == null, "the roll line: %s" % line)
	var c2 := Career.quick_start()
	FirstWeek.ana_joins(c2)
	var g := c2.grappler_by_id("ana")
	Grapplers.enter(c2, "ana", 33)
	_check(((g.get("field", {}) as Dictionary).get(33, []) as Array).size() == 3, "entering draws the bracket path (3 opponents)")
	var days2: Array = []
	for d in range(1, 41):
		c2.day = d
		Grapplers.day(c2)
		if g.has("roll_week"):
			days2.append(d)
			g.erase("roll_week")
		if d == 34:
			g.erase("open_week")
	_check(days2 == [6, 20], "no roll in an open week %s" % str(days2))
	_check(not (g.get("field", {}) as Dictionary).has(33), "the field is dropped after the open")
	# A move that turned felt since the last roll is tried once and named.
	var named := 0
	for s in 6:
		var c3 := Career.quick_start()
		FirstWeek.ana_joins(c3)
		c3.seed = 100 + s
		c3.day = 6
		var h := c3.grappler_by_id("ana")
		var now := BjjOpen.usable_moves(h)
		h["bjj_rolls"] = [{"d": -8, "how": "points 2-0", "win": true, "path": [], "felt": now.filter(func(m): return m != "single_leg_shoot"), "tried": []}]
		var r := BjjOpen.roll_week(c3, h)
		if r.get("tried", []) == ["single_leg_shoot"] and str(r["line"]).contains("tried the low single"):
			named += 1
	_check(named >= 4, "a newly felt move is tried and named in the line (%d of 6 seeds)" % named)
	var c4 := Career.quick_start()
	FirstWeek.ana_joins(c4)
	var k := c4.grappler_by_id("ana")
	for i in 9:
		c4.day = 6 + 14 * i
		k.erase("open_week")
		BjjOpen.roll_week(c4, k)
	_check((k["bjj_rolls"] as Array).size() == 6, "the last 6 rolls are kept (%d)" % (k["bjj_rolls"] as Array).size())
	var pre := Career.quick_start()
	FirstWeek.ana_joins(pre)
	var pf := pre.grappler_by_id("ana")
	pf["partner"] = BjjOpp.partner(pf, pre.seed)
	pf["belt"] = "white"
	pre.day = 400
	pf["belt_day"] = -400
	pf["mat_classes"] = 200
	var seed0 := int(pf["partner"]["seed"])
	var news0 := pre.news.size()
	Grapplers.promote(pre, "ana")
	var added := pre.news.slice(0, pre.news.size() - news0).map(func(n): return str(n["t"]))
	_check(str(pf["partner"]["belt"]) == "blue" and int(pf["partner"]["seed"]) == seed0 and not added.any(func(t): return t.contains("Marta")),
		"a promotion regenerates Marta at blue, same seed, no news line of its own %s" % str(added))


func _report() -> void:
	var c := Career.quick_start()
	c.seed = 7   # S387 one known career (as golden_path): on some seeds a short open tries no edge at all
	FirstWeek.ana_joins(c)
	var f := c.grappler_by_id("ana")
	f["drill"] = "tree:single_leg_shoot"
	Grapplers.enter(c, "ana", 33)
	for d in range(1, 35):
		c.day = d
		Grapplers.day(c)
		if d % 7 == 0 and d < 35:
			Grapplers.week_report(c)
	c.day = 35
	var rows := Grapplers.week_report(c)
	var r: Dictionary = rows[0]
	_check(str(r["move_name"]) == "Low single" and r.has("events") and r.has("paths") and r.has("leak") and r.has("roll"),
		"the week row carries move_name, events, paths, leak, roll (%s)" % str(r["move_name"]))
	var ms: Array = (r["open"] as Dictionary).get("matches", [])
	_check(ms.size() >= 1 and (r["paths"] as Array).size() == ms.size(), "one path line per bout: %s" % str((r["paths"] as Array).map(func(p): return p["line"])))
	var stats: Dictionary = f.get("mat_stats", {})
	_check(not stats.is_empty(), "the open noted Ana's edges tried / landed (%d edges)" % stats.size())
	print("  info leak: %s" % str(r["leak"]))
	_check(str(r).length() > 0 and _pron.search(str(r["paths"])) == null and _pron.search(str(r["leak"])) == null, "path and leak words are pronoun-clean")
	var f2 := NoGi.athlete()
	f2["mat_classes"] = 133
	var mw := {"move": "single_leg_shoot", "levels_before": BjjTree.levels(NoGi.athlete()), "n": 0}
	f2["mat_classes"] = 200
	var row := {"move": "single_leg_shoot", "before": 19.5, "after": 30.0, "open": {}}
	Grapplers.tree_report(row, f2, mw)
	_check(str(row["class_line"]).begins_with("Class time: ") and str(row["class_line"]).contains("white basics now owned"),
		"class-time crossings fold into one line: %s" % row["class_line"])
	var row2 := {"move": "kimura_trap_roll", "before": 0.0, "after": 1.6, "open": {}}
	Grapplers.tree_report(row2, NoGi.athlete(), {"n": 1})
	_check(str(row2["off_belt_line"]) == "Kimura roll to the back +1.6 - a blue-belt move, half rate." or str(row2["off_belt_line"]).ends_with("a blue-belt move, half rate."),
		"the off-belt line: %s" % row2["off_belt_line"])


func _check(ok: bool, what: String) -> void:
	print(("  ok   " if ok else "  FAIL ") + what)
	if not ok:
		_fails += 1
