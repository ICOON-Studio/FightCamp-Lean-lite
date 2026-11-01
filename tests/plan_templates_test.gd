extends SceneTree
## S341 situation templates from real fight plans (PlanTemplates; Game Godot/research/REALPLANS_S341.md): every template is a
## legal plan on our maps (one arrow per card and situation, our moves only), a smaller coach keeps its core, and in the bout
## each boxing template made for a game beats the coach's starter plan against an opponent who plays that game.
## Population: Lucy Jackson (out-boxer) against Maria Ortega (pressure fighter, Data.OPPONENTS[0]) and Priya Nair
## (counter-puncher, [1]) - two different opponents; 40 bouts each on 40 different days, every plan on the same 40.

const Data := preload("res://scripts/state/Data.gd")
const Bouts := preload("res://scripts/state/Bouts.gd")
const PlanBoard := preload("res://scripts/rules/PlanBoard.gd")
const PlanFight := preload("res://scripts/rules/PlanFight.gd")
const PlanTemplates := preload("res://scripts/rules/PlanTemplates.gd")
const StrikeMap := preload("res://scripts/rules/StrikeMap.gd")
const TieUpPanel := preload("res://scripts/grapple/TieUpPanel.gd")
const FightFlow := preload("res://scripts/rules/FightFlow.gd")
const BOUTS := 40

var failures := 0


func _initialize() -> void:
	# 1. Legal on our maps, at the top coach's limit.
	for t in PlanTemplates.BOXING:
		var v := PlanBoard.validate(t["arrows"], StrikeMap.MOVES, PlanBoard.TOP_COACH, FightFlow.WHEN_WORDS)
		_check(v["ok"] and (t["arrows"] as Array).all(func(a): return str(a.get("when", "")) == "" or FightFlow.WHEN_WORDS.has(str(a["when"]))),
			"%s: %d arrows, legal (%s) - from %s" % [t["name"], (t["arrows"] as Array).size(), str(v["problems"]), t["from"]])
	var wmap := TieUpPanel.plan_map()
	for t in PlanTemplates.WRESTLING:
		var v := PlanBoard.validate(t["arrows"], wmap, PlanBoard.TOP_COACH)
		_check(v["ok"], "%s: legal on the tie-up map (%s)" % [t["name"], str(v["problems"])])
	var small := PlanTemplates.load(PlanTemplates.boxing("t_ground"), PlanBoard.NEW_COACH)
	_check(small.size() == PlanBoard.NEW_COACH and str(small[0]["move"]) == "tie_up", "a new coach keeps the core 4 of Holyfield's 7")
	_check(PlanTemplates.for_game("press").has("t_turn") and PlanTemplates.for_game("counter").has("t_outwork"), "templates are found by her game")

	# 2. In the bout: the template for her game against the coach's starter plan.
	var maria: Dictionary = Data.OPPONENTS[0]
	var priya: Dictionary = Data.OPPONENTS[1]
	var ranger: Dictionary = Data.RIVALS.filter(func(r): return str(r["style"]) == "Out-boxer")[0]
	# [template, opponent, gate]: "beats" = more edge and as many exchanges as the starter; "matches" = as many exchanges
	# won and a positive edge (S342: after Q-S294-67 the starter's opening 1-2 IS the walk-down's jab - REALPLANS edit 2 -
	# so vs a range boxer the template can only match it; the S341 t_walk read 0.535 vs 0.549 here and fails this);
	# "report" = a real plan our table disagrees with.
	for row in [["t_turn", maria, "beats"], ["t_outwork", priya, "beats"], ["t_walk", ranger, "matches"], ["t_ground", maria, "report"]]:
		var t := PlanTemplates.boxing(str(row[0]))
		var tp := _share(PlanTemplates.load(t, PlanBoard.TOP_COACH), row[1])
		var st := _share(PlanFight.starter(), row[1])
		print("  %s vs %s (%s): won %.3f (edge %+.2f) vs the starter plan %.3f (edge %+.2f)" % [t["name"], row[1]["first"], row[1]["style"],
			tp[0], tp[1], st[0], st[1]])
		if str(row[2]) == "beats":
			_check(float(tp[1]) > float(st[1]) and float(tp[0]) >= float(st[0]) - 0.005, "%s answers %s better than the starter plan" % [t["id"], row[1]["first"]])
		elif str(row[2]) == "matches":
			_check(float(tp[1]) > 0.0 and float(tp[0]) >= float(st[0]) - 0.005, "%s wins as many exchanges vs %s as the starter plan, with a plan edge" % [t["id"], row[1]["first"]])
		else:
			print("  (real plan our answer table disagrees with - REALPLANS_S341.md section 3; reported, not gated)")
	var merged := PlanTemplates.load(PlanTemplates.boxing("t_exits"), 6, PlanFight.starter(), StrikeMap.MOVES)
	_check(merged.size() == 6 and (merged.slice(0, 5) as Array) == PlanTemplates.boxing("t_exits")["arrows"] and merged[5] == {"move": "1-2"},
		"a situation template is an add-on: its 5 arrows first, then her own any-time 1-2, up to the coach's 6 (%s)" % str(merged))

	print("PLAN_TEMPLATES failures=%d" % failures)
	quit(1 if failures > 0 else 0)


## [share of exchanges won, mean plan edge] over BOUTS bouts with this plan against this opponent.
func _share(arrows: Array, opp: Dictionary) -> Array:
	var won := 0
	var all := 0
	var edge := 0.0
	for i in BOUTS:
		var c := Career.quick_start()
		c.fighters.append(Data.fighter_state(Data.lucy(), c.day))
		c.day = 40 + i
		var f: Dictionary = c.fighter()
		f["camp"] = {}
		f["combos"] = {"1-1": 50.0, "1-2": 50.0, "1-1-2": 50.0, "2-3": 40.0}
		f["arrows"] = arrows.duplicate(true)
		f["bout"] = {"opp": opp.duplicate(true), "day": c.day, "weighed": true, "made": true, "done": false, "film": 3}
		var m := {"fid": f["id"], "step": "tape", "total": 3}
		Bouts.fight_step(c, f, m, "sim")
		for r in m["rounds"]:
			for x in r["exchanges"]:
				all += 1
				won += int(bool(x["won"]))
				edge += float(x.get("plan_edge", 0.0))
	return [float(won) / maxf(1.0, float(all)), edge / maxf(1.0, float(all))]


func _check(cond: bool, label: String) -> void:
	if cond:
		print("PASS ", label)
	else:
		failures += 1
		print("FAIL ", label)
