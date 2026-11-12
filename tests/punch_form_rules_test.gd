extends SceneTree
## PunchForm: 11 tests.
## 1. elbow_deg: straight=180, right angle=90, folded<40.
## 2. hang_s: snap peak <0.05; held 0.30; double-peak only counts one run.
## 3. hang_s: uneven time gaps give same hang as even ones.
## 4. other_glove: 0.20 under chin reads 0.20; at chin reads <=0.
## 5. pre_drop: 0.40 drop for 0.20s reads depth=0.40 held=0.20; after contact not counted.
## 6. finish_over_head: +0.15 above head; chin height negative.
## 7. bow_m: head 0.12 in front of knee; facing turned 90 still reads along facing.
## 8. hip_turn_deg: 170 to -170 reads 20 not 340.
## 9. back_s: back at 0.35 reads 0.35; never back reads -1.
## 10. empty and one-sample: no error, zero answers.
## 11. mutants: prove the test can fail.

const PF := preload("res://scripts/rules/PunchForm.gd")

var failures := 0


func _initialize() -> void:
	_test1_elbow_deg()
	_test2_hang_basic()
	_test3_hang_uneven()
	_test4_other_glove()
	_test5_pre_drop()
	_test6_finish_over_head()
	_test7_bow()
	_test8_hip_turn()
	_test9_back_s()
	_test10_empty()
	_test11_mutants()
	print("PUNCH_FORM_RULES failures=%d" % failures)
	quit(1 if failures > 0 else 0)


func _check(cond: bool, msg: String) -> void:
	if not cond:
		failures += 1
		print("  FAIL: " + msg)


func _approx(a: float, b: float, eps: float = 0.001) -> bool:
	return abs(a - b) <= eps


func _make_sample(t: float, sh: Vector3, el: Vector3, wr: Vector3, ow: Vector3, hd: Vector3, yaw: float, lk: Vector3) -> Dictionary:
	return {"t": t, "shoulder": sh, "elbow": el, "wrist": wr, "other_wrist": ow, "head": hd, "pelvis_yaw": yaw, "lead_knee": lk}


# -- helpers for building sample arrays --
func _guard_sample(t: float) -> Dictionary:
	var sh := Vector3(0.2, 1.4, 0.0)
	var el := Vector3(0.15, 1.2, -0.1)
	var wr := Vector3(0.1, 1.45, -0.15)
	var ow := Vector3(-0.15, 1.45, -0.15)
	var hd := Vector3(0.0, 1.6, 0.0)
	var lk := Vector3(-0.1, 0.9, 0.1)
	return _make_sample(t, sh, el, wr, ow, hd, 0.0, lk)


# Test 1: elbow_deg
func _test1_elbow_deg() -> void:
	# Straight arm: shoulder->elbow->wrist all in a line
	var s_straight := _guard_sample(0.0)
	s_straight["shoulder"] = Vector3(0.0, 1.4, 0.0)
	s_straight["elbow"] = Vector3(0.3, 1.4, 0.0)
	s_straight["wrist"] = Vector3(0.6, 1.4, 0.0)
	var deg_straight: float = PF.elbow_deg(s_straight)
	_check(_approx(deg_straight, 180.0, 0.5), "straight arm should be 180 deg, got %.2f" % deg_straight)
	# Right angle: shoulder->elbow along +x, elbow->wrist along -y
	var s_right := _guard_sample(0.0)
	s_right["shoulder"] = Vector3(0.0, 1.4, 0.0)
	s_right["elbow"] = Vector3(0.3, 1.4, 0.0)
	s_right["wrist"] = Vector3(0.3, 1.1, 0.0)
	var deg_right: float = PF.elbow_deg(s_right)
	_check(_approx(deg_right, 90.0, 0.5), "right angle should be 90 deg, got %.2f" % deg_right)
	# Folded arm: acute angle
	var s_fold := _guard_sample(0.0)
	s_fold["shoulder"] = Vector3(0.0, 1.4, 0.0)
	s_fold["elbow"] = Vector3(0.2, 1.4, 0.0)
	s_fold["wrist"] = Vector3(0.08, 1.5, 0.0)
	var deg_fold: float = PF.elbow_deg(s_fold)
	_check(deg_fold < 40.0, "folded arm should be < 40 deg, got %.2f" % deg_fold)


# Test 2: hang_s basic
func _test2_hang_basic() -> void:
	var facing := Vector3(0.0, 0.0, -1.0)
	# Snap peak for one sample: reach goes up then immediately back
	var samples_snap: Array = []
	for i in range(5):
		var t: float = i * 0.05
		var s := _guard_sample(t)
		var r: float = 0.0
		if i == 2:
			r = 0.60  # peak at t=0.10
		else:
			r = 0.30
		s["shoulder"] = Vector3(0.2, 1.4, 0.0)
		s["wrist"] = Vector3(0.2, 1.4, -r)  # -z direction to match facing
		samples_snap.append(s)
	var hang_snap: float = PF.hang_s(samples_snap, facing)
	_check(hang_snap < 0.05, "snap peak hang should be < 0.05 s, got %.4f" % hang_snap)
	# Held 0.30 s at peak: boundary samples at threshold so interpolation is exact
	var samples_held: Array = []
	var times_held := [0.0, 0.05, 0.10, 0.15, 0.20, 0.25, 0.30, 0.35, 0.40, 0.45, 0.50]
	for t in times_held:
		var s := _guard_sample(t)
		s["shoulder"] = Vector3(0.2, 1.4, 0.0)
		var r: float = 0.30
		if t >= 0.10 and t <= 0.40:
			if t == 0.10 or t == 0.40:
				r = 0.55  # exactly at threshold (peak 0.60 - within 0.05)
			else:
				r = 0.60  # held peak
		s["wrist"] = Vector3(0.2, 1.4, -r)  # -z direction to match facing
		samples_held.append(s)
	var hang_held: float = PF.hang_s(samples_held, facing)
	_check(_approx(hang_held, 0.30, 0.02), "held peak hang should be ~0.30 s, got %.4f" % hang_held)
	# Double peak: reach goes to peak, dips, then back to peak - only count one run
	var samples_double: Array = []
	var times_dbl := [0.0, 0.05, 0.10, 0.15, 0.20, 0.25, 0.30, 0.35, 0.40, 0.45, 0.50]
	for t in times_dbl:
		var s := _guard_sample(t)
		s["shoulder"] = Vector3(0.2, 1.4, 0.0)
		var r: float = 0.30
		if t >= 0.10 and t <= 0.15:
			r = 0.60  # first peak
		elif t >= 0.25 and t <= 0.35:
			r = 0.60  # second (larger) peak
		elif t > 0.15 and t < 0.25:
			r = 0.40  # dip between
		s["wrist"] = Vector3(0.2, 1.4, -r)  # -z direction to match facing
		samples_double.append(s)
	var hang_dbl: float = PF.hang_s(samples_double, facing)
	# The second peak run is 0.25..0.35 = 0.10 s (plus interpolation edges)
	_check(hang_dbl < 0.20, "double peak hang should count only one run, got %.4f" % hang_dbl)


# Test 3: hang_s with uneven time gaps
func _test3_hang_uneven() -> void:
	var facing := Vector3(0.0, 0.0, -1.0)
	# Even samples: 0.0, 0.05, 0.10, 0.15, 0.20 - peak held from 0.05 to 0.15
	var samples_even: Array = []
	var times_even := [0.0, 0.05, 0.10, 0.15, 0.20]
	for t in times_even:
		var s := _guard_sample(t)
		s["shoulder"] = Vector3(0.2, 1.4, 0.0)
		var r: float = 0.30
		if t >= 0.05 and t <= 0.15:
			r = 0.60
		s["wrist"] = Vector3(0.2, 1.4, -r)  # -z direction to match facing
		samples_even.append(s)
	var hang_even: float = PF.hang_s(samples_even, facing)
	# Uneven samples: same shape but irregular times
	var samples_uneven: Array = []
	var times_uneven := [0.0, 0.02, 0.05, 0.15, 0.20]
	for t in times_uneven:
		var s := _guard_sample(t)
		s["shoulder"] = Vector3(0.2, 1.4, 0.0)
		var r: float = 0.30
		if t >= 0.05 and t <= 0.15:
			r = 0.60
		s["wrist"] = Vector3(0.2, 1.4, -r)  # -z direction to match facing
		samples_uneven.append(s)
	var hang_uneven: float = PF.hang_s(samples_uneven, facing)
	_check(_approx(hang_even, hang_uneven, 0.02), "uneven gaps should give same hang: even=%.4f uneven=%.4f" % [hang_even, hang_uneven])


# Test 4: other_glove
func _test4_other_glove() -> void:
	# chin = head.y - 0.10
	# other wrist 0.20 m under chin
	var samples_low: Array = []
	for i in range(5):
		var t: float = i * 0.05
		var s := _guard_sample(t)
		s["head"] = Vector3(0.0, 1.6, 0.0)
		s["other_wrist"] = Vector3(-0.1, 1.30, 0.0)  # chin=1.50, wrist=1.30, diff=0.20
		samples_low.append(s)
	var og_low: Dictionary = PF.other_glove(samples_low, 0.0, 0.20)
	var low_m: float = og_low["low_m"]
	_check(_approx(low_m, 0.20, 0.01), "other glove 0.20 under chin should read 0.20, got %.4f" % low_m)
	# other wrist at chin
	var samples_at: Array = []
	for i in range(5):
		var t: float = i * 0.05
		var s := _guard_sample(t)
		s["head"] = Vector3(0.0, 1.6, 0.0)
		s["other_wrist"] = Vector3(-0.1, 1.50, 0.0)  # chin=1.50, wrist=1.50
		samples_at.append(s)
	var og_at: Dictionary = PF.other_glove(samples_at, 0.0, 0.20)
	var low_at: float = og_at["low_m"]
	_check(low_at < 0.01, "other glove at chin should read <= 0, got %.4f" % low_at)


# Test 5: pre_drop
func _test5_pre_drop() -> void:
	# Wrist dropped 0.40 m under shoulder for 0.20 s before contact
	var samples_drop: Array = []
	var times_drop := [0.0, 0.05, 0.10, 0.15, 0.20, 0.25, 0.30]
	var contact_t: float = 0.30
	for t in times_drop:
		var s := _guard_sample(t)
		s["shoulder"] = Vector3(0.2, 1.4, 0.0)
		var wr_y: float = 1.4
		if t <= 0.20:
			wr_y = 1.0  # 0.40 m below shoulder
		else:
			wr_y = 1.4  # back up after 0.20
		s["wrist"] = Vector3(0.2, wr_y, 0.0)
		samples_drop.append(s)
	var pd: Dictionary = PF.pre_drop(samples_drop, contact_t, 0.25)
	var depth: float = pd["depth_m"]
	var held: float = pd["held_s"]
	_check(_approx(depth, 0.40, 0.01), "pre_drop depth should be 0.40, got %.4f" % depth)
	_check(_approx(held, 0.20, 0.02), "pre_drop held should be ~0.20, got %.4f" % held)
	# Drop AFTER contact should not be counted
	var samples_after: Array = []
	var times_after := [0.0, 0.05, 0.10, 0.15, 0.20]
	var contact_after: float = 0.10
	for t in times_after:
		var s := _guard_sample(t)
		s["shoulder"] = Vector3(0.2, 1.4, 0.0)
		var wr_y: float = 1.4
		if t > contact_after:
			wr_y = 1.0  # drop after contact
		s["wrist"] = Vector3(0.2, wr_y, 0.0)
		samples_after.append(s)
	var pd_after: Dictionary = PF.pre_drop(samples_after, contact_after, 0.25)
	_check(pd_after["depth_m"] <= 0.0, "drop after contact should not count, depth=%.4f" % pd_after["depth_m"])


# Test 6: finish_over_head
func _test6_finish_over_head() -> void:
	# Wrist 0.15 m above head top
	var samples_above: Array = []
	for i in range(5):
		var t: float = i * 0.05
		var s := _guard_sample(t)
		s["wrist"] = Vector3(0.1, 1.90, 0.0)  # head_top_y = 1.75
		samples_above.append(s)
	var finish_above: float = PF.finish_over_head(samples_above, 1.75)
	_check(_approx(finish_above, 0.15, 0.01), "wrist 0.15 above head should read +0.15, got %.4f" % finish_above)
	# Wrist at chin height (below head top)
	var samples_below: Array = []
	for i in range(5):
		var t: float = i * 0.05
		var s := _guard_sample(t)
		s["wrist"] = Vector3(0.1, 1.50, 0.0)  # head_top_y = 1.75
		samples_below.append(s)
	var finish_below: float = PF.finish_over_head(samples_below, 1.75)
	_check(finish_below < 0.0, "wrist at chin height should read negative, got %.4f" % finish_below)


# Test 7: bow_m
func _test7_bow() -> void:
	var facing := Vector3(0.0, 0.0, -1.0)
	# Head 0.12 m in front of lead knee along facing
	var samples_bow: Array = []
	var times_bow := [0.0, 0.05, 0.10, 0.15, 0.20]
	var contact_t: float = 0.10
	for t in times_bow:
		var s := _guard_sample(t)
		s["head"] = Vector3(0.0, 1.6, -0.12)  # 0.12 m in front (along -z facing)
		s["lead_knee"] = Vector3(0.0, 0.9, 0.0)
		samples_bow.append(s)
	var bow: float = PF.bow_m(samples_bow, contact_t, facing)
	_check(_approx(bow, 0.12, 0.01), "head 0.12 in front of knee should read 0.12, got %.4f" % bow)
	# Facing turned 90 degrees: facing along +x now
	var facing2 := Vector3(1.0, 0.0, 0.0)
	var samples_bow2: Array = []
	for t in times_bow:
		var s := _guard_sample(t)
		s["head"] = Vector3(0.12, 1.6, 0.0)  # 0.12 m in front along +x
		s["lead_knee"] = Vector3(0.0, 0.9, 0.0)
		samples_bow2.append(s)
	var bow2: float = PF.bow_m(samples_bow2, contact_t, facing2)
	_check(_approx(bow2, 0.12, 0.01), "facing 90 deg: head 0.12 in front should read 0.12, got %.4f" % bow2)


# Test 8: hip_turn_deg
func _test8_hip_turn() -> void:
	var samples_hip: Array = []
	var times_hip := [0.0, 0.05, 0.10]
	var t0: float = 0.0
	var contact_t: float = 0.10
	for t in times_hip:
		var s := _guard_sample(t)
		if t == t0:
			s["pelvis_yaw"] = deg_to_rad(170.0)
		else:
			s["pelvis_yaw"] = deg_to_rad(-170.0)
		samples_hip.append(s)
	var hip: float = PF.hip_turn_deg(samples_hip, t0, contact_t)
	_check(_approx(hip, 20.0, 0.5), "yaw 170 to -170 should be 20 deg, got %.2f" % hip)


# Test 9: back_s
func _test9_back_s() -> void:
	var guard_wrist := Vector3(0.1, 1.45, -0.15)
	var contact_t: float = 0.10
	# Wrist returns to guard at t=0.45 (0.35 s after contact)
	var samples_back: Array = []
	var times_back := [0.0, 0.05, 0.10, 0.15, 0.20, 0.25, 0.30, 0.35, 0.40, 0.45, 0.50]
	for t in times_back:
		var s := _guard_sample(t)
		if t <= contact_t:
			s["wrist"] = Vector3(0.5, 1.4, -0.3)  # extended
		elif t < 0.45:
			var frac: float = (t - contact_t) / (0.45 - contact_t)
			s["wrist"] = Vector3(0.5 - frac * 0.35, 1.4 + frac * 0.03, -0.3 + frac * 0.12)
		else:
			s["wrist"] = guard_wrist
		samples_back.append(s)
	var back: float = PF.back_s(samples_back, contact_t, guard_wrist, 0.10)
	_check(_approx(back, 0.35, 0.02), "back_s should be ~0.35, got %.4f" % back)
	# Never back
	var samples_never: Array = []
	for t in times_back:
		var s := _guard_sample(t)
		s["wrist"] = Vector3(0.5, 1.4, -0.3)  # stays extended
		samples_never.append(s)
	var back_never: float = PF.back_s(samples_never, contact_t, guard_wrist, 0.10)
	_check(_approx(back_never, -1.0, 0.001), "never back should be -1.0, got %.4f" % back_never)


# Test 10: empty and one-sample
func _test10_empty() -> void:
	var facing := Vector3(0.0, 0.0, -1.0)
	var guard_wrist := Vector3(0.1, 1.45, -0.15)
	var head_top_y: float = 1.75
	var contact_t: float = 0.10
	var t0: float = 0.0
	# Empty
	var m_empty: Dictionary = PF.measure([], facing, contact_t, guard_wrist, head_top_y, t0)
	_check(_approx(m_empty["elbow_deg"], 0.0), "empty elbow_deg should be 0, got %.4f" % m_empty["elbow_deg"])
	_check(_approx(m_empty["reach"], 0.0), "empty reach should be 0")
	_check(_approx(m_empty["hang_s"], 0.0), "empty hang_s should be 0")
	_check(_approx(m_empty["back_s"], -1.0), "empty back_s should be -1.0, got %.4f" % m_empty["back_s"])
	# One sample
	var one: Array = [_guard_sample(0.0)]
	var m_one: Dictionary = PF.measure(one, facing, contact_t, guard_wrist, head_top_y, t0)
	_check(_approx(m_one["elbow_deg"], 0.0), "one-sample elbow_deg should be 0, got %.4f" % m_one["elbow_deg"])
	_check(_approx(m_one["back_s"], -1.0), "one-sample back_s should be -1.0, got %.4f" % m_one["back_s"])


# Test 11: mutants - prove the test can fail
func _test11_mutants() -> void:
	var facing := Vector3(0.0, 0.0, -1.0)
	var guard_wrist := Vector3(0.1, 1.45, -0.15)
	var head_top_y: float = 1.75
	var contact_t: float = 0.10
	var t0: float = 0.0
	# Mutant: bad hang (held too long)
	var samples_bad_hang: Array = []
	var times_bh := [0.0, 0.05, 0.10, 0.15, 0.20, 0.25, 0.30, 0.35, 0.40, 0.45]
	for t in times_bh:
		var s := _guard_sample(t)
		s["shoulder"] = Vector3(0.2, 1.4, 0.0)
		var r: float = 0.30
		if t >= 0.05 and t <= 0.40:
			r = 0.60  # held 0.35 s
		s["wrist"] = Vector3(0.2, 1.4, -r)  # -z direction to match facing
		samples_bad_hang.append(s)
	var m_bad: Dictionary = PF.measure(samples_bad_hang, facing, contact_t, guard_wrist, head_top_y, t0)
	_check(m_bad["hang_s"] > 0.13, "mutant bad hang should be > 0.13, got %.4f" % m_bad["hang_s"])
	# Mutant: bad elbow (not straight enough)
	var samples_bad_elbow: Array = []
	for i in range(5):
		var t: float = i * 0.05
		var s := _guard_sample(t)
		s["shoulder"] = Vector3(0.0, 1.4, 0.0)
		s["elbow"] = Vector3(0.2, 1.4, 0.0)
		s["wrist"] = Vector3(0.3, 1.2, 0.0)  # ~120 deg, not 150+
		samples_bad_elbow.append(s)
	var m_bad2: Dictionary = PF.measure(samples_bad_elbow, facing, contact_t, guard_wrist, head_top_y, t0)
	_check(m_bad2["elbow_deg"] < 150.0, "mutant bad elbow should be < 150, got %.2f" % m_bad2["elbow_deg"])
	# Mutant: bad finish (wrist above head)
	var samples_bad_finish: Array = []
	for i in range(5):
		var t: float = i * 0.05
		var s := _guard_sample(t)
		s["wrist"] = Vector3(0.1, 1.95, 0.0)  # above head_top_y=1.75
		samples_bad_finish.append(s)
	var m_bad3: Dictionary = PF.measure(samples_bad_finish, facing, contact_t, guard_wrist, head_top_y, t0)
	_check(m_bad3["finish_over_head"] > 0.0, "mutant bad finish should be > 0, got %.4f" % m_bad3["finish_over_head"])
