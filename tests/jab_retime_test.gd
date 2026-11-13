extends SceneTree
## S438 CLIPFIX4 (in-house round): the three retimed jabs against their originals, on ONE hang number.
## The fixed take is the clip the stage already loaded (FightClips' fixed/ lookup = what the game plays); the original
## is loaded beside it as o_<clip> through FightClips._add_baked (the game's own loader). Per jab:
##  1. a fixed take exists and is shorter than the original;
##  2. the original's hang > the ruler's bar (Ruler.HANG_MAX 0.17, LEAD RULING S439 R1; its own red "before");
##  3. the fixed hang <= the clip's target (Retime.TARGETS, LEAD RULING S439 R3: jab 0.165, jab_b and jab_c 0.14):
##     PunchForm.hang_s over the ruler's strike window (tools/punch_form.gd strike_samples),
##     contact and back_s measured on the take by clip_contact's / clip_recovery's methods (tools/jab_retime.gd), and
##     those two equal the committed clip_contact / clip_recovery rows (so the ruler reads the same window);
##  4. contact within one 60 Hz frame of the original (counted in frames: Retime.contact_frames <= 1), target (0, head_y, stage.gap_m) as clip_contact.gd;
##  5. peak reach (LeftHand to LeftUpperArm) within 2 %;
##  6. first and last pose within 1 cm over EVERY bone of the skeleton;
##  7. the worst 60 Hz step of any bone <= the original's worst x (original hang / TARGET hang) + 0.01 m (LEAD RULING
##     S439 R7; Retime.step_bar and Retime.worst_step, the tool's own: it refuses to write a take that breaks it);
##  8. the same keys as the original (count and values per track), times strictly increasing: re-timed, not re-posed.
## A jab tools/jab_retime.gd STOPPED on (no fixed take) prints a FINDING and fails: that is the lead's decision.

const Stage := preload("res://scripts/fight3d/FightStage.gd")
const FightClips := preload("res://scripts/fight3d/FightClips.gd")
const BeatClips := preload("res://scripts/fight3d/BeatClips.gd")
const Retime := preload("res://tools/jab_retime.gd")
const Ruler := preload("res://tools/punch_form.gd")
const BAKED := "res://assets/anim/baked/"
const FIXED := "res://assets/anim/baked/fixed/"
const HZ := 60.0
const JABS := {
	"pro_left_jab": "mc_Box1_M3_Left_Jab.res",
	"pro_left_jab_b": "mc_Box1_M3_Left_Jab_B.res",
	"pro_left_jab_c": "mc_Box1_M3_Left_Jab_C.res",
}

var failures := 0


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
	print("JAB_RETIME_TEST gap_m=%.4f bones=%d" % [gap, skel.get_bone_count()])
	var contact_doc: Dictionary = Ruler.read_json(BeatClips.CONTACT_PATH)
	var recovery_doc: Dictionary = Ruler.read_json(BeatClips.RECOVERY_PATH)
	for clip in JABS:
		var o_name: String = "o_" + clip
		FightClips._add_baked(lib, skel, prefix, o_name, BAKED + str(JABS[clip]))
		var orig: Dictionary = Retime.measure_take(bx, o_name, gap)
		var target: float = float(Retime.TARGETS[clip])
		_check(float(orig["hang"]) > Ruler.HANG_MAX, "%s original hang %.4f > %.2f (red before)" % [clip, orig["hang"], Ruler.HANG_MAX])
		if not ResourceLoader.exists(FIXED + str(JABS[clip])):
			failures += 1
			print("FAIL FINDING %s: no fixed take - tools/jab_retime.gd STOPPED on it (its STOP lines say which bars cannot hold together: hang <= %.3f with contact within one frame, or the step bar). The game plays the original, hang %.4f" % [clip, target, orig["hang"]])
			continue
		var fixed: Dictionary = Retime.measure_take(bx, clip, gap)
		_check(float(fixed["length"]) < float(orig["length"]), "%s fixed length %.3f < original %.3f" % [clip, fixed["length"], orig["length"]])
		_check(float(fixed["hang"]) <= target, "%s fixed hang %.4f <= target %.3f (original %.4f)" % [clip, fixed["hang"], target, orig["hang"]])
		var crow: Dictionary = contact_doc.get(clip, {})
		var rrow: Dictionary = recovery_doc.get(clip, {})
		# POWER1 step 2: the ruler's window is anchored on far_s (the rule contact used until S439); contact_s is now the hit frame.
		_check(absf(float(crow.get("far_s", -9.0)) - float(fixed["contact"])) < 0.0005,
			"%s clip_contact.json far_s %.3f = measured %.3f (the ruler's window)" % [clip, float(crow.get("far_s", -9.0)), fixed["contact"]])
		_check(absf(float(rrow.get("back_s", -9.0)) - float(fixed["back"])) < 0.0005,
			"%s clip_recovery.json back_s %.3f = measured %.3f (the ruler's window)" % [clip, float(rrow.get("back_s", -9.0)), fixed["back"]])
		var shift: float = absf(float(fixed["contact"]) - float(orig["contact"]))
		var frames: int = Retime.contact_frames(float(fixed["contact"]), float(orig["contact"]))
		_check(frames <= 1, "%s contact within one frame: %.3f -> %.3f (shift %.3f s = %d frames at 60 Hz)" % [clip, orig["contact"], fixed["contact"], shift, frames])
		var reach_err: float = absf(float(fixed["peak_reach"]) - float(orig["peak_reach"])) / float(orig["peak_reach"])
		_check(reach_err <= 0.02, "%s peak reach within 2%%: %.4f -> %.4f (%.2f%%)" % [clip, orig["peak_reach"], fixed["peak_reach"], reach_err * 100.0])
		var first: float = _pose_gap(bx, o_name, 0.0, clip, 0.0)
		_check(first < 0.01, "%s first pose, every bone: worst %.5f m < 0.01" % [clip, first])
		var last: float = _pose_gap(bx, o_name, float(orig["length"]), clip, float(fixed["length"]))
		_check(last < 0.01, "%s last pose, every bone: worst %.5f m < 0.01" % [clip, last])
		var o_step: float = Retime.worst_step(bx, o_name, float(orig["length"]))
		var f_step: float = Retime.worst_step(bx, clip, float(fixed["length"]))
		var bar: float = Retime.step_bar(o_step, float(orig["hang"]), target)
		_check(f_step <= bar, "%s worst 60 Hz step, every bone: fixed %.4f m <= %.4f (original %.4f x %.3f / target %.3f + 0.01)" % [
			clip, f_step, bar, o_step, float(orig["hang"]), target])
		_check_keys(ap.get_animation(o_name), ap.get_animation(clip), clip)
	print("JAB_RETIME failures=%d" % failures)
	quit(1 if failures > 0 else 0)


func _pose_gap(bx: Dictionary, a: String, ta: float, b: String, tb: float) -> float:
	var pa: PackedVector3Array = Retime.all_points(bx, a, ta)
	var pb: PackedVector3Array = Retime.all_points(bx, b, tb)
	var worst := 0.0
	for i in pa.size():
		worst = maxf(worst, pa[i].distance_to(pb[i]))
	return worst


## Re-timed, not re-posed: same tracks, same key counts, same key values; times strictly increasing.
func _check_keys(o: Animation, f: Animation, clip: String) -> void:
	var ok: bool = o.get_track_count() == f.get_track_count()
	var worst_val := 0.0
	var keys := 0
	for tr in mini(o.get_track_count(), f.get_track_count()):
		if o.track_get_key_count(tr) != f.track_get_key_count(tr):
			ok = false
			continue
		var prev := -1.0
		for k in f.track_get_key_count(tr):
			var ft: float = f.track_get_key_time(tr, k)
			if ft <= prev:
				ok = false
			prev = ft
			keys += 1
			var ov: Variant = o.track_get_key_value(tr, k)
			var fv: Variant = f.track_get_key_value(tr, k)
			if ov is Quaternion:
				worst_val = maxf(worst_val, absf(1.0 - absf((ov as Quaternion).dot(fv as Quaternion))))
			elif ov is Vector3:
				worst_val = maxf(worst_val, (ov as Vector3).distance_to(fv as Vector3))
	_check(ok and worst_val < 0.000001, "%s keys: %d tracks, %d keys, order strictly increasing, worst value change %.8f" % [
		clip, f.get_track_count(), keys, worst_val])


func _check(cond: bool, msg: String) -> void:
	if cond:
		print("PASS " + msg)
	else:
		failures += 1
		print("FAIL " + msg)
