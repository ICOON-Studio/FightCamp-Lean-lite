extends RefCounted
## S374 operator: "to lower clinches and make them have a bit sense should clinch happen only when a fighter is desperate
## to break opponents combo but get risk of getting hit, that should be pretty rare and i dont care about the real stats".
## A clinch is an ANSWER: a combination landing on her (COMBO_MIN punches inside COMBO_GAP_S, COMBO_LANDED_MIN of them
## landing) - the one under fire may grab to stop it (GRAB_P, more when hurt or tired, or with the clinches_when_tired
## habit while tired), and closing in to grab costs her: ENTRY_HIT_P of the time the attacker's next shot lands first.
## No combination, no clinch; at most one an exchange. The corner's "tie" call (ClinchRest) still forces hers, entry risk
## included. (Before S374: 2.5 -> 4.8 a round at random, Davis et al. 2015 - the operator set the real stats aside.)
## ctx = {"n": round, "sit": Exchanges.MODES key, "energy": {"a", "b"}, "habits": {"a": [ids], "b": [ids]}, "tie": {}}

const COMBO_MIN := 3
const COMBO_LANDED_MIN := 2
const COMBO_GAP_S := 0.9
const GRAB_P := 0.12
const GRAB_P_MAX := 0.45
const ENTRY_HIT_P := 0.55
const ENTRY_LEAD_S := 0.30             # the entry shot lands this long before the tie-up
const ENTRY_SHOTS := ["lead_hook", "rear_uppercut", "body_hook"]
const DUR_MEAN_S := 2.6
const DUR_SD_S := 0.9
const DUR_MIN_S := 1.2
const DUR_MAX_S := 4.5
const BREAK_S := 0.8
const FIT_MIN_S := 1.2                 # the player's tie needs at least this much free time
const PUNCHES := ["jab", "cross", "lead_hook", "body_hook", "rear_uppercut"]
## How desperate the one under fire is: her own hurt / tiring (sit is from her corner's side: "hurt" = the opponent).
const DESPERATE := {"hurt": 2.5, "tiring": 1.6}


static func apply(beats: Array, ctx: Dictionary, rng: RandomNumberGenerator) -> Array:
	var sit: String = str(ctx.get("sit", "press"))
	var energy: Dictionary = ctx.get("energy", {"a": 100.0, "b": 100.0})
	var habits: Dictionary = ctx.get("habits", {"a": [], "b": []})
	var tie: Dictionary = ctx.get("tie", {})
	var new_beats: Array = []
	if not tie.is_empty():
		# S340 she tied up this exchange (ClinchRest record): her clinch, carrying the opponent's digs in it.
		var cb := _forced(beats, rng)
		if not cb.is_empty():
			if int(tie.get("shots", 0)) > 0:
				cb["digs"] = int(tie["shots"])   # Clinch.gd (CLINCH2) plays the opponent's free hand digging
				cb["digger"] = "b"
			_place(new_beats, cb, "b", rng)
	else:
		for c in _combos(beats):
			var holder: String = str(c["victim"])
			if rng.randf() >= _grab_p(holder, sit, energy, habits):
				continue
			var cb := _after_combo(beats, c, rng)
			if cb.is_empty():
				continue
			cb["who"] = holder
			_place(new_beats, cb, str(c["attacker"]), rng)
			break   # rare: at most one an exchange
	beats.append_array(new_beats)
	beats.sort_custom(_sort_t)
	return new_beats


## The chance the one under fire grabs: GRAB_P, x DESPERATE when she is the hurt / tiring one, x1.6 for the
## clinches_when_tired habit under 50 energy; at most GRAB_P_MAX.
static func _grab_p(holder: String, sit: String, energy: Dictionary, habits: Dictionary) -> float:
	var mine := sit if holder == "b" else str({"she_hurt": "hurt", "she_tired": "tiring"}.get(sit, ""))
	var p := GRAB_P * float(DESPERATE.get(mine, 1.0))
	if "clinches_when_tired" in (habits.get(holder, []) as Array) and float(energy.get(holder, 100.0)) < 50.0:
		p *= 1.6
	return minf(p, GRAB_P_MAX)


## Combinations that land: runs of one boxer's punches, each within COMBO_GAP_S of the last, COMBO_MIN long with
## COMBO_LANDED_MIN landing. [{attacker, victim, end_t, next_t}] (next_t = the next punch by anyone after it).
static func _combos(beats: Array) -> Array:
	var pt: Array = []
	for b in beats:
		if str(b["move"]) in PUNCHES:
			pt.append(b)
	pt.sort_custom(_sort_t)
	var out: Array = []
	var i := 0
	while i < pt.size():
		var j := i
		while j + 1 < pt.size() and str(pt[j + 1]["who"]) == str(pt[i]["who"]) and float(pt[j + 1]["t"]) - float(pt[j]["t"]) <= COMBO_GAP_S:
			j += 1
		var landed := 0
		for k in range(i, j + 1):
			landed += 1 if str(pt[k]["result"]) == "lands" else 0
		if j - i + 1 >= COMBO_MIN and landed >= COMBO_LANDED_MIN:
			var who := str(pt[i]["who"])
			out.append({"attacker": who, "victim": "b" if who == "a" else "a", "end_t": float(pt[j]["t"]),
				"next_t": float(pt[j + 1]["t"]) if j + 1 < pt.size() else 30.0})
		i = j + 1
	return out


## Her grab right after the combination, if it fits before the next punch; the entry shot's time rides along.
static func _after_combo(beats: Array, c: Dictionary, rng: RandomNumberGenerator) -> Dictionary:
	var entry := rng.randf() < ENTRY_HIT_P
	var t := float(c["end_t"]) + 0.15 + (ENTRY_LEAD_S if entry else 0.0)
	var room := minf(float(c["next_t"]), 29.5) - t - BREAK_S - 0.02
	if room < DUR_MIN_S or t < 0.5:
		return {}
	var dur := minf(clampf(_normal(DUR_MEAN_S, DUR_SD_S, rng), DUR_MIN_S, DUR_MAX_S), room)
	var cb := {"t": t, "move": "clinch", "result": "none", "caption": "", "dur": dur, "break_t": t + dur}
	if entry:
		cb["entry_t"] = float(c["end_t"]) + 0.15
	return cb


## The player's tie: the first free gap long enough (the old placement), with the same entry risk.
static func _forced(beats: Array, rng: RandomNumberGenerator) -> Dictionary:
	var pt: Array = _punch_times(beats)
	var gap: Dictionary = _pick_gap(pt, [], DUR_MEAN_S, rng)
	if gap.is_empty() or float(gap["max_dur"]) < FIT_MIN_S:
		return {}
	var entry := rng.randf() < ENTRY_HIT_P
	var t: float = maxf(0.5, float(gap["start"]) + 0.01) + (ENTRY_LEAD_S if entry else 0.0)
	var dur: float = minf(clampf(_normal(DUR_MEAN_S, DUR_SD_S, rng), DUR_MIN_S, DUR_MAX_S), float(gap["end"]) - t - BREAK_S - 0.02)
	if dur < DUR_MIN_S or t + dur > 29.5:
		return {}
	var cb := {"t": t, "who": "a", "move": "clinch", "result": "none", "caption": "", "dur": dur, "break_t": t + dur}
	if entry:
		cb["entry_t"] = t - ENTRY_LEAD_S
	return cb


## The clinch, its entry shot (the attacker's punch landing on her as she closes) and the two step-outs at the break.
static func _place(new_beats: Array, cb: Dictionary, attacker: String, rng: RandomNumberGenerator) -> void:
	if cb.has("entry_t"):
		new_beats.append({"t": float(cb["entry_t"]), "who": attacker, "move": ENTRY_SHOTS[rng.randi() % ENTRY_SHOTS.size()],
			"result": "lands", "caption": "", "entry": true})
		cb.erase("entry_t")
	new_beats.append(cb)
	new_beats.append({"t": float(cb["break_t"]), "who": "a", "move": "step_out", "result": "none", "caption": "", "ref": true})
	new_beats.append({"t": float(cb["break_t"]), "who": "b", "move": "step_out", "result": "none", "caption": "", "ref": true})


static func _sort_t(a: Dictionary, b: Dictionary) -> bool:
	return float(a["t"]) < float(b["t"])


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
