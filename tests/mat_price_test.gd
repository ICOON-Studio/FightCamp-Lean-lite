extends SceneTree
## MATPRICE1: the price of one line of the no-gi grappler's plan (scripts/rules/MatPrice.gd).
## Prints MAT_PRICE failures=N. Every chance, tank and slide is asserted against the BjjTree / BjjBody / TheRead
## function the match itself calls; the only typed numbers are the map's worked numbers (MATPLAN_MAP_S433.md section 5).
## Population: Ana (NoGi.athlete, cardio 58) and a second athlete at cardio 40 / 70; Rosa-like opponents built per case.
## REVIEW3 (blind review): the hidden answer is rated as an even owned answer (never the opponent's true level), the worked
## numbers pass the found answers the map names, Americana 0.154 / 0.197 are checked with the read, grade cut points,
## read_mult and the tank against BjjBody.spend are real asserts, and every mutant fails an assert the real price passes.

const BjjTree := preload("res://scripts/rules/BjjTree.gd")
const BjjBody := preload("res://scripts/rules/BjjBody.gd")
const BjjBeat := preload("res://scripts/rules/BjjBeat.gd")
const TheRead := preload("res://scripts/rules/TheRead.gd")
const NoGi := preload("res://scripts/rules/NoGi.gd")
const MatPrice := preload("res://scripts/rules/MatPrice.gd")
const MatLines := preload("res://scripts/rules/MatLines.gd")

var _fails := 0
var _rules: Dictionary = {}


func _initialize() -> void:
	BjjTree.reset_tuning()
	_rules = BjjTree.rules_for("white")
	var ana := NoGi.athlete()
	_check(str(ana["belt"]) == "white", "Ana is white belt")
	_worked_numbers(ana)
	_chance_equals_odds(ana)
	_timed_chance(ana)
	_hidden_and_found_answer(ana)
	_tank_two_cardios()
	_sit_tight(ana)
	_read_mult()
	_grade_cuts(ana)
	_chips_format(ana)
	_mutants(ana)
	print("MAT_PRICE failures=%d" % _fails)
	quit(0 if _fails == 0 else 1)


func _check(ok: bool, what: String) -> void:
	print(("  ok   " if ok else "  FAIL ") + what)
	if not ok:
		_fails += 1


func _approx(a: float, b: float, tol: float = 0.005) -> bool:
	return absf(a - b) <= tol


## An opponent with one answer at a level (its TRUE level: hidden from the price until `known` names it).
func _opp_with_answer(move_id: String, level: float, all_stats: float = 50.0) -> Dictionary:
	var st := {}
	for k in BjjBody.ATTRS:
		st[k] = all_stats
	return {"id": "rosa", "belt": "white", "mat_classes": 0, "bjj": {move_id: level}, "tree": {}, "stats": st, "iq": 40.0}


func _opp_empty() -> Dictionary:
	return _opp_with_answer("none", 0.0)


## The map's section 5, to 0.005; each case passes the found answer level the map names.
func _worked_numbers(ana: Dictionary) -> void:
	var f := ana.duplicate(true)
	var opp := _opp_with_answer("posture_closed_guard", 38.0)
	var found38 := {"posture_closed_guard": 38.0}
	var p := MatPrice.price(f, opp, {"at": "closed_guard_bottom", "edge": "e053", "timing": "at_once"}, _rules, found38)
	var direct := BjjTree.odds(BjjTree.edge("e053"), BjjTree.mastery(f, "hip_bump_sweep"), 38.0, _rules)
	_check(_approx(float(p["chance"]), 0.50) and _approx(float(p["chance"]), direct),
		"hip bump sweep 32 vs answer 38: got %.3f, map 0.50, direct odds %.3f" % [float(p["chance"]), direct])

	# Americana from mount after the sweep, chained, answer 35, read after 3 looks of 16: the map's 0.154 / 0.197 include
	# the read; price's chance is the bare chance (the read is read_mult), so the map's numbers are checked on BjjTree.odds
	# with the read TheRead gives and price's chance against the same odds without it.
	var e32 := BjjTree.edge("e032")
	var m_am := BjjTree.mastery(f, "americana")
	var read3 := TheRead.LOOKS_PER_EXCHANGE / TheRead.looks_needed(BjjTree.watcher_iq(opp), false)
	var with_read := BjjTree.odds(e32, m_am, 35.0, _rules, true, read3)
	_check(_approx(with_read, 0.154), "Americana chained vs 35, read 3 of 16 looks: %.3f, map 0.154" % with_read)
	_check(_approx(BjjTree.logit_add(with_read, 2.0 * float(BjjTree.T["GRIP_W"])), 0.197),
		"Americana SET IT UP with the read: %.3f, map 0.197" % BjjTree.logit_add(with_read, 2.0 * float(BjjTree.T["GRIP_W"])))
	var found35 := {"shrimp_bridge": 35.0}
	var p2 := MatPrice.price(f, _opp_with_answer("shrimp_bridge", 35.0), {"edge": "e032", "timing": "set_up", "chain": true}, _rules, found35)
	var bare := BjjTree.odds(e32, m_am, 35.0, _rules, true)
	_check(_approx(float(p2["chance"]), bare) and _approx(float(p2["chance_timed"]), BjjTree.logit_add(bare, 2.0 * float(BjjTree.T["GRIP_W"]))),
		"Americana price: chance %.3f = odds %.3f, SET IT UP %.3f" % [float(p2["chance"]), bare, float(p2["chance_timed"])])

	# Frame and recover guard 36, no answer found (film found none: level 0): 0.345; FRAME FIRST 0.416.
	var none4 := {"kob_pop": 0.0, "mount_step": 0.0}
	var p4 := MatPrice.price(f, _opp_empty(), {"edge": "e046", "timing": "frame_first"}, _rules, none4)
	var direct4 := BjjTree.odds(BjjTree.edge("e046"), BjjTree.mastery(f, "frame_recover_guard"), 0.0, _rules)
	_check(_approx(float(p4["chance"]), 0.345) and _approx(float(p4["chance"]), direct4),
		"Frame and recover guard 36 vs no answer: got %.3f, map 0.345, direct %.3f" % [float(p4["chance"]), direct4])
	_check(_approx(float(p4["chance_timed"]), 0.416), "Frame and recover guard FRAME FIRST: got %.3f, map 0.416" % float(p4["chance_timed"]))
	# miss slide 21/30 = 0.7 (answer 21 found)
	var p6 := MatPrice.price(f, _opp_with_answer("kob_pop", 21.0), {"edge": "e046", "timing": "at_once"}, _rules, {"kob_pop": 21.0})
	_check(_approx(float(p6["miss_slides"]), 0.7) and _approx(float(p6["miss_slides"]), BjjTree.p_bad(21.0)),
		"miss slide vs answer 21: got %.3f, map 0.7" % float(p6["miss_slides"]))
	var p7 := MatPrice.price(f, _opp_empty(), {"edge": "e031", "timing": "at_once"}, _rules, {"turtle_back_take": 0.0})
	_check(_approx(float(p7["chance"]), 0.244), "Seatbelt escape 22 vs no answer: got %.3f, map 0.244" % float(p7["chance"]))
	var p8 := MatPrice.price(f, opp, {"edge": "e054", "timing": "at_once"}, _rules, found38)
	_check(_approx(float(p8["chance"]), 0.143), "Armbar from guard 28 vs answer 38: got %.3f, map 0.143" % float(p8["chance"]))
	var p9 := MatPrice.price(f, _opp_empty(), {"edge": "e056", "timing": "at_once"}, _rules, {"kimura_defence": 0.0})
	_check(_approx(float(p9["chance"]), 0.48), "Kimura grip entry 35 vs no answer: got %.3f, map 0.48" % float(p9["chance"]))


## Every chance equals a direct call of BjjTree.odds with the same inputs (the found level, or the even 30 while hidden).
func _chance_equals_odds(ana: Dictionary) -> void:
	var f := ana.duplicate(true)
	var opp := _opp_with_answer("posture_closed_guard", 30.0)
	for line in [{"edge": "e053", "timing": "at_once"}, {"edge": "e046", "timing": "frame_first"}, {"edge": "e032", "timing": "set_up", "chain": true}]:
		var e := BjjTree.edge(str(line["edge"]))
		var m_att := BjjTree.mastery(f, str(e["move"]))
		var chain := bool(line.get("chain", false))
		var ans := str((e["answers"] as Array)[0])
		var found := MatPrice.price(f, opp, line, _rules, {ans: 25.0})
		_check(_approx(float(found["chance"]), BjjTree.odds(e, m_att, 25.0, _rules, chain), 0.0001),
			"%s found at 25: chance = BjjTree.odds" % str(line["edge"]))
		var hidden := MatPrice.price(f, opp, line, _rules)
		_check(_approx(float(hidden["chance"]), BjjTree.odds(e, m_att, MatLines.EVEN_ANSWER, _rules, chain), 0.0001),
			"%s hidden: chance = BjjTree.odds at the even answer" % str(line["edge"]))


func _timed_chance(ana: Dictionary) -> void:
	var f := ana.duplicate(true)
	var p_at := MatPrice.price(f, _opp_empty(), {"edge": "e046", "timing": "at_once"}, _rules)
	_check(_approx(float(p_at["chance_timed"]), float(p_at["chance"]), 0.0001), "at_once: chance_timed equals chance")
	var p_ff := MatPrice.price(f, _opp_empty(), {"edge": "e046", "timing": "frame_first"}, _rules)
	_check(_approx(float(p_ff["chance_timed"]), BjjTree.logit_add(float(p_ff["chance"]), 2.0 * float(BjjTree.T["GRIP_W"])), 0.0001),
		"frame_first: chance_timed = logit_add(chance, 2 x GRIP_W)")


## Hidden: the price never reads the opponent's true answer; chance_lo = the even owned answer, chance_hi = no answer.
func _hidden_ok(p: Dictionary, f: Dictionary) -> bool:
	var e := BjjTree.edge("e053")
	var m := BjjTree.mastery(f, "hip_bump_sweep")
	return _approx(float(p["chance"]), BjjTree.odds(e, m, MatLines.EVEN_ANSWER, _rules), 0.0001) \
		and _approx(float(p["chance_lo"]), BjjTree.odds(e, m, MatLines.EVEN_ANSWER, _rules), 0.0001) \
		and _approx(float(p["chance_hi"]), BjjTree.odds(e, m, 0.0, _rules), 0.0001)


func _hidden_and_found_answer(ana: Dictionary) -> void:
	var f := ana.duplicate(true)
	var line := {"edge": "e053", "timing": "at_once"}
	var p_weak := MatPrice.price(f, _opp_with_answer("posture_closed_guard", 10.0), line, _rules)
	var p_strong := MatPrice.price(f, _opp_with_answer("posture_closed_guard", 70.0), line, _rules)
	_check(_hidden_ok(p_weak, f) and _hidden_ok(p_strong, f), "hidden answer: chance = even 30, lo = even 30, hi = no answer, whatever the true level")
	_check(float(p_weak["chance_lo"]) < float(p_weak["chance_hi"]), "hidden answer: chance_lo < chance_hi")
	var p_found := MatPrice.price(f, _opp_with_answer("posture_closed_guard", 70.0), line, _rules, {"posture_closed_guard": 35.0})
	_check(_approx(float(p_found["chance"]), BjjTree.odds(BjjTree.edge("e053"), BjjTree.mastery(f, "hip_bump_sweep"), 35.0, _rules), 0.0001)
		and float(p_found["chance_lo"]) == float(p_found["chance"]) and float(p_found["chance_hi"]) == float(p_found["chance"]),
		"found answer: chance_lo == chance_hi == chance at the FOUND level")


## Tank and tank_miss equal BjjBody.spend for two athletes with DIFFERENT cardio; the map's Ana line: 5.5, a miss 2.8 more.
func _tank_two_cardios() -> void:
	var line := {"edge": "e046", "timing": "at_once"}
	for c in [40.0, 70.0]:
		var f := NoGi.athlete().duplicate(true)
		f["stats"]["cardio"] = c
		var p := MatPrice.price(f, _opp_empty(), line, _rules)
		var hit := 100.0 * (1.0 - BjjBody.spend(1.0, "escape", true, c))
		var miss_more := 100.0 * (BjjBody.spend(1.0, "escape", true, c) - BjjBody.spend(1.0, "escape", false, c))
		_check(_approx(float(p["tank"]), hit, 0.0001) and _approx(float(p["tank_miss"]), miss_more, 0.0001),
			"cardio %d: tank %.2f (spend %.2f), a miss adds %.2f (spend %.2f)" % [int(c), float(p["tank"]), hit, float(p["tank_miss"]), miss_more])
	var ana := MatPrice.price(NoGi.athlete(), _opp_empty(), line, _rules)
	_check(_approx(float(ana["tank"]), 5.5, 0.05) and _approx(float(ana["tank_miss"]), 2.8, 0.05),
		"Ana (cardio 58) escape: tank %.2f (map 5.5), a miss %.2f more (map 2.8)" % [float(ana["tank"]), float(ana["tank_miss"])])
	var ff := MatPrice.price(NoGi.athlete(), _opp_empty(), {"edge": "e046", "timing": "frame_first"}, _rules)
	var work := 100.0 * 2.0 * BjjBeat.WORK_GAS * float(BjjTree.T["BEAT2_S"]) / BjjBeat.OLD_BEAT * BjjBody.drain(58.0)
	_check(_approx(float(ff["tank"]) - float(ana["tank"]), work, 0.0001) and work < 1.5,
		"frame first adds two work beats as BjjBeat charges them: +%.2f (map: about 1)" % (float(ff["tank"]) - float(ana["tank"])))


func _sit_tight(ana: Dictionary) -> void:
	var p := MatPrice.price(ana.duplicate(true), _opp_empty(), {"edge": "e046", "timing": "sit_tight"}, _rules)
	_check(_approx(float(p["chance_timed"]), 0.0), "sit_tight: chance_timed is 0")
	_check(_approx(float(p["time_s"]), 0.0), "sit_tight: time_s is 0")
	_check(_approx(float(p["tank"]), 0.0) and _approx(float(p["tank_miss"]), 0.0), "sit_tight: no tank spent")


## read_mult: two tries' looks (TheRead.LOOKS_PER_EXCHANGE each) over the looks the opponent's IQ needs (BjjTree.watcher_iq).
func _read_mult() -> void:
	var f := NoGi.athlete()
	var line := {"edge": "e046", "timing": "at_once"}
	var white := _opp_empty()
	white.erase("iq")
	var blue := white.duplicate(true)
	blue["belt"] = "blue"
	for o in [white, blue]:
		var looks := TheRead.looks_needed(BjjTree.watcher_iq(o), false)
		var want := 1.0 / (1.0 + float(BjjTree.T["READ_W"]) * minf(1.0, 2.0 * TheRead.LOOKS_PER_EXCHANGE / looks))
		var got := float(MatPrice.price(f, o, line, _rules)["read_mult"])
		_check(_approx(got, want, 0.0001), "%s belt: read_mult %.3f = %.3f" % [str(o["belt"]), got, want])
	_check(_approx(float(MatPrice.price(f, white, line, _rules)["read_mult"]), 0.82),
		"white belt: read x0.82 by the 3rd try (map)")


## Grade flips at the two cut points: shifts built just each side of +0.08 and -0.08 through the opponent's body.
func _grade_cuts(ana: Dictionary) -> void:
	_check(MatPrice.GRADE_GOOD_AT == 0.08 and MatPrice.GRADE_POOR_AT == -0.08, "the two cut points are the map's 0.08 / -0.08")
	var e := BjjTree.edge("e046")
	var a := BjjBody.attrs(ana)
	var s50 := BjjBody.shift(e, a, BjjBody.attrs(_opp_with_answer("none", 0.0, 50.0)))
	for target in [0.08, -0.08]:
		for side in [0.002, -0.002]:
			# the escape's defender weights sum to 1, so one point on every stat moves the shift by 0.01
			var v: float = 50.0 + (s50 - (float(target) + float(side))) * 100.0
			var opp := _opp_with_answer("none", 0.0, v)
			var sh := BjjBody.shift(e, a, BjjBody.attrs(opp))
			var want := "Good" if sh >= 0.08 else ("Poor" if sh <= -0.08 else "OK")
			var got := str(MatPrice.price(ana, opp, {"edge": "e046", "timing": "at_once"}, _rules)["grade"])
			_check(absf(sh - (float(target) + float(side))) < 0.0005 and got == want,
				"shift %.4f: grade %s (want %s)" % [sh, got, want])


func _chips_format(ana: Dictionary) -> void:
	var p := MatPrice.price(ana.duplicate(true), _opp_empty(), {"edge": "e046", "timing": "frame_first"}, _rules)
	var chips: Array = p["chips"]
	_check(chips.size() == 6, "six chips (%d)" % chips.size())
	var pronoun := RegEx.create_from_string("(?i)\\b(she|her|hers|herself|he|him|his|himself)\\b")
	var clean := true
	for c in chips:
		clean = clean and pronoun.search(str(c)) == null
	_check(clean, "no chip has a pronoun: %s" % str(chips))
	_check(str(chips[0]) == "%d in 100" % roundi(float(p["chance_timed"]) * 100.0), "chance chip '%s'" % str(chips[0]))
	var at_once := MatPrice.price(ana.duplicate(true), _opp_empty(), {"edge": "e046", "timing": "at_once"}, _rules)
	_check(str((at_once["chips"] as Array)[3]) == "Tank -6, -8 on a miss", "Ana's escape tank chip is the map's 'Tank -6, -8 on a miss' (%s)"
		% str((at_once["chips"] as Array)[3]))


## MUTANTS: copies of price's chance that ignore `known`, that add the stacks at once, and that read the hidden answer from
## the opponent (the delivery's own leak). Each fails an assert the real price passes; an uncaught mutant is a failure.
func _mutants(ana: Dictionary) -> void:
	var f := ana.duplicate(true)
	var opp := _opp_with_answer("posture_closed_guard", 70.0)
	var line := {"edge": "e053", "timing": "at_once"}
	var known := {"posture_closed_guard": 20.0}
	var e := BjjTree.edge("e053")
	var m := BjjTree.mastery(f, "hip_bump_sweep")
	var want_found := BjjTree.odds(e, m, 20.0, _rules)
	_check(_approx(float(MatPrice.price(f, opp, line, _rules, known)["chance"]), want_found, 0.0001), "real price: chance at the found 20")
	var m1 := not _approx(float(_mutant_chance(f, opp, e, known, "ignore_known")["chance"]), want_found, 0.0001)
	_check(m1, "MUTANT caught: ignore known")
	var m2 := not _approx(float(_mutant_chance(f, opp, e, known, "stacks")["chance_timed"]), want_found, 0.0001)
	_check(m2, "MUTANT caught: stacks at once")
	var leak := _mutant_chance(f, opp, e, {}, "leak")
	_check(not _hidden_ok({"chance": leak["chance"], "chance_lo": leak["chance"], "chance_hi": leak["chance"]}, f),
		"MUTANT caught: hidden answer read from the opponent")


func _mutant_chance(f: Dictionary, opp: Dictionary, e: Dictionary, known: Dictionary, kind: String) -> Dictionary:
	var m_att := BjjTree.mastery(f, str(e["move"]))
	var m_ans := MatLines.EVEN_ANSWER
	for a in e.get("answers", []):
		if kind != "ignore_known" and known.has(str(a)):
			m_ans = float(known[str(a)])
	if kind == "leak" and known.is_empty():
		m_ans = BjjTree.answer_mastery(opp, e, _rules)
	var chance := BjjTree.odds(e, m_att, m_ans, _rules)
	var timed := BjjTree.logit_add(chance, 2.0 * float(BjjTree.T["GRIP_W"])) if kind == "stacks" else chance
	return {"chance": chance, "chance_timed": timed}
