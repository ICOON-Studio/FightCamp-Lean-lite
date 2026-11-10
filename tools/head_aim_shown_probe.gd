extends SceneTree
## HEADAIM2B shown probe: where each head punch clip's fist lands relative to the target's face at contact,
## with the height-only aim. Fresh stage per setup, positions reset before every clip, validity-checked.
##   python ops/Tools/godot_slot.py run --who qwen -- <godot.exe> --headless --audio-driver Dummy --path . --script res://tools/head_aim_shown_probe.gd

const Stage := preload("res://scripts/fight3d/FightStage.gd")
const BeatClips := preload("res://scripts/fight3d/BeatClips.gd")
const Faces := preload("res://scripts/rules/Faces.gd")

const HZ := 30.0
const HEIGHT_BAR := 0.06
const GAP_TOL := 0.05
const FLAT_MAX := 0.7
const BOXER_A := "mh_boxer_10"
const BOXER_B := "mh_boxer_12"
const RESULT_PATH := "res://docs/HEADAIM2_RESULT.md"

# All head punch clips (excluding body shots and off-takes)
const HEAD_PUNCH_STEMS := ["pro_left_jab", "pro_right_cross", "pro_left_hook", "pro_right_hook",
	"pro_left_uppercut", "pro_right_uppercut"]

var failures := 0
var rows: Array = []


func _initialize() -> void:
	Engine.max_fps = 30
	print("HEADAIM2B_PROBE")
	# Setup 1+2: A vs B (up and down)
	var s1 := await _make_stage()
	var clips_ab := _collect_clips(s1.boxers[0]["ap"])
	print("CLIPS %d" % clips_ab.size())
	for clip in clips_ab:
		await _await_measure(s1, 0, 1, clip, "A_B_up")
	for clip in clips_ab:
		await _await_measure(s1, 1, 0, clip, "B_A_dn")
	s1.queue_free()
	# Setup 3: A vs A (level)
	var s2 := await _make_stage_same()
	var clips_aa := _collect_clips(s2.boxers[0]["ap"])
	for clip in clips_aa:
		await _await_measure(s2, 0, 1, clip, "A_A_lv")
	s2.queue_free()
	_write_result()
	print("HEADAIM2B_PROBE DONE failures=%d" % failures)
	quit(0 if failures == 0 else 1)


## Fresh stage: A vs B.
func _make_stage() -> Node3D:
	var stg: Node3D = Stage.new()
	root.add_child(stg)
	await process_frame
	stg.setup({"glb": "res://assets/models/metahuman/%s.glb" % BOXER_A, "corner": "red"},
		{"glb": "res://assets/models/metahuman/%s.glb" % BOXER_B, "corner": "blue"})
	for i in 3:
		await process_frame
	var ha: float = _body_height(stg.boxers[0]["skel"])
	var hb: float = _body_height(stg.boxers[1]["skel"])
	print("PAIR A=%s(%.3f) B=%s(%.3f) gap=%.3f" % [BOXER_A, ha, BOXER_B, hb, stg.gap_m])
	return stg


## Fresh stage: A vs A (same height).
func _make_stage_same() -> Node3D:
	var stg: Node3D = Stage.new()
	root.add_child(stg)
	await process_frame
	stg.setup({"glb": "res://assets/models/metahuman/%s.glb" % BOXER_A, "corner": "red"},
		{"glb": "res://assets/models/metahuman/%s.glb" % BOXER_A, "corner": "blue"})
	for i in 3:
		await process_frame
	var ha: float = _body_height(stg.boxers[0]["skel"])
	var hb: float = _body_height(stg.boxers[1]["skel"])
	print("PAIR A=%s(%.3f) A=%s(%.3f) gap=%.3f" % [BOXER_A, ha, BOXER_A, hb, stg.gap_m])
	return stg


func _body_height(skel: Skeleton3D) -> float:
	var hi: int = skel.find_bone("Head")
	var fi: int = skel.find_bone("LeftFoot")
	if hi < 0 or fi < 0:
		return 0.0
	return (skel.get_bone_global_rest(hi).origin - skel.get_bone_global_rest(fi).origin).length()


func _hips_gap(stage: Node3D) -> float:
	var a: Vector3 = _bone_world(stage.boxers[0]["skel"], "Hips")
	var b: Vector3 = _bone_world(stage.boxers[1]["skel"], "Hips")
	return Vector2(a.x - b.x, a.z - b.z).length()


func _bone_world(skel: Skeleton3D, bone: String) -> Vector3:
	var i: int = skel.find_bone(bone)
	if i < 0:
		return Vector3.ZERO
	return skel.global_transform * skel.get_bone_global_pose(i).origin


func _collect_clips(ap: AnimationPlayer) -> Array:
	var out: Array = []
	for stem in HEAD_PUNCH_STEMS:
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


## Reset positions, wait, return Hips gap.
func _reset(stage: Node3D) -> float:
	stage.boxers[0]["pos"] = Vector3(0, 0, -stage.gap_m * 0.5)
	stage.boxers[1]["pos"] = Vector3(0, 0, stage.gap_m * 0.5)
	stage.guard(0)
	stage.guard(1)
	for i in 3:
		await process_frame
	return _hips_gap(stage)


func _await_measure(stage: Node3D, who: int, other: int, clip: String, setup: String) -> void:
	var gap: float = await _reset(stage)
	var bx: Dictionary = stage.boxers[who]
	var ap: AnimationPlayer = bx["ap"]
	if not ap.has_animation(clip):
		return
	var contact_s: float = BeatClips.contact(clip, 8.0 / 30.0)
	var hand: String = "LeftHand" if clip.contains("left") or clip.contains("jab") else "RightHand"
	hand = stage.hand_of(who, hand)
	# Play and aim
	stage.play(who, clip, 1.0, 0.0)
	stage.aim_height(who, clip, 0.0, contact_s)
	var face_y: float = stage.target_point(other, false).y
	# Measure around contact
	var cf: int = int(contact_s * HZ)
	var min_dy: float = 999.0
	var flat_c: float = 0.0
	for fr in range(maxi(0, cf - 2), cf + 3):
		var t: float = float(fr) / HZ
		ap.seek(t, true)
		await process_frame
		await process_frame
		var gf: Vector3 = stage.glove_front(who, hand)
		var face: Vector3 = stage.target_point(other, false)
		var dy: float = absf(gf.y - face_y)
		min_dy = minf(min_dy, dy)
		if fr == cf:
			flat_c = Vector2(gf.x - face.x, gf.z - face.z).length()
	var valid: bool = absf(gap - stage.gap_m) <= GAP_TOL and flat_c >= 0.0 and flat_c <= FLAT_MAX
	var height_ok: bool = min_dy <= HEIGHT_BAR and valid
	rows.append({"clip": clip, "setup": setup, "dy": min_dy, "flat": flat_c, "gap": gap,
		"valid": valid, "ok": height_ok})
	print("PROBE %s %s dy=%.3f flat=%.3f gap=%.3f %s%s" % [setup, clip, min_dy, flat_c, gap,
		"PASS" if height_ok else "FAIL", "" if valid else " VOID"])
	if not height_ok:
		failures += 1


func _write_result() -> void:
	var lines: Array = ["# HEADAIM2B result (S417)", "",
		"Where each head punch clip's fist lands relative to the target's face at contact, with the height-only aim.",
		"Fresh stage per setup, positions reset before every clip, Hips gap validated.",
		"Three setups: A_B_up (162cm punches 178cm), B_A_dn (178cm punches 162cm), A_A_lv (162cm punches 162cm).",
		"dy = |glove front height - latched face height| in metres. flat = horizontal distance glove to face in metres.",
		"HEIGHT_BAR = %.2f m. GAP_TOL = %.2f m. FLAT_MAX = %.2f m." % [HEIGHT_BAR, GAP_TOL, FLAT_MAX],
		"A clip passes if dy <= HEIGHT_BAR and the row is valid (gap within tolerance, flat in range).",
		""]
	lines.append("| Setup | Clip | dy m | flat m | gap m | Valid | Pass |")
	lines.append("|---|---|---|---|---|---|---|")
	for r in rows:
		lines.append("| %s | %s | %.3f | %.3f | %.3f | %s | %s |" % [
			r["setup"], r["clip"], r["dy"], r["flat"], r["gap"],
			"YES" if r["valid"] else "VOID", "YES" if r["ok"] else "NO"])
	lines.append("")
	# Summary
	var total: int = rows.size()
	var passed: int = 0
	var void_count: int = 0
	var worst_clip: String = ""
	var worst_dy: float = 0.0
	for r in rows:
		if r["ok"]:
			passed += 1
		if not r["valid"]:
			void_count += 1
		if r["dy"] > worst_dy:
			worst_dy = r["dy"]
			worst_clip = r["clip"]
	lines.append("## Summary")
	lines.append("")
	lines.append("Of %d head punch clips across three setups, %d pass the %.2f m height bar." % [total, passed, HEIGHT_BAR])
	lines.append("%d rows void (gap out of tolerance or flat out of range)." % void_count)
	lines.append("Worst clip: %s at dy=%.3f m." % [worst_clip, worst_dy])
	lines.append("")
	var f := FileAccess.open(RESULT_PATH, FileAccess.WRITE)
	if f != null:
		f.store_string("\n".join(lines) + "\n")
	print("HEADAIM2B result -> %s" % RESULT_PATH)
