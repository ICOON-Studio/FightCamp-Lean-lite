extends SceneTree
## READBACK3: two rules, each read from a bout key and OFF when the key is absent.
## - set_up (bool): a waited line used AFTER another planned line won an exchange earlier in the SAME ROUND
##   is NOT waited for on that use (keeps full edge, not a wrong answer): thrown behind something.
##   The set-up is per-round (cleared at the bell), and only a DIFFERENT line's win counts.
## - wait_cost (float, e.g. 1.25): while her corner waits for a line, Lucy's OTHER planned lines earn
##   their edge times this in that round: the corner looking for one thing sees the others late.
## Pure test, no scene. Prints READ_BACK failures=<n>.

const ReadBack := preload("res://scripts/rules/ReadBack.gd")

var failures := 0


func _initialize() -> void:
	# No keys -> exactly today's factor for plain, covered (0.5), and waited (-0.5) lines
	var bout_plain := {}
	var pick_planned := {"planned": true, "move": "1-1"}
	var pick_unplanned := {"planned": false, "move": "instinct"}
	var rb := ReadBack.factor(bout_plain, "1-1", pick_planned, "")
	_check(float(rb["cov"]) == 1.0, "no keys: plain line cov=1.0")
	_check(float(rb["mult"]) == 1.0, "no keys: plain line mult=1.0")
	_check(not bool(rb["wrong"]), "no keys: plain line not wrong")

	var bout_covered := {"covered": {"1-1": 0.5}}
	rb = ReadBack.factor(bout_covered, "1-1", pick_planned, "")
	_check(is_equal_approx(float(rb["cov"]), 0.5), "covered 0.5: cov=0.5")
	_check(float(rb["mult"]) == 1.0, "covered 0.5: mult=1.0 (no wait_cost)")
	_check(not bool(rb["wrong"]), "covered 0.5: not wrong")

	var bout_waited := {"covered": {"1-1": -0.5}}
	rb = ReadBack.factor(bout_waited, "1-1", pick_planned, "")
	_check(is_equal_approx(float(rb["cov"]), -0.5), "waited -0.5: cov=-0.5")
	_check(float(rb["mult"]) == 1.0, "waited -0.5: mult=1.0 (waited line doesn't get wait_cost)")
	_check(bool(rb["wrong"]), "waited -0.5: wrong")

	# Unplanned picks never changed
	rb = ReadBack.factor(bout_waited, "instinct", pick_unplanned, "")
	_check(float(rb["cov"]) == 1.0, "unplanned: cov=1.0")
	_check(float(rb["mult"]) == 1.0, "unplanned: mult=1.0")
	_check(not bool(rb["wrong"]), "unplanned: not wrong")

	# set_up on -> waited before another line won, full after
	var bout_setup := {"covered": {"1-1": -0.5}, "set_up": true}
	rb = ReadBack.factor(bout_setup, "1-1", pick_planned, "")
	_check(is_equal_approx(float(rb["cov"]), -0.5), "set_up on, no win yet: cov=-0.5 (still waited)")
	_check(bool(rb["wrong"]), "set_up on, no win yet: wrong")

	# READBACK3: only a DIFFERENT line's win sets up the waited line
	rb = ReadBack.factor(bout_setup, "1-1", pick_planned, "step_back")
	_check(float(rb["cov"]) == 1.0, "set_up on, DIFFERENT line won: cov=1.0 (not waited)")
	_check(not bool(rb["wrong"]), "set_up on, DIFFERENT line won: not wrong")

	# READBACK3: the waited line's OWN win does NOT set it up
	rb = ReadBack.factor(bout_setup, "1-1", pick_planned, "1-1")
	_check(is_equal_approx(float(rb["cov"]), -0.5), "set_up on, OWN win: cov=-0.5 (still waited)")
	_check(bool(rb["wrong"]), "set_up on, OWN win: wrong")

	# READBACK3: a win in round 1 does not set up round 2 (plan_won_arrow is cleared at the bell)
	# Simulated by passing "" (the state at the start of a new round)
	rb = ReadBack.factor(bout_setup, "1-1", pick_planned, "")
	_check(is_equal_approx(float(rb["cov"]), -0.5), "set_up on, new round (arrow cleared): cov=-0.5 (still waited)")
	_check(bool(rb["wrong"]), "set_up on, new round (arrow cleared): wrong")

	# wait_cost on -> other planned lines x1.25, the waited line unchanged
	var bout_wait_cost := {"covered": {"1-1": -0.5}, "wait_cost": 1.25}
	rb = ReadBack.factor(bout_wait_cost, "step_back", pick_planned, "")
	_check(float(rb["cov"]) == 1.0, "wait_cost: other line cov=1.0")
	_check(is_equal_approx(float(rb["mult"]), 1.25), "wait_cost: other line mult=1.25")
	_check(not bool(rb["wrong"]), "wait_cost: other line not wrong")

	rb = ReadBack.factor(bout_wait_cost, "1-1", pick_planned, "")
	_check(is_equal_approx(float(rb["cov"]), -0.5), "wait_cost: waited line cov=-0.5")
	_check(float(rb["mult"]) == 1.0, "wait_cost: waited line mult=1.0 (doesn't get boost)")
	_check(bool(rb["wrong"]), "wait_cost: waited line wrong")

	print("READ_BACK failures=%d" % failures)
	quit(1 if failures > 0 else 0)


func _check(ok: bool, what: String) -> void:
	if not ok:
		failures += 1
		print("FAIL ", what)
