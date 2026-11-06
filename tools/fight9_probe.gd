extends SceneTree
## S371/S372/S377 FIGHT9 probe: red-to-green verification for the FIGHT9 loop.
## Verifies on live drawn bones (PoseTap, after SkeletonModifier3D stack):
##   1. No referee in the ring (stage.referee == null, no Referee node, MoveWords clean).
##   2. Ring-entry top-rope skull clearance (< 1.25 m).
##   3. Moving legs: knees track over toes (<= 18 deg total, <= 5 deg inward valgus) and stay apart (>= 0.14 m).
##   4. S376/S377 leg & boot bars: knees bent (< 170 deg on >= 98% of frames), foot jumps <= 4, drawn knee jerk p95
##      <= 4.5 deg/frame^2 and flips <= 1.5/s, 3D knee hinge bend axis within 25 deg of hip side axis across all
##      BeatClips pools, and zero bare toe/foot skin triangles in boots.
##   5. Snappy punch speed & retraction + crisp head hit-snap + anti-spam defence + clinch PushOff & camera stability.

const Stage := preload("res://scripts/fight3d/FightStage.gd")
const BeatFire := preload("res://scripts/fight3d/BeatFire.gd")
const BeatClips := preload("res://scripts/fight3d/BeatClips.gd")
const FightCast := preload("res://scripts/fight3d/FightCast.gd")
const FightIntro := preload("res://scripts/fight3d/FightIntro.gd")
const RangeBreath := preload("res://scripts/fight3d/RangeBreath.gd")
const MoveWords := preload("res://scripts/rules/MoveWords.gd")
const PoseTap := preload("res://tools/pose_tap.gd")
const Faces := preload("res://scripts/rules/Faces.gd")
const ClinchCheck := preload("res://tools/clinch_check.gd")
const PushOff := preload("res://scripts/fight3d/PushOff.gd")
const KneeTrack := preload("res://scripts/fight3d/KneeTrack.gd")
const FighterKit := preload("res://scripts/fight3d/FighterKit.gd")
const MeshCut := preload("res://scripts/fight3d/MeshCut.gd")

const THROUGH_M := 0.04
const TOUCH_M := 0.06
const SLOW_LO := 0.7
const SLOW_HI := 1.6
const TORSO_R := 0.15
const HEAD_R := 0.11
const HEAD_UP_M := 0.08
const FOREARM_R := 0.045
const HAND_R := 0.05
const GLOVE_FWD_M := 0.08
const BONES := ["Head", "Neck", "UpperChest", "Chest", "Spine", "Hips", "LeftHand", "RightHand",
	"LeftLowerArm", "RightLowerArm", "LeftUpperArm", "RightUpperArm",
	"LeftUpperLeg", "RightUpperLeg", "LeftLowerLeg", "RightLowerLeg", "LeftFoot", "RightFoot", "LeftToes", "RightToes"]

var stage: Node3D
var crew: Node3D
var _view: Node
var _beat: RefCounted
var _taps: Array = []
var failures := 0

class View:
	extends Node
	var stage: Node3D
	var _amb_rng := RandomNumberGenerator.new()
	var _stop := ""
	var _profiles := {"a": {}, "b": {}}
	var _close_left := 0.0
	var t := 0.0
	var body := NoBody.new()
	class NoBody:
		extends RefCounted
		func land(_b: Dictionary, _at: float) -> void:
			pass
	func pace() -> float:
		return Engine.time_scale


func _initialize() -> void:
	call_deferred("_run")


func _run() -> void:
	root.size = Vector2i(1280, 720)
	stage = Stage.new()
	root.add_child(stage)
	var pair := Faces.pair({"name": "Lucy"}, {"name": "Maria", "stance": "orthodox"})
	stage.setup({"glb": Faces.glb(pair[0]), "corner": "red", "scale": 1.0, "stance": "orthodox"},
		{"glb": Faces.glb(pair[1]), "corner": "blue", "scale": 1.0, "stance": "orthodox"})
	crew = FightCast.crew(stage, false)
	_view = View.new()
	_view.stage = stage
	_view._amb_rng.seed = 20261103
	root.add_child(_view)
	_beat = BeatFire.new()
	for i in 2:
		var skel: Skeleton3D = stage.boxers[i]["skel"]
		var tap: SkeletonModifier3D = PoseTap.new()
		tap.setup(skel, BONES)
		skel.add_child(tap)
		_taps.append(tap)
	await process_frame
	await process_frame
	_check_no_referee()
	await _check_ring_entry_rope()
	await _check_moving_legs()
	await _check_s376_bars()
	await _check_s377_hinge_and_boots()
	await _check_punch_and_head_snap()
	await _check_clinch_push_off_and_camera()
	print("FIGHT9 failures=%d" % failures)
	quit(1 if failures > 0 else 0)


func _check_no_referee() -> void:
	var ref_null := stage.get("referee") == null and stage.find_child("Referee", true, false) == null
	_check(ref_null, "no referee node in FightStage (referee == null)")
	var words_ok := not str(MoveWords.WORDS.get("tie_up", "")).to_lower().contains("referee") \
		and not str(MoveWords.WORDS.get("break", "")).to_lower().contains("referee") \
		and not str(MoveWords.WORDS.get("push_off", "")).to_lower().contains("referee")
	_check(words_ok, "MoveWords clinch/break strings have no referee references")


func _check_ring_entry_rope() -> void:
	var fi := FightIntro.new()
	fi.set_process(false)
	root.add_child(fi)
	fi.view = _view
	fi.stage = stage
	fi.crew = crew
	fi.ctx = {"names": ["Lucy", "Maria"], "intros": ["Red", "Blue"]}
	stage.scene_mode(true)
	fi.cue_enter_red()
	var worst_head_y := 0.0
	var samples := 0
	while fi.t < 4.5:
		await process_frame
		var dt := root.get_process_delta_time()
		fi.t += dt
		fi._carry_in()
		var e: Dictionary = fi._entry(0)
		var head_pos := _bone(0, "Head")
		if absf((head_pos - (e["rope"] as Vector3)).dot(e["in"] as Vector3)) < 0.14:
			samples += 1
			worst_head_y = maxf(worst_head_y, head_pos.y)
	fi.set_process(false)
	stage.boxers[0]["ik"].upright(0.0)
	stage.boxers[1]["ik"].upright(0.0)
	stage._ropes.part(0, Vector3.ZERO, 0.0)
	stage.scene_mode(false)
	fi.queue_free()
	await process_frame
	_check(samples > 0 and worst_head_y + 0.11 < 1.25,
		"ring entry ducks cleanly under 1.25 m top rope (head_y=%.3f, samples=%d)" % [worst_head_y, samples])


func _check_moving_legs() -> void:
	_reset_pair()
	await process_frame
	await process_frame
	var worst_abs_track := 0.0
	var worst_inward := 0.0
	var min_knee_sep := 9.9
	var samples := 0
	var bad := 0   # S379: samples past 18 deg, and the phase each worst came from
	var worst_phase := ""
	var phases: Array = [
		{"kind": "step", "dir": 1, "dur": 0.45}, {"kind": "step", "dir": -1, "dur": 0.45},
		{"kind": "circle", "dir": -1, "dur": 0.45}, {"kind": "play", "clip": "pro_left_dodge", "dur": 0.45},
		{"kind": "play", "clip": "pro_right_dodge", "dur": 0.45}, {"kind": "play", "clip": "pro_left_weave", "dur": 0.45},
	]
	for ph in phases:
		var p: Dictionary = ph
		var kind := str(p["kind"])
		if kind == "step":
			stage.step(0, int(p["dir"]))
		elif kind == "circle":
			stage.circle(int(p["dir"]), float(p["dur"]))
		elif kind == "play":
			stage.play(0, str(p["clip"]), BeatClips.speed(str(p["clip"]), ""))
		var elapsed := 0.0
		while elapsed < float(p["dur"]):
			await process_frame
			var dt := root.get_process_delta_time()
			elapsed += dt
			_view.t += dt
			var lk := _bone(0, "LeftLowerLeg")
			var rk := _bone(0, "RightLowerLeg")
			min_knee_sep = minf(min_knee_sep, Vector2(lk.x - rk.x, lk.z - rk.z).length())
			for side in ["Left", "Right"]:
				var other_side := "Right" if side == "Left" else "Left"
				var hip := _bone(0, side + "UpperLeg")
				var knee := _bone(0, side + "LowerLeg")
				var ankle := _bone(0, side + "Foot")
				var toes := _bone(0, side + "Toes")
				var flex := 180.0 - rad_to_deg((hip - knee).angle_to(ankle - knee))
				var span := ankle - hip
				if flex < 12.0 or span.length() < 0.05:
					continue
				var axis := span.normalized()
				var off := (knee - hip) - axis * (knee - hip).dot(axis)
				var foot := Vector3(toes.x - ankle.x, 0.0, toes.z - ankle.z)
				var off_xz := Vector3(off.x, 0.0, off.z)
				# S385: a foot pitched near vertical (toe-off, heel up) has no forward: R7-R13 failed on ONE such frame
				# (foot 1.4 cm across the floor -> 153 deg). Under 5 cm across the floor the frame is not scored.
				if foot.length() < 0.05 or off_xz.length() <= 0.005:
					continue
				var fwd := foot.normalized()
				var side_vec := Vector3.UP.cross(fwd)
				if side_vec.dot(_bone(0, other_side + "UpperLeg") - hip) < 0.0:
					side_vec = -side_vec
				var track := rad_to_deg(atan2(off_xz.dot(side_vec), off_xz.dot(fwd)))
				samples += 1
				if absf(track) > 18.0:
					bad += 1
				if absf(track) > worst_abs_track:
					worst_phase = "%s %s %s" % [kind, str(p.get("clip", p.get("dir", ""))), side]
				worst_abs_track = maxf(worst_abs_track, absf(track))
				worst_inward = maxf(worst_inward, track)
	_check(samples >= 20 and worst_abs_track <= 18.0 and worst_inward <= 5.0,
		"moving legs keep knees over toes during steps/slips/weaves (max_track=%.1f deg at %s, max_inward=%.1f deg, %d of %d samples past 18 deg)" % [
			worst_abs_track, worst_phase, worst_inward, bad, samples])
	_check(min_knee_sep >= 0.14, "moving knees never cave into each other (min_sep=%.3f m)" % min_knee_sep)


func _check_s376_bars() -> void:
	_reset_pair()
	await process_frame
	await process_frame
	var straight := 0
	var frames := 0
	var foot_jumps := 0
	var fast_clips := 0
	var knee_prev := {}
	var knee_vel := {}
	var knee_jerk: Array = []
	var knee_flips := 0
	var prev_lf := _bone(0, "LeftFoot")
	var prev_rf := _bone(0, "RightFoot")
	var jump_cd := [0.0, 0.0]
	var t := 0.0
	var phase_t := 0.0
	var phase_idx := 0
	var phases: Array = [
		{"kind": "wait", "dur": 2.5}, {"kind": "step", "dir": 1, "dur": 0.45},
		{"kind": "wait", "dur": 2.0}, {"kind": "step", "dir": -1, "dur": 0.45},
		{"kind": "circle", "dir": -1, "dur": 0.45}, {"kind": "wait", "dur": 1.5},
		{"kind": "play", "clip": "pro_left_dodge", "dur": 0.45}, {"kind": "play", "clip": "pro_right_weave", "dur": 0.45},
	]
	while t < 40.0:
		await process_frame
		var dt := root.get_process_delta_time()
		t += dt
		_view.t += dt
		phase_t += dt
		if phase_t >= float(phases[phase_idx]["dur"]):
			phase_t = 0.0
			phase_idx = (phase_idx + 1) % phases.size()
			var ph: Dictionary = phases[phase_idx]
			var active := str(ph.get("kind", "wait"))
			if active == "step":
				stage.step(0, int(ph["dir"]))
			elif active == "circle":
				stage.circle(int(ph["dir"]), float(ph["dur"]))
			elif active == "play":
				stage.play(0, str(ph["clip"]), BeatClips.speed(str(ph["clip"]), ""))
		for li in 2:
			var side := "Left" if li == 0 else "Right"
			var ang := rad_to_deg((_bone(0, side + "UpperLeg") - _bone(0, side + "LowerLeg")).angle_to(
				_bone(0, side + "Foot") - _bone(0, side + "LowerLeg")))
			frames += 1
			if ang > 170.0:
				straight += 1
			if knee_prev.has(li):
				var d: float = ang - float(knee_prev[li])
				if knee_vel.has(li):
					var pv: float = knee_vel[li]
					knee_jerk.append(absf(d - pv))
					if absf(d) > 0.4 and absf(pv) > 0.4 and signf(d) != signf(pv):
						knee_flips += 1
				knee_vel[li] = d
			knee_prev[li] = ang
		var inv := (stage.boxers[0]["node"] as Node3D).global_transform.affine_inverse()
		var lf := _bone(0, "LeftFoot")
		var rf := _bone(0, "RightFoot")
		if dt > 1e-5:
			var feet := [lf, rf]
			var prevs := [prev_lf, prev_rf]
			for fi in 2:
				jump_cd[fi] = maxf(float(jump_cd[fi]) - dt, 0.0)
				var v := inv.basis * ((feet[fi] as Vector3) - (prevs[fi] as Vector3)) / dt
				if float(jump_cd[fi]) <= 0.0 and Vector2(v.x, v.z).length() > 3.0 \
						and (feet[fi] as Vector3).distance_to(prevs[fi] as Vector3) > 0.04:
					foot_jumps += 1
					jump_cd[fi] = 0.18
		prev_lf = lf
		prev_rf = rf
		for i in 2:
			var ap: AnimationPlayer = stage.boxers[i]["ap"]
			if ap.is_playing() and ap.speed_scale > 1.6:
				fast_clips += 1
	var straight_share := float(straight) / maxf(float(frames), 1.0)
	_check(frames > 100 and straight_share <= 0.02, "S376 knees locked straight (>170 deg) in <=2%% of frames (share=%.3f, n=%d)" % [straight_share, frames])
	_check(foot_jumps <= 4, "S376 foot jumps (>3 m/s body frame) <=4 (count=%d)" % foot_jumps)
	var fast_share := float(fast_clips) / maxf(float(frames * 2), 1.0)
	_check(fast_share <= 0.02, "S376 AnimationPlayer speed>1.6x in <=2%% of frames (share=%.3f)" % fast_share)
	knee_jerk.sort()
	var jerk_p95 := float(knee_jerk[int((knee_jerk.size() - 1) * 0.95)]) if not knee_jerk.is_empty() else 99.0
	var flip_rate := float(knee_flips) / maxf(t * 2.0, 1.0)
	_check(jerk_p95 <= 4.5 and flip_rate <= 1.5,
		"S377 drawn knee jerk p95 <=4.5 deg/f^2 (%.2f) and flips <=1.5/s (%.2f)" % [jerk_p95, flip_rate])


func _check_s377_hinge_and_boots() -> void:
	var bx: Dictionary = stage.boxers[0]
	var skel: Skeleton3D = bx["skel"]
	var ap: AnimationPlayer = bx["ap"]
	var clips: Dictionary = {}
	for c in BeatClips.GUARD + BeatClips.TIRED:   # S379: DOWN / OUT / WIN play free of FootPlant (lying, falling) - no hinge to hold
		clips[str(c)] = true
	for c in BeatClips.BIG_REACT:   # S379: an Array, not a Dictionary - the cast crashed the probe in R7
		clips[str(c)] = true
	for row in (BeatClips.PUNCH as Dictionary).values():   # [base, suffixes, kind] - the clips are base + suffix
		for suf in row[1]:
			clips[str(row[0]) + str(suf)] = true
	for pool in [BeatClips.REACT, BeatClips.DEFENCE]:
		for arr in (pool as Dictionary).values():
			for c in arr:
				clips[str(c)] = true
	# S385: read the DRAWN legs (PoseTap, after FootPlant/KneeTrack). KneeTrack.bend_axis_err_deg reads
	# get_bone_global_pose from outside the stack = the raw clip (pose_tap.gd: the skeleton restores the raw pose after its
	# modifiers), so R7-R13 were graded on the mocap itself (~30 deg in every guard idle) and no round could move it.
	var worst_hinge := 0.0
	var worst_where := ""
	var scored := 0
	for clip in clips.keys():
		if not ap.has_animation(clip):
			continue
		var length := ap.get_animation(clip).length
		for s in 6:
			var ts := length * float(s) / 5.0
			Stage.IdleMatch.freeze(bx, clip, ts)
			await process_frame
			await process_frame   # the stack (FootPlant low-pass) settles on the frozen pose; PoseTap holds what is drawn
			for side in ["Left", "Right"]:
				var hp := _bone(0, side + "UpperLeg")
				var kn := _bone(0, side + "LowerLeg")
				var an := _bone(0, side + "Foot")
				if 180.0 - rad_to_deg((hp - kn).angle_to(an - kn)) < 15.0:
					continue   # a near-straight leg has no bend plane to measure (the knees-bent bar covers straight legs)
				var bend := (kn - hp).cross(an - hp).normalized()
				var hip_side := (hp - _bone(0, ("Right" if side == "Left" else "Left") + "UpperLeg")).normalized()
				var err := rad_to_deg(acos(clampf(absf(bend.dot(hip_side)), 0.0, 1.0)))
				scored += 1
				if err > worst_hinge:
					worst_hinge = err
					worst_where = "%s@%.2fs(%s)" % [clip, ts, side]
	ap.play(str(BeatClips.GUARD[0]))   # S379: the freezes left him paused - the later head-shot check read -1 s
	_check(scored >= 100 and worst_hinge <= 25.0, "S377 drawn knee bend axis <=25 deg of hip side axis across BeatClips (worst=%.1f deg at %s, %d legs scored)" % [worst_hinge, worst_where, scored])
	var leftover := 0
	for m in (bx["node"] as Node3D).find_children("*", "MeshInstance3D", true, false):
		var mi := m as MeshInstance3D
		if not mi.has_meta("fighter_kit"):
			leftover += MeshCut.cut(mi, skel, FighterKit.CUT_FEET, "MH_Skin", 0.25)
	var boot_l := skel.find_child("FighterKitSkin_LeftFoot_0", false, false) as MeshInstance3D
	var boot_r := skel.find_child("FighterKitSkin_RightFoot_0", false, false) as MeshInstance3D
	_check(leftover == 0 and boot_l != null and boot_r != null, "S377 bare toes/feet cut from skin inside boots (leftover=%d)" % leftover)


func _check_punch_and_head_snap() -> void:
	_check(absf(float(BeatClips.IMPACT_S["jab"]) - 0.365) < 0.02 and float(BeatClips.OTHER_SPEED) <= 1.11 and float(BeatClips.RECOVER_MAX) <= 1.51,
		"Undisputed IMPACT_S pace restored (jab=%.3fs OTHER_SPEED=%.2f RECOVER_MAX=%.1f)" % [
			float(BeatClips.IMPACT_S["jab"]), float(BeatClips.OTHER_SPEED), float(BeatClips.RECOVER_MAX)])
	_reset_pair()
	await process_frame
	await process_frame
	var head0 := _bone(1, "Head")
	stage.hit_gaps.clear()
	_beat.reset()
	_view.t = 1.0
	_beat.fire(_view, {"t": 1.0, "who": "a", "move": "jab", "result": "lands", "caption": ""})
	var max_head_disp := 0.0
	var back_t := -1.0
	var elapsed := 0.0
	while elapsed < 1.05:
		await process_frame
		var dt := root.get_process_delta_time()
		elapsed += dt
		_view.t += dt
		max_head_disp = maxf(max_head_disp, _bone(1, "Head").distance_to(head0))
		if elapsed > 0.35 and back_t < 0.0 and BeatClips.GUARD.has(str((stage.boxers[0]["ap"] as AnimationPlayer).current_animation)):
			back_t = elapsed
	var miss := float(stage.hit_gaps.back()["miss"]) if not stage.hit_gaps.is_empty() else 9.9
	_check(miss <= 0.08, "landed jab glove reaches target face at contact (miss=%.3f m)" % miss)
	_check(max_head_disp >= 0.03, "landed jab snaps defender drawn Head bone (disp=%.3f m)" % max_head_disp)
	_check(back_t > 0.0 and back_t <= 0.95, "jab retracts back to pro_idle guard crisply (%.2f s)" % back_t)
	_reset_pair()
	await process_frame
	_view.t = 3.0
	_beat.fire(_view, {"t": 3.0, "who": "a", "move": "lead_hook", "result": "lands", "big": true, "caption": ""})
	var min_scale := Engine.time_scale
	var def_back_t := -1.0
	elapsed = 0.0
	while elapsed < 1.05:
		await process_frame
		var dt := root.get_process_delta_time()
		elapsed += dt
		_view.t += dt
		min_scale = minf(min_scale, Engine.time_scale)
		if elapsed > 0.35 and def_back_t < 0.0 and BeatClips.GUARD.has(str((stage.boxers[1]["ap"] as AnimationPlayer).current_animation)):
			def_back_t = elapsed
	_check(min_scale >= 0.99 and not stage.camera.close, "big shot stays at 1x speed without slow-mo camera cut (min_scale=%.2f)" % min_scale)
	_check(def_back_t > 0.0 and def_back_t <= 0.95, "big head shot snaps and recovers to guard without slow torso rock (%.2f s)" % def_back_t)
	_beat.fire(_view, {"t": 4.0, "who": "a", "move": "lead_hook", "result": "blocked", "def": "weave", "caption": ""})
	var d1 := str(_beat.last_def[1])
	_view.t = 4.35
	_beat.fire(_view, {"t": 4.35, "who": "a", "move": "rear_hook", "result": "blocked", "def": "weave", "caption": ""})
	var d2 := str(_beat.last_def[1])
	_check(d1 == "weave" and d2 != "weave", "consecutive weave defences de-duplicated (%s -> %s)" % [d1, d2])


func _check_clinch_push_off_and_camera() -> void:
	_reset_pair()
	_beat.reset()
	await process_frame
	await process_frame
	var t := 0.0
	var next := 0
	var engaged := false
	var push_on := false
	var push_t := 0.0
	var hands_hit := [false, false]
	var through_frames := 0
	var gap_end := -1.0
	var breaks: Array = []
	var cam_sign := 0.0
	var cam_flips := 0
	while t < 16.0:
		await process_frame
		var dt := root.get_process_delta_time()
		t += dt
		_view.t = t
		while next < ClinchCheck.BEATS.size() and t >= float(ClinchCheck.BEATS[next]["t"]):
			_beat.fire(_view, ClinchCheck.BEATS[next])
			next += 1
		stage.aim(RangeBreath.phase(ClinchCheck.BEATS, next, t))
		var a_pos: Vector3 = stage.boxers[0]["pos"]
		var b_pos: Vector3 = stage.boxers[1]["pos"]
		var cross_y: float = (stage.camera.global_position - (a_pos + b_pos) * 0.5).cross(b_pos - a_pos).y
		if absf(cross_y) > 0.05:
			var s := signf(cross_y)
			if cam_sign == 0.0:
				cam_sign = s
			elif s != cam_sign:
				cam_flips += 1
				cam_sign = s
		engaged = bool(stage.clinch.engaged)
		if PushOff.active() and not push_on:
			push_on = true
			push_t = 0.0
			hands_hit = [false, false]
			through_frames = 0
			gap_end = -1.0
		if push_on:
			push_t += dt
			for i in 2:
				var other := 1 - i
				var torso := [_bone(other, "Hips"), _bone(other, "UpperChest")]
				for side in ["Left", "Right"]:
					var gv := _glove(i, side)
					var cp := Geometry3D.get_closest_points_between_segments(gv, gv, torso[0], torso[1])
					if cp[0].distance_to(cp[1]) - HAND_R - TORSO_R <= TOUCH_M and push_t <= 0.35:
						hands_hit[i] = true
				for vol in [[torso[0], torso[1], TORSO_R], [_bone(other, "Head") + Vector3.UP * HEAD_UP_M, _bone(other, "Head") + Vector3.UP * HEAD_UP_M, HEAD_R]]:
					for limb in _limbs(i):
						var cp2 := Geometry3D.get_closest_points_between_segments(limb[0], limb[1], vol[0], vol[1])
						if float(limb[2]) + float(vol[2]) - cp2[0].distance_to(cp2[1]) > THROUGH_M and push_t >= 0.06:
							through_frames += 1
			if push_t >= PushOff.PUSH_END and gap_end < 0.0:
				gap_end = a_pos.distance_to(b_pos)
		if push_on and not PushOff.active():
			push_on = false
			var g_now := gap_end if gap_end >= 0.0 else a_pos.distance_to(b_pos)
			breaks.append({"hands": hands_hit[0] and hands_hit[1], "through": through_frames, "dur": push_t, "gap": g_now})
	_check(breaks.size() >= 3, "all %d scripted clinches engaged and broke via PushOff (need >= 3)" % breaks.size())
	for k in breaks.size():
		var br: Dictionary = breaks[k]
		var ok := bool(br["hands"]) and int(br["through"]) == 0 and float(br["dur"]) >= SLOW_LO \
			and float(br["dur"]) <= SLOW_HI and float(br["gap"]) >= float(stage.gap_m) - 0.06
		_check(ok, "clinch break %d: hands=%s through=%d dur=%.2fs gap=%.2fm" % [
			k + 1, str(br["hands"]), int(br["through"]), float(br["dur"]), float(br["gap"])])
	_check(cam_flips == 0, "broadcast camera stays on one side of the 180-degree line (flips=%d)" % cam_flips)


func _reset_pair() -> void:
	PushOff.cancel(stage)
	stage.clinch.holder = -1
	stage.clinch.engaged = false
	stage.boxers[0]["pos"] = Vector3(0, 0, -stage.gap_m * 0.5)
	stage.boxers[1]["pos"] = Vector3(0, 0, stage.gap_m * 0.5)
	for i in 2:
		stage.boxers[i]["move_left"] = 0.0
		stage.stun.clear(i)
		stage.guard(i)
	stage._compose(0.0)
	stage.broadcast(true)


func _bone(i: int, bone: String) -> Vector3:
	var shown: Dictionary = (_taps[i] as SkeletonModifier3D).shown
	if shown.has(bone):
		return (stage.boxers[i]["skel"] as Skeleton3D).global_transform * (shown[bone] as Vector3)
	return (stage.boxers[i]["node"] as Node3D).global_position


func _glove(i: int, side: String) -> Vector3:
	var hand := _bone(i, side + "Hand")
	var arm := hand - _bone(i, side + "LowerArm")
	return hand + (arm.normalized() if arm.length() > 1e-5 else Vector3.UP) * GLOVE_FWD_M


func _limbs(i: int) -> Array:
	var out: Array = []
	for side in ["Left", "Right"]:
		var lo := _bone(i, side + "LowerArm")
		var hand := _bone(i, side + "Hand")
		var gv := _glove(i, side)
		out.append([lo, hand, FOREARM_R])
		out.append([gv, gv, HAND_R])
	return out


func _check(cond: bool, label: String) -> void:
	if cond:
		print("PASS ", label)
	else:
		failures += 1
		print("FAIL ", label)
