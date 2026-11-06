extends SceneTree
## S379 C222 CAMMOTION probe (operator on the FIGHT9 round-9 film at 1:40.5: "the camera movement makes me dizzy, watch what
## angles are used in televised events and try to do the same, why you keep zooming in and out and rotate all at the same
## time"). Plays Danny's bout (TestJump men_fight): the intro, round 1, and at `knockdown=` s of round time a big landing cross
## and the count beat (as judge_film.gd: the shot, the fall, the slow-motion replay, the count, BOX!), then the round on to
## `secs=`. Every frame it reads the camera that draws the ring - whichever is current (the broadcast lens, the replay's, the
## count's, the intro's) - and measures how fast it turns (deg/s, film seconds), how fast its FOV changes, how fast it moves.
## Another camera, a cut the lens counts (RingCamera.cuts), a jump of the lens or a snap of its look starts a new shot.
## The bars (the TV rulebook S379, docs/TV_CAMERA_RULES.md) - never loosen one to make a line pass:
## - a lens turns at most TURN_MAX deg/s (S379 preview rule; RED/Sony: a pan crosses one picture width in >= 7 s);
## - the FOV never changes while the lens turns or moves (no zoom during a pan or a dolly: one move per shot);
## - no frame from behind a boxer (S368: within BEHIND_DEG of straight behind her, both standing);
## - no shot shorter than MIN_SHOT_S (the replay's shots are 2-4 s; live TV cuts about every 9 s) - but one the broadcast
##   lens left by its emergency cut (the rulebook's "leave a blocked angle immediately": a boxer at the lens, or the lens
##   about to be behind one), counted and printed apart;
## - S380 (operator on a still shot through the ropes: "i thought you fixed the ropes, why old problems appear again?"): no
##   frame from outside the ropes (S347) - every lens, live, replay, count and intro, keeps max(|x|, |z|) <= ROPE_M (the
##   rope line, FightStage.RING_M * 0.5; tools/corner_film.gd checks the corner minute the same way).
## `fromcorners` opens the bout as the films do (FightIntro / CornerStart); `clinch=<s>[,<s>...]` puts a tie-up at those round
## seconds (tools/cam_view_probe.gd's, so the clinch lens is measured too - natural clinches are rare).
## Headless (the 3D stage plays with `show3d`):
##   <godot.exe> --headless --audio-driver Dummy --fixed-fps 30 --path . --script res://tools/cam_motion_probe.gd -- show3d \
##       [secs=60] [knockdown=20] [fightjump=men_fight]
## Prints CAMMOTION lines (every shot, the worst frames), then CAMMOTION_SUMMARY ... PASS/FAIL; quit(1) on FAIL.

const TestJump := preload("res://scripts/ui/TestJump.gd")
const PoseTap := preload("res://tools/pose_tap.gd")
const CamView := preload("res://tools/cam_view_probe.gd")

const TURN_MAX := 10.0         # deg/s
const MIN_SHOT_S := 2.0
const BEHIND_DEG := 45.0       # tools/cam_view_probe.gd
const ROPE_M := 2.75           # the rope line (FightStage.RING_M * 0.5)
const STAND_HEAD_M := 1.2      # a boxer counts as standing while his head is this high (scale 1)
## What counts as a cut between two frames (film seconds at 30 fps): the lens jumps, its look snaps or its FOV jumps.
const JUMP_M := 0.4
const SNAP_DEG := 20.0
const FOV_JUMP := 3.0
## "Turning", "moving", "zooming" (per film second): below these a lens is still.
const TURNING := 0.5
const MOVING := 0.05
const ZOOMING := 0.3
const DT := 1.0 / 30.0

var main: Node
var _taps: Array = []


func _initialize() -> void:
	var secs := 60.0
	var kd_at := 20.0
	var jump := "men_fight"
	var clinch_at: Array = []
	for a in OS.get_cmdline_user_args():
		var s := str(a)
		if s.begins_with("secs="):
			secs = float(s.trim_prefix("secs="))
		elif s.begins_with("knockdown="):
			kd_at = float(s.trim_prefix("knockdown="))
		elif s.begins_with("fightjump="):
			jump = s.trim_prefix("fightjump=")
		elif s.begins_with("clinch="):
			for c in s.trim_prefix("clinch=").split(","):
				clinch_at.append(float(c))
	root.size = Vector2i(1280, 720)
	main = load("res://scenes/Main.tscn").instantiate()
	root.add_child(main)
	await _wait(4)
	print("CAMMOTION reached fight night: ", TestJump.run(main, jump))
	await _wait(4)
	main.act("fightstep", "start")
	await _wait(2)
	var view: Node = main._fight_layer.get_child(0)
	var st: Node = view.stage
	if st == null:
		print("CAMMOTION FAIL no 3D stage (run with -- show3d)")
		quit(1)
		return
	# Headless, the fight's SubViewport comes up 1920 x 1920; the game and the films draw it 16:9. The lens frames by its
	# viewport's aspect, so pin it to the film's 1280 x 720 (the container's stretch would size it back).
	var vp := st.get_viewport() as SubViewport
	if vp != null and DisplayServer.get_name() == "headless":
		if vp.get_parent() is SubViewportContainer:
			(vp.get_parent() as SubViewportContainer).stretch = false
		vp.size = Vector2i(1280, 720)
	print("CAMMOTION stage viewport %s" % str(st.get_viewport().get_visible_rect().size))
	for i in 2:
		var tap: SkeletonModifier3D = PoseTap.new()
		tap.setup(st.boxers[i]["skel"], ["Head", "Hips"])
		(st.boxers[i]["skel"] as Skeleton3D).add_child(tap)
		_taps.append(tap)
	var shots: Array = []          # {t, len, name, phase, fov, turn, move, zoom}
	var frames := 0
	var turning_over := 0          # frames turning faster than TURN_MAX
	var zoom_moving := 0           # frames whose FOV changes while the lens turns or moves
	var behind := 0
	var standing := 0
	var turn_all: Array = []
	var move_all: Array = []
	var worst_turn := [0.0, 0.0, ""]
	var worst_zoom: Array = []
	var behind_at: Array = []
	var shake_max := 0.0
	var outside := 0
	var out_by: Dictionary = {}    # "shot/phase" -> [frames outside, worst reach past the rope line (m)]
	var axis_prev := INF
	var axis_ema := 0.0
	var axis_raw: Array = []      # |deg/s| of the pair's hips line, frame to frame (live, both standing)
	var axis_eased: Array = []    # the same eased over ~0.3 s
	var fast_turn: Array = []
	var prev_cam: Camera3D = null
	var prev_x := Transform3D()
	var prev_fov := 0.0
	var prev_cuts := -1
	var film_t := 0.0
	var kd_fired := false
	var round_seen := false
	while film_t < 600.0:
		await process_frame
		film_t += DT
		var playing := bool(view.playing)
		round_seen = round_seen or playing
		if round_seen and (float(view.t) >= secs or (not playing and not view.replay.active() and str(view.kd.phase) in ["", "over"]
				and float(view.t) > 1.0)):
			break
		if playing and not clinch_at.is_empty() and float(view.t) >= float(clinch_at[0]) - 1.0:
			CamView.put_clinch(view, float(clinch_at.pop_front()))
		if playing and not kd_fired and kd_at > 0.0 and float(view.t) >= kd_at:
			kd_fired = true
			_knockdown(view)
		var cam: Camera3D = st.get_viewport().get_camera_3d()
		if cam == null:
			continue
		frames += 1
		var x := cam.global_transform
		var name := _name(cam, view)
		var phase := _phase(view)
		var reach := maxf(absf(x.origin.x), absf(x.origin.z)) - ROPE_M
		var key := "%s/%s" % [name, phase]
		if not out_by.has(key):
			out_by[key] = [0, -9.0]
		out_by[key][1] = maxf(float(out_by[key][1]), reach)
		if reach > 0.0:
			outside += 1
			out_by[key][0] = int(out_by[key][0]) + 1
		shake_max = maxf(shake_max, Vector2(cam.h_offset, cam.v_offset).length())
		var cuts_now := int(cam.get("cuts")) if cam.get("cuts") != null else -1
		var cut := prev_cam != cam or shots.is_empty() or (cuts_now >= 0 and cuts_now != prev_cuts)
		var turn := 0.0
		var move := 0.0
		var zoom := 0.0
		if not cut:
			turn = rad_to_deg((prev_x.basis.orthonormalized().inverse() * x.basis.orthonormalized()).get_rotation_quaternion().get_angle())
			move = prev_x.origin.distance_to(x.origin)
			zoom = absf(cam.fov - prev_fov)
			cut = move > JUMP_M or turn > SNAP_DEG or zoom > FOV_JUMP or name != str(shots[-1]["name"])
		if cut:
			if not shots.is_empty():
				shots[-1]["len"] = film_t - float(shots[-1]["t"])
			shots.append({"t": film_t, "len": 0.0, "name": name, "phase": phase, "fov": cam.fov, "turn": 0.0, "move": 0.0, "zoom": 0.0,
				"rt": float(view.t), "why": str(cam.get("cut_why")) if cam.get("cut_why") != null else ""})
		else:
			var tps := turn / DT
			var mps := move / DT
			var zps := zoom / DT
			turn_all.append(tps)
			move_all.append(mps)
			var sh: Dictionary = shots[-1]
			sh["turn"] = maxf(float(sh["turn"]), tps)
			sh["move"] = maxf(float(sh["move"]), mps)
			sh["zoom"] = maxf(float(sh["zoom"]), zps)
			if tps > float(worst_turn[0]):
				worst_turn = [tps, film_t, "%s/%s" % [name, phase]]
			if tps > TURN_MAX:
				turning_over += 1
			if zps > ZOOMING and (tps > TURNING or mps > MOVING):
				zoom_moving += 1
				if worst_zoom.size() < 6:
					worst_zoom.append("t=%.2f %s/%s fov %.2f deg/s turn %.1f deg/s move %.2f m/s" % [film_t, name, phase, zps, tps, mps])
		if phase == "live" and _standing(st, 0) and _standing(st, 1):
			var h0 := _bone(0, "Hips")
			var h1 := _bone(1, "Hips")
			var ang := rad_to_deg(atan2(-(h1.z - h0.z), h1.x - h0.x))
			if is_finite(axis_prev):
				var w := wrapf(ang - axis_prev, -180.0, 180.0) / DT
				axis_ema = lerpf(axis_ema, w, 1.0 - exp(-DT / 0.3))
				axis_raw.append(absf(w))
				axis_eased.append(absf(axis_ema))
			axis_prev = ang
		else:
			axis_prev = INF
		if not cut and turn / DT > 9.0 and fast_turn.size() < 8:
			fast_turn.append("t=%.2f %s %.1f deg/s scale %.2f ang_v %s" % [film_t, name, turn / DT, Engine.time_scale, str(cam.get("_ang_v"))])
		if phase in ["live", "replay"] and _standing(st, 0) and _standing(st, 1):
			standing += 1
			var ang := _behind(x.origin)
			if ang < BEHIND_DEG:
				behind += 1
				if behind_at.size() < 6:
					behind_at.append("t=%.2f %s/%s %.0f deg" % [film_t, name, phase, ang])
		prev_cam = cam
		prev_cuts = cuts_now
		prev_x = x
		prev_fov = cam.fov
	if not shots.is_empty():
		shots[-1]["len"] = film_t - float(shots[-1]["t"])
	var short: Array = []
	var left: Array = []    # short, but left by the emergency cut (rule 11)
	for i in shots.size():
		var sh: Dictionary = shots[i]
		print("CAMMOTION shot %2d film %6.2f s (round %5.1f) %5.2f s %-14s %-7s fov %4.1f | turn max %5.1f deg/s, move max %4.2f m/s, zoom max %4.1f deg/s"
			% [i, float(sh["t"]), float(sh["rt"]), float(sh["len"]), str(sh["name"]), str(sh["phase"]), float(sh["fov"]),
			float(sh["turn"]), float(sh["move"]), float(sh["zoom"])] + ("  [%s]" % str(sh["why"]) if str(sh["why"]) != "" else ""))
		if float(sh["len"]) < MIN_SHOT_S and i < shots.size() - 1:
			var tag := "%d (%s %.2f s at %.1f)" % [i, str(sh["name"]), float(sh["len"]), float(sh["t"])]
			if str(shots[i + 1]["why"]).begins_with("emergency"):
				left.append(tag)
			else:
				short.append(tag)
	turn_all.sort()
	move_all.sort()
	var n := maxf(1.0, float(frames))
	print("CAMMOTION frames %d (%.0f film s), %d shots, %.1f s a shot on average, the knockdown %s" % [frames, film_t, shots.size(),
		film_t / maxf(1.0, shots.size()), "fired" if kd_fired else "NOT fired"])
	print("CAMMOTION turn: p50 %.1f p95 %.1f max %.1f deg/s (at film %.2f, %s); %d frames over %.0f deg/s (%.1f %%)" % [_pct(turn_all, 0.5),
		_pct(turn_all, 0.95), float(worst_turn[0]), float(worst_turn[1]), str(worst_turn[2]), turning_over, TURN_MAX, 100.0 * turning_over / n])
	print("CAMMOTION move: p50 %.2f p95 %.2f max %.2f m/s | shake (h/v offset) max %.3f m" % [_pct(move_all, 0.5), _pct(move_all, 0.95),
		_pct(move_all, 1.0), shake_max])
	axis_raw.sort()
	axis_eased.sort()
	print("CAMMOTION the pair's hips line turns (live): frame to frame p50 %.0f p90 %.0f p99 %.0f deg/s | eased 0.3 s p50 %.0f p90 %.0f p99 %.0f max %.0f deg/s"
		% [_pct(axis_raw, 0.5), _pct(axis_raw, 0.9), _pct(axis_raw, 0.99), _pct(axis_eased, 0.5), _pct(axis_eased, 0.9),
		_pct(axis_eased, 0.99), _pct(axis_eased, 1.0)])
	print("CAMMOTION turns over 9 deg/s: %s" % str(fast_turn))
	print("CAMMOTION zoom while turning or moving: %d frames %s" % [zoom_moving, str(worst_zoom)])
	print("CAMMOTION behind a boxer (both standing, live + replay): %d of %d frames %s" % [behind, standing, str(behind_at)])
	print("CAMMOTION shots shorter than %.1f s: %d %s | left early by the emergency cut: %d %s" % [MIN_SHOT_S, short.size(),
		str(short), left.size(), str(left)])
	for k in out_by:
		print("CAMMOTION lens %s: %d frames outside the ropes, furthest %.2f m %s the rope line" % [k, int(out_by[k][0]),
			absf(float(out_by[k][1])), "PAST" if float(out_by[k][1]) > 0.0 else "inside"])
	print("CAMMOTION outside the ropes: %d of %d frames" % [outside, frames])
	var ok := kd_fired and turning_over == 0 and zoom_moving == 0 and behind == 0 and short.is_empty() and outside == 0
	print("CAMMOTION_SUMMARY turn_max=%.1f over10=%d zoom_moving=%d behind=%d short=%d emergency_short=%d outside=%d shots=%d %s" % [
		float(worst_turn[0]), turning_over, zoom_moving, behind, short.size(), left.size(), outside, shots.size(),
		"PASS" if ok else "FAIL"])
	quit(0 if ok else 1)


## As judge_film.gd knockdown=: a big landing cross, then the count beat 0.35 s later.
func _knockdown(view: Node) -> void:
	var t0 := float(view.t)
	var bs: Array = view.beats
	while int(view.next) < bs.size() and float(bs[int(view.next)]["t"]) < t0 + 0.35:
		view.next = int(view.next) + 1
	view._fire({"t": t0, "who": "a", "move": "cross", "result": "lands", "big": true, "knockback": true, "caption": "", "def": ""})
	while float(view.t) < t0 + 0.35:
		await process_frame
	view._fire({"t": float(view.t), "who": "b", "move": "count", "result": "none", "big": false, "knockback": false, "caption": "",
		"def": ""})
	print("CAMMOTION knockdown at round t=%.1f" % t0)


func _phase(view: Node) -> String:
	if view.replay != null and view.replay.active():
		return "replay"
	if str(view.kd.phase) != "":
		return "count"
	return "live" if bool(view.playing) else "intro"


func _name(cam: Camera3D, view: Node) -> String:
	if view.replay != null and cam == view.replay.get("cam") and str(view.replay.get("shot_name")) not in ["", "<null>"]:
		return str(view.replay.get("shot_name"))
	var shot: Variant = cam.get("shot_name")
	if shot != null:
		return str(shot)
	if cam.get("close") != null:   # the pre-S379 broadcast lens: its director shot, or a film shot
		if bool(cam.get("close")):
			return "film"
		var k := int(cam.get("_shot"))
		var list: Array = cam.get("SHOTS") if cam.get("SHOTS") != null else []
		return str(list[k]["name"]) if k >= 0 and k < list.size() else "broadcast"
	return str(cam.name)


## The smallest angle, over both boxers, between "away from the other one" and "toward the lens" (flat, hips as shown).
func _behind(lens: Vector3) -> float:
	var best := 180.0
	for i in 2:
		var me := _bone(i, "Hips")
		var them := _bone(1 - i, "Hips")
		var away := Vector3(me.x - them.x, 0, me.z - them.z)
		var to_lens := Vector3(lens.x - me.x, 0, lens.z - me.z)
		if away.length() > 0.01 and to_lens.length() > 0.01:
			best = minf(best, rad_to_deg(away.angle_to(to_lens)))
	return best


func _standing(st: Node, i: int) -> bool:
	return _bone(i, "Head").y >= STAND_HEAD_M * (st.boxers[i]["node"] as Node3D).scale.y


func _bone(i: int, bone: String) -> Vector3:
	var tap: SkeletonModifier3D = _taps[i]
	var skel := tap.get_skeleton()
	if tap.shown.has(bone) and skel != null:
		return skel.global_transform * (tap.shown[bone] as Vector3)
	return skel.global_position if skel != null else Vector3.ZERO


func _pct(a: Array, q: float) -> float:
	if a.is_empty():
		return 0.0
	return float(a[clampi(int(a.size() * q), 0, a.size() - 1)])


func _wait(n: int) -> void:
	for k in n:
		await process_frame
