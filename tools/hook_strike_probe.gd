extends SceneTree
## REARHAND2 (S414): the strike on a hook. REARHAND1's window ends at "full extension" (frame furthest from chin),
## but on a hook that can be the low point itself. This finds the actual strike: the frame of highest forward speed
## after the lowest hand position. Reports strike frame, hand height at strike, frames between low and strike.
## Same read as hand_path_probe.gd: skeleton_updated, modifiers off, Engine.max_fps = 30.
##   godot_slot run -- <godot.exe> --headless --audio-driver Dummy --path . --script res://tools/hook_strike_probe.gd

const Stage := preload("res://scripts/fight3d/FightStage.gd")
const HEAD := 0
const LH := 1
const RH := 2
const HIPS := 3

const RIGHT_HOOKS := [
	"pro_right_hook", "pro_right_hook_hard", "pro_right_hook_ft", "pro_right_hook_hard_ft",
	"pro_right_hook_miss", "pro_right_hook_hurt", "pro_right_hook_hurt_ft", "pro_right_hook_special"
]
const CONTROLS := ["pro_left_jab", "pro_right_cross", "pro_left_hook"]


func _initialize() -> void:
	Engine.max_fps = 30
	var stage: Node = Stage.new()
	stage.process_mode = Node.PROCESS_MODE_DISABLED
	root.add_child(stage)
	await process_frame
	stage.setup({"glb": "res://assets/models/metahuman/mh_boxer_10.glb", "corner": "red"},
		{"glb": "res://assets/models/metahuman/mh_boxer_11.glb", "corner": "blue"})
	stage.set_process(false)
	stage.process_mode = Node.PROCESS_MODE_INHERIT
	var bx: Dictionary = stage.boxers[0]
	var skel: Skeleton3D = bx["skel"]
	var ap: AnimationPlayer = bx["ap"]
	for c in skel.get_children():
		if c is SkeletonModifier3D:
			(c as SkeletonModifier3D).active = false
	var bones: Array = [skel.find_bone("Head"), skel.find_bone("LeftHand"), skel.find_bone("RightHand"), skel.find_bone("Hips")]
	var foot_i: int = skel.find_bone("LeftFoot")
	if bones.has(-1) or foot_i < 0:
		print("HOOK_STRIKE FAIL a bone is missing: %s foot=%d" % [str(bones), foot_i])
		quit(1)
		return
	var hgt: float = (skel.get_bone_global_rest(bones[HEAD]).origin - skel.get_bone_global_rest(foot_i).origin).length()
	var reads: Array = []
	skel.skeleton_updated.connect(func():
		var r: Array = []
		for b in bones:
			r.append(skel.get_bone_global_pose(b).origin)
		reads.append(r))

	var jab_data: Array = await _read(ap, "pro_left_jab", reads)
	if jab_data.size() < 2:
		print("HOOK_STRIKE FAIL no jab frames: %d" % jab_data.size())
		quit(1)
		return
	var jab_ext: int = _ext_frame(jab_data, LH)
	var jab_line: Vector3 = (jab_data[jab_ext][LH] as Vector3) - (jab_data[0][LH] as Vector3)
	var forward := Vector3(jab_line.x, 0.0, jab_line.z).normalized()
	print("HOOK_STRIKE body=%.3f m forward=%s" % [hgt, str(forward)])

	var results: Dictionary = {}
	var clips: Array = RIGHT_HOOKS + CONTROLS
	for clip in clips:
		var data: Array = await _read(ap, clip, reads) if clip != "pro_left_jab" else jab_data
		if data.size() < 2:
			print("HOOK_STRIKE SKIP %s: %d frames" % [clip, data.size()])
			continue
		var is_hook: bool = clip.contains("hook")
		var punch_left: bool = _max_chin(data, LH) >= _max_chin(data, RH)
		var p_i: int = LH if punch_left else RH
		var analysis: Dictionary = _analyse_hook(clip, data, p_i, forward, hgt, is_hook)
		results[clip] = analysis
		print(_row_text(clip, analysis, hgt, " "))

	_write_results(results, hgt)
	print("HOOK_STRIKE DONE clips=%d" % results.size())
	quit(0)


func _read(ap: AnimationPlayer, clip: String, reads: Array) -> Array:
	var data: Array = []
	if not ap.has_animation(clip):
		return data
	var n: int = int(ap.get_animation(clip).length * 30.0)
	ap.play(clip)
	for f in n:
		ap.seek(float(f) / 30.0, true)
		ap.pause()
		reads.clear()
		await process_frame
		await process_frame
		if not reads.is_empty():
			data.append(reads.back())
	return data


static func _chin(d: Array, hand: int) -> float:
	return (d[hand] as Vector3).distance_to(d[HEAD] as Vector3)


static func _height(d: Array, hand: int) -> float:
	return (d[hand] as Vector3).y - (d[HIPS] as Vector3).y


static func _max_chin(data: Array, hand: int) -> float:
	var m: float = 0.0
	for d in data:
		m = maxf(m, _chin(d, hand))
	return m


static func _ext_frame(data: Array, hand: int) -> int:
	var best: int = 0
	var m: float = -1.0
	for f in data.size():
		var v: float = _chin(data[f], hand)
		if v > m:
			m = v
			best = f
	return best


static func _analyse_hook(clip: String, data: Array, hand_i: int, forward: Vector3, hgt: float, is_hook: bool) -> Dictionary:
	var ext: int = _ext_frame(data, hand_i)
	var h0: float = _height(data[0], hand_i)
	var low_h: float = h0
	var low_h_f: int = 0
	var low_ahead: float = INF
	var low_ahead_f: int = 0
	for f in range(0, ext + 1):
		var d: Array = data[f]
		var hand: Vector3 = d[hand_i]
		var h: float = _height(d, hand_i)
		var ahead: float = (hand - (d[HIPS] as Vector3)).dot(forward)
		if h < low_h:
			low_h = h
			low_h_f = f
		if ahead < low_ahead:
			low_ahead = ahead
			low_ahead_f = f
	var strike_f: int = low_h_f
	var strike_h: float = low_h
	var strike_ahead: float = low_ahead
	var strike_chin: float = _chin(data[low_h_f], hand_i)
	if is_hook and low_h_f < data.size() - 1:
		var best_speed: float = -INF
		for f in range(low_h_f + 1, data.size()):
			var hand_curr: Vector3 = data[f][hand_i]
			var hand_prev: Vector3 = data[f - 1][hand_i]
			var speed: float = (hand_curr - hand_prev).dot(forward)
			if speed > best_speed:
				best_speed = speed
				strike_f = f
				strike_h = _height(data[f], hand_i)
				strike_ahead = (hand_curr - (data[f][HIPS] as Vector3)).dot(forward)
				strike_chin = _chin(data[f], hand_i)
	var frames_low_to_strike: int = strike_f - low_h_f
	return {"clip": clip, "n": data.size(), "ext": ext,
		"low_h": low_h / hgt, "low_h_f": low_h_f, "low_ahead": low_ahead / hgt, "low_ahead_f": low_ahead_f,
		"strike_f": strike_f, "strike_h": strike_h / hgt, "strike_ahead": strike_ahead / hgt, "strike_chin": strike_chin / hgt,
		"frames_low_to_strike": frames_low_to_strike}


static func _row_text(clip: String, r: Dictionary, hgt: float, sep: String) -> String:
	return sep.join([
		clip, str(r["n"]),
		"low_h=%.3f" % r["low_h"], "f=%d" % r["low_h_f"],
		"low_ahead=%.3f" % r["low_ahead"], "f=%d" % r["low_ahead_f"],
		"strike_f=%d" % r["strike_f"],
		"strike_h=%.3f" % r["strike_h"],
		"strike_ahead=%.3f" % r["strike_ahead"],
		"strike_chin=%.3f" % r["strike_chin"],
		"gap=%d" % r["frames_low_to_strike"]])


static func _write_results(results: Dictionary, hgt: float) -> void:
	var lines: Array = ["# REARHAND2 result (S414)", "",
		"Model mh_boxer_10. Body height: %.3f m. Every number is a share of it." % hgt, "",
		"Low-over-hips: lowest hand height above hips (as share of body height).",
		"Ahead-of-hips: hand position on forward axis at lowest point (negative = behind hip).",
		"Strike frame: frame of highest forward speed after lowest point (hooks only).",
		"Strike height: hand height at strike frame.", "",
		"| Clip | Frm | Low over hips | f | Low ahead | f | Strike f | Strike h | Strike ahead | Strike chin | Gap |",
		"|---|---|---|---|---|---|---|---|---|---|---|"]
	for clip in results:
		var r: Dictionary = results[clip]
		lines.append("| %s | %d | %.3f | %d | %.3f | %d | %d | %.3f | %.3f | %.3f | %d |" % [
			clip, r["n"], r["low_h"], r["low_h_f"], r["low_ahead"], r["low_ahead_f"],
			r["strike_f"], r["strike_h"], r["strike_ahead"], r["strike_chin"], r["frames_low_to_strike"]])
	lines.append("")
	var f := FileAccess.open("res://docs/REARHAND2_GAME_DATA.md", FileAccess.WRITE)
	if f != null:
		f.store_string("\n".join(lines) + "\n")
