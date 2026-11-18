extends SceneTree
## S518 STEPVALUE1 map s7 (the Why): the planned step that fired 3+ times is weighed against the opponent's style
## (StepValue.TARGET) - YOUR PLAN when it helps ("worth about +3.5 in 100 against that style"), AGAINST YOU when it walks
## into her game; NEXT says learn Pivot off the ropes when the count put the boxer there and no way off fired. Fewer than
## 3, or no style known, says nothing. Rounds are hand-made tallies (PlanFight.tally's shape: moves {id: [won, used]}).
## Prints STEP_WHY failures=N.

const FightWhy := preload("res://scripts/rules/FightWhy.gd")

var _fails := 0


func _round(moves: Dictionary, ropes := 0) -> Dictionary:
	return {"exchanges": [{"won": true}, {"won": false}], "arrows": {"used": 0, "worked": 0, "improvised": 0, "moves": moves}, "ropes": ropes}


func _initialize() -> void:
	var r := FightWhy.read([_round({"step_back": [2, 3]}), _round({"step_back": [1, 2]})], "Lucy", "Maria", "Pressure fighter")
	_check(str(r["plan"]).contains("fired 5 times against a pressure fighter: worth about +3.5 in 100"), "step back vs pressure, 5 fired: %s" % r["plan"])
	var w := FightWhy.read([_round({"step_back": [1, 4]})], "Lucy", "Maria", "Out-boxer")
	_check(str(w["against"]).contains("walks into that style (about -1.5 in 100)") and not str(w["plan"]).contains("worth about"),
		"step back vs an out-boxer walks into it: %s" % w["against"])
	var few := FightWhy.read([_round({"step_back": [1, 2]})], "Lucy", "Maria", "Pressure fighter")
	_check(not str(few["plan"]).contains("worth about"), "2 fired: nothing said")
	var nostyle := FightWhy.read([_round({"step_back": [2, 5]})], "Lucy", "Maria")
	_check(not str(nostyle["plan"]).contains("worth about"), "no style known: nothing said")
	var trapped := FightWhy.read([_round({"step_back": [0, 3]}, 2)], "Lucy", "Maria", "Pressure fighter")
	_check(str(trapped["next"]).contains("Learn Pivot off the ropes: a way off the ropes."), "on the ropes, no way off: %s" % trapped["next"])
	var pivoted := FightWhy.read([_round({"pivot_out": [1, 1]}, 1)], "Lucy", "Maria", "Pressure fighter")
	_check(not str(pivoted["next"]).contains("Learn Pivot"), "a pivot fired: no learn line")
	print("STEP_WHY failures=%d" % _fails)
	quit(1 if _fails > 0 else 0)


func _check(ok: bool, what: String) -> void:
	if ok:
		print("  ok   %s" % what)
	else:
		_fails += 1
		print("  FAIL %s" % what)
