extends SceneTree
## BoutBurn: 9 tests.

const BB := preload("res://scripts/rules/BoutBurn.gd")

var failures := 0


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
	print("BOUT_BURN failures=%d" % failures)
	quit(1 if failures > 0 else 0)


func _check(cond: bool, label: String) -> void:
	if cond:
		print("PASS ", label)
	else:
		failures += 1
		print("FAIL ", label)


func _stats(cond: int = 50) -> Dictionary:
	return {"power": 50, "speed": 50, "technique": 50, "conditioning": cond}


func _ex(her: int, opp: int = 0, pace: String = "steady", sit: String = "range") -> Dictionary:
	return {"sit": sit, "pace": pace, "landed": [her, opp]}


func _rnd(exchanges: Array) -> Dictionary:
	return {"exchanges": exchanges}


## 1. per_round([], {}, "") == [].
func _test1() -> void:
	var r: Array = BB.per_round([], {}, "")
	_check(r.is_empty(), "test 1: per_round([], {}, '') == []")


## 2. beats_of landed 0 -> []; landed 10 -> 31 beats, who all "a", t increasing, all < 30.
func _test2() -> void:
	var b0: Array = BB.beats_of({"landed": [0, 3]})
	_check(b0.is_empty(), "test 2a: beats_of landed 0 -> []")
	var b10: Array = BB.beats_of({"landed": [10, 0]})
	var ok := true
	if b10.size() != 31:
		ok = false
		print("  t2: expected 31 beats, got %d" % b10.size())
	var prev_t: float = -1.0
	for beat in b10:
		if str(beat["who"]) != "a":
			ok = false
		var t: float = float(beat["t"])
		if t <= prev_t:
			ok = false
		if t >= 30.0:
			ok = false
		prev_t = t
	_check(ok, "test 2b: beats_of landed 10 -> 31 beats, who=a, t increasing, t<30")


## 3. Move mix of 31 thrown: largest-remainder distribution, sums to 31.
func _test3() -> void:
	var beats: Array = BB.beats_of({"landed": [10, 0]})
	var counts: Dictionary = {}
	for b in beats:
		var m: String = str(b["move"])
		counts[m] = counts.get(m, 0) + 1
	var total: int = 0
	for m in counts:
		total += int(counts[m])
	var jab_n: int = int(counts.get("jab", 0))
	var cross_n: int = int(counts.get("cross", 0))
	var lh_n: int = int(counts.get("lead_hook", 0))
	var bh_n: int = int(counts.get("body_hook", 0))
	var ru_n: int = int(counts.get("rear_uppercut", 0))
	print("  t3: jab=%d cross=%d lead_hook=%d body_hook=%d rear_uppercut=%d" % [jab_n, cross_n, lh_n, bh_n, ru_n])
	var ok := true
	if total != 31:
		ok = false
	# Largest remainder for 31:
	# exact: jab=15.5 cross=7.75 lead_hook=4.03 body_hook=1.86 rear_uppercut=1.86
	# floors: 15+7+4+1+1=28, remainder=3
	# top 3 fracs: body_hook(0.86), rear_uppercut(0.86), cross(0.75)
	# result: jab=15, cross=8, lead_hook=4, body_hook=2, rear_uppercut=2
	if jab_n != 15 or cross_n != 8 or lh_n != 4 or bh_n != 2 or ru_n != 2:
		ok = false
	_check(ok, "test 3: mix of 31 = jab 15, cross 8, lead_hook 4, body_hook 2, rear_uppercut 2 (sum 31)")


## 4. One round, six exchanges at [8,4] steady: 1 entry, 6 parts, 0-100, lead_shoulder>0, legs>0.
func _test4() -> void:
	var exchanges: Array = []
	for _i in 6:
		exchanges.append(_ex(8, 4))
	var r: Array = BB.per_round([_rnd(exchanges)], _stats(), "")
	var ok := true
	if r.size() != 1:
		ok = false
		print("  t4: expected 1 round, got %d" % r.size())
	else:
		var snap: Dictionary = r[0]
		if snap.size() != 6:
			ok = false
			print("  t4: expected 6 parts, got %d" % snap.size())
		for p in snap:
			var v: float = float(snap[p])
			if v < 0.0 or v > 100.0:
				ok = false
				print("  t4: part %s = %.2f out of 0-100" % [str(p), v])
		if float(snap.get("lead_shoulder", 0.0)) <= 0.0:
			ok = false
			print("  t4: lead_shoulder = 0")
		if float(snap.get("legs", 0.0)) <= 0.0:
			ok = false
			print("  t4: legs = 0")
	_check(ok, "test 4: one round six exchanges, 6 parts, 0-100, lead_shoulder>0, legs>0")


## 5. Busier is hotter: [16,4] > [4,4] on lead_shoulder and rear_arm.
func _test5() -> void:
	var ex_busy: Array = []
	var ex_calm: Array = []
	for _i in 6:
		ex_busy.append(_ex(16, 4))
		ex_calm.append(_ex(4, 4))
	var r_busy: Array = BB.per_round([_rnd(ex_busy)], _stats(), "")
	var r_calm: Array = BB.per_round([_rnd(ex_calm)], _stats(), "")
	var ls_busy: float = float(r_busy[0]["lead_shoulder"])
	var ls_calm: float = float(r_calm[0]["lead_shoulder"])
	var ra_busy: float = float(r_busy[0]["rear_arm"])
	var ra_calm: float = float(r_calm[0]["rear_arm"])
	print("  t5: busy ls=%.2f calm ls=%.2f | busy ra=%.2f calm ra=%.2f" % [ls_busy, ls_calm, ra_busy, ra_calm])
	_check(ls_busy > ls_calm and ra_busy > ra_calm,
		"test 5: busier [16,4] > calmer [4,4] on lead_shoulder and rear_arm")


## 6. Pace: push > save on lead_shoulder.
func _test6() -> void:
	var ex_push: Array = []
	var ex_save: Array = []
	for _i in 6:
		ex_push.append(_ex(8, 4, "push"))
		ex_save.append(_ex(8, 4, "save"))
	var r_push: Array = BB.per_round([_rnd(ex_push)], _stats(), "")
	var r_save: Array = BB.per_round([_rnd(ex_save)], _stats(), "")
	var ls_push: float = float(r_push[0]["lead_shoulder"])
	var ls_save: float = float(r_save[0]["lead_shoulder"])
	print("  t6: push ls=%.2f save ls=%.2f" % [ls_push, ls_save])
	_check(ls_push > ls_save, "test 6: push lead_shoulder > save lead_shoulder")


## 7. Three identical rounds -> 3 entries; legs r3 >= legs r1.
func _test7() -> void:
	var exchanges: Array = []
	for _i in 6:
		exchanges.append(_ex(8, 4))
	var rnd: Dictionary = _rnd(exchanges)
	var r: Array = BB.per_round([rnd, rnd, rnd], _stats(), "")
	var ok := true
	if r.size() != 3:
		ok = false
		print("  t7: expected 3 rounds, got %d" % r.size())
	else:
		var legs1: float = float(r[0]["legs"])
		var legs3: float = float(r[2]["legs"])
		print("  t7: legs r1=%.2f r3=%.2f" % [legs1, legs3])
		if legs3 < legs1 - 0.001:
			ok = false
	_check(ok, "test 7: three rounds -> 3 entries; legs r3 >= legs r1")


## 8. Conditioning 90 -> round-2 legs <= conditioning 30.
func _test8() -> void:
	var exchanges: Array = []
	for _i in 6:
		exchanges.append(_ex(8, 4))
	var rnd: Dictionary = _rnd(exchanges)
	var r90: Array = BB.per_round([rnd, rnd], _stats(90), "")
	var r30: Array = BB.per_round([rnd, rnd], _stats(30), "")
	var legs90: float = float(r90[1]["legs"])
	var legs30: float = float(r30[1]["legs"])
	print("  t8: cond90 r2 legs=%.2f cond30 r2 legs=%.2f" % [legs90, legs30])
	_check(legs90 <= legs30 + 0.001,
		"test 8: cond 90 round-2 legs (%.2f) <= cond 30 (%.2f)" % [legs90, legs30])


## 9. Same input -> same output; rounds/stats not mutated.
func _test9() -> void:
	var exchanges: Array = []
	for _i in 6:
		exchanges.append(_ex(8, 4))
	var rounds: Array = [_rnd(exchanges), _rnd(exchanges.duplicate(true))]
	var stats: Dictionary = _stats()
	var before_r: String = str(rounds)
	var before_s: String = str(stats)
	var r1: Array = BB.per_round(rounds, stats, "")
	var r2: Array = BB.per_round(rounds, stats, "")
	var after_r: String = str(rounds)
	var after_s: String = str(stats)
	var ok := true
	if r1.size() != r2.size():
		ok = false
	else:
		for i in r1.size():
			for p in r1[i]:
				if absf(float(r1[i][p]) - float(r2[i][p])) > 0.001:
					ok = false
	if before_r != after_r:
		ok = false
	if before_s != after_s:
		ok = false
	_check(ok, "test 9: same input -> same output; not mutated")
