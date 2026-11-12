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


## Hang window: the single continuous run around the peak where reach stays within `within` of the peak
## reach, edges interpolated linearly. Returns {left_t, right_t, peak_t, peak_reach, hang_s}. A run that reaches
## the first (last) sample starts (ends) there. S438 CLIPFIX4: the ruler, the retime tool and the retime test all
## read this one walk, so the hang is one number everywhere.
static func hang_window(samples: Array, facing: Vector3, within: float = 0.05) -> Dictionary:
	if samples.size() < 2:
		return {"left_t": 0.0, "right_t": 0.0, "peak_t": 0.0, "peak_reach": 0.0, "hang_s": 0.0}
	var peak_idx: int = 0
	var peak_reach: float = reach(samples[0], facing)
	for i in range(1, samples.size()):
		var r: float = reach(samples[i], facing)
		if r > peak_reach:
			peak_reach = r
			peak_idx = i
	var threshold: float = peak_reach - within
	var left_t: float = samples[0].get("t", 0.0)
	for i in range(peak_idx, 0, -1):
		var r_curr: float = reach(samples[i], facing)
		var r_prev: float = reach(samples[i - 1], facing)
		if r_prev < threshold:
			var t_curr: float = samples[i].get("t", 0.0)
			var t_prev: float = samples[i - 1].get("t", 0.0)
			var frac: float = (threshold - r_prev) / (r_curr - r_prev)
			left_t = t_prev + frac * (t_curr - t_prev)
			break
	var right_t: float = samples[samples.size() - 1].get("t", 0.0)
	for i in range(peak_idx, samples.size() - 1):
		var r_here: float = reach(samples[i], facing)
		var r_next: float = reach(samples[i + 1], facing)
		if r_next < threshold:
			var t_here: float = samples[i].get("t", 0.0)
			var t_next: float = samples[i + 1].get("t", 0.0)
			var frac2: float = (threshold - r_here) / (r_next - r_here)
			right_t = t_here + frac2 * (t_next - t_here)
			break
	return {"left_t": left_t, "right_t": right_t, "peak_t": float(samples[peak_idx].get("t", 0.0)),
		"peak_reach": peak_reach, "hang_s": right_t - left_t}


## Hang time: seconds of the hang window (see hang_window).
static func hang_s(samples: Array, facing: Vector3, within: float = 0.05) -> float:
	return float(hang_window(samples, facing, within)["hang_s"])


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


## Bow: at contact (interpolated), head minus lead_knee along facing. S438 CLIPFIX4: `joint` names the sample key to
## measure against (default the lead knee; the ruler also prints the head over the lead hip as information).
static func bow_m(samples: Array, contact_t: float, facing: Vector3, joint: String = "lead_knee") -> float:
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
	var knee0: Vector3 = s0.get(joint, Vector3.ZERO)
	var knee1: Vector3 = s1.get(joint, Vector3.ZERO)
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


## Back time: seconds from contact until the wrist is first within `within` of guard_wrist. Returns -1.0 if it
## never is. S438 CLIPFIX4: both sides are relative to the pelvis - each sample's wrist minus its own "hips" (a
## sample without "hips" reads hips at the origin, i.e. absolute) - so pass the guard wrist relative to the pelvis.
static func back_s(samples: Array, contact_t: float, guard_wrist: Vector3, within: float = 0.10) -> float:
	if samples.is_empty():
		return -1.0
	for s in samples:
		var t: float = s.get("t", 0.0)
		if t <= contact_t:
			continue
		var wrist_rel: Vector3 = s.get("wrist", Vector3.ZERO) - s.get("hips", Vector3.ZERO)
		if wrist_rel.distance_to(guard_wrist) <= within:
			return t - contact_t
	return -1.0


## S438 CLIPFIX4: the other glove's largest displacement from its own guard spot (both relative to the pelvis),
## metres. A sample without "hips" reads hips at the origin.
static func other_glove_from_guard(samples: Array, guard_rel: Vector3) -> float:
	var far_m: float = 0.0
	for s in samples:
		var rel: Vector3 = s.get("other_wrist", Vector3.ZERO) - s.get("hips", Vector3.ZERO)
		far_m = maxf(far_m, rel.distance_to(guard_rel))
	return far_m


## S438 CLIPFIX4: the largest wrist-to-shoulder distance over the arm's own length (upper arm + forearm) in any
## sample. A straight arm reads 1.0, a bent arm less.
static func reach_frac_max(samples: Array) -> float:
	var best: float = 0.0
	for s in samples:
		var sh: Vector3 = s.get("shoulder", Vector3.ZERO)
		var el: Vector3 = s.get("elbow", Vector3.ZERO)
		var wr: Vector3 = s.get("wrist", Vector3.ZERO)
		var arm_len: float = sh.distance_to(el) + el.distance_to(wr)
		if arm_len < 0.01:
			continue
		best = maxf(best, wr.distance_to(sh) / arm_len)
	return best


## S439 CLIPFIX4 (LEAD RULING S439 R10, a number for the eye and PUNCHSNAP1, no bar): the extension hold - seconds of
## the one continuous run around the peak where the 3D hand-to-shoulder (UpperArm joint) distance stays within `within`
## of its peak, edges interpolated as hang_window's. Unlike hang_s it ignores the facing direction.
static func extension_hold_s(samples: Array, within: float = 0.05) -> float:
	if samples.size() < 2:
		return 0.0
	var d: Array = []
	var pk: int = 0
	for i in samples.size():
		d.append((samples[i].get("wrist", Vector3.ZERO) as Vector3).distance_to(samples[i].get("shoulder", Vector3.ZERO)))
		if float(d[i]) > float(d[pk]):
			pk = i
	var thr: float = float(d[pk]) - within
	var left_t: float = float(samples[0].get("t", 0.0))
	for i in range(pk, 0, -1):
		if float(d[i - 1]) < thr:
			var f: float = (thr - float(d[i - 1])) / (float(d[i]) - float(d[i - 1]))
			left_t = lerpf(float(samples[i - 1].get("t", 0.0)), float(samples[i].get("t", 0.0)), f)
			break
	var right_t: float = float(samples[samples.size() - 1].get("t", 0.0))
	for i in range(pk, samples.size() - 1):
		if float(d[i + 1]) < thr:
			var f2: float = (thr - float(d[i])) / (float(d[i + 1]) - float(d[i]))
			right_t = lerpf(float(samples[i].get("t", 0.0)), float(samples[i + 1].get("t", 0.0)), f2)
			break
	return right_t - left_t


## The sample pair bracketing time t and the fraction between them: [s0, s1, frac].
static func _bracket(samples: Array, t: float) -> Array:
	var idx: int = samples.size() - 1
	for i in range(samples.size() - 1):
		if t <= float(samples[i + 1].get("t", 0.0)):
			idx = i
			break
	var s0: Dictionary = samples[idx]
	var s1: Dictionary = samples[idx + 1] if idx + 1 < samples.size() else samples[idx]
	var t0: float = s0.get("t", 0.0)
	var t1: float = s1.get("t", 0.0)
	var frac: float = clampf((t - t0) / (t1 - t0), 0.0, 1.0) if t1 > t0 else 0.0
	return [s0, s1, frac]


## S438 CLIPFIX4: how far forward the punching wrist is at time t (interpolated), from `origin` along facing,
## metres. The ruler passes the pelvis at the clip's first frame: a short punch reads small.
static func forward_at(samples: Array, t: float, origin: Vector3, facing: Vector3) -> float:
	if samples.is_empty():
		return 0.0
	var b: Array = _bracket(samples, t)
	var w: Vector3 = (b[0] as Dictionary).get("wrist", Vector3.ZERO).lerp((b[1] as Dictionary).get("wrist", Vector3.ZERO), b[2])
	return (w - origin).dot(facing)


## S438 CLIPFIX4: the elbow angle at time t (joints interpolated), degrees - a hook's elbow is read at contact.
static func elbow_at(samples: Array, t: float) -> float:
	if samples.is_empty():
		return 0.0
	var b: Array = _bracket(samples, t)
	var s0: Dictionary = b[0]
	var s1: Dictionary = b[1]
	var f: float = b[2]
	var s := {}
	for k in ["shoulder", "elbow", "wrist"]:
		s[k] = (s0.get(k, Vector3.ZERO) as Vector3).lerp(s1.get(k, Vector3.ZERO) as Vector3, f)
	return elbow_deg(s)


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
