extends SceneTree
## HEADAIM2B (S417): a ruler that holds, and joins.
## Both noaim and aim-on measured in ONE process for deterministic comparison.
##   python ops/Tools/godot_slot.py run --who qwen -- <godot.exe> --headless --audio-driver Dummy --path . --script res://tests/head_aim_test.gd

const Stage := preload("res://scripts/fight3d/FightStage.gd")
const BeatClips := preload("res://scripts/fight3d/BeatClips.gd")
const Faces := preload("res://scripts/rules/Faces.gd")
const Stand := preload("res://tests/ruler_stand.gd")   # S436: the bodies stand at the stage's own gap, and the row knows it

const HZ := 30.0
const HEIGHT_BAR := 0.06
const FLAT_MAX := 0.7
const SMOOTH_TOL := 0.30            # IK sensitivity: large height changes cause disproportionate wrist jumps
const DEPTH_TOL := 0.20            # IK geometry: solving for a different height shifts _along, causing X/Z drift
const LATCH_TOL := 0.05             # body movement between reads (stage compose moves boxers)
const BOXER_A := "mh_boxer_10"  # 162 cm
const BOXER_B := "mh_boxer_12"  # 178 cm
const CLIP_MAP := {"jab": "pro_left_jab", "cross": "pro_right_cross", "lead_hook": "pro_left_hook", "rear_hook": "pro_right_hook"}

var failures := 0
var rows_read := 0
var rows_total := 0


func _initialize() -> void:
	Engine.max_fps = 30
	print("HEADAIM2B")
	# Setup 1: A punches B (up)
	var s1 := await _make_stage()
	for clip in ["jab", "cross", "lead_hook", "rear_hook"]:
		await _await_measure_both(s1, 0, 1, clip, "A_B_up")
	s1.queue_free()
	await process_frame
	# Setup 2: B punches A (down)
	var s2 := await _make_stage()
	for clip in ["jab", "cross", "lead_hook", "rear_hook"]:
		await _await_measure_both(s2, 1, 0, clip, "B_A_dn")
	s2.queue_free()
	await process_frame
	# Setup 3: A punches A (level) + latch + joins
	var s3 := await _make_stage_same()
	for clip in ["jab", "cross", "lead_hook", "rear_hook"]:
		await _await_measure_both(s3, 0, 1, clip, "A_A_lv")
	await _await_test_latch(s3)
	await _await_pair(s3, "jab", "cross", "landed_jab_unlanded_cross")
	await _await_pair(s3, "jab", "cross", "unlanded_jab_landed_cross")
	await _await_pair(s3, "jab", "jab", "unlanded_jab_unlanded_jab")
	await _await_pair(s3, "jab", "jab", "landed_jab_unlanded_jab")
	s3.queue_free()
	await process_frame
	print("HEAD_AIM rows read=%d of %d" % [rows_read, rows_total])
	print("HEAD_AIM failures=%d" % failures)
	quit(0 if failures == 0 else 1)


## Fresh stage: A (162cm) vs B (178cm).
func _make_stage() -> Node3D:
	var stg: Node3D = Stage.new()
	root.add_child(stg)
	stg.set_process(false)   # S418: a stage ticking before setup() threw four script errors a setup
	await process_frame
	stg.setup({"glb": "res://assets/models/metahuman/%s.glb" % BOXER_A, "corner": "red"},
		{"glb": "res://assets/models/metahuman/%s.glb" % BOXER_B, "corner": "blue"})
	stg.set_process(true)
	for i in 3:
		await process_frame
	if not await Stand.open(stg, self):
		failures += 1
		print("FAIL STAND: two stands of the same pair disagree, no gap to hold the rows to")
	var ha: float = _body_height(stg.boxers[0]["skel"])
	var hb: float = _body_height(stg.boxers[1]["skel"])
	print("PAIR A=%s(%.3f) B=%s(%.3f) gap=%.3f stand=%.3f" % [BOXER_A, ha, BOXER_B, hb, stg.gap_m, Stand.ref(stg)])
	return stg


## Fresh stage: A vs A (same height, level case).
func _make_stage_same() -> Node3D:
	var stg: Node3D = Stage.new()
	root.add_child(stg)
	stg.set_process(false)   # S418: a stage ticking before setup() threw four script errors a setup
	await process_frame
	stg.setup({"glb": "res://assets/models/metahuman/%s.glb" % BOXER_A, "corner": "red"},
		{"glb": "res://assets/models/metahuman/%s.glb" % BOXER_A, "corner": "blue"})
	stg.set_process(true)
	for i in 3:
		await process_frame
	if not await Stand.open(stg, self):
		failures += 1
		print("FAIL STAND: two stands of the same pair disagree, no gap to hold the rows to")
	var ha: float = _body_height(stg.boxers[0]["skel"])
	var hb: float = _body_height(stg.boxers[1]["skel"])
	print("PAIR A=%s(%.3f) A=%s(%.3f) gap=%.3f stand=%.3f" % [BOXER_A, ha, BOXER_A, hb, stg.gap_m, Stand.ref(stg)])
	return stg


func _body_height(skel: Skeleton3D) -> float:
	var hi: int = skel.find_bone("Head")
	var fi: int = skel.find_bone("LeftFoot")
	if hi < 0 or fi < 0:
		return 0.0
	return (skel.get_bone_global_rest(hi).origin - skel.get_bone_global_rest(fi).origin).length()


## Both back on their marks, held still until the hips gap stops moving (tests/ruler_stand.gd); returns that gap.
func _reset(stage: Node3D) -> float:
	return await Stand.stand(stage, self)


## Measure one punch (noaim or aim-on) at contact. Returns {dy, flat, jump}.
func _measure_one(stage: Node3D, who: int, other: int, clip: String, use_aim: bool) -> Dictionary:
	var bx: Dictionary = stage.boxers[who]
	var ap: AnimationPlayer = bx["ap"]
	var full: String = CLIP_MAP.get(clip, "")
	if full == "" or not ap.has_animation(full):
		return {}
	var contact_s: float = BeatClips.contact(full, 8.0 / 30.0)
	var hand: String = "LeftHand" if full.contains("left") or full.contains("jab") else "RightHand"
	hand = stage.hand_of(who, hand)
	stage.play(who, full, 1.0, 0.0)
	if use_aim:
		stage.aim_height(who, full, 0.0, contact_s)
	var face_y: float = stage.target_point(other, false).y
	var cf: int = int(contact_s * HZ)
	var min_dy: float = 999.0
	var flat_c: float = 0.0
	var max_jump: float = 0.0
	var prev: Vector3 = Vector3.ZERO
	var first: bool = true
	for fr in range(maxi(0, cf - 2), cf + 3):
		var t: float = float(fr) / HZ
		ap.seek(t, true)
		await process_frame
		await process_frame
		var gf: Vector3 = stage.glove_front(who, hand)
		var face: Vector3 = stage.target_point(other, false)
		var dy: float = absf(gf.y - face_y)
		min_dy = minf(min_dy, dy)
		if fr == cf:
			flat_c = Vector2(gf.x - face.x, gf.z - face.z).length()
		if not first:
			max_jump = maxf(max_jump, gf.distance_to(prev))
		prev = gf
		first = false
	return {"dy": min_dy, "flat": flat_c, "jump": max_jump}


## Measure one clip BOTH noaim and aim-on, print results, check bars.
func _await_measure_both(stage: Node3D, who: int, other: int, clip: String, setup: String) -> void:
	rows_total += 1
	# --- noaim pass ---
	var gap_noaim: float = await _reset(stage)
	var noaim: Dictionary = await _measure_one(stage, who, other, clip, false)
	if noaim.is_empty():
		# S435 (ANIM_AUDIT_S435 A10): a clip that could not be measured is a failure, never a silent pass.
		failures += 1
		print("FAIL SKIP %s %s: the clip could not be measured" % [setup, clip])
		return
	# --- aim pass ---
	var gap_aim: float = await _reset(stage)
	var aim: Dictionary = await _measure_one(stage, who, other, clip, true)
	var valid_noaim: bool = Stand.held(stage, gap_noaim) and float(noaim["flat"]) >= 0.0 and float(noaim["flat"]) <= FLAT_MAX
	var valid_aim: bool = Stand.held(stage, gap_aim) and float(aim["flat"]) >= 0.0 and float(aim["flat"]) <= FLAT_MAX
	var valid: bool = valid_noaim and valid_aim
	# HEIGHT bar (aim-on)
	var aim_dy: float = float(aim["dy"])
	var height_ok: bool = aim_dy <= HEIGHT_BAR
	# DEPTH: flat must not change by more than SMOOTH_TOL
	var noaim_flat: float = float(noaim["flat"])
	var aim_flat: float = float(aim["flat"])
	var flat_diff: float = absf(aim_flat - noaim_flat)
	var depth_ok: bool = flat_diff <= DEPTH_TOL
	# SMOOTH: aim jump must not exceed noaim jump + SMOOTH_TOL
	var noaim_jump: float = float(noaim["jump"])
	var aim_jump: float = float(aim["jump"])
	var smooth_ok: bool = aim_jump <= noaim_jump + SMOOTH_TOL
	# Print
	print("AIM %s %s dy=%.3f flat=%.3f noaim_dy=%.3f noaim_flat=%.3f gap=%.3f noaim_gap=%.3f jump=%.3f noaim_jump=%.3f%s%s" % [
		setup, clip, aim_dy, aim_flat, float(noaim["dy"]), noaim_flat, gap_aim, gap_noaim, aim_jump, noaim_jump,
		"" if valid else " VOID", "" if height_ok else " HEIGHT_FAIL"])
	# INSTRUMENT check: noaim A_B_up jab must FAIL the height bar
	if setup == "A_B_up" and clip == "jab":
		var noaim_dy_val: float = float(noaim["dy"])
		if noaim_dy_val <= HEIGHT_BAR:
			failures += 1
			print("FAIL instrument noaim jab dy=%.3f <= %.3f (ruler void)" % [noaim_dy_val, HEIGHT_BAR])
		else:
			print("PASS instrument noaim jab dy=%.3f > %.3f" % [noaim_dy_val, HEIGHT_BAR])
	if not valid:
		failures += 1
		print("FAIL VOID %s %s: stood at %.3f / %.3f, the stage's own gap is %.3f (band %.2f)" % [setup, clip, gap_noaim, gap_aim, Stand.ref(stage), Stand.BAND_M])
		return
	rows_read += 1
	if not height_ok:
		failures += 1
		print("FAIL %s %s height dy=%.3f > %.3f" % [setup, clip, aim_dy, HEIGHT_BAR])
	if not depth_ok:
		failures += 1
		print("FAIL %s %s depth flat_diff=%.3f > %.3f" % [setup, clip, flat_diff, DEPTH_TOL])
	if not smooth_ok:
		failures += 1
		print("FAIL %s %s smooth jump=%.3f > noaim+%.3f=%.3f" % [setup, clip, aim_jump, SMOOTH_TOL, noaim_jump + SMOOTH_TOL])


## Join test: two punches, measure max wrist jump BOTH noaim and aim-on.
func _await_pair(stage: Node3D, p1: String, p2: String, label: String) -> void:
	# --- noaim pass ---
	var gap_n: float = await _reset(stage)
	var noaim_j: float = await _measure_pair(stage, p1, p2, false)
	# --- aim pass ---
	var gap_a: float = await _reset(stage)
	var aim_j: float = await _measure_pair(stage, p1, p2, true)
	print("JOIN %s jump=%.3f noaim_jump=%.3f" % [label, aim_j, noaim_j])
	if aim_j > noaim_j + SMOOTH_TOL:
		failures += 1
		print("FAIL join %s jump=%.3f > noaim+%.3f=%.3f" % [label, aim_j, SMOOTH_TOL, noaim_j + SMOOTH_TOL])


## Play a punch pair and return the max one-frame jump of both wrists.
func _measure_pair(stage: Node3D, p1: String, p2: String, use_aim: bool) -> float:
	var ap: AnimationPlayer = stage.boxers[0]["ap"]
	var c1: String = CLIP_MAP[p1]
	var c2: String = CLIP_MAP[p2]
	if not ap.has_animation(c1) or not ap.has_animation(c2):
		return 0.0
	var cs1: float = BeatClips.contact(c1, 8.0 / 30.0)
	var cs2: float = BeatClips.contact(c2, 8.0 / 30.0)
	var h1: String = "LeftHand" if c1.contains("left") or c1.contains("jab") else "RightHand"
	var h2: String = "LeftHand" if c2.contains("left") or c2.contains("jab") else "RightHand"
	h1 = stage.hand_of(0, h1)
	h2 = stage.hand_of(0, h2)
	stage.play(0, c1, 1.0, 0.0)
	if use_aim:
		stage.aim_height(0, c1, 0.0, cs1)
	var skip: float = cs1 + 0.30
	stage.play(0, c2, 1.0, skip)
	if use_aim:
		stage.aim_height(0, c2, skip, cs2)
	var cf2: int = int((skip + cs2) * HZ)
	var start_f: int = maxi(0, int(cs1 * HZ) - 4)
	var max_j: float = 0.0
	var prev1: Vector3 = Vector3.ZERO
	var prev2: Vector3 = Vector3.ZERO
	var first: bool = true
	for fr in range(start_f, cf2 + 3):
		var t: float = float(fr) / HZ
		ap.seek(t, true)
		await process_frame
		await process_frame
		var g1: Vector3 = stage.glove_front(0, h1)
		var g2: Vector3 = stage.glove_front(0, h2)
		if not first:
			max_j = maxf(max_j, g1.distance_to(prev1))
			max_j = maxf(max_j, g2.distance_to(prev2))
		prev1 = g1
		prev2 = g2
		first = false
	return max_j


## Latch test: aim height should not chase a slipping target.
func _await_test_latch(stage: Node3D) -> void:
	await _reset(stage)
	var face_y: float = stage.target_point(1, false).y
	var ap: AnimationPlayer = stage.boxers[0]["ap"]
	var full: String = CLIP_MAP["jab"]
	var cs: float = BeatClips.contact(full, 8.0 / 30.0)
	var hand: String = stage.hand_of(0, "LeftHand")
	stage.play(0, full, 1.0, 0.0)
	stage.aim_height(0, full, 0.0, cs)
	var cf: int = int(cs * HZ)
	ap.seek(float(cf) / HZ, true)
	await process_frame
	await process_frame
	var gf0: Vector3 = stage.glove_front(0, hand)
	var dy0: float = absf(gf0.y - face_y)
	var slip_ap: AnimationPlayer = stage.boxers[1]["ap"]
	if slip_ap.has_animation("slip"):
		stage.play(1, "slip", 1.0, 0.0)
		slip_ap.seek(0.3, true)
		await process_frame
		await process_frame
		ap.seek(float(cf) / HZ, true)
		await process_frame
		await process_frame
		var gf1: Vector3 = stage.glove_front(0, hand)
		var dy1: float = absf(gf1.y - face_y)
		var delta: float = absf(dy1 - dy0)
		if delta > LATCH_TOL:
			failures += 1
			print("FAIL latch aimed moved %.4f > %.4f" % [delta, LATCH_TOL])
		else:
			print("PASS latch aimed moved %.4f" % delta)
	# INSTRUMENT check: noaim jab must fail the height bar
	# (measured in _await_measure_both for A_B_up jab; here we just report)
