extends SceneTree
## S383b OWNED MOCAP tremble diagnosis (operator on the owned-mocap reel: "the video clip is lagging, cant tell how good the
## animations are, also the knees are trembling again"). MEASURE ONLY - per clip, per frame at 30 fps:
##   KNEE flex (0 = straight) both legs: RMS of the second difference (deg/frame^2) and ZIGZAGS = reversals of the first
##     difference (both steps > 0.1 deg, opposite signs) that come within 3 frames of the previous reversal (a bounce at
##     2-3 Hz reverses every 5-7 frames and is not counted; a tremble at 5-15 Hz is). Rate per second.
##   KNEE POLE: the knee's offset from the hip-ankle line, as a signed angle about that line from the foot's direction
##     (ankle -> ball); frames bent > 15 deg only. Jumps > 20 deg and > 90 deg in one frame (a flip).
##   JOINTS: every animated bone's LOCAL rotation: angular step w (deg/frame), RMS |w[n] - w[n-1]| (deg/frame^2) and
##     zigzags of w (w[n].w[n-1] < 0, both > 0.3 deg, within 3 frames). Hips position: RMS 2nd difference (mm/frame^2),
##     per-frame step evenness, zigzags of each axis (> 0.5 mm steps).
## Modes:
##   mode=clip  (default) the .res keys on the body by our own FK (no AnimationPlayer, no modifiers) - the clip itself.
##   mode=shown the film's path, tools/clip_orbit.gd's: FightStage boxer, AnimationPlayer freeze (play+seek+pause) per frame,
##              KneeTrack.align, then the whole modifier stack; read on Skeleton3D.skeleton_updated (as drawn).
##              Run with --fixed-fps N to set the modifiers' delta (the films ran on wall time). `noalign` skips the
##              explicit align; the game's own switches (nojoin noguard noreach nosnap noglove noknee nofeet nofloor) apply.
##   <godot> --headless --audio-driver Dummy --path . [--fixed-fps 30] --script res://tools/owned_mocap_jitter.gd -- \
##       res=<a.res,b.res> [mode=clip|shown] [glb=mh_boxer_08] [t1=40] [tag=<label>]
## One JIT_JSON line per clip ({"clip","tag","mode","n","knee":{L,R},"pole":{L,R},"joints":{bone: [rms_acc, zz_per_s]},
## "hips":{...},"keys":{...},"slide":{...}}).
## S383d: `strip` (shown) switches every modifier off but MetaHumanTwist (the pure-clip film, clip_orbit.strip_modifiers);
##   step=<s> advances the clip <s> per frame (run with --fixed-fps 1/<s> so the modifiers' delta matches; default 1/30);
##   every=<k> keeps every k-th frame before the report (a 1/30 run read at 0.2 s = every=6, to compare with step=0.2),
##   from frame skip=<n> (`play` captures after the first advance: a 1/30 run's frame 5 is a 0.2 s run's frame 0).
##   `play` (shown): the clip PLAYS (AnimationPlayer advancing on the frame delta, as in a fight) instead of a freeze per
##   frame (seek + pause, the films' path: the seek runs the modifier stack a second time each frame).
##   JIT_DUMP=1 (environment) also prints each knee's bend, frame by frame (JIT_FLEX lines).
##   ids=<a,b> (shown): clips as the FIGHT loaded them (FightClips: pro_combo_punch, pro_idle - hips X/Z held in place).
##   SLIDE: plants of each ball of the foot (owned_mocap_measure.gd's rule - within 2.5 cm of its floor, slower than
##   0.25 m/s, >= 0.2 s) in world space at the report's own step; max / mean of the farthest the ball gets from the start.

const Stage := preload("res://scripts/fight3d/FightStage.gd")
const KneeTrack := preload("res://scripts/fight3d/KneeTrack.gd")
const Orbit := preload("res://tools/clip_orbit.gd")
const Measure := preload("res://tools/owned_mocap_measure.gd")
const FPS := 30.0
const WARM := 30
const LEGS := [["L", "LeftUpperLeg", "LeftLowerLeg", "LeftFoot", "LeftToes"],
	["R", "RightUpperLeg", "RightLowerLeg", "RightFoot", "RightToes"]]

var _cap := {}       # the last drawn pose (shown mode): {"g": [Transform3D per bone], "n": update count}
var _updates := 0
var _step := 1.0 / FPS   # clip seconds per frame (step=)
var _every := 1          # report every k-th frame (every=)
var _skip := 0           # ... starting at this frame (skip=)
var _xf := Transform3D.IDENTITY   # skeleton space -> world (slide)


func _initialize() -> void:
	var paths: Array = []
	var mode := "clip"
	var glb := "mh_boxer_08"
	var t1 := 40.0
	var tag := ""
	for a in OS.get_cmdline_user_args():
		var s := str(a)
		if s.begins_with("res="):
			paths += Array(s.substr(4).split(",", false))
		elif s.begins_with("ids="):
			paths += Array(s.substr(4).split(",", false))
		elif s.begins_with("mode="):
			mode = s.substr(5)
		elif s.begins_with("glb="):
			glb = s.substr(4)
		elif s.begins_with("t1="):
			t1 = float(s.substr(3))
		elif s.begins_with("tag="):
			tag = s.substr(4)
		elif s.begins_with("step="):
			_step = float(s.substr(5))
		elif s.begins_with("every="):
			_every = maxi(1, int(s.substr(6)))
		elif s.begins_with("skip="):
			_skip = maxi(0, int(s.substr(5)))
	if mode == "shown":
		await _shown(paths, glb, t1, tag)
	else:
		_clip(paths, glb, t1, tag)
	quit(0)


# ---------------------------------------------------------------- capture

## The clip itself: own FK on the rest pose, every bone's global transform per frame.
func _clip(paths: Array, glb: String, t1: float, tag: String) -> void:
	var rig := Measure.rig_for(glb)
	root.add_child(rig["body"])
	_xf = rig["xf"]
	var skel: Skeleton3D = rig["skel"]
	var par: Array = rig["par"]
	var rest: Array = rig["rest"]
	for p in paths:
		var anim := load(str(p)) as Animation
		var rot_t := {}
		var pos_t := {}
		for t in anim.get_track_count():
			var b := skel.find_bone(str(anim.track_get_path(t)))
			if b < 0:
				continue
			if anim.track_get_type(t) == Animation.TYPE_ROTATION_3D:
				rot_t[b] = t
			elif anim.track_get_type(t) == Animation.TYPE_POSITION_3D:
				pos_t[b] = t
		var n := mini(int(round(anim.length / _step)) + 1, int(t1 / _step) + 1)
		var frames := []
		for f in n:
			var t := minf(f * _step, anim.length)
			var g := []
			g.resize(par.size())
			for i in par.size():
				var r: Transform3D = rest[i]
				var local := r
				if rot_t.has(i):
					local = Transform3D(Basis(anim.rotation_track_interpolate(rot_t[i], t)), r.origin)
				if pos_t.has(i):
					local.origin = r.origin + anim.position_track_interpolate(pos_t[i], t)
				g[i] = (g[par[i]] as Transform3D) * local if par[i] >= 0 else local
			frames.append(g)
		_report(str(p).get_file().get_basename(), tag, "clip", skel, frames, rot_t.keys(), _keys(anim, skel))


## Key spacing and interpolation of the clip's tracks (sampling check).
static func _keys(anim: Animation, skel: Skeleton3D) -> Dictionary:
	var dev := 0.0
	var interp := {}
	var counts := {}
	for t in anim.get_track_count():
		interp[str(anim.track_get_interpolation_type(t))] = true
		counts[str(anim.track_get_key_count(t))] = true
		for k in range(1, anim.track_get_key_count(t)):
			dev = maxf(dev, absf(anim.track_get_key_time(t, k) - anim.track_get_key_time(t, k - 1) - 1.0 / FPS))
	return {"len": anim.length, "step": anim.step, "loop": anim.loop_mode, "interp": interp.keys(), "key_counts": counts.keys(),
		"max_step_dev_ms": dev * 1000.0}


## The film's path (tools/clip_orbit.gd): the stage's boxer, freeze per frame, KneeTrack.align, the modifier stack.
func _shown(paths: Array, glb: String, t1: float, tag: String) -> void:
	var stage: Node3D = Stage.new()
	root.add_child(stage)
	await process_frame
	stage.setup({"glb": "res://assets/models/metahuman/%s.glb" % glb, "corner": "red"},
		{"glb": "res://assets/models/metahuman/mh_boxer_11.glb", "corner": "blue"})
	stage.set_process(false)
	var bx: Dictionary = stage.boxers[0]
	var skel: Skeleton3D = bx["skel"]
	var ap: AnimationPlayer = bx["ap"]
	_xf = skel.global_transform
	var align := not OS.get_cmdline_user_args().has("noalign")
	if OS.get_cmdline_user_args().has("strip"):
		Orbit.strip_modifiers(skel)
		align = false
	skel.skeleton_updated.connect(func() -> void:
		var g := []
		for i in skel.get_bone_count():
			g.append(skel.get_bone_global_pose(i))
		_cap = {"g": g}
		_updates += 1)
	var mods := []
	for c in skel.get_children():
		if c is SkeletonModifier3D:
			mods.append(str(c.name))
	print("JIT shown modifiers: ", ",".join(mods), " align=", align)
	for p in paths:
		var name := str(p).get_file().get_basename() if str(p).ends_with(".res") else str(p)
		if not ap.has_animation(name):
			Orbit._add_res(ap, skel, str(p))
		var anim := ap.get_animation(name)
		var rot_t := []
		for t in anim.get_track_count():
			if anim.track_get_type(t) == Animation.TYPE_ROTATION_3D:
				var b := skel.find_bone(str(anim.track_get_path(t).get_concatenated_subnames()))
				if b >= 0:
					rot_t.append(b)
		var n := mini(int(round(anim.length / _step)) + 1, int(t1 / _step) + 1)
		var frames := []
		var stale := 0
		var dts := {}
		var play := OS.get_cmdline_user_args().has("play")
		# Settle: WARM frames held on the clip's first pose (not measured), so each clip starts from its own guard and
		# the fight layers' state (planted feet) does not carry over from the clip measured before it.
		for w in WARM:
			Stage.IdleMatch.freeze(bx, name, 0.0)
			await process_frame
		for f in n:
			if not play:
				Stage.IdleMatch.freeze(bx, name, minf(f * _step, anim.length))
			elif f == 0:
				ap.play(name, 0.0)
				ap.seek(0.0, true)
			if align:
				KneeTrack.align(skel, 1.0)
			var before := _updates
			# The skeleton's modifier pass runs in this frame, after the coroutine yields: the capture read on the next
			# frame's start is pose f as drawn.
			await process_frame
			dts[snappedf(get_root().get_process_delta_time(), 0.001)] = true
			frames.append(_cap["g"])
			if _updates == before:
				stale += 1
		print("JIT shown %s frames %d stale %d deltas %s" % [name, frames.size(), stale, str(dts.keys().slice(0, 4))])
		_report(name, tag, "shown", skel, frames, rot_t, {})


# ---------------------------------------------------------------- analysis

## Reversals of a 1-D series' steps (both > eps, opposite signs) within 3 frames of the previous reversal.
static func _zigzag(d1: Array, eps: float) -> int:
	var last := -100
	var cnt := 0
	for i in range(1, d1.size()):
		var a: float = d1[i - 1]
		var b: float = d1[i]
		if a * b < 0.0 and absf(a) > eps and absf(b) > eps:
			if i - last <= 3:
				cnt += 1
			last = i
	return cnt


static func _rms(arr: Array) -> float:
	if arr.is_empty():
		return 0.0
	var s := 0.0
	for v in arr:
		s += float(v) * float(v)
	return sqrt(s / arr.size())


static func _diff(x: Array) -> Array:
	var o := []
	for i in range(1, x.size()):
		o.append(float(x[i]) - float(x[i - 1]))
	return o


static func _rotvec(q: Quaternion) -> Vector3:
	var qq := q.normalized()
	if qq.w < 0.0:
		qq = -qq
	var ang := 2.0 * acos(clampf(qq.w, -1.0, 1.0))
	var s := sqrt(maxf(1.0 - qq.w * qq.w, 0.0))
	if s < 1e-6:
		return Vector3.ZERO
	return Vector3(qq.x, qq.y, qq.z) / s * rad_to_deg(ang)


func _report(clip: String, tag: String, mode: String, skel: Skeleton3D, all_frames: Array, bones: Array, keys: Dictionary) -> void:
	var frames := []
	for i in range(_skip, all_frames.size(), _every):
		frames.append(all_frames[i])
	var dt := _step * _every
	var n := frames.size()
	var secs := maxf((n - 1) * dt, 1e-3)
	var out := {"clip": clip, "tag": tag, "mode": mode, "n": n, "secs": secs, "dt": dt, "keys": keys,
		"slide": slide(skel, frames, _xf, dt)}
	# Knees.
	var knee := {}
	var pole := {}
	for leg in LEGS:
		var u := skel.find_bone(leg[1])
		var l := skel.find_bone(leg[2])
		var fb := skel.find_bone(leg[3])
		var tb := skel.find_bone(leg[4])
		var flex := []
		var pa := []
		for g in frames:
			var H: Vector3 = (g[u] as Transform3D).origin
			var K: Vector3 = (g[l] as Transform3D).origin
			var A: Vector3 = (g[fb] as Transform3D).origin
			var T: Vector3 = (g[tb] as Transform3D).origin
			var fx := 180.0 - rad_to_deg((H - K).angle_to(A - K))
			flex.append(fx)
			var ax := (A - H).normalized()
			var v0 := (K - H) - ax * (K - H).dot(ax)
			var fd := (T - A) - ax * (T - A).dot(ax)
			if fx > 15.0 and v0.length() > 0.005 and fd.length() > 0.005:
				pa.append(rad_to_deg(fd.signed_angle_to(v0, ax)))
			else:
				pa.append(null)
		var d1 := _diff(flex)
		var d2 := _diff(d1)
		var j20 := 0
		var j90 := 0
		var pmax := 0.0
		for i in range(1, pa.size()):
			if pa[i] == null or pa[i - 1] == null:
				continue
			var dd := absf(wrapf(float(pa[i]) - float(pa[i - 1]), -180.0, 180.0))
			pmax = maxf(pmax, dd)
			if dd > 20.0:
				j20 += 1
			if dd > 90.0:
				j90 += 1
		var p_abs := []
		for v in pa:
			if v != null:
				p_abs.append(absf(float(v)))
		p_abs.sort()
		var first := []
		for v in flex.slice(0, 60):
			first.append(snappedf(float(v), 0.01))
		knee[leg[0]] = {"d2_rms": _rms(d2), "zz": _zigzag(d1, 0.1), "zz_s": _zigzag(d1, 0.1) / secs,
			"d1_max": _maxabs(d1), "d2_p99": _pct_abs(d2, 0.99), "first2s": first}
		if OS.get_environment("JIT_DUMP") != "":
			print("JIT_FLEX %s %s %s" % [clip, leg[0], JSON.stringify(flex.map(func(v): return snappedf(v, 0.01)))])
		pole[leg[0]] = {"jump20": j20, "flip90": j90, "max_step": pmax,
			"abs_p50": p_abs[int(p_abs.size() * 0.5)] if not p_abs.is_empty() else 0.0,
			"abs_p95": p_abs[int(p_abs.size() * 0.95)] if not p_abs.is_empty() else 0.0}
	out["knee"] = knee
	out["pole"] = pole
	# Joints: local rotation steps.
	var joints := {}
	for b in bones:
		var par := skel.get_bone_parent(int(b))
		var w := []
		for f in range(1, n):
			var g0: Transform3D = frames[f - 1][b]
			var g1: Transform3D = frames[f][b]
			var l0 := g0.basis.get_rotation_quaternion()
			var l1 := g1.basis.get_rotation_quaternion()
			if par >= 0:
				l0 = (frames[f - 1][par] as Transform3D).basis.get_rotation_quaternion().inverse() * l0
				l1 = (frames[f][par] as Transform3D).basis.get_rotation_quaternion().inverse() * l1
			w.append(_rotvec(l1 * l0.inverse()))
		var acc := []
		var last := -100
		var zz := 0
		var big := 0
		for i in range(1, w.size()):
			var a: Vector3 = w[i - 1]
			var c: Vector3 = w[i]
			acc.append((c - a).length())
			if a.dot(c) < 0.0 and a.length() > 0.3 and c.length() > 0.3:
				if i - last <= 3:
					zz += 1
				last = i
		for v in w:
			if (v as Vector3).length() > 15.0:
				big += 1
		joints[skel.get_bone_name(int(b))] = [snappedf(_rms(acc), 0.01), snappedf(zz / secs, 0.01), big]
	out["joints"] = joints
	# Hips position.
	var hb := skel.find_bone("Hips")
	var hp := []
	for g in frames:
		hp.append((g[hb] as Transform3D).origin)
	var st := []
	var acc2 := []
	var ax_d1 := {"x": [], "y": [], "z": []}
	for i in range(1, n):
		var d: Vector3 = hp[i] - hp[i - 1]
		st.append(d.length() * 1000.0)
		ax_d1["x"].append(d.x * 1000.0)
		ax_d1["y"].append(d.y * 1000.0)
		ax_d1["z"].append(d.z * 1000.0)
		if i >= 2:
			acc2.append(((hp[i] as Vector3) - 2.0 * (hp[i - 1] as Vector3) + (hp[i - 2] as Vector3)).length() * 1000.0)
	# The orbit camera follows the hips along the floor (clip_orbit.gd: c = hips, c.y = 1): its per-frame shake.
	var cam_acc := []
	for i in range(2, n):
		var a2: Vector3 = (hp[i] as Vector3) - 2.0 * (hp[i - 1] as Vector3) + (hp[i - 2] as Vector3)
		cam_acc.append(Vector2(a2.x, a2.z).length() * 1000.0)
	out["hips"] = {"step_mm_p50": _pct_abs(st, 0.5), "step_mm_p95": _pct_abs(st, 0.95), "acc_mm_rms": _rms(acc2),
		"acc_mm_p99": _pct_abs(acc2, 0.99), "zz_s": (_zigzag(ax_d1["x"], 0.5) + _zigzag(ax_d1["y"], 0.5) + _zigzag(ax_d1["z"], 0.5)) / secs,
		"xz_acc_mm_rms": _rms(cam_acc), "xz_zz_s": (_zigzag(ax_d1["x"], 0.5) + _zigzag(ax_d1["z"], 0.5)) / secs}
	# Feet (ankles, as drawn): per-frame travel; a step finished in one frame is a jump.
	var feet := {}
	for leg in LEGS:
		var fb := skel.find_bone(leg[3])
		var fs := []
		for i in range(1, n):
			fs.append(((frames[i][fb] as Transform3D).origin - (frames[i - 1][fb] as Transform3D).origin).length() * 1000.0)
		var j := 0
		for v in fs:
			if float(v) > 50.0:
				j += 1
		feet[leg[0]] = {"step_mm_p99": _pct_abs(fs, 0.99), "max_mm": _maxabs(fs), "over50mm": j}
	out["feet"] = feet
	print("JIT_JSON ", JSON.stringify(out))


## Plant slide of both balls of the feet (world, cm), owned_mocap_measure.gd's plant rule at step `dt`.
static func slide(skel: Skeleton3D, frames: Array, xf: Transform3D, dt: float) -> Dictionary:
	var out := []
	for nm in ["LeftToes", "RightToes"]:
		var b := skel.find_bone(nm)
		var ball := []
		for g in frames:
			ball.append(xf * (g[b] as Transform3D).origin)
		var hs := []
		for p in ball:
			hs.append((p as Vector3).y)
		hs.sort()
		var fl: float = hs[clampi(int(hs.size() * 0.05), 0, hs.size() - 1)]
		var start := -1
		var min_n := maxi(1, int(round(Measure.PLANT_MIN_S / dt)))
		for i in range(1, ball.size() + 1):
			var on := false
			if i < ball.size():
				var d: Vector3 = (ball[i] as Vector3) - (ball[i - 1] as Vector3)
				on = (ball[i] as Vector3).y - fl < Measure.FLOOR_BAND and Vector2(d.x, d.z).length() / dt < Measure.PLANT_SPEED
			if on and start < 0:
				start = i - 1
			elif not on and start >= 0:
				if i - start >= min_n:
					var far := 0.0
					for k in range(start, i):
						var d2: Vector3 = (ball[k] as Vector3) - (ball[start] as Vector3)
						far = maxf(far, Vector2(d2.x, d2.z).length())
					out.append(far * 100.0)
				start = -1
	var s := 0.0
	for v in out:
		s += float(v)
	return {"plants": out.size(), "max_cm": _maxabs(out), "mean_cm": s / maxf(1.0, out.size())}


static func _maxabs(arr: Array) -> float:
	var m := 0.0
	for v in arr:
		m = maxf(m, absf(float(v)))
	return m


static func _pct_abs(arr: Array, p: float) -> float:
	if arr.is_empty():
		return 0.0
	var s := []
	for v in arr:
		s.append(absf(float(v)))
	s.sort()
	return float(s[clampi(int(s.size() * p), 0, s.size() - 1)])
