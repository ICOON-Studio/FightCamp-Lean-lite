extends RefCounted
## FILMCOUNT1 - count any marked pattern on a film (the coach's check).
## Given a film (FilmBout.build output) and a claim {when, then}, returns the raw counts
## FilmPattern judges. Pure static; the film's moments and windows are FilmMoments' (split out at collection, S498).

const FilmMoments := preload("res://scripts/rules/FilmMoments.gd")
const FilmPattern := preload("res://scripts/rules/FilmPattern.gd")

static func _is_point_when(when: String) -> bool:
	return when == "jab" or when == "cross" or when == "hook" or when == "combo" or when == "hurt"


static func _is_punch_when(when: String) -> bool:
	return when == "jab" or when == "cross" or when == "hook"


## The raw counts for one claim {when, then}. Uses precomputed data.
static func count_pre(pre: Dictionary, claim: Dictionary, seen_only: bool = false) -> Dictionary:
	var when: String = str(claim.get("when", ""))
	var then: String = str(claim.get("then", ""))
	var b_punches: Array = pre["b"]
	var a_punches: Array = pre["a"]
	var film: Dictionary = pre["film"]

	if then == "fewer":
		return _count_fewer_pre(pre, when)
	if then == "outlanded":
		return _count_outlanded_pre(pre, when)

	return _count_after_pre(pre, when, then, seen_only)


static func _count_after_pre(pre: Dictionary, when: String, then: String, seen_only: bool) -> Dictionary:
	var moments: Array = FilmMoments.moments_from(pre, when)
	var b_punches: Array = pre["b"]
	var a_punches: Array = pre["a"]
	var is_point: bool = _is_point_when(when)

	var after_key: String = ""
	if then == "right_low":
		after_key = "right_low"
	elif then == "lunged":
		after_key = "lunged"
	elif then == "stood":
		after_key = "stood"

	if is_point:
		return _count_after_point_pre(moments, b_punches, a_punches, when, then, after_key, seen_only)
	else:
		return _count_after_window_pre(moments, b_punches, a_punches, then, after_key, seen_only)


static func _count_after_point_pre(moments: Array, b_punches: Array, a_punches: Array, when: String, then: String, after_key: String, seen_only: bool) -> Dictionary:
	var n: int = moments.size()
	var k: int = 0
	var rest_n: int = 0
	var rest_k: int = 0

	var moment_t_set: Dictionary = {}
	for m in moments:
		moment_t_set[float((m as Dictionary)["t"])] = true

	for m in moments:
		var md: Dictionary = m as Dictionary
		var m_t: float = float(md["t"])
		var m_beat: Dictionary = md.get("beat", {})
		var is_b_punch_moment: bool = bool(md.get("is_b_punch", false))

		var fact_ok: bool = _eval_fact(then, after_key, m_beat, m_t, is_b_punch_moment, b_punches, a_punches, seen_only)
		if fact_ok:
			k += 1

	if _is_punch_when(when):
		for bp in b_punches:
			var bpd: Dictionary = bp as Dictionary
			var bp_t: float = float(bpd["t"])
			if moment_t_set.has(bp_t):
				continue
			rest_n += 1
			if _eval_fact_for_rest(then, after_key, bpd["beat"], bp_t, true, b_punches, a_punches, seen_only):
				rest_k += 1
	else:
		for bp in b_punches:
			var bpd: Dictionary = bp as Dictionary
			var bp_t: float = float(bpd["t"])
			if moment_t_set.has(bp_t):
				continue
			if FilmMoments.in_2s_after_any(bp_t, moments):
				continue
			rest_n += 1
			if _eval_fact_for_rest(then, after_key, bpd["beat"], bp_t, false, b_punches, a_punches, seen_only):
				rest_k += 1

	return {"kind": "after", "k": k, "n": n, "rest_k": rest_k, "rest_n": rest_n}


static func _count_after_window_pre(moments: Array, b_punches: Array, a_punches: Array, then: String, after_key: String, seen_only: bool) -> Dictionary:
	var n: int = 0
	var k: int = 0
	var rest_n: int = 0
	var rest_k: int = 0

	for bp in b_punches:
		var bpd: Dictionary = bp as Dictionary
		var bp_t: float = float(bpd["t"])
		var inside: bool = FilmMoments.in_window(bp_t, moments)
		if inside:
			n += 1
			if _eval_fact_for_rest(then, after_key, bpd["beat"], bp_t, true, b_punches, a_punches, seen_only):
				k += 1
		else:
			rest_n += 1
			if _eval_fact_for_rest(then, after_key, bpd["beat"], bp_t, false, b_punches, a_punches, seen_only):
				rest_k += 1

	return {"kind": "after", "k": k, "n": n, "rest_k": rest_k, "rest_n": rest_n}


## S503: a hook or cross she throws inside her own burst (within COMBO_GAP_S of her previous punch: the one-two,
## the two-three, the double hook) is a combination, not a wild swing.
const COMBO_GAP_S := 0.7


static func _is_combo_follow(beat: Dictionary, found: Dictionary) -> bool:
	if str(beat.get("who", "")) != "b":
		return false
	var gap: float = float(found.get("t", 0.0)) - float(beat.get("t", 0.0))
	return gap > 0.0 and gap <= COMBO_GAP_S


static func _eval_fact(then: String, after_key: String, beat: Dictionary, beat_t: float, is_b_punch: bool, b_punches: Array, a_punches: Array, seen_only: bool) -> bool:
	match then:
		"right_low", "lunged", "stood":
			if is_b_punch:
				if seen_only and not bool(beat.get("seen", false)):
					return false
				return str(beat.get("after", "")) == after_key
			else:
				var found: Dictionary = FilmMoments.first_b_punch_after(beat_t, b_punches)
				if found.is_empty():
					return false
				if seen_only and not bool(found.get("seen", false)):
					return false
				return str(found.get("after", "")) == after_key
		"to_body":
			var found: Dictionary = FilmMoments.first_b_punch_after(beat_t, b_punches)
			if found.is_empty():
				return false
			return FilmMoments.target(str(found.get("move", ""))) == "body"
		"wild":
			var found: Dictionary = FilmMoments.first_b_punch_after(beat_t, b_punches)
			if found.is_empty():
				return false
			var move: String = str(found.get("move", ""))
			var pw: String = FilmMoments.punch_word(move)
			if pw != "hook" and pw != "cross":
				return false
			if _is_combo_follow(beat, found):
				return false
			if str(found.get("result", "")) != "misses":
				return false
			if str(found.get("def", "")) != "":
				return false
			return true
		"countered":
			var found: Dictionary = FilmMoments.first_a_landed_after(beat_t, a_punches)
			return not found.is_empty()
	return false


static func _eval_fact_for_rest(then: String, after_key: String, beat: Dictionary, beat_t: float, is_b_punch: bool, b_punches: Array, a_punches: Array, seen_only: bool) -> bool:
	match then:
		"right_low", "lunged", "stood":
			if seen_only and not bool(beat.get("seen", false)):
				return false
			return str(beat.get("after", "")) == after_key
		"to_body":
			# For rest, check if first "b" punch within 2s after this beat has target body
			var found: Dictionary = FilmMoments.first_b_punch_after(beat_t, b_punches)
			if found.is_empty():
				return false
			return FilmMoments.target(str(found.get("move", ""))) == "body"
		"wild":
			# For rest, check if first "b" punch within 2s after this beat is wild
			var found: Dictionary = FilmMoments.first_b_punch_after(beat_t, b_punches)
			if found.is_empty():
				return false
			var move: String = str(found.get("move", ""))
			var pw: String = FilmMoments.punch_word(move)
			if pw != "hook" and pw != "cross":
				return false
			if _is_combo_follow(beat, found):
				return false
			if str(found.get("result", "")) != "misses":
				return false
			if str(found.get("def", "")) != "":
				return false
			return true
		"countered":
			var found: Dictionary = FilmMoments.first_a_landed_after(beat_t, a_punches)
			return not found.is_empty()
	return false


static func _count_fewer_pre(pre: Dictionary, when: String) -> Dictionary:
	var moments: Array = FilmMoments.moments_from(pre, when)
	var b_punches: Array = pre["b"]
	var film: Dictionary = pre["film"]
	var is_point: bool = _is_point_when(when)

	var inside: int = 0
	var inside_min: float = 0.0
	var outside: int = 0
	var outside_min: float = 0.0

	if is_point:
		var windows: Array = []
		for m in moments:
			var mt: float = float((m as Dictionary)["t"])
			windows.append({"t_start": mt, "t_end": mt + 2.0, "round": 0})
		var merged: Array = FilmMoments.merge_windows_generic(windows)
		for w in merged:
			inside_min += (float(w["t_end"]) - float(w["t_start"])) / 60.0
		var rounds: int = int(film.get("rounds", 3))
		var total_min: float = float(rounds) * 3.0
		outside_min = total_min - inside_min
		if outside_min < 0.0:
			outside_min = 0.0
		for bp in b_punches:
			var bpd: Dictionary = bp as Dictionary
			if FilmMoments.in_window_generic(float(bpd["t"]), merged):
				inside += 1
			else:
				outside += 1
	else:
		for w in moments:
			inside_min += (float(w["t_end"]) - float(w["t_start"])) / 60.0
		var rounds: int = int(film.get("rounds", 3))
		var total_min: float = float(rounds) * 3.0
		outside_min = total_min - inside_min
		if outside_min < 0.0:
			outside_min = 0.0
		for bp in b_punches:
			var bpd: Dictionary = bp as Dictionary
			if FilmMoments.in_window(float(bpd["t"]), moments):
				inside += 1
			else:
				outside += 1

	var slowdown: float = 0.9 if when == "last_min" else 1.0
	return {"kind": "fewer", "inside": inside, "inside_min": inside_min, "outside": outside, "outside_min": outside_min, "slowdown": slowdown,
		"films": 1, "one_round": ONE_ROUND_WHENS.has(when)}


static func _count_outlanded_pre(pre: Dictionary, when: String) -> Dictionary:
	var moments: Array = FilmMoments.moments_from(pre, when)
	var a_punches: Array = pre["a"]
	var film: Dictionary = pre["film"]
	var is_point: bool = _is_point_when(when)

	var in_landed: int = 0
	var in_min: float = 0.0
	var out_landed: int = 0
	var out_min: float = 0.0

	# For hurt WHEN, moments are "a" landings - exclude them from inside count to avoid bias
	var exclude_moments: bool = when == "hurt"
	var moment_t_set: Dictionary = {}
	if exclude_moments:
		for m in moments:
			moment_t_set[float((m as Dictionary)["t"])] = true

	if is_point:
		var windows: Array = []
		for m in moments:
			var mt: float = float((m as Dictionary)["t"])
			windows.append({"t_start": mt, "t_end": mt + 2.0, "round": 0})
		var merged: Array = FilmMoments.merge_windows_generic(windows)
		for w in merged:
			in_min += (float(w["t_end"]) - float(w["t_start"])) / 60.0
		var rounds: int = int(film.get("rounds", 3))
		var total_min: float = float(rounds) * 3.0
		out_min = total_min - in_min
		if out_min < 0.0:
			out_min = 0.0
		for ap in a_punches:
			var apd: Dictionary = ap as Dictionary
			var bd: Dictionary = apd["beat"]
			if str(bd.get("result", "")) != "lands":
				continue
			var ap_t: float = float(apd["t"])
			# Exclude moment times for hurt WHEN
			if exclude_moments and moment_t_set.has(ap_t):
				out_landed += 1
			elif FilmMoments.in_window_generic(ap_t, merged):
				in_landed += 1
			else:
				out_landed += 1
	else:
		for w in moments:
			in_min += (float(w["t_end"]) - float(w["t_start"])) / 60.0
		var rounds: int = int(film.get("rounds", 3))
		var total_min: float = float(rounds) * 3.0
		out_min = total_min - in_min
		if out_min < 0.0:
			out_min = 0.0
		for ap in a_punches:
			var apd: Dictionary = ap as Dictionary
			var bd: Dictionary = apd["beat"]
			if str(bd.get("result", "")) != "lands":
				continue
			if FilmMoments.in_window(float(apd["t"]), moments):
				in_landed += 1
			else:
				out_landed += 1

	return {"kind": "outlanded", "in_landed": in_landed, "in_min": in_min, "out_landed": out_landed, "out_min": out_min,
		"films": 1, "one_round": ONE_ROUND_WHENS.has(when)}


## Non-precomputed version for single claims.
static func count(film: Dictionary, claim: Dictionary, seen_only: bool = false) -> Dictionary:
	var pre := FilmMoments.precompute(film)
	return count_pre(pre, claim, seen_only)


## S503: a claim about one round of one film rests on one won-or-lost round (rounds come in clumps), so one
## film can only say "maybe"; two films pooled (two rounds) can pass.
const ONE_ROUND_WHENS := ["round1", "last_min"]


static func judge(counts: Dictionary) -> Dictionary:
	var j: Dictionary = _judge_counts(counts)
	if bool(counts.get("one_round", false)) and int(counts.get("films", 1)) < 2 and str(j.get("word", "")) == "pass":
		j["word"] = "maybe"
	return j


static func _judge_counts(counts: Dictionary) -> Dictionary:
	var kind: String = str(counts.get("kind", ""))
	match kind:
		"after":
			return FilmPattern.after_moment(int(counts["k"]), int(counts["n"]), int(counts["rest_k"]), int(counts["rest_n"]))
		"fewer":
			return FilmPattern.throws_fewer(int(counts["inside"]), float(counts["inside_min"]), int(counts["outside"]), float(counts["outside_min"]), float(counts["slowdown"]))
		"outlanded":
			return FilmPattern.outlanded(int(counts["in_landed"]), float(counts["in_min"]), int(counts["out_landed"]), float(counts["out_min"]))
	return {"word": "nothing", "k": 0, "n": 0, "e": 0.0, "z": 0.0}


static func pooled(a: Dictionary, b: Dictionary) -> Dictionary:
	return FilmPattern.pool(a, b)


static func check(films: Array, claim: Dictionary) -> Dictionary:
	if films.is_empty():
		return {"word": "nothing", "k": 0, "n": 0, "e": 0.0, "z": 0.0, "films": 0}
	var pre := FilmMoments.precompute(films[0] as Dictionary)
	var counts: Dictionary = count_pre(pre, claim)
	for i in range(1, films.size()):
		var pre2 := FilmMoments.precompute(films[i] as Dictionary)
		var c2: Dictionary = count_pre(pre2, claim)
		counts = pooled(counts, c2)
	var j: Dictionary = judge(counts)
	j["films"] = films.size()
	return j


## Check all claims on a precomputed film. Returns array of {claim, result}.
static func check_all_pre(pre: Dictionary, claims: Array) -> Array:
	var out: Array = []
	for claim in claims:
		var cl: Dictionary = claim as Dictionary
		var counts: Dictionary = count_pre(pre, cl)
		var j: Dictionary = judge(counts)
		j["films"] = 1
		out.append({"claim": cl, "result": j})
	return out
