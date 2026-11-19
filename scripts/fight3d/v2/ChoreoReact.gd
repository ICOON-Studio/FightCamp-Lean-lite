extends RefCounted
## FIGHTPLAYER2 phase 2 (FP2CHOREO1, split out of Choreographer.gd for the 500-line rule): what the OTHER man does with a
## punch - the reaction take by size and direction (R6), the block take (R8), the defence take (R8). Pure.

const R := preload("res://scripts/fight3d/v2/ChoreoRules.gd")
const BeatClips := preload("res://scripts/fight3d/BeatClips.gd")


static func react(db: Dictionary, rows: Dictionary, move: String, big: bool, from_left: bool, rng: RandomNumberGenerator, hfh: float, log: Array) -> Array:
	var size: String = R.react_size_for(move, big)
	var want: float = R.react_head_m(move, big)
	# Direction: straight -> back (x >= 0.6); hook from left -> his left (y >= 0.5); hook from right -> his right (y <= -0.5)
	var want_back: bool = R.is_straight(move) or move.contains("uppercut")
	var is_body: bool = move == "body_hook"
	var want_side: int = 0  # 0 = no side preference, 1 = his left, -1 = his right
	if move.contains("hook") and not is_body:
		want_side = 1 if from_left else -1
	var pool: Array = []    # [score, name]: the takes that go the right way, by how near their head travel is to the ask
	var any: Array = []     # ... and every take of the right kind, for when none goes the right way
	for n in rows:
		var r: Dictionary = rows[n]
		if str(r.get("kind", "")) != "reaction" or not may_play(r, move != "jab"):
			continue
		if is_body != str(n).contains("gutshot"):
			continue
		var hd: Array = r.get("head_dir", [])
		if hd.size() < 3:
			continue
		var score: float = absf(float(r.get("head_rel_m", 0.0)) - want) + (0.0 if str(n).begins_with("pro_") else 0.05) + (0.2 if str(n) in R.REACT_SLOW else 0.0)
		any.append([score, str(n)])
		var dx: float = float(hd[0])
		var dy: float = float(hd[1])
		if want_back and not is_body:
			if dx < 0.6:
				continue
			score += absf(dx - 0.8) * 0.05
		if want_side != 0:
			if (want_side > 0 and dy < 0.5) or (want_side < 0 and dy > -0.5):
				continue
			score += absf(dy - float(want_side) * 0.7) * 0.05
		pool.append([score, str(n)])
	if pool.is_empty() and not any.is_empty():
		pool = any
		log.append("react: %s no take goes the right way" % move)
	var best: String = "react_head"
	var best_row: Dictionary = rows.get("react_head", {})
	if not pool.is_empty():
		pool.sort_custom(func(x, y): return float(x[0]) < float(y[0]) if float(x[0]) != float(y[0]) else str(x[1]) < str(y[1]))
		# S513: nearly every head punch played ONE take; any take within REACT_VARY_M of the best fit may play.
		var near: Array = pool.filter(func(c): return float(c[0]) <= float(pool[0][0]) + R.REACT_VARY_M)
		best = str(near[rng.randi_range(0, near.size() - 1)][1]) if near.size() > 1 else str(pool[0][1])
		best_row = rows[best]
	var hips: float = float(best_row.get("hips_max_m", 0.0))
	var rpart: String = "whole" if hips >= R.WHOLE_BODY_HIPS_M else "upper"
	return [best, best_row, rpart, size]


## A reaction take may play when the census dropped nothing on it, or - for a power punch - dropped it only for a face
## tipped up no more than R.REACT_FACE_UP_OK_DEG.
static func may_play(r: Dictionary, power: bool) -> bool:
	var drops: Array = r.get("drop", [])
	if drops.is_empty():
		return true
	if not power:
		return false
	for d in drops:
		var txt := str(d)
		if not txt.begins_with("face tips up ") or float(txt.trim_prefix("face tips up ").get_slice(" ", 0)) > R.REACT_FACE_UP_OK_DEG:
			return false
	return true


static func _size_order(size: String) -> Array:
	if size == "light":
		return ["light", "medium", "heavy"]
	if size == "medium":
		return ["medium", "light", "heavy"]
	return ["heavy", "medium", "light"]


static func block(db: Dictionary, rows: Dictionary) -> Array:
	var pref := ["pro_block_straight_hit_v2", "mc_block_hit", "pro_block_loop", "mc_to_block", "pro_idle_to_block", "mc_block"]
	for n in pref:
		if rows.has(n) and (rows[n].get("drop", []) as Array).is_empty():
			return [n, rows[n]]
	return ["mc_block", rows.get("mc_block", {})]


static func defence(db: Dictionary, rows: Dictionary, kind: String, move: String, from_left: bool, south: bool) -> Array:
	var has_fn := func(clip: String) -> bool:
		return rows.has(clip) and (rows[clip].get("drop", []) as Array).is_empty()
	var clip: String = BeatClips.defence(kind, move, from_left, south, has_fn)
	if clip != "" and rows.has(clip):
		return [clip, rows[clip]]
	return ["", {}]
