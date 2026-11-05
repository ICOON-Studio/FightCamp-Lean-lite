extends RefCounted
## GAMETREE1 (S384) the honest walk (design 3.2): a seeded paper walk on the one mirrored map. Side 0 is Ana, side 1 the
## opponent; `at` is the node from Ana's view and the opponent stands on mirror(at). The side with the initiative acts: on
## the plan it takes the plan step, off it the best p x gain - (1 - p) x P_bad x loss (EPS: the second best). A hit moves
## and scores and keeps the initiative; a miss slides down the bad arrow only as far as the defender owns the answer, else
## it resets (a missed scoring or submission attempt +1 advantage) and the initiative passes. At the bell: points,
## advantages, then a seeded referee decision. Every hidden rule that moved a beat's odds 5%+ or decided it leaves a note.
## Pure static; preloads BjjTree, BjjOpp, BeltRoad, TheRead.

const BjjTree := preload("res://scripts/rules/BjjTree.gd")
const TheRead := preload("res://scripts/rules/TheRead.gd")
const BjjOpp := preload("res://scripts/rules/BjjOpp.gd")
const BeltRoad := preload("res://scripts/rules/BeltRoad.gd")

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
		"try_once": extra.get("try_once", []), "tried": {}}


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
	if _leads(st, s) and float(st["t"]) >= float(st["end"]) - float(T["LATE_S"]) and ["top", "neutral"].has(str(BjjTree.node(own).get("side", ""))):
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
		var p := BjjTree.odds(e, _m(ctx, s, mv), m_ans, ctx["rules"], false, 0.0, float(st["mood"]) if s == 0 else 0.0)
		var gain := float(e["points"]) + BjjTree.node_value(str(e["ok"]))
		var loss := float(e["bad_gives"]) + BjjTree.node_value(BjjTree.mirror(str(e["bad"])))
		var score := p * gain - (1.0 - p) * (1.0 if base else BjjTree.p_bad(m_ans)) * loss
		if here > 0 and int(dist.get(str(e["ok"]), -1)) == here - 1:
			score += float(T["PLAN_PULL"])
		if s == 1 and score > 0.0 and (ctx["lanes"] as Array).has(str(e["lane"])):
			score *= float(T["STYLE_W"])
		if try_once.has(mv) and not (ctx["tried"] as Dictionary).has(mv):
			score = 1e6
		cand.append([score, e])
	cand.sort_custom(func(a, b): return float(a[0]) > float(b[0]))
	if cand.size() > 1 and float(cand[0][0]) < 1e6 and rng.randf() < float(T["EPS"]):
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
	var ctx := _ctx(ana, opp, plans, rules, extra)
	var T: Dictionary = BjjTree.T
	var beat_s := float(T["BEAT_S"])
	var mood := 0.0 if bool(extra.get("no_mood", false)) or bool(rules.get("roll", false)) else BjjTree.mood_of(ana)
	var st := {"at": "standing", "init": rng.randi() % 2, "t": 0.0, "end": float(minutes * 60), "score": [0, 0], "adv": [0, 0],
		"plan_i": [0, 0], "plan_hit": [false, false], "looks": [0.0, 0.0], "seen": [0, 0], "mood": mood, "notes": {}, "beat": 0,
		"path": [], "visits": {}, "prev_move": ["", ""], "held": [false, false], "attempts": [0, 0], "style_n": 0}
	var winner := -1
	var finish := ""
	var fin_t := 0.0
	while float(st["t"]) < float(st["end"]):
		var s := int(st["init"])
		var at_before: String = st["at"]
		var vis: Array = (st["visits"] as Dictionary).get_or_add(at_before, [0, 0, 0])
		vis[0] += 1
		var pick := choose(ctx, st, s, rng)
		var e: Dictionary = pick["e"]
		if e.is_empty():
			if pick["why"] == "late" and not st["held"][s]:
				st["held"][s] = true
				var own: String = at_before if s == 0 else BjjTree.mirror(at_before)
				_note(st, "hold", 0.5, "%d-%d up with %s left: %s held the %s to the bell." % [st["score"][s], st["score"][1 - s],
					clock(float(st["end"]) - float(st["t"])), ctx["names"][s], str(BjjTree.node(own)["name"]).to_lower()])
			st["init"] = 1 - s
			st["t"] = float(st["t"]) + beat_s
			st["beat"] = int(st["beat"]) + 1
			continue
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
		var p := BjjTree.odds(e, m_att, m_ans, rules, chain, read, md)
		var r := rng.randf()
		if not base:
			st["attempts"][s] = int(st["attempts"][s]) + 1
			if s == 1 and (ctx["lanes"] as Array).has(str(e["lane"])):
				st["style_n"] = int(st["style_n"]) + 1
			if s == 0 and (ctx["try_once"] as Array).has(mv):
				(ctx["tried"] as Dictionary)[mv] = true
			_beat_notes(ctx, st, s, e, pick, p, r, m_att, m_ans, chain, read, md)
		var hit := r < p
		var res := "hit"
		var other := 1 - s
		if hit:
			st["at"] = str(e["ok"]) if s == 0 else BjjTree.mirror(str(e["ok"]))
			st["score"][s] = int(st["score"][s]) + int(e["points"])
			if s == 1:
				vis[1] += int(e["points"])
		elif base or rng.randf() < BjjTree.p_bad(m_ans):
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
		if BjjTree.is_ending(str(st["at"])):
			winner = 0 if str(st["at"]) == "tap_win" else 1
			finish = mv
			fin_t = minf(float(st["end"]) - 1.0, float(st["t"]) + rng.randi_range(0, int(beat_s) - 1))
			if winner == 1:
				vis[2] += 1
			break
		if not hit:
			st["init"] = other
		st["t"] = float(st["t"]) + beat_s
		st["beat"] = int(st["beat"]) + 1
	var ref := false
	if winner < 0:
		var sc: Array = st["score"]
		var ad: Array = st["adv"]
		if int(sc[0]) != int(sc[1]):
			winner = 0 if int(sc[0]) > int(sc[1]) else 1
		elif int(ad[0]) != int(ad[1]):
			winner = 0 if int(ad[0]) > int(ad[1]) else 1
		else:
			ref = true
			winner = rng.randi() % 2
	var lanes_n := int(st["style_n"])
	if lanes_n >= STYLE_LINE_AT and str(opp.get("style", "")) != "":
		_note(st, "style", 0.1, "%s: %s %s %d times in %d minutes." % [str(opp["style"]), ctx["names"][1],
			str(STYLE_VERB.get(str(opp["style"]), "attacked")), lanes_n, minutes])
	var w := {"win": winner == 0, "score": st["score"], "adv": st["adv"], "ref": ref, "path": st["path"], "end": str(st["at"]),
		"finish": finish, "t": fin_t if finish != "" else float(st["end"]), "notes": (st["notes"] as Dictionary).values(),
		"visits": st["visits"], "attempts": st["attempts"], "seen": st["seen"]}
	w["how"] = how_of(w)
	return w


## The beat's rule notes (CHAIN, read, MOOD, FELT, EPS) for a non-BASE attempt.
static func _beat_notes(ctx: Dictionary, st: Dictionary, s: int, e: Dictionary, pick: Dictionary, p: float, r: float,
		m_att: float, m_ans: float, chain: bool, read: float, md: float) -> void:
	var rules: Dictionary = ctx["rules"]
	var mv := str(e["move"])
	var nm := BjjTree.move_name(mv)
	var when := clock(float(st["t"]))
	var hit := r < p
	if chain:
		var w := _weigh(p, BjjTree.odds(e, m_att, m_ans, rules, false, read, md), r)
		if w > 0.0 and hit and str(st["prev_move"][s]) != "":
			_note(st, "chain", w, "%s %s, straight off the %s: %s a step late." % [nm, when,
				BjjTree.move_name(str(st["prev_move"][s])).to_lower(), ctx["names"][1 - s]])
	if read > 0.0:
		var w2 := _weigh(p, BjjTree.odds(e, m_att, m_ans, rules, chain, 0.0, md), r)
		if w2 > 0.0 and not hit:
			_note(st, "read", w2, "%s had seen the plan %d times; it was read at the %s." % [ctx["names"][1 - s],
				int(st["seen"][1 - s]) - 1, nm.to_lower()])
	if md != 0.0:
		var w3 := _weigh(p, BjjTree.odds(e, m_att, m_ans, rules, chain, read, 0.0), r)
		if w3 > 0.0:
			var k := 1.0 + float(BjjTree.T["MOOD_W"]) * md
			_note(st, "mood", w3, "Morale %d: %s's attempts %s today (odds x%.1f)." % [int((ctx["f"][0] as Dictionary).get("morale", 60)),
				ctx["names"][0], "sharper" if k > 1.0 else "flatter", k])
	if m_att < BeltRoad.OWNED_AT:
		var w4 := _weigh(p, BjjTree.odds(e, BeltRoad.OWNED_AT, m_ans, rules, chain, read, md), r)
		if w4 > 0.0:
			_note(st, "felt", w4, "%s, felt, %s at %s - owned at 30." % [nm, "landed" if hit else "missed", when])
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
