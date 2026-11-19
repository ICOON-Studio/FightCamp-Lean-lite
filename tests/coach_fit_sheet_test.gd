extends SceneTree
## S529 COACHSCOPE1 phase 1: every number printed in ops/research/COACHFIT_SHEET.md, recomputed from the code
## (Arena's COACHFIT1 v9 10/10 item 1: "a RED test that asserts every example in that table"). A row of the sheet
## that changes must change here too. Pure: CoachFit + the live levers it joins (Exchanges.uptake, FighterProfile.TRUST,
## CoachedMornings, BoutRules camp protocols, WeekPlan).

const CoachFit := preload("res://scripts/rules/CoachFit.gd")
const Exchanges := preload("res://scripts/rules/Exchanges.gd")
const FighterProfile := preload("res://scripts/rules/FighterProfile.gd")
const CoachedMornings := preload("res://scripts/rules/CoachedMornings.gd")
const BoutRules := preload("res://scripts/rules/BoutRules.gd")
const WeekPlan := preload("res://scripts/rules/WeekPlan.gd")

var checks: int = 0
var failures: int = 0


func _initialize() -> void:
	_test_examples()
	_test_reach()
	_test_drift_clamp()
	_test_stack()
	_test_joined_levers()
	print("COACH_FIT_SHEET checks=%d failures=%d" % [checks, failures])
	quit(1 if failures > 0 else 0)


func _check(cond: bool, label: String) -> void:
	checks += 1
	if not cond:
		failures += 1
		print("  FAIL: %s" % label)


func _near(a: float, b: float) -> bool:
	return absf(a - b) < 0.0005


func _boxer(morale_word: String, coachability: int, share: float) -> Dictionary:
	return {"morale_word": morale_word, "coachability": coachability, "cards_known_share": share}


## Sheet section 2: the worked examples. [label, inputs, fit, gain, tired, word]
func _test_examples() -> void:
	var rows: Array = [
		["E1 steady coach, working bond, plain morning", {"temper": "steady", "bond": 8.0}, 50, 1.00, 1.00, "MIXED"],
		["E2 stranger on a morning", {"temper": "steady", "bond": 0.0, "evening": false}, 50, 1.00, 1.00, "MIXED"],
		["E3 technician teaching a coachable novice, trusted, focus morning",
			{"temper": "technician", "mode": "teach", "boxer": _boxer("Steady", 75, 0.3), "bond": 45.0, "focus": "this"},
			76, 1.26, 0.935, "TOP FIT"],
		["E4 motivator lifting a flat boxer, corner bond, focus morning",
			{"temper": "motivator", "mode": "lift", "boxer": _boxer("Flat", 50, 0.5), "bond": 110.0, "focus": "this"},
			82, 1.32, 0.92, "TOP FIT"],
		["E5 technician polishing an uncoachable novice, stranger, evening",
			{"temper": "technician", "mode": "polish", "boxer": _boxer("Steady", 25, 0.3), "bond": 0.0, "evening": true},
			34, 0.84, 1.04, "RISKY"],
		["E6 = E5 and taught out (mastery 60, ceiling 63)",
			{"temper": "technician", "mode": "polish", "boxer": _boxer("Steady", 25, 0.3), "bond": 0.0, "evening": true,
				"mastery_or_stat": 60.0, "ceiling": 63.0},
			28, 0.78, 1.055, "RISKY"],
		["E7 motivator with a steady boxer: nothing to lift",
			{"temper": "motivator", "mode": "lift", "boxer": _boxer("Steady", 50, 0.5), "bond": 8.0}, 50, 1.00, 1.00, "MIXED"],
	]
	for r in rows:
		var row: Array = r
		var fit: int = CoachFit.fit(row[1])
		_check(fit == int(row[2]), "%s: fit %d (got %d)" % [row[0], row[2], fit])
		_check(_near(CoachFit.gain_mult(fit), float(row[3])), "%s: gain x%.3f (got %.3f)" % [row[0], row[3], CoachFit.gain_mult(fit)])
		_check(_near(CoachFit.tired_mult(fit), float(row[4])), "%s: tired x%.3f (got %.3f)" % [row[0], row[4], CoachFit.tired_mult(fit)])
		_check(CoachFit.word(fit) == str(row[5]), "%s: word %s (got %s)" % [row[0], row[5], CoachFit.word(fit)])
	_check(CoachFit.morning_ceiling(74.0) == 80, "ceiling: morning, pads 74 -> 80")
	_check(CoachFit.evening_ceiling(74.0) == 74, "ceiling: evening, pads 74 -> 74")


## Sheet section 1 "reach": with no time penalty (the time rows are cut) fit spans 28..82 over every input the game has.
func _test_reach() -> void:
	var lo := 999
	var hi := -999
	for temper in ["steady", "motivator", "technician", ""]:
		for mode in ["", "lift", "polish", "teach"]:
			for mood in ["Fired up", "Steady", "Flat", "Low"]:
				for coach in [10, 50, 75]:
					for share in [0.2, 0.8]:
						for bond in [0.0, 8.0, 45.0, 110.0]:
							for evening in [false, true]:
								for focus in ["", "this", "other"]:
									for taught in [false, true]:
										var p := {"temper": temper, "mode": mode, "boxer": _boxer(mood, coach, share),
											"bond": bond, "evening": evening, "focus": focus}
										if taught:
											p["mastery_or_stat"] = 60.0
											p["ceiling"] = 63.0
										var f := CoachFit.fit(p)
										lo = mini(lo, f)
										hi = maxi(hi, f)
	_check(lo == 28, "reach: lowest fit 28 (got %d)" % lo)
	_check(hi == 82, "reach: highest fit 82 (got %d)" % hi)


## Sheet section 3: the tiredness drift 1.125 - 0.0025 x fit, held inside 0.92..1.08 (Arena item 3).
func _test_drift_clamp() -> void:
	_check(_near(CoachFit.tired_mult(50), 1.0), "drift: fit 50 -> 1.00")
	_check(_near(CoachFit.tired_mult(75), 0.9375), "drift: fit 75 -> 0.9375")
	_check(_near(CoachFit.tired_mult(35), 1.0375), "drift: fit 35 -> 1.0375")
	_check(_near(CoachFit.tired_mult(10), 1.08), "drift: fit 10 held at 1.08 (got %.3f)" % CoachFit.tired_mult(10))
	_check(_near(CoachFit.tired_mult(90), 0.92), "drift: fit 90 held at 0.92 (got %.3f)" % CoachFit.tired_mult(90))


## Sheet section 4: the stack. fit multiplies what the gain already gets today (coached morning x camp); the result is
## held at 1.6 unless today's product is already above 1.6 - a fit never lowers a gain the game gives today below today's
## with a neutral coach, and never lifts it past max(1.6, today).
func _test_stack() -> void:
	var c := CoachFit.capped(1.32, 1.0)
	_check(_near(float(c["mult"]), 1.32) and not bool(c["capped"]), "stack: TOP fit on a plain morning x1.32")
	c = CoachFit.capped(1.32, CoachedMornings.SOLO)
	_check(_near(float(c["mult"]), 1.6) and bool(c["capped"]), "stack: TOP fit on a 1-to-1 morning held at 1.6")
	var today: float = CoachedMornings.SOLO_WEAK * float(BoutRules.PROTOCOLS[3]["focus"])
	_check(_near(today, 1.89), "stack: weak-spot 1-to-1 in a Hard camp is x1.89 today")
	c = CoachFit.capped(1.32, today)
	_check(_near(float(c["mult"]), 1.89), "stack: TOP fit adds nothing past today's x1.89 (got %.3f)" % float(c["mult"]))
	c = CoachFit.capped(0.84, today)
	_check(_near(float(c["mult"]), 1.5876), "stack: a RISKY fit still costs on top of x1.89 (got %.4f)" % float(c["mult"]))
	c = CoachFit.capped(1.0, today)
	_check(_near(float(c["mult"]), 1.89), "stack: a neutral fit leaves today's x1.89 alone (got %.3f)" % float(c["mult"]))


## Sheet section 5: the channels fit does NOT enter (they stay exactly today's) and the live numbers they read.
func _test_joined_levers() -> void:
	_check(_near(Exchanges.uptake(75.0, 0), 0.925), "corner: coachability 75 takes in 0.925 of a shout")
	_check(_near(Exchanges.uptake(75.0, 0) * float(FighterProfile.TRUST["Flat"]), 0.78625), "corner: x Flat trust 0.85 = 0.786")
	_check(_near(float(FighterProfile.TRUST["Low"]), 0.7), "corner: Low trust is 0.7 (not a hard zero)")
	_check(_near(CoachedMornings.SOLO, 1.25) and _near(CoachedMornings.SHARED, 1.15) and _near(CoachedMornings.SOLO_WEAK, 1.4),
		"time: the coached-morning deal is x1.25 / x1.15 / x1.4 (ClubDeal owns the coach's hours)")
	_check(_near(WeekPlan.TIRED_GAIN, 0.6) and _near(WeekPlan.OVERREACHED, 80.0), "tiredness: overreached at 80 trains at x0.6")
	_check(CoachFit.temper_part("steady", "lift", _boxer("Flat", 80, 0.9)) == 0,
		"temper: no temper gives fit for nothing (Steady is the 0 baseline)")
