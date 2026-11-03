extends SceneTree
## S373 the women's 2025 classes (John J_MEN1: 61.2 kg is in no rulebook, 66 kg was dropped on 1 Jan 2025): 57, 60, 65,
## 75 kg; Lucy and Samira still walk 1.4 kg over their class. A save from before moves each fighter's limit to her
## division's and her weight by the same step, once. Population: a quick start with Lucy signed (as save_load_test); the
## same career written the old way (Lucy 61.2 / 62.6, Samira's prospect at 67.4).

const Data := preload("res://scripts/state/Data.gd")
const Sim := preload("res://scripts/state/Sim.gd")
const SaveGame := preload("res://scripts/state/SaveGame.gd")

var failures := 0


func _initialize() -> void:
	_classes()
	_old_save()
	print("WOMEN_CLASSES failures=%d" % failures)
	quit(1 if failures > 0 else 0)


func _check(cond: bool, label: String) -> void:
	if cond:
		print("PASS ", label)
	else:
		failures += 1
		print("FAIL ", label)


func _classes() -> void:
	var lim: Array = ["wfw", "wlw", "www", "wmw"].map(func(d): return float(Data.DIVISIONS[d]["limit"]))
	_check(lim == [57.0, 60.0, 65.0, 75.0], "the women's classes are 57 / 60 / 65 / 75 kg (%s)" % str(lim))
	var lucy := Data.fighter_state(Data.lucy(), 0)
	_check(is_equal_approx(float(lucy["limit"]), 60.0) and is_equal_approx(float(lucy["weight"]) - float(lucy["limit"]), 1.4),
		"Lucy boxes at 60 kg and walks 1.4 kg over (%.1f)" % float(lucy["weight"]))
	var sam: Dictionary = Data.PROSPECTS.filter(func(p): return str(p["id"]) == "samira")[0]
	_check(is_equal_approx(float(sam["weight"]) - 65.0, 1.4), "Samira walks 1.4 kg over 65 (%.1f)" % float(sam["weight"]))


func _old_save() -> void:
	var c := Career.quick_start("Old Save Gym", "London")
	Sim.sign(c, ["Jab and move", "Pad rounds", "Hill sprints"])
	var d := SaveGame.to_dict(c)
	var props: Dictionary = d["props"]
	props["fighters"][0]["limit"] = 61.2
	props["fighters"][0]["weight"] = 62.6
	for p in props["prospects"]:
		if str(p["id"]) == "samira":
			p["weight"] = 67.4
	var l := SaveGame.from_dict(d)
	var f: Dictionary = l.fighters[0]
	_check(is_equal_approx(float(f["limit"]), 60.0) and is_equal_approx(float(f["weight"]), 61.4),
		"an old save: Lucy 61.2 / 62.6 becomes 60.0 / 61.4, the same cut (%.1f / %.1f)" % [float(f["limit"]), float(f["weight"])])
	var sam: Dictionary = l.prospects.filter(func(p): return str(p["id"]) == "samira")[0]
	_check(is_equal_approx(float(sam["weight"]), 66.4), "an old save: Samira's 67.4 becomes 66.4 (%.1f)" % float(sam["weight"]))
	var again := SaveGame.from_dict(SaveGame.to_dict(l))
	_check(is_equal_approx(float(again.fighters[0]["weight"]), 61.4) and is_equal_approx(float(again.fighters[0]["limit"]), 60.0),
		"a second load moves nothing")
