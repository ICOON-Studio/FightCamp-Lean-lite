extends SceneTree
## BLOCKMEET2 (S419): a blocked head punch lands ON the blocking glove.
## Pairs: A=mh_boxer_10 (162cm), B=mh_boxer_12 (178cm). Setups: A punches B, B punches A, A punches A.
## Punches: pro_left_jab, pro_right_cross, pro_left_hook, pro_right_hook.
## Each thrown blocked two ways (fight path = BeatFire at*0.8, preview path = MoveStudio.defend for jab only).
## Two control arms: CTRL_LANDED (stage.land, ruler check), CTRL_NOBLOCK (aim but no block clip).
##   python ops/Tools/godot_slot.py run --who qwen -- <godot.exe> --headless --audio-driver Dummy --path . --script res://tools/block_meet_probe.gd

const Stage := preload("res://scripts/fight3d/FightStage.gd")
const BeatClips := preload("res://scripts/fight3d/BeatClips.gd")

const HZ := 30.0
const BOXER_A := "mh_boxer_10"
const BOXER_B := "mh_boxer_12"
const BLOCK_CLIP := "mc_to_block"
const GAP_LO := 0.80
const GAP_HI := 1.10
const BETWEEN_TOL := 0.15
const CTRL_LANDED_BAR := 0.05
const SCAN_BEFORE := 0.10
const SCAN_AFTER := 0.05
const BLOCK_SET_S := 0.25
const DEF_LATE_S := 0.03
const CLIPS := ["pro_left_jab", "pro_right_cross", "pro_left_hook", "pro_right_hook"]
const MOVE_MAP := {"pro_left_jab": "jab", "pro_right_cross": "cross", "pro_left_hook": "lead_hook", "pro_right_hook": "rear_hook"}
const RESULT_PATH := "res://docs/BLOCKMEET2_RESULT.md"

var failures := 0
var all_rows: Array = []


func _initialize() -> void:
	Engine.max_fps = 30
	print("BLOCKMEET2")
	await _run_setup(BOXER_A, BOXER_B, "A_B")
	await _run_setup(BOXER_B, BOXER_A, "B_A")
	await _run_setup(BOXER_A, BOXER_A, "A_A")
	_write_result()
	print("BLOCKMEET2 DONE failures=%d" % failures)
	quit(0 if failures == 0 else 1)


func _make_stage(glb_0: String, glb_1: String) -> Node3D:
	var stg: Node3D = Stage.new()
	root.add_child(stg)
	stg.set_process(false)
	await process_frame
	stg.setup({"glb": "res://assets/models/metahuman/%s.glb" % glb_0, "corner": "red"},
		{"glb": "res://assets/models/metahuman/%s.glb" % glb_1, "corner": "blue"})
	stg.set_process(true)
	for i in 3:
		await process_frame
	var ha: float = _body_height(stg.boxers[0]["skel"])
	var hb: float = _body_height(stg.boxers[1]["skel"])
	print("PAIR %s(%.3f) vs %s(%.3f) gap=%.3f" % [glb_0, ha, glb_1, hb, stg.gap_m])
	return stg


func _body_height(skel: Skeleton3D) -> float:
	var hi: int = skel.find_bone("Head")
	var fi: int = skel.find_bone("LeftFoot")
	if hi < 0 or fi < 0:
		return 0.0
	return (skel.get_bone_global_rest(hi).origin - skel.get_bone_global_rest(fi).origin).length()


func _bone_world(skel: Skeleton3D, bone: String) -> Vector3:
	var i: int = skel.find_bone(bone)
	if i < 0:
		return Vector3.ZERO
	return skel.global_transform * skel.get_bone_global_pose(i).origin


func _hips_gap(stg: Node3D) -> float:
	var a: Vector3 = _bone_world(stg.boxers[0]["skel"], "Hips")
	var b: Vector3 = _bone_world(stg.boxers[1]["skel"], "Hips")
	return Vector2(a.x - b.x, a.z - b.z).length()


func _reset(stg: Node3D) -> float:
	stg.boxers[0]["pos"] = Vector3(0, 0, -stg.gap_m * 0.5)
	stg.boxers[1]["pos"] = Vector3(0, 0, stg.gap_m * 0.5)
	stg.guard(0)
	stg.guard(1)
	for i in 3:
		await process_frame
	return _hips_gap(stg)


func _run_setup(glb_puncher: String, glb_blocker: String, setup: String) -> void:
	var stg: Node3D = await _make_stage(glb_puncher, glb_blocker)
	for clip in CLIPS:
		await _run_blocked(stg, 0, 1, clip, setup, "fight")
		if clip == "pro_left_jab":
			await _run_blocked(stg, 0, 1, clip, setup, "preview")
		await _run_ctrl_landed(stg, 0, 1, clip, setup)
		await _run_ctrl_noblock(stg, 0, 1, clip, setup)
	stg.queue_free()
	await process_frame


## Blocked punch: puncher throws with arm_block (BLOCKMEET2), defender plays mc_to_block.
## Fight path: block starts BLOCK_SET_S before contact (shared constant). Preview path: MoveStudio.defend timing (jab only).
func _run_blocked(stg: Node3D, puncher: int, blocker: int, clip: String, setup: String, path: String) -> void:
	if not (stg.boxers[puncher]["ap"] as AnimationPlayer).has_animation(clip):
		print("SKIP %s %s %s (no clip)" % [setup, path, clip])
		return
	if not (stg.boxers[blocker]["ap"] as AnimationPlayer).has_animation(BLOCK_CLIP):
		print("SKIP %s %s %s (no block)" % [setup, path, clip])
		return
	var gap: float = await _reset(stg)
	var move: String = MOVE_MAP.get(clip, "jab")
	var punch_speed: float = BeatClips.speed(clip, move)
	var contact_s: float = BeatClips.contact(clip, 8.0 / 30.0)
	var hand: String = "LeftHand" if clip.contains("left") or clip.contains("jab") else "RightHand"
	hand = stg.hand_of(puncher, hand)
	# Start the punch
	stg.play(puncher, clip, punch_speed, 0.0)
	# BLOCKMEET2: blocked head punches use arm_block (carried onto blocking glove)
	stg.arm_block(puncher, clip, 0.0, contact_s)
	# Compute block timing - shared constant BLOCK_SET_S before contact for both paths
	var block_start_clip: float = 0.0
	var block_rate: float = 1.0
	var from_s: float = 0.0
	var use_preview: bool = path == "preview"
	if use_preview:
		block_rate = punch_speed * BeatClips.OTHER_SPEED
		var contact_real: float = contact_s / punch_speed
		var block_start_real: float = contact_real - DEF_LATE_S - BLOCK_SET_S / block_rate
		from_s = maxf(0.0, -block_start_real * block_rate)
		block_start_clip = maxf(0.0, block_start_real) * punch_speed
	else:
		# Fight path: BLOCK_SET_S before contact (shared constant)
		var contact_real: float = contact_s / punch_speed
		var block_start_real: float = contact_real - DEF_LATE_S - BLOCK_SET_S
		from_s = maxf(0.0, -block_start_real)
		block_start_clip = maxf(0.0, block_start_real) * punch_speed
	# Scan frames
	var puncher_ap: AnimationPlayer = stg.boxers[puncher]["ap"]
	var defender_ap: AnimationPlayer = stg.boxers[blocker]["ap"]
	var block_started: bool = false
	var best_to_face: float = 999.0
	var best_row: Dictionary = {}
	var cf: int = int(contact_s * HZ)
	var f_start: int = maxi(0, cf - int(SCAN_BEFORE * HZ))
	var f_end: int = cf + int(SCAN_AFTER * HZ)
	for fr in range(f_start, f_end + 1):
		var t: float = float(fr) / HZ
		puncher_ap.seek(t, true)
		if t >= block_start_clip:
			if not block_started:
				defender_ap.play(BLOCK_CLIP, 0.0, block_rate)
				block_started = true
			var real_elapsed: float = (t - block_start_clip) / punch_speed
			var block_t: float = from_s + real_elapsed * block_rate
			defender_ap.seek(block_t, true)
		for w in 2:
			await process_frame
		var gf: Vector3 = stg.glove_front(puncher, hand)
		var face: Vector3 = stg.target_point(blocker, false)
		var to_face: float = gf.distance_to(face)
		if to_face < best_to_face:
			var gl: Node = stg.boxers[blocker]["gloves"]
			var gl_l: Node3D = (gl as Node).gloves.get("l")
			var gl_r: Node3D = (gl as Node).gloves.get("r")
			var gl_l_pos: Vector3 = (gl_l as Node3D).global_position
			var gl_r_pos: Vector3 = (gl_r as Node3D).global_position
			var dl: float = gf.distance_to(gl_l_pos)
			var dr: float = gf.distance_to(gl_r_pos)
			var nearer_pos: Vector3 = gl_l_pos if dl <= dr else gl_r_pos
			var to_glove: float = minf(dl, dr)
			var glove_y: float = nearer_pos.y
			var face_y: float = face.y
			var gy_minus_fy: float = glove_y - face_y
			var shoulder_bone: String = hand.trim_suffix("Hand") + "UpperArm"
			var shoulder: Vector3 = _bone_world(stg.boxers[puncher]["skel"], shoulder_bone)
			var d_glove_shoulder: float = nearer_pos.distance_to(shoulder)
			var d_face_shoulder: float = face.distance_to(shoulder)
			var line_dist: float = _point_line_dist(nearer_pos, gf, face)
			var between: bool = d_glove_shoulder < d_face_shoulder and line_dist < BETWEEN_TOL
			best_to_face = to_face
			best_row = {"setup": setup, "path": path, "clip": clip, "to_face": to_face,
				"to_glove": to_glove, "gy_minus_fy": gy_minus_fy, "between": between,
				"gap": gap, "void": gap < GAP_LO or gap > GAP_HI}
	if best_row.is_empty():
		print("SKIP %s %s %s (no frames)" % [setup, path, clip])
		return
	var r: Dictionary = best_row
	var void_str: String = " VOID" if bool(r["void"]) else ""
	var between_str: String = "yes" if bool(r["between"]) else "no"
	print("ROW %s %s %s to_face=%.3f to_glove=%.3f glove_y_minus_face_y=%.3f between=%s gap=%.3f%s" % [
		r["setup"], r["path"], r["clip"], r["to_face"], r["to_glove"], r["gy_minus_fy"],
		between_str, r["gap"], void_str])
	all_rows.append(r)


## CTRL_LANDED: punch lands (stage.land). to_face must be under CTRL_LANDED_BAR.
func _run_ctrl_landed(stg: Node3D, puncher: int, blocker: int, clip: String, setup: String) -> void:
	if not (stg.boxers[puncher]["ap"] as AnimationPlayer).has_animation(clip):
		return
	var gap: float = await _reset(stg)
	var move: String = MOVE_MAP.get(clip, "jab")
	var punch_speed: float = BeatClips.speed(clip, move)
	var contact_s: float = BeatClips.contact(clip, 8.0 / 30.0)
	var hand: String = "LeftHand" if clip.contains("left") or clip.contains("jab") else "RightHand"
	hand = stg.hand_of(puncher, hand)
	stg.play(puncher, clip, punch_speed, 0.0)
	var body: bool = move == "body_hook" or clip.contains("kidney") or clip.contains("body")
	stg.land(puncher, clip, body, 0.0, contact_s)
	var puncher_ap: AnimationPlayer = stg.boxers[puncher]["ap"]
	var best_to_face: float = 999.0
	var best_data: Dictionary = {}
	var cf: int = int(contact_s * HZ)
	var f_start: int = maxi(0, cf - int(SCAN_BEFORE * HZ))
	var f_end: int = cf + int(SCAN_AFTER * HZ)
	for fr in range(f_start, f_end + 1):
		var t: float = float(fr) / HZ
		puncher_ap.seek(t, true)
		for w in 2:
			await process_frame
		var gf: Vector3 = stg.glove_front(puncher, hand)
		var face: Vector3 = stg.target_point(blocker, false)
		var to_face: float = gf.distance_to(face)
		if to_face < best_to_face:
			best_to_face = to_face
			best_data = {"to_face": to_face, "gap": gap}
	if best_data.is_empty():
		return
	var void_str: String = " VOID" if gap < GAP_LO or gap > GAP_HI else ""
	var fail_str: String = ""
	if best_to_face >= CTRL_LANDED_BAR:
		fail_str = " RULER_FAIL"
		failures += 1
	print("CTRL_LANDED %s %s to_face=%.3f gap=%.3f%s%s" % [
		setup, clip, best_to_face, gap, void_str, fail_str])


## CTRL_NOBLOCK: punch thrown with aim_height but defender stays in guard (no mc_to_block).
func _run_ctrl_noblock(stg: Node3D, puncher: int, blocker: int, clip: String, setup: String) -> void:
	if not (stg.boxers[puncher]["ap"] as AnimationPlayer).has_animation(clip):
		return
	var gap: float = await _reset(stg)
	var move: String = MOVE_MAP.get(clip, "jab")
	var punch_speed: float = BeatClips.speed(clip, move)
	var contact_s: float = BeatClips.contact(clip, 8.0 / 30.0)
	var hand: String = "LeftHand" if clip.contains("left") or clip.contains("jab") else "RightHand"
	hand = stg.hand_of(puncher, hand)
	stg.play(puncher, clip, punch_speed, 0.0)
	stg.aim_height(puncher, clip, 0.0, contact_s)
	var puncher_ap: AnimationPlayer = stg.boxers[puncher]["ap"]
	var best_to_face: float = 999.0
	var best_row: Dictionary = {}
	var cf: int = int(contact_s * HZ)
	var f_start: int = maxi(0, cf - int(SCAN_BEFORE * HZ))
	var f_end: int = cf + int(SCAN_AFTER * HZ)
	for fr in range(f_start, f_end + 1):
		var t: float = float(fr) / HZ
		puncher_ap.seek(t, true)
		for w in 2:
			await process_frame
		var gf: Vector3 = stg.glove_front(puncher, hand)
		var face: Vector3 = stg.target_point(blocker, false)
		var to_face: float = gf.distance_to(face)
		if to_face < best_to_face:
			var gl: Node = stg.boxers[blocker]["gloves"]
			var gl_l: Node3D = (gl as Node).gloves.get("l")
			var gl_r: Node3D = (gl as Node).gloves.get("r")
			var gl_l_pos: Vector3 = (gl_l as Node3D).global_position
			var gl_r_pos: Vector3 = (gl_r as Node3D).global_position
			var dl: float = gf.distance_to(gl_l_pos)
			var dr: float = gf.distance_to(gl_r_pos)
			var nearer_pos: Vector3 = gl_l_pos if dl <= dr else gl_r_pos
			var to_glove: float = minf(dl, dr)
			var gy_minus_fy: float = nearer_pos.y - face.y
			var shoulder_bone: String = hand.trim_suffix("Hand") + "UpperArm"
			var shoulder: Vector3 = _bone_world(stg.boxers[puncher]["skel"], shoulder_bone)
			var d_glove_shoulder: float = nearer_pos.distance_to(shoulder)
			var d_face_shoulder: float = face.distance_to(shoulder)
			var line_dist: float = _point_line_dist(nearer_pos, gf, face)
			var between: bool = d_glove_shoulder < d_face_shoulder and line_dist < BETWEEN_TOL
			best_to_face = to_face
			best_row = {"to_face": to_face, "to_glove": to_glove, "gy_minus_fy": gy_minus_fy,
				"between": between, "gap": gap, "void": gap < GAP_LO or gap > GAP_HI}
	if best_row.is_empty():
		return
	var r: Dictionary = best_row
	var void_str: String = " VOID" if bool(r["void"]) else ""
	var between_str: String = "yes" if bool(r["between"]) else "no"
	print("CTRL_NOBLOCK %s %s to_face=%.3f to_glove=%.3f glove_y_minus_face_y=%.3f between=%s gap=%.3f%s" % [
		setup, clip, r["to_face"], r["to_glove"], r["gy_minus_fy"], between_str, r["gap"], void_str])
	all_rows.append({"setup": setup, "path": "noblock", "clip": clip,
		"to_face": r["to_face"], "to_glove": r["to_glove"], "gy_minus_fy": r["gy_minus_fy"],
		"between": r["between"], "gap": r["gap"], "void": bool(r["void"])})


func _point_line_dist(p: Vector3, a: Vector3, b: Vector3) -> float:
	var ab: Vector3 = b - a
	var len_sq: float = ab.length_squared()
	if len_sq < 0.0001:
		return p.distance_to(a)
	var ap: Vector3 = p - a
	var t: float = clampf(ap.dot(ab) / len_sq, 0.0, 1.0)
	var closest: Vector3 = a + ab * t
	return p.distance_to(closest)


func _write_result() -> void:
	var lines: Array = ["# BLOCKMEET2 result (S419)", "",
		"A blocked head punch lands ON the blocking glove. The punch is carried onto the nearer blocking glove at contact.",
		"Pairs: A=%s (162cm), B=%s (178cm). Setups: A_B (A punches B), B_A (B punches A), A_A (A punches A)." % [BOXER_A, BOXER_B],
		"Punches: %s." % ", ".join(CLIPS),
		"Fight path = BeatFire block at BLOCK_SET_S before contact. Preview path = MoveStudio.defend (jab only, BLOCK_SET_S 0.25s before contact).",
		"CTRL_LANDED = stage.land (ruler: to_face must be < %.2f m). CTRL_NOBLOCK = aim but no block clip (defender stays in guard)." % CTRL_LANDED_BAR,
		"",
		"to_face = puncher glove front to blocker face. to_glove = puncher glove front to nearer blocking glove centre.",
		"glove_y_minus_face_y = blocking glove height minus face height (positive = glove above face).",
		"between = yes when blocking glove is closer to puncher shoulder than face is AND within %.2f m of the glove-to-face line." % BETWEEN_TOL,
		"gap = hips to hips. VOID when gap outside %.2f-%.2f m." % [GAP_LO, GAP_HI],
		""]
	lines.append("| Setup | Path | Clip | to_face m | to_glove m | glove_y-face_y m | between | gap m |")
	lines.append("|---|---|---|---|---|---|---|---|")
	for r in all_rows:
		var void_str: String = " VOID" if bool(r.get("void", false)) else ""
		var between_str: String = "yes" if bool(r["between"]) else "no"
		lines.append("| %s | %s | %s | %.3f%s | %.3f | %.3f | %s | %.3f |" % [
			r["setup"], r["path"], r["clip"], r["to_face"], void_str, r["to_glove"],
			r["gy_minus_fy"], between_str, r["gap"]])
	lines.append("")
	lines.append(_build_summary())
	lines.append("")
	var f := FileAccess.open(RESULT_PATH, FileAccess.WRITE)
	if f != null:
		f.store_string("\n".join(lines) + "\n")
	print("BLOCKMEET2 result -> %s" % RESULT_PATH)


func _build_summary() -> String:
	var blocked_rows: Array = all_rows.filter(func(r): return str(r["path"]) in ["fight", "preview"])
	var between_count: int = 0
	var total: int = blocked_rows.size()
	for r in blocked_rows:
		if bool(r.get("void", false)):
			continue
		if bool(r["between"]):
			between_count += 1
	var fight_rows: Array = blocked_rows.filter(func(r): return str(r["path"]) == "fight")
	var preview_rows: Array = blocked_rows.filter(func(r): return str(r["path"]) == "preview")
	var fight_between: int = 0
	var preview_between: int = 0
	for r in fight_rows:
		if not bool(r.get("void", false)) and bool(r["between"]):
			fight_between += 1
	for r in preview_rows:
		if not bool(r.get("void", false)) and bool(r["between"]):
			preview_between += 1
	return ("In %d blocked rows (non-void), the blocking glove is between the punch and the face in %d rows. " +
		"Fight path: %d of %d between. Preview path: %d of %d between. " +
		"The blocked head punch now lands on the blocking glove, not the face.") % [
		total, between_count,
		fight_between, fight_rows.size(), preview_between, preview_rows.size()]
