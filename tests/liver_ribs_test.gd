extends SceneTree
## LiverRibs: tests for every function at its edges.
## LIVERRIBS2 - pure module + unit tests.

const LR := preload("res://scripts/rules/LiverRibs.gd")

var failures := 0


func _initialize() -> void:
	_test_side_of()
	_test_band()
	_test_drain()
	_test_liver_fold_chance()
	_test_ribs_penalty()
	_test_crack_chance()
	_test_corner_retires()
	_test_injury_split()
	_test_heal_days()
	_test_side_tally()
	_test_traffic_mean()
	_test_control_wrong_drain()
	print("LIVER_RIBS failures=%d" % failures)
	quit(1 if failures > 0 else 0)


func _check(cond: bool, label: String) -> void:
	if cond:
		print("PASS ", label)
	else:
		failures += 1
		print("FAIL ", label)


func _near(a: float, b: float, eps: float = 1e-6) -> bool:
	return absf(a - b) < eps


## side_of: left hand -> "liver", right hand -> "ribs", whatever the stance.
func _test_side_of() -> void:
	var ok := true
	# Orthodox both hands.
	if LR.side_of("orthodox", "left") != "liver":
		ok = false
	if LR.side_of("orthodox", "right") != "ribs":
		ok = false
	# Southpaw both hands.
	if LR.side_of("southpaw", "left") != "liver":
		ok = false
	if LR.side_of("southpaw", "right") != "ribs":
		ok = false
	# Unknown stance still works (hand is what matters).
	if LR.side_of("switch", "left") != "liver":
		ok = false
	if LR.side_of("switch", "right") != "ribs":
		ok = false
	_check(ok, "side_of: left->liver right->ribs for orthodox AND southpaw")


## band: 55.0 is hurt, 55.1 ok, 35.0 critical.
func _test_band() -> void:
	var ok := true
	if LR.band(55.1) != "ok":
		ok = false
	if LR.band(55.0) != "hurt":
		ok = false
	if LR.band(50.0) != "hurt":
		ok = false
	if LR.band(35.0) != "critical":
		ok = false
	if LR.band(34.9) != "critical":
		ok = false
	if LR.band(0.0) != "critical":
		ok = false
	if LR.band(100.0) != "ok":
		ok = false
	_check(ok, "band: 55.0 hurt, 55.1 ok, 35.0 critical")


## drain: LIVER_DRAIN for liver, RIB_DRAIN for ribs.
func _test_drain() -> void:
	var ok := true
	if not _near(LR.drain("liver"), LR.LIVER_DRAIN):
		ok = false
	if not _near(LR.drain("ribs"), LR.RIB_DRAIN):
		ok = false
	_check(ok, "drain: liver=1.3 ribs=0.55")


## liver_fold_chance: 0 at ok, 0 at FOLDS_MAX, clamped to FOLD_MIN for weak puncher,
## FOLD_MAX x2 <= FOLD_CAP for strong puncher at critical.
func _test_liver_fold_chance() -> void:
	var ok := true
	# 0 when band ok (liver_value > 55).
	var p_ok: float = LR.liver_fold_chance(50.0, 50.0, 60.0, 50.0, 60.0, 0)
	if not _near(p_ok, 0.0):
		ok = false
	# 0 when folds_so_far >= FOLDS_MAX.
	var p_max: float = LR.liver_fold_chance(50.0, 50.0, 60.0, 50.0, 50.0, LR.FOLDS_MAX)
	if not _near(p_max, 0.0):
		ok = false
	# Weak puncher at hurt: clamped to FOLD_MIN.
	# attack_power = (10+10)/2 * (0.5 + 20/200) = 10 * 0.6 = 6
	# exp((6 - 80) / 12) = exp(-6.167) ~ 0.0021
	# BASE_FOLD * 0.0021 = 0.000063 -> clamped to FOLD_MIN 0.01
	var p_weak: float = LR.liver_fold_chance(10.0, 10.0, 20.0, 80.0, 50.0, 0)
	if not _near(p_weak, LR.FOLD_MIN):
		ok = false
	# Strong puncher at critical: FOLD_MAX * FOLD_CRIT_MULT = 0.08 * 2.0 = 0.16 <= FOLD_CAP.
	# attack_power = (90+90)/2 * (0.5 + 100/200) = 90 * 1.0 = 90
	# exp((90 - 30) / 12) = exp(5) ~ 148.4 -> BASE_FOLD * 148.4 = 4.45 -> clamped to FOLD_MAX 0.08
	# x FOLD_CRIT_MULT = 0.16 -> min(0.16, FOLD_CAP 0.16) = 0.16
	var p_strong: float = LR.liver_fold_chance(90.0, 90.0, 100.0, 30.0, 30.0, 0)
	var expected_strong: float = minf(LR.FOLD_MAX * LR.FOLD_CRIT_MULT, LR.FOLD_CAP)
	if not _near(p_strong, expected_strong):
		ok = false
	# Verify FOLD_MAX * 2 <= FOLD_CAP (the design invariant).
	if LR.FOLD_MAX * LR.FOLD_CRIT_MULT > LR.FOLD_CAP + 1e-9:
		ok = false
	_check(ok, "liver_fold_chance: 0 at ok, 0 at FOLDS_MAX, FOLD_MIN for weak, FOLD_CAP for strong at critical")


## ribs_penalty: cracked -> CRACK_*, hurt/critical -> RIB_*_HURT, ok -> {0, 1.0}.
func _test_ribs_penalty() -> void:
	var ok := true
	# Ok ribs, not cracked.
	var p_ok: Dictionary = LR.ribs_penalty(70.0, false)
	if not _near(float(p_ok["guard"]), 0.0):
		ok = false
	if not _near(float(p_ok["output"]), 1.0):
		ok = false
	# Hurt ribs, not cracked.
	var p_hurt: Dictionary = LR.ribs_penalty(50.0, false)
	if not _near(float(p_hurt["guard"]), LR.RIB_GUARD_HURT):
		ok = false
	if not _near(float(p_hurt["output"]), LR.RIB_OUTPUT_HURT):
		ok = false
	# Critical ribs, not cracked.
	var p_crit: Dictionary = LR.ribs_penalty(30.0, false)
	if not _near(float(p_crit["guard"]), LR.RIB_GUARD_HURT):
		ok = false
	if not _near(float(p_crit["output"]), LR.RIB_OUTPUT_HURT):
		ok = false
	# Cracked (whatever value).
	var p_crack: Dictionary = LR.ribs_penalty(50.0, true)
	if not _near(float(p_crack["guard"]), LR.CRACK_GUARD):
		ok = false
	if not _near(float(p_crack["output"]), LR.CRACK_OUTPUT):
		ok = false
	_check(ok, "ribs_penalty: ok {0,1.0}, hurt/crit RIB_*, cracked CRACK_*")


## crack_chance: CRACK_CHANCE at critical, else 0; 0 when already cracked.
func _test_crack_chance() -> void:
	var ok := true
	# Critical, not yet cracked.
	if not _near(LR.crack_chance(30.0, false), LR.CRACK_CHANCE):
		ok = false
	# Hurt, not cracked.
	if not _near(LR.crack_chance(50.0, false), 0.0):
		ok = false
	# Ok, not cracked.
	if not _near(LR.crack_chance(70.0, false), 0.0):
		ok = false
	# Already cracked (whatever value).
	if not _near(LR.crack_chance(30.0, true), 0.0):
		ok = false
	_check(ok, "crack_chance: CRACK_CHANCE at critical, 0 otherwise, 0 when already cracked")


## corner_retires: 0 / RETIRE_BASE / RETIRE_BEHIND.
func _test_corner_retires() -> void:
	var ok := true
	# Not cracked.
	if not _near(LR.corner_retires(false, false), 0.0):
		ok = false
	if not _near(LR.corner_retires(false, true), 0.0):
		ok = false
	# Cracked, not behind.
	if not _near(LR.corner_retires(true, false), LR.RETIRE_BASE):
		ok = false
	# Cracked and behind.
	if not _near(LR.corner_retires(true, true), LR.RETIRE_BEHIND):
		ok = false
	_check(ok, "corner_retires: 0 / RETIRE_BASE / RETIRE_BEHIND")


## injury_split: liver never injured; cracked -> cracked; critical + roll < BELL_CRACK -> cracked;
## ribs_value < BRUISE_LINE -> bruised; else none.
func _test_injury_split() -> void:
	var ok := true
	# Cracked in the bout -> cracked (whatever roll).
	var r1: Dictionary = LR.injury_split(40.0, true, 0.99)
	if str(r1["kind"]) != "cracked":
		ok = false
	# Critical + roll < BELL_CRACK -> cracked.
	var r2: Dictionary = LR.injury_split(30.0, false, 0.20)
	if str(r2["kind"]) != "cracked":
		ok = false
	# Critical + roll >= BELL_CRACK -> not cracked (bruised or none).
	var r3: Dictionary = LR.injury_split(30.0, false, 0.30)
	if str(r3["kind"]) == "cracked":
		ok = false
	# ribs_value < BRUISE_LINE -> bruised (not critical, not cracked).
	var r4: Dictionary = LR.injury_split(45.0, false, 0.50)
	if str(r4["kind"]) != "bruised":
		ok = false
	# ribs_value >= BRUISE_LINE (and not critical, not cracked) -> none.
	var r5: Dictionary = LR.injury_split(55.0, false, 0.50)
	if str(r5["kind"]) != "none":
		ok = false
	# Liver never produces an injury (whatever the roll, whatever the value).
	# The liver side never calls injury_split, but we verify the function's contract:
	# if someone passes liver_value < BRUISE_LINE, it returns bruised.
	# The real contract is that liver never calls this. We test it is callable.
	for roll_i in range(0, 100):
		var r: float = float(roll_i) / 100.0
		# The liver never calls injury_split - that is the caller's job.
		# We just verify the function works at all rolls for ribs.
		var r6: Dictionary = LR.injury_split(30.0, false, r)
		var k: String = str(r6["kind"])
		if k != "cracked" and k != "bruised" and k != "none":
			ok = false
	_check(ok, "injury_split: cracked/critical->cracked, <BRUISE_LINE->bruised, else none")


## heal_days: 84 vs 112 around WORSE_CHANCE.
func _test_heal_days() -> void:
	var ok := true
	# Pull: always 35.
	if LR.heal_days("pull", 0.0) != 35:
		ok = false
	if LR.heal_days("pull", 0.5) != 35:
		ok = false
	# Defend: always 63.
	if LR.heal_days("defend", 0.0) != 63:
		ok = false
	if LR.heal_days("defend", 0.5) != 63:
		ok = false
	# Fight: 84 when roll >= WORSE_CHANCE, 84+28=112 when roll < WORSE_CHANCE.
	if LR.heal_days("fight", 0.5) != 84:
		ok = false
	if LR.heal_days("fight", LR.WORSE_CHANCE) != 84:
		ok = false
	if LR.heal_days("fight", 0.05) != 112:
		ok = false
	if LR.heal_days("fight", 0.0) != 112:
		ok = false
	_check(ok, "heal_days: 35/63/84, fight+roll<WORSE_CHANCE=112")


## 60/40 traffic mean: 0.6 * drain(liver) + 0.4 * drain(ribs) == 1.0 (+-0.001).
func _test_traffic_mean() -> void:
	var mean: float = 0.6 * LR.drain("liver") + 0.4 * LR.drain("ribs")
	_check(_near(mean, 1.0, 0.001), "traffic mean: 0.6*1.3 + 0.4*0.55 = 1.0 (got %f)" % mean)


## CONTROL: a wrong module would fail. Swap LIVER_DRAIN and RIB_DRAIN -> mean != 1.0.
func _test_control_wrong_drain() -> void:
	var wrong_mean: float = 0.6 * LR.RIB_DRAIN + 0.4 * LR.LIVER_DRAIN
	_check(not _near(wrong_mean, 1.0, 0.001),
		"CONTROL: swapped drain mean != 1.0 (got %f)" % wrong_mean)


## S467 wiring: the fight's side tally. Ten free shots drain 10 units (the old count); ten aimed at the liver 13, at the
## ribs 5.5; counts split the free ones 6/4 and add the aimed ones on their side.
func _test_side_tally() -> void:
	var free := {}
	LR.add_shots(free, 10, "")
	var liv := {}
	LR.add_shots(liv, 10, "right_ribs")
	var rib := {}
	LR.add_shots(rib, 10, "left_ribs")
	_check(_near(LR.drain_units(free), 10.0, 1e-4) and _near(LR.drain_units(liv), 13.0, 1e-4) and _near(LR.drain_units(rib), 5.5, 1e-4),
		"side tally: free 10 -> 10 units, liver 10 -> 13, ribs 10 -> 5.5 (got %.3f %.3f %.3f)" % [LR.drain_units(free), LR.drain_units(liv), LR.drain_units(rib)])
	LR.add_shots(free, 2, "left_ribs")
	var cn: Dictionary = LR.counts(free)
	_check(int(cn["liver"]) == 6 and int(cn["ribs"]) == 6, "side tally counts: 10 free + 2 ribs -> liver 6, ribs 6 (got %s)" % str(cn))
	# CONTROL: a swapped drain (liver cheap) must read differently.
	_check(not _near(LR.drain_units(liv), LR.drain_units(rib), 1e-3), "CONTROL: liver and ribs drain differ")
