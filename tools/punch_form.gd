extends SceneTree
## S438 CLIPFIX4 (in-house round): the punch form ruler. Every clip is measured as the GAME loads it (FightClips, so the
## three jabs are the fixed/ takes when those exist) over the strike window: 0.4 s before contact_s (clip_contact.json)
## to back_s (clip_recovery.json). LEAD RULING S439 R8: a clip with a fixed take also gets an o_<clip> row measured on
## its ORIGINAL take (window from jab_retime's measure_take), so the json holds before and after; the test judges the
## eye's fault on o_<clip>, and the fixed take by LEAD RULING S439 R12: it must pass the fixed fault's bar and be no
## worse than o_<clip> on any other bar (a fault the original already had prints STILL FAULTY and does not fail;
## reason: the retime fixes the eye's fault only, e.g. jab_c's rear glove og_far 0.319 fixed / 0.321 original). The shoulder is the UpperArm joint. Guards (the punching wrist and the other glove)
## are the clip's first frame relative to the pelvis. Back-to-guard searches from contact to the clip's END.
## Every measure is one PunchForm call (no value is computed twice or overwritten). punch_form.json also stores, per
## clip, the md5 of the take file it measured and of the contact and recovery rows it read: punch_form_test compares
## those hashes, so a stale json is caught on a fresh clone (mtimes do not survive git); it also stores the md5 of the
## clip's own row, so a hand-edited output value is caught too.
## The static helpers below (strike_window, strike_samples) are the ONE strike window: tools/jab_retime.gd and
## tests/jab_retime_test.gd call them, so the hang is one number (PunchForm.hang_s) on one window everywhere.
## Run it LAST, after clip_contact.gd, clip_recovery.gd and clip_travel.gd. Headless:
##   <godot.exe> --headless --audio-driver Dummy --path . --script res://tools/punch_form.gd

const Stage := preload("res://scripts/fight3d/FightStage.gd")
const PunchForm := preload("res://scripts/rules/PunchForm.gd")
const BeatClips := preload("res://scripts/fight3d/BeatClips.gd")
const FightClips := preload("res://scripts/fight3d/FightClips.gd")
const OUT := "res://assets/data/punch_form.json"
const HZ := 60.0
const LEAD_S := 0.4
const FACING := Vector3(0, 0, 1)
## The hang bar for jabs and crosses (LEAD RULING S439 R1: 0.17 s; the GOOD jab_a reads 0.167 on this measure and a real
## jab's contact phase is 122-144 ms, Ueberschar 2021). tests/punch_form_test.gd and tests/jab_retime_test.gd read it.
const HANG_MAX := 0.17
## The body shots' bow bar (LEAD RULING S439 R5): the head over the lead HIP (bow_hip_m), fail above 0.25 m.
const BOW_HIP_MAX := 0.25
const CLIPS := [
	"pro_left_jab_a", "pro_right_uppercut",
	"pro_left_jab", "pro_left_jab_b", "pro_left_jab_c",
	"pro_right_cross", "pro_right_cross_a", "pro_right_cross_b", "pro_right_cross_c",
	"pro_left_hook", "pro_left_hook_v2",
	"pro_left_uppercut",
	"pro_body_shot", "pro_kidney_shot",
	"pro_right_hook",
]
const BONES := ["LeftUpperArm", "LeftLowerArm", "LeftHand", "RightUpperArm", "RightLowerArm", "RightHand",
	"Head", "Hips", "LeftUpperLeg", "RightUpperLeg", "LeftLowerLeg"]


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
	# Loaded, not preloaded: jab_retime.gd preloads this script (its measure_take is the original's window, R8).
	var retime: GDScript = load("res://tools/jab_retime.gd")
	var contact_doc: Dictionary = read_json(BeatClips.CONTACT_PATH)
	var recovery_doc: Dictionary = read_json(BeatClips.RECOVERY_PATH)
	var clips_out := {}
	var inputs := {}
	for clip in CLIPS:
		if not ap.has_animation(clip):
			print("MISSING %s" % clip)
			continue
		var length: float = ap.get_animation(clip).length
		var crow: Dictionary = contact_doc.get(clip, {})
		var rrow: Dictionary = recovery_doc.get(clip, {})
		# POWER1 step 2: the window is anchored on the clip's furthest point (far_s, the rule contact used until S439); the
		# hit now lands earlier, on the glove's fast frame (contact_s), which is not what this ruler measures around.
		var contact_s: float = float(crow.get("far_s", crow.get("contact_s", -1.0)))
		if contact_s < 0.15:
			contact_s = BeatClips.contact(clip, length * 0.5)
		_measure_into(bx, clip, contact_s, float(rrow.get("back_s", -1.0)), crow, rrow, clips_out, inputs)
		if has_fixed(clip):
			# LEAD RULING S439 R8: a clip with a fixed take keeps a second row, o_<clip>, its ORIGINAL take (the eye's
			# row). Its window is measured on that take by jab_retime's measure_take (clip_contact's and
			# clip_recovery's methods), the measure jab_retime_test already makes; the tables hold the fixed take's rows.
			var o_name: String = "o_" + clip
			FightClips._add_baked(lib, skel, prefix, o_name, take_path(o_name))
			var om: Dictionary = retime.measure_take(bx, o_name, stage.gap_m)
			_measure_into(bx, o_name, float(om["contact"]), float(om["back"]), {}, {}, clips_out, inputs)
	var f := FileAccess.open(OUT, FileAccess.WRITE)
	f.store_string(JSON.stringify({"clips": clips_out, "inputs": inputs}, "\t", true))
	f.close()
	print("PUNCH_FORM DONE %d rows -> %s" % [clips_out.size(), OUT])
	quit(0)


## One clip's row (and its inputs' hashes) from its strike window [contact - 0.4, back_row].
static func _measure_into(bx: Dictionary, clip: String, contact_s: float, back_row: float, crow: Dictionary, rrow: Dictionary,
		clips_out: Dictionary, inputs: Dictionary) -> void:
	var length: float = (bx["ap"] as AnimationPlayer).get_animation(clip).length
	var is_left: bool = clip.contains("left_") or clip.contains("kidney")
	var win: Array = strike_window(contact_s, back_row, length)
	var samples: Array = strike_samples(bx, clip, contact_s, back_row, length, is_left)
	# Back-to-guard: its own samples from contact to the clip's end (not cut at back_row).
	var tail: Array = samples_between(bx, clip, contact_s, length, is_left)
	var g: Dictionary = sample_pose(bx, clip, 0.0, is_left)
	var guard_rel: Vector3 = (g["wrist"] as Vector3) - (g["hips"] as Vector3)
	var other_rel: Vector3 = (g["other_wrist"] as Vector3) - (g["hips"] as Vector3)
	var t_last: float = float(samples[samples.size() - 1]["t"])
	var pk: Dictionary = PunchForm.peak(samples, FACING)
	var og: Dictionary = PunchForm.other_glove(samples, float(win[0]), t_last)
	var pd: Dictionary = PunchForm.pre_drop(samples, contact_s)
	var head_top_y: float = (samples[0]["head"] as Vector3).y + 0.10
	var m := {
		"length_s": length, "contact_s": contact_s, "window_s": [win[0], win[1]],
		"elbow_deg": pk["elbow_deg"], "elbow_contact_deg": PunchForm.elbow_at(samples, contact_s),
		"reach": pk["reach"], "hang_s": PunchForm.hang_s(samples, FACING),
		"other_glove_low_m": og["low_m"], "other_glove_far_m": PunchForm.other_glove_from_guard(samples, other_rel),
		"pre_drop_depth_m": pd["depth_m"], "pre_drop_held_s": pd["held_s"],
		"finish_over_head": PunchForm.finish_over_head(samples, head_top_y),
		"bow_m": PunchForm.bow_m(samples, contact_s, FACING),
		# The head over the lead HIP joint: the body shots' bow bar reads this (LEAD RULING S439 R5, BOW_HIP_MAX).
		"bow_hip_m": PunchForm.bow_m(samples, contact_s, FACING, "lead_hip"),
		"hip_turn_deg": PunchForm.hip_turn_deg(samples, float(win[0]), contact_s),
		"back_s": PunchForm.back_s(tail, contact_s, guard_rel),
		"reach_frac": PunchForm.reach_frac_max(samples),
		"forward_m": PunchForm.forward_at(samples, contact_s, g["hips"], FACING),
		# LEAD RULING S439 R10: the 3D extension hold (hand to UpperArm joint within 0.05 m of its peak), no bar.
		"ext_hold_s": PunchForm.extension_hold_s(samples),
	}
	clips_out[clip] = m
	inputs[clip] = {"take": take_path(clip), "take_md5": FileAccess.get_md5(take_path(clip)),
		"contact_row_md5": row_md5(crow), "recovery_row_md5": row_md5(rrow),
		# The md5 of this clip's own measured row as it reads back from the json: a hand-edited value goes stale.
		"row_md5": row_md5(JSON.parse_string(JSON.stringify(m, "	", true)))}
	print("FORM %s elbow=%.2f elbow_contact=%.2f hang=%.3f og_low=%.3f og_far=%.3f pre_drop=%.3f/%.3f finish=%.3f bow=%.3f bow_hip=%.3f hip=%.1f back=%.3f reach_frac=%.3f fwd=%.3f ext_hold=%.3f window=[%.3f, %.3f]" % [
		clip, m["elbow_deg"], m["elbow_contact_deg"], m["hang_s"], m["other_glove_low_m"], m["other_glove_far_m"],
		m["pre_drop_depth_m"], m["pre_drop_held_s"], m["finish_over_head"], m["bow_m"], m["bow_hip_m"], m["hip_turn_deg"],
		m["back_s"], m["reach_frac"], m["forward_m"], m["ext_hold_s"], win[0], win[1]])


static func read_json(path: String) -> Dictionary:
	var parsed: Variant = JSON.parse_string(FileAccess.get_file_as_string(path))
	return parsed if parsed is Dictionary else {}


## The md5 of one json row as parsed (punch_form_test recomputes it the same way from the same file).
static func row_md5(row: Dictionary) -> String:
	return JSON.stringify(row, "", true).md5_text()


## The take file the game loads for a pro_ clip: fixed/ when it exists (FightClips' lookup), else the baked one.
## o_<clip> (LEAD RULING S439 R8) is always the ORIGINAL baked take of <clip>.
static func take_path(clip: String) -> String:
	var original: bool = clip.begins_with("o_")
	var name: String = clip.substr(2) if original else clip
	for stem in FightClips.pro_stems():
		if FightClips.pro_name(str(stem)) == name:
			var path: String = FightClips.BAKED_DIR + str(stem) + ".res"
			var fixed: String = FightClips.FIXED_DIR + str(stem) + ".res"
			return fixed if (not original and ResourceLoader.exists(fixed)) else path
	return ""


## True when the game loads a fixed/ take for this clip (it then has an o_<clip> row too, R8).
static func has_fixed(clip: String) -> bool:
	return take_path(clip).begins_with(FightClips.FIXED_DIR)


## THE strike window: [contact - 0.4 (not before 0), back_s (the clip's end when back_s is not measured)].
static func strike_window(contact_s: float, back_s: float, length: float) -> Array:
	return [maxf(0.0, contact_s - LEAD_S), minf(length, back_s if back_s > 0.0 else length)]


## The strike window sampled at 60 Hz (every sample carries "t").
static func strike_samples(bx: Dictionary, clip: String, contact_s: float, back_s: float, length: float, is_left: bool) -> Array:
	var win: Array = strike_window(contact_s, back_s, length)
	return samples_between(bx, clip, float(win[0]), float(win[1]), is_left)


static func samples_between(bx: Dictionary, clip: String, a: float, b: float, is_left: bool) -> Array:
	var out: Array = []
	var t: float = a
	while t <= b + 0.0001:
		out.append(sample_pose(bx, clip, t, is_left))
		t += 1.0 / HZ
	return out


## One 60 Hz sample on the game's body: the punching arm (shoulder = the UpperArm joint), the other wrist, head,
## pelvis, the lead KNEE (the LeftLowerLeg joint; rounds 1-4 read the LeftUpperLeg joint, the hip, as the knee) and the
## pelvis yaw from the hip line on the floor plane.
static func sample_pose(bx: Dictionary, clip: String, t: float, is_left: bool) -> Dictionary:
	var p := {}
	for b in BONES:
		p[b] = Stage.IdleMatch.pose_point(bx, clip, t, b)
	var side: String = "Left" if is_left else "Right"
	var other: String = "Right" if is_left else "Left"
	return {"t": t, "wrist": p[side + "Hand"], "elbow": p[side + "LowerArm"], "shoulder": p[side + "UpperArm"],
		"other_wrist": p[other + "Hand"], "head": p["Head"], "hips": p["Hips"], "lead_knee": p["LeftLowerLeg"], "lead_hip": p["LeftUpperLeg"],
		"pelvis_yaw": pelvis_yaw(p)}


static func pelvis_yaw(p: Dictionary) -> float:
	var hip_right: Vector3 = (p["RightUpperLeg"] as Vector3) - (p["LeftUpperLeg"] as Vector3)
	hip_right.y = 0.0
	if hip_right.length() < 0.001:
		return 0.0
	var fwd: Vector3 = Vector3(-hip_right.z, 0.0, hip_right.x).normalized()
	return atan2(fwd.x, fwd.z)
