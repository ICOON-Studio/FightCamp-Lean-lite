extends SceneTree
## PUNCH_END_TEST: the ruler that reads where each punch ends and how fast the hand comes home.
## Hand-built rows (no csv). 10 checks: empty, jab on head, cross above, body shot, southpaw,
## home in 3, home never (30), short run ignored, skipped frame splits, missing opponent skipped.

const PE := preload("res://scripts/rules/PunchEnd.gd")

var failures := 0


func _initialize() -> void:
	_test_empty()
	_test_jab_on_head()
	_test_cross_above()
	_test_body_shot()
	_test_southpaw()
	_test_home_3()
	_test_home_never()
	_test_short_run_ignored()
	_test_skipped_frame_splits()
	_test_missing_opponent()
	print("PUNCH_END_TEST failures=%d" % failures)
	quit(1 if failures > 0 else 0)


func _check(cond: bool, msg: String) -> void:
	if not cond:
		failures += 1
		print("  FAIL: " + msg)


func _approx(a: float, b: float, eps: float = 1.0) -> bool:
	return abs(a - b) <= eps


func _row(frame: int, who: int, clip: String, hips: Vector3, head: Vector3, lh: Vector3, rh: Vector3) -> Dictionary:
	return {
		"frame": frame, "who": who, "clip": clip, "phase": "fight",
		"Hips_x": hips.x, "Hips_y": hips.y, "Hips_z": hips.z,
		"Head_x": head.x, "Head_y": head.y, "Head_z": head.z,
		"LeftHand_x": lh.x, "LeftHand_y": lh.y, "LeftHand_z": lh.z,
		"RightHand_x": rh.x, "RightHand_y": rh.y, "RightHand_z": rh.z,
	}


## Common positions.
const HIPS0 := Vector3(0.0, 1.0, 0.0)
const HEAD0 := Vector3(0.0, 1.7, 0.0)
const HIPS1 := Vector3(0.5, 1.0, 0.0)
const HEAD1 := Vector3(0.5, 1.7, 0.0)
const LH_GUARD := Vector3(-0.2, 1.5, 0.0)
const RH_GUARD := Vector3(0.2, 1.4, 0.0)


func _test_empty() -> void:
	var r := PE.analyse([])
	_check(r["punches"].size() == 0, "empty: punches size 0")
	_check(r["head_n"] == 0, "empty: head_n 0")
	_check(r["above_10_n"] == 0, "empty: above_10_n 0")


func _test_jab_on_head() -> void:
	## Jab ending on the head: above_cm about 0, home in 3 frames.
	var rows: Array = []
	## Boxer 0 throws pro_jab frames 10-15, right hand extends to opponent head.
	for f in range(10, 16):
		var t: float = float(f - 10) / 5.0
		var rh := RH_GUARD.lerp(Vector3(0.48, 1.70, 0.0), t)
		rows.append(_row(f, 0, "pro_jab", HIPS0, HEAD0, LH_GUARD, rh))
	## Boxer 1 present at frames 10-15 (opponent target).
	for f in range(10, 16):
		rows.append(_row(f, 1, "idle", HIPS1, HEAD1, LH_GUARD, RH_GUARD))
	## Recovery: hand comes home at frame 18 (3 frames after far=15).
	rows.append(_row(16, 0, "idle", HIPS0, HEAD0, LH_GUARD, Vector3(0.40, 1.60, 0.0)))
	rows.append(_row(17, 0, "idle", HIPS0, HEAD0, LH_GUARD, Vector3(0.30, 1.50, 0.0)))
	rows.append(_row(18, 0, "idle", HIPS0, HEAD0, LH_GUARD, Vector3(0.22, 1.38, 0.0)))
	var r := PE.analyse(rows)
	_check(r["punches"].size() == 1, "jab: 1 punch")
	var p: Dictionary = r["punches"][0]
	_check(p["clip"] == "pro_jab", "jab: clip")
	_check(p["who"] == 0, "jab: who")
	_check(p["start_frame"] == 10, "jab: start_frame")
	_check(p["far_frame"] == 15, "jab: far_frame")
	_check(_approx(p["above_cm"], 0.0, 1.0), "jab: above_cm ~0, got %f" % p["above_cm"])
	_check(p["home_frames"] == 3, "jab: home_frames 3, got %d" % p["home_frames"])
	_check(r["head_n"] == 1, "jab: head_n 1")
	_check(r["above_10_n"] == 0, "jab: above_10_n 0")


func _test_cross_above() -> void:
	## Cross ending 20 cm above target head: above10 counts it.
	var rows: Array = []
	for f in range(10, 16):
		var t: float = float(f - 10) / 5.0
		var rh := RH_GUARD.lerp(Vector3(0.48, 1.90, 0.0), t)
		rows.append(_row(f, 0, "pro_cross", HIPS0, HEAD0, LH_GUARD, rh))
	for f in range(10, 16):
		rows.append(_row(f, 1, "idle", HIPS1, HEAD1, LH_GUARD, RH_GUARD))
	var r := PE.analyse(rows)
	_check(r["punches"].size() == 1, "cross: 1 punch")
	var p: Dictionary = r["punches"][0]
	_check(_approx(p["above_cm"], 20.0, 2.0), "cross: above_cm ~20, got %f" % p["above_cm"])
	_check(r["head_n"] == 1, "cross: head_n 1")
	_check(r["above_10_n"] == 1, "cross: above_10_n 1")


func _test_body_shot() -> void:
	## Body shot: not a head punch, not in above10.
	var rows: Array = []
	for f in range(10, 16):
		var t: float = float(f - 10) / 5.0
		var rh := RH_GUARD.lerp(Vector3(0.45, 1.20, 0.0), t)
		rows.append(_row(f, 0, "pro_body_shot", HIPS0, HEAD0, LH_GUARD, rh))
	for f in range(10, 16):
		rows.append(_row(f, 1, "idle", HIPS1, HEAD1, LH_GUARD, RH_GUARD))
	var r := PE.analyse(rows)
	_check(r["punches"].size() == 1, "body: 1 punch")
	var p: Dictionary = r["punches"][0]
	_check(p["is_body"] == true, "body: is_body true")
	_check(r["head_n"] == 0, "body: head_n 0")
	_check(r["above_10_n"] == 0, "body: above_10_n 0")


func _test_southpaw() -> void:
	## Southpaw: clip is pro_left_jab but RIGHT hand punches (grows more).
	## MUTANT: if hand picked by clip word 'left' -> LeftHand, the left hand growth is ~0,
	## the far frame distance would be ~0.54 (guard), above_cm would be ~-20 (hand below head),
	## and home_frames would differ. This check proves the movement-based pick works.
	var rows: Array = []
	for f in range(10, 16):
		var t: float = float(f - 10) / 5.0
		var rh := RH_GUARD.lerp(Vector3(0.48, 1.70, 0.0), t)
		rows.append(_row(f, 0, "pro_left_jab", HIPS0, HEAD0, LH_GUARD, rh))
	for f in range(10, 16):
		rows.append(_row(f, 1, "idle", HIPS1, HEAD1, LH_GUARD, RH_GUARD))
	var r := PE.analyse(rows)
	_check(r["punches"].size() == 1, "southpaw: 1 punch")
	var p: Dictionary = r["punches"][0]
	_check(_approx(p["above_cm"], 0.0, 2.0), "southpaw: above_cm ~0 (right hand reached head), got %f" % p["above_cm"])


func _test_home_3() -> void:
	## Hand comes home in 3 frames (already tested in jab, but explicit).
	var rows: Array = []
	for f in range(10, 16):
		var t: float = float(f - 10) / 5.0
		var rh := RH_GUARD.lerp(Vector3(0.48, 1.70, 0.0), t)
		rows.append(_row(f, 0, "pro_jab", HIPS0, HEAD0, LH_GUARD, rh))
	for f in range(10, 16):
		rows.append(_row(f, 1, "idle", HIPS1, HEAD1, LH_GUARD, RH_GUARD))
	rows.append(_row(16, 0, "idle", HIPS0, HEAD0, LH_GUARD, Vector3(0.35, 1.50, 0.0)))
	rows.append(_row(17, 0, "idle", HIPS0, HEAD0, LH_GUARD, Vector3(0.28, 1.45, 0.0)))
	rows.append(_row(18, 0, "idle", HIPS0, HEAD0, LH_GUARD, Vector3(0.21, 1.39, 0.0)))
	var r := PE.analyse(rows)
	var p: Dictionary = r["punches"][0]
	_check(p["home_frames"] == 3, "home3: home_frames 3, got %d" % p["home_frames"])


func _test_home_never() -> void:
	## Hand never comes home: 30.
	var rows: Array = []
	for f in range(10, 16):
		var t: float = float(f - 10) / 5.0
		var rh := RH_GUARD.lerp(Vector3(0.48, 1.70, 0.0), t)
		rows.append(_row(f, 0, "pro_jab", HIPS0, HEAD0, LH_GUARD, rh))
	for f in range(10, 16):
		rows.append(_row(f, 1, "idle", HIPS1, HEAD1, LH_GUARD, RH_GUARD))
	## Hand stays out for 30+ frames.
	for f in range(16, 50):
		rows.append(_row(f, 0, "idle", HIPS0, HEAD0, LH_GUARD, Vector3(0.48, 1.70, 0.0)))
	var r := PE.analyse(rows)
	var p: Dictionary = r["punches"][0]
	_check(p["home_frames"] == 30, "home_never: home_frames 30, got %d" % p["home_frames"])


func _test_short_run_ignored() -> void:
	## 2-frame run: ignored.
	var rows: Array = []
	rows.append(_row(10, 0, "pro_jab", HIPS0, HEAD0, LH_GUARD, Vector3(0.3, 1.5, 0.0)))
	rows.append(_row(11, 0, "pro_jab", HIPS0, HEAD0, LH_GUARD, Vector3(0.4, 1.6, 0.0)))
	rows.append(_row(10, 1, "idle", HIPS1, HEAD1, LH_GUARD, RH_GUARD))
	rows.append(_row(11, 1, "idle", HIPS1, HEAD1, LH_GUARD, RH_GUARD))
	var r := PE.analyse(rows)
	_check(r["punches"].size() == 0, "short: 0 punches")


func _test_skipped_frame_splits() -> void:
	## Same clip but frame gap -> two runs. Both < 3 frames -> ignored.
	var rows: Array = []
	rows.append(_row(10, 0, "pro_jab", HIPS0, HEAD0, LH_GUARD, Vector3(0.3, 1.5, 0.0)))
	rows.append(_row(11, 0, "pro_jab", HIPS0, HEAD0, LH_GUARD, Vector3(0.4, 1.6, 0.0)))
	rows.append(_row(13, 0, "pro_jab", HIPS0, HEAD0, LH_GUARD, Vector3(0.3, 1.5, 0.0)))
	rows.append(_row(14, 0, "pro_jab", HIPS0, HEAD0, LH_GUARD, Vector3(0.4, 1.6, 0.0)))
	for f in [10, 11, 13, 14]:
		rows.append(_row(f, 1, "idle", HIPS1, HEAD1, LH_GUARD, RH_GUARD))
	var r := PE.analyse(rows)
	_check(r["punches"].size() == 0, "skipped: 0 punches (both runs < 3)")


func _test_missing_opponent() -> void:
	## Opponent row missing at far frame -> punch skipped.
	var rows: Array = []
	for f in range(10, 16):
		var t: float = float(f - 10) / 5.0
		var rh := RH_GUARD.lerp(Vector3(0.48, 1.70, 0.0), t)
		rows.append(_row(f, 0, "pro_jab", HIPS0, HEAD0, LH_GUARD, rh))
	## No boxer 1 rows at all -> opponent missing at far frame 15.
	var r := PE.analyse(rows)
	_check(r["punches"].size() == 0, "missing_opp: 0 punches (opponent missing)")
