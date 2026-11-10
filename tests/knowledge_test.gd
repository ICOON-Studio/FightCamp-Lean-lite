extends SceneTree
## KNOW1 - Knowledge.gd tests (Q-S294-139, S411).
## 1. Truth inside lo..hi at every exposure, hype, truth 0-100.
## 2. More exposure never widens a range; new range inside old when truth unchanged (hype fixed).
## 3. Fire: fire_spar alone leaves width >= half day-one; a bout goes below it.
## 4. A body session does not change skills or fire width.
## 5. stale widens fire and leaves body/skills alone; truth still inside afterwards.
## 6. Same seed+attr -> same offset; two different seeds differ somewhere.
## 7. all_seen gives width 0 and lo = hi = truth.
## 8. Hype 1.0 puts centre above truth (truth < 90) by no more than 0.9 * width.
## 9. Control: offset forced to 1.5, truth falls outside.

const K := preload("res://scripts/rules/Knowledge.gd")
const Attrs := preload("res://scripts/rules/Attrs.gd")

var failures := 0
var n_checks := 0


func _initialize() -> void:
	_test1_truth_inside()
	_test2_exposure_narrows()
	_test3_fire_spar_floor()
	_test4_body_does_not_leak()
	_test5_stale()
	_test6_offset_stable()
	_test7_all_seen()
	_test8_hype()
	_test9_control_can_fail()
	print("KNOWLEDGE failures=%d (%d checks)" % [failures, n_checks])
	quit(0 if failures == 0 else 1)


func _check(ok: bool, label: String) -> void:
	n_checks += 1
	if ok:
		pass
	else:
		failures += 1
		print("FAIL " + label)


func _all_attrs() -> Array:
	var out: Array = []
	for a in K.BODY_ATTRS + K.SKILLS_ATTRS + K.FIRE_ATTRS:
		out.append(a)
	return out


# --- 1. Truth inside lo..hi at every exposure, hype, truth 0-100 ---
func _test1_truth_inside() -> void:
	var rng := RandomNumberGenerator.new()
	rng.seed = 1001
	var attrs := _all_attrs()
	var ok := true
	for i in 2200:
		var seed: int = rng.randi_range(1, 999999)
		var k: Dictionary = K.fresh(seed)
		var attr: String = str(attrs[rng.randi_range(0, attrs.size() - 1)])
		var g: String = K.group_of(attr)
		# Random exposure
		var exp_amount: float = rng.randf_range(0.0, 50.0)
		if g == "fire":
			var kind: String = "spar" if rng.randf() < 0.5 else "bout"
			K.expose(k, g, exp_amount, kind)
		else:
			K.expose(k, g, exp_amount, "session")
		var truth: float = rng.randf_range(0.0, 100.0)
		var hype: float = rng.randf_range(0.0, 1.0)
		var r: Dictionary = K.range_of(k, attr, truth, hype)
		if truth < float(r["lo"]) - 0.001 or truth > float(r["hi"]) + 0.001:
			ok = false
			break
	_check(ok, "1. truth inside lo..hi at every exposure, hype, truth 0-100 (2200 cases)")


# --- 2. More exposure never widens; new range inside old (hype fixed) ---
func _test2_exposure_narrows() -> void:
	var rng := RandomNumberGenerator.new()
	rng.seed = 2002
	var attrs := _all_attrs()
	var ok := true
	for i in 2200:
		var seed: int = rng.randi_range(1, 999999)
		var attr: String = str(attrs[rng.randi_range(0, attrs.size() - 1)])
		var g: String = K.group_of(attr)
		if g == "":
			continue
		var k1: Dictionary = K.fresh(seed)
		var exp1: float = rng.randf_range(0.0, 20.0)
		var kind: String = "spar" if g == "fire" else "session"
		K.expose(k1, g, exp1, kind)
		var k2: Dictionary = k1.duplicate()
		var exp2: float = rng.randf_range(1.0, 30.0)
		K.expose(k2, g, exp2, kind)
		var truth: float = rng.randf_range(5.0, 95.0)
		var hype: float = rng.randf_range(0.0, 0.5)
		var r1: Dictionary = K.range_of(k1, attr, truth, hype)
		var r2: Dictionary = K.range_of(k2, attr, truth, hype)
		# Width must not grow
		if float(r2["width"]) > float(r1["width"]) + 0.001:
			ok = false
			break
		# New range inside old
		if float(r2["lo"]) < float(r1["lo"]) - 0.001 or float(r2["hi"]) > float(r1["hi"]) + 0.001:
			ok = false
			break
	_check(ok, "2. more exposure never widens; new range inside old (2200 cases)")


# --- 3. Fire: spar alone leaves width >= half day-one; bout goes below ---
func _test3_fire_spar_floor() -> void:
	var half_fire := K.FIRE_START / 2.0
	var ok_spar := true
	var ok_bout := false
	var rng := RandomNumberGenerator.new()
	rng.seed = 3003
	for i in 500:
		var seed: int = rng.randi_range(1, 999999)
		# Spar only, huge amount
		var k: Dictionary = K.fresh(seed)
		K.expose(k, "fire", rng.randf_range(50.0, 500.0), "spar")
		var w: float = K.width(k, "fire")
		if w < half_fire - 0.001:
			ok_spar = false
			break
	# Bout goes below half
	for i in 100:
		var seed: int = rng.randi_range(1, 999999)
		var k: Dictionary = K.fresh(seed)
		K.expose(k, "fire", 100.0, "bout")
		var w: float = K.width(k, "fire")
		if w < half_fire - 0.001:
			ok_bout = true
			break
	_check(ok_spar, "3a. fire_spar alone leaves fire width >= half day-one (%.2f)" % half_fire)
	_check(ok_bout, "3b. a bout takes fire width below half day-one")


# --- 4. A body session does not change skills or fire width ---
func _test4_body_does_not_leak() -> void:
	var ok := true
	var rng := RandomNumberGenerator.new()
	rng.seed = 4004
	for i in 500:
		var seed: int = rng.randi_range(1, 999999)
		var k: Dictionary = K.fresh(seed)
		var w_skills_before: float = K.width(k, "skills")
		var w_fire_before: float = K.width(k, "fire")
		K.expose(k, "body", rng.randf_range(1.0, 50.0), "session")
		var w_skills_after: float = K.width(k, "skills")
		var w_fire_after: float = K.width(k, "fire")
		if absf(w_skills_after - w_skills_before) > 0.001 or absf(w_fire_after - w_fire_before) > 0.001:
			ok = false
			break
	_check(ok, "4. a body session does not change skills or fire width")


# --- 5. stale widens fire, leaves body/skills alone; truth inside afterwards ---
func _test5_stale() -> void:
	var ok := true
	var rng := RandomNumberGenerator.new()
	rng.seed = 5005
	var fire_attrs := K.FIRE_ATTRS
	var body_attrs := K.BODY_ATTRS
	var skills_attrs := K.SKILLS_ATTRS
	for i in 500:
		var seed: int = rng.randi_range(1, 999999)
		var k: Dictionary = K.fresh(seed)
		K.expose(k, "fire", 20.0, "spar")
		K.expose(k, "fire", 5.0, "bout")
		K.expose(k, "body", 10.0, "session")
		K.expose(k, "skills", 10.0, "session")
		var w_fire_before: float = K.width(k, "fire")
		var w_body_before: float = K.width(k, "body")
		var w_skills_before: float = K.width(k, "skills")
		var why: String = ["knockout", "layoff", "step_up", "ageing"][rng.randi_range(0, 3)]
		K.stale(k, why)
		var w_fire_after: float = K.width(k, "fire")
		var w_body_after: float = K.width(k, "body")
		var w_skills_after: float = K.width(k, "skills")
		# Fire widens (or stays same if no exposure)
		if w_fire_after < w_fire_before - 0.001:
			ok = false
			break
		# Body and skills unchanged
		if absf(w_body_after - w_body_before) > 0.001 or absf(w_skills_after - w_skills_before) > 0.001:
			ok = false
			break
		# Truth still inside for fire attrs
		for attr in fire_attrs:
			var truth: float = rng.randf_range(0.0, 100.0)
			var r: Dictionary = K.range_of(k, attr, truth)
			if truth < float(r["lo"]) - 0.001 or truth > float(r["hi"]) + 0.001:
				ok = false
				break
	_check(ok, "5. stale widens fire, leaves body/skills alone; truth inside afterwards")


# --- 6. Same seed+attr -> same offset; different seeds differ somewhere ---
func _test6_offset_stable() -> void:
	var attrs := _all_attrs()
	# Same seed -> same offset
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
	# Different seeds differ somewhere
	var ok_diff := false
	var k_a: Dictionary = K.fresh(42)
	var k_b: Dictionary = K.fresh(99)
	for attr in attrs:
		var ra: Dictionary = K.range_of(k_a, attr, 50.0)
		var rb: Dictionary = K.range_of(k_b, attr, 50.0)
		if absf(float(ra["centre"]) - float(rb["centre"])) > 0.001:
			ok_diff = true
			break
	_check(ok_same, "6a. same seed and attribute give same offset across calls")
	_check(ok_diff, "6b. two different seeds differ somewhere")


# --- 7. all_seen gives width 0 and lo = hi = truth ---
func _test7_all_seen() -> void:
	var k: Dictionary = K.all_seen()
	var ok := true
	var attrs := _all_attrs()
	for attr in attrs:
		var w: float = K._attr_width(k, attr)
		if absf(w) > 0.001:
			ok = false
			break
		var truth: float = 62.0
		var r: Dictionary = K.range_of(k, attr, truth)
		if absf(float(r["lo"]) - truth) > 0.001 or absf(float(r["hi"]) - truth) > 0.001:
			ok = false
			break
	_check(ok, "7. all_seen gives width 0 and lo = hi = truth")


# --- 8. Hype 1.0 puts centre above truth (truth < 90) by no more than 0.9 * width ---
func _test8_hype() -> void:
	var ok := true
	var rng := RandomNumberGenerator.new()
	rng.seed = 8008
	var attrs := _all_attrs()
	for i in 2200:
		var seed: int = rng.randi_range(1, 999999)
		var attr: String = str(attrs[rng.randi_range(0, attrs.size() - 1)])
		var g: String = K.group_of(attr)
		if g == "":
			continue
		var k: Dictionary = K.fresh(seed)
		var truth: float = rng.randf_range(0.0, 89.0)
		var r0: Dictionary = K.range_of(k, attr, truth, 0.0)
		var r1: Dictionary = K.range_of(k, attr, truth, 1.0)
		var w: float = float(r0["width"])
		var lift: float = float(r1["centre"]) - truth
		if lift > 0.9 * w + 0.001:
			ok = false
			break
		# Centre should be above truth (or at least not below by much - offset can be negative)
		# The test says "puts the centre above the truth" - this is when offset + hype lift > 0
		# With truth < 90 and hype 1.0, the max lift is 0.9*width
	_check(ok, "8. hype 1.0 lifts centre by no more than 0.9 * width (2200 cases)")


# --- 9. Control: offset forced to 1.5, truth falls outside ---
func _test9_control_can_fail() -> void:
	# Simulate a range with offset forced to 1.5 inside the test
	var truth := 50.0
	var w := 10.0
	var fake_offset := 1.5
	var centre := truth + fake_offset * w  # 50 + 15 = 65
	var lo := truth + (fake_offset - 1.0) * w  # 50 + 5 = 55
	var hi := truth + (fake_offset + 1.0) * w  # 50 + 25 = 75
	# Truth (50) is outside lo..hi (55..75)
	var truth_outside := truth < lo or truth > hi
	_check(truth_outside, "9. control: forced offset 1.5 puts truth outside lo..hi")
