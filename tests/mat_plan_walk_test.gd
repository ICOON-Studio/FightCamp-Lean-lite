extends SceneTree
## MATWALK1 (MATPLAN_MAP_S433 4.5, build task M4): the mat plan's lines and scoreboard reach the match (BjjBeat.walk).
## Ana (NoGi.athlete, white) against a seeded white Passer (BjjOpp.generate): two different athletes. Prints MAT_PLAN_WALK failures=N.
##  1 no lines and no board = today's walk, seed for seed (path and score)
##  2 a side-control escape line is tried from side control more often than the walk tries it on its own
##  3 FRAME FIRST works the hands before the try: under a stack of 2 the beat's pick is WORK, at 2 it is the line
##  4 the scoreboard: Push on every row makes Ana try more than Save on every row
##  5 SIT TIGHT never tries the escape on that position

const BjjTree := preload("res://scripts/rules/BjjTree.gd")
const BjjWalk := preload("res://scripts/rules/BjjWalk.gd")
const BjjBeat := preload("res://scripts/rules/BjjBeat.gd")
const BjjOpp := preload("res://scripts/rules/BjjOpp.gd")
const NoGi := preload("res://scripts/rules/NoGi.gd")

const SEEDS := 160
const SC := "side_control_bottom"
const ESC := "e046"

var _fails := 0
var _rules: Dictionary = {}
var _ana: Dictionary = {}
var _opp: Dictionary = {}


func _initialize() -> void:
	BjjTree.reset_tuning()
	BjjOpp.reset_tuning()
	_rules = BjjTree.rules_for("white")
	_ana = NoGi.athlete()
	_opp = BjjOpp.generate("white", "Passer", 3)
	_check(str(_ana["stats"]) != str(_opp["stats"]), "two different athletes (Ana v %s, Passer)" % str(_opp["name"]))
	var base := _run({})
	var same := _run({"lines": []})
	_check(str(base["paths"]) == str(same["paths"]) and str(base["scores"]) == str(same["scores"]),
		"1 no lines, no board: the same %d walks seed for seed" % SEEDS)
	var once := _run({"lines": [{"at": SC, "edge": ESC, "timing": "at_once"}]})
	_check(int(once["esc"]) > int(base["esc"]), "2 the escape line is tried more from side control (%d against %d)" % [once["esc"], base["esc"]])
	_frame_first()
	var push := _run({"board": {"level": "push", "ahead": "push", "behind": "push"}})
	var save := _run({"board": {"level": "save", "ahead": "save", "behind": "save"}})
	_check(int(push["tries"]) > int(save["tries"]), "4 Push on every row tries more than Save (%d against %d)" % [push["tries"], save["tries"]])
	var sit := _run({"lines": [{"at": SC, "edge": ESC, "timing": "sit_tight"}]})
	_check(int(sit["esc"]) == 0, "5 sit tight never tries the escape from side control (%d)" % sit["esc"])
	print("MAT_PLAN_WALK failures=%d" % _fails)
	quit(0 if _fails == 0 else 1)


func _frame_first() -> void:
	var a: Dictionary = _ana.duplicate(true)
	var plan: Dictionary = (a.get("bjj_plan", {}) as Dictionary).duplicate(true)
	plan["lines"] = [{"at": SC, "edge": ESC, "timing": "frame_first"}]
	a["bjj_plan"] = plan
	var r := RandomNumberGenerator.new()
	r.seed = 515
	var ctx := BjjWalk._ctx(a, _opp, [[], []], _rules, {})
	var st := BjjWalk.start(a, 5, _rules, r, {})
	st["at"] = SC
	st["grip"] = [0.0, 0.0]
	var p0: Dictionary = BjjBeat._choose(ctx, st, 0, r)
	st["grip"] = [2.0, 0.0]
	var p2: Dictionary = BjjBeat._choose(ctx, st, 0, r)
	_check((p0["e"] as Dictionary).is_empty() and str(p0["why"]) == "line" and str((p2["e"] as Dictionary).get("id", "")) == ESC,
		"3 frame first: no hands won = work the frames; two stacks = the escape line (%s)" % str((p2["e"] as Dictionary).get("id", "")))


## SEEDS walks of Ana (her plan + `add`) against the Passer. -> {paths, scores, esc (Ana's tries of ESC), works, tries}
func _run(add: Dictionary) -> Dictionary:
	var a: Dictionary = _ana.duplicate(true)
	var plan: Dictionary = (a.get("bjj_plan", {}) as Dictionary).duplicate(true)
	for k in add:
		plan[k] = add[k]
	a["bjj_plan"] = plan
	var steps: Array = BjjTree.plan_of(a, _rules)
	var opp_steps: Array = BjjTree.route(str(_opp.get("route", ""))).get("steps", [])
	var out := {"paths": [], "scores": [], "esc": 0, "works": 0, "tries": 0}
	for i in SEEDS:
		var r := RandomNumberGenerator.new()
		r.seed = hash("matwalk|%d" % i)
		var w: Dictionary = BjjWalk.walk(a, _opp, [steps, opp_steps], 5, _rules, r)
		out["paths"].append(w["path"])
		out["scores"].append(w["score"])
		out["works"] = int(out["works"]) + int((w.get("works", [0, 0]) as Array)[0])
		out["tries"] = int(out["tries"]) + int((w.get("attempts", [0, 0]) as Array)[0])
		for p in w["path"]:
			if str(p[0]) == ESC and int(p[1]) == 0:
				out["esc"] = int(out["esc"]) + 1
	return out


func _check(ok: bool, what: String) -> void:
	print(("  ok   " if ok else "  FAIL ") + what)
	if not ok:
		_fails += 1
