extends SceneTree
## S355 CORE3 step 3, the combo lab's hit rates (ComboOdds):
##   1. win_odds is the fight's own dice: over 20,000 Exchanges.settle rolls the share won at an edge matches it (the lab
##      never promises what the ring will not do),
##   2. a book combination maps to its fight move; its table rates each opponent game by its fit (best > none > wrong),
##   3. pad time, Fast hands and the strength gap move the numbers the way the fight does.
## Population: Lucy (Data.lucy, out-boxer) vs Maria (pressure fighter 61.5) and Dana (Data.MISMATCH, boxer-puncher 72); the
## one-two and the body hook, head hook.

const Data := preload("res://scripts/state/Data.gd")
const CO := preload("res://scripts/rules/ComboOdds.gd")
const Exchanges := preload("res://scripts/rules/Exchanges.gd")
const PlanFight := preload("res://scripts/rules/PlanFight.gd")

var _fails := 0


func _initialize() -> void:
	_check(is_equal_approx(CO.win_odds(0.0), 0.5) and CO.win_odds(Exchanges.EX_SPREAD) == 1.0 and CO.win_odds(-Exchanges.EX_SPREAD) == 0.0,
		"even = 50%, a full spread up = sure, down = never")
	_check(is_equal_approx(CO.win_odds(12.0) + CO.win_odds(-12.0), 1.0) and CO.win_odds(12.0) > CO.win_odds(5.0), "symmetric and rising")
	var rng := RandomNumberGenerator.new()
	rng.seed = 355
	var worst := 0.0
	for d in [-25.0, -9.0, 0.0, 7.0, 21.0]:
		var won := 0
		for i in 20000:
			won += int(bool(Exchanges.settle(d, rng.randf(), rng.randf())["won"]))
		var err := absf(float(won) / 20000.0 - CO.win_odds(d))
		worst = maxf(worst, err)
		print("  edge %+.0f: ring %.3f, lab %.3f" % [d, float(won) / 20000.0, CO.win_odds(d)])
	_check(worst < 0.015, "the lab's odds are the ring's: worst gap %.3f over 5 edges x 20,000 exchanges" % worst)

	_check(CO.move_of("1-2") == "1-2" and CO.move_of("3b-3") == "3b-3" and CO.move_of("nonsense") == "", "book combinations map to fight moves")
	var f: Dictionary = Data.fighter_state(Data.lucy(), 0)
	f["camp"] = {}
	f["combos"] = {"1-2": 60.0}
	var maria: Dictionary = (Data.OPPONENTS[0] as Dictionary).duplicate(true)
	var t := CO.table("1-2", f, maria)
	_check((t["rows"] as Array).size() == CO.GAMES.size() and str(t["main"]) == Exchanges.favourite("Pressure fighter"), "five games, Maria's main game marked (%s)" % t["main"])
	var by := {}
	for r in t["rows"]:
		by[str(r["fit"])] = float(r["odds"])
	print("  one-two vs Maria: %s, base %.2f" % [str((t["rows"] as Array).map(func(r): return "%s %s %.2f" % [r["sit"], r["fit"], r["odds"]])), t["base"]])
	if by.has("best") and by.has("wrong"):
		_check(float(by["best"]) > float(t["base"]) and float(by["wrong"]) < float(t["base"]), "its best game beats a plain exchange, a wrong game loses to it")
	var best_sit := ""
	for r in t["rows"]:
		if str(r["fit"]) in ["best", "ok"]:
			best_sit = str(r["sit"])
			break
	_check(best_sit != "", "the one-two fits some game")
	var raw := f.duplicate(true)
	raw["combos"] = {}
	var t_raw := CO.table("1-2", raw, maria)
	var fast := f.duplicate(true)
	fast["perks"] = {"hand_speed": 1}
	var t_fast := CO.table("1-2", fast, maria)
	_check(_odds(t_raw, best_sit) < _odds(t, best_sit) and not bool(t_raw["drilled"]), "undrilled: worth less on its good game")
	_check(_odds(t_fast, best_sit) > _odds(t, best_sit), "Fast hands: lands whole more often")
	var dana := CO.table("1-2", f, (Data.MISMATCH as Dictionary).duplicate(true))
	_check(float(dana["gap"]) < float(t["gap"]) and _odds(dana, best_sit) < _odds(t, best_sit), "against Dana (72) every number drops")
	var even := CO.table("1-2", f, {})
	_check(float(even["gap"]) == 0.0 and is_equal_approx(float(even["base"]), 0.5) and str(even["main"]) == "", "no opponent: an even one")
	_check(CO.table("nonsense", f, maria).is_empty(), "no table for a chain that is not a book combination")
	print("FAILURES %d" % _fails)
	quit(1 if _fails > 0 else 0)


func _odds(t: Dictionary, sit: String) -> float:
	for r in t["rows"]:
		if str(r["sit"]) == sit:
			return float(r["odds"])
	return -1.0


func _check(ok: bool, what: String) -> void:
	print(("PASS " if ok else "FAIL ") + what)
	if not ok:
		_fails += 1
