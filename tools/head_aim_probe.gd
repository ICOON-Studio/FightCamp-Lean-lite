extends SceneTree
## HEADAIM1 (S416): where does each punch clip's fist land relative to the target's head at the contact frame?
## Two setups (same height, different height) x two spacings (fight gap, preview gap). No clip or game code changed.
##   python ops/Tools/godot_slot.py run --who qwen -- <godot.exe> --headless --audio-driver Dummy --path . --script res://tools/head_aim_probe.gd

const Stage := preload("res://scripts/fight3d/FightStage.gd")
const IdleMatch := preload("res://scripts/fight3d/IdleMatch.gd")
const BeatClips := preload("res://scripts/fight3d/BeatClips.gd")

const PREVIEW_GAP := 0.6
const CHIN_SHARE := 0.06
const BELOW_BAR := 0.04
const RESULT_PATH := "res://docs/HEADAIM1_RESULT.md"
const RULER_CLIP := "pro_left_jab"
const RULER_EXPECT := 0.441
const RULER_TOL := 0.01
const HZ := 30.0
const BASE_MODEL := "mh_boxer_10"

var failures := 0


func _initialize() -> void:
	Engine.max_fps = 30
	var partner: String = await _find_partner()
	var rows_same: Array = await _run_pair(BASE_MODEL, BASE_MODEL, "same")
	var rows_diff: Array = await _run_pair(BASE_MODEL, partner, "diff")
	_write_result(rows_same, rows_diff, partner)
	print("HEADAIM1 DONE failures=%d" % failures)
	quit(0 if failures == 0 else 1)


func _find_partner() -> String:
	var stage: Node3D = Stage.new()
	root.add_child(stage)
	await process_frame
	stage.setup({"glb": "res://assets/models/metahuman/%s.glb" % BASE_MODEL, "corner": "red"},
		{"glb": "res://assets/models/metahuman/%s.glb" % BASE_MODEL, "corner": "blue"})
	stage.set_process(false)
	var base_hgt: float = _body_height(stage.boxers[0]["skel"])
	stage.queue_free()
	await process_frame
	print("BASE %s hgt=%.3f" % [BASE_MODEL, base_hgt])
	var candidates: Array = ["mh_boxer_01", "mh_boxer_03", "mh_boxer_07", "mh_boxer_08",
		"mh_boxer_13", "mh_boxer_15", "mh_boxer_20", "mh_boxer_22", "mh_boxer_23"]
	for c in candidates:
		var s2: Node3D = Stage.new()
		root.add_child(s2)
		await process_frame
		s2.setup({"glb": "res://assets/models/metahuman/%s.glb" % BASE_MODEL, "corner": "red"},
			{"glb": "res://assets/models/metahuman/%s.glb" % c, "corner": "blue"})
		s2.set_process(false)
		var h: float = _body_height(s2.boxers[1]["skel"])
		s2.queue_free()
		await process_frame
		var diff: float = h - base_hgt
		if abs(diff) >= 0.08:
			print("DIFF_PARTNER %s hgt=%.3f (diff=%+.3f)" % [c, h, diff])
			return c
	print("DIFF_PARTNER WARN no boxer 8cm+ different")
	failures += 1
	return "mh_boxer_01"


func _body_height(skel: Skeleton3D) -> float:
	var head_i: int = skel.find_bone("Head")
	var foot_i: int = skel.find_bone("LeftFoot")
	if head_i < 0 or foot_i < 0:
		return 0.0
	return (skel.get_bone_global_rest(head_i).origin - skel.get_bone_global_rest(foot_i).origin).length()


func _ruler_check(bx: Dictionary, hgt: float) -> void:
	var ap: AnimationPlayer = bx["ap"]
	if not ap.has_animation(RULER_CLIP):
		print("READ_CHECK FAIL no %s" % RULER_CLIP)
		failures += 1
		quit(1)
		return
	var max_d: float = 0.0
	var length: float = ap.get_animation(RULER_CLIP).length
	var n: int = int(length * HZ)
	for f in n:
		var t: float = float(f) / HZ
		var hand: Vector3 = IdleMatch.pose_point(bx, RULER_CLIP, t, "LeftHand")
		var head: Vector3 = IdleMatch.pose_point(bx, RULER_CLIP, t, "Head")
		var d: float = hand.distance_to(head)
		if d > max_d:
			max_d = d
	var reach: float = max_d / hgt
	var ok: bool = abs(reach - RULER_EXPECT) <= RULER_TOL
	print("READ_CHECK reach=%.4f (expect %.3f +- %.2f) %s" % [reach, RULER_EXPECT, RULER_TOL, "PASS" if ok else "FAIL"])
	if not ok:
		failures += 1
		print("READ_CHECK STOP ruler miss too large")
		quit(1)


func _collect_clips(ap: AnimationPlayer) -> Array:
	var stems: Dictionary = {
		"jab": "pro_left_jab",
		"cross": "pro_right_cross",
		"lead_hook": "pro_left_hook",
		"rear_hook": "pro_right_hook",
		"lead_uppercut": "pro_left_uppercut",
		"rear_uppercut": "pro_right_uppercut",
	}
	var out: Array = []
	for sn in stems:
		var stem: String = stems[sn]
		for a in ap.get_animation_list():
			var name: String = str(a)
			if not name.begins_with(stem):
				continue
			if name.contains("body") or name.contains("kidney"):
				continue
			if BeatClips.OFF_TAKES.has(name):
				continue
			out.append(name)
	out.sort()
	return out


func _run_pair(glb_a: String, glb_b: String, label: String) -> Array:
	var stage: Node3D = Stage.new()
	root.add_child(stage)
	await process_frame
	stage.setup({"glb": "res://assets/models/metahuman/%s.glb" % glb_a, "corner": "red"},
		{"glb": "res://assets/models/metahuman/%s.glb" % glb_b, "corner": "blue"})
	stage.set_process(false)
	var bx0: Dictionary = stage.boxers[0]
	var bx1: Dictionary = stage.boxers[1]
	var skel0: Skeleton3D = bx0["skel"]
	var hgt0: float = _body_height(skel0)
	var hgt1: float = _body_height(bx1["skel"])
	print("PAIR %s: A=%s (%.3f) B=%s (%.3f) fight_gap=%.3f" % [label, glb_a, hgt0, glb_b, hgt1, stage.gap_m])
	if label == "same":
		_ruler_check(bx0, hgt0)
	var clips: Array = _collect_clips(bx0["ap"])
	print("PAIR %s clips=%d" % [label, clips.size()])
	var fight_gap: float = stage.gap_m
	var rows_fight: Array = _measure_all(bx0, bx1, hgt0, hgt1, clips, fight_gap, "fight")
	var rows_preview: Array = _measure_all(bx0, bx1, hgt0, hgt1, clips, PREVIEW_GAP, "preview")
	stage.queue_free()
	await process_frame
	var all_rows: Array = []
	all_rows.append_array(rows_fight)
	all_rows.append_array(rows_preview)
	return all_rows


func _measure_all(bx0: Dictionary, bx1: Dictionary, hgt0: float, hgt1: float, clips: Array, gap: float, spacing: String) -> Array:
	var rows: Array = []
	var target_head_y: float = IdleMatch.pose_point(bx1, "pro_idle", 0.0, "Head").y
	var chin_y: float = target_head_y - CHIN_SHARE * hgt1
	for clip in clips:
		var contact_s: float = BeatClips.contact(clip, 8.0 / 30.0)
		var hand_name: String = "LeftHand" if clip.contains("left_") or clip.contains("jab") else "RightHand"
		var fist: Vector3 = IdleMatch.pose_point(bx0, clip, contact_s, hand_name)
		var above_head: float = (fist.y - target_head_y) / hgt0
		var above_chin: float = (fist.y - chin_y) / hgt0
		var side_miss: float = abs(fist.x) / hgt0
		rows.append({"clip": clip, "spacing": spacing, "gap": gap,
			"fist_y": fist.y / hgt0, "head_y": target_head_y / hgt0, "chin_y": chin_y / hgt0,
			"above_head": above_head, "above_chin": above_chin, "side_miss": side_miss,
			"hgt0": hgt0, "hgt1": hgt1, "contact_s": contact_s, "hand": hand_name})
		print("AIM %s %s gap=%.2f fist_y=%.3f head=%.3f chin=%.3f above_head=%+.3f above_chin=%+.3f side=%.3f" % [
			clip, spacing, gap, fist.y / hgt0, target_head_y / hgt0, chin_y / hgt0, above_head, above_chin, side_miss])
	return rows


func _write_result(rows_same: Array, rows_diff: Array, partner: String) -> void:
	var lines: Array = ["# HEADAIM1 result (S416)", "",
		"Where each punch clip's fist lands at the contact frame (clip_contact.json), as shares of the attacker's body height.",
		"Positive above_head/above_chin = fist above the landmark. Side miss = lateral offset from the head's centre.",
		"Fight gap = the stage's jab gap. Preview gap = %.2f m (MovePlayer default)." % PREVIEW_GAP,
		"Same-height pair: %s vs %s. Different-height pair: %s vs %s." % [BASE_MODEL, BASE_MODEL, BASE_MODEL, partner],
		""]
	lines.append("## Same-height pair")
	lines.append("")
	lines.append("| Clip | Spacing | Gap m | Contact s | Hand | Fist Y | Head Y | Chin Y | Above head | Above chin | Side miss |")
	lines.append("|---|---|---|---|---|---|---|---|---|---|---|")
	for r in rows_same:
		lines.append(_row_line(r))
	lines.append("")
	lines.append("## Different-height pair")
	lines.append("")
	lines.append("| Clip | Spacing | Gap m | Contact s | Hand | Fist Y | Head Y | Chin Y | Above head | Above chin | Side miss |")
	lines.append("|---|---|---|---|---|---|---|---|---|---|---|")
	for r in rows_diff:
		lines.append(_row_line(r))
	lines.append("")
	var summary: String = _build_summary(rows_same, rows_diff)
	lines.append(summary)
	lines.append("")
	var f := FileAccess.open(RESULT_PATH, FileAccess.WRITE)
	if f != null:
		f.store_string("\n".join(lines) + "\n")
	print("HEADAIM1 result -> %s" % RESULT_PATH)


func _row_line(r: Dictionary) -> String:
	return "| %s | %s | %.2f | %.3f | %s | %.3f | %.3f | %.3f | %+.3f | %+.3f | %.3f |" % [
		r["clip"], r["spacing"], r["gap"], r["contact_s"], str(r["hand"]).substr(0, 1),
		r["fist_y"], r["head_y"], r["chin_y"], r["above_head"], r["above_chin"], r["side_miss"]]


func _build_summary(rows_same: Array, rows_diff: Array) -> String:
	var fight_below_same: int = 0
	var preview_below_same: int = 0
	var fight_total_same: int = 0
	var preview_total_same: int = 0
	var fight_below_diff: int = 0
	var preview_below_diff: int = 0
	var fight_total_diff: int = 0
	var preview_total_diff: int = 0
	var same_fight_flags: Dictionary = {}
	var same_preview_flags: Dictionary = {}
	var diff_fight_flags: Dictionary = {}
	var diff_preview_flags: Dictionary = {}
	for r in rows_same:
		var clip: String = str(r["clip"])
		var sp: String = str(r["spacing"])
		var below: bool = float(r["above_chin"]) < -BELOW_BAR
		if sp == "fight":
			fight_total_same += 1
			if below:
				fight_below_same += 1
			same_fight_flags[clip] = below
		else:
			preview_total_same += 1
			if below:
				preview_below_same += 1
			same_preview_flags[clip] = below
	for r in rows_diff:
		var clip: String = str(r["clip"])
		var sp: String = str(r["spacing"])
		var below: bool = float(r["above_chin"]) < -BELOW_BAR
		if sp == "fight":
			fight_total_diff += 1
			if below:
				fight_below_diff += 1
			diff_fight_flags[clip] = below
		else:
			preview_total_diff += 1
			if below:
				preview_below_diff += 1
			diff_preview_flags[clip] = below
	var spacing_mismatch: int = 0
	var height_mismatch: int = 0
	for clip in same_fight_flags:
		if same_fight_flags.get(clip, false) != same_preview_flags.get(clip, false):
			spacing_mismatch += 1
		if same_fight_flags.get(clip, false) != diff_fight_flags.get(clip, false):
			height_mismatch += 1
	return ("Of %d head punches at fight spacing (same height), %d end below the chin by more than %.2f of body height. " +
		"At preview spacing, %d of %d do. " +
		"%d clips change below-chin status between fight and preview spacing. " +
		"At fight spacing, %d of %d change status when the target is a different height. " +
		"Different height at fight: %d below chin. Different height at preview: %d of %d below chin.") % [
		fight_total_same, fight_below_same, BELOW_BAR,
		preview_below_same, preview_total_same,
		spacing_mismatch,
		height_mismatch, fight_total_same,
		fight_below_diff, preview_below_diff, preview_total_diff]
