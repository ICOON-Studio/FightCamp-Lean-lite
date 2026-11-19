extends RefCounted
## FIGHTPLAYER2 phase 2 (FP2CHOREO1, split out of Choreographer.gd for the 500-line rule): what the OTHER man does with a
## punch - the reaction take by size and direction (R6), the block take (R8), the defence take (R8). Pure.

const R := preload("res://scripts/fight3d/v2/ChoreoRules.gd")
const BeatClips := preload("res://scripts/fight3d/BeatClips.gd")


static func react(db: Dictionary, rows: Dictionary, move: String, big: bool, from_left: bool, rng: RandomNumberGenerator, hfh: float, log: Array, sc: float = 1.0) -> Array:
	var size: String = R.react_size_for(move, big)
	var want: float = R.react_head_m(move, big) / maxf(sc, 0.5)   # S530: the takes are measured on the census body; a bigger man shows more
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


## S530 NO HEAD OVER THE BAR IN ONE PICTURE (film 6 and the S529 bout: 20 head jumps over 12 cm, the worst 20 cm; both
## critics' bar is none over 10). A reaction is started part-way into its take and the join carries the head there: a
## 28-36 cm take joined at its peak put 0.4-0.5 of that way into ONE picture, though no bought take moves a head faster
## than 6 cm a picture by itself. So the take starts as late as keeps every picture's step (the join's way x the take's
## own head curve, clip_db head_g, on this body's size) under R.HEAD_STEP_MAX_M: a light take still starts
## react_peak_s before its peak, on the quick join (the head furthest three pictures after the glove); a heavy one takes
## the soft join and starts earlier - its first 18-20 cm in three pictures, the rest at its own pace. [from_s, soft]
static func start_s(row: Dictionary, move: String, hz: float, sc: float) -> Array:
	var r_peak: float = float(row.get("head_peak_s", 0.0))
	var from: float = maxf(minf(r_peak, float(row.get("head_rel_s", r_peak))) - R.react_peak_s(move), 0.0)
	var curve: Array = row.get("head_g", [])
	if curve.is_empty():
		return [from, false]
	if move != "body_hook" and worst_step(curve, from + 1.0 / R.FILM_HZ, R.JOIN_WAY["quick"], hz) * sc <= R.HEAD_STEP_MAX_M:
		return [from, false]
	var way: Array = R.JOIN_WAY["fold" if move == "body_hook" else "snap"]
	while from > 0.0 and worst_step(curve, from + 1.0 / R.FILM_HZ, way, hz) * sc > R.HEAD_STEP_MAX_M:
		from = maxf(from - 0.5 / R.FILM_HZ, 0.0)
	return [from, true]


## The biggest step of the head in one film picture when the take is joined from the guard at take time `at`
## (`hips`: the take's own hip travel, clip_db hips_g, rides on top when the take moves the body).
static func worst_step(curve: Array, at: float, way: Array, hz: float, hips: Array = []) -> float:
	var worst := 0.0
	var prev := 0.0
	for k in range(1, way.size() + 3):
		var cur: float = (float(way[k - 1]) if k <= way.size() else 1.0) * g_at(curve, at + float(k) / R.FILM_HZ, hz)
		var body: float = 0.0 if hips.is_empty() else maxf(g_at(hips, at + float(k) / R.FILM_HZ, hz) - g_at(hips, at + float(k - 1) / R.FILM_HZ, hz), 0.0)
		worst = maxf(worst, cur - prev + body)
		prev = cur
	return worst


static func g_at(curve: Array, s: float, hz: float) -> float:
	var x: float = clampf(s * hz, 0.0, float(curve.size() - 1))
	var i: int = mini(int(x), curve.size() - 1)
	var k: int = mini(i + 1, curve.size() - 1)
	return lerpf(float(curve[i]), float(curve[k]), x - float(i))


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
	# S531: the cover-up first. pro_block_straight_hit_v2 throws the lead glove over his own crown on the fight bodies
	# (film 9, both critics, def3 #18-#23: "like a man waving"); the census body does not show it.
	var pref := ["pro_idle_to_block", "pro_block_straight_hit_v2", "mc_block_hit", "pro_block_loop", "mc_to_block", "pro_idle_to_block", "mc_block"]
	for n in pref:
		if rows.has(n) and (rows[n].get("drop", []) as Array).is_empty():
			return [n, rows[n]]
	return ["mc_block", rows.get("mc_block", {})]


static func defence(db: Dictionary, rows: Dictionary, kind: String, move: String, from_left: bool, south: bool, quick: bool = true) -> Array:
	var has_fn := func(clip: String) -> bool:
		return rows.has(clip) and (rows[clip].get("drop", []) as Array).is_empty()
	# S531 NO SIDE DODGE (pro_left_dodge / pro_right_dodge step 0.3-0.6 m ACROSS the line: on the fixed side camera the
	# dodger lands in front of or behind the other man and the two melt into one shape (film 9, def2 #53-#68, both
	# critics); they also turned the pair 14-24 deg off side-on and slid the most of any take). A slip is a weave on the
	# spot - the ducks are what both critics call the best thing in the film.
	if kind == "slip":
		kind = "weave"
	var clip: String = BeatClips.defence(kind, move, from_left, south, has_fn)
	# S530 (film 6, coach: "ducking is too deep and too long ... his head at the other man's chest"): the deep weaves
	# (the head 36-41 cm down and round) go under HOOKS; a straight punch is slipped with the quick weave (23 cm, the
	# head beside the glove, 5 cm of dip).
	if quick and kind == "weave" and R.is_straight(move) and has_fn.call(R.WEAVE_STRAIGHT):
		clip = R.WEAVE_STRAIGHT
	if clip != "" and rows.has(clip):
		return [clip, rows[clip]]
	return ["", {}]
