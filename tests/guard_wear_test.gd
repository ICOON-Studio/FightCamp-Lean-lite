extends SceneTree
## GUARDWEAR1 - tests for GuardWear pure rules (guard damage v4).
## Run: godot --headless --audio-driver Dummy --fixed-fps 60 --path . --script res://tests/guard_wear_test.gd

const GW := preload("res://scripts/rules/GuardWear.gd")

var failures := 0


func _initialize() -> void:
	_transmission()
	_wear()
	_shoulder()
	_posture()
	_recovery()
	_max_and_traits()
	_parry()
	_scoring()
	_colour()
	print("GUARD_WEAR failures=%d" % failures)
	quit(0 if failures == 0 else 1)


func _check(ok: bool, what: String) -> void:
	print(("ok  " if ok else "FAIL ") + what)
	if not ok:
		failures += 1


func _eq(a: float, b: float) -> bool:
	return absf(a - b) < 0.0001


func _transmission() -> void:
	var t1: float = GW.transmission("jab", 100.0, 100.0, "middle", 1)
	_check(_eq(t1, 0.25), "transmission full guard jab 0.25 (got %.4f)" % t1)
	var t2: float = GW.transmission("power", 50.0, 100.0, "middle", 1)
	_check(_eq(t2, 0.6375), "transmission half guard power 0.6375 (got %.4f)" % t2)
	var t3: float = GW.transmission("heavy", 0.0, 100.0, "middle", 1)
	_check(_eq(t3, 0.80), "transmission empty heavy capped 0.80 (got %.4f)" % t3)
	var t4: float = GW.transmission("jab", 120.0, 120.0, "heavy", 1)
	_check(_eq(t4, 0.325), "transmission heavy class jab at full 0.325 (got %.4f)" % t4)
	var t5: float = GW.transmission("jab", 80.0, 80.0, "light", 1)
	_check(_eq(t5, 0.225), "transmission light class jab at full 0.225 (got %.4f)" % t5)
	var t6: float = GW.transmission("jab", 50.0, 100.0, "middle", 1)
	_check(_eq(t6, 0.375), "transmission half guard jab 0.375 (got %.4f)" % t6)
	var t7: float = GW.transmission("power", 100.0, 100.0, "middle", 1)
	_check(_eq(t7, 0.425), "transmission full guard power 0.425 (got %.4f)" % t7)
	var t8: float = GW.transmission("heavy", 100.0, 100.0, "middle", 1)
	_check(_eq(t8, 0.55), "transmission full guard heavy 0.55 (got %.4f)" % t8)
	var t9: float = GW.transmission("jab", 100.0, 100.0, "middle", 2)
	_check(_eq(t9, 0.25), "transmission second punch no combo (got %.4f)" % t9)
	var t10: float = GW.transmission("jab", 100.0, 100.0, "middle", 3)
	_check(_eq(t10, 0.375), "transmission third punch x1.5 (got %.4f)" % t10)
	var t11: float = GW.transmission("heavy", 0.0, 120.0, "heavy", 3)
	_check(_eq(t11, 0.80), "transmission cap wins over class and combo (got %.4f)" % t11)
	var t12: float = GW.transmission("mystery", 100.0, 100.0, "middle", 1)
	_check(_eq(t12, 0.25), "transmission unknown kind counts as jab (got %.4f)" % t12)
	var t13: float = GW.transmission("jab", 100.0, 100.0, "mystery", 1)
	_check(_eq(t13, 0.25), "transmission unknown class counts as middle (got %.4f)" % t13)
	# Mutant arm: empty heavy must be exactly 0.80. With a 0.85 cap the uncapped 1.10
	# would read 0.85 and this check would fail, so the cap is pinned.
	var t14: float = GW.transmission("heavy", 0.0, 100.0, "middle", 1)
	_check(_eq(t14, 0.80) and not _eq(t14, 0.85), "mutant cap 0.85 would fail empty heavy (got %.4f)" % t14)
	var rng: RandomNumberGenerator = RandomNumberGenerator.new()
	rng.seed = 12345
	var kinds: Array = ["jab", "power", "heavy"]
	var classes: Array = ["light", "middle", "heavy"]
	var sweep_ok: bool = true
	var sweep_worst: float = 0.0
	for i in 1000:
		var kind: String = str(kinds[rng.randi_range(0, 2)])
		var wclass: String = str(classes[rng.randi_range(0, 2)])
		var max_g: float = GW.max_guard(wclass, false)
		var guard: float = rng.randf() * max_g
		var combo_n: int = rng.randi_range(0, 5)
		var v: float = GW.transmission(kind, guard, max_g, wclass, combo_n)
		if v < 0.0 or v > 0.80:
			sweep_ok = false
		sweep_worst = maxf(sweep_worst, v)
	_check(sweep_ok, "transmission sweep 1000 random stays 0..0.80 (worst %.4f)" % sweep_worst)
	_check(_eq(float(GW.TRANS_JAB), 0.25) and _eq(float(GW.TRANS_CAP), 0.80), "constants TRANS_JAB 0.25 TRANS_CAP 0.80")


func _wear() -> void:
	var w1: float = GW.wear("jab", 1, {})
	_check(_eq(w1, 1.0), "wear base jab 1 (got %.4f)" % w1)
	var w2: float = GW.wear("power", 1, {})
	_check(_eq(w2, 3.0), "wear base power 3 (got %.4f)" % w2)
	var w3: float = GW.wear("heavy", 1, {})
	_check(_eq(w3, 5.0), "wear base heavy 5 (got %.4f)" % w3)
	var w4: float = GW.wear("jab", 2, {})
	_check(_eq(w4, 1.0), "wear second punch no combo (got %.4f)" % w4)
	var w5: float = GW.wear("jab", 3, {})
	_check(_eq(w5, 1.5), "wear third punch x1.5 (got %.4f)" % w5)
	var w6: float = GW.wear("power", 3, {})
	_check(_eq(w6, 4.5), "wear power third punch 4.5 (got %.4f)" % w6)
	var w7: float = GW.wear("jab", 1, {"ropes": true})
	_check(_eq(w7, 1.12), "wear ropes +12%% (got %.4f)" % w7)
	var w8: float = GW.wear("jab", 1, {"moving": true})
	_check(_eq(w8, 0.95), "wear moving -5%% (got %.4f)" % w8)
	var w9: float = GW.wear("jab", 1, {"condition": 60.0})
	_check(_eq(w9, 1.10), "wear condition 60 +10%% (got %.4f)" % w9)
	var w10: float = GW.wear("jab", 1, {"condition": 70.0})
	_check(_eq(w10, 1.0), "wear condition 70 no cut (got %.4f)" % w10)
	var w11: float = GW.wear("jab", 1, {"condition": 80.0})
	_check(_eq(w11, 1.0), "wear condition 80 no cut (got %.4f)" % w11)
	var w12: float = GW.wear("jab", 1, {"missed_weight": true})
	_check(_eq(w12, 1.18), "wear missed weight +18%% (got %.4f)" % w12)
	var w13: float = GW.wear("jab", 1, {"missed_weight": true, "condition": 60.0})
	_check(_eq(w13, 1.18), "wear missed weight instead of condition (got %.4f)" % w13)
	var w14: float = GW.wear("jab", 1, {"posture": "high"})
	_check(_eq(w14, 1.08), "wear posture high +8%% (got %.4f)" % w14)
	var w15: float = GW.wear("jab", 1, {"posture": "low"})
	_check(_eq(w15, 1.0), "wear posture low no cut (got %.4f)" % w15)
	var w16: float = GW.wear("jab", 1, {"amateur": true})
	_check(_eq(w16, 1.15), "wear amateur +15%% (got %.4f)" % w16)
	var w17: float = GW.wear("jab", 1, {"shoulder": 65.0})
	_check(_eq(w17, 0.88), "wear shoulder 65 -12%% (got %.4f)" % w17)
	var w18: float = GW.wear("jab", 1, {"shoulder": 80.0})
	_check(_eq(w18, 0.80), "wear shoulder 80 -20%% (got %.4f)" % w18)
	var w19: float = GW.wear("jab", 1, {"shoulder": 50.0})
	_check(_eq(w19, 1.0), "wear shoulder 50 no cut (got %.4f)" % w19)
	var w20: float = GW.wear("jab", 1, {"trait": "slow_starter", "round_n": 1})
	_check(_eq(w20, 0.88), "wear trait slow starter round 1 -12%% (got %.4f)" % w20)
	var w21: float = GW.wear("jab", 1, {"trait": "slow_starter", "round_n": 3})
	_check(_eq(w21, 1.12), "wear trait slow starter round 3 +12%% (got %.4f)" % w21)
	var w22: float = GW.wear("jab", 1, {"trait": "other_trait", "round_n": 1})
	_check(_eq(w22, 1.0), "wear other trait no cut (got %.4f)" % w22)
	var w23: float = GW.wear("jab", 1, {"ropes": true, "amateur": true})
	_check(_eq(w23, 1.27), "wear percents add not compound 1.27 (got %.4f)" % w23)
	var w24: float = GW.wear("jab", 1, {"ropes": true, "moving": true})
	_check(_eq(w24, 1.07), "wear ropes plus moving 1.07 (got %.4f)" % w24)
	var ctx_neg: Dictionary = {"moving": true, "shoulder": 100.0, "trait": "slow_starter", "round_n": 1}
	var w25: float = GW.wear("jab", 1, ctx_neg)
	_check(_eq(w25, 0.58) and w25 >= 0.5, "wear all negatives factor 0.58 floor 0.5 (got %.4f)" % w25)
	var w26: float = GW.wear("power", 3, {"ropes": true})
	_check(_eq(w26, 5.04), "wear power combo plus ropes 5.04 (got %.4f)" % w26)
	var w27: float = GW.wear("mystery", 1, {})
	_check(_eq(w27, 1.0), "wear unknown kind counts as jab (got %.4f)" % w27)


func _shoulder() -> void:
	var s1: float = GW.shoulder(70.0, 50.0)
	_check(_eq(s1, 64.0), "shoulder 70 50 = 64 (got %.4f)" % s1)
	var s2: float = GW.shoulder(100.0, 100.0)
	_check(_eq(s2, 100.0), "shoulder 100 100 = 100 (got %.4f)" % s2)
	var s3: float = GW.shoulder(0.0, 0.0)
	_check(_eq(s3, 0.0), "shoulder 0 0 = 0 (got %.4f)" % s3)
	var p1: float = GW.shoulder_wear_pct(50.0)
	_check(_eq(p1, 0.0), "shoulder wear 50 = 0 (got %.4f)" % p1)
	var p2: float = GW.shoulder_wear_pct(65.0)
	_check(_eq(p2, -0.12), "shoulder wear 65 = -12%% exactly (got %.4f)" % p2)
	var p3: float = GW.shoulder_wear_pct(80.0)
	_check(_eq(p3, -0.20), "shoulder wear 80 = -20%% (got %.4f)" % p3)
	var p4: float = GW.shoulder_wear_pct(57.5)
	_check(_eq(p4, -0.06), "shoulder wear 57.5 = -6%% (got %.4f)" % p4)
	var p5: float = GW.shoulder_wear_pct(72.5)
	_check(_eq(p5, -0.16), "shoulder wear 72.5 = -16%% (got %.4f)" % p5)
	var p6: float = GW.shoulder_wear_pct(85.0)
	_check(_eq(p6, -0.2266667), "shoulder wear 85 slope (got %.4f)" % p6)
	var p7: float = GW.shoulder_wear_pct(90.0)
	_check(_eq(p7, -0.25), "shoulder wear 90 floor -25%% (got %.4f)" % p7)
	var p8: float = GW.shoulder_wear_pct(100.0)
	_check(_eq(p8, -0.25), "shoulder wear 100 floor -25%% (got %.4f)" % p8)
	var p9: float = GW.shoulder_wear_pct(30.0)
	_check(_eq(p9, 0.0), "shoulder wear 30 = 0 (got %.4f)" % p9)


func _posture() -> void:
	_check(_eq(GW.posture_damage("high", "head"), 0.80), "posture high head 0.80")
	_check(_eq(GW.posture_damage("high", "body"), 1.15), "posture high body 1.15")
	_check(_eq(GW.posture_damage("low", "head"), 1.15), "posture low head 1.15")
	_check(_eq(GW.posture_damage("low", "body"), 0.80), "posture low body 0.80")
	_check(_eq(GW.posture_damage("neutral", "head"), 1.0), "posture neutral head 1.0")
	_check(_eq(GW.posture_damage("neutral", "body"), 1.0), "posture neutral body 1.0")
	_check(_eq(GW.posture_damage("peekaboo", "head"), 1.0), "posture peekaboo head neutral")
	_check(_eq(GW.posture_damage("peekaboo", "body"), 1.0), "posture peekaboo body neutral")
	_check(_eq(GW.posture_damage("mystery", "head"), 1.0), "posture unknown neutral")


func _recovery() -> void:
	_check(_eq(GW.in_round(0, false), 3.0), "in round 0 pro +3")
	_check(_eq(GW.in_round(0, true), 4.0), "in round 0 amateur +4")
	_check(_eq(GW.in_round(1, false), 1.0), "in round 1 +1")
	_check(_eq(GW.in_round(2, false), 1.0), "in round 2 +1")
	_check(_eq(GW.in_round(3, false), 0.0), "in round 3 +0")
	_check(_eq(GW.in_round(5, true), 0.0), "in round 5 amateur +0")
	_check(_eq(GW.in_round(1, true), 1.0), "in round 1 amateur +1")
	var d1: Dictionary = GW.clinch(false, 40.0, 100.0, false)
	var ok1: bool = bool(d1.get("ok", false))
	var g1: float = float(d1.get("guard", 0.0))
	var st1: float = float(d1.get("stamina", 0.0))
	var fe1: bool = bool(d1.get("free_exchange", false))
	_check(ok1 and _eq(g1, 10.0) and _eq(st1, -10.0) and fe1, "clinch allowed under half guard +10 -10 free")
	var d2: Dictionary = GW.clinch(true, 40.0, 100.0, false)
	var g2: float = float(d2.get("guard", 0.0))
	_check(bool(d2.get("ok", false)) and _eq(g2, 13.0), "clinch skilled +13 (got %.4f)" % g2)
	var d3: Dictionary = GW.clinch(false, 60.0, 100.0, false)
	var why3: String = str(d3.get("why", ""))
	_check(not bool(d3.get("ok", false)) and why3 != "", "clinch refused at 60%% guard")
	var d4: Dictionary = GW.clinch(false, 50.0, 100.0, false)
	_check(not bool(d4.get("ok", false)), "clinch refused at exactly half guard")
	var d5: Dictionary = GW.clinch(false, 40.0, 100.0, true)
	_check(not bool(d5.get("ok", false)), "clinch refused on second try in round")
	_check(_eq(GW.corner([], false, false), 15.0), "corner base +15")
	_check(_eq(GW.corner(["hands_up"], false, false), 20.0), "corner hands up +5")
	_check(_eq(GW.corner([], true, false), 20.0), "corner good cutman no cut +5")
	_check(_eq(GW.corner([], true, true), 15.0), "corner good cutman with cut no bonus")
	_check(_eq(GW.corner(["back_off"], false, false), 35.0), "corner back off +20")
	_check(_eq(GW.corner(["hands_up", "back_off"], true, false), 45.0), "corner all calls +45")
	_check(_eq(GW.clamp_guard(120.0, 100.0), 100.0), "clamp guard over max")
	_check(_eq(GW.clamp_guard(-5.0, 100.0), 0.0), "clamp guard under zero")
	_check(_eq(GW.clamp_guard(50.0, 100.0), 50.0), "clamp guard inside")
	_check(_eq(GW.clamp_guard(50.0, 0.0), 0.0), "clamp guard zero max")


func _max_and_traits() -> void:
	_check(_eq(GW.max_guard("light", false), 80.0), "max guard light pro 80")
	_check(_eq(GW.max_guard("middle", false), 100.0), "max guard middle pro 100")
	_check(_eq(GW.max_guard("heavy", false), 120.0), "max guard heavy pro 120")
	_check(_eq(GW.max_guard("light", true), 70.0), "max guard light amateur 70")
	_check(_eq(GW.max_guard("middle", true), 70.0), "max guard middle amateur 70")
	_check(_eq(GW.max_guard("heavy", true), 70.0), "max guard heavy amateur 70")
	_check(_eq(GW.trait_wear_pct("slow_starter", 1), -0.12), "trait wear slow starter round 1 -12%%")
	_check(_eq(GW.trait_wear_pct("slow_starter", 2), -0.12), "trait wear slow starter round 2 -12%%")
	_check(_eq(GW.trait_wear_pct("slow_starter", 3), 0.12), "trait wear slow starter round 3 +12%%")
	_check(_eq(GW.trait_wear_pct("slow_starter", 5), 0.12), "trait wear slow starter round 5 +12%%")
	_check(_eq(GW.trait_wear_pct("other_trait", 1), 0.0), "trait wear other 0")
	_check(_eq(GW.trait_recovery_pct("fades_late", 5, 80.0), -0.25), "trait recovery fades late round 5 -25%%")
	_check(_eq(GW.trait_recovery_pct("fades_late", 4, 80.0), 0.0), "trait recovery fades late round 4 0")
	_check(_eq(GW.trait_recovery_pct("chases_stoppage", 1, 80.0), -0.10), "trait recovery chases -10%%")
	_check(_eq(GW.trait_recovery_pct("other_trait", 1, 30.0), -0.20), "trait recovery morale low -20%%")
	_check(_eq(GW.trait_recovery_pct("fades_late", 5, 30.0), -0.45), "trait recovery fades plus morale -45%%")
	_check(_eq(GW.trait_recovery_pct("chases_stoppage", 1, 30.0), -0.30), "trait recovery chases plus morale -30%%")
	_check(_eq(GW.trait_recovery_pct("other_trait", 1, 80.0), 0.0), "trait recovery other morale high 0")


func _parry() -> void:
	_check(_eq(GW.parry_chance("jab", 50.0), 0.70), "parry jab defence 50 0.70")
	_check(_eq(GW.parry_chance("jab", 100.0), 0.80), "parry jab defence 100 0.80")
	_check(_eq(GW.parry_chance("cross", 50.0), 0.55), "parry cross 0.55")
	_check(_eq(GW.parry_chance("hook", 50.0), 0.40), "parry hook 0.40")
	_check(_eq(GW.parry_chance("uppercut", 50.0), 0.35), "parry uppercut 0.35")
	_check(_eq(GW.parry_chance("jab", 49.0), 0.0), "parry defence 49 zero")
	_check(_eq(GW.parry_chance("jab", 0.0), 0.0), "parry defence 0 zero")
	_check(_eq(GW.parry_chance("jab", 75.0), 0.75), "parry jab defence 75 0.75")
	_check(_eq(GW.parry_chance("jab", 200.0), 0.95), "parry clamp 0.95")
	_check(_eq(GW.parry_chance("mystery", 100.0), 0.0), "parry unknown kind zero")
	_check(_eq(float(GW.PARRY_WEAR), 0.3) and _eq(float(GW.PARRY_TRANSMISSION), 0.08), "constants PARRY_WEAR PARRY_TRANSMISSION")


func _scoring() -> void:
	_check(GW.blocked_strikes(0) == 0, "blocked strikes 0")
	_check(GW.blocked_strikes(2) == 0, "blocked strikes 2 = 0")
	_check(GW.blocked_strikes(3) == 1, "blocked strikes 3 = 1")
	_check(GW.blocked_strikes(5) == 1, "blocked strikes 5 = 1")
	_check(GW.blocked_strikes(6) == 2, "blocked strikes 6 = 2")
	_check(GW.blocked_strikes(9) == 3, "blocked strikes 9 = 3")


func _colour() -> void:
	_check(GW.colour(80.0, 100.0) == "green", "colour 80 green")
	_check(GW.colour(75.0, 100.0) == "green", "colour 75 green")
	_check(GW.colour(74.0, 100.0) == "yellow", "colour 74 yellow")
	_check(GW.colour(50.0, 100.0) == "yellow", "colour 50 yellow")
	_check(GW.colour(49.0, 100.0) == "orange", "colour 49 orange")
	_check(GW.colour(25.0, 100.0) == "orange", "colour 25 orange")
	_check(GW.colour(24.0, 100.0) == "red", "colour 24 red")
	_check(GW.colour(0.0, 100.0) == "red", "colour 0 red")
	_check(GW.colour(100.0, 100.0) == "green", "colour 100 green")
	_check(GW.word("green") == "Holding well", "word green Holding well")
	_check(GW.word("yellow") == "Arms tiring", "word yellow Arms tiring")
	_check(GW.word("orange") == "Leaking heavily", "word orange Leaking heavily")
	_check(GW.word("red") == "Arms dropping", "word red Arms dropping")
