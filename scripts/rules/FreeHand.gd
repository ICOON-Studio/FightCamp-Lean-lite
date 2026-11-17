extends RefCounted
## FREEHAND1: a ruler for the free hand - does the glove that is NOT punching stay at the chin?
## Pure static analyser over shown.csv rows. ZERO preloads.

const PUNCH_WORDS := ["jab", "cross", "hook", "uppercut", "body_shot"]
const EXCLUDE_WORDS := ["hit_by", "dodge", "weave", "idle"]
const OFF_CM := 20.0
const DROP_CM := 25.0


static func analyse(rows: Array) -> Dictionary:
	var empty := {"runs": [], "runs_count": 0, "runs_off": 0, "off_share": 0.0,
		"free_cm_p50": 0.0, "free_cm_p90": 0.0, "drop_cm_p90": 0.0,
		"by_clip": {}, "guard_free_cm_p50": 0.0}
	if rows.is_empty():
		return empty
	var by_who := {}
	for r in rows:
		var w: int = int(r["who"])
		if not by_who.has(w):
			by_who[w] = []
		by_who[w].append(r)
	var all_runs: Array = []
	for who in by_who:
		var boxer_arr: Array = by_who[who]
		var sorted := _sort_by_frame(boxer_arr)
		var runs := _extract_runs(sorted)
		for run in runs:
			all_runs.append(run)
	var free_vals: Array = []
	var drop_vals: Array = []
	var guard_free_vals: Array = []
	var runs_off: int = 0
	var non_body: int = 0
	var by_clip := {}
	var run_outs: Array = []
	for run in all_runs:
		var clip: String = str(run[0]["clip"])
		var who: int = int(run[0]["who"])
		var start: int = int(run[0]["frame"])
		var punch := _punch_hand(run)
		var free: String = "LeftHand" if punch == "RightHand" else "RightHand"
		var is_body: bool = clip.contains("body")
		var max_free: float = 0.0
		var max_drop: float = 0.0
		var frames_off: int = 0
		for r in run:
			var hp := _bone_pos(r, free)
			var headp := _bone_pos(r, "Head")
			var fc: float = hp.distance_to(headp) * 100.0
			var fd: float = (headp.y - hp.y) * 100.0
			max_free = maxf(max_free, fc)
			max_drop = maxf(max_drop, fd)
			if fc > OFF_CM or fd > DROP_CM:
				frames_off += 1
		var out := {"clip": clip, "who": who, "start_frame": start,
			"frames_off": frames_off, "max_free_cm": max_free, "max_drop_cm": max_drop,
			"is_body": is_body}
		run_outs.append(out)
		if not is_body:
			non_body += 1
			free_vals.append(max_free)
			drop_vals.append(max_drop)
			if frames_off >= 2:
				runs_off += 1
		if not by_clip.has(clip):
			by_clip[clip] = {"n": 0, "off": 0}
		by_clip[clip]["n"] += 1
		if frames_off >= 2 and not is_body:
			by_clip[clip]["off"] += 1
	for r in rows:
		var clip: String = str(r["clip"])
		if clip.contains("idle") or clip.contains("guard"):
			var headp := _bone_pos(r, "Head")
			var lh := _bone_pos(r, "LeftHand")
			var rh := _bone_pos(r, "RightHand")
			guard_free_vals.append(minf(lh.distance_to(headp), rh.distance_to(headp)) * 100.0)
	var off_share: float = 0.0
	if non_body > 0:
		off_share = float(runs_off) / float(non_body)
	var bc_out := {}
	for c in by_clip:
		var d: Dictionary = by_clip[c]
		var cs: float = 0.0
		if d["n"] > 0:
			cs = float(d["off"]) / float(d["n"])
		bc_out[c] = {"n": d["n"], "off_share": cs}
	return {"runs": run_outs, "runs_count": all_runs.size(), "runs_off": runs_off,
		"off_share": off_share, "free_cm_p50": _pct(free_vals, 0.5),
		"free_cm_p90": _pct(free_vals, 0.9), "drop_cm_p90": _pct(drop_vals, 0.9),
		"by_clip": bc_out, "guard_free_cm_p50": _pct(guard_free_vals, 0.5)}


static func _sort_by_frame(arr: Array) -> Array:
	var frames: Array = []
	for r in arr:
		frames.append(int(r["frame"]))
	frames.sort()
	var by_frame := {}
	for r in arr:
		by_frame[int(r["frame"])] = r
	var out: Array = []
	for f in frames:
		out.append(by_frame[f])
	return out


static func _extract_runs(boxer_rows: Array) -> Array:
	var runs: Array = []
	var cur: Array = []
	for r in boxer_rows:
		var clip: String = str(r["clip"])
		var is_punch := _is_punch_clip(clip)
		if cur.is_empty():
			if is_punch:
				cur.append(r)
		else:
			var prev_clip: String = str(cur.back()["clip"])
			var frame: int = int(r["frame"])
			var prev_frame: int = int(cur.back()["frame"])
			if is_punch and clip == prev_clip and frame == prev_frame + 1:
				cur.append(r)
			else:
				if cur.size() >= 3:
					runs.append(cur)
				cur = [r] if is_punch else []
	if cur.size() >= 3:
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


static func _punch_hand(run: Array) -> String:
	var first: Dictionary = run[0]
	var lg := _hand_dist(first, "LeftHand")
	var rg := _hand_dist(first, "RightHand")
	for r in run:
		lg = maxf(lg, _hand_dist(r, "LeftHand"))
		rg = maxf(rg, _hand_dist(r, "RightHand"))
	if rg > lg:
		return "RightHand"
	return "LeftHand"


static func _bone_pos(row: Dictionary, bone: String) -> Vector3:
	return Vector3(float(row[bone + "_x"]), float(row[bone + "_y"]), float(row[bone + "_z"]))


static func _hand_dist(row: Dictionary, hand: String) -> float:
	return _bone_pos(row, hand).distance_to(_bone_pos(row, "UpperChest"))


static func _pct(vals: Array, p: float) -> float:
	if vals.is_empty():
		return 0.0
	var s := vals.duplicate()
	s.sort()
	var idx: int = int(p * float(s.size() - 1))
	return float(s[idx])
