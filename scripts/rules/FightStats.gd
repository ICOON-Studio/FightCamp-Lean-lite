extends RefCounted
## S430 the fight in numbers (operator: "during the corner time i asked to see more match analysis stats"; on the result
## page: "you show the holos but no stats , you need to show stats to explain what happenned"). Pure: reads the settled
## rounds' exchange records (LiveRound), the same truth the cards are scored from, so a round watched in 3D, in words or
## skipped reads the same.
##   of(rounds) -> {rounds: [{n, won, landed, body, xwon, tank, counts}], landed, body, head, xwon, tank,
##                  calls: [{id, used, won}], games: [{sit, n, won}], pace: {push|steady|save: {n, won}}}
##   rows(st)   -> [{label, a, b, fa, fb, lead}]   the paired bars (a = ours, b = the opponent)
## Every pair is [ours, the opponent's].

const Exchanges := preload("res://scripts/rules/Exchanges.gd")


static func of(rounds: Array) -> Dictionary:
	var out := {"rounds": [], "landed": [0, 0], "body": [0, 0], "head": [0, 0], "xwon": [0, 0], "tank": [100.0, 100.0],
		"calls": [], "games": [], "pace": {}}
	var calls := {}
	var games := {}
	for r in rounds:
		var row := {"n": int(r.get("n", (out["rounds"] as Array).size() + 1)), "won": bool(r.get("won", false)),
			"landed": [0, 0], "body": [0, 0], "xwon": [0, 0], "counts": int(r.get("counts", 0)), "down": str(r.get("down", ""))}
		for x in r.get("exchanges", []):
			var l: Array = x.get("landed", [0, 0])
			var b: Array = x.get("body", [0, 0])
			for k in 2:
				row["landed"][k] = int(row["landed"][k]) + (int(l[k]) if l.size() > k else 0)
				row["body"][k] = int(row["body"][k]) + (int(b[k]) if b.size() > k else 0)
			var won := bool(x.get("won", false))
			row["xwon"][0 if won else 1] = int(row["xwon"][0 if won else 1]) + 1
			_count(calls, str(x.get("call", "")), won)
			_count(games, str(x.get("sit", "")), won)
			_count(out["pace"], str(x.get("pace", "steady")), won)
		var e: Dictionary = r.get("energy", {})
		row["tank"] = [float(e.get("a_end", 100.0)), float(e.get("b_end", 100.0))]
		out["tank"] = row["tank"]
		for k in 2:
			out["landed"][k] = int(out["landed"][k]) + int(row["landed"][k])
			out["body"][k] = int(out["body"][k]) + int(row["body"][k])
			out["xwon"][k] = int(out["xwon"][k]) + int(row["xwon"][k])
		(out["rounds"] as Array).append(row)
	for k in 2:
		out["head"][k] = maxi(0, int(out["landed"][k]) - int(out["body"][k]))
	out["calls"] = _sorted(calls, "id")
	out["games"] = _sorted(games, "sit")
	return out


## The paired bars: landed, to the head, to the body, exchanges won, the tank at the last bell.
static func rows(st: Dictionary) -> Array:
	var out: Array = []
	out.append(_pair("Punches landed", st["landed"]))
	out.append(_pair("To the head", st["head"]))
	out.append(_pair("To the body", st["body"]))
	out.append(_pair("Exchanges won", st["xwon"]))
	var t: Array = st["tank"]
	out.append({"label": "Energy left at the last bell",   # DEFECTS1: "Tank" was jargon
		"a": "%d" % int(round(float(t[0]))), "b": "%d" % int(round(float(t[1]))),
		"fa": clampf(float(t[0]) / 100.0, 0.0, 1.0), "fb": clampf(float(t[1]) / 100.0, 0.0, 1.0),
		"lead": 0 if float(t[0]) > float(t[1]) + 0.5 else (1 if float(t[1]) > float(t[0]) + 0.5 else -1)})
	return out


## "Jab and move" for a call id, "Pressing" for a game id ("" when unknown).
static func call_word(id: String) -> String:
	return str((Exchanges.CALLS.get(id, {}) as Dictionary).get("label", ""))


static func game_word(sit: String) -> String:
	return str((Exchanges.MODES.get(sit, {}) as Dictionary).get("label", ""))


## The call that beats a game ("" when unknown): what to shout the next time she shows it.
static func answer(sit: String) -> String:
	return call_word(str((Exchanges.MODES.get(sit, {}) as Dictionary).get("best", "")))


static func _count(into: Dictionary, key: String, won: bool) -> void:
	if key == "":
		return
	var row: Dictionary = into.get(key, {"n": 0, "won": 0})
	row["n"] = int(row["n"]) + 1
	row["won"] = int(row["won"]) + (1 if won else 0)
	into[key] = row


## Most used first; ties keep the order they first came up in.
static func _sorted(counts: Dictionary, key: String) -> Array:
	var out: Array = []
	for id in counts.keys():
		out.append({key: id, "n": int(counts[id]["n"]), "won": int(counts[id]["won"]), "used": int(counts[id]["n"]), "i": out.size()})
	out.sort_custom(func(x, y): return int(x["n"]) > int(y["n"]) if int(x["n"]) != int(y["n"]) else int(x["i"]) < int(y["i"]))
	return out


static func _pair(label: String, v: Array) -> Dictionary:
	var a := int(v[0])
	var b := int(v[1])
	var top := float(maxi(1, maxi(a, b)))
	return {"label": label, "a": "%d" % a, "b": "%d" % b, "fa": a / top, "fb": b / top, "lead": 0 if a > b else (1 if b > a else -1)}
