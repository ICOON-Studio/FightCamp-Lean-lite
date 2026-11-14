extends SceneTree
## FightWeekEvents: the Monday pull-out roll, late replacement asks, favours with a host.

const FightWeekEvents := preload("res://scripts/rules/FightWeekEvents.gd")

var checks := 0
var failures := 0


func _initialize() -> void:
	_test_roll_day()
	_test_pulls_out()
	_test_answers()
	_test_kept_on_pull_out()
	_test_asks()
	_test_fill_gap()
	_test_spend()
	_test_one_stop()
	_test_seeded_rolls()
	print("FIGHT_WEEK_EVENTS checks=%d failures=%d" % [checks, failures])
	quit(1 if failures > 0 else 0)


func _check(condition: bool, label: String) -> void:
	checks += 1
	if not condition:
		failures += 1
		print("  FAIL: %s" % label)


func _test_roll_day() -> void:
	_check(FightWeekEvents.roll_day(10) == 5, "roll_day(10) == 5 (bout day minus 5)")
	_check(FightWeekEvents.roll_day(5) == 0, "roll_day(5) == 0 (Monday of week 1)")
	_check(FightWeekEvents.roll_day(40) == 35, "roll_day(40) == 35")


func _test_pulls_out() -> void:
	_check(FightWeekEvents.pulls_out(0.34), "pulls_out at 0.34 is true (below 0.35)")
	_check(not FightWeekEvents.pulls_out(0.35), "pulls_out at 0.35 is false (on the line)")
	_check(not FightWeekEvents.pulls_out(0.9), "pulls_out at 0.9 is false")
	_check(FightWeekEvents.pulls_out(0.0), "pulls_out at 0.0 is true")


func _test_answers() -> void:
	var a := FightWeekEvents.answers(0, "Kalli")
	_check(a.size() == 3, "answers returns 3 entries")
	_check(a[0]["id"] == "take_replacement", "first answer is take_replacement")
	_check(a[1]["id"] == "go_home", "second answer is go_home")
	_check(a[2]["id"] == "next_month", "third answer is next_month")

	# take_replacement keys and values
	var tr: Dictionary = a[0]
	_check(tr["ok"] == true, "take_replacement ok is true")
	_check(tr["mood"] == 0, "take_replacement mood is 0")
	_check(tr["favours"] == 0, "take_replacement favours is 0")
	_check(tr["rep_x"] == 2, "take_replacement rep_x is 2")

	# go_home
	var gh: Dictionary = a[1]
	_check(gh["ok"] == true, "go_home ok is true")
	_check(gh["mood"] == -6, "go_home mood is -6")
	_check(gh["favours"] == 0, "go_home favours is 0")
	_check(gh["rep_x"] == 1, "go_home rep_x is 1")

	# next_month with 0 favours: greyed out
	var nm: Dictionary = a[2]
	_check(nm["ok"] == false, "next_month ok is false at 0 favours")
	_check(nm["why"] == "no favour with Kalli", "next_month why names the host at 0 favours")
	_check(nm["mood"] == 0, "next_month mood is 0")
	_check(nm["favours"] == 0, "next_month favours is 0 when greyed")
	_check(nm["rep_x"] == 1, "next_month rep_x is 1")

	# next_month with 1 favour: ok
	var b := FightWeekEvents.answers(1, "Host")
	var nm2: Dictionary = b[2]
	_check(nm2["ok"] == true, "next_month ok is true at 1 favour")
	_check(nm2["why"] == "", "next_month why is empty when ok")
	_check(nm2["favours"] == -1, "next_month favours is -1 when spent")


func _test_kept_on_pull_out() -> void:
	var k := FightWeekEvents.kept_on_pull_out(200, 50)
	_check(k["banked"] == 200, "kept_on_pull_out preserves banked")
	_check(k["refund"] == 0, "kept_on_pull_out refund is 0")
	var k2 := FightWeekEvents.kept_on_pull_out(0, 100)
	_check(k2["banked"] == 0, "kept_on_pull_out banked 0 stays 0")
	_check(k2["refund"] == 0, "kept_on_pull_out commute paid still refunds 0")


func _test_asks() -> void:
	# Blocked cases
	_check(not FightWeekEvents.asks(0.1, true, true, true), "asks blocked when already asked this show")
	_check(not FightWeekEvents.asks(0.1, false, true, false), "asks blocked when does not fit gap")
	_check(not FightWeekEvents.asks(0.1, true, false, false), "asks blocked when not ready")
	# Open cases
	_check(FightWeekEvents.asks(0.1, true, true, false), "asks ok at 0.1 (below 1/6)")
	_check(not FightWeekEvents.asks(0.2, true, true, false), "asks not ok at 0.2 (above 1/6)")
	_check(FightWeekEvents.asks(0.0, true, true, false), "asks ok at 0.0")
	_check(not FightWeekEvents.asks(0.17, true, true, false), "asks not ok at 0.17 (above 1/6)")


func _test_fill_gap() -> void:
	_check(FightWeekEvents.fill_gap(0) == 1, "fill_gap(0) == 1")
	_check(FightWeekEvents.fill_gap(2) == 3, "fill_gap(2) == 3")
	_check(FightWeekEvents.fill_gap(3) == 3, "fill_gap(3) == 3 (caps at max)")
	_check(FightWeekEvents.fill_gap(5) == 3, "fill_gap(5) == 3 (caps even above max)")


func _test_spend() -> void:
	var s1 := FightWeekEvents.spend(2, 1)
	_check(s1["ok"] == true, "spend(2, 1) ok")
	_check(s1["favours"] == 1, "spend(2, 1) favours == 1")
	var s2 := FightWeekEvents.spend(0, 1)
	_check(s2["ok"] == false, "spend(0, 1) not ok")
	_check(s2["favours"] == 0, "spend(0, 1) favours stays 0")
	var s3 := FightWeekEvents.spend(3, 3)
	_check(s3["ok"] == true, "spend(3, 3) ok (exact)")
	_check(s3["favours"] == 0, "spend(3, 3) favours == 0")


func _test_one_stop() -> void:
	_check(FightWeekEvents.one_stop(0), "one_stop(0) is true (no stops yet)")
	_check(not FightWeekEvents.one_stop(1), "one_stop(1) is false (already stopped)")
	_check(not FightWeekEvents.one_stop(2), "one_stop(2) is false (multiple stops)")


func _test_seeded_rolls() -> void:
	var rng := RandomNumberGenerator.new()
	rng.seed = 474
	var pull_count := 0
	var ask_count := 0
	for i in 1000:
		var r: float = rng.randf()
		if FightWeekEvents.pulls_out(r):
			pull_count += 1
		if FightWeekEvents.asks(r, true, true, false):
			ask_count += 1
	var pull_pct: float = pull_count / 1000.0
	var ask_pct: float = ask_count / 1000.0
	_check(pull_pct >= 0.30 and pull_pct <= 0.40,
		"seeded pulls_out between 30%% and 40%% (got %.1f%%)" % [pull_pct * 100.0])
	_check(ask_pct >= 0.12 and ask_pct <= 0.21,
		"seeded asks between 12%% and 21%% (got %.1f%%)" % [ask_pct * 100.0])
