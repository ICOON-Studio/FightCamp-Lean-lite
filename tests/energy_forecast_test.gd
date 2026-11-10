extends SceneTree
## FIGHTDISPLAY2: the tank forecast. Five cases, numbers printed. Steady holds, push runs out a round sooner,
## save lasts longer, nothing left to fight this round, energy already under 20.

const EnergyForecast := preload("res://scripts/rules/EnergyForecast.gd")

var failures := 0


func _initialize() -> void:
	_steady_stays()
	_push_sooner()
	_save_longer()
	_zero_exchanges()
	_already_under()
	print("ENERGY_FORECAST failures=%d" % failures)
	quit(1 if failures > 0 else 0)


func _steady_stays() -> void:
	var got: Dictionary = EnergyForecast.rounds_left(70.0, [], "steady", 6, 2)
	print("  steady stays ", got)
	_near(got["by_round"], [52.0, 43.0, 34.0], "steady ends each round above 20")
	_check(int(got["out_round"]) == 0, "steady lasts (out %s)" % str(got["out_round"]))


func _push_sooner() -> void:
	var drains: Array = [{"drain": 5.0, "pace": "steady"}, {"drain": 5.0, "pace": "steady"}]
	var steady: Dictionary = EnergyForecast.rounds_left(35.0, drains, "steady", 3, 3)
	var push: Dictionary = EnergyForecast.rounds_left(35.0, drains, "push", 3, 3)
	print("  push sooner steady ", steady, " push ", push)
	_check(int(push["out_round"]) == int(steady["out_round"]) - 1,
		"push runs out a round sooner (push %s, steady %s)" % [str(push["out_round"]), str(steady["out_round"])])
	_near_one(push["by_round"][0], 14.75, "push is under 20 at the end of this round")


func _save_longer() -> void:
	var drains: Array = [{"drain": 5.0, "pace": "steady"}, {"drain": 5.0, "pace": "steady"}]
	var steady: Dictionary = EnergyForecast.rounds_left(35.0, drains, "steady", 3, 3)
	var save: Dictionary = EnergyForecast.rounds_left(35.0, drains, "save", 3, 3)
	print("  save longer ", save, " steady out ", steady["out_round"])
	_check(int(save["out_round"]) == 0 and int(steady["out_round"]) > 0,
		"save lasts the projected rounds (save %s, steady %s)" % [str(save["out_round"]), str(steady["out_round"])])
	_near_one(save["by_round"][0], 26.0, "save still has the tank at the end of this round")


func _zero_exchanges() -> void:
	var got: Dictionary = EnergyForecast.rounds_left(55.0, [], "steady", 0, 2)
	print("  zero exchanges ", got)
	_near_one(got["by_round"][0], 55.0, "no exchanges left: this round ends where it is")
	_near(got["by_round"], [55.0, 46.0, 37.0], "later rounds still take the rest and the drain")
	_check(int(got["out_round"]) == 0, "it has not run out")


func _already_under() -> void:
	var got: Dictionary = EnergyForecast.rounds_left(12.0, [], "steady", 3, 1)
	print("  already under ", got)
	_check(int(got["out_round"]) == 1, "energy already under 20 runs out this round (out %s)" % str(got["out_round"]))
	_near_one(got["by_round"][0], 3.0, "this round ends under 20")


func _near(got: Variant, want: Array, label: String) -> void:
	var row: Array = got
	var ok := row.size() == want.size()
	if ok:
		for i in want.size():
			if absf(float(row[i]) - float(want[i])) > 0.05:
				ok = false
	_check(ok, "%s (%s, want %s)" % [label, got, want])


func _near_one(got: Variant, want: float, label: String) -> void:
	_check(absf(float(got) - want) < 0.05, "%s (%s, want %s)" % [label, got, want])


func _check(cond: bool, label: String) -> void:
	print(("OK  " if cond else "FAIL ") + label)
	if not cond:
		failures += 1
