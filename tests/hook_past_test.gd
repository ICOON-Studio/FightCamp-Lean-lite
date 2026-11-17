extends SceneTree
## HOOK_PAST_TEST: fixtures for the fling ruler - after a landed punch, how far and how fast does the glove go past?
## Every fixture is built in code. Values are Strings, as shown.csv writes them.
## A coach's hook: the fist stops at the jaw and comes home on the same line (3 m/s, no fling).
## A swing: the fist sails on across and up two frames after contact (10 m/s, up_cm > 10).

const HookPast = preload("res://scripts/rules/HookPast.gd")

const HEAD := Vector3(0.0, 1.80, 0.0)
const HIPS := Vector3(0.0, 1.00, 0.0)
const UC := Vector3(0.0, 1.40, 0.0)
const GUARD_L := Vector3(0.15, 1.62, 0.12)
const GUARD_R := Vector3(-0.15, 1.62, 0.12)
const CONTACT_Z := 0.90   # the hand at contact is sqrt(0.15^2 + 0.10^2 + 0.90^2) = 0.918 m from UpperChest

var failures := 0


func _initialize() -> void:
	_test_hook_stops_and_comes_home()
	_test_hook_flies_on()
	_test_no_hold_not_counted()
	_test_hold_too_early_not_contact()
	_test_left_and_right_interleaved()
	_test_window_cap()
	_test_kinds_and_summary()
	_test_mutants()
	_test_empty()
	print("HOOK_PAST_TEST failures=%d" % failures)
	quit(1 if failures > 0 else 0)


## The good hook: out at 4.5 m/s, contact at frame 104, home at 3 m/s. Nothing sails.
func _test_hook_stops_and_comes_home() -> void:
	var path := _punch_path(13, CONTACT_Z, 1.50, -1.0, Vector3.ZERO, 5, 3.0)
	var rows := _rows_for(100, 0, "pro_left_hook", path, [4], false)
	var res := HookPast.analyse(rows)
	_check(res["runs"] == 1, "stop: one landed run")
	if res["runs"] != 1:
		return
	var p: Dictionary = res["punches"][0]
	_check(p["hand"] == "RightHand", "stop: right hand punches")
	_check(p["kind"] == "hook", "stop: kind hook")
	_check(p["contact_frame"] == 104, "stop: contact at 104")
	_check(absf(p["fling_mps"] - 3.0) < 0.05, "stop: fastest post-contact frame is the 3 m/s return")
	_check(p["fling_frame"] == 2, "stop: that speed is 2 frames after contact")
	_check(absf(p["up_cm"]) < 0.01, "stop: no rise")
	_check(res["flings"] == 0, "stop: not a fling")
	# Blind spot, kept honest: past_cm is excursion from the contact point, so the 70 cm return home reads
	# as 70 cm past. The direction is not in this number - the speed gate is what calls a swing.
	_check(absf(p["past_cm"] - 70.0) < 0.5, "stop: past_cm is the whole excursion (70 cm home)")


## The swing: one frame at contact+2 carries the glove 30 cm across and 15 cm up = 10.06 m/s.
func _test_hook_flies_on() -> void:
	var sail := Vector3(0.30, 0.15, 0.0)
	var path := _punch_path(13, CONTACT_Z, 1.50, -1.0, sail, 6, 3.0)
	var rows := _rows_for(100, 0, "pro_left_hook_ft", path, [4], false)
	var res := HookPast.analyse(rows)
	_check(res["runs"] == 1, "fling: one landed run")
	if res["runs"] != 1:
		return
	var p: Dictionary = res["punches"][0]
	_check(p["contact_frame"] == 104, "fling: contact at 104 (the sail did not move the reach gate)")
	_check(absf(p["fling_mps"] - 10.06) < 0.1, "fling: 10 m/s two frames after contact")
	_check(p["fling_frame"] == 2, "fling: fling_frame 2")
	_check(p["up_cm"] > 10.0, "fling: up_cm > 10")
	_check(absf(p["up_cm"] - 15.0) < 0.1, "fling: up_cm 15")
	_check(absf(p["past_cm"] - 33.5) < 0.5, "fling: past_cm ~33.5")
	_check(res["flings"] == 1, "fling: counted as a fling")
	_check(res["worst"].size() == 1, "fling: worst has the run")
	_check(res["worst"][0]["clip"] == "pro_left_hook_ft", "fling: worst names the clip")


## No hold frame anywhere in the run: the punch never landed, so it is not counted.
func _test_no_hold_not_counted() -> void:
	var sail := Vector3(0.30, 0.15, 0.0)
	var path := _punch_path(13, CONTACT_Z, 1.50, -1.0, sail, 6, 3.0)
	var rows := _rows_for(100, 0, "pro_left_hook", path, [], false)
	var res := HookPast.analyse(rows)
	_check(res["runs"] == 0, "no hold: not counted")
	_check(res["flings"] == 0, "no hold: no flings")
	_check(res["worst"].is_empty(), "no hold: worst empty")


## The stage's hold is written on both boxers' rows: a hold while the hand is still near the chest is not
## this punch's contact. Only a hold at 85 % of the run's reach or more counts.
func _test_hold_too_early_not_contact() -> void:
	var path := _punch_path(13, CONTACT_Z, 1.50, -1.0, Vector3.ZERO, 5, 3.0)
	var early := _rows_for(100, 0, "pro_left_hook", path, [1], false)
	var res := HookPast.analyse(early)
	_check(res["runs"] == 0, "early hold: hand not out, not counted")
	var both := _rows_for(100, 0, "pro_left_hook", path, [1, 4], false)
	var res2 := HookPast.analyse(both)
	_check(res2["runs"] == 1, "early hold: the later hold at full reach counts")
	if res2["runs"] == 1:
		_check(res2["punches"][0]["contact_frame"] == 104, "early hold: contact is the full-reach frame")


## Both boxers are interleaved per frame in shown.csv: runs are built per who, and each hand is picked
## from its own run (the hand furthest from UpperChest).
func _test_left_and_right_interleaved() -> void:
	var a := _rows_for(300, 0, "pro_right_cross",
		_punch_path(13, CONTACT_Z, 1.50, -1.0, Vector3(0.30, 0.15, 0.0), 6, 3.0), [4], false)
	var b := _rows_for(300, 1, "pro_left_hook",
		_punch_path(13, CONTACT_Z, 1.50, 1.0, Vector3(-0.25, 0.10, 0.0), 6, 3.0), [4], true)
	var rows: Array = []
	for i in range(a.size()):
		rows.append(a[i])
		rows.append(b[i])
	var res := HookPast.analyse(rows)
	_check(res["runs"] == 2, "two boxers: two runs, not one merged run")
	_check(res["flings"] == 2, "two boxers: both fling")
	if res["runs"] != 2:
		return
	var hands := {}
	var left: Dictionary = {}
	for p in res["punches"]:
		hands[p["who"]] = p["hand"]
		_check(p["contact_frame"] == 304, "two boxers: contact 304")
		if p["who"] == 1:
			left = p
	_check(hands.get(0, "") == "RightHand", "two boxers: who 0 punches right")
	_check(hands.get(1, "") == "LeftHand", "two boxers: who 1 punches left")
	_check(not left.is_empty(), "two boxers: who 1 has a run")
	if not left.is_empty():
		_check(absf(left["up_cm"] - 10.0) < 0.1, "two boxers: left hook rises 10 cm")
		_check(absf(left["fling_mps"] - 8.08) < 0.1, "two boxers: left hook 8 m/s")


## The window is the contact frame plus at most 12 frames: a glove still creeping home at frame 20 is not read.
func _test_window_cap() -> void:
	var path := _punch_path(25, CONTACT_Z, 1.50, -1.0, Vector3.ZERO, 5, 1.5)
	var rows := _rows_for(100, 0, "pro_left_hook", path, [4], false)
	var res := HookPast.analyse(rows)
	_check(res["runs"] == 1, "cap: one run")
	if res["runs"] != 1:
		return
	var p: Dictionary = res["punches"][0]
	_check(absf(p["past_cm"] - 55.0) < 0.5, "cap: past_cm stops at frame 12 (55 cm, not 95)")
	_check(p["past_cm"] < 90.0, "cap: the frames after 12 are not read")
	_check(p["fling_frame"] <= 12, "cap: fling_frame inside the window")
	_check(absf(p["fling_mps"] - 1.5) < 0.05, "cap: 1.5 m/s creep")
	_check(res["flings"] == 0, "cap: a slow return is not a fling")


## Five kinds, five runs: the summary percentiles, by_kind and the worst list, on numbers worked out by hand.
func _test_kinds_and_summary() -> void:
	var rows: Array = []
	rows.append_array(_rows_for(100, 0, "pro_left_jab",
		_punch_path(13, CONTACT_Z, 1.50, -1.0, Vector3.ZERO, 5, 3.0), [4], false))
	rows.append_array(_rows_for(200, 0, "pro_right_cross",
		_punch_path(13, CONTACT_Z, 1.50, -1.0, Vector3(0.30, 0.15, 0.0), 6, 3.0), [4], false))
	rows.append_array(_rows_for(300, 0, "pro_left_hook_v2",
		_punch_path(13, CONTACT_Z, 1.50, -1.0, Vector3(0.25, 0.10, 0.0), 6, 3.0), [4], false))
	rows.append_array(_rows_for(400, 0, "pro_right_uppercut",
		_punch_path(13, CONTACT_Z, 1.50, -1.0, Vector3(0.10, 0.30, 0.0), 6, 3.0), [4], false))
	rows.append_array(_rows_for(500, 1, "pro_body_shot",
		_punch_path(13, CONTACT_Z, 1.20, -1.0, Vector3(0.20, 0.05, 0.0), 6, 3.0), [4], false))
	var res := HookPast.analyse(rows)
	_check(res["runs"] == 5, "summary: 5 landed runs")
	if res["runs"] != 5:
		return
	_check(res["flings"] == 4, "summary: 4 flings (the jab comes home)")
	_check(absf(res["past_p50"] - 31.6) < 0.2, "summary: past_p50 ~31.6")
	_check(absf(res["past_p90"] - 33.5) < 0.2, "summary: past_p90 ~33.5")
	_check(absf(res["up_p90"] - 15.0) < 0.1, "summary: up_p90 15")
	_check(absf(res["fling_p50"] - 8.08) < 0.1, "summary: fling_p50 ~8.1")
	_check(absf(res["fling_p90"] - 9.49) < 0.1, "summary: fling_p90 ~9.5")
	var kinds := ["jab", "cross", "hook", "uppercut", "body"]
	for k in kinds:
		_check(res["by_kind"].has(k), "summary: by_kind has %s" % k)
		if res["by_kind"].has(k):
			_check(res["by_kind"][k]["n"] == 1, "summary: %s n=1" % k)
	_check(res["by_kind"]["jab"]["flings"] == 0, "summary: jab no fling")
	_check(res["by_kind"]["uppercut"]["flings"] == 1, "summary: uppercut flings")
	_check(absf(res["by_kind"]["uppercut"]["fling_p90"] - 9.49) < 0.1, "summary: uppercut fling_p90")
	_check(absf(res["by_kind"]["body"]["past_p90"] - 20.6) < 0.2, "summary: body past_p90")
	var worst: Array = res["worst"]
	_check(worst.size() == 5, "summary: worst holds 5")
	if worst.size() != 5:
		return
	_check(worst[0]["clip"] == "pro_right_cross", "summary: worst first is the cross")
	_check(worst[1]["clip"] == "pro_right_uppercut", "summary: worst second is the uppercut")
	_check(worst[4]["clip"] == "pro_left_jab", "summary: worst last is the jab")
	for i in range(1, worst.size()):
		_check(worst[i - 1]["fling_mps"] >= worst[i]["fling_mps"], "summary: worst sorted at %d" % i)
	_check(worst[0]["start_frame"] == 200, "summary: worst carries the start frame")
	_check(worst[0]["who"] == 0, "summary: worst carries who")


## MUTANTS: wrong-way copies of the fixtures. Each must break the assert the real fixture passes, so the
## checks are known to be sensitive to the thing they claim to measure.
func _test_mutants() -> void:
	var sail := Vector3(0.30, 0.15, 0.0)
	# 1. the same hook with the sail slowed to a 3 m/s return: no fling.
	var slow := _rows_for(100, 0, "pro_left_hook",
		_punch_path(13, CONTACT_Z, 1.50, -1.0, Vector3.ZERO, 5, 3.0), [4], false)
	var m1 := HookPast.analyse(slow)
	_check(m1["flings"] == 0, "mutant slow: the fling assert fails without the sail")
	_check(m1["runs"] == 1, "mutant slow: still a landed run")
	if m1["runs"] == 1:
		_check(m1["punches"][0]["fling_mps"] < 6.0, "mutant slow: under the 6 m/s gate")
	# 2. the sail one frame after contact instead of two: the impact frame is not a fling.
	var soon := _rows_for(100, 0, "pro_left_hook",
		_punch_path(13, CONTACT_Z, 1.50, -1.0, sail, 5, 3.0), [4], false)
	var m2 := HookPast.analyse(soon)
	_check(m2["runs"] == 1, "mutant early sail: still a landed run")
	_check(m2["flings"] == 0, "mutant early sail: frame 1 is the impact, not a fling")
	if m2["runs"] == 1:
		_check(m2["punches"][0]["fling_mps"] > 6.0, "mutant early sail: still fast")
	# 3. the sail across only, no rise: up_cm must fall to nothing.
	var flat := _rows_for(100, 0, "pro_left_hook",
		_punch_path(13, CONTACT_Z, 1.50, -1.0, Vector3(0.30, 0.0, 0.0), 6, 3.0), [4], false)
	var m3 := HookPast.analyse(flat)
	_check(m3["runs"] == 1, "mutant flat: still a landed run")
	_check(m3["flings"] == 1, "mutant flat: 9 m/s across is still a fling")
	if m3["runs"] == 1:
		_check(absf(m3["punches"][0]["up_cm"]) < 0.01, "mutant flat: up_cm is 0 without the rise")
	# 4. who-blind: both boxers stamped who 0, the interleaved frames collapse and the two runs are lost.
	var a := _rows_for(300, 0, "pro_right_cross",
		_punch_path(13, CONTACT_Z, 1.50, -1.0, sail, 6, 3.0), [4], false)
	var b := _rows_for(300, 1, "pro_left_hook",
		_punch_path(13, CONTACT_Z, 1.50, 1.0, Vector3(-0.25, 0.10, 0.0), 6, 3.0), [4], true)
	var blind: Array = []
	for i in range(a.size()):
		var ra: Dictionary = a[i].duplicate()
		var rb: Dictionary = b[i].duplicate()
		ra["who"] = "0"
		rb["who"] = "0"
		blind.append(ra)
		blind.append(rb)
	var m4 := HookPast.analyse(blind)
	_check(m4["runs"] != 2 or m4["flings"] != 2, "mutant who-blind: the two-boxer assert fails")
	# 5. the hold removed: a punch that never landed is not in the number.
	var no_hold := _rows_for(100, 0, "pro_left_hook",
		_punch_path(13, CONTACT_Z, 1.50, -1.0, sail, 6, 3.0), [], false)
	var m5 := HookPast.analyse(no_hold)
	_check(m5["runs"] == 0, "mutant no hold: the landed-run assert fails")


func _test_empty() -> void:
	var res := HookPast.analyse([])
	_check(res["runs"] == 0, "empty: no runs")
	_check(res["flings"] == 0, "empty: no flings")
	_check(res["past_p50"] == 0.0, "empty: past_p50 0")
	_check(res["past_p90"] == 0.0, "empty: past_p90 0")
	_check(res["up_p90"] == 0.0, "empty: up_p90 0")
	_check(res["fling_p50"] == 0.0, "empty: fling_p50 0")
	_check(res["fling_p90"] == 0.0, "empty: fling_p90 0")
	_check(res["by_kind"].is_empty(), "empty: by_kind empty")
	_check(res["worst"].is_empty(), "empty: worst empty")


## A punch path in world metres: out to contact_z over frames 0-4 (15 cm/frame), held at contact until
## sail_i, one sail frame of `sail`, then home at home_mps back along the sail's line as far as the contact
## point (with no sail, straight back down the z axis - the hand came out along +z). side -1 = the right
## hand's guard x, +1 = the left's.
func _punch_path(n: int, contact_z: float, y: float, side: float, sail: Vector3, sail_i: int, home_mps: float) -> Array:
	var contact := Vector3(side * 0.15, y, contact_z)
	var dir := Vector3(0.0, 0.0, 1.0)
	if sail.length() > 0.0001:
		dir = sail.normalized()
	var step: float = home_mps / 30.0
	var out: Array = []
	for i in range(n):
		var p: Vector3
		if i < 4:
			p = Vector3(side * 0.15, y, contact_z - 0.15 * float(4 - i))
		elif i < sail_i:
			p = contact
		elif i == sail_i:
			p = contact + sail
		else:
			var back: float = step * float(i - sail_i)
			if sail.length() > 0.0001:
				back = minf(back, sail.length())
			p = contact + sail - dir * back
		out.append(p)
	return out


func _rows_for(start: int, who: int, clip: String, path: Array, holds: Array, left: bool) -> Array:
	var rows: Array = []
	for i in range(path.size()):
		var p: Vector3 = path[i]
		var lh := GUARD_L
		var rh := GUARD_R
		if left:
			lh = p
		else:
			rh = p
		rows.append(_row(start + i, who, clip, "1" if holds.has(i) else "0", lh, rh))
	return rows


func _row(frame: int, who: int, clip: String, hold: String, lh: Vector3, rh: Vector3) -> Dictionary:
	var d := {"frame": str(frame), "who": str(who), "clip": clip, "hold": hold}
	var bones := {"Head": HEAD, "Hips": HIPS, "UpperChest": UC, "LeftHand": lh, "RightHand": rh}
	for b in bones:
		var p: Vector3 = bones[b]
		d[b + "_x"] = str(p.x)
		d[b + "_y"] = str(p.y)
		d[b + "_z"] = str(p.z)
	return d


func _check(cond: bool, label: String) -> void:
	if cond:
		print("PASS ", label)
	else:
		failures += 1
		print("FAIL ", label)
