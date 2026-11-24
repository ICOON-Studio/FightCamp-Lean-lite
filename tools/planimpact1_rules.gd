extends RefCounted
## PLANIMPACT1 local rules (S548, ops/research/TASK_PLANIMPACT1.md; the rules as written BEFORE any run:
## ops/research/DESIGN_PLANIMPACT1.md). Probe only; nothing under scripts/ reads this. All switches off = the game.
## L1 VARIETY: a place (card + when) may hold two lines; she throws the one the opponent has counted fewer times (tie: the
##    first written). Half (0.5): she alternates only on a coin of her own (a probe stream), else the first line.
## L2 DRILLED: a live corner command the plan prepared (a plan line that is a best answer in one of the command's best
##    moments; NARROW: and thrown from the card that moment is fought on) is carried out one grade higher. Half: mult halfway.
## L3 ROUND ONE: no live corner command in round 1 (half: none in its first three exchanges).
const PlanFight := preload("res://scripts/rules/PlanFight.gd")
const PlanBoard := preload("res://scripts/rules/PlanBoard.gd")
const PlanLines := preload("res://scripts/rules/PlanLines.gd")
const StrikeMap := preload("res://scripts/rules/StrikeMap.gd")
const Exchanges := preload("res://scripts/rules/Exchanges.gd")
const ComboCounter := preload("res://scripts/rules/ComboCounter.gd")
const CoachPlan := preload("res://scripts/rules/CoachPlan.gd")
const R := preload("res://tools/cornercmd2_rules.gd")

static var L1 := 0.0
static var L2 := 0.0
static var L3 := 0.0
static var NARROW := false


## The plan's place key (PlanBoard.validate: from + when).
static func place(l: Dictionary) -> String:
	return "%s:%s" % [str(StrikeMap.move(str(l["move"])).get("from", "")), str(l.get("when", ""))]


static func has_twins(plan: Array) -> bool:
	var seen := {}
	for l in plan:
		var p := place(l)
		if seen.has(p):
			return true
		seen[p] = true
	return false


## L1: the plan with ONE line a place. counts = the counter's counts as the exchange starts; roll = the probe's own coin.
static func filter(plan: Array, counts: Dictionary, roll: float) -> Array:
	var groups := {}
	var order: Array = []
	for l in plan:
		var p := place(l)
		if not groups.has(p):
			groups[p] = []
			order.append(p)
		(groups[p] as Array).append(l)
	var out: Array = []
	for p in order:
		var g: Array = groups[p]
		var pick: Dictionary = g[0]
		if g.size() > 1 and L1 > 0.0 and (L1 >= 1.0 or roll < L1):
			var c0 := int(counts.get(str(g[0]["move"]), 0))
			var c1 := int(counts.get(str(g[1]["move"]), 0))
			if c1 < c0:
				pick = g[1]
		out.append(pick)
	return out


## L2: is command id prepared by this plan?
static func prepared(id: String, plan: Array) -> bool:
	var row: Dictionary = R.CMD[id]
	for l in plan:
		var mv := str(l["move"])
		var w := str(l.get("when", ""))
		for sit in row["best"]:
			if w != "" and w == str(sit):
				return true
			if PlanFight.fit(mv, str(sit)) != "best":
				continue
			if not NARROW or str(StrikeMap.move(mv).get("from", "")) == str(PlanFight.GAME_CARD.get(str(sit), "")):
				return true
	return false


const UP := {"Poor": "OK", "OK": "Good", "Good": "Good"}
const MULT := {"Poor": 0.25, "OK": 0.6, "Good": 1.25}   # cornercmd2_rules GRADE2 (the probe runs with GRADES2 on)


## L2: the raised grade {word, mult, mean}. Half: mult halfway, the old word (its commit).
static func raise(g: Dictionary) -> Dictionary:
	var w := str(g["word"])
	var nw: String = UP[w]
	var out := g.duplicate()
	if L2 >= 1.0:
		out["word"] = nw
		out["mult"] = maxf(float(g["mult"]), float(MULT[nw]))
	elif L2 > 0.0:
		out["mult"] = float(g["mult"]) + L2 * (maxf(float(g["mult"]), float(MULT[nw])) - float(g["mult"]))
	return out


## L2 applied to a reader state's grades (st["gr"]); returns the prepared command ids.
static func sharpen(st: Dictionary, plan: Array) -> Array:
	var raised: Array = []
	if L2 <= 0.0:
		return raised
	for c in R.FIGHT:
		if prepared(str(c), plan):
			st["gr"][c] = raise(st["gr"][c])
			raised.append(str(c))
	return raised


## L3: may the live corner command this exchange (round n, exchange i 0-based)?
static func may_speak(n: int, i: int) -> bool:
	if n != 1 or L3 <= 0.0:
		return true
	return L3 < 1.0 and i >= 3


## Her mastery of a line (punch, drilled combination or step / defence bar); 0 = not throwable.
static func mastery(f: Dictionary, id: String) -> float:
	var row := StrikeMap.move(id)
	if row.is_empty() or not PlanFight.can_do(row, f.get("moves", {})) or PlanFight.rate(id, f.get("combos", {})) < 1.0:
		return 0.0
	var b := PlanFight.base_id(id)
	var v := float((f.get("moves", {}) as Dictionary).get(b, 0.0))
	v = maxf(v, float((f.get("combos", {}) as Dictionary).get(str(row.get("combo", "")), 0.0)))
	v = maxf(v, float((f.get("steps", {}) as Dictionary).get(b, 0.0)))
	return maxf(v, 1.0)


## K, the plan written FOR the corner: the reader's command in each moment of the style (her grades), weighted by the style's
## mix (+ she_tired, she_hurt at 0.1); for each command by weight the highest-mastery line that prepares it, one a place, the
## moment's own card first; no filler.
static func corner_plan(f: Dictionary, style: String, lim: int) -> Array:
	var st := R.new_state("reader_nr", 3, 58.0, f)
	var mix: Dictionary = (Exchanges.STYLE_MODES.get(style, Exchanges.STYLE_MODES["Boxer-puncher"]) as Dictionary).duplicate()
	mix["she_tired"] = 0.1
	mix["she_hurt"] = 0.1
	var need := {}
	for sit in mix:
		var pick: Array = R.best_for(str(sit), st["gr"], st["rg"], float(st["heard"]), str(st["own"]))
		if str(pick[0]) != "":
			need[str(pick[0])] = float(need.get(str(pick[0]), 0.0)) + float(mix[sit])
	var cmds: Array = need.keys()
	cmds.sort_custom(func(a, b): return float(need[a]) > float(need[b]))
	var plan: Array = []
	var used := {}
	for c in cmds:
		if plan.size() >= lim or prepared(str(c), plan):
			continue
		var best := ""
		var bv := -1.0
		for sit in R.CMD[c]["best"]:
			var card := str(PlanFight.GAME_CARD.get(str(sit), "long"))
			for row in StrikeMap.MOVES:
				var id := str(row.get("id", ""))
				if str(row.get("kind", "")) in ["", "forced"] or used.has(str(row.get("from", ""))) or PlanFight.fit(id, str(sit)) != "best":
					continue
				var v := mastery(f, id) + (1000.0 if str(row.get("from", "")) == card else 0.0)
				if mastery(f, id) > 0.0 and v > bv:
					bv = v; best = id
		if best != "":
			plan.append({"move": best})
			used[str(StrikeMap.move(best)["from"])] = true
	return plan


## E, PLANWORTH1's careless plan (tools/planworth1_probe.gd careless(), copied to take a fighter).
static func careless(f: Dictionary, style: String, lim: int) -> Array:
	var game_on := {}
	for cg in CoachPlan.cards(style):
		game_on[str(cg[0])] = str(cg[1])
	var pool: Array = []
	for d in [f.get("moves", {}), f.get("combos", {}), f.get("steps", {})]:
		for id in d:
			var row := StrikeMap.move(str(id))
			if row.is_empty() or not PlanFight.can_do(row, f.get("moves", {})) or PlanFight.rate(str(id), f.get("combos", {})) < 1.0:
				continue
			pool.append([str(id), float(d[id])])
	pool.sort_custom(func(a, b): return float(a[1]) > float(b[1]))
	var plan: Array = []
	var used := {}
	for p in pool:
		if plan.size() >= lim:
			break
		var pl := str(StrikeMap.move(str(p[0]))["from"])
		if used.has(pl) or PlanFight.fit(str(p[0]), str(game_on.get(pl, ""))) == "best":
			continue
		plan.append({"move": str(p[0])})
		used[pl] = true
	return plan


## L1's chooser's options from C: (a) C + one twin on a place of C (under the limit), (b) C less its last line + one twin of
## another place. A twin = a throwable any-time move on the same card not already on the plan.
static func twin_options(f: Dictionary, c: Array, lim: int) -> Array:
	var out: Array = []
	var on := {}
	for l in c:
		on[str(l["move"])] = true
	var last_place := place(c[-1]) if not c.is_empty() else ""
	for l in c:
		if str(l.get("when", "")) != "":
			continue
		var pl := str(StrikeMap.move(str(l["move"])).get("from", ""))
		for o in PlanLines.options(pl, "", f.get("moves", {}), f.get("combos", {})):
			var id := str(o["id"])
			if str(o["why"]) != "" or on.has(id) or mastery(f, id) <= 0.0:
				continue
			if c.size() < lim:
				out.append({"kind": "add", "plan": c + [{"move": id}]})
			if place(l) != last_place:
				out.append({"kind": "swap", "plan": c.slice(0, c.size() - 1) + [{"move": id}]})
	return out
