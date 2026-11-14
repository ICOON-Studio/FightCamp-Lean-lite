extends SceneTree
## FightWeekPick: your assistant's fight-week pick (five facts, sureness, wrong = next stop).

const FightWeekPick := preload("res://scripts/rules/FightWeekPick.gd")

var checks := 0
var failures := 0


func _initialize() -> void:
	_test_constants()
	_test_sureness()
	_test_best_stop_five_sets()
	_test_rule_order()
	_test_spar()
	_test_weight_way()
	_test_stop_name()
	_test_pick_and_lines()
	_test_seeded_wrong_rate()
	print("FIGHT_WEEK_PICK checks=%d failures=%d" % [checks, failures])
	quit(1 if failures > 0 else 0)


func _check(condition: bool, label: String) -> void:
	checks += 1
	if not condition:
		failures += 1
		print("  FAIL: %s" % label)


func _fact_tired() -> Dictionary:
	return {
		"start_tired": 72,
		"tank_weight": 0,
		"opp_round1": "even",
		"rating_gap": 0.0,
		"unsparred": 1,
		"near_usable": false,
		"has_week_before": false,
	}


func _fact_heavy_cut() -> Dictionary:
	return {
		"start_tired": 38,
		"tank_weight": 4,
		"opp_round1": "slow",
		"rating_gap": 1.0,
		"unsparred": 0,
		"near_usable": false,
		"has_week_before": false,
	}


func _fact_near_usable() -> Dictionary:
	return {
		"start_tired": 30,
		"tank_weight": 0,
		"opp_round1": "even",
		"rating_gap": 0.0,
		"unsparred": 2,
		"near_usable": true,
		"has_week_before": true,
	}


func _fact_rating_edge() -> Dictionary:
	return {
		"start_tired": 45,
		"tank_weight": 0,
		"opp_round1": "slow",
		"rating_gap": 6.5,
		"unsparred": 1,
		"near_usable": false,
		"has_week_before": false,
	}


func _fact_fast_starter() -> Dictionary:
	return {
		"start_tired": 40,
		"tank_weight": 0,
		"opp_round1": "fast",
		"rating_gap": -1.5,
		"unsparred": 1,
		"near_usable": false,
		"has_week_before": false,
	}


func _test_constants() -> void:
	_check(FightWeekPick.STOPS == ["rest_up", "tick_over", "train_through"], "STOPS order is rest_up, tick_over, train_through")
	_check(FightWeekPick.TIRED_REST == 65, "TIRED_REST is 65")
	_check(absf(FightWeekPick.GAP_TRAIN - (-5.0)) < 0.0001, "GAP_TRAIN is -5.0")
	_check(FightWeekPick.FACT_WORDS.size() == 6, "FACT_WORDS has 6 entries")


func _test_sureness() -> void:
	_check(absf(FightWeekPick.sureness(58) - 0.79) < 0.0001, "Luke Reid rating 58 -> sureness 0.79")
	_check(absf(FightWeekPick.sureness(74) - 0.87) < 0.0001, "Marcus Hale rating 74 -> sureness 0.87")
	_check(absf(FightWeekPick.sureness(0) - 0.5) < 0.0001, "rating 0 -> sureness 0.5")
	_check(absf(FightWeekPick.sureness(-20) - 0.5) < 0.0001, "negative rating clamps to 0.5")
	_check(absf(FightWeekPick.sureness(98) - 0.99) < 0.0001, "rating 98 -> sureness 0.99")
	_check(absf(FightWeekPick.sureness(100) - 0.99) < 0.0001, "rating 100 clamps to 0.99")


func _test_best_stop_five_sets() -> void:
	var b1: Dictionary = FightWeekPick.best_stop(_fact_tired())
	_check(b1.get("stop", "") == "rest_up", "tired boxer -> rest_up")
	_check(b1.get("fact", "") == "tired", "tired boxer -> fact 'tired'")

	var b2: Dictionary = FightWeekPick.best_stop(_fact_heavy_cut())
	_check(b2.get("stop", "") == "rest_up", "heavy cut -> rest_up")
	_check(b2.get("fact", "") == "weight", "heavy cut -> fact 'weight'")

	var b3: Dictionary = FightWeekPick.best_stop(_fact_near_usable())
	_check(b3.get("stop", "") == "train_through", "move near Usable -> train_through")
	_check(b3.get("fact", "") == "near_usable", "move near Usable -> fact 'near_usable'")

	var b4: Dictionary = FightWeekPick.best_stop(_fact_rating_edge())
	_check(b4.get("stop", "") == "train_through", "big rating edge -> train_through")
	_check(b4.get("fact", "") == "rating_gap", "big rating edge -> fact 'rating_gap'")

	var b5: Dictionary = FightWeekPick.best_stop(_fact_fast_starter())
	_check(b5.get("stop", "") == "tick_over", "plain week vs fast starter -> tick_over")
	_check(b5.get("fact", "") == "opp_round1", "plain week vs fast starter -> fact 'opp_round1'")

	var plain: Dictionary = _fact_fast_starter()
	plain["opp_round1"] = "even"
	var b6: Dictionary = FightWeekPick.best_stop(plain)
	_check(b6.get("stop", "") == "tick_over" and b6.get("fact", "") == "default", "plain week vs even starter -> tick_over / default")


func _test_rule_order() -> void:
	var tired_and_usable: Dictionary = _fact_near_usable()
	tired_and_usable["start_tired"] = 65
	var r1: Dictionary = FightWeekPick.best_stop(tired_and_usable)
	_check(r1.get("stop", "") == "rest_up" and r1.get("fact", "") == "tired", "tired (65) AND near_usable -> rest_up / tired")

	var tired_and_weight: Dictionary = _fact_heavy_cut()
	tired_and_weight["start_tired"] = 65
	var r2: Dictionary = FightWeekPick.best_stop(tired_and_weight)
	_check(r2.get("stop", "") == "rest_up" and r2.get("fact", "") == "tired", "tired (65) AND tank_weight 4 -> tired wins over weight")

	var weight_and_usable: Dictionary = _fact_near_usable()
	weight_and_usable["tank_weight"] = 4
	var r3: Dictionary = FightWeekPick.best_stop(weight_and_usable)
	_check(r3.get("stop", "") == "rest_up" and r3.get("fact", "") == "weight", "tank_weight 4 AND near_usable -> rest_up / weight")

	var usable_and_gap: Dictionary = _fact_rating_edge()
	usable_and_gap["near_usable"] = true
	var r4: Dictionary = FightWeekPick.best_stop(usable_and_gap)
	_check(r4.get("stop", "") == "train_through" and r4.get("fact", "") == "near_usable", "near_usable AND rating_gap >= 5 -> near_usable first")

	var edge_boundary: Dictionary = _fact_rating_edge()
	edge_boundary["rating_gap"] = 5.0
	var r5: Dictionary = FightWeekPick.best_stop(edge_boundary)
	_check(r5.get("stop", "") == "train_through" and r5.get("fact", "") == "rating_gap", "rating_gap 5.0 boundary -> train_through")


func _test_spar() -> void:
	var wb: Dictionary = _fact_near_usable()
	_check(FightWeekPick.spar(wb, 12) == 8, "spar: has_week_before -> 8 even when choices_now is 12")

	var fw: Dictionary = _fact_fast_starter()
	_check(FightWeekPick.spar(fw, 6) == 7, "spar: no week before, unsparred 1, choices 6 (6+3<12) -> 7")
	_check(FightWeekPick.spar(fw, 9) == 0, "spar: choices 9 (9+3 == 12, not < 12) -> 0")
	_check(FightWeekPick.spar(fw, 12) == 0, "spar: choices 12 (train_through) -> 0")

	var none_unsparred: Dictionary = _fact_heavy_cut()
	_check(FightWeekPick.spar(none_unsparred, 0) == 0, "spar: unsparred 0 -> 0")


func _test_weight_way() -> void:
	_check(FightWeekPick.weight_way(_fact_tired()) == "", "weight_way: tank_weight 0 -> empty")
	_check(FightWeekPick.weight_way(_fact_heavy_cut()) == "train_off", "weight_way: tank_weight 4 and start_tired 38 (<42) -> train_off")

	var cut_41: Dictionary = _fact_heavy_cut()
	cut_41["start_tired"] = 41
	_check(FightWeekPick.weight_way(cut_41) == "train_off", "weight_way: start_tired 41 -> train_off")

	var cut_42: Dictionary = _fact_heavy_cut()
	cut_42["start_tired"] = 42
	_check(FightWeekPick.weight_way(cut_42) == "eat_less", "weight_way: start_tired 42 -> eat_less")


func _test_stop_name() -> void:
	_check(FightWeekPick.stop_name("rest_up") == "Rest up", "stop_name rest_up -> Rest up")
	_check(FightWeekPick.stop_name("tick_over") == "Tick over", "stop_name tick_over -> Tick over")
	_check(FightWeekPick.stop_name("train_through") == "Train through", "stop_name train_through -> Train through")


func _test_pick_and_lines() -> void:
	# Right pick at roll 0.0 on fast starter -> tick_over
	var p_right: Dictionary = FightWeekPick.pick(_fact_fast_starter(), 58, 0.0)
	_check(p_right.get("stop", "") == "tick_over", "pick at roll 0.0 -> right stop tick_over")
	_check(p_right.get("fact", "") == "opp_round1", "pick at roll 0.0 -> fact opp_round1")
	_check(p_right.get("wrong", true) == false, "pick at roll 0.0 -> wrong is false")
	_check(p_right.get("spar", -1) == 7, "pick tick_over (6 tank) with unsparred 1 -> spar 7")
	_check(p_right.get("weight", "x") == "", "pick with tank_weight 0 -> weight empty")
	_check(p_right.get("line", "") == "Tick over: the opponent starts fast.", "pick line for tick_over + opp_round1")

	# Wrong pick at roll 0.99 on tired boxer: rest_up -> tick_over, keeps fact "tired"
	var p_wrong_tired: Dictionary = FightWeekPick.pick(_fact_tired(), 58, 0.99)
	_check(p_wrong_tired.get("stop", "") == "tick_over", "wrong pick on rest_up -> next stop tick_over")
	_check(p_wrong_tired.get("fact", "") == "tired", "wrong pick keeps same fact 'tired'")
	_check(p_wrong_tired.get("wrong", false) == true, "wrong pick at roll 0.99 -> wrong is true")

	# Wrong pick at roll 0.99 on fast starter: tick_over -> train_through (tank 12 -> spar becomes 0)
	var p_wrong_tick: Dictionary = FightWeekPick.pick(_fact_fast_starter(), 58, 0.99)
	_check(p_wrong_tick.get("stop", "") == "train_through", "wrong pick on tick_over -> next stop train_through")
	_check(p_wrong_tick.get("fact", "") == "opp_round1", "wrong pick on tick_over keeps fact 'opp_round1'")
	_check(p_wrong_tick.get("spar", -1) == 0, "wrong pick to train_through (12 tank) drops 7-day spar to 0")

	# Wrap from train_through -> rest_up at roll 0.99
	var p_wrap: Dictionary = FightWeekPick.pick(_fact_rating_edge(), 74, 0.99)
	_check(p_wrap.get("stop", "") == "rest_up", "wrong pick on train_through wraps to rest_up")
	_check(p_wrap.get("fact", "") == "rating_gap", "wrapped wrong pick keeps fact 'rating_gap'")
	_check(p_wrap.get("wrong", false) == true, "wrapped wrong pick marks wrong true")
	_check(p_wrap.get("spar", -1) == 7, "wrapped rest_up has choices_now 0 so unsparred 1 gets spar 7")

	# Check all five fact sets produce lines with no "best" and no capitalised name
	var sets: Array = [_fact_tired(), _fact_heavy_cut(), _fact_near_usable(), _fact_rating_edge(), _fact_fast_starter()]
	var forbidden_names: Array = ["Luke", "Reid", "Marcus", "Hale"]
	for i in sets.size():
		var fset: Dictionary = sets[i]
		var p: Dictionary = FightWeekPick.pick(fset, 58, 0.0)
		var line: String = str(p.get("line", ""))
		_check(line.to_lower().find("best") == -1, "set %d line contains no 'best': %s" % [i, line])
		var has_name := false
		for nm in forbidden_names:
			if line.find(str(nm)) != -1:
				has_name = true
		var body: String = line.substr(line.find(":") + 1)
		for word in body.split(" ", false):
			var clean: String = word.trim_suffix(".")
			if clean.length() > 0 and clean != "Usable" and clean[0] >= "A" and clean[0] <= "Z":
				has_name = true
		_check(not has_name, "set %d line contains no capitalised name: %s" % [i, line])


func _test_seeded_wrong_rate() -> void:
	var rng := RandomNumberGenerator.new()
	rng.seed = 474
	var sets: Array = [_fact_tired(), _fact_heavy_cut(), _fact_near_usable(), _fact_rating_edge(), _fact_fast_starter()]
	var wrong_count := 0
	var total := 2000
	for i in total:
		var fset: Dictionary = sets[i % sets.size()]
		var res: Dictionary = FightWeekPick.pick(fset, 58, rng.randf())
		if bool(res.get("wrong", false)):
			wrong_count += 1
	var rate: float = float(wrong_count) / float(total)
	_check(rate >= 0.17 and rate <= 0.25, "seeded 2000 picks at rating 58 wrong rate %.3f in [0.17, 0.25]" % rate)
