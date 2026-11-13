extends SceneTree
## POWER1 step 2, review round 1 (blind review of a7b785d3: "a landed jab's glove pops right after contact"; the played
## fight's jabs jumped 8-17 cm within two frames of the hit; hit_frame_test could not see it - it stops the stage and runs
## PunchReach alone). This ruler runs the PLAYED path with the whole stage on: FightStage.play at the game's pace
## (BeatClips.speed), FightStage.land, and FightStage.hit on a timer at the contact as BeatFire does (the hit-stop, her
## head snap, the fast recovery back to guard, PunchWeight's hips and carry, GloveClear's settle - every correction). It
## reads the hitting glove front AS DRAWN (FightStage.glove_front), frame by frame at 60 frames a second, from 0.30 s
## before the hit to the start of its way home, and for every punch the fight can land:
##   SPEED   arriving on the hit frame at least SHARE_MIN of its top speed over the 0.30 s before.
##   ON      the glove front within ON_M of her face (ribs) on the hit frame.
##   CARRY   it goes on past the hit point, along the way it arrived, THROUGH_M (0.05-0.11 m) - the whole body's carry
##           as drawn: arm, hips and lunge together.
##   SMOOTH  from the hit to the start of its return it never moves more than STEP_M in one 1/60 s frame, and from the
##           hit until it is well on its way home (WINDOW_BACK_M behind the hit point) it changes direction along that
##           line at most once (out, then back: never out-back-out).
## Two DIFFERENT bodies (mh_boxer_12 against mh_boxer_07). 3D only: no rule is read or changed.
## Run: <godot> --headless --audio-driver Dummy --path . --script res://tests/hit_carry_test.gd
##   [-- only=<clip> | upto=<clip>] [show] (the frame table) [noland] (no reach: the clip's own glove) [noclose] (no step-in)

const Stage := preload("res://scripts/fight3d/FightStage.gd")
const BeatClips := preload("res://scripts/fight3d/BeatClips.gd")
const PunchPace := preload("res://scripts/fight3d/PunchPace.gd")
## POWER1 step 4 (each punch from its own distance): with it on, each punch is staged where the fight's footwork stands the
## pair for it (FightStage.aim with the punch, as RangeBreath hands it a punch in the air: feet.want_m) and its ON is read
## against the point the fight aims it at (RangeTable.aim: an uppercut at her chin). `-- nopunchrange` = as before.
const RangeTable := preload("res://scripts/fight3d/RangeTable.gd")
const HZ := 60.0
const BEFORE_S := 0.30
const AFTER_S := 0.45
const SHARE_MIN := 0.5
const THROUGH_M := Vector2(0.05, 0.11)
const ON_M := 0.05
const STEP_M := 0.06
const NOISE_M := 0.004        # a frame's move along the line under this is not a change of direction
const WINDOW_BACK_M := 0.05
const ROLLS := [0.0, 0.3, 0.55, 0.8, 0.99]

var failures := 0
var st: Node3D
var _hit_i := -1
var _n := 0


func _check(ok: bool, what: String) -> void:
	if not ok:
		failures += 1
	print(("PASS " if ok else "FAIL ") + what)


func _fight_punches() -> Array:
	var out: Array = []
	for move in BeatClips.PUNCH:
		for big in [false, true]:
			for tired in [false, true]:
				for step in [false, true]:
					for roll in ROLLS:
						var clip := BeatClips.punch(str(move), {"big": big, "tired": tired, "step": step, "roll": roll}, st.has_move)
						if clip.begins_with("pro_") and not out.has([clip, str(move)]):
							out.append([clip, str(move)])
	return out


func _on_hit() -> void:
	_hit_i = _n


func _initialize() -> void:
	Engine.max_fps = int(HZ)
	st = Stage.new()
	root.add_child(st)
	await process_frame
	st.setup({"glb": "res://assets/models/metahuman/mh_boxer_12.glb", "corner": "red"},
		{"glb": "res://assets/models/metahuman/mh_boxer_07.glb", "corner": "blue"})
	for i in 30:
		await process_frame
	var home := [st.boxers[0]["pos"], st.boxers[1]["pos"]]
	var only := ""
	var upto := ""
	for a in OS.get_cmdline_user_args():
		if str(a).begins_with("only="):
			only = str(a).get_slice("=", 1)
		elif str(a).begins_with("upto="):
			upto = str(a).get_slice("=", 1)
	var show := OS.get_cmdline_user_args().has("show")
	print("HIT_CARRY gap %.3f m (the whole stage running, %d frames a second)" % [st.gap_m, int(HZ)])
	var carries: Array = []
	for pair in _fight_punches():
		var clip := str(pair[0])
		var move := str(pair[1])
		if only != "" and clip != only:
			continue
		if upto == "-":
			break
		var body := move == "body_hook" or clip.contains("kidney")
		var own := RangeTable.on and RangeTable.kind(clip) != "body"
		if own:
			st.aim({"phase": "pocket", "who": 0, "move": move, "clip": clip})
		for i in 2:
			st.boxers[i]["pos"] = home[i]
			if own:
				var line: Vector3 = (home[1] as Vector3) - (home[0] as Vector3)
				line.y = 0.0
				st.boxers[i]["pos"] = (home[0] + home[1]) * 0.5 + line.normalized() * float(st.feet.want_m) * (0.5 if i == 1 else -0.5)
			st.boxers[i]["vel"] = Vector3.ZERO
			st.guard(i)
		for i in 45:
			await process_frame
		var sp := BeatClips.speed(clip, move)
		var c := BeatClips.contact(clip, float(Stage.CONTACT.get(move, Stage.CONTACT_S)))
		# POWER1 step 3: as BeatFire plays it now - from the punch's start, its drive armed (PunchPace), the hit's timer at
		# the screen time the drive gives (`-- nofastdrive`: start 0, flat pace, c / sp as before).
		var pp := PunchPace.plan(clip, move, c)
		var at := PunchPace.real(pp, float(pp["start"]), c) - PunchPace.lead()
		var hand: String = st.hand_of(0, str(BeatClips.contact_row(clip).get("hand", "RightHand")))
		if not st.play(0, clip, sp, float(pp["start"])):
			_check(false, "PLAY %s did not start" % clip)
			continue
		PunchPace.arm(st, 0, pp)
		var pid := int(st.boxers[0]["play_id"])
		if not OS.get_cmdline_user_args().has("noland"):
			st.land(0, clip, body, 0.0 if OS.get_cmdline_user_args().has("noclose") else at, c)
		if show:
			var hd := []
			for k in 2:
				var sk: Skeleton3D = st.boxers[k]["skel"]
				hd.append(sk.global_transform * sk.get_bone_global_pose(sk.find_bone("Head")).origin)
			print("  start: heads %.3f m apart, node pos %s / %s, fwd %s / %s, south %s / %s, lead glove to her face %.3f, rear %.3f" % [
				(hd[0] as Vector3).distance_to(hd[1]), (st.boxers[0]["node"] as Node3D).global_position, (st.boxers[1]["node"] as Node3D).global_position,
				(st.boxers[0]["node"] as Node3D).global_transform.basis.z, (st.boxers[1]["node"] as Node3D).global_transform.basis.z,
				st.boxers[0].get("south"), st.boxers[1].get("south"), st.glove_front(0, "LeftHand").distance_to(st.target_point(1, false)),
				st.glove_front(0, "RightHand").distance_to(st.target_point(1, false))])
			var gc1: Node = st.boxers[1].get("gclear")
			print("  her face point %s, her animated head %s, shown head %s" % [st.target_point(1, false), hd[1], gc1.get("shown_head") if gc1 != null else null])
			print("  land: gap shown %.3f, stage gap %.3f, lunge %.3f, move_left %.3f, vel %s" % [st._gap_shown(), st.gap_m,
				float(st.boxers[0]["reach"].get("lunge_m")), float(st.boxers[0]["move_left"]), str(st.boxers[0]["vel"])])
		var react := BeatClips.react(move, false, st.has_move, 0.5, false)
		_hit_i = -1
		_n = 0
		var tm := create_timer(at)
		tm.timeout.connect(st.hit.bind(1, react, BeatClips.speed(react, ""), 0, move, false, pid))
		tm.timeout.connect(_on_hit)
		var g: Array = []
		var f: Array = []
		var dbg: Array = []
		var fw: Array = []
		var dts: Array = []
		var frames := int((at + AFTER_S) * HZ) + 4
		for i in frames:
			await process_frame
			g.append(st.glove_front(0, hand))
			f.append(RangeTable.aim(st, 1, body, clip) if own else st.target_point(1, body))
			fw.append((st.boxers[0]["node"] as Node3D).global_transform.basis.z.normalized())
			dts.append(clampf(st.get_process_delta_time(), 0.004, 0.1))
			var rc: Node = st.boxers[0]["reach"]
			var apx: AnimationPlayer = st.boxers[0]["ap"]
			dbg.append([rc.get("_aim_w"), float(rc.get("last_weight")), apx.current_animation_position, apx.speed_scale, str(apx.assigned_animation), rc.get("_prev_g"), float(rc.get("_peak_v")), rc.get("_hit_w"), rc.get("_dir_w"), int(rc.get("_hit_f")), int(rc.get("_key"))])
			_n += 1
		var ci := _hit_i
		if ci < 1 or ci >= g.size() - 2:
			_check(false, "HIT %s: the hit never fired inside the run (frame %d of %d)" % [clip, ci, g.size()])
			continue
		# Per frame: how far the drawn glove moved, as metres per 1/60 s (the frame's own length read off the stage).
		var step: Array = [0.0]
		for i in range(1, g.size()):
			step.append((g[i] as Vector3).distance_to(g[i - 1]) / float(dts[i]) / HZ)
		var peak := 0.0
		for i in range(maxi(1, ci - int(BEFORE_S * HZ)), ci + 1):
			peak = maxf(peak, float(step[i]))
		var share := float(step[ci]) / peak if peak > 0.0 else 0.0
		var dir: Vector3 = ((g[ci] as Vector3) - (g[ci - 1] as Vector3)).normalized()
		var along: Array = []
		for i in g.size():
			along.append(((g[i] as Vector3) - (g[ci] as Vector3)).dot(dir))
		# The window: from the hit until she is WINDOW_BACK_M behind the hit point on her way home (or the run ends).
		# POWER1D S457 (contract): an uppercut arrives UPWARD, and after the stage hands her back to her guard its glove goes
		# up and back to the guard - along the arrival line that RETURN reads as more carry (S456: 0.15-0.26 m, top at
		# +383-500 ms). For an uppercut the window also ends on the first frame the punch's clip is no longer the one shown
		# (the hand-back to guard); its carry up to then is read exactly as for every other punch.
		var upper := clip.contains("uppercut")
		var end := g.size() - 1
		for i in range(ci + 1, g.size()):
			if float(along[i]) < -WINDOW_BACK_M or (upper and str(dbg[i][4]) != clip):
				end = i
				break
		var top := ci
		for i in range(ci, end + 1):
			if float(along[i]) > float(along[top]):
				top = i
		var carry := float(along[top])
		var big_step := 0.0
		for i in range(ci + 1, top + 1):
			big_step = maxf(big_step, float(step[i]))
		var turns := 0
		var last := 0
		for i in range(ci + 1, end + 1):
			var d := float(along[i]) - float(along[i - 1])
			if absf(d) < NOISE_M:
				continue
			var sgn := 1 if d > 0.0 else -1
			if last != 0 and sgn != last:
				turns += 1
			last = sgn
		var miss := (g[ci] as Vector3).distance_to(f[ci])
		carries.append(carry)
		if show:
			for i in range(maxi(1, ci - 8), end + 1):
				var aw: Vector3 = dbg[i][0]
				print("  %+4.0f ms  step %.3f m  along %+.3f m  face %.3f m  past %+.3f | dt %.1f ms aim-along %+.3f w %.2f clip %s t %.3f x%.2f clipglove-face %.3f clip-along %+.3f face-moved %.3f v %.2f hit %s dir %s hf %d key %d" % [
					1000.0 * (i - ci) / HZ, step[i], along[i], (g[i] as Vector3).distance_to(f[i]), ((g[i] as Vector3) - (f[i] as Vector3)).dot(fw[i]), 1000.0 * float(dts[i]),
					(aw - (g[ci] as Vector3)).dot(dir) if aw.is_finite() else -9.0, dbg[i][1], str(dbg[i][4]).trim_prefix("pro_"), dbg[i][2], dbg[i][3], (dbg[i][5] as Vector3).distance_to(f[i]) if (dbg[i][5] as Vector3).is_finite() else -1.0,
					((dbg[i][5] as Vector3) - (g[ci] as Vector3)).dot(dir) if (dbg[i][5] as Vector3).is_finite() else -9.0, (f[i] as Vector3).distance_to(f[ci]), dbg[i][6], dbg[i][7], dbg[i][8], dbg[i][9], dbg[i][10]])
		print("ROW %s x%.2f: peak %.3f m/frame, on the hit frame %.0f%%, on her %.3f m, carry %.3f m (top at %+.0f ms), biggest carry step %.3f m, turns %d" % [
			clip, sp, peak, 100.0 * share, miss, carry, 1000.0 * (top - ci) / HZ, big_step, turns])
		_check(share >= SHARE_MIN, "SPEED %s: arrives at %.0f%% of its top speed (bar %.0f%%)" % [clip, 100.0 * share, 100.0 * SHARE_MIN])
		_check(miss <= ON_M, "ON %s: the glove front meets her %.3f m off on the hit frame (bar %.2f)" % [clip, miss, ON_M])
		_check(carry >= THROUGH_M.x and carry <= THROUGH_M.y, "CARRY %s: goes %.3f m on past the hit point as drawn (bar %.2f-%.2f)" % [clip, carry, THROUGH_M.x, THROUGH_M.y])
		_check(big_step <= STEP_M, "SMOOTH %s: its biggest move in one frame while carrying through is %.3f m (bar %.2f)" % [clip, big_step, STEP_M])
		_check(turns <= 1, "SMOOTH %s: changes direction %d times between the hit and its way home (bar 1: out, then back)" % [clip, turns])
		if clip == upto:
			upto = "-"
		st.boxers[0]["reach"].disarm()
		for i in 90:
			await process_frame
	carries.sort()
	if not carries.is_empty():
		print("HIT_CARRY %d punches, carry as drawn: lowest %.3f, median %.3f, highest %.3f m" % [carries.size(), carries[0],
			carries[carries.size() / 2], carries[-1]])
	print("HIT_CARRY failures=%d" % failures)
	quit(1 if failures > 0 else 0)
