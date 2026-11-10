extends SceneTree
## KDFIX4: a downed boxer's chest may settle as the body lands, then lie still.
## Settle is chest side travel in 0-0.5 s. Sway is the same travel in 0.5-5 s, the window that reads as rocking.
## Sway with the layers on stays within 0.5 cm of the same clip with the layers off (the floor).
## Settle with the layers on stays within 3x the floor's settle.
## The KDFIX2 control stays: a knockdown played with the layers on travels at least 3x the layers-off reading.
##   python ops/Tools/godot_slot.py run --who cursor -- <godot.exe> --headless --audio-driver Dummy --path . --script res://tests/knockdown_still_test.gd

const Stage := preload("res://scripts/fight3d/FightStage.gd")

const BOXER_A := "mh_boxer_10"
const BOXER_B := "mh_boxer_12"
const FALL_CLIP := "react_hurt"
const KO_CLIP := "pro_knockout_v1"
const SAMPLE_S := 5.0
const SPLIT_S := 0.5
const TOL_CM := 0.5
const LAYERS := ["GuardWeave", "TiredSag", "FighterLife"]

var failures := 0


const STAND_S := 60.0

func _initialize() -> void:
	Engine.max_fps = 30
	print("KNOCKDOWN_STILL")
	var stage := await _make_stage()
	var bx: Dictionary = stage.boxers[0]
	var skel: Skeleton3D = bx["skel"]
	var hip_attach := _attach(skel, "Hips")
	var chest_attach := _attach(skel, "Chest")
	if hip_attach == null or chest_attach == null:
		print("FAIL missing bones")
		failures += 1
		quit(1)
		return
	# KDFIX2 tree, run once: play-from-zero with layers on, against the layers-off seek that starts at 0.5 s.
	var floor_cm: float = await _measure_floor(stage, 0, FALL_CLIP, hip_attach, chest_attach)
	var kd_all_cm: float = await _measure_knockdown(stage, 0, FALL_CLIP, hip_attach, chest_attach)
	var kd_off_cm: float = await _measure_knockdown_no_layers(stage, 0, FALL_CLIP, LAYERS, hip_attach, chest_attach)
	print("  control floor %.2f cm, all on %.2f cm, layers off %.2f cm" % [floor_cm, kd_all_cm, kd_off_cm])
	_check(kd_all_cm >= kd_off_cm * 3.0, "ruler sees layers: knockdown all on %.2f cm >= 3x layers off %.2f cm = %.2f cm" % [kd_all_cm, kd_off_cm, kd_off_cm * 3.0])
	var fall_on: Dictionary = await _windows(stage, 0, FALL_CLIP, [], hip_attach, chest_attach)
	var fall_off: Dictionary = await _windows(stage, 0, FALL_CLIP, LAYERS, hip_attach, chest_attach)
	var ko_on: Dictionary = await _windows(stage, 0, KO_CLIP, [], hip_attach, chest_attach)
	var ko_off: Dictionary = await _windows(stage, 0, KO_CLIP, LAYERS, hip_attach, chest_attach)
	print("  knockdown settle all on %.2f cm, floor %.2f cm (limit %.2f)" % [fall_on["settle"], fall_off["settle"], fall_off["settle"] * 3.0])
	print("  knockdown sway all on %.2f cm, floor %.2f cm" % [fall_on["sway"], fall_off["sway"]])
	print("  knockout settle all on %.2f cm, floor %.2f cm (limit %.2f)" % [ko_on["settle"], ko_off["settle"], ko_off["settle"] * 3.0])
	print("  knockout sway all on %.2f cm, floor %.2f cm" % [ko_on["sway"], ko_off["sway"]])
	_check(fall_on["settle"] <= fall_off["settle"] * 3.0, "knockdown settle %.2f cm <= 3x floor settle %.2f cm" % [fall_on["settle"], fall_off["settle"]])
	_check(ko_on["settle"] <= ko_off["settle"] * 3.0, "knockout settle %.2f cm <= 3x floor settle %.2f cm" % [ko_on["settle"], ko_off["settle"]])
	_check(absf(fall_on["sway"] - fall_off["sway"]) <= TOL_CM, "knockdown sway after 0.5 s %.2f cm within %.1f cm of floor %.2f cm" % [fall_on["sway"], TOL_CM, fall_off["sway"]])
	_check(absf(ko_on["sway"] - ko_off["sway"]) <= TOL_CM, "knockout sway after 0.5 s %.2f cm within %.1f cm of floor %.2f cm" % [ko_on["sway"], TOL_CM, ko_off["sway"]])
	print("KNOCKDOWN_STILL failures=%d" % failures)
	quit(0 if failures == 0 else 1)


func _check(cond: bool, label: String) -> void:
	if cond:
		print("PASS " + label)
	else:
		failures += 1
		print("FAIL " + label)


func _make_stage() -> Node3D:
	var stg: Node3D = Stage.new()
	root.add_child(stg)
	stg.set_process(false)
	await process_frame
	stg.setup({"glb": "res://assets/models/metahuman/%s.glb" % BOXER_A, "corner": "red"},
		{"glb": "res://assets/models/metahuman/%s.glb" % BOXER_B, "corner": "blue"})
	stg.set_process(true)
	for i in 3:
		await process_frame
	# S427: the same hold as block_meet_test (S426). A rhythm step or a fidget starting mid-read moved the sway
	# 0.00-0.94 cm run to run (1 red in 2-3 runs); the read is about the layers on a downed body, not the stage's idle life.
	stg.feet._pause = [STAND_S, STAND_S]
	stg.life._quiet = [STAND_S, STAND_S]
	return stg


func _attach(skel: Skeleton3D, bone: String) -> BoneAttachment3D:
	var nm := "kdfix4_" + bone
	var n: Node = skel.get_node_or_null(nm)
	if n != null and n is BoneAttachment3D:
		return n as BoneAttachment3D
	var ba := BoneAttachment3D.new()
	ba.name = nm
	ba.bone_name = bone
	skel.add_child(ba)
	return ba


func _chest_side(hip_attach: BoneAttachment3D, chest_attach: BoneAttachment3D) -> float:
	if hip_attach == null or chest_attach == null:
		return 0.0
	var hips_pos: Vector3 = hip_attach.global_transform.origin
	var chest_pos: Vector3 = chest_attach.global_transform.origin
	var hips_to_chest: Vector3 = chest_pos - hips_pos
	var hips_basis: Basis = hip_attach.global_transform.basis
	var hips_left: Vector3 = hips_basis.x.normalized()
	var hips_up: Vector3 = hips_basis.y.normalized()
	var side_in_hips: Vector3 = hips_left - hips_up * hips_left.dot(hips_up)
	if side_in_hips.length() < 0.001:
		return 0.0
	return hips_to_chest.dot(side_in_hips.normalized())


## 0-0.5 s and 0.5-5 s on one play. `drop` layers are off for the play. A fixed idle warms the stack
## the same way every time (stage.guard picks a random captured guard). The clip is stepped at 1/30 s
## so a slow frame cannot move the 0.5 s split, and each step is padded to that same 1/30 s so the
## other modifiers see one steady delta.
func _windows(stage: Node3D, who: int, clip: String, drop: Array, hip_attach: BoneAttachment3D, chest_attach: BoneAttachment3D) -> Dictionary:
	var bx: Dictionary = stage.boxers[who]
	var skel: Skeleton3D = bx["skel"]
	var ap: AnimationPlayer = bx["ap"]
	var empty := {"settle": 0.0, "sway": 0.0}
	if not ap.has_animation(clip):
		return empty
	bx["move_left"] = 99.0
	var idle := "pro_idle" if ap.has_animation("pro_idle") else "idle"
	if ap.has_animation(idle):
		ap.play(idle, 0.0, 1.0)
		ap.seek(0.0, true)
	for i in 12:
		await process_frame
	var removed := _drop(skel, drop)
	var prev_mode := ap.callback_mode_process
	ap.callback_mode_process = AnimationMixer.ANIMATION_CALLBACK_MODE_PROCESS_MANUAL
	ap.play(clip, 0.0, 1.0)
	var settle_lo := 999.0
	var settle_hi := -999.0
	var sway_lo := 999.0
	var sway_hi := -999.0
	var settle_n := 0
	var sway_n := 0
	var step_us := int(1000000.0 / 30.0)
	var t0 := Time.get_ticks_usec()
	var steps := int(SAMPLE_S * 30.0)
	for i in steps:
		ap.advance(1.0 / 30.0)
		await process_frame
		var side: float = _chest_side(hip_attach, chest_attach)
		if float(i + 1) / 30.0 <= SPLIT_S:
			settle_lo = minf(settle_lo, side)
			settle_hi = maxf(settle_hi, side)
			settle_n += 1
		else:
			sway_lo = minf(sway_lo, side)
			sway_hi = maxf(sway_hi, side)
			sway_n += 1
		var wait_us := t0 + (i + 1) * step_us - Time.get_ticks_usec()
		if wait_us > 0:
			OS.delay_usec(wait_us)
	ap.callback_mode_process = prev_mode
	_restore(skel, removed)
	bx["move_left"] = 0.0
	return {"settle": _span(settle_lo, settle_hi, settle_n), "sway": _span(sway_lo, sway_hi, sway_n)}


func _span(lo: float, hi: float, n: int) -> float:
	if n <= 0:
		return 0.0
	return (hi - lo) * 100.0


func _drop(skel: Skeleton3D, names: Array) -> Array:
	var found: Array = []
	for layer_name in names:
		var layer: Node = skel.get_node_or_null(str(layer_name))
		if layer != null:
			found.append(layer)
	found.sort_custom(func(a: Node, b: Node) -> bool: return a.get_index() > b.get_index())
	var removed: Array = []
	for layer in found:
		var at: int = (layer as Node).get_index()
		skel.remove_child(layer)
		removed.append({"n": layer, "i": at})
	return removed


func _restore(skel: Skeleton3D, removed: Array) -> void:
	var back: Array = removed.duplicate()
	back.reverse()
	for item in back:
		var layer: Node = item["n"]
		skel.add_child(layer)
		skel.move_child(layer, mini(int(item["i"]), skel.get_child_count() - 1))


## KDFIX2 control, layers off, seek from 0.5 s: the floor the ruler was proved against.
func _measure_floor(stage: Node3D, who: int, clip: String, hip_attach: BoneAttachment3D, chest_attach: BoneAttachment3D) -> float:
	return await _measure_seek(stage, who, clip, LAYERS, hip_attach, chest_attach)


func _measure_knockdown_no_layers(stage: Node3D, who: int, clip: String, layer_names: Array, hip_attach: BoneAttachment3D, chest_attach: BoneAttachment3D) -> float:
	return await _measure_seek(stage, who, clip, layer_names, hip_attach, chest_attach)


func _measure_seek(stage: Node3D, who: int, clip: String, layer_names: Array, hip_attach: BoneAttachment3D, chest_attach: BoneAttachment3D) -> float:
	var bx: Dictionary = stage.boxers[who]
	var skel: Skeleton3D = bx["skel"]
	var ap: AnimationPlayer = bx["ap"]
	if not ap.has_animation(clip):
		return 0.0
	var removed := _drop(skel, layer_names)
	var length: float = ap.get_animation(clip).length
	var lo := 999.0
	var hi := -999.0
	var n := 0
	stage.set_process(false)
	for i in 3:
		await process_frame
	ap.play(clip, 0.0, 1.0)
	var t := 0.5
	while t <= minf(length - 0.2, SAMPLE_S):
		ap.seek(t, true)
		for i in 2:
			await process_frame
		var side: float = _chest_side(hip_attach, chest_attach)
		lo = minf(lo, side)
		hi = maxf(hi, side)
		n += 1
		t += 0.1
	stage.set_process(true)
	for i in 3:
		await process_frame
	_restore(skel, removed)
	return _span(lo, hi, n)


## KDFIX2 control: play the clip with the layers on, from the first frame through the clip.
func _measure_knockdown(stage: Node3D, who: int, clip: String, hip_attach: BoneAttachment3D, chest_attach: BoneAttachment3D) -> float:
	var bx: Dictionary = stage.boxers[who]
	var ap: AnimationPlayer = bx["ap"]
	if not ap.has_animation(clip):
		return 0.0
	var length: float = ap.get_animation(clip).length
	var lo := 999.0
	var hi := -999.0
	var n := 0
	ap.play(clip, 0.0, 1.0)
	var t := 0.0
	var sample_end: float = minf(length - 0.2, SAMPLE_S)
	while t < sample_end:
		await process_frame
		var side: float = _chest_side(hip_attach, chest_attach)
		lo = minf(lo, side)
		hi = maxf(hi, side)
		n += 1
		t += 1.0 / 30.0
	for i in 3:
		await process_frame
	return _span(lo, hi, n)
