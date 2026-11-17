extends RefCounted
## FIGHTPLAYER2 phase 2 (FP2CHOREO1): the choreographer plans one exchange of the 3D fight before it plays.
## Pure: no scene, no node. Reads clip_db.json through ClipCensus.
## The plan sees a whole 30-second exchange before it plays (scope 3b-3d, 8).

const R := preload("res://scripts/fight3d/v2/ChoreoRules.gd")
const ClipCensus := preload("res://scripts/fight3d/v2/ClipCensus.gd")
const BeatClips := preload("res://scripts/fight3d/BeatClips.gd")


## Plan one exchange. beats: time-ordered input (never mutated). db: parsed clip_db.json.
## opts: {t0, t1, gap0, seed, south: {a: bool, b: bool}}.
static func plan(beats: Array, db: Dictionary, opts: Dictionary) -> Dictionary:
	var t0: float = float(opts.get("t0", 0.0))
	var t1: float = float(opts.get("t1", 30.0))
	var gap0: float = float(opts.get("gap0", R.REST_M))
	var seed: int = int(opts.get("seed", 0))
	var south: Dictionary = opts.get("south", {"a": false, "b": false})
	var rng := RandomNumberGenerator.new()
	rng.seed = seed
	var rows: Dictionary = db.get("rows", {})
	var head_from_hips: float = float(db.get("meta", {}).get("head_from_hips_m", 0.023))
	var out_beats: Array = []
	var ev_a: Array = []
	var ev_b: Array = []
	var gap_anc: Array = [[t0, gap0, ""]]
	var counts := {"a": {"thrown": 0, "landed": 0, "cut": 0}, "b": {"thrown": 0, "landed": 0, "cut": 0}}
	var log: Array = []
	var stun_until := {"a": -1.0, "b": -1.0}
	var last_two := {"a": ["", ""], "b": ["", ""]}
	var ctrl_until := {"a": -1.0, "b": -1.0}
	var has_fn := func(clip: String) -> bool:
		return rows.has(clip) and (rows[clip].get("drop", []) as Array).is_empty()
	for beat in beats:
		var who: String = str(beat.get("who", "a"))
		var other: String = "b" if who == "a" else "a"
		var move: String = str(beat.get("move", ""))
		var result: String = str(beat.get("result", ""))
		var def: String = str(beat.get("def", ""))
		var big: bool = bool(beat.get("big", false))
		var bt: float = float(beat.get("t", 0.0))
		var ob: Dictionary = beat.duplicate()
		var evs := ev_a if who == "a" else ev_b
		var o_evs := ev_b if who == "a" else ev_a
		if not R.is_punch(move):
			_handle_non_punch(ob, move, bt, who, gap_anc, evs, ctrl_until, log)
			out_beats.append(ob)
			continue
		# --- PUNCH ---
		counts[who]["thrown"] = int(counts[who]["thrown"]) + 1
		if result == "lands":
			counts[who]["landed"] = int(counts[who]["landed"]) + 1
		var base_impact: float = R.impact_s_for(move)
		var base_ct: float = bt + base_impact
		var in_stun: bool = base_ct < stun_until[who]
		# R5: Check if step needed BEFORE selecting take
		var gap_before: float = _gap_at(gap_anc, base_ct - 0.6)
		var needs_step: bool = gap_before >= R.CREEP_M
		if needs_step:
			# Find best take to determine target gap
			var temp_cands: Array = ClipCensus.takes_for(db, move, gap_before)
			var target_gap: float = R.CREEP_M
			if not temp_cands.is_empty():
				target_gap = float(rows[str(temp_cands[0])].get("contact_gap_m", R.CREEP_M))
			var step_t: float = maxf(base_ct - 0.3, ctrl_until[who])
			gap_anc.append([base_ct - 0.3, target_gap, who])
			_add_ev(evs, {"t": step_t, "clip": "", "kind": "step", "part": "whole", "from_s": 0.0, "join_s": R.join_for("guard"), "control_t": base_ct})
			ctrl_until[who] = maxf(ctrl_until[who], base_ct)
		var wanted_gap: float = _gap_at(gap_anc, base_ct)
		var cands: Array = _candidates(db, rows, move, big, wanted_gap, last_two[who], who, log)
		var take_name: String = ""
		var take_row: Dictionary = {}
		var pgap: float = wanted_gap
		# R8: miss SHORT, blocked LONG
		if result == "misses" and def == "":
			if not cands.is_empty():
				take_name = str(cands[0])
				take_row = rows.get(take_name, {})
				pgap = float(take_row.get("contact_gap_m", wanted_gap)) + _rng_range(rng, 0.15, 0.30)
			else:
				log.append("misfit: %s %s miss no takes" % [who, move])
		elif result == "blocked":
			if not cands.is_empty():
				take_name = str(cands[0])
				take_row = rows.get(take_name, {})
				pgap = float(take_row.get("contact_gap_m", wanted_gap)) + _rng_range(rng, 0.05, 0.10)
			else:
				log.append("misfit: %s %s blocked no takes" % [who, move])
		else:
			var sel := _pick_take(cands, rows, move, wanted_gap)
			take_name = sel[0]
			take_row = sel[1]
			if take_name == "" and not cands.is_empty():
				take_name = str(cands[0])
				take_row = rows.get(take_name, {})
				log.append("misfit: %s %s gap %.2f no fit" % [who, move, wanted_gap])
		# R9: heads apart
		if not take_row.is_empty():
			var ha := _heads_apart(pgap, take_row, head_from_hips, cands, rows)
			if ha[0] != "":
				take_name = ha[0]
				take_row = ha[1]
			elif ha[2]:
				pgap = ha[3]
				log.append("heads: %s %s gap -> %.2f" % [who, move, pgap])
		var contact_s: float = float(take_row.get("contact_s", base_impact))
		var from_s: float = float(take_row.get("start_s", 0.0))
		var contact_t: float = base_ct
		# R7: stun
		if in_stun:
			var stun_end: float = stun_until[who]
			var min_ct: float = stun_end + (contact_s - from_s)
			if contact_t < min_ct:
				var slide: float = min_ct - contact_t
				if slide <= R.SLIDE_MAX_S:
					contact_t = min_ct
					log.append("slide: %s %s +%.2f (stun)" % [who, move, slide])
				elif result != "lands":
					counts[who]["cut"] = int(counts[who]["cut"]) + 1
					counts[who]["thrown"] = int(counts[who]["thrown"]) - 1
					log.append("cut: %s %s (stun)" % [who, move])
					_fill_ob(ob, bt, "", 0.0, base_ct, wanted_gap, 0.0, true, "", "", "", "cut:stun")
					out_beats.append(ob)
					continue
				else:
					contact_t = base_ct + R.SLIDE_MAX_S
					log.append("overlap: %s %s landed in stun" % [who, move])
		contact_t = clampf(contact_t, t0, t1)
		# R2: t_play, from_s
		var t_play: float = contact_t - (contact_s - from_s)
		if t_play < ctrl_until[who]:
			var need: float = from_s + (ctrl_until[who] - t_play)
			var max_fs: float = contact_s - R.WIND_MIN_S
			from_s = clampf(need, float(take_row.get("start_s", 0.0)), max_fs)
			t_play = contact_t - (contact_s - from_s)
		from_s = clampf(from_s, float(take_row.get("start_s", 0.0)), maxf(0.0, contact_s - R.WIND_MIN_S))
		t_play = contact_t - (contact_s - from_s)
		var ik_m: float = 0.0
		if R.is_straight(move) and take_row.has("contact_gap_m"):
			ik_m = minf(absf(pgap - float(take_row.get("contact_gap_m", 0.0))), R.IK_MAX_M)
		gap_anc.append([contact_t, pgap, who])
		# Punch event - ensure it respects control
		var punch_t: float = maxf(t_play, ctrl_until[who])
		var part: String = "upper" if R.is_straight(move) else "whole"
		_add_ev(evs, {"t": punch_t, "clip": take_name, "kind": "punch", "part": part, "from_s": from_s, "join_s": R.join_for("punch"), "control_t": contact_t + R.CONTROL_S})
		ctrl_until[who] = contact_t + R.CONTROL_S
		# R6/R8: reaction / block / defence
		var react_name: String = ""
		var react_part: String = ""
		var defence_name: String = ""
		if result == "lands":
			var ri := _react(db, rows, move, big, R.is_left_hand(move), rng, head_from_hips, log)
			react_name = ri[0]
			var rrow: Dictionary = ri[1]
			react_part = ri[2]
			# Reaction starts at contact_t, but respect other's control
			var react_t: float = maxf(contact_t, ctrl_until[other])
			var rctrl: float = react_t + float(rrow.get("back_s", 0.5))
			_add_ev(o_evs, {"t": react_t, "clip": react_name, "kind": "reaction", "part": react_part, "from_s": 0.0, "join_s": R.join_for("reaction"), "control_t": rctrl})
			ctrl_until[other] = maxf(ctrl_until[other], rctrl)
			stun_until[other] = maxf(stun_until[other], contact_t + R.stun_for(ri[3]))
			if react_part == "whole":
				gap_anc.append([contact_t + 0.3, pgap + float(rrow.get("hips_max_m", 0.0)), other])
		elif result == "blocked":
			var bi := _block(db, rows)
			defence_name = bi[0]
			var brow: Dictionary = bi[1]
			var block_t: float = maxf(contact_t, ctrl_until[other])
			var bctrl: float = block_t + float(brow.get("back_s", 0.5))
			_add_ev(o_evs, {"t": block_t, "clip": defence_name, "kind": "block", "part": "upper", "from_s": 0.0, "join_s": R.join_for("block"), "control_t": bctrl})
			ctrl_until[other] = maxf(ctrl_until[other], bctrl)
		elif def != "" and def != "block":
			var di := _defence(db, rows, def, move, R.is_left_hand(move), bool(south.get(other, false)))
			defence_name = di[0]
			var drow: Dictionary = di[1]
			var dpeak: float = float(drow.get("head_peak_s", 0.5))
			var dt: float = maxf(contact_t - dpeak, ctrl_until[other])
			var dctrl: float = dt + float(drow.get("back_s", 0.5))
			_add_ev(o_evs, {"t": dt, "clip": defence_name, "kind": "defence", "part": "upper", "from_s": 0.0, "join_s": R.join_for("defence"), "control_t": dctrl})
			ctrl_until[other] = maxf(ctrl_until[other], dctrl)
		last_two[who] = [last_two[who][1], take_name]
		_fill_ob(ob, t_play, take_name, from_s, contact_t, pgap, ik_m, false, react_name, react_part, defence_name, _why(result, def, take_name))
		out_beats.append(ob)
	_finalize_gap(gap_anc, t0, t1)
	_add_pivots(ev_a, ev_b, gap_anc, t0, t1, rng, ctrl_until)
	ev_a.sort_custom(func(a, b): return float(a["t"]) < float(b["t"]))
	ev_b.sort_custom(func(a, b): return float(a["t"]) < float(b["t"]))
	# Post-process: ensure no overlaps
	_fix_overlaps(ev_a)
	_fix_overlaps(ev_b)
	return {"beats": out_beats, "tracks": {"a": ev_a, "b": ev_b}, "gap": gap_anc, "counts": counts, "log": log}


# --- Helpers ---

static func _gap_at(anc: Array, t: float) -> float:
	if anc.is_empty():
		return R.REST_M
	if t <= float(anc[0][0]):
		return float(anc[0][1])
	if t >= float(anc[-1][0]):
		return float(anc[-1][1])
	for i in range(1, anc.size()):
		var t0: float = float(anc[i - 1][0])
		var t1: float = float(anc[i][0])
		if t <= t1:
			var g0: float = float(anc[i - 1][1])
			var g1: float = float(anc[i][1])
			var f: float = 0.0 if t1 == t0 else (t - t0) / (t1 - t0)
			return lerpf(g0, g1, f)
	return float(anc[-1][1])


static func _add_ev(evs: Array, ev: Dictionary) -> void:
	evs.append(ev)


static func _fix_overlaps(evs: Array) -> void:
	# Ensure no overlaps: each event's t >= previous event's control_t
	for i in range(1, evs.size()):
		var prev_ctrl: float = float(evs[i - 1]["control_t"])
		var cur_t: float = float(evs[i]["t"])
		if cur_t < prev_ctrl - 0.001:
			# Adjust current event's t
			var diff: float = prev_ctrl - cur_t
			evs[i]["t"] = prev_ctrl
			evs[i]["control_t"] = float(evs[i]["control_t"]) + diff


static func _handle_non_punch(ob: Dictionary, move: String, bt: float, who: String, gap_anc: Array, evs: Array, ctrl_until: Dictionary, log: Array) -> void:
	if move == "step_in":
		gap_anc.append([bt, R.CREEP_M, who])
	elif move == "step_out":
		gap_anc.append([bt, R.REST_M, who])
	if move in R.PASS_MOVES:
		var pass_t: float = maxf(bt, float(ctrl_until[who]))
		_add_ev(evs, {"t": pass_t, "clip": "", "kind": "pass", "part": "whole", "from_s": 0.0, "join_s": 0.0, "control_t": pass_t})
		ctrl_until[who] = pass_t
	ob["t_play"] = bt
	ob["take"] = ""
	ob["from_s"] = 0.0
	ob["contact_t"] = bt
	ob["gap"] = _gap_at(gap_anc, bt)
	ob["ik_m"] = 0.0
	ob["cut"] = false
	ob["react"] = ""
	ob["react_part"] = ""
	ob["defence"] = ""
	ob["why"] = move


static func _fill_ob(ob: Dictionary, t_play: float, take: String, from_s: float, contact_t: float, gap: float, ik_m: float, cut: bool, react: String, react_part: String, defence: String, why: String) -> void:
	ob["t_play"] = t_play
	ob["take"] = take
	ob["from_s"] = from_s
	ob["contact_t"] = contact_t
	ob["gap"] = gap
	ob["ik_m"] = ik_m
	ob["cut"] = cut
	ob["react"] = react
	ob["react_part"] = react_part
	ob["defence"] = defence
	ob["why"] = why


static func _why(result: String, def: String, take: String) -> String:
	if result == "lands":
		return "lands %s" % take
	if result == "blocked":
		return "blocked %s" % take
	if def != "":
		return "%s %s" % [def, take]
	return "%s %s" % [result, take]


static func _rng_range(rng: RandomNumberGenerator, lo: float, hi: float) -> float:
	return lo + (hi - lo) * rng.randf()


static func _candidates(db: Dictionary, rows: Dictionary, move: String, big: bool, gap: float, lt: Array, who: String, log: Array) -> Array:
	var cands: Array = ClipCensus.takes_for(db, move, gap)
	if big:
		var hard: Array = cands.filter(func(n): return str(rows[n].get("form", "")) in ["hard", "hard_ft", "special"])
		if not hard.is_empty():
			cands = hard
	if lt.size() >= 2 and lt[0] == lt[1] and lt[0] != "":
		var alt: Array = cands.filter(func(n): return n != lt[0])
		if not alt.is_empty():
			cands = alt
		else:
			log.append("misfit: %s %s no alt to %s" % [who, move, lt[0]])
	return cands


static func _pick_take(cands: Array, rows: Dictionary, move: String, gap: float) -> Array:
	var fit_bar: float = R.gap_fit_for(move)
	for cn in cands:
		var cr: Dictionary = rows.get(str(cn), {})
		var cg: float = float(cr.get("contact_gap_m", 0.0))
		var diff: float = absf(gap - cg)
		if R.is_straight(move):
			if diff <= fit_bar and diff <= R.IK_MAX_M:
				return [cn, cr]
		else:
			if diff <= fit_bar:
				return [cn, cr]
	return ["", {}]


static func _heads_apart(pgap: float, trow: Dictionary, hfh: float, cands: Array, rows: Dictionary) -> Array:
	var hfm: float = float(trow.get("head_fwd_m", 0.0))
	if pgap - hfm - hfh >= R.HEADS_APART_M:
		return ["", {}, false, 0.0]
	for cn in cands:
		var cr: Dictionary = rows.get(str(cn), {})
		if cr == trow:
			continue
		var chfm: float = float(cr.get("head_fwd_m", 0.0))
		if pgap - chfm - hfh >= R.HEADS_APART_M:
			return [cn, cr, false, 0.0]
	var need: float = R.HEADS_APART_M + hfm + hfh
	if need > pgap:
		return ["", {}, true, need]
	return ["", {}, false, 0.0]


static func _react(db: Dictionary, rows: Dictionary, move: String, big: bool, from_left: bool, rng: RandomNumberGenerator, hfh: float, log: Array) -> Array:
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


static func _block(db: Dictionary, rows: Dictionary) -> Array:
	var pref := ["pro_block_straight_hit_v2", "mc_block_hit", "pro_block_loop", "mc_to_block", "pro_idle_to_block", "mc_block"]
	for n in pref:
		if rows.has(n) and (rows[n].get("drop", []) as Array).is_empty():
			return [n, rows[n]]
	return ["mc_block", rows.get("mc_block", {})]


static func _defence(db: Dictionary, rows: Dictionary, kind: String, move: String, from_left: bool, south: bool) -> Array:
	var has_fn := func(clip: String) -> bool:
		return rows.has(clip) and (rows[clip].get("drop", []) as Array).is_empty()
	var clip: String = BeatClips.defence(kind, move, from_left, south, has_fn)
	if clip != "" and rows.has(clip):
		return [clip, rows[clip]]
	return ["", {}]


static func _finalize_gap(anc: Array, t0: float, t1: float) -> void:
	# Add quiet-period and burst-end anchors
	if anc.is_empty():
		anc.append([t0, R.REST_M, ""])
		anc.append([t1, R.REST_M, ""])
		return
	# Collect contact times
	var contacts: Array = []
	for a in anc:
		if str(a[2]) != "":
			contacts.append(float(a[0]))
	contacts.sort()
	# After last contact in a burst, return to rest
	if not contacts.is_empty():
		var last_ct: float = float(contacts[-1])
		anc.append([last_ct + R.LEAVE_S, R.REST_M, ""])
		# Quiet periods
		for i in range(1, contacts.size()):
			var dt: float = float(contacts[i]) - float(contacts[i - 1])
			if dt > 3.0:
				var mid: float = (float(contacts[i - 1]) + float(contacts[i])) * 0.5
				anc.append([mid, R.REST_M, ""])
	anc.append([t1, R.REST_M, ""])
	# Sort by time
	anc.sort_custom(func(a, b): return float(a[0]) < float(b[0]))
	# Enforce MIN_GAP_M
	for a in anc:
		a[1] = maxf(float(a[1]), R.MIN_GAP_M)


static func _add_pivots(ev_a: Array, ev_b: Array, anc: Array, t0: float, t1: float, rng: RandomNumberGenerator, ctrl_until: Dictionary) -> void:
	# Find quiet spells and add pivot events
	var contacts: Array = []
	for a in anc:
		if str(a[2]) != "":
			contacts.append(float(a[0]))
	contacts.sort()
	var windows: Array = []
	if contacts.is_empty():
		windows.append([t0, t1])
	else:
		if float(contacts[0]) - t0 >= R.QUIET_MIN_S:
			windows.append([t0, float(contacts[0])])
		for i in range(1, contacts.size()):
			var dt: float = float(contacts[i]) - float(contacts[i - 1])
			if dt >= R.QUIET_MIN_S:
				windows.append([float(contacts[i - 1]), float(contacts[i])])
		if t1 - float(contacts[-1]) >= R.QUIET_MIN_S:
			windows.append([float(contacts[-1]), t1])
	# Add pivots every PIVOT_EVERY_S
	var need_pivot_at: float = t0 + R.PIVOT_EVERY_S
	for w in windows:
		var ws: float = float(w[0])
		var we: float = float(w[1])
		while need_pivot_at < we:
			if need_pivot_at > ws + 0.2:
				var who: String = "a" if rng.randf() < 0.5 else "b"
				var evs := ev_a if who == "a" else ev_b
				var pivot_t: float = maxf(need_pivot_at, float(ctrl_until[who]))
				_add_ev(evs, {"t": pivot_t, "clip": "", "kind": "pivot", "part": "whole", "from_s": 0.0, "join_s": 0.0, "control_t": pivot_t + 0.5})
				ctrl_until[who] = pivot_t + 0.5
			need_pivot_at += R.PIVOT_EVERY_S
