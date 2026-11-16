extends RefCounted
## PUNCHEND1: where each punch ends and how fast the hand comes home.
## Pure static analyser over shown.csv rows. ZERO preloads.

const PUNCH_WORDS := ["jab", "cross", "hook", "uppercut", "body_shot"]
const EXCLUDE_WORDS := ["hit_by", "dodge", "weave", "idle"]
const HOME_RADIUS_M := 0.08
const HOME_SEARCH := 30


static func analyse(rows: Array) -> Dictionary:
	var empty: Dictionary = {"punches": [], "head_n": 0, "above_10_n": 0, "above_p50": 0.0, "above_p90": 0.0, "home_p50": 0.0, "home_p90": 0.0, "by_clip": {}}
	if rows.is_empty():
		return empty
	var by_frame_who: Dictionary = {}
	var by_who: Dictionary = {}
	for r in rows:
		var f: int = int(r["frame"])
		var w: int = int(r["who"])
		if not by_frame_who.has(f):
			by_frame_who[f] = {}
		by_frame_who[f][w] = r
		if not by_who.has(w):
			by_who[w] = []
		by_who[w].append(r)
	for w in by_who:
		by_who[w].sort_custom(func(a, b): return int(a["frame"]) < int(b["frame"]))
	var punches: Array = []
	for who in by_who:
		var runs: Array = _extract_runs(by_who[who])
		for run in runs:
			if run.size() < 3:
				continue
			var p: Variant = _analyse_run(run, who, by_frame_who, by_who)
			if p != null:
				punches.append(p)
	var head_n: int = 0
	var above_10_n: int = 0
	var above_vals: Array = []
	var home_vals: Array = []
	var by_clip: Dictionary = {}
	for p in punches:
		var is_body: bool = p["is_body"]
		if not is_body:
			head_n += 1
			above_vals.append(p["above_cm"])
			if p["above_cm"] > 10.0:
				above_10_n += 1
		home_vals.append(p["home_frames"])
		var clip: String = p["clip"]
		if not by_clip.has(clip):
			by_clip[clip] = {"n": 0, "above": [], "home": []}
		by_clip[clip]["n"] += 1
		if not is_body:
			by_clip[clip]["above"].append(p["above_cm"])
		by_clip[clip]["home"].append(p["home_frames"])
	var by_clip_out: Dictionary = {}
	for clip in by_clip:
		var d: Dictionary = by_clip[clip]
		by_clip_out[clip] = {"n": d["n"], "above_p50": _pct(d["above"], 0.5), "home_p50": _pct(d["home"], 0.5)}
	return {
		"punches": punches,
		"head_n": head_n,
		"above_10_n": above_10_n,
		"above_p50": _pct(above_vals, 0.5),
		"above_p90": _pct(above_vals, 0.9),
		"home_p50": _pct(home_vals, 0.5),
		"home_p90": _pct(home_vals, 0.9),
		"by_clip": by_clip_out,
	}


static func _extract_runs(boxer_rows: Array) -> Array:
	var runs: Array = []
	if boxer_rows.is_empty():
		return runs
	var cur: Array = []
	for i in range(boxer_rows.size()):
		var r: Dictionary = boxer_rows[i]
		var clip: String = str(r["clip"])
		var is_punch := _is_punch_clip(clip)
		if cur.is_empty():
			if is_punch:
				cur.append(r)
		else:
			var prev: Dictionary = cur.back()
			var prev_clip: String = str(prev["clip"])
			var frame: int = int(r["frame"])
			var prev_frame: int = int(prev["frame"])
			if is_punch and clip == prev_clip and frame == prev_frame + 1:
				cur.append(r)
			else:
				runs.append(cur)
				if is_punch:
					cur = [r]
				else:
					cur = []
	if not cur.is_empty():
		runs.append(cur)
	return runs


static func _is_punch_clip(clip: String) -> bool:
	if not clip.begins_with("pro_"):
		return false
	var has_word := false
	for w in PUNCH_WORDS:
		if clip.contains(w):
			has_word = true
			break
	if not has_word:
		return false
	for w in EXCLUDE_WORDS:
		if clip.contains(w):
			return false
	return true


static func _analyse_run(run: Array, who: int, by_frame_who: Dictionary, by_who: Dictionary) -> Variant:
	var first_row: Dictionary = run[0]
	var start_frame: int = int(first_row["frame"])
	var clip: String = str(first_row["clip"])
	var hand_name := _pick_hand(run)
	var far_idx := 0
	var far_dist := -1.0
	for i in range(run.size()):
		var d := _hand_dist(run[i], hand_name)
		if d > far_dist:
			far_dist = d
			far_idx = i
	var far_row: Dictionary = run[far_idx]
	var far_frame: int = int(far_row["frame"])
	var opponent: int = 1 - who
	if not by_frame_who.has(far_frame):
		return null
	if not by_frame_who[far_frame].has(opponent):
		return null
	var opp_row: Dictionary = by_frame_who[far_frame][opponent]
	var hand_pos := _bone_pos(far_row, hand_name)
	var head_pos := _bone_pos(opp_row, "Head")
	var above_cm: float = (hand_pos.y - head_pos.y) * 100.0
	var miss_cm: float = hand_pos.distance_to(head_pos) * 100.0
	var is_body: bool = clip.contains("body")
	var home_frames := _compute_home(run, who, hand_name, far_frame, by_who)
	return {
		"clip": clip,
		"who": who,
		"start_frame": start_frame,
		"far_frame": far_frame,
		"out_frames": far_frame - start_frame,
		"above_cm": above_cm,
		"miss_cm": miss_cm,
		"is_body": is_body,
		"home_frames": home_frames,
	}


static func _pick_hand(run: Array) -> String:
	var first_row: Dictionary = run[0]
	var left_first := _hand_dist(first_row, "LeftHand")
	var right_first := _hand_dist(first_row, "RightHand")
	var left_max := left_first
	var right_max := right_first
	for i in range(1, run.size()):
		var ld := _hand_dist(run[i], "LeftHand")
		var rd := _hand_dist(run[i], "RightHand")
		left_max = maxf(left_max, ld)
		right_max = maxf(right_max, rd)
	var left_growth := left_max - left_first
	var right_growth := right_max - right_first
	return "RightHand" if right_growth > left_growth else "LeftHand"


static func _hand_dist(row: Dictionary, hand: String) -> float:
	var hp := _bone_pos(row, hand)
	var hips := _bone_pos(row, "Hips")
	return hp.distance_to(hips)


static func _bone_pos(row: Dictionary, bone: String) -> Vector3:
	return Vector3(float(row[bone + "_x"]), float(row[bone + "_y"]), float(row[bone + "_z"]))


static func _compute_home(run: Array, who: int, hand_name: String, far_frame: int, by_who: Dictionary) -> int:
	var first_row: Dictionary = run[0]
	var ref_hand := _bone_pos(first_row, hand_name) - _bone_pos(first_row, "Hips")
	var last_frame: int = int(run.back()["frame"])
	var search_start: int = maxi(last_frame + 1, far_frame + 1)
	var search_end: int = far_frame + HOME_SEARCH
	var boxer_rows: Array = by_who[who]
	for r in boxer_rows:
		var f: int = int(r["frame"])
		if f < search_start:
			continue
		if f > search_end:
			break
		var cur_hand := _bone_pos(r, hand_name) - _bone_pos(r, "Hips")
		if cur_hand.distance_to(ref_hand) <= HOME_RADIUS_M:
			return f - far_frame
	return HOME_SEARCH


static func _pct(vals: Array, p: float) -> float:
	if vals.is_empty():
		return 0.0
	var s := vals.duplicate()
	s.sort()
	var idx: int = int(p * float(s.size() - 1))
	return float(s[idx])
