extends RefCounted
## S537 STEPPAY3: the checks the five step_moment_*_test.gd share (one moment each; rules/StepMoment.gd deals them,
## PlanFight.ANSWERS grades them). Red on main: no StepMoment, no row in the answer table, no moment in a played bout.
## Control arm: StepMoment.on false = the game before (no moment dealt).

const Bouts := preload("res://scripts/state/Bouts.gd")
const Data := preload("res://scripts/state/Data.gd")
const PlanFight := preload("res://scripts/rules/PlanFight.gd")
const StrikeMap := preload("res://scripts/rules/StrikeMap.gd")
const StepWire := preload("res://scripts/state/StepWire.gd")
const PATH := "res://scripts/rules/StepMoment.gd"
const MOMENTS := ["short", "landed", "flurry", "smother", "drift"]
const BOUTS := 30
## Set at the end of run(): a script error inside it returns early, and the caller must not read that as a pass.
static var finished: bool = false


static func _opp(opp_name: String) -> Dictionary:
	for o in Data.OPPONENTS + Data.RIVALS + [Data.MISMATCH]:
		if str(o["name"]) == opp_name:
			return (o as Dictionary).duplicate(true)
	return {}


## Lucy Jackson (Data.lucy, an out-boxer: never the opponent's twin) with every punch, combination and this step drilled (60).
static func _boxer(c: Career, step: String) -> Dictionary:
	c.fighters.append(Data.fighter_state(Data.lucy(), c.day))
	var f: Dictionary = c.fighter()
	var moves := {}
	for k in Data.MOVES:
		moves[k] = 60.0
	f["moves"] = moves
	var combos := {}
	for m in StrikeMap.MOVES:
		if str(m["kind"]) == "combo":
			combos[str(m["combo"])] = 60.0
	f["combos"] = combos
	var steps: Dictionary = (f.get("steps", {}) as Dictionary).duplicate()
	steps[step] = 60.0
	f["steps"] = steps
	return f


## Every exchange record of BOUTS amateur bouts (3 rounds, days 40..) against the named opponent with this plan.
static func _played(step: String, opp_name: String, plan: Array) -> Dictionary:
	var out: Array = []
	var rounds := 0
	for k in BOUTS:
		var c := Career.quick_start()
		var f := _boxer(c, step)
		c.day = 40 + k
		f["camp"] = {}
		f["arrows"] = plan.duplicate(true)
		f["bout"] = {"opp": _opp(opp_name), "day": c.day, "weighed": true, "made": true, "done": false, "film": 0, "rounds": 3}
		var m := {"fid": f["id"], "step": "tape", "total": 3}
		Bouts.fight_step(c, f, m, "sim")
		for r in m.get("rounds", []):
			rounds += 1
			out.append_array((r as Dictionary)["exchanges"])
	return {"x": out, "rounds": rounds}


## Runs the moment's checks and prints each; returns the number that failed.
## yes / no = [[situation, card, your boxer won the last exchange]] that must / must not open the moment;
## not_sit = a situation the step does not answer (no ride there).
static func run(id: String, step: String, opp_name: String, yes: Array, no: Array, not_sit: String) -> int:
	finished = false
	var fails := [0]
	var check := func(ok: bool, what: String) -> void:
		print("%s %s" % ["ok  " if ok else "FAIL", what])
		if not ok:
			fails[0] += 1
	var row := StrikeMap.move(step)
	var from := str(row.get("from", ""))
	var to := str(row.get("to", ""))
	# 1. the answer table: the step is THE answer to its moment, to no other step's moment, and wrong somewhere.
	check.call(PlanFight.fit(step, id) == "best", "%s is the best answer to '%s' (%s)" % [step, id, PlanFight.fit(step, id)])
	check.call(MOMENTS.all(func(o): return str(o) == id or PlanFight.fit(step, str(o)) != "best"), "%s is not the answer to another step's moment" % step)
	check.call(PlanFight.ANSWERS.keys().any(func(s): return PlanFight.fit(step, str(s)) == "wrong"), "%s is the wrong answer in at least one situation" % step)
	var others_best: Array = (PlanFight.ANSWERS.get(id, {}) as Dictionary).get("best", [])
	var five := ["step_in", "step_out", "roll_out", "push_off", "herd"]
	check.call(not others_best.is_empty() and others_best.all(func(b): return str(b) == step or not five.has(str(b))),
		"none of the other four steps is best in '%s' (%s)" % [id, str(others_best)])
	# 2. the rule that deals it.
	var SM: Variant = load(PATH) if ResourceLoader.exists(PATH) else null
	check.call(SM != null, "rules/StepMoment.gd exists")
	if SM == null:
		finished = true
		return fails[0]
	check.call(str(SM.STEP.get(id, "")) == step and str(SM.CARD.get(id, from)) == from, "'%s' is %s's moment, fought on its card (%s)" % [id, step, from])
	check.call(float(SM.rate(id)) > 0.0 and float(SM.rate(id)) < 1.0, "it is dealt at a rate, never every time (%.2f)" % float(SM.rate(id)))
	for y in yes:
		var open: Array = SM.open_to(str(y[0]), str(y[1]), bool(y[2]))
		var before := 0.0
		for o in open:
			if str(o) == id:
				break
			before += float(SM.rate(str(o)))
		var d: Dictionary = SM.deal(str(y[0]), str(y[1]), bool(y[2]), before + 0.0001)
		check.call(open.has(id) and str(d.get("id", "")) == id and str(d.get("at", "")) == from, "%s on %s, last exchange won=%s: '%s' is dealt, fought on %s" % [str(y[0]), str(y[1]), str(y[2]), id, from])
		check.call((SM.deal(str(y[0]), str(y[1]), bool(y[2]), 0.9999) as Dictionary).is_empty(), "  ... and not on a high roll")
	for x in no:
		check.call(not (SM.open_to(str(x[0]), str(x[1]), bool(x[2])) as Array).has(id), "%s on %s, last exchange won=%s: no '%s'" % [str(x[0]), str(x[1]), str(x[2]), id])
	var lv0 := {"at": str(yes[0][1])}
	var on_card: Dictionary = SM.deal_on(lv0, str(yes[0][0]), bool(yes[0][2]), 0.9999)
	check.call(on_card.is_empty() and str(lv0["at"]) == str(yes[0][1]), "no moment: the exchange stays on its card")
	SM.on = false
	check.call(yes.all(func(y): return (SM.deal(str(y[0]), str(y[1]), bool(y[2]), 0.0) as Dictionary).is_empty()), "control arm (StepMoment off): never dealt")
	SM.on = true
	# 3. in its moment the planned step costs no exchange (StepWire.ride); in a situation it does not answer it does.
	var c0 := Career.quick_start()
	var f0 := _boxer(c0, step)
	f0["bout"] = {}
	var plan := [{"move": step}]
	var pick := PlanFight.choose(plan, from, f0["moves"], str(yes[0][0]))
	var rode := StepWire.ride({"n": 1}, pick, plan, f0, id, str(yes[0][0]), from, 0.0)
	check.call(str(pick["move"]) == step and not rode.is_empty() and str(rode.get("at", "")) == to, "in its moment the planned %s rides: the exchange is fought on %s" % [step, to])
	check.call(StepWire.ride({"n": 1}, pick, plan, f0, not_sit, not_sit, from, 0.0).is_empty(), "against '%s' it does not ride" % not_sit)
	# 4. played bouts: the fight deals it, not every round, on the step's card, inside the games the rule names.
	var games := {}
	for y in yes:
		games[str(y[0])] = true
	var p := _played(step, opp_name, plan)
	var dealt: Array = (p["x"] as Array).filter(func(x): return str((x as Dictionary).get("moment", "")) == id)
	check.call(dealt.size() >= 3 and dealt.size() < int(p["rounds"]), "%d bouts against %s: dealt %d times in %d rounds (some, not every round)" % [BOUTS, opp_name, dealt.size(), int(p["rounds"])])
	check.call(dealt.all(func(x): return games.has(str(x["sit"])) and str(x.get("rode_from", x["at"])) == from), "every one inside the opponent's game the rule names, on %s" % from)
	var fired: Array = dealt.filter(func(x): return bool(x["planned"]) and PlanFight.base_id(str(x["arrow"])) == step)
	check.call(not fired.is_empty() and fired.all(func(x): return str(x["arrow_fit"]) == "best" and PlanFight.base_id(str(x.get("rode", ""))) == step and str(x["at"]) == to),
		"the planned %s came off in %d of them: graded best, fought on %s" % [step, fired.size(), to])
	check.call(dealt.all(func(x): return PlanFight.ANSWERS.has(str(x["psit"])) and not MOMENTS.has(str(x["psit"]))), "the record keeps the opponent's game beside the moment")
	SM.on = false
	var q := _played(step, opp_name, plan)
	SM.on = true
	check.call((q["x"] as Array).all(func(x): return str((x as Dictionary).get("moment", "")) == ""), "control arm: no moment in the same %d bouts" % BOUTS)
	finished = true
	return fails[0]
