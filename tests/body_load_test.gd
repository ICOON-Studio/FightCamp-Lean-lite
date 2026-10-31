extends SceneTree
## BodyLoad: 10 tests, 300 seeds each.
## 1. fresh() + one jab adds SHOULDER_PER_PUNCH / ARM_PER_PUNCH
## 2. Hand sides (cross -> rear, lead_hook arm x POWER_ARM_MULT, combo x FAST_PUNCH, non-punch nothing)
## 3. Clinch: 4 s adds CLINCH_PER_S x 4 to both shoulders + core of BOTH boxers
## 4. Clamp 0..100 after extreme sequence
## 5. Calibration: busiest shoulder end of rounds 1/2/3 in 30..50 / 48..70 / 62..85
## 6. Pace: push > steady > save
## 7. Rates: 0.7 < 1.0
## 8. Rest: factor, ribs_hurt, second
## 9. Effects: guard_drop, step_scale, power_scale, band
## 10. Determinism

const RS := preload("res://scripts/rules/RoundScript.gd")
const BL := preload("res://scripts/rules/BodyLoad.gd")
const BS := preload("res://scripts/rules/BurstShape.gd")
const CB := preload("res://scripts/rules/ClinchBeats.gd")

var failures := 0
const SEEDS := 300
const EXCHANGES_PER_ROUND := 6
const ROUNDS := 3
const TANK_R1 := 100.0
const TANK_R2 := 78.0
const TANK_R3 := 61.0


func _initialize() -> void:
	_test1()
	_test2()
	_test3()
	_test4()
	_test5()
	_test6()
	_test7()
	_test8()
	_test9()
	_test10()
	print("BODY_LOAD failures=%d" % failures)
	quit(1 if failures > 0 else 0)


func _rl(n: int) -> Dictionary:
	return {"n": n, "won": true, "mine": 60.0, "theirs": 40.0, "corner": "",
		"lines": [], "names": ["Lucy", "Maria"]}


func _build_exchange(rn: int, seed: int, a_won: bool, mine: float, theirs: float) -> Array:
	var rd := _rl(rn)
	rd["won"] = a_won
	rd["mine"] = mine
	rd["theirs"] = theirs
	var sc: Dictionary = RS.build(rd, "Out-boxer", "Out-boxer", 30.0, seed)
	var beats: Array = []
	for b in sc["beats"]:
		beats.append(b.duplicate(true))
	var rng := RandomNumberGenerator.new()
	rng.seed = seed * 7 + 1
	BS.apply(beats, rng)
	var rng2 := RandomNumberGenerator.new()
	rng2.seed = seed * 13 + 3
	CB.apply(beats, {"n": rn, "sit": "press"}, rng2)
	return beats


func _build_round(rn: int, seed: int, a_won: bool) -> Array:
	var all_beats: Array = []
	for ex in EXCHANGES_PER_ROUND:
		var s: int = seed * 1000 + rn * 100 + ex
		var mine: float = 63.0 if a_won else 57.0
		var theirs: float = 60.0
		all_beats.append_array(_build_exchange(rn, s, a_won, mine, theirs))
	return all_beats


func _bout_n(seed: int) -> int:
	return (seed % 3) + 1


func _bout_mine(seed: int) -> float:
	return float([3, 10, 20][(seed / 3) % 3])


func _build_bout(seed: int) -> Dictionary:
	var load: Dictionary = BL.fresh()
	var tank_vals: Array = [TANK_R1, TANK_R2, TANK_R3]
	var n: int = _bout_n(seed)
	var mine: float = _bout_mine(seed)
	for rn in n:
		var tank: float = float(tank_vals[rn])
		for ex in EXCHANGES_PER_ROUND:
			var s: int = seed * 1000 + (rn + 1) * 100 + ex
			var a_won: bool = mine > 60.0
			var beats: Array = _build_exchange(rn + 1, s, a_won, mine, 60.0)
			var ctx: Dictionary = {"sit": "press", "pace": {"a": "steady", "b": "steady"},
				"tank": {"a": tank, "b": tank}}
			BL.add_exchange(load, beats, ctx)
		if rn < n - 1:
			BL.rest(load, {}, {}, {})
	return load


## 1. fresh() + one jab adds SHOULDER_PER_PUNCH to lead_shoulder and ARM_PER_PUNCH to lead_arm.
func _test1() -> void:
	var ok := true
	var load: Dictionary = BL.fresh()
	for who in ["a", "b"]:
		for p in BL.PARTS:
			if BL.burn(load, who, p) != 0.0:
				ok = false
	if not ok:
		_check(false, "test 1: fresh() all parts at 0")
		return
	var beats: Array = [{"t": 1.0, "who": "a", "move": "jab", "result": "lands"}]
	BL.add_exchange(load, beats, {})
	if absf(BL.burn(load, "a", "lead_shoulder") - BL.SHOULDER_PER_PUNCH) > 0.001:
		ok = false
	if absf(BL.burn(load, "a", "lead_arm") - BL.ARM_PER_PUNCH) > 0.001:
		ok = false
	if absf(BL.burn(load, "a", "rear_shoulder") - 0.0) > 0.001:
		ok = false
	if absf(BL.burn(load, "a", "rear_arm") - 0.0) > 0.001:
		ok = false
	for p in ["lead_shoulder", "rear_shoulder", "lead_arm", "rear_arm", "core"]:
		if absf(BL.burn(load, "b", p)) > 0.001:
			ok = false
	_check(ok, "test 1: fresh() + one jab -> SHOULDER_PER_PUNCH / ARM_PER_PUNCH on a lead")


## 2. Hand sides, combo multiplier, non-punch nothing.
func _test2() -> void:
	# Cross -> rear_shoulder + rear_arm (NOT a power arm punch - cross is straight, not hook/uppercut).
	var l1: Dictionary = BL.fresh()
	BL.add_exchange(l1, [{"t": 1.0, "who": "a", "move": "cross", "result": "lands"}], {})
	var ok1 := true
	if absf(BL.burn(l1, "a", "rear_shoulder") - BL.SHOULDER_PER_PUNCH) > 0.001:
		ok1 = false
	if absf(BL.burn(l1, "a", "rear_arm") - BL.ARM_PER_PUNCH) > 0.001:
		ok1 = false
	if absf(BL.burn(l1, "a", "lead_shoulder")) > 0.001:
		ok1 = false
	if absf(BL.burn(l1, "a", "lead_arm")) > 0.001:
		ok1 = false
	_check(ok1, "test 2a: cross -> rear_shoulder + rear_arm (x POWER_ARM_MULT)")
	# Lead hook arm = ARM_PER_PUNCH x POWER_ARM_MULT.
	var l2: Dictionary = BL.fresh()
	BL.add_exchange(l2, [{"t": 2.0, "who": "a", "move": "lead_hook", "result": "lands"}], {})
	var ok2 := true
	var lh_arm: float = BL.ARM_PER_PUNCH * BL.POWER_ARM_MULT
	if absf(BL.burn(l2, "a", "lead_arm") - lh_arm) > 0.001:
		ok2 = false
	if absf(BL.burn(l2, "a", "lead_shoulder") - BL.SHOULDER_PER_PUNCH) > 0.001:
		ok2 = false
	_check(ok2, "test 2b: lead_hook arm = ARM_PER_PUNCH x POWER_ARM_MULT")
	# Combo beat costs FAST_PUNCH x the single cost.
	var l3: Dictionary = BL.fresh()
	BL.add_exchange(l3, [{"t": 3.0, "who": "a", "move": "jab", "result": "lands", "combo": true}], {})
	var ok3 := true
	if absf(BL.burn(l3, "a", "lead_shoulder") - BL.SHOULDER_PER_PUNCH * BL.FAST_PUNCH) > 0.001:
		ok3 = false
	if absf(BL.burn(l3, "a", "lead_arm") - BL.ARM_PER_PUNCH * BL.FAST_PUNCH) > 0.001:
		ok3 = false
	_check(ok3, "test 2c: combo beat costs FAST_PUNCH x single")
	# Non-punch move with "none" result adds no punch/core burn.
	var l4: Dictionary = BL.fresh()
	BL.add_exchange(l4, [{"t": 4.0, "who": "a", "move": "step_in", "result": "none"}], {})
	var ok4 := true
	for p in ["lead_shoulder", "rear_shoulder", "lead_arm", "rear_arm", "core"]:
		if absf(BL.burn(l4, "a", p)) > 0.001:
			ok4 = false
	_check(ok4, "test 2d: non-punch adds no punch/core burn")
	# Punch with "misses" still adds burn (thrown, not landed).
	var l5: Dictionary = BL.fresh()
	BL.add_exchange(l5, [{"t": 5.0, "who": "a", "move": "jab", "result": "misses"}], {})
	var ok5 := true
	if absf(BL.burn(l5, "a", "lead_shoulder") - BL.SHOULDER_PER_PUNCH) > 0.001:
		ok5 = false
	_check(ok5, "test 2e: misses still burns")


## 3. Clinch: 4 s adds CLINCH_PER_S x 4 to both shoulders + core of BOTH boxers.
func _test3() -> void:
	var ok := true
	var load: Dictionary = BL.fresh()
	var beats: Array = [{"t": 5.0, "who": "a", "move": "clinch", "result": "none", "break_t": 9.0}]
	BL.add_exchange(load, beats, {})
	var expected: float = BL.CLINCH_PER_S * 4.0
	for who in ["a", "b"]:
		if absf(BL.burn(load, who, "lead_shoulder") - expected) > 0.001:
			ok = false
		if absf(BL.burn(load, who, "rear_shoulder") - expected) > 0.001:
			ok = false
		if absf(BL.burn(load, who, "core") - expected) > 0.001:
			ok = false
		if BL.burn(load, who, "lead_arm") != 0.0:
			ok = false
		if BL.burn(load, who, "rear_arm") != 0.0:
			ok = false
	_check(ok, "test 3: clinch 4 s -> CLINCH_PER_S x 4 both shoulders + core, BOTH boxers")


## 4. Clamp 0..100 after extreme sequence.
func _test4() -> void:
	var ok := true
	for s in SEEDS:
		var load: Dictionary = BL.fresh()
		for rn in ROUNDS:
			for ex in EXCHANGES_PER_ROUND:
				var seed_val: int = s * 1000 + (rn + 1) * 100 + ex
				var beats: Array = _build_exchange(rn + 1, seed_val, true, 63.0, 60.0)
				var ctx: Dictionary = {"sit": "press",
					"pace": {"a": "push", "b": "push"},
					"tank": {"a": 0.0, "b": 0.0},
					"rates": {"a": {"lead_shoulder": 1.3, "rear_shoulder": 1.3,
						"lead_arm": 1.3, "rear_arm": 1.3, "core": 1.3, "legs": 1.3},
						"b": {"lead_shoulder": 1.3, "rear_shoulder": 1.3,
						"lead_arm": 1.3, "rear_arm": 1.3, "core": 1.3, "legs": 1.3}}}
				BL.add_exchange(load, beats, ctx)
			if rn < ROUNDS - 1:
				BL.rest(load, {}, {}, {})
		for who in ["a", "b"]:
			for p in BL.PARTS:
				var v: float = BL.burn(load, who, p)
				if v < 0.0 or v > 100.0:
					ok = false
					break
			if not ok:
				break
		if not ok:
			break
	_check(ok, "test 4: clamp 0..100 after extreme sequence (push, tank 0, rates 1.3, 3 rounds)")


## 5. Calibration: busiest shoulder end of rounds 1/2/3 in range.
func _test5() -> void:
	var r1_sum := 0.0
	var r2_sum := 0.0
	var r3_sum := 0.0
	var r1_count := 0
	var r2_count := 0
	var r3_count := 0
	for s in SEEDS:
		var load: Dictionary = BL.fresh()
		var tank_vals: Array = [TANK_R1, TANK_R2, TANK_R3]
		var n: int = _bout_n(s)
		var mine: float = _bout_mine(s)
		for rn in n:
			var tank: float = float(tank_vals[rn])
			for ex in EXCHANGES_PER_ROUND:
				var seed_val: int = s * 1000 + (rn + 1) * 100 + ex
				var a_won: bool = mine > 60.0
				var beats: Array = _build_exchange(rn + 1, seed_val, a_won, mine, 60.0)
				var ctx: Dictionary = {"sit": "press",
					"pace": {"a": "steady", "b": "steady"},
					"tank": {"a": tank, "b": tank}}
				BL.add_exchange(load, beats, ctx)
			if rn == 0:
				var wp: String = BL.worst_part(load, "a")
				r1_sum += BL.burn(load, "a", wp)
				r1_count += 1
			elif rn == 1:
				var wp: String = BL.worst_part(load, "a")
				r2_sum += BL.burn(load, "a", wp)
				r2_count += 1
			elif rn == 2:
				var wp: String = BL.worst_part(load, "a")
				r3_sum += BL.burn(load, "a", wp)
				r3_count += 1
			if rn < n - 1:
				BL.rest(load, {}, {}, {})
	var r1_mean: float = r1_sum / float(maxi(r1_count, 1))
	var r2_mean: float = r2_sum / float(maxi(r2_count, 1))
	var r3_mean: float = r3_sum / float(maxi(r3_count, 1))
	print("  t5: busiest shoulder means: r1=%.1f r2=%.1f r3=%.1f" % [r1_mean, r2_mean, r3_mean])
	_check(r1_mean >= 30.0 and r1_mean <= 50.0,
		"test 5: r1 busiest shoulder %.1f in 30..50" % r1_mean)
	_check(r2_mean >= 48.0 and r2_mean <= 70.0,
		"test 5: r2 busiest shoulder %.1f in 48..70" % r2_mean)
	_check(r3_mean >= 62.0 and r3_mean <= 85.0,
		"test 5: r3 busiest shoulder %.1f in 62..85" % r3_mean)


## 6. Pace: push > steady > save on every part with any work.
func _test6() -> void:
	var ok := true
	for s in SEEDS:
		var seed_val: int = s * 1000 + 100
		var beats: Array = _build_exchange(1, seed_val, true, 63.0, 60.0)
		var l_push: Dictionary = BL.fresh()
		BL.add_exchange(l_push, beats.duplicate(true),
			{"pace": {"a": "push", "b": "push"}, "tank": {"a": 80.0, "b": 80.0}})
		var l_steady: Dictionary = BL.fresh()
		BL.add_exchange(l_steady, beats.duplicate(true),
			{"pace": {"a": "steady", "b": "steady"}, "tank": {"a": 80.0, "b": 80.0}})
		var l_save: Dictionary = BL.fresh()
		BL.add_exchange(l_save, beats.duplicate(true),
			{"pace": {"a": "save", "b": "save"}, "tank": {"a": 80.0, "b": 80.0}})
		for who in ["a", "b"]:
			for p in BL.PARTS:
				var pv: float = BL.burn(l_push, who, p)
				var sv: float = BL.burn(l_steady, who, p)
				var avv: float = BL.burn(l_save, who, p)
				if pv > 0.0:
					if pv <= sv + 0.001:
						ok = false
				if sv > 0.0:
					if sv <= avv + 0.001:
						ok = false
		if not ok:
			break
	_check(ok, "test 6: pace push > steady > save")


## 7. Rates: part at 0.7 ends lower than at 1.0.
func _test7() -> void:
	var ok := true
	for s in SEEDS:
		var seed_val: int = s * 1000 + 200
		var beats: Array = _build_exchange(1, seed_val, true, 63.0, 60.0)
		var l1: Dictionary = BL.fresh()
		BL.add_exchange(l1, beats.duplicate(true), {})
		var l2: Dictionary = BL.fresh()
		BL.add_exchange(l2, beats.duplicate(true),
			{"rates": {"a": {"lead_shoulder": 0.7}, "b": {"lead_shoulder": 0.7}}})
		if BL.burn(l2, "a", "lead_shoulder") >= BL.burn(l1, "a", "lead_shoulder") - 0.001:
			ok = false
		if not ok:
			break
	_check(ok, "test 7: rate 0.7 < rate 1.0 on lead_shoulder")


## 8. Rest: factor, ribs_hurt, second.
func _test8() -> void:
	var ok := true
	# With cond 1.0, no ribs hurt, no second: every part = before x (1 - REST_BACK).
	var load: Dictionary = BL.fresh()
	load["a"]["lead_shoulder"] = 40.0
	load["a"]["rear_shoulder"] = 30.0
	load["a"]["lead_arm"] = 20.0
	load["a"]["rear_arm"] = 50.0
	load["a"]["core"] = 10.0
	load["a"]["legs"] = 60.0
	load["b"]["lead_shoulder"] = 45.0
	load["b"]["rear_shoulder"] = 35.0
	load["b"]["lead_arm"] = 25.0
	load["b"]["rear_arm"] = 55.0
	load["b"]["core"] = 15.0
	load["b"]["legs"] = 65.0
	var before: Dictionary = {}
	for who in ["a", "b"]:
		before[who] = {}
		for p in BL.PARTS:
			before[who][p] = BL.burn(load, who, p)
	BL.rest(load, {}, {}, {})
	for who in ["a", "b"]:
		for p in BL.PARTS:
			var expected: float = float(before[who][p]) * (1.0 - BL.REST_BACK)
			if absf(BL.burn(load, who, p) - expected) > 0.001:
				ok = false
	if not ok:
		_check(false, "test 8a: rest factor = 1 - REST_BACK")
		return
	# ribs_hurt true leaves more burn than false.
	var l_rh: Dictionary = BL.fresh()
	l_rh["a"]["core"] = 40.0
	var l_no: Dictionary = BL.fresh()
	l_no["a"]["core"] = 40.0
	BL.rest(l_rh, {}, {"a": true}, {})
	BL.rest(l_no, {}, {"a": false}, {})
	if BL.burn(l_rh, "a", "core") <= BL.burn(l_no, "a", "core") + 0.001:
		ok = false
	if not ok:
		_check(false, "test 8b: ribs_hurt leaves more burn")
		return
	# second = worst_part takes SECOND_WORK more off that part only.
	var l_sec: Dictionary = BL.fresh()
	l_sec["a"]["lead_shoulder"] = 30.0
	l_sec["a"]["rear_shoulder"] = 30.0
	l_sec["a"]["lead_arm"] = 30.0
	l_sec["a"]["rear_arm"] = 30.0
	l_sec["a"]["core"] = 30.0
	l_sec["a"]["legs"] = 60.0
	BL.rest(l_sec, {}, {}, {"a": "legs"})
	var expected_legs: float = 60.0 * (1.0 - BL.REST_BACK) - BL.SECOND_WORK
	if absf(BL.burn(l_sec, "a", "legs") - expected_legs) > 0.001:
		ok = false
	if absf(BL.burn(l_sec, "a", "lead_shoulder") - 30.0 * (1.0 - BL.REST_BACK)) > 0.001:
		ok = false
	_check(ok, "test 8c: second = worst_part takes SECOND_WORK off that part only")


## 9. Effects: guard_drop, step_scale, power_scale, band.
func _test9() -> void:
	var ok := true
	# guard_drop: 0 at shoulders <= 50, GUARD_DROP_MAX at 100, monotone.
	var l1: Dictionary = BL.fresh()
	l1["a"]["lead_shoulder"] = 50.0
	l1["a"]["rear_shoulder"] = 50.0
	if absf(BL.guard_drop(l1, "a")) > 0.001:
		ok = false
	var l2: Dictionary = BL.fresh()
	l2["a"]["lead_shoulder"] = 100.0
	l2["a"]["rear_shoulder"] = 100.0
	if absf(BL.guard_drop(l2, "a") - BL.GUARD_DROP_MAX) > 0.001:
		ok = false
	var prev_gd := -1.0
	var mono_ok := true
	for sv in [50.0, 60.0, 70.0, 80.0, 90.0, 100.0]:
		var lt: Dictionary = BL.fresh()
		lt["a"]["lead_shoulder"] = sv
		lt["a"]["rear_shoulder"] = sv
		var gd: float = BL.guard_drop(lt, "a")
		if gd < prev_gd - 0.001:
			mono_ok = false
		prev_gd = gd
	if not mono_ok:
		ok = false
	# step_scale: 1.0 at legs <= 50, STEP_MIN at 100.
	var l3: Dictionary = BL.fresh()
	l3["a"]["legs"] = 50.0
	if absf(BL.step_scale(l3, "a") - 1.0) > 0.001:
		ok = false
	var l4: Dictionary = BL.fresh()
	l4["a"]["legs"] = 100.0
	if absf(BL.step_scale(l4, "a") - BL.STEP_MIN) > 0.001:
		ok = false
	# power_scale: 1.0 at arms <= 50, POWER_MIN at 100.
	var l5: Dictionary = BL.fresh()
	l5["a"]["lead_arm"] = 50.0
	l5["a"]["rear_arm"] = 50.0
	if absf(BL.power_scale(l5, "a") - 1.0) > 0.001:
		ok = false
	var l6: Dictionary = BL.fresh()
	l6["a"]["lead_arm"] = 100.0
	l6["a"]["rear_arm"] = 100.0
	if absf(BL.power_scale(l6, "a") - BL.POWER_MIN) > 0.001:
		ok = false
	# band edges.
	if BL.band(24.9) != "fresh":
		ok = false
	if BL.band(25.0) != "warm":
		ok = false
	if BL.band(50.0) != "hot":
		ok = false
	if BL.band(75.0) != "burning":
		ok = false
	_check(ok, "test 9: effects (guard_drop, step_scale, power_scale, band)")


## 10. Determinism: same input -> same output.
func _test10() -> void:
	var ok := true
	for s in SEEDS:
		var load1: Dictionary = _build_bout(s)
		var load2: Dictionary = _build_bout(s)
		for who in ["a", "b"]:
			for p in BL.PARTS:
				if absf(BL.burn(load1, who, p) - BL.burn(load2, who, p)) > 0.001:
					ok = false
					break
			if not ok:
				break
		if not ok:
			break
	_check(ok, "test 10: determinism (same input -> same output)")


func _check(cond: bool, label: String) -> void:
	if cond:
		print("PASS ", label)
	else:
		failures += 1
		print("FAIL ", label)
