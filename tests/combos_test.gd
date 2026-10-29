extends SceneTree
## Combos test: 9 tests covering unlock, cap, drill, edge, pick, interval,
## combo_cost, energy (uses / round_spend / recover / tired_penalty / max_len),
## and opponent_combos. Two fighters A and B, never identical.

const C := preload("res://scripts/rules/Combos.gd")

var failures := 0


func _initialize() -> void:
	_test_1_unlocked()
	_test_2_cap()
	_test_3_drill()
	_test_4_edge()
	_test_5_pick()
	_test_6_interval()
	_test_7_combo_cost()
	_test_8_energy()
	_test_9_opponent()
	print("COMBOS failures=%d" % failures)
	quit(1 if failures > 0 else 0)


func _check(cond: bool, label: String) -> void:
	if cond:
		print("PASS ", label)
	else:
		failures += 1
		print("FAIL ", label)


func _approx(a: float, b: float, tol: float = 0.01) -> bool:
	return absf(a - b) < tol


func _fighter_a() -> Dictionary:
	return {"Jab": 62, "Cross": 48, "Lead hook": 33, "Body hook": 12, "Uppercut": 0, "Check hook": 0}


func _fighter_b() -> Dictionary:
	return {"Jab": 35, "Cross": 31, "Lead hook": 5, "Body hook": 40, "Uppercut": 31, "Check hook": 30}


## 1. unlocked + missing
func _test_1_unlocked() -> void:
	var a := _fighter_a()
	var b := _fighter_b()
	var ua := C.unlocked(a)
	var ub := C.unlocked(b)
	_check(ua == ["1-1", "1-2", "1-1-2", "2-3", "1-2-3", "1-2-3-2"], "unlocked(A) = 6 combos")
	_check(ub == ["1-1", "1-2", "1-1-2", "1-2-3b", "slip 2-3"], "unlocked(B) = 5 combos")
	_check(C.missing("3b-3", a) == ["Body hook"], "missing('3b-3', A) = [Body hook]")
	_check(C.missing("1-6-3", b) == ["Lead hook"], "missing('1-6-3', B) = [Lead hook]")


## 2. cap
func _test_2_cap() -> void:
	var a := _fighter_a()
	_check(_approx(C.cap("1-2-3", a, 70, 60), 33.0), "cap('1-2-3', A, 70, 60) = 33 (lead hook)")
	_check(_approx(C.cap("1-2", a, 30, 30), 48.0), "cap('1-2', A, 30, 30) = 48: never sharper than her cross (S302 fix: the brief said 58)")
	_check(_approx(C.cap("1-2", {"Jab": 90.0, "Cross": 88.0}, 30, 30), 58.0), "cap: the technique cap binds when both punches are past it (58)")


## 3. drill: 4-punch gains about half a 2-punch in the same minutes; never past cap
func _test_3_drill() -> void:
	var m := 10.0
	var cap_v := 100.0
	var gain2 := C.drill(m, "1-2", 30.0, 50.0, 2, cap_v) - m
	var gain4 := C.drill(m, "1-2-3-2", 30.0, 50.0, 2, cap_v) - m
	var ratio := gain4 / gain2
	_check(ratio > 0.4 and ratio < 0.6, "drill: 4-punch gains ~half of 2-punch (ratio=%.2f)" % ratio)
	var d1 := C.drill(50.0, "1-2", 60.0, 50.0, 2, 55.0)
	_check(d1 <= 55.0, "drill: never past cap (50 -> cap 55)")
	var d2 := C.drill(0.0, "1-2", 60.0, 50.0, 2, 10.0)
	_check(d2 <= 10.0, "drill: never past cap (0 -> cap 10)")


## 4. edge
func _test_4_edge() -> void:
	_check(_approx(C.edge({}, 100.0), 0.0), "edge: 0 with no combos")
	var sig := {"1-1": 90.0, "1-2": 90.0, "1-1-2": 90.0}
	_check(_approx(C.edge(sig, 100.0), 0.6), "edge: 3 SIGNATURE at energy 100 = 0.6")
	_check(_approx(C.edge(sig, 24.0), 0.42), "edge: 3 SIGNATURE at energy 24 = 0.42 (30% shorter combos)")


## 5. pick
func _test_5_pick() -> void:
	var p1 := C.pick({"1-1": 20.0}, 10, 0.5)
	_check(p1.is_empty(), "pick: {} when mastery < LEARN_AT")
	var p2 := C.pick({"1-2-3": 50.0}, 2, 0.5)
	_check(p2.is_empty(), "pick: {} when combo longer than max_len")
	var p3 := C.pick({}, 10, 0.5)
	_check(p3.is_empty(), "pick: {} when no combos")
	var rng := RandomNumberGenerator.new()
	rng.seed = 42
	var c80 := 0
	var c35 := 0
	for _i in 1000:
		var p := C.pick({"1-1": 80.0, "1-2": 35.0}, 10, rng.randf())
		var pid := str(p.get("id", ""))
		if pid == "1-1":
			c80 += 1
		elif pid == "1-2":
			c35 += 1
	_check(c80 > c35, "pick: 80 picked more often than 35 over 1000 rolls (%d vs %d)" % [c80, c35])
	var ok_bounds := true
	for s in 200:
		var rng2 := RandomNumberGenerator.new()
		rng2.seed = s
		var p := C.pick({"1-1": 50.0, "1-2-3": 40.0, "2-3": 35.0}, 2, rng2.randf())
		if not p.is_empty():
			if float(p.get("moves", []).size()) > 2:
				ok_bounds = false
			var pid := str(p.get("id", ""))
			if float({"1-1": 50.0, "1-2-3": 40.0, "2-3": 35.0}.get(pid, 0.0)) < C.LEARN_AT:
				ok_bounds = false
	_check(ok_bounds, "pick: never returns under LEARN_AT or longer than max_len (200 seeds)")


## 6. interval
func _test_6_interval() -> void:
	_check(_approx(C.interval(0.0, false, 100.0), 0.45), "interval: m=0 alt = 0.45")
	_check(_approx(C.interval(100.0, false, 100.0), 0.30), "interval: m=100 alt = 0.30")
	_check(_approx(C.interval(100.0, true, 100.0), 0.40), "interval: m=100 same hand = 0.40")
	_check(_approx(C.interval(100.0, false, 20.0), 0.30), "interval: m=100 at 20 holds = 0.30")
	_check(_approx(C.interval(100.0, false, 10.0), 0.33), "interval: m=100 under 20 stretches 10% = 0.33")
	_check(_approx(C.interval(0.0, true, 10.0), 0.605), "interval: m=0 same hand + tired = 0.605")


## 7. combo_cost
func _test_7_combo_cost() -> void:
	_check(_approx(C.combo_cost(2), 0.5258, 0.001), "combo_cost(2) = 0.22 x 2.39")
	_check(_approx(C.combo_cost(4), 1.1374, 0.001), "combo_cost(4) = 0.22 x 5.17")
	_check(C.combo_cost(3) > C.combo_cost(2), "combo_cost: 3 > 2")
	_check(C.combo_cost(4) > C.combo_cost(3), "combo_cost: 4 > 3")
	var ok_per := true
	for n in range(2, 6):
		var per_n := C.combo_cost(n) / float(n)
		var per_n1 := C.combo_cost(n + 1) / float(n + 1)
		if per_n1 < per_n:
			ok_per = false
	_check(ok_per, "combo_cost: longer always costs more per punch")


## 8. energy over a 3-round bout
func _test_8_energy() -> void:
	var combos := {"1-1": 50.0, "1-2": 40.0, "1-1-2": 35.0}
	# John J-COMBOENERGY1 targets at finals pace: bells ~68 / 46 / 29, rests ~78 / 61. Bounds, never the exact count.
	var bells := _bout(combos, "", 50.0)
	_check(bells[0] > 60.0 and bells[0] < 76.0, "energy: cond-50 round 1 bell in 60..76 (%.1f)" % bells[0])
	_check(bells[1] > 38.0 and bells[1] < 56.0, "energy: cond-50 round 2 bell in 38..56 (%.1f)" % bells[1])
	_check(bells[2] > 20.0 and bells[2] < 40.0, "energy: cond-50 round 3 bell in 20..40 (%.1f)" % bells[2])
	_check(bells[3] > bells[0] and bells[4] > bells[1], "energy: the rest gives some back (%.1f, %.1f)" % [bells[3], bells[4]])
	_check(bells[3] < C.TANK - 10.0, "energy: the rest never clears a round (%.1f)" % bells[3])
	var e80: Array = _bout(combos, "", 80.0)
	var e45: Array = _bout(combos, "", 45.0)
	_check(e80[2] > e45[2] + 8.0, "energy: cond-80 ends clearly above cond-45 (%.1f > %.1f)" % [e80[2], e45[2]])
	var ec: Array = _bout(combos, "calm", 60.0)
	var eb: Array = _bout(combos, "body", 60.0)
	_check(ec[2] > eb[2], "energy: calm ends with more than body (%.1f > %.1f)" % [ec[2], eb[2]])
	_check(C.combo_cost(3) > 3.0 * C.PUNCH_COST, "energy: a 3-combo costs more than 3 singles")
	_check(_approx(C.tired_penalty(25.0), 0.0), "tired_penalty: 0 at >= 20 (force holds)")
	_check(_approx(C.tired_penalty(0.0), 1.0), "tired_penalty: 1.0 at 0")
	_check(C.max_len(100.0, 4) == 4, "max_len(100, 4) = 4 (fresh = her speed cap)")
	_check(C.max_len(30.0, 4) == 3, "max_len(30, 4) = 3 (~30% shorter)")
	_check(C.max_len(10.0, 1) == 1, "max_len never under 1")
	_check(_approx(C.cut_chance(50.0), 0.0) and _approx(C.cut_chance(20.0), 0.5) and _approx(C.cut_chance(0.0), 0.5),
		"cut_chance: none above 40, half by 20")


## Three rounds: [bell 1, bell 2, bell 3, after rest 1, after rest 2].
func _bout(combos: Dictionary, corner: String, cond: float) -> Array:
	var e := C.TANK
	var debt := 0.0
	var bells: Array = []
	var rests: Array = []
	for r in 3:
		var o := C.after_round(e, debt, C.round_spend(combos, corner, cond), cond)
		bells.append(float(o["bell"]))
		e = float(o["next"])
		debt = float(o["debt"])
		rests.append(e)
	return [bells[0], bells[1], bells[2], rests[0], rests[1]]


## 9. opponent_combos
func _test_9_opponent() -> void:
	var opp1 := {"style": "Out-boxer", "weak": "Doubles the jab"}
	var oc1 := C.opponent_combos(opp1)
	_check(float(oc1.get("1-1", 0.0)) == 60.0, "opponent: Out-boxer + 'Doubles the jab' -> 1-1 at 60")
	var opp2 := {"style": "Something else"}
	var oc2 := C.opponent_combos(opp2)
	_check(float(oc2.get("1-2", 0.0)) == 45.0 and oc2.size() == 1, "opponent: unknown style -> {'1-2': 45}")
	var opp3 := {"style": "Slugger", "threat": "heavy body work"}
	var oc3 := C.opponent_combos(opp3)
	_check(float(oc3.get("3b-3", 0.0)) == 50.0 and float(oc3.get("2-3", 0.0)) == 55.0, "opponent: Slugger + 'body' -> 3b-3 50, keeps 2-3 55")
