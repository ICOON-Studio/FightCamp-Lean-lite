extends SceneTree
## FILMTRUTH1 - film nights: how sure a seen tell is, look again or next group,
## cleared as false, debutant lock. Same shape as amateur_booking_test.gd.

const FilmTruth := preload("res://scripts/rules/FilmTruth.gd")

var checks := 0
var failures := 0


func _initialize() -> void:
	_test_locked()
	_test_open_group()
	_test_next_group()
	_test_look_again()
	_test_second_night_options()
	_test_truth()
	_test_check_minute()
	_test_apply()
	_test_best_second_night()
	_test_seeded_run()
	print("FILM_TRUTH checks=%d failures=%d" % [checks, failures])
	quit(1 if failures > 0 else 0)


func _check(condition: bool, label: String) -> void:
	checks += 1
	if not condition:
		failures += 1
		print("  FAIL: %s" % label)


## SIX tells across three groups (one a fade).
func _fixture() -> Array:
	return [
		{"id": "t1", "group": 0, "mode": "pressing", "state": "hidden", "sure": 0.0, "fade": false},
		{"id": "t2", "group": 0, "mode": "pressing", "state": "hidden", "sure": 0.0, "fade": false},
		{"id": "t3", "group": 1, "mode": "ranging", "state": "hidden", "sure": 0.0, "fade": false},
		{"id": "t4", "group": 1, "mode": "ranging", "state": "hidden", "sure": 0.0, "fade": false},
		{"id": "t5", "group": 2, "mode": "tiring", "state": "hidden", "sure": 0.0, "fade": true},
		{"id": "t6", "group": 2, "mode": "tiring", "state": "hidden", "sure": 0.0, "fade": false},
	]


func _test_locked() -> void:
	_check(FilmTruth.locked(0) == "no tape on a debutant", "locked at 0 bouts: debutant")
	_check(FilmTruth.locked(3) == "", "locked at 3 bouts: open")
	_check(FilmTruth.locked(1) == "", "locked at 1 bout: open")


func _test_open_group() -> void:
	var tells := _fixture()
	var n := FilmTruth.open_group(tells, 0)
	_check(n == 2, "open_group 0 opens 2 tells")
	_check(tells[0]["state"] == "seen", "t1 is seen after open")
	_check(tells[1]["state"] == "seen", "t2 is seen after open")
	_check(tells[0]["sure"] == 0.70, "t1 sure is 0.70 after open")
	_check(tells[2]["state"] == "hidden", "t3 still hidden (group 1)")
	var n2 := FilmTruth.open_group(tells, 0)
	_check(n2 == 0, "open_group 0 again opens 0 (already seen)")


func _test_next_group() -> void:
	var tells := _fixture()
	_check(FilmTruth.next_group(tells) == 0, "next_group: lowest hidden is 0")
	FilmTruth.open_group(tells, 0)
	_check(FilmTruth.next_group(tells) == 1, "next_group after opening 0: lowest hidden is 1")
	FilmTruth.open_group(tells, 1)
	FilmTruth.open_group(tells, 2)
	_check(FilmTruth.next_group(tells) == -1, "next_group after all open: -1")


func _test_look_again() -> void:
	var tells := _fixture()
	FilmTruth.open_group(tells, 0)
	var n := FilmTruth.look_again(tells, 0)
	_check(n == 2, "look_again on group 0: 2 tells go to 0.90")
	_check(tells[0]["sure"] == 0.90, "t1 sure is 0.90 after look_again")
	_check(tells[1]["sure"] == 0.90, "t2 sure is 0.90 after look_again")
	# look_again on a group with no seen tells
	var n2 := FilmTruth.look_again(tells, 1)
	_check(n2 == 0, "look_again on group 1 (all hidden): 0")


func _test_second_night_options() -> void:
	var tells := _fixture()
	FilmTruth.open_group(tells, 0)
	var opts := FilmTruth.second_night_options(tells)
	_check(opts.size() == 2, "two options")
	var la: Dictionary = opts[0]
	var ng: Dictionary = opts[1]
	_check(la["id"] == "look_again", "first option is look_again")
	_check(la["ok"] == true, "look_again ok: group 0 has 2 seen")
	_check(la["group"] == 0, "look_again group is 0")
	_check(ng["id"] == "next_group", "second option is next_group")
	_check(ng["ok"] == true, "next_group ok: groups 1 and 2 still hidden")
	_check(ng["group"] == 1, "next_group group is 1 (lowest hidden)")

	# All seen, nothing to look at again (all at 0.90 now)
	FilmTruth.look_again(tells, 0)
	var opts2 := FilmTruth.second_night_options(tells)
	var la2: Dictionary = opts2[0]
	_check(la2["ok"] == false, "look_again not ok when no seen at 0.70")
	_check(la2["why"] == "nothing seen to look at again", "look_again why when none")

	# All open
	FilmTruth.open_group(tells, 1)
	FilmTruth.open_group(tells, 2)
	var opts3 := FilmTruth.second_night_options(tells)
	var ng3: Dictionary = opts3[1]
	_check(ng3["ok"] == false, "next_group not ok when every group is open")
	_check(ng3["why"] == "every group is open", "next_group why when all open")


func _test_truth() -> void:
	var tell := {"id": "t1", "group": 0, "mode": "pressing", "state": "seen", "sure": 0.70, "fade": false}
	_check(FilmTruth.truth(tell, 0.69) == true, "truth at roll 0.69 with sure 0.70: true")
	_check(FilmTruth.truth(tell, 0.71) == false, "truth at roll 0.71 with sure 0.70: false")
	tell["sure"] = 0.90
	_check(FilmTruth.truth(tell, 0.89) == true, "truth at roll 0.89 with sure 0.90: true")
	_check(FilmTruth.truth(tell, 0.91) == false, "truth at roll 0.91 with sure 0.90: false")


func _test_check_minute() -> void:
	var normal := {"id": "t1", "group": 0, "mode": "pressing", "state": "seen", "sure": 0.70, "fade": false}
	var fade := {"id": "t5", "group": 2, "mode": "tiring", "state": "seen", "sure": 0.70, "fade": true}

	# Normal tell, round 1, mode came up, true
	_check(FilmTruth.check_minute(normal, true, true, 1) == "confirmed", "normal tell round 1 mode up true: confirmed")
	# Normal tell, round 1, mode came up, not true
	_check(FilmTruth.check_minute(normal, false, true, 1) == "false", "normal tell round 1 mode up false: false")
	# Normal tell, round 1, mode not came up
	_check(FilmTruth.check_minute(normal, true, false, 1) == "", "normal tell round 1 mode not up: stays seen")
	# Fade, round 1: not yet
	_check(FilmTruth.check_minute(fade, true, true, 1) == "", "fade round 1: not yet")
	# Fade, round 2, mode came up, true
	_check(FilmTruth.check_minute(fade, true, true, 2) == "confirmed", "fade round 2 mode up true: confirmed")
	# Fade, round 2, mode came up, not true
	_check(FilmTruth.check_minute(fade, false, true, 2) == "false", "fade round 2 mode up false: false")
	# Fade, round 2, mode not came up
	_check(FilmTruth.check_minute(fade, true, false, 2) == "", "fade round 2 mode not up: stays seen")
	# Round 3: always ""
	_check(FilmTruth.check_minute(normal, true, true, 3) == "", "round 3: always empty")
	_check(FilmTruth.check_minute(fade, true, true, 3) == "", "fade round 3: always empty")


func _test_apply() -> void:
	var tell := {"id": "t1", "group": 0, "mode": "pressing", "state": "seen", "sure": 0.70, "fade": false}
	FilmTruth.apply(tell, "confirmed")
	_check(tell["state"] == "confirmed", "apply confirmed: state is confirmed")
	_check(tell["sure"] == 1.0, "apply confirmed: sure is 1.0")

	var tell2 := {"id": "t2", "group": 0, "mode": "pressing", "state": "seen", "sure": 0.70, "fade": false}
	FilmTruth.apply(tell2, "false")
	_check(tell2["state"] == "false", "apply false: state is false")
	_check(tell2["sure"] == 0.0, "apply false: sure is 0.0")

	var tell3 := {"id": "t3", "group": 1, "mode": "ranging", "state": "seen", "sure": 0.70, "fade": false}
	FilmTruth.apply(tell3, "")
	_check(tell3["state"] == "seen", "apply empty: state unchanged")
	_check(tell3["sure"] == 0.70, "apply empty: sure unchanged")


func _test_best_second_night() -> void:
	# Case 1: a seen tell has 2+ lines relying on it -> look_again
	var tells1 := _fixture()
	FilmTruth.open_group(tells1, 0)
	var lines1 := {"t1": 3, "t2": 1}
	_check(FilmTruth.best_second_night(tells1, lines1) == "look_again", "best: 2+ lines on t1 -> look_again")

	# Case 2: no tell has 2+ lines, but a group is still hidden -> next_group
	var tells2 := _fixture()
	FilmTruth.open_group(tells2, 0)
	var lines2 := {"t1": 1, "t2": 1}
	_check(FilmTruth.best_second_night(tells2, lines2) == "next_group", "best: no 2+ lines, hidden group -> next_group")

	# Case 3: all open, no 2+ lines -> look_again (fallback)
	var tells3 := _fixture()
	FilmTruth.open_group(tells3, 0)
	FilmTruth.open_group(tells3, 1)
	FilmTruth.open_group(tells3, 2)
	var lines3 := {"t1": 1}
	_check(FilmTruth.best_second_night(tells3, lines3) == "look_again", "best: all open, no 2+ lines -> look_again")


func _test_seeded_run() -> void:
	# 2000 seen tells at 0.70, seeded RNG: true count should be 66-74%
	var rng := RandomNumberGenerator.new()
	rng.seed = 474
	var n_true := 0
	var total := 2000
	for i in total:
		var tell := {"id": "s%d" % i, "group": 0, "mode": "x", "state": "seen", "sure": 0.70, "fade": false}
		var roll: float = rng.randf()
		if FilmTruth.truth(tell, roll):
			n_true += 1
	var pct: float = float(n_true) / float(total) * 100.0
	_check(pct >= 66.0 and pct <= 74.0, "seeded run: %d/%d = %.1f%% true (expect 66-74%%)" % [n_true, total, pct])
