extends SceneTree
## S370 GOALTESTS1: the skills award road (six grades, 8 coached sessions + the assessment) and the bleep-test reading.

const SkillAwards := preload("res://scripts/rules/SkillAwards.gd")
const ComboFlow := preload("res://scripts/rules/ComboFlow.gd")
const Combos := preload("res://scripts/rules/Combos.gd")
const RoundStyle := preload("res://scripts/rules/RoundStyle.gd")
const ComboStrip := preload("res://scripts/ui/ComboStrip.gd")
const ComboBuilder := preload("res://scripts/ui/ComboBuilder.gd")

var failures := 0


func _initialize() -> void:
	var f := {"moves": {"Jab": 40.0, "Cross": 22.0, "Lead hook": 10.0, "Body hook": 5.0, "Uppercut": 0.0, "Check hook": 0.0},
		"w": 0, "l": 0}
	_check(str(SkillAwards.next_award(f)["id"]) == "preliminary", "a new boxer works toward the Preliminary award")
	var p := SkillAwards.progress(f)
	_check(int(p["sessions"]) == 0 and not bool(p["ready"]), "no sessions yet: not ready")
	for i in 7:
		SkillAwards.count_session(f, "pads")
	SkillAwards.count_session(f, "rest")
	_check(int(f["award_sessions"]) == 7 and SkillAwards.assess(f, 10).is_empty(), "7 coached sessions (a rest evening does not count): no assessment yet")
	SkillAwards.count_session(f, "sparring")
	SkillAwards.count_session(f, "pads")
	_check(int(f["award_sessions"]) == 8, "sessions stop at 8")
	var got := SkillAwards.assess(f, 14)
	_check(str(got.get("id", "")) == "preliminary" and SkillAwards.passed(f) == ["preliminary"] and int(f["award_sessions"]) == 0,
		"8 sessions pass the Preliminary (no moves asked); the count starts again")
	for i in 8:
		SkillAwards.count_session(f, "pads")
	p = SkillAwards.progress(f)
	_check(str(p["award"]["id"]) == "standard" and not bool(p["ready"]) and (p["moves"] as Array).any(func(m): return str(m["name"]) == "Cross" and not bool(m["ok"])),
		"Standard waits on the cross (22 of 30) though the sessions are done")
	_check(SkillAwards.assess(f, 21).is_empty(), "not ready: no grade passed")
	f["moves"]["Cross"] = 31.0
	_check(str(SkillAwards.assess(f, 28).get("id", "")) == "standard", "the cross a weapon: Standard passed")
	f["awards"] = [{"id": "preliminary", "d": 0}, {"id": "standard", "d": 0}, {"id": "bronze", "d": 0}, {"id": "silver", "d": 0}, {"id": "gold", "d": 0}]
	f["award_sessions"] = 8
	_check(not bool(SkillAwards.progress(f)["ready"]), "Platinum needs a bout in the ring")
	f["w"] = 1
	_check(str(SkillAwards.assess(f, 99).get("id", "")) == "platinum" and SkillAwards.next_award(f).is_empty() and bool(SkillAwards.progress(f)["done"]),
		"with a bout Platinum passes and the road is done")
	_check(is_equal_approx(SkillAwards.bleep(40.0), 6.6) and is_equal_approx(SkillAwards.bleep(60.0), 8.0) and is_equal_approx(SkillAwards.bleep(85.0), 9.0),
		"the women's bleep anchors: 40 -> 6.6, 60 -> 8.0 (S373 K_CALIB1 club anchor), 85 -> 9.0")
	_check(SkillAwards.bleep(55.0) > SkillAwards.bleep(50.0) and SkillAwards.bleep(0.0) >= 4.0 and SkillAwards.bleep(100.0) <= 12.0, "rises with conditioning, held inside 4-12")
	_check(is_equal_approx(SkillAwards.bleep(40.0, "m"), 9.0) and is_equal_approx(SkillAwards.bleep(60.0, "m"), 12.5)
		and is_equal_approx(SkillAwards.bleep(85.0, "m"), 14.0) and SkillAwards.bleep(100.0, "m") <= 16.0, "men's bleep anchors (J_TESTS3): 40 -> 9.0, 60 -> 12.5, 85 -> 14.0")
	_check(SkillAwards.bleep_known("m") and SkillAwards.bleep_words(9.2, "m").begins_with("above") and SkillAwards.bleep_words(14.0, "m") == "national-team level",
		"his level in words against the men's norms")
	_check(SkillAwards.bleep_words(9.2) == "national-team level" and SkillAwards.bleep_words(6.0).begins_with("below"), "the level in words")
	_graded()
	print("SKILL_AWARDS failures=%d" % failures)
	quit(1 if failures > 0 else 0)


## S373 phase 2: a passed grade's moves are graded - the card wears the grade, and they cost less gas on the card and in
## the bout. Population: a boxer with Standard passed (jab, cross); the same boxer with every grade to Gold.
func _graded() -> void:
	var f := {"moves": {"Jab": 45.0, "Cross": 40.0, "Lead hook": 35.0, "Body hook": 31.0, "Uppercut": 31.0, "Check hook": 31.0},
		"awards": [{"id": "preliminary", "d": 0}, {"id": "standard", "d": 7}], "w": 0, "l": 0}
	_check(SkillAwards.grade_of(f, "Jab") == "standard" and SkillAwards.grade_of(f, "Lead hook") == "", "Standard grades the jab and cross only")
	_check(is_equal_approx(SkillAwards.economy(f, "Cross"), 0.92) and is_equal_approx(SkillAwards.economy(f, "Lead hook"), 1.0), "a graded cross costs 8 % less, an ungraded hook full price")
	var plain := ComboFlow.energy(["jab", "cross"])
	var graded := ComboFlow.energy(["jab", "cross"], SkillAwards.economy_ids(f))
	_check(is_equal_approx(graded, plain * 0.92), "the 1-2's gas on the card drops 8 %% (%.3f -> %.3f)" % [plain, graded])
	_check(is_equal_approx(ComboFlow.energy(["jab", "lead_hook"], SkillAwards.economy_ids(f)), ComboFlow.energy(["jab", "lead_hook"]) * 0.96),
		"a chain half graded drops by half as much")
	var econ := SkillAwards.bout_economy(f, RoundStyle.SHARE)
	_check(econ < 1.0 and econ > 0.92, "in the bout: jab and cross are 72 %% of the punches, so the round's punch gas drops %.1f %%" % (100.0 * (1.0 - econ)))
	var combos := {"1-2": 40.0}
	_check(Combos.round_spend(combos, "", 60.0, econ) < Combos.round_spend(combos, "", 60.0), "her round spend is lower with the grade")
	_check(is_equal_approx(SkillAwards.bout_economy({"awards": []}, RoundStyle.SHARE), 1.0), "no grade, no change")
	f["awards"] = ["preliminary", "standard", "bronze", "silver", "gold"].map(func(a): return {"id": a, "d": 0})
	_check(SkillAwards.grade_of(f, "Jab") == "gold" and is_equal_approx(SkillAwards.economy(f, "Jab"), 0.88)
		and SkillAwards.grade_of(f, "Uppercut") == "silver", "Gold re-grades the jab (12 % less); the uppercut stays Silver")
	var entries := {}
	for e in ComboBuilder.PALETTE:
		entries[str(e["id"])] = e
	var strip := ComboStrip.strip(f, ["jab", "rear_uppercut", "slip"], ComboFlow.rate(["jab", "rear_uppercut", "slip"]), entries, func(_i): pass)
	var chips := strip.find_children("Graded", "", true, false)
	_check(chips.size() == 2, "the strip: the jab and the uppercut wear their grade, the slip none (%d)" % chips.size())
	strip.free()


func _check(cond: bool, label: String) -> void:
	if cond:
		print("  ok: " + label)
	else:
		failures += 1
		print("  FAIL: " + label)
