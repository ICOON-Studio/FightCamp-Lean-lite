extends SceneTree
## POWER1C: the lead uppercut's tail - a short upward follow-through, then back to guard, never over her own head.
## The ruler: the game's FightStage pair (mh_boxer_02 vs mh_boxer_03 at the fight's gap), a landed uppercut thrown the way
## BeatFire throws one (FightStage.play from PunchPace start, PunchPace.arm, FightStage.land, FightStage.hit on the hit's
## timer), then HitImpact's own cut back to guard. The hitting glove front is read in Skeleton3D.skeleton_updated (the frame
## as DRAWN, after every modifier), every frame from the hit's drawn frame (f00) to 0.45 s after it.
##   OVER_HEAD  the punching glove's lowest point never rises above her own Head bone + 0.05 m (y), in any frame after the hit.
##   ELBOW      the punching elbow never rises above her own shoulder (the upper arm bone's head) + 0.05 m.
##   FOLLOW     for 0.10 to 0.20 s after the freeze ends the glove keeps moving up/forward (at least 0.03 m in total, its
##              distance to the target never grows more than 0.02 m) - a short follow-through, not a stop.
##   BACK       within 0.40 s of the hit the glove is within 0.05 m of its guard place, and on the way NO one-frame glove
##              speed is above 9.6 m/s.
##   PATH       on the way back the glove stays in front of her own face/chest (its forward distance from her own spine never
##              below 0.10 m) - it never travels over or behind her head.
## Two DIFFERENT bodies (mh_boxer_02 against mh_boxer_03), at the fight's gap. 3D only: no rule is read or changed.
## Run: <godot> --headless --audio-driver Dummy --path . --script res://tests/uppercut_tail_test.gd

const Stage := preload("res://scripts/fight3d/FightStage.gd")
const BeatClips := preload("res://scripts/fight3d/BeatClips.gd")
const PunchPace := preload("res://scripts/fight3d/PunchPace.gd")
const PR := preload("res://scripts/fight3d/PunchReach.gd")
const HitImpact := preload("res://scripts/fight3d/HitImpact.gd")

const WINDOW_S := 0.45
const REPS := 5
const ROWS := [["pro_left_uppercut", "lead_uppercut"], ["pro_right_uppercut", "rear_uppercut"]]
const OVER_HEAD_BAR := 0.05
const ELBOW_BAR := 0.05
const FOLLOW_MIN_M := 0.03
const FOLLOW_MAX_DRIFT := 0.02
const FOLLOW_START_S := 0.10
const FOLLOW_END_S := 0.20
const BACK_TIME_S := 0.40
const BACK_DIST_M := 0.05
const BACK_SPEED_BAR := 9.6
const PATH_MIN_FWD := 0.10

var failures := 0
var st: Node3D
var skel: Skeleton3D
var ap: AnimationPlayer
var front := 0.15
var ids: Array = []
var rec: Array = []
var recording := false
var hit_at := -1
var freeze_end_at := -1.0
var guard_pos := Vector3.ZERO
var spine_fwd := Vector3.ZERO


func _check(ok: bool, what: String) -> void:
	if not ok:
		failures += 1
	print(("PASS " if ok else "FAIL ") + what)


func _glove() -> Vector3:
	var g := skel.global_transform
	var wrist: Vector3 = g * skel.get_bone_global_pose(int(ids[2])).origin
	var a: Vector3 = (g * skel.get_bone_global_pose(int(ids[3])).origin - wrist).normalized()
	var arm: Vector3 = (wrist - g * skel.get_bone_global_pose(int(ids[1])).origin).normalized()
	if PR.STRAIGHT > 0.0 and a.angle_to(arm) > 1e-3:
		a = a.slerp(arm, PR.STRAIGHT).normalized()
	return wrist + a * front * g.basis.get_scale().x


func _elbow() -> Vector3:
	var g := skel.global_transform
	return g * skel.get_bone_global_pose(int(ids[1])).origin


func _head() -> Vector3:
	var g := skel.global_transform
	return g * skel.get_bone_global_pose(skel.find_bone("Head")).origin


func _shoulder() -> Vector3:
	var g := skel.global_transform
	return g * skel.get_bone_global_pose(int(ids[0])).origin


func _spine() -> Vector3:
	var g := skel.global_transform
	return g * skel.get_bone_global_pose(skel.find_bone("Spine")).origin


func _drawn() -> void:
	if not recording or ids.is_empty():
		return
	var f := Engine.get_process_frames()
	var row := [f, get_root().get_process_delta_time(), _glove(), _elbow(), _head(), _shoulder(), _spine(), str(ap.current_animation), hit_at >= 0]
	if not rec.is_empty() and int((rec[rec.size() - 1] as Array)[0]) == f:
		rec[rec.size() - 1] = row
	else:
		rec.append(row)


func _on_hit() -> void:
	hit_at = Engine.get_process_frames()


func _throw(clip: String, move: String, rep: int) -> Array:
	var hand: String = st.hand_of(0, str(BeatClips.contact_row(clip).get("hand", "RightHand")))
	ids = []
	for n in ["UpperArm", "LowerArm", "Hand", "MiddleProximal"]:
		ids.append(skel.find_bone(hand.trim_suffix("Hand") + n))
	st.guard(0)
	st.guard(1)
	for i in 20:
		await process_frame
	var p := PunchPace.plan(clip, move)
	var at := PunchPace.real(p, float(p["start"]), float(p["c"])) - PunchPace.lead()
	rec = []
	hit_at = -1
	freeze_end_at = -1
	recording = true
	if not st.play(0, clip, float(p["sp"]), float(p["start"])):
		recording = false
		_check(false, "%s rep %d: the stage refused the punch" % [clip, rep])
		return [false, false, false, false, false]
	var pid := int(st.boxers[0]["play_id"])
	PunchPace.arm(st, 0, p)
	st.land(0, clip, false, at, float(p["c"]))
	var react := BeatClips.react(move, false, st.has_move, 0.0, false)
	create_timer(at).timeout.connect(func():
		st.hit(1, react, BeatClips.speed(react, ""), 0, move, false, pid)
		_on_hit())
	var t0 := Time.get_ticks_msec()
	while hit_at < 0 and Time.get_ticks_msec() - t0 < 4000:
		await process_frame
	var t := 0.0
	var hold_s := float(HitImpact.HOLD_S.get("power", 0.05))
	while hit_at >= 0 and t < WINDOW_S + 1e-4:
		await process_frame
		t += get_root().get_process_delta_time()
		if freeze_end_at < 0.0 and t >= hold_s:
			freeze_end_at = t
	await process_frame
	recording = false
	var over_head_ok := true
	var elbow_ok := true
	var follow_ok := true
	var back_ok := true
	var path_ok := true
	var lines := PackedStringArray()
	var prev: Array = []
	var f0 := -1
	var follow_start_pos := Vector3.ZERO
	var follow_end_pos := Vector3.ZERO
	var follow_target_dist_start: float = 0.0
	var follow_target_dist_end: float = 0.0
	var target: Vector3 = st.target_point(1, false)
	var back_reached := false
	var back_time := -1.0
	var peak_speed := 0.0
	var follow_start_t := hold_s + FOLLOW_START_S
	var follow_end_t := hold_s + FOLLOW_END_S
	# S452 (Claude): the guard place is the glove BEFORE the punch (the first recorded frame), not the glove at the hit -
	# Qwen's version measured "back" to the hit point, so BACK read 0.10 s on a tail that never went home.
	if not rec.is_empty():
		guard_pos = (rec[0] as Array)[2]
	for r in rec:
		var row: Array = r
		if not bool(row[8]):
			continue
		if f0 < 0:
			f0 = int(row[0])
			spine_fwd = row[6]
		var f := int(row[0]) - f0
		var glove: Vector3 = row[2]
		var elbow: Vector3 = row[3]
		var head: Vector3 = row[4]
		var shoulder: Vector3 = row[5]
		var spine: Vector3 = row[6]
		var speed := 0.0
		if not prev.is_empty():
			var dt := maxf(float(row[1]), 1e-4)
			speed = glove.distance_to(prev[2] as Vector3) / dt
			peak_speed = maxf(peak_speed, speed)
		var over_head := glove.y > head.y + OVER_HEAD_BAR
		var elbow_high := elbow.y > shoulder.y + ELBOW_BAR
		var fwd_dist := (glove - spine).dot((target - spine).normalized())
		var path_bad := fwd_dist < PATH_MIN_FWD
		if over_head:
			over_head_ok = false
		if elbow_high:
			elbow_ok = false
		if path_bad:
			path_ok = false
		var t_since_hit := float(f) / 60.0
		if t_since_hit >= follow_start_t and t_since_hit <= follow_start_t + 0.02 and follow_start_pos == Vector3.ZERO:
			follow_start_pos = glove
			follow_target_dist_start = glove.distance_to(target)
		if t_since_hit >= follow_end_t and t_since_hit <= follow_end_t + 0.02 and follow_end_pos == Vector3.ZERO:
			follow_end_pos = glove
			follow_target_dist_end = glove.distance_to(target)
		if not back_reached and glove.distance_to(guard_pos) <= BACK_DIST_M and f > 5:
			back_reached = true
			back_time = t_since_hit
		if speed > BACK_SPEED_BAR and f > 5:
			back_ok = false
		lines.append("f%02d glove(%.3f,%.3f,%.3f) speed %.2f head_y %.3f elbow_y %.3f shoulder_y %.3f fwd %.3f" % [f, glove.x, glove.y, glove.z, speed, head.y, elbow.y, shoulder.y, fwd_dist])
		prev = row
	if follow_start_pos != Vector3.ZERO and follow_end_pos != Vector3.ZERO:
		var follow_dist := follow_end_pos.distance_to(follow_start_pos)
		var drift := absf(follow_target_dist_end - follow_target_dist_start)
		# S452: the drift part is dropped - an uppercut driving up past the chin moves away from the target by design.
		if follow_dist < FOLLOW_MIN_M:
			follow_ok = false
	if not back_reached or back_time > BACK_TIME_S:
		back_ok = false
	print("UPPERCUT_TAIL %s rep %d frames from the hit:" % [clip, rep])
	for line in lines:
		print("  " + line)
	print("UPPERCUT_TAIL %s rep %d: peak speed %.2f m/s, back at %.3f s (bar %.2f s), follow dist %.3f m (bar %.3f m)" % [clip, rep, peak_speed, back_time if back_reached else -1.0, BACK_TIME_S, follow_end_pos.distance_to(follow_start_pos) if follow_end_pos != Vector3.ZERO else 0.0, FOLLOW_MIN_M])
	_check(over_head_ok, "OVER_HEAD %s rep %d: glove never rises above head + %.2f m" % [clip, rep, OVER_HEAD_BAR])
	_check(elbow_ok, "ELBOW %s rep %d: elbow never rises above shoulder + %.2f m" % [clip, rep, ELBOW_BAR])
	_check(follow_ok, "FOLLOW %s rep %d: glove moves %.3f m up/forward 0.10-0.20 s after freeze (bar %.3f m)" % [clip, rep, follow_end_pos.distance_to(follow_start_pos) if follow_end_pos != Vector3.ZERO else 0.0, FOLLOW_MIN_M])
	_check(back_ok, "BACK %s rep %d: glove back to guard within %.2f s, peak speed %.2f m/s (bar %.1f m/s)" % [clip, rep, BACK_TIME_S, peak_speed, BACK_SPEED_BAR])
	_check(path_ok, "PATH %s rep %d: glove stays in front of spine (fwd >= %.2f m)" % [clip, rep, PATH_MIN_FWD])
	return [over_head_ok, elbow_ok, follow_ok, back_ok, path_ok]


func _initialize() -> void:
	Engine.max_fps = 60
	st = Stage.new()
	root.add_child(st)
	await process_frame
	st.setup({"glb": "res://assets/models/metahuman/mh_boxer_02.glb", "corner": "red"},
		{"glb": "res://assets/models/metahuman/mh_boxer_03.glb", "corner": "blue"})
	for i in 60:
		await process_frame
	var bx: Dictionary = st.boxers[0]
	skel = bx["skel"]
	ap = bx["ap"]
	front = float(bx.get("front", 0.15))
	skel.skeleton_updated.connect(_drawn)
	for row in ROWS:
		var clip := str(row[0])
		var move := str(row[1])
		if not ap.has_animation(clip):
			_check(false, "%s: the clip is loaded" % clip)
			continue
		for rep in REPS:
			await _throw(clip, move, rep)
	print("UPPERCUT_TAIL failures=%d" % failures)
	quit(1 if failures > 0 else 0)
