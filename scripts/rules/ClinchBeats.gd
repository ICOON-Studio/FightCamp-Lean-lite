extends RefCounted
## Real amateur clinch counts (Davis et al. 2015, elite 3x3 min; 2023 women's WC 4.06 +- 2.27 s).
## Inserts clinch beats into one exchange (in place, kept sorted) and returns the new beats.
## ctx = {"n": round 1..12, "sit": Exchanges.MODES key, "energy": {"a": 0..100, "b": 0..100},
##        "habits": {"a": [ids], "b": [ids]}}

const PER_ROUND := [2.5, 3.2, 4.8]
const DUR_MEAN_S := 4.1
const DUR_SD_S := 2.3
const DUR_MIN_S := 1.5
const DUR_MAX_S := 8.0
const BREAK_S := 0.8
const FIT_MIN_S := 2.5                  # a gap that would cut a clinch under 2.5 s is skipped
const PUNCHES := ["jab", "cross", "lead_hook", "body_hook", "rear_uppercut"]
const SIT_MULT := {"press": 1.2, "range": 0.5, "counter": 1.0, "loadup": 1.1,
	"tiring": 1.5, "hurt": 2.0, "she_tired": 1.5, "she_hurt": 2.0}


static func apply(beats: Array, ctx: Dictionary, rng: RandomNumberGenerator) -> Array:
	var rn: int = clampi(int(ctx.get("n", 1)), 1, PER_ROUND.size())
	var sit: String = str(ctx.get("sit", "press"))
	var mult: float = float(SIT_MULT.get(sit, 1.0))
	var base: float = float(PER_ROUND[rn - 1]) / 6.0 * mult
	var count: int = mini(_pick_count(base, rng), 2)
	# S340 she tied up this exchange (ClinchRest record): at least one clinch, hers, carrying the opponent's digs in it.
	var tie: Dictionary = ctx.get("tie", {})
	if not tie.is_empty():
		count = maxi(count, 1)
	if count <= 0:
		return []
	var energy: Dictionary = ctx.get("energy", {"a": 100.0, "b": 100.0})
	var habits: Dictionary = ctx.get("habits", {"a": [], "b": []})
	var new_beats: Array = []
	var pt: Array = _punch_times(beats)
	var taken: Array = []
	for i in count:
		var forced := i == 0 and not tie.is_empty()
		var who: String = "a" if forced else _who_clinches(beats, sit, energy, habits, rng)
		var desired_dur: float = clampf(_normal(DUR_MEAN_S, DUR_SD_S, rng), DUR_MIN_S, DUR_MAX_S)
		var gap: Dictionary = _pick_gap(pt, taken, desired_dur, rng)
		if gap.is_empty():
			continue
		if float(gap["max_dur"]) < minf(desired_dur, FIT_MIN_S):
			continue
		var dur: float = minf(desired_dur, float(gap["max_dur"]))
		var t_min: float = maxf(0.5, float(gap["start"]) + 0.01)
		var t_max: float = minf(29.5 - dur, float(gap["end"]) - dur - BREAK_S - 0.01)
		if t_min > t_max:
			continue
		# A boxer who was just hit grabs at once; otherwise anywhere in the gap.
		var t: float = t_min if gap["land"] else rng.randf_range(t_min, t_max)
		var break_t: float = t + dur
		# The placed window blocks the next clinch like a punch would (no overlapping clinches).
		pt.append({"t": t, "result": "none"})
		pt.append({"t": break_t + BREAK_S, "result": "none"})
		pt.sort_custom(_sort_t)
		taken.append([t, break_t + BREAK_S])
		var cb := {"t": t, "who": who, "move": "clinch", "result": "none", "caption": "", "dur": dur, "break_t": break_t}
		if forced and int(tie.get("shots", 0)) > 0:
			cb["digs"] = int(tie["shots"])   # Clinch.gd (CLINCH2) plays the opponent's free hand digging
			cb["digger"] = "b"
		new_beats.append(cb)
		new_beats.append({"t": break_t, "who": "a", "move": "step_out", "result": "none", "caption": "", "ref": true})
		new_beats.append({"t": break_t, "who": "b", "move": "step_out", "result": "none", "caption": "", "ref": true})
	beats.append_array(new_beats)
	beats.sort_custom(_sort_t)
	return new_beats


static func _sort_t(a: Dictionary, b: Dictionary) -> bool:
	return float(a["t"]) < float(b["t"])


static func _pick_count(base: float, rng: RandomNumberGenerator) -> int:
	if base <= 0.0:
		return 0
	var f: int = int(floorf(base))
	var frac: float = base - float(f)
	return f + (1 if rng.randf() < frac else 0)


static func _normal(mean: float, sd: float, rng: RandomNumberGenerator) -> float:
	var u1: float = maxf(0.0001, rng.randf())
	var u2: float = rng.randf()
	return mean + sd * sqrt(-2.0 * log(u1)) * cos(2.0 * PI * u2)


static func _punch_times(beats: Array) -> Array:
	var out: Array = []
	for b in beats:
		var m: String = str(b["move"])
		if m in PUNCHES:
			out.append({"t": float(b["t"]), "result": str(b["result"])})
	out.sort_custom(_sort_t)
	return out


static func _who_clinches(beats: Array, sit: String, energy: Dictionary, habits: Dictionary, rng: RandomNumberGenerator) -> String:
	if sit == "hurt" or sit == "tiring":
		return "b"
	if sit == "she_hurt" or sit == "she_tired":
		return "a"
	var wa: float = 1.0
	var wb: float = 1.0
	var last: Dictionary = _last_landed(beats)
	if not last.is_empty():
		var receiver: String = "a" if str(last["who"]) == "b" else "b"
		if receiver == "a":
			wa += 1.0
		else:
			wb += 1.0
	var ha: Array = habits.get("a", [])
	var hb: Array = habits.get("b", [])
	if "clinches_when_tired" in ha and float(energy.get("a", 100.0)) < 50.0:
		wa += 1.0
	if "clinches_when_tired" in hb and float(energy.get("b", 100.0)) < 50.0:
		wb += 1.0
	return "a" if rng.randf() < wa / (wa + wb) else "b"


static func _last_landed(beats: Array) -> Dictionary:
	var best: Dictionary = {}
	for b in beats:
		var m: String = str(b["move"])
		if m in PUNCHES and str(b["result"]) == "lands":
			if best.is_empty() or float(b["t"]) > float(best["t"]):
				best = b
	return best


static func _pick_gap(punches: Array, taken: Array, desired_dur: float, rng: RandomNumberGenerator) -> Dictionary:
	var gaps: Array = _gaps(punches)
	var valid: Array = []
	for g in gaps:
		if _inside_taken(g, taken):
			continue
		var max_dur: float = float(g["end"]) - float(g["start"]) - BREAK_S - 0.02
		if max_dur >= DUR_MIN_S:
			valid.append({"start": g["start"], "end": g["end"], "land": g["land"], "max_dur": max_dur})
	if valid.is_empty():
		return {}
	# Prefer a gap right after a landed punch that fits the whole clinch, then any landed gap, then the longest.
	var landed: Array = []
	var fits: Array = []
	for g in valid:
		if g["land"]:
			landed.append(g)
			if float(g["max_dur"]) >= desired_dur:
				fits.append(g)
	if not fits.is_empty():
		return fits[rng.randi() % fits.size()]
	valid.sort_custom(_gap_size_first)
	return valid[0]


## A gap between a placed clinch's two edge points is that clinch itself, not free time.
static func _inside_taken(g: Dictionary, taken: Array) -> bool:
	for w in taken:
		if float(g["start"]) >= float(w[0]) - 0.001 and float(g["end"]) <= float(w[1]) + 0.001:
			return true
	return false


static func _gap_size_first(a: Dictionary, b: Dictionary) -> bool:
	return float(a["max_dur"]) > float(b["max_dur"])


static func _gaps(punches: Array) -> Array:
	var out: Array = []
	if punches.is_empty():
		out.append({"start": 0.0, "end": 30.0, "land": false})
		return out
	if float(punches[0]["t"]) > 0.8:
		out.append({"start": 0.0, "end": float(punches[0]["t"]), "land": false})
	for i in range(punches.size() - 1):
		var t1: float = float(punches[i]["t"])
		var t2: float = float(punches[i + 1]["t"])
		if t2 - t1 > 1.0:
			out.append({"start": t1, "end": t2, "land": str(punches[i]["result"]) == "lands"})
	var lt: float = float(punches[-1]["t"])
	if 30.0 - lt > 1.0:
		out.append({"start": lt, "end": 30.0, "land": str(punches[-1]["result"]) == "lands"})
	return out
