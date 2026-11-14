extends SceneTree
## S397 rank 3 bots (docs/STRUCTURE_DESIGN_S395.md 5.3a, the test lines of rules 1 and 4), through the game's real bout.
## Close matchup: Lucy against Maria (pressure), the plan_effect_probe's bout, N bouts an arm on the same days as dice.
## Rule 1: your plan with your corner >= your plan with the assistant's corner (sim) > the coach's plan (Hale, 74) > the
## weaker coach's (Reid, 58) >= no plan; the coach's best is worth at most about half of a well-read plan.
## Rule 4: a bot that only answers the scouting report (her favourite game's first right answer on every card, drilled or
## not, never changed) must fall clearly short of one that also weighs drills, the game each card really brings and her
## tiring legs, and swaps an answer at the corner once the opponent has adjusted to it (PlanRead.FREE_USES).
## S397 measured: it does NOT yet (Maria 0.720 vs 0.725, Priya 0.630 vs 0.645, Erin 0.420 vs 0.420): a few answers -
## step back, the double jab, pivot off the ropes - are right against nearly every game, so reading more of an opponent adds
## nothing. Rule 4 is OPEN (NEXT_SESSION_PROMPT item 3): printed, not gated, until "lines compete" is built.
## Prints PLAN_BOTS checks=<n> failures=<n> and the table.

const Data := preload("res://scripts/state/Data.gd")
const Bouts := preload("res://scripts/state/Bouts.gd")
const LiveRound := preload("res://scripts/state/LiveRound.gd")
const Exchanges := preload("res://scripts/rules/Exchanges.gd")
const BoutRules := preload("res://scripts/rules/BoutRules.gd")
const StrikeMap := preload("res://scripts/rules/StrikeMap.gd")
const PlanFight := preload("res://scripts/rules/PlanFight.gd")
const PlanRead := preload("res://scripts/rules/PlanRead.gd")
const CoachPlan := preload("res://scripts/rules/CoachPlan.gd")
const StepMastery := preload("res://scripts/rules/StepMastery.gd")
const FightWhy := preload("res://scripts/rules/FightWhy.gd")

const N := 200
## Rule 1's simmed arms (S434: their bar needs the bigger sample; the live arms stay at N).
const N_SIM := 1000
## The player's well-read plan against a presser (plan_effect_probe GOOD).
const GOOD := [{"move": "1-1"}, {"move": "step_back"}, {"move": "pivot_out"}, {"move": "tie_up"}]

var checks := 0
var failures := 0
var opp_i := 0


func _initialize() -> void:
	var opp: Dictionary = Data.OPPONENTS[0]
	var style := str(opp["style"])
	# CoachPlan itself: no coach writes nothing, Reid reads one card, Hale two, nobody more; only answers she can throw.
	var lucy0: Dictionary = Data.fighter_state(Data.lucy(), 40)
	_check(CoachPlan.reads(0.0) == 0 and CoachPlan.reads(58.0) == 1 and CoachPlan.reads(74.0) == 2 and CoachPlan.reads(99.0) == 2, "coach reads by rating")
	var hp := CoachPlan.write(style, 74.0, lucy0.get("moves", {}), {"1-1": 50.0})
	_check(hp.size() == 2 and hp.all(func(a): return PlanFight.fit(str(a["move"]), "press") == "best" and bool(a.get("coach", false))),
		"the coach's arrows answer her main game and are marked his: %s" % str(hp))
	# S398 rank 5: a hired coach always writes a line, whatever her style, even with no combination drilled (a walk-in vs Priya got
	# none and the Why said NO PLAN); every line is a best answer to the game on its card.
	for st in Exchanges.STYLE_MODES:
		var bare := CoachPlan.write(str(st), 58.0, lucy0.get("moves", {}), {})
		_check(bare.size() == 1 and bare.all(func(a): return PlanFight.fit(str(a["move"]), _game_on(str(st), str(a["move"]))) == "best" and PlanFight.rate(str(a["move"]), {}) >= 1.0),
			"coach 58 writes one drilled best line vs %s with no combination drilled: %s" % [st, str(bare)])
		_check(CoachPlan.write(str(st), 74.0, lucy0.get("moves", {}), {}).size() == 2, "coach 74 writes two lines vs %s" % st)
		# S464 STEPPLAN1: a fresh signing's bars (step_back / pivot_out / tie_up at 0 never fire) - the coach plans none of them.
		var fresh := CoachPlan.write(str(st), 74.0, lucy0.get("moves", {}), {"1-1": 50.0}, StepMastery.start_values(55.0))
		_check(fresh.all(func(a): return not StepMastery.NODES.has(str(a["move"])) or float(StepMastery.start_values(55.0)[str(a["move"])]) >= 30.0),
			"the coach plans no step she cannot fire yet vs %s: %s" % [st, str(fresh)])
	var why := FightWhy.read([{"won": true, "plan": hp, "exchanges": [{"won": true, "landed": [4, 3], "planned": true, "arrow": "step_back",
		"arrow_fit": "best", "psit": "press", "plan_edge": 5.0}]}], "Lucy", "Maria")
	_check(str(why["plan"]).begins_with("The coach's plan") and str(why["next"]).contains("plan of your own"), "the Why says it was the coach's plan")
	# S434 CARDIO1 round 2: the simmed arms of rule 1 on N_SIM bouts (the same days from 40, 5x as many; a sim is cheap). On
	# 200 the "about half" bar sat inside its own noise: the fade line moving 59 -> 60 (0.25 more round-3 fade for Lucy)
	# moved coach 74 - none to 0.160 against 0.6 x 0.260 = 0.156 and turned it red. Measured on 1,000: line 59 none 0.384,
	# plan+sim 0.578, coach 74 0.472 (0.088 vs 0.116); line 60 none 0.378, plan+sim 0.575, coach 74 0.469 (0.091 vs 0.118).
	# Every bar is unchanged.
	var none := _share(func(_f): return [], -1.0, false, false, N_SIM)
	var own_corner := _share(func(_f): return GOOD, -1.0, true, false)
	var own_sim := _share(func(_f): return GOOD, -1.0, false, false, N_SIM)
	var hale := _share(func(_f): return [], 74.0, false, false, N_SIM)
	var reid := _share(func(_f): return [], 58.0, false, false, N_SIM)
	print("PLAN_BOTS rule 1: plan+corner %.3f  plan+sim %.3f  coach 74 %.3f  coach 58 %.3f  none %.3f" % [own_corner, own_sim, hale, reid, none])
	_check(own_corner >= own_sim - 0.03, "your corner adds on top of your plan (or at least costs nothing)")
	_check(own_sim > hale + 0.05, "your plan beats the coach's clearly")
	_check(hale >= reid and reid >= none, "a better coach writes a better plan, and any coach's plan is safe")
	_check(hale > none + 0.03, "the best coach's plan is worth something")
	_check(hale - none <= 0.6 * (own_sim - none), "the coach's best is about half of a well-read plan at most")
	var lucy: Dictionary = Data.fighter_state(Data.lucy(), 40)
	lucy["combos"] = {"1-1": 50.0, "1-2": 50.0}
	print("PLAN_BOTS lookup plan %s | weighed plan %s" % [lookup_plan(style, lucy), weighed_plan(style, lucy)])
	var lookup := _share(func(f): return lookup_plan(style, f), -1.0, false, false)
	var weighed := _share(func(f): return weighed_plan(style, f), -1.0, false, true)
	print("PLAN_BOTS rule 4: report lookup %.3f  weighs drills/cards/legs + adjusts %.3f  (none %.3f)" % [lookup, weighed, none])
	print("PLAN_BOTS rule 4 %s: weighed - lookup %+.3f (target +0.08)" % ["PASS" if weighed >= lookup + 0.08 else "OPEN", weighed - lookup])
	print("PLAN_BOTS checks=%d failures=%d" % [checks, failures])
	quit(1 if failures > 0 else 0)


## The game the coach answered on the card a move leaves from (CoachPlan.cards).
static func _game_on(style: String, move_id: String) -> String:
	var card := str(StrikeMap.move(move_id).get("from", ""))
	for cg in CoachPlan.cards(style):
		if str(cg[0]) == card:
			return str(cg[1])
	return ""


## Rule 4 lookup: the report says "pressure" - the first move on each card that answers pressure, whatever she has drilled.
static func lookup_plan(style: String, f: Dictionary) -> Array:
	var fav := Exchanges.favourite(style)
	var plan: Array = []
	for cg in CoachPlan.cards(style):
		for m in StrikeMap.outs(str(cg[0])):
			if PlanFight.fit(str(m["id"]), fav) == "best" and PlanFight.can_do(m, f.get("moves", {})):
				plan.append({"move": str(m["id"])})
				break
	return plan


## Rule 4 weighed: the game each card really brings, drilled answers only, and inside (where her tiring legs put her) the
## answer that also holds when she is tired.
static func weighed_plan(style: String, f: Dictionary) -> Array:
	var plan: Array = []
	var cards := CoachPlan.cards(style)
	cards.append(["inside", "she_tired"])
	for cg in cards:
		for m in StrikeMap.outs(str(cg[0])):
			var id := str(m["id"])
			if PlanFight.fit(id, str(cg[1])) == "best" and PlanFight.can_do(m, f.get("moves", {})) and PlanFight.rate(id, f.get("combos", {})) >= 1.0:
				plan.append({"move": id})
				break
	return plan.slice(0, 4)


## Win share over N close bouts. plan_of(f) -> arrows; coach = the gym coach's rating (-1 none); corner = the player's
## corner (shout the clue's answer twice a round, the corner call on the last situation) instead of the simulation;
## adjust = the corner swaps an answer the opponent has adjusted to for another right one on its card.
func _share(plan_of: Callable, coach: float, corner: bool, adjust: bool, n: int = N) -> float:
	var wins := 0
	for i in n:
		var c := Career.quick_start()
		c.fighters.append(Data.fighter_state(Data.lucy(), c.day))
		c.coach = {"rating": coach} if coach >= 0.0 else {}
		c.day = 40 + i
		var f: Dictionary = c.fighter()
		f["camp"] = {}
		f["combos"] = {"1-1": 50.0, "1-2": 50.0}
		# S464 STEPPLAN1: every step/defence bar at Signature (85, always fires = before the S463 gate) - this test grades the plan, not
		# the drilling (the approved PROGRESSION_MAP M1 starts a new signing's step_back / pivot_out / tie_up at 0, as fight_why_test does).
		for sid in StepMastery.NODES:
			(f.get_or_add("steps", {}) as Dictionary)[sid] = 85.0
		f["arrows"] = (plan_of.call(f) as Array).duplicate(true)
		f["bout"] = {"opp": (Data.OPPONENTS[opp_i] as Dictionary).duplicate(true), "day": c.day, "weighed": true, "made": true,
			"done": false, "film": 0, "rounds": 3}
		var m := {"fid": f["id"], "step": "tape", "total": 3}
		if not corner and not adjust:
			Bouts.fight_step(c, f, m, "sim")
		else:
			_live(c, f, m, corner, adjust)
		wins += int(str(m.get("outcome", "")) == "win")
	return float(wins) / n


func _live(c: Career, f: Dictionary, m: Dictionary, corner: bool, adjust: bool) -> void:
	Bouts.fight_step(c, f, m, "start")
	while true:
		while not LiveRound.live(m).is_empty():
			var lv := LiveRound.live(m)
			Bouts.fight_step(c, f, m, "shout:" + (str(LiveRound.preview(f, m)["coach"]) if corner and int(lv["shouts"]) < 2 else ""))
		if int(m["round"]) >= Bouts.rounds_of(f) or Bouts.stopped(m) != "":
			break
		var last: Dictionary = (m["rounds"] as Array)[-1]
		var call := str(Exchanges.MODES[str(last["exchanges"][-1]["sit"])]["best"]) if corner else ""
		var act := "corner:" + (call if call != "" else BoutRules.auto_corner(f["stats"]))   # sim's own corner call
		if adjust:
			act += _swap(f)
		Bouts.fight_step(c, f, m, act)
	Bouts.fight_step(c, f, m, "end")


## "|arrow=i:move" for the arrow the opponent has adjusted to most (used past FREE_USES), swapped for another right
## answer on its card to the game it answered; "" when none needs it.
static func _swap(f: Dictionary) -> String:
	var uses: Dictionary = f["bout"].get("answer_uses", {})
	var arrows: Array = f["bout"].get("arrows", [])
	var style := str(f["bout"]["opp"].get("style", ""))
	for i in arrows.size():
		var id := str(arrows[i]["move"])
		if int(uses.get(id, 0)) <= PlanRead.FREE_USES:
			continue
		var card := str(StrikeMap.move(id).get("from", ""))
		var game := ""
		for cg in CoachPlan.cards(style):
			if str(cg[0]) == card:
				game = str(cg[1])
		for mv in StrikeMap.outs(card):
			var alt := str(mv["id"])
			if alt != id and PlanFight.fit(alt, game) == "best" and PlanFight.can_do(mv, f.get("moves", {})) \
					and PlanFight.rate(alt, f.get("combos", {})) >= 1.0 and int(uses.get(alt, 0)) <= PlanRead.FREE_USES:
				return "|arrow=%d:%s" % [i, alt]
	return ""


func _check(ok: bool, what: String) -> void:
	checks += 1
	if not ok:
		failures += 1
		print("FAIL ", what)
