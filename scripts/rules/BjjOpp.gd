extends RefCounted
## GAMETREE1 (S384) the opens' field and the gym partner (design 5.2, 5.5): seeded opponents at a belt, each with one of
## five lane styles, owned moves by the belt's band, a go-to route legal at the belt, and a watcher iq. The same dict
## shape BjjTree.mastery reads (bjj, tree, mat_classes, belt). Marta Kowal is the club partner: class time only, never
## drilled, regenerated at Ana's belt with the same seed when Ana is promoted.
## Pure static; preloads BjjTree, BeltRoad and NoGi.

const BjjTree := preload("res://scripts/rules/BjjTree.gd")
const BeltRoad := preload("res://scripts/rules/BeltRoad.gd")
const NoGi := preload("res://scripts/rules/NoGi.gd")

const STYLES := {"Wrestler": ["standing", "kimura_back"], "Guard player": ["closed_guard", "open_guard"],
	"Passer": ["passing", "top_control"], "Half-guard player": ["half_guard", "escapes"], "Leg locker": ["leg_lock", "open_guard"]}
const STYLE_ORDER := ["Wrestler", "Guard player", "Passer", "Half-guard player", "Leg locker"]
const PARTNER_NAME := "Marta Kowal"
const PARTNER_STYLE := "Passer"
## ESTIMATE (design 4.5): owned moves a belt uses. Counted as owned syllabus moves of every belt plus owned tree moves of
## the opponent's own belt (class-taught lower-belt tree moves are not counted; a fresh blue already owns 34 that way).
## Purple = blue + 1 system, brown/black + 2-3 (the extra systems are the go-to routes at ROUTE_M); capped by the pool.
const OWNED_BAND := {"white": [8, 12], "blue": [25, 36], "purple": [30, 40], "brown": [36, 46], "black": [40, 50]}
## The white groups lean the field to the game that tests them: escapes -> Passer, passes and sweeps -> Guard player,
## takedowns and submissions -> Wrestler.
const LEAN_STYLE := ["Passer", "Guard player", "Wrestler"]
## [T] (bar 1 / bar 12 / bar 11c). UNOWNED_M and LEAN_W are new values the design does not give (flagged in the report).
## S384 calibration: OWNED_M 30-50 -> 30-45, CLASS_SHARE 0.4-0.9 -> 0.5-0.9, UNOWNED_M 5-28 -> 11-26 (bars 1, 3, 4).
const T0 := {"OWNED_M": Vector2(30, 45), "CLASS_SHARE": Vector2(0.5, 0.9), "ROUTE_M": Vector2(50, 70),
	"UNOWNED_M": Vector2(11, 26), "LEAN_W": 2.0}
static var T: Dictionary = T0.duplicate()


static func reset_tuning() -> void:
	T = T0.duplicate()


static func _mv_belt(id: String) -> String:
	return str(BjjTree.move(id).get("belt", "white"))


## Every non-BASE move of the route sits at or below the belt and is IBJJF-legal there.
static func route_fits(rid: String, belt: String) -> bool:
	var rules := BjjTree.rules_for(belt)
	for eid in BjjTree.route(rid).get("steps", []):
		var mv := str(BjjTree.edge(str(eid))["move"])
		if BjjTree.is_base(mv):
			continue
		if BeltRoad.rank(_mv_belt(mv)) > BeltRoad.rank(belt) or not BjjTree.legal(mv, rules):
			return false
	return true


## A route in the style's lanes that fits the belt, else any route that fits.
static func go_to(belt: String, style: String, rng: RandomNumberGenerator) -> String:
	var lanes: Array = STYLES.get(style, [])
	var mine: Array = []
	var any: Array = []
	for rid in BjjTree.data()["routes"]:
		if not route_fits(rid, belt):
			continue
		any.append(rid)
		if lanes.has(str(BjjTree.route(rid)["lane"])):
			mine.append(rid)
	var pool := mine if not mine.is_empty() else any
	return str(pool[rng.randi() % pool.size()]) if not pool.is_empty() else ""


## Sets a move to mastery m (tree moves store the part above class time).
static func _put(o: Dictionary, id: String, m: float) -> void:
	if str(BjjTree.move(id).get("src", "")) == "tree":
		(o["tree"] as Dictionary)[id] = maxf(0.0, m - BjjTree.class_part(o, id))
	else:
		(o["bjj"] as Dictionary)[id] = m


static func _rand(rng: RandomNumberGenerator, r: Vector2) -> float:
	return snappedf(rng.randf_range(r.x, r.y), 0.1)


## One seeded opponent at a belt and style: {id, name, first, belt, style, mat_classes, bjj{}, tree{}, route, iq, seed}.
static func generate(belt: String, style: String, seed: int) -> Dictionary:
	var rng := RandomNumberGenerator.new()
	rng.seed = seed
	var first := str(NoGi.OPP_FIRST[rng.randi() % NoGi.OPP_FIRST.size()])
	var last := str(NoGi.OPP_LAST[rng.randi() % NoGi.OPP_LAST.size()])
	var share := rng.randf_range((T["CLASS_SHARE"] as Vector2).x, (T["CLASS_SHARE"] as Vector2).y)
	var o := {"id": "opp_%d" % (seed & 0x7fffffff), "name": "%s %s" % [first, last], "first": first, "belt": belt, "style": style,
		"mat_classes": int(round(share * float(BeltRoad.CLASSES_TO_NEXT.get(belt, 300)))), "bjj": {}, "tree": {},
		"route": "", "iq": float(BjjTree.IQ.get(belt, 40.0)), "seed": seed}
	var rank := BeltRoad.rank(belt)
	var owned := {}
	# Lower belts' syllabus: all owned (tree moves of lower belts come through class time, 30).
	for b in BeltRoad.BELTS:
		if BeltRoad.rank(b) < rank:
			for id in BeltRoad.moves_for(b):
				_put(o, id, _rand(rng, T["OWNED_M"]))
				owned[id] = true
	# The go-to route (and at brown/black more systems): ROUTE_M at purple and up, OWNED_M below.
	var systems := 1 + (rng.randi_range(1, 2) if rank >= BeltRoad.rank("brown") else 0)
	var routes: Array = []
	for i in systems:
		var rid := go_to(belt, style, rng)
		if rid == "" or routes.has(rid):
			continue
		routes.append(rid)
		for eid in BjjTree.route(rid)["steps"]:
			var mv := str(BjjTree.edge(str(eid))["move"])
			if BjjTree.is_base(mv):
				continue
			var m := _rand(rng, T["ROUTE_M"] if rank >= BeltRoad.rank("purple") else T["OWNED_M"])
			_put(o, mv, maxf(m, BjjTree.mastery(o, mv)))
			owned[mv] = true
	o["route"] = str(routes[0]) if not routes.is_empty() else ""
	o["routes"] = routes
	# More owned moves from the belt's own pool, the style's lanes weighted, up to the band.
	var lanes: Array = STYLES.get(style, [])
	var pool: Array = []
	for id in BjjTree.data()["moves"]:
		var mvd := BjjTree.move(id)
		if str(mvd["src"]) != "base" and str(mvd["belt"]) == belt and not owned.has(id):
			pool.append(id)
	var band: Array = OWNED_BAND.get(belt, [8, 12])
	var want := rng.randi_range(int(band[0]), int(band[1]))
	while count_owned(o) < want and not pool.is_empty():
		var tot := 0.0
		for id in pool:
			tot += float(BjjTree.T["STYLE_W"]) if lanes.has(str(BjjTree.move(id)["lane"])) else 1.0
		var r := rng.randf() * tot
		var pick := str(pool[0])
		for id in pool:
			r -= float(BjjTree.T["STYLE_W"]) if lanes.has(str(BjjTree.move(id)["lane"])) else 1.0
			if r <= 0.0:
				pick = id
				break
		pool.erase(pick)
		_put(o, pick, _rand(rng, T["OWNED_M"]))
		owned[pick] = true
	# The rest of the belt's syllabus sits below owned; its tree moves keep class time only.
	for id in BeltRoad.moves_for(belt):
		if not owned.has(id):
			_put(o, id, _rand(rng, T["UNOWNED_M"]))
	return o


## The band count: owned syllabus moves of every belt + owned tree moves of the opponent's own belt.
static func count_owned(o: Dictionary) -> int:
	var n := 0
	var belt := str(o.get("belt", "white"))
	for id in BjjTree.data()["moves"]:
		var mvd := BjjTree.move(id)
		var src := str(mvd["src"])
		if src == "base" or (src == "tree" and str(mvd["belt"]) != belt):
			continue
		if BjjTree.mastery(o, id) >= BeltRoad.OWNED_AT:
			n += 1
	return n


## The open's lean group (NoGi.lean_group) draws its style LEAN_W times as often as each other style.
static func pick_style(f: Dictionary, o: Dictionary, rng: RandomNumberGenerator) -> String:
	var lean := ""
	if not NoGi.lean_group(f, o).is_empty():
		lean = str(LEAN_STYLE[int(o["lean"]) % LEAN_STYLE.size()])
	var tot := 0.0
	for s in STYLE_ORDER:
		tot += float(T["LEAN_W"]) if s == lean else 1.0
	var r := rng.randf() * tot
	for s in STYLE_ORDER:
		r -= float(T["LEAN_W"]) if s == lean else 1.0
		if r <= 0.0:
			return s
	return str(STYLE_ORDER[0])


static func field_seed(base_seed: int, o: Dictionary, slot: int) -> int:
	return hash("%d|%s|%d|%d" % [base_seed, str(o.get("name", "")), int(o.get("d", 0)), slot])


## The bracket path: 3 opponents at the athlete's belt, distinct names (one per round).
static func field(f: Dictionary, o: Dictionary, base_seed: int) -> Array:
	var out: Array = []
	var names := {}
	var belt := str(f.get("belt", "white"))
	for slot in 3:
		var s := field_seed(base_seed, o, slot)
		var rng := RandomNumberGenerator.new()
		rng.seed = s
		var style := pick_style(f, o, rng)
		var opp := generate(belt, style, s)
		var bump := 0
		while names.has(opp["name"]) or str(opp["name"]) == PARTNER_NAME:
			bump += 1
			opp = generate(belt, style, hash("%d|%d" % [s, bump]))
		names[opp["name"]] = true
		out.append(opp)
	return out


## The gym partner at the athlete's belt (created once from the career seed).
static func partner(f: Dictionary, base_seed: int) -> Dictionary:
	return partner_at(hash("%d|%s|partner" % [base_seed, str(f.get("id", ""))]), str(f.get("belt", "white")))


## The partner regenerated at a belt from its own seed (a promotion keeps the same person).
static func partner_at(seed: int, belt: String) -> Dictionary:
	var p := generate(belt, PARTNER_STYLE, seed)
	p["name"] = PARTNER_NAME
	p["first"] = PARTNER_NAME.get_slice(" ", 0)
	p["id"] = "partner"
	return p
