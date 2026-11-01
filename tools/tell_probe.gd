extends SceneTree
## S343 TELLS1 probe: measures whether the tells show on her body. Builds a FightStage the way TapeFilm does (two
## MetaHuman bodies, red "a" and blue "b"), and for each film shape fires TapeClips's beats through BeatFire in real time,
## measuring on HER SKELETON (bone global positions, never a value the module reports about itself).
##   hand_drop: rear glove height below head at guard (g0) and lowest within 0.6s after jab contact (g1)
##   lunge: pelvis travel toward other woman and chest forward lean at contact
##   tired_guard: both gloves below head, held
##   hands_low: like tired_guard but shorter
## Headless: $GODOT_EXE --headless --audio-driver Dummy --path . --script res://tools/tell_probe.gd
## Windowed (for stills): xvfb-run -a -s "-screen 0 1920x1080x24" $GODOT_EXE --path . --windowed --resolution 1280x720
##     --audio-driver Dummy --fixed-fps 30 --script res://tools/tell_probe.gd -- show3d fastdraw

const Stage := preload("res://scripts/fight3d/FightStage.gd")
const BeatFire := preload("res://scripts/fight3d/BeatFire.gd")
const TapeClips := preload("res://scripts/rules/TapeClips.gd")
const BeatClips := preload("res://scripts/fight3d/BeatClips.gd")
const RangeBreath := preload("res://scripts/fight3d/RangeBreath.gd")
const HZ := 60.0

## Pass thresholds (from the task).
const HAND_DROP_MIN := 0.30   # S347 control (no tell) 0.21, tell 0.42
const HAND_DROP_BACK_MIN := 0.15
const LUNGE_TRAVEL_MIN := 0.22
const LUNGE_LEAN_GAIN := 28.0   # S347: the jab alone leans 23.0 deg over her guard (notell control)
const LUNGE_BACK_M := 0.15
const TIRED_GUARD_LOW_MIN := 0.25   # S347 control 0.13 / 0.09, tell 0.37 / 0.35
const TIRED_GUARD_HELD_MIN := 1.0
const HANDS_LOW_HELD_MIN := 0.8

var _stage: Node3D
var _beat: BeatFire
var _pass := 0


## A stub view for BeatFire (it reads stage, _amb_rng, t, _profiles, _stop, _close_left, body, pace).
class View:
	extends Node
	var stage: Node3D
	var _amb_rng: RandomNumberGenerator
	var t := 0.0
	var _profiles := {"a": {}, "b": {}}
	var _stop := ""
	var _close_left := 0.0
	var body: RefCounted
	func pace() -> float:
		return 1.0
	class NoBody:
		extends RefCounted
		func land(_b: Dictionary, _at: float) -> void:
			pass
	func _init(s: Node3D) -> void:
		stage = s
		_amb_rng = RandomNumberGenerator.new()
		body = NoBody.new()


func _initialize() -> void:
	_stage = Stage.new()
	root.add_child(_stage)
	await process_frame
	# Two bodies: red "a" (the opponent she fought), blue "b" (her).
	_stage.setup({"glb": "res://assets/models/metahuman/mh_boxer_10.glb", "corner": "red", "stance": "orthodox"},
		{"glb": "res://assets/models/metahuman/mh_boxer_11.glb", "corner": "blue", "stance": "orthodox"})
	_beat = BeatFire.new()
	_watch(0)
	_watch(1)
	# Measure each tell (must await - they are coroutines with await inside).
	await _measure_hand_drop()
	await _measure_lunge()
	await _measure_tired_guard()
	await _measure_hands_low()
	print("TELL OK %d/4" % _pass)
	quit(0 if _pass == 4 else 1)


## Bone world position for boxer `who`, bone `name`.
## S347: read the pose AS SHOWN. Outside the modifier pass get_bone_global_pose returns the animation's pose (Godot restores
## it after the skin update), so r1/r2 never saw TellPose (the same 0.158 m before and after the fix). skeleton_updated fires
## after every modifier, before the restore: the bones are cached there.
var _shown := [{}, {}]
const SHOWN_BONES := ["Head", "Hips", "Chest", "LeftHand", "RightHand"]

func _watch(who: int) -> void:
	var skel: Skeleton3D = _stage.boxers[who]["skel"]
	skel.skeleton_updated.connect(func() -> void:
		var d := {}
		for n in SHOWN_BONES:
			var bi := skel.find_bone(n)
			if bi >= 0:
				d[n] = skel.global_transform * skel.get_bone_global_pose(bi).origin
		_shown[who] = d)


func _bone_pos(who: int, bone_name: String) -> Vector3:
	return (_shown[who] as Dictionary).get(bone_name, Vector3.ZERO)


## Steps the simulation for `dt` seconds, firing beats up to the current time.
func _step(view: View, beats: Array, next_idx: Array, dt: float) -> void:
	view.t += dt
	while next_idx[0] < beats.size() and float(beats[next_idx[0]]["t"]) <= view.t:
		_beat.fire(view, beats[next_idx[0]])
		next_idx[0] += 1
	# Process the stage (modifiers run)
	for i in 3:
		await process_frame


## Finds the beat index for a specific move by boxer "b".
func _find_beat(beats: Array, move: String) -> int:
	for i in beats.size():
		if str(beats[i]["who"]) == "b" and str(beats[i]["move"]) == move:
			return i
	return -1


## Measures hand_drop: rear glove drops after jab.
func _measure_hand_drop() -> void:
	var shape := "drops_right"
	var clip: Dictionary = _make_clip(shape)
	var beats: Array = clip["beats"]
	var view := View.new(_stage)
	root.add_child(view)
	view._amb_rng.seed = hash(shape)
	_beat.reset()
	# Reset boxer positions
	_stage.boxers[0]["pos"] = Vector3(0, 0, -_stage.gap_m * 0.5)
	_stage.boxers[1]["pos"] = Vector3(0, 0, _stage.gap_m * 0.5)
	_stage.guard(0)
	_stage.guard(1)
	# Find the jab beat (has the tell)
	var jab_idx := _find_beat(beats, "jab")
	if jab_idx < 0:
		print("TELL hand_drop SKIP no jab beat")
		return
	var jab_t: float = float(beats[jab_idx]["t"])
	var contact: float = BeatClips.contact("jab", float(Stage.CONTACT_S))
	# Step to just before the jab, measure guard height (g0)
	var next_idx := [0]
	var pre_t := jab_t - 0.1
	while next_idx[0] < beats.size() and float(beats[next_idx[0]]["t"]) <= pre_t:
		_beat.fire(view, beats[next_idx[0]])
		next_idx[0] += 1
	# Wait for the pose to settle
	for i in 6:
		await process_frame
	var g0: float = _rear_glove_height() - _head_height()
	# Step through the jab and measure lowest point within 0.6s after contact
	var lowest := g0
	var lowest_t := 0.0
	var measure_end := jab_t + contact + 0.6
	var dt := 1.0 / HZ
	var t := pre_t
	while t < measure_end:
		t += dt
		view.t = t
		while next_idx[0] < beats.size() and float(beats[next_idx[0]]["t"]) <= t:
			_beat.fire(view, beats[next_idx[0]])
			next_idx[0] += 1
		for i in 1:
			await process_frame
		var h: float = _rear_glove_height() - _head_height()
		if h < lowest:
			lowest = h
			lowest_t = t
	# Measure recovery: height at +1.2s after contact
	var recover_t := jab_t + contact + 1.2
	while view.t < recover_t:
		view.t += dt
		for i in 1:
			await process_frame
	var g1: float = _rear_glove_height() - _head_height()
	var drop: float = g0 - lowest
	var back: float = g1 - lowest
	var ok := drop >= HAND_DROP_MIN and back >= HAND_DROP_BACK_MIN
	if ok:
		_pass += 1
	print("TELL hand_drop drop=%.3f back=%.3f %s" % [drop, back, "PASS" if ok else "FAIL"])


## Rear glove height (boxer 1, blue, "b").
func _rear_glove_height() -> float:
	# For orthodox stance, rear hand is RightHand
	var hand_bone := "RightHand"
	if bool(_stage.boxers[1].get("south", false)):
		hand_bone = "LeftHand"
	return _bone_pos(1, hand_bone).y


## Head height (boxer 1).
func _head_height() -> float:
	return _bone_pos(1, "Head").y


## Pelvis position (boxer 1).
func _pelvis_pos() -> Vector3:
	return _bone_pos(1, "Hips")


## Measures lunge: pelvis travel and chest lean during jab.
func _measure_lunge() -> void:
	var shape := "lunges"
	var clip: Dictionary = _make_clip(shape)
	var beats: Array = clip["beats"]
	var view := View.new(_stage)
	root.add_child(view)
	view._amb_rng.seed = hash(shape)
	_beat.reset()
	# Reset positions
	_stage.boxers[0]["pos"] = Vector3(0, 0, -_stage.gap_m * 0.5)
	_stage.boxers[1]["pos"] = Vector3(0, 0, _stage.gap_m * 0.5)
	_stage.guard(0)
	_stage.guard(1)
	# Find the jab beat
	var jab_idx := _find_beat(beats, "jab")
	if jab_idx < 0:
		print("TELL lunge SKIP no jab beat")
		return
	var jab_t: float = float(beats[jab_idx]["t"])
	var contact: float = BeatClips.contact("jab", float(Stage.CONTACT_S))
	# Step to just before the jab, measure start position
	var next_idx := [0]
	var pre_t := jab_t - 0.2
	while next_idx[0] < beats.size() and float(beats[next_idx[0]]["t"]) <= pre_t:
		_beat.fire(view, beats[next_idx[0]])
		next_idx[0] += 1
	for i in 8:
		await process_frame
	var start_pos: Vector3 = _pelvis_pos()
	# S347: the lean is the GAIN over her own guard lean (the guard alone read 18.8 deg, over the old absolute 12).
	var lean0: float = _chest_lean_deg()
	# Step through the jab, measure furthest point
	var furthest := 0.0
	var max_lean := 0.0
	var measure_end := jab_t + contact + 0.5
	var dt := 1.0 / HZ
	var t := pre_t
	while t < measure_end:
		t += dt
		view.t = t
		while next_idx[0] < beats.size() and float(beats[next_idx[0]]["t"]) <= t:
			_beat.fire(view, beats[next_idx[0]])
			next_idx[0] += 1
		for i in 1:
			await process_frame
		var pos: Vector3 = _pelvis_pos()
		# Travel toward the other woman (in -Z direction for boxer 1 facing boxer 0)
		var travel: float = start_pos.z - pos.z
		if travel > furthest:
			furthest = travel
		# Measure chest lean
		var lean: float = _chest_lean_deg()
		if lean > max_lean:
			max_lean = lean
	# Measure recovery: position at +1.5s
	var recover_t := jab_t + contact + 1.5
	while view.t < recover_t:
		view.t += dt
		for i in 1:
			await process_frame
	var end_pos: Vector3 = _pelvis_pos()
	var back_travel: float = end_pos.z - start_pos.z
	var ok := furthest >= LUNGE_TRAVEL_MIN and max_lean - lean0 >= LUNGE_LEAN_GAIN and back_travel <= LUNGE_BACK_M
	if ok:
		_pass += 1
	print("TELL lunge travel=%.3f lean=%.1f gain=%.1f %s" % [furthest, max_lean, max_lean - lean0, "PASS" if ok else "FAIL"])


## Chest forward lean in degrees (boxer 1).
func _chest_lean_deg() -> float:
	# S347: head over hips as shown (a chest bone turning about its own origin never moved the chest origin).
	var up: Vector3 = (_bone_pos(1, "Head") - _bone_pos(1, "Hips")).normalized()
	# Lean is the angle from vertical
	var angle := rad_to_deg(up.angle_to(Vector3.UP))
	return angle


## Measures tired_guard: both gloves low, held.
func _measure_tired_guard() -> void:
	var shape := "tiring"
	var clip: Dictionary = _make_clip(shape)
	var beats: Array = clip["beats"]
	var view := View.new(_stage)
	root.add_child(view)
	view._amb_rng.seed = hash(shape)
	_beat.reset()
	# Reset positions
	_stage.boxers[0]["pos"] = Vector3(0, 0, -_stage.gap_m * 0.5)
	_stage.boxers[1]["pos"] = Vector3(0, 0, _stage.gap_m * 0.5)
	_stage.guard(0)
	_stage.guard(1)
	# Find the tired beat (has the tell)
	var tired_idx := _find_beat(beats, "tired")
	if tired_idx < 0:
		print("TELL tired_guard SKIP no tired beat")
		return
	var tired_t: float = float(beats[tired_idx]["t"])
	# Step to just before the tired beat
	var next_idx := [0]
	var pre_t := tired_t - 0.1
	while next_idx[0] < beats.size() and float(beats[next_idx[0]]["t"]) <= pre_t:
		_beat.fire(view, beats[next_idx[0]])
		next_idx[0] += 1
	for i in 6:
		await process_frame
	var g0: float = _both_gloves_height()
	# Step through and measure how long both gloves are low
	var held := 0.0
	var lowest := g0
	var dt := 1.0 / HZ
	var measure_end := tired_t + 2.5
	var t := pre_t
	while t < measure_end:
		t += dt
		view.t = t
		while next_idx[0] < beats.size() and float(beats[next_idx[0]]["t"]) <= t:
			_beat.fire(view, beats[next_idx[0]])
			next_idx[0] += 1
		for i in 1:
			await process_frame
		var h: float = _both_gloves_height()
		if h < g0 - TIRED_GUARD_LOW_MIN:
			held += dt
		if h < lowest:
			lowest = h
	var low := g0 - lowest
	var ok := low >= TIRED_GUARD_LOW_MIN and held >= TIRED_GUARD_HELD_MIN
	if ok:
		_pass += 1
	print("TELL tired_guard low=%.3f held=%.2f %s" % [low, held, "PASS" if ok else "FAIL"])


## Both gloves' average height relative to head (boxer 1). Lower is more negative.
func _both_gloves_height() -> float:
	var head_y: float = _head_height()
	var left_hand := "LeftHand"
	var right_hand := "RightHand"
	if bool(_stage.boxers[1].get("south", false)):
		left_hand = "RightHand"
		right_hand = "LeftHand"
	var left_y: float = _bone_pos(1, left_hand).y
	var right_y: float = _bone_pos(1, right_hand).y
	return (left_y + right_y) * 0.5 - head_y


## Measures hands_low: both gloves low, held (shorter than tired_guard).
func _measure_hands_low() -> void:
	var shape := "admires"
	var clip: Dictionary = _make_clip(shape)
	var beats: Array = clip["beats"]
	var view := View.new(_stage)
	root.add_child(view)
	view._amb_rng.seed = hash(shape)
	_beat.reset()
	# Reset positions
	_stage.boxers[0]["pos"] = Vector3(0, 0, -_stage.gap_m * 0.5)
	_stage.boxers[1]["pos"] = Vector3(0, 0, _stage.gap_m * 0.5)
	_stage.guard(0)
	_stage.guard(1)
	# Find the say beat (has the tell)
	var say_idx := _find_beat(beats, "say")
	if say_idx < 0:
		print("TELL hands_low SKIP no say beat")
		return
	var say_t: float = float(beats[say_idx]["t"])
	# Step to just before the say beat
	var next_idx := [0]
	var pre_t := say_t - 0.1
	while next_idx[0] < beats.size() and float(beats[next_idx[0]]["t"]) <= pre_t:
		_beat.fire(view, beats[next_idx[0]])
		next_idx[0] += 1
	for i in 6:
		await process_frame
	var g0: float = _both_gloves_height()
	# Step through and measure how long both gloves are low
	var held := 0.0
	var lowest := g0
	var dt := 1.0 / HZ
	var measure_end := say_t + 2.0
	var t := pre_t
	while t < measure_end:
		t += dt
		view.t = t
		while next_idx[0] < beats.size() and float(beats[next_idx[0]]["t"]) <= t:
			_beat.fire(view, beats[next_idx[0]])
			next_idx[0] += 1
		for i in 1:
			await process_frame
		var h: float = _both_gloves_height()
		if h < g0 - TIRED_GUARD_LOW_MIN:
			held += dt
		if h < lowest:
			lowest = h
	var low := g0 - lowest
	var ok := low >= TIRED_GUARD_LOW_MIN and held >= HANDS_LOW_HELD_MIN
	if ok:
		_pass += 1
	print("TELL hands_low low=%.3f held=%.2f %s" % [low, held, "PASS" if ok else "FAIL"])


## Makes a clip dictionary for a shape (copied from TapeClips._clip structure).
func _make_clip(shape: String) -> Dictionary:
	var s: Dictionary = TapeClips.SHAPES[shape]
	var beats: Array = []
	var nodes: Array = []
	for r in s["beats"]:
		var b := {"t": float(r[0]), "who": str(r[1]), "move": str(r[2]), "result": str(r[3]), "def": str(r[4]),
			"caption": "", "big": false, "knockback": false}
		var pose: Array = TapeClips.TELL_POSES.get(shape, [])
		# S347 `-- notell`: the control arm (same clips, no tell) must read under every bound.
		if not pose.is_empty() and str(r[1]) == "b" and str(r[2]) == str(pose[0]) and not OS.get_cmdline_user_args().has("notell"):
			b["tell"] = str(pose[1])
		if str(r[5]) != "":
			b["node"] = nodes.size()
			nodes.append({"t": float(r[0]), "title": str(r[5]), "line": str(r[6]), "edge": str(r[7]), "who": str(r[1]),
				"tell": nodes.size() == int(s["tell"])})
		beats.append(b)
	return {"shape": shape, "beats": beats, "nodes": nodes, "tell_node": int(s["tell"]), "seconds": float(s["seconds"])}
