extends RefCounted
## GAMETREE1 (S384) the calibration's populations and counts, shared by tools/bjj_tree_balance.gd and
## tests/bjj_tree_sim_test.gd. Seeded: the same seeds give the same walks.
##   white_field(f, seeds)      Ana against BjjOpp.field(f, a plain open, seed), all three bouts a seed
##   even_field(belt, seeds)    two BjjOpp.generate athletes of one belt, random styles, each on its go-to route
##   tally(walks)               every count the bars read (finishes, attempts, scoring kinds, stays, late lead, misses,
##                              first scorer, openings)
##   ana_at(share)              Ana at a readiness share (bar 1d)

const BjjTree := preload("res://scripts/rules/BjjTree.gd")
const BjjWalk := preload("res://scripts/rules/BjjWalk.gd")
const BjjOpp := preload("res://scripts/rules/BjjOpp.gd")
const NoGi := preload("res://scripts/rules/NoGi.gd")
const BeltRoad := preload("res://scripts/rules/BeltRoad.gd")

## Finish families (bar 3, FloGrappling 2022 split). Triangles count as chokes; the crucifix finish as an arm lock.
const CHOKES := ["guillotine", "rear_naked_choke", "triangle", "darce", "anaconda", "north_south_choke", "back_triangle",
	"clock_choke", "mounted_triangle", "head_arm_choke"]
const ARMS := ["armbar_guard", "kimura", "americana", "mount_armbar", "crucifix"]
const LEGS := ["straight_ankle_lock", "outside_heel_hook", "kneebar", "toe_hold", "inside_heel_hook", "calf_slicer"]
## A takedown attempt from standing (bar 11c): the standing lane's shots and the snap down.
const TAKEDOWNS := ["double_leg", "single_leg_shoot", "snap_down"]


static func rng(seed: int, tag: String) -> RandomNumberGenerator:
	var r := RandomNumberGenerator.new()
	r.seed = hash("%d|%s" % [seed, tag])
	return r


## The first open without its lean (as no_gi_test runs it).
static func plain_open() -> Dictionary:
	var o: Dictionary = NoGi.opens_after(1, 1)[0].duplicate()
	o.erase("lean")
	return o


static func steps(o: Dictionary) -> Array:
	return BjjTree.route(str(o.get("route", ""))).get("steps", [])


## Ana at a readiness share, the least change from her start: classes = share x 200, and ceil(share x 14) white syllabus
## moves owned - the closest unowned ones lifted to 30 (the coach's drilling order), or the lowest owned ones set back to
## 29. 0.64 = Ana herself.
static func ana_at(share: float) -> Dictionary:
	var f := NoGi.athlete()
	if is_equal_approx(share, 0.64):
		return f
	var bjj: Dictionary = f["bjj"]
	var syl: Array = BeltRoad.moves_for("white").duplicate()
	syl.sort_custom(func(a, b): return float(bjj.get(a, 0.0)) > float(bjj.get(b, 0.0)))
	var k := clampi(ceili(share * syl.size() - 0.0001), 1, syl.size())
	for i in syl.size():
		var m := float(bjj.get(syl[i], 0.0))
		if i < k:
			bjj[syl[i]] = maxf(m, BeltRoad.OWNED_AT)
		else:
			bjj[syl[i]] = minf(m, BeltRoad.OWNED_AT - 1.0)
	f["mat_classes"] = int(round(share * float(BeltRoad.CLASSES_TO_NEXT["white"])))
	return f


## BjjWalk.walk with the bout length kept on the result (bar 7 reads it).
static func walk(a: Dictionary, b: Dictionary, plans: Array, mins: int, rules: Dictionary, r: RandomNumberGenerator) -> Dictionary:
	var w := BjjWalk.walk(a, b, plans, mins, rules, r)
	w["minutes"] = mins
	return w


## Ana against a seeded white field: all three bouts per seed. -> [walks, opponents]
static func white_field(f: Dictionary, seeds: int, seed0: int = 0) -> Array:
	var rules := BjjTree.rules_for("white")
	var plan := BjjTree.plan_of(f, rules)
	var o := plain_open()
	var ws: Array = []
	var opps: Array = []
	for s in seeds:
		var fl := BjjOpp.field(f, o, seed0 + s)
		for i in 3:
			ws.append(walk(f, fl[i], [plan, steps(fl[i])], int(rules["minutes"]), rules, rng(seed0 + s, "w%d" % i)))
			opps.append(fl[i])
	return [ws, opps]


## Two generated athletes of one belt, random styles, each on its go-to route.
static func even_field(belt: String, seeds: int, minutes: int = 0) -> Array:
	var rules := BjjTree.rules_for(belt)
	var mins := minutes if minutes > 0 else int(rules["minutes"])
	var ws: Array = []
	for s in seeds:
		var r := rng(s, "even|" + belt)
		var a := BjjOpp.generate(belt, str(BjjOpp.STYLE_ORDER[r.randi() % 5]), hash("%d|a|%s" % [s, belt]))
		var b := BjjOpp.generate(belt, str(BjjOpp.STYLE_ORDER[r.randi() % 5]), hash("%d|b|%s" % [s, belt]))
		ws.append(walk(a, b, [steps(a), steps(b)], mins, rules, r))
	return ws


static func win_rate(ws: Array) -> float:
	var n := 0
	for w in ws:
		n += 1 if bool(w["win"]) else 0
	return float(n) / maxf(1.0, ws.size())


## The bout replayed beat by beat: [{e, s, res, t, from, to, sc [a, b] after, ad [a, b] after, pts, by}].
static func replay(w: Dictionary) -> Array:
	var at := "standing"
	var sc := [0, 0]
	var ad := [0, 0]
	var out: Array = []
	for p in w["path"]:
		var e := BjjTree.edge(str(p[0]))
		var s := int(p[1])
		var res := str(p[2])
		var base := BjjTree.is_base(str(e["move"]))
		var from := at
		var pts := 0
		var by := -1
		if res == "hit":
			at = str(e["ok"]) if s == 0 else BjjTree.mirror(str(e["ok"]))
			pts = int(e["points"])
			by = s
		elif res == "miss":
			at = str(e["bad"]) if s == 0 else BjjTree.mirror(str(e["bad"]))
			if not base:
				pts = int(e["bad_gives"])
				by = 1 - s
		elif int(e["points"]) > 0 or str(e["odds"]) == "submission":
			ad[s] += 1
		if by >= 0:
			sc[by] += pts
		out.append({"e": e, "s": s, "res": res, "t": float(p[3]), "from": from, "to": at, "sc": sc.duplicate(),
			"ad": ad.duplicate(), "pts": pts, "by": by})
	return out


## A scoring event's kind from the scorer's landing node and the edge.
static func score_kind(node: String, pts: int, e: Dictionary) -> String:
	if pts == 4:
		return "back" if node.begins_with("back") else "mount"
	if pts == 3:
		return "pass"
	if node.begins_with("knee_on_belly"):
		return "knee_on_belly"
	return "takedown" if str(e["odds"]) == "takedown" else "sweep"


## Every count the bars read, over a set of walks.
static func tally(ws: Array) -> Dictionary:
	var a := {"bouts": ws.size(), "subs": 0, "finish": {}, "sub_att": 0, "secs": 0.0, "fin_t": {"chokes": [0.0, 0], "arms": [0.0, 0],
		"legs": [0.0, 0]}, "kinds": {}, "stays": {}, "lead_n": 0, "lead_tapped": 0, "miss_n": 0, "miss_bad": 0, "first_n": 0,
		"first_won": 0, "open_n": 0, "open_pull": 0, "pull_n": 0, "pull_hit": 0}
	for w in ws:
		var rp := replay(w)
		a["secs"] += float(w["t"])
		var fin := str(w["finish"])
		if fin != "":
			a["subs"] += 1
			a["finish"][fin] = int(a["finish"].get(fin, 0)) + 1
			var cat := "chokes" if CHOKES.has(fin) else ("legs" if LEGS.has(fin) else "arms")
			a["fin_t"][cat][0] += float(w["t"])
			a["fin_t"][cat][1] += 1
		var first := -1
		for i in rp.size():
			var b: Dictionary = rp[i]
			var e: Dictionary = b["e"]
			var mv := str(e["move"])
			if i == 0:
				a["open_n"] += 1
				a["open_pull"] += 1 if mv == "guard_pull" else 0
			if mv == "guard_pull":
				a["pull_n"] += 1
				a["pull_hit"] += 1 if b["res"] == "hit" else 0
			if BjjTree.is_base(mv):
				continue
			if str(e["odds"]) == "submission":
				a["sub_att"] += 1
			if b["res"] != "hit":
				a["miss_n"] += 1
				a["miss_bad"] += 1 if b["res"] == "miss" and int(e["bad_gives"]) >= 3 else 0
			if int(b["pts"]) > 0:
				if first < 0:
					first = int(b["by"])
				var node: String = b["to"] if int(b["by"]) == 0 else BjjTree.mirror(b["to"])
				var k := score_kind(node, int(b["pts"]), e)
				a["kinds"][k] = int(a["kinds"].get(k, 0)) + 1
		if first >= 0:
			a["first_n"] += 1
			a["first_won"] += 1 if bool(w["win"]) == (first == 0) else 0
		_stays(a, rp, w)
		_late(a, rp, w)
	return a


## Position-to-finish conversion: each run of beats on one node is a stay for both sides (side 1 on the mirror);
## a stay converts when that side's submission from it ended the bout.
static func _stays(a: Dictionary, rp: Array, w: Dictionary) -> void:
	var cur := "standing"
	var fin_s := -1
	if str(w["finish"]) != "":
		fin_s = 0 if bool(w["win"]) else 1
	var runs: Array = [cur]
	for b in rp:
		if str(b["to"]) != cur:
			cur = str(b["to"])
			runs.append(cur)
	for i in runs.size():
		var at: String = runs[i]
		if BjjTree.is_ending(at):
			continue
		var last := i == runs.size() - 2 and BjjTree.is_ending(str(runs[-1]))
		for s in 2:
			var node: String = at if s == 0 else BjjTree.mirror(at)
			var st: Array = a["stays"].get_or_add(node, [0, 0])
			st[0] += 1
			st[1] += 1 if last and s == fin_s else 0


## Late lead (bar 7): the side ahead (points, then advantages) with 60 s left; was it tapped after that?
static func _late(a: Dictionary, rp: Array, w: Dictionary) -> void:
	var total := float(w.get("minutes", 0)) * 60.0
	var mark := total - 60.0
	if total <= 0.0 or float(w["t"]) < mark:
		return
	var sc := [0, 0]
	var ad := [0, 0]
	for b in rp:
		if float(b["t"]) >= mark:
			break
		sc = b["sc"]
		ad = b["ad"]
	var lead := -1
	if int(sc[0]) != int(sc[1]):
		lead = 0 if int(sc[0]) > int(sc[1]) else 1
	elif int(ad[0]) != int(ad[1]):
		lead = 0 if int(ad[0]) > int(ad[1]) else 1
	if lead < 0:
		return
	a["lead_n"] += 1
	var lead_won := bool(w["win"]) == (lead == 0)
	a["lead_tapped"] += 1 if (not lead_won and str(w["finish"]) != "") else 0


static func conv(a: Dictionary, node: String) -> float:
	var st: Array = a["stays"].get(node, [0, 0])
	return float(st[1]) / maxf(1.0, float(st[0]))


static func top(d: Dictionary) -> String:
	var best := ""
	for k in d:
		if best == "" or int(d[k]) > int(d[best]):
			best = k
	return best


static func share(a: Dictionary, cat: Array) -> float:
	var n := 0
	for k in a["finish"]:
		n += int(a["finish"][k]) if cat.has(k) else 0
	return float(n) / maxf(1.0, float(a["subs"]))
