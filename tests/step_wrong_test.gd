extends SceneTree
## S538 STEPPAY4: the wrong style punishes the step (rules/StepWrong.gd, wired in state/RingDuel.gd). One rule a step:
## step in / herd give a presser her press, step out / step back / pivot out give a range boxer her range - for the rest
## of the round, until your boxer wins an exchange without the step. Red on main (no rule, no mark in a played bout).
## Control arm: StepWrong.on false = the game before.

const Kit := preload("res://tests/step_moment_kit.gd")
const PATH := "res://scripts/rules/StepWrong.gd"
## step -> [the game it gives, the shipped opponent of the style that punishes it]
const RULES := {
	"step_in": ["press", "Maria Ortega", 0.55], "herd": ["press", "Maria Ortega", 0.55],
	"step_out": ["range", "Holly Price", 0.6], "step_back": ["range", "Holly Price", 0.6], "pivot_out": ["range", "Holly Price", 0.6],
}
## step -> a situation it is the best answer to (it rides there, StepWire.ride)
const BEST := {"step_in": "short", "herd": "drift", "step_out": "landed", "step_back": "press", "pivot_out": "press"}
var fails := 0


func check(ok: bool, what: String) -> void:
	print("%s %s" % ["ok  " if ok else "FAIL", what])
	if not ok:
		fails += 1


func _initialize() -> void:
	if not ResourceLoader.exists(PATH):
		print("FAIL no rule: %s" % PATH)
		print("step_wrong_test: FAIL (1 failures)")
		quit(1)
		return
	var SW: Script = load(PATH)
	for step in ["cut_off", "feint", "tie_up", "roll_out", "push_off", "1-2", ""]:
		check(str(SW.gives(step)) == "", "'%s' gives her no game" % step)
	for step in RULES:
		_rule(SW, str(step), str(RULES[step][0]), str(RULES[step][1]), float(RULES[step][2]))
		_bare(SW, str(step), str(RULES[step][1]), str(BEST[step]), "")
	# the line of the loaded shot: step back against the boxer whose main game it is, while she loads up
	var slug: Dictionary = Kit.Data.OPPONENTS.filter(func(o): return str(o["style"]) == "Slugger")[0] if Kit.Data.OPPONENTS.any(func(o): return str(o["style"]) == "Slugger") else {}
	var sw: Dictionary = {"loadup": 0.45, "press": 0.35, "counter": 0.1, "range": 0.1}
	check(bool(SW.bare("step_back", sw, "loadup")) and not bool(SW.bare("step_back", sw, "press")) and not bool(SW.bare("step_back", sw, "")), "step back from a slugger loading up is only a step; in her other games it is what it was")
	check(not bool(SW.bare("step_back", {"press": 0.55, "loadup": 0.2}, "loadup")) and not bool(SW.bare("pivot_out", sw, "loadup")) and not bool(SW.bare("roll_out", sw, "loadup")),
		"  only the boxer whose main game is the loaded shot, only the step straight back")
	check(is_equal_approx(float(SW.meet("step_back", sw, "loadup")), -float(SW.COST) * 0.45) and float(SW.meet("step_back", sw, "press")) == 0.0 and float(SW.meet("roll_out", sw, "loadup")) == 0.0 and str(SW.met_game("step_back", sw, "loadup")) == "loadup",
		"  and she meets it there: the exchange is hers by %.1f points (her loadup share)" % (float(SW.COST) * 0.45))
	check(str(SW.main(sw)) == "loadup" and str(SW.main({})) == "", "  her main game is the heaviest of her style's row")
	if not slug.is_empty():
		_bare(SW, "step_back", str(slug["name"]), "loadup", "loadup")
	_slide(SW)
	print("step_wrong_test: %s (%d failures)" % ["PASS" if fails == 0 else "FAIL", fails])
	quit(1 if fails > 0 else 0)


func _rule(SW: Script, step: String, game: String, opp_name: String, w: float) -> void:
	var other := "range" if game == "press" else "press"
	check(str(SW.gives(step)) == game and str(SW.gives(step + "@corner")) == game, "%s gives her '%s'" % [step, game])
	# the mark: a planned step that came off (won or lost); not an unplanned one; a won exchange without it takes it back
	var lv := {}
	SW.after(lv, step, false, false)
	check(not lv.has("gave"), "  an unplanned or held %s marks nothing" % step)
	SW.after(lv, step, true, true)
	check(str(lv.get("gave", "")) == game, "  the planned %s leaves the mark, even in an exchange your boxer won" % step)
	SW.after(lv, "1-2", true, false)
	check(str(lv.get("gave", "")) == game, "  a lost exchange keeps it")
	check(is_equal_approx(float(SW.edge(lv, game, w)), -float(SW.COST) * w) and float(SW.edge(lv, other, w)) == 0.0 and float(SW.edge(lv, "tiring", w)) == 0.0,
		"  she has %.1f power points while she plays '%s' (%.2f of her fight), nothing in another game" % [float(SW.COST) * w, game, w])
	check(is_equal_approx(float(SW.meet(step, {game: w})), -float(SW.COST) * w) and float(SW.meet(step, {game: 0.45})) == 0.0 and float(SW.meet("1-2", {game: w})) == 0.0 and float(SW.meet("", {game: w})) == 0.0,
		"  she meets the step itself at the same price; a boxer who does not live on '%s' does not" % game)
	check(float(SW.edge(lv, game, 0.45)) == 0.0 and float(SW.edge(lv, game, 0.1)) == 0.0 and float(SW.edge(lv, game, 0.5)) < 0.0, "  only a style that lives on '%s' (half her fight) punishes it" % game)
	var lm := {}
	SW.after(lm, step, true, false)
	check(str(lm.get("gave", "")) == game, "  a lost exchange with the planned step marks it too")
	var b0 := {other: 0.5}
	var b: Dictionary = SW.bias(b0, lv, {game: w})
	check(float(b.get(game, 0.0)) == float(SW.PULL) and float(b[other]) == 0.5 and not b0.has(game) and (SW.bias(b0, lv, {game: 0.45}) as Dictionary) == b0, "  and plays it %.1fx as often (the bias handed in is not edited)" % float(SW.PULL))
	SW.on = false
	check(float(SW.edge(lv, game, w)) == 0.0 and (SW.bias(b0, lv, {game: w}) as Dictionary) == b0, "  control arm (StepWrong off): no points, no pull")
	SW.on = true
	SW.after(lv, "1-2", true, true)
	check(not lv.has("gave") and float(SW.edge(lv, game, w)) == 0.0, "  a won exchange without the step takes the ring back")
	# played bouts: she cashes it in some exchanges, far from all, always in the game a planned step gave her
	# a later planned step that gives her ANOTHER game takes the mark over, so the press steps play without the range steps
	var plan := [{"move": step}, {"move": "1-2"}, {"move": "tie_up"}] if game == "press" else [{"move": step}, {"move": "1-2"}, {"move": "step_back"}, {"move": "tie_up"}, {"move": "pivot_out"}]
	var games := {}
	for a in plan:
		if str(SW.gives(str(a["move"]))) != "":
			games[str(SW.gives(str(a["move"])))] = true
	var p: Dictionary = Kit._played(step, opp_name, plan)
	var xs: Array = p["x"]
	var traps: Array = xs.filter(func(x): return str((x as Dictionary).get("trap", "")) != "")
	check(traps.any(func(x): return str(x["trap"]) == game and is_equal_approx(float(x["trap_edge"]), -float(SW.COST) * w)), "  ... '%s' among them at %.1f points" % [game, float(SW.COST) * w])
	check(traps.size() >= 3 and traps.size() < xs.size() / 2, "  %d bouts against %s: she cashed a given game in %d of %d exchanges (some, far from all)" % [int(Kit.BOUTS), opp_name, traps.size(), xs.size()])
	check(traps.all(func(x): return games.has(str(x["trap"])) and float(x["trap_edge"]) < 0.0 and float(x["trap_edge"]) >= -float(SW.COST) * 0.61 and (str(x["mode"]) == str(x["trap"]) or (bool(x.get("met", false)) and bool(x["planned"]) and str(SW.gives(str(x["arrow"]))) == str(x["trap"])))),
		"  each in the game a planned step gave her or on the step itself, at the rule's price, kept apart from the duel's points")
	var fired: Array = xs.filter(func(x): return bool(x["planned"]) and Kit.PlanFight.base_id(str(x["arrow"])) == step)
	check(not fired.is_empty() and fired.all(func(x): return str(x.get("trap", "")) == game and is_equal_approx(float(x["trap_edge"]), -float(SW.COST) * w) and str(x.get("rode", "")) == "" and str(x["arrow_fit"]) == "wrong"),
		"  she met each of the %d planned %s that came off: the exchange is hers by %.1f points, no punch went with the step, graded wrong" % [fired.size(), step, float(SW.COST) * w])
	SW.on = false
	var q: Dictionary = Kit._played(step, opp_name, plan)
	SW.on = true
	check((q["x"] as Array).all(func(x): return str((x as Dictionary).get("trap", "")) == ""), "  control arm: none in the same %d bouts" % int(Kit.BOUTS))


## (c) the step is only a step: StepWire.ride gives no punch with it against the style that punishes it (mode = her game
## for the line rule, "" = any), and rides as before against another style and in the control arm.
func _bare(SW: Script, step: String, opp_name: String, psit: String, mode: String) -> void:
	var from := str(Kit.StrikeMap.move(step).get("from", ""))
	var c0 := Career.quick_start()
	var f0: Dictionary = Kit._boxer(c0, step)
	var plan := [{"move": step}]
	var pick: Dictionary = Kit.PlanFight.choose(plan, from, f0["moves"], psit)
	var lv := {"n": 1, "mode": mode}
	f0["bout"] = {"opp": Kit._opp("Priya Nair")}
	var free: Dictionary = Kit.StepWire.ride(lv.duplicate(), pick, plan, f0, psit, psit, from, 0.0)
	check(str(pick["move"]) == step and not free.is_empty(), "  against a counter-puncher the planned %s still carries its punch in '%s'" % [step, psit])
	f0["bout"] = {"opp": Kit._opp(opp_name)}
	check((Kit.StepWire.ride(lv.duplicate(), pick, plan, f0, psit, psit, from, 0.0) as Dictionary).is_empty(), "  against %s it is only a step (no punch with it)" % opp_name)
	if mode != "":
		check(not (Kit.StepWire.ride({"n": 1, "mode": "press"}, pick, plan, f0, psit, psit, from, 0.0) as Dictionary).is_empty(), "  ... and carries its punch when she is not playing '%s'" % mode)
	SW.on = false
	check(not (Kit.StepWire.ride(lv.duplicate(), pick, plan, f0, psit, psit, from, 0.0) as Dictionary).is_empty(), "  control arm (StepWrong off): it rides against %s as before" % opp_name)
	SW.on = true


## S539 STEPPAY5: a boxer who lives on the range slides off the first cut of a round (only a step, no punch rides); once
## the ring is cut (lv.ring_cut) the next cut rides. Another style, and the control arm, ride as before.
func _slide(SW: Script) -> void:
	var ob := {"range": 0.6, "counter": 0.25, "press": 0.05, "loadup": 0.1}
	check(bool(SW.slides("cut_off", ob, {})) and not bool(SW.slides("cut_off", ob, {"ring_cut": 0.3})) and not bool(SW.slides("cut_off", {"range": 0.25, "counter": 0.55}, {})) and not bool(SW.slides("step_in", ob, {})),
		"cut off: a range boxer slides off the first cut; not once the ring is cut, not another style, not another step")
	var from := str(Kit.StrikeMap.move("cut_off").get("from", ""))
	var f0: Dictionary = Kit._boxer(Career.quick_start(), "cut_off")
	var plan := [{"move": "cut_off"}]
	var pick: Dictionary = Kit.PlanFight.choose(plan, from, f0["moves"], "range")
	f0["bout"] = {"opp": Kit._opp("Holly Price")}
	check(str(pick["move"]) == "cut_off" and (Kit.StepWire.ride({"n": 1, "mode": "range"}, pick, plan, f0, "range", "range", from, 0.0) as Dictionary).is_empty(), "  against Holly Price the first cut is only a step")
	check(not (Kit.StepWire.ride({"n": 1, "mode": "range", "ring_cut": 0.3}, pick, plan, f0, "range", "range", from, 0.0) as Dictionary).is_empty(), "  ... and the cut after it carries its punch")
	SW.on = false
	check(not (Kit.StepWire.ride({"n": 1, "mode": "range"}, pick, plan, f0, "range", "range", from, 0.0) as Dictionary).is_empty(), "  control arm (StepWrong off): the first cut rides as before")
	SW.on = true
	f0["bout"] = {"opp": Kit._opp("Priya Nair")}
	check(not (Kit.StepWire.ride({"n": 1, "mode": "range"}, pick, plan, f0, "range", "range", from, 0.0) as Dictionary).is_empty(), "  against a counter-puncher the first cut rides")
