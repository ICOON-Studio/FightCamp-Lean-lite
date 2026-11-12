extends RefCounted
## PunchSnap - what makes a punch read as POWERFUL on film, as numbers (pure, zero preloads).
## A coach's four looks: the body loads before the hand goes; hips, then shoulders, then fist;
## the fist is still speeding up when it lands; it stops dead and comes home.
## Samples: time-ordered Dictionaries (uneven gaps allowed) with the keys PunchForm.gd reads: `t` (s)
## plus Vector3 metres for shoulder, elbow, wrist (punching arm), l_/r_shoulder, l_/r_hip, pelvis,
## chest, head, l_/r_foot; a missing key reads as Vector3.ZERO. `facing`: unit, on the floor, at the
## opponent. Each measure names its "no data" value in its comment and never raises an error.
const EPS := 0.0001
const TURN_EPS := 0.001  # rad/s: a body line turning slower than this toward the punch is "not turning"

static func _t(samples: Array, i: int) -> float:
	var t: float = samples[i].get("t", 0.0)
	return t

static func _p(samples: Array, i: int, key: String) -> Vector3:
	var v: Vector3 = samples[i].get(key, Vector3.ZERO)
	return v

# Position of `key` at time t, straight-line between the two samples around t (clamped at the ends).
static func _interp(samples: Array, key: String, t: float) -> Vector3:
	var n: int = samples.size()
	if n == 0:
		return Vector3.ZERO
	for i in range(n - 1):
		var ta: float = _t(samples, i)
		var tb: float = _t(samples, i + 1)
		if t >= ta and t <= tb:
			var f: float = (t - ta) / (tb - ta) if tb - ta > EPS else 0.0
			return _p(samples, i, key).lerp(_p(samples, i + 1, key), f)
	return _p(samples, 0, key) if t <= _t(samples, 0) else _p(samples, n - 1, key)

static func _elbow_deg(s: Dictionary) -> float:
	var el: Vector3 = s.get("elbow", Vector3.ZERO)
	var a: Vector3 = s.get("shoulder", Vector3.ZERO) - el
	var b: Vector3 = s.get("wrist", Vector3.ZERO) - el
	if a.length() < EPS or b.length() < EPS:
		return 0.0
	return rad_to_deg(acos(clampf(a.dot(b) / (a.length() * b.length()), -1.0, 1.0)))

static func _floor(v: Vector3) -> Vector3:
	return Vector3(v.x, 0.0, v.z)

# Signed angle (degrees, -180..180) from d0 to d1 about the vertical axis.
static func _signed_angle_deg(d0: Vector3, d1: Vector3) -> float:
	return rad_to_deg(atan2(d0.cross(d1).y, d0.dot(d1)))

# Slope at time `at` of the curve through three points (exact for constant acceleration).
static func _quad_slope(ta: float, tb: float, tc: float, xa: float, xb: float, xc: float, at: float) -> float:
	if tb - ta < EPS or tc - tb < EPS:
		return (xc - xa) / (tc - ta) if tc - ta > EPS else 0.0
	var ca: float = ((at - tb) + (at - tc)) / ((ta - tb) * (ta - tc))
	var cb: float = ((at - ta) + (at - tc)) / ((tb - ta) * (tb - tc))
	var cc: float = ((at - ta) + (at - tb)) / ((tc - ta) * (tc - tb))
	return xa * ca + xb * cb + xc * cc

# Rate of change of xs over ts: three-point differences correct on uneven gaps, the ends one-sided.
static func _rate(ts: Array, xs: Array) -> Array:
	var n: int = ts.size()
	var out: Array = []
	for i in range(n):
		var v: float = 0.0
		if n == 2:
			var dt: float = ts[1] - ts[0]
			v = (xs[1] - xs[0]) / dt if dt > EPS else 0.0
		elif n >= 3:
			var j: int = clampi(i, 1, n - 2)
			v = _quad_slope(ts[j - 1], ts[j], ts[j + 1], xs[j - 1], xs[j], xs[j + 1], ts[i])
		out.append(v)
	return out

# 1. Hand speed: how fast the fist travels at the target (m/s). No data: []; one sample: v 0.0.
static func fist_speed(samples: Array, facing: Vector3) -> Array:
	var ts: Array = []
	var xs: Array = []
	for i in range(samples.size()):
		ts.append(_t(samples, i))
		xs.append(_p(samples, i, "wrist").dot(facing))
	var vs: Array = _rate(ts, xs)
	var out: Array = []
	for i in range(ts.size()):
		out.append({"t": ts[i], "v": vs[i]})
	return out

# 2. Top hand speed and when it came. No data (fewer than 2 samples): {t: 0.0, v: 0.0}.
static func peak_speed(samples: Array, facing: Vector3) -> Dictionary:
	if samples.size() < 2:
		return {"t": 0.0, "v": 0.0}
	var sp: Array = fist_speed(samples, facing)
	var bi: int = 0
	for i in range(1, sp.size()):
		if sp[i]["v"] > sp[bi]["v"]:
			bi = i
	return {"t": sp[bi]["t"], "v": sp[bi]["v"]}

static func _interp_speed(sp: Array, t: float) -> float:
	for i in range(sp.size() - 1):
		var t0: float = sp[i]["t"]
		var t1: float = sp[i + 1]["t"]
		if t >= t0 and t <= t1:
			var f: float = (t - t0) / (t1 - t0) if t1 - t0 > EPS else 0.0
			return sp[i]["v"] + f * (sp[i + 1]["v"] - sp[i]["v"])
	return sp[0]["v"] if t <= sp[0]["t"] else sp[sp.size() - 1]["v"]

# Top hand speed up to contact, the speed at contact included. {t: -1, v: 0} if it never went forward.
static func _peak_to_contact(sp: Array, contact_t: float) -> Dictionary:
	var best: Dictionary = {"t": -1.0, "v": 0.0}
	for s in sp:
		if s["t"] <= contact_t and s["v"] > best["v"]:
			best = {"t": s["t"], "v": s["v"]}
	var vc: float = _interp_speed(sp, contact_t)
	if vc > best["v"]:
		best = {"t": contact_t, "v": vc}
	return best

# 3. Still speeding up when it lands? Speed at contact over the top speed before it, 0..1
# (1.0 = heavy, toward 0 = a push; a fist already coming home at contact reads 0).
# No data (fewer than 2 samples or no forward speed): 0.0.
static func speed_at_contact_frac(samples: Array, facing: Vector3, contact_t: float) -> float:
	if samples.size() < 2:
		return 0.0
	var sp: Array = fist_speed(samples, facing)
	var pk: Dictionary = _peak_to_contact(sp, contact_t)
	if pk["v"] < 0.001:
		return 0.0
	return clampf(_interp_speed(sp, contact_t) / pk["v"], 0.0, 1.0)

# 4. How long before landing the hand hit top speed (positive = it is slowing as it lands).
# No data (fewer than 2 samples): 0.0.
static func peak_lead_s(samples: Array, facing: Vector3, contact_t: float) -> float:
	if samples.size() < 2:
		return 0.0
	var pk: Dictionary = peak_speed(samples, facing)
	return contact_t - pk["t"]

# 5. Does it stop dead? Seconds from contact until the hand slows under `frac` of its top speed
# before contact (crossing interpolated). -1 when it never does, and when there is no data.
static func stop_s(samples: Array, facing: Vector3, contact_t: float, frac: float = 0.2) -> float:
	if samples.size() < 2:
		return -1.0
	var sp: Array = fist_speed(samples, facing)
	var pk: Dictionary = _peak_to_contact(sp, contact_t)
	if pk["v"] < 0.001:
		return -1.0
	var thr: float = frac * pk["v"]
	var prev_t: float = contact_t
	var prev_v: float = _interp_speed(sp, contact_t)
	if prev_v < thr:
		return 0.0
	for s in sp:
		if s["t"] <= contact_t:
			continue
		if s["v"] < thr:
			return prev_t + (prev_v - thr) / (prev_v - s["v"]) * (s["t"] - prev_t) - contact_t
		prev_t = s["t"]
		prev_v = s["v"]
	return -1.0

# 6. How fast the arm snaps straight: seconds for the elbow to open from from_deg to to_deg on the
# way out (the first such run before the longest reach), crossings interpolated.
# -1 when the arm never passes both angles, and when there is no data.
static func straighten_s(samples: Array, from_deg: float = 100.0, to_deg: float = 160.0) -> float:
	if samples.size() < 2:
		return -1.0
	var max_d: float = -1.0
	var max_i: int = 0
	for i in range(samples.size()):
		var d: float = (_p(samples, i, "wrist") - _p(samples, i, "shoulder")).length()
		if d > max_d:
			max_d = d
			max_i = i
	# found_from, not the sign of t_from: sample times may be negative (a clip timed from contact).
	var found_from: bool = false
	var t_from: float = 0.0
	var ed_prev: float = _elbow_deg(samples[0])
	for i in range(1, max_i + 1):
		var ed: float = _elbow_deg(samples[i])
		var t0: float = _t(samples, i - 1)
		var t1: float = _t(samples, i)
		if ed_prev < from_deg and ed >= from_deg:
			t_from = t0 + (from_deg - ed_prev) / (ed - ed_prev) * (t1 - t0)
			found_from = true
		elif ed < from_deg:
			found_from = false
		if found_from and ed_prev < to_deg and ed >= to_deg:
			var t_to: float = t0 + (to_deg - ed_prev) / (ed - ed_prev) * (t1 - t0)
			return t_to - t_from
		ed_prev = ed
	return -1.0

# 7. The load: how far the fist draws back from the target (measured from the hips) before contact,
# and when it was furthest back. 0 when it only goes forward (at_t = the first sample's time).
# No data: {back_m: 0.0, at_t: 0.0}.
static func windup_m(samples: Array, facing: Vector3, contact_t: float) -> Dictionary:
	if samples.is_empty():
		return {"back_m": 0.0, "at_t": 0.0}
	var d_start: float = (_p(samples, 0, "wrist") - _p(samples, 0, "pelvis")).dot(facing)
	var min_d: float = d_start
	var min_t: float = _t(samples, 0)
	for i in range(samples.size()):
		var t: float = _t(samples, i)
		if t > contact_t:
			break
		var d: float = (_p(samples, i, "wrist") - _p(samples, i, "pelvis")).dot(facing)
		if d < min_d:
			min_d = d
			min_t = t
	return {"back_m": d_start - min_d, "at_t": min_t}

# 8. How far a line across the body (a to b) turned between two moments, in degrees (-180..180,
# seen from above). No data (a point on top of the other): 0.0.
static func turn_deg(a0: Vector3, b0: Vector3, a1: Vector3, b1: Vector3) -> float:
	var d0: Vector3 = _floor(b0 - a0)
	var d1: Vector3 = _floor(b1 - a1)
	if d0.length() < EPS or d1.length() < EPS:
		return 0.0
	return _signed_angle_deg(d0, d1)

static func _line_turn(samples: Array, lkey: String, rkey: String, t0: float, t1: float, right: bool) -> float:
	var ang: float = turn_deg(_interp(samples, lkey, t0), _interp(samples, rkey, t0),
		_interp(samples, lkey, t1), _interp(samples, rkey, t1))
	return ang if right else -ang

# 8b. Shoulder turn, t0 to contact: punching shoulder driving in = positive, wrong way negative. No data: 0.0.
static func shoulder_turn_deg(samples: Array, t0: float, contact_t: float, punching_right: bool) -> float:
	return _line_turn(samples, "l_shoulder", "r_shoulder", t0, contact_t, punching_right)

# 8c. Hip turn, t0 to contact: punching-side hip driving in = positive, wrong way negative. No data: 0.0.
static func hip_turn_signed_deg(samples: Array, t0: float, contact_t: float, punching_right: bool) -> float:
	return _line_turn(samples, "l_hip", "r_hip", t0, contact_t, punching_right)

# When a body line turned fastest toward the punching side, up to contact. -1 when it never did.
static func _fastest_turn_t(samples: Array, lkey: String, rkey: String, contact_t: float, right: bool) -> float:
	var ts: Array = [_t(samples, 0)]
	var angs: Array = [0.0]
	for i in range(1, samples.size()):
		var da: float = turn_deg(_p(samples, i - 1, lkey), _p(samples, i - 1, rkey), _p(samples, i, lkey), _p(samples, i, rkey))
		ts.append(_t(samples, i))
		angs.append(angs[i - 1] + deg_to_rad(da if right else -da))
	var w: Array = _rate(ts, angs)
	var best_t: float = -1.0
	var best_w: float = TURN_EPS
	for i in range(ts.size()):
		if ts[i] <= contact_t and w[i] > best_w:
			best_w = w[i]
			best_t = ts[i]
	return best_t

# 9. Hips, then shoulders, then fist? The times of the fastest hip turn and shoulder turn toward the
# punch and of the top hand speed, all up to contact; ordered = hip_t <= shoulder_t <= fist_t
# (thrown from the ground up; an arm punch has the fist first). A part that never turns or moves
# reads -1 and the punch is not ordered. No data (fewer than 3 samples): all -1, ordered false.
static func chain_order(samples: Array, facing: Vector3, contact_t: float, punching_right: bool) -> Dictionary:
	if samples.size() < 3:
		return {"hip_t": -1.0, "shoulder_t": -1.0, "fist_t": -1.0, "ordered": false}
	var hip_t: float = _fastest_turn_t(samples, "l_hip", "r_hip", contact_t, punching_right)
	var sh_t: float = _fastest_turn_t(samples, "l_shoulder", "r_shoulder", contact_t, punching_right)
	var fist_t: float = _peak_to_contact(fist_speed(samples, facing), contact_t)["t"]
	var ordered: bool = hip_t >= 0.0 and sh_t >= 0.0 and fist_t >= 0.0 and hip_t <= sh_t and sh_t <= fist_t
	return {"hip_t": hip_t, "shoulder_t": sh_t, "fist_t": fist_t, "ordered": ordered}

# 10. Weight going in: how far the hips (pelvis), chest and head travel at the target from t0 to
# contact (both ends interpolated). No data: all 0.0.
static func weight_m(samples: Array, facing: Vector3, t0: float, contact_t: float) -> Dictionary:
	var out: Dictionary = {}
	for k in ["pelvis", "chest", "head"]:
		out[k + "_m"] = (_interp(samples, k, contact_t) - _interp(samples, k, t0)).dot(facing)
	return out

# 11. Rear heel up: the most the punching-side foot rises between t0 and contact, above its height
# at t0 (both ends interpolated). No data: 0.0.
static func rear_heel_lift_m(samples: Array, t0: float, contact_t: float, punching_right: bool) -> float:
	var fkey: String = "r_foot" if punching_right else "l_foot"
	var y0: float = _interp(samples, fkey, t0).y
	var max_y: float = maxf(y0, _interp(samples, fkey, contact_t).y)
	for i in range(samples.size()):
		var t: float = _t(samples, i)
		if t > t0 and t < contact_t:
			max_y = maxf(max_y, _p(samples, i, fkey).y)
	return max_y - y0

# 12. The whole power read in one Dictionary of plain numbers (chain_ordered is a yes/no).
# No data: each entry holds its measure's own no-data value.
static func read(samples: Array, facing: Vector3, contact_t: float, t0: float, punching_right: bool) -> Dictionary:
	var pk: Dictionary = peak_speed(samples, facing)
	var co: Dictionary = chain_order(samples, facing, contact_t, punching_right)
	var w: Dictionary = weight_m(samples, facing, t0, contact_t)
	var wi: Dictionary = windup_m(samples, facing, contact_t)
	return {
		"peak_speed_v": pk["v"], "peak_speed_t": pk["t"],
		"speed_at_contact_frac": speed_at_contact_frac(samples, facing, contact_t),
		"peak_lead_s": peak_lead_s(samples, facing, contact_t),
		"stop_s": stop_s(samples, facing, contact_t),
		"straighten_s": straighten_s(samples),
		"windup_back_m": wi["back_m"], "windup_at_t": wi["at_t"],
		"shoulder_turn_deg": shoulder_turn_deg(samples, t0, contact_t, punching_right),
		"hip_turn_signed_deg": hip_turn_signed_deg(samples, t0, contact_t, punching_right),
		"chain_hip_t": co["hip_t"], "chain_shoulder_t": co["shoulder_t"],
		"chain_fist_t": co["fist_t"], "chain_ordered": co["ordered"],
		"weight_pelvis_m": w["pelvis_m"], "weight_chest_m": w["chest_m"], "weight_head_m": w["head_m"],
		"rear_heel_lift_m": rear_heel_lift_m(samples, t0, contact_t, punching_right)}
