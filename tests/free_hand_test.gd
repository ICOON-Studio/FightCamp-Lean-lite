extends SceneTree
## FREE_HAND_TEST: fixtures for the free-hand ruler.
## Does the glove that is NOT punching stay at the chin?

const FreeHand = preload("res://scripts/rules/FreeHand.gd")

var failures := 0


func _initialize() -> void:
	_test_jab_ok()
	_test_cross_drop()
	_test_body_excluded()
	_test_hand_swap()
	_test_empty()
	_test_aggregate()
	print("FREE_HAND_TEST failures=%d" % failures)
	quit(1 if failures > 0 else 0)


func _test_jab_ok() -> void:
	# Jab: right hand punches (extends far), left hand stays 12 cm from head.
	var rows := []
	for i in range(5):
		var ov := {
			"LeftHand_x": 0.10, "LeftHand_y": 1.78, "LeftHand_z": 0.05,
			"RightHand_x": -0.10 - 0.10 * i, "RightHand_y": 1.50, "RightHand_z": 0.20,
		}
		rows.append(_row(100 + i, "pro_jab", ov))
	var res := FreeHand.analyse(rows)
	_check(res["runs_count"] == 1, "jab: runs_count")
	_check(res["runs_off"] == 0, "jab: runs_off")
	_check(res["runs"][0]["is_body"] == false, "jab: not body")
	_check(res["runs"][0]["frames_off"] == 0, "jab: frames_off")
	_check(abs(res["runs"][0]["max_free_cm"] - 12.0) < 2.0, "jab: max_free_cm ~12")


func _test_cross_drop() -> void:
	# Cross: left hand punches, right hand (free) drops 26 cm below head for 5 frames.
	var rows := []
	for i in range(5):
		var ov := {
			"LeftHand_x": 0.10 + 0.10 * i, "LeftHand_y": 1.50, "LeftHand_z": 0.20,
			"RightHand_x": -0.12, "RightHand_y": 1.54, "RightHand_z": 0.05,
		}
		rows.append(_row(100 + i, "pro_cross", ov))
	var res := FreeHand.analyse(rows)
	_check(res["runs_count"] == 1, "cross: runs_count")
	_check(res["runs_off"] == 1, "cross: runs_off")
	_check(res["runs"][0]["frames_off"] == 5, "cross: all 5 frames off")
	_check(abs(res["runs"][0]["max_drop_cm"] - 26.0) < 2.0, "cross: max_drop ~26")


func _test_body_excluded() -> void:
	# Body shot: free hand far away (would be off), but body shots excluded from runs_off.
	var rows := []
	for i in range(5):
		var ov := {
			"LeftHand_x": -0.30, "LeftHand_y": 1.50, "LeftHand_z": 0.10,
			"RightHand_x": 0.10 + 0.10 * i, "RightHand_y": 1.20, "RightHand_z": 0.20,
		}
		rows.append(_row(100 + i, "pro_body_shot", ov))
	var res := FreeHand.analyse(rows)
	_check(res["runs_count"] == 1, "body: runs_count")
	_check(res["runs_off"] == 0, "body: excluded from runs_off")
	_check(res["runs"][0]["is_body"] == true, "body: is_body")
	_check(res["runs"][0]["frames_off"] == 5, "body: frames_off counted")


func _test_hand_swap() -> void:
	# Right hand extends far from UpperChest -> punching. Left hand (free) stays near head.
	var rows := []
	for i in range(5):
		var ov := {
			"LeftHand_x": 0.10 + 0.01 * i, "LeftHand_y": 1.78, "LeftHand_z": 0.05,
			"RightHand_x": -0.10 - 0.10 * i, "RightHand_y": 1.50, "RightHand_z": 0.20,
		}
		rows.append(_row(100 + i, "pro_jab", ov))
	var res := FreeHand.analyse(rows)
	_check(res["runs_count"] == 1, "swap: runs_count")
	_check(res["runs_off"] == 0, "swap: free hand stays near head")
	_check(abs(res["runs"][0]["max_free_cm"] - 10.0) < 5.0, "swap: free ~10-15 cm")


func _test_empty() -> void:
	var res := FreeHand.analyse([])
	_check(res["runs_count"] == 0, "empty: no runs")
	_check(res["runs_off"] == 0, "empty: no off")
	_check(res["off_share"] == 0.0, "empty: off_share")


func _test_aggregate() -> void:
	var rows := []
	# Jab (who=0): free hand 12 cm, not off.
	for i in range(5):
		rows.append(_row(i, "pro_jab", {
			"LeftHand_x": 0.10, "LeftHand_y": 1.78, "LeftHand_z": 0.05,
			"RightHand_x": -0.10 - 0.10 * i, "RightHand_y": 1.50, "RightHand_z": 0.20,
		}))
	# Cross (who=0): free hand drops 26 cm, off.
	for i in range(5):
		rows.append(_row(10 + i, "pro_cross", {
			"LeftHand_x": 0.10 + 0.10 * i, "LeftHand_y": 1.50, "LeftHand_z": 0.20,
			"RightHand_x": -0.12, "RightHand_y": 1.54, "RightHand_z": 0.05,
		}))
	# Body shot (who=0): excluded from runs_off.
	for i in range(5):
		rows.append(_row(20 + i, "pro_body_shot", {
			"LeftHand_x": -0.30, "LeftHand_y": 1.50, "LeftHand_z": 0.10,
			"RightHand_x": 0.10 + 0.10 * i, "RightHand_y": 1.20, "RightHand_z": 0.20,
		}))
	# Hand swap (who=0): right hand punches, left hand free at 10 cm.
	for i in range(5):
		rows.append(_row(30 + i, "pro_jab", {
			"LeftHand_x": 0.10 + 0.01 * i, "LeftHand_y": 1.78, "LeftHand_z": 0.05,
			"RightHand_x": -0.10 - 0.10 * i, "RightHand_y": 1.50, "RightHand_z": 0.20,
		}))
	# Cross drop (who=1): free hand drops 35 cm, off.
	for i in range(5):
		rows.append(_row(100 + i, "pro_cross", {
			"who": 1,
			"LeftHand_x": 0.10 + 0.10 * i, "LeftHand_y": 1.50, "LeftHand_z": 0.20,
			"RightHand_x": -0.10, "RightHand_y": 1.45, "RightHand_z": 0.05,
		}))
	# Guard frames (who=0): both hands ~11 cm from head.
	for i in range(3):
		rows.append(_row(200 + i, "pro_guard", {
			"LeftHand_x": 0.10, "LeftHand_y": 1.78, "LeftHand_z": 0.05,
			"RightHand_x": -0.10, "RightHand_y": 1.78, "RightHand_z": 0.05,
		}))
	var res := FreeHand.analyse(rows)
	_check(res["runs_count"] == 5, "agg: 5 runs")
	_check(res["runs_off"] == 2, "agg: 2 runs off (cross + cross_drop, body excluded)")
	_check(abs(res["off_share"] - 0.5) < 0.01, "agg: off_share 0.5")
	_check(abs(res["free_cm_p50"] - 15.0) < 2.0, "agg: free_p50 ~15")
	_check(abs(res["free_cm_p90"] - 29.0) < 2.0, "agg: free_p90 ~29")
	_check(abs(res["drop_cm_p90"] - 26.0) < 2.0, "agg: drop_p90 ~26")
	_check(res["guard_free_cm_p50"] > 5.0, "agg: guard p50 > 5")
	_check(res["guard_free_cm_p50"] < 20.0, "agg: guard p50 < 20")
	_check(res["by_clip"]["pro_jab"]["n"] == 2, "agg: jab n=2")
	_check(res["by_clip"]["pro_cross"]["n"] == 2, "agg: cross n=2")
	_check(abs(res["by_clip"]["pro_cross"]["off_share"] - 1.0) < 0.01, "agg: cross off_share 1.0")


func _row(frame: int, clip: String, ov: Dictionary = {}) -> Dictionary:
	var d := {
		"frame": frame, "who": 0, "clip": clip, "hold": "0", "phase": "",
		"Head_x": 0.0, "Head_y": 1.80, "Head_z": 0.0,
		"LeftHand_x": 0.15, "LeftHand_y": 1.50, "LeftHand_z": 0.10,
		"RightHand_x": -0.15, "RightHand_y": 1.50, "RightHand_z": 0.10,
		"Hips_x": 0.0, "Hips_y": 1.0, "Hips_z": 0.0,
		"UpperChest_x": 0.0, "UpperChest_y": 1.40, "UpperChest_z": 0.0,
		"LeftShoulder_x": -0.15, "LeftShoulder_y": 1.60, "LeftShoulder_z": 0.0,
		"RightShoulder_x": 0.15, "RightShoulder_y": 1.60, "RightShoulder_z": 0.0,
	}
	for k in ov:
		d[k] = ov[k]
	return d


func _check(cond: bool, label: String) -> void:
	if cond:
		print("PASS ", label)
	else:
		failures += 1
		print("FAIL ", label)
