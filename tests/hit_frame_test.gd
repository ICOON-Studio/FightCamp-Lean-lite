extends SceneTree
## POWER1 step 2 (owner S439: "the punches do not feellike the y have power"; ops/research/CROSS_POWER_S439.md: the hit
## fired on the frame the glove had stopped, 3-6 frames after its fastest moment, and PunchReach eased it to a stop on the
## face). The ruler: for every punch the fight can land (BeatClips.punch over every context and roll, the takes the game
## really picks), with the game's real arm solve (FightStage.land arms PunchReach as the fight does; the reach is solved on
## the clip's own pose frame by frame at 60 Hz, clip time):
##   SPEED    the glove front's speed arriving on the contact frame (the frame BeatClips.contact names: the thud, the
##            freeze, the head snap) as a share of its top speed over the 0.30 s before it: at least SHARE_MIN.
##   THROUGH  after contact the glove front carries on past where it met the face, along the way it arrived, by THROUGH_M
##            (0.05-0.11 m; a shipped game's punches keep moving 0.08-0.5 s after contact, real crosses carry ~11 cm)
##            before it returns (read up to the first frame it stops going further along that line).
##   ON       the glove front still meets the face at contact: within ON_M of the face point (the hit lands).
## Two DIFFERENT bodies (mh_boxer_02 against mh_boxer_03), staged at the fight's gap. 3D only: no rule is read or changed.
## Run: <godot> --headless --audio-driver Dummy --path . --script res://tests/hit_frame_test.gd

const Stage := preload("res://scripts/fight3d/FightStage.gd")
const BeatClips := preload("res://scripts/fight3d/BeatClips.gd")
const PR := preload("res://scripts/fight3d/PunchReach.gd")
## POWER1 step 4 (each punch from its own distance): with it on the fight no longer throws every punch from the jab gap; each
## punch here is staged at its own (RangeTable.clip_m, which the fight's footwork and carry bring the pair to) and aimed
## where the fight aims it (RangeTable.aim: an uppercut at her chin). `-- nopunchrange` = the jab gap and her face, as before.
const RangeTable := preload("res://scripts/fight3d/RangeTable.gd")
const HZ := 60.0
const BEFORE_S := 0.30
const AFTER_S := 0.20
const SHARE_MIN := 0.5
const THROUGH_M := Vector2(0.05, 0.11)
const ON_M := 0.05
const ROLLS := [0.0, 0.3, 0.55, 0.8, 0.99]

var failures := 0
var st: Node3D
var skel: Skeleton3D
var ap: AnimationPlayer
var reach: Node
var front := 0.15


func _check(ok: bool, what: String) -> void:
	if not ok:
		failures += 1
	print(("PASS " if ok else "FAIL ") + what)


## Every clip the fight can throw as a LANDED punch (a wide miss never lands; rokoko clips keep their own contact table).
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


func _glove(ids: Array) -> Vector3:
	var g := skel.global_transform
	var wrist: Vector3 = g * skel.get_bone_global_pose(int(ids[2])).origin
	var a: Vector3 = (g * skel.get_bone_global_pose(int(ids[3])).origin - wrist).normalized()
	var arm: Vector3 = (wrist - g * skel.get_bone_global_pose(int(ids[1])).origin).normalized()
	if PR.STRAIGHT > 0.0 and a.angle_to(arm) > 1e-3:
		a = a.slerp(arm, PR.STRAIGHT).normalized()
	return wrist + a * front * g.basis.get_scale().x


func _initialize() -> void:
	st = Stage.new()
	root.add_child(st)
	await process_frame
	st.setup({"glb": "res://assets/models/metahuman/mh_boxer_02.glb", "corner": "red"},
		{"glb": "res://assets/models/metahuman/mh_boxer_03.glb", "corner": "blue"})
	# Review round 1: her face where the game aims (FightStage.target_point rides on her SHOWN head, GloveClear.shown_head):
	# with the stage stopped straight after setup it read her raw head bone, 0.18-0.20 m behind the face the fight aims at
	# (hit_carry_test, the whole stage running). The stage runs her guard a second first, both guards held on their first frame
	# so every run reads the same face (tools/clip_contact.gd stages the same way).
	for b in st.boxers:
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
	front = float(bx.get("front", 0.15))
	_check(reach != null, "the landing reach (PunchReach) is on the body")
	if reach == null:
		print("HIT_FRAME failures=%d" % failures)
		quit(1)
		return
	var new_api: bool = reach.has_method("reach_at")
	print("HIT_FRAME gap %.3f m, front %.3f m, arm solve: %s" % [st.gap_m, front, "PunchReach.reach_at (drive through)" if new_api else "PunchReach.weight + _reach (today's)"])
	var shares: Array = []
	var home0: Vector3 = (bx["node"] as Node3D).global_position
	for pair in _fight_punches():
		var clip := str(pair[0])
		var move := str(pair[1])
		var body := move == "body_hook" or clip.contains("kidney") or clip.contains("body")
		var c := BeatClips.contact(clip, float(Stage.CONTACT.get(move, Stage.CONTACT_S)))
		var hand: String = st.hand_of(0, str(BeatClips.contact_row(clip).get("hand", "RightHand")))
		var ids := []
		for n in ["UpperArm", "LowerArm", "Hand", "MiddleProximal"]:
			ids.append(skel.find_bone(hand.trim_suffix("Hand") + n))
		var own := RangeTable.on and RangeTable.kind(clip) != "body"
		(bx["node"] as Node3D).global_position = home0
		if own:
			var n0: Node3D = bx["node"]
			var n1: Node3D = st.boxers[1]["node"]
			var line := n1.global_position - n0.global_position
			line.y = 0.0
			n0.global_position = n1.global_position - line.normalized() * RangeTable.clip_m(st, 0, clip)
		ap.play(clip, 0.0, 1.0)
		ap.seek(0.0, true)
		# Review round 1: her hips travel with the punch as the game plays it (PunchWeight, POWER1 step 1, first in the
		# stack; FightStage.play arms it). Without it every straight punch here was thrown from pinned hips, 5-10 cm
		# shorter than in the fight, and the reach could not hold the carry (off its aim by up to 0.3 m after contact).
		var pw: Node = bx.get("weight")
		if pw != null:
			pw.arm(clip)
		st.land(0, clip, body, 0.0, c)
		var target: Vector3 = RangeTable.aim(st, 1, body, clip) if own else st.target_point(1, body)
		var tgt := func() -> Vector3: return target
		var t0 := maxf(0.0, c - BEFORE_S)
		var n := int(round((minf(ap.get_animation(clip).length, c + AFTER_S) - t0) * HZ))
		var ci := int(round((c - t0) * HZ))
		var g: Array = []
		for i in n + 1:
			var t := t0 + i / HZ
			ap.seek(t, true)
			if pw != null:
				pw._process_modification()
			if new_api:
				reach.reach_at(t)
				reach.settle()   # GloveClear lands the glove again after the head clear, every frame of the stack
			else:
				var w := PR.weight(t, c)
				if w > 0.0:
					reach._reach(skel, hand, w, tgt, front)
			g.append(_glove(ids))
			if OS.get_cmdline_user_args().has("show=" + clip) and new_api:
				var aim: Vector3 = reach.get("_aim_w")
				print("  aim t=%.3f off-aim %.3f m, aim-face %.3f m" % [t, (g[-1] as Vector3).distance_to(aim) if aim.is_finite() else -1.0, aim.distance_to(target) if aim.is_finite() else -1.0])
		var spd: Array = [0.0]
		for i in range(1, g.size()):
			spd.append((g[i] as Vector3).distance_to(g[i - 1]) * HZ)
		var peak := 0.0
		for i in range(1, mini(ci, spd.size() - 1) + 1):
			peak = maxf(peak, float(spd[i]))
		var at_c: float = float(spd[ci]) if ci < spd.size() else 0.0
		var share := at_c / peak if peak > 0.0 else 0.0
		shares.append(share)
		var dir: Vector3 = ((g[ci] as Vector3) - (g[maxi(0, ci - 1)] as Vector3)).normalized()
		# Before it returns: the run of frames after contact on which the glove keeps going further along its arrival line.
		var past := 0.0
		for i in range(ci + 1, g.size()):
			var d: float = ((g[i] as Vector3) - (g[ci] as Vector3)).dot(dir)
			if d <= past:
				break
			past = d
		var miss: float = (g[ci] as Vector3).distance_to(target)
		if OS.get_cmdline_user_args().has("show=" + clip):   # `-- show=<clip>`: the frame table
			for i in g.size():
				print("  %+4.0f ms  %.2f m/s  along %+.3f m  face %.3f m" % [1000.0 * (i - ci) / HZ, spd[i],
					((g[i] as Vector3) - (g[ci] as Vector3)).dot(dir), (g[i] as Vector3).distance_to(target)])
		print("ROW %s contact %.3f s: peak %.2f m/s, at contact %.2f m/s (%.0f%%), through %.3f m, on the face %.3f m" % [
			clip, c, peak, at_c, 100.0 * share, past, miss])
		_check(share >= SHARE_MIN, "SPEED %s: the glove arrives at %.0f%% of its top speed (bar %.0f%%)" % [clip, 100.0 * share, 100.0 * SHARE_MIN])
		_check(past >= THROUGH_M.x and past <= THROUGH_M.y, "THROUGH %s: carries %.3f m past the contact (bar %.2f-%.2f)" % [clip, past, THROUGH_M.x, THROUGH_M.y])
		_check(miss <= ON_M, "ON %s: the glove meets the face %.3f m off at contact (bar %.2f)" % [clip, miss, ON_M])
		reach.disarm()
		reach.set("_fades", {})
	shares.sort()
	if not shares.is_empty():
		print("HIT_FRAME %d punches, share at contact: lowest %.2f, median %.2f, highest %.2f" % [shares.size(), shares[0], shares[shares.size() / 2], shares[-1]])
	print("HIT_FRAME failures=%d" % failures)
	quit(1 if failures > 0 else 0)
