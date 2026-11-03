extends SceneTree
## S376 KNOCKDOWN1 probe + film: Danny's bout (TestJump men_fight), 6 s into round 1 a big landing cross and the count beat
## are fired through the real beat path (FightView._fire -> BeatFire), as the round script's last exchange does for a
## knockdown. S377 KNOCKCOUNT1 adds what follows (KnockdownCount): the standing boxer walks to a neutral corner, the round
## clock holds, the count runs to 8, the downed boxer gets up, BOX! and the round goes on. `-- stop=KO` (or RSC) closes the
## round first as a stoppage: the count goes to 10 (KO) or ends in STOPPED, a KO'd boxer stays on the canvas, the winner
## celebrates and the bout ends at once (the bell banner). Times are the fight's own (game) seconds: the slow-motion replay
## pauses the ring and is not counted. PASS/FAIL lines, "KNOCKDOWN failures=<n>", quit(1) on a failure. Film it under the
## movie writer:
##   python tools/hidden_desktop.py run --timeout=400 <godot.exe> --path . --windowed --resolution 1280x720 \
##       --fixed-fps 30 --write-movie <out>.avi --audio-driver Dummy --script res://tools/knockdown_film.gd [-- stop=KO]

const TestJump := preload("res://scripts/ui/TestJump.gd")
const Bouts := preload("res://scripts/state/Bouts.gd")
const Stage := preload("res://scripts/fight3d/FightStage.gd")
const KnockdownCount := preload("res://scripts/fight3d/KnockdownCount.gd")

const NEAR_CORNER_M := 0.6
const CLEAR_M := 2.0

var main: Node
var failures := 0
var g := 0.0   # game seconds since the count beat (the ring's own clock: scaled, stopped by the replay's pause)


func _initialize() -> void:
	var stop_how := ""
	var skip := false   # S377 review: SKIP ROUND pressed 0.5 s into the fall (with stop=KO: he stays down, no replay later)
	for a in OS.get_cmdline_user_args():
		if str(a).begins_with("stop="):
			stop_how = str(a).trim_prefix("stop=")
		if str(a) == "skip":
			skip = true
	root.size = Vector2i(1280, 720)
	main = load("res://scenes/Main.tscn").instantiate()
	root.add_child(main)
	for i in 4:
		await process_frame
	print("JUMP ", TestJump.run(main, "men_fight"))
	main.act("fightstep", "start")
	for i in 4:
		await process_frame
	var view: Node = main._fight_layer.get_child(0)
	while not bool(view.playing):
		await process_frame
	var base_frames := 0
	var base_out := 0
	while float(view.t) < 6.0:
		await process_frame
		if float(view.t) > 1.0 and not view.stage.camera.close:
			base_frames += 1
			if not _framed(view.stage.camera, view.stage.boxers):
				base_out += 1
				if base_out % 8 == 1:
					print("KNOCKDOWN baseline out t %.2f %s" % [float(view.t), _outs(view.stage.camera, view.stage.boxers)])
	print("KNOCKDOWN baseline (the fight's own lenses before the knockdown): %d of %d frames out" % [base_out, base_frames])
	if stop_how != "":
		# A stoppage is decided when the round closes (the 150 s shout in a real round): close round 1 here and make it one.
		var c: Variant = main.career
		Bouts.fight_step(c, c.fighter_by_id(str(view.fid)), main.modal, "round_out")
		var r: Dictionary = (main.modal["rounds"] as Array)[0]
		r["won"] = true
		r["counts"] = 1
		r["down"] = "b"
		r["stopped"] = stop_how
		r["up_at"] = [6]
		view._stop = stop_how
	var kd: Node = view.kd
	var down: Dictionary = view.stage.boxers[1]
	var up: Dictionary = view.stage.boxers[0]
	var head_y0 := _head(down)
	var t0 := float(view.t)
	var bs: Array = view.beats
	while int(view.next) < bs.size() and float(bs[int(view.next)]["t"]) < t0 + 0.35:
		view.next = int(view.next) + 1
	view._fire({"t": t0, "who": "a", "move": "cross", "result": "lands", "big": true, "knockback": true, "caption": "", "def": ""})
	var shot := float(view._beat.last_contact[0])
	while float(view.t) < t0 + 0.35:
		await process_frame
	var t_count := float(view.t)
	view._fire({"t": t_count, "who": "b", "move": "count", "result": "none", "big": false, "knockback": false, "caption": "", "def": ""})
	var contact_in := shot - t_count   # game seconds from the count beat to the shot's contact
	print("KNOCKDOWN shot contact at view t %.2f (fired %.2f, count %.2f)" % [shot, t0, t_count])
	var ap: AnimationPlayer = down["ap"]
	var replay: Node = view.replay
	if skip:
		await _skip_check(view, down, contact_in, stop_how)
		return
	var fall_g := -1.0
	var head_08 := head_y0
	var rep_start := -1.0
	var rep_end := -1.0
	var frames := 0
	var t_drift := 0.0          # how far view.t moved while the count held it
	var min_clear := 99.0       # the walker's closest approach to the downed body, from the fall on
	var at_corner := -1.0       # the walker's distance to the nearest neutral mark when the count shows 5
	var gap_at_5 := -1.0
	var head_up := -1.0         # the downed boxer's head height when the count ends (BOX! / STOPPED / KO)
	var top := 0
	var words: Array = []
	var box_g := -1.0
	var t_box := -1.0
	var t_after := -1.0
	var bell_g := -1.0
	var head_max_down := 0.0    # KO: the highest the head got after the fall
	var won_clip := ""
	var slides: Array = []      # S377 STEPROOT1: the walker's planted (lower) ankle, m/s over the canvas while he walks
	var walked := 0.0           # how far his body went on the walk
	var walk_s := 0.0
	var foot_prev: Array = []
	var body_prev := Vector3.INF
	var box_left := "-"         # the count graphic 4 s after BOX! (S377 review: BOX! never cleared)
	var cam_frames := 0         # S377: frames from the count on where the lens is checked
	var cam_out := 0            # ... where a head or a foot of either boxer is out of the picture (operator: no feet-only frames)
	var h := Stage.RING_M * 0.5 - KnockdownCount.NEUTRAL_IN_M
	var marks := [Vector3(-h, 0, h), Vector3(h, 0, -h)]
	while frames < 30 * 150 and g < 40.0:
		await process_frame
		frames += 1
		if not paused:
			g += root.get_process_delta_time()
		var clip := str(ap.current_animation)
		if fall_g < 0.0 and (clip.contains("countdown") or clip.contains("knockout")):
			fall_g = g
		if head_08 == head_y0 and g >= contact_in + 0.8 and not replay.active():
			head_08 = _head(down)
		if rep_start < 0.0 and replay.active():
			rep_start = frames / 30.0
		if rep_start >= 0.0 and rep_end < 0.0 and not replay.active():
			rep_end = frames / 30.0
		var wp: Vector3 = (up["node"] as Node3D).position
		var body: Vector3 = kd._body_centre()
		if fall_g >= 0.0 and kd.holding():
			# S377 review: the lying body is a segment hips -> head, not its midpoint
			min_clear = minf(min_clear, KnockdownCount._seg_gap(wp, wp, (down["node"] as Node3D).position, kd._head_ground(down)))
			t_drift = maxf(t_drift, absf(float(view.t) - t_count))
		if kd.shown != "" and not (str(kd.shown) in words):
			words.append(str(kd.shown))
		if int(kd.top) > top:
			top = int(kd.top)
			if top == 5:
				gap_at_5 = Vector2(wp.x - body.x, wp.z - body.z).length()
				at_corner = minf(Vector2(wp.x - marks[0].x, wp.z - marks[0].z).length(), Vector2(wp.x - marks[1].x, wp.z - marks[1].z).length())
		if head_up < 0.0 and str(kd.shown) in ["BOX!", "STOPPED", "KO"]:
			head_up = _head(down)
		if stop_how == "KO" and fall_g >= 0.0 and g >= fall_g + 2.0:
			head_max_down = maxf(head_max_down, _head(down))
		var walking: bool = str(kd.phase) == "count" and not (kd.get("_path") as Array).is_empty() and not paused
		var feet := [_ankle(up, "LeftFoot"), _ankle(up, "RightFoot")]
		var dt := root.get_process_delta_time()
		if walking and foot_prev.size() == 2 and body_prev.is_finite() and dt > 0.0:
			var low := 0 if (feet[0] as Vector3).y <= (feet[1] as Vector3).y else 1
			if absf((feet[low] as Vector3).y - (foot_prev[low] as Vector3).y) < 0.01:
				var fd: Vector3 = (feet[low] as Vector3) - (foot_prev[low] as Vector3)
				slides.append(Vector2(fd.x, fd.z).length() / dt)
			walked += Vector2(wp.x - body_prev.x, wp.z - body_prev.z).length()
			walk_s += dt
		foot_prev = feet
		body_prev = wp
		if str(kd.phase) in ["count", "end", "over", "back"] and not replay.active():   # the count's own lens (the fight's: baseline)
			cam_frames += 1
			if not (view.stage.camera.is_position_in_frustum(_ankle(down, "Head")) if walking else _framed(view.stage.camera, view.stage.boxers)):   # walking: the count close-up on his head
				cam_out += 1
				if cam_out % 4 == 1:
					print("KNOCKDOWN out of frame: phase '%s' count %s g %.2f (BOX! at %.2f) out %s" % [str(kd.phase), str(kd.shown), g, box_g, _outs(view.stage.camera, view.stage.boxers)])
		if str(kd.shown) == "BOX!" and box_g < 0.0:
			box_g = g
			t_box = float(view.t)
		if box_g >= 0.0 and t_after < 0.0 and g >= box_g + 2.0:
			t_after = float(view.t)
		if box_g >= 0.0 and g >= box_g + 4.0:
			box_left = str(kd.shown)
			break
		if bell_g < 0.0 and (float(view._bell_left) >= 0.0 or not bool(view.playing)):
			bell_g = g
			won_clip = str((up["ap"] as AnimationPlayer).current_animation)
		if bell_g >= 0.0 and g >= bell_g + 3.0:
			break
	print("KNOCKDOWN fall starts %.2f s after the count beat (contact %.2f s after it); head %.2f m -> %.2f m 0.8 s after the shot"
		% [fall_g, contact_in, head_y0, head_08])
	print("KNOCKDOWN replay %.1f s -> %.1f s (film seconds), replays %d, live again %s" % [rep_start, rep_end, int(replay.count), str(not paused)])
	print("KNOCKDOWN count shown %s, top %d; clock drift during the count %.3f s; walker at 5: %.2f m from the body, %.2f m from a neutral corner; closest to the body %.2f m"
		% [str(words), top, t_drift, gap_at_5, at_corner, min_clear])
	_check(fall_g >= contact_in + 0.12 - 0.05, "the fall starts after the shot lands (%.2f >= %.2f)" % [fall_g, contact_in + 0.12])
	_check(head_y0 - head_08 > 0.25, "the head has dropped %.2f m by 0.8 s after the shot" % (head_y0 - head_08))
	_check(int(replay.count) == 1 and rep_end > rep_start and rep_start > 0.0, "one slow-motion replay plays (%.1f s long)" % (rep_end - rep_start))
	_check(t_drift < 0.05, "the round clock holds through the count (drift %.3f s)" % t_drift)
	_check(gap_at_5 >= CLEAR_M and at_corner <= NEAR_CORNER_M, "the standing boxer waits in a neutral corner (%.2f m off it, %.2f m from the body)" % [at_corner, gap_at_5])
	slides.sort()
	var slide_mean := 0.0
	for v in slides:
		slide_mean += float(v)
	slide_mean /= maxf(1.0, float(slides.size()))
	var slide_p90: float = slides[int(slides.size() * 0.9)] if not slides.is_empty() else 99.0
	print("KNOCKDOWN walk: %.2f m in %.2f s (%.2f m/s), planted ankle slides mean %.3f m/s, p90 %.3f m/s, max %.3f over %d frames"
		% [walked, walk_s, walked / maxf(walk_s, 0.01), slide_mean, slide_p90, slides[-1] if not slides.is_empty() else 0.0, slides.size()])
	_check(walked >= 2.0 and slide_mean <= 0.10 and slide_p90 <= 0.20,
		"he steps to the corner, the planted foot holds (walk %.2f m, slide mean %.3f / p90 %.3f m/s)" % [walked, slide_mean, slide_p90])
	_check(min_clear >= 0.45, "the standing boxer never steps over the downed one (closest to his body %.2f m)" % min_clear)
	var scale := (down["node"] as Node3D).scale.y
	if stop_how == "KO":
		_check(top >= 10 and "KO" in words, "the count goes to 10, KO (%d, %s)" % [top, str(words)])
		_check(head_max_down < 0.6 * scale, "the knocked-out boxer stays on the canvas (head at most %.2f m)" % head_max_down)
	else:
		_check(top >= 8, "the count reaches the mandatory 8 (%d)" % top)
		_check(head_up >= KnockdownCount.STAND_HEAD_M * scale, "the downed boxer is up when the count ends (head %.2f m)" % head_up)
	if stop_how == "":
		_check("BOX!" in words and t_after - t_box >= 1.0, "BOX! and the round goes on (clock %.2f -> %.2f in 2 s)" % [t_box, t_after])
		_check(not view.stage.scene, "both are back in the fight")
		_check(box_left == "", "BOX! is gone 4 s later ('%s')" % box_left)
	else:
		_check(stop_how == "RSC" and "STOPPED" in words or stop_how == "KO", "a stoppage ends in its word (%s)" % str(words))
		_check(bell_g >= 0.0 and str(view._banner.text).begins_with("STOPPED") or not bool(view.playing),
			"the bout ends at once: the bell banner '%s' %.1f s after the count beat" % [str(view._banner.text), bell_g])
		_check(won_clip.contains("win"), "the winner celebrates in his corner (%s)" % won_clip)
	_check(cam_frames > 0 and cam_out <= int(cam_frames * 0.02), "in the count's picture: the downed boxer's head while the other walks, then both whole (%d of %d frames out)" % [cam_out, cam_frames])
	_check(not paused and not replay.active(), "the ring is live again after the replay")
	print("KNOCKDOWN failures=%d" % failures)
	quit(1 if failures > 0 else 0)


func _outs(cam: Camera3D, boxers: Array) -> String:
	var out := []
	for i in boxers.size():
		var skel: Skeleton3D = boxers[i]["skel"]
		for bone in ["Head", "LeftToeBase", "RightToeBase", "LeftFoot", "RightFoot"]:
			var id := skel.find_bone(bone)
			if id >= 0 and not cam.is_position_in_frustum(skel.global_transform * skel.get_bone_global_pose(id).origin):
				out.append("%d:%s" % [i, bone])
	return str(out)


## Both boxers' heads and toes inside the live lens's frustum.
func _framed(cam: Camera3D, boxers: Array) -> bool:
	for bx in boxers:
		var skel: Skeleton3D = bx["skel"]
		for bone in ["Head", "LeftToeBase", "RightToeBase", "LeftFoot", "RightFoot"]:
			var id := skel.find_bone(bone)
			if id >= 0 and not cam.is_position_in_frustum(skel.global_transform * skel.get_bone_global_pose(id).origin):
				return false
	return true


## Skip round 0.5 s into the fall: the count clears, the replay never cuts in (it paused the corner minute / the result
## card), and a knocked-out boxer stays on the canvas under the result.
func _skip_check(view: Node, down: Dictionary, contact_in: float, stop_how: String) -> void:
	while g < contact_in + 0.6:
		await process_frame
		if not paused:
			g += root.get_process_delta_time()
	view.skip_round()
	var paused_after := false
	var head_max := 0.0
	var frames := 0
	while frames < 30 * 10:
		await process_frame
		frames += 1
		paused_after = paused_after or paused
		if frames > 30 * 3:
			head_max = maxf(head_max, _head(down))
	print("KNOCKDOWN skip: replays %d, tree paused after the skip %s, head at most %.2f m after 3 s, count '%s' phase '%s'"
		% [int(view.replay.count), str(paused_after), head_max, str(view.kd.shown), str(view.kd.phase)])
	_check(int(view.replay.count) == 0 and not paused_after, "no replay cuts in after the skip")
	_check(str(view.kd.shown) == "", "the count is cleared")
	if stop_how == "KO":
		_check(head_max < 0.6 * (down["node"] as Node3D).scale.y, "the knocked-out boxer stays down under the result (%.2f m)" % head_max)
	print("KNOCKDOWN failures=%d" % failures)
	quit(1 if failures > 0 else 0)


func _ankle(bx: Dictionary, bone: String) -> Vector3:
	var skel: Skeleton3D = bx["skel"]
	return skel.global_transform * skel.get_bone_global_pose(skel.find_bone(bone)).origin


func _head(bx: Dictionary) -> float:
	var skel: Skeleton3D = bx["skel"]
	return (skel.global_transform * skel.get_bone_global_pose(skel.find_bone("Head"))).origin.y


func _check(cond: bool, label: String) -> void:
	if cond:
		print("PASS " + label)
	else:
		failures += 1
		print("FAIL " + label)
