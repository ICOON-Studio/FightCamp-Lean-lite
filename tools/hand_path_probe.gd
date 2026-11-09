extends SceneTree
## REARHAND1 (S413, probe corrected S414): a judge said the hand drops to or behind the hip before a punch and the guard
## sags after. This measures every punch clip the fight can pick, the benched takes and two controls, frame by frame at 30 fps,
## read inside skeleton_updated with modifiers off.
## S414 fixes to Qwen's first version: the punching and other hand were swapped; "height" was the hips' local offset (hip
## height), now the head joint above the foot joint in the rest pose; "behind the hip" is now measured on the boxer's forward axis.
## Numbers are shares of that body height. Controls must pass or no table is written.
## Reading it: "full extension" is the frame furthest from the chin. On hooks that can be the low point itself, because a low hand
## is further from the head than a bent-arm hook at head height, so the window can end before the strike. DROP's 0.05 is tight:
## the jab control trips it. HIP and BEHIND are the flags that answer the judge.
##   godot_slot run -- <godot.exe> --headless --audio-driver Dummy --path . --script res://tools/hand_path_probe.gd

const Stage := preload("res://scripts/fight3d/FightStage.gd")
const OFF_TAKES := ["pro_left_jab_special", "pro_left_jab_hard_ft", "pro_right_cross_hard", "pro_right_cross_special",
	"pro_right_cross_miss", "pro_right_hook_special", "pro_right_uppercut_hard",
	"pro_left_uppercut_ft", "pro_left_uppercut_miss", "pro_left_uppercut_special",
	"pro_right_uppercut_ft", "pro_right_uppercut_hard_ft",
	"pro_right_uppercut_miss", "pro_right_uppercut_special", "pro_left_hook_miss", "pro_left_hook_special",
	"pro_right_hook_hurt", "pro_right_hook_hurt_ft", "pro_left_jab_miss"]
const RESULT_PATH := "res://docs/REARHAND1_RESULT.md"
const HEAD := 0
const LH := 1
const RH := 2
const HIPS := 3
const CONTROL_BAR := 0.30


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
		print("HAND_PATH FAIL a bone is missing: %s foot=%d" % [str(bones), foot_i])
		quit(1)
		return
	var hgt: float = (skel.get_bone_global_rest(bones[HEAD]).origin - skel.get_bone_global_rest(foot_i).origin).length()
	var reads: Array = []
	skel.skeleton_updated.connect(func():
		var r: Array = []
		for b in bones:
			r.append(skel.get_bone_global_pose(b).origin)
		reads.append(r))

	var idle_data: Array = await _read(ap, "pro_idle", reads)
	var jab_data: Array = await _read(ap, "pro_left_jab", reads)
	if idle_data.size() < 2 or jab_data.size() < 2:
		print("HAND_PATH FAIL no frames read: idle=%d jab=%d" % [idle_data.size(), jab_data.size()])
		quit(1)
		return
	var idle_max_l: float = _max_chin(idle_data, LH)
	var idle_max_r: float = _max_chin(idle_data, RH)
	var idle_max: float = maxf(idle_max_l, idle_max_r)
	var jab_ext: int = _ext_frame(jab_data, LH)
	var jab_reach: float = _chin(jab_data[jab_ext], LH)
	var jab_line: Vector3 = (jab_data[jab_ext][LH] as Vector3) - (jab_data[0][LH] as Vector3)
	var forward := Vector3(jab_line.x, 0.0, jab_line.z).normalized()
	var ok_idle: bool = idle_max / hgt < CONTROL_BAR
	var ok_jab: bool = jab_reach / hgt >= CONTROL_BAR
	print("HAND_PATH body=%.3f m forward=%s" % [hgt, str(forward)])
	print("HAND_PATH CONTROL guard idle largest hand-chin %.4f (bar under %.2f) %s" % [idle_max / hgt, CONTROL_BAR, "PASS" if ok_idle else "FAIL"])
	print("HAND_PATH CONTROL jab lead hand reach %.4f (bar at least %.2f) %s" % [jab_reach / hgt, CONTROL_BAR, "PASS" if ok_jab else "FAIL"])
	if not ok_idle or not ok_jab:
		print("HAND_PATH STOP a control failed: no table written")
		quit(1)
		return

	var clips: Array = []
	for a in ap.get_animation_list():
		var s: String = str(a)
		if _is_punch(s) or OFF_TAKES.has(s):
			clips.append(s)
	var rows: Array = []
	for clip in clips:
		var data: Array = await _read(ap, clip, reads) if clip != "pro_left_jab" else jab_data
		if data.size() < 2:
			print("HAND_PATH SKIP %s: %d frames" % [clip, data.size()])
			continue
		rows.append(_analyse(clip, data, forward, hgt))
	rows.sort_custom(func(a, b): return a["below"] > b["below"])
	var wrong: Array = []
	for r in rows:
		if r["named"] != "" and r["named"] != r["hand"]:
			wrong.append(r["clip"])
	print("HAND_PATH CONTROL measured hand equals the clip's name: %d of %d, wrong: %s" % [rows.size() - wrong.size(), rows.size(), str(wrong)])
	for r in rows:
		print(_row_text(r, " "))
	_write_result(rows, hgt, idle_max / hgt, jab_reach / hgt, wrong)
	print("HAND_PATH DONE clips=%d" % rows.size())
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


static func _is_punch(s: String) -> bool:
	if s == "pro_body_shot":
		return true
	if not (s.begins_with("pro_left_") or s.begins_with("pro_right_")):
		return false
	return s.contains("jab") or s.contains("cross") or s.contains("hook") or s.contains("uppercut")


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


static func _analyse(clip: String, data: Array, forward: Vector3, hgt: float) -> Dictionary:
	var punch_left: bool = _max_chin(data, LH) >= _max_chin(data, RH)
	var p_i: int = LH if punch_left else RH
	var o_i: int = RH if punch_left else LH
	var ext: int = _ext_frame(data, p_i)
	var guard: Vector3 = data[0][p_i]
	var line: Vector3 = (data[ext][p_i] as Vector3) - guard
	var u: Vector3 = line.normalized()
	var h0: float = _height(data[0], p_i)
	var below: float = 0.0
	var below_f: int = 0
	var back: float = 0.0
	var back_f: int = 0
	var off: float = 0.0
	var low_h: float = h0
	var low_ahead: float = INF
	var low_ahead_f: int = 0
	for f in range(0, ext + 1):
		var d: Array = data[f]
		var hand: Vector3 = d[p_i]
		var rel: Vector3 = hand - guard
		var along: float = rel.dot(u)
		var h: float = _height(d, p_i)
		var ahead: float = (hand - (d[HIPS] as Vector3)).dot(forward)
		if h0 - h > below:
			below = h0 - h
			below_f = f
		if -along > back:
			back = -along
			back_f = f
		off = maxf(off, (rel - u * along).length())
		low_h = minf(low_h, h)
		if ahead < low_ahead:
			low_ahead = ahead
			low_ahead_f = f
	var o_max: float = 0.0
	var o_max_f: int = 0
	var o_low: float = INF
	var o_low_f: int = 0
	var o_h0: float = _height(data[0], o_i)
	for f in data.size():
		var c: float = _chin(data[f], o_i)
		if c > o_max:
			o_max = c
			o_max_f = f
		var h: float = _height(data[f], o_i)
		if h < o_low:
			o_low = h
			o_low_f = f
	var tail: int = mini(int(float(data.size()) * 0.9), data.size() - 1)
	var flags := ""
	if below / hgt > 0.05:
		flags += " DROP"
	if low_h / hgt < 0.10:
		flags += " HIP"
	if low_ahead < 0.0:
		flags += " BEHIND"
	return {"clip": clip, "benched": OFF_TAKES.has(clip), "n": data.size(),
		"named": "L" if clip.begins_with("pro_left_") else ("R" if clip.begins_with("pro_right_") else ""),
		"hand": "L" if punch_left else "R", "reach": _chin(data[ext], p_i) / hgt, "ext": ext,
		"start": _chin(data[0], p_i) / hgt, "below": below / hgt, "below_f": below_f,
		"back": back / hgt, "back_f": back_f, "off": off / hgt, "low_h": low_h / hgt,
		"low_ahead": low_ahead / hgt, "low_ahead_f": low_ahead_f,
		"o_max": o_max / hgt, "o_max_f": o_max_f, "o_low": o_low / hgt, "o_low_f": o_low_f,
		"o_drop": (o_h0 - o_low) / hgt, "sag_p": (_tail_chin(data, p_i, tail) - _chin(data[0], p_i)) / hgt,
		"sag_o": (_tail_chin(data, o_i, tail) - _chin(data[0], o_i)) / hgt, "flags": flags}


static func _tail_chin(data: Array, hand: int, tail: int) -> float:
	var s: float = 0.0
	for f in range(tail, data.size()):
		s += _chin(data[f], hand)
	return s / float(data.size() - tail)


static func _row_text(r: Dictionary, sep: String) -> String:
	return sep.join([
		"%s%s" % [r["clip"], " [BENCHED]" if r["benched"] else ""], str(r["n"]), r["hand"],
		"%.3f" % r["reach"], str(r["ext"]), "%.3f" % r["start"],
		"%.3f" % r["below"], str(r["below_f"]), "%.3f" % r["back"], str(r["back_f"]), "%.3f" % r["off"],
		"%.3f" % r["low_h"], "%.3f" % r["low_ahead"], str(r["low_ahead_f"]),
		"%.3f" % r["o_max"], str(r["o_max_f"]), "%.3f" % r["o_drop"], str(r["o_low_f"]),
		"%.3f" % r["sag_p"], "%.3f" % r["sag_o"], r["flags"].strip_edges()])


static func _kind(clip: String) -> String:
	if clip.contains("uppercut"):
		return "uppercut"
	if clip.contains("hook"):
		return "hook"
	if clip.contains("body"):
		return "body"
	return "straight"


static func _write_result(rows: Array, hgt: float, idle_max: float, jab_reach: float, wrong: Array) -> void:
	var lines: Array = ["# REARHAND1 result (S414, on the corrected probe)", "",
		"Model mh_boxer_10. Body height (head joint above foot joint, rest pose): %.3f m. Every number is a share of it." % hgt, "",
		"Controls: guard idle largest hand-to-chin %.3f (bar under %.2f), jab lead hand reach %.3f (bar at least %.2f). Measured hand equals the clip's name on %d of %d clips%s." % [
			idle_max, CONTROL_BAR, jab_reach, CONTROL_BAR, rows.size() - wrong.size(), rows.size(),
			"" if wrong.is_empty() else " (wrong: %s)" % ", ".join(wrong)], "",
		"Sorted by how far the punching hand drops below its starting height before full extension.",
		"Below, Back, Off line, Low over hips and Ahead of hips are the punching hand, from frame 0 to full extension.",
		"Ahead of hips: hand in front of the hips on the boxer's forward axis; negative means behind the hip.",
		"Flags: DROP below guard by over 0.05; HIP within 0.10 of hip height; BEHIND behind the hip.", "",
		"| Clip | Frm | Hand | Reach | Ext f | Start | Below | f | Back | f | Off line | Low over hips | Ahead of hips | f | Other max chin | f | Other drop | f | Sag punch | Sag other | Flags |",
		"|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|"]
	for r in rows:
		lines.append("| %s |" % _row_text(r, " | "))
	lines.append("")
	var counts: Dictionary = {}
	var other_off: int = 0
	var drop: int = 0
	var hip: int = 0
	var behind: int = 0
	for r in rows:
		var k: String = _kind(r["clip"])
		if not counts.has(k):
			counts[k] = [0, 0, 0, 0]
		counts[k][0] += 1
		if r["flags"].contains("DROP"):
			counts[k][1] += 1
			drop += 1
		if r["flags"].contains("HIP"):
			counts[k][2] += 1
			hip += 1
		if r["flags"].contains("BEHIND"):
			counts[k][3] += 1
			behind += 1
		if r["o_max"] > idle_max:
			other_off += 1
	lines.append("## Summary")
	lines.append("")
	lines.append("Of %d punch clips: the other hand leaves the chin by more than the guard idle's largest value on %d; the punching hand drops over 0.05 below its start on %d, comes within 0.10 of hip height on %d, goes behind the hip on %d." % [rows.size(), other_off, drop, hip, behind])
	lines.append("")
	lines.append("| Kind | Clips | Drop | Hip height | Behind hip |")
	lines.append("|---|---|---|---|---|")
	for k in counts:
		lines.append("| %s | %d | %d | %d | %d |" % [k, counts[k][0], counts[k][1], counts[k][2], counts[k][3]])
	lines.append("")
	var f := FileAccess.open(RESULT_PATH, FileAccess.WRITE)
	if f != null:
		f.store_string("\n".join(lines) + "\n")
