extends RefCounted
## HOOKPAST1: a ruler for the fling - after a landed punch, how far and how fast does the glove go past the head?
## Pure static analyser over shown.csv rows (every value a String). ZERO preloads.
## A coach's hook stops at the jaw and comes home on the same line; a swing sails on past the head and up over it.
## Contact is PunchEnd's rule: the run's first hold with the punching hand out at CONTACT_REACH of the run's
## furthest reach - but the reach is measured from UpperChest, the brief's hand bone (PunchEnd uses Hips), so
## the two rulers count a few runs differently. The punching hand is the one that moves furthest from
## UpperChest (FreeHand's rule). Runs are per who - both boxers are interleaved per frame in the film - and
## at least MIN_RUN frames, as in PunchEnd. Only runs with a contact frame count: landed or blocked.
## Two honest limits: past_cm is excursion from the contact point in ANY direction, so the return home counts
## in it too - the speed gate is what calls a swing. And a fling is read from frame 2 on: frame 1 after contact
## is the impact itself, not the glove sailing away.

const PUNCH_WORDS := ["jab", "cross", "hook", "uppercut", "body_shot"]
const EXCLUDE_WORDS := ["hit_by", "dodge", "weave", "idle"]
const CONTACT_REACH := 0.85
const MIN_RUN := 3
const PAST_FRAMES := 12
const FLING_MPS := 6.0
const FLING_AFTER := 2
const FPS := 30.0
const WORST_N := 5


## "runs" is the number of landed runs; "punches" holds one dictionary per run.
static func analyse(rows: Array) -> Dictionary:
	var out := {"runs": 0, "punches": [], "past_p50": 0.0, "past_p90": 0.0, "up_p90": 0.0,
		"fling_p50": 0.0, "fling_p90": 0.0, "flings": 0, "by_kind": {}, "worst": []}
	if rows.is_empty():
		return out
	var by_who := {}
	for r in rows:
		var w: int = int(r["who"])
		if not by_who.has(w):
			by_who[w] = []
		by_who[w].append(r)
	var punches: Array = []
	for who in by_who:
		var sorted := _sort_by_frame(by_who[who])
		var runs := _extract_runs(sorted)
		for run in runs:
			if run.size() < MIN_RUN:
				continue
			var p: Dictionary = _analyse_run(run, who)
			if not p.is_empty():
				punches.append(p)
	var past_vals: Array = []
	var up_vals: Array = []
	var fling_vals: Array = []
	var flings := 0
	var by_kind := {}
	for p in punches:
		past_vals.append(p["past_cm"])
		up_vals.append(p["up_cm"])
		fling_vals.append(p["fling_mps"])
		var is_fling: bool = p["late_fling_mps"] > FLING_MPS
		if is_fling:
			flings += 1
		var k: String = p["kind"]
		if not by_kind.has(k):
			by_kind[k] = {"n": 0, "past": [], "fling": [], "flings": 0}
		by_kind[k]["n"] += 1
		by_kind[k]["past"].append(p["past_cm"])
		by_kind[k]["fling"].append(p["fling_mps"])
		if is_fling:
			by_kind[k]["flings"] += 1
	var kinds_out := {}
	for k in by_kind:
		var d: Dictionary = by_kind[k]
		kinds_out[k] = {"n": d["n"], "past_p90": _pct(d["past"], 0.9),
			"fling_p90": _pct(d["fling"], 0.9), "flings": d["flings"]}
	var ranked := punches.duplicate()
	ranked.sort_custom(func(a, b):
		if a["fling_mps"] != b["fling_mps"]:
			return a["fling_mps"] > b["fling_mps"]
		if a["start_frame"] != b["start_frame"]:
			return a["start_frame"] < b["start_frame"]
		return a["who"] < b["who"])
	var worst: Array = []
	for i in range(mini(WORST_N, ranked.size())):
		var p: Dictionary = ranked[i]
		worst.append({"clip": p["clip"], "who": p["who"], "start_frame": p["start_frame"],
			"fling_mps": p["fling_mps"], "past_cm": p["past_cm"], "up_cm": p["up_cm"]})
	out["runs"] = punches.size()
	out["punches"] = punches
	out["past_p50"] = _pct(past_vals, 0.5)
	out["past_p90"] = _pct(past_vals, 0.9)
	out["up_p90"] = _pct(up_vals, 0.9)
	out["fling_p50"] = _pct(fling_vals, 0.5)
	out["fling_p90"] = _pct(fling_vals, 0.9)
	out["flings"] = flings
	out["by_kind"] = kinds_out
	out["worst"] = worst
	return out


static func _analyse_run(run: Array, who: int) -> Dictionary:
	var hand := _punch_hand(run)
	var reach := 0.0
	for r in run:
		reach = maxf(reach, _hand_dist(r, hand))
	var contact_idx := -1
	for i in range(run.size()):
		var r: Dictionary = run[i]
		if r.has("hold") and float(r["hold"]) > 0.0 and _hand_dist(r, hand) >= CONTACT_REACH * reach:
			contact_idx = i
			break
	if contact_idx < 0:
		return {}
	var first: Dictionary = run[0]
	var clip: String = str(first["clip"])
	var contact_row: Dictionary = run[contact_idx]
	var cpos := _bone_pos(contact_row, hand)
	var last_idx: int = mini(contact_idx + PAST_FRAMES, run.size() - 1)
	var past_cm := 0.0
	var up_cm := 0.0
	var fling_mps := 0.0
	var fling_frame := 0
	var late_mps := 0.0
	for i in range(contact_idx, last_idx + 1):
		var pos := _bone_pos(run[i], hand)
		past_cm = maxf(past_cm, pos.distance_to(cpos) * 100.0)
		up_cm = maxf(up_cm, (pos.y - cpos.y) * 100.0)
		if i > contact_idx:
			var prev := _bone_pos(run[i - 1], hand)
			# cm per frame * 0.3 is m/s at 30 fps: distance in metres * 30.
			var mps: float = pos.distance_to(prev) * FPS
			var rel: int = i - contact_idx
			if mps > fling_mps:
				fling_mps = mps
				fling_frame = rel
			if rel >= FLING_AFTER:
				late_mps = maxf(late_mps, mps)
	return {"clip": clip, "who": who, "start_frame": int(first["frame"]),
		"contact_frame": int(contact_row["frame"]), "hand": hand, "kind": _kind(clip),
		"past_cm": past_cm, "up_cm": up_cm, "fling_mps": fling_mps, "fling_frame": fling_frame,
		"late_fling_mps": late_mps}


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
			var prev: Dictionary = cur.back()
			var frame: int = int(r["frame"])
			var prev_frame: int = int(prev["frame"])
			if is_punch and clip == str(prev["clip"]) and frame == prev_frame + 1:
				cur.append(r)
			else:
				runs.append(cur)
				cur = [r] if is_punch else []
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


static func _kind(clip: String) -> String:
	if clip.contains("body"):
		return "body"
	for w in ["uppercut", "hook", "cross", "jab"]:
		if clip.contains(w):
			return w
	return "other"


static func _punch_hand(run: Array) -> String:
	var lg := 0.0
	var rg := 0.0
	for r in run:
		lg = maxf(lg, _hand_dist(r, "LeftHand"))
		rg = maxf(rg, _hand_dist(r, "RightHand"))
	return "RightHand" if rg > lg else "LeftHand"


static func _hand_dist(row: Dictionary, hand: String) -> float:
	return _bone_pos(row, hand).distance_to(_bone_pos(row, "UpperChest"))


static func _bone_pos(row: Dictionary, bone: String) -> Vector3:
	return Vector3(float(row[bone + "_x"]), float(row[bone + "_y"]), float(row[bone + "_z"]))


static func _sort_by_frame(arr: Array) -> Array:
	var out := arr.duplicate()
	out.sort_custom(func(a, b): return int(a["frame"]) < int(b["frame"]))
	return out


static func _pct(vals: Array, p: float) -> float:
	if vals.is_empty():
		return 0.0
	var s := vals.duplicate()
	s.sort()
	var idx: int = int(p * float(s.size() - 1))
	return float(s[idx])
