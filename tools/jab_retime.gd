extends SceneTree
## S438 CLIPFIX4 (in-house round): retime the three hanging jabs on THE ruler's number. The hang is PunchForm.hang_s
## over the ruler's strike window (tools/punch_form.gd strike_samples: contact - 0.4 s to back_s), the UpperArm shoulder,
## facing +Z. Contact and back_s are measured here on the take itself by clip_contact.gd's and clip_recovery.gd's
## methods (never read from the jsons, which a re-run rewrites from the FIXED take). The original is loaded as
## o_<clip> through FightClips._add_baked, exactly as the game loads a take.
## The warp: the span starts at the PEAK sample (the hold after full reach, never the extension) and ends where the
## hang run ends. Its time-scale factor runs from 1 down to m over ramp_keys keys of the take (30 Hz), stays m, and
## runs back to 1 over ramp_keys keys (smoothstep), integrated in closed form so time is monotonic; every key after
## the span moves earlier by the time saved. No key is deleted or re-posed. The span's new length D is the LARGEST
## that brings the measured hang to <= the clip's target (TARGETS); that take must keep contact within MAX_FRAMES 60 Hz frames (counted
## as frames, never as a float compare of snapped times), peak reach within 2 % and the step bar. If the span from the
## peak fails, the span start walks later one 60 Hz sample at a time; the first start that holds everything is written.
## If none does, the clip is NOT written: STOP lines give the best hang of any tried take with contact kept and the
## contact shift the span from the peak needs for the target hang.
## Originals in assets/anim/baked are never written; fixed takes go to assets/anim/baked/fixed/. A clip whose hang
## is already <= its target has any old fixed/ file removed. The chosen take must ALSO pass the retime test's step
## bar (worst 60 Hz step of any bone <= the original's x original hang / TARGET hang + 0.01 m, every bone): if not,
## STOP (nothing written, any old fixed/ file removed so the game plays the original). Headless:
##   <godot.exe> --headless --audio-driver Dummy --path . --script res://tools/jab_retime.gd [-- ramp=N] [-- dry]
## `dry` writes and removes nothing (to look at another ease length).

const Stage := preload("res://scripts/fight3d/FightStage.gd")
const PunchForm := preload("res://scripts/rules/PunchForm.gd")
const FightClips := preload("res://scripts/fight3d/FightClips.gd")
const Ruler := preload("res://tools/punch_form.gd")
const BAKED := "res://assets/anim/baked/"
const FIXED := "res://assets/anim/baked/fixed/"
const TMP := "user://jab_retime_tmp_%s_%d.res"
const HZ := 60.0
const KEY_DT := 1.0 / 30.0
## The ease at each edge of the span, in keys of the take. LEAD RULING S439 (R2): ONE key (with one key jab_b and jab_c
## pass every check at 3.2x / 4.5x middle speed, against 31.9x with two). `-- ramp=N` changes it for a look.
static var ramp_keys := 1
## LEAD RULING S439 (R3): the hang each jab is retimed to, per clip. jab_b and jab_c 0.14; the plain jab 0.165 (at or
## under the GOOD jab_a's 0.167). tests/jab_retime_test.gd reads this same table (one source).
const TARGETS := {
	"pro_left_jab": 0.165,
	"pro_left_jab_b": 0.14,
	"pro_left_jab_c": 0.14,
}
## Contact is kept when it moves at most this many 60 Hz frames (counted, never a float compare of snapped times).
const MAX_FRAMES := 1
const FACING := Vector3(0, 0, 1)
const JABS := {
	"pro_left_jab": "mc_Box1_M3_Left_Jab.res",
	"pro_left_jab_b": "mc_Box1_M3_Left_Jab_B.res",
	"pro_left_jab_c": "mc_Box1_M3_Left_Jab_C.res",
}

var _tmp_n := 0
## The target hang of the clip being retimed (TARGETS[clip]).
var _target := 0.14
## The lowest-hang take tried so far (this clip) that kept contact and reach: the STOP report's "best kept".
var _kept: Dictionary = {}


func _initialize() -> void:
	var stage: Node3D = Stage.new()
	root.add_child(stage)
	await process_frame
	stage.setup({"glb": "res://assets/models/metahuman/mh_boxer_10.glb", "corner": "red"},
		{"glb": "res://assets/models/metahuman/mh_boxer_11.glb", "corner": "blue"})
	stage.set_process(false)
	var bx: Dictionary = stage.boxers[0]
	var ap: AnimationPlayer = bx["ap"]
	var skel: Skeleton3D = bx["skel"]
	var lib: AnimationLibrary = ap.get_animation_library("")
	var prefix: String = str(ap.get_node(ap.root_node).get_path_to(skel))
	var gap: float = stage.gap_m
	var dry := false
	for arg in OS.get_cmdline_user_args():
		if str(arg) == "dry":
			dry = true
		elif str(arg).begins_with("ramp="):
			ramp_keys = int(str(arg).substr(5))
	print("JAB_RETIME gap_m=%.4f ramp_keys=%d dry=%s" % [gap, ramp_keys, dry])
	for clip in JABS:
		var src: String = BAKED + str(JABS[clip])
		var o_name: String = "o_" + clip
		FightClips._add_baked(lib, skel, prefix, o_name, src)
		var orig: Dictionary = measure_take(bx, o_name, gap)
		var hw: Dictionary = orig["window"]
		print("JAB_RETIME %s ORIGINAL len=%.3f contact=%.3f back=%.3f hang=%.4f left=%.4f peak=%.4f right=%.4f reach=%.4f" % [
			clip, orig["length"], orig["contact"], orig["back"], orig["hang"], hw["left_t"], hw["peak_t"], hw["right_t"], orig["peak_reach"]])
		var out_path: String = FIXED + str(JABS[clip])
		_target = float(TARGETS[clip])
		if float(orig["hang"]) <= _target:
			_drop(out_path, dry)
			print("JAB_RETIME %s hang %.4f already <= %.3f: no retime, no fixed file" % [clip, orig["hang"], _target])
			continue
		var anim: Animation = load(src)
		var o_step: float = worst_step(bx, o_name, float(orig["length"]))
		var found: Dictionary = _find(lib, skel, prefix, bx, gap, anim, clip, orig, o_step)
		if found.is_empty():
			_drop(out_path, dry)
			continue
		var fixed: Animation = found["anim"]
		var line: String = found["line"]
		if dry:
			print("JAB_RETIME %s DRY (not written) %s" % [clip, line])
			continue
		# The saved id would otherwise come from Godot's id generator, whose draws depend on how much searching ran
		# first: an id from the clip's name keeps a re-run byte-identical.
		fixed.resource_scene_unique_id = "Animation_%08x" % (clip.hash() & 0x7fffffff)
		var err := ResourceSaver.save(fixed, out_path)
		print("JAB_RETIME %s WROTE %s err=%d %s" % [clip, out_path, err, line])
	print("JAB_RETIME DONE")
	quit(0)


func _drop(path: String, dry: bool) -> void:
	if not dry and ResourceLoader.exists(path):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(path))
		print("JAB_RETIME removed %s (the game plays the original)" % path)


func _candidate_step(lib: AnimationLibrary, skel: Skeleton3D, prefix: String, bx: Dictionary, w: Animation, clip: String) -> float:
	_tmp_n += 1
	var path: String = TMP % [clip, _tmp_n]
	ResourceSaver.save(w, path)
	var name: String = "w_" + clip
	FightClips._add_baked(lib, skel, prefix, name, path)
	var step: float = worst_step(bx, name, w.length)
	(bx["ap"] as AnimationPlayer).stop()
	lib.remove_animation(name)
	DirAccess.remove_absolute(ProjectSettings.globalize_path(path))
	return step


## Every bone's position at time t (one seek, then the whole skeleton), in the body's space as IdleMatch.pose_point.
static func all_points(bx: Dictionary, clip: String, t: float) -> PackedVector3Array:
	var ap: AnimationPlayer = bx["ap"]
	ap.play(clip)
	ap.seek(t, true)
	var skel: Skeleton3D = bx["skel"]
	var to_body := (bx["node"] as Node3D).global_transform.affine_inverse() * skel.global_transform
	var out := PackedVector3Array()
	for i in skel.get_bone_count():
		out.append(to_body * skel.get_bone_global_pose(i).origin)
	return out


## The largest distance any bone moves between two 60 Hz samples, over the whole take.
static func worst_step(bx: Dictionary, clip: String, length: float) -> float:
	var prev: PackedVector3Array = all_points(bx, clip, 0.0)
	var worst := 0.0
	var t := 1.0 / HZ
	while t <= length + 0.0001:
		var cur: PackedVector3Array = all_points(bx, clip, minf(t, length))
		for i in cur.size():
			worst = maxf(worst, cur[i].distance_to(prev[i]))
		prev = cur
		t += 1.0 / HZ
	return worst


## Every number the retime is judged on, measured on one loaded take.
static func measure_take(bx: Dictionary, name: String, gap: float) -> Dictionary:
	var length: float = (bx["ap"] as AnimationPlayer).get_animation(name).length
	var contact: float = contact_on_take(bx, name, length, gap)
	var back: float = back_on_take(bx, name, contact, length)
	var samples: Array = Ruler.strike_samples(bx, name, contact, back, length, true)
	var hw: Dictionary = PunchForm.hang_window(samples, FACING)
	return {"length": length, "contact": contact, "back": back, "window": hw, "hang": hw["hang_s"],
		"peak_reach": peak_reach(bx, name, length)}


## clip_contact.gd's far_s for a lead-hand punch at head height (the rule contact used until S439; since POWER1 step 2 the
## hit, contact_s, lands earlier): the moment, from 0.15 s to 75 % of the clip, the LeftHand comes closest to
## (0, head_y at frame 0, gap_m); snapped to 1 ms as clip_contact.json stores it.
static func contact_on_take(bx: Dictionary, name: String, length: float, gap: float) -> float:
	var head_y: float = Stage.IdleMatch.pose_point(bx, name, 0.0, "Head").y
	var target := Vector3(0.0, head_y, gap)
	var best_t := 0.0
	var best_miss := 99.0
	var t := 0.15
	while t <= length * 0.75:
		var miss: float = Stage.IdleMatch.pose_point(bx, name, t, "LeftHand").distance_to(target)
		if miss < best_miss:
			best_miss = miss
			best_t = t
		t += 1.0 / HZ
	return snappedf(best_t, 0.001)


## clip_recovery.gd's back_s: from the contact sample, the first 60 Hz moment both hands, head and hips are all within
## 0.08 m of pro_idle's frame 0; snapped to 1 ms as clip_recovery.json stores it.
static func back_on_take(bx: Dictionary, name: String, contact: float, length: float) -> float:
	var bones := ["LeftHand", "RightHand", "Head", "Hips"]
	var guard := {}
	for b in bones:
		guard[b] = Stage.IdleMatch.pose_point(bx, "pro_idle", 0.0, b)
	var devs: Array = []
	var t := 0.0
	while t <= length + 0.0001:
		var worst := 0.0
		for b in bones:
			worst = maxf(worst, Stage.IdleMatch.pose_point(bx, name, minf(t, length), b).distance_to(guard[b]))
		devs.append(worst)
		t += 1.0 / HZ
	var from_i: int = mini(devs.size() - 1, int(round(contact * HZ)))
	for i in range(from_i, devs.size()):
		if float(devs[i]) <= 0.08:
			return snappedf(i / HZ, 0.001)
	return -1.0


## The largest LeftHand-to-LeftUpperArm distance over the whole take.
static func peak_reach(bx: Dictionary, name: String, length: float) -> float:
	var best := 0.0
	var t := 0.0
	while t <= length + 0.0001:
		best = maxf(best, Stage.IdleMatch.pose_point(bx, name, t, "LeftHand").distance_to(
			Stage.IdleMatch.pose_point(bx, name, t, "LeftUpperArm")))
		t += 1.0 / HZ
	return best


## Bisection, on the measured hang alone, for the largest span length D that reads hang <= _target; the take at
## that D is the least compressed one that meets the hang, so it also moves contact least. It is then judged on
## contact and reach ("ok"). Returns the shortest try (ok=false) when even it reads hang > _target.
func _search(lib: AnimationLibrary, skel: Skeleton3D, prefix: String, bx: Dictionary, gap: float, anim: Animation,
		clip: String, orig: Dictionary, a: float, span: float) -> Dictionary:
	var lo: float = ramp_len(span) + 0.002   # D must exceed the ramps' own share (m > 0)
	var hi: float = span
	var shortest: Dictionary = _try(lib, skel, prefix, bx, gap, anim, clip, orig, a, span, lo)
	print("JAB_RETIME %s shortest span %.4f s: %s" % [clip, lo, _brief(shortest)])
	if float(shortest["hang"]) > _target:
		shortest["ok"] = false
		return shortest
	var best: Dictionary = shortest
	for i in 12:
		var mid: float = (lo + hi) * 0.5
		var got: Dictionary = _try(lib, skel, prefix, bx, gap, anim, clip, orig, a, span, mid)
		print("JAB_RETIME %s try span %.4f s: %s" % [clip, mid, _brief(got)])
		if float(got["hang"]) <= _target:
			best = got
			lo = mid
		else:
			hi = mid
	return best


func _try(lib: AnimationLibrary, skel: Skeleton3D, prefix: String, bx: Dictionary, gap: float, anim: Animation,
		clip: String, orig: Dictionary, a: float, span: float, d: float) -> Dictionary:
	var w: Animation = warp_animation(anim, a, span, d)
	_tmp_n += 1
	var path: String = TMP % [clip, _tmp_n]
	ResourceSaver.save(w, path)
	var name: String = "w_" + clip
	if lib.has_animation(name):
		lib.remove_animation(name)
	FightClips._add_baked(lib, skel, prefix, name, path)
	var got: Dictionary = measure_take(bx, name, gap)
	(bx["ap"] as AnimationPlayer).stop()
	lib.remove_animation(name)
	DirAccess.remove_absolute(ProjectSettings.globalize_path(path))
	var contact_shift: float = absf(float(got["contact"]) - float(orig["contact"]))
	var reach_err: float = absf(float(got["peak_reach"]) - float(orig["peak_reach"])) / float(orig["peak_reach"])
	got["d"] = d
	got["m"] = ramp_mid_scale(span, d)
	got["contact_shift"] = contact_shift
	got["frames"] = contact_frames(float(got["contact"]), float(orig["contact"]))
	got["a"] = a
	got["ok"] = float(got["hang"]) <= _target and int(got["frames"]) <= MAX_FRAMES and reach_err <= 0.02
	if int(got["frames"]) <= MAX_FRAMES and reach_err <= 0.02 and (_kept.is_empty() or float(got["hang"]) < float(_kept["hang"])):
		_kept = got.duplicate()
	return got


## How many 60 Hz frames apart two contact times are (both are 60 Hz samples from 0.15 s, snapped to 1 ms).
static func contact_frames(t1: float, t2: float) -> int:
	return int(round(absf(t1 - t2) * HZ))


func _brief(g: Dictionary) -> String:
	return "hang %.4f contact %.3f (shift %.3f, %d frames) back %.3f reach %.4f ok=%s" % [g["hang"], g["contact"],
		g["contact_shift"], g["frames"], g["back"], g["peak_reach"], g["ok"]]


## Walk the span start from the PEAK sample later, one 60 Hz sample at a time (the span always ends where the hang run
## ends). At each start: bisection for the largest D reading hang <= _target, judged on contact (<= MAX_FRAMES
## frames), reach (2 %) and then the step bar. The first start whose take holds all of them is returned (the least
## moved). Otherwise STOP lines: every step-bar failure as it happens, the lowest hang of any tried take that kept
## contact and reach, and the contact shift the span from the peak needs for hang <= _target. Returns {} on STOP.
func _find(lib: AnimationLibrary, skel: Skeleton3D, prefix: String, bx: Dictionary, gap: float, anim: Animation,
		clip: String, orig: Dictionary, o_step: float) -> Dictionary:
	_kept = {}
	var hw: Dictionary = orig["window"]
	var right: float = float(hw["right_t"])
	var a: float = float(hw["peak_t"])
	var from_peak: Dictionary = {}
	var first := true
	while a < right - 0.02:
		var span: float = right - a
		var best: Dictionary = _search(lib, skel, prefix, bx, gap, anim, clip, orig, a, span)
		if first:
			from_peak = best
			first = false
		if not best.is_empty() and bool(best["ok"]):
			var w: Animation = warp_animation(anim, a, span, float(best["d"]))
			var f_step: float = _candidate_step(lib, skel, prefix, bx, w, clip)
			var bar: float = step_bar(o_step, float(orig["hang"]), _target)
			var line := "span [%.4f, %.4f] -> %.4f s (m=%.3f, middle %.1fx speed) len %.3f -> %.3f hang %.4f -> %.4f contact %.3f -> %.3f (%d frames) back %.3f -> %.3f reach %.4f -> %.4f worst step %.4f -> %.4f (bar %.4f)" % [
				a, a + span, best["d"], best["m"], 1.0 / float(best["m"]), orig["length"], w.length, orig["hang"], best["hang"],
				orig["contact"], best["contact"], best["frames"], orig["back"], best["back"], orig["peak_reach"], best["peak_reach"], o_step, f_step, bar]
			if f_step <= bar:
				# A fresh warp for the file: `w` was saved to a temp path, which stamps a new local id into the resource.
				return {"anim": warp_animation(anim, a, span, float(best["d"])), "line": line}
			print("JAB_RETIME %s STOP (step) at span start %.4f: hang <= %.3f with contact kept breaks the step bar: %s" % [clip, a, _target, line])
		a += 1.0 / HZ
	if _kept.is_empty():
		print("JAB_RETIME %s STOP: no tried take keeps contact within %d frame and reach within 2%%" % [clip, MAX_FRAMES])
	else:
		print("JAB_RETIME %s STOP: best hang with contact kept %.4f (span from %.4f, D %.4f, contact %.3f -> %.3f, %d frames); target %.3f" % [
			clip, _kept["hang"], _kept["a"], _kept["d"], orig["contact"], _kept["contact"], _kept["frames"], _target])
	if from_peak.is_empty() or float(from_peak["hang"]) > _target:
		print("JAB_RETIME %s STOP: the span from the peak never reads hang <= %.3f" % [clip, _target])
	else:
		print("JAB_RETIME %s STOP: hang %.4f from the peak needs contact %.3f -> %.3f (shift %.3f s, %d frames at 60 Hz)" % [
			clip, from_peak["hang"], orig["contact"], from_peak["contact"], from_peak["contact_shift"], from_peak["frames"]])
	print("JAB_RETIME %s STOP: nothing written; the hang's part before the peak is %.4f s, contact is %.3f s after the peak" % [
		clip, float(hw["peak_t"]) - float(hw["left_t"]), float(orig["contact"]) - float(hw["peak_t"])])
	return {}


## The step bar (LEAD RULING S439 R7: divided by the TARGET hang, as the brief says, not the measured one):
## the original's worst 60 Hz step x original hang / target hang + 0.01 m.
static func step_bar(o_step: float, orig_hang: float, target: float) -> float:
	return o_step * orig_hang / target + 0.01


## The ramp's length at each edge in the original's time: ramp_keys keys of the take, at most half the span.
static func ramp_len(span: float) -> float:
	return minf(ramp_keys * KEY_DT, span * 0.5)


## The middle time-scale factor m that makes a span of length `span` last `d`: r(1 + m) + m(span - 2r) = d.
static func ramp_mid_scale(span: float, d: float) -> float:
	var r: float = ramp_len(span)
	return (d - r) / (span - r)


## New time of original time t: speed 1 before a, smoothstep 1 -> m over r, m, smoothstep m -> 1 over r, then 1.
static func warp_time(t: float, a: float, span: float, d: float) -> float:
	if t <= a:
		return t
	var r: float = ramp_len(span)
	var m: float = ramp_mid_scale(span, d)
	var x: float = t - a
	if x >= span:
		return a + d + (x - span)
	if x <= r:
		return a + x + (m - 1.0) * r * _ease_area(x / r)
	var base: float = r * (1.0 + m) * 0.5
	if x <= span - r:
		return a + base + m * (x - r)
	var y: float = (x - (span - r)) / r
	return a + base + m * (span - 2.0 * r) + r * (m * y + (1.0 - m) * _ease_area(y))


## The area under smoothstep from 0 to y: y^3 - y^4 / 2.
static func _ease_area(y: float) -> float:
	return y * y * y - y * y * y * y * 0.5


## A copy of `anim` with every key time warped; asserts the times stay strictly increasing per track.
static func warp_animation(anim: Animation, a: float, span: float, d: float) -> Animation:
	var w: Animation = anim.duplicate(true)
	for tr in w.get_track_count():
		var prev := -1.0
		for k in w.track_get_key_count(tr):
			var nt: float = warp_time(w.track_get_key_time(tr, k), a, span, d)
			assert(nt > prev, "warp kept key order")
			if nt <= prev:
				push_error("JAB_RETIME key order broken on track %d key %d" % [tr, k])
			w.track_set_key_time(tr, k, nt)
			prev = nt
	w.length = warp_time(anim.length, a, span, d)
	return w
