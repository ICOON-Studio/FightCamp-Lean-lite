extends SceneTree
## S524 GUARDWEAR steps 1-2: GuardState - both guards full at the first bell (amateur max 70, a pro by class), blocks
## wear the defender (the side that took more punches loses more guard), the ropes wear faster than the open ring
## (control arm: the same exchange off the ropes), the corner's minute gives back 15, and the HUD bar reads it.

const GuardState := preload("res://scripts/state/GuardState.gd")
const GuardWear := preload("res://scripts/rules/GuardWear.gd")
const FightMeters := preload("res://scripts/rules/FightMeters.gd")
const FightStats := preload("res://scripts/rules/FightStats.gd")

var failures := 0


func _check(ok: bool, what: String) -> void:
	print("%s %s" % ["ok  " if ok else "FAIL", what])
	if not ok:
		failures += 1


func _f(pro: bool, limit: float) -> Dictionary:
	return {"pro": pro, "limit": limit, "bout": {}, "stats": {}, "attrs": {"stamina": 60.0, "strength": 55.0}}


func _initialize() -> void:
	var am := _f(false, 60.0)
	var g: Dictionary = GuardState.open(am, 1)
	_check(float(g["a"]["g"]) == 70.0 and float(g["b"]["max"]) == 70.0, "an amateur's guard starts full at 70")
	var pro := _f(true, 75.0)
	_check(float(GuardState.open(pro, 1)["a"]["max"]) == 100.0, "a pro middleweight's guard is 100")
	_check(float(GuardState.open(_f(true, 57.0), 1)["a"]["max"]) == 80.0 and GuardState.wclass(90.0) == "heavy", "light 80, heavy above 81 kg")
	_check(GuardState.blocked_of(4) == 5 and GuardState.blocked_of(0) == 0, "4 landed of 13 thrown: 5 of the other 9 blocked (%d)" % GuardState.blocked_of(4))
	# A 6-1 exchange: our boxer landed 6, the opponent 1 - the opponent blocked far more of ours and loses more guard.
	var r := GuardState.after(am, [6, 1], "", {"stamina": 55.0, "strength": 55.0})
	var ga := float(r["g"][0])
	var gb := float(r["g"][1])
	_check(gb < ga and ga <= 70.0 and gb > 0.0, "the side under fire loses more guard (ours %.1f, theirs %.1f)" % [ga, gb])
	_check(absf(float(r["share"][1]) - gb / 70.0) < 0.001, "share = guard / max")
	# Control arm: the same exchange with our boxer on the ropes wears ours faster.
	var open_ring := _f(false, 60.0)
	GuardState.open(open_ring, 1)
	var on_ropes := _f(false, 60.0)
	GuardState.open(on_ropes, 1)
	var r1 := GuardState.after(open_ring, [3, 4], "", {})
	var r2 := GuardState.after(on_ropes, [3, 4], "own_ropes", {})
	_check(float(r2["g"][0]) < float(r1["g"][0]) and absf(float(r2["g"][1]) - float(r1["g"][1])) < 0.001,
		"trapped on the ropes wears our guard faster (%.2f vs %.2f), theirs the same" % [float(r2["g"][0]), float(r1["g"][0])])
	# A round of six 4-3 exchanges, then the corner.
	var bout := _f(false, 60.0)
	GuardState.open(bout, 1)
	for i in 6:
		GuardState.after(bout, [4, 3], "", {})
	var end_r1 := float(bout["bout"]["guard"]["a"]["g"])
	_check(end_r1 < 70.0 and end_r1 > 20.0, "a round of 4-3 exchanges wears the guard but leaves it standing (%.1f of 70)" % end_r1)
	GuardState.open(bout, 2)
	_check(absf(float(bout["bout"]["guard"]["a"]["g"]) - minf(70.0, end_r1 + 15.0)) < 0.001, "the corner's minute gives back 15")
	# The HUD bar: guard_v4 lowers the bar; without it the bar is as before.
	var src := {"energy": 100.0, "burn": {}, "drop": {}}
	var before := float(FightMeters.bars(src)["guard"]["fill"])
	src["guard_v4"] = 0.4
	_check(absf(float(FightMeters.bars(src)["guard"]["fill"]) - 0.4) < 0.001 and before == 1.0, "the guard bar reads the worn guard (1.0 -> 0.4)")
	_check(GuardState.share({"bout": {}}, "a") == -1.0, "no guard yet (an old save): -1, the bar keeps its old reading")
	# The result page's stats: blocks and the guard left, only for a bout that has a guard (control: an old save's rounds).
	var ex1 := {"landed": [4, 3], "body": [1, 0], "won": true, "guard": {"blocked": [5, 6], "share": [0.8, 0.7]}}
	var ex2 := {"landed": [2, 5], "body": [0, 1], "won": false, "guard": {"blocked": [7, 3], "share": [0.6, 0.65]}}
	var st := FightStats.of([{"n": 1, "exchanges": [ex1, ex2]}])
	var labels: Array = FightStats.rows(st).map(func(r): return str(r["label"]))
	_check(st["blocked"] == [12, 9] and labels.has("Punches blocked") and labels.has("Guard left at the last bell"),
		"the result page counts blocks (%s) and the guard left (%s)" % [str(st["blocked"]), str(st["guard"])])
	var old := FightStats.rows(FightStats.of([{"n": 1, "exchanges": [{"landed": [4, 3], "body": [1, 0], "won": true}]}]))
	_check(not old.map(func(r): return str(r["label"])).has("Punches blocked"), "an old save's bout shows no guard rows")
	print("GUARD_STATE failures=%d" % failures)
	quit(0 if failures == 0 else 1)
