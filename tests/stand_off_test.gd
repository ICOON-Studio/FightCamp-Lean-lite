extends SceneTree
## STAND_OFF_TEST: hand-built rows proving the StandOff analyser.
## Mutant note: if hips distance were measured in 3D (including y) instead of x/z only,
## a boxer bending 0.3 m lower at the same x/z separation of 0.8 m would read
## sqrt(0.8^2 + 0.3^2) = 0.854 m - still under 1.0 m, but at x/z = 0.95 m with y drop 0.3 m
## the 3D distance would be sqrt(0.95^2 + 0.3^2) = 0.996 m (still passes), while at
## x/z = 0.98 m, y drop = 0.3 m -> 3D = 1.025 m (FAILS the near check, so near_frames
## would be 0 instead of 12, and pressing_share would be 0.0 instead of 1.0).

var failures := 0
var SO: RefCounted


func _initialize() -> void:
	SO = load("res://scripts/rules/StandOff.gd")
	_test_basic_standoff()
	_test_too_far()
	_test_gloves_too_far()
	_test_too_short()
	_test_busy_splits()
	_test_skipped_frame_splits()
	_test_missing_who1()
	_test_custom_args()
	_test_empty()
	_test_mutant_3d_hips()
	_test_idle_inside_basic()
	_test_idle_inside_busy_splits()
	_test_idle_inside_too_far()
	_test_idle_inside_too_short()
	_test_idle_inside_missing_frame_splits()
	_test_idle_inside_phase()
	print("STAND_OFF_TEST failures=%d" % failures)
	quit(1 if failures > 0 else 0)


func _test_basic_standoff() -> void:
	var rows := _make_run(100, 111, 0.8, 0.10, "idle", "idle")
	var r: Dictionary = SO.analyse(rows)
	_check(r["count"] == 1, "basic: count=1 got %d" % r["count"])
	_check(r["total_frames"] == 12, "basic: total_frames=12 got %d" % r["total_frames"])
	_check(r["longest_frames"] == 12, "basic: longest=12 got %d" % r["longest_frames"])
	_check(r["near_frames"] == 12, "basic: near_frames=12 got %d" % r["near_frames"])
	_check(absf(r["pressing_share"] - 1.0) < 0.001, "basic: pressing_share=1.0 got %.3f" % r["pressing_share"])


func _test_too_far() -> void:
	var rows := _make_run(100, 111, 1.2, 0.10, "idle", "idle")
	var r: Dictionary = SO.analyse(rows)
	_check(r["count"] == 0, "too_far: count=0 got %d" % r["count"])
	_check(r["near_frames"] == 0, "too_far: near_frames=0 got %d" % r["near_frames"])


func _test_gloves_too_far() -> void:
	var rows := _make_run(100, 111, 0.8, 0.30, "idle", "idle")
	var r: Dictionary = SO.analyse(rows)
	_check(r["count"] == 0, "gloves_far: count=0 got %d" % r["count"])
	_check(r["near_frames"] == 12, "gloves_far: near_frames=12 got %d" % r["near_frames"])
	_check(absf(r["pressing_share"]) < 0.001, "gloves_far: pressing_share=0.0 got %.3f" % r["pressing_share"])


func _test_too_short() -> void:
	var rows := _make_run(100, 108, 0.8, 0.10, "idle", "idle")
	var r: Dictionary = SO.analyse(rows)
	_check(r["count"] == 0, "short: count=0 got %d" % r["count"])
	_check(r["total_frames"] == 0, "short: total_frames=0 got %d" % r["total_frames"])


func _test_busy_splits() -> void:
	var rows := _make_run(100, 111, 0.8, 0.10, "idle", "idle")
	for row in rows:
		var f: int = int(row["frame"])
		if f >= 105 and f <= 106:
			row["clip"] = "pro_left_jab" if int(row["who"]) == 0 else "idle"
	var r: Dictionary = SO.analyse(rows)
	_check(r["count"] == 0, "busy_splits: count=0 (runs of 5 and 6, both <10) got %d" % r["count"])


func _test_skipped_frame_splits() -> void:
	var rows := _make_run(100, 120, 0.8, 0.10, "idle", "idle")
	var filtered: Array = []
	for row in rows:
		if int(row["frame"]) != 110:
			filtered.append(row)
	var r: Dictionary = SO.analyse(filtered)
	_check(r["count"] == 2, "skipped: count=2 got %d" % r["count"])
	_check(r["total_frames"] == 20, "skipped: total_frames=20 got %d" % r["total_frames"])


func _test_missing_who1() -> void:
	var rows := _make_run(100, 111, 0.8, 0.10, "idle", "idle")
	var filtered: Array = []
	for row in rows:
		if int(row["frame"]) == 105 and int(row["who"]) == 1:
			continue
		filtered.append(row)
	var r: Dictionary = SO.analyse(filtered)
	_check(r["count"] == 0, "missing_who1: count=0 (11 frames, split by gap) got %d" % r["count"])
	_check(r["total_frames"] == 0, "missing_who1: total_frames=0 (runs of 5 and 6) got %d" % r["total_frames"])


func _test_custom_args() -> void:
	var rows := _make_run(100, 107, 1.8, 0.25, "idle", "idle")
	var r: Dictionary = SO.analyse(rows, 2.0, 0.30, 5)
	_check(r["count"] == 1, "custom: count=1 got %d" % r["count"])
	_check(r["total_frames"] == 8, "custom: total_frames=8 got %d" % r["total_frames"])


func _test_empty() -> void:
	var r: Dictionary = SO.analyse([])
	_check(r["count"] == 0, "empty: count=0 got %d" % r["count"])
	_check(r["standoffs"].size() == 0, "empty: standoffs empty got %d" % r["standoffs"].size())


func _test_mutant_3d_hips() -> void:
	## If hips distance used 3D (including y), a boxer bending 0.3 m lower at x/z=0.98 m
	## would read 1.025 m and fail the near check. With x/z only, it reads 0.98 m (passes).
	var rows: Array = []
	for f in range(100, 112):
		var r0 := _row(f, 0, "idle", 0.49, 1.0, 0.0)
		var r1 := _row(f, 1, "idle", -0.49, 0.7, 0.0)
		rows.append(r0)
		rows.append(r1)
	var r: Dictionary = SO.analyse(rows)
	_check(r["near_frames"] == 12, "mutant_3d: near_frames=12 (x/z=0.98) got %d" % r["near_frames"])


func _test_idle_inside_basic() -> void:
	## 30 frames inside 0.9 m, both idle -> 1 spell of 30 frames.
	## analyse (glove rule) with glove_m=0.30 would report count=0 (gloves too far for pressing),
	## but idle_inside finds 1 spell because it doesn't require close gloves.
	var rows := _make_run(100, 129, 0.9, 0.30, "idle", "idle")
	var r: Dictionary = SO.idle_inside(rows)
	_check(r["count"] == 1, "idle_basic: count=1 got %d" % r["count"])
	_check(r["total_frames"] == 30, "idle_basic: total_frames=30 got %d" % r["total_frames"])
	_check(r["spells"].size() == 1, "idle_basic: spells.size()=1 got %d" % r["spells"].size())
	if r["spells"].size() > 0:
		var sp: Dictionary = r["spells"][0]
		_check(sp["frames"] == 30, "idle_basic: spell frames=30 got %d" % sp["frames"])


func _test_idle_inside_busy_splits() -> void:
	## 30 frames, one boxer in "pro_left_jab" on frames 110-114 -> splits into 10 + 15 idle frames.
	## Both parts < 20 (min_frames), so 0 spells.
	var rows := _make_run(100, 129, 0.9, 0.30, "idle", "idle")
	for row in rows:
		var f: int = int(row["frame"])
		if f >= 110 and f <= 114:
			if int(row["who"]) == 0:
				row["clip"] = "pro_left_jab"
	var r: Dictionary = SO.idle_inside(rows)
	_check(r["count"] == 0, "idle_busy_splits: count=0 (10+15, both <20) got %d" % r["count"])
	_check(r["near_frames"] == 30, "idle_busy_splits: near_frames=30 got %d" % r["near_frames"])


func _test_idle_inside_too_far() -> void:
	## 30 frames at 1.2 m both idle -> 0 spells and near_frames 0.
	var rows := _make_run(100, 129, 1.2, 0.30, "idle", "idle")
	var r: Dictionary = SO.idle_inside(rows)
	_check(r["count"] == 0, "idle_too_far: count=0 got %d" % r["count"])
	_check(r["near_frames"] == 0, "idle_too_far: near_frames=0 got %d" % r["near_frames"])


func _test_idle_inside_too_short() -> void:
	## 15 idle frames inside -> 0 spells (under min_frames) but near_frames 15.
	var rows := _make_run(100, 114, 0.9, 0.30, "idle", "idle")
	var r: Dictionary = SO.idle_inside(rows)
	_check(r["count"] == 0, "idle_short: count=0 got %d" % r["count"])
	_check(r["near_frames"] == 15, "idle_short: near_frames=15 got %d" % r["near_frames"])


func _test_idle_inside_missing_frame_splits() -> void:
	## 50 frames, remove frame 125 -> splits into 25 + 24 = 2 spells.
	var rows := _make_run(100, 149, 0.9, 0.30, "idle", "idle")
	var filtered: Array = []
	for row in rows:
		if int(row["frame"]) != 125:
			filtered.append(row)
	var r: Dictionary = SO.idle_inside(filtered)
	_check(r["count"] == 2, "idle_missing_frame: count=2 got %d" % r["count"])
	_check(r["total_frames"] == 49, "idle_missing_frame: total_frames=49 got %d" % r["total_frames"])


func _test_idle_inside_phase() -> void:
	## The film's phase column is the range (in / inside / pocket / clinch) or "rest" - never "fight".
	## "inside" frames count; the same frames marked "rest" (between rounds) do not.
	var rows := _make_run(100, 129, 0.9, 0.30, "idle", "idle")
	for row in rows:
		row["phase"] = "inside"
	var r: Dictionary = SO.idle_inside(rows)
	_check(r["count"] == 1, "idle_phase: inside counts, count=1 got %d" % r["count"])
	for row in rows:
		row["phase"] = "rest"
	r = SO.idle_inside(rows)
	_check(r["count"] == 0, "idle_phase: rest does not count, count=0 got %d" % r["count"])


func _make_run(start_f: int, end_f: int, hips_m: float, glove_m: float, clip0: String, clip1: String) -> Array:
	var rows: Array = []
	var half := hips_m / 2.0
	for f in range(start_f, end_f + 1):
		var r0 := _row(f, 0, clip0, half, 1.0, 0.0)
		var r1 := _row(f, 1, clip1, -half, 1.0, 0.0)
		_place_gloves(r0, r1, glove_m)
		rows.append(r0)
		rows.append(r1)
	return rows


func _row(frame: int, who: int, clip: String, hx: float, hy: float, hz: float) -> Dictionary:
	return {
		"frame": str(frame), "who": str(who), "clip": clip,
		"film_s": str(float(frame) / 30.0),
		"Hips_x": str(hx), "Hips_y": str(hy), "Hips_z": str(hz),
		"Head_x": str(hx), "Head_y": str(hy + 0.5), "Head_z": str(hz),
		"LeftHand_x": str(hx - 0.2), "LeftHand_y": str(hy), "LeftHand_z": str(hz),
		"RightHand_x": str(hx + 0.2), "RightHand_y": str(hy), "RightHand_z": str(hz),
	}


func _place_gloves(r0: Dictionary, r1: Dictionary, target_glove_m: float) -> void:
	var h0x := float(r0["Hips_x"])
	var h0z := float(r0["Hips_z"])
	var h1x := float(r1["Hips_x"])
	var h1z := float(r1["Hips_z"])
	var mid_x := (h0x + h1x) / 2.0
	var mid_z := (h0z + h1z) / 2.0
	var hy := float(r0["Hips_y"])
	var half_g := target_glove_m / 2.0
	r0["LeftHand_x"] = str(mid_x - half_g)
	r0["LeftHand_y"] = str(hy)
	r0["LeftHand_z"] = str(mid_z)
	r0["RightHand_x"] = str(mid_x - half_g)
	r0["RightHand_y"] = str(hy)
	r0["RightHand_z"] = str(mid_z)
	r1["LeftHand_x"] = str(mid_x + half_g)
	r1["LeftHand_y"] = str(hy)
	r1["LeftHand_z"] = str(mid_z)
	r1["RightHand_x"] = str(mid_x + half_g)
	r1["RightHand_y"] = str(hy)
	r1["RightHand_z"] = str(mid_z)


func _check(cond: bool, label: String) -> void:
	if cond:
		print("PASS %s" % label)
	else:
		failures += 1
		print("FAIL %s" % label)
