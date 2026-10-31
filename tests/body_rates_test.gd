extends SceneTree
## BodyRates: 10 tests.
## 1. Default stats + Boxer-puncher -> all 1.0
## 2. Conditioning: 100 -> 0.75 all; 0 -> 1.25 all
## 3. Technique 100 lowers shoulders/arms by 0.10; speed 100 lowers legs by 0.08
## 4. Power: 30 nothing; 100 raises arms by 0.06
## 5. Style comparisons (Out-boxer legs > Pressure; Pressure arms > Out-boxer; unknown = Boxer-puncher)
## 6. Clamp: never exceeds RATE_MAX or goes under RATE_MIN
## 7. Monotone: raising conditioning never raises any rate
## 8. Wired with BodyLoad: rates < 1.0 -> every worked part ends lower
## 9. word(): 0.85 -> "trained", 1.15 -> "burns fast", 1.0 -> "average"
## 10. Determinism: same input -> same output

const BL := preload("res://scripts/rules/BodyLoad.gd")
const BR := preload("res://scripts/rules/BodyRates.gd")
const RS := preload("res://scripts/rules/RoundScript.gd")
const BS := preload("res://scripts/rules/BurstShape.gd")
const CB := preload("res://scripts/rules/ClinchBeats.gd")

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
	_test10()
	print("BODY_RATES failures=%d" % failures)
	quit(1 if failures > 0 else 0)


func _check(cond: bool, label: String) -> void:
	if cond:
		print("PASS ", label)
	else:
		failures += 1
		print("FAIL ", label)


func _rl(n: int) -> Dictionary:
	return {"n": n, "won": true, "mine": 60.0, "theirs": 40.0, "corner": "",
		"lines": [], "names": ["Lucy", "Maria"]}


func _build_exchange(seed: int) -> Array:
	var rd := _rl(1)
	var sc: Dictionary = RS.build(rd, "Out-boxer", "Out-boxer", 30.0, seed)
	var beats: Array = []
	for b in sc["beats"]:
		beats.append(b.duplicate(true))
	var rng := RandomNumberGenerator.new()
	rng.seed = seed * 7 + 1
	BS.apply(beats, rng)
	var rng2 := RandomNumberGenerator.new()
	rng2.seed = seed * 13 + 3
	CB.apply(beats, {"n": 1, "sit": "press"}, rng2)
	return beats


## 1. Default stats (all 50) + Boxer-puncher -> all 1.0.
func _test1() -> void:
	var ok := true
	var rates: Dictionary = BR.of({}, "Boxer-puncher")
	for p in BR.PARTS:
		if absf(float(rates[p]) - 1.0) > 0.001:
			ok = false
	_check(ok, "test 1: default stats + Boxer-puncher -> all 1.0")


## 2. Conditioning: 100 -> 0.75 every part; 0 -> 1.25 every part.
func _test2() -> void:
	var ok := true
	var r100: Dictionary = BR.of({"conditioning": 100.0}, "Boxer-puncher")
	for p in BR.PARTS:
		if absf(float(r100[p]) - 0.75) > 0.001:
			ok = false
	var r0: Dictionary = BR.of({"conditioning": 0.0}, "Boxer-puncher")
	for p in BR.PARTS:
		if absf(float(r0[p]) - 1.25) > 0.001:
			ok = false
	_check(ok, "test 2: conditioning 100 -> 0.75; 0 -> 1.25")


## 3. Technique 100 lowers shoulders/arms by 0.10, leaves core/legs at 1.0; speed 100 lowers legs by 0.08 only.
func _test3() -> void:
	var ok := true
	var rt: Dictionary = BR.of({"technique": 100.0}, "Boxer-puncher")
	for p in ["lead_shoulder", "rear_shoulder", "lead_arm", "rear_arm"]:
		if absf(float(rt[p]) - 0.90) > 0.001:
			ok = false
	if absf(float(rt["core"]) - 1.0) > 0.001:
		ok = false
	if absf(float(rt["legs"]) - 1.0) > 0.001:
		ok = false
	var rs: Dictionary = BR.of({"speed": 100.0}, "Boxer-puncher")
	if absf(float(rs["legs"]) - 0.92) > 0.001:
		ok = false
	for p in ["lead_shoulder", "rear_shoulder", "lead_arm", "rear_arm", "core"]:
		if absf(float(rs[p]) - 1.0) > 0.001:
			ok = false
	_check(ok, "test 3: technique 100 -> upper -0.10; speed 100 -> legs -0.08")


## 4. Power: 30 changes nothing; 100 raises arms by 0.06.
func _test4() -> void:
	var ok := true
	var r30: Dictionary = BR.of({"power": 30.0}, "Boxer-puncher")
	for p in BR.PARTS:
		if absf(float(r30[p]) - 1.0) > 0.001:
			ok = false
	var r100: Dictionary = BR.of({"power": 100.0}, "Boxer-puncher")
	if absf(float(r100["lead_arm"]) - 1.06) > 0.001:
		ok = false
	if absf(float(r100["rear_arm"]) - 1.06) > 0.001:
		ok = false
	for p in ["lead_shoulder", "rear_shoulder", "core", "legs"]:
		if absf(float(r100[p]) - 1.0) > 0.001:
			ok = false
	_check(ok, "test 4: power 30 -> nothing; 100 -> arms +0.06")


## 5. Style comparisons.
func _test5() -> void:
	var ok := true
	var out_box: Dictionary = BR.of({}, "Out-boxer")
	var press: Dictionary = BR.of({}, "Pressure fighter")
	var unknown: Dictionary = BR.of({}, "Martian")
	var bp: Dictionary = BR.of({}, "Boxer-puncher")
	if float(out_box["legs"]) <= float(press["legs"]) + 0.001:
		ok = false
	if float(press["lead_arm"]) <= float(out_box["lead_arm"]) + 0.001:
		ok = false
	for p in BR.PARTS:
		if absf(float(unknown[p]) - float(bp[p])) > 0.001:
			ok = false
	_check(ok, "test 5: Out-boxer legs > Pressure; Pressure arms > Out-boxer; unknown = Boxer-puncher")


## 6. Clamp: never exceeds RATE_MAX or goes under RATE_MIN.
func _test6() -> void:
	var ok := true
	var worst_high: Dictionary = BR.of({"conditioning": 0.0, "technique": 0.0, "power": 100.0}, "Pressure fighter")
	for p in BR.PARTS:
		if float(worst_high[p]) > BR.RATE_MAX + 0.001:
			ok = false
	var worst_low: Dictionary = BR.of({"conditioning": 100.0, "technique": 100.0, "speed": 100.0}, "Boxer-puncher")
	for p in BR.PARTS:
		if float(worst_low[p]) < BR.RATE_MIN - 0.001:
			ok = false
	_check(ok, "test 6: clamp RATE_MIN..RATE_MAX holds at extremes")


## 7. Monotone: raising conditioning in steps of 10 never raises any rate.
func _test7() -> void:
	var ok := true
	for style_name in BR.STYLE:
		var prev: Dictionary = BR.of({"conditioning": 0.0}, style_name)
		for cv in [10, 20, 30, 40, 50, 60, 70, 80, 90, 100]:
			var cur: Dictionary = BR.of({"conditioning": float(cv)}, style_name)
			for p in BR.PARTS:
				if float(cur[p]) > float(prev[p]) + 0.001:
					ok = false
			prev = cur
	_check(ok, "test 7: raising conditioning never raises any rate (all styles)")


## 8. Wired with BodyLoad: rates < 1.0 -> every worked part of "a" ends lower.
func _test8() -> void:
	var ok := true
	var beats: Array = _build_exchange(42)
	var l_no: Dictionary = BL.fresh()
	BL.add_exchange(l_no, beats.duplicate(true), {})
	var rates_a: Dictionary = BR.of({"conditioning": 80.0, "technique": 70.0}, "Boxer-puncher")
	var l_rates: Dictionary = BL.fresh()
	BL.add_exchange(l_rates, beats.duplicate(true), {"rates": {"a": rates_a}})
	for p in BL.PARTS:
		var v_no: float = BL.burn(l_no, "a", p)
		var v_r: float = BL.burn(l_rates, "a", p)
		if v_no > 0.001:
			if v_r >= v_no - 0.001:
				ok = false
	_check(ok, "test 8: wired with BodyLoad - rates < 1.0 -> worked parts lower")


## 9. word().
func _test9() -> void:
	var ok := true
	if BR.word(0.85) != "trained":
		ok = false
	if BR.word(1.15) != "burns fast":
		ok = false
	if BR.word(1.0) != "average":
		ok = false
	_check(ok, "test 9: word() -> trained / burns fast / average")


## 10. Determinism: same input -> same output.
func _test10() -> void:
	var ok := true
	for s in 100:
		var stats: Dictionary = {"conditioning": float(s), "technique": float(100 - s), "power": float(s % 80), "speed": float((s * 3) % 100)}
		for style_name in BR.STYLE:
			var r1: Dictionary = BR.of(stats, style_name)
			var r2: Dictionary = BR.of(stats, style_name)
			for p in BR.PARTS:
				if absf(float(r1[p]) - float(r2[p])) > 0.001:
					ok = false
	_check(ok, "test 10: determinism (same input -> same output)")
