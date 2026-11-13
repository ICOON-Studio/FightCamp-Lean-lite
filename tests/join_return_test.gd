extends SceneTree
## JOINFIX1 (POWER1_STEP4_RESULT.md "still red" 2: after a landed lead uppercut the glove jumped up to 0.48 m in ONE frame on
## the cut back to guard, 26-28.6 m/s, where a real glove comes back well under 10 m/s). The ruler: the game's FightStage
## pair (the staging of punch_speed_test: mh_boxer_02 against mh_boxer_03, at the fight's gap), the stage running live at
## 60 frames a second, a punch thrown the way BeatFire throws a landed one (FightStage.play from its PunchPace start,
## PunchPace.arm, FightStage.land, FightStage.hit on the hit's timer), then HitImpact's own cut back to guard. The hitting
## glove front is read in Skeleton3D.skeleton_updated, the frame as DRAWN (after every modifier: the join smoother, the
## guard, PunchReach, ReachLimit, the head clearance), every frame from the hit's drawn frame (f00, the first drawn after
## FightStage.hit fired) to WINDOW_S after it - and, when the cut back to guard comes later (the cross's longer recovery),
## on to AFTER_CUT_S past the cut. The step onto f00 is the punch arriving (punch_speed_test, hit_frame_test), not the return.
##   STEP   no one-frame step of the glove front is faster than BAR_MS (the jab / cross band's top 7.5 m/s + 20 %).
##   RETURN the same bar from the cut back to guard on (the join's own part of the window; STEP covers the whole of it).
##   JOIN   the cut back to guard falls inside the window (so the step bar reads the join, not only the follow-through).
## Every frame's speed is printed. 3D only: no rule is read or changed.
## Run: <godot> --headless --audio-driver Dummy --path . --script res://tests/join_return_test.gd   (probes: -- trace, reps=<n>, only=<clip>)

const Stage := preload("res://scripts/fight3d/FightStage.gd")
const BeatClips := preload("res://scripts/fight3d/BeatClips.gd")
const PunchPace := preload("res://scripts/fight3d/PunchPace.gd")
const PR := preload("res://scripts/fight3d/PunchReach.gd")
const BAR_MS := 9.0
const WINDOW_S := 0.40
const MAX_S := 1.2            # a punch whose cut back to guard comes after WINDOW_S is read on to it ...
const AFTER_CUT_S := 0.30     # ... and this long past it (the join's own length, FightStage.GUARD_JOIN_S at most)
const REPS := 5
const ROWS := [["pro_left_uppercut", "lead_uppercut"], ["pro_right_uppercut", "rear_uppercut"], ["pro_left_hook", "lead_hook"],
	["pro_right_cross", "cross"]]

var failures := 0
var st: Node3D
var skel: Skeleton3D
var ap: AnimationPlayer
var front := 0.15
var ids: Array = []
var rec: Array = []          # per drawn frame of the throw: [process frame, delta, glove front, clip, after the hit]
var recording := false
var hit_at := -1
var reps := REPS
var only := ""
var _face := Vector3.ZERO
var trace := false           # `-- trace`: per drawn frame, the clip, its time and speed, the join's clock, the reach's weight


func _check(ok: bool, what: String) -> void:
	if not ok:
		failures += 1
	print(("PASS " if ok else "FAIL ") + what)


## The glove's striking face from the drawn bones (punch_speed_test._glove).
func _glove() -> Vector3:
	var g := skel.global_transform
	var wrist: Vector3 = g * skel.get_bone_global_pose(int(ids[2])).origin
	var a: Vector3 = (g * skel.get_bone_global_pose(int(ids[3])).origin - wrist).normalized()
	var arm: Vector3 = (wrist - g * skel.get_bone_global_pose(int(ids[1])).origin).normalized()
	if PR.STRAIGHT > 0.0 and a.angle_to(arm) > 1e-3:
		a = a.slerp(arm, PR.STRAIGHT).normalized()
	return wrist + a * front * g.basis.get_scale().x


## skeleton_updated: the pose after every modifier, i.e. what is drawn this frame (the last emission of a frame wins).
func _drawn() -> void:
	if not recording or ids.is_empty():
		return
	var f := Engine.get_process_frames()
	var row := [f, get_root().get_process_delta_time(), _glove(), str(ap.current_animation), hit_at >= 0]
	if trace:
		var js: Node = st.boxers[0].get("js")
		var pr: Node = st.boxers[0].get("reach")
		var face: Vector3 = st.target_point(1, false)
		var glove: Vector3 = row[2]
		print("  trace f%d hit %s clip %s at %.3f x%.2f | join t %.3f pending %s | reach %s w %.2f | her face %.3f m off the glove, moved %.3f m" % [f,
			str(hit_at >= 0), ap.current_animation, ap.current_animation_position, ap.speed_scale, float(js.get("_t")), str(js.get("_pending")),
			str(pr.get("_clip")), float(pr.get("_w_now")), face.distance_to(glove), face.distance_to(_face)] + " fades %s" % str(pr.get("_fades")).left(120))
		_face = face
	if not rec.is_empty() and int((rec[rec.size() - 1] as Array)[0]) == f:
		rec[rec.size() - 1] = row
	else:
		rec.append(row)


func _on_hit() -> void:
	hit_at = Engine.get_process_frames()


## One landed punch and its return to guard; returns [peak m/s, its frame from the hit, the join frame from the hit or -1,
## the peak before the cut, the peak from the cut on].
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
	recording = true
	if not st.play(0, clip, float(p["sp"]), float(p["start"])):
		recording = false
		_check(false, "%s rep %d: the stage refused the punch" % [clip, rep])
		return [0.0, -1, -1, 0.0, 0.0]
	var pid := int(st.boxers[0]["play_id"])
	PunchPace.arm(st, 0, p)
	st.land(0, clip, false, at, float(p["c"]))
	var react := BeatClips.react(move, false, st.has_move, 0.0, false)
	create_timer(at).timeout.connect(func():
		st.hit(1, react, BeatClips.speed(react, ""), 0, move, false, pid)
		_on_hit())
	var guard := BeatClips.first(BeatClips.GUARD, ap.has_animation)
	var t0 := Time.get_ticks_msec()
	while hit_at < 0 and Time.get_ticks_msec() - t0 < 4000:
		await process_frame
	var t := 0.0
	var cut_t := -1.0
	while hit_at >= 0 and (t < WINDOW_S + 1e-4 or (cut_t < 0.0 and t < MAX_S) or (cut_t >= 0.0 and t < cut_t + AFTER_CUT_S)):
		await process_frame
		t += get_root().get_process_delta_time()
		if cut_t < 0.0 and str(ap.current_animation) != clip:
			cut_t = t
	await process_frame
	recording = false
	var peak := 0.0
	var peak_f := -1
	var join_f := -1
	var pre := 0.0
	var post := 0.0
	var lines := PackedStringArray()
	var prev: Array = []
	var f0 := -1
	for r in rec:
		var row: Array = r
		if not bool(row[4]):
			continue   # drawn before the hit: the arrival onto the hit frame is the punch's own (punch_speed, hit_frame)
		if f0 < 0:
			f0 = int(row[0])
		var f := int(row[0]) - f0
		if not prev.is_empty():
			var dt := maxf(float(row[1]), 1e-4)
			var v := (row[2] as Vector3).distance_to(prev[2] as Vector3) / dt
			var gone := str(row[3]) != clip and str(prev[3]) == clip
			if gone and join_f < 0:
				join_f = f
			lines.append("f%02d %.2f%s" % [f, v, " J" if gone else ""])
			if v > peak:
				peak = v
				peak_f = f
			if join_f < 0:
				pre = maxf(pre, v)
			else:
				post = maxf(post, v)
		prev = row
	print("JOIN_RETURN %s rep %d frames from the hit (glove front as drawn, m/s; J = the cut back to %s): %s" % [clip, rep, guard, ", ".join(lines)])
	return [peak, peak_f, join_f, pre, post]


func _initialize() -> void:
	Engine.max_fps = 60
	trace = OS.get_cmdline_user_args().has("trace")
	for a in OS.get_cmdline_user_args():   # `-- reps=<n>` throws per row, `-- only=<clip>` one row (probes; the test is the default)
		if str(a).begins_with("reps="):
			reps = maxi(1, int(str(a).get_slice("=", 1)))
		elif str(a).begins_with("only="):
			only = str(a).get_slice("=", 1)
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
	_check(bx.get("js") != null, "the join smoother is on the body")
	_check(bx.get("reach") != null, "the landing reach (PunchReach) is on the body")
	for row in ROWS:
		var clip := str(row[0])
		var move := str(row[1])
		if only != "" and clip != only:
			continue
		if not ap.has_animation(clip):
			_check(false, "%s: the clip is loaded" % clip)
			continue
		var worst := 0.0
		var worst_f := -1
		var joins := 0
		var pre := 0.0
		var post := 0.0
		for rep in reps:
			var got: Array = await _throw(clip, move, rep)
			pre = maxf(pre, float(got[3]))
			post = maxf(post, float(got[4]))
			if float(got[0]) > worst:
				worst = float(got[0])
				worst_f = int(got[1])
			if int(got[2]) >= 0:
				joins += 1
		print("JOIN_RETURN ROW %s: peak one-frame glove speed %.2f m/s at f%02d after the hit (before the cut to guard %.2f, from the cut on %.2f; %d of %d returns cut to guard in the window)" % [
			clip, worst, worst_f, pre, post, joins, reps])
		_check(worst <= BAR_MS, "STEP %s: peak one-frame glove step %.2f m/s from the hit to %.2f s after (bar %.1f)" % [clip, worst, WINDOW_S, BAR_MS])
		# The same bar on the return alone (the cut to guard and the join after it, JoinSmoother's part of the window).
		_check(post <= BAR_MS, "RETURN %s: peak one-frame glove step %.2f m/s from the cut back to guard on (bar %.1f)" % [clip, post, BAR_MS])
		_check(joins == reps, "JOIN %s: the cut back to guard fell inside the window on %d of %d throws" % [clip, joins, reps])
	print("JOIN_RETURN failures=%d" % failures)
	quit(1 if failures > 0 else 0)
