extends RefCounted
## FIGHTPLAYER2 phase 2 (FP2CHOREO1, split out of Choreographer.gd for the 500-line rule): what the OTHER man does with a
## punch - the reaction take by size and direction (R6), the block take (R8), the defence take (R8). Pure.

const R := preload("res://scripts/fight3d/v2/ChoreoRules.gd")
const BeatClips := preload("res://scripts/fight3d/BeatClips.gd")


static func react(db: Dictionary, rows: Dictionary, move: String, big: bool, from_left: bool, rng: RandomNumberGenerator, hfh: float, log: Array) -> Array:
	var size: String = R.react_size_for(move, big)
	# Direction: straight -> back (x >= 0.6); hook from left -> his left (y >= 0.5); hook from right -> his right (y <= -0.5)
	var want_back: bool = R.is_straight(move) or move.contains("uppercut")
	var want_side: int = 0  # 0 = no side preference, 1 = his left, -1 = his right
	if move.contains("hook"):
		want_side = 1 if from_left else -1
	var is_body: bool = move == "body_hook"
	var best: String = ""
	var best_row: Dictionary = {}
	var best_score: float = 999.0
	var size_order: Array = _size_order(size)
	for sz in size_order:
		for n in rows:
			var r: Dictionary = rows[n]
			if str(r.get("kind", "")) != "reaction":
				continue
			if (r.get("drop", []) as Array).size() > 0:
				continue
			if str(r.get("size", "")) != sz:
				continue
			if is_body and not str(n).contains("gutshot"):
				continue
			if not is_body and str(n).contains("gutshot"):
				continue
			var hd: Array = r.get("head_dir", [])
			if hd.size() < 3:
				continue
			var dx: float = float(hd[0])
			var dy: float = float(hd[1])
			var ok := true
			var score: float = 0.0
			if want_back and not is_body:
				if dx < 0.6:
					ok = false
				else:
					score += absf(dx - 0.8)
			if want_side != 0 and not is_body:
				if want_side > 0 and dy < 0.5:
					ok = false
				elif want_side < 0 and dy > -0.5:
					ok = false
				else:
					score += absf(dy - float(want_side) * 0.7)
			if not ok:
				continue
			if score < best_score:
				best_score = score
				best = str(n)
				best_row = r
	if best == "":
		# Fallback: nearest size with any direction
		for sz in size_order:
			for n in rows:
				var r: Dictionary = rows[n]
				if str(r.get("kind", "")) != "reaction" or (r.get("drop", []) as Array).size() > 0:
					continue
				if str(r.get("size", "")) != sz:
					continue
				if is_body and not str(n).contains("gutshot"):
					continue
				if not is_body and str(n).contains("gutshot"):
					continue
				best = str(n)
				best_row = r
				break
			if best != "":
				log.append("react: %s fallback size %s" % [move, sz])
				break
	if best == "":
		best = "react_head"
		best_row = rows.get("react_head", {})
	var hips: float = float(best_row.get("hips_max_m", 0.0))
	var rpart: String = "whole" if hips >= R.WHOLE_BODY_HIPS_M else "upper"
	return [best, best_row, rpart, size]


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
