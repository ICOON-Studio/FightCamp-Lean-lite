extends SceneTree
## PaceAim: 13 tests.

const PA := preload("res://scripts/rules/PaceAim.gd")
const BL := preload("res://scripts/rules/BodyLoad.gd")
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
	_test11()
	_test12()
	_test13()
	print("PACE_AIM failures=%d" % failures)
	quit(1 if failures > 0 else 0)


func _check(cond: bool, label: String) -> void:
	if cond:
		print("PASS ", label)
	else:
		failures += 1
		print("FAIL ", label)


## 1. Baseline: edge("steady", "", {}, {}) == 0.0.
func _test1() -> void:
	var ok := true
	if not is_equal_approx(PA.edge("steady", "", {}, {}), 0.0):
		ok = false
	_check(ok, "test 1: edge(steady, '', {}, {}) == 0.0")


## 2. Pace: push 6, save -6, unknown 0.
func _test2() -> void:
	var ok := true
	if not is_equal_approx(PA.edge("push", "", {}, {}), 6.0):
		ok = false
	if not is_equal_approx(PA.edge("save", "", {}, {}), -6.0):
		ok = false
	if not is_equal_approx(PA.edge("bogus", "", {}, {}), 0.0):
		ok = false
	_check(ok, "test 2: pace edge push/save/unknown")


## 3. Aim cost: any aim != "" costs AIM_COST.
func _test3() -> void:
	var ok := true
	if not is_equal_approx(PA.edge("steady", "head", {}, {}), -1.5):
		ok = false
	if not is_equal_approx(PA.edge("steady", "body", {}, {}), -1.5):
		ok = false
	_check(ok, "test 3: aim cost -1.5")


## 4. Hurt aim: left_ribs hurt -> +4; head_hurt with head hurt -> +4.
func _test4() -> void:
	var ok := true
	if not is_equal_approx(PA.edge("steady", "left_ribs", {"left_ribs": true}, {}), 2.5):
		ok = false
	if not is_equal_approx(PA.edge("steady", "left_ribs", {"left_ribs": false}, {}), -1.5):
		ok = false
	if not is_equal_approx(PA.edge("steady", "head_hurt", {"head": true}, {}), 2.5):
		ok = false
	_check(ok, "test 4: hurt aim bonuses")


## 5. Body on tired: core or legs >= 50 -> +3; ribs hurt AND tired -> both bonuses.
func _test5() -> void:
	var ok := true
	if not is_equal_approx(PA.edge("steady", "body", {}, {"legs": 60.0}), 1.5):
		ok = false
	if not is_equal_approx(PA.edge("steady", "body", {}, {"legs": 40.0, "core": 40.0}), -1.5):
		ok = false
	if not is_equal_approx(PA.edge("steady", "right_ribs", {"right_ribs": true}, {"core": 55.0}), 5.5):
		ok = false
	_check(ok, "test 5: body on tired + hurt ribs stacked")


## 6. spend/output/recover.
func _test6() -> void:
	var ok := true
	if not is_equal_approx(PA.spend("push"), 1.35):
		ok = false
	if not is_equal_approx(PA.spend("steady"), 1.0):
		ok = false
	if not is_equal_approx(PA.spend("save"), 0.6):
		ok = false
	if not is_equal_approx(PA.spend("bogus"), 1.0):
		ok = false
	if not is_equal_approx(PA.output("push"), 1.25):
		ok = false
	if not is_equal_approx(PA.output("steady"), 1.0):
		ok = false
	if not is_equal_approx(PA.output("save"), 0.75):
		ok = false
	if not is_equal_approx(PA.output("bogus"), 1.0):
		ok = false
	if not is_equal_approx(PA.recover("push"), 0.0):
		ok = false
	if not is_equal_approx(PA.recover("steady"), 0.0):
		ok = false
	if not is_equal_approx(PA.recover("save"), 3.0):
		ok = false
	if not is_equal_approx(PA.recover("bogus"), 0.0):
		ok = false
	_check(ok, "test 6: spend/output/recover")


## 7. body_share.
func _test7() -> void:
	var ok := true
	if not is_equal_approx(PA.body_share(""), 0.2):
		ok = false
	if not is_equal_approx(PA.body_share("head"), 0.08):
		ok = false
	if not is_equal_approx(PA.body_share("body"), 0.5):
		ok = false
	if not is_equal_approx(PA.body_share("left_ribs"), 0.6):
		ok = false
	if not is_equal_approx(PA.body_share("bogus"), 0.2):
		ok = false
	for aim in PA.AIMS:
		var v: float = PA.body_share(aim)
		if v < 0.0 or v > 1.0:
			ok = false
	_check(ok, "test 7: body_share values and 0..1")


## 8. damage.
func _test8() -> void:
	var ok := true
	if not is_equal_approx(PA.damage("left_ribs", "left_ribs", {"left_ribs": true}), 1.3):
		ok = false
	if not is_equal_approx(PA.damage("left_ribs", "left_ribs", {"left_ribs": false}), 1.0):
		ok = false
	if not is_equal_approx(PA.damage("left_ribs", "right_ribs", {"right_ribs": true}), 1.0):
		ok = false
	if not is_equal_approx(PA.damage("head_hurt", "head", {"head": true}), 1.3):
		ok = false
	if not is_equal_approx(PA.damage("body", "left_ribs", {"left_ribs": true}), 1.0):
		ok = false
	_check(ok, "test 8: damage multipliers")


## 9. Words.
func _test9() -> void:
	var ok := true
	if PA.pace_word("push") != "Push now!":
		ok = false
	if PA.pace_word("steady") != "Stay steady":
		ok = false
	if PA.pace_word("save") != "Take this one easy":
		ok = false
	if PA.pace_word("") != "":
		ok = false
	if PA.pace_word("bogus") != "":
		ok = false
	if PA.aim_word("") != "":
		ok = false
	if PA.aim_word("head") != "Head hunt":
		ok = false
	if PA.aim_word("body") != "Go to the body":
		ok = false
	if PA.aim_word("left_ribs") != "Her left ribs!":
		ok = false
	if PA.aim_word("right_ribs") != "Her right ribs!":
		ok = false
	if PA.aim_word("head_hurt") != "Finish the head!":
		ok = false
	if PA.aim_word("bogus") != "":
		ok = false
	_check(ok, "test 9: pace_word / aim_word")


## 10. offers.
func _test10() -> void:
	var ok := true
	var o1: Array = PA.offers({})
	if o1 != ["", "head", "body"]:
		ok = false
	var o2: Array = PA.offers({"right_ribs": true, "head": true})
	if o2 != ["", "head", "body", "right_ribs", "head_hurt"]:
		ok = false
	var o3: Array = PA.offers({"left_ribs": false})
	if o3 != ["", "head", "body"]:
		ok = false
	_check(ok, "test 10: offers")


## 11. Trade: push > steady > save (net) over 6 exchanges.
func _test11() -> void:
	var ok := true
	var base_spend := 5.0
	var n := 6
	var push_s: float = n * base_spend * PA.spend("push")
	var steady_s: float = n * base_spend * PA.spend("steady")
	var save_s: float = n * (base_spend * PA.spend("save") - PA.recover("save"))
	if not (push_s > steady_s):
		ok = false
	if not (steady_s > save_s):
		ok = false
	var push_e: float = PA.edge("push", "", {}, {})
	var steady_e: float = PA.edge("steady", "", {}, {})
	var save_e: float = PA.edge("save", "", {}, {})
	if not (push_e > steady_e):
		ok = false
	if not (steady_e > save_e):
		ok = false
	_check(ok, "test 11: pace trade push > steady > save")


## 12. BodyLoad agrees: push ends higher than save on every worked part.
func _build_exchange(rn: int, seed: int) -> Array:
	var rd: Dictionary = {"n": rn, "won": true, "mine": 60.0, "theirs": 40.0, "corner": "",
		"lines": [], "names": ["Lucy", "Maria"]}
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


func _test12() -> void:
	var ok := true
	for s in 50:
		var seed_val: int = s * 1000 + 100
		var beats: Array = _build_exchange(1, seed_val)
		var l_push: Dictionary = BL.fresh()
		BL.add_exchange(l_push, beats.duplicate(true),
			{"sit": "press", "pace": {"a": "push", "b": "steady"}, "tank": {"a": 80.0, "b": 80.0}})
		var l_save: Dictionary = BL.fresh()
		BL.add_exchange(l_save, beats.duplicate(true),
			{"sit": "press", "pace": {"a": "save", "b": "steady"}, "tank": {"a": 80.0, "b": 80.0}})
		for p in BL.PARTS:
			var pv: float = BL.burn(l_push, "a", p)
			var sv: float = BL.burn(l_save, "a", p)
			if pv > 0.0:
				if pv <= sv + 0.001:
					ok = false
		if not ok:
			break
	_check(ok, "test 12: BodyLoad push > save on every worked part of 'a'")


## 13. Determinism.
func _test13() -> void:
	var ok := true
	for i in 100:
		var pace: String = PA.PACES[i % PA.PACES.size()]
		var aim: String = PA.AIMS[i % PA.AIMS.size()]
		var hurt: Dictionary = {"left_ribs": (i % 2) == 0, "head": (i % 3) == 0}
		var burn_d: Dictionary = {"core": float(i), "legs": float(i % 2) * 50.0}
		var e1: float = PA.edge(pace, aim, hurt, burn_d)
		var e2: float = PA.edge(pace, aim, hurt, burn_d)
		if not is_equal_approx(e1, e2):
			ok = false
		var d1: float = PA.damage(aim, "left_ribs", hurt)
		var d2: float = PA.damage(aim, "left_ribs", hurt)
		if not is_equal_approx(d1, d2):
			ok = false
		var o1: Array = PA.offers(hurt)
		var o2: Array = PA.offers(hurt)
		if o1 != o2:
			ok = false
	_check(ok, "test 13: determinism")
