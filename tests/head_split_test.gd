extends SceneTree
## HEAD_SPLIT_TEST: fixtures for the ruler that splits a head jump into what moved it, and compares two films
## only over their shared part. Every fixture is built in code; values are Strings, as shown.csv writes them.
## Poses are four cumulative offsets in cm along +y (root, hips on root, trunk on hips, neck on chest), so the
## difference between two poses is exactly the four cm numbers the ruler reads - worked out by hand here.
## MUTANTS are wrong-way copies of the fixtures: each must break the assert the real fixture passes.

const HS := preload("res://scripts/rules/HeadSplit.gd")

var failures := 0


func _initialize() -> void:
	_test_trunk_and_neck_carry_it()
	_test_root_slid()
	_test_hips_trunk_neck_alone()
	_test_ten_cm_is_not_a_jump()
	_test_clip_change_and_inside()
	_test_frame_gap()
	_test_both_boxers_interleaved()
	_test_kinds_and_rates()
	_test_medians_and_worst()
	_test_worst_tie()
	_test_two_films_shared()
	_test_phase_in_the_punch()
	_test_phase_clip_change_and_boxers()
	_test_phase_none_and_no_hold()
	_test_mutants()
	_test_empty()
	print("HEAD_SPLIT_TEST failures=%d" % failures)
	quit(1 if failures > 0 else 0)


## The root stands still: the back bends 8 cm and the neck 7 cm, so the head travels 15 cm.
func _test_trunk_and_neck_carry_it() -> void:
	var rows := [_row(100, 0, "pro_idle", _pose(0, 0, 0, 0)), _row(101, 0, "pro_idle", _pose(0, 0, 8, 7))]
	var res := HS.analyse(rows)
	_check(int(res["jumps"]) == 1, "trunk+neck: one jump")
	var j := _one(res)
	if j.is_empty():
		return
	_near(j["head_cm"], 15.0, "trunk+neck: head 15 cm")
	_near(j["root_cm"], 0.0, "trunk+neck: root still")
	_near(j["hips_cm"], 0.0, "trunk+neck: hips still on the root")
	_near(j["trunk_cm"], 8.0, "trunk+neck: trunk 8")
	_near(j["neck_cm"], 7.0, "trunk+neck: neck 7")
	_check(str(j["kind"]) == "other", "trunk+neck: pro_idle is other")
	_check(str(j["cause"]) == "inside", "trunk+neck: same clip, inside")
	_check(int(j["who"]) == 0, "trunk+neck: who 0")
	_check(str(j["clip"]) == "pro_idle", "trunk+neck: row b's clip")
	_near(j["film_s"], 101.0 / 30.0, "trunk+neck: row b's film_s")
	_check(res["worst"].size() == 1, "trunk+neck: worst holds it")
	_near(res["worst"][0]["head_cm"], 15.0, "trunk+neck: worst head_cm")


## The whole man slides 15 cm (9 across, 12 deep - a 3-4-5 triangle): root_cm 15, the body segments unmoved.
func _test_root_slid() -> void:
	var base := _pose(0, 0, 0, 0)
	var rows := [_row(100, 0, "pro_idle", base),
		_row(101, 0, "pro_idle", _slide(base, Vector3(0.09, 0.0, 0.12)))]
	var res := HS.analyse(rows)
	_check(int(res["jumps"]) == 1, "root slide: one jump")
	var j := _one(res)
	if j.is_empty():
		return
	_near(j["head_cm"], 15.0, "root slide: head 15 cm")
	_near(j["root_cm"], 15.0, "root slide: root_cm 15, not 9 or 12")
	_near(j["hips_cm"], 0.0, "root slide: hips rode the root")
	_near(j["trunk_cm"], 0.0, "root slide: trunk ~0")
	_near(j["neck_cm"], 0.0, "root slide: neck ~0")


## Each segment alone carries the head 15 cm: hips on a still root, trunk on still hips, neck on a still chest.
func _test_hips_trunk_neck_alone() -> void:
	var cases := [{"pose": _pose(0, 15, 0, 0), "key": "hips_cm", "label": "hips"},
		{"pose": _pose(0, 0, 15, 0), "key": "trunk_cm", "label": "trunk"},
		{"pose": _pose(0, 0, 0, 15), "key": "neck_cm", "label": "neck"}]
	for c in cases:
		var rows := [_row(100, 0, "pro_idle", _pose(0, 0, 0, 0)), _row(101, 0, "pro_idle", c["pose"])]
		var res := HS.analyse(rows)
		_check(int(res["jumps"]) == 1, "%s alone: one jump" % c["label"])
		var j := _one(res)
		if j.is_empty():
			continue
		_near(j["head_cm"], 15.0, "%s alone: head 15" % c["label"])
		_near(j[c["key"]], 15.0, "%s alone: %s 15" % [c["label"], c["key"]])
		for k in ["root_cm", "hips_cm", "trunk_cm", "neck_cm"]:
			if k != str(c["key"]):
				_near(j[k], 0.0, "%s alone: %s still" % [c["label"], k])


## 10 cm in a frame is not a jump; 12.5 is. The gate is strictly over 12 cm (an exact 12.0 cm fixture would
## sit on the float rounding of 0.12 m, so the pair straddles the gate instead).
func _test_ten_cm_is_not_a_jump() -> void:
	var small := [_row(100, 0, "pro_idle", _pose(0, 0, 0, 0)), _row(101, 0, "pro_idle", _pose(0, 0, 6, 4))]
	var res := HS.analyse(small)
	_check(int(res["jumps"]) == 0, "10 cm: not a jump")
	_check(res["jump_list"].is_empty(), "10 cm: no jump rows")
	_check(res["worst"].is_empty(), "10 cm: worst empty")
	_check(res["root_p50"] == 0.0 and res["neck_p50"] == 0.0, "10 cm: medians 0")
	_check(int(res["starts"].get("other", 0)) == 0, "10 cm: no clip start")
	var under := [_row(100, 0, "pro_idle", _pose(0, 0, 0, 0)), _row(101, 0, "pro_idle", _pose(0, 0, 8, 3.5))]
	_check(int(HS.analyse(under)["jumps"]) == 0, "11.5 cm: under the gate")
	var over := [_row(100, 0, "pro_idle", _pose(0, 0, 0, 0)), _row(101, 0, "pro_idle", _pose(0, 0, 8, 4.5))]
	_check(int(HS.analyse(over)["jumps"]) == 1, "12.5 cm: over the gate")


## A jump on the frame the clip changes is cause change; the next frame inside the new clip is cause inside.
func _test_clip_change_and_inside() -> void:
	var rows := [_row(100, 0, "pro_idle", _pose(0, 0, 0, 0)),
		_row(101, 0, "pro_left_jab", _pose(0, 0, 8, 7)),
		_row(102, 0, "pro_left_jab", _pose(0, 0, 16, 14))]
	var res := HS.analyse(rows)
	_check(int(res["jumps"]) == 2, "change: two jumps")
	if int(res["jumps"]) != 2:
		return
	var first: Dictionary = res["jump_list"][0]
	var second: Dictionary = res["jump_list"][1]
	_check(str(first["cause"]) == "change", "change: the clip changed under it")
	_check(str(first["kind"]) == "punch", "change: row b's clip is the jab")
	_check(str(second["cause"]) == "inside", "change: the next frame is inside the jab")
	_check(int(res["starts"].get("punch", 0)) == 1, "change: one punch start")
	_near(res["per_punch"], 2.0, "change: two jumps on one punch clip")
	_check(res["per_react"] == 0.0, "change: no react start, per_react 0")


## Frames 10 -> 12 are not consecutive: a 30 cm move across the gap is never a jump. A clip change across
## the same gap IS still a clip start - starts do not need consecutive frames.
func _test_frame_gap() -> void:
	var same := [_row(10, 0, "pro_idle", _pose(0, 0, 0, 0)), _row(12, 0, "pro_idle", _pose(0, 0, 16, 14))]
	var res := HS.analyse(same)
	_check(int(res["jumps"]) == 0, "gap: 30 cm across a dropped frame is not a jump")
	_check(res["starts"].is_empty(), "gap: same clip, no start")
	var changed := [_row(10, 0, "pro_idle", _pose(0, 0, 0, 0)), _row(12, 0, "pro_left_jab", _pose(0, 0, 16, 14))]
	var res2 := HS.analyse(changed)
	_check(int(res2["jumps"]) == 0, "gap: still no jump when the clip changes")
	_check(int(res2["starts"].get("punch", 0)) == 1, "gap: the clip change is a start")


## Both boxers are interleaved per frame, and stand 3 m apart: pairing across boxers would read a 3 m jump.
## who 0 throws inside his jab (15 cm), who 1 is hit on the clip change (20 cm).
func _test_both_boxers_interleaved() -> void:
	var away := Vector3(3.0, 0.0, 0.0)
	var rows := [_row(100, 0, "pro_left_jab", _pose(0, 0, 0, 0)),
		_row(100, 1, "pro_idle", _slide(_pose(0, 0, 0, 0), away)),
		_row(101, 0, "pro_left_jab", _pose(0, 0, 8, 7)),
		_row(101, 1, "pro_hit_head_high", _slide(_pose(0, 0, 0, 20), away))]
	var res := HS.analyse(rows)
	_check(int(res["jumps"]) == 2, "two boxers: two jumps, one each")
	if int(res["jumps"]) != 2:
		return
	var by_who := {}
	for j in res["jump_list"]:
		by_who[int(j["who"])] = j
	_check(by_who.has(0) and by_who.has(1), "two boxers: both attributed")
	if not by_who.has(0) or not by_who.has(1):
		return
	_near(by_who[0]["head_cm"], 15.0, "two boxers: who 0 head 15")
	_near(by_who[1]["head_cm"], 20.0, "two boxers: who 1 head 20")
	_check(str(by_who[0]["kind"]) == "punch", "two boxers: who 0 punch")
	_check(str(by_who[1]["kind"]) == "react", "two boxers: who 1 react")
	_check(str(by_who[1]["cause"]) == "change", "two boxers: who 1 changed clip")
	_near(by_who[1]["root_cm"], 0.0, "two boxers: who 1 did not slide")
	_check(int(res["by_kind"].get("punch", 0)) == 1, "two boxers: by_kind punch 1")
	_check(int(res["by_kind"].get("react", 0)) == 1, "two boxers: by_kind react 1")
	_check(int(res["starts"].get("react", 0)) == 1, "two boxers: one react start")
	_check(res["per_punch"] == 0.0, "two boxers: no punch start, per_punch 0")
	_near(res["per_react"], 1.0, "two boxers: one jump on one reaction")
	_near(res["trunk_p50"], 4.0, "two boxers: trunk median of 8 and 0")
	_near(res["neck_p50"], 13.5, "two boxers: neck median of 7 and 20")
	_near(res["worst"][0]["head_cm"], 20.0, "two boxers: worst is who 1")
	_check(int(res["worst"][0]["who"]) == 1, "two boxers: worst names who 1")


## Fourteen clips, one 15 cm jump inside each: react wins over a punch word in the same clip name, and the
## rates are per clip start, not per film. A frame gap between clips keeps the return home out of the count.
func _test_kinds_and_rates() -> void:
	var clips := ["pro_hit_head_high", "react_body_gut", "mc_hit_liver", "pro_hit_jab_snap",
		"pro_left_jab", "pro_right_cross", "pro_left_hook", "pro_right_uppercut", "pro_body_shot",
		"pro_kidney_shot", "pro_idle", "pro_idle_fidget_v6", "pro_walk_ring", "mc_guard"]
	var rows: Array = []
	for k in range(clips.size()):
		rows.append(_row(100 + 3 * k, 0, clips[k], _pose(0, 0, 0, 0)))
		rows.append(_row(101 + 3 * k, 0, clips[k], _pose(0, 0, 8, 7)))
	var res := HS.analyse(rows)
	_check(int(res["jumps"]) == 14, "kinds: one jump per clip")
	_check(int(res["by_kind"].get("react", 0)) == 4, "kinds: 4 react (pro_hit, react_, mc_hit, pro_hit+jab)")
	_check(int(res["by_kind"].get("punch", 0)) == 6, "kinds: 6 punch (jab cross hook uppercut body kidney)")
	_check(int(res["by_kind"].get("other", 0)) == 4, "kinds: 4 other")
	_check(int(res["starts"].get("react", 0)) == 3, "kinds: 3 react starts (the first clip has no previous row)")
	_check(int(res["starts"].get("punch", 0)) == 6, "kinds: 6 punch starts")
	_check(int(res["starts"].get("other", 0)) == 4, "kinds: 4 other starts")
	_near(res["per_punch"], 1.0, "kinds: 6 jumps on 6 punch clips")
	_near(res["per_react"], 4.0 / 3.0, "kinds: 4 jumps on 3 reaction clips")
	_near(res["trunk_p50"], 8.0, "kinds: every jump trunk 8")
	_near(res["neck_p50"], 7.0, "kinds: every jump neck 7")
	var react_kinds := {}
	for j in res["jump_list"]:
		if str(j["clip"]) == "pro_hit_jab_snap":
			react_kinds[str(j["kind"])] = true
	_check(react_kinds.has("react"), "kinds: pro_hit_jab_snap is react, not punch")


## Six jumps of 13..18 cm with a different split each: the medians (even count = mean of the middle two) and
## the five biggest, worked out by hand. No clip ever changes, so both rates are 0.0 with jumps present.
func _test_medians_and_worst() -> void:
	var splits := [[0, 0, 8, 5], [2, 0, 8, 4], [0, 0, 8, 7], [4, 0, 8, 4], [0, 0, 10, 7], [6, 0, 8, 4]]
	var rows := [_row(200, 0, "pro_left_hook", _pose(0, 0, 0, 0))]
	var cum := [0.0, 0.0, 0.0, 0.0]
	for i in range(splits.size()):
		for k in range(4):
			cum[k] += float(splits[i][k])
		rows.append(_row(201 + i, 0, "pro_left_hook", _pose(cum[0], cum[1], cum[2], cum[3])))
	var res := HS.analyse(rows)
	_check(int(res["jumps"]) == 6, "medians: six jumps")
	_near(res["root_p50"], 1.0, "medians: root of 0,2,0,4,0,6 -> 1.0")
	_near(res["hips_p50"], 0.0, "medians: hips never moved")
	_near(res["trunk_p50"], 8.0, "medians: trunk 8,8,8,8,10,8 -> 8")
	_near(res["neck_p50"], 4.5, "medians: neck 5,4,7,4,7,4 -> 4.5")
	_check(res["per_punch"] == 0.0 and res["per_react"] == 0.0, "medians: no starts, both rates 0")
	var worst: Array = res["worst"]
	_check(worst.size() == 5, "medians: worst holds five of the six")
	if worst.size() != 5:
		return
	var want := [18.0, 17.0, 16.0, 15.0, 14.0]
	for i in range(want.size()):
		_near(worst[i]["head_cm"], want[i], "medians: worst %d head_cm" % i)
	_near(worst[0]["root_cm"], 6.0, "medians: the biggest jump was the root sliding 6")
	_near(worst[0]["neck_cm"], 4.0, "medians: the biggest jump neck 4")
	_near(worst[3]["trunk_cm"], 8.0, "medians: the 15 cm jump trunk 8")
	_near(worst[3]["neck_cm"], 7.0, "medians: the 15 cm jump neck 7")
	_check(int(worst[0]["who"]) == 0, "medians: worst carries who")
	_check(str(worst[0]["clip"]) == "pro_left_hook", "medians: worst carries the clip")
	_near(worst[0]["film_s"], 206.0 / 30.0, "medians: worst carries film_s")


## Equal head_cm on the same frame: the worst list breaks the tie by who, so it never reshuffles between runs.
func _test_worst_tie() -> void:
	var rows := [_row(50, 0, "pro_idle", _pose(0, 0, 0, 0)), _row(50, 1, "pro_idle", _pose(0, 0, 0, 0)),
		_row(51, 0, "pro_idle", _pose(0, 0, 8, 7)), _row(51, 1, "pro_idle", _pose(0, 0, 8, 7))]
	var res := HS.analyse(rows)
	_check(int(res["jumps"]) == 2, "tie: two equal jumps")
	if int(res["jumps"]) != 2:
		return
	_check(int(res["worst"][0]["who"]) == 0, "tie: who 0 first")
	_check(int(res["worst"][1]["who"]) == 1, "tie: who 1 second")


## Two films: five shared clip starts, then who 0 throws a hook in A and an uppercut in B at frame 41.
## Three jumps each (who 0 at 15 and 45, who 1 at 5), so the shared part holds two of them.
func _test_two_films_shared() -> void:
	var a := _film("pro_left_hook")
	var b := _film("pro_right_uppercut")
	_check(HS.shared_until(a, b) == 41, "shared: the sixth start's frame")
	_check(HS.shared_until(a, a) == 60, "shared: a film shares itself to its last frame")
	_check(HS.shared_until(b, a) == 41, "shared: the same frame either way round")
	var short := _film("pro_left_hook", 40)
	_check(HS.shared_until(a, short) == 40, "shared: a prefix gives the shorter film's last frame")
	_check(HS.shared_until(short, a) == 40, "shared: prefix either way round")
	var early := _film("pro_left_hook", 60, 9)
	_check(HS.shared_until(a, early) == 9, "shared: the earlier of two differing frames (9 vs 11)")
	var late := _film("pro_left_hook", 60, 13)
	_check(HS.shared_until(a, late) == 11, "shared: the earlier of two differing frames (11 vs 13)")
	var whole := HS.analyse(a)
	_check(int(whole["jumps"]) == 3, "shared: film A whole has three jumps")
	_check(int(whole["by_kind"].get("punch", 0)) == 2, "shared: whole punch jumps 2")
	_check(int(whole["by_kind"].get("other", 0)) == 1, "shared: whole other jumps 1")
	_check(int(whole["starts"].get("punch", 0)) == 3, "shared: whole punch starts 3")
	_check(int(whole["starts"].get("other", 0)) == 3, "shared: whole other starts 3")
	_check(int(whole["starts"].get("punch", 0)) + int(whole["starts"].get("other", 0)) == 6,
		"shared: six clip starts in film A (five shared, then the sixth)")
	_near(whole["per_punch"], 2.0 / 3.0, "shared: whole per_punch 2/3")
	var part := HS.analyse(a, 41)
	_check(int(part["jumps"]) == 2, "shared: only the jumps before frame 41")
	_check(int(part["by_kind"].get("punch", 0)) == 1, "shared: one punch jump before 41")
	_check(int(part["starts"].get("punch", 0)) == 2, "shared: two punch starts before 41")
	_check(int(part["starts"].get("other", 0)) == 3, "shared: three other starts before 41")
	_near(part["per_punch"], 0.5, "shared: one jump on two punch clips")
	var part_b := HS.analyse(b, 41)
	_check(int(part_b["jumps"]) == 2, "shared: film B's shared part matches A's")
	_near(part_b["per_punch"], 0.5, "shared: film B's shared rate matches")
	var frames: Array = []
	for j in part["jump_list"]:
		frames.append(int(j["frame"]))
	frames.sort()
	_check(frames.size() == 2 and int(frames[0]) == 5 and int(frames[1]) == 15,
		"shared: the counted jumps are frames 5 and 15")
	_check(int(HS.analyse(a, 5)["jumps"]) == 0, "shared: until is exclusive (frame 5 not counted)")
	_check(int(HS.analyse(a, 6)["jumps"]) == 1, "shared: frame 5 counted once until passes it")


## hold 0,0,1,1,0: pre / contact / post. 12 frames after contact is post, 13 and 15 late, a second 0 -> 1 restarts.
func _test_phase_in_the_punch() -> void:
	_phase_case(_hold_run(100, 104, "pro_left_jab", "00110", [101, 102, 103, 104]),
		[[-1, "pre"], [0, "contact"], [1, "post"], [2, "post"]], [1, 1, 2, 0, 0], 1.5, "hold 00110")
	_phase_case(_hold_run(100, 116, "pro_left_jab", "01", [113, 114, 116]),
		[[12, "post"], [13, "late"], [15, "late"]], [0, 0, 1, 2, 0], 12.0, "12/13/15 after contact")
	_phase_case(_hold_run(100, 103, "pro_left_jab", "0101", [101, 102, 103]),
		[[0, "contact"], [1, "post"], [0, "contact"]], [0, 2, 1, 0, 0], 1.0, "a second contact")


## The clip change resets since_contact to -1; a contact ON the change frame is the new clip's. Only who 0 lands.
func _test_phase_clip_change_and_boxers() -> void:
	var rows := [_hrow(100, 0, "pro_left_jab", 0.0, "0"), _hrow(101, 0, "pro_left_jab", 15.0, "1"),
		_hrow(102, 0, "pro_left_jab", 30.0, "1"), _hrow(103, 0, "pro_right_cross", 45.0, "0"),
		_hrow(104, 0, "pro_right_cross", 60.0, "0")]
	_phase_case(rows, [[0, "contact"], [1, "post"], [-1, "pre"], [-1, "pre"]], [2, 1, 1, 0, 0], 1.0, "clip change")
	var on_change := rows.duplicate(true)
	on_change[2]["hold"] = "0"
	on_change[3]["hold"] = "1"
	_phase_case(on_change, [[0, "contact"], [1, "post"], [0, "contact"], [1, "post"]], [0, 2, 2, 0, 0], 1.0,
		"contact on the change frame")
	var blind := rows.duplicate(true)
	for r in blind:
		r["clip"] = "pro_left_jab"
	_check(str(HS.analyse(blind)["jump_list"][2]["phase"]) == "post", "mutant clip-blind: the reset assert fails")
	var interleaved: Array = []
	for i in range(3):
		interleaved.append(_hrow(100 + i, 0, "pro_left_jab", 15.0 * i, "0" if i == 0 else "1"))
		interleaved.append(_hrow(100 + i, 1, "pro_right_cross", 15.0 * i, "0"))
	var res := _phase_case(interleaved, [[0, "contact"], [1, "post"], [-1, "pre"], [-1, "pre"]],
		[2, 1, 1, 0, 0], 1.0, "two boxers")
	_check(int(res["jump_list"][2]["who"]) == 1, "two boxers: the pre jumps are who 1's")


## A react or idle jump is none on its own contact frame; no hold column (hold-blind): all pre, no error; empty: 0s.
func _test_phase_none_and_no_hold() -> void:
	_phase_case(_hold_run(100, 102, "pro_hit_head_high", "01", [101, 102]),
		[[0, "none"], [1, "none"]], [0, 0, 0, 0, 2], 0.0, "react")
	_phase_case(_hold_run(100, 101, "pro_idle", "01", [101]), [[0, "none"]], [0, 0, 0, 0, 1], 0.0, "idle")
	_phase_case([_row(100, 0, "pro_left_jab", _pose(0, 0, 0, 0)), _row(101, 0, "pro_left_jab", _pose(0, 0, 15, 0)),
		_row(102, 0, "pro_hit_head_high", _pose(0, 0, 30, 0))],
		[[-1, "pre"], [-1, "none"]], [1, 0, 0, 0, 1], 0.0, "no hold column")
	_phase_case([], [], [0, 0, 0, 0, 0], 0.0, "empty")


## MUTANTS: wrong-way copies. Each must break the assert the real fixture passes.
func _test_mutants() -> void:
	# 1. who-blind: the interleaved boxers stamped who 0 - the pairs cross boxers and the two jumps are lost.
	var away := Vector3(3.0, 0.0, 0.0)
	var blind: Array = []
	for r in [_row(100, 0, "pro_left_jab", _pose(0, 0, 0, 0)),
			_row(100, 1, "pro_idle", _slide(_pose(0, 0, 0, 0), away)),
			_row(101, 0, "pro_left_jab", _pose(0, 0, 8, 7)),
			_row(101, 1, "pro_hit_head_high", _slide(_pose(0, 0, 0, 20), away))]:
		var c: Dictionary = r.duplicate()
		c["who"] = "0"
		blind.append(c)
	var m1 := HS.analyse(blind)
	_check(int(m1["jumps"]) != 2, "mutant who-blind: the two-boxer assert fails")
	# 2. gap-blind: the dropped frame filled in - the same 30 cm move now reads as a jump.
	var closed := [_row(10, 0, "pro_idle", _pose(0, 0, 0, 0)), _row(11, 0, "pro_idle", _pose(0, 0, 16, 14))]
	_check(int(HS.analyse(closed)["jumps"]) == 1, "mutant gap-blind: the gap assert fails")
	# 3. root-blind: the slide taken away - the head stands still and root_cm 15 is gone.
	var still := [_row(100, 0, "pro_idle", _pose(0, 0, 0, 0)), _row(101, 0, "pro_idle", _pose(0, 0, 0, 0))]
	var m3 := HS.analyse(still)
	_check(int(m3["jumps"]) == 0, "mutant root-blind: the root-slide assert fails")
	# 4. neck-blind: the 7 cm neck taken off the 8 cm trunk - 8 cm is under the gate.
	var no_neck := [_row(100, 0, "pro_idle", _pose(0, 0, 0, 0)), _row(101, 0, "pro_idle", _pose(0, 0, 8, 0))]
	_check(int(HS.analyse(no_neck)["jumps"]) == 0, "mutant neck-blind: the trunk+neck assert fails")
	# 5. prefix-blind: the reaction prefix dropped, so the same clip name reads punch by its jab word.
	var no_prefix := [_row(100, 0, "pro_idle", _pose(0, 0, 0, 0)),
		_row(101, 0, "hit_jab_snap", _pose(0, 0, 8, 7))]
	var m5 := HS.analyse(no_prefix)
	_check(int(m5["jumps"]) == 1, "mutant prefix-blind: still a jump")
	if int(m5["jumps"]) == 1:
		_check(str(m5["jump_list"][0]["kind"]) == "punch", "mutant prefix-blind: the react assert fails")
	# 6. until-blind: film B given A's sixth clip - the films no longer part at 41.
	var same_film := _film("pro_left_hook")
	_check(HS.shared_until(_film("pro_left_hook"), same_film) == 60, "mutant until-blind: the 41 assert fails")


func _test_empty() -> void:
	var res := HS.analyse([])
	_check(int(res["jumps"]) == 0, "empty: no jumps")
	_check(res["jump_list"].is_empty(), "empty: no jump rows")
	_check(res["by_kind"].is_empty(), "empty: by_kind empty")
	_check(res["starts"].is_empty(), "empty: starts empty")
	_check(res["per_punch"] == 0.0, "empty: per_punch 0")
	_check(res["per_react"] == 0.0, "empty: per_react 0")
	_check(res["root_p50"] == 0.0 and res["hips_p50"] == 0.0, "empty: root and hips medians 0")
	_check(res["trunk_p50"] == 0.0 and res["neck_p50"] == 0.0, "empty: trunk and neck medians 0")
	_check(res["worst"].is_empty(), "empty: worst empty")
	_check(HS.shared_until([], []) == 0, "empty: two empty films share nothing")
	_check(HS.shared_until(_film("pro_left_hook"), []) == 0, "empty: an empty film's last frame is 0")
	_check(int(HS.analyse([], 41)["jumps"]) == 0, "empty: an until on no rows is still no jumps")


## A pose from four cumulative offsets in cm along +y: the root's height, the hips on the root, the trunk on
## the hips, the neck on the chest. Base lengths: hips 100 cm above the root, chest 40 above the hips, head
## 40 above the chest - so a difference between two poses is exactly the four cm numbers the ruler reads.
func _pose(root_cm: float, hips_cm: float, trunk_cm: float, neck_cm: float) -> Dictionary:
	var node := Vector3(0.0, root_cm / 100.0, 0.0)
	var hips := node + Vector3(0.0, (100.0 + hips_cm) / 100.0, 0.0)
	var uc := hips + Vector3(0.0, (40.0 + trunk_cm) / 100.0, 0.0)
	var head := uc + Vector3(0.0, (40.0 + neck_cm) / 100.0, 0.0)
	return {"node": node, "Hips": hips, "UpperChest": uc, "Head": head}


func _slide(pose: Dictionary, v: Vector3) -> Dictionary:
	var out := {}
	for b in pose:
		var p: Vector3 = pose[b]
		out[b] = p + v
	return out


func _row(frame: int, who: int, clip: String, pose: Dictionary) -> Dictionary:
	var d := {"frame": str(frame), "who": str(who), "clip": clip, "clip_t": "0.033",
		"film_s": "%.3f" % (float(frame) / 30.0)}
	for b in pose:
		var p: Vector3 = pose[b]
		d[b + "_x"] = str(p.x)
		d[b + "_y"] = str(p.y)
		d[b + "_z"] = str(p.z)
	return d


## A row with a hold column, its head trunk_cm above the base pose: a 15 cm step is a jump the trunk carried.
func _hrow(frame: int, who: int, clip: String, trunk_cm: float, hold: String) -> Dictionary:
	var d := _row(frame, who, clip, _pose(0, 0, trunk_cm, 0))
	d["hold"] = hold
	return d


## One boxer's frames from..to in one clip: holds one character per frame (the last repeats), 15 cm steps at jump_at.
func _hold_run(from: int, to: int, clip: String, holds: String, jump_at: Array, who: int = 0) -> Array:
	var rows: Array = []
	var trunk := 0.0
	for f in range(from, to + 1):
		if jump_at.has(f):
			trunk += 15.0
		rows.append(_hrow(f, who, clip, trunk, holds.substr(mini(f - from, holds.length() - 1), 1)))
	return rows


## One phase fixture: every jump's (since_contact, phase) against want, the five by_phase counts, post_p50.
func _phase_case(rows: Array, want: Array, counts: Array, p50: float, label: String) -> Dictionary:
	var res := HS.analyse(rows)
	var bp: Dictionary = res["by_phase"]
	_check(int(res["jumps"]) == want.size(), "%s: %d jumps" % [label, want.size()])
	_check([bp["pre"], bp["contact"], bp["post"], bp["late"], bp["none"]] == counts, "%s: by_phase %s" % [label, counts])
	_near(res["post_p50_frames"], p50, "%s: post_p50" % label)
	for i in range(mini(want.size(), res["jump_list"].size())):
		var j: Dictionary = res["jump_list"][i]
		_check(int(j["since_contact"]) == want[i][0] and str(j["phase"]) == want[i][1],
			"%s: jump %d since %d phase %s" % [label, i, want[i][0], want[i][1]])
	return res


## The two films of the shared-part fixture: who 0 idles, jabs (11), idles (21), crosses (31) and throws
## last_clip (41); who 1 idles and fidgets from fidget_from to 30. who 0's head jumps 15 cm at frames 15 and
## 45, who 1's at frame 5. Both boxers' rows are interleaved per frame, as shown.csv writes them.
func _film(last_clip: String, n_frames: int = 60, fidget_from: int = 11) -> Array:
	var rows: Array = []
	for f in range(1, n_frames + 1):
		var clip0 := "pro_idle"
		if f >= 41:
			clip0 = last_clip
		elif f >= 31:
			clip0 = "pro_right_cross"
		elif f >= 11 and f <= 20:
			clip0 = "pro_left_jab"
		var p0 := _pose(0, 0, 0, 0)
		if f >= 45:
			p0 = _pose(0, 0, 16, 14)
		elif f >= 15:
			p0 = _pose(0, 0, 8, 7)
		rows.append(_row(f, 0, clip0, p0))
		var clip1 := "pro_idle"
		if f >= fidget_from and f <= 30:
			clip1 = "pro_idle_fidget_v2"
		var p1 := _pose(0, 0, 0, 0)
		if f >= 5:
			p1 = _pose(0, 0, 8, 7)
		rows.append(_row(f, 1, clip1, _slide(p1, Vector3(3.0, 0.0, 0.0))))
	return rows


func _one(res: Dictionary) -> Dictionary:
	if int(res["jumps"]) != 1:
		return {}
	var j: Dictionary = res["jump_list"][0]
	return j


func _near(got: float, want: float, label: String) -> void:
	_check(absf(got - want) < 0.01, "%s (%.4f ~ %.4f)" % [label, got, want])


func _check(cond: bool, label: String) -> void:
	if cond:
		print("PASS ", label)
	else:
		failures += 1
		print("FAIL ", label)
