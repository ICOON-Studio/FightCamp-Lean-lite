extends "res://tools/pics2d_anim.gd"
## RINGANIM1 step 2 (S552): the frame runs of the Ring Switches actions that are not a punch - the feet (step in, back
## off), a hand held high or low, the feint, the push off, the clinch tying up and the knockdown. Each is the game's own
## take or layer, recorded from the fixed side camera; nothing is layered over a take.
##   step in / back off : the refitted step takes (StepPlay.TAKES: st_in_m, st_out_m), the body carried by the take's own
##                        hip travel, as StepPlay does
##   hold high          : pro_idle_to_block into pro_block_loop (the tight high guard)
##   hold low           : mc_to_block into mc_block (the body cover-up the blocked body punches use)
##   feint              : ChoreoWait's paw - the lead hand of pro_left_jab_b to 0.20 s, then home (Player2._wait)
##   push               : PushOff (hands on the chest, both pushed out to range) - the game's only push
##   clinch             : Clinch.start, as the still tool's clinch picture, seen tying up
##   knockdown          : pro_knockout_v1 from the first buckle to the canvas
## NOT here because no take exists: an overhand (the page borrows the rear hook), a one-hand hold (both hands move).
##   same command as pics2d_anim.gd with --script res://tools/pics2d_anim_more.gd

const RootPath := preload("res://scripts/fight3d/v2/RootPath.gd")
const PushOff := preload("res://scripts/fight3d/PushOff.gd")
const STEPS := {"step_in": ["st_in_m", 1.0, 0.355], "back_off": ["st_out_m", -1.0, 0.35]}   # take, way along the line, its travel (foot_db)
const STEP_T := [0.0, 0.12, 0.24, 0.36, 0.48, 0.60, 0.72, 0.86]
const HOLDS := {"hold_high": [["pro_idle_to_block", "pro_block_loop"], [0.0, 0.10, 0.20, 0.32, 0.50]],
	"hold_low": [["mc_to_block", "mc_block"], [0.0, 0.12, 0.25, 0.40, 0.60, 0.85]]}
const FEINT := ["pro_left_jab_b", 0.20]   # ChoreoWait.BEATS "paw"
const FEINT_T := [0.0, 0.07, 0.13, 0.20, 0.27, 0.36, 0.46]
const PUSH_T := [0.0, 0.10, 0.20, 0.30, 0.40, 0.55, 0.70, 0.85]
const PUSH_GAP_M := 0.68          # Clinch.PAIR_GAP_M: the push starts from the tie-up
const CLINCH_GAP := {"m": 0.68, "w": 0.62}   # Clinch.PAIR_GAP_M; the still's 0.66 / 0.60 read 0.214-0.219 m apart here (bar 0.22)
const CLINCH_T := [0.0, 0.25, 0.50, 0.80, 1.20, 2.50]
const KO_FRAC := [0.04, 0.12, 0.20, 0.30, 0.42, 0.56, 0.72, 0.97]


func _run() -> void:
	for who in 2:
		var col: String = ["red", "blue"][who]
		for key in STEPS:
			if _want("%s_%s" % [col, key]):
				await _step_run(who, str(key), "%s_%s" % [col, key])
		for key in HOLDS:
			if _want("%s_%s" % [col, key]):
				await _hold_run(who, HOLDS[key][0], HOLDS[key][1], "%s_%s" % [col, key])
		if _want(col + "_feint"):
			await _feint_run(who, col + "_feint")
		if _want(col + "_knockdown"):
			await _ko_run(who, col + "_knockdown")
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
func _step_run(who: int, key: String, name: String) -> void:
	var clip: String = STEPS[key][0]
	if not _has(who, clip):
		return
	var ap: AnimationPlayer = stage.boxers[who]["ap"]
	var way := float(STEPS[key][1])
	var dist := float(STEPS[key][2])
	var toward := axis * (1.0 if who == 0 else -1.0)
	var from: Vector3 = home_t[who].origin - (toward * dist if way > 0.0 else Vector3.ZERO)
	var path := RootPath.of(ap.get_animation(clip))
	var len := ap.get_animation(clip).length
	var build := func() -> Array:
		await _home_guard()
		_node(who).global_position = from
		return [[0.0, func() -> void: stage.v2._play(who, clip, 0.0, "step", false)]]
	var each := func(_t: float) -> void:
		var pos := ap.current_animation_position if str(ap.current_animation) == clip else len
		var frac := smoothstep(0.17 * len, 0.82 * len, pos)
		if not path.is_empty():
			var whole := RootPath.at(path, 99.0) - RootPath.at(path, 0.0)
			if whole.length() > 0.01:
				frac = clampf((RootPath.at(path, pos) - RootPath.at(path, 0.0)).dot(whole) / whole.length_squared(), 0.0, 1.0)
		_node(who).global_position = from + toward * way * dist * frac
	await _solo(name, clip, STEP_T.filter(func(t) -> bool: return float(t) <= len), build, each)


func _hold_run(who: int, clips: Array, times: Array, name: String) -> void:
	if not _has(who, clips[0]) or not _has(who, clips[1]):
		return
	var len0 := (stage.boxers[who]["ap"] as AnimationPlayer).get_animation(clips[0]).length
	var build := func() -> Array:
		await _home_guard()
		return [[0.0, func() -> void: stage.v2._play(who, clips[0], 0.0, "block", false)],
			[len0 - 0.03, func() -> void: stage.v2._play(who, clips[1], 0.0, "block", false)]]
	await _solo(name, "%s > %s" % clips, times, build)


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
	var gap := float(CLINCH_GAP.get(_arg("set", "w"), 0.66))
	var build := func() -> Array:
		await _hands_free()
		_node(0).global_position = mid - axis * gap * 0.5
		_node(1).global_position = mid + axis * gap * 0.5
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
