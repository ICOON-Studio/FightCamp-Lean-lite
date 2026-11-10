extends SceneTree
## BLOCKMEET2: a blocked head punch lands ON the blocking glove.
## Pairs: A=mh_boxer_10 (162cm), B=mh_boxer_12 (178cm). Setups: A_B, B_A, A_A.
## Punches: pro_left_jab, pro_right_cross, pro_left_hook, pro_right_hook.
## Fight path for all four, preview path for jab only.
## Bars (at the frame where puncher's glove front is nearest blocking glove):
##   touch: glove-to-glove surface distance <= 0.04 m, not > 0.03 m inside
##   between: blocking glove is between punch and face (BLOCKMEET1 definition)
##   to_face >= 0.08 m (punch does not reach the face; a landed one reads <= 0.021)
##   wrist: the blocking elbow-to-wrist distance changes <= 0.01 m (S420: the lift may not tear the hand off the arm)
##   glove_y_minus_face_y: -0.08 to +0.06 m (block at face height)
##   gap: 0.80-1.10 m, else VOID
##   CTRL_LANDED < 0.05 m (landed punch ruler still holds)
##   python ops/Tools/godot_slot.py run --who qwen -- <godot.exe> --headless --audio-driver Dummy --path . --script res://tests/block_meet_test.gd

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
const TOUCH_LO := 0.0  # not more than 0.03 m inside (negative = inside)
const TOUCH_HI := 0.04
const FACE_DIST_BAR := 0.08  # S420: a glove held in front of the face shields from ~0.09 m (its thickness); a landed punch reads <= 0.021
const GLOVE_Y_LO := -0.08
const GLOVE_Y_HI := 0.06
const WRIST_BAR := 0.01  # S420: the blocking forearm-to-hand distance may not change (a lift that moved the hand alone tore the wrist)
const GLOVE_RADIUS := 0.04  # blocking glove surface offset
const CLIPS := ["pro_left_jab", "pro_right_cross", "pro_left_hook", "pro_right_hook"]
const MOVE_MAP := {"pro_left_jab": "jab", "pro_right_cross": "cross", "pro_left_hook": "lead_hook", "pro_right_hook": "rear_hook"}

var failures := 0


func _initialize() -> void:
	Engine.max_fps = 30
	print("BLOCK_MEET")
	await _run_setup(BOXER_A, BOXER_B, "A_B")
	await _run_setup(BOXER_B, BOXER_A, "B_A")
	await _run_setup(BOXER_A, BOXER_A, "A_A")
	print("BLOCK_MEET failures=%d" % failures)
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
	return stg


func _bone_world(skel: Skeleton3D, bone: String) -> Vector3:
	var i: int = skel.find_bone(bone)
	if i < 0:
		return Vector3.ZERO
	return skel.global_transform * skel.get_bone_global_pose(i).origin


func _hips_gap(stg: Node3D) -> float:
	var a: Vector3 = _bone_world(stg.boxers[0]["skel"], "Hips")
	var b: Vector3 = _bone_world(stg.boxers[1]["skel"], "Hips")
	return Vector2(a.x - b.x, a.z - b.z).length()


const STAND_S := 30.0
func _reset(stg: Node3D) -> float:
	stg.boxers[0]["pos"] = Vector3(0, 0, -stg.gap_m * 0.5)
	stg.boxers[1]["pos"] = Vector3(0, 0, stg.gap_m * 0.5)
	stg.guard(0)
	stg.guard(1)
	stg.feet._pause = [STAND_S, STAND_S]   # S426: no rhythm step or fidget starts mid-read (the rows' gap ran 0.84-1.05 run to run)
	stg.life._quiet = [STAND_S, STAND_S]
	for i in 3:
		await process_frame
	return _hips_gap(stg)


func _run_setup(glb_puncher: String, glb_blocker: String, setup: String) -> void:
	var stg: Node3D = await _make_stage(glb_puncher, glb_blocker)
	_wrists(stg.boxers[1]["skel"])   # S420: the wrist ruler's attachments, made once before any timeline
	for clip in CLIPS:
		await _run_blocked(stg, 0, 1, clip, setup, "fight")
		if clip == "pro_left_jab":
			await _run_blocked(stg, 0, 1, clip, setup, "preview")
		await _run_ctrl_landed(stg, 0, 1, clip, setup)
	stg.queue_free()
	await process_frame


## Blocked punch: puncher throws with arm_block (blocked head punch goes to glove), defender plays mc_to_block.
## Fight path: block starts BLOCK_SET_S before contact (shared constant).
## Preview path: MoveStudio.defend timing (jab only).
func _run_blocked(stg: Node3D, puncher: int, blocker: int, clip: String, setup: String, path: String) -> void:
	if not (stg.boxers[puncher]["ap"] as AnimationPlayer).has_animation(clip):
		return
	if not (stg.boxers[blocker]["ap"] as AnimationPlayer).has_animation(BLOCK_CLIP):
		return
	var gap: float = await _reset(stg)
	# VOID check
	if gap < GAP_LO or gap > GAP_HI:
		print("VOID %s %s %s gap=%.3f" % [setup, path, clip, gap])
		return
	var move: String = MOVE_MAP.get(clip, "jab")
	var punch_speed: float = BeatClips.speed(clip, move)
	var contact_s: float = BeatClips.contact(clip, 8.0 / 30.0)
	var hand: String = "LeftHand" if clip.contains("left") or clip.contains("jab") else "RightHand"
	hand = stg.hand_of(puncher, hand)
	# Start the punch
	stg.play(puncher, clip, punch_speed, 0.0)
	# BLOCKMEET2: blocked head punches use arm_block (carried onto blocking glove), not aim_height
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
	var best_to_glove: float = 999.0
	var best_row: Dictionary = {}
	var wrist_ref: Array = _wrists(stg.boxers[blocker]["skel"])   # S420: elbow-to-wrist in the guard after the reset, before any block
	var wrist_worst: float = 0.0
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
		var wn: Array = _wrists(stg.boxers[blocker]["skel"])
		if block_started:
			for k in 2:
				wrist_worst = maxf(wrist_worst, absf(float(wn[k]) - float(wrist_ref[k])))
		var face: Vector3 = stg.target_point(blocker, false)
		# Get blocking glove positions
		var gl: Node = stg.boxers[blocker]["gloves"]
		var gl_l: Node3D = (gl as Node).gloves.get("l")
		var gl_r: Node3D = (gl as Node).gloves.get("r")
		var gl_l_pos: Vector3 = (gl_l as Node3D).global_position
		var gl_r_pos: Vector3 = (gl_r as Node3D).global_position
		var dl: float = gf.distance_to(gl_l_pos)
		var dr: float = gf.distance_to(gl_r_pos)
		var nearer_pos: Vector3 = gl_l_pos if dl <= dr else gl_r_pos
		var to_glove: float = minf(dl, dr)
		# Find best frame: nearest to blocking glove
		if to_glove < best_to_glove:
			var to_face: float = gf.distance_to(face)
			var glove_y: float = nearer_pos.y
			var face_y: float = face.y
			var gy_minus_fy: float = glove_y - face_y
			var shoulder_bone: String = hand.trim_suffix("Hand") + "UpperArm"
			var shoulder: Vector3 = _bone_world(stg.boxers[puncher]["skel"], shoulder_bone)
			var d_glove_shoulder: float = nearer_pos.distance_to(shoulder)
			var d_face_shoulder: float = face.distance_to(shoulder)
			var line_dist: float = _point_line_dist(nearer_pos, gf, face)
			var between: bool = d_glove_shoulder < d_face_shoulder and line_dist < BETWEEN_TOL
			# Touch: surface distance (center distance minus glove radius)
			var touch: float = to_glove - GLOVE_RADIUS
			best_to_glove = to_glove
			best_row = {"setup": setup, "path": path, "clip": clip, "to_face": to_face,
				"to_glove": to_glove, "touch": touch, "gy_minus_fy": gy_minus_fy,
				"between": between, "gap": gap}
	if best_row.is_empty():
		return
	var r: Dictionary = best_row
	var touch_val: float = float(r["touch"])
	var between_ok: bool = bool(r["between"])
	var to_face_val: float = float(r["to_face"])
	var face_ok: bool = to_face_val >= FACE_DIST_BAR
	var gy_val: float = float(r["gy_minus_fy"])
	var gy_ok: bool = gy_val >= GLOVE_Y_LO and gy_val <= GLOVE_Y_HI
	var touch_ok: bool = touch_val >= TOUCH_LO - 0.03 and touch_val <= TOUCH_HI
	var wrist_ok: bool = wrist_worst <= WRIST_BAR
	var row_ok: bool = between_ok and face_ok and gy_ok and touch_ok and wrist_ok
	var fail_str: String = ""
	if not between_ok:
		fail_str += " BETWEEN_FAIL"
	if not face_ok:
		fail_str += " FACE_FAIL(%.3f<%.2f)" % [to_face_val, FACE_DIST_BAR]
	if not gy_ok:
		fail_str += " GY_FAIL(%.3f)" % gy_val
	if not touch_ok:
		fail_str += " TOUCH_FAIL(%.3f)" % touch_val
	if not wrist_ok:
		fail_str += " WRIST_FAIL(%.3f)" % wrist_worst
	if not row_ok:
		failures += 1
	print("ROW %s %s %s touch=%.3f between=%s to_face=%.3f gy=%.3f wrist=%.3f gap=%.3f%s" % [
		r["setup"], r["path"], r["clip"], touch_val, "yes" if between_ok else "no",
		to_face_val, gy_val, wrist_worst, r["gap"], fail_str])


## CTRL_LANDED: punch lands (stage.land). to_face must be under CTRL_LANDED_BAR.
func _run_ctrl_landed(stg: Node3D, puncher: int, blocker: int, clip: String, setup: String) -> void:
	if not (stg.boxers[puncher]["ap"] as AnimationPlayer).has_animation(clip):
		return
	var gap: float = await _reset(stg)
	if gap < GAP_LO or gap > GAP_HI:
		return
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
	var fail_str: String = ""
	if best_to_face >= CTRL_LANDED_BAR:
		fail_str = " RULER_FAIL"
		failures += 1
	print("CTRL_LANDED %s %s to_face=%.3f gap=%.3f%s" % [setup, clip, best_to_face, gap, fail_str])


## S420: blocker's elbow-to-wrist world distance, left then right, read through BoneAttachment3D nodes (they follow
## the pose AFTER the skeleton modifiers; get_bone_global_pose here reads it before them and cannot see the lift).
func _wrists(skel: Skeleton3D) -> Array:
	var out: Array = []
	for side in ["Left", "Right"]:
		var e := _attach(skel, side + "LowerArm")
		var h := _attach(skel, side + "Hand")
		out.append(e.global_position.distance_to(h.global_position))
	return out


func _attach(skel: Skeleton3D, bone: String) -> BoneAttachment3D:
	var nm := "s420_" + bone
	var n := skel.get_node_or_null(nm)
	if n == null:
		n = BoneAttachment3D.new()
		n.name = nm
		n.bone_name = bone
		skel.add_child(n)
	return n


func _point_line_dist(p: Vector3, a: Vector3, b: Vector3) -> float:
	var ab: Vector3 = b - a
	var len_sq: float = ab.length_squared()
	if len_sq < 0.0001:
		return p.distance_to(a)
	var ap: Vector3 = p - a
	var t: float = clampf(ap.dot(ab) / len_sq, 0.0, 1.0)
	var closest: Vector3 = a + ab * t
	return p.distance_to(closest)
