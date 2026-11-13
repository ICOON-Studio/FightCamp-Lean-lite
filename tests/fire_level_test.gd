extends SceneTree
## FIRELEVEL1: the fire level rule - a planned line fires more reliably the better it is drilled.
## Pure test, no game state.

const FireLevel := preload("res://scripts/rules/FireLevel.gd")

var failures := 0


func _initialize() -> void:
	# 1. No key -> 1.0 at every tier (today's behavior)
	var no_key := {}
	_check(FireLevel.share(no_key, 30.0) == 1.0, "no key at 30 -> 1.0")
	_check(FireLevel.share(no_key, 60.0) == 1.0, "no key at 60 -> 1.0")
	_check(FireLevel.share(no_key, 85.0) == 1.0, "no key at 85 -> 1.0")
	# S427: an undrilled combination whose punches are learned is planned today; no key must not switch it off
	_check(FireLevel.share(no_key, 0.0) == 1.0, "no key at 0 (undrilled) -> 1.0")
	_check(FireLevel.fires(no_key, 0.0, 0.99), "no key, undrilled: still fires")
	# 2. Tier edges: 29 (under 30 = cannot be planned), 30 (usable), 59 (usable), 60 (sharp), 84 (sharp), 85 (signature)
	var shares := {"usable": 0.6, "sharp": 0.8, "signature": 1.0}
	_check(FireLevel.share(shares, 29.0) == 0.0, "29 -> 0.0 (cannot be planned)")
	_check(FireLevel.share(shares, 30.0) == 0.6, "30 -> 0.6 (usable)")
	_check(FireLevel.share(shares, 59.0) == 0.6, "59 -> 0.6 (usable)")
	_check(FireLevel.share(shares, 60.0) == 0.8, "60 -> 0.8 (sharp)")
	_check(FireLevel.share(shares, 84.0) == 0.8, "84 -> 0.8 (sharp)")
	_check(FireLevel.share(shares, 85.0) == 1.0, "85 -> 1.0 (signature)")
	# 3. fires() true below the share and false above
	_check(FireLevel.fires(shares, 30.0, 0.5), "fires: roll 0.5 < share 0.6 -> true")
	_check(not FireLevel.fires(shares, 30.0, 0.7), "fires: roll 0.7 >= share 0.6 -> false")
	_check(FireLevel.fires(shares, 60.0, 0.7), "fires: roll 0.7 < share 0.8 -> true")
	_check(not FireLevel.fires(shares, 60.0, 0.9), "fires: roll 0.9 >= share 0.8 -> false")
	_check(FireLevel.fires(shares, 85.0, 0.99), "fires: roll 0.99 < share 1.0 -> true")
	_check(FireLevel.fires(shares, 29.0, 0.0) == false, "fires: mastery 29, roll 0.0 -> false (share 0.0)")
	# 4. Partial key: only usable set
	var partial := {"usable": 0.5}
	_check(FireLevel.share(partial, 30.0) == 0.5, "partial: usable 0.5 at 30 -> 0.5")
	_check(FireLevel.share(partial, 60.0) == 1.0, "partial: sharp missing at 60 -> 1.0")
	_check(FireLevel.share(partial, 85.0) == 1.0, "partial: signature missing at 85 -> 1.0")
	# 5. FIRELEVEL3: a bout with no key fights on the game's shares; a probe's explicit key wins; steps stay full.
	_check(FireLevel.share(FireLevel.shares_for({}), 40.0) == 0.5, "no key on the bout: a Usable combination at 40 fires half the time")
	_check(FireLevel.share(FireLevel.shares_for({}), 70.0) == 0.75, "no key on the bout: Sharp at 70 -> 0.75")
	_check(FireLevel.share(FireLevel.shares_for({}), 90.0) == 1.0, "no key on the bout: Signature -> 1.0")
	_check(FireLevel.share(FireLevel.shares_for({"fire_level": FireLevel.OFF}), 40.0) == 1.0, "the rule-off arm's explicit key -> 1.0")
	_check(FireLevel.share(FireLevel.shares_for({"fire_level": {}}), 0.0) == 1.0, "an explicit empty key = today's game at every mastery")
	_check(FireLevel.mastery_of({}, "step_in") == 100.0 and FireLevel.share(FireLevel.GAME_SHARES, FireLevel.mastery_of({}, "step_in")) == 1.0, "a step keeps full fire under the game's shares")
	print("FIRE_LEVEL failures=%d" % failures)
	quit(1 if failures > 0 else 0)


func _check(cond: bool, label: String) -> void:
	if cond:
		print("PASS ", label)
	else:
		failures += 1
		print("FAIL ", label)
