extends SceneTree
## GOAL1 (S238) + S292 retarget: the goal contract, copied from E:\FightCamp\Game\Godot\tests\fighter_goal_test.gd and trimmed
## to the archetypes the lean game keeps (pick_for, make-the-weight and the gatekeeper rows went with their code).

const FighterGoal := preload("res://scripts/rules/FighterGoal.gd")

var failures: int = 0


func _initialize() -> void:
	_test_archetypes()
	_test_goal_for()
	_test_progress_states_and_rates()
	_test_outcome_and_card()
	_test_immutability_and_determinism()
	print("FIGHTER_GOAL failures=%d" % failures)
	quit(1 if failures > 0 else 0)


func _check(condition: bool, label: String) -> void:
	if not condition:
		failures += 1
		print("FAIL FIGHTER_GOAL: " + label)


func _near(actual: float, expected: float, label: String, eps: float = 0.0001) -> void:
	_check(absf(actual - expected) <= eps, "%s actual=%s expected=%s" % [label, actual, expected])


func _leo_amateur() -> Dictionary:
	return {
		"id": "leo_vance", "name": "Leo Vance", "weight_class": "welterweight", "weight_kg": 66.4,
		"booked_fight": false,
		"stats": {"power": 52.0, "technique": 58.0, "speed": 62.0, "defense": 56.0, "conditioning": 54.0, "fight_iq": 55.0},
	}


func _call_checked(method_name: String, args: Array) -> Dictionary:
	var before: Array = args.duplicate(true)
	var result: Dictionary = Callable(FighterGoal, method_name).callv(args)
	var saved: Dictionary = result.duplicate(true)
	_check(args == before, method_name + " preserves arguments")
	var repeated: Dictionary = Callable(FighterGoal, method_name).callv(args)
	_check(repeated == saved, method_name + " deterministic")
	return saved


func _test_archetypes() -> void:
	var expected_days := {"debut_inside_a_month": 28, "southpaw_answer": 21, "five_round_engine": 28}
	_check(FighterGoal.ARCHETYPES.size() == 3, "ARCHETYPES has the three lean goals")
	for row in FighterGoal.ARCHETYPES:
		var goal_id := str(row.get("id", ""))
		_check(expected_days.has(goal_id), "known archetype id " + goal_id)
		_check(int(row.get("days", 0)) == int(expected_days.get(goal_id, -1)), goal_id + " days match spec")
		_check(not str(row.get("title", "")).strip_edges().is_empty(), goal_id + " has title")
		_check(not str(row.get("persona_line", "")).strip_edges().is_empty(), goal_id + " has persona_line")
		for k in (row.get("targets", {}) as Dictionary).keys():
			_check(k == "booked_fight" or FighterGoal.STAT_KEYS.has(str(k)), goal_id + " target uses a stat key: " + str(k))


func _test_goal_for() -> void:
	var leo := _leo_amateur()
	var debut := _call_checked("goal_for", [leo, "debut_inside_a_month", 1])
	_check(int(debut.get("deadline_day", 0)) - int(debut.get("start_day", 0)) == 28, "debut deadline is 28 days")
	_check(bool((debut["targets"] as Dictionary).get("booked_fight", false)), "debut target includes booked_fight")
	_near(float(debut["targets"]["conditioning"]), 54.0 + 3.5, "debut conditioning target is start + 3.5")
	var southpaw := _call_checked("goal_for", [leo, "southpaw_answer", 1])
	_near(float(southpaw["targets"]["technique"]), 58.0 + 2.5, "southpaw technique target is start + 2.5 (S292)")
	var engine := _call_checked("goal_for", [leo, "five_round_engine", 1])
	_near(float(engine["targets"]["conditioning"]), 54.0 + 2.5, "engine conditioning target is start + 2.5")
	_check(int(engine["deadline_day"]) == 29, "engine deadline is 28 days on")
	_check(FighterGoal.goal_for(leo, "no_such_goal", 1).is_empty(), "unknown archetype -> {}")


func _test_progress_states_and_rates() -> void:
	var leo := _leo_amateur()
	var goal := _call_checked("goal_for", [leo, "debut_inside_a_month", 1])
	## These rows test the projection maths, so the target is pinned at 65 (as in the original test).
	(goal["targets"] as Dictionary)["conditioning"] = 65.0
	var fighter_day11: Dictionary = leo.duplicate(true)
	fighter_day11["booked_fight"] = true
	fighter_day11["stats"]["conditioning"] = 58.0

	var prog_on_track := _call_checked("progress", [goal, fighter_day11, 11, {"conditioning": 0.6}])
	_check(int(prog_on_track.get("days_left", -1)) == 18, "days_left counts down to 18")
	_check(str(prog_on_track.get("status", "")) == "ON_TRACK", "ON_TRACK when projected hits 100% at least 2 days before deadline")
	_check(float(prog_on_track.get("projected_share", 0.0)) >= 1.0, "ON_TRACK projected_share >= 1.0")
	var rows: Array = prog_on_track.get("per_target", [])
	_check(rows.size() == 2, "per_target has one entry per goal target")
	for row in rows:
		if str(row.get("key", "")) == "conditioning":
			_near(float(row.get("projected", -1.0)), 58.0 + 0.6 * 18.0, "per_target projected = current + rate * days_left")

	var prog_at_risk := _call_checked("progress", [goal, fighter_day11, 11, {"conditioning": 0.0}])
	_check(str(prog_at_risk.get("status", "")) == "AT_RISK", "AT_RISK when projected misses target by 10-20% (58/65)")
	var prog_late := _call_checked("progress", [goal, fighter_day11, 11, {"conditioning": 0.4}])
	_check(str(prog_late.get("status", "")) == "AT_RISK", "hitting target inside the final 2 days is AT_RISK, not ON_TRACK")

	var fighter_off: Dictionary = fighter_day11.duplicate(true)
	fighter_off["stats"]["conditioning"] = 45.0
	var prog_off := _call_checked("progress", [goal, fighter_off, 11, {"conditioning": 0.2}])
	_check(str(prog_off.get("status", "")) == "OFF_TRACK", "OFF_TRACK when projected misses by more than 20%")

	var fighter_met: Dictionary = fighter_day11.duplicate(true)
	fighter_met["stats"]["conditioning"] = 66.0
	var prog_met := _call_checked("progress", [goal, fighter_met, 20, {"conditioning": 0.0}])
	_check(str(prog_met.get("status", "")) == "MET", "MET when every target is reached")
	_near(float(prog_met.get("share_done", 0.0)), 1.0, "MET has share_done = 1.0")
	var fighter_unbooked: Dictionary = fighter_met.duplicate(true)
	fighter_unbooked["booked_fight"] = false
	var prog_unbooked := _call_checked("progress", [goal, fighter_unbooked, 20, {"conditioning": 0.0}])
	_check(str(prog_unbooked.get("status", "")) != "MET", "debut goal is not MET while booked_fight is false")

	var prog_missed := _call_checked("progress", [goal, fighter_day11, 30, {"conditioning": 0.5}])
	_check(int(prog_missed.get("days_left", 0)) == -1, "days_left is negative past deadline_day")
	_check(str(prog_missed.get("status", "")) == "MISSED", "MISSED when days_left < 0 and not met")


func _test_outcome_and_card() -> void:
	var leo := _leo_amateur()
	var goal := _call_checked("goal_for", [leo, "debut_inside_a_month", 1])
	(goal["targets"] as Dictionary)["conditioning"] = 65.0
	var win_out := _call_checked("outcome", [goal, true])
	_check(int(win_out.get("trust_delta", 0)) == 25, "success outcome gives trust +25")
	_check(int(win_out.get("morale_delta", 0)) > 0, "success outcome raises morale")
	var fail_out := _call_checked("outcome", [goal, false])
	_check(int(fail_out.get("trust_delta", 0)) < 0 and int(fail_out.get("morale_delta", 0)) < 0, "failure drops trust and morale")
	_check(str(fail_out.get("line", "")).to_lower().contains("walk"), "failure outcome warns of walk-out risk")

	var fighter_day11: Dictionary = leo.duplicate(true)
	fighter_day11["booked_fight"] = true
	fighter_day11["stats"]["conditioning"] = 58.0
	var card_on := _call_checked("card", [goal, _call_checked("progress", [goal, fighter_day11, 11, {"conditioning": 0.6}])])
	_check(str(card_on.get("title", "")) == str(goal.get("title", "")), "card shows goal title")
	_check(str(card_on.get("days_left", "")) == "DAYS LEFT 18", "card formats DAYS LEFT 18")
	_check(str(card_on.get("colour", "")) == "cool", "ON_TRACK card colour is cool")
	_check((card_on.get("targets", []) as Array).has("Conditioning 58 / 65"), "card includes 'Conditioning 58 / 65'")
	var card_amber := _call_checked("card", [goal, _call_checked("progress", [goal, fighter_day11, 11, {"conditioning": 0.0}])])
	_check(str(card_amber.get("colour", "")) == "amber", "AT_RISK card colour is amber")
	var fighter_met: Dictionary = fighter_day11.duplicate(true)
	fighter_met["stats"]["conditioning"] = 66.0
	var card_gold := _call_checked("card", [goal, _call_checked("progress", [goal, fighter_met, 15, {"conditioning": 0.0}])])
	_check(str(card_gold.get("colour", "")) == "gold", "MET card colour is gold")


func _test_immutability_and_determinism() -> void:
	var leo := _leo_amateur()
	for i in range(12):
		var goal := _call_checked("goal_for", [leo, ["southpaw_answer", "five_round_engine"][i % 2], i])
		var rate := {"technique": 0.1 * float(i % 4), "conditioning": 0.12}
		var p1 := _call_checked("progress", [goal, leo, i + (i % 30), rate])
		var share := float(p1.get("share_done", -1.0))
		_check(is_finite(share) and share >= 0.0 and share <= 1.0, "share_done in 0..1")
		var c1 := _call_checked("card", [goal, p1])
		_check(str(c1.get("colour", "")) in ["cool", "amber", "red", "gold"], "valid card colour key")
