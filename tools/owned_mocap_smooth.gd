extends RefCounted
## S383c OWNED MOCAP, zero-phase smoothing of a baked clip's tracks, ONLY on the tracks whose source is noisy (operator on
## the owned reel: "the knees are trembling again"). Runs in tools/owned_mocap_bake.gd before the planted-foot pin, and
## again on the leg tracks after it (the pin's per-frame IK hands the hips' leftover shake to the knee).
## A track is NOISY when its SHAKE (the key minus its 5-frame quadratic Savitzky-Golay fit, RMS: what is left is the
## >= 7.5 Hz band - a 5 Hz bounce keeps 91 % in the fit, a 10 Hz shake 23 %) is over NOISE_DEG (NOISE_MM for the hips
## position). A noisy track is low-passed by a
## 4th-order Butterworth run forwards and backwards (zero phase, no lag), taken as its symmetric impulse response and
## applied on rotation logs about each key (q_i * exp(sum h_j log(q_i^-1 q_i+j))), so a turn of any size is handled.
## Cut-offs: 6 Hz for the trunk and legs (the stance bounce at 2-3 Hz passes whole, the CMU actors' quick ~5 Hz bounce
## at 81 %, a 7.5 Hz shake at 14 %), 8 Hz for hands and feet, 12 Hz for the shoulders / upper arms / forearms (a punch's
## peak survives, see the bars' wrist speed). A key that still turns > POP_DEG in one frame (outside the punching arm's
## punch frames, `exempt`) gets a lower cut-off (3/4, again and again down to 2 Hz) blended in ONLY around that key.
## Clean tracks are left untouched. No speed change: same keys, same times.
##   Smooth.smooth(anim, only, exempt) -> {track: [shake before, after, cut-off Hz; negative = only the pop limiter]}

const FPS := 30.0
const HALF := 12
const SG5 := [-3.0, 12.0, 17.0, 12.0, -3.0]   # / 35
const NOISE_DEG := 0.05
const NOISE_MM := 0.2
const POP_DEG := 15.0
const LIMIT_HZ := 2.0
const TARGET_MIN_HZ := 4.0
const ARMS := ["LeftShoulder", "LeftUpperArm", "LeftLowerArm", "RightShoulder", "RightUpperArm", "RightLowerArm"]
const HANDS_FEET := ["LeftHand", "RightHand", "LeftFoot", "RightFoot", "LeftToes", "RightToes"]


static func cutoff(bone: String) -> float:
	if ARMS.has(bone):
		return 12.0
	if HANDS_FEET.has(bone):
		return 8.0
	return 6.0


## The symmetric impulse response of a 4th-order Butterworth (fc Hz at FPS; two biquads, Q 0.5412 and 1.3066) run
## forwards then backwards, +-HALF frames. At fc = 6 Hz: 2.5 Hz passes 99.9 %, 5 Hz 81 %, 7.5 Hz 14 %, 10 Hz 2 %.
static func kernel(fc: float) -> PackedFloat64Array:
	var k := tan(PI * fc / FPS)
	var L := 80
	var y := PackedFloat64Array()
	y.resize(2 * L + 1)
	y[L] = 1.0
	for _dir in 2:
		for q in [0.5412, 1.3066]:
			var nrm: float = 1.0 / (1.0 + k / q + k * k)
			var b0: float = k * k * nrm
			y = _biquad(y, b0, 2.0 * b0, 2.0 * (k * k - 1.0) * nrm, (1.0 - k / q + k * k) * nrm)
		y.reverse()
	var h := PackedFloat64Array()
	var s := 0.0
	for j in range(-HALF, HALF + 1):
		h.append(y[L + j])
		s += y[L + j]
	for j in h.size():
		h[j] /= s
	return h


static func _biquad(x: PackedFloat64Array, b0: float, b1: float, a1: float, a2: float) -> PackedFloat64Array:
	var y := PackedFloat64Array()
	y.resize(x.size())
	var x1 := 0.0
	var x2 := 0.0
	var y1 := 0.0
	var y2 := 0.0
	for i in x.size():
		var v := b0 * x[i] + b1 * x1 + b0 * x2 - a1 * y1 - a2 * y2
		x2 = x1
		x1 = x[i]
		y2 = y1
		y1 = v
		y[i] = v
	return y


static func rotvec(q: Quaternion) -> Vector3:
	var qq := q.normalized()
	if qq.w < 0.0:
		qq = -qq
	var s := sqrt(maxf(1.0 - qq.w * qq.w, 0.0))
	if s < 1e-9:
		return Vector3.ZERO
	return Vector3(qq.x, qq.y, qq.z) / s * (2.0 * acos(clampf(qq.w, -1.0, 1.0)))


static func expq(v: Vector3) -> Quaternion:
	var a := v.length()
	if a < 1e-12:
		return Quaternion.IDENTITY
	return Quaternion(v / a, a)


## Mirror an index into [0, n).
static func _mi(i: int, n: int) -> int:
	if i < 0:
		i = -i
	if i >= n:
		i = 2 * (n - 1) - i
	return clampi(i, 0, n - 1)


## A kernel (Array of weights, centred) applied on rotation logs about each key.
static func filter_rot(q: Array, h: PackedFloat64Array) -> Array:
	var n := q.size()
	var half := (h.size() - 1) / 2
	var out := []
	out.resize(n)
	for i in n:
		var qi: Quaternion = q[i]
		var qinv := qi.inverse()
		var acc := Vector3.ZERO
		for j in h.size():
			acc += rotvec(qinv * (q[_mi(i + j - half, n)] as Quaternion)) * h[j]
		out[i] = (qi * expq(acc)).normalized()
	return out


static func filter_vec(p: Array, h: PackedFloat64Array) -> Array:
	var n := p.size()
	var half := (h.size() - 1) / 2
	var out := []
	out.resize(n)
	for i in n:
		var acc := Vector3.ZERO
		for j in h.size():
			acc += (p[_mi(i + j - half, n)] as Vector3) * h[j]
		out[i] = acc
	return out


## High band of a rotation series (deg RMS) and its largest key-to-key turn (deg).
static func rot_noise(q: Array) -> Array:
	var n := q.size()
	var s := 0.0
	var cnt := 0
	for i in range(2, n - 2):
		var qinv := (q[i] as Quaternion).inverse()
		var acc := Vector3.ZERO
		for j in 5:
			acc += rotvec(qinv * (q[i - 2 + j] as Quaternion)) * (SG5[j] / 35.0)
		s += acc.length_squared()
		cnt += 1
	var step := 0.0
	for i in range(1, n):
		step = maxf(step, (q[i - 1] as Quaternion).angle_to(q[i] as Quaternion))
	return [rad_to_deg(sqrt(s / maxf(cnt, 1))), rad_to_deg(step)]


static func vec_noise(p: Array) -> float:
	var s := 0.0
	var cnt := 0
	for i in range(2, p.size() - 2):
		var acc := Vector3.ZERO
		for j in 5:
			acc += (p[i - 2 + j] as Vector3) * (SG5[j] / 35.0)
		s += ((p[i] as Vector3) - acc).length_squared()
		cnt += 1
	return sqrt(s / maxf(cnt, 1)) * 1000.0


## Smooths the noisy tracks of `anim` in place (keys every frame). `only` limits it to these track names (empty = all).
## `exempt`: track name -> Array[bool] per key where a pop is allowed (the punching arm's frames) - the pop limiter
## leaves those keys alone.
## `target` > 0 (deg): a filtered track whose shake is still over it is filtered again from its raw keys 0.5 Hz lower,
## down to TARGET_MIN_HZ (the bake's second leg pass: the CMU actors' 5-7 Hz knee shake).
static func smooth(anim: Animation, only: Array = [], exempt: Dictionary = {}, target: float = 0.0) -> Dictionary:
	var rep := {}
	var kern := {}
	for t in anim.get_track_count():
		var name := str(anim.track_get_path(t))
		if not only.is_empty() and not only.has(name):
			continue
		var n := anim.track_get_key_count(t)
		if n < 8:
			continue
		if anim.track_get_type(t) == Animation.TYPE_POSITION_3D:
			var p := []
			for k in n:
				p.append(anim.track_get_key_value(t, k))
			var before := vec_noise(p)
			if before <= NOISE_MM:
				rep[name + "@pos"] = [before, before, 0.0]
				continue
			var fc := 6.0
			if not kern.has(fc):
				kern[fc] = kernel(fc)
			var f := filter_vec(p, kern[fc])
			for k in n:
				anim.track_set_key_value(t, k, f[k])
			rep[name + "@pos"] = [before, vec_noise(f), fc]
			continue
		if anim.track_get_type(t) != Animation.TYPE_ROTATION_3D:
			continue
		var q := []
		for k in n:
			var v: Quaternion = anim.track_get_key_value(t, k)
			if k > 0 and (q[k - 1] as Quaternion).dot(v) < 0.0:
				v = -v
			q.append(v)
		var nb := rot_noise(q)
		var ex: Array = exempt.get(name, [])
		var fc := cutoff(name) if nb[0] > NOISE_DEG else 0.0
		var f: Array = q.duplicate()
		while fc > 0.0:
			if not kern.has(fc):
				kern[fc] = kernel(fc)
			f = filter_rot(q, kern[fc])
			if target <= 0.0 or fc - 0.5 < TARGET_MIN_HZ or rot_noise(f)[0] <= target:
				break
			fc -= 0.5
		# The POP LIMITER: a key still turning > POP_DEG from the last (outside the exempt frames) gets the raw keys
		# low-passed at 3/4 the cut-off, then 3/4 again (down to MIN_HZ), blended in ONLY around it (full +-2 keys,
		# fading over 3 more) - a real fast turn elsewhere in the take keeps its speed.
		var fl := (cutoff(name) if fc <= 0.0 else fc) * 0.75
		var limited := 0
		while fl >= LIMIT_HZ:
			var w := _pop_mask(f, ex)
			if w.is_empty():
				break
			if not kern.has(fl):
				kern[fl] = kernel(fl)
			var low := filter_rot(q, kern[fl])
			for k in w:
				f[k] = (f[k] as Quaternion).slerp(low[k], w[k])
			limited += w.size()
			fl *= 0.75
		if fc <= 0.0 and limited == 0:
			rep[name] = [nb[0], nb[0], 0.0]
			continue
		for k in n:
			anim.track_set_key_value(t, k, f[k])
		rep[name] = [nb[0], rot_noise(f)[0], fc if fc > 0.0 else -fl / 0.75]
	return rep


## Key -> blend weight around every key that turns > POP_DEG from the last (both keys not exempt). Empty: no pop.
static func _pop_mask(q: Array, ex: Array) -> Dictionary:
	var w := {}
	for k in range(1, q.size()):
		if rad_to_deg((q[k - 1] as Quaternion).angle_to(q[k] as Quaternion)) <= POP_DEG:
			continue
		if ex.size() > k and (bool(ex[k]) or bool(ex[k - 1])):
			continue
		for j in range(-5, 6):
			var i := k + j
			if i < 0 or i >= q.size():
				continue
			var a := 1.0 if absi(j) <= 2 else 1.0 - (absi(j) - 2) / 4.0
			w[i] = maxf(float(w.get(i, 0.0)), a)
	return w


## The bake's FBX read (tools/owned_mocap_bake.gd): Rokoko's FBX is keyed at 24 fps; read at 30 fps a LINEAR track turns
## at a new speed on every source key (a 5:4 limp), so `tracks` go cubic (spherical cubic for rotations: a continuous
## speed). A first key that is a teleport (Rokoko's Mixamo exports: the hips ~1 m off on key 0) would bend the cubic curve
## into the next keys, so it is removed from every track first. Returns the time the read starts at.
static func fbx_cubic(anim: Animation, tracks: Array, hips_pos: int) -> float:
	var t_first := 0.0
	if hips_pos >= 0 and anim.track_get_key_count(hips_pos) >= 3:
		var p0: Vector3 = anim.track_get_key_value(hips_pos, 0)
		var p1: Vector3 = anim.track_get_key_value(hips_pos, 1)
		var p2: Vector3 = anim.track_get_key_value(hips_pos, 2)
		if (p1 - p0).length() > 10.0 * (p2 - p1).length() + 1e-6:
			var k0 := anim.track_get_key_time(hips_pos, 0)
			for t in tracks:
				if anim.track_get_key_count(t) > 2 and is_equal_approx(anim.track_get_key_time(t, 0), k0):
					anim.track_remove_key(t, 0)
			t_first = anim.track_get_key_time(hips_pos, 0)
			print("OWNEDMOCAP removed the first key (a hips teleport); the read starts at %.3f s" % t_first)
	for t in tracks:
		anim.track_set_interpolation_type(t, Animation.INTERPOLATION_CUBIC)
	return t_first


static func report(rep: Dictionary) -> String:
	var s := ""
	for k in rep:
		var r: Array = rep[k]
		if float(r[2]) != 0.0:
			s += "%s %.2f->%.2f@%.1fHz " % [k, r[0], r[1], r[2]]
	return s.strip_edges()
