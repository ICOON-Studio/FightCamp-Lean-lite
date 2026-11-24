extends RefCounted
## PLANIMPACT2 local rule (S550, ops/research/TASK_PLANIMPACT2.md; written BEFORE any run: ops/research/DESIGN_PLANIMPACT2.md).
## Probe only; nothing under scripts/ reads this. STRENGTH 0 = the game (and PLANIMPACT1's lever-off arms).
## THE RULE: a live corner command is PREPARED only by a plan line that answers that moment ON THE CARD WHERE THIS OPPONENT'S
## STYLE FIGHTS IT: the line is thrown from a card c, [c, g] is in CoachPlan.cards(opponent style) (the game g her style brings
## to c most), g is one of the command's best moments (cornercmd2_rules CMD.best), and the line is a best answer to g
## (PlanFight.fit; a "when g" line on c that is not wrong also counts). A prepared command is carried out one grade higher
## (Poor -> OK -> Good, PLANIMPACT1's raise); every other command at her own grade. Half (0.5): the mult halfway, the old word.
const P1 := preload("res://tools/planimpact1_rules.gd")
const PlanFight := preload("res://scripts/rules/PlanFight.gd")
const StrikeMap := preload("res://scripts/rules/StrikeMap.gd")
const CoachPlan := preload("res://scripts/rules/CoachPlan.gd")
const Exchanges := preload("res://scripts/rules/Exchanges.gd")
const R := preload("res://tools/cornercmd2_rules.gd")
const FireLevel := preload("res://scripts/rules/FireLevel.gd")

static var STRENGTH := 0.0


static func card_of(l: Dictionary) -> String:
	return str(StrikeMap.move(str(l["move"])).get("from", ""))


## TRIAL AMENDMENT (taken once, before the full run; DESIGN_PLANIMPACT2.md): a line prepares only if it FIRES - the coach's own
## test (CoachReadWire l.38, PlanAuto l.20): she can do it, at full rate, and FireLevel.mastery_of reaches USABLE_AT (30).
static func fires(f: Dictionary, id: String) -> bool:
	var row := StrikeMap.move(id)
	if not PlanFight.can_do(row, f.get("moves", {})) or PlanFight.rate(id, f.get("combos", {})) < 1.0:
		return false
	return FireLevel.mastery_of(f, id) >= FireLevel.USABLE_AT


## The commands one plan line prepares against this opponent style (in R.FIGHT order). f = the boxer (her bars).
static func line_prepares(l: Dictionary, style: String, f: Dictionary) -> Array:
	var out: Array = []
	if not fires(f, str(l["move"])):
		return out
	var card := card_of(l)
	var w := str(l.get("when", ""))
	for cg in CoachPlan.cards(style):
		if str(cg[0]) != card:
			continue
		var g := str(cg[1])
		var ft := PlanFight.fit(str(l["move"]), g)
		if ft != "best" and not (w == g and ft != "wrong"):
			continue
		for c in R.FIGHT:
			if (R.CMD[c]["best"] as Array).has(g) and not out.has(c):
				out.append(str(c))
	return out


static func prepared_set(plan: Array, style: String, f: Dictionary) -> Array:
	var out: Array = []
	for l in plan:
		for c in line_prepares(l, style, f):
			if not out.has(c):
				out.append(c)
	return out


## The raised grade {word, mult, mean}. Half: mult halfway, the old word (its commit).
static func raise(g: Dictionary) -> Dictionary:
	var w := str(g["word"])
	var nw: String = P1.UP[w]
	var out := g.duplicate()
	var top := maxf(float(g["mult"]), float(P1.MULT[nw]))
	if STRENGTH >= 1.0:
		out["word"] = nw
		out["mult"] = top
	elif STRENGTH > 0.0:
		out["mult"] = float(g["mult"]) + STRENGTH * (top - float(g["mult"]))
	return out


## The rule applied to a reader state's grades (st["gr"]); returns the prepared command ids.
static func sharpen(st: Dictionary, plan: Array, style: String, f: Dictionary) -> Array:
	if STRENGTH <= 0.0:
		return []
	var raised := prepared_set(plan, style, f)
	for c in raised:
		st["gr"][c] = raise(st["gr"][c])
	return raised


## K2, the plan written FOR the corner under this rule: the reader's command in each moment of the style (her grades),
## weighted by the style's mix (+ she_tired, she_hurt at 0.1, as PLANIMPACT1's K); for each command by weight, among the
## style's cards whose game the command answers best, the highest-mastery throwable best answer there, one line a card;
## a command the rule cannot prepare against this style is skipped; no filler.
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
		if plan.size() >= lim or prepared_set(plan, style, f).has(str(c)):
			continue
		var best := ""
		var bv := 0.0
		for cg in CoachPlan.cards(style):
			var card := str(cg[0])
			if used.has(card) or not (R.CMD[c]["best"] as Array).has(str(cg[1])):
				continue
			for row in StrikeMap.outs(card):
				var id := str(row.get("id", ""))
				if str(row.get("kind", "")) in ["", "forced"] or PlanFight.fit(id, str(cg[1])) != "best":
					continue
				var v := P1.mastery(f, id) if fires(f, id) else 0.0
				if v > bv:
					bv = v; best = id
		if best != "":
			plan.append({"move": best})
			used[card_of({"move": best})] = true
	return plan
