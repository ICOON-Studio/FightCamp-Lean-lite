extends RefCounted
## PunchForm - the maths of a punch's form (pure module).
##
## Given sampled joint positions over time, computes geometric measures of punch quality:
## elbow angle, reach, hang time at peak, other glove position, wrist drop, finish height,
## bow (head forward bend), hip turn, and return to guard time.
##
## PURE: zero preloads of scenes, no autoload, no Node access, no file/network access.

## Angle at the elbow in degrees. 180 = straight arm, 90 = right angle.
## Vector from elbow to shoulder and elbow to wrist; angle between them.
static func elbow_deg(s: Dictionary) -> float:
	var shoulder: Vector3 = s.get("shoulder", Vector3.ZERO)
	var elbow: Vector3 = s.get("elbow", Vector3.ZERO)
	var wrist: Vector3 = s.get("wrist", Vector3.ZERO)
	var to_shoulder: Vector3 = shoulder - elbow
	var to_wrist: Vector3 = wrist - elbow
	var len1: float = to_shoulder.length()
	var len2: float = to_wrist.length()
	if len1 < 0.0001 or len2 < 0.0001:
		return 0.0
	var dot_val: float = to_shoulder.dot(to_wrist) / (len1 * len2)
	dot_val = clampf(dot_val, -1.0, 1.0)
	return rad_to_deg(acos(dot_val))


## Reach: wrist minus shoulder, projected along facing direction (metres).
static func reach(s: Dictionary, facing: Vector3) -> float:
	var shoulder: Vector3 = s.get("shoulder", Vector3.ZERO)
	var wrist: Vector3 = s.get("wrist", Vector3.ZERO)
	var arm: Vector3 = wrist - shoulder
	return arm.dot(facing)


## Peak: the sample with the largest reach. Returns {t, reach, elbow_deg}.
static func peak(samples: Array, facing: Vector3) -> Dictionary:
	if samples.is_empty():
		return {"t": 0.0, "reach": 0.0, "elbow_deg": 0.0}
	var best_idx: int = 0
	var best_reach: float = reach(samples[0], facing)
	for i in range(1, samples.size()):
		var r: float = reach(samples[i], facing)
		if r > best_reach:
			best_reach = r
			best_idx = i
	var s: Dictionary = samples[best_idx]
	var t: float = s.get("t", 0.0)
	var ed: float = elbow_deg(s)
	return {"t": t, "reach": best_reach, "elbow_deg": ed}


## Hang time: seconds of the single continuous run around the peak where reach stays
## within `within` of the peak reach. Interpolates the run's edges linearly.
static func hang_s(samples: Array, facing: Vector3, within: float = 0.05) -> float:
	if samples.size() < 2:
		return 0.0
	# Find peak index
	var peak_idx: int = 0
	var peak_reach: float = reach(samples[0], facing)
	for i in range(1, samples.size()):
		var r: float = reach(samples[i], facing)
		if r > peak_reach:
			peak_reach = r
			peak_idx = i
	var threshold: float = peak_reach - within
	# Walk backward from peak to find left edge (S438: a run that reaches the first sample starts there)
	var left_t: float = samples[0].get("t", 0.0)
	for i in range(peak_idx, 0, -1):
		var r_curr: float = reach(samples[i], facing)
		var r_prev: float = reach(samples[i - 1], facing)
		if r_prev < threshold:
			# Interpolate crossing
			var t_curr: float = samples[i].get("t", 0.0)
			var t_prev: float = samples[i - 1].get("t", 0.0)
			var frac: float = (threshold - r_prev) / (r_curr - r_prev)
			left_t = t_prev + frac * (t_curr - t_prev)
			break
	# Walk forward from peak to find right edge (S438: a run that reaches the last sample ends there)
	var right_t: float = samples[samples.size() - 1].get("t", 0.0)
	for i in range(peak_idx, samples.size() - 1):
		var r_curr: float = reach(samples[i], facing)
		var r_next: float = reach(samples[i + 1], facing)
		if r_next < threshold:
			# Interpolate crossing
			var t_curr: float = samples[i].get("t", 0.0)
			var t_next: float = samples[i + 1].get("t", 0.0)
			var frac: float = (threshold - r_curr) / (r_next - r_curr)
			right_t = t_curr + frac * (t_next - t_curr)
			break
	return right_t - left_t


## Other glove: how much the other wrist goes under the chin and how far from chin.
## chin = head.y - 0.10. Returns {low_m, far_m}.
static func other_glove(samples: Array, t0: float, t1: float) -> Dictionary:
	var low_m: float = 0.0
	var far_m: float = 0.0
	for s in samples:
		var t: float = s.get("t", 0.0)
		if t < t0 or t > t1:
			continue
		var head: Vector3 = s.get("head", Vector3.ZERO)
		var ow: Vector3 = s.get("other_wrist", Vector3.ZERO)
		var chin_y: float = head.y - 0.10
		var chin_pt: Vector3 = Vector3(head.x, chin_y, head.z)
		var drop: float = chin_y - ow.y
		if drop > low_m:
			low_m = drop
		var dist: float = ow.distance_to(chin_pt)
		if dist > far_m:
			far_m = dist
	return {"low_m": low_m, "far_m": far_m}


## Pre-drop: how much the wrist drops under its own shoulder before contact.
## Returns {depth_m, held_s}. depth_m = max drop (positive = below).
## held_s = seconds it stays more than `deep` below (longest continuous run).
static func pre_drop(samples: Array, contact_t: float, deep: float = 0.25) -> Dictionary:
	var depth_m: float = 0.0
	# Find max drop before contact
	for s in samples:
		var t: float = s.get("t", 0.0)
		if t >= contact_t:
			continue
		var shoulder: Vector3 = s.get("shoulder", Vector3.ZERO)
		var wrist: Vector3 = s.get("wrist", Vector3.ZERO)
		var drop: float = shoulder.y - wrist.y
		if drop > depth_m:
			depth_m = drop
	# Find longest continuous run where drop > deep
	var held_s: float = 0.0
	var run_start: float = -1.0
	var run_end: float = -1.0
	for s in samples:
		var t: float = s.get("t", 0.0)
		if t >= contact_t:
			break
		var shoulder: Vector3 = s.get("shoulder", Vector3.ZERO)
		var wrist: Vector3 = s.get("wrist", Vector3.ZERO)
		var drop: float = shoulder.y - wrist.y
		if drop > deep:
			if run_start < 0.0:
				run_start = t
			run_end = t
		else:
			if run_start >= 0.0:
				var dur: float = run_end - run_start
				if dur > held_s:
					held_s = dur
				run_start = -1.0
				run_end = -1.0
	if run_start >= 0.0:
		var dur: float = run_end - run_start
		if dur > held_s:
			held_s = dur
	return {"depth_m": depth_m, "held_s": held_s}


## Finish over head: wrist's highest y minus head_top_y (positive = above head).
static func finish_over_head(samples: Array, head_top_y: float) -> float:
	var max_y: float = -INF
	for s in samples:
		var wrist: Vector3 = s.get("wrist", Vector3.ZERO)
		if wrist.y > max_y:
			max_y = wrist.y
	if max_y == -INF:
		return 0.0
	return max_y - head_top_y


## Bow: at contact (interpolated), head minus lead_knee along facing.
static func bow_m(samples: Array, contact_t: float, facing: Vector3) -> float:
	if samples.is_empty():
		return 0.0
	# Find the two samples bracketing contact_t
	var idx: int = 0
	for i in range(samples.size() - 1):
		var t0: float = samples[i].get("t", 0.0)
		var t1: float = samples[i + 1].get("t", 0.0)
		if contact_t >= t0 and contact_t <= t1:
			idx = i
			break
	var s0: Dictionary = samples[idx]
	var s1: Dictionary = samples[idx + 1] if idx + 1 < samples.size() else samples[idx]
	var t0: float = s0.get("t", 0.0)
	var t1: float = s1.get("t", 0.0)
	var frac: float = 0.0
	if t1 > t0:
		frac = (contact_t - t0) / (t1 - t0)
	var head0: Vector3 = s0.get("head", Vector3.ZERO)
	var head1: Vector3 = s1.get("head", Vector3.ZERO)
	var knee0: Vector3 = s0.get("lead_knee", Vector3.ZERO)
	var knee1: Vector3 = s1.get("lead_knee", Vector3.ZERO)
	var head_interp: Vector3 = head0.lerp(head1, frac)
	var knee_interp: Vector3 = knee0.lerp(knee1, frac)
	var diff: Vector3 = head_interp - knee_interp
	return diff.dot(facing)


## Hip turn: pelvis yaw change from t0 to contact_t, wrapped to [-180, 180], in degrees.
static func hip_turn_deg(samples: Array, t0: float, contact_t: float) -> float:
	if samples.is_empty():
		return 0.0
	# Find yaw at t0
	var yaw0: float = 0.0
	for s in samples:
		var t: float = s.get("t", 0.0)
		if t >= t0:
			yaw0 = s.get("pelvis_yaw", 0.0)
			break
	# Find yaw at contact_t
	var yaw1: float = 0.0
	for i in range(samples.size() - 1, -1, -1):
		var t: float = samples[i].get("t", 0.0)
		if t <= contact_t:
			yaw1 = samples[i].get("pelvis_yaw", 0.0)
			break
	var diff_rad: float = yaw1 - yaw0
	var diff_deg: float = rad_to_deg(diff_rad)
	# Wrap to [-180, 180]
	while diff_deg > 180.0:
		diff_deg -= 360.0
	while diff_deg < -180.0:
		diff_deg += 360.0
	return abs(diff_deg)


## Back time: seconds from contact until wrist is first within `within` of guard_wrist.
## Returns -1.0 if it never is.
static func back_s(samples: Array, contact_t: float, guard_wrist: Vector3, within: float = 0.10) -> float:
	if samples.is_empty():
		return -1.0
	# Find first sample after contact where wrist is within `within` of guard
	for s in samples:
		var t: float = s.get("t", 0.0)
		if t <= contact_t:
			continue
		var wrist: Vector3 = s.get("wrist", Vector3.ZERO)
		var dist: float = wrist.distance_to(guard_wrist)
		if dist <= within:
			return t - contact_t
	return -1.0


## Measure: all of the above in one Dictionary.
static func measure(samples: Array, facing: Vector3, contact_t: float, guard_wrist: Vector3, head_top_y: float, t0: float) -> Dictionary:
	if samples.is_empty():
		return {
			"elbow_deg": 0.0,
			"reach": 0.0,
			"hang_s": 0.0,
			"other_glove_low_m": 0.0,
			"other_glove_far_m": 0.0,
			"pre_drop_depth_m": 0.0,
			"pre_drop_held_s": 0.0,
			"finish_over_head": 0.0,
			"bow_m": 0.0,
			"hip_turn_deg": 0.0,
			"back_s": -1.0
		}
	if samples.size() == 1:
		return {
			"elbow_deg": 0.0,
			"reach": 0.0,
			"hang_s": 0.0,
			"other_glove_low_m": 0.0,
			"other_glove_far_m": 0.0,
			"pre_drop_depth_m": 0.0,
			"pre_drop_held_s": 0.0,
			"finish_over_head": 0.0,
			"bow_m": 0.0,
			"hip_turn_deg": 0.0,
			"back_s": -1.0
		}
	var pk: Dictionary = peak(samples, facing)
	# S438: the other glove is read over the whole strike, out AND back (the cross's lead glove drops after contact)
	var og: Dictionary = other_glove(samples, t0, float(samples[samples.size() - 1].get("t", contact_t)))
	var pd: Dictionary = pre_drop(samples, contact_t)
	return {
		"elbow_deg": pk["elbow_deg"],
		"reach": pk["reach"],
		"hang_s": hang_s(samples, facing),
		"other_glove_low_m": og["low_m"],
		"other_glove_far_m": og["far_m"],
		"pre_drop_depth_m": pd["depth_m"],
		"pre_drop_held_s": pd["held_s"],
		"finish_over_head": finish_over_head(samples, head_top_y),
		"bow_m": bow_m(samples, contact_t, facing),
		"hip_turn_deg": hip_turn_deg(samples, t0, contact_t),
		"back_s": back_s(samples, contact_t, guard_wrist)
	}
