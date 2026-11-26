extends "res://tools/pics2d_anim.gd"
## RINGANIM1 step 2 (S552): the frame runs of the Ring Switches actions that are not a punch - the feet (step in, back
## off), a hand held high or low, the feint, the push off, the clinch tying up and the knockdown. Each is the game's own
## take or layer, recorded from the fixed side camera; nothing is layered over a take.
##   step in / back off : the refitted step takes (StepPlay.TAKES: st_in_m, st_out_m), the body carried by the take's own
##                        hip travel, as StepPlay does
##   a hand held        : HOLDTAKES1 (S553) - lead high / lead low / rear high / rear low, the four authored one-hand
##                        holds (tools/pics2d_hold_bake.gd -> assets/anim/baked/holds/), added to each boxer here
##   feint              : ChoreoWait's paw - the lead hand of pro_left_jab_b to 0.20 s, then home (Player2._wait)
##   push               : PushOff (hands on the chest, both pushed out to range) - the game's only push
##   clinch             : Clinch.start, as the still tool's clinch picture, seen tying up
##   knockdown          : pro_knockout_v1 from the first buckle to the canvas
## NOT here because no take exists: an overhand (the page borrows the rear hook).
##   same command as pics2d_anim.gd with --script res://tools/pics2d_anim_more.gd

const RootPath := preload("res://scripts/fight3d/v2/RootPath.gd")
const PushOff := preload("res://scripts/fight3d/PushOff.gd")
const STEPS := {"step_in": ["st_in_m", 1.0, 0.355], "back_off": ["st_out_m", -1.0, 0.35]}   # take, way along the line, its travel (foot_db)
## THE RANGE IS SEEN (owner S553: "i think you need to draw them for inside/midrang/long ?"): the standing pictures at the
## page's three ranges. Long = the guard spots; each step in is the step take's own travel (0.355 m), so Mid = one step,
## Inside = two. A run's plain name is Long; _r2 = Mid, _r1 = Inside. A step run's suffix is the range it ENDS on.
const RANGE_IN := {"": 0.0, "_r2": 0.355, "_r1": 0.71}
const STEP_T := [0.0, 0.12, 0.24, 0.36, 0.48, 0.60, 0.72, 0.86]
## a held hand -> the hand, the place it guards as [landmark, [toward him, out to the hand's side, up] m], and how the
## bar reads it: "glove" = the glove's middle, "arm" = the nearest point of elbow-to-glove (the forearm does the guarding;
## the place is the body cross's own contact, 6 cm over the belt-line target), "under" = the glove waits UNDER the place
## on the punch's way up (an uppercut: how far the glove is off the line straight under the chin)
const HAND := {"lead_high": ["Left", "face", Vector3(0.0, 0.0, 0.0), "glove"], "lead_low": ["Left", "ribs", Vector3(0.0, 0.0, 0.06), "arm"],
	"rear_high": ["Right", "head", Vector3(0.13, 0.07, 0.05), "glove"], "rear_low": ["Right", "face", Vector3(0.0, 0.0, -0.13), "under"]}
## run -> the hands it holds (one hand, or both: the page holds every hand that does not punch high or low)
const HOLDS := {"lead_high": ["lead_high"], "lead_low": ["lead_low"], "rear_high": ["rear_high"], "rear_low": ["rear_low"],
	"both_high_high": ["lead_high", "rear_high"], "both_high_low": ["lead_high", "rear_low"],
	"both_low_high": ["lead_low", "rear_high"], "both_low_low": ["lead_low", "rear_low"]}
const HOLD_T := [0.0, 0.08, 0.14, 0.20, 0.26, 0.34, 0.50]
const HOLD_PLACE_M := 0.08   # the glove (or forearm) this near the place it guards
const HOLD_OTHER_M := 0.05   # the other hand this near where the guard has it
const HOLD_OTHER_FACE_M := 0.34   # the hand that is not held: its wrist this near the face (it is in a guard)
const HOLD_FRONT_M := 0.15   # a glove guarding the face: this far in front of it at most
## GUARDEAR1 (S559, owner on the blue man's rear_high: "this guard is wrong why he protects his ears ?"): a high rear
## glove sits on the cheek, AHEAD of the ear line (the head bone) by this much at least. The S553 take had it 0.02 m ahead.
const HOLD_EAR_AHEAD_M := 0.05
const FEINT := ["pro_left_jab_b", 0.20]   # ChoreoWait.BEATS "paw"
const FEINT_T := [0.0, 0.07, 0.13, 0.20, 0.27, 0.36, 0.46]
const PUSH_T := [0.0, 0.10, 0.20, 0.30, 0.40, 0.55, 0.70, 0.85]
const PUSH_GAP_M := 0.68          # Clinch.PAIR_GAP_M: the push starts from the tie-up
const CLINCH_GAP := {"m": 0.68, "w": 0.62}   # Clinch.PAIR_GAP_M; the still's 0.66 / 0.60 read 0.214-0.219 m apart here (bar 0.22)
const CLINCH_T := [0.0, 0.25, 0.50, 0.80, 1.20, 2.50]
const KO_FROM := 0.42   # s into the knockdown take where the fall starts (its lead-in is a standing guard)
const KO_FRAC := [0.04, 0.12, 0.20, 0.30, 0.42, 0.56, 0.72, 0.97]
const KO_AFTER := [0.0, 0.06, 0.12, 0.20, 0.30, 0.42, 0.56, 0.72, 0.90, 1.12, 1.40, 1.75, 2.15]   # s from the contact
## MASK1 (S559): the pictures the page shows while the player plans (the guard, every hold) get a part mask beside each
## frame, <run>_<k>_mask.png, drawn in the same frame (tools/pics2d_mask.gd). mask=off skips it.
const Mask := preload("res://tools/pics2d_mask.gd")
var mask: RefCounted = null


func _run() -> void:
	if _arg("mask", "on") != "off":
		mask = Mask.new(root, stage, cam, sv)
	for who in 2:
		var col: String = ["red", "blue"][who]
		for rk in RANGE_IN:   # MASK1: the guard at each range, as the page shows it while he plans
			if _want("%s_guard%s" % [col, rk]):
				await _solo("%s_guard%s" % [col, rk], "guard", [0.0], func() -> Array:
					await _home_guard(float(RANGE_IN[rk]), who)
					return [])
		for key in STEPS:
			if _want("%s_%s" % [col, key]):
				await _step_run(who, str(key), "%s_%s" % [col, key])
			for rk in (["_r2", "_r1"] if str(key) == "step_in" else ["_r3", "_r2"]):   # the range it ends on
				if _want("%s_%s%s" % [col, key, rk]):
					await _step_run(who, str(key), "%s_%s%s" % [col, key, rk], float(RANGE_IN.get(rk, 0.0)), true)
		for key in HOLDS:
			for rk in RANGE_IN:
				if _want("%s_%s%s" % [col, key, rk]):
					await _hold_run(who, str(key), "%s_%s%s" % [col, key, rk], float(RANGE_IN[rk]))
		if _want(col + "_feint"):
			await _feint_run(who, col + "_feint")
		if _want(col + "_knockdown"):
			await _ko_run(who, col + "_knockdown")
		for fam in FAMILIES:
			if _want("%s_%s_ko" % [col, fam]):
				await _punch_ko_run(who, str(fam), "%s_%s_ko" % [col, fam])
	# LAST: the push and the clinch put the arms on the other man through the stage's reach layer, and it stayed on
	# (the first render had every later run of the other corner with a lead arm held straight out).
	if _want("push"):
		await _push_run(0, "push")
		await _hands_free()
	for who in 2:
		if _want(["red", "blue"][who] + "_clinch"):
			await _clinch_run(who, ["red", "blue"][who] + "_clinch")
			await _hands_free()
	_finish()


## MASK1: the planning pictures (the guard and the holds) are saved with their part mask, from the same drawn frame.
func _frame(name: String, who: Array = [0, 1]) -> bool:
	var masked := mask != null and (name.contains("_guard") or HOLDS.keys().any(func(k) -> bool: return name.contains("_" + str(k))))
	if masked:
		mask.sync()
	var ok: bool = await super._frame(name, who)
	if ok and masked:
		mask.save(out_dir.path_join(name + "_mask.png"))
	return ok


## The clinch and the push off let go: nobody holds, no hand reaches, both back in the guard.
func _hands_free() -> void:
	stage.clinch.holder = -1
	stage.clinch.engaged = false
	PushOff.cancel(stage)
	for i in 2:
		var ik: Node = stage.boxers[i].get("ik")
		if ik != null:
			ik.reach("Left", null)
			ik.reach("Right", null)
	await _home_guard()
	for f in 30:
		await process_frame


## A run with no contact. `times`: s from its start. `build` (awaited) puts the pair in place for one frame and returns
## what happens when ([[t, Callable], ...]); `each` is called every picture with the time. The camera is fixed on the
## run's last picture (`fit`: widened to hold both men, a body on the canvas).
func _solo(name: String, clip: String, times: Array, build: Callable, each: Callable = Callable(), fit := false, gate: Callable = Callable()) -> void:
	await _solo_at(build, each, float(times[-1]))
	await process_frame
	_aim([0, 1])
	if fit and not Gate.framed(stage, cam, [0, 1], SIZE).is_empty():
		Gate.fit(stage, cam, [0, 1], ORTHO_M)
	var gate_fails: Array = (gate.call() as Dictionary)["fails"] if gate.is_valid() else []
	var files: Array = []
	for t in times:
		await _solo_at(build, each, float(t))
		var f := "%s_%d" % [name, files.size()]
		if not await _frame(f):
			refused += 1
			return
		files.append(f + ".png")
	if not gate_fails.is_empty():
		print("PICS_GATE FAIL %s (last frame): %s" % [name, "; ".join(PackedStringArray(gate_fails))])
		failed.append(name)
	runs[name] = {"files": files, "offs": times, "contact": -1, "clip": clip, "gate_fails": gate_fails}
	print("PICS2D_ANIM %s = %s, %d frames" % [name, clip, files.size()])
	_save()


func _solo_at(build: Callable, each: Callable, off: float) -> void:
	var todo: Array = await build.call()
	var t := 0.0
	while true:
		for e in todo:
			if e.size() == 2 and t >= float(e[0]) - EPS:
				(e[1] as Callable).call()
				e.append(true)
		if each.is_valid():
			each.call(t)
		if t >= off - EPS:
			break
		await process_frame
		t += 1.0 / 60.0
	_freeze(0)
	_freeze(1)


func _has(who: int, clip: String) -> bool:
	if (stage.boxers[who]["ap"] as AnimationPlayer).has_animation(clip):
		return true
	print("PICS2D_ANIM no take %s" % clip)
	refused += 1
	return false


## A step: the take played on the spot, the body carried along the line by the share of its hip travel made so far.
## Step in ends on the guard spot (it starts a step further out); back off starts on it.
func _step_run(who: int, key: String, name: String, end_in: float = 0.0, ranged := false) -> void:
	var clip: String = STEPS[key][0]
	if not _has(who, clip):
		return
	var ap: AnimationPlayer = stage.boxers[who]["ap"]
	var way := float(STEPS[key][1])
	var dist := float(STEPS[key][2])
	var toward := axis * (1.0 if who == 0 else -1.0)
	var from: Vector3 = home_t[who].origin - (toward * dist if way > 0.0 else Vector3.ZERO)
	if ranged:   # it ENDS end_in m in from Long: a step in starts a step further out, a step back a step further in
		from = home_t[who].origin + toward * (end_in - way * dist)
	var path := RootPath.of(ap.get_animation(clip))
	var len := ap.get_animation(clip).length
	# RENDERFIT1 (S559): a back off's last picture is taken at 0.72 s, when the take has carried him only 87% of its
	# travel (RootPath), so he ended 0.05 m short of the next spot: RINGCAM1's "hips 0.05 m ahead" (12 px). The Hips bone
	# stays on the root through the take (read: 0.023 m all the way), so landing the hips = landing the root: the carry
	# is spread over the pictures' own window, the last picture on the spot. Step in already lands (7 px): unchanged.
	var times := STEP_T.filter(func(t) -> bool: return float(t) <= len)
	var span := [1.0]
	if key == "back_off" and not path.is_empty() and not times.is_empty():
		var whole0 := RootPath.at(path, 99.0) - RootPath.at(path, 0.0)
		if whole0.length() > 0.01:
			span[0] = clampf((RootPath.at(path, float(times.back())) - RootPath.at(path, 0.0)).dot(whole0) / whole0.length_squared(), 0.5, 1.0)
	var build := func() -> Array:
		# RINGCAM1: settled ON the start spot (40 frames), as the hold pictures are; moved there after the guard settled
		# at Long, frame 0 drew the body 13-28 px short of it (the guard had not caught up) - the "start" snap off Long
		await _home_guard((from - home_t[who].origin).dot(toward), who)
		_node(who).global_position = from
		return [[0.0, func() -> void: stage.v2._play(who, clip, 0.0, "step", false)]]
	var each := func(_t: float) -> void:
		var pos := ap.current_animation_position if str(ap.current_animation) == clip else len
		var frac := smoothstep(0.17 * len, 0.82 * len, pos)
		if not path.is_empty():
			var whole := RootPath.at(path, 99.0) - RootPath.at(path, 0.0)
			if whole.length() > 0.01:
				frac = clampf((RootPath.at(path, pos) - RootPath.at(path, 0.0)).dot(whole) / whole.length_squared(), 0.0, 1.0)
		frac = minf(frac / span[0], 1.0)   # RENDERFIT1: 1.0 on the last picture of a back off (span above)
		_node(who).global_position = from + toward * way * dist * frac
	await _solo(name, clip, times, build, each)


## A hand held, or both (HOLDTAKES1): the authored take from the guard; a hand it does not name stays where the guard has it.
func _hold_run(who: int, key: String, name: String, step_in: float = 0.0) -> void:
	var clip := "hold_" + key
	_add_hold(who, clip)
	if not _has(who, clip):
		return
	var was := {}   # each wrist from the head, in the guard
	var build := func() -> Array:
		await _home_guard(step_in, who)
		for s in ["Left", "Right"]:
			was[s] = Gate.world(stage, who, s + "Hand") - Gate.world(stage, who, "Head")
		return [[0.0, func() -> void: stage.v2._play(who, clip, 0.0, "block", false)]]
	# S554: the take holds the guard's FIRST picture; the home guard is a loop caught at any phase (it read 0.011 to
	# 0.056 m by run). The other hand is read against the take's own first drawn picture: does it stay there.
	var each := func(t: float) -> void:
		if t > EPS and t < 0.03:
			for s in ["Left", "Right"]:
				was[s] = Gate.world(stage, who, s + "Hand") - Gate.world(stage, who, "Head")
	await _solo(name, clip, HOLD_T, build, each, false, func() -> Dictionary: return _hold_gate(who, key, was))


## The bars of a hold, read on the stage as it is drawn: each held glove (or forearm) at the place it guards, no glove
## over the top of the head, a hand that is not held still in its guard.
func _hold_gate(who: int, key: String, was: Dictionary) -> Dictionary:
	var sc: float = _node(who).scale.x
	var fwd: Vector3 = _node(who).global_transform.basis.z.normalized()
	var head := Gate.world(stage, who, "Head")
	var top := head.y + 0.16 * sc
	var fails: Array = []
	var said: Array = []
	var held := {}
	for h in HOLDS[key]:
		var row: Array = HAND[h]
		var s: String = str(stage.hand_of(who, str(row[0]) + "Hand")).trim_suffix("Hand")
		held[s] = true
		var out := fwd.cross(Vector3.UP).normalized() * (-1.0 if s == "Left" else 1.0)
		var off: Vector3 = row[2]
		var place: Vector3 = stage.target_point(who, str(row[1]) == "ribs") if str(row[1]) != "head" else head
		place += (fwd * off.x + out * off.y + Vector3.UP * off.z) * sc
		var tip: Vector3 = stage.glove_front(who, s + "Hand")
		var mid := (tip + Gate.world(stage, who, s + "Hand")) * 0.5
		var near := mid.distance_to(place)
		if str(row[3]) == "arm":
			near = Geometry3D.get_closest_point_to_segment(place, Gate.world(stage, who, s + "LowerArm"), tip).distance_to(place)
		elif str(row[3]) == "under":
			near = ((mid - place) * Vector3(1, 0, 1)).length() if mid.y < place.y else 9.0
		var front := 0.0
		if str(row[1]) == "face" and str(row[3]) == "glove":   # S554: a glove guards the face from IN FRONT of it, on the
			front = (mid - place).dot(fwd)                       # punch's line: read how far it is ACROSS that line, and
			near = ((mid - place) - fwd * front).length()        # that it is in front and not out at arm's length (the
			if front < 0.0 or front > HOLD_FRONT_M * sc:         # first bar was the plain distance to a point ON the face)
				fails.append("%s %.3f m in front of the face (bar 0 to %.2f)" % [h, front / sc, HOLD_FRONT_M])
		if near > HOLD_PLACE_M * sc:
			fails.append("%s %.3f m from the place it guards (bar %.2f)" % [h, near / sc, HOLD_PLACE_M])
		if str(row[1]) == "head" and (mid - head).dot(fwd) / sc < HOLD_EAR_AHEAD_M:
			fails.append("%s glove %.3f m ahead of the ear line (bar %.2f): it guards the ear, not the cheek" % [h, (mid - head).dot(fwd) / sc, HOLD_EAR_AHEAD_M])
		if maxf(tip.y, mid.y) > top:
			fails.append("%s glove %.3f m over the top of the head" % [h, (maxf(tip.y, mid.y) - top) / sc])
		var d := (mid - place) / sc   # read back the way the place is written: [toward him, out to the hand's side, up]
		said.append("%s %.3f m from its place [%.2f, %.2f, %.2f], %.3f m under the top of the head, %.2f m over the hips" % [h, near / sc, d.dot(fwd), d.dot(out), d.y, (top - maxf(tip.y, mid.y)) / sc, (mid.y - Gate.world(stage, who, "Hips").y) / sc])
	for s in ["Left", "Right"]:
		if held.has(s):
			continue
		var moved := (Gate.world(stage, who, s + "Hand") - head).distance_to(was[s])
		if moved > HOLD_OTHER_M * sc:
			fails.append("the other hand %.3f m from its guard (bar %.2f)" % [moved / sc, HOLD_OTHER_M])
		said.append("the other hand %.3f m from its guard" % [moved / sc])
		# the control: the bar above is read against the take's own first picture, so it cannot see an arm that was
		# ALREADY wrong there (a reach layer left on held a lead arm straight out, S553). A guard wrist is 0.22-0.27 m
		# from the face; an arm held out is over 0.5 m.
		var far := Gate.world(stage, who, s + "Hand").distance_to(stage.target_point(who, false))
		if far > HOLD_OTHER_FACE_M * sc:
			fails.append("the other hand %.3f m from the face (bar %.2f): it is not in a guard" % [far / sc, HOLD_OTHER_FACE_M])
	print("HOLD_GATE %s %s: %s" % [["red", "blue"][who], key, "; ".join(PackedStringArray(said))])
	return {"fails": fails}


func _feint_run(who: int, name: String) -> void:
	if not _has(who, FEINT[0]):
		return
	var build := func() -> Array:
		await _home_guard()
		return [[0.0, func() -> void: stage.v2._play(who, FEINT[0], 0.0, "feint", false)],
			[float(FEINT[1]), func() -> void:
				stage.v2._join_next = Player2.JOIN_HOME
				stage.v2.guard(who)]]
	await _solo(name, str(FEINT[0]), FEINT_T, build)


## The push off: both men from the tie-up, hands on the chest, out to range (PushOff.begin / step, as after a clinch).
func _push_run(_who: int, name: String) -> void:
	var mid: Vector3 = (home_t[0].origin + home_t[1].origin) * 0.5
	var keep := [stage.boxers[0]["pos"], stage.boxers[1]["pos"]]
	var build := func() -> Array:
		await _hands_free()
		for i in 2:
			var at: Vector3 = mid + axis * PUSH_GAP_M * (0.5 if i == 1 else -0.5)
			_node(i).global_position = at
			stage.boxers[i]["pos"] = Vector3(at.x, 0.0, at.z)
		PushOff.begin(stage)
		return []
	var each := func(t: float) -> void:
		if t > 0.0:
			PushOff.step(stage, 1.0 / 60.0)
		for i in 2:
			var at: Vector3 = stage.boxers[i]["pos"]
			_node(i).global_position = Vector3(at.x, _node(i).global_position.y, at.z)
	await _solo(name, "PushOff", PUSH_T, build, each)
	PushOff.cancel(stage)
	for i in 2:
		stage.boxers[i]["pos"] = keep[i]


func _clinch_run(who: int, name: String) -> void:
	var mid: Vector3 = (home_t[0].origin + home_t[1].origin) * 0.5
	var gap := float(_arg("clinch_gap", str(CLINCH_GAP.get(_arg("set", "w"), 0.66))))
	var build := func() -> Array:
		await _hands_free()
		# S554: with blue mirrored both heads lean to the SAME side and met (0.10 m apart, a head inside a head). In a
		# tie-up the heads pass cheek to cheek: blue half a head nearer the camera, red half a head further.
		var side: Vector3 = (cam.global_transform.basis.z * Vector3(1, 0, 1)).normalized() * (float(_arg("clinch_side", "0.07")) if bool(stage.boxers[1].get("south", false)) else 0.0)
		_node(0).global_position = mid - axis * gap * 0.5 - side
		_node(1).global_position = mid + axis * gap * 0.5 + side
		stage.clinch.start(who, 30.0, 0, -1)
		return []
	await _solo(name, "Clinch", CLINCH_T, build, Callable(), false, func() -> Dictionary: return Gate.clinch(stage, _view()))
	stage.clinch.holder = -1
	stage.clinch.engaged = false


func _ko_run(who: int, name: String) -> void:
	if not _has(who, KO_CLIP):
		return
	var len := (stage.boxers[who]["ap"] as AnimationPlayer).get_animation(KO_CLIP).length
	var build := func() -> Array:
		await _home_guard()
		return [[0.0, func() -> void: stage.v2._play(who, KO_CLIP, 0.0, "reaction", false)]]
	var times: Array = KO_FRAC.map(func(f) -> float: return snappedf(float(f) * len, 0.01))
	await _solo(name, KO_CLIP, times, build, Callable(), true)


## THE KNOCKDOWN COMES FROM THE PUNCH (owner S553, on the fall played by itself after the punch: "there is no hit how is
## that knock down ?"): a landed punch's own run from its contact on, the hit man going down from that blow (KO_CLIP
## started one picture after the glove arrives, as a hit reaction is). The pair, the camera and the size are the landed
## run's own; the picture is twice as wide, so the man on the canvas is still in it and nothing changes size. The page
## plays the landed run up to its contact, then this.
func _punch_ko_run(who: int, fam: String, name: String) -> void:
	# S554: the knockdown take stands in its guard for its first 0.4 s; played from 0 the hit man took the punch, stood
	# calmly for half a second and THEN fell. It is entered where the body starts to go.
	var ko_from := float(_arg("ko_from", str(KO_FROM)))
	var b := await _find(who, fam, "landed")
	if b.is_empty() or not _has(1 - who, KO_CLIP):
		print("PICS2D_ANIM no %s take on %s" % [fam, name])
		refused += 1
		return
	cover = ""
	var body: bool = FAMILIES[fam][1]
	await _pose(who, str(b["clip"]), fam, "landed", float(b["cs"]), b["hand"], body, float(b["step"]), b["side"])
	_aim([0, 1])
	var pl := _plan(who, b, fam, "landed")
	pl["ans"] = KO_CLIP
	pl["ans_kind"] = "reaction"
	pl["ans_t"] = 1.0 / 60.0
	pl["ans_from"] = ko_from
	var dirv := axis * (1.0 if who == 0 else -1.0)
	for attempt in 4:   # the landed run's own last step: the glove on the target on the contact as it is played live
		await _pose_at(who, b, pl, Vector3.ZERO, 0.0)
		await process_frame
		var m: Dictionary = Gate.punch(stage, who, b["hand"], "landed", body, dirv, _px, SIZE / cam.size, _view())
		if (m["fails"] as Array).is_empty():
			break
		var back := maxf(maxf(Gate.APART_MIN_M - float(m["apart_m"]), Gate.FEET_MIN_M - float(m["feet_m"])), Gate.HEAD_CLEAR_M - float(m["head_clear_m"]))
		b["step"] = float(b["step"]) - back - 0.02 if back > 0.0 else float(b["step"]) + float(m.get("hit_m", 0.0)) - 0.01
	var len := (stage.boxers[1 - who]["ap"] as AnimationPlayer).get_animation(KO_CLIP).length
	sv.size = Vector2i(SIZE * 2, SIZE)
	var files: Array = []
	var times: Array = []
	for off in KO_AFTER:
		if float(off) > len - ko_from - 0.05:
			break
		await _pose_at(who, b, pl, Vector3.ZERO, float(off))
		await RenderingServer.frame_post_draw
		var f := "%s_%d" % [name, files.size()]
		sv.get_texture().get_image().save_png(out_dir.path_join(f + ".png"))
		wrote += 1
		files.append(f + ".png")
		times.append(off)
	sv.size = Vector2i(SIZE, SIZE)
	for f in 3:
		await process_frame
	runs[name] = {"files": files, "offs": times, "contact": 0, "clip": str(b["clip"]), "answer": KO_CLIP, "wide": 2, "step": snappedf(float(b["step"]), 0.001), "gate_fails": []}
	print("PICS2D_ANIM %s = %s then %s, %d frames, step %.2f m" % [name, b["clip"], KO_CLIP, files.size(), float(b["step"])])
	_save()
