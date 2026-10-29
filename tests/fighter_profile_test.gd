extends SceneTree
## FighterProfile tests: pure rule module for footwork, style, personality, habits and morale.

const FighterProfile := preload("res://scripts/rules/FighterProfile.gd")
const FighterGoal := preload("res://scripts/rules/FighterGoal.gd")

var failures: int = 0


func _check(condition: bool, label: String) -> void:
	if condition:
		print("OK  " + label)
	else:
		failures += 1
		print("FAIL " + label)


func _near(actual: float, expected: float, label: String, eps: float = 0.05) -> void:
	_check(absf(actual - expected) <= eps, "%s actual=%s expected=%s" % [label, actual, expected])


func _out_boxer() -> Dictionary:
	return {
		"id": "test_out_boxer", "name": "Test Out-Boxer", "style": "Out-boxer",
		"stats": {"power": 55.0, "speed": 65.0, "technique": 60.0, "defense": 60.0, "conditioning": 60.0, "fight_iq": 60.0, "chin": 60.0},
	}


func _slugger() -> Dictionary:
	return {
		"id": "test_slugger", "name": "Test Slugger", "style": "Slugger",
		"stats": {"power": 75.0, "speed": 50.0, "technique": 45.0, "defense": 40.0, "conditioning": 55.0, "fight_iq": 50.0, "chin": 70.0},
	}


func _test_determinism_and_difference() -> void:
	var lucy := _out_boxer()
	var p1 := FighterProfile.make(lucy, 42)
	var p2 := FighterProfile.make(lucy, 42)
	_check(p1 == p2, "same fighter + same seed gives equal profiles")

	var slugger := _slugger()
	var p3 := FighterProfile.make(slugger, 42)
	_check(float(p1["footwork"]) != float(p3["footwork"]), "different fighters give different footwork")
	var d1: Dictionary = p1["style_dials"]
	var d3: Dictionary = p3["style_dials"]
	_check(float(d1["pressure"]) != float(d3["pressure"]), "different fighters give different pressure")


func _test_ranges_and_habits() -> void:
	var f := _out_boxer()
	var p := FighterProfile.make(f, 7)
	var dials: Dictionary = p["style_dials"]
	for key in ["pressure", "work_rate", "body_share", "counter"]:
		var v: float = float(dials[key])
		_check(v >= 0.0 and v <= 100.0, "dial %s in 0..100 (got %s)" % [key, v])
	var personality: Dictionary = p["personality"]
	var traits: Array = FighterProfile.TRAITS
	for t in traits:
		var v: float = float(personality[t])
		_check(v >= 0.0 and v <= 100.0, "trait %s in 0..100 (got %s)" % [t, v])
	var habits: Array = p["habits"]
	_check(habits.size() == 2, "two habits")
	_check(str(habits[0]) != str(habits[1]), "habits are distinct")
	for h in habits:
		_check(FighterProfile.HABITS.has(str(h)), "habit '%s' is in HABITS" % str(h))
	_near(float(p["morale"]), float(FighterProfile.MORALE_START), "morale starts at MORALE_START")


func _test_style_pressure_ordering() -> void:
	for seed in range(1, 21):
		var out := _out_boxer()
		var pressure_f := {"id": "pf", "name": "PF", "style": "Pressure fighter",
			"stats": {"power": 60.0, "speed": 60.0, "technique": 60.0, "defense": 60.0, "conditioning": 60.0, "fight_iq": 60.0, "chin": 60.0}}
		var p_out := FighterProfile.make(out, seed)
		var p_pf := FighterProfile.make(pressure_f, seed)
		var out_pressure: float = float((p_out["style_dials"] as Dictionary)["pressure"])
		var pf_pressure: float = float((p_pf["style_dials"] as Dictionary)["pressure"])
		_check(out_pressure < pf_pressure, "seed %d: Out-boxer pressure (%.1f) < Pressure fighter pressure (%.1f)" % [seed, out_pressure, pf_pressure])


func _test_ensure_preserves_existing() -> void:
	var f := {"id": "veteran", "name": "Veteran", "style": "Out-boxer",
		"stats": {"power": 60.0, "speed": 60.0, "technique": 60.0, "defense": 60.0, "conditioning": 60.0, "fight_iq": 60.0, "chin": 60.0},
		"morale": 33.0, "footwork": 70.0}
	FighterProfile.ensure(f)
	_near(float(f["morale"]), 33.0, "ensure keeps existing morale")
	_near(float(f["footwork"]), 70.0, "ensure keeps existing footwork")
	_check(f.has("style_dials"), "ensure adds style_dials")
	_check(f.has("personality"), "ensure adds personality")
	_check(f.has("habits"), "ensure adds habits")

	var before := f.duplicate(true)
	FighterProfile.ensure(f)
	_check(f == before, "ensure twice changes nothing")


func _test_mood_bands() -> void:
	_check(FighterProfile.mood(80.0) == "Fired up", "mood 80 -> Fired up")
	_check(FighterProfile.mood(60.0) == "Steady", "mood 60 -> Steady")
	_check(FighterProfile.mood(40.0) == "Flat", "mood 40 -> Flat")
	_check(FighterProfile.mood(10.0) == "Low", "mood 10 -> Low")
	_check(FighterProfile.mood(75.0) == "Fired up", "mood 75 -> Fired up")
	_check(FighterProfile.mood(50.0) == "Steady", "mood 50 -> Steady")


func _test_heart_scales_loss() -> void:
	var f_high_heart := _out_boxer()
	f_high_heart["personality"] = {"heart": 90.0, "temper": 50.0, "confidence": 50.0, "discipline": 50.0, "coachability": 50.0, "loyalty": 50.0}
	f_high_heart["morale"] = 60.0

	var f_low_heart := _out_boxer()
	f_low_heart["id"] = "low_heart"
	f_low_heart["personality"] = {"heart": 10.0, "temper": 50.0, "confidence": 50.0, "discipline": 50.0, "coachability": 50.0, "loyalty": 50.0}
	f_low_heart["morale"] = 60.0

	var r_high := FighterProfile.apply_morale(f_high_heart, "loss", "lost fight")
	var r_low := FighterProfile.apply_morale(f_low_heart, "loss", "lost fight")
	var delta_high: float = absf(float(r_high["delta"]))
	var delta_low: float = absf(float(r_low["delta"]))
	_check(delta_high < delta_low, "heart-90 loses LESS morale (%.2f) than heart-10 (%.2f)" % [delta_high, delta_low])


func _test_confidence_scales_goal_missed() -> void:
	var f_high_conf := _out_boxer()
	f_high_conf["personality"] = {"heart": 50.0, "temper": 50.0, "confidence": 90.0, "discipline": 50.0, "coachability": 50.0, "loyalty": 50.0}
	f_high_conf["morale"] = 60.0

	var f_low_conf := _out_boxer()
	f_low_conf["id"] = "low_conf"
	f_low_conf["personality"] = {"heart": 50.0, "temper": 50.0, "confidence": 10.0, "discipline": 50.0, "coachability": 50.0, "loyalty": 50.0}
	f_low_conf["morale"] = 60.0

	var r_high := FighterProfile.apply_morale(f_high_conf, "goal_missed", "missed goal")
	var r_low := FighterProfile.apply_morale(f_low_conf, "goal_missed", "missed goal")
	var delta_high: float = absf(float(r_high["delta"]))
	var delta_low: float = absf(float(r_low["delta"]))
	_check(delta_high > delta_low, "confidence-90 loses MORE from goal_missed (%.2f) than confidence-10 (%.2f)" % [delta_high, delta_low])


func _test_morale_events_match_fighter_goal() -> void:
	_check(int(FighterProfile.MORALE_EVENTS["goal_met"]) == FighterGoal.SUCCESS_MORALE_DELTA,
		"goal_met equals FighterGoal.SUCCESS_MORALE_DELTA")
	_check(int(FighterProfile.MORALE_EVENTS["goal_missed"]) == FighterGoal.FAILURE_MORALE_DELTA,
		"goal_missed equals FighterGoal.FAILURE_MORALE_DELTA")


func _test_clamp() -> void:
	var f_low := _out_boxer()
	f_low["morale"] = 5.0
	f_low["personality"] = {"heart": 50.0, "temper": 50.0, "confidence": 50.0, "discipline": 50.0, "coachability": 50.0, "loyalty": 50.0}
	var r_low := FighterProfile.apply_morale(f_low, "loss", "lost")
	_check(float(r_low["morale"]) >= 0.0, "morale 5 + loss stays >= 0 (got %s)" % r_low["morale"])

	var f_high := _out_boxer()
	f_high["id"] = "high_morale"
	f_high["morale"] = 98.0
	f_high["personality"] = {"heart": 50.0, "temper": 50.0, "confidence": 50.0, "discipline": 50.0, "coachability": 50.0, "loyalty": 50.0}
	var r_high := FighterProfile.apply_morale(f_high, "goal_met", "met goal")
	_check(float(r_high["morale"]) <= 100.0, "morale 98 + goal_met stays <= 100 (got %s)" % r_high["morale"])


func _test_unknown_kind() -> void:
	var f := _out_boxer()
	f["morale"] = 55.0
	f["personality"] = {"heart": 50.0, "temper": 50.0, "confidence": 50.0, "discipline": 50.0, "coachability": 50.0, "loyalty": 50.0}
	var r := FighterProfile.apply_morale(f, "unknown_event", "something")
	_near(float(r["delta"]), 0.0, "unknown kind returns delta 0")
	_near(float(r["morale"]), 55.0, "unknown kind leaves morale unchanged")


func _initialize() -> void:
	_test_determinism_and_difference()
	_test_ranges_and_habits()
	_test_style_pressure_ordering()
	_test_ensure_preserves_existing()
	_test_mood_bands()
	_test_heart_scales_loss()
	_test_confidence_scales_goal_missed()
	_test_morale_events_match_fighter_goal()
	_test_clamp()
	_test_unknown_kind()
	print("FIGHTER_PROFILE failures=%d" % failures)
	quit(1 if failures > 0 else 0)
