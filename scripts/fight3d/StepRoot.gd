extends RefCounted
## S377 STEPROOT1 - the body travels only as far as the foot on the canvas pushes it (operator S377 on the knockdown film:
## "their legs dont really move they slide across"; eyes burst 0:18.2-18.5: the same leg pose while the body moved a body
## width). Every clip plays in place (FightClips.hold_root_xz) and the code slid the body at a set speed, so a foot stayed
## put only when the clip's stride happened to match. Here the clip itself says how far: sampled once per body and clip, the
## lower ankle is the planted foot, and the body's travel is minus that foot's travel in the skeleton's own space (forward
## kinematics on the clip's keys over the rest pose - no modifier takes part). Any playback speed, no slide by construction.
##   travel(ap, skel, clip) -> {t, x, z: PackedFloat32Array, loop: Vector3, length}   (cached per body + clip)
##   moved(ap, skel, clip, t0, t1) -> Vector3   skeleton-space travel between two clip times (wraps a looping clip)
##   heading(ap, skel, clip) -> Vector3   the clip's travel direction over a whole loop, skeleton space (ZERO = in place)

const RATE := 60.0          # samples a second of clip
const SWAP_M := 0.01        # the other ankle must be this much lower to take over as the planted foot
const FEET := ["LeftFoot", "RightFoot"]

static var _cache := {}


static func travel(ap: AnimationPlayer, skel: Skeleton3D, clip: String) -> Dictionary:
	var key := "%d:%s" % [skel.get_instance_id(), clip]
	if _cache.has(key):
		return _cache[key]
	var out := {"t": PackedFloat32Array([0.0]), "x": PackedFloat32Array([0.0]), "z": PackedFloat32Array([0.0]),
		"loop": Vector3.ZERO, "length": 0.0}
	if not ap.has_animation(clip):
		return out
	var anim := ap.get_animation(clip)
	var tracks := {}   # bone -> {Animation.TYPE_*: track index}
	for i in anim.get_track_count():
		var bone := str(anim.track_get_path(i)).get_slice(":", 1)
		if not tracks.has(bone):
			tracks[bone] = {}
		(tracks[bone] as Dictionary)[anim.track_get_type(i)] = i
	var chains := []
	for foot in FEET:
		var chain := []
		var b := skel.find_bone(foot)
		while b >= 0:
			chain.push_front(b)
			b = skel.get_bone_parent(b)
		chains.append(chain)
	var n := maxi(2, int(anim.length * RATE) + 1)
	var ts := PackedFloat32Array()
	var xs := PackedFloat32Array()
	var zs := PackedFloat32Array()
	var acc := Vector3.ZERO
	var planted := -1
	var prev: Array = []
	for s in n:
		var t := anim.length * float(s) / float(n - 1)
		var feet := [_fk(anim, skel, tracks, chains[0], t), _fk(anim, skel, tracks, chains[1], t)]
		if s > 0:
			var low := 0 if (feet[0] as Vector3).y <= (feet[1] as Vector3).y else 1
			if planted < 0 or (feet[low] as Vector3).y < (feet[planted] as Vector3).y - SWAP_M:
				planted = low
			var d: Vector3 = (feet[planted] as Vector3) - (prev[planted] as Vector3)
			acc -= Vector3(d.x, 0.0, d.z)
		ts.append(t)
		xs.append(acc.x)
		zs.append(acc.z)
		prev = feet
	out = {"t": ts, "x": xs, "z": zs, "loop": acc, "length": anim.length}
	_cache[key] = out
	return out


static func moved(ap: AnimationPlayer, skel: Skeleton3D, clip: String, t0: float, t1: float) -> Vector3:
	var tr := travel(ap, skel, clip)
	if t1 >= t0:
		return _at(tr, t1) - _at(tr, t0)
	return (tr["loop"] as Vector3) - _at(tr, t0) + _at(tr, t1)   # wrapped round a looping clip


static func heading(ap: AnimationPlayer, skel: Skeleton3D, clip: String) -> Vector3:
	var loop: Vector3 = travel(ap, skel, clip)["loop"]
	return loop.normalized() if loop.length() > 0.01 else Vector3.ZERO


static func _at(tr: Dictionary, t: float) -> Vector3:
	var ts: PackedFloat32Array = tr["t"]
	if ts.size() < 2:
		return Vector3.ZERO
	var i := clampi(ts.bsearch(t), 1, ts.size() - 1)
	var k := clampf((t - ts[i - 1]) / maxf(ts[i] - ts[i - 1], 0.0001), 0.0, 1.0)
	var xs: PackedFloat32Array = tr["x"]
	var zs: PackedFloat32Array = tr["z"]
	return Vector3(lerpf(xs[i - 1], xs[i], k), 0.0, lerpf(zs[i - 1], zs[i], k))


## The ankle in skeleton space at clip time t: the chain's keys where it has them, the rest pose where it does not.
static func _fk(anim: Animation, skel: Skeleton3D, tracks: Dictionary, chain: Array, t: float) -> Vector3:
	var g := Transform3D.IDENTITY
	for b in chain:
		var rest := skel.get_bone_rest(b)
		var tk: Dictionary = tracks.get(skel.get_bone_name(b), {})
		var pos: Vector3 = anim.position_track_interpolate(tk[Animation.TYPE_POSITION_3D], t) \
			if tk.has(Animation.TYPE_POSITION_3D) else rest.origin
		var rot: Quaternion = anim.rotation_track_interpolate(tk[Animation.TYPE_ROTATION_3D], t) \
			if tk.has(Animation.TYPE_ROTATION_3D) else rest.basis.get_rotation_quaternion()
		var scl: Vector3 = anim.scale_track_interpolate(tk[Animation.TYPE_SCALE_3D], t) \
			if tk.has(Animation.TYPE_SCALE_3D) else rest.basis.get_scale()
		g = g * Transform3D(Basis(rot) * Basis.from_scale(scl), pos)
	return g.origin
