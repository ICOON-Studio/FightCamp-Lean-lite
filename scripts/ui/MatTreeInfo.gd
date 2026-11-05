extends RefCounted
## GAMETREE1 stage 1 item 6 (S384, ops/research/GAMETREE1_DESIGN_S384.md section 7): what Ana's Playbook centre column
## says, pure and testable. The column (MatTree) only draws it.
##   fill(f, goal) -> {goal, steps, chance, missing, line}   the coach's fill: the best usable route from the feet to the
##       goal (highest chance product vs an even field, at most MAX_STEPS non-BASE steps) plus the best usable finish from
##       there; one step off (the field's second-best edge at the first fork) when `one_off` (a scouted opponent, stage 2).
##   step_info(f, steps, i) -> {p, word, costly, miss, pts, read, ...}   one plan card: chip word, costly corner, tooltip.
##   alternatives(f, eid) -> [edge ids]   the usable, legal edges at the same fork (the swap-pair cycle).
##   leaks(f, today) -> [{node, move, line, plan, cost}]   the 3 holes the next field walks Ana into (seeded walks).
##   map_nodes(f, steps, sel) -> {cols {node: col}, nodes [], edges [], miss []}   the map's nodes and arrows.
##   links(f) / ahead(f) -> [move ids]   the moves list's Links group (tree moves of her belt) and a belt ahead.
## Odds are BjjTree.odds - the one formula; nothing here changes a sim number.

const BjjTree := preload("res://scripts/rules/BjjTree.gd")
const BjjWalk := preload("res://scripts/rules/BjjWalk.gd")
const BjjOpp := preload("res://scripts/rules/BjjOpp.gd")
const BeltRoad := preload("res://scripts/rules/BeltRoad.gd")
const NoGi := preload("res://scripts/rules/NoGi.gd")
const TheRead := preload("res://scripts/rules/TheRead.gd")

const GOALS := ["back", "mount", "legs", "points"]
const GOAL_NAME := {"back": "Back", "mount": "Mount", "legs": "Legs", "points": "Points"}
const GOAL_NODE := {"back": "back_top", "mount": "mount_top"}
const START := "standing"
const MAX_STEPS := 5      # non-BASE steps in a plan (design 7: 5 slots)
const MAX_EDGES := 7      # BASE steps included
const PATH_CAP := 30000   # the path search stops here (never reached on the 49-node map)
const EVEN := 30.0        # the field's answer when nothing is scouted (BjjTree.route_chance's even answer)
const LEAK_WALKS := 200
const LEAK_N := 3
const AHEAD_N := 6
const RING_PER_COL := 4   # the map shows at most this many positions in one column (the plan's own excepted)

static var _leak_cache := {}


static func rules(f: Dictionary) -> Dictionary:
	return BjjTree.rules_for(str(f.get("belt", "white")))


static func edge_state(f: Dictionary, e: Dictionary, rl: Dictionary) -> String:
	var mv := str(e.get("move", ""))
	if BjjTree.is_base(mv):
		return "base"
	if not BjjTree.legal(mv, rl):
		return "illegal"
	var st := BjjTree.state(BjjTree.mastery(f, mv))
	if st == "learning" and BeltRoad.rank(str(BjjTree.move(mv).get("belt", "white"))) > BeltRoad.rank(str(f.get("belt", "white"))):
		return "ahead"
	return st


## The plan the page shows: f["bjj_plan"] when it still chains and is legal, else the walk's default (BjjTree.plan_of).
static func plan_steps(f: Dictionary) -> Array:
	return BjjTree.plan_of(f, rules(f))


static func plan_goal(f: Dictionary) -> String:
	return str((f.get("bjj_plan", {}) as Dictionary).get("goal", ""))


# --- the coach's fill --------------------------------------------------------------------------------------------------

## Every simple path from `start` on legal edges whose move is usable (felt+) or BASE; `learning` also walks learning
## edges (scored as if felt at FELT). -> [{steps, end, chance, pts, n}]
static func paths(f: Dictionary, start: String, rl: Dictionary, learning: bool = false) -> Array:
	var out: Array = []
	_dfs(f, rl, learning, start, [], {start: true}, 1.0, 0, 0, out)
	return out


static func _dfs(f: Dictionary, rl: Dictionary, learning: bool, at: String, steps: Array, seen: Dictionary, p: float,
		pts: int, n: int, out: Array) -> void:
	if out.size() >= PATH_CAP or steps.size() >= MAX_EDGES or BjjTree.is_ending(at):
		return
	for e in BjjTree.edges_from(at):
		var mv := str(e["move"])
		var to := str(e["ok"])
		if seen.has(to) or not BjjTree.legal(mv, rl):
			continue
		var base := BjjTree.is_base(mv)
		var m := BjjTree.mastery(f, mv)
		if not base and not BjjTree.usable(m) and not learning:
			continue
		if not base and n >= MAX_STEPS:
			continue
		var q := p
		if not base:
			q *= BjjTree.odds(e, maxf(m, float(BjjTree.T["FELT"])), EVEN, rl, n > 0)
		var st2 := steps.duplicate()
		st2.append(str(e["id"]))
		var row := {"steps": st2, "end": to, "chance": q, "pts": pts + int(e["points"]), "n": n + (0 if base else 1),
			"last": mv}
		out.append(row)
		seen[to] = true
		_dfs(f, rl, learning, to, st2, seen, q, int(row["pts"]), int(row["n"]), out)
		seen.erase(to)


static func _goal_hit(goal: String, row: Dictionary) -> bool:
	if int(row["n"]) == 0:
		return false
	match goal:
		"back", "mount":
			return str(row["end"]) == str(GOAL_NODE[goal])
		"legs":
			return str(row["end"]) == "tap_win" and str(BjjTree.move(str(row["last"])).get("lane", "")) == "leg_lock"
	return int(row["pts"]) > 0


static func _score(goal: String, row: Dictionary) -> float:
	var s := float(row["chance"]) * (float(row["pts"]) if goal == "points" else 1.0)
	return s - 0.0001 * (row["steps"] as Array).size()


## Ranked rows reaching the goal, best first.
static func _ranked(goal: String, rows: Array) -> Array:
	var hit := rows.filter(func(r): return _goal_hit(goal, r))
	hit.sort_custom(func(a, b): return _score(goal, a) > _score(goal, b))
	return hit


## The best usable submission from a node (ok = tap_win), "" when none.
static func finish_from(f: Dictionary, node_id: String, rl: Dictionary) -> String:
	var best := ""
	var top := 0.0
	for e in BjjTree.edges_from(node_id):
		var mv := str(e["move"])
		if str(e["ok"]) != "tap_win" or not BjjTree.legal(mv, rl) or not BjjTree.usable(BjjTree.mastery(f, mv)):
			continue
		var p := BjjTree.odds(e, BjjTree.mastery(f, mv), EVEN, rl, true)
		if p > top:
			top = p
			best = str(e["id"])
	return best


## The coach's fill for a goal tile (design 7). steps = [] and missing = the first move to drill when no usable route.
static func fill(f: Dictionary, goal: String, one_off: bool = false) -> Dictionary:
	var rl := rules(f)
	var ranked := _ranked(goal, paths(f, START, rl))
	var out := {"goal": goal, "steps": [], "chance": 0.0, "missing": "", "line": ""}
	if ranked.is_empty():
		var lr := _ranked(goal, paths(f, START, rl, true))
		if not lr.is_empty():
			for id in lr[0]["steps"]:
				var mv := str(BjjTree.edge(str(id))["move"])
				if not BjjTree.is_base(mv) and not BjjTree.usable(BjjTree.mastery(f, mv)):
					out["missing"] = mv
					break
		out["line"] = "Drill: %s" % BjjTree.move_name(str(out["missing"])).to_lower() if str(out["missing"]) != "" else "no route yet"
		if goal == "legs" and BeltRoad.rank(str(rl["legal"])) < BeltRoad.rank("brown"):
			out["line"] = "IBJJF: straight ankle only"
		return out
	var steps: Array = (ranked[0]["steps"] as Array).duplicate()
	if one_off:
		steps = _one_off(f, goal, ranked, rl)
	if goal != "legs":
		var fin := finish_from(f, str(BjjTree.edge(str(steps[-1]))["ok"]), rl)
		if fin != "" and count_steps(steps) < MAX_STEPS:
			steps.append(fin)
	out["steps"] = steps
	out["chance"] = BjjTree.route_chance(f, steps, rl)
	var n := count_steps(steps)
	var owned := steps.all(func(id): return edge_state(f, BjjTree.edge(str(id)), rl) in ["base", "owned", "signature"])
	match goal:
		"points":
			var first := ""
			for id in steps:
				if not BjjTree.is_base(str(BjjTree.edge(str(id))["move"])):
					first = BjjTree.move_name(str(BjjTree.edge(str(id))["move"]))
					break
			out["line"] = "%s, +%d" % [first, int(ranked[0]["pts"])]
		"legs":
			out["line"] = "%d step%s - %s" % [n, "" if n == 1 else "s", "all owned" if owned else "felt in it"]
		_:
			out["line"] = "%d step%s, %s" % [n, "" if n == 1 else "s", "all owned" if owned else "felt in it"]
	return out


## Kalli 5: against a scouted opponent the fill takes the field's second-best edge at the route's first fork.
static func _one_off(f: Dictionary, goal: String, ranked: Array, rl: Dictionary) -> Array:
	var best: Array = ranked[0]["steps"]
	for k in best.size():
		for r in ranked.slice(1):
			var s: Array = r["steps"]
			if s.size() > k and s.slice(0, k) == best.slice(0, k) and str(s[k]) != str(best[k]):
				return s.duplicate()
	return best.duplicate()


## Non-BASE steps in a plan (the ones that count toward its length and its read).
static func count_steps(steps: Array) -> int:
	return steps.filter(func(id): return not BjjTree.is_base(str(BjjTree.edge(str(id)).get("move", "")))).size()


## The rest of a route after a swap: the best usable path from `node` to the goal (or to a finish), else [].
static func complete_from(f: Dictionary, node_id: String, goal: String, budget: int) -> Array:
	var rl := rules(f)
	if goal != "" and goal != "points" and goal != "legs" and node_id == str(GOAL_NODE.get(goal, "")):
		var fin := finish_from(f, node_id, rl)
		return [fin] if fin != "" and budget > 0 else []
	var ranked := _ranked(goal if goal != "" else "points", paths(f, node_id, rl))
	ranked = ranked.filter(func(r): return int(r["n"]) <= budget)
	return (ranked[0]["steps"] as Array).duplicate() if not ranked.is_empty() else []


## Writes the plan (f["bjj_plan"]: {goal, steps, name}); the name is the preset route's when the steps are one.
static func set_plan(f: Dictionary, goal: String, steps: Array) -> void:
	var name := "%s plan" % str(GOAL_NAME.get(goal, "Own"))
	for rid in BjjTree.data()["routes"]:
		if BjjTree.route(rid)["steps"] == steps:
			name = str(BjjTree.route(rid)["name"])
	f["bjj_plan"] = {"goal": goal, "steps": steps.duplicate(), "name": name}


## A preset route's card line: "4 steps - 2 owned - long: gets read" (+ the IBJJF line when it is not legal at her belt).
static func route_line(f: Dictionary, rid: String) -> String:
	var rl := rules(f)
	var steps: Array = BjjTree.route(rid).get("steps", [])
	var n := count_steps(steps)
	var owned := 0
	for id in steps:
		if edge_state(f, BjjTree.edge(str(id)), rl) in ["owned", "signature"]:
			owned += 1
	var line := "%d step%s - %d owned" % [n, "" if n == 1 else "s", owned]
	if n >= BjjTree.LONG_AT:
		line += " - long: gets read"
	if not BjjTree.route_legal(steps, rl):
		line += " - IBJJF: brown and up"
	return line


# --- one plan card -----------------------------------------------------------------------------------------------------

## Card i of the plan: the chip word (LIKELY / EVEN / LONG SHOT), the costly corner and the four tooltip numbers.
static func step_info(f: Dictionary, steps: Array, i: int, holes: Array = []) -> Dictionary:
	var rl := rules(f)
	var e := BjjTree.edge(str(steps[i]))
	var mv := str(e["move"])
	var k := 0
	for j in i:
		if not BjjTree.is_base(str(BjjTree.edge(str(steps[j]))["move"])):
			k += 1
	var st := edge_state(f, e, rl)
	var m := BjjTree.mastery(f, mv)
	var read := minf(1.0, k * TheRead.LOOKS_PER_EXCHANGE / TheRead.looks_needed(float(BjjTree.IQ.get(str(rl["belt"]), 40.0)), false))
	var base := st == "base"
	var p := BjjTree.odds(e, m, EVEN, rl, k > 0 and not base, 0.0 if base else read) if (base or BjjTree.usable(m)) else 0.0
	var bad := str(e["bad"])
	var ans := ""
	for a in e.get("answers", []):
		if BjjTree.legal(str(a), rl):
			ans = BjjTree.move_name(str(a)).to_lower()
			break
	var stays := bad == str(e["from"])
	var hole := holes.has(bad)
	var costly := not base and BjjTree.p_bad(EVEN) >= 0.5 and not stays and (hole or int(e["bad_gives"]) >= 2)
	return {"id": str(e["id"]), "move": mv, "name": BjjTree.move_name(mv), "state": st, "m": m, "p": p,
		"word": BjjTree.chip_word(p), "costly": costly, "pts": int(e["points"]), "tap": str(e["ok"]) == "tap_win",
		"miss": "everyone's move" if base else ("miss: stays" if stays else "miss: " + str(BjjTree.node(bad).get("name", bad)).to_lower()),
		"miss_hole": hole, "answer": ans, "read": read, "step": k + 1, "base": base,
		"swap": alternatives(f, str(e["id"])).size() > 1}


## The four numbers for the hover tooltip, as lines.
static func tip_lines(info: Dictionary) -> Array:
	var out: Array = []
	if bool(info["base"]):
		return ["%d%% - everyone's move" % roundi(float(info["p"]) * 100.0), "points +%d" % int(info["pts"])]
	out.append("%d%% vs the field" % roundi(float(info["p"]) * 100.0))
	out.append("tap" if bool(info["tap"]) else "+%d points" % int(info["pts"]))
	var miss := str(info["miss"]).trim_prefix("miss: ")
	out.append("miss: %s%s%s" % [miss, " (a hole)" if bool(info["miss_hole"]) else "",
		(", the field owns the %s" % str(info["answer"])) if str(info["answer"]) != "" and miss != "stays" else ""])
	out.append(read_words(float(info["read"])))
	return out


## The field's read on the plan by this step (design 3.4), in words.
static func read_words(r: float) -> String:
	if r < 0.05:
		return "not read yet"
	if r < 0.4:
		return "read a little (%d%%)" % roundi(r * 100.0)
	return "half read (%d%%)" % roundi(r * 100.0) if r < 0.8 else "read (%d%%)" % roundi(r * 100.0)


## The usable, legal edges at the same fork as `eid` (itself included, JSON order): the swap cycle.
static func alternatives(f: Dictionary, eid: String) -> Array:
	var rl := rules(f)
	var e := BjjTree.edge(eid)
	var out: Array = []
	for x in BjjTree.edges_from(str(e.get("from", ""))):
		if edge_state(f, x, rl) in ["felt", "owned", "signature"] or str(x["id"]) == eid:
			out.append(str(x["id"]))
	return out


# --- leaks -------------------------------------------------------------------------------------------------------------

## The next field: the R1-R3 path of the soonest entered open, else one opponent of each style at her belt.
static func next_field(f: Dictionary, today: int) -> Array:
	var best := -1
	for d in (f.get("field", {}) as Dictionary):
		if int(d) > today and (best < 0 or int(d) < best):
			best = int(d)
	if best >= 0:
		var fl: Array = f["field"].get(best, f["field"].get(str(best), []))
		if fl.size() >= 3:
			return fl
	var out: Array = []
	var belt := str(f.get("belt", "white"))
	for i in BjjOpp.STYLE_ORDER.size():
		out.append(BjjOpp.generate(belt, str(BjjOpp.STYLE_ORDER[i]), hash("leakfield|%s|%d" % [belt, i])))
	return out


## The next opponent (R1 of the soonest entered open), {} when none is entered.
static func next_opp(f: Dictionary, today: int) -> Dictionary:
	var best := -1
	for d in (f.get("field", {}) as Dictionary):
		if int(d) > today and (best < 0 or int(d) < best):
			best = int(d)
	if best < 0:
		return {}
	var fl: Array = f["field"].get(best, f["field"].get(str(best), []))
	return fl[0] if not fl.is_empty() else {}


## Design 5.1: the holes the field actually walks Ana into - visits x points or taps lost over LEAK_WALKS seeded walks
## against the next field, on her current plan. Each with the move that fills it best (BjjTree.leak_move).
static func leaks(f: Dictionary, today: int, walks: int = LEAK_WALKS) -> Array:
	var rl := rules(f)
	var field := next_field(f, today)
	var plan := plan_steps(f)
	var key := "%s|%s|%s|%s|%d" % [str(BjjTree.levels(f).hash()), str(rl["belt"]), str(plan), str(field.map(func(o): return o.get("name", ""))), walks]
	if not _leak_cache.has(key):
		_leak_cache = {key: _walk_leaks(f, field, plan, rl, walks)}
	var out: Array = []
	for lk in _leak_cache[key]:
		out.append((lk as Dictionary).duplicate())
	return out


static func _walk_leaks(f: Dictionary, field: Array, plan: Array, rl: Dictionary, walks: int) -> Array:
	var visits := {}
	var rng := RandomNumberGenerator.new()
	for i in walks:
		rng.seed = hash("leak|%d" % i)
		var opp: Dictionary = field[i % field.size()]
		var w := BjjWalk.walk(f, opp, [plan, BjjTree.route(str(opp.get("route", ""))).get("steps", [])], int(rl["minutes"]), rl, rng,
			{"no_mood": true})
		for k in w["visits"]:
			var v: Array = visits.get_or_add(k, [0, 0, 0])
			for j in 3:
				v[j] += int(w["visits"][k][j])
	var rows: Array = []
	for node in BjjTree.holes(f, rl):
		if not visits.has(node):
			continue
		var mv := BjjTree.leak_move(f, node, rl)
		if mv == "":
			continue
		var v: Array = visits[node]
		rows.append({"node": node, "move": mv, "cost": float(v[1]) + float(BjjTree.T["TAP_VALUE"]) * float(v[2]), "visits": int(v[0]),
			"lost_pts": int(v[1]), "taps": int(v[2])})
	rows.sort_custom(func(a, b): return float(a["cost"]) > float(b["cost"]) or (float(a["cost"]) == float(b["cost"]) and int(a["visits"]) > int(b["visits"])))
	return rows.slice(0, LEAK_N)


## A leak tile's words: the move, its mastery and when the drill gets it felt / owned; the open it cost, when it did.
static func leak_line(f: Dictionary, lk: Dictionary) -> String:
	var mv := str(lk["move"])
	var m := BjjTree.mastery(f, mv)
	var n := maxi(0, BeltRoad.rank(str(BjjTree.move(mv).get("belt", "white"))) - BeltRoad.rank(str(f.get("belt", "white"))))
	var g := maxf(0.01, BjjTree.gain(f, n))
	var to := float(BjjTree.T["FELT"]) if m < float(BjjTree.T["FELT"]) else BeltRoad.OWNED_AT
	var weeks := ceili((to - m) / g)
	var when := "%s %s" % ["felt" if to < BeltRoad.OWNED_AT else "owned", "next Sunday" if weeks <= 1 else "in %d weeks" % weeks]
	var line := "%s %d - %s" % [BjjTree.move_name(mv), int(m), when]
	var ow: Dictionary = (f.get("open_week", {}) as Dictionary)
	if str((ow.get("leak", {}) as Dictionary).get("node", "")) == str(lk["node"]):
		line += " - the %s loss" % str(ow.get("name", "open"))
	return line


# --- the map -----------------------------------------------------------------------------------------------------------

## Shortest hop count from the feet over every edge (the map's columns).
static func depth() -> Dictionary:
	var d := {START: 0}
	var q: Array = [START]
	while not q.is_empty():
		var at: String = q.pop_front()
		for e in BjjTree.edges_from(at):
			var to := str(e["ok"])
			if not d.has(to):
				d[to] = int(d[at]) + 1
				q.append(to)
	return d


## The map: the plan's nodes, the selected node and its ins and outs (the reachable ring), the plan's miss landings.
## -> {nodes [ids], edges [edge ids drawn], miss [edge ids whose miss arrow is drawn], plan_nodes [], cols {id: col}}
static func map_nodes(f: Dictionary, steps: Array, sel: String) -> Dictionary:
	var rl := rules(f)
	var nodes: Array = []
	var plan_nodes: Array = []
	var edges: Array = []
	var miss: Array = []
	for id in steps:
		var e := BjjTree.edge(str(id))
		for n in [str(e["from"]), str(e["ok"])]:
			if not plan_nodes.has(n):
				plan_nodes.append(n)
		edges.append(str(id))
		if str(e["bad"]) != str(e["from"]) and not BjjTree.is_base(str(e["move"])):
			miss.append(str(id))
	if plan_nodes.is_empty():
		plan_nodes.append(START)
	nodes = plan_nodes.duplicate()
	if not nodes.has(sel):
		nodes.append(sel)
	for id in miss:
		var bad := str(BjjTree.edge(str(id))["bad"])
		if not nodes.has(bad):
			nodes.append(bad)
	var dp := depth()
	var per_col := {}
	for n in nodes:
		per_col[int(dp.get(n, 0))] = int(per_col.get(int(dp.get(n, 0)), 0)) + 1
	# the ring: owned and felt arrows first, then learning, then everyone's; at most RING_PER_COL positions a column
	var ring: Array = (BjjTree.edges_from(sel) + BjjTree.edges_into(sel)).filter(func(e):
		return not (edge_state(f, e, rl) == "illegal" and BeltRoad.rank(str(rl["legal"])) < BeltRoad.rank("brown")))
	var pri := {"signature": 0, "owned": 0, "felt": 1, "learning": 2, "ahead": 3, "base": 4, "illegal": 5}
	ring.sort_custom(func(a, b): return int(pri[edge_state(f, a, rl)]) < int(pri[edge_state(f, b, rl)]))
	for e in ring:
		for n in [str(e["from"]), str(e["ok"])]:
			var c := int(dp.get(n, 0)) if not BjjTree.is_ending(n) else 99
			if not nodes.has(n) and nodes.size() < 14 and int(per_col.get(c, 0)) < RING_PER_COL:
				nodes.append(n)
				per_col[c] = int(per_col.get(c, 0)) + 1
		if nodes.has(str(e["from"])) and nodes.has(str(e["ok"])) and not edges.has(str(e["id"])):
			edges.append(str(e["id"]))
	var cols := {}
	for n in nodes:
		cols[n] = int(dp.get(n, 0)) if not BjjTree.is_ending(n) else -1
	var last := 0
	for n in nodes:
		last = maxi(last, int(cols[n]))
	for n in nodes:
		if int(cols[n]) < 0:
			cols[n] = last + 1
	return {"nodes": nodes, "edges": edges, "miss": miss, "plan_nodes": plan_nodes, "cols": cols}


# --- the moves list ----------------------------------------------------------------------------------------------------

## Tree moves of her belt (taught in class), highest mastery first.
static func links(f: Dictionary) -> Array:
	var belt := str(f.get("belt", "white"))
	var out: Array = []
	for id in BjjTree.data()["moves"]:
		var m: Dictionary = BjjTree.move(id)
		if str(m["src"]) == "tree" and str(m["belt"]) == belt:
			out.append(str(id))
	out.sort_custom(func(a, b): return BjjTree.mastery(f, a) > BjjTree.mastery(f, b) or (BjjTree.mastery(f, a) == BjjTree.mastery(f, b) and a < b))
	return out


## A belt ahead: moves of the next belt on an edge out of a node Ana reaches (her plan's nodes and their ring), at most
## AHEAD_N, closest to felt first.
static func ahead(f: Dictionary) -> Array:
	var belt := str(f.get("belt", "white"))
	var nxt := BeltRoad.next_belt(belt)
	if nxt == "":
		return []
	var rl := rules(f)
	var reach := {START: true}
	for id in plan_steps(f):
		reach[str(BjjTree.edge(str(id))["from"])] = true
		reach[str(BjjTree.edge(str(id))["ok"])] = true
	for n in reach.keys():
		for e in BjjTree.edges_from(n):
			reach[str(e["ok"])] = true
	var out: Array = []
	for n in reach:
		for e in BjjTree.edges_from(n):
			var mv := str(e["move"])
			if str(BjjTree.move(mv).get("belt", "")) == nxt and BjjTree.legal(mv, rl) and not out.has(mv):
				out.append(mv)
	out.sort_custom(func(a, b): return BjjTree.mastery(f, a) > BjjTree.mastery(f, b) or (BjjTree.mastery(f, a) == BjjTree.mastery(f, b) and a < b))
	return out.slice(0, AHEAD_N)


## The move the classes drill this week: a tree plan's target, else NoGi.drilling (unchanged).
static func drilled(f: Dictionary, day: int) -> String:
	var plan := str(f.get("drill", "coach"))
	if BjjTree.is_tree_plan(plan):
		return str(BjjTree.drill_target(f, plan).get("move", ""))
	return NoGi.drilling(f, day)
