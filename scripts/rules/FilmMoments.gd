extends RefCounted
## FILMCOUNT1 (Goose, collected S498): the moments of a film a claim's WHEN names - the punch beats of both boxers in time
## order, the moments and windows a WHEN word marks, and the lookups FilmCount counts with. Split out of FilmCount.gd
## (578 lines as delivered; the house limit is 500). Pure static; preloads only FightLog.

const FightLog := preload("res://scripts/rules/FightLog.gd")

const ROUND_S := 180.0
const EX_S := 30.0
const HOOK_MOVES: Array = ["lead_hook", "rear_hook", "body_hook"]


static func is_punch_beat(beat: Dictionary) -> bool:
	var move: String = str(beat.get("move", ""))
	if not FightLog.PUNCH.has(move):
		return false
	return str(beat.get("result", "")) != "none"


static func punch_word(move: String) -> String:
	if not FightLog.PUNCH.has(move):
		return ""
	return str(FightLog.PUNCH[move][1])


static func target(move: String) -> String:
	if not FightLog.PUNCH.has(move):
		return ""
	return str(FightLog.PUNCH[move][2])


static func sort_by_t(arr: Array) -> void:
	for i in range(1, arr.size()):
		var j: int = i
		while j > 0:
			if float(arr[j - 1]["t"]) > float(arr[j]["t"]):
				var tmp = arr[j]
				arr[j] = arr[j - 1]
				arr[j - 1] = tmp
				j -= 1
			else:
				break


## Pre-computed film data for efficient multi-claim counting.
static func precompute(film: Dictionary) -> Dictionary:
	var b_punches: Array = []
	var a_punches: Array = []
	for ex in film.get("exchanges", []):
		var ed: Dictionary = ex as Dictionary
		var rn: int = int(ed.get("round", 1))
		var at: float = float(ed.get("at", 0.0))
		for beat in ed.get("beats", []):
			var bd: Dictionary = beat as Dictionary
			if not is_punch_beat(bd):
				continue
			var t_abs: float = float(rn - 1) * ROUND_S + at + float(bd.get("t", 0.0))
			var who: String = str(bd.get("who", ""))
			var entry := {"beat": bd, "t": t_abs, "ex": ed, "round": rn}
			if who == "b":
				b_punches.append(entry)
			elif who == "a":
				a_punches.append(entry)
	sort_by_t(b_punches)
	sort_by_t(a_punches)
	return {"b": b_punches, "a": a_punches, "film": film}


static func moments_from(pre: Dictionary, when: String) -> Array:
	var film: Dictionary = pre["film"]
	var b_punches: Array = pre["b"]
	var a_punches: Array = pre["a"]
	var out: Array = []
	match when:
		"jab", "cross", "hook":
			var target_word: String = when
			for bp in b_punches:
				var bpd: Dictionary = bp as Dictionary
				var move: String = str(bpd["beat"].get("move", ""))
				var match_pw: bool = false
				if target_word == "hook":
					match_pw = HOOK_MOVES.has(move)
				else:
					match_pw = punch_word(move) == target_word
				if match_pw:
					out.append({"t": float(bpd["t"]), "beat": bpd["beat"], "is_b_punch": true})
		"combo":
			var last_land_t: float = -999.0
			for bp in b_punches:
				var bpd: Dictionary = bp as Dictionary
				var bd: Dictionary = bpd["beat"]
				var result: String = str(bd.get("result", ""))
				var t_abs: float = float(bpd["t"])
				if result == "lands" and last_land_t > -900.0 and t_abs - last_land_t <= 1.5:
					out.append({"t": t_abs, "beat": bd, "is_b_punch": true})
				if result == "lands":
					last_land_t = t_abs
		"hurt":
			for ap in a_punches:
				var apd: Dictionary = ap as Dictionary
				var bd: Dictionary = apd["beat"]
				if str(bd.get("result", "")) == "lands" and bool(bd.get("big", false)):
					out.append({"t": float(apd["t"]), "beat": bd, "is_b_punch": false})
		"last_min":
			var rounds: int = int(film.get("rounds", 3))
			for r in rounds:
				var rn: int = r + 1
				out.append({"t_start": float(rn - 1) * ROUND_S + 120.0, "t_end": float(rn) * ROUND_S, "round": rn})
		"round1":
			out.append({"t_start": 0.0, "t_end": ROUND_S, "round": 1})
		"after_body":
			var windows: Array = []
			for ap in a_punches:
				var apd: Dictionary = ap as Dictionary
				var bd: Dictionary = apd["beat"]
				var move: String = str(bd.get("move", ""))
				if str(bd.get("result", "")) != "lands":
					continue
				if target(move) != "body":
					continue
				var t_abs: float = float(apd["t"])
				var rn: int = int(apd["round"])
				var w_end: float = t_abs + 30.0
				var r_end: float = float(rn) * ROUND_S
				if w_end > r_end:
					w_end = r_end
				windows.append({"t_start": t_abs, "t_end": w_end, "round": rn})
			out = merge_windows(windows)
		"walked":
			for ex in film.get("exchanges", []):
				var ed: Dictionary = ex as Dictionary
				if str(ed.get("a_mode", "")) == "press":
					var rn: int = int(ed.get("round", 1))
					var at: float = float(ed.get("at", 0.0))
					var t_start: float = float(rn - 1) * ROUND_S + at
					out.append({"t_start": t_start, "t_end": t_start + EX_S, "round": rn})
	return out


static func merge_windows(windows: Array) -> Array:
	if windows.is_empty():
		return []
	var sorted_w: Array = windows.duplicate()
	for i in range(1, sorted_w.size()):
		var j: int = i
		while j > 0:
			if float(sorted_w[j - 1]["t_start"]) > float(sorted_w[j]["t_start"]):
				var tmp = sorted_w[j]
				sorted_w[j] = sorted_w[j - 1]
				sorted_w[j - 1] = tmp
				j -= 1
			else:
				break
	var merged: Array = [sorted_w[0].duplicate()]
	for i in range(1, sorted_w.size()):
		var cur: Dictionary = sorted_w[i]
		var last: Dictionary = merged[merged.size() - 1]
		if int(cur["round"]) == int(last["round"]) and float(cur["t_start"]) <= float(last["t_end"]):
			if float(cur["t_end"]) > float(last["t_end"]):
				last["t_end"] = float(cur["t_end"])
		else:
			merged.append(cur.duplicate())
	return merged


static func merge_windows_generic(windows: Array) -> Array:
	if windows.is_empty():
		return []
	var sorted_w: Array = windows.duplicate()
	for i in range(1, sorted_w.size()):
		var j: int = i
		while j > 0:
			if float(sorted_w[j - 1]["t_start"]) > float(sorted_w[j]["t_start"]):
				var tmp = sorted_w[j]
				sorted_w[j] = sorted_w[j - 1]
				sorted_w[j - 1] = tmp
				j -= 1
			else:
				break
	var merged: Array = [sorted_w[0].duplicate()]
	for i in range(1, sorted_w.size()):
		var cur: Dictionary = sorted_w[i]
		var last: Dictionary = merged[merged.size() - 1]
		if float(cur["t_start"]) <= float(last["t_end"]):
			if float(cur["t_end"]) > float(last["t_end"]):
				last["t_end"] = float(cur["t_end"])
		else:
			merged.append(cur.duplicate())
	return merged


static func in_window(t: float, windows: Array) -> bool:
	for w in windows:
		var wd: Dictionary = w as Dictionary
		if wd.has("t_start") and t >= float(wd["t_start"]) and t < float(wd["t_end"]):
			return true
	return false


static func in_window_generic(t: float, windows: Array) -> bool:
	for w in windows:
		var wd: Dictionary = w as Dictionary
		if t >= float(wd["t_start"]) and t < float(wd["t_end"]):
			return true
	return false


static func in_2s_after_any(t: float, moments: Array) -> bool:
	for m in moments:
		var md: Dictionary = m as Dictionary
		if md.has("t"):
			var mt: float = float(md["t"])
			if t > mt and t <= mt + 2.0:
				return true
	return false


static func first_b_punch_after(t: float, b_punches: Array) -> Dictionary:
	for bp in b_punches:
		var bpd: Dictionary = bp as Dictionary
		var bp_t: float = float(bpd["t"])
		if bp_t > t and bp_t <= t + 2.0:
			return bpd["beat"]
	return {}


static func first_a_landed_after(t: float, a_punches: Array) -> Dictionary:
	for ap in a_punches:
		var apd: Dictionary = ap as Dictionary
		var ap_t: float = float(apd["t"])
		if ap_t > t and ap_t <= t + 2.0:
			var bd: Dictionary = apd["beat"]
			if str(bd.get("result", "")) == "lands":
				return bd
	return {}
