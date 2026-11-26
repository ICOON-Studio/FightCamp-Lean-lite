extends "res://tools/pics2d_anim_more.gd"
## KICKTAKE1 (S559, ops/research/TASK_KICKTAKE1.md): the first kick pictures of the kickboxing page (proto/twohands/kick.html):
## the teep and the low kick from Mixamo takes (assets/anim/kicks, CREDITS.md), put on the boxer's own MetaHuman by the
## game's retarget (scripts/fight3d/RkRetarget.gd, the Rokoko route - reused, not changed), and the authored shin check
## (tools/pics2d_hold_bake.gd only=check -> assets/anim/baked/holds/hold_check.res). The same fixed side camera, bodies,
## framing and frames.json as the punch runs (tools/pics2d_anim.gd); a new file because pics2d_anim(_more).gd sit near the
## 500-line rule.
##   teep_landed    the sole on his belly, he folds (the gut-shot reaction) and is driven back by the foot
##   teep_blocked   CAUGHT (the page: "a lead hand held low catches it"): his lead forearm held low (hold_lead_low) stops the foot
##   teep_missed    he pulls back and gives ground: the sole stops short
##   low_kick_landed  the rear SHIN on the outside of his lead thigh, his lead leg planted (R111: our old kicks all flew)
##   low_kick_blocked CHECKED: his lead shin up (hold_check), shin on shin
##   low_kick_missed  he gives ground: the shin swings past in front of his thigh
##   check            the shin check held, alone (the page holds it all beat)
## THE STANDING FOOT IS PLANTED: from the moment the kick starts the body is carried so the standing foot keeps its spot on
## the canvas (the Mixamo low kick skids it 9 cm during the swing; the teep 3 mm). Measured on every contact frame.
## No _r2 (Mid) runs: the page names a kick run without a range (runOf), and a captured kick touches at one distance only -
## the range is FOUND from the take (the punch tools' rule), never a foot pushed into a body.
##   same command as pics2d_anim.gd with --script res://tools/pics2d_kick.gd [only=red_teep,blue_check,...]

const RkRetarget := preload("res://scripts/fight3d/RkRetarget.gd")
const KDIR := "res://assets/anim/kicks/"
## kick -> the take, the kicking leg, the take window searched for the contact [from, to] s, where the run starts in it (s)
const KICKS := {"teep": ["teep_mixamo.fbx", "lead", [1.05, 1.40], 0.55], "low_kick": ["low_kick_mixamo.fbx", "rear", [0.36, 0.75], 0.10]}
const K_OFFS := {"teep": [-0.55, -0.40, -0.28, -0.18, -0.10, -0.05, 0.0, 0.08, 0.18, 0.30, 0.45],
	"low_kick": [-0.30, -0.22, -0.15, -0.09, -0.04, 0.0, 0.06, 0.14, 0.26, 0.42, 0.62]}
const SOLE_M := 0.04         # the sole's front, ahead of the toes bone along the foot
const SHIN_GAP := {"landed": 0.13, "blocked": 0.12}   # bone line to bone line on the contact: shin + thigh / shin + shin and boot leather
const SHIN_FROM := 0.30      # the contact is on the shin: at least this far down from the knee (share of knee-to-ankle)
const SHIN_AT := 0.65        # the striking part of the shin, fitted to his leg (the first fit touched with the ankle, 1.0)
const GOAL_ON := [0.25, 0.85]   # ... on this part of his thigh / shin (not the hip, not the knee or the foot)
const GIVE_M := {"teep": 0.28, "low_kick": 0.46}   # low kick: at 0.34 the shin passed 0.13 m from his lead leg   # a miss: the ground he gives (the sole / shin stops this short)
const KICK_APART_M := 0.45   # torso to torso on the contact
const STAND_RISE_M := 0.03   # the standing foot off the canvas at most (R111)
const STAND_SLIDE_M := 0.02
const MISS_CLEAR_M := 0.15
const CHECK_FOOT_UP_M := 0.15

var pin := {}   # who -> the standing foot's spot (world, flat) while a kick plays
## GLIDE2 (S562, owner: "the distance between fighters is not consistant when clips play"): range=<2|3> makes a kick run at
## the page's range (the kicks reach Long and Mid on kick.html; Inside they are smothered): the KICKER starts and ends on
## his spot at that range (Long = the guard spots, Mid one step of 0.355 m in) and is carried into the kick's own spot
## between, the standing foot with him (pinned to the body, so it does not skid inside the kick); the other man starts and
## ends on his own spot (the ground a miss gives him and the push of a teep that lands ease in and out the same way). One
## exception the rules make: a teep that LANDS at Mid pushes him one place back (kick.html: range + 1), so that run ends
## with him one step (0.355 m) further back. Names: plain = Long, _r2 = Mid; the run's row says its range.
const KICK_RANGES := [3, 2]
const GLIDE_IN := 0.12   # on the kick's spot this long before the contact
const GLIDE_OUT := 0.08  # and leaves it after this
## S564 (the edge table: the kicker's first / last picture 15-25 px off the hold): the kick take stands his hips away from
## his root, so on the range's spot his body is put where the guard puts it - the hips' flat offset from the root in the
## guard (read once at the start), eased out by the same weight as the glide.
var guard_hips := {}   # who -&gt; the guard's Hips minus root, flat (world)


func _run() -> void:
	RANGE_AT = int(_arg("range", "0"))
	if RANGE_AT in [2, 3]:
		await _home_guard()
		await process_frame
		for who in 2:
			guard_hips[who] = _flat(Gate.world(stage, who, "Hips") - _node(who).global_position)
	for who in 2:
		for k in KICKS:
			_load_kick(who, str(k))
		_add_hold(who, "hold_check")
		_add_hold(who, "hold_lead_low")
	for who in 2:
		var col: String = ["red", "blue"][who]
		for k in KICKS:
			for res in RESULTS:
				if RANGE_AT != 0 and not KICK_RANGES.has(RANGE_AT):
					continue
				var name := "%s_%s_%s" % [col, k, res] + ("_r%d" % RANGE_AT if RANGE_AT in [1, 2] else "")
				if _want(name):
					await _kick_run(who, str(k), str(res), name)
		if RANGE_AT == 0 and _want(col + "_check"):
			await _check_run(who, col + "_check")
	_finish()


## The take on this boxer's own skeleton (RkRetarget), mirrored for a southpaw (his lead is his right), as "kick_<k>".
func _load_kick(who: int, k: String) -> void:
	var ap: AnimationPlayer = stage.boxers[who]["ap"]
	var skel: Skeleton3D = stage.boxers[who]["skel"]
	var clip := "kick_" + k
	if ap.has_animation(clip):
		return
	var anim: Animation = RkRetarget.build(skel, KDIR + str(KICKS[k][0]), 0.0, 999.0, true)
	if anim == null:
		print("PICS2D_KICK FAIL %s did not build" % k)
		return
	var prefix := str(ap.get_node(ap.root_node).get_path_to(skel))
	for t in anim.get_track_count():
		anim.track_set_path(t, NodePath("%s:%s" % [prefix, str(anim.track_get_path(t))]))
	anim.loop_mode = Animation.LOOP_NONE
	if bool(stage.boxers[who].get("south", false)):
		var m: Animation = MirrorClip.mirror(anim, skel, MirrorClip._plane(skel))
		if m != null:
			m.length = anim.length
			anim = m
	ap.get_animation_library("").add_animation(clip, anim)


func _lead(who: int) -> String: return str(stage.hand_of(who, "LeftHand")).trim_suffix("Hand")


func _rear(who: int) -> String: return "Right" if _lead(who) == "Left" else "Left"


func _leg(who: int, k: String) -> String: return _lead(who) if str(KICKS[k][1]) == "lead" else _rear(who)


func _flat(v: Vector3) -> Vector3: return Vector3(v.x, 0.0, v.z)


func _sole(who: int, side: String) -> Vector3:
	var toe := Gate.world(stage, who, side + "Toes")
	return toe + (toe - Gate.world(stage, who, side + "Foot")).normalized() * SOLE_M


## Where the kick's contact is on the other man: [a, b] of the bone line it meets (low kick), or a point (teep; b = a).
func _goal(who: int, k: String, res: String) -> Array:
	var d := 1 - who
	var lead := _lead(d)
	if k == "teep":
		var p: Vector3 = stage.target_point(d, true)
		if res == "blocked":   # caught on his lead forearm, held low
			var s := _sole(who, _leg(who, k))
			p = Geometry3D.get_closest_point_to_segment(s, Gate.world(stage, d, lead + "LowerArm"), Gate.world(stage, d, lead + "Hand"))
			p += (s - p).normalized() * Gate.FOREARM_R
		return [p, p]
	if res == "blocked":   # checked: his lead shin
		return [Gate.world(stage, d, lead + "LowerLeg"), Gate.world(stage, d, lead + "Foot")]
	return [Gate.world(stage, d, lead + "UpperLeg"), Gate.world(stage, d, lead + "LowerLeg")]


## The kicker's shin as a bone line, knee to ankle.
func _shin(who: int, k: String) -> Array:
	var s := _leg(who, k)
	return [Gate.world(stage, who, s + "LowerLeg"), Gate.world(stage, who, s + "Foot")]


## One kick played live from the run's start in take time and stopped at take time "upto"; "rec" (if given) gets one row a
## frame: [tau, sole, shin a, shin b, goal a, goal b, the height aimed at]. The standing foot is pinned from the kick's first frame; a teep that
## lands or is caught drives him back by what the sole would go into him.
func _kick_live(who: int, kp: Dictionary, upto: float, rec = null) -> void:
	var d := 1 - who
	var k: String = kp["k"]
	var res: String = kp["res"]
	var dirv := axis * (1.0 if who == 0 else -1.0)
	var stand := _rear(who) if str(KICKS[k][1]) == "lead" else _lead(who)
	await _home_guard(float(kp["step"]), who)
	_node(who).global_position += kp["side"]
	_node(d).global_position += kp["give"]
	pin.erase(who)
	var tau := minf(float(kp["from_s"]), float(kp["ans_tau"]))
	if upto < tau:
		return
	var kicked := false
	var answered := false
	while true:
		if not kicked and tau >= float(kp["from_s"]) - EPS:
			stage.v2._play(who, "kick_" + k, float(kp["from_s"]), "punch", false)
			pin[who] = _flat(Gate.world(stage, who, stand + "Foot"))
			kicked = true
		if not answered and str(kp["ans"]) != "" and tau >= float(kp["ans_tau"]) - EPS:
			stage.v2._play(d, kp["ans"], float(kp["ans_from"]), kp["ans_kind"], false)
			answered = true
		if pin.has(who):   # the standing foot keeps its spot: the body is carried by what it slid
			_node(who).global_position -= _flat(Gate.world(stage, who, stand + "Foot")) - (pin[who] as Vector3)
		if k == "teep" and res != "missed" and tau > float(kp["tc"]) + EPS:
			var g: Array = _goal(who, k, res)
			var pen := (_sole(who, _leg(who, k)) - (g[0] as Vector3)).dot(dirv)
			if pen > 0.0:
				_node(d).global_position += dirv * pen
		if rec != null:
			var sh := _shin(who, k)
			var gl := _goal(who, k, res)
			var aim: Vector3 = stage.target_point(d, true)   # the height the teep is fitted to: his belly, or his low forearm (caught)
			if k == "teep" and res == "blocked":
				aim = (Gate.world(stage, d, _lead(d) + "LowerArm") + Gate.world(stage, d, _lead(d) + "Hand")) * 0.5
			(rec as Array).append([tau, _sole(who, _leg(who, k)), sh[0], sh[1], gl[0], gl[1], aim])
		if tau >= upto - EPS:
			break
		await process_frame
		tau += 1.0 / 60.0
	_freeze(who)
	_freeze(d)


## The plan of a run: the answer (what he does) and when, in take time; contact and range filled in by _kfind.
func _kplan(who: int, k: String, res: String) -> Dictionary:
	var d := 1 - who
	var dap: AnimationPlayer = stage.boxers[d]["ap"]
	var rows: Dictionary = stage.v2.db["rows"]
	var win: Array = KICKS[k][2]
	var kp := {"k": k, "res": res, "from_s": float(KICKS[k][3]), "tc": float(win[0] + win[1]) * 0.5, "step": 0.0, "side": Vector3.ZERO,
		"give": Vector3.ZERO, "ans": "", "ans_kind": "reaction", "ans_tau": INF, "ans_from": 0.0, "ans_rel": INF}
	if res == "landed" and k == "teep":
		kp["ans"] = str(REACT["body_jab"])
		kp["ans_rel"] = 1.0 / 60.0
		kp["ans_from"] = maxf(0.0, float((rows.get(kp["ans"], {}) as Dictionary).get("head_peak_s", 0.3)) - R.react_peak_s("body_jab"))
	elif res == "blocked":
		kp["ans"] = "hold_lead_low" if k == "teep" else "hold_check"
		kp["ans_kind"] = "block" if k == "teep" else "punch"   # a check lifts a leg: kind "block" keeps both feet on the canvas (Player2._play)
		kp["ans_rel"] = -0.45   # the hold is in place (its move takes 0.32 s) before the foot arrives
	elif res == "missed":
		kp["ans"] = BeatClips.defence("pull", "jab", true, false, func(c: String) -> bool: return dap.has_animation(c))
		kp["ans_kind"] = "defence"
		if kp["ans"] != "":
			var dpeak := float((rows.get(kp["ans"], {}) as Dictionary).get("head_peak_s", dap.get_animation(kp["ans"]).length * 0.42))
			var lead_in := minf(dpeak, R.DEF_LEAD_S)
			kp["ans_rel"] = -lead_in
			kp["ans_from"] = dpeak - lead_in
	if kp["ans"] == "" or not dap.has_animation(kp["ans"]):
		kp["ans"] = ""
	return kp


func _retime(kp: Dictionary) -> void:
	kp["ans_tau"] = float(kp["tc"]) + float(kp["ans_rel"]) if str(kp["ans"]) != "" else INF


## THE CONTACT AND THE RANGE ARE FOUND from the take: one live pass through the contact window from the guard spots, then
## the contact picture and the step in along the line (and across, for the teep) so the sole meets his belly / the shin
## meets his thigh or shin. A miss is the landed kick with ground given.
func _kfind(who: int, kp: Dictionary) -> void:
	var k: String = kp["k"]
	var res: String = kp["res"]
	var dirv := axis * (1.0 if who == 0 else -1.0)
	var goal_res := "landed" if res == "missed" else res
	var probe := kp.duplicate()
	probe["res"] = goal_res
	if res == "missed":
		probe["ans"] = ""
	for pass_n in 2:   # the second pass with the answer timed on the first pass's contact
		_retime(probe)
		var rec: Array = []
		await _kick_live(who, probe, float(KICKS[k][2][1]), rec)
		var win: Array = KICKS[k][2]
		var best := [INF, 0.0, 0.0, Vector3.ZERO]   # [score, tc, step, side]
		if k == "teep":   # the sole meets his belly WHILE STILL GOING OUT (a push), at the height of the belly: of the frames
			var most := -INF   # where the sole still extends and is within 0.12 m of its full reach (blue's caught teep took a
			for r in rec:      # chambered frame 0.2 s early), the one whose sole is level with the target (first try: full
				if float(r[0]) >= float(win[0]) - EPS:   # extension, the sole met his hip 0.17 m under the belly)
					most = maxf(most, (r[1] as Vector3).dot(dirv))
			var last := -INF
			for r in rec:
				var reach := (r[1] as Vector3).dot(dirv)
				var out := reach > last + 0.002
				last = reach
				if float(r[0]) < float(win[0]) - EPS or not out or reach < most - 0.12:
					continue
				var off: Vector3 = (r[4] as Vector3) - (r[1] as Vector3)
				var dy := absf(((r[6] as Vector3) - (r[1] as Vector3)).y)   # a caught teep is the same kick: its frame by the belly too
				if dy < float(best[0]):
					best = [dy, float(r[0]), off.dot(dirv), _flat(off) - dirv * off.dot(dirv)]
		else:
			var gap := float(SHIN_GAP[goal_res])
			var s := -1.2
			while s <= 1.2:   # the smallest step in at which the shin's striking part reaches the middle of his leg line
				var near := [INF, 0.0]
				for r in rec:
					if float(r[0]) < float(win[0]) - EPS:
						continue
					var a: Vector3 = (r[2] as Vector3) + dirv * s
					var b: Vector3 = (r[3] as Vector3) + dirv * s
					var p := a.lerp(b, SHIN_AT)
					var q := Geometry3D.get_closest_point_to_segment(p, r[4], r[5])
					var on := (q - (r[4] as Vector3)).length() / maxf(0.01, ((r[5] as Vector3) - (r[4] as Vector3)).length())
					var c := Geometry3D.get_closest_points_between_segments(a, b, r[4], r[5])
					var through := (c[0] as Vector3).distance_to(c[1]) < gap - 0.07   # another part of the shin already inside his leg
					if on >= float(GOAL_ON[0]) and on <= float(GOAL_ON[1]) and not through and p.distance_to(q) < float(near[0]):
						near = [p.distance_to(q), float(r[0])]
				if float(near[0]) <= gap:
					best = [0.0, float(near[1]), s, Vector3.ZERO]
					break
				s += 0.01
		if float(best[0]) == INF:
			var why := [INF, 0.0, 0.0, 0.0, false]   # the nearest the striking part came, at what step, frame, where on his leg
			if k != "teep":
				for s2 in range(-120, 121, 4):
					for r in rec:
						if float(r[0]) < float(win[0]) - EPS:
							continue
						var a2: Vector3 = (r[2] as Vector3) + dirv * (s2 / 100.0)
						var p2 := a2.lerp((r[3] as Vector3) + dirv * (s2 / 100.0), SHIN_AT)
						var q2 := Geometry3D.get_closest_point_to_segment(p2, r[4], r[5])
						if p2.distance_to(q2) < float(why[0]):
							why = [p2.distance_to(q2), s2 / 100.0, float(r[0]), (q2 - (r[4] as Vector3)).length() / maxf(0.01, ((r[5] as Vector3) - (r[4] as Vector3)).length()), q2.y]
			print("PICS2D_KICK %s %s: no contact found in the window (nearest %s)" % [k, res, str(why)])
			return
		kp["tc"] = best[1]
		kp["step"] = best[2]
		kp["side"] = best[3]
		probe["tc"] = best[1]
		print("PICS2D_KICK find %s %s pass %d: contact %.3f s into the take, step %+.3f m, across %.3f m" % [k, res, pass_n, float(kp["tc"]), float(kp["step"]), (kp["side"] as Vector3).length()])
	if res == "missed":
		kp["give"] = dirv * float(GIVE_M[k])
	_retime(kp)


## The bars on the contact picture, read on the stage as it is drawn.
func _kgate(who: int, kp: Dictionary, stand0: float) -> Dictionary:
	var k: String = kp["k"]
	var res: String = kp["res"]
	var d := 1 - who
	var fails: Array = []
	var m := {}
	var stand := _rear(who) if str(KICKS[k][1]) == "lead" else _lead(who)
	m["stand_rise_m"] = snappedf(Gate.world(stage, who, stand + "Foot").y - stand0, 0.001)
	m["stand_slide_m"] = snappedf((_flat(Gate.world(stage, who, stand + "Foot")) - (pin.get(who, Vector3.ZERO) as Vector3)).length(), 0.001)
	m["apart_m"] = snappedf(Gate.apart_m(stage), 0.001)
	if float(m["stand_rise_m"]) > STAND_RISE_M:
		fails.append("the standing foot %.3f m off the canvas (bar %.2f)" % [m["stand_rise_m"], STAND_RISE_M])
	if float(m["stand_slide_m"]) > STAND_SLIDE_M:
		fails.append("the standing foot slid %.3f m (bar %.2f)" % [m["stand_slide_m"], STAND_SLIDE_M])
	if float(m["apart_m"]) < KICK_APART_M:
		fails.append("torsos %.3f m apart (bar %.2f)" % [m["apart_m"], KICK_APART_M])
	var g := _goal(who, k, "landed" if res == "missed" else res)
	if k == "teep":
		var s := _sole(who, _leg(who, k))
		m["sole_m"] = snappedf(s.distance_to(g[0]), 0.001)
		if res != "missed" and float(m["sole_m"]) > 0.07:
			fails.append("the sole %.3f m from %s (bar 0.07)" % [m["sole_m"], "his belly" if res == "landed" else "his lead forearm"])
	else:
		var sh := _shin(who, k)
		var c := Geometry3D.get_closest_points_between_segments(sh[0], sh[1], g[0], g[1])
		m["shin_m"] = snappedf((c[0] as Vector3).distance_to(c[1]), 0.001)
		m["on_shin"] = snappedf(((c[0] as Vector3) - (sh[0] as Vector3)).length() / maxf(0.01, ((sh[1] as Vector3) - (sh[0] as Vector3)).length()), 0.01)
		m["on_goal"] = snappedf(((c[1] as Vector3) - (g[0] as Vector3)).length() / maxf(0.01, ((g[1] as Vector3) - (g[0] as Vector3)).length()), 0.01)
		if res != "missed":
			var gap := float(SHIN_GAP[res])
			if float(m["shin_m"]) > gap + 0.05 or float(m["shin_m"]) < gap - 0.07:
				fails.append("shin to %s %.3f m (bar %.2f-%.2f)" % ["thigh" if res == "landed" else "shin", m["shin_m"], gap - 0.07, gap + 0.05])
			if float(m["on_shin"]) < SHIN_FROM:
				fails.append("it lands with the knee, %.2f down the shin (bar %.2f)" % [m["on_shin"], SHIN_FROM])
		if res == "blocked":
			m["check_foot_up_m"] = snappedf(Gate.world(stage, d, _lead(d) + "Foot").y - stand0, 0.001)
			if float(m["check_foot_up_m"]) < CHECK_FOOT_UP_M:
				fails.append("his checking foot only %.3f m up (bar %.2f)" % [m["check_foot_up_m"], CHECK_FOOT_UP_M])
	if res == "missed":
		var me := Gate.chain(stage, who, [_leg(who, k) + "UpperLeg", _leg(who, k) + "LowerLeg", _leg(who, k) + "Foot", _leg(who, k) + "Toes"])
		var near := INF
		for ch in [Gate.TORSO, ["LeftUpperLeg", "LeftLowerLeg", "LeftFoot"], ["RightUpperLeg", "RightLowerLeg", "RightFoot"]]:
			near = minf(near, Gate.chain_dist(me, Gate.chain(stage, d, ch)))
		m["clear_m"] = snappedf(near, 0.001)
		if near < MISS_CLEAR_M:
			fails.append("the kick %.3f m from him on a miss (bar %.2f)" % [near, MISS_CLEAR_M])
	m["fails"] = fails
	return m


func _kick_run(who: int, k: String, res: String, name: String) -> void:
	if not (stage.boxers[who]["ap"] as AnimationPlayer).has_animation("kick_" + k):
		print("PICS2D_KICK no take kick_%s on %s" % [k, name])
		refused += 1
		return
	var kp := _kplan(who, k, res)
	await _kfind(who, kp)
	# the camera is fixed on the contact, as in the punch runs
	await _kick_live(who, kp, float(kp["tc"]))
	await process_frame
	_aim([0, 1])
	var stand := _rear(who) if str(KICKS[k][1]) == "lead" else _lead(who)
	var floor_y := minf(Gate.world(stage, who, stand + "Foot").y, Gate.world(stage, 1 - who, _rear(1 - who) + "Foot").y)
	var offs: Array = K_OFFS[k]
	var files: Array = []
	var times: Array = []
	var m := {}
	var hit: Array = []
	for off in offs:
		await _kick_live(who, kp, float(kp["tc"]) + float(off))
		_kglide(who, kp, float(off), offs)
		if is_zero_approx(float(off)):
			m = _kgate(who, kp, floor_y)
			var at: Vector3 = _sole(who, _leg(who, k)) if k == "teep" else ((_shin(who, k)[0] as Vector3).lerp(_shin(who, k)[1], 0.7))
			var px := _px(at)
			hit = [snappedf(px.x / SIZE, 0.001), snappedf(px.y / SIZE, 0.001)]
		var f := "%s_%d" % [name, files.size()]
		if not await _frame(f):
			refused += 1
			return
		files.append(f + ".png")
		times.append(off)
	var fails: Array = m.get("fails", [])
	if not fails.is_empty():
		print("PICS_GATE FAIL %s (contact frame): %s" % [name, "; ".join(PackedStringArray(fails))])
		failed.append(name)
	runs[name] = {"files": files, "offs": times, "contact": times.find(0.0), "clip": "kick_" + k, "answer": kp["ans"],
		"step": snappedf(float(kp["step"]), 0.001), "take_contact_s": snappedf(float(kp["tc"]), 0.001), "gate_fails": fails, "hit": hit, "measures": m,
		"range": RANGE_AT, "glide_from": snappedf(float(RANGE_IN[["_r1", "_r2", ""][RANGE_AT - 1]]), 0.001) if RANGE_AT in [2, 3] else -1.0}
	print("PICS2D_KICK %s = kick_%s, answer %s, %d frames, contact %.2f s into the take, step %+.2f m, %s" % [name, k, kp["ans"] if str(kp["ans"]) != "" else "guard", files.size(), float(kp["tc"]), float(kp["step"]), JSON.stringify(m)])
	_save()


## GLIDE2: 0 on the range's spots, 1 on the kick's - smooth in from the run's first picture, smooth out to its last.
func _kw(off: float, offs: Array) -> float:
	if off <= -GLIDE_IN:
		return smoothstep(float(offs[0]), -GLIDE_IN, off)
	if off >= GLIDE_OUT:
		return 1.0 - smoothstep(GLIDE_OUT, float(offs[offs.size() - 1]), off)
	return 1.0


## GLIDE2: the pair as _kick_live left it (the kick's own spots) moved to the run's range: the kicker by what is left of
## his step at this picture, the other man by what is left of what he was moved (given ground, a teep's push).
func _kglide(who: int, kp: Dictionary, off: float, offs: Array) -> void:
	if not (RANGE_AT in [2, 3]):
		return
	var d := 1 - who
	var dirv := axis * (1.0 if who == 0 else -1.0)
	var w := _kw(off, offs)
	var from_m := float(RANGE_IN[["_r1", "_r2", ""][RANGE_AT - 1]])   # the range's spot (one shared table, never a number here)
	_node(who).global_position += dirv * (lerpf(from_m, float(kp["step"]), w) - float(kp["step"])) + (kp["side"] as Vector3) * (w - 1.0)
	if guard_hips.has(who):   # S564: his body (not his root) on the range's spot at the run's ends
		var hips := _flat(Gate.world(stage, who, "Hips") - _node(who).global_position)
		_node(who).global_position += ((guard_hips[who] as Vector3) - hips) * (1.0 - w)
	var moved := _flat(_node(d).global_position - home_t[d].origin)
	var rest := Vector3.ZERO
	if off > 0.0 and RANGE_AT == 2 and str(kp["k"]) == "teep" and str(kp["res"]) == "landed":
		rest = dirv * (float(RANGE_IN["_r2"]) - float(RANGE_IN[""]))   # the rules push him one place back: Mid to Long
	_node(d).global_position += moved.lerp(rest, 1.0 - w) - moved


## The check held, alone (the page holds it all beat): the lead shin up from the guard, read on the last picture.
func _check_run(who: int, name: String) -> void:
	if not _has(who, "hold_check"):
		return
	var floor_y := [0.0]
	var build := func() -> Array:
		await _home_guard()
		floor_y[0] = Gate.world(stage, who, _rear(who) + "Foot").y
		return [[0.0, func() -> void: stage.v2._play(who, "hold_check", 0.0, "punch", false)]]   # its legs are the take's own
	var gate := func() -> Dictionary:
		var fails: Array = []
		var up := Gate.world(stage, who, _lead(who) + "Foot").y - float(floor_y[0])
		var rise := Gate.world(stage, who, _rear(who) + "Foot").y - float(floor_y[0])
		if up < CHECK_FOOT_UP_M:
			fails.append("the checking foot %.3f m up (bar %.2f)" % [up, CHECK_FOOT_UP_M])
		if rise > STAND_RISE_M:
			fails.append("the standing foot %.3f m up (bar %.2f)" % [rise, STAND_RISE_M])
		for s in ["Left", "Right"]:
			var far := Gate.world(stage, who, s + "Hand").distance_to(stage.target_point(who, false))
			if far > HOLD_OTHER_FACE_M * _node(who).scale.x:
				fails.append("the %s hand %.3f m from the face: not in a guard" % [s.to_lower(), far])
		print("CHECK_GATE %s: checking foot %.3f m up, standing foot %.3f m up" % [name, up, rise])
		return {"fails": fails}
	await _solo(name, "hold_check", HOLD_T, build, Callable(), false, gate)
