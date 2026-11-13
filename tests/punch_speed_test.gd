extends SceneTree
## POWER1 step 3 (owner S439: "the punches do not feellike the y have power"; CROSS_POWER_S439.md: the glove's striking
## face tops out at 4.4-5.4 m/s where real crosses run 6-11.5; CLIP_CRITICS_S439.md: 0.3-0.7 s of near-stillness before the
## hand moves on the plain jab, cross a, cross b, the right hook and the right uppercut). The ruler, per punch the fight can
## throw (BeatClips.punch over every context and roll), played the way the game plays it on screen: from its start offset,
## at its pace (BeatClips.speed), 60 frames a second, the game's real arm solve on a landed punch (PunchPace.arm, then
## PunchReach armed by FightStage.land with its drive - review round 2: the glove alone, ReachDrive - the hips' travel by
## PunchWeight, the stack's settle()):
##   SPEED  the glove front's top speed on screen up to the contact is in its band: SPEED_BAND (jab 6-8, cross and hooks
##          7-9 m/s; uppercuts and the body shot are not sped and have no band). Speed = what the glove covers in two frames
##          (33 ms) a second: a one-frame read alternates by 1-2 m/s as the reach solve lands, and its top was a spike.
##   FIRST  the hand moves within FIRST_S of the punch starting: counting back from the glove's top speed, the frame after
##          the last one under MOVE_SHARE of it (the start rule of CROSS_POWER_S439.md).
##   POP    no bone's worst one-frame step is more than POP_X times its worst step in the punch as played before step 3
##          (from clip 0 at the pace, its recovery played fast the way HitImpact.recover plays it, to back in guard); a bone
##          whose old worst step is under POP_FLOOR_M is compared with that floor.
##   SYNC   played live as BeatFire plays it, the clip is on its contact when the hit's timer fires (see _sync).
## Review round 2: a JOIN check (played live from her guard through the join smoother, each bone's top speed against the
## punch started at 0) was built and dropped: it read up to 4.4x on punches whose start did not change (feet and the
## other hand from the footwork and guard life, run to run, even with the guard seeded). The ROW line also prints the
## worst step OUTSIDE the punching arm (the drive moves that arm faster on purpose; POP still counts every bone).
## Two DIFFERENT bodies (mh_boxer_02 against mh_boxer_03), at the fight's gap. 3D only: no rule is read or changed.
## Run: <godot> --headless --audio-driver Dummy --path . --script res://tests/punch_speed_test.gd   (-- nofastdrive = control)

const Stage := preload("res://scripts/fight3d/FightStage.gd")
const BeatClips := preload("res://scripts/fight3d/BeatClips.gd")
const PR := preload("res://scripts/fight3d/PunchReach.gd")
const PACE_PATH := "res://scripts/fight3d/PunchPace.gd"
const HZ := 60.0
const SPEED_BAND := {"jab": Vector2(6.0, 8.0), "cross": Vector2(7.0, 9.0), "lead_hook": Vector2(7.0, 9.0), "rear_hook": Vector2(7.0, 9.0)}
const FIRST_S := 0.13
const MOVE_SHARE := 0.15
const POP_X := 1.5
const POP_FLOOR_M := 0.005
const RECOVER_RAMP_S := 0.05   # HitImpact.RECOVER_RAMP_S
const ROLLS := [0.0, 0.3, 0.55, 0.8, 0.99]
const BONES := ["Hips", "Spine", "Chest", "Neck", "Head", "LeftShoulder", "RightShoulder", "LeftUpperArm", "RightUpperArm",
	"LeftLowerArm", "RightLowerArm", "LeftHand", "RightHand", "LeftUpperLeg", "RightUpperLeg", "LeftLowerLeg", "RightLowerLeg",
	"LeftFoot", "RightFoot"]

var failures := 0
var st: Node3D
var skel: Skeleton3D
var ap: AnimationPlayer
var reach: Node
var pw: Node
var front := 0.15
var pace: Script = null


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


## The punch's plan: today's (start 0, flat pace) or PunchPace's.
func _plan(clip: String, move: String, new: bool) -> Dictionary:
	if new and pace != null:
		return pace.call("plan", clip, move)
	return {"clip": clip, "start": 0.0, "v": 0.0, "sp": BeatClips.speed(clip, move), "c": BeatClips.contact(clip, float(Stage.CONTACT.get(move, Stage.CONTACT_S)))}


func _glove(ids: Array) -> Vector3:
	var g := skel.global_transform
	var wrist: Vector3 = g * skel.get_bone_global_pose(int(ids[2])).origin
	var a: Vector3 = (g * skel.get_bone_global_pose(int(ids[3])).origin - wrist).normalized()
	var arm: Vector3 = (wrist - g * skel.get_bone_global_pose(int(ids[1])).origin).normalized()
	if PR.STRAIGHT > 0.0 and a.angle_to(arm) > 1e-3:
		a = a.slerp(arm, PR.STRAIGHT).normalized()
	return wrist + a * front * g.basis.get_scale().x


## Plays `clip` on screen frames as the game would under plan `p`; returns {glove: [world], bones: [[world]], t: [clip s], ci}.
func _play(clip: String, move: String, p: Dictionary, bone_ids: Array) -> Dictionary:
	var body := move == "body_hook" or clip.contains("kidney") or clip.contains("body")
	var c := float(p["c"])
	var hand: String = st.hand_of(0, str(BeatClips.contact_row(clip).get("hand", "RightHand")))
	var ids := []
	for n in ["UpperArm", "LowerArm", "Hand", "MiddleProximal"]:
		ids.append(skel.find_bone(hand.trim_suffix("Hand") + n))
	ap.play(clip, 0.0, 1.0)
	ap.seek(float(p["start"]), true)
	if pace != null:
		pace.call("arm", st, 0, p)   # the drive the reach takes (none on the old plan: v 0)
	else:
		reach.set("drive_for", [])
	if pw != null:
		pw.arm(clip)
	st.land(0, clip, body, 0.0, c)
	# The punch to back in guard, its recovery fast from BeatClips.recovery's start (as HitImpact.recover).
	var rec := BeatClips.recovery(clip)
	var scale := BeatClips.recover_scale(clip, float(p["sp"]))
	var end := ap.get_animation(clip).length
	if rec.y > rec.x and rec.x >= 0.15:
		end = minf(end, rec.y)
	var t := float(p["start"])
	var ss := 1.0
	var out := {"glove": [], "bones": [], "t": [], "ci": -1}
	while t <= end + 1e-6:
		ap.seek(t, true)
		if pw != null:
			pw._process_modification()
		reach.reach_at(t)
		reach.settle()
		(out["glove"] as Array).append(_glove(ids))
		var bs: Array = []
		for b in bone_ids:
			bs.append(skel.global_transform * skel.get_bone_global_pose(int(b)).origin)
		(out["bones"] as Array).append(bs)
		(out["t"] as Array).append(t)
		if rec.x >= 0.15 and t >= rec.x and ss < scale:
			ss = minf(scale, ss + scale / HZ / RECOVER_RAMP_S)
		var nt := t + float(p["sp"]) * ss / HZ
		if int(out["ci"]) < 0 and nt >= c - 1e-6:
			out["ci"] = (out["t"] as Array).size()   # the first frame at or past the contact
		t = nt
	reach.disarm()
	reach.set("_fades", {})
	reach.set("drive_for", [])
	return out


## SYNC: the punch played live the way BeatFire plays it (FightStage.play from its start, PunchPace.arm, the stage
## running at 60 frames a second): when the hit's timer fires (the screen time BeatFire gives it), the clip is short of its
## contact by at most two frames and never past it (PunchPace.LEAD_S: HitImpact.hit then puts it on its contact, so the hit
## frame still draws the glove moving).
func _sync() -> void:
	Engine.max_fps = 60
	st.set_process(true)
	for pair in _fight_punches():
		var clip := str(pair[0])
		var move := str(pair[1])
		var p := _plan(clip, move, true)
		var at := float(pace.call("real", p, float(p["start"]), float(p["c"]))) - float(pace.call("lead")) if pace != null else (float(p["c"]) - float(p["start"])) / float(p["sp"])
		st.guard(0)
		for i in 10:
			await process_frame
		if not st.play(0, clip, float(p["sp"]), float(p["start"])):
			_check(false, "SYNC %s: the stage refused the punch" % clip)
			continue
		if pace != null:
			pace.call("arm", st, 0, p)
		await create_timer(at).timeout
		var pos := ap.current_animation_position
		var fr := float(p["sp"]) / 60.0
		var short := float(p["c"]) - pos
		_check(str(ap.current_animation) == clip and short >= -0.002 and short <= 2.0 * fr + 0.002, "SYNC %s: at the hit's timer (%.3f s) the clip is at %.3f s, %.3f short of its contact %.3f (bar: never past it, at most two frames, %.3f, short)" % [
			clip, at, pos, short, float(p["c"]), 2.0 * fr])
	st.set_process(false)


## Speed into each frame: what the glove covered over the last two frames, a second (the first frame: one).
func _speeds(g: Array) -> Array:
	var out: Array = [0.0]
	for i in range(1, g.size()):
		var k := mini(i, 2)
		out.append((g[i] as Vector3).distance_to(g[i - k]) * HZ / k)
	return out


func _initialize() -> void:
	if ResourceLoader.exists(PACE_PATH):
		pace = load(PACE_PATH)
	st = Stage.new()
	root.add_child(st)
	await process_frame
	st.setup({"glb": "res://assets/models/metahuman/mh_boxer_02.glb", "corner": "red"},
		{"glb": "res://assets/models/metahuman/mh_boxer_03.glb", "corner": "blue"})
	for b in st.boxers:   # her face where the game aims (the stage runs a second, guards held: hit_frame_test)
		var apb: AnimationPlayer = b["ap"]
		apb.seek(0.0, true)
		apb.pause()
	for i in 60:
		await process_frame
	st.set_process(false)
	await process_frame
	var bx: Dictionary = st.boxers[0]
	skel = bx["skel"]
	ap = bx["ap"]
	reach = bx.get("reach")
	pw = bx.get("weight")
	front = float(bx.get("front", 0.15))
	_check(reach != null, "the landing reach (PunchReach) is on the body")
	var on: bool = pace != null and bool(pace.call("is_on"))
	print("PUNCH_SPEED drive: %s" % ("PunchPace (step 3, the glove's drive: ReachDrive)" if on else ("PunchPace OFF (-- nofastdrive)" if pace != null else "none (today's flat pace)")))
	var bone_ids: Array = []
	for n in BONES:
		var id := skel.find_bone(str(n))
		if id >= 0:
			bone_ids.append(id)
	for pair in _fight_punches():
		var clip := str(pair[0])
		var move := str(pair[1])
		var p := _plan(clip, move, true)
		var old := _play(clip, move, _plan(clip, move, false), bone_ids)
		var now := _play(clip, move, p, bone_ids)
		var g: Array = now["glove"]
		var ci := int(now["ci"]) if int(now["ci"]) > 0 else g.size() - 1
		var spd := _speeds(g)
		var top := 0.0
		var top_i := 0
		for i in range(1, mini(ci, spd.size() - 1) + 1):
			if float(spd[i]) > top:
				top = float(spd[i])
				top_i = i
		# Where the punch starts: counting back from its top speed, the frame after the last one under MOVE_SHARE of it (the
		# rule of CROSS_POWER_S439.md). A forward scan read the wind-up's slow drift as the hand moving (the plain jab 0.050 s
		# on today's code, where the critics timed 6 tiles of wind-up).
		var first := 1
		for i in range(top_i, 0, -1):
			if float(spd[i]) < MOVE_SHARE * top:
				first = i + 1
				break
		var first_s := (first - 1) / HZ if first > 0 else INF   # the step into frame i happens during screen frame i-1 -> i
		# POP: per bone, worst one-frame step now against before.
		var worst_x := 0.0
		var worst_b := ""
		var body_x := 0.0   # outside the punching arm (shoulder to hand)
		var side := str(st.hand_of(0, str(BeatClips.contact_row(clip).get("hand", "RightHand")))).trim_suffix("Hand")
		for k in bone_ids.size():
			var w_old := POP_FLOOR_M
			var w_new := 0.0
			var ob: Array = old["bones"]
			var nb: Array = now["bones"]
			for i in range(1, ob.size()):
				w_old = maxf(w_old, ((ob[i] as Array)[k] as Vector3).distance_to((ob[i - 1] as Array)[k]))
			for i in range(1, nb.size()):
				w_new = maxf(w_new, ((nb[i] as Array)[k] as Vector3).distance_to((nb[i - 1] as Array)[k]))
			if w_new / w_old > worst_x:
				worst_x = w_new / w_old
				worst_b = skel.get_bone_name(int(bone_ids[k]))
			if not skel.get_bone_name(int(bone_ids[k])).begins_with(side) or skel.get_bone_name(int(bone_ids[k])).contains("Leg") or skel.get_bone_name(int(bone_ids[k])).contains("Foot"):
				body_x = maxf(body_x, w_new / w_old)
		if OS.get_cmdline_user_args().has("show=" + clip):   # `-- show=<clip>`: the frame tables, before and now
			for run in [old, now]:
				var rg: Array = run["glove"]
				for i in range(1, rg.size()):
					print("  %s f%02d t=%.3f %s %.2f m/s" % ["old" if run == old else "now", i, float((run["t"] as Array)[i]),
						"C" if i == int(run["ci"]) else " ", (rg[i] as Vector3).distance_to(rg[i - 1]) * HZ])
		var ospd := _speeds(old["glove"])
		var old_top := 0.0
		for i in range(1, mini(int(old["ci"]) if int(old["ci"]) > 0 else ospd.size() - 1, ospd.size() - 1) + 1):
			old_top = maxf(old_top, float(ospd[i]))
		print("ROW %s (%s) start %.3f pace %.2fx drive onto her %.0f m/s contact %.3f: top %.2f m/s (before %.2f) at %+.0f ms, hand moves at %.3f s, worst step %.2fx (%s), outside the punching arm %.2fx" % [
			clip, move, float(p["start"]), float(p["sp"]), float(p.get("v", 0.0)), float(p["c"]), top, old_top,
			1000.0 * (top_i - ci) / HZ, first_s, worst_x, worst_b, body_x])
		if SPEED_BAND.has(move):
			var band: Vector2 = SPEED_BAND[move]
			_check(top >= band.x and top <= band.y, "SPEED %s: glove top %.2f m/s on screen (band %.0f-%.0f)" % [clip, top, band.x, band.y])
		_check(first_s <= FIRST_S + 1e-4, "FIRST %s: the hand moves %.3f s after the punch starts (bar %.2f)" % [clip, first_s, FIRST_S])
		_check(worst_x <= POP_X, "POP %s: worst bone step %.2fx the old punch's (%s, bar %.1fx)" % [clip, worst_x, worst_b, POP_X])
	await _sync()
	print("PUNCH_SPEED failures=%d" % failures)
	quit(1 if failures > 0 else 0)
