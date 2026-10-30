extends RefCounted
## Short evidence lines for the eight corner calls + the open habit.
## Pure static module, zero preloads. "a" = our fighter, "b" = opponent.

const HURT := 55.0
const CRITICAL := 35.0
const DOCTOR := 15.0

const PLACE_WORDS := {
	"head": "head",
	"left_eye": "left eye",
	"right_eye": "right eye",
	"nose": "nose",
	"left_ribs": "left ribs",
	"right_ribs": "right ribs",
}

const SIX_PLACES := ["head", "left_eye", "right_eye", "nose", "left_ribs", "right_ribs"]
const FACE_PLACES := ["head", "left_eye", "right_eye", "nose"]


static func _band(v: float) -> String:
	if v > HURT:
		return "fine"
	if v > CRITICAL:
		return "hurt"
	if v > DOCTOR:
		return "critical"
	return "doctor"


static func _places(map: Dictionary, who: String) -> Dictionary:
	if map.has(who) and map[who] is Dictionary and map[who].has("places"):
		return map[who]["places"]
	return {}


static func _pv(places: Dictionary, p: String) -> float:
	return places.get(p, 100.0)


static func _lowest(places: Dictionary, keys: Array) -> Array:
	var bp: String = keys[0]
	var bv: float = _pv(places, keys[0])
	for i in range(1, keys.size()):
		var p: String = keys[i]
		var v: float = _pv(places, p)
		if v < bv:
			bv = v
			bp = p
	return [bp, bv]


static func _ti(d: Dictionary, k: String) -> int:
	return int(d.get(k, 0))


static func lines(map: Dictionary, tally: Dictionary, fires: Array, energy: Dictionary,
		names: Array, habit_words: Dictionary) -> Dictionary:
	var an: String = names[0]
	var bn: String = names[1]
	var ap: Dictionary = _places(map, "a")
	var bp: Dictionary = _places(map, "b")
	var at: Dictionary = tally.get("a", {})
	var bt: Dictionary = tally.get("b", {})
	var at_l: Dictionary = at.get("landed", {})
	var at_t: Dictionary = at.get("thrown", {})
	var bt_l: Dictionary = bt.get("landed", {})
	var bt_t: Dictionary = bt.get("thrown", {})

	var jl: int = _ti(at_l, "jab")
	var jt: int = _ti(at_t, "jab")
	var long_line: String
	if jt == 0:
		long_line = "%s threw no jabs" % an
	else:
		long_line = "%s's jab: %d of %d landed" % [an, jl, jt]

	var brl: float = _pv(bp, "left_ribs")
	var brr: float = _pv(bp, "right_ribs")
	var brv: float = minf(brl, brr)
	var ab: int = _ti(at_l, "body")
	var body_line := "%s's ribs: %d (%s), %d to the body" % [bn, int(brv), _band(brv), ab]   # S318 fits the card's button

	var btt: int = _ti(bt_t, "total")
	var btl: int = _ti(bt_l, "total")
	var lead_line := "%s threw %d punches, landed %d" % [bn, btt, btl]

	var bhp: int = _ti(bt_l, "jab") + _ti(bt_l, "straight") + _ti(bt_l, "hook") + _ti(bt_l, "uppercut")
	var al: Array = _lowest(ap, FACE_PLACES)
	var hands_line := "%s took %d to the head; %s %d" % [an, bhp, PLACE_WORDS[al[0]], int(al[1])]

	var att: int = _ti(at_t, "total")
	var let_go_line := "%s threw %d, %s threw %d" % [an, att, bn, btt]

	var ae: float = float(energy.get("a", 100.0))
	var calm_line := "%s's energy: %d at the bell" % [an, int(round(ae))]

	var bhu: int = _ti(bt_l, "hook") + _ti(bt_l, "uppercut")
	var tie_line := "%s landed %d hooks and uppercuts" % [bn, bhu]

	var bl: Array = _lowest(bp, SIX_PLACES)
	var finish_line := "%s's %s: %d (%s)" % [bn, PLACE_WORDS[bl[0]], int(bl[1]), _band(bl[1])]

	return {
		"long": long_line,
		"body": body_line,
		"lead": lead_line,
		"hands": hands_line,
		"let_go": let_go_line,
		"calm": calm_line,
		"tie": tie_line,
		"finish": finish_line,
		"open": open_line(fires, names, habit_words),
	}


static func open_line(fires: Array, names: Array, habit_words: Dictionary) -> String:
	var bname: String = names[1]
	var counts := {}
	var first := {}
	for f in fires:
		if str(f.get("who", "")) != "b":
			continue
		var h: String = str(f.get("habit", ""))
		var t: float = float(f.get("t", 0.0))
		if not counts.has(h):
			counts[h] = 0
			first[h] = t
		else:
			if t < first[h]:
				first[h] = t
		counts[h] += 1
	if counts.is_empty():
		return ""
	var best_h: String = ""
	var best_n: int = 0
	var best_t: float = INF
	for h in counts:
		var n: int = int(counts[h])
		var ft: float = float(first[h])
		if n > best_n or (n == best_n and ft < best_t):
			best_h = h
			best_n = n
			best_t = ft
	var words: String
	if habit_words.has(best_h):
		words = str(habit_words[best_h])
	else:
		words = best_h.replace("_", " ")
	var ts: String = "once" if best_n == 1 else "%d times" % best_n
	return "%s %s: %s" % [bname, words, ts]
