extends RefCounted
## HEADEASE1: a ruler for head reactions - when does a hit head peak, and how fast does it come back?
## Pure static analyser over shown.csv rows. ZERO preloads.
## A HIT RUN is consecutive frames of ONE boxer whose clip contains "hit_by" and none of the body words
## (gutshot / body / kidney / liver): head shots only. The film interleaves both boxers per frame, so runs
## are built per `who`, never across the other boxer's rows.
## d_cm is the head's move on its OWN body: (Head - Hips) now vs (Head - Hips) on the run's first frame,
## so a step back (hips and head travelling together) is not counted. HitSnap's settle is an exponential
## (tau 0.11 s) that comes back fastest the frame after the peak; this reads the peak timing and the
## spring-back speed off the film so the curve change can be judged before/after.

const BODY_WORDS := ["gutshot", "body", "kidney", "liver"]
const KIND_WORDS := ["jab", "cross", "hook", "uppercut"]
const BACK_SHARE := 0.30   # "back" = d_cm first falls under this share of the peak
const MIN_RUN := 4         # runs shorter than this are skipped (counted in `skipped`)
const LATE_FRAME := 3      # peak later than this reads "late" (critics want the peak 2-3 frames in)
const SNAP_MAX := 4        # back in 0..this many frames reads "snap" (came back too fast)


static func analyse(rows: Array) -> Dictionary:
	var empty := {
		"runs": [], "skipped": 0,
		"peak_frame_p50": 0.0, "peak_cm_p50": 0.0, "back_frames_p50": 0.0,
		"max_back_cm_p50": 0.0, "max_back_cm_p90": 0.0,
		"late_share": 0.0, "snap_share": 0.0, "by_kind": {},
	}
	if rows.is_empty():
		return empty
	var by_who := _group_by_who(rows)
	var runs: Array = []
	var skipped := 0
	for who in by_who:
		for run in _extract_runs(by_who[who]):
			if run.size() < MIN_RUN:
				skipped += 1
				continue
			runs.append(_analyse_run(run, who))
	var peak_frames: Array = []
	var peak_cms: Array = []
	var backs: Array = []
	var max_backs: Array = []
	var late_n := 0
	var snap_n := 0
	var by_kind: Dictionary = {}
	for p in runs:
		peak_frames.append(p["peak_frame"])
		peak_cms.append(p["peak_cm"])
		max_backs.append(p["max_back_cm"])
		var bf: int = p["back_frames"]
		if bf >= 0:
			backs.append(bf)
		if int(p["peak_frame"]) > LATE_FRAME:
			late_n += 1
		if bf >= 0 and bf <= SNAP_MAX:
			snap_n += 1
		var k: String = p["kind"]
		if not by_kind.has(k):
			by_kind[k] = {"n": 0, "peak": [], "back": []}
		by_kind[k]["n"] += 1
		by_kind[k]["peak"].append(p["peak_cm"])
		if bf >= 0:
			by_kind[k]["back"].append(bf)
	var by_kind_out: Dictionary = {}
	for k in by_kind:
		by_kind_out[k] = {
			"n": by_kind[k]["n"],
			"peak_cm_p50": _pct(by_kind[k]["peak"], 0.5),
			"back_frames_p50": _pct(by_kind[k]["back"], 0.5),
		}
	var n := runs.size()
	return {
		"runs": runs,
		"skipped": skipped,
		"peak_frame_p50": _pct(peak_frames, 0.5),
		"peak_cm_p50": _pct(peak_cms, 0.5),
		"back_frames_p50": _pct(backs, 0.5),
		"max_back_cm_p50": _pct(max_backs, 0.5),
		"max_back_cm_p90": _pct(max_backs, 0.9),
		"late_share": float(late_n) / float(n) if n > 0 else 0.0,
		"snap_share": float(snap_n) / float(n) if n > 0 else 0.0,
		"by_kind": by_kind_out,
	}


static func _group_by_who(rows: Array) -> Dictionary:
	var by_who: Dictionary = {}
	for r in rows:
		var w: int = int(r["who"])
		if not by_who.has(w):
			by_who[w] = []
		by_who[w].append(r)
	for w in by_who:
		by_who[w].sort_custom(func(a, b): return int(a["frame"]) < int(b["frame"]))
	return by_who


## Consecutive frames (frame == prev + 1) of this boxer that pass the head-hit test; a gap or a
## non-head-hit row ends the run.
static func _extract_runs(boxer_rows: Array) -> Array:
	var runs: Array = []
	var cur: Array = []
	for r in boxer_rows:
		if _is_head_hit(str(r["clip"])):
			if cur.is_empty():
				cur.append(r)
			elif int(r["frame"]) == int(cur.back()["frame"]) + 1:
				cur.append(r)
			else:
				runs.append(cur)
				cur = [r]
		elif not cur.is_empty():
			runs.append(cur)
			cur = []
	if not cur.is_empty():
		runs.append(cur)
	return runs


static func _is_head_hit(clip: String) -> bool:
	if not clip.contains("hit_by"):
		return false
	for w in BODY_WORDS:
		if clip.contains(w):
			return false
	return true


static func _analyse_run(run: Array, who: int) -> Dictionary:
	var ref := _local(run[0])
	var ds: Array = []
	for r in run:
		ds.append(_local(r).distance_to(ref) * 100.0)
	var peak_idx := 0
	for i in range(ds.size()):
		if float(ds[i]) > float(ds[peak_idx]):
			peak_idx = i
	var peak_cm: float = ds[peak_idx]
	var start_frame: int = int(run[0]["frame"])
	var peak_abs: int = int(run[peak_idx]["frame"])
	var back_frames := -1
	var thresh := BACK_SHARE * peak_cm
	for i in range(peak_idx + 1, ds.size()):
		if float(ds[i]) < thresh:
			back_frames = int(run[i]["frame"]) - peak_abs
			break
	var max_back := 0.0
	for i in range(peak_idx + 1, ds.size()):
		var drop: float = float(ds[i - 1]) - float(ds[i])
		if drop > max_back:
			max_back = drop
	return {
		"who": who,
		"clip": str(run[0]["clip"]),
		"start_frame": start_frame,
		"peak_frame": peak_abs - start_frame,
		"peak_cm": peak_cm,
		"back_frames": back_frames,
		"max_back_cm": max_back,
		"kind": _kind(str(run[0]["clip"])),
	}


static func _kind(clip: String) -> String:
	for w in KIND_WORDS:
		if clip.contains(w):
			return w
	return "other"


## The head on its own body: Head - Hips in world metres.
static func _local(row: Dictionary) -> Vector3:
	return _bone_pos(row, "Head") - _bone_pos(row, "Hips")


static func _bone_pos(row: Dictionary, bone: String) -> Vector3:
	return Vector3(float(row[bone + "_x"]), float(row[bone + "_y"]), float(row[bone + "_z"]))


static func _pct(vals: Array, p: float) -> float:
	if vals.is_empty():
		return 0.0
	var s := vals.duplicate()
	s.sort()
	var idx: int = int(p * float(s.size() - 1))
	return float(s[idx])
