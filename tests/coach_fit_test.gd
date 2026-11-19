extends SceneTree
## CoachFit test: pure module + test, no Godot needed for parse.
## Map: DESIGN_COACHFIT1_V8 2.1,2.2,3.3,3.4,4.1,5.2,6.1

const CoachFit := preload("res://scripts/rules/CoachFit.gd")

var checks: int = 0
var failures: int = 0


func _initialize() -> void:
	_test_neutral()
	_test_gain_tired()
	_test_time_penalty()
	_test_bond_step()
	_test_temper_part()
	_test_teach_polish_fork()
	_test_taught_out()
	_test_focus()
	_test_clamp()
	_test_words()
	_test_capped()
	_test_ceilings()
	_test_coach_time()
	_test_next_week()
	print("COACH_FIT checks=%d failures=%d" % [checks, failures])
	quit(1 if failures > 0 else 0)


func _check(cond: bool, label: String) -> void:
	checks += 1
	if not cond:
		failures += 1
		print("  FAIL: %s" % label)


func _boxer(morale_word: String, coachability: int, share: float) -> Dictionary:
	return {"morale_word": morale_word, "coachability": coachability, "cards_known_share": share}


func _test_neutral() -> void:
	var f: int = CoachFit.fit({})
	_check(f == 50, "fit 50 equals today exactly (fit({})==50 got %d)" % f)
	var gm: float = CoachFit.gain_mult(50)
	_check(is_equal_approx(gm, 1.0), "fit 50 equals today exactly: gain 1.0")
	var tm: float = CoachFit.tired_mult(50)
	_check(is_equal_approx(tm, 1.0), "fit 50 equals today exactly: tired 1.0")
	_check(CoachFit.NEUTRAL == 50, "NEUTRAL 50")
	_check(CoachFit.FIT_MIN == 10 and CoachFit.FIT_MAX == 90, "limits 10 and 90")


func _test_gain_tired() -> void:
	var g10: float = CoachFit.gain_mult(10)
	_check(is_equal_approx(g10, 0.60), "gain_mult 10 ->0.60 got %.3f" % g10)
	var g82: float = CoachFit.gain_mult(82)
	_check(is_equal_approx(g82, 1.32), "gain_mult 82 ->1.32 got %.3f" % g82)
	var t10: float = CoachFit.tired_mult(10)
	_check(is_equal_approx(t10, 1.08), "tired_mult 10 ->1.08 (S529 clamp) got %.3f" % t10)
	var t82: float = CoachFit.tired_mult(82)
	_check(is_equal_approx(t82, 0.92), "tired_mult 82 ->0.92 got %.3f" % t82)
	_check(is_equal_approx(CoachFit.gain_mult(50), 1.0), "gain 50 ==1.0")


func _test_time_penalty() -> void:
	_check(CoachFit.time_penalty(0.5) == 0, "time_penalty 0.5 ->0")
	_check(CoachFit.time_penalty(0.6) == -8, "time_penalty 0.6 ->-8")
	_check(CoachFit.time_penalty(1.5) == -8, "time_penalty 1.5 ->-8")
	_check(CoachFit.time_penalty(1.6) == -18, "time_penalty 1.6 ->-18")
	_check(CoachFit.time_penalty(2.0) == -18, "time_penalty 2.0 ->-18")
	_check(CoachFit.time_penalty(0.0) == 0, "time_penalty 0 ->0")
	_check(CoachFit.OVER_FREE == 0.5, "OVER_FREE 0.5")
	_check(CoachFit.OVER_MID == 1.5, "OVER_MID 1.5")
	_check(CoachFit.PEN_MID == -8, "PEN_MID -8")
	_check(CoachFit.PEN_HIGH == -18, "PEN_HIGH -18")


func _test_bond_step() -> void:
	var bs0: Dictionary = CoachFit.bond_step(0.0)
	var w0: String = str(bs0.get("word", ""))
	var f0: int = int(bs0.get("fit", 99))
	_check(w0 == "Stranger" and f0 == -4, "bond_step 0 Stranger -4")
	var bs79: Dictionary = CoachFit.bond_step(7.9)
	_check(str(bs79.get("word", "")) == "Stranger", "bond_step 7.9 Stranger")
	var bs8: Dictionary = CoachFit.bond_step(8.0)
	var w8: String = str(bs8.get("word", ""))
	var f8: int = int(bs8.get("fit", 99))
	_check(w8 == "Working" and f8 == 0, "bond_step 8 Working 0")
	var bs45: Dictionary = CoachFit.bond_step(45.0)
	var w45: String = str(bs45.get("word", ""))
	var f45: int = int(bs45.get("fit", 99))
	_check(w45 == "Trusted" and f45 == 6, "bond_step 45 Trusted 6")
	var bs110: Dictionary = CoachFit.bond_step(110.0)
	var w110: String = str(bs110.get("word", ""))
	var f110: int = int(bs110.get("fit", 99))
	_check(w110 == "Corner" and f110 == 12, "bond_step 110 Corner 12")
	var p_evening: Dictionary = {"bond": 0.0, "evening": true}
	var f_evening: int = CoachFit.fit(p_evening)
	_check(f_evening == 46, "Stranger even -4 fit 46 got %d" % f_evening)
	var p_morning: Dictionary = {"bond": 0.0, "evening": false}
	var f_morning: int = CoachFit.fit(p_morning)
	_check(f_morning == 50, "Stranger morn 0 fit 50 got %d" % f_morning)
	_check(CoachFit.STRANGER_EVENINGS_ONLY == true, "evenings only true")


func _test_temper_part() -> void:
	var b_flat: Dictionary = _boxer("Flat", 50, 0.5)
	var tp_mot_lift: int = CoachFit.temper_part("motivator", "lift", b_flat)
	_check(tp_mot_lift == 10, "Motivator+LIFT Flat +10 got %d" % tp_mot_lift)
	var b_low: Dictionary = _boxer("Low", 50, 0.5)
	_check(CoachFit.temper_part("motivator", "lift", b_low) == 10, "Motivator LIFT Low +10")
	var b_steady: Dictionary = _boxer("Steady", 80, 0.9)
	_check(CoachFit.temper_part("motivator", "lift", b_steady) == 0, "Motivator Steady 0")
	var b_tech: Dictionary = _boxer("Steady", 20, 0.2)
	_check(CoachFit.temper_part("technician", "polish", b_tech) == -12, "Tech 20 POLISH -12")
	_check(CoachFit.temper_part("steady", "", b_flat) == 0, "Steady 0 (S529 sheet)")
	_check(CoachFit.temper_part("steady", "lift", b_flat) == 0, "Steady ign mode")
	_check(CoachFit.temper_part("", "", {}) == 0, "unknown temper 0")
	var mid: Dictionary = _boxer("Steady", 50, 0.5)
	_check(CoachFit.temper_part("technician", "", mid) == 0, "tech mid 0")


func _test_teach_polish_fork() -> void:
	var low: Dictionary = _boxer("Steady", 50, 0.2)
	var high: Dictionary = _boxer("Steady", 50, 0.9)
	_check(CoachFit.temper_part("technician", "teach", low) == 4, "TEACH 0.2 +4")
	_check(CoachFit.temper_part("technician", "polish", low) == -4, "POLISH 0.2 -4")
	_check(CoachFit.temper_part("technician", "teach", high) == -4, "TEACH 0.9 -4")
	_check(CoachFit.temper_part("technician", "polish", high) == 4, "POLISH 0.9 +4")
	var mid: Dictionary = _boxer("Steady", 50, 0.5)
	_check(CoachFit.temper_part("technician", "polish", mid) == -4, "POLISH 0.5 -4")
	_check(CoachFit.temper_part("technician", "teach", mid) == -4, "TEACH 0.5 -4")


func _test_taught_out() -> void:
	var p1: Dictionary = {"mastery_or_stat": 70.0, "ceiling": 74.0}
	_check(CoachFit.fit(p1) == 44, "taught 70/74 -6 fit44 got %d" % CoachFit.fit(p1))
	var p2: Dictionary = {"mastery_or_stat": 68.0, "ceiling": 74.0}
	_check(CoachFit.fit(p2) == 50, "taught 68/74 0 fit50 got %d" % CoachFit.fit(p2))
	var p3: Dictionary = {"mastery_or_stat": 74.0, "ceiling": 74.0}
	_check(CoachFit.fit(p3) == 50, "at ceiling 74 fit50 got %d" % CoachFit.fit(p3))
	_check(is_equal_approx(CoachFit.ceiling_mult(74.0, 74.0), 0.5), "ceil >= 0.5")
	_check(is_equal_approx(CoachFit.ceiling_mult(73.9, 74.0), 1.0), "ceil below 1.0")
	_check(CoachFit.TAUGHT_OUT == -6, "TAUGHT_OUT -6")
	_check(CoachFit.TAUGHT_OUT_WITHIN == 5, "WITHIN 5")


func _test_focus() -> void:
	var p_this: Dictionary = {"focus": "this", "evening": false}
	_check(CoachFit.fit(p_this) == 60, "focus this +10 got %d" % CoachFit.fit(p_this))
	var p_other: Dictionary = {"focus": "other", "evening": false}
	_check(CoachFit.fit(p_other) == 47, "focus other -3 got %d" % CoachFit.fit(p_other))
	var p_eve: Dictionary = {"focus": "this", "evening": true, "bond": 8.0}
	_check(CoachFit.fit(p_eve) == 50, "focus eve 0 got %d" % CoachFit.fit(p_eve))
	_check(CoachFit.FOCUS_MORNING == 10, "FOCUS_MORNING 10")
	_check(CoachFit.FOCUS_OTHER_MORNING == -3, "FOCUS_OTHER -3")


func _test_clamp() -> void:
	var low: Dictionary = {
		"temper": "technician",
		"mode": "teach",
		"boxer": _boxer("Steady", 10, 0.9),
		"over": 2.0,
		"bond": 0.0,
		"evening": true,
		"mastery_or_stat": 70.0,
		"ceiling": 74.0,
		"focus": "other"
	}
	_check(CoachFit.fit(low) == 10, "clamp low 10 got %d" % CoachFit.fit(low))
	_check(CoachFit.FIT_MAX == 90, "FIT_MAX 90")
	_check(CoachFit.FIT_MIN == 10, "FIT_MIN 10")
	_check(clampi(100, CoachFit.FIT_MIN, CoachFit.FIT_MAX) == 90, "clamp>90 90")
	_check(clampi(5, CoachFit.FIT_MIN, CoachFit.FIT_MAX) == 10, "clamp<10 10")
	var high: Dictionary = {
		"temper": "motivator",
		"mode": "lift",
		"boxer": _boxer("Flat", 50, 0.5),
		"over": 0.0,
		"bond": 110.0,
		"evening": false,
		"focus": "this"
	}
	var fh: int = CoachFit.fit(high)
	_check(fh == 82, "max fit 82 got %d" % fh)
	_check(fh <= CoachFit.FIT_MAX, "high <=90")


func _test_words() -> void:
	_check(CoachFit.word(75) == "TOP FIT", "word 75 TOP FIT")
	_check(CoachFit.word(74) == "GOOD", "word 74 GOOD")
	_check(CoachFit.word(58) == "GOOD", "word 58 GOOD")
	_check(CoachFit.word(57) == "MIXED", "word 57 MIXED")
	_check(CoachFit.word(40) == "MIXED", "word 40 MIXED")
	_check(CoachFit.word(39) == "RISKY", "word 39 RISKY")
	_check(CoachFit.word(90) == "TOP FIT", "word 90 TOP FIT")
	_check(CoachFit.word(10) == "RISKY", "word 10 RISKY")


func _test_capped() -> void:
	var c1: Dictionary = CoachFit.capped(1.32, 1.35)
	_check(is_equal_approx(float(c1.get("mult", 0.0)), 1.6), "capped 1.32x1.35 1.6")
	_check(bool(c1.get("capped", false)) == true, "capped true")
	var c2: Dictionary = CoachFit.capped(1.0, 1.2)
	_check(is_equal_approx(float(c2.get("mult", 0.0)), 1.2), "capped 1.0x1.2 1.2")
	_check(bool(c2.get("capped", true)) == false, "capped false")
	_check(CoachFit.STACK_CAP == 1.6, "STACK_CAP 1.6")


func _test_ceilings() -> void:
	_check(CoachFit.morning_ceiling(58.0) == 75, "morn 58 75 got %d" % CoachFit.morning_ceiling(58.0))
	_check(CoachFit.morning_ceiling(90.0) == 86, "morn 90 86 got %d" % CoachFit.morning_ceiling(90.0))
	_check(CoachFit.evening_ceiling(74.9) == 74, "eve 74.9 74 got %d" % CoachFit.evening_ceiling(74.9))
	_check(CoachFit.evening_ceiling(74.0) == 74, "eve 74.0 74")


func _test_coach_time() -> void:
	var one: Array = ["pads", "pads", "pads", "spar"]
	_check(is_equal_approx(CoachFit.week_cost(one), 4.5), "one box 4.5")
	var two: Array = ["pads", "pads", "pads", "spar", "pads", "pads", "pads", "spar"]
	_check(is_equal_approx(CoachFit.week_cost(two), 9.0), "two box 9.0")
	var o105: float = CoachFit.over("sessional", 10.5, 0.0)
	_check(is_equal_approx(o105, 0.5), "over 10.5 0.5 got %.2f" % o105)
	_check(CoachFit.time_penalty(o105) == 0, "pen 0.5 0")
	var o11: float = CoachFit.over("sessional", 11.0, 0.0)
	_check(is_equal_approx(o11, 1.0), "over 11.0 1.0 got %.2f" % o11)
	_check(CoachFit.time_penalty(o11) == -8, "pen 1.0 -8")
	var ofull: float = CoachFit.over("fulltime", 11.0, 0.0)
	_check(ofull < 0.0, "fulltime 11 <0 got %.2f" % ofull)
	_check(CoachFit.can_take("sessional", 12.0, 0.0) == true, "can 12.0 true")
	_check(CoachFit.can_take("sessional", 12.1, 0.0) == false, "can 12.1 false")
	_check(is_equal_approx(CoachFit.week_cost(["unknown_id"]), 0.0), "unknown 0")
	_check(CoachFit.COACH_TIME["sessional"] == 10.0, "COACH_TIME 10")


func _test_next_week() -> void:
	var nxt: float = CoachFit.next_week_time("sessional", 1.0, false)
	_check(is_equal_approx(nxt, 9.0), "next over1 9.0 got %.2f" % nxt)
	var rested: float = CoachFit.next_week_time("sessional", 1.0, true)
	_check(is_equal_approx(rested, 13.0), "next rested 13 got %.2f" % rested)
	var neg: float = CoachFit.next_week_time("sessional", -1.0, false)
	_check(is_equal_approx(neg, 10.0), "next neg stays 10 got %.2f" % neg)
