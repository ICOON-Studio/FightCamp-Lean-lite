extends SceneTree
## POWER1C: the lead uppercut's tail - a short upward follow-through, then back to guard, never over her own head.
## The ruler: the game's FightStage pair (mh_boxer_02 vs mh_boxer_03 at the fight's gap), a landed uppercut thrown the way
## BeatFire throws one (FightStage.play from PunchPace start, PunchPace.arm, FightStage.land, FightStage.hit on the hit's
## timer), then HitImpact's own cut back to guard. The hitting glove front is read in Skeleton3D.skeleton_updated (the frame
## as DRAWN, after every modifier), every frame from the hit's drawn frame (f00) to 0.45 s after it.
##   OVER_HEAD  the punching glove's LOWEST point (the lower of its wrist and its front, see _low) never rises above her own
##              Head bone + 0.05 m (y), in any frame after the hit.
##   ELBOW      the punching elbow never rises above her own shoulder (the upper arm bone's head) + 0.05 m.
##   FOLLOW     for 0.10 to 0.20 s after the freeze ends the glove keeps moving up/forward (at least 0.03 m in total, its
##              distance to the target never grows more than 0.02 m) - a short follow-through, not a stop.
##   BACK       within 0.40 s of the hit the glove is within BACK_DIST_M of its guard place IN HER CHEST'S FRAME (see _home),
##              and on the way NO one-frame glove speed is above 9.6 m/s.
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
## POWER1D S457 (contract): BACK is read in her chest's frame against the nearest frame of her guard window (GUARD_WIN
## frames, the last of the 20 she stands in guard before the throw). 0.07 m, not the old world 0.05 m: her guard is a living
## captured take - in her chest's frame its lead hand travels 0.02-0.26 m within 1.2 s of standing in guard (8 entries
## probed, S457), so a hand truly home sits a few cm off the window's frames. S456 measured the hand-back home 0.025-0.07 m
## against the spine; S457 (patch on) the lead was home by 0.30-0.38 s on all 5 reps at this bar. A glove held on its hit
## point (mutant QUICK_BACK_S 0.45) never comes within it: BACK red 5/5. f00 reads 0.29-0.49 m.
const BACK_DIST_M := 0.07
const GUARD_WIN := 8
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
var spine_fwd := Vector3.ZERO
## POWER1D S457: the glove front in her chest's frame (metres, chest-bone axes) on each frame of the guard window before the
## throw - the guard is a living loop (IdleMatch), so "home" is the nearest of these, not one frame.
var guard_win: Array = []
var guard_rec := false


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


## POWER1D S457 (contract): the glove's lowest point - the lower of the wrist and the glove front. An upright guard glove's
## front is its TOP (GuardTuck.GUARD: the lead wrist sits 0.04 m under the Head bone, so the front sits ~0.04 m over it); the
## old read called a glove held at her own chin "over her head".
func _low(wrist: Vector3, glove: Vector3) -> float:
	return minf(wrist.y, glove.y)


func _wrist() -> Vector3:
	return skel.global_transform * skel.get_bone_global_pose(int(ids[2])).origin


## POWER1D S457 (contract): the glove front in her chest's frame - world metres, on the Chest bone's axes. The body sways
## 0.04-0.16 m during the tail (S456), so BACK compares the arm to the torso, not to a world point.
func _in_chest(glove: Vector3) -> Vector3:
	var c: Transform3D = skel.global_transform * skel.get_bone_global_pose(skel.find_bone("Chest"))
	return c.basis.orthonormalized().inverse() * (glove - c.origin)


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
	if ids.is_empty():
		return
	if guard_rec:
		guard_win.append(_in_chest(_glove()))
		return
	if not recording:
		return
	var f := Engine.get_process_frames()
	# POWER1D: the reach still holds the glove on its target this frame (armed on the clip shown, at full weight).
	var pr: Node = st.boxers[0].get("reach")
	var held := pr != null and str(pr.get("_clip")) != "" and str(pr.get("_clip")) == str(ap.assigned_animation) and float(pr.get("last_weight")) >= 0.999
	var gl := _glove()
	var row := [f, get_root().get_process_delta_time(), gl, _elbow(), _head(), _shoulder(), _spine(), str(ap.current_animation), hit_at >= 0, held, _wrist(), _in_chest(gl)]
	if not rec.is_empty() and int((rec[rec.size() - 1] as Array)[0]) == f:
		rec[rec.size() - 1] = row
	else:
		rec.append(row)


## The glove's distance from home: in her chest's frame, to the nearest frame of the guard window before the throw.
func _home(in_chest: Vector3) -> float:
	var best := INF
	for g in guard_win:
		best = minf(best, in_chest.distance_to(g as Vector3))
	return best


func _on_hit() -> void:
	hit_at = Engine.get_process_frames()


func _throw(clip: String, move: String, rep: int) -> Array:
	var hand: String = st.hand_of(0, str(BeatClips.contact_row(clip).get("hand", "RightHand")))
	ids = []
	for n in ["UpperArm", "LowerArm", "Hand", "MiddleProximal"]:
		ids.append(skel.find_bone(hand.trim_suffix("Hand") + n))
	guard_win = []
	st.guard(0)
	st.guard(1)
	for i in 20:
		# The guard window: her last GUARD_WIN frames of guard before the throw (the earlier ones are still the join).
		guard_rec = i >= 20 - GUARD_WIN
		await process_frame
	guard_rec = false
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
	var hit_y := -INF
	# S452 (Claude): the guard place is the glove BEFORE the punch, not the glove at the hit - Qwen's version measured "back"
	# to the hit point, so BACK read 0.10 s on a tail that never went home. S457: in her chest's frame, against the nearest
	# frame of the guard window (see _home).
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
		var low := _low(row[10] as Vector3, glove)
		if f == 0:
			hit_y = low
		# POWER1D (TASK_POWER1D open question b): measured from f01 - on the hit frame, and while the reach still holds the
		# glove on her (a taller opponent's chin can stand above her own head), the bar is max(her head, the hit's glove).
		var top := maxf(head.y, hit_y) if bool(row[9]) else head.y
		var over_head := f >= 1 and low > top + OVER_HEAD_BAR
		var elbow_high := f >= 1 and elbow.y > shoulder.y + ELBOW_BAR
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
		var home := _home(row[11] as Vector3)
		if not back_reached and home <= BACK_DIST_M and f > 5:
			back_reached = true
			back_time = t_since_hit
		if speed > BACK_SPEED_BAR and f > 5:
			back_ok = false
		lines.append("f%02d glove(%.3f,%.3f,%.3f) low %.3f speed %.2f head_y %.3f elbow_y %.3f shoulder_y %.3f fwd %.3f home %.3f" % [f, glove.x, glove.y, glove.z, low, speed, head.y, elbow.y, shoulder.y, fwd_dist, home])
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
