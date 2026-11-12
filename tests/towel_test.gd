extends SceneTree
## R26 THE TOWEL: when the card comes in the corner minute, the risk it shows, and what each answer costs.
## Pure module test: risk(), softer(), reasons(), comes(), coach_pulls(), answer(), words().

const TW := preload("res://scripts/rules/Towel.gd")
const KD := preload("res://scripts/rules/Knockdowns.gd")
const BM := preload("res://scripts/rules/BodyMap.gd")
const IR := preload("res://scripts/rules/InjuryRoll.gd")
const AT := preload("res://scripts/rules/Attrs.gd")
const Data := preload("res://scripts/state/Data.gd")

var failures := 0


func _initialize() -> void:
	_test_risk_exact_equality()
	_test_stop_safe_le_stop()
	_test_softer()
	_test_reasons()
	_test_comes()
	_test_coach_pulls()
	_test_answer_pull()
	_test_answer_one_more()
	_test_answer_box_safe()
	_test_words()
	_test_mutants()
	print("TOWEL failures=%d" % failures)
	quit(0 if failures == 0 else 1)


func _check(cond: bool, label: String) -> void:
	if cond:
		print("OK  " + label)
	else:
		failures += 1
		print("FAIL " + label)


## Build sides from two Data.PROSPECTS rows (deep copies: power/chin from stats, heart from personality).
func _sides_from_prospects(idx_a: int, idx_b: int) -> Dictionary:
	var pa: Dictionary = (Data.PROSPECTS[idx_a] as Dictionary).duplicate(true)
	var pb: Dictionary = (Data.PROSPECTS[idx_b] as Dictionary).duplicate(true)
	var sa: Dictionary = pa["stats"]
	var sb: Dictionary = pb["stats"]
	var pea: Dictionary = pa["personality"]
	var peb: Dictionary = pb["personality"]
	return {"a": {"power": float(sa["power"]), "chin": float(sa["chin"]), "heart": float(pea["heart"]), "stop_mult": 1.0},
		"b": {"power": float(sb["power"]), "chin": float(sb["chin"]), "heart": float(peb["heart"]), "stop_mult": 1.0}}


## The test's own loop over Knockdowns, same seed and draw order as Towel.risk.
func _risk_reference(state: Dictionary, n: int, seed: int) -> Dictionary:
	var rng := RandomNumberGenerator.new()
	rng.seed = seed
	var sides: Dictionary = state["sides"]
	var damage: Dictionary = state["damage"]
	var counts: Dictionary = state["counts"]
	var p_lose: float = float(state["p_lose"])
	var p_lose_safe: float = float(state["p_lose_safe"])
	var margins: Dictionary = state["margins"]
	var stop := 0
	var stop_safe := 0
	var lose := 0
	var lose_safe := 0
	for _i in range(n):
		var u := rng.randf()   # S441 at collect: ONE draw for both arms, so the two numbers differ by the answer, not by luck
		var lost := u < p_lose
		var lost_safe := u < p_lose_safe
		var margin := _draw_margin_ref(margins, rng)
		var internal_seed := rng.randi()
		var internal_rng := RandomNumberGenerator.new()
		internal_rng.seed = internal_seed
		if lost:
			lose += 1
			var res := KD.round_counts(margin, "a", sides, damage, counts, internal_rng)
			if bool(res["stopped"]):
				stop += 1
		else:
			var res := KD.puncher_chance("a", sides, damage, counts, internal_rng)
			if bool(res["stopped"]):
				stop += 1
		internal_rng.seed = internal_seed
		if lost_safe:
			lose_safe += 1
			var res := KD.round_counts(TW.softer(margin), "a", sides, damage, counts, internal_rng)
			if bool(res["stopped"]):
				stop_safe += 1
		else:
			var res := KD.puncher_chance("a", sides, damage, counts, internal_rng)
			if bool(res["stopped"]):
				stop_safe += 1
	return {"stop": float(stop) / float(n), "stop_safe": float(stop_safe) / float(n),
		"lose": float(lose) / float(n), "lose_safe": float(lose_safe) / float(n)}


func _draw_margin_ref(margins: Dictionary, rng: RandomNumberGenerator) -> String:
	var roll := rng.randf()
	var accum := 0.0
	for key in ["close", "clear", "dominant"]:
		accum += float(margins.get(key, 0.0))
		if roll < accum:
			return key
	return "close"


## 1. risk() equals a loop written IN THE TEST over Knockdowns with the same seed and draw order (exact equality).
func _test_risk_exact_equality() -> void:
	var sides1 := _sides_from_prospects(0, 1)
	var state1 := {"sides": sides1, "damage": {"a": 20.0, "b": 15.0}, "counts": {"a": 0, "b": 1},
		"p_lose": 0.45, "p_lose_safe": 0.35, "margins": {"close": 0.5, "clear": 0.35, "dominant": 0.15}}
	var r1 := TW.risk(state1, 200, 1)
	var ref1 := _risk_reference(state1, 200, 1)
	_check(absf(float(r1["stop"]) - float(ref1["stop"])) < 0.0001, "risk() stop exact equality (got %f, ref %f)" % [float(r1["stop"]), float(ref1["stop"])])
	_check(absf(float(r1["stop_safe"]) - float(ref1["stop_safe"])) < 0.0001, "risk() stop_safe exact equality (got %f, ref %f)" % [float(r1["stop_safe"]), float(ref1["stop_safe"])])
	_check(absf(float(r1["lose"]) - float(ref1["lose"])) < 0.0001, "risk() lose exact equality (got %f, ref %f)" % [float(r1["lose"]), float(ref1["lose"])])
	_check(absf(float(r1["lose_safe"]) - float(ref1["lose_safe"])) < 0.0001, "risk() lose_safe exact equality (got %f, ref %f)" % [float(r1["lose_safe"]), float(ref1["lose_safe"])])
	var sides2 := _sides_from_prospects(2, 3)
	var state2 := {"sides": sides2, "damage": {"a": 30.0, "b": 25.0}, "counts": {"a": 1, "b": 0},
		"p_lose": 0.55, "p_lose_safe": 0.40, "margins": {"close": 0.4, "clear": 0.4, "dominant": 0.2}}
	var r2 := TW.risk(state2, 200, 42)
	var ref2 := _risk_reference(state2, 200, 42)
	_check(absf(float(r2["stop"]) - float(ref2["stop"])) < 0.0001, "risk() stop exact equality #2 (got %f, ref %f)" % [float(r2["stop"]), float(ref2["stop"])])
	_check(absf(float(r2["stop_safe"]) - float(ref2["stop_safe"])) < 0.0001, "risk() stop_safe exact equality #2 (got %f, ref %f)" % [float(r2["stop_safe"]), float(ref2["stop_safe"])])


## 2. stop_safe <= stop on three different damage levels; risk rises with damage.
func _test_stop_safe_le_stop() -> void:
	var sides := _sides_from_prospects(0, 1)
	var damages := [{"a": 10.0, "b": 10.0}, {"a": 30.0, "b": 25.0}, {"a": 50.0, "b": 40.0}]
	var prev_stop := -1.0
	var ok_le := true
	var ok_rises := true
	for dmg in damages:
		var state := {"sides": sides, "damage": dmg, "counts": {"a": 0, "b": 0},
			"p_lose": 0.5, "p_lose_safe": 0.4, "margins": {"close": 0.5, "clear": 0.35, "dominant": 0.15}}
		var r := TW.risk(state, 200, 7)
		if float(r["stop_safe"]) > float(r["stop"]) + 0.0001:
			ok_le = false
		if prev_stop >= 0.0 and float(r["stop"]) < prev_stop:
			ok_rises = false
		prev_stop = float(r["stop"])
	_check(ok_le, "stop_safe <= stop on three damage levels")
	_check(ok_rises, "risk rises with damage")


## 3. softer: dominant -> clear -> close -> close.
func _test_softer() -> void:
	_check(TW.softer("dominant") == "clear", "softer(dominant) = clear")
	_check(TW.softer("clear") == "close", "softer(clear) = close")
	_check(TW.softer("close") == "close", "softer(close) = close")


## 4. reasons: each of four appears alone when only its condition holds.
func _test_reasons() -> void:
	var base_state := {"counts_last_round": 0, "head_v": 100.0, "eye_closing": false}
	var base_risk := {"stop": 0.10, "stop_safe": 0.05, "lose": 0.5, "lose_safe": 0.4}
	var state_count := base_state.duplicate()
	state_count["counts_last_round"] = 1
	var r_count := TW.reasons(state_count, "normal", base_risk)
	_check(r_count.size() == 1 and str(r_count[0]["id"]) == "count", "reasons: count alone")
	var state_head := base_state.duplicate()
	state_head["head_v"] = BM.CRITICAL
	var r_head := TW.reasons(state_head, "normal", base_risk)
	_check(r_head.size() == 1 and str(r_head[0]["id"]) == "head", "reasons: head at CRITICAL reads")
	var state_head_above := base_state.duplicate()
	state_head_above["head_v"] = BM.CRITICAL + 1.0
	var r_head_above := TW.reasons(state_head_above, "normal", base_risk)
	_check(r_head_above.size() == 0, "reasons: head at CRITICAL + 1 does not read")
	var state_eye := base_state.duplicate()
	state_eye["eye_closing"] = true
	var r_eye := TW.reasons(state_eye, "normal", base_risk)
	_check(r_eye.size() == 1 and str(r_eye[0]["id"]) == "eye", "reasons: eye alone")
	var state_line := base_state.duplicate()
	var r_line := TW.reasons(state_line, "normal", {"stop": TW.LINES["normal"], "stop_safe": 0.05, "lose": 0.5, "lose_safe": 0.4})
	_check(r_line.size() == 1 and str(r_line[0]["id"]) == "line", "reasons: line at exactly LINES[line] reads")


## 5. comes() false with none.
func _test_comes() -> void:
	var base_state := {"counts_last_round": 0, "head_v": 100.0, "eye_closing": false}
	var base_risk := {"stop": 0.10, "stop_safe": 0.05, "lose": 0.5, "lose_safe": 0.4}
	_check(not TW.comes(base_state, "normal", base_risk), "comes() false with no reasons")


## 6. coach_pulls true at the line, false just under it.
func _test_coach_pulls() -> void:
	var at_line := {"stop": TW.LINES["normal"], "stop_safe": 0.05}
	_check(TW.coach_pulls(at_line, "normal"), "coach_pulls true at the line")
	var under_line := {"stop": TW.LINES["normal"] - 0.001, "stop_safe": 0.05}
	_check(not TW.coach_pulls(under_line, "normal"), "coach_pulls false just under the line")


## 7. answer("pull"): wear false, days_out 14; loyalty +2 for Settled/Loyal, -6 for Wavering/Leaving.
func _test_answer_pull() -> void:
	var ctx := {"band": "Settled", "day": 100, "last_stop_day": -1}
	var a := TW.answer("pull", ctx)
	_check(not bool(a["wear"]), "answer(pull): wear false")
	_check(int(a["days_out"]) == TW.PULL_DAYS, "answer(pull): days_out = PULL_DAYS (14)")
	_check(int(a["loyalty"]) == 2, "answer(pull): loyalty +2 for Settled")
	var ctx_loyal := {"band": "Loyal", "day": 100, "last_stop_day": -1}
	_check(int(TW.answer("pull", ctx_loyal)["loyalty"]) == 2, "answer(pull): loyalty +2 for Loyal")
	var ctx_wav := {"band": "Wavering", "day": 100, "last_stop_day": -1}
	_check(int(TW.answer("pull", ctx_wav)["loyalty"]) == -6, "answer(pull): loyalty -6 for Wavering")
	var ctx_leav := {"band": "Leaving", "day": 100, "last_stop_day": -1}
	_check(int(TW.answer("pull", ctx_leav)["loyalty"]) == -6, "answer(pull): loyalty -6 for Leaving")


## 8. answer("one_more"): days_out = KO_DAYS with no stop, KO_SECOND_DAYS with stop 60 days ago, KO_DAYS with stop KO_SECOND_WINDOW + 1 ago.
func _test_answer_one_more() -> void:
	var ctx_no_stop := {"band": "Settled", "day": 100, "last_stop_day": -1}
	var a1 := TW.answer("one_more", ctx_no_stop)
	_check(int(a1["if_stopped"]["days_out"]) == IR.KO_DAYS, "answer(one_more): days_out = KO_DAYS with no stop before")
	_check(int(a1["if_stopped"]["durability_drop"]) == AT.STOP_DROP, "answer(one_more): durability_drop = STOP_DROP")
	var ctx_recent_stop := {"band": "Settled", "day": 100, "last_stop_day": 40}
	var a2 := TW.answer("one_more", ctx_recent_stop)
	_check(int(a2["if_stopped"]["days_out"]) == IR.KO_SECOND_DAYS, "answer(one_more): days_out = KO_SECOND_DAYS with stop 60 days ago")
	var ctx_old_stop := {"band": "Settled", "day": 100, "last_stop_day": 100 - IR.KO_SECOND_WINDOW - 1}
	var a3 := TW.answer("one_more", ctx_old_stop)
	_check(int(a3["if_stopped"]["days_out"]) == IR.KO_DAYS, "answer(one_more): days_out = KO_DAYS with stop KO_SECOND_WINDOW + 1 ago")


## 9. answer("box_safe").
func _test_answer_box_safe() -> void:
	var ctx := {"band": "Settled", "day": 100, "last_stop_day": -1}
	var a := TW.answer("box_safe", ctx)
	_check(bool(a["next_round"]), "answer(box_safe): next_round true")
	_check(str(a["pace"]) == "save", "answer(box_safe): pace = save")
	_check(str(a["call"]) == "hands", "answer(box_safe): call = hands")
	_check(bool(a["gloves_high"]), "answer(box_safe): gloves_high true")
	_check(str(a["margin"]) == "softer", "answer(box_safe): margin = softer")


## 10. words() holds both numbers and the line, and no pronoun.
func _test_words() -> void:
	var risk_now := {"stop": 0.14, "stop_safe": 0.06, "lose": 0.5, "lose_safe": 0.4}
	var w := TW.words(risk_now, "normal")
	_check(w.find("14") >= 0, "words() holds stop number 14")
	_check(w.find("6") >= 0, "words() holds safe number 6")
	_check(w.find("20") >= 0, "words() holds line number 20")
	_check(w.find("he ") < 0 and w.find("she ") < 0 and w.find("him ") < 0 and w.find("her ") < 0, "words() has no pronoun")


## 11. MUTANTS: a copy of softer that goes the wrong way and a copy of the line check with > in place of >= must each FAIL.
func _test_mutants() -> void:
	var mutant_softer := func(margin: String) -> String:
		if margin == "close":
			return "clear"
		if margin == "clear":
			return "dominant"
		return "close"
	var mutant_caught := false
	if mutant_softer.call("dominant") != "clear":
		mutant_caught = true
	if mutant_softer.call("clear") != "close":
		mutant_caught = true
	if mutant_softer.call("close") != "close":
		mutant_caught = true
	if mutant_caught:
		print("MUTANT caught: softer wrong way")
	var mutant_line_check := func(risk_stop: float, line: String) -> bool:
		return risk_stop > float(TW.LINES.get(line, 0.20))
	var mutant_line_caught := false
	if not mutant_line_check.call(TW.LINES["normal"], "normal"):
		mutant_line_caught = true
	if mutant_line_caught:
		print("MUTANT caught: line check with > instead of >=")
	_check(mutant_caught, "MUTANT: softer wrong way fails the assert")
	_check(mutant_line_caught, "MUTANT: line check with > fails at exactly the line")
