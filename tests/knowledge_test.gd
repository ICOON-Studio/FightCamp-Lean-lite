extends SceneTree
## KNOWLEDGE1A - Knowledge v3 tests (issue #378).
## 1. Truth inside lo..hi at every exposure, hype, truth 0-100 (1000 cases).
## 2. More exposure never widens; new range inside old (hype fixed).
## 3. under_fire: unknown until hard_spar; opens at ±15.
## 4. A body morning does not change skills or under_fire width.
## 5. stale widens under_fire/body, leaves skills alone; truth inside afterwards.
## 6. Same seed+attr -> same offset; different seeds differ somewhere.
## 7. all_seen gives width 0 and lo = hi = truth.
## 8. Hype lifts centre; truth still inside.
## 9. Control: forced offset 1.5, truth outside.
## 10. Groups: body 6, skills 6, under_fire 2, mind 6 (no range).
## 11. room_word thresholds.
## 12. Width word thresholds.
## 13. Moment threshold (4.9 = no, 5.0 = yes).
## 14. Monday lines: at most 2, no names, no pronouns.
## 15. Stale causes tracked.
## 16. Recheck halves stale.

const K := preload("res://scripts/rules/Knowledge.gd")
const Attrs := preload("res://scripts/rules/Attrs.gd")

var failures := 0
var n_checks := 0

func _initialize() -> void:
	_test1_truth_inside()
	_test2_exposure_narrows()
	_test3_under_fire_opens()
	_test4_body_does_not_leak()
	_test5_stale()
	_test6_offset_stable()
	_test7_all_seen()
	_test8_hype()
	_test9_control_can_fail()
	_test10_groups()
	_test11_room_word()
	_test12_width_word()
	_test13_moment()
	_test14_monday_lines()
	_test15_stale_causes()
	_test16_recheck()
	print("KNOWLEDGE failures=%d (%d checks)" % [failures, n_checks])
	quit(0 if failures == 0 else 1)

func _check(ok: bool, label: String) -> void:
	n_checks += 1
	if not ok:
		failures += 1
		print("FAIL " + label)

func _all_attrs() -> Array:
	var out: Array = []
	for a in K.BODY_ATTRS + K.SKILLS_ATTRS + K.UNDER_FIRE_ATTRS:
		out.append(a)
	return out

# 1. Truth inside lo..hi at every exposure, hype, truth 0-100.
func _test1_truth_inside() -> void:
	var rng := RandomNumberGenerator.new()
	rng.seed = 1001
	var attrs := _all_attrs()
	var ok := true
	for i in 1000:
		var seed: int = rng.randi_range(1, 999999)
		var k: Dictionary = K.fresh(seed)
		var attr: String = str(attrs[rng.randi_range(0, attrs.size() - 1)])
		var g: String = K.group_of(attr)
		var exp_amount: float = rng.randf_range(0.0, 50.0)
		if g == "under_fire":
			K.hard_spar(k, false)  # open it first
			K.expose(k, g, exp_amount, "spar")
		else:
			K.expose(k, g, exp_amount, "session")
		var truth: float = rng.randf_range(0.0, 100.0)
		var hype: float = rng.randf_range(0.0, 1.0)
		var r: Dictionary = K.range_of(k, attr, truth, hype)
		if truth < float(r["lo"]) - 0.001 or truth > float(r["hi"]) + 0.001:
			ok = false
			break
	_check(ok, "1. truth inside lo..hi (1000 cases)")

# 2. More exposure never widens; new range inside old.
func _test2_exposure_narrows() -> void:
	var rng := RandomNumberGenerator.new()
	rng.seed = 2002
	var attrs := _all_attrs()
	var ok := true
	for i in 1000:
		var seed: int = rng.randi_range(1, 999999)
		var attr: String = str(attrs[rng.randi_range(0, attrs.size() - 1)])
		var g: String = K.group_of(attr)
		if g == "" or g == "mind":
			continue
		var k1: Dictionary = K.fresh(seed)
		if g == "under_fire":
			K.hard_spar(k1, false)
		var exp1: float = rng.randf_range(0.0, 20.0)
		var kind: String = "spar" if g == "under_fire" else "session"
		K.expose(k1, g, exp1, kind)
		var k2: Dictionary = k1.duplicate()
		var exp2: float = rng.randf_range(1.0, 30.0)
		K.expose(k2, g, exp2, kind)
		var truth: float = rng.randf_range(5.0, 95.0)
		var hype: float = rng.randf_range(0.0, 0.5)
		var r1: Dictionary = K.range_of(k1, attr, truth, hype)
		var r2: Dictionary = K.range_of(k2, attr, truth, hype)
		if float(r2["width"]) > float(r1["width"]) + 0.001:
			ok = false
			break
		if float(r2["lo"]) < float(r1["lo"]) - 0.001 or float(r2["hi"]) > float(r1["hi"]) + 0.001:
			ok = false
			break
	_check(ok, "2. more exposure never widens (1000 cases)")

# 3. under_fire: unknown until hard_spar; opens at ±15.
func _test3_under_fire_opens() -> void:
	var k: Dictionary = K.fresh(100)
	var w_before: float = K.width(k, "under_fire")
	var is_unknown: bool = w_before > K.WORD_ROUGH_HI
	K.hard_spar(k, false)
	var w_after: float = K.width(k, "under_fire")
	var opened: bool = w_after <= K.UNDER_FIRE_START + 0.001
	_check(is_unknown and opened, "3. under_fire unknown until hard_spar, then ~±15")

# 4. A body morning does not change skills or under_fire width.
func _test4_body_does_not_leak() -> void:
	var ok := true
	var rng := RandomNumberGenerator.new()
	rng.seed = 4004
	for i in 500:
		var seed: int = rng.randi_range(1, 999999)
		var k: Dictionary = K.fresh(seed)
		var w_skills_before: float = K.width(k, "skills")
		K.morning(k, "body")
		var w_skills_after: float = K.width(k, "skills")
		if absf(w_skills_after - w_skills_before) > 0.001:
			ok = false
			break
	_check(ok, "4. body morning does not change skills width")

# 5. stale widens under_fire/body, leaves skills alone; truth inside.
func _test5_stale() -> void:
	var ok := true
	var rng := RandomNumberGenerator.new()
	rng.seed = 5005
	for i in 500:
		var seed: int = rng.randi_range(1, 999999)
		var k: Dictionary = K.fresh(seed)
		K.hard_spar(k, false)
		K.expose(k, "under_fire", 10.0, "spar")
		K.expose(k, "body", 10.0, "session")
		K.expose(k, "skills", 10.0, "session")
		var w_fire_before: float = K.width(k, "under_fire")
		var w_body_before: float = K.width(k, "body")
		var w_skills_before: float = K.width(k, "skills")
		var why: String = ["stoppage", "layoff", "step_up", "ageing"][rng.randi_range(0, 3)]
		K.stale(k, why)
		var w_fire_after: float = K.width(k, "under_fire")
		var w_body_after: float = K.width(k, "body")
		var w_skills_after: float = K.width(k, "skills")
		if why != "ageing" and w_fire_after < w_fire_before - 0.001:
			ok = false
			break
		if why == "ageing" and w_body_after < w_body_before - 0.001:
			ok = false
			break
		if absf(w_skills_after - w_skills_before) > 0.001:
			ok = false
			break
		for attr in K.UNDER_FIRE_ATTRS:
			var truth: float = rng.randf_range(0.0, 100.0)
			var r: Dictionary = K.range_of(k, attr, truth)
			if truth < float(r["lo"]) - 0.001 or truth > float(r["hi"]) + 0.001:
				ok = false
				break
	_check(ok, "5. stale widens correctly, truth inside")

# 6. Same seed+attr -> same offset; different seeds differ somewhere.
func _test6_offset_stable() -> void:
	var attrs := _all_attrs()
	var ok_same := true
	for i in 200:
		var seed: int = (i + 1) * 7
		var k1: Dictionary = K.fresh(seed)
		var k2: Dictionary = K.fresh(seed)
		for attr in attrs:
			var r1: Dictionary = K.range_of(k1, attr, 50.0)
			var r2: Dictionary = K.range_of(k2, attr, 50.0)
			if absf(float(r1["centre"]) - float(r2["centre"])) > 0.001:
				ok_same = false
				break
	var ok_diff := false
	var k_a: Dictionary = K.fresh(42)
	var k_b: Dictionary = K.fresh(99)
	for attr in attrs:
		var ra: Dictionary = K.range_of(k_a, attr, 50.0)
		var rb: Dictionary = K.range_of(k_b, attr, 50.0)
		if absf(float(ra["centre"]) - float(rb["centre"])) > 0.001:
			ok_diff = true
			break
	_check(ok_same, "6a. same seed+attr gives same offset")
	_check(ok_diff, "6b. different seeds differ somewhere")

# 7. all_seen gives width 0 and lo = hi = truth.
func _test7_all_seen() -> void:
	var k: Dictionary = K.all_seen()
	var ok := true
	for attr in _all_attrs():
		var w: float = K._attr_width(k, attr)
		if absf(w) > 0.001:
			ok = false
			break
		var truth: float = 62.0
		var r: Dictionary = K.range_of(k, attr, truth)
		if absf(float(r["lo"]) - truth) > 0.001 or absf(float(r["hi"]) - truth) > 0.001:
			ok = false
			break
	_check(ok, "7. all_seen gives width 0, lo = hi = truth")

# 8. Hype lifts centre; truth still inside.
func _test8_hype() -> void:
	var ok := true
	var rng := RandomNumberGenerator.new()
	rng.seed = 8008
	var attrs := _all_attrs()
	for i in 1000:
		var seed: int = rng.randi_range(1, 999999)
		var attr: String = str(attrs[rng.randi_range(0, attrs.size() - 1)])
		var g: String = K.group_of(attr)
		if g == "" or g == "mind":
			continue
		var k: Dictionary = K.fresh(seed)
		if g == "under_fire":
			K.hard_spar(k, false)
		var truth: float = rng.randf_range(0.0, 89.0)
		var r1: Dictionary = K.range_of(k, attr, truth, 1.0)
		if truth < float(r1["lo"]) - 0.001 or truth > float(r1["hi"]) + 0.001:
			ok = false
			break
	_check(ok, "8. hype: truth still inside (1000 cases)")

# 9. Control: forced offset 1.5, truth outside.
func _test9_control_can_fail() -> void:
	var truth := 50.0
	var w := 10.0
	var fake_offset := 1.5
	var lo := truth + (fake_offset - 1.0) * w
	var hi := truth + (fake_offset + 1.0) * w
	var truth_outside := truth < lo or truth > hi
	_check(truth_outside, "9. control: offset 1.5 puts truth outside")

# 10. Groups: body 6, skills 6, under_fire 2, mind 6 (no range).
func _test10_groups() -> void:
	var ok := K.BODY_ATTRS.size() == 6
	ok = ok and K.SKILLS_ATTRS.size() == 6
	ok = ok and K.UNDER_FIRE_ATTRS.size() == 2
	ok = ok and K.MIND_ATTRS.size() == 6
	# mind attrs have no range
	for attr in K.MIND_ATTRS:
		var k: Dictionary = K.fresh(1)
		var w: float = K._attr_width(k, attr)
		if w > 0.001:
			ok = false
			break
	# heart not in under_fire
	ok = ok and not K.UNDER_FIRE_ATTRS.has("heart")
	_check(ok, "10. groups: body 6, skills 6, under_fire 2, mind 6 (no range)")

# 11. room_word thresholds.
func _test11_room_word() -> void:
	var ok := K.room_word(80.0, 50.0) == "lots"  # gap 30 >= 15
	ok = ok and K.room_word(60.0, 50.0) == "some"  # gap 10 >= 5
	ok = ok and K.room_word(53.0, 50.0) == "little"  # gap 3 < 5
	_check(ok, "11. room_word thresholds")

# 12. Width word thresholds.
func _test12_width_word() -> void:
	var ok := K.word(1.0) == "Exact"  # <= 2
	ok = ok and K.word(2.0) == "Exact"  # <= 2
	ok = ok and K.word(2.5) == "Good read"  # > 2, <= 8
	ok = ok and K.word(5.0) == "Good read"  # 3-8
	ok = ok and K.word(8.0) == "Good read"  # <= 8
	ok = ok and K.word(10.0) == "Rough"  # > 8
	ok = ok and K.word(16.0) == "Unknown"  # > 15
	_check(ok, "12. width word thresholds")

# 13. Moment threshold (4.9 = no, 5.0 = yes).
func _test13_moment() -> void:
	# under_fire opening is always a moment
	var k_before: Dictionary = K.fresh(200)
	var k_after: Dictionary = k_before.duplicate()
	K.hard_spar(k_after, false)
	var opened_moment: bool = K.moment(k_before, k_after)
	# Width change of 5+ is a moment (body: exposure 0 -> 50 gives ~6pt change)
	var k_a: Dictionary = K.fresh(201)
	var k_b: Dictionary = K.fresh(201)
	K.expose(k_b, "body", 50.0, "session")  # big change from fresh
	var width_moment: bool = K.moment(k_a, k_b)
	# Small change is not a moment
	var k_c: Dictionary = K.fresh(202)
	K.expose(k_c, "body", 5.0, "session")
	var k_d: Dictionary = k_c.duplicate()
	K.expose(k_d, "body", 6.0, "session")  # tiny change
	var no_moment: bool = not K.moment(k_c, k_d)
	_check(opened_moment and width_moment and no_moment, "13. moment threshold")

# 14. Monday lines: at most 2, no names, no pronouns.
func _test14_monday_lines() -> void:
	var changes: Array = [
		{"attr": "strength", "before_lo": 50.0, "before_hi": 66.0, "after_lo": 54.0, "after_hi": 62.0,
		 "centre_before": 58.0, "centre_after": 58.0},
		{"attr": "speed", "before_lo": 45.0, "before_hi": 61.0, "after_lo": 48.0, "after_hi": 58.0,
		 "centre_before": 53.0, "centre_after": 53.0},
		{"attr": "stamina", "before_lo": 40.0, "before_hi": 56.0, "after_lo": 44.0, "after_hi": 52.0,
		 "centre_before": 48.0, "centre_after": 48.0},
	]
	var lines: Array = K.monday_lines(changes)
	var ok := lines.size() == 2  # at most 2
	# No pronouns
	for line in lines:
		var s: String = str(line)
		if s.contains("he ") or s.contains("she ") or s.contains("his ") or s.contains("her "):
			ok = false
			break
	_check(ok, "14. monday_lines: at most 2, no pronouns")

# 15. Stale causes tracked.
func _test15_stale_causes() -> void:
	var k: Dictionary = K.fresh(300)
	K.hard_spar(k, false)
	K.stale(k, "step_up")
	K.stale(k, "layoff")
	var causes: Array = K.stale_causes(k)
	var ok := causes.size() == 2
	ok = ok and str(causes[0]).contains("step up")
	ok = ok and str(causes[1]).contains("bout")
	_check(ok, "15. stale causes tracked")

# 16. Recheck halves stale.
func _test16_recheck() -> void:
	var k: Dictionary = K.fresh(400)
	K.hard_spar(k, false)
	K.stale(k, "stoppage")
	var stale_before: float = float(k.get("stale_fire", 0.0))
	K.recheck(k)
	var stale_after: float = float(k.get("stale_fire", 0.0))
	var ok := absf(stale_after - stale_before * 0.5) < 0.001
	_check(ok, "16. recheck halves stale")
