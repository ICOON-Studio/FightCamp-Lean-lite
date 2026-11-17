extends SceneTree
## HEAD_EASE_TEST: the ruler that reads when a hit head peaks and how fast it comes back.
## Hand-built rows (no csv), values as Strings exactly like the film log. Covers the brief's six fixtures
## (ease, late, snap, hips-slide, body-shot, empty) plus the traps: both boxers interleaved per frame,
## short runs skipped, a frame gap splitting a run, a head that never comes back (-1), and kind/by_kind.

const HE := preload("res://scripts/rules/HeadEase.gd")

var failures := 0

const HIPS0 := Vector3(0.0, 1.0, 0.0)
## A head that moves 12 cm over 2 frames then drifts home over 10 (peak_frame 2, back_frames 7, not snap).
const EASE_CM := [0.0, 6.0, 12.0, 10.7, 9.4, 8.1, 6.8, 5.5, 4.2, 2.9, 1.6, 0.3, 0.0]


func _initialize() -> void:
	_test_empty()
	_test_ease()
	_test_late()
	_test_snap()
	_test_hips_slide_not_counted()
	_test_body_shots_not_runs()
	_test_interleaved_boxers()
	_test_short_run_skipped()
	_test_four_frame_run_counts()
	_test_frame_gap_splits()
	_test_never_back()
	_test_kinds_and_by_kind()
	print("HEAD_EASE_TEST failures=%d" % failures)
	quit(1 if failures > 0 else 0)


func _check(cond: bool, msg: String) -> void:
	if not cond:
		failures += 1
		print("  FAIL: " + msg)


func _approx(a: float, b: float, eps: float = 0.5) -> bool:
	return abs(a - b) <= eps


## A csv-shaped row: every value a String, as the film log writes them.
func _row(frame: int, who: int, clip: String, hips: Vector3, head: Vector3) -> Dictionary:
	return {
		"frame": str(frame), "who": str(who), "clip": clip,
		"Hips_x": str(hips.x), "Hips_y": str(hips.y), "Hips_z": str(hips.z),
		"Head_x": str(head.x), "Head_y": str(head.y), "Head_z": str(head.z),
	}


## A hit run from a head-displacement profile (cm along +z on its own body). `hips_slide_m` per frame
## moves the whole body; the head rides with it, so the step cancels out of (Head - Hips).
func _hit_run(start: int, who: int, clip: String, profile_cm: Array, hips_slide_m: float = 0.0) -> Array:
	var rows: Array = []
	for i in range(profile_cm.size()):
		var hips := HIPS0 + Vector3(hips_slide_m * float(i), 0.0, 0.0)
		var head := hips + Vector3(0.0, 0.7, float(profile_cm[i]) / 100.0)
		rows.append(_row(start + i, who, clip, hips, head))
	return rows


func _run_of(result: Dictionary, who: int) -> Dictionary:
	for p in result["runs"]:
		if int(p["who"]) == who:
			return p
	return {}


func _test_empty() -> void:
	var r := HE.analyse([])
	_check(r["runs"].size() == 0, "empty: runs size 0")
	_check(int(r["skipped"]) == 0, "empty: skipped 0")
	_check(float(r["peak_cm_p50"]) == 0.0, "empty: peak_cm_p50 0")
	_check(float(r["back_frames_p50"]) == 0.0, "empty: back_frames_p50 0")
	_check(float(r["late_share"]) == 0.0, "empty: late_share 0")
	_check(float(r["snap_share"]) == 0.0, "empty: snap_share 0")
	_check((r["by_kind"] as Dictionary).is_empty(), "empty: by_kind empty")


func _test_ease() -> void:
	var r := HE.analyse(_hit_run(10, 0, "pro_hit_by_jab_v3", EASE_CM))
	_check(r["runs"].size() == 1, "ease: 1 run")
	if r["runs"].is_empty():
		return
	var p: Dictionary = r["runs"][0]
	_check(int(p["peak_frame"]) == 2, "ease: peak_frame 2, got %d" % p["peak_frame"])
	_check(_approx(float(p["peak_cm"]), 12.0), "ease: peak_cm ~12, got %f" % p["peak_cm"])
	var bf: int = p["back_frames"]
	_check(bf >= 7 and bf <= 8, "ease: back_frames ~7-8, got %d" % bf)
	_check(_approx(float(p["max_back_cm"]), 1.3, 0.3), "ease: max_back ~1.3 (gentle), got %f" % p["max_back_cm"])
	_check(float(r["late_share"]) == 0.0, "ease: not late")
	_check(float(r["snap_share"]) == 0.0, "ease: not snap")


func _test_late() -> void:
	## Peaks at frame 6 (slow rise), then home over 6 frames: late, not snap.
	var profile := [0.0, 2.0, 4.0, 6.0, 8.0, 10.0, 12.0, 10.0, 8.0, 6.0, 4.0, 2.0, 0.0]
	var r := HE.analyse(_hit_run(10, 0, "pro_hit_by_cross_v3", profile))
	_check(r["runs"].size() == 1, "late: 1 run")
	if r["runs"].is_empty():
		return
	var p: Dictionary = r["runs"][0]
	_check(int(p["peak_frame"]) == 6, "late: peak_frame 6, got %d" % p["peak_frame"])
	_check(float(r["late_share"]) == 1.0, "late: late_share 1")
	_check(float(r["snap_share"]) == 0.0, "late: not snap")


func _test_snap() -> void:
	## Springs back in 2 frames with a big one-frame fall: snap.
	var profile := [0.0, 6.0, 12.0, 4.0, 0.0, 0.0]
	var r := HE.analyse(_hit_run(10, 0, "pro_hit_by_hook_v5", profile))
	_check(r["runs"].size() == 1, "snap: 1 run")
	if r["runs"].is_empty():
		return
	var p: Dictionary = r["runs"][0]
	_check(int(p["back_frames"]) == 2, "snap: back_frames 2, got %d" % p["back_frames"])
	_check(float(p["max_back_cm"]) >= 6.0, "snap: big max_back, got %f" % p["max_back_cm"])
	_check(float(r["snap_share"]) == 1.0, "snap: snap_share 1")


func _test_hips_slide_not_counted() -> void:
	## MUTANT guard: the hips slide 20 cm while the head rides along (only 2 cm of its own move).
	## d_cm stays ~2; a world-Head ruler would read ~20 cm and call this a big reaction.
	var profile := [0.0, 1.0, 2.0, 1.0, 0.0, 0.0]
	var r := HE.analyse(_hit_run(10, 0, "pro_hit_by_jab_v3", profile, 0.04))
	_check(r["runs"].size() == 1, "hips_slide: 1 run")
	if r["runs"].is_empty():
		return
	var p: Dictionary = r["runs"][0]
	_check(_approx(float(p["peak_cm"]), 2.0), "hips_slide: peak_cm ~2 (step not counted), got %f" % p["peak_cm"])
	_check(float(p["peak_cm"]) < 5.0, "hips_slide: peak_cm small, got %f" % p["peak_cm"])


func _test_body_shots_not_runs() -> void:
	for clip in ["pro_hit_by_gutshot_v2", "pro_hit_by_body_shot", "pro_hit_by_kidney_v1", "pro_hit_by_liver_v1"]:
		var r := HE.analyse(_hit_run(10, 0, clip, [0.0, 6.0, 12.0, 6.0, 0.0]))
		_check(r["runs"].size() == 0, "body: %s not a run" % clip)
		_check(int(r["skipped"]) == 0, "body: %s not counted as skipped" % clip)


func _test_interleaved_boxers() -> void:
	## THE trap: both boxers' rows interleaved per frame. Runs must be per `who`, never across the
	## other boxer. Boxer 0 peaks 12 cm (jab), boxer 1 peaks 6 cm (cross); mixing them would corrupt d_cm.
	var a := _hit_run(10, 0, "pro_hit_by_jab_v3", EASE_CM)
	var b := _hit_run(10, 1, "pro_hit_by_cross_v3", [0.0, 3.0, 6.0, 5.0, 4.0, 3.0, 2.0, 1.0, 0.0])
	var rows: Array = []
	for i in range(a.size()):
		rows.append(a[i])
		if i < b.size():
			rows.append(b[i])
	var r := HE.analyse(rows)
	_check(r["runs"].size() == 2, "interleaved: 2 runs, got %d" % r["runs"].size())
	var p0 := _run_of(r, 0)
	var p1 := _run_of(r, 1)
	_check(not p0.is_empty() and _approx(float(p0["peak_cm"]), 12.0), "interleaved: who0 peak ~12")
	_check(not p1.is_empty() and _approx(float(p1["peak_cm"]), 6.0), "interleaved: who1 peak ~6")
	_check(str(p0.get("kind", "")) == "jab", "interleaved: who0 kind jab")
	_check(str(p1.get("kind", "")) == "cross", "interleaved: who1 kind cross")


func _test_short_run_skipped() -> void:
	var r := HE.analyse(_hit_run(10, 0, "pro_hit_by_jab_v3", [0.0, 6.0, 12.0]))
	_check(r["runs"].size() == 0, "short: 3-frame run ignored")
	_check(int(r["skipped"]) == 1, "short: skipped 1, got %d" % r["skipped"])


func _test_four_frame_run_counts() -> void:
	var r := HE.analyse(_hit_run(10, 0, "pro_hit_by_jab_v3", [0.0, 6.0, 12.0, 6.0]))
	_check(r["runs"].size() == 1, "four: 4-frame run counts")
	_check(int(r["skipped"]) == 0, "four: skipped 0")


func _test_frame_gap_splits() -> void:
	var rows := _hit_run(10, 0, "pro_hit_by_jab_v3", [0.0, 6.0, 12.0, 6.0])
	rows.append_array(_hit_run(15, 0, "pro_hit_by_jab_v3", [0.0, 6.0, 12.0, 6.0]))
	var r := HE.analyse(rows)
	_check(r["runs"].size() == 2, "gap: two runs, got %d" % r["runs"].size())
	_check(int(r["skipped"]) == 0, "gap: skipped 0")


func _test_never_back() -> void:
	## Head moves out and stays: never under 30% of peak inside the run -> back_frames -1,
	## excluded from back_frames_p50 and not a snap.
	var r := HE.analyse(_hit_run(10, 0, "pro_hit_by_jab_v3", [0.0, 6.0, 12.0, 12.0, 12.0, 12.0]))
	_check(r["runs"].size() == 1, "never: 1 run")
	if r["runs"].is_empty():
		return
	var p: Dictionary = r["runs"][0]
	_check(int(p["back_frames"]) == -1, "never: back_frames -1, got %d" % p["back_frames"])
	_check(float(r["back_frames_p50"]) == 0.0, "never: -1 excluded from p50")
	_check(float(r["snap_share"]) == 0.0, "never: not snap")


func _test_kinds_and_by_kind() -> void:
	var rows: Array = []
	var clips := ["pro_hit_by_jab_v3", "pro_hit_by_cross_v3", "pro_hit_by_hook_v5", "pro_hit_by_uppercut_v1", "pro_hit_by_slip_v1"]
	var want := ["jab", "cross", "hook", "uppercut", "other"]
	for i in range(clips.size()):
		rows.append_array(_hit_run(10 + i * 10, 0, clips[i], [0.0, 6.0, 12.0, 6.0, 0.0]))
	var r := HE.analyse(rows)
	_check(r["runs"].size() == 5, "kinds: 5 runs, got %d" % r["runs"].size())
	for i in range(r["runs"].size()):
		_check(str(r["runs"][i]["kind"]) == want[i], "kinds: run %d kind %s, got %s" % [i, want[i], r["runs"][i]["kind"]])
	var bk: Dictionary = r["by_kind"]
	for k in want:
		_check(bk.has(k) and int(bk[k]["n"]) == 1, "by_kind: %s n=1" % k)
	_check(_approx(float(r["peak_cm_p50"]), 12.0), "kinds: peak_cm_p50 ~12")
