extends SceneTree
## R17PHASE1 PlanPhase test: rounds on lines, early/middle/late phases, the last round split IF AHEAD / IF BEHIND.
## Pure module; no screen, no wiring.

const PP := preload("res://scripts/rules/PlanPhase.gd")
const SM := preload("res://scripts/rules/StrikeMap.gd")
const Exchanges := preload("res://scripts/rules/Exchanges.gd")
const PaceAim := preload("res://scripts/rules/PaceAim.gd")

var failures := 0


func _initialize() -> void:
	_test_split_cases()
	_test_split_coverage()
	_test_old_plan_lives_everywhere()
	_test_the_hand()
	_test_late_state()
	_test_late_state_of()
	_test_live_and_pace()
	_test_body_pays()
	_test_validate_refuses()
	_test_mutants()
	# S442 collect: a late-state line's label names its state; problems are in plain words.
	_check(PP.words({"move": "1-2", "rounds": "late"}, 3, "behind") == "R3, if behind", "words: R3, if behind")
	for prob in PP.validate([], {"ahead": {"pace": "fast", "arrows": [{"move": "1-2"}, {"move": "1-1"}, {"move": "nope"}]}}, 3, 4):
		_check(str(prob).find("late.") < 0 and str(prob).find("PaceAim") < 0 and str(prob).find("StrikeMap") < 0, "validate: plain words (%s)" % prob)
	print("PLAN_PHASE failures=%d" % failures)
	quit(0 if failures == 0 else 1)


func _check(cond: bool, label: String) -> void:
	if cond:
		print("  ok   " + label)
	else:
		failures += 1
		print("  FAIL " + label)


## split(3), split(4), split(6) equal the map's three cases.
func _test_split_cases() -> void:
	var s3 := PP.split(3)
	_check(s3["early"] == [1] and s3["middle"] == [2] and s3["late"] == [3], "split(3): R1 / R2 / R3")
	var s4 := PP.split(4)
	_check(s4["early"] == [1] and s4["middle"] == [2, 3] and s4["late"] == [4], "split(4): R1 / R2-3 / R4")
	var s6 := PP.split(6)
	_check(s6["early"] == [1, 2] and s6["middle"] == [3, 4] and s6["late"] == [5, 6], "split(6): R1-2 / R3-4 / R5-6")


## Every round 1..n sits in exactly one phase for n in 2..12; split(2) has an empty middle.
func _test_split_coverage() -> void:
	for n in range(2, 13):
		var s := PP.split(n)
		var all: Array = []
		all.append_array(s["early"])
		all.append_array(s["middle"])
		all.append_array(s["late"])
		all.sort()
		var expected: Array = []
		for i in range(1, n + 1):
			expected.append(i)
		_check(all == expected, "split(%d): every round in exactly one phase" % n)
	var s2 := PP.split(2)
	_check(s2["middle"].is_empty(), "split(2): empty middle")
	_check(s2["early"] == [1] and s2["late"] == [2], "split(2): R1 / R2")


## An old plan (no `rounds` keys, no `late`) lives whole in every round: live() returns every arrow for every round and state.
func _test_old_plan_lives_everywhere() -> void:
	var arrows := [{"move": "1-2"}, {"move": "step_back"}, {"move": "3b-3"}]
	var late := {}
	for r in range(1, 4):
		for state in ["ahead", "behind"]:
			var living := PP.live(arrows, late, r, 3, state)
			_check(living.size() == 3, "old plan round %d, %s: all 3 arrows live" % [r, state])


## THE HAND: six lines (two "early", two "late", two "all") with brought 4 validate clean;
## the same six all "all" are refused; three arrows in late.ahead are refused.
func _test_the_hand() -> void:
	var arrows := [
		{"move": "1-1", "rounds": "early"},
		{"move": "1-2", "rounds": "early"},
		{"move": "2-3", "rounds": "late"},
		{"move": "3b-3", "rounds": "late"},
		{"move": "step_in", "rounds": "all"},
		{"move": "step_back", "rounds": "all"},
	]
	var late := {"ahead": {"pace": "push", "arrows": []}, "behind": {"pace": "steady", "arrows": []}}
	var problems := PP.validate(arrows, late, 3, 4)
	_check(problems.is_empty(), "THE HAND: 6 lines (2 early, 2 late, 2 all) with brought 4 validate clean")
	# Same six all "all" are refused
	var all_arrows := [
		{"move": "1-1", "rounds": "all"},
		{"move": "1-2", "rounds": "all"},
		{"move": "2-3", "rounds": "all"},
		{"move": "3b-3", "rounds": "all"},
		{"move": "step_in", "rounds": "all"},
		{"move": "step_back", "rounds": "all"},
	]
	var problems2 := PP.validate(all_arrows, {}, 3, 4)
	_check(not problems2.is_empty(), "THE HAND: 6 all 'all' are refused")
	var found_round := false
	for p in problems2:
		if str(p).contains("Round"):
			found_round = true
			break
	_check(found_round, "THE HAND: problem names the round")
	# Three arrows in late.ahead are refused
	var late3 := {"ahead": {"pace": "push", "arrows": [{"move": "1-2"}, {"move": "2-3"}, {"move": "3b-3"}]}}
	var problems3 := PP.validate([], late3, 3, 4)
	_check(not problems3.is_empty(), "THE HAND: 3 arrows in late.ahead refused")


## late_state(1, 1) is "behind", (2, 1) "ahead", (0, 2) "behind".
func _test_late_state() -> void:
	_check(PP.late_state(1, 1) == "behind", "late_state(1, 1) == behind (level counts as behind)")
	_check(PP.late_state(2, 1) == "ahead", "late_state(2, 1) == ahead")
	_check(PP.late_state(0, 2) == "behind", "late_state(0, 2) == behind")


## late_state_of on hand-built rounds agrees with Exchanges.round_of's "won" for each round.
func _test_late_state_of() -> void:
	# Build 3 rounds: round 1 won, round 2 lost, round 3 won -> 2 won, 1 lost -> ahead
	var round1_exs := [{"won": true, "margin": 10.0, "landed": [5, 3]}]
	var round2_exs := [{"won": false, "margin": -10.0, "landed": [3, 5]}]
	var round3_exs := [{"won": true, "margin": 15.0, "landed": [6, 2]}]
	var rounds_exs := [round1_exs, round2_exs, round3_exs]
	# Verify Exchanges.round_of gives the expected won/lost
	var r1 := Exchanges.round_of(round1_exs)
	var r2 := Exchanges.round_of(round2_exs)
	var r3 := Exchanges.round_of(round3_exs)
	_check(bool(r1["won"]) and not bool(r2["won"]) and bool(r3["won"]), "round_of agrees: R1 won, R2 lost, R3 won")
	# late_state_of should be "ahead" (2 won, 1 lost)
	_check(PP.late_state_of(rounds_exs) == "ahead", "late_state_of: 2 won 1 lost == ahead")
	# All lost
	var all_lost := [round2_exs, round2_exs]
	_check(PP.late_state_of(all_lost) == "behind", "late_state_of: all lost == behind")


## live() in the last round adds late.ahead's arrows when ahead and late.behind's when behind, never both;
## pace() returns the state's pace in the last round and "" in round 1.
func _test_live_and_pace() -> void:
	var arrows := [{"move": "1-2", "rounds": "early"}]
	var late := {
		"ahead": {"pace": "push", "arrows": [{"move": "step_in"}]},
		"behind": {"pace": "save", "arrows": [{"move": "step_back"}]}
	}
	# Round 3 of 3 is late
	var live_ahead := PP.live(arrows, late, 3, 3, "ahead")
	var live_behind := PP.live(arrows, late, 3, 3, "behind")
	# early arrow does not live in late round
	_check(live_ahead.size() == 1 and str(live_ahead[0]["move"]) == "step_in", "live ahead in R3: only late.ahead arrow")
	_check(live_behind.size() == 1 and str(live_behind[0]["move"]) == "step_back", "live behind in R3: only late.behind arrow")
	# Never both
	var all_moves := []
	for a in live_ahead:
		all_moves.append(str(a["move"]))
	for a in live_behind:
		all_moves.append(str(a["move"]))
	_check(all_moves.count("step_in") == 1 and all_moves.count("step_back") == 1, "live: never both states' arrows")
	# pace() in last round
	_check(PP.pace(late, 3, 3, "ahead") == "push", "pace in R3 ahead == push")
	_check(PP.pace(late, 3, 3, "behind") == "save", "pace in R3 behind == save")
	_check(PP.pace(late, 1, 3, "ahead") == "", "pace in R1 == '' (not late)")


## body_pays: an early "3b-3" line on 3 rounds reads 3; an "all" body line reads 0; an early "1-2" reads 0.
func _test_body_pays() -> void:
	var early_body := {"move": "3b-3", "rounds": "early"}
	_check(PP.body_pays(early_body, 3) == 3, "body_pays: early 3b-3 on 3 rounds == 3 (pays in R3)")
	var all_body := {"move": "3b-3", "rounds": "all"}
	_check(PP.body_pays(all_body, 3) == 0, "body_pays: all 3b-3 == 0 (not early)")
	var early_non_body := {"move": "1-2", "rounds": "early"}
	_check(PP.body_pays(early_non_body, 3) == 0, "body_pays: early 1-2 == 0 (no body punch)")
	# Verify 1-2 combo from StrikeMap has no body
	var combo_12 := str(SM.move("1-2").get("combo", ""))
	_check(not combo_12.contains("b"), "1-2 combo has no body punch")


## validate refuses a pace "fast" and a rounds word "late_ahead".
func _test_validate_refuses() -> void:
	var late_bad_pace := {"ahead": {"pace": "fast", "arrows": []}}
	var problems1 := PP.validate([], late_bad_pace, 3, 4)
	_check(not problems1.is_empty(), "validate refuses pace 'fast'")
	var found_pace := false
	for p in problems1:
		if str(p).contains("fast"):
			found_pace = true
			break
	_check(found_pace, "validate problem mentions 'fast'")
	var bad_arrow := {"move": "1-2", "rounds": "late_ahead"}
	var problems2 := PP.validate([bad_arrow], {}, 3, 4)
	_check(not problems2.is_empty(), "validate refuses rounds word 'late_ahead'")
	var found_word := false
	for p in problems2:
		if str(p).contains("late_ahead"):
			found_word = true
			break
	_check(found_word, "validate problem mentions 'late_ahead'")


## MUTANTS: a copy of split that gives middle the remainder of a ceil, and a copy of late_state where level
## counts as ahead, must each FAIL the same asserts; print "MUTANT caught" for each.
func _test_mutants() -> void:
	# MUTANT split: middle gets ceil instead of floor remainder
	var mutant_split_caught := false
	var s3_mut := _mutant_split(3)
	# With ceil: edge = ceil(3/3) = 1, same as floor for 3
	# But for 4: edge = ceil(4/3) = 2, so early=[1,2], late=[3,4], middle=[]
	# This differs from the real split(4) which has early=[1], middle=[2,3], late=[4]
	if s3_mut["early"] != PP.split(3)["early"] or s3_mut["middle"] != PP.split(3)["middle"] or s3_mut["late"] != PP.split(3)["late"]:
		mutant_split_caught = true
	# Actually test with 4 rounds where ceil differs
	var s4_mut := _mutant_split(4)
	var s4_real := PP.split(4)
	if s4_mut["early"] != s4_real["early"] or s4_mut["middle"] != s4_real["middle"] or s4_mut["late"] != s4_real["late"]:
		mutant_split_caught = true
	if mutant_split_caught:
		print("  MUTANT caught: mutant_split gives different result than real split")
	_check(mutant_split_caught, "MUTANT split fails the same asserts")

	# MUTANT late_state: level counts as ahead
	var mutant_state_caught := false
	if _mutant_late_state(1, 1) != PP.late_state(1, 1):
		mutant_state_caught = true
	if mutant_state_caught:
		print("  MUTANT caught: mutant_late_state(1,1) differs from real late_state")
	_check(mutant_state_caught, "MUTANT late_state fails the same asserts")


## MUTANT split: uses ceil for edge calculation (middle gets the remainder of a ceil, not floor).
func _mutant_split(rounds: int) -> Dictionary:
	var r := clampi(rounds, PP.MIN_ROUNDS, PP.MAX_ROUNDS)
	# MUTANT: use ceil instead of floor
	var edge := maxi(1, ceili(float(r) / 3.0))
	var early: Array = []
	var middle: Array = []
	var late: Array = []
	for i in range(1, r + 1):
		if i <= edge:
			early.append(i)
		elif i > r - edge:
			late.append(i)
		else:
			middle.append(i)
	return {"early": early, "middle": middle, "late": late}


## MUTANT late_state: level counts as ahead (opposite of real).
func _mutant_late_state(won: int, lost: int) -> String:
	return "ahead" if won >= lost else "behind"
