extends SceneTree
## FIGHTPLAYER2 phase 3: the v2 player's rulers, headless (no picture needed: clips, bones and the kept layers run).
## Two DIFFERENT bodies play real RoundScript exchanges through Player2 at 60 frames a second; every frame is read AS
## DRAWN (after every modifier). Bars from the scope (section 5 + 8) and the r14 critics:
##   LANDS    a landed punch's glove front is within ON_M of the face (ribs) on its contact frame (median, worst)
##   SHORT    a missed punch's glove is NOT on him; a blocked one does not pass his guard line
##   JUMPS    no head moves more than 12 cm in 1/30 s outside a contact
##   SLIDE    a standing foot travels under 1 m in a 30 s exchange
##   REST     with no punch within 1.5 s the pelvises are at the edge of range (ChoreoRules.REST_M - 0.22 .. + 0.3: past the longest jab's 1.04 m)
##   APART    no head inside the other man's head or chest
##   COUNTS   the plan lands what the round landed
##   HANDS    while a man is hit his wrists stay near their guard distance to his head (the guard goes with the head)
##   GAZE     on every cross take v2 plays, blue's face is within GAZE_DEG of red's head around the contact (FP2POSE1)
##   FEET     ... and his feet never cross: the left foot stays FEET_M to the left of the right, across the fight's line
##   HEEL     ... and at the contact his rear heel is up: the rear ankle rides HEEL_M higher over the ball of the foot
##            than in his guard, on every take (FP2POSE2; `-- fp2nocrosslegs` = the takes as bought: red)
## A bar v2 does not hold YET prints as DEBT with its number and fails only past a guard (it may not get worse).
## Run: <godot> --headless --audio-driver Dummy --fixed-fps 60 --path . --script res://tests/player2_test.gd [-- seed=7 rounds=2 show]

const Stage := preload("res://scripts/fight3d/FightStage.gd")
const RS := preload("res://scripts/rules/RoundScript.gd")
const R := preload("res://scripts/fight3d/v2/ChoreoRules.gd")
const Player2 := preload("res://scripts/fight3d/v2/Player2.gd")
const FightClips := preload("res://scripts/fight3d/FightClips.gd")
const HZ := 60.0
const ON_M := 0.12
const HANDS_M := 0.12        # a hit man's wrist may be this much further from his head than in his guard
## FP2POSE1 (owner C454: "where the fuck is he looking at"): a boxer's eyes stay on the target through a cross, the chin
## behind the punching shoulder - the face a few degrees off the other man, not riding the shoulders (the raw take: 76).
const GAZE_DEG := 25.0
const FEET_M := 0.10
## FP2POSE2 (owner C454: "wtf is that legs doing"): a cross is driven off the ball of the rear foot - the heel comes up
## and the foot turns in with the hips. As bought the rear ankle rises 0-3 cm at the contact (the actor is flat-footed).
const HEEL_M := 0.025
const BONES := ["Hips", "Head", "Chest", "LeftToes", "RightToes", "LeftHand", "RightHand", "LeftLowerLeg", "RightLowerLeg", "LeftFoot", "RightFoot"]

var failures := 0
var st: Node3D
var shown: Array = [{}, {}]
var heads: Array = [Basis.IDENTITY, Basis.IDENTITY]   # each head as drawn (skeleton space)


func _check(ok: bool, what: String) -> void:
	if not ok:
		failures += 1
	print(("PASS " if ok else "FAIL ") + what)


func _debt(ok: bool, guard: bool, what: String) -> void:
	if not guard:
		failures += 1
	print(("PASS " if ok else ("DEBT " if guard else "FAIL ")) + what)


func _w(i: int, bone: String) -> Vector3:
	return (st.boxers[i]["skel"] as Skeleton3D).global_transform * (shown[i].get(bone, Vector3.ZERO) as Vector3)


## The face (the lower face: mouth and chin, where a punch is aimed) and the ribs of boxer i, as drawn.
func _target(i: int, body: bool) -> Vector3:
	var fwd: Vector3 = (st.boxers[i]["node"] as Node3D).global_transform.basis.z.normalized()
	var s: float = (st.boxers[i]["node"] as Node3D).scale.x
	if body:
		return _w(i, "Chest") + (fwd * 0.11 + Vector3.DOWN * 0.14) * s
	return _w(i, "Head") + (fwd * 0.09 + Vector3.UP * 0.02) * s


## GAZE and FEET: blue throws every cross take v2 plays, alone, from his guard (no plan: the take as the player shows it).
func _pose(p2: Node) -> void:
	var rows: Dictionary = p2.db.get("rows", {})
	var ap: AnimationPlayer = st.boxers[1]["ap"]
	var sk: Skeleton3D = st.boxers[1]["skel"]
	var node: Node3D = st.boxers[1]["node"]
	var sb := sk.global_transform.basis.orthonormalized()
	var rest_inv := sk.get_bone_global_rest(sk.find_bone("Head")).basis.orthonormalized().inverse()
	var rl: Vector3 = sb * (sk.get_bone_global_rest(sk.find_bone("LeftFoot")).origin - sk.get_bone_global_rest(sk.find_bone("RightFoot")).origin)
	var sgn := 1.0 if rl.dot(node.global_transform.basis.x) >= 0.0 else -1.0
	var worst := 0.0
	var worst_take := ""
	var feet := 9.0
	var feet_take := ""
	var heel := 9.0
	var heel_take := ""
	var n := 0
	for name in rows:
		var r: Dictionary = rows[name]
		if str(r.get("family", "")) != "cross" or not bool(r.get("played", false)) or not (r.get("drop", []) as Array).is_empty() or not ap.has_animation(str(name)):
			continue
		n += 1
		p2.guard(1)
		for f in 40:
			await process_frame
		var to0: Vector3 = (st.boxers[0]["node"] as Node3D).global_position - node.global_position
		var rear := "Right" if to0.dot(_w(1, "RightFoot") - _w(1, "LeftFoot")) < 0.0 else "Left"
		var flat_h := _w(1, rear + "Foot").y - _w(1, rear + "Toes").y
		var up := -9.0
		p2._play(1, str(name), 0.0, "punch", true)
		var cs := float(r.get("contact_s", 0.3))
		for f in int((cs + 0.2) * HZ):
			await process_frame
			if str(ap.current_animation) != str(name):
				break
			var tt := ap.current_animation_position
			var axis: Vector3 = (st.boxers[0]["node"] as Node3D).global_position - node.global_position
			axis = Vector3(axis.x, 0.0, axis.z).normalized()
			var across := sgn * Vector3.UP.cross(axis).dot(_w(1, "LeftFoot") - _w(1, "RightFoot"))
			if across < feet:
				feet = across
				feet_take = str(name)
			if absf(tt - cs) <= 0.04:
				up = maxf(up, (_w(1, rear + "Foot").y - _w(1, rear + "Toes").y - flat_h) / node.scale.x)
			if tt < cs - 0.10 or tt > cs + 0.05:
				continue
			sb = sk.global_transform.basis.orthonormalized()
			var face: Vector3 = sb * ((heads[1] as Basis) * rest_inv * (sb.inverse() * node.global_transform.basis.orthonormalized().z))
			var to := _w(0, "Head") - _w(1, "Head")
			var off := absf(rad_to_deg(Vector3(to.x, 0.0, to.z).signed_angle_to(Vector3(face.x, 0.0, face.z), Vector3.UP)))
			if off > worst:
				worst = off
				worst_take = str(name)
		if up < heel:
			heel = up
			heel_take = str(name)
	p2.guard(1)
	for f in 40:
		await process_frame
	_check(n > 0 and worst <= GAZE_DEG, "GAZE on a cross blue's face stays within %.0f deg of red's head around the contact (worst %.0f deg, %s; %d takes)" % [GAZE_DEG, worst, worst_take, n])
	_check(n > 0 and feet >= FEET_M, "FEET on a cross blue's feet never cross: the left stays %.0f cm to the left of the right (least %.0f cm, %s)" % [FEET_M * 100.0, feet * 100.0, feet_take])
	_check(n > 0 and heel >= HEEL_M, "HEEL on a cross blue's rear heel is up at the contact: the ankle %.1f cm or more higher over the ball than in his guard (least %.1f cm, %s)" % [HEEL_M * 100.0, heel * 100.0, heel_take])


func _initialize() -> void:
	Engine.max_fps = int(HZ)
	var sd := 7
	var rounds := 2
	var show := OS.get_cmdline_user_args().has("show")
	for a in OS.get_cmdline_user_args():
		if str(a).begins_with("seed="):
			sd = int(str(a).substr(5))
		if str(a).begins_with("rounds="):
			rounds = int(str(a).substr(7))
	Player2.force = true
	FightClips.untouched = true
	st = Stage.new()
	root.add_child(st)
	await process_frame
	st.setup({"glb": "res://assets/models/metahuman/mh_boxer_12.glb", "corner": "red"},
		{"glb": "res://assets/models/metahuman/mh_boxer_07.glb", "corner": "blue"})
	if st.v2 == null:
		print("PLAYER2 the v2 player was not built")
		print("PLAYER2 failures=1")
		quit(1)
		return
	for i in 2:
		var sk: Skeleton3D = st.boxers[i]["skel"]
		var ids: Array = BONES.map(func(b): return sk.find_bone(str(b)))
		var d: Dictionary = shown[i]
		sk.skeleton_updated.connect(func():
			heads[i] = sk.get_bone_global_pose(sk.find_bone("Head")).basis.orthonormalized()
			for k in BONES.size():
				d[BONES[k]] = sk.get_bone_global_pose(int(ids[k])).origin)
		var names: Array = []
		for c in sk.get_children():
			if c is SkeletonModifier3D and (c as SkeletonModifier3D).active:
				names.append(str(c.name))
		print("PLAYER2 boxer %d layers on: %s" % [i, " ".join(names)])
	for i in 30:
		await process_frame
	var p2: Node = st.v2
	await _pose(p2)
	var miss: Array = []        # landed: glove front to target (m)
	var short_on := 0           # missed punches whose glove is on him
	var short_n := 0
	var jumps := 0
	var slide := [0.0, 0.0]
	var rest: Array = []
	var inside := 0
	var landed_plan := 0
	var landed_want := 0
	var frames := 0
	var seen := 0
	var pend: Array = []
	var glove_at: Array = [{"LeftHand": Vector3.ZERO, "RightHand": Vector3.ZERO}, {"LeftHand": Vector3.ZERO, "RightHand": Vector3.ZERO}]
	var slide_by := {}
	var glove_was: Array = [{"LeftHand": [9.0, 9.0], "RightHand": [9.0, 9.0]}, {"LeftHand": [9.0, 9.0], "RightHand": [9.0, 9.0]}]
	var prev_head: Array = [[], []]
	var prev_ball: Array = [[null, null], [null, null]]
	var floor_y := [[0.0, 0.0], [0.0, 0.0]]
	var guard_d: Array = [{"LeftHand": [], "RightHand": []}, {"LeftHand": [], "RightHand": []}]   # wrist to head in the guard
	var react_d: Array = []     # [boxer, hand, take, wrist to head, seconds into the reaction]
	for i in 2:
		var sk2: Skeleton3D = st.boxers[i]["skel"]
		for k in 2:
			floor_y[i][k] = _w(i, ["LeftToes", "RightToes"][k]).y   # the ball as it stands in the guard (FloorStand puts it on the canvas)
	for rn in rounds:
		var round := {"n": 1, "won": rn % 2 == 0, "mine": 60.0, "theirs": 55.0, "corner": "", "lines": []}
		var beats: Array = RS.build(round, "Slugger", "Boxer", 30.0, sd + rn)["beats"]
		var t0 := float(rn) * 30.0
		for b in beats:
			b["t"] = float(b["t"]) + t0
			if str(b["result"]) == "lands" and R.is_punch(str(b["move"])):
				landed_want += 1
		p2.queue(beats, t0, t0 + 30.0)
		for side in ["a", "b"]:
			landed_plan += int(p2.plan["counts"][side]["landed"])
		var cts: Array = (p2.plan["beats"] as Array).filter(func(b): return R.is_punch(str(b["move"])) and not bool(b["cut"])).map(func(b): return float(b["contact_t"]))
		var t := t0
		while t < t0 + 30.0:
			p2.clock(t, true)
			await process_frame
			t += 1.0 / HZ
			frames += 1
			var near := false
			var at_contact := false
			for c in cts:
				near = near or absf(float(c) - t) < 1.5
				at_contact = at_contact or absf(float(c) - t) < 0.12
			while seen < (p2.contacts as Array).size():
				var c0: Dictionary = p2.contacts[seen]
				seen += 1
				var hitter := 0 if str(c0["who"]) == "a" else 1
				var row: Dictionary = p2.db["rows"].get(str(c0["take"]), {})
				var hand: String = st.hand_of(hitter, str(row.get("hand", "LeftHand")))
				var body := str(c0["move"]) == "body_hook"
				var c: Dictionary = c0
				var off0: float = minf(st.glove_front(hitter, hand).distance_to(_target(1 - hitter, body)), float(glove_was[hitter][hand][1 if body else 0]))
				pend.append([3, c, hitter, hand, body, off0])
			for pd in pend:
				pd[0] = int(pd[0]) - 1
				var tg: Vector3 = _target(1 - int(pd[2]), bool(pd[4]))
				var g1: Vector3 = st.glove_front(int(pd[2]), str(pd[3]))
				var g0: Vector3 = glove_at[int(pd[2])][str(pd[3])]
				var vec: Vector3 = tg - Geometry3D.get_closest_point_to_segment(tg, g0, g1)   # a hook's glove covers 20 cm a frame: read its path
				if vec.length() <= float(pd[5]) + 0.0001:
					pd[5] = vec.length()
					var nb: Basis = (st.boxers[int(pd[2])]["node"] as Node3D).global_transform.basis.orthonormalized()
					pd.resize(7)
					pd[6] = "fwd %+.2f side %+.2f up %+.2f f%d" % [vec.dot(nb.z), vec.dot(nb.x), vec.y, 3 - int(pd[0])]
			while not pend.is_empty() and int(pend[0][0]) <= 0:
				var pd0: Array = pend.pop_front()
				var c: Dictionary = pd0[1]
				var off: float = float(pd0[5])
				if str(c["result"]) == "lands":
					miss.append(off)
				elif str(c["result"]) == "misses":
					short_n += 1
					short_on += 1 if off < 0.05 else 0
				if show:
					print("  contact %6.2f %s %-13s %-8s %-26s gap %.2f glove off %.2f aim %.2f" % [float(c["t"]), c["who"], c["move"], c["result"], c["take"], float(c["gap"]), off, float(p2._aim[int(pd0[2])].last_m)], " left %.2f late %+.3f " % [float(p2._aim[int(pd0[2])].left_m), float(c.get("late_s", 0.0))], pd0[6] if pd0.size() > 6 else "before")
			for i in 2:
				for hand in ["LeftHand", "RightHand"]:   # the gloves of last frame (the contact falls between two frames)
					glove_at[i][hand] = st.glove_front(i, hand)
					glove_was[i][hand] = [st.glove_front(i, hand).distance_to(_target(1 - i, false)), st.glove_front(i, hand).distance_to(_target(1 - i, true))]
			for i in 2:
				var tk: Dictionary = p2._take[i]
				for hand in ["LeftHand", "RightHand"]:
					var dh: float = (shown[i][hand] as Vector3).distance_to(shown[i]["Head"])
					if str(tk.get("kind", "")) == "guard":
						(guard_d[i][hand] as Array).append(dh)
					elif str(tk.get("kind", "")) == "reaction":
						react_d.append([i, hand, str(tk.get("clip", "")), dh, t - float(tk.get("at", t))])
			for i in 2:
				var head := _w(i, "Head")
				var hist: Array = prev_head[i]
				hist.append(head)
				if hist.size() > 3:
					hist.pop_front()
				if hist.size() == 3 and (hist[2] as Vector3).distance_to(hist[0]) > 0.12 and not at_contact:
					jumps += 1
					if show:
						print("  head jump %6.2f boxer %d %.2f m clip %s" % [t, i, (hist[2] as Vector3).distance_to(hist[0]), (st.boxers[i]["ap"] as AnimationPlayer).current_animation])
				var slips: Array = []   # the stiller foot that stands is the support foot: what IT travels is slide
				for k in 2:
					var ball := _w(i, ["LeftToes", "RightToes"][k])
					var last: Variant = prev_ball[i][k]
					if last != null and ball.y < float(floor_y[i][k]) + 0.008 and (last as Vector3).y < float(floor_y[i][k]) + 0.008:
						slips.append(Vector2(ball.x - (last as Vector3).x, ball.z - (last as Vector3).z).length())
					prev_ball[i][k] = ball
				if not slips.is_empty():
					slide[i] = float(slide[i]) + float(slips.min())
					var ck := str((st.boxers[i]["ap"] as AnimationPlayer).current_animation)
					slide_by[ck] = float(slide_by.get(ck, 0.0)) + float(slips.min())
				var oh := _w(1 - i, "Head")
				var oc := _w(1 - i, "Chest")
				if head.distance_to(oh) < 0.16 or head.distance_to(oc) < 0.18:
					inside += 1
			if not near:
				rest.append(Vector2(_w(0, "Hips").x - _w(1, "Hips").x, _w(0, "Hips").z - _w(1, "Hips").z).length())
	miss.sort()
	rest.sort()
	if show:
		var keys: Array = slide_by.keys()
		keys.sort_custom(func(x, y): return float(slide_by[x]) > float(slide_by[y]))
		for k in keys.slice(0, 12):
			print("  slide %-30s %.2f m" % [k, float(slide_by[k])])
	# HANDS (owner C435 on film 15: "reds hands are not moving with the reaction"): while a man is hit each wrist stays
	# within HANDS_M of where his guard keeps it from his head - the guard goes with the head that was hit.
	var away_worst := 0.0
	var away_n := 0
	var away_by := {}
	for i in 2:
		for hand in ["LeftHand", "RightHand"]:
			(guard_d[i][hand] as Array).sort()
	for rd in react_d:
		var gd: Array = guard_d[int(rd[0])][str(rd[1])]
		var away: float = float(rd[3]) - (float(gd[gd.size() / 2]) if not gd.is_empty() else 0.25)
		away_worst = maxf(away_worst, away)
		away_n += 1 if away > HANDS_M else 0
		away_by[str(rd[2])] = maxf(float(away_by.get(str(rd[2]), 0.0)), away)
	if show:
		for k in away_by:
			print("  hands %-30s a wrist up to %+.2f m further from the head than in the guard" % [k, float(away_by[k])])
		for i in 2:
			for hand in ["LeftHand", "RightHand"]:
				var gd2: Array = guard_d[i][hand]
				print("  guard boxer %d %s wrist to head %.2f m (median of %d frames)" % [i, hand, float(gd2[gd2.size() / 2]) if not gd2.is_empty() else 0.0, gd2.size()])
	var med: float = float(miss[miss.size() / 2]) if not miss.is_empty() else 9.0
	var on_n := miss.filter(func(m): return float(m) <= ON_M).size()
	print("PLAYER2 frames %d landed %d: glove off the target median %.3f m, worst %.3f m, within %.2f m %d of %d" % [frames, miss.size(), med, float(miss[-1]) if not miss.is_empty() else 9.0, ON_M, on_n, miss.size()])
	print("PLAYER2 misses %d (glove on him anyway %d) head jumps %d foot slide %.2f / %.2f m per %d s rest %.2f..%.2f m (%d frames) heads inside %d frames" % [short_n, short_on, jumps,
		float(slide[0]), float(slide[1]), rounds * 30, float(rest[0]) if not rest.is_empty() else 0.0, float(rest[-1]) if not rest.is_empty() else 0.0, rest.size(), inside])
	_check(landed_plan == landed_want, "COUNTS the plan lands what the round landed (%d of %d)" % [landed_plan, landed_want])
	_check(miss.size() >= landed_want * 0.9, "LANDS at least 9 landed punches in 10 reach their contact uncut (%d of %d)" % [miss.size(), landed_want])
	_check(med <= ON_M, "LANDS the median landed glove is within %.2f m of its target (%.3f)" % [ON_M, med])
	_debt(on_n >= miss.size() * 0.9, on_n >= miss.size() * 0.7, "LANDS 9 landed gloves in 10 are within %.2f m (%d of %d; guard 7 in 10)" % [ON_M, on_n, miss.size()])
	_check(short_on == 0, "SHORT no missed punch has its glove on him (%d of %d)" % [short_on, short_n])
	_debt(jumps == 0, jumps <= 6 * rounds, "JUMPS no head moves over 12 cm in 1/30 s outside a contact (%d; guard %d)" % [jumps, 6 * rounds])
	_debt(float(slide[0]) <= 1.0 * rounds and float(slide[1]) <= 1.0 * rounds, maxf(float(slide[0]), float(slide[1])) <= 5.0 * rounds, "SLIDE a standing foot travels under 1 m an exchange (%.2f / %.2f over %d; guard 5 m)" % [float(slide[0]), float(slide[1]), rounds])
	_check(not rest.is_empty() and float(rest[0]) >= R.REST_M - 0.35 and float(rest[-1]) <= R.REST_M + 0.3, "REST out of reach between bursts (%.2f..%.2f m)" % [float(rest[0]) if not rest.is_empty() else 0.0, float(rest[-1]) if not rest.is_empty() else 0.0])
	_check(not react_d.is_empty() and away_n == 0, "HANDS a hit man's wrists stay within %.2f m of their guard distance to his head (%d of %d frames over, worst %+.2f m)" % [HANDS_M, away_n, react_d.size(), away_worst])
	_check(inside == 0, "APART no head inside the other man (%d frames)" % inside)
	print("PLAYER2 failures=%d" % failures)
	quit(0 if failures == 0 else 1)
