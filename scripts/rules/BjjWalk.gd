extends RefCounted
## GAMETREE1 (S384) the honest walk (design 3.2): a seeded paper walk on the one mirrored map. Side 0 is Ana, side 1 the
## opponent; `at` is the node from Ana's view and the opponent stands on mirror(at). The side with the initiative acts: on
## the plan it takes the plan step, off it the best p x gain - (1 - p) x P_bad x loss (EPS: the second best). A hit moves
## and scores and keeps the initiative; a miss slides down the bad arrow only as far as the defender owns the answer, else
## it resets (a missed scoring or submission attempt +1 advantage) and the initiative passes. At the bell: points,
## advantages, then a seeded referee decision. Every hidden rule that moved a beat's odds 5%+ or decided it leaves a note.
## S397 BJJREAL (ops/research/BJJ_REALISM_S397.md 5, design v2 after three critics): every attempt also reads, on the
## logit, side against side: MAT TIME (BjjBody.mat_time - the belt and the classes, attack and defence alike), the BODY
## (BjjBody: strength, flexibility, explosiveness, composure by the move's kind), both TANKS (an attempt costs gas, a hold
## breathes; equal tanks cancel) and each side's FORM on the day (one draw a match, both sides). A landed submission still
## has to beat the FINISH GATE (the defender's escape, by tier and mat time; escaped = a near submission, an advantage).
## The second-best pick (EPS) shrinks with IQ. Aggression bends the chooser (a sub hunter takes the marginal shot and never
## sits on a lead). A hold off a pin is a stall the referee sees; the bell is BjjRef's (points, advantages, penalties, then
## who was more offensive - no coin).
## Pure static; preloads BjjTree, BjjOpp, BeltRoad, TheRead, BjjBody, BjjRef.

const BjjTree := preload("res://scripts/rules/BjjTree.gd")
const TheRead := preload("res://scripts/rules/TheRead.gd")
const BjjOpp := preload("res://scripts/rules/BjjOpp.gd")
const BeltRoad := preload("res://scripts/rules/BeltRoad.gd")
const BjjBody := preload("res://scripts/rules/BjjBody.gd")
const BjjRef := preload("res://scripts/rules/BjjRef.gd")

const NOTE_AT := 0.05
const STYLE_VERB := {"Wrestler": "shot", "Guard player": "attacked from guard", "Passer": "passed or pinned",
	"Half-guard player": "worked from half guard", "Leg locker": "went for the legs"}
const STYLE_LINE_AT := 3


static func clock(t: float) -> String:
	var s := int(t)
	return "%d:%02d" % [s / 60, s % 60]


## The walk's context: both athletes' masteries and caches, built once.
static func _ctx(ana: Dictionary, opp: Dictionary, plans: Array, rules: Dictionary, extra: Dictionary) -> Dictionary:
	var lv: Array = [BjjTree.levels(ana), BjjTree.levels(opp)]
	var pl: Array = [plans[0] if plans.size() > 0 else [], plans[1] if plans.size() > 1 else []]
	return {"f": [ana, opp], "lv": lv, "plans": pl, "rules": rules, "opts": [{}, {}], "ans": [{}, {}], "dist": [{}, {}],
		"names": [str(ana.get("first", "Ana")), str(opp.get("first", "The opponent"))],
		"iq": [BjjTree.watcher_iq(ana), BjjTree.watcher_iq(opp)],
		"lanes": BjjOpp.STYLES.get(str(opp.get("style", "")), []),
		"try_once": extra.get("try_once", []), "tried": {},
		"body": [BjjBody.attrs(ana), BjjBody.attrs(opp)], "bf": [{}, {}], "mat": [BjjBody.mat_time(ana), BjjBody.mat_time(opp)]}


## The levers of side s doing e, on the logit: {body, tank, mat, form} (each 0 when even); the body is cached per edge.
static func _parts(ctx: Dictionary, st: Dictionary, s: int, e: Dictionary) -> Dictionary:
	var c: Dictionary = ctx["bf"][s]
	var id := str(e["id"])
	if not c.has(id):
		c[id] = BjjBody.shift(e, ctx["body"][s], ctx["body"][1 - s])
	return {"body": float(c[id]), "tank": BjjBody.tank(float(st["gas"][s]), float(st["gas"][1 - s])),
		"mat": BjjBody.mat_shift(float(ctx["mat"][s]) - float(ctx["mat"][1 - s])),
		"form": float(st["form"][s]) - float(st["form"][1 - s]),
		"grip": float(BjjTree.T.get("GRIP_W", 0.0)) * (float(st["grip"][s]) - float(st["grip"][1 - s]))}


static func _shift(ctx: Dictionary, st: Dictionary, s: int, e: Dictionary) -> float:
	var x := 0.0
	var parts := _parts(ctx, st, s, e)
	for k in parts:
		x += float(parts[k])
	return x


static func _m(ctx: Dictionary, s: int, mv: String) -> float:
	if BjjTree.is_base(mv):
		return 100.0
	return float((ctx["lv"][s] as Dictionary).get(mv, 0.0))


## The defender's (1 - s) best legal answer to an edge done by s, cached.
static func _ans(ctx: Dictionary, s: int, e: Dictionary) -> float:
	var c: Dictionary = ctx["ans"][s]
	var id := str(e["id"])
	if not c.has(id):
		var best := 0.0
		for a in e.get("answers", []):
			if BjjTree.legal(str(a), ctx["rules"]):
				best = maxf(best, _m(ctx, 1 - s, str(a)))
		c[id] = best
	return float(c[id])


## Legal edges from the side's own node whose move is usable (felt 15+) or BASE. Learning edges are never tried.
static func options(ctx: Dictionary, s: int, own: String) -> Array:
	var c: Dictionary = ctx["opts"][s]
	if not c.has(own):
		var out: Array = []
		for e in BjjTree.edges_from(own):
			var mv := str(e["move"])
			if BjjTree.legal(mv, ctx["rules"]) and (BjjTree.is_base(mv) or BjjTree.usable(_m(ctx, s, mv))):
				out.append(e)
		c[own] = out
	return c[own]


## Steps from each node to `target` on the side's usable + BASE edges (reverse BFS, cached per target).
static func _dist(ctx: Dictionary, s: int, target: String) -> Dictionary:
	var c: Dictionary = ctx["dist"][s]
	if c.has(target):
		return c[target]
	var d := {target: 0}
	var q: Array = [target]
	while not q.is_empty():
		var x: String = q.pop_front()
		for e in BjjTree.edges_into(x):
			var fr := str(e["from"])
			if d.has(fr):
				continue
			var mv := str(e["move"])
			if BjjTree.legal(mv, ctx["rules"]) and (BjjTree.is_base(mv) or BjjTree.usable(_m(ctx, s, mv))):
				d[fr] = int(d[x]) + 1
				q.append(fr)
	c[target] = d
	return d


static func _leads(st: Dictionary, s: int) -> bool:
	var sc: Array = st["score"]
	var ad: Array = st["adv"]
	return int(sc[s]) > int(sc[1 - s]) or (int(sc[s]) == int(sc[1 - s]) and int(ad[s]) > int(ad[1 - s]))


## The side's choice this beat: {e (edge or {} for HOLD), why plan|best|eps|late|hold, alt (the usual pick when EPS)}.
static func choose(ctx: Dictionary, st: Dictionary, s: int, rng: RandomNumberGenerator) -> Dictionary:
	var own: String = st["at"] if s == 0 else BjjTree.mirror(st["at"])
	var opt := options(ctx, s, own)
	var T: Dictionary = BjjTree.T
	var aggr := float(ctx["body"][s]["aggression"])
	var late := float(T["LATE_S"]) * (2.0 if aggr <= BjjBody.CAUTIOUS_AGGR else 1.0)
	if _leads(st, s) and aggr < BjjBody.HOLD_AGGR and float(st["t"]) >= float(st["end"]) - late 			and ["top", "neutral"].has(str(BjjTree.node(own).get("side", ""))):
		return {"e": {}, "why": "late"}
	var plan: Array = ctx["plans"][s]
	var pi := int(st["plan_i"][s])
	var target := ""
	for k in range(pi, plan.size()):
		var pe := BjjTree.edge(str(plan[k]))
		if str(pe["from"]) == own:
			st["plan_i"][s] = k
			if opt.any(func(x): return str(x["id"]) == str(pe["id"])):
				return {"e": pe, "why": "plan", "step": k}
			break
	pi = int(st["plan_i"][s])
	if pi < plan.size():
		target = str(BjjTree.edge(str(plan[pi]))["from"])
	var dist := _dist(ctx, s, target) if target != "" else {}
	var here := int(dist.get(own, -1))
	var cand: Array = [[0.0, {}]]
	var try_once: Array = ctx["try_once"] if s == 0 else []
	for e in opt:
		var mv := str(e["move"])
		var base := BjjTree.is_base(mv)
		var m_ans := _ans(ctx, s, e)
		var p := BjjTree.odds(e, _m(ctx, s, mv), m_ans, ctx["rules"], false, 0.0, float(st["mood"]) if s == 0 else 0.0,
			_shift(ctx, st, s, e))
		var gain := float(e["points"]) + BjjTree.node_value(str(e["ok"]))
		var loss := float(e["bad_gives"]) + BjjTree.node_value(BjjTree.mirror(str(e["bad"])))
		var score := p * gain - (1.0 - p) * (1.0 if base else BjjTree.p_bad(m_ans)) * loss
		if not base:
			score += BjjBody.aggr_bias(aggr)
		if here > 0 and int(dist.get(str(e["ok"]), -1)) == here - 1:
			score += float(T["PLAN_PULL"])
		if s == 1 and score > 0.0 and (ctx["lanes"] as Array).has(str(e["lane"])):
			score *= float(T["STYLE_W"])
		if try_once.has(mv) and not (ctx["tried"] as Dictionary).has(mv):
			score = 1e6
		cand.append([score, e])
	cand.sort_custom(func(a, b): return float(a[0]) > float(b[0]))
	# S397 the second-best pick shrinks with IQ: T.EPS at white (IQ 40), x T.EPS_IQ at brown/black (IQ 85).
	var eps := float(T["EPS"]) * lerpf(1.0, float(T["EPS_IQ"]), clampf((float(ctx["iq"][s]) - 40.0) / 45.0, 0.0, 1.0))
	if cand.size() > 1 and float(cand[0][0]) < 1e6 and rng.randf() < eps:
		return {"e": cand[1][1], "why": "eps", "alt": cand[0][1]}
	return {"e": cand[0][1], "why": "best" if not (cand[0][1] as Dictionary).is_empty() else "hold"}


## Keeps the strongest note per rule: {rule, beat, line, w}.
static func _note(st: Dictionary, rule: String, w: float, line: String) -> void:
	var n: Dictionary = st["notes"]
	if not n.has(rule) or float(n[rule]["w"]) < w:
		n[rule] = {"rule": rule, "beat": int(st["beat"]), "line": line, "w": w}


## A rule's weight on this beat: decided (the roll fell between p with and without it) = 1 + the change; else the
## relative change when it is NOTE_AT or more; 0 = no note.
static func _weigh(p: float, p_without: float, r: float) -> float:
	if r >= minf(p, p_without) and r < maxf(p, p_without):
		return 1.0 + absf(p - p_without)
	var rel := absf(p - p_without) / maxf(0.01, p_without)
	return rel if rel >= NOTE_AT else 0.0


## The match: plans = [Ana's steps, the opponent's steps] (edge ids). extra: {"try_once": [move ids]} (a gym roll's new
## felt moves) and {"no_mood": true}. -> {win, how, score, adv, ref, path [[eid, actor, hit|miss|reset, t]], end, finish,
## t, notes [{rule, beat, line, w}], visits {node: [beats, pts_lost, taps]}, attempts [Ana's, the opponent's]}
static func walk(ana: Dictionary, opp: Dictionary, plans: Array, minutes: int, rules: Dictionary, rng: RandomNumberGenerator,
		extra: Dictionary = {}) -> Dictionary:
	# S398 the two-sided beat (BjjBeat, ~11 s, both sides choose) when T.BEATS2 is on; this loop is the 33-s one-actor beat.
	if float(BjjTree.T.get("BEATS2", 0.0)) > 0.0:
		return load("res://scripts/rules/BjjBeat.gd").walk(ana, opp, plans, minutes, rules, rng, extra)
	var ctx := _ctx(ana, opp, plans, rules, extra)
	var beat_s := float(BjjTree.T["BEAT_S"])
	var st := start(ana, minutes, rules, rng, extra)
	while float(st["t"]) < float(st["end"]):
		var s := int(st["init"])
		var at_before: String = st["at"]
		var vis := visit(st)
		var pick := choose(ctx, st, s, rng)
		if (pick["e"] as Dictionary).is_empty():
			hold(ctx, st, s, pick, at_before, BjjBody.BREATHE)
			_stall(ctx, st, s, at_before if s == 0 else BjjTree.mirror(at_before))
			_top(st)
			st["init"] = 1 - s
			st["t"] = float(st["t"]) + beat_s
			st["beat"] = int(st["beat"]) + 1
			continue
		var hit := attempt(ctx, st, s, pick, rng, vis)
		_top(st)
		if ended(st, str(pick["e"]["move"]), rng, beat_s, vis):
			break
		if not hit:
			st["init"] = 1 - s
		st["t"] = float(st["t"]) + beat_s
		st["beat"] = int(st["beat"]) + 1
	return result(ctx, st, opp, minutes, rng)


## The match state at the first beat (both engines).
static func start(ana: Dictionary, minutes: int, rules: Dictionary, rng: RandomNumberGenerator, extra: Dictionary) -> Dictionary:
	var mood := 0.0 if bool(extra.get("no_mood", false)) or bool(rules.get("roll", false)) else BjjTree.mood_of(ana)
	return {"at": "standing", "init": rng.randi() % 2, "t": 0.0, "end": float(minutes * 60), "score": [0, 0], "adv": [0, 0],
		"plan_i": [0, 0], "plan_hit": [false, false], "looks": [0.0, 0.0], "seen": [0, 0], "mood": mood, "notes": {}, "beat": 0,
		"path": [], "visits": {}, "prev_move": ["", ""], "held": [false, false], "attempts": [0, 0], "style_n": 0,
		"gas": [1.0, 1.0], "ref": BjjRef.new_tally(), "form": _form(rng, bool(rules.get("roll", false))), "grip": [0.0, 0.0],
		"winner": -1, "finish": "", "fin_t": 0.0}


## The beat's visit row of the current node: [beats, points lost, taps].
static func visit(st: Dictionary) -> Array:
	var vis: Array = (st["visits"] as Dictionary).get_or_add(str(st["at"]), [0, 0, 0])
	vis[0] += 1
	return vis


## A hold by s (no attempt): the late-lead note once, a breath of `breath`.
static func hold(ctx: Dictionary, st: Dictionary, s: int, pick: Dictionary, at_before: String, breath: float) -> void:
	if pick["why"] == "late" and not st["held"][s]:
		st["held"][s] = true
		var own: String = at_before if s == 0 else BjjTree.mirror(at_before)
		_note(st, "hold", 0.5, "%d-%d up with %s left: %s held the %s to the bell." % [st["score"][s], st["score"][1 - s],
			clock(float(st["end"]) - float(st["t"])), ctx["names"][s], str(BjjTree.node(own)["name"]).to_lower()])
	st["gas"][s] = minf(1.0, float(st["gas"][s]) + breath)


## Side s tries pick["e"]: the odds with every lever, the roll, gas, the referee's tally, the finish gate, the landing
## (hit: the arrow's end + points; miss: the bad arrow as far as the answer is owned; else a reset, +1 advantage for a
## missed scoring or submission attempt), the path and the plan. True on a hit.
static func attempt(ctx: Dictionary, st: Dictionary, s: int, pick: Dictionary, rng: RandomNumberGenerator, vis: Array) -> bool:
	var rules: Dictionary = ctx["rules"]
	var e: Dictionary = pick["e"]
	var mv := str(e["move"])
	var base := BjjTree.is_base(mv)
	var is_plan: bool = pick["why"] == "plan"
	var chain: bool = is_plan and bool(st["plan_hit"][s])
	var read := 0.0
	if is_plan and not base:
		read = minf(1.0, float(st["looks"][1 - s]) / TheRead.looks_needed(float(ctx["iq"][1 - s]), false))
		st["looks"][1 - s] = float(st["looks"][1 - s]) + TheRead.LOOKS_PER_EXCHANGE
		st["seen"][1 - s] = int(st["seen"][1 - s]) + 1
	var m_att := _m(ctx, s, mv)
	var m_ans := _ans(ctx, s, e)
	var md := float(st["mood"]) if s == 0 else 0.0
	var parts := _parts(ctx, st, s, e)
	var sh := 0.0
	for k in parts:
		sh += float(parts[k])
	var p := BjjTree.odds(e, m_att, m_ans, rules, chain, read, md, sh)
	var r := rng.randf()
	if base:
		st["gas"][s] = BjjBody.breathe(float(st["gas"][s]))
	else:
		st["gas"][s] = BjjBody.spend(float(st["gas"][s]), str(e["odds"]), r < p, float(ctx["body"][s]["cardio"]))
		BjjRef.attempt(st["ref"], s, str(e["odds"]), r < p)
		st["attempts"][s] = int(st["attempts"][s]) + 1
		if s == 1 and (ctx["lanes"] as Array).has(str(e["lane"])):
			st["style_n"] = int(st["style_n"]) + 1
		if s == 0 and (ctx["try_once"] as Array).has(mv):
			(ctx["tried"] as Dictionary)[mv] = true
		_beat_notes(ctx, st, s, e, pick, p, r, m_att, m_ans, chain, read, md, parts)
	var hit := r < p
	var res := "hit"
	var other := 1 - s
	var escaped := false
	if hit and str(e["odds"]) == "submission" and BjjTree.is_ending(str(e["ok"])):
		var esc := BjjBody.escape_chance(rules, float(ctx["mat"][other]) - float(ctx["mat"][s]))
		if rng.randf() < esc:
			hit = false
			escaped = true
			_note(st, "escape", 0.6, "%s had the %s locked at %s; %s got out before the tap (%d%% chance)." % [ctx["names"][s],
				BjjTree.move_name(mv).to_lower(), clock(float(st["t"])), ctx["names"][other], int(round(esc * 100.0))])
	if hit:
		st["at"] = str(e["ok"]) if s == 0 else BjjTree.mirror(str(e["ok"]))
		st["score"][s] = int(st["score"][s]) + int(e["points"])
		if s == 1:
			vis[1] += int(e["points"])
	elif not escaped and (base or rng.randf() < BjjTree.p_bad(m_ans)):
		res = "miss"
		st["at"] = str(e["bad"]) if s == 0 else BjjTree.mirror(str(e["bad"]))
		if not base:
			st["score"][other] = int(st["score"][other]) + int(e["bad_gives"])
			if s == 0:
				vis[1] += int(e["bad_gives"])
	else:
		res = "reset"
		if int(e["points"]) > 0 or str(e["odds"]) == "submission":
			st["adv"][s] = int(st["adv"][s]) + 1
	(st["path"] as Array).append([str(e["id"]), s, res, float(st["t"])])
	if is_plan:
		st["plan_hit"][s] = hit
		if hit:
			st["plan_i"][s] = int(pick["step"]) + 1
	else:
		st["plan_hit"][s] = false
	st["prev_move"][s] = mv if hit else ""
	return hit


## True when the walk stands on a tap: the winner, the finish move and its time within the beat go on st.
static func ended(st: Dictionary, mv: String, rng: RandomNumberGenerator, beat_s: float, vis: Array) -> bool:
	if not BjjTree.is_ending(str(st["at"])):
		return false
	st["winner"] = 0 if str(st["at"]) == "tap_win" else 1
	st["finish"] = mv
	st["fin_t"] = minf(float(st["end"]) - 1.0, float(st["t"]) + rng.randi_range(0, int(beat_s) - 1))
	if int(st["winner"]) == 1:
		vis[2] += 1
	return true


## The walk's result dict at a tap or the bell (BjjRef's decision when nobody tapped).
static func result(ctx: Dictionary, st: Dictionary, opp: Dictionary, minutes: int, rng: RandomNumberGenerator) -> Dictionary:
	var winner := int(st["winner"])
	var finish := str(st["finish"])
	var ref := false
	var by := "submission"
	if winner < 0:
		var dec := BjjRef.decide(st["score"], st["adv"], st["ref"], rng)
		winner = int(dec["winner"])
		by = str(dec["by"])
		ref = by == "decision"
		if ref:
			_note(st, "referee", 0.4, "Level on points and advantages: the referee gave it to %s, the more offensive (%d%% of the attacks)." % [
				ctx["names"][winner], int(round(100.0 * (float(dec["share"]) if winner == 0 else 1.0 - float(dec["share"]))))])
	var lanes_n := int(st["style_n"])
	if lanes_n >= STYLE_LINE_AT and str(opp.get("style", "")) != "":
		_note(st, "style", 0.1, "%s: %s %s %d times in %d minutes." % [str(opp["style"]), ctx["names"][1],
			str(STYLE_VERB.get(str(opp["style"]), "attacked")), lanes_n, minutes])
	var w := {"win": winner == 0, "score": st["score"], "adv": st["adv"], "ref": ref, "by": by, "pen": st["ref"]["pen"],
		"off": st["ref"]["off"], "gas": st["gas"], "path": st["path"], "end": str(st["at"]),
		"finish": finish, "t": float(st["fin_t"]) if finish != "" else float(st["end"]), "notes": (st["notes"] as Dictionary).values(),
		"visits": st["visits"], "attempts": st["attempts"], "seen": st["seen"]}
	w["how"] = how_of(w)
	return w


## S397 the day's form: one draw a side a match, N(0, T.FORM_SD) on the logit (an off day for the favourite, a good one for
## the underdog - both sides, unlike morale). From its own generator seeded off the walk's state, so the walk's own rolls
## are untouched; a gym roll has none.
static func _form(rng: RandomNumberGenerator, roll: bool) -> Array:
	if roll or float(BjjTree.T["FORM_SD"]) <= 0.0:
		return [0.0, 0.0]
	var fr := RandomNumberGenerator.new()
	fr.seed = hash("%d|form" % rng.state)
	var sd := float(BjjTree.T["FORM_SD"])
	return [fr.randfn(0.0, sd), fr.randfn(0.0, sd)]


## The beat's top position counts towards the referee's offence tally (Ana's view: top / attack = side 0).
static func _top(st: Dictionary, w: float = 1.0) -> void:
	var sd := str(BjjTree.node(str(st["at"])).get("side", ""))
	if sd == "top" or sd == "attack":
		BjjRef.on_top(st["ref"], 0, w)
	elif sd == "bottom" or sd == "defend":
		BjjRef.on_top(st["ref"], 1, w)


## S397 a hold off a pin is a stall the referee sees (BjjRef): every 2nd one a penalty; the 2nd penalty is an advantage to
## the other side, the 3rd two points.
static func _stall(ctx: Dictionary, st: Dictionary, s: int, own: String) -> void:
	var what := BjjRef.hold(st["ref"], s, own)
	if what == "advantage":
		st["adv"][1 - s] = int(st["adv"][1 - s]) + 1
	elif what == "points":
		st["score"][1 - s] = int(st["score"][1 - s]) + 2
	if what != "":
		_note(st, "stall", 0.45 if what == "points" else 0.35, "%s penalised for stalling at %s: %s to %s." % [ctx["names"][s],
			clock(float(st["t"])), "an advantage" if what == "advantage" else "two points", ctx["names"][1 - s]])


## The beat's rule notes (CHAIN, read, MOOD, FELT, EPS, and S397 MAT TIME, BODY, TANK, FORM) for a non-BASE attempt.
static func _beat_notes(ctx: Dictionary, st: Dictionary, s: int, e: Dictionary, pick: Dictionary, p: float, r: float,
		m_att: float, m_ans: float, chain: bool, read: float, md: float, parts: Dictionary = {}) -> void:
	var bd := 0.0
	for k in parts:
		bd += float(parts[k])
	var rules: Dictionary = ctx["rules"]
	var mv := str(e["move"])
	var nm := BjjTree.move_name(mv)
	var when := clock(float(st["t"]))
	var hit := r < p
	if chain:
		var w := _weigh(p, BjjTree.odds(e, m_att, m_ans, rules, false, read, md, bd), r)
		if w > 0.0 and hit and str(st["prev_move"][s]) != "":
			_note(st, "chain", w, "%s %s, straight off the %s: %s a step late." % [nm, when,
				BjjTree.move_name(str(st["prev_move"][s])).to_lower(), ctx["names"][1 - s]])
	if read > 0.0:
		var w2 := _weigh(p, BjjTree.odds(e, m_att, m_ans, rules, chain, 0.0, md, bd), r)
		if w2 > 0.0 and not hit:
			_note(st, "read", w2, "%s had seen the plan %d times; it was read at the %s." % [ctx["names"][1 - s],
				int(st["seen"][1 - s]) - 1, nm.to_lower()])
	if md != 0.0:
		var w3 := _weigh(p, BjjTree.odds(e, m_att, m_ans, rules, chain, read, 0.0, bd), r)
		if w3 > 0.0:
			var k := 1.0 + float(BjjTree.T["MOOD_W"]) * md
			_note(st, "mood", w3, "Morale %d: %s's attempts %s today (odds x%.1f)." % [int((ctx["f"][0] as Dictionary).get("morale", 60)),
				ctx["names"][0], "sharper" if k > 1.0 else "flatter", k])
	if m_att < BeltRoad.OWNED_AT:
		var w4 := _weigh(p, BjjTree.odds(e, BeltRoad.OWNED_AT, m_ans, rules, chain, read, md, bd), r)
		if w4 > 0.0:
			_note(st, "felt", w4, "%s, felt, %s at %s - owned at 30." % [nm, "landed" if hit else "missed", when])
	for k in parts:
		var x := float(parts[k])
		if absf(x) < 0.01:
			continue
		var w5 := _weigh(p, BjjTree.odds(e, m_att, m_ans, rules, chain, read, md, bd - x), r)
		if w5 <= 0.0:
			continue
		var up := x > 0.0
		var who: String = ctx["names"][s] if up else ctx["names"][1 - s]
		var why := ""
		match str(k):
			"mat":
				why = "%s has more mat time (%s)" % [who, BjjBody.mat_words(float(ctx["mat"][s]) - float(ctx["mat"][1 - s]))]
			"tank":
				why = "%s had more left in the tank" % who
			"form":
				why = "%s was %s today" % [ctx["names"][s], "sharp" if up else "flat"]
			"grip":
				why = "%s had won the grips first" % who
			_:
				var dd := BjjBody.decider(e, ctx["body"][s], ctx["body"][1 - s])
				why = "%s's %s" % [ctx["names"][1 - s] if str(dd[0]).begins_with("their ") else ctx["names"][s], str(dd[0]).trim_prefix("their ")]
		_note(st, str(k), w5, "%s %s at %s: %s." % [nm, "landed" if hit else "missed", when, why])
	if pick["why"] == "eps" and not (pick.get("alt", {}) as Dictionary).is_empty():
		_note(st, "eps", 0.3 if hit else 0.06, "%s went for the %s, not the usual %s." % [ctx["names"][s], nm.to_lower(),
			BjjTree.move_name(str(pick["alt"]["move"])).to_lower()])


## "submission (<move>) m:ss" | "points a-o" | "points a-o, advantages a-o" | "..., referee decision" (Ana's numbers first).
static func how_of(w: Dictionary) -> String:
	if str(w.get("finish", "")) != "":
		return "submission (%s) %s" % [BjjTree.move_name(str(w["finish"])).to_lower(), clock(float(w["t"]))]
	var sc: Array = w["score"]
	var ad: Array = w["adv"]
	var s := "points %d-%d" % [int(sc[0]), int(sc[1])]
	if int(sc[0]) == int(sc[1]):
		s += ", advantages %d-%d" % [int(ad[0]), int(ad[1])]
		if int(ad[0]) == int(ad[1]):
			var pen: Array = w.get("pen", [0, 0])
			if int(pen[0]) != int(pen[1]):
				s += ", penalties %d-%d" % [int(pen[0]), int(pen[1])]
			else:
				s += ", referee decision"
	return s


## The result card's lines: one per rule, most decisive first.
static func rule_lines(w: Dictionary, max_lines: int = 5) -> Array:
	var notes: Array = (w.get("notes", []) as Array).duplicate()
	notes.sort_custom(func(a, b): return float(a["w"]) > float(b["w"]))
	var out: Array = []
	for n in notes:
		if out.size() >= max_lines:
			break
		out.append(str(n["line"]))
	return out
