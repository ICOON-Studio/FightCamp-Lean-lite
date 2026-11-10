extends SceneTree
## REARHAND5B: blend the right hook's arm bones toward the guard pose in the wind-up.
## For RightUpperArm, RightLowerArm, RightHand rotation tracks, each key from f0 to fs
## becomes orig.slerp(guard, w) where guard is that track's value at frame 0.
## w rises smoothly from 0 at f0 to W over RISE frames, holds, then falls to 0 at fs over FALL frames.
## Writes ONLY the three arm bone rotation tracks. Frames outside f0..fs are untouched.
## Refuses to run twice: sets meta "rear_hook_lift" on the saved Animation.
##   godot_slot run -- <godot.exe> --headless --audio-driver Dummy --path . --script res://tools/rear_hook_lift.gd

const Stage := preload("res://scripts/fight3d/FightStage.gd")
const BAKED := "res://assets/anim/baked/"
const CLIPS := ["mc_Box1_M3_Right_Hook.res", "mc_Box1_M3_Right_Hook_FT.res"]
const CLIP_NAMES := ["pro_right_hook", "pro_right_hook_ft"]
const META_KEY := "rear_hook_lift"
const FPS := 30.0
const W := 0.60
const RISE := 2
const FALL := 2
const BONES := ["RightUpperArm", "RightLowerArm", "RightHand"]


func _initialize() -> void:
	Engine.max_fps = int(FPS)
	var stage: Node3D = Stage.new()
	root.add_child(stage)
	await process_frame
	stage.setup({"glb": "res://assets/models/metahuman/mh_boxer_10.glb", "corner": "red"},
		{"glb": "res://assets/models/metahuman/mh_boxer_11.glb", "corner": "blue"})
	stage.set_process(false)
	var bx: Dictionary = stage.boxers[0]
	var skel: Skeleton3D = bx["skel"]
	for c in skel.get_children():
		if c is SkeletonModifier3D:
			(c as SkeletonModifier3D).active = false

	for i in CLIPS.size():
		var clip_file: String = CLIPS[i]
		var clip_name: String = CLIP_NAMES[i]
		var path: String = BAKED + clip_file
		var anim: Animation = load(path)
		if anim == null:
			print("REAR_HOOK_LIFT SKIP %s: load failed" % clip_file)
			continue
		if anim.has_meta(META_KEY):
			print("REAR_HOOK_LIFT SKIP %s: already lifted" % clip_file)
			continue
		var ap: AnimationPlayer = bx["ap"]
		var lib: AnimationLibrary = ap.get_animation_library("")
		var retargeted_anim: Animation = lib.get_animation(clip_name)
		var orig_path: String = "res://.godot/orig_" + clip_name + ".res"
		ResourceSaver.save(retargeted_anim, orig_path)
		var orig_raw_path: String = "res://.godot/orig_raw_" + clip_name + ".res"
		ResourceSaver.save(anim, orig_raw_path)
		print("REAR_HOOK_LIFT saved original to %s (retargeted) and %s (raw)" % [orig_path, orig_raw_path])
		var result: Dictionary = _blend_clip(anim, bx, clip_name, skel)
		if result.is_empty():
			print("REAR_HOOK_LIFT FAIL %s: no blend applied" % clip_file)
			continue
		anim.set_meta(META_KEY, true)
		var err := ResourceSaver.save(anim, path)
		if err != OK:
			print("REAR_HOOK_LIFT FAIL %s: save error %d" % [clip_file, err])
		else:
			print("REAR_HOOK_LIFT %s f0=%d fs=%d W=%.2f RISE=%d FALL=%d keys=%d" % [
				clip_file, result["f0"], result["fs"], W, RISE, FALL, result["keys"]])
	print("REAR_HOOK_LIFT DONE")
	quit(0)


func _blend_clip(anim: Animation, bx: Dictionary, clip_name: String, skel: Skeleton3D) -> Dictionary:
	var tracks: Array = []
	for bone in BONES:
		var t: int = _find_track(anim, bone)
		if t < 0:
			return {}
		tracks.append(t)

	var n_frames: int = int(anim.length * FPS)
	if n_frames < 3:
		return {}

	var hand_positions: Array = []
	for f in n_frames:
		var t: float = float(f) / FPS
		hand_positions.append(Stage.IdleMatch.pose_point(bx, clip_name, t, "RightHand"))

	var f0: int = _find_fall_start(hand_positions)
	var fs: int = _find_strike_frame(hand_positions)
	if f0 >= fs or fs - f0 < 2:
		return {}

	var t_f0: float = float(f0) / FPS
	var t_fs: float = float(fs) / FPS

	var guards: Array = []
	for tr in tracks:
		guards.append(anim.rotation_track_interpolate(tr, 0.0))

	var keys_applied: int = 0
	for ti in tracks.size():
		var tr: int = tracks[ti]
		var guard: Quaternion = guards[ti]
		for k in anim.track_get_key_count(tr):
			var kt: float = anim.track_get_key_time(tr, k)
			if kt < t_f0 or kt > t_fs:
				continue
			var orig: Quaternion = anim.track_get_key_value(tr, k)
			var w: float = _weight(kt, t_f0, t_fs)
			var blended: Quaternion = orig.slerp(guard, w)
			anim.track_set_key_value(tr, k, blended)
			keys_applied += 1

	return {"f0": f0, "fs": fs, "keys": keys_applied}


func _weight(t: float, t_f0: float, t_fs: float) -> float:
	var t_rise_end: float = t_f0 + float(RISE) / FPS
	var t_fall_start: float = t_fs - float(FALL) / FPS
	if t_rise_end >= t_fall_start:
		var mid: float = (t_f0 + t_fs) * 0.5
		if t <= t_f0 or t >= t_fs:
			return 0.0
		var half: float = (t_fs - t_f0) * 0.5
		if half <= 0.0:
			return 0.0
		if t <= mid:
			var p: float = (t - t_f0) / half
			return W * _smooth(p)
		else:
			var p: float = (t_fs - t) / half
			return W * _smooth(p)
	if t <= t_f0 or t >= t_fs:
		return 0.0
	if t < t_rise_end:
		var p: float = (t - t_f0) / (t_rise_end - t_f0)
		return W * _smooth(p)
	if t > t_fall_start:
		var p: float = (t_fs - t) / (t_fs - t_fall_start)
		return W * _smooth(p)
	return W


func _smooth(x: float) -> float:
	x = clampf(x, 0.0, 1.0)
	return x * x * (3.0 - 2.0 * x)


func _find_track(anim: Animation, bone: String) -> int:
	for i in anim.get_track_count():
		if anim.track_get_type(i) == Animation.TYPE_ROTATION_3D and str(anim.track_get_path(i)) == bone:
			return i
	return -1


func _find_fall_start(hand_positions: Array) -> int:
	if hand_positions.size() < 3:
		return 0
	var min_y: float = hand_positions[0].y
	var min_f: int = 0
	for f in hand_positions.size():
		if hand_positions[f].y < min_y:
			min_y = hand_positions[f].y
			min_f = f
	var start_f: int = 0
	for f in range(min_f):
		if hand_positions[f].y > hand_positions[start_f].y:
			start_f = f
	return start_f


func _find_strike_frame(hand_positions: Array) -> int:
	if hand_positions.size() < 3:
		return hand_positions.size() - 1
	var min_y: float = hand_positions[0].y
	var min_f: int = 0
	for f in hand_positions.size():
		if hand_positions[f].y < min_y:
			min_y = hand_positions[f].y
			min_f = f
	var best_speed: float = -INF
	var strike_f: int = min_f
	for f in range(min_f, hand_positions.size()):
		if f > 0:
			var speed: float = (hand_positions[f] - hand_positions[f - 1]).length()
			if speed > best_speed:
				best_speed = speed
				strike_f = f
	return strike_f
