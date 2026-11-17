extends SceneTree
## PUNCH_END_TEST: the ruler that reads where each punch ends and how fast the hand comes home.
## Hand-built rows (no csv). 14 checks: empty, jab on head, cross above, body shot, southpaw,
## home in 3, home never (30), short run ignored, skipped frame splits, missing opponent skipped,
## mid-blend home from guard, no idle before (home_from start), contact_home 4, contact_home -1.

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
	_test_mid_blend_home_from_guard()
	_test_no_idle_before()
	_test_contact_home_4()
	_test_contact_home_minus1()
	_test_home_inside_clip()
	_test_hold_of_the_other_man()
	_test_chest_frame_cross()
	_test_chest_ring_counts()
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


## Build a row WITH shoulder columns. Hand positions are given in the CHEST FRAME (right, up, forward) and
## converted to world. The chest rotates around the Y axis through UpperChest by `chest_angle_deg`.
func _row_chest(frame: int, who: int, clip: String, hips: Vector3, head: Vector3, lh_chest: Vector3, rh_chest: Vector3, chest_angle_deg: float) -> Dictionary:
	var uc := hips + Vector3(0.0, 0.4, 0.0)
	var angle := deg_to_rad(chest_angle_deg)
	var cos_a := cos(angle)
	var sin_a := sin(angle)
	var ls_local := Vector3(-0.15, 0.0, 0.0)
	var rs_local := Vector3(0.15, 0.0, 0.0)
	var ls := uc + Vector3(ls_local.x * cos_a - ls_local.z * sin_a, ls_local.y, ls_local.x * sin_a + ls_local.z * cos_a)
	var rs := uc + Vector3(rs_local.x * cos_a - rs_local.z * sin_a, rs_local.y, rs_local.x * sin_a + rs_local.z * cos_a)
	var right := rs - ls
	right.y = 0.0
	right = right.normalized()
	var up := Vector3(0.0, 1.0, 0.0)
	var forward := up.cross(right)
	var lh_world := uc + lh_chest.x * right + lh_chest.y * up + lh_chest.z * forward
	var rh_world := uc + rh_chest.x * right + rh_chest.y * up + rh_chest.z * forward
	var row := _row(frame, who, clip, hips, head, lh_world, rh_world)
	row["UpperChest_x"] = uc.x; row["UpperChest_y"] = uc.y; row["UpperChest_z"] = uc.z
	row["LeftShoulder_x"] = ls.x; row["LeftShoulder_y"] = ls.y; row["LeftShoulder_z"] = ls.z
	row["RightShoulder_x"] = rs.x; row["RightShoulder_y"] = rs.y; row["RightShoulder_z"] = rs.z
	return row


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


func _test_mid_blend_home_from_guard() -> void:
	## Mid-blend start: punch run starts 41 cm off guard, but idle frames before show guard position.
	## OLD RULE (first-frame): home = hand pos at frame 10 = (0.48, 1.7, 0.0) - HIPS0 = (0.48, 0.7, 0.0),
	##   distance from guard = 0.41m, hand never returns to 41cm-off position -> home_frames = 30.
	## NEW RULE (guard): home = avg of idle frames 5-9 = RH_GUARD = (0.2, 1.4, 0.0),
	##   hand returns to guard at frame 18 -> home_frames = 3.
	var rows: Array = []
	## Idle frames 5-9 at guard position.
	for f in range(5, 10):
		rows.append(_row(f, 0, "idle", HIPS0, HEAD0, LH_GUARD, RH_GUARD))
	## Punch run frames 10-15, starts 41cm off guard, extends further.
	for f in range(10, 16):
		var t: float = float(f - 10) / 5.0
		var rh := Vector3(0.48, 1.70, 0.0).lerp(Vector3(0.5, 1.7, 0.0), t)
		rows.append(_row(f, 0, "pro_jab", HIPS0, HEAD0, LH_GUARD, rh))
	for f in range(5, 16):
		rows.append(_row(f, 1, "idle", HIPS1, HEAD1, LH_GUARD, RH_GUARD))
	## Recovery: hand returns to guard at frame 18.
	rows.append(_row(16, 0, "idle", HIPS0, HEAD0, LH_GUARD, Vector3(0.35, 1.55, 0.0)))
	rows.append(_row(17, 0, "idle", HIPS0, HEAD0, LH_GUARD, Vector3(0.28, 1.48, 0.0)))
	rows.append(_row(18, 0, "idle", HIPS0, HEAD0, LH_GUARD, RH_GUARD))
	var r := PE.analyse(rows)
	_check(r["punches"].size() == 1, "mid_blend: 1 punch")
	var p: Dictionary = r["punches"][0]
	_check(p["home_from"] == "guard", "mid_blend: home_from guard, got %s" % p["home_from"])
	_check(p["home_frames"] == 3, "mid_blend: home_frames 3 (not 30), got %d" % p["home_frames"])


func _test_no_idle_before() -> void:
	## No idle frame in 45 frames before punch -> home_from "start".
	var rows: Array = []
	## Punch starts at frame 100, no idle/guard frames before it for boxer 0.
	for f in range(100, 106):
		var t: float = float(f - 100) / 5.0
		var rh := RH_GUARD.lerp(Vector3(0.48, 1.70, 0.0), t)
		rows.append(_row(f, 0, "pro_jab", HIPS0, HEAD0, LH_GUARD, rh))
	for f in range(55, 106):
		rows.append(_row(f, 1, "idle", HIPS1, HEAD1, LH_GUARD, RH_GUARD))
	rows.append(_row(106, 0, "idle", HIPS0, HEAD0, LH_GUARD, RH_GUARD))
	var r := PE.analyse(rows)
	_check(r["punches"].size() == 1, "no_idle: 1 punch")
	var p: Dictionary = r["punches"][0]
	_check(p["home_from"] == "start", "no_idle: home_from start, got %s" % p["home_from"])


func _test_contact_home_4() -> void:
	## Landed punch with hold=1 on 3rd frame, hand home 4 frames after contact.
	var rows: Array = []
	for f in range(5, 10):
		rows.append(_row(f, 0, "idle", HIPS0, HEAD0, LH_GUARD, RH_GUARD))
	## Punch frames 10-15, hold=1 at frame 12 (3rd frame of run). S504 collect: the hand is at full reach by then (the
	## contact is where the glove lands; a hold with the hand still near the chin is the other man's, see below).
	for f in range(10, 16):
		var t: float = minf(1.0, float(f - 10) / 2.0)
		var rh := RH_GUARD.lerp(Vector3(0.48, 1.70, 0.0), t)
		var row := _row(f, 0, "pro_jab", HIPS0, HEAD0, LH_GUARD, rh)
		row["hold"] = "1" if f == 12 else "0"
		rows.append(row)
	for f in range(5, 16):
		var row := _row(f, 1, "idle", HIPS1, HEAD1, LH_GUARD, RH_GUARD)
		row["hold"] = "0"
		rows.append(row)
	## Hand returns to guard at frame 16 (4 frames after contact at 12).
	rows.append(_row(16, 0, "idle", HIPS0, HEAD0, LH_GUARD, RH_GUARD))
	var r := PE.analyse(rows)
	_check(r["punches"].size() == 1, "contact_home: 1 punch")
	var p: Dictionary = r["punches"][0]
	_check(p["contact_home_frames"] == 4, "contact_home: 4, got %d" % p["contact_home_frames"])
	_check(r["landed_n"] == 1, "contact_home: landed_n 1, got %d" % r["landed_n"])
	_check(r["contact_home_le4"] == 1, "contact_home: le4 1, got %d" % r["contact_home_le4"])


func _test_contact_home_minus1() -> void:
	## No hold frame -> contact_home_frames = -1, not counted in landed_n.
	var rows: Array = []
	for f in range(5, 10):
		rows.append(_row(f, 0, "idle", HIPS0, HEAD0, LH_GUARD, RH_GUARD))
	for f in range(10, 16):
		var t: float = float(f - 10) / 5.0
		var rh := RH_GUARD.lerp(Vector3(0.48, 1.70, 0.0), t)
		var row := _row(f, 0, "pro_jab", HIPS0, HEAD0, LH_GUARD, rh)
		row["hold"] = "0"
		rows.append(row)
	for f in range(5, 16):
		var row := _row(f, 1, "idle", HIPS1, HEAD1, LH_GUARD, RH_GUARD)
		row["hold"] = "0"
		rows.append(row)
	var r := PE.analyse(rows)
	_check(r["punches"].size() == 1, "no_hold: 1 punch")
	var p: Dictionary = r["punches"][0]
	_check(p["contact_home_frames"] == -1, "no_hold: contact_home -1, got %d" % p["contact_home_frames"])
	_check(r["landed_n"] == 0, "no_hold: landed_n 0, got %d" % r["landed_n"])


func _test_home_inside_clip() -> void:
	## S504 collect: the hand comes home INSIDE the punch clip's own recovery (frame 16; the clip runs to 24). The search
	## starts after the far point / the contact, not after the run: the old rule read home 12 / contact_home 12 here.
	var rows: Array = []
	for f in range(5, 10):
		rows.append(_row(f, 0, "idle", HIPS0, HEAD0, LH_GUARD, RH_GUARD))
	for f in range(10, 25):
		var rh := RH_GUARD.lerp(Vector3(0.48, 1.70, 0.0), float(f - 10) / 3.0) if f <= 13 else RH_GUARD.lerp(Vector3(0.48, 1.70, 0.0), maxf(0.0, float(16 - f) / 3.0))
		var row := _row(f, 0, "pro_cross", HIPS0, HEAD0, LH_GUARD, rh)
		row["hold"] = "1" if f == 13 else "0"
		rows.append(row)
	for f in range(5, 25):
		var row := _row(f, 1, "idle", HIPS1, HEAD1, LH_GUARD, RH_GUARD)
		row["hold"] = "0"
		rows.append(row)
	var r := PE.analyse(rows)
	_check(r["punches"].size() == 1, "inside_clip: 1 punch")
	if r["punches"].is_empty():
		return
	var p: Dictionary = r["punches"][0]
	_check(p["home_frames"] == 3, "inside_clip: home 3 frames after the far point, got %d" % p["home_frames"])
	_check(p["contact_home_frames"] == 3, "inside_clip: contact_home 3 (glove lands at the far point, 13), got %d" % p["contact_home_frames"])


func _test_hold_of_the_other_man() -> void:
	## S504 collect: the stage's hold lands on both rows. A hold while this hand is still near the chin (frame 10, the run's
	## first frame) is the other man's punch landing, not this punch's contact: contact_home -1, not landed.
	var rows: Array = []
	for f in range(5, 10):
		rows.append(_row(f, 0, "idle", HIPS0, HEAD0, LH_GUARD, RH_GUARD))
	for f in range(10, 16):
		var row := _row(f, 0, "pro_jab", HIPS0, HEAD0, LH_GUARD, RH_GUARD.lerp(Vector3(0.48, 1.70, 0.0), float(f - 10) / 5.0))
		row["hold"] = "1" if f == 10 else "0"
		rows.append(row)
	for f in range(5, 16):
		var row := _row(f, 1, "idle", HIPS1, HEAD1, LH_GUARD, RH_GUARD)
		row["hold"] = "1" if f == 10 else "0"
		rows.append(row)
	var r := PE.analyse(rows)
	_check(r["punches"].size() == 1 and int(r["punches"][0]["contact_home_frames"]) == -1 and int(r["landed_n"]) == 0,
		"other man's hold: not this punch's contact, got %s" % str(r["punches"][0]["contact_home_frames"] if not r["punches"].is_empty() else "none"))


func _test_chest_frame_cross() -> void:
	## S505: a cross that turns the chest 40° between guard and far point. The hand returns to the SAME SPOT in
	## the chest frame (guard position) by frame 18. In the chest frame: home in 3 frames. In ring axes (old rule):
	## the guard reference was taken at 0° chest angle, but the recovery hand is at 40° chest angle -> different
	## world position. Distance in ring axes: ~0.137m > 0.08m HOME_RADIUS_M -> NOT home (would read 30 = never).
	## Chest-frame positions: RH_GUARD = (0.2, 0.0, 0.0); extended = (0.1, 0.1, -0.5); recovery returns to guard.
	var rows: Array = []
	## Guard rows (frames 5-9): chest at 0°, hand at guard in chest frame.
	for f in range(5, 10):
		rows.append(_row_chest(f, 0, "idle", HIPS0, HEAD0, Vector3(-0.2, 0.1, 0.0), Vector3(0.2, 0.0, 0.0), 0.0))
	## Punch run (frames 10-15): chest turns to 40°, hand extends forward in chest frame.
	for f in range(10, 16):
		var t: float = float(f - 10) / 5.0
		var rh_chest := Vector3(0.2, 0.0, 0.0).lerp(Vector3(0.1, 0.1, -0.5), t)
		rows.append(_row_chest(f, 0, "pro_cross", HIPS0, HEAD0, Vector3(-0.2, 0.1, 0.0), rh_chest, 40.0))
	## Opponent present for the far frame check.
	for f in range(5, 16):
		rows.append(_row(f, 1, "idle", HIPS1, HEAD1, LH_GUARD, RH_GUARD))
	## Recovery (frames 16-18): chest still at 40°, hand returns to guard in chest frame over 3 frames.
	rows.append(_row_chest(16, 0, "idle", HIPS0, HEAD0, Vector3(-0.2, 0.1, 0.0), Vector3(0.17, 0.07, -0.33), 40.0))
	rows.append(_row_chest(17, 0, "idle", HIPS0, HEAD0, Vector3(-0.2, 0.1, 0.0), Vector3(0.19, 0.03, -0.17), 40.0))
	rows.append(_row_chest(18, 0, "idle", HIPS0, HEAD0, Vector3(-0.2, 0.1, 0.0), Vector3(0.2, 0.0, 0.0), 40.0))
	var r := PE.analyse(rows)
	_check(r["punches"].size() == 1, "chest_cross: 1 punch, got %d" % r["punches"].size())
	if r["punches"].is_empty():
		return
	var p: Dictionary = r["punches"][0]
	_check(p["home_frames"] <= 4, "chest_cross: home within 4 frames in chest frame, got %d" % p["home_frames"])
	_check(int(r["chest_frame_rows"]) == 14, "chest_cross: chest_frame_rows 14, got %d" % r["chest_frame_rows"])
	_check(int(r["ring_axes_rows"]) == 11, "chest_cross: ring_axes_rows 11 (opponent has no shoulders), got %d" % r["ring_axes_rows"])


func _test_chest_ring_counts() -> void:
	## S505: mixed rows - some with shoulder columns (chest frame), some without (ring axes fallback).
	## Verify the summary counts chest_frame_rows and ring_axes_rows correctly.
	var rows: Array = []
	## 3 rows with shoulders (chest frame).
	for f in range(10, 13):
		rows.append(_row_chest(f, 0, "pro_jab", HIPS0, HEAD0, Vector3(-0.2, 0.1, 0.0), Vector3(0.2, 0.0, 0.0), 0.0))
	## 2 rows without shoulders (ring axes).
	for f in range(13, 15):
		rows.append(_row(f, 0, "idle", HIPS0, HEAD0, LH_GUARD, RH_GUARD))
	var r := PE.analyse(rows)
	_check(int(r["chest_frame_rows"]) == 3, "counts: chest_frame_rows 3, got %d" % r["chest_frame_rows"])
	_check(int(r["ring_axes_rows"]) == 2, "counts: ring_axes_rows 2, got %d" % r["ring_axes_rows"])

