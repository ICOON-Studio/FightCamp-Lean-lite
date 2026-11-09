extends RefCounted
## S398 a bout nobody watches, fought on the player's own maths (FIGHTER_MODEL_S397.md v2 section 7): the distance ladder,
## the duels, tired and hurt, form on the night, the exchange dice (Exchanges.EX_SPREAD), knockdowns from either side.
## No corner, no plan. fight() rolls one; chance() is its exact expectation without knockdowns (offers, the bot test, bars).
## fast() is the world's everyday path (S398: a month of every division, the bot careers): the pair's expected edge per
## exchange comes from a cache (edges(), recomputed once the levels drift CACHE_DRIFT apart from when it was made), then
## the dice, the form and the knockdowns are rolled as in fight(); the ladder's mean is in the edges.
## a / b = boxer dicts (world, region or opponent shape: rating, shape, style, words, age, reach, height, stance) or
## {"attrs": {...}} for a ready profile. Pure static.

const Attrs := preload("res://scripts/rules/Attrs.gd")
const AttrGen := preload("res://scripts/rules/AttrGen.gd")
const Duels := preload("res://scripts/rules/Duels.gd")
const Exchanges := preload("res://scripts/rules/Exchanges.gd")
const Combos := preload("res://scripts/rules/Combos.gd")
const Knockdowns := preload("res://scripts/rules/Knockdowns.gd")
const ComboOdds := preload("res://scripts/rules/ComboOdds.gd")

const FORM_SD := 8.0   # world bouts only: wide enough that a +18 rating is not a certain win (bar 4). A watched bout uses RingDuel.FORM_SD.
## A round's energy spend: moving and guarding + punches at the pace dial (Combos' numbers).
const PACE_SPEND := [0.8, 0.4]
## Gauss-Hermite (probabilists') nodes and weights for the form difference.
const GH_X := [-2.8570, -1.3556, 0.0, 1.3556, 2.8570]
const GH_W := [0.01126, 0.22208, 0.53333, 0.22208, 0.01126]
const CACHE_DRIFT := 3.0
const MEAN_LANDED := 3.5
const HURT_BASE := 0.18
const HURT_EDGE_SCALE := 90.0
const HURT_POWER_SCALE := 60.0
const HURT_MAX := 0.5
const HURT_WEIGHT := 4.0

static var _cache := {}


static func profile(b: Dictionary) -> Dictionary:
	if b.has("attrs") and not (b["attrs"] as Dictionary).is_empty():
		return b["attrs"]
	return AttrGen.attrs_of(b)


static func spend(a: Dictionary) -> float:
	var p := Duels.v(a, "pace") / 100.0
	# The engine sets how fast the work drains the tank (bar 8, S398: engine was near-dead on the world's path).
	return (Combos.ROUND_COST + Combos.PUNCHES * Combos.PUNCH_COST * Combos.POWER_MIX * (PACE_SPEND[0] + PACE_SPEND[1] * p)) \
		* (1.5 - Duels.v(a, "engine") / 100.0)


## Expected body work that landed: the target's body changes the drain after the punch, never whether it lands.
static func _body_drain(attacker: Dictionary, defender: Dictionary) -> float:
	var body_attack := 0.5 * Duels.v(attacker, "hooks") + 0.3 * Duels.v(attacker, "power") + 0.2 * Duels.v(attacker, "inside")
	var shots := float(Exchanges.EXCHANGES) * MEAN_LANDED * Exchanges.BODY_SHARE
	return shots * Exchanges.body_cost(Duels.v(defender, "body")) * clampf(1.0 + (body_attack - 60.0) / 100.0, 0.7, 1.3)


## The tank's fitness for the refill between rounds: recovery's job (bar 8, S398: recovery was dead at an even split).
static func _cond(a: Dictionary) -> float:
	return 0.15 * Duels.v(a, "engine") + 0.85 * Duels.v(a, "recovery")


## The energy at each exchange's start of every round, both sides: [[a per exchange], [b per exchange]] x rounds, plus the
## bell's tired penalty edge per round.
static func tanks(a: Dictionary, b: Dictionary, rounds: int) -> Array:
	var ea := Combos.TANK
	var eb := Combos.TANK
	var qa := 0.0
	var qb := 0.0
	var out: Array = []
	for n in rounds:
		var ra := Combos.after_round(ea, qa, spend(a) + _body_drain(b, a), _cond(a))
		var rb := Combos.after_round(eb, qb, spend(b) + _body_drain(a, b), _cond(b))
		var pa: Array = []
		var pb: Array = []
		for i in Exchanges.EXCHANGES:
			pa.append(lerpf(ea, float(ra["bell"]), float(i) / Exchanges.EXCHANGES))
			pb.append(lerpf(eb, float(rb["bell"]), float(i) / Exchanges.EXCHANGES))
		out.append({"a": pa, "b": pb, "edge": Combos.tired_penalty(float(rb["bell"])) - Combos.tired_penalty(float(ra["bell"]))})
		ea = float(ra["next"])
		eb = float(rb["next"])
		qa = float(ra["debt"])
		qb = float(rb["debt"])
	return out


## Cheap world-path hurt state: the last exchange's edge can leave either boxer compromised; recovery clears it, heart
## keeps working and composure keeps the defence together. This is an expected edge so fast() and shown odds stay aligned.
static func _hurt_cost(a: Dictionary) -> float:
	return HURT_WEIGHT * Duels.HURT_DEF * (1.2 - Duels.v(a, "composure") / 100.0) * (1.35 - Duels.v(a, "recovery") / 100.0) \
		* (1.25 - Duels.v(a, "heart") / 100.0)


static func _hurt_edge(last: float, a: Dictionary, b: Dictionary) -> float:
	var pa := clampf(HURT_BASE + maxf(0.0, last) / HURT_EDGE_SCALE \
		+ (Duels.v(a, "power") - Duels.v(b, "chin")) / HURT_POWER_SCALE, 0.0, HURT_MAX)
	var pb := clampf(HURT_BASE + maxf(0.0, -last) / HURT_EDGE_SCALE \
		+ (Duels.v(b, "power") - Duels.v(a, "chin")) / HURT_POWER_SCALE, 0.0, HURT_MAX)
	return pa * _hurt_cost(b) - pb * _hurt_cost(a)


static func _with_hurt(row: Array, a: Dictionary, b: Dictionary) -> Array:
	var out: Array = []
	var last := 0.0
	for edge in row:
		var base := float(edge)
		out.append(base + _hurt_edge(last, a, b))
		last = base
	return out


static func _ctx(x: Dictionary, y: Dictionary) -> Dictionary:
	return Duels.facts(x, y)


## One bout. Returns {winner: "a"|"b"|"", stopped, how, round, rounds_won: [a, b], kd: [a, b], places: [long, pocket, inside],
## duels: {tool: count}}.
static func fight(x: Dictionary, y: Dictionary, rounds: int, rng: RandomNumberGenerator) -> Dictionary:
	var a := profile(x)
	var b := profile(y)
	var ctx := _ctx(x, y)
	var form := rng.randfn(0.0, FORM_SD) - rng.randfn(0.0, FORM_SD)
	var tk := tanks(a, b, rounds)
	var won := [0, 0]
	var counts := {"a": 0, "b": 0}
	var damage := {"a": 0.0, "b": 0.0}
	var places := [0, 0, 0]
	var duels := {}
	var sides := {"a": _side(a), "b": _side(b)}
	var place := Duels.LONG
	var last_edge := 0.0
	for n in rounds:
		var pins := [0, 0]
		var sum := 0.0
		var wn := 0
		var late := n >= 2
		for i in Exchanges.EXCHANGES:
			var ea := Duels.effective(a, float(tk[n]["a"][i]), false, late)
			var eb := Duels.effective(b, float(tk[n]["b"][i]), false, late)
			var st := Duels.step(ea, eb, place, ctx, -1, -1, pins, rng.randf(), rng.randf(), rng.randf())
			place = int(st["place"])
			pins = [Duels.pin_next(int(pins[0]), int(st["wa"]), place), Duels.pin_next(int(pins[1]), int(st["wb"]), place)]
			var c := ctx.duplicate()
			c["stepin"] = int(st["stepin"])
			var d := Duels.at(ea, eb, place, c)
			var duel_edge := float(d["edge"])
			var margin := duel_edge + _hurt_edge(last_edge, a, b) + form + float(tk[n]["edge"]) + (rng.randf() - 0.5) * Exchanges.EX_SPREAD \
				- (rng.randf() - 0.5) * Exchanges.EX_SPREAD
			last_edge = duel_edge
			places[place] += 1
			var tool := str(d["a_best"]) if margin >= 0.0 else str(d["b_best"])
			duels[tool] = int(duels.get(tool, 0)) + 1
			sum += margin
			wn += 1 if margin >= 0.0 else 0
		var a_round := wn * 2 > Exchanges.EXCHANGES or (wn * 2 == Exchanges.EXCHANGES and sum >= 0.0)
		won[0 if a_round else 1] += 1
		var loser := "b" if a_round else "a"
		var band := Exchanges.band(sum / float(Exchanges.EXCHANGES))
		var k := Knockdowns.round_counts(band, loser, sides, damage, counts, rng)
		damage = k["damage"]
		counts[loser] = int(counts[loser]) + int(k["counts"])
		if bool(k["stopped"]):
			return _out("a" if loser == "b" else "b", true, str(k["how"]), n + 1, won, counts, places, duels)
		var winner := "a" if loser == "b" else "b"
		var kc := Knockdowns.puncher_chance(winner, sides, damage, counts, rng)
		counts[winner] = int(counts[winner]) + int(kc["counts"])
		if bool(kc["stopped"]):
			return _out(loser, true, str(kc["how"]), n + 1, won, counts, places, duels)
	var w := "a" if won[0] > won[1] else ("b" if won[1] > won[0] else "")
	return _out(w, false, "", rounds, won, counts, places, duels)


static func _out(w: String, stopped: bool, how: String, rd: int, won: Array, counts: Dictionary, places: Array, duels: Dictionary) -> Dictionary:
	return {"winner": w, "stopped": stopped, "how": how, "round": rd, "rounds_won": won, "kd": [int(counts["b"]), int(counts["a"])],
		"places": places, "duels": duels}


## A pair's cached rows and the level drift since: {rows, extra}. Profiles given as {"attrs"} are not cached.
static func cached(x: Dictionary, y: Dictionary, rounds: int) -> Dictionary:
	if x.has("attrs") or y.has("attrs"):
		return {"rows": edges(x, y, rounds)["rounds"], "extra": 0.0}
	var key := "%s|%s|%d" % [_key(x), _key(y), rounds]
	var ra := float(x.get("rating", 60.0))
	var rb := float(y.get("rating", 60.0))
	var c: Dictionary = _cache.get(key, {})
	if c.is_empty() or absf(ra - float(c["ra"])) > CACHE_DRIFT or absf(rb - float(c["rb"])) > CACHE_DRIFT:
		c = {"rows": quick_rows(x, y, rounds), "ra": ra, "rb": rb,
			"sides": {"a": _side(profile(x)), "b": _side(profile(y))}}
		_cache[key] = c
	var extra := (ra - float(c["ra"])) - (rb - float(c["rb"]))
	# Sides belong to the levels the rows were built at. A drift inside the window rebuilds them in fast().
	return {"rows": c["rows"], "extra": extra, "sides": c["sides"] if absf(extra) <= 0.001 else {}}


static func _key(b: Dictionary) -> String:
	var flat := true
	for v in (b.get("shape", {}) as Dictionary).values():
		if absf(float(v)) > 0.0001:
			flat = false
			break
	var shaped := "L" if flat and b.has("shape") else "S"
	var sh: Dictionary = b.get("shape", {})
	return "%s:%s:%s:%d:%.2f:%.2f" % [str(b.get("id", "")), str(b.get("name", "")), shaped, int(b.get("age", 0)),
		float(sh.get("explosiveness", sh.get("power", 0.0))), float(sh.get("jab", 0.0))]


## The everyday bout: cached expected edges, the dice, form and knockdowns. Same result shape as fight() (no places/duels).
static func fast(x: Dictionary, y: Dictionary, rounds: int, rng: RandomNumberGenerator) -> Dictionary:
	var c := cached(x, y, rounds)
	var rows: Array = c["rows"]
	var sides: Dictionary = c.get("sides", {})
	if sides.is_empty():
		sides = {"a": _side(profile(x)), "b": _side(profile(y))}
	var form := rng.randfn(0.0, FORM_SD) - rng.randfn(0.0, FORM_SD) + float(c["extra"])
	var won := [0, 0]
	var counts := {"a": 0, "b": 0}
	var damage := {"a": 0.0, "b": 0.0}
	for n in rounds:
		var sum := 0.0
		var wn := 0
		for i in Exchanges.EXCHANGES:
			var margin := float(rows[n][i]) + form + (rng.randf() - 0.5) * Exchanges.EX_SPREAD - (rng.randf() - 0.5) * Exchanges.EX_SPREAD
			sum += margin
			wn += 1 if margin >= 0.0 else 0
		var a_round := wn * 2 > Exchanges.EXCHANGES or (wn * 2 == Exchanges.EXCHANGES and sum >= 0.0)
		won[0 if a_round else 1] += 1
		var loser := "b" if a_round else "a"
		var k := Knockdowns.round_counts(Exchanges.band(sum / float(Exchanges.EXCHANGES)), loser, sides, damage, counts, rng)
		damage = k["damage"]
		counts[loser] = int(counts[loser]) + int(k["counts"])
		if bool(k["stopped"]):
			return _out("a" if loser == "b" else "b", true, str(k["how"]), n + 1, won, counts, [0, 0, 0], {})
		var winner := "a" if loser == "b" else "b"
		var kc := Knockdowns.puncher_chance(winner, sides, damage, counts, rng)
		counts[winner] = int(counts[winner]) + int(kc["counts"])
		if bool(kc["stopped"]):
			return _out(loser, true, str(kc["how"]), n + 1, won, counts, [0, 0, 0], {})
	var w := "a" if won[0] > won[1] else ("b" if won[1] > won[0] else "")
	return _out(w, false, "", rounds, won, counts, [0, 0, 0], {})


## The everyday edges (S398: a world of new pairs every career): each round's duels on the attributes at the round's
## middle energy (tired, late heart), the ladder walked as a 3x3 chance matrix from the long opening with the step-in
## counter on a closing move (no ropes). Dozens of duel reads a pair instead of the exact walk's hundreds;
## tests/fighter_model_test.gd holds it near edges().
static func quick_rows(x: Dictionary, y: Dictionary, rounds: int) -> Array:
	var a0 := profile(x)
	var b0 := profile(y)
	var ctx := _ctx(x, y)
	var tk := tanks(a0, b0, rounds)
	var out: Array = []
	var v := [1.0, 0.0, 0.0]
	for n in rounds:
		var mid := Exchanges.EXCHANGES / 2
		var a := Duels.effective(a0, float(tk[n]["a"][mid]), false, n >= 2)
		var b := Duels.effective(b0, float(tk[n]["b"][mid]), false, n >= 2)
		var reach := float(ctx.get("reach", 0.0))
		var height := float(ctx.get("height", 0.0))
		var south := int(ctx.get("southpaw", 0))
		var wa := Duels.wants(a, b, ctx)
		var wb := Duels.wants(b, a, Duels.flip(ctx))
		var ed := PackedFloat32Array()
		ed.resize(9)
		var have := PackedByteArray()
		have.resize(9)
		var t := [[0.0, 0.0, 0.0], [0.0, 0.0, 0.0], [0.0, 0.0, 0.0]]
		var ev := [0.0, 0.0, 0.0]
		for s0 in 3:
			for xa in 3:
				if float(wa[xa]) <= 0.0:
					continue
				for xb in 3:
					var pw := float(wa[xa]) * float(wb[xb])
					if pw <= 0.0:
						continue
					_pour(a, b, s0, xa, xb, pw, ev, t, ed, have, reach, height, south)
		var row: Array = []
		for i in Exchanges.EXCHANGES:
			row.append(float(v[0]) * float(ev[0]) + float(v[1]) * float(ev[1]) + float(v[2]) * float(ev[2]) + float(tk[n]["edge"]))
			var nv := [0.0, 0.0, 0.0]
			for s0 in 3:
				for s1 in 3:
					nv[s1] += float(v[s0]) * float(t[s0][s1])
			v = nv
		out.append(_with_hurt(row, a0, b0))
	return out


## One cell of the place matrix. Pins stay off on this path (quick_rows walks no ropes). Same moves as Duels.moves.
static func _pour(a: Dictionary, b: Dictionary, s0: int, xa: int, xb: int, pw: float, ev: Array, t: Array, ed: PackedFloat32Array, have: PackedByteArray, reach: float, height: float, south: int) -> void:
	var da := signi(xa - s0)
	var db := signi(xb - s0)
	if da == db:
		if da == 0:
			_cell(a, b, s0, s0, pw, -1, ev, t, ed, have, reach, height, south)
		else:
			_cell(a, b, s0, s0 + da, pw * Duels.SAME_WAY, -1, ev, t, ed, have, reach, height, south)
			_cell(a, b, s0, s0, pw * (1.0 - Duels.SAME_WAY), -1, ev, t, ed, have, reach, height, south)
		return
	var ca := Duels.control(a, da, s0, false)
	var cb := Duels.control(b, db, s0, false)
	var pa := clampf(0.5 + (ca - cb) / Duels.STEER_SPAN, Duels.STEER_MIN, Duels.STEER_MAX)
	var a_to := s0 + da
	var b_to := s0 + db
	if da > 0 and xa - s0 >= 2 and ca - cb >= Duels.TWO_STEP_GAP:
		a_to = mini(xa, s0 + 2)
	if db > 0 and xb - s0 >= 2 and cb - ca >= Duels.TWO_STEP_GAP:
		b_to = mini(xb, s0 + 2)
	var sa := (1 if da > 0 else -1) if da != 0 else (0 if db > 0 else -1)
	var sb := (0 if db > 0 else -1) if db != 0 else (1 if da > 0 else -1)
	_cell(a, b, s0, a_to, pw * pa, sa, ev, t, ed, have, reach, height, south)
	_cell(a, b, s0, b_to, pw * (1.0 - pa), sb, ev, t, ed, have, reach, height, south)


static func _cell(a: Dictionary, b: Dictionary, s0: int, place: int, w: float, stepin: int, ev: Array, t: Array, ed: PackedFloat32Array, have: PackedByteArray, reach: float, height: float, south: int) -> void:
	var si := stepin if place > s0 else -1
	var slot := place * 3 + si + 1
	if have[slot] == 0:
		ed[slot] = Duels.edge_of(a, b, place, reach, height, south, si)
		have[slot] = 1
	t[s0][place] = float(t[s0][place]) + w
	ev[s0] = float(ev[s0]) + w * ed[slot]


## The knockdown side of a profile: the punch (power with accuracy), the chin, the heart.
static func _side(a: Dictionary) -> Dictionary:
	return {"power": 0.7 * Duels.v(a, "power") + 0.3 * Duels.v(a, "accuracy"), "chin": Duels.v(a, "chin"), "heart": Duels.v(a, "heart")}


## Expected edge per exchange for every round (no form): [[6 edges] x rounds], plus the place share over the bout.
static func edges(x: Dictionary, y: Dictionary, rounds: int) -> Dictionary:
	var a := profile(x)
	var b := profile(y)
	var ctx := _ctx(x, y)
	var tk := tanks(a, b, rounds)
	var out: Array = []
	var share := [0.0, 0.0, 0.0]
	var states: Dictionary = {}
	for n in rounds:
		var ea: Array = []
		var eb: Array = []
		for i in Exchanges.EXCHANGES:
			ea.append(Duels.effective(a, float(tk[n]["a"][i]), false, n >= 2))
			eb.append(Duels.effective(b, float(tk[n]["b"][i]), false, n >= 2))
		var wa: Array = []
		var wb: Array = []
		for i in Exchanges.EXCHANGES:
			wa.append(Duels.wants(ea[i], eb[i], ctx))
			wb.append(Duels.wants(eb[i], ea[i], Duels.flip(ctx)))
		var ex := Duels.expect(ea, eb, ctx, wa, wb, Exchanges.EXCHANGES, states)
		states = ex["states"]
		var row: Array = []
		for e in ex["edges"]:
			row.append(float(e) + float(tk[n]["edge"]))
		out.append(_with_hurt(row, a, b))
		for p in 3:
			share[p] += float(ex["share"][p]) / float(rounds)
	return {"rounds": out, "share": share}


## a's chance to win (draws count half), integrated over form on the night.
static func chance(x: Dictionary, y: Dictionary, rounds: int) -> float:
	var c := cached(x, y, rounds)
	return chance_of(c["rows"], float(c["extra"]))


static func chance_of(rows: Array, extra: float = 0.0) -> float:
	var total := 0.0
	var sd := FORM_SD * sqrt(2.0)
	for j in GH_X.size():
		var d := extra + float(GH_X[j]) * sd
		var rp: Array = []
		for row in rows:
			rp.append(round_odds(row, d))
		total += float(GH_W[j]) * bout_odds(rp)
	return total


## The round from six exchanges with their own edges: most won; a 3-3 split leans like the exchanges do.
static func round_odds(row: Array, d: float) -> float:
	var dist := [1.0]
	var mean_p := 0.0
	for e in row:
		var p := ComboOdds.win_odds(float(e) + d)
		mean_p += p / float(row.size())
		var nd := []
		nd.resize(dist.size() + 1)
		nd.fill(0.0)
		for k in dist.size():
			nd[k] += float(dist[k]) * (1.0 - p)
			nd[k + 1] += float(dist[k]) * p
		dist = nd
	var n := row.size()
	var out := 0.0
	for k in dist.size():
		if k * 2 > n:
			out += float(dist[k])
		elif k * 2 == n:
			out += float(dist[k]) * mean_p
	return out


## The bout from its rounds' odds: most rounds won, a level card counts half.
static func bout_odds(rp: Array) -> float:
	var dist := [1.0]
	for p in rp:
		var nd := []
		nd.resize(dist.size() + 1)
		nd.fill(0.0)
		for k in dist.size():
			nd[k] += float(dist[k]) * (1.0 - float(p))
			nd[k + 1] += float(dist[k]) * float(p)
		dist = nd
	var n := rp.size()
	var out := 0.0
	for k in dist.size():
		if k * 2 > n:
			out += float(dist[k])
		elif k * 2 == n:
			out += float(dist[k]) * 0.5
	return out
