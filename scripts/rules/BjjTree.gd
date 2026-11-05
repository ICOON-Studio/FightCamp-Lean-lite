extends RefCounted
## GAMETREE1 (S384, ops/research/GAMETREE1_DESIGN_S384.md) - Ana's game tree: positions are free, the arrows between them
## are moves, drilling turns a grey arrow half-yellow (FELT, 15) and then yellow (owned, 30). This module is the map's data,
## mastery (class time teaches the tree moves of the belt), IBJJF legality, the one odds formula and the tree drilling of the
## week (tree:/route:/ahead:, scaled by belt, never locked). The walk itself is BjjWalk; the field is BjjOpp.
## Numbers: [R] research rows and [CODE] game constants are fixed here; [T] tuning values live in T0 and are read through
## the static T, so a balance runner can sweep them without editing code (tests call reset_tuning() first).
## Pure static; preloads BeltRoad and NoGi (neither preloads this).

const BeltRoad := preload("res://scripts/rules/BeltRoad.gd")
const NoGi := preload("res://scripts/rules/NoGi.gd")

const PATH := "res://assets/data/bjj_tree.json"
## [R] even-field rate per edge kind: [white/blue, brown/black]; purple = the midpoint. entry/transition/escape/takedown
## and the pro back take come from T (UNVERIFIED or tuned rows).
const KIND_BASE := {"sweep": [0.52, 0.35], "back_take": [0.60, -1.0], "pass": [0.23, 0.23], "submission": [0.16, 0.16]}
## [R] per-move even-field rates at every tier (ADCC 2022, GC 2023, GC 2024/25 best-edge tables).
const OVERRIDES := {"rear_naked_choke": 0.35, "kneebar": 0.27, "inside_heel_hook": 0.25, "darce": 0.22, "anaconda": 0.21,
	"guillotine": 0.10, "mat_return": 0.71, "body_lock_pass": 0.37, "leg_drag": 0.31}
## [R: Williams 2019 (gi)] white/blue only.
const OVERRIDES_AMATEUR := {"scissor_sweep": 0.55}
const BASE_P := 0.94
const CLAMP := Vector2(0.03, 0.90)
const P_BAD_AT := BeltRoad.OWNED_AT
const SIGNATURE := NoGi.SIGNATURE
const LONG_AT := 4   # mirrors OwnCombos.LONG_AT (the boxing long-combo mark)
const LIKELY_AT := 0.60
const LONG_SHOT_BELOW := 0.35
const IQ := {"white": 40.0, "blue": 55.0, "purple": 70.0, "brown": 85.0, "black": 85.0}   # ends = TheRead.IQ_LOW / IQ_HIGH
const ROLL_MINUTES := 5
const PLANS := ["tree:", "route:", "ahead:"]

## [T] tuning values (design 10.5), each set by its bar in tools/bjj_tree_balance.gd (S384 calibration, log in
## tmp/s384/gametree1_build/TUNING.md). Design start -> shipped: TAP_VALUE 10 -> 20, EPS 0.2 -> 0.17, MOOD_W 5 -> 4,
## MF_CEIL 1.8 -> 1.4, BASE_ENTRY 0.5 -> 0.42, BASE_TRANSITION 0.4 -> 0.45, BASE_BACK_PRO 0.35 -> 0.30, BEAT_S 22 -> 33,
## PLAN_PULL 2 -> 1.5, CHAIN 1.15 -> 1.1, D_NONE 0.7 -> 0.9; the rest at the design's start. Stage-2 bars (9, 10, 12)
## have not been run on CHAIN / READ_W / D_NONE / PLAN_PULL yet.
const T0 := {"TAP_VALUE": 20.0, "EPS": 0.17, "STYLE_W": 2.0, "LATE_S": 60.0, "MOOD_W": 4.0, "MF_CEIL": 1.4,
	"BASE_ENTRY": 0.42, "BASE_TRANSITION": 0.45, "BASE_ESCAPE": 0.30, "BASE_BACK_PRO": 0.30, "BASE_TAKEDOWN": 0.33,
	"BACK_FINISH_W": 0.36, "OFF_BELT": 0.5, "BEAT_S": 33.0, "FELT": 15.0, "ROLL_EVERY": 2,
	"PLAN_PULL": 1.5, "CHAIN": 1.1, "READ_W": 0.6, "D_NONE": 0.9, "FILM_OPENS": 3}
## The design's start values (10.5): the formula tests check the worked numbers of 3.3 against these.
const T_DESIGN := {"TAP_VALUE": 10.0, "EPS": 0.2, "STYLE_W": 2.0, "LATE_S": 60.0, "MOOD_W": 5.0, "MF_CEIL": 1.8,
	"BASE_ENTRY": 0.50, "BASE_TRANSITION": 0.40, "BASE_ESCAPE": 0.30, "BASE_BACK_PRO": 0.35, "BASE_TAKEDOWN": 0.33,
	"BACK_FINISH_W": 0.36, "OFF_BELT": 0.5, "BEAT_S": 22.0, "FELT": 15.0, "ROLL_EVERY": 2,
	"PLAN_PULL": 2.0, "CHAIN": 1.15, "READ_W": 0.6, "D_NONE": 0.7, "FILM_OPENS": 3}
static var T: Dictionary = T0.duplicate()
static var _data: Dictionary = {}


static func reset_tuning() -> void:
	T = T0.duplicate()


# --- the map -----------------------------------------------------------------------------------------------------------

## {nodes{id:}, moves{id:}, edges{id:}, routes{id:}, from{node:[edge]}, into{node:[edge]}, meta, edge_ids[] (JSON order)}
static func data() -> Dictionary:
	if not _data.is_empty():
		return _data
	var raw: Variant = JSON.parse_string(FileAccess.get_file_as_string(PATH))
	if not (raw is Dictionary):
		push_error("BjjTree: %s did not parse" % PATH)
		return {}
	var d := {"nodes": {}, "moves": {}, "edges": {}, "routes": {}, "from": {}, "into": {}, "meta": raw.get("meta", {}), "edge_ids": []}
	for n in raw["nodes"]:
		d["nodes"][str(n["id"])] = n
		d["from"][str(n["id"])] = []
		d["into"][str(n["id"])] = []
	for m in raw["moves"]:
		d["moves"][str(m["id"])] = m
	for e in raw["edges"]:
		d["edges"][str(e["id"])] = e
		d["edge_ids"].append(str(e["id"]))
		(d["from"].get_or_add(str(e["from"]), []) as Array).append(e)
		(d["into"].get_or_add(str(e["ok"]), []) as Array).append(e)
	for r in raw["routes"]:
		d["routes"][str(r["id"])] = r
	_data = d
	return _data


static func node(id: String) -> Dictionary:
	return data()["nodes"].get(id, {})


static func move(id: String) -> Dictionary:
	return data()["moves"].get(id, {})


static func edge(id: String) -> Dictionary:
	return data()["edges"].get(id, {})


static func route(id: String) -> Dictionary:
	return data()["routes"].get(id, {})


## The label: NoGi.move_name for syllabus moves (the same words the Playbook shows), the JSON name for the rest.
static func move_name(id: String) -> String:
	var m := move(id)
	if m.is_empty() or str(m.get("src", "")) == "syllabus":
		return NoGi.move_name(id)
	return str(m["name"])


static func mirror(node_id: String) -> String:
	return str(node(node_id).get("mirror", node_id))


static func edges_from(node_id: String) -> Array:
	return data()["from"].get(node_id, [])


static func edges_into(node_id: String) -> Array:
	return data()["into"].get(node_id, [])


static func is_base(move_id: String) -> bool:
	return str(move(move_id).get("src", "")) == "base"


static func is_ending(node_id: String) -> bool:
	return node_id == "tap_win" or node_id == "tap_loss"


# --- mastery -----------------------------------------------------------------------------------------------------------

## Class time teaches a tree move: 30 below the athlete's belt, 30 x the share of the belt's classes at it, 0 above.
static func class_part(f: Dictionary, move_id: String) -> float:
	var mb := BeltRoad.rank(str(move(move_id).get("belt", "white")))
	var fb := BeltRoad.rank(str(f.get("belt", "white")))
	if mb < fb:
		return BeltRoad.OWNED_AT
	if mb > fb:
		return 0.0
	var need := float(BeltRoad.CLASSES_TO_NEXT.get(str(f.get("belt", "white")), 0))
	if need <= 0.0:
		return BeltRoad.OWNED_AT
	return BeltRoad.OWNED_AT * minf(1.0, float(f.get("mat_classes", 0)) / need)


## syllabus: f["bjj"][id]; tree: min(100, class_part + f["tree"][id]); BASE: 100.
static func mastery(f: Dictionary, move_id: String) -> float:
	var m := move(move_id)
	match str(m.get("src", "")):
		"base":
			return 100.0
		"tree":
			return minf(100.0, class_part(f, move_id) + float((f.get("tree", {}) as Dictionary).get(move_id, 0.0)))
	return float((f.get("bjj", {}) as Dictionary).get(move_id, 0.0))


## Every non-BASE move -> its mastery (the week report's before/after snapshots).
static func levels(f: Dictionary) -> Dictionary:
	var out := {}
	for id in data()["moves"]:
		if not is_base(id):
			out[id] = mastery(f, id)
	return out


static func state(m: float) -> String:
	if m < float(T["FELT"]):
		return "learning"
	if m < BeltRoad.OWNED_AT:
		return "felt"
	return "owned" if m < SIGNATURE else "signature"


## Felt or better: tried in an open. Learning moves are only drilled.
static func usable(m: float) -> bool:
	return m >= float(T["FELT"])


# --- rules -------------------------------------------------------------------------------------------------------------

## {belt, legal (the belt whose IBJJF table applies), tier amateur|mid|pro, minutes, roll}. A gym roll: white-belt leg-lock
## rules at any belt, 5 minutes.
static func rules_for(belt: String, roll: bool = false) -> Dictionary:
	var tier := "amateur"
	if belt == "purple":
		tier = "mid"
	elif belt == "brown" or belt == "black":
		tier = "pro"
	return {"belt": belt, "legal": "white" if roll else belt, "tier": tier,
		"minutes": ROLL_MINUTES if roll else BeltRoad.match_minutes(belt), "roll": roll}


static func legal(move_id: String, rules: Dictionary) -> bool:
	return BeltRoad.rank(str(rules.get("legal", "white"))) >= BeltRoad.rank(str(move(move_id).get("ibjjf_min", "white")))


## Nodes (no endings) where the athlete owns no legal non-BASE out-edge.
static func holes(f: Dictionary, rules: Dictionary) -> Array:
	var out: Array = []
	var lv := levels(f)
	for id in data()["nodes"]:
		if is_ending(id):
			continue
		var own := false
		for e in edges_from(id):
			var mv := str(e["move"])
			if not is_base(mv) and legal(mv, rules) and float(lv.get(mv, 0.0)) >= BeltRoad.OWNED_AT:
				own = true
				break
		if not own:
			out.append(id)
	return out


# --- odds --------------------------------------------------------------------------------------------------------------

## The mastery factor: felt m/30, owned 1 + (MF_CEIL - 1) x (m - 30) / 70.
static func mf(m: float) -> float:
	if m < BeltRoad.OWNED_AT:
		return maxf(0.0, m) / BeltRoad.OWNED_AT
	return 1.0 + (float(T["MF_CEIL"]) - 1.0) * (minf(m, 100.0) - BeltRoad.OWNED_AT) / 70.0


static func _kind_rate(kind: String, pro: bool) -> float:
	match kind:
		"entry":
			return float(T["BASE_ENTRY"])
		"transition":
			return float(T["BASE_TRANSITION"])
		"escape":
			return float(T["BASE_ESCAPE"])
		"takedown":
			return float(T["BASE_TAKEDOWN"])
		"base":
			return BASE_P
		"back_take":
			return float(T["BASE_BACK_PRO"]) if pro else float(KIND_BASE["back_take"][0])
	var row: Array = KIND_BASE.get(kind, [0.30, 0.30])
	return float(row[1] if pro else row[0])


## The edge's even-field rate under the bout's rules (overrides, amateur overrides, the kind's row; purple = midpoint).
static func base_rate(e: Dictionary, rules: Dictionary) -> float:
	var mv := str(e["move"])
	if OVERRIDES.has(mv):
		return float(OVERRIDES[mv])
	var tier := str(rules.get("tier", "amateur"))
	if tier == "amateur" and OVERRIDES_AMATEUR.has(mv):
		return float(OVERRIDES_AMATEUR[mv])
	var kind := str(e["odds"])
	match tier:
		"pro":
			return _kind_rate(kind, true)
		"mid":
			return (_kind_rate(kind, false) + _kind_rate(kind, true)) / 2.0
	return _kind_rate(kind, false)


## The defender's best LEGAL answer to the edge (0 when it owns none). An illegal heel hook stops nothing.
static func answer_mastery(defender: Dictionary, e: Dictionary, rules: Dictionary) -> float:
	var best := 0.0
	for a in e.get("answers", []):
		if legal(str(a), rules):
			best = maxf(best, mastery(defender, str(a)))
	return best


## The one formula (design 3.3): BASE edges 0.94; else clamp(base x A x CHAIN x MOOD / (D x READ), 0.03, 0.90).
static func odds(e: Dictionary, m_att: float, m_ans: float, rules: Dictionary, chain: bool = false, read: float = 0.0,
		mood: float = 0.0) -> float:
	if is_base(str(e["move"])):
		return BASE_P
	var p := base_rate(e, rules) * mf(m_att) * (float(T["CHAIN"]) if chain else 1.0) * (1.0 + float(T["MOOD_W"]) * mood)
	p /= maxf(float(T["D_NONE"]), mf(m_ans)) * (1.0 + float(T["READ_W"]) * read)
	return clampf(p, CLAMP.x, CLAMP.y)


## A miss slides down the bad arrow only as far as the defender owns the answer.
static func p_bad(m_ans: float) -> float:
	return minf(1.0, maxf(0.0, m_ans) / P_BAD_AT)


## Exactly NoGi.win_chance's mood term: (morale - 60) / 400 - TOUGH; 0 for a dict without morale.
static func mood_of(f: Dictionary) -> float:
	if not f.has("morale"):
		return 0.0
	return (float(f["morale"]) - NoGi.MORALE_START) / NoGi.MORALE_SPAN - (NoGi.TOUGH if bool(f.get("tough_next", false)) else 0.0)


static func chip_word(p: float) -> String:
	if p >= LIKELY_AT:
		return "LIKELY"
	return "EVEN" if p >= LONG_SHOT_BELOW else "LONG SHOT"


## The value of standing on a node: its finish share x TAP_VALUE (back_top: T BACK_FINISH_W); a tap is +-TAP_VALUE.
static func node_value(node_id: String) -> float:
	if node_id == "tap_win":
		return float(T["TAP_VALUE"])
	if node_id == "tap_loss":
		return -float(T["TAP_VALUE"])
	var w := float(T["BACK_FINISH_W"]) if node_id == "back_top" else float(node(node_id).get("finish_w", 0.0))
	return w * float(T["TAP_VALUE"])


static func watcher_iq(f: Dictionary) -> float:
	return float(f.get("iq", IQ.get(str(f.get("belt", "white")), 40.0)))


# --- routes ------------------------------------------------------------------------------------------------------------

## Each step starts where the last one landed (BASE steps allowed).
static func route_ok(steps: Array) -> bool:
	if steps.is_empty():
		return false
	var at := ""
	for id in steps:
		var e := edge(str(id))
		if e.is_empty() or (at != "" and str(e["from"]) != at):
			return false
		at = str(e["ok"])
	return true


static func route_legal(steps: Array, rules: Dictionary) -> bool:
	return steps.all(func(id): return legal(str(edge(str(id)).get("move", "")), rules))


## The plan's chance against an even answer (30): the product of each non-BASE step's p, CHAIN from the 2nd plan step;
## a learning step counts 0.
static func route_chance(f: Dictionary, steps: Array, rules: Dictionary) -> float:
	var p := 1.0
	var first := true
	for id in steps:
		var e := edge(str(id))
		var mv := str(e.get("move", ""))
		if e.is_empty() or is_base(mv):
			continue
		var m := mastery(f, mv)
		p *= odds(e, m, BeltRoad.OWNED_AT, rules, not first) if usable(m) else 0.0
		first = false
	return p


## The plan the walk follows: f["bjj_plan"].steps when they still chain and are legal; else the coach's default - the
## preset route legal at the rules with the best route_chance for the athlete (ties: more usable steps, then JSON order).
static func plan_of(f: Dictionary, rules: Dictionary) -> Array:
	var own: Array = (f.get("bjj_plan", {}) as Dictionary).get("steps", [])
	if route_ok(own) and route_legal(own, rules):
		return own
	var best: Array = []
	var top := -1.0
	for rid in data()["routes"]:
		var steps: Array = route(rid)["steps"]
		if not route_legal(steps, rules):
			continue
		var usable_n := steps.filter(func(id): return usable(mastery(f, str(edge(str(id))["move"])))).size()
		var score := route_chance(f, steps, rules) + 0.001 * usable_n
		if score > top:
			top = score
			best = steps
	return best


# --- the week (tree drilling, FLOW rule: scale the cost, never lock) ---------------------------------------------------

static func is_tree_plan(plan: String) -> bool:
	return PLANS.any(func(p): return plan.begins_with(p))


## {move, store "bjj"|"tree", n (belts above the athlete's)} or {} (done at SIGNATURE, unknown id, wrong prefix).
## tree:<id> a tree move; ahead:<id> a syllabus move of another belt; route:<id> the route's lowest non-BASE move < 50.
static func drill_target(f: Dictionary, plan: String) -> Dictionary:
	var belt := str(f.get("belt", "white"))
	var id := plan.get_slice(":", 1)
	var mv := ""
	if plan.begins_with("tree:"):
		if str(move(id).get("src", "")) == "tree":
			mv = id
	elif plan.begins_with("ahead:"):
		if str(move(id).get("src", "")) == "syllabus" and str(move(id).get("belt", "")) != belt:
			mv = id
	elif plan.begins_with("route:"):
		var low := SIGNATURE
		for eid in route(id).get("steps", []):
			var m := str(edge(str(eid))["move"])
			if not is_base(m) and mastery(f, m) < low:
				low = mastery(f, m)
				mv = m
	if mv == "" or mastery(f, mv) >= SIGNATURE:
		return {}
	return {"move": mv, "store": "tree" if str(move(mv)["src"]) == "tree" else "bjj",
		"n": maxi(0, BeltRoad.rank(str(move(mv)["belt"])) - BeltRoad.rank(belt))}


## The drilled move's gain a week: NoGi.gain_of x HUNGRY (stripe held) x OFF_BELT^n.
static func gain(f: Dictionary, n: int) -> float:
	return NoGi.gain_of(f) * (NoGi.HUNGRY if int(f.get("held", 0)) > 0 else 1.0) * pow(float(T["OFF_BELT"]), n)


## A tree-plan week: the classes count (as NoGi.week), the target gains. Returns the move ("" when the plan is done).
static func week(f: Dictionary, _day: int = 0) -> String:
	f["mat_classes"] = int(f.get("mat_classes", 0)) + NoGi.classes_of(f)
	var t := drill_target(f, str(f.get("drill", "")))
	var mv := str(t.get("move", ""))
	f["drill_on"] = mv
	f["drill_n"] = int(t.get("n", 0))
	if mv != "":
		var store: Dictionary = f.get_or_add(str(t["store"]), {})
		store[mv] = minf(100.0, float(store.get(mv, 0.0)) + gain(f, int(t["n"])))
	return mv


## The week's mark for the report: {move, move_name, before, after, n, levels_before}.
static func week_mark(f: Dictionary, before_levels: Dictionary, mv: String) -> Dictionary:
	return {"move": mv, "move_name": move_name(mv) if mv != "" else "", "before": float(before_levels.get(mv, 0.0)),
		"after": mastery(f, mv) if mv != "" else 0.0, "n": int(f.get("drill_n", 0)), "levels_before": before_levels}


## The Drill plan for a move: "move:" (a syllabus move of the athlete's belt), "tree:" or "ahead:".
static func drill_plan_for(f: Dictionary, move_id: String) -> String:
	var m := move(move_id)
	if str(m.get("src", "")) == "tree":
		return "tree:" + move_id
	if str(m.get("belt", "")) == str(f.get("belt", "white")):
		return "move:" + move_id
	return "ahead:" + move_id


## The Drill pick for a node: its legal non-BASE out-edge move closest to owned (highest mastery under 30), ties by points.
static func leak_move(f: Dictionary, node_id: String, rules: Dictionary) -> String:
	var best := ""
	var top := -1.0
	for e in edges_from(node_id):
		var mv := str(e["move"])
		if is_base(mv) or not legal(mv, rules):
			continue
		var m := mastery(f, mv)
		var score := m + 0.01 * float(e["points"])
		if m < BeltRoad.OWNED_AT and score > top:
			top = score
			best = mv
	return best
