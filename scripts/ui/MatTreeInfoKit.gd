extends RefCounted
## SPLIT500B: the leaks lifted out of MatTreeInfo.gd (the 500-line rule) - the next field, the seeded walks that find
## the holes it walks Ana into, and the leak tile's words. MatTreeInfo keeps every public name as a one-line forward;
## the rules and the plan it already holds are passed in as plain values (the Kit never preloads its owner).
##   leaks(f, today, walks, rl, plan)  next_field(f, today)  next_opp(f, today)  leak_line(f, lk)

const BjjTree := preload("res://scripts/rules/BjjTree.gd")
const BjjWalk := preload("res://scripts/rules/BjjWalk.gd")
const BjjOpp := preload("res://scripts/rules/BjjOpp.gd")
const BeltRoad := preload("res://scripts/rules/BeltRoad.gd")

const LEAK_WALKS := 200
const LEAK_N := 3

static var _leak_cache := {}


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
static func leaks(f: Dictionary, today: int, walks: int, rl: Dictionary, plan: Array) -> Array:
	var field := next_field(f, today)
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
