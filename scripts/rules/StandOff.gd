extends RefCounted
## STANDOFF1: glove-pressing stand-offs inside 1.0 m.
## Pure static analyser over shown.csv rows. ZERO preloads.

const BUSY_WORDS := ["jab", "cross", "hook", "uppercut", "body_shot", "hit_by", "clinch", "dodge", "weave", "slip", "knock"]


static func analyse(rows: Array, near_m: float = 1.0, glove_m: float = 0.15, min_frames: int = 10) -> Dictionary:
	var empty := {
		"standoffs": [], "count": 0, "total_frames": 0, "total_s": 0.0,
		"longest_frames": 0, "near_frames": 0, "pressing_share": 0.0,
	}
	if rows.is_empty():
		return empty
	var by_frame := _pair_by_frame(rows)
	var frames := by_frame.keys()
	frames.sort()
	var so_flags: Array = []
	var near_flags: Array = []
	var hips_dists: Array = []
	var glove_dists: Array = []
	var clip0s: Array = []
	var clip1s: Array = []
	var film_ss: Array = []
	for f in frames:
		var pair: Dictionary = by_frame[f]
		if not (pair.has(0) and pair.has(1)):
			so_flags.append(false)
			near_flags.append(false)
			hips_dists.append(0.0)
			glove_dists.append(0.0)
			clip0s.append("")
			clip1s.append("")
			film_ss.append(0.0)
			continue
		var r0: Dictionary = pair[0]
		var r1: Dictionary = pair[1]
		var hd := _hips_hz_dist(r0, r1)
		var gd := _min_glove_dist(r0, r1)
		var busy := _is_busy(str(r0["clip"])) or _is_busy(str(r1["clip"]))
		var is_near := hd < near_m
		var is_so := is_near and (not busy) and gd < glove_m
		so_flags.append(is_so)
		near_flags.append(is_near)
		hips_dists.append(hd)
		glove_dists.append(gd)
		clip0s.append(str(r0["clip"]))
		clip1s.append(str(r1["clip"]))
		film_ss.append(float(r0.get("film_s", r1.get("film_s", "0"))))
	var runs := _extract_runs(so_flags, frames)
	var standoffs: Array = []
	var total_so_frames := 0
	var longest := 0
	for run in runs:
		if run.size() < min_frames:
			continue
		var hd_slice := _slice(hips_dists, run)
		var gd_slice := _slice(glove_dists, run)
		var sf: int = frames[run[0]]
		var ef: int = frames[run.back()]
		var entry := {
			"start_frame": sf,
			"end_frame": ef,
			"frames": run.size(),
			"start_s": film_ss[run[0]],
			"hips_m": _median(hd_slice),
			"glove_m": _median(gd_slice),
			"clips": [clip0s[run[0]], clip1s[run[0]]],
		}
		standoffs.append(entry)
		total_so_frames += run.size()
		if run.size() > longest:
			longest = run.size()
	var near_count := 0
	for nf in near_flags:
		if nf:
			near_count += 1
	var pressing_share := 0.0
	if near_count > 0:
		pressing_share = float(total_so_frames) / float(near_count)
	return {
		"standoffs": standoffs,
		"count": standoffs.size(),
		"total_frames": total_so_frames,
		"total_s": float(total_so_frames) / 30.0,
		"longest_frames": longest,
		"near_frames": near_count,
		"pressing_share": pressing_share,
	}


static func _pair_by_frame(rows: Array) -> Dictionary:
	var out := {}
	for r in rows:
		var f: int = int(r["frame"])
		var w: int = int(r["who"])
		if not out.has(f):
			out[f] = {}
		out[f][w] = r
	return out


static func _hips_hz_dist(r0: Dictionary, r1: Dictionary) -> float:
	var dx := float(r0["Hips_x"]) - float(r1["Hips_x"])
	var dz := float(r0["Hips_z"]) - float(r1["Hips_z"])
	return sqrt(dx * dx + dz * dz)


static func _min_glove_dist(r0: Dictionary, r1: Dictionary) -> float:
	var l0 := Vector3(float(r0["LeftHand_x"]), float(r0["LeftHand_y"]), float(r0["LeftHand_z"]))
	var r0h := Vector3(float(r0["RightHand_x"]), float(r0["RightHand_y"]), float(r0["RightHand_z"]))
	var l1 := Vector3(float(r1["LeftHand_x"]), float(r1["LeftHand_y"]), float(r1["LeftHand_z"]))
	var r1h := Vector3(float(r1["RightHand_x"]), float(r1["RightHand_y"]), float(r1["RightHand_z"]))
	var best := l0.distance_to(l1)
	best = minf(best, l0.distance_to(r1h))
	best = minf(best, r0h.distance_to(l1))
	best = minf(best, r0h.distance_to(r1h))
	return best


static func _is_busy(clip: String) -> bool:
	var low := clip.to_lower()
	for w in BUSY_WORDS:
		if low.contains(w):
			return true
	return false


static func _extract_runs(flags: Array, frames: Array) -> Array:
	var runs: Array = []
	var cur: Array = []
	for i in range(flags.size()):
		if flags[i]:
			if cur.is_empty():
				cur.append(i)
			else:
				var prev_idx: int = cur.back()
				if frames[i] == frames[prev_idx] + 1:
					cur.append(i)
				else:
					runs.append(cur)
					cur = [i]
		else:
			if not cur.is_empty():
				runs.append(cur)
				cur = []
	if not cur.is_empty():
		runs.append(cur)
	return runs


static func _slice(arr: Array, indices: Array) -> Array:
	var out: Array = []
	for idx in indices:
		out.append(arr[idx])
	return out


static func _median(vals: Array) -> float:
	if vals.is_empty():
		return 0.0
	var s := vals.duplicate()
	s.sort()
	var n: int = s.size()
	if n % 2 == 1:
		return float(s[n / 2])
	return (float(s[n / 2 - 1]) + float(s[n / 2])) / 2.0
