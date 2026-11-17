extends SceneTree
## HEAD_SPLIT_TEST: fixtures for the ruler that splits a head jump into what moved it, and compares two films
## only over their shared part. Every fixture is built in code; values are Strings, as shown.csv writes them.
## Poses are four cumulative offsets in cm along +y (root, hips on root, trunk on hips, neck on chest), so the
## difference between two poses is exactly the four cm numbers the ruler reads - worked out by hand here.
## MUTANTS are wrong-way copies of the fixtures: each must break the assert the real fixture passes.
## S509: combo - a pre jump 1..POST_FRAMES after her last landed hit is the next punch of a combo, so the clip
## change no longer hides that hit; her own reaction hold rows never count as one.

const HS := preload("res://scripts/rules/HeadSplit.gd")
const CM_KEYS := ["head_cm", "root_cm", "hips_cm", "trunk_cm", "neck_cm"]

var failures := 0


func _initialize() -> void:
	_test_splits()
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
	_test_combo_after_a_landed_hit()
	_test_combo_needs_her_own_hit()
	_test_mutants()
	_test_empty()
	print("HEAD_SPLIT_TEST failures=%d" % failures)
	quit(1 if failures > 0 else 0)


## The four offsets, each read against its own parent, so a root slide is not blamed on the neck: one 15 cm
## head jump carried by a different part each time (the root's 9 across + 12 deep is a 3-4-5 triangle).
## want is [head, root, hips, trunk, neck] in cm, worked out by hand. The trunk+neck jump also carries the
## identity keys and the place in worst.
func _test_splits() -> void:
	var cases := [
		["trunk+neck", _pose(0, 0, 8, 7), [15.0, 0.0, 0.0, 8.0, 7.0]],
		["root slide", _slide(_pose(0, 0, 0, 0), Vector3(0.09, 0.0, 0.12)), [15.0, 15.0, 0.0, 0.0, 0.0]],
		["hips alone", _pose(0, 15, 0, 0), [15.0, 0.0, 15.0, 0.0, 0.0]],
		["trunk alone", _pose(0, 0, 15, 0), [15.0, 0.0, 0.0, 15.0, 0.0]],
		["neck alone", _pose(0, 0, 0, 15), [15.0, 0.0, 0.0, 0.0, 15.0]],
	]
	for c in cases:
		_split_case([_still(100, "pro_idle"), _row(101, 0, "pro_idle", c[1])], c[2], str(c[0]))
	var res := HS.analyse([_still(100, "pro_idle"), _bend(101, "pro_idle", 8, 7)])
	var j := _one(res)
	if j.is_empty():
		return
	_want(j, {"kind": "other", "cause": "inside", "who": 0, "clip": "pro_idle"}, "trunk+neck")
	_near(j["film_s"], 101.0 / 30.0, "trunk+neck: row b's film_s")
	_check(res["worst"].size() == 1, "trunk+neck: worst holds it")
	_near(res["worst"][0]["head_cm"], 15.0, "trunk+neck: worst head_cm")


## 10 cm in a frame is not a jump; 12.5 is. The gate is strictly over 12 cm (an exact 12.0 cm fixture would
## sit on the float rounding of 0.12 m, so the pair straddles the gate instead).
func _test_ten_cm_is_not_a_jump() -> void:
	var res := HS.analyse([_still(100, "pro_idle"), _bend(101, "pro_idle", 6, 4)])
	_check(int(res["jumps"]) == 0, "10 cm: not a jump")
	_check(res["jump_list"].is_empty() and res["worst"].is_empty(), "10 cm: no jump rows, worst empty")
	_check(res["root_p50"] == 0.0 and res["neck_p50"] == 0.0, "10 cm: medians 0")
	_check(int(res["starts"].get("other", 0)) == 0, "10 cm: no clip start")
	var under := HS.analyse([_still(100, "pro_idle"), _bend(101, "pro_idle", 8, 3.5)])
	_check(int(under["jumps"]) == 0, "11.5 cm: under the gate")
	var over := HS.analyse([_still(100, "pro_idle"), _bend(101, "pro_idle", 8, 4.5)])
	_check(int(over["jumps"]) == 1, "12.5 cm: over the gate")


## A jump on the frame the clip changes is cause change; the next frame inside the new clip is cause inside.
func _test_clip_change_and_inside() -> void:
	var rows := [_still(100, "pro_idle"), _bend(101, "pro_left_jab", 8, 7), _bend(102, "pro_left_jab", 16, 14)]
	var res := HS.analyse(rows)
	_check(int(res["jumps"]) == 2, "change: two jumps")
	if int(res["jumps"]) != 2:
		return
	_want(res["jump_list"][0], {"cause": "change", "kind": "punch"}, "change: row b's clip is the jab")
	_check(str(res["jump_list"][1]["cause"]) == "inside", "change: the next frame is inside the jab")
	_want(res["starts"], {"punch": 1}, "change: one punch start")
	_near(res["per_punch"], 2.0, "change: two jumps on one punch clip")
	_check(res["per_react"] == 0.0, "change: no react start, per_react 0")


## Frames 10 -> 12 are not consecutive: a 30 cm move across the gap is never a jump. A clip change across
## the same gap IS still a clip start - starts do not need consecutive frames.
func _test_frame_gap() -> void:
	var res := HS.analyse([_still(10, "pro_idle"), _bend(12, "pro_idle", 16, 14)])
	_check(int(res["jumps"]) == 0 and res["starts"].is_empty(), "gap: 30 cm over a dropped frame is no jump, no start")
	var res2 := HS.analyse([_still(10, "pro_idle"), _bend(12, "pro_left_jab", 16, 14)])
	_check(int(res2["jumps"]) == 0, "gap: still no jump when the clip changes")
	_check(int(res2["starts"].get("punch", 0)) == 1, "gap: the clip change is a start")


## Both boxers are interleaved per frame, and stand 3 m apart: pairing across boxers would read a 3 m jump.
## who 0 throws inside his jab (15 cm), who 1 is hit on the clip change (20 cm).
func _test_both_boxers_interleaved() -> void:
	var rows := [_still(100, "pro_left_jab"), _far(100, "pro_idle"),
		_bend(101, "pro_left_jab", 8, 7), _far(101, "pro_hit_head_high", 0.0, 20.0)]
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
	_want(by_who[0], {"kind": "punch"}, "two boxers: who 0")
	_want(by_who[1], {"kind": "react", "cause": "change"}, "two boxers: who 1")
	_near(by_who[1]["root_cm"], 0.0, "two boxers: who 1 did not slide")
	_want(res["by_kind"], {"punch": 1, "react": 1}, "two boxers: by_kind")
	_want(res["starts"], {"react": 1}, "two boxers: one react start")
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
		rows.append(_still(100 + 3 * k, clips[k]))
		rows.append(_bend(101 + 3 * k, clips[k], 8, 7))
	var res := HS.analyse(rows)
	_check(int(res["jumps"]) == 14, "kinds: one jump per clip")
	_want(res["by_kind"], {"react": 4, "punch": 6, "other": 4}, "kinds: pro_hit/react_/mc_hit, six punch words, four other")
	_want(res["starts"], {"react": 3, "punch": 6, "other": 4}, "kinds: starts (the first clip has no previous row)")
	_near(res["per_punch"], 1.0, "kinds: 6 jumps on 6 punch clips")
	_near(res["per_react"], 4.0 / 3.0, "kinds: 4 jumps on 3 reaction clips")
	_near(res["trunk_p50"], 8.0, "kinds: every jump trunk 8")
	_near(res["neck_p50"], 7.0, "kinds: every jump neck 7")
	var snap: Array = res["jump_list"].filter(func(j): return str(j["clip"]) == "pro_hit_jab_snap")
	_check(snap.size() == 1 and str(snap[0]["kind"]) == "react", "kinds: pro_hit_jab_snap is react, not punch")


## Six jumps of 13..18 cm with a different split each: the medians (even count = mean of the middle two) and
## the five biggest, worked out by hand. No clip ever changes, so both rates are 0.0 with jumps present.
func _test_medians_and_worst() -> void:
	var splits := [[0, 0, 8, 5], [2, 0, 8, 4], [0, 0, 8, 7], [4, 0, 8, 4], [0, 0, 10, 7], [6, 0, 8, 4]]
	var rows := [_still(200, "pro_left_hook")]
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
	_want(worst[0], {"who": 0, "clip": "pro_left_hook"}, "medians: worst carries")
	_near(worst[0]["film_s"], 206.0 / 30.0, "medians: worst carries film_s")


## Equal head_cm on the same frame: the worst list breaks the tie by who, so it never reshuffles between runs.
func _test_worst_tie() -> void:
	var rows := [_still(50, "pro_idle"), _still(50, "pro_idle", 1),
		_bend(51, "pro_idle", 8, 7), _bend(51, "pro_idle", 8, 7, 1)]
	var res := HS.analyse(rows)
	_check(int(res["jumps"]) == 2, "tie: two equal jumps")
	if int(res["jumps"]) != 2:
		return
	_check(int(res["worst"][0]["who"]) == 0 and int(res["worst"][1]["who"]) == 1, "tie: who 0 first, who 1 second")


## Two films: five shared clip starts, then who 0 throws a hook in A and an uppercut in B at frame 41.
## Three jumps each (who 0 at 15 and 45, who 1 at 5), so the shared part holds two of them.
func _test_two_films_shared() -> void:
	var a := _film("pro_left_hook")
	var b := _film("pro_right_uppercut")
	var short := _film("pro_left_hook", 40)
	var early := _film("pro_left_hook", 60, 9)
	var late := _film("pro_left_hook", 60, 13)
	for p in [[a, b, 41, "the sixth start's frame"], [a, a, 60, "a film shares itself to its last frame"],
			[b, a, 41, "the same frame either way round"], [a, short, 40, "a prefix gives the shorter last frame"],
			[short, a, 40, "prefix either way round"], [a, early, 9, "the earlier of two differing frames (9 vs 11)"],
			[a, late, 11, "the earlier of two differing frames (11 vs 13)"]]:
		_check(HS.shared_until(p[0], p[1]) == p[2], "shared: %s" % p[3])
	var whole := HS.analyse(a)
	_check(int(whole["jumps"]) == 3, "shared: film A whole has three jumps")
	_want(whole["by_kind"], {"punch": 2, "other": 1}, "shared: whole jumps")
	_want(whole["starts"], {"punch": 3, "other": 3}, "shared: whole starts")
	_check(int(whole["starts"].get("punch", 0)) + int(whole["starts"].get("other", 0)) == 6,
		"shared: six clip starts in film A (five shared, then the sixth)")
	_near(whole["per_punch"], 2.0 / 3.0, "shared: whole per_punch 2/3")
	var part := HS.analyse(a, 41)
	_check(int(part["jumps"]) == 2, "shared: only the jumps before frame 41")
	_want(part["by_kind"], {"punch": 1}, "shared: one punch jump before 41")
	_want(part["starts"], {"punch": 2, "other": 3}, "shared: starts before 41")
	_near(part["per_punch"], 0.5, "shared: one jump on two punch clips")
	var part_b := HS.analyse(b, 41)
	_check(int(part_b["jumps"]) == 2, "shared: film B's shared part matches A's")
	_near(part_b["per_punch"], 0.5, "shared: film B's shared rate matches")
	var frames: Array = part["jump_list"].map(func(j): return int(j["frame"]))
	frames.sort()
	_check(frames == [5, 15], "shared: the counted jumps are frames 5 and 15")
	_check(int(HS.analyse(a, 5)["jumps"]) == 0, "shared: until is exclusive (frame 5 not counted)")
	_check(int(HS.analyse(a, 6)["jumps"]) == 1, "shared: frame 5 counted once until passes it")


## hold 0,0,1,1,0: pre / contact / post. 12 frames after contact is post, 13 and 15 late, a second 0 -> 1 restarts.
func _test_phase_in_the_punch() -> void:
	_phase_case(_hold_run(100, 104, "pro_left_jab", "00110", [101, 102, 103, 104]),
		[[-1, "pre"], [0, "contact"], [1, "post"], [2, "post"]], [1, 0, 1, 2, 0, 0], 1.5, "hold 00110")
	_phase_case(_hold_run(100, 116, "pro_left_jab", "01", [113, 114, 116]),
		[[12, "post"], [13, "late"], [15, "late"]], [0, 0, 0, 1, 2, 0], 12.0, "12/13/15 after contact")
	_phase_case(_hold_run(100, 103, "pro_left_jab", "0101", [101, 102, 103]),
		[[0, "contact"], [1, "post"], [0, "contact"]], [0, 0, 2, 1, 0, 0], 1.0, "a second contact")


## The clip change resets since_contact to -1, but NOT since_prev_hit: the cross 2 frames after the jab's
## contact is combo (S509 - it was pre). A contact ON the change frame is the new clip's. Only who 0 lands.
func _test_phase_clip_change_and_boxers() -> void:
	var rows := [_hrow(100, 0, "pro_left_jab", 0.0, "0"), _hrow(101, 0, "pro_left_jab", 15.0, "1"),
		_hrow(102, 0, "pro_left_jab", 30.0, "1"), _hrow(103, 0, "pro_right_cross", 45.0, "0"),
		_hrow(104, 0, "pro_right_cross", 60.0, "0")]
	_phase_case(rows, [[0, "contact"], [1, "post"], [-1, "combo"], [-1, "combo"]], [0, 2, 1, 1, 0, 0], 1.0,
		"clip change", [0, 1, 2, 3])
	var on_change := rows.duplicate(true)
	on_change[2]["hold"] = "0"
	on_change[3]["hold"] = "1"
	_phase_case(on_change, [[0, "contact"], [1, "post"], [0, "contact"], [1, "post"]], [0, 0, 2, 2, 0, 0], 1.0,
		"contact on the change frame", [0, 1, 0, 1])
	var blind := rows.duplicate(true)
	for r in blind:
		r["clip"] = "pro_left_jab"
	_check(str(HS.analyse(blind)["jump_list"][2]["phase"]) == "post", "mutant clip-blind: the reset assert fails")
	var interleaved: Array = []
	for i in range(3):
		interleaved.append(_hrow(100 + i, 0, "pro_left_jab", 15.0 * i, "0" if i == 0 else "1"))
		interleaved.append(_hrow(100 + i, 1, "pro_right_cross", 15.0 * i, "0"))
	var res := _phase_case(interleaved, [[0, "contact"], [1, "post"], [-1, "pre"], [-1, "pre"]],
		[2, 0, 1, 1, 0, 0], 1.0, "two boxers", [0, 1, -1, -1])
	_check(int(res["jump_list"][2]["who"]) == 1, "two boxers: the pre jumps are who 1's")


## A react or idle jump is none on its own contact frame; no hold column (hold-blind): all pre, no error; empty: 0s.
func _test_phase_none_and_no_hold() -> void:
	_phase_case(_hold_run(100, 102, "pro_hit_head_high", "01", [101, 102]),
		[[0, "none"], [1, "none"]], [0, 0, 0, 0, 0, 2], 0.0, "react", [-1, -1])
	_phase_case(_hold_run(100, 101, "pro_idle", "01", [101]), [[0, "none"]], [0, 0, 0, 0, 0, 1], 0.0, "idle", [-1])
	_phase_case([_still(100, "pro_left_jab"), _bend(101, "pro_left_jab", 15), _bend(102, "pro_hit_head_high", 30)],
		[[-1, "pre"], [-1, "none"]], [1, 0, 0, 0, 0, 1], 0.0, "no hold column", [-1, -1])
	_phase_case([], [], [0, 0, 0, 0, 0, 0], 0.0, "empty")


## S509: the hook lands at f378 and its clip cuts; the cross's jump 2 frames later is combo, not pre - the pop
## is the second punch coming off the first hit (who 1 f380 pro_right_cross_c on s506a). 15 frames later: pre.
func _test_combo_after_a_landed_hit() -> void:
	var hook := _hold_run(376, 378, "pro_right_hook", "001", [378])
	var near := hook + _hold_run(379, 382, "pro_right_cross_c", "0", [380], 0, 15.0)
	var res := _phase_case(near, [[0, "contact"], [-1, "combo"]], [0, 1, 1, 0, 0, 0], 0.0,
		"combo 2 frames after the hook", [0, 2])
	if int(res["jumps"]) == 2:
		_want(res["jump_list"][1], {"clip": "pro_right_cross_c", "cause": "inside", "kind": "punch"}, "combo: the next clip")
	var far := hook + _hold_run(379, 393, "pro_right_cross_c", "0", [393], 0, 15.0)
	_phase_case(far, [[0, "contact"], [-1, "pre"]], [1, 0, 1, 0, 0, 0], 0.0, "15 frames after the hook", [0, 15])
	for gap in [1, HS.POST_FRAMES, HS.POST_FRAMES + 1]:
		var g: int = gap
		var word := "combo" if g <= HS.POST_FRAMES else "pre"
		var counts := [0, 1, 1, 0, 0, 0] if word == "combo" else [1, 0, 1, 0, 0, 0]
		_phase_case(hook + _hold_run(379, 378 + g, "pro_right_cross_c", "0", [378 + g], 0, 15.0),
			[[0, "contact"], [-1, word]], counts, 0.0, "combo window %d frames" % g, [0, g])


## A contact start on her OWN reaction rows (she is being hit) never dates her next punch, nor does an idle's.
## Two boxers interleaved: only the one who landed reads combo, the other stays pre on the same frames.
func _test_combo_needs_her_own_hit() -> void:
	for clip in ["pro_hit_head_high", "pro_idle"]:
		var rows := _hold_run(100, 102, clip, "01", [101, 102]) + _hold_run(103, 105, "pro_left_jab", "0", [104], 0, 30.0)
		_phase_case(rows, [[0, "none"], [1, "none"], [-1, "pre"]], [1, 0, 0, 0, 0, 2], 0.0,
			"%s contact never counts" % clip, [-1, -1, -1])
	var inter: Array = []
	for i in range(4):
		var f := 100 + i
		inter.append(_hrow(f, 0, "pro_right_hook" if f <= 101 else "pro_right_cross_c", 15.0 * i, "1" if f == 101 else "0"))
		inter.append(_hrow(f, 1, "pro_right_cross_c", 15.0 * i, "0"))
	var res := _phase_case(inter,
		[[0, "contact"], [-1, "combo"], [-1, "combo"], [-1, "pre"], [-1, "pre"], [-1, "pre"]],
		[3, 2, 1, 0, 0, 0], 0.0, "two boxers, one landed", [0, 1, 2, -1, -1, -1])
	if int(res["jumps"]) == 6:
		_check(int(res["jump_list"][1]["who"]) == 0 and int(res["jump_list"][3]["who"]) == 1,
			"two boxers: the combo jumps are who 0's, the pre jumps who 1's")


## MUTANTS: wrong-way copies. Each must break the assert the real fixture passes.
func _test_mutants() -> void:
	# 1. who-blind: the interleaved boxers stamped who 0 - the pairs cross boxers and the two jumps are lost.
	var blind: Array = []
	for r in [_still(100, "pro_left_jab"), _far(100, "pro_idle"),
			_bend(101, "pro_left_jab", 8, 7), _far(101, "pro_hit_head_high", 0.0, 20.0)]:
		var c: Dictionary = r.duplicate()
		c["who"] = "0"
		blind.append(c)
	_check(int(HS.analyse(blind)["jumps"]) != 2, "mutant who-blind: the two-boxer assert fails")
	# 2. gap-blind: the dropped frame filled in - the same 30 cm move now reads as a jump.
	var closed := [_still(10, "pro_idle"), _bend(11, "pro_idle", 16, 14)]
	_check(int(HS.analyse(closed)["jumps"]) == 1, "mutant gap-blind: the gap assert fails")
	# 3. root-blind: the slide taken away - the head stands still and root_cm 15 is gone.
	var m3 := HS.analyse([_still(100, "pro_idle"), _still(101, "pro_idle")])
	_check(int(m3["jumps"]) == 0, "mutant root-blind: the root-slide assert fails")
	# 4. neck-blind: the 7 cm neck taken off the 8 cm trunk - 8 cm is under the gate.
	var no_neck := [_still(100, "pro_idle"), _bend(101, "pro_idle", 8)]
	_check(int(HS.analyse(no_neck)["jumps"]) == 0, "mutant neck-blind: the trunk+neck assert fails")
	# 5. prefix-blind: the reaction prefix dropped, so the same clip name reads punch by its jab word.
	var m5 := HS.analyse([_still(100, "pro_idle"), _bend(101, "hit_jab_snap", 8, 7)])
	_check(int(m5["jumps"]) == 1, "mutant prefix-blind: still a jump")
	if int(m5["jumps"]) == 1:
		_check(str(m5["jump_list"][0]["kind"]) == "punch", "mutant prefix-blind: the react assert fails")
	# 6. until-blind: film B given A's sixth clip - the films no longer part at 41.
	_check(HS.shared_until(_film("pro_left_hook"), _film("pro_left_hook")) == 60, "mutant until-blind: the 41 assert fails")
	# 7. hit-blind: the hook's hold never rises (a whiff) - the cross jump 2 frames later is pre, not combo.
	var whiff := _hold_run(376, 378, "pro_right_hook", "0", [378]) + _hold_run(379, 382, "pro_right_cross_c", "0", [380], 0, 15.0)
	var m7 := HS.analyse(whiff)
	_check(int(m7["jumps"]) == 2 and str(m7["jump_list"][1]["phase"]) == "pre", "mutant hit-blind: the combo assert fails")
	_check(int(m7["jumps"]) == 2 and int(m7["jump_list"][1]["since_prev_hit"]) == -1, "mutant hit-blind: no landed hit")
	# 8. react-blind: the same reaction hold rows on a punch-named clip - being hit now dates her next punch.
	var m8 := HS.analyse(_hold_run(100, 102, "pro_hook_snap", "01", [101, 102]) + _hold_run(103, 105, "pro_left_jab", "0", [104], 0, 30.0))
	_check(int(m8["jumps"]) == 3 and str(m8["jump_list"][2]["phase"]) == "combo", "mutant react-blind: the pre assert fails")


func _test_empty() -> void:
	var res := HS.analyse([])
	_check(int(res["jumps"]) == 0, "empty: no jumps")
	_check(res["jump_list"].is_empty() and res["worst"].is_empty(), "empty: no jump rows, worst empty")
	_check(res["by_kind"].is_empty() and res["starts"].is_empty(), "empty: by_kind and starts empty")
	_check(res["per_punch"] == 0.0 and res["per_react"] == 0.0, "empty: both rates 0")
	_check(res["root_p50"] == 0.0 and res["hips_p50"] == 0.0 and res["trunk_p50"] == 0.0 and res["neck_p50"] == 0.0,
		"empty: all four medians 0")
	_check(res["by_phase"] == {"pre": 0, "combo": 0, "contact": 0, "post": 0, "late": 0, "none": 0},
		"empty: by_phase carries six zeroes, combo among them")
	_check(HS.shared_until([], []) == 0 and HS.shared_until(_film("pro_left_hook"), []) == 0,
		"empty: two empty films share nothing, an empty film's last frame is 0")
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


## The row shapes every fixture is made of: nothing moved, the trunk/neck alone carrying the head, and who 1
## standing 3 m away (pairing across boxers would read a 3 m jump).
func _still(frame: int, clip: String, who: int = 0) -> Dictionary:
	return _row(frame, who, clip, _pose(0, 0, 0, 0))


func _bend(frame: int, clip: String, trunk_cm: float, neck_cm: float = 0.0, who: int = 0) -> Dictionary:
	return _row(frame, who, clip, _pose(0, 0, trunk_cm, neck_cm))


func _far(frame: int, clip: String, trunk_cm: float = 0.0, neck_cm: float = 0.0) -> Dictionary:
	return _row(frame, 1, clip, _slide(_pose(0, 0, trunk_cm, neck_cm), Vector3(3.0, 0.0, 0.0)))


## A row with a hold column, its head trunk_cm above the base pose: a 15 cm step is a jump the trunk carried.
func _hrow(frame: int, who: int, clip: String, trunk_cm: float, hold: String) -> Dictionary:
	var d := _bend(frame, clip, trunk_cm, 0.0, who)
	d["hold"] = hold
	return d


## One boxer's frames from..to in one clip: holds one character per frame (the last repeats), 15 cm steps at
## jump_at, the trunk starting at trunk0 so two runs join into a combo without a step at the seam.
func _hold_run(from: int, to: int, clip: String, holds: String, jump_at: Array, who: int = 0, trunk0: float = 0.0) -> Array:
	var rows: Array = []
	var trunk := trunk0
	for f in range(from, to + 1):
		if jump_at.has(f):
			trunk += 15.0
		rows.append(_hrow(f, who, clip, trunk, holds.substr(mini(f - from, holds.length() - 1), 1)))
	return rows


## One two-row fixture: one jump, and its head_cm plus the four splits against want, in CM_KEYS order.
func _split_case(rows: Array, want: Array, label: String) -> Dictionary:
	var res := HS.analyse(rows)
	_check(int(res["jumps"]) == 1, "%s: one jump" % label)
	var j := _one(res)
	if not j.is_empty():
		for i in range(CM_KEYS.size()):
			_near(j[CM_KEYS[i]], want[i], "%s: %s" % [label, CM_KEYS[i]])
	return res


## A jump's keys or a film's counts against want: every key checked, one line per fixture.
func _want(got: Dictionary, want: Dictionary, label: String) -> void:
	for k in want:
		_check(str(got.get(k, "")) == str(want[k]), "%s: %s %s" % [label, k, want[k]])


## One phase fixture: every jump's (since_contact, phase) against want, the six by_phase counts in PHASES
## order, post_p50, and - when prev is given - every jump's since_prev_hit.
func _phase_case(rows: Array, want: Array, counts: Array, p50: float, label: String, prev: Array = []) -> Dictionary:
	var res := HS.analyse(rows)
	var got: Array = []
	for p in HS.PHASES:
		got.append(int(res["by_phase"][p]))
	_check(int(res["jumps"]) == want.size(), "%s: %d jumps" % [label, want.size()])
	_check(got == counts, "%s: by_phase %s" % [label, counts])
	_near(res["post_p50_frames"], p50, "%s: post_p50" % label)
	for i in range(mini(want.size(), res["jump_list"].size())):
		var j: Dictionary = res["jump_list"][i]
		_check(int(j["since_contact"]) == want[i][0] and str(j["phase"]) == want[i][1],
			"%s: jump %d since %d phase %s" % [label, i, want[i][0], want[i][1]])
		if prev.size() > i:
			_check(int(j["since_prev_hit"]) == prev[i], "%s: jump %d since_prev_hit %d" % [label, i, prev[i]])
	return res


## The two films of the shared-part fixture: who 0 idles, jabs (11), idles (21), crosses (31) and throws
## last_clip (41); who 1 idles and fidgets from fidget_from to 30. who 0's head jumps 15 cm at frames 15 and
## 45, who 1's at frame 5. Both boxers' rows are interleaved per frame, as shown.csv writes them.
func _film(last_clip: String, n_frames: int = 60, fidget_from: int = 11) -> Array:
	var rows: Array = []
	for f in range(1, n_frames + 1):
		var clip0 := last_clip if f >= 41 else "pro_right_cross" if f >= 31 else "pro_left_jab" if f >= 11 and f <= 20 else "pro_idle"
		var p0 := _pose(0, 0, 16, 14) if f >= 45 else _pose(0, 0, 8, 7) if f >= 15 else _pose(0, 0, 0, 0)
		rows.append(_row(f, 0, clip0, p0))
		var clip1 := "pro_idle_fidget_v2" if f >= fidget_from and f <= 30 else "pro_idle"
		rows.append(_far(f, clip1, 8.0 if f >= 5 else 0.0, 7.0 if f >= 5 else 0.0))
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
