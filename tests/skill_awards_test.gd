extends SceneTree
## S370 GOALTESTS1: the skills award road (six grades, 8 coached sessions + the assessment) and the bleep-test reading.

const SkillAwards := preload("res://scripts/rules/SkillAwards.gd")

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
	_check(is_equal_approx(SkillAwards.bleep(40.0), 6.6) and is_equal_approx(SkillAwards.bleep(85.0), 9.0), "the bleep anchors: 40 -> 6.6, 85 -> 9.0")
	_check(SkillAwards.bleep(55.0) > SkillAwards.bleep(50.0) and SkillAwards.bleep(0.0) >= 4.0 and SkillAwards.bleep(100.0) <= 12.0, "rises with conditioning, held inside 4-12")
	_check(SkillAwards.bleep_words(9.2) == "national-team level" and SkillAwards.bleep_words(6.0).begins_with("below"), "the level in words")
	print("SKILL_AWARDS failures=%d" % failures)
	quit(1 if failures > 0 else 0)


func _check(cond: bool, label: String) -> void:
	if cond:
		print("  ok: " + label)
	else:
		failures += 1
		print("  FAIL: " + label)
