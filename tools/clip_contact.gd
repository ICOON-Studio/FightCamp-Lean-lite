extends SceneTree
## When each punch clip lands, measured on the game's own bodies (the staged pair, FightStage.setup, at the fight's jab
## gap), sampled at 60 Hz. Writes res://assets/data/clip_contact.json {clip: {"contact_s", "hand", "reach_m", "length_s",
## "far_s", "peak_s", "in_reach"}} that BeatClips reads for hit timing. Headless:
##   <godot.exe> --headless --path . --script res://tools/clip_contact.gd -- [prefix=pro_]
##
## THE RULE (POWER1 step 2, S439). Until then contact was the frame the glove came CLOSEST to the head, which is the frame
## it has stopped: the thud, the freeze and the head snap all fired 3-6 frames after the glove's fastest moment
## (ops/research/CROSS_POWER_S439.md). Now:
##   far_s    the punch's furthest point: the old rule, unchanged (the punching WRIST closest to the head-height point
##            straight ahead at the gap, in the thrower's own frame; 0.5 m lower for a body shot; from GUARD_S to 75% of
##            the clip). It only anchors things: the search below, the punch ruler's window (punch_form.gd, jab_retime.gd)
##            and the stage's gap (FightStage._jab_gap) - those read what they read before.
##   peak_s   the frame of the GLOVE FRONT's top speed in the APPROACH_S before far_s. Glove front = the wrist plus the
##            glove's striking face along its axis (the point PunchReach lands); target = the OTHER boxer's face point
##            (FightStage.target_point, on her head as the stage SHOWS it; her ribs for a body or kidney shot), world space;
##            speed = central difference. (Review round 1: the speed TOWARD the target was the anchor; most clips pass her
##            face 0.1-0.5 m to its side, so that speed stayed small and the plain jab's "top" fell on its furthest point.)
##   contact  from the frame the glove first moves at MOVING of that top speed (its drive), the first frame at which the
##            glove front TOUCHES her (within TOUCH_M of the target), or - a jab or a cross - is level with her face (as
##            deep as her face point along the thrower's front, whatever its side: PunchReach carries the side), or comes
##            closest to her (the nearest it comes in the drive: a hook or an uppercut passing her face, or a glove
##            that stops short, which PunchReach drives in). Up to far_s. (the first frame its distance to the target stops
##            shrinking: a glove passing beside her face, or one that stops short). Measured with the hips' own forward
##            travel that the game puts back into every punch (PunchWeight, POWER1 step 1), so the glove is where the
##            game shows it. in_reach = the glove front came within TOUCH_M.
##            Review round 1 (S442 blind review, low): the rule was "the target within the arm's straight length plus the
##            lean from the shoulder", which is true at the fight's gap almost from the start of every punch, so the hit
##            fired one frame after the top speed wherever the glove was: the plain jab's glove had already gone 9-15 cm
##            past her face (beside her head) in the played fight, and PunchReach dragged it back onto the face.
## A punch whose contact reads 0 or whose glove travels (relative to her hips, start to contact) under TRAVEL_MIN_M FAILS
## the run: the table is not written and the tool exits 1 (pro_left_uppercut read contact 0 and travel 0 until S435).

const Stage := preload("res://scripts/fight3d/FightStage.gd")
const PR := preload("res://scripts/fight3d/PunchReach.gd")
const OUT := "res://assets/data/clip_contact.json"
## Clip names that throw a punch.
const PUNCH_WORDS := ["jab", "cross", "hook", "uppercut", "body_shot", "kidney_shot", "combo_punch", "combo_lh"]
const HZ := 60.0
const GUARD_S := 0.15   # BeatClips.contact reads anything earlier as the guard
const APPROACH_S := 0.30   # the drive: real first move to hit 0.22-0.50 s, the top speed 8-21 ms before it (G75, K54)
const TRAVEL_MIN_M := 0.05
const SETTLE_F := 60
const MOVING := 0.5     # the search starts once the glove moves at this share of its top speed (the drive, not the load)
const STRAIGHT_WORDS := ["jab", "cross"]   # a straight punch lands when it is level with her face, whatever its side
const TOUCH_M := 0.05   # the glove front this close to her face point is touching her (the ruler's ON bar, hit_frame_test)

var st: Node3D
var skel: Skeleton3D
var ap: AnimationPlayer
var scale := 1.0
var front := 0.15


func _initialize() -> void:
	var prefix := "pro_"
	for a in OS.get_cmdline_user_args():
		if str(a).begins_with("prefix="):
			prefix = str(a).substr(7)
	st = Stage.new()
	root.add_child(st)
	await process_frame
	st.setup({"glb": "res://assets/models/metahuman/mh_boxer_10.glb", "corner": "red"},
		{"glb": "res://assets/models/metahuman/mh_boxer_11.glb", "corner": "blue"})
	# Review round 1: her face where the game shows it. The face point rides on her SHOWN head (GloveClear.shown_head,
	# after the stage's corrections lean her into her guard): read straight after setup, with nothing run yet, it was her
	# raw head bone, 0.18-0.20 m further back than the face the fight aims at (hit_carry_test, mh_boxer_12 v 07), so every
	# straight punch passed the real face long before this table's contact. The stage runs its guard a second first, both
	# guards held on one frame (their first) so the face it settles on is the same on every run.
	for b in st.boxers:
		var apb: AnimationPlayer = b["ap"]
		apb.seek(0.0, true)
		apb.pause()
	for i in SETTLE_F:
		await process_frame
	st.set_process(false)
	var bx: Dictionary = st.boxers[0]
	skel = bx["skel"]
	ap = bx["ap"]
	scale = (bx["node"] as Node3D).scale.x
	front = float(bx.get("front", 0.15))
	var faces := [st.target_point(1, false), st.target_point(1, true)]
	print("CONTACT staged pair: gap %.3f m, glove front %.3f m, face %s, ribs %s" % [st.gap_m, front, faces[0], faces[1]])
	# S435 (ANIM_AUDIT_S435 A5): this tool rewrote the whole file and dropped the keys other tools store in a row
	# (punch_reach.gd's short_m, gone since S342). A re-run now keeps every key it does not measure itself.
	var old: Dictionary = {}
	if FileAccess.file_exists(OUT):
		var parsed: Variant = JSON.parse_string(FileAccess.get_file_as_string(OUT))
		old = parsed if parsed is Dictionary else {}
	var out := {}
	var bad: Array = []
	var earlier: Array = []
	for n in ap.get_animation_list():
		var name := str(n)
		if not name.begins_with(prefix) or name.contains("hit_by") or not PUNCH_WORDS.any(func(w): return name.contains(w)):
			continue
		var length: float = ap.get_animation(name).length
		if bx.get("weight") != null:
			(bx["weight"] as Node).arm(name)   # her hips' own travel (PunchWeight.forward_at), as the game plays it
		var hands: Array = ["LeftHand"] if name.contains("left_") or name.contains("kidney") else (["RightHand"] if name.contains("right_") else ["LeftHand", "RightHand"])
		var body := name.contains("body") or name.contains("kidney")
		var far: Array = _legacy_far(bx, name, hands, body, length)
		var m := _measure(name, str(far[1]), faces[1 if body else 0], float(far[0]))
		var row := {"contact_s": snappedf(float(m["contact"]), 0.001), "hand": far[1], "reach_m": snappedf(float(m["miss"]), 0.001),
			"length_s": snappedf(length, 0.001), "far_s": snappedf(float(far[0]), 0.001), "peak_s": snappedf(float(m["peak"]), 0.001),
			"in_reach": m["in_reach"]}
		var kept: Variant = old.get(name, null)
		if kept is Dictionary:
			for k in (kept as Dictionary):
				if not row.has(k):
					row[k] = kept[k]
		out[name] = row
		earlier.append(float(far[0]) - float(m["contact"]))
		print("CONTACT %s %.3fs (furthest %.3f, %.0f ms earlier; top speed toward her %.2f m/s at %.3f%s) %s %.3f m off, travel %.2f m (len %.2fs)" % [
			name, m["contact"], far[0], 1000.0 * (float(far[0]) - float(m["contact"])), m["peak_v"], m["peak"],
			"" if bool(m["in_reach"]) else (", closest approach (never within %.2f m)" % TOUCH_M), far[1], m["miss"], m["travel"], length])
		print("CONTACT_PAST %s %+.3f m (+ = past her face point, along her front), %.3f m to its side" % [name, m["past"], m["side"]])
		if float(m["contact"]) <= 0.0 or float(m["travel"]) < TRAVEL_MIN_M:
			bad.append("%s contact %.3f s travel %.3f m" % [name, m["contact"], m["travel"]])
	if not bad.is_empty():
		for b in bad:
			print("CONTACT FAIL a punch reads 0: %s (nothing written)" % b)
		quit(1)
		return
	earlier.sort()
	if not earlier.is_empty():
		print("CONTACT the hit before the furthest point: lowest %.0f ms, median %.0f ms, highest %.0f ms" % [1000.0 * float(earlier[0]),
			1000.0 * float(earlier[earlier.size() / 2]), 1000.0 * float(earlier[-1])])
	var f := FileAccess.open(OUT, FileAccess.WRITE)
	f.store_string(JSON.stringify(out, "\t", true))
	f.close()
	print("CONTACT DONE %d clips -> %s" % [out.size(), OUT])
	quit(0)


## The rule's peak_s and contact for `hand` on `clip` against `target` (world), searched in the approach to far_t.
func _measure(clip: String, hand: String, target: Vector3, far_t: float) -> Dictionary:
	var side := hand.trim_suffix("Hand")
	var ids := [skel.find_bone(side + "UpperArm"), skel.find_bone(side + "LowerArm"), skel.find_bone(hand),
		skel.find_bone(side + "MiddleProximal")]
	var hips := skel.find_bone("Hips")
	var pw: Node = st.boxers[0].get("weight")
	var fwd: Vector3 = (st.boxers[0]["node"] as Node3D).global_transform.basis.z.normalized()
	var far := int(round(far_t * HZ))
	var g: Array = []
	var rel: Array = []
	for i in far + 2:
		ap.play(clip)
		ap.seek(i / HZ, true)
		var w := skel.global_transform
		var p := [w * skel.get_bone_global_pose(int(ids[1])).origin, w * skel.get_bone_global_pose(int(ids[2])).origin,
			w * skel.get_bone_global_pose(int(ids[3])).origin]
		var axis: Vector3 = ((p[2] as Vector3) - (p[1] as Vector3)).normalized()
		var fore: Vector3 = ((p[1] as Vector3) - (p[0] as Vector3)).normalized()
		if PR.STRAIGHT > 0.0 and axis.angle_to(fore) > 1e-3:
			axis = axis.slerp(fore, PR.STRAIGHT).normalized()
		var gf: Vector3 = (p[1] as Vector3) + axis * front * scale
		rel.append(gf - w * skel.get_bone_global_pose(hips).origin)
		g.append(gf + fwd * (float(pw.call("forward_at", i / HZ)) if pw != null else 0.0))
	var from := maxi(int(ceil(GUARD_S * HZ)), far - int(round(APPROACH_S * HZ)))
	var spd: Array = []
	for i in far + 1:
		spd.append(((g[i + 1] as Vector3) - (g[maxi(i - 1, 0)] as Vector3)).length() * HZ / float(i + 1 - maxi(i - 1, 0)))
	var peak := from
	var peak_v := -INF
	for i in range(from, far + 1):
		if float(spd[i]) > peak_v:
			peak_v = float(spd[i])
			peak = i
	var straight := STRAIGHT_WORDS.any(func(w): return clip.contains(str(w)))
	var hit := -1
	var in_reach := false
	var start := -1
	var near := far
	for i in range(from, far + 1):
		if start < 0 and float(spd[i]) >= MOVING * peak_v:
			start = i
		if start < 0:
			continue
		var off: Vector3 = (g[i] as Vector3) - target
		if hit < 0 and (off.length() <= TOUCH_M or (straight and off.dot(fwd) >= 0.0)):
			hit = i
			in_reach = true
		if off.length() < (g[near] as Vector3).distance_to(target) or near == far:
			near = i if off.length() < (g[near] as Vector3).distance_to(target) else near
	if hit < 0:
		hit = near
	var travel := 0.0
	for i in range(1, hit + 1):
		travel += (rel[i] as Vector3).distance_to(rel[i - 1])
	return {"contact": hit / HZ, "peak": peak / HZ, "peak_v": peak_v, "in_reach": in_reach,
		"miss": (g[hit] as Vector3).distance_to(target), "travel": travel,
		"past": ((g[hit] as Vector3) - target).dot(fwd), "side": (((g[hit] as Vector3) - target) - fwd * ((g[hit] as Vector3) - target).dot(fwd)).length()}


## far_s: the rule contact used until S439, exactly as it was (the punching wrist's closest moment to the head-height point
## straight ahead at the gap, in the thrower's own frame; body shots 0.5 m lower), so what is anchored on it stays put.
## [seconds, hand]
func _legacy_far(bx: Dictionary, name: String, hands: Array, body: bool, length: float) -> Array:
	var head_y: float = Stage.IdleMatch.pose_point(bx, name, 0.0, "Head").y
	var target := Vector3(0.0, head_y - (0.5 if body else 0.0), st.gap_m)
	var best := [0.0, str(hands[0])]
	var best_miss := 99.0
	var t := GUARD_S
	while t <= length * 0.75:
		for hand in hands:
			var miss: float = Stage.IdleMatch.pose_point(bx, name, t, str(hand)).distance_to(target)
			if miss < best_miss:
				best_miss = miss
				best = [t, str(hand)]
		t += 1.0 / HZ
	return best
