extends RefCounted
## FilmBout: rebuilds an opponent's past bout punch by punch for film night.
## Same opponent + same bout day = the same bout, punch for punch. The scout's
## tape shows the fighter's real game: their style, their habits on their triggers,
## their best punch landing most. Pure static; three preloads.

const RoundScript := preload("res://scripts/rules/RoundScript.gd")
const HabitBeats := preload("res://scripts/rules/HabitBeats.gd")
const Exchanges := preload("res://scripts/rules/Exchanges.gd")
const RoundStyle := preload("res://scripts/rules/RoundStyle.gd")

const AFTER_KEYS: Array = ["guard_up", "threw_on", "right_low", "left_low", "stood", "lunged"]
const AFTER_BASE: Array = [0.45, 0.15, 0.12, 0.10, 0.10, 0.08]
const A_MODES: Array = ["press", "range", "counter"]


## Rebuilds a past bout. opp = opponent profile (id, style, threat, habits).
## row = one past-bout row (d, vs, win, how). Returns {exchanges, rounds, won, how}.
static func build(opp: Dictionary, row: Dictionary, rounds: int = 3) -> Dictionary:
	var seed: int = hash(str(opp.get("id", "")) + ":" + str(row.get("d", 0)))
	var rng := RandomNumberGenerator.new()
	rng.seed = seed
	var style: String = str(opp.get("style", "Boxer-puncher"))
	var threat: String = str(opp.get("threat", ""))
	var weak: String = str(opp.get("weak", "")).to_lower()
	var habits: Array = (opp.get("habits", []) as Array).duplicate()
	var a_style: String = "Boxer-puncher"
	var b_wins_bout: bool = bool(row.get("win", false))
	var how: String = str(row.get("how", ""))
	var is_stop: bool = how.contains("stopped")
	var stop_r: int = _parse_stoppage_round(how)
	var round_a_wins: Array = _decide_round_wins(b_wins_bout, how, is_stop, stop_r, rounds, rng)
	# The opponent throws her real mix (RoundStyle: rating, style, threat words), not the generic one.
	var profiles: Dictionary = {"b": RoundStyle.from_opponent(opp)}
	# FILMCOUNT1: habits minus the two hurt habits (FilmBout fires those itself after a big landings)
	var non_hurt_habits: Array = []
	for h in habits:
		var hs: String = str(h)
		if hs != "digs_body_when_hurt" and hs != "loads_up_when_hurt":
			non_hurt_habits.append(hs)
	var has_digs_body: bool = habits.has("digs_body_when_hurt")
	var has_loads_up: bool = habits.has("loads_up_when_hurt")
	# Weakness against pressure?
	var weak_pressure: bool = weak.contains("backed up") or weak.contains("backs straight") or weak.contains("pressure")
	var exchanges: Array = []
	for r in rounds:
		var rn: int = r + 1
		if is_stop and rn > stop_r:
			break
		var ex_n: int = Exchanges.EXCHANGES
		if is_stop and rn == stop_r:
			ex_n = rng.randi_range(2, 5)
		var a_wr: bool = r < round_a_wins.size() and bool(round_a_wins[r])
		var ex_w: Array = _decide_ex_winners(a_wr, ex_n, rng)
		var a_big_count_rn: int = 0  # track "a" big landings per round (max 2)
		for i in ex_n:
			var mode: String = _roll_mode(style, rng)
			var place: int = _place_for_mode(mode, rng)
			var pinned: bool = mode == "press" and rng.randf() < 0.125
			var a_won: bool = bool(ex_w[i])
			var rd: Dictionary = {"n": rn, "won": a_won, "mine": 65.0 if a_won else 55.0,
				"theirs": 55.0 if a_won else 65.0, "corner": "", "lines": []}
			var ex_seed: int = rng.randi()
			var script: Dictionary = RoundScript.build(rd, a_style, style, Exchanges.EX_SECONDS, ex_seed, profiles)
			_bias_threat(script, threat, rng)   # before the habits, so a habit's own punch is never rewritten
			HabitBeats.apply(script, {"a": [], "b": non_hurt_habits}, {}, rng)
			_apply_after_facts(script, habits, rng)
			_apply_big(script, threat, rng)
			_apply_a_big(script, rng, a_big_count_rn)
			# FILMCOUNT1: hurt habits fire after "a" big landings
			if has_digs_body or has_loads_up:
				a_big_count_rn = _apply_hurt_habits(script, has_digs_body, has_loads_up, a_big_count_rn, rn)
			_apply_slowdown(script, habits, rn, i, rng)
			var landed: Array = [0, 0]
			for beat in script["beats"]:
				if str(beat["result"]) == "lands":
					if str(beat["who"]) == "a":
						landed[0] = int(landed[0]) + 1
					elif str(beat["who"]) == "b":
						landed[1] = int(landed[1]) + 1
			# FILMCOUNT1: a_mode drawn AFTER everything else for this exchange
			var a_mode: String = str(A_MODES[rng.randi_range(0, A_MODES.size() - 1)])
			# FILMCOUNT1: weakness against pressure - turn up to 2 a misses/blocked into lands
			if weak_pressure and a_mode == "press":
				_apply_weakness_pressure(script, landed)
			exchanges.append({"i": i, "round": rn, "at": int(Exchanges.EX_SECONDS) * i,
				"mode": mode, "a_mode": a_mode, "place": place, "pinned": pinned,
				"won": a_won, "landed": landed, "beats": script["beats"]})
	return {"exchanges": exchanges, "rounds": rounds, "won": b_wins_bout, "how": how}


## {punch move: landed count} for one corner.
static func clean_counts(bout: Dictionary, who: String) -> Dictionary:
	var out: Dictionary = {}
	for ex in bout["exchanges"]:
		for beat in (ex as Dictionary)["beats"]:
			var bd: Dictionary = beat as Dictionary
			if str(bd["who"]) != who or str(bd["result"]) != "lands" or not _is_punch(str(bd["move"])):
				continue
			var mv: String = str(bd["move"])
			out[mv] = int(out.get(mv, 0)) + 1
	return out


## {mode: exchange count}.
static func mode_counts(bout: Dictionary) -> Dictionary:
	var out: Dictionary = {}
	for ex in bout["exchanges"]:
		var m: String = str((ex as Dictionary)["mode"])
		out[m] = int(out.get(m, 0)) + 1
	return out


# --- internal ---

static func _is_punch(move: String) -> bool:
	return move != "step_in" and move != "step_out" and move != "tired" and move != "count" and move != "slip" and move != "clinch" and move != "inside"


static func _parse_stoppage_round(how: String) -> int:
	var idx: int = how.find("round ")
	if idx < 0:
		return 0
	return int(how.substr(idx + 6))


static func _decide_round_wins(b_wins: bool, how: String, is_stop: bool, stop_r: int, rounds: int, rng: RandomNumberGenerator) -> Array:
	var out: Array = []
	if is_stop:
		for r in rounds:
			if r + 1 > stop_r:
				break
			out.append(not b_wins)
		return out
	var scores: Array = _parse_score(how)
	var win_n: int = int(scores[0])
	var lose_n: int = int(scores[1])
	if b_wins:
		var a_n: int = lose_n
		var picks: Array = _pick_n(a_n, rounds, rng)
		for r in rounds:
			out.append(picks.has(r))
	else:
		var b_n: int = lose_n
		var picks: Array = _pick_n(b_n, rounds, rng)
		for r in rounds:
			out.append(not picks.has(r))
	return out


static func _parse_score(how: String) -> Array:
	var parts: Array = how.split(", ")
	if parts.size() < 2:
		return [3, 0]
	var sc: String = str(parts[parts.size() - 1])
	var ab: Array = sc.split("-")
	if ab.size() < 2:
		return [3, 0]
	return [int(ab[0]), int(ab[1])]


static func _pick_n(n: int, total: int, rng: RandomNumberGenerator) -> Array:
	var idx: Array = []
	for i in total:
		idx.append(i)
	for i in range(idx.size() - 1, 0, -1):
		var j: int = rng.randi_range(0, i)
		var tmp = idx[i]
		idx[i] = idx[j]
		idx[j] = tmp
	return idx.slice(0, n)


static func _decide_ex_winners(a_wr: bool, count: int, rng: RandomNumberGenerator) -> Array:
	var out: Array = []
	var win_n: int = maxi(count / 2 + 1, int(ceil(float(count) * 0.6)))
	win_n = mini(win_n, count)
	var picks: Array = _pick_n(win_n, count, rng)
	for i in count:
		if a_wr:
			out.append(picks.has(i))
		else:
			out.append(not picks.has(i))
	return out


static func _roll_mode(style: String, rng: RandomNumberGenerator) -> String:
	if not Exchanges.MODE_I.has(style):
		var modes: Array = ["press", "range", "counter", "loadup"]
		return str(modes[rng.randi_range(0, modes.size() - 1)])
	var names: Array = Exchanges.MODE_I[style]
	var weights: Array = Exchanges.MODE_V[style]
	var total: float = 0.0
	for w in weights:
		total += float(w)
	var roll: float = rng.randf() * total
	for i in names.size():
		roll -= float(weights[i])
		if roll <= 0.0:
			return str(names[i])
	return str(names[0])


static func _place_for_mode(mode: String, rng: RandomNumberGenerator) -> int:
	var r: float = rng.randf()
	if mode == "press" or mode == "loadup":
		return 2 if r < 0.6 else (1 if r < 0.85 else 0)
	if mode == "range":
		return 0 if r < 0.6 else (1 if r < 0.85 else 2)
	if mode == "counter":
		return 1 if r < 0.6 else (0 if r < 0.85 else 2)
	return rng.randi_range(0, 2)


static func _apply_after_facts(script: Dictionary, habits: Array, rng: RandomNumberGenerator) -> void:
	var beats: Array = script["beats"]
	var has_drops: bool = habits.has("drops_right_after_jab")
	var has_lunges: bool = habits.has("lunges_with_jab")
	var has_admires: bool = habits.has("admires_her_work")
	var b_land_times: Array = []
	for i in beats.size():
		var bd: Dictionary = beats[i]
		if str(bd["who"]) != "b" or not _is_punch(str(bd["move"])):
			continue
		var rates: Array = AFTER_BASE.duplicate()
		var mv: String = str(bd["move"])
		if has_drops and mv == "jab":
			rates[2] = float(rates[2]) + 0.30
			rates[0] = maxf(0.0, float(rates[0]) - 0.30)
		if has_lunges and mv == "jab":
			rates[5] = float(rates[5]) + 0.30
			rates[0] = maxf(0.0, float(rates[0]) - 0.30)
		if has_admires:
			var t: float = float(bd["t"])
			var second: bool = false
			for pt in b_land_times:
				if t - float(pt) <= 1.5:
					second = true
					break
			if second:
				rates[4] = float(rates[4]) + 0.45
				rates[0] = maxf(0.0, float(rates[0]) - 0.45)
		if str(bd["result"]) == "lands":
			b_land_times.append(float(bd["t"]))
		bd["after"] = _roll_after(rates, rng)
		bd["seen"] = rng.randf() < (2.0 / 3.0)


static func _roll_after(rates: Array, rng: RandomNumberGenerator) -> String:
	var total: float = 0.0
	for r in rates:
		total += float(r)
	var roll: float = rng.randf() * total
	for i in AFTER_KEYS.size():
		roll -= float(rates[i])
		if roll <= 0.0:
			return str(AFTER_KEYS[i])
	return str(AFTER_KEYS[0])


static func _bias_threat(script: Dictionary, threat: String, rng: RandomNumberGenerator) -> void:
	if threat == "":
		return
	for bd in script["beats"]:
		if str(bd["who"]) != "b" or not _is_punch(str(bd["move"])):
			continue
		if str(bd["move"]) == threat or str(bd["move"]) == "jab":
			continue   # the jab stays a jab: the jab habits fire off it
		if rng.randf() < 0.5:
			bd["move"] = threat


static func _apply_big(script: Dictionary, threat: String, rng: RandomNumberGenerator) -> void:
	for bd in script["beats"]:
		if str(bd["who"]) != "b" or str(bd["result"]) != "lands" or not _is_punch(str(bd["move"])):
			continue
		var thresh: float = 0.5 if (threat != "" and str(bd["move"]) == threat) else (1.0 / 6.0)
		bd["big"] = rng.randf() < thresh


## FILMCOUNT1: mark "a" landing big with p 1/12.
static func _apply_a_big(script: Dictionary, rng: RandomNumberGenerator, already_big: int) -> void:
	for bd in script["beats"]:
		if str(bd["who"]) != "a" or str(bd["result"]) != "lands" or not _is_punch(str(bd["move"])):
			continue
		bd["big"] = rng.randf() < (1.0 / 12.0)


## FILMCOUNT1: hurt habits fire after "a" big landings (at most 2 per round total).
## digs_body -> next "b" punch within 2s becomes "body_hook"
## loads_up -> next "b" punch within 2s becomes "lead_hook", result "misses", def ""
## Returns updated a_big_count for the round.
static func _apply_hurt_habits(script: Dictionary, has_digs: bool, has_loads: bool, a_big_count: int, rn: int) -> int:
	var beats: Array = script["beats"]
	var digs_fired: int = 0
	var loads_fired: int = 0
	for i in beats.size():
		var bd: Dictionary = beats[i]
		if str(bd["who"]) != "a" or str(bd["result"]) != "lands" or not bool(bd.get("big", false)):
			continue
		if not _is_punch(str(bd["move"])):
			continue
		a_big_count += 1
		if a_big_count > 2:
			break
		var a_t: float = float(bd["t"])
		# Find next "b" punch within 2s
		for j in range(i + 1, beats.size()):
			var nb: Dictionary = beats[j]
			if float(nb["t"]) - a_t > 2.0:
				break
			if str(nb["who"]) != "b" or not _is_punch(str(nb["move"])):
				continue
			if has_digs and digs_fired < 2:
				nb["move"] = "body_hook"
				nb["habit"] = "digs_body_when_hurt"
				digs_fired += 1
				break
			elif has_loads and loads_fired < 2:
				nb["move"] = "lead_hook"
				nb["result"] = "misses"
				nb["def"] = ""
				nb["habit"] = "loads_up_when_hurt"
				loads_fired += 1
				break
	return a_big_count


## FILMCOUNT1: weakness against pressure - turn up to 2 "a" misses/blocked into lands.
static func _apply_weakness_pressure(script: Dictionary, landed: Array) -> void:
	var turned: int = 0
	for bd in script["beats"]:
		if turned >= 2:
			break
		if str(bd["who"]) != "a" or not _is_punch(str(bd["move"])):
			continue
		var result: String = str(bd["result"])
		if result == "misses" or result == "blocked":
			bd["result"] = "lands"
			bd["def"] = ""
			landed[0] = int(landed[0]) + 1
			turned += 1


static func _apply_slowdown(script: Dictionary, habits: Array, rn: int, ex_i: int, rng: RandomNumberGenerator) -> void:
	var beats: Array = script["beats"]
	var has_fades: bool = habits.has("fades_late")
	var has_slow: bool = habits.has("slow_starter")
	var late: bool = ex_i >= 4
	var keep: Array = []
	for bd in beats:
		if not _is_punch(str(bd["move"])):
			keep.append(bd)
			continue
		var drop: bool = false
		if late and rng.randf() < 0.1:
			drop = true
		if late and has_fades and str(bd["who"]) == "b" and rng.randf() < 0.3:
			drop = true
		if rn == 1 and has_slow and str(bd["who"]) == "b" and rng.randf() < 0.3:
			drop = true
		if not drop:
			keep.append(bd)
	script["beats"] = keep
