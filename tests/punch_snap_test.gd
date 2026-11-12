extends SceneTree
## PunchSnap: tests for the punch power read. Samples are built by hand from motion whose answer is
## known; every expected number is arithmetic on that motion, never a copy of the module's output.
## Each measure is checked with the whole scene turned 0, 90 and 180 degrees in the world.
## MUTANTS: buggy copies of four measures run the SAME asserts and must fail them.

const PS := preload("res://scripts/rules/PunchSnap.gd")
const FACE := Vector3(0.0, 0.0, -1.0)
const ROTS := [0.0, 90.0, 180.0]
const WRIST0 := Vector3(0.45, 1.38, -0.1)
const PELVIS0 := Vector3(0.0, 1.0, 0.0)
const NODATA := {"peak_speed_v": 0.0, "peak_speed_t": 0.0, "speed_at_contact_frac": 0.0, "peak_lead_s": 0.0,
	"stop_s": -1.0, "straighten_s": -1.0, "windup_back_m": 0.0, "windup_at_t": 0.0, "shoulder_turn_deg": 0.0,
	"hip_turn_signed_deg": 0.0, "chain_hip_t": -1.0, "chain_shoulder_t": -1.0, "chain_fist_t": -1.0,
	"chain_ordered": false, "weight_pelvis_m": 0.0, "weight_chest_m": 0.0, "weight_head_m": 0.0,
	"rear_heel_lift_m": 0.0}
var failures := 0
var _muted := false
var _mut_fails := 0

func _initialize() -> void:
	_b_speed(Callable(PS, "fist_speed"))
	_b_contact(Callable(PS, "speed_at_contact_frac"))
	_b_stop(Callable(PS, "stop_s"))
	_b_straighten(Callable(PS, "straighten_s"))
	_b_windup(Callable(PS, "windup_m"))
	_b_turn(Callable(PS, "shoulder_turn_deg"), "l_shoulder", "r_shoulder")
	_b_turn(Callable(PS, "hip_turn_signed_deg"), "l_hip", "r_hip")
	_b_chain(Callable(PS, "chain_order"))
	_b_weight(Callable(PS, "weight_m"))
	_b_heel(Callable(PS, "rear_heel_lift_m"))
	_t_wrap()
	_t_no_data()
	_t_read()
	_mutant("weight_m with the interpolation dropped", _b_weight, _mut_weight_m)
	_mutant("shoulder turn without the left-hand flip", _b_turn.bind("l_shoulder", "r_shoulder"), _mut_shoulder_turn)
	_mutant("fist_speed as a plain secant", _b_speed, _mut_fist_speed)
	_mutant("chain_order without the shoulder check", _b_chain, _mut_chain_order)
	_mutant("chain_order without the hip-before-shoulder check", _b_chain, _mut_chain_no_hip_first)
	print("PUNCH_SNAP failures=%d" % failures)
	quit(1 if failures > 0 else 0)

func _check(cond: bool, msg: String) -> void:
	if cond:
		return
	if _muted:
		_mut_fails += 1
	else:
		failures += 1
		print("  FAIL: " + msg)

func _mutant(name: String, body: Callable, fn: Callable) -> void:
	_muted = true
	_mut_fails = 0
	body.call(fn)
	_muted = false
	if _mut_fails > 0:
		print("  MUTANT caught: %s (%d asserts failed)" % [name, _mut_fails])
	else:
		failures += 1
		print("  FAIL: mutant not caught: " + name)

func _approx(a: float, b: float, eps: float) -> bool:
	return absf(a - b) <= eps

func _s(t: float, over: Dictionary = {}) -> Dictionary:
	var s: Dictionary = {"t": t, "shoulder": Vector3(0.2, 1.4, 0.0), "elbow": Vector3(0.35, 1.35, -0.05),
		"wrist": WRIST0, "l_shoulder": Vector3(-0.1, 1.4, 0.0), "r_shoulder": Vector3(0.2, 1.4, 0.0),
		"l_hip": Vector3(-0.1, 1.0, 0.0), "r_hip": Vector3(0.1, 1.0, 0.0), "pelvis": PELVIS0,
		"chest": Vector3(0.05, 1.4, 0.0), "head": Vector3(0.0, 1.6, 0.0),
		"l_foot": Vector3(-0.1, 0.0, 0.1), "r_foot": Vector3(0.1, 0.0, -0.1)}
	s.merge(over, true)
	return s

# The fist `x` metres toward the target from its start.
func _fist(t: float, x: float) -> Dictionary:
	return _s(t, {"wrist": WRIST0 + FACE * x})

func _times(step: float, n: int) -> Array:
	var out: Array = []
	for i in range(n):
		out.append(i * step)
	return out

# The whole scene turned `deg` about the vertical axis.
func _rot(samples: Array, deg: float) -> Array:
	var out: Array = []
	for s in samples:
		var c: Dictionary = {}
		for k in s:
			var v: Variant = s[k]
			c[k] = v.rotated(Vector3.UP, deg_to_rad(deg)) if v is Vector3 else v
		out.append(c)
	return out

func _face(deg: float) -> Vector3:
	return FACE.rotated(Vector3.UP, deg_to_rad(deg))

# Fist speed: constant 4 m/s on even and uneven gaps; constant acceleration on uneven gaps reads a*t.
func _b_speed(fn: Callable) -> void:
	for r in ROTS:
		for times in [[0.0, 0.05, 0.10, 0.15, 0.20], [0.0, 0.02, 0.07, 0.12, 0.20]]:
			var sm: Array = []
			for t in times:
				sm.append(_fist(t, 4.0 * t))
			var sp: Array = fn.call(_rot(sm, r), _face(r))
			_check(sp.size() == times.size(), "speed: %d readings for %d samples" % [sp.size(), times.size()])
			for p in sp:
				_check(_approx(p["v"], 4.0, 0.01), "rot %s: 4 m/s read %.4f at t=%.3f" % [r, p["v"], p["t"]])
		var acc: float = 10.0
		var ta: Array = [0.0, 0.02, 0.07, 0.10, 0.16, 0.20]
		var sa: Array = []
		for t in ta:
			sa.append(_fist(t, 0.5 * acc * t * t))
		var spa: Array = fn.call(_rot(sa, r), _face(r))
		_check(spa.size() == ta.size(), "accel: wrong reading count")
		for i in range(spa.size()):
			var want: float = acc * float(ta[i])
			_check(_approx(spa[i]["v"], want, 0.01), "rot %s: accel read %.4f, want %.4f" % [r, spa[i]["v"], want])

# Speed at contact: a fist speeding up into contact (then slowing, mirror image) reads ~1.0 and peaks
# within one gap of contact; a fist at top speed by 40% of the way that then slows reads (vp-d*dt)/vp.
func _b_contact(fn: Callable) -> void:
	var a: float = 20.0
	var tc: float = 0.19
	var vp: float = 5.0
	var d: float = 40.0
	for r in ROTS:
		var sa: Array = []
		var sb: Array = []
		for t in _times(0.02, 13):
			var xa: float = 0.5 * a * t * t
			if t > tc:
				xa = 0.5 * a * tc * tc + a * tc * (t - tc) - 0.5 * a * (t - tc) * (t - tc)
			sa.append(_fist(t, xa))
			var a1: float = vp / 0.06
			var xb: float = 0.5 * a1 * minf(t, 0.06) * minf(t, 0.06) + vp * clampf(t - 0.06, 0.0, 0.06)
			if t > 0.12:
				xb += vp * (t - 0.12) - 0.5 * d * (t - 0.12) * (t - 0.12)
			sb.append(_fist(t, xb))
		var fa: float = fn.call(_rot(sa, r), _face(r), tc)
		_check(fa >= 0.95, "rot %s: speeding-up punch frac %.4f < 0.95" % [r, fa])
		var la: float = PS.peak_lead_s(_rot(sa, r), _face(r), tc)
		_check(absf(la) <= 0.02 + 0.0001, "rot %s: speeding-up punch lead %.4f beyond one gap" % [r, la])
		var fb: float = fn.call(_rot(sb, r), _face(r), tc)
		var want_b: float = (vp - d * (tc - 0.12)) / vp
		_check(fb < 0.6 and _approx(fb, want_b, 0.005), "rot %s: early-peak frac %.4f, want %.4f" % [r, fb, want_b])
		var lb: float = PS.peak_lead_s(_rot(sb, r), _face(r), tc)
		_check(lb > 0.05 and lb >= tc - 0.10 - 0.001 and lb <= tc - 0.08 + 0.001, "rot %s: early-peak lead %.4f" % [r, lb])
		# Still speeding up through contact and past it: only speed BEFORE contact is the top, so 1.0.
		var sc: Array = []
		for t in _times(0.02, 13):
			sc.append(_fist(t, 0.5 * a * t * t))
		var fc: float = fn.call(_rot(sc, r), _face(r), tc)
		_check(_approx(fc, 1.0, 0.005), "rot %s: speeding-through frac %.4f, want 1.0" % [r, fc])
		# Its top speed over the whole clip is at the last sample (12 gaps of 0.02), AFTER contact: lead negative.
		var lc: float = PS.peak_lead_s(_rot(sc, r), _face(r), tc)
		var want_lc: float = tc - 12 * 0.02
		_check(_approx(lc, want_lc, 0.0001), "rot %s: speeding-through lead %.4f, want %.4f" % [r, lc, want_lc])
		# Out at 4 m/s until 0.08, then home at 4 m/s: coming back at contact 0.12 carries nothing, 0.
		var sd: Array = []
		for t in _times(0.02, 10):
			sd.append(_fist(t, 4.0 * minf(t, 0.08) - 4.0 * maxf(t - 0.08, 0.0)))
		var fd: float = fn.call(_rot(sd, r), _face(r), 0.12)
		_check(_approx(fd, 0.0, 0.0001), "rot %s: coming-home frac %.4f, want 0" % [r, fd])

# Stop: a dead stop just after contact stops within one sample gap; a fist that drifts on at half speed
# never does (-1). The drift punch starts from still, so a stop search that ignores contact goes red.
func _b_stop(fn: Callable) -> void:
	var tc: float = 0.07
	for r in ROTS:
		var s_stop: Array = []
		var s_drift: Array = []
		for t in _times(0.02, 9):
			s_stop.append(_fist(t, 4.0 * minf(t, tc)))
			var xd: float = 4.0 * clampf(t - 0.02, 0.0, tc - 0.02) + 2.0 * maxf(t - tc, 0.0)
			s_drift.append(_fist(t, xd))
		var st: float = fn.call(_rot(s_stop, r), _face(r), tc, 0.2)
		_check(st >= 0.0 and st <= 0.02, "rot %s: dead stop read %.4f, want 0..0.02" % [r, st])
		var dr: float = fn.call(_rot(s_drift, r), _face(r), tc, 0.2)
		_check(_approx(dr, -1.0, 0.0001), "rot %s: drift read %.4f, want -1" % [r, dr])

# An arm whose elbow angle is `e_deg` (shoulder - elbow - wrist).
func _arm(t: float, e_deg: float) -> Dictionary:
	var el: Vector3 = Vector3(0.35, 1.4, 0.0)
	var e: float = deg_to_rad(e_deg)
	return _s(t, {"shoulder": Vector3(0.2, 1.4, 0.0), "elbow": el, "wrist": el + 0.3 * Vector3(-cos(e), 0.0, sin(e))})

# Straighten: the elbow opens at 600 deg/s, crossing 100 at t=0.013 (between samples): 100->160 reads
# 0.10; 110->150 reads 40/600 (crossings off the grid); an arm that stops at 140 never reaches 160.
func _b_straighten(fn: Callable) -> void:
	var rate: float = 600.0
	var so: Array = []
	var ss: Array = []
	for t in _times(0.02, 11):
		so.append(_arm(t, minf(100.0 + rate * (t - 0.013), 170.0)))
		ss.append(_arm(t, minf(92.0 + 300.0 * t, 140.0)))
	var st: float = fn.call(so, 100.0, 160.0)
	_check(_approx(st, (160.0 - 100.0) / rate, 0.005), "straighten 100->160 read %.4f, want 0.10" % st)
	var st2: float = fn.call(so, 110.0, 150.0)
	_check(_approx(st2, (150.0 - 110.0) / rate, 0.002), "straighten 110->150 read %.4f" % st2)
	var st3: float = fn.call(ss, 100.0, 160.0)
	_check(_approx(st3, -1.0, 0.0001), "straighten never reaching 160 read %.4f" % st3)
	# The same arm on a clip timed from contact (every time 0.2 s earlier, all crossings below 0).
	var sn: Array = []
	for t in _times(0.02, 11):
		sn.append(_arm(t - 0.2, minf(100.0 + rate * (t - 0.013), 170.0)))
	var st4: float = fn.call(sn, 100.0, 160.0)
	_check(_approx(st4, (160.0 - 100.0) / rate, 0.005), "straighten on negative times read %.4f, want 0.10" % st4)

# Wind-up: the hips move 0.05 m at the target while the fist draws 0.12 m back FROM THE HIPS by
# t=0.04, then drives forward. A forward-only fist reads 0.
func _b_windup(fn: Callable) -> void:
	for r in ROTS:
		var sb: Array = []
		var sf: Array = []
		for t in _times(0.02, 8):
			var hips: float = 0.05 * minf(t, 0.04) / 0.04
			var rel: float = -0.12 * t / 0.04 if t <= 0.04 else -0.12 + 3.0 * (t - 0.04)
			sb.append(_s(t, {"pelvis": PELVIS0 + FACE * hips, "wrist": WRIST0 + FACE * (hips + rel)}))
			sf.append(_s(t, {"pelvis": PELVIS0 + FACE * hips, "wrist": WRIST0 + FACE * (hips + 3.0 * t)}))
		var wb: Dictionary = fn.call(_rot(sb, r), _face(r), 0.14)
		_check(_approx(wb["back_m"], 0.12, 0.002), "rot %s: wind-up read %.4f, want 0.12" % [r, wb["back_m"]])
		_check(_approx(wb["at_t"], 0.04, 0.0001), "rot %s: wind-up at %.3f, want 0.04" % [r, wb["at_t"]])
		var wf: Dictionary = fn.call(_rot(sf, r), _face(r), 0.14)
		_check(_approx(wf["back_m"], 0.0, 0.0001), "rot %s: forward-only wind-up read %.4f" % [r, wf["back_m"]])

# A body line (lkey to rkey) turning at `rate` deg/s; positive turns the right end at the target.
func _line_samples(lkey: String, rkey: String, rate: float, mid: Vector3) -> Array:
	var out: Array = []
	for t in _times(0.04, 5):
		var th: float = deg_to_rad(rate * t)
		var dv: Vector3 = Vector3(cos(th), 0.0, -sin(th))
		out.append(_s(t, {lkey: mid - 0.15 * dv, rkey: mid + 0.15 * dv}))
	return out

# Turns read from t0=0.01 to contact 0.11 (both between samples): 300 deg/s = 30 degrees.
# Right hand +30, its left-hand mirror +30, the wrong way -30, at 0, 90 and 180 degrees in the world.
func _b_turn(fn: Callable, lkey: String, rkey: String) -> void:
	var mid: Vector3 = Vector3(0.05, 1.2, 0.0)
	var want: float = 300.0 * (0.11 - 0.01)
	for r in ROTS:
		var right: Array = _rot(_line_samples(lkey, rkey, 300.0, mid), r)
		var left: Array = _rot(_line_samples(lkey, rkey, -300.0, mid), r)
		var a: float = fn.call(right, 0.01, 0.11, true)
		_check(_approx(a, want, 0.1), "%s rot %s: right hand read %.3f, want +30" % [lkey, r, a])
		var b: float = fn.call(left, 0.01, 0.11, false)
		_check(_approx(b, want, 0.1), "%s rot %s: left mirror read %.3f, want +30" % [lkey, r, b])
		var c: float = fn.call(left, 0.01, 0.11, true)
		_check(_approx(c, -want, 0.1), "%s rot %s: wrong way read %.3f, want -30" % [lkey, r, c])

func _t_wrap() -> void:
	var d0: Vector3 = Vector3(cos(deg_to_rad(170.0)), 0.0, -sin(deg_to_rad(170.0)))
	var d1: Vector3 = Vector3(cos(deg_to_rad(190.0)), 0.0, -sin(deg_to_rad(190.0)))
	var w: float = PS.turn_deg(Vector3.ZERO, d0, Vector3.ZERO, d1)
	_check(_approx(w, 20.0, 0.01), "170 to -170 read %.3f, want 20" % w)
	var wb: float = PS.turn_deg(Vector3.ZERO, d1, Vector3.ZERO, d0)
	_check(_approx(wb, -20.0, 0.01), "-170 to 170 read %.3f, want -20" % wb)

# A smooth 0 -> amount move from `start` over `dur`, fastest at start + dur/2.
func _bump(t: float, start: float, dur: float, amount: float) -> float:
	return amount * (1.0 - cos(PI * clampf((t - start) / dur, 0.0, 1.0))) / 2.0

func _chain_samples(hs: float, hip_amt: float, ss: float, fs: float, fd: float) -> Array:
	var out: Array = []
	for t in _times(0.01, 31):
		var h: float = deg_to_rad(_bump(t, hs, 0.12, hip_amt))
		var sh: float = deg_to_rad(_bump(t, ss, 0.12, 40.0))
		var hd: Vector3 = Vector3(cos(h), 0.0, -sin(h))
		var sd: Vector3 = Vector3(cos(sh), 0.0, -sin(sh))
		out.append(_s(t, {"l_hip": Vector3(0.0, 1.0, 0.0) - 0.1 * hd, "r_hip": Vector3(0.0, 1.0, 0.0) + 0.1 * hd,
			"l_shoulder": Vector3(0.0, 1.4, 0.0) - 0.15 * sd, "r_shoulder": Vector3(0.0, 1.4, 0.0) + 0.15 * sd,
			"wrist": WRIST0 + FACE * _bump(t, fs, fd, 0.6)}))
	return out

# Chain: [hip start, hip turn, shoulder start, fist start, fist duration, ordered?, hip_t, shoulder_t, fist_t,
# contact] (-1 = never turns toward the punch). Times read to one sample gap (0.01). Each move is fastest
# at its start + half its duration (hips and shoulders take 0.12 s, so start + 0.06).
func _b_chain(fn: Callable) -> void:
	var cases: Array = [
		[0.0, 40.0, 0.04, 0.0, 0.28, true, 0.06, 0.10, 0.14, 0.20],     # hips, shoulders, fist
		[0.02, 40.0, 0.06, 0.0, 0.08, false, 0.08, 0.12, 0.04, 0.20],   # fist first: an arm punch
		[0.0, 40.0, 0.08, 0.0, 0.20, false, 0.06, 0.14, 0.10, 0.20],    # hips, fist, shoulders last
		[0.0, -40.0, 0.04, 0.0, 0.28, false, -1.0, 0.10, 0.14, 0.20],   # hips turn the wrong way
		[0.0, 40.0, 0.04, 0.0, 0.36, true, 0.06, 0.10, 0.12, 0.12],     # lands at 0.12, fist still speeding up
		# shoulders first, then hips, then fist: the fist is last but the trunk turned before the hips
		[0.06, 40.0, 0.0, 0.0, 0.28, false, 0.06 + 0.06, 0.0 + 0.06, 0.0 + 0.28 / 2.0, 0.20]]
	for r in ROTS:
		for c in cases:
			var co: Dictionary = fn.call(_rot(_chain_samples(c[0], c[1], c[2], c[3], c[4]), r), _face(r), c[9], true)
			var tag: String = "rot %s case %s" % [r, c]
			_check(co["ordered"] == c[5], "%s: ordered %s" % [tag, co["ordered"]])
			_check(_approx(co["hip_t"], c[6], 0.0101), "%s: hip_t %.3f" % [tag, co["hip_t"]])
			_check(_approx(co["shoulder_t"], c[7], 0.0101), "%s: shoulder_t %.3f" % [tag, co["shoulder_t"]])
			_check(_approx(co["fist_t"], c[8], 0.0101), "%s: fist_t %.3f" % [tag, co["fist_t"]])

# Still until t1, then v1 m/s until t2, then v2 m/s.
func _pw(t: float, t1: float, v1: float, t2: float, v2: float) -> float:
	return v1 * clampf(t - t1, 0.0, t2 - t1) + v2 * maxf(t - t2, 0.0)

# Weight: t0=0.03 and contact=0.09 both between samples; each part has its own travel.
func _b_weight(fn: Callable) -> void:
	for r in ROTS:
		var sm: Array = []
		for t in _times(0.02, 7):
			sm.append(_s(t, {"pelvis": PELVIS0 + FACE * _pw(t, 0.04, 1.0, 9.0, 0.0),
				"chest": Vector3(0.05, 1.4, 0.0) + FACE * _pw(t, 0.06, 2.0, 9.0, 0.0),
				"head": Vector3(0.0, 1.6, 0.0) + FACE * _pw(t, 0.04, 1.5, 0.08, 0.5)}))
		var w: Dictionary = fn.call(_rot(sm, r), _face(r), 0.03, 0.09)
		_check(_approx(w["pelvis_m"], 1.0 * (0.09 - 0.04), 0.002), "rot %s: pelvis_m %.4f" % [r, w["pelvis_m"]])
		_check(_approx(w["chest_m"], 2.0 * (0.09 - 0.06), 0.002), "rot %s: chest_m %.4f" % [r, w["chest_m"]])
		var want_h: float = 1.5 * (0.08 - 0.04) + 0.5 * (0.09 - 0.08)
		_check(_approx(w["head_m"], want_h, 0.002), "rot %s: head_m %.4f, want %.4f" % [r, w["head_m"], want_h])

# Heel: the rear foot rises 0.05*sin(pi t/0.10); t0=0.01, contact=0.09. A left foot still rising at
# contact (0.5 m/s) is read at contact.
func _b_heel(fn: Callable) -> void:
	var sm: Array = []
	var sl: Array = []
	for t in _times(0.02, 7):
		var y: float = 0.05 * sin(PI * t / 0.10) if t <= 0.10 else 0.0
		sm.append(_s(t, {"r_foot": Vector3(0.1, y, -0.1)}))
		sl.append(_s(t, {"l_foot": Vector3(-0.1, 0.5 * t, 0.1)}))
	var lift: float = fn.call(sm, 0.01, 0.09, true)
	var want: float = 0.05 * sin(0.4 * PI) - lerpf(0.0, 0.05 * sin(0.2 * PI), 0.5)
	_check(_approx(lift, want, 0.002), "heel lift %.4f, want %.4f" % [lift, want])
	var ll: float = fn.call(sl, 0.01, 0.09, false)
	_check(_approx(ll, 0.5 * (0.09 - 0.01), 0.002), "left heel still rising read %.4f, want 0.04" % ll)
	var lr: float = fn.call(sl, 0.01, 0.09, true)
	_check(_approx(lr, 0.0, 0.0001), "still right foot read %.4f, want 0" % lr)

# No data: every measure on [] and on one sample returns its documented value, never an error.
func _t_no_data() -> void:
	for sm in [[], [_s(0.0)]]:
		var n: int = sm.size()
		var sp: Array = PS.fist_speed(sm, FACE)
		_check(sp.size() == n and (n == 0 or _approx(sp[0]["v"], 0.0, 0.0001)), "no data %d: fist_speed %s" % [n, sp])
		var pk: Dictionary = PS.peak_speed(sm, FACE)
		_check(pk["v"] == 0.0 and pk["t"] == 0.0, "no data %d: peak_speed %s" % [n, pk])
		var rd: Dictionary = PS.read(sm, FACE, 0.1, 0.0, true)
		for k in NODATA:
			_check(rd.has(k) and rd[k] == NODATA[k], "no data %d: read %s = %s, want %s" % [n, k, rd.get(k), NODATA[k]])
		_check(PS.speed_at_contact_frac(sm, FACE, 0.1) == 0.0, "no data %d: speed_at_contact_frac" % n)
		_check(PS.peak_lead_s(sm, FACE, 0.1) == 0.0, "no data %d: peak_lead_s" % n)
		_check(PS.stop_s(sm, FACE, 0.1) == -1.0, "no data %d: stop_s" % n)
		_check(PS.straighten_s(sm) == -1.0, "no data %d: straighten_s" % n)
		var wi: Dictionary = PS.windup_m(sm, FACE, 0.1)
		_check(wi["back_m"] == 0.0 and wi["at_t"] == 0.0, "no data %d: windup_m %s" % [n, wi])
		_check(PS.shoulder_turn_deg(sm, 0.0, 0.1, true) == 0.0, "no data %d: shoulder_turn_deg" % n)
		_check(PS.hip_turn_signed_deg(sm, 0.0, 0.1, false) == 0.0, "no data %d: hip_turn_signed_deg" % n)
		var co: Dictionary = PS.chain_order(sm, FACE, 0.1, true)
		_check(co["hip_t"] == -1.0 and co["shoulder_t"] == -1.0 and co["fist_t"] == -1.0 and not co["ordered"], "no data %d: chain %s" % [n, co])
		var w: Dictionary = PS.weight_m(sm, FACE, 0.0, 0.1)
		_check(w["pelvis_m"] == 0.0 and w["chest_m"] == 0.0 and w["head_m"] == 0.0, "no data %d: weight_m %s" % [n, w])
		_check(PS.rear_heel_lift_m(sm, 0.0, 0.1, true) == 0.0, "no data %d: rear_heel_lift_m" % n)
	var two: Dictionary = PS.chain_order([_s(0.0), _fist(0.1, 0.4)], FACE, 0.1, true)
	_check(not two["ordered"] and two["hip_t"] == -1.0, "two samples: chain %s" % two)
	# Hips turn and the fist goes, the shoulders never turn: not ordered, shoulder_t -1.
	var still: Array = _chain_samples(0.0, 40.0, 0.0, 0.0, 0.28)
	for s in still:
		s["l_shoulder"] = Vector3(-0.15, 1.4, 0.0)
		s["r_shoulder"] = Vector3(0.15, 1.4, 0.0)
	var cs: Dictionary = PS.chain_order(still, FACE, 0.20, true)
	_check(not cs["ordered"] and cs["shoulder_t"] == -1.0, "still shoulders: chain %s" % cs)

# read(): every key there, plain numbers, wired to the right measure (checked on the ordered punch).
func _t_read() -> void:
	var sm: Array = _chain_samples(0.0, 40.0, 0.04, 0.0, 0.28)
	var rd: Dictionary = PS.read(sm, FACE, 0.20, 0.0, true)
	for k in NODATA:
		_check(rd.has(k) and (rd[k] is float or rd[k] is bool), "read: key %s missing or not a plain number" % k)
	_check(rd.get("chain_ordered", false) == true, "read: chain_ordered %s" % rd.get("chain_ordered"))
	_check(_approx(rd.get("chain_hip_t", -9.0), 0.06, 0.0101), "read: chain_hip_t %s" % rd.get("chain_hip_t"))
	_check(_approx(rd.get("chain_fist_t", -9.0), 0.14, 0.0101), "read: chain_fist_t %s" % rd.get("chain_fist_t"))
	_check(_approx(rd.get("hip_turn_signed_deg", 0.0), 40.0, 0.5), "read: hip turn %s, want 40" % rd.get("hip_turn_signed_deg"))
	_check(_approx(rd.get("shoulder_turn_deg", 0.0), 40.0, 0.5), "read: shoulder turn %s, want 40" % rd.get("shoulder_turn_deg"))

# ---- MUTANTS: copies of real measures, each with one deliberate bug. ----

# BUG: reads the nearest earlier sample instead of interpolating.
func _mut_weight_m(samples: Array, facing: Vector3, t0: float, contact_t: float) -> Dictionary:
	var out: Dictionary = {}
	for k in ["pelvis", "chest", "head"]:
		var a: Vector3 = Vector3.ZERO
		var b: Vector3 = Vector3.ZERO
		for s in samples:
			if s["t"] <= t0:
				a = s.get(k, Vector3.ZERO)
			if s["t"] <= contact_t:
				b = s.get(k, Vector3.ZERO)
		out[k + "_m"] = (b - a).dot(facing)
	return out

# BUG: no sign flip for a left-hand punch.
func _mut_shoulder_turn(samples: Array, t0: float, contact_t: float, _punching_right: bool) -> float:
	return PS.turn_deg(PS._interp(samples, "l_shoulder", t0), PS._interp(samples, "r_shoulder", t0),
		PS._interp(samples, "l_shoulder", contact_t), PS._interp(samples, "r_shoulder", contact_t))

# BUG: the plain secant (x[i+1]-x[i-1])/(t[i+1]-t[i-1]), wrong under acceleration on uneven gaps.
func _mut_fist_speed(samples: Array, facing: Vector3) -> Array:
	var out: Array = []
	var n: int = samples.size()
	for i in range(n):
		var a: int = maxi(i - 1, 0)
		var b: int = mini(i + 1, n - 1)
		var wa: Vector3 = samples[a]["wrist"]
		var wb: Vector3 = samples[b]["wrist"]
		var dt: float = samples[b]["t"] - samples[a]["t"]
		out.append({"t": samples[i]["t"], "v": (wb - wa).dot(facing) / dt if dt > 0.0001 else 0.0})
	return out

# BUG: the shoulder check dropped (hips before fist is enough).
func _mut_chain_order(samples: Array, facing: Vector3, contact_t: float, punching_right: bool) -> Dictionary:
	var co: Dictionary = PS.chain_order(samples, facing, contact_t, punching_right)
	co["ordered"] = co["hip_t"] >= 0.0 and co["fist_t"] >= 0.0 and co["hip_t"] <= co["fist_t"]
	return co

# BUG: the hip-before-shoulder check dropped (shoulders before fist is enough).
func _mut_chain_no_hip_first(samples: Array, facing: Vector3, contact_t: float, punching_right: bool) -> Dictionary:
	var co: Dictionary = PS.chain_order(samples, facing, contact_t, punching_right)
	co["ordered"] = co["hip_t"] >= 0.0 and co["shoulder_t"] >= 0.0 and co["fist_t"] >= 0.0 		and co["shoulder_t"] <= co["fist_t"]
	return co
