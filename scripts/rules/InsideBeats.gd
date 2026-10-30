extends RefCounted
## Real women's amateur finals spend 17-31 % of a round at inside range (pelvis to pelvis under 0.65 m).
## Marks inside spells in one exchange (in place, kept sorted) and returns the inserted beats.
## ctx = {"sit": the exchange's situation (Exchanges.MODES keys, as in ClinchBeats)}

const BURST_GAP_S := 1.4
const SHARE := 0.15
const SIT_MULT := {"press": 1.6, "range": 0.35, "counter": 0.7, "loadup": 0.8, "tiring": 1.2, "she_tired": 1.2,
	"hurt": 1.2, "she_hurt": 1.2}
const LEAD_S := 0.38
const LINGER_S := Vector2(0.8, 1.6)
const SPELL_S := Vector2(1.5, 6.0)
## Inside, a straight becomes a hook or uppercut this often (S314: 0.65 left inside spells at 53 % hooks+uppercuts and the
## round at 63 % straights - real elite ~53 % straights, Davis 2015 - because combinations keep their own punches).
const TURN := 0.75
const PUNCHES := ["jab", "cross", "lead_hook", "body_hook", "rear_uppercut"]


static func apply(beats: Array, ctx: Dictionary, rng: RandomNumberGenerator) -> Array:
	var sit: String = str(ctx.get("sit", "press"))
	var mult: float = float(SIT_MULT.get(sit, 1.0))
	var target: float = SHARE * mult * 30.0
	var max_total: float = 1.5 * target
	var punch_idx: Array = _punch_indices(beats)
	if punch_idx.is_empty():
		return []
	var bursts: Array = _find_bursts(punch_idx, beats)
	var order: Array = []
	for i in bursts.size():
		order.append(i)
	_shuffle(order, rng)
	var picked: Array = []
	var total_inside: float = 0.0
	for oi in order:
		if total_inside >= target:
			break
		var burst: Array = bursts[oi]
		var first_t: float = float(beats[burst[0]]["t"])
		var last_t: float = float(beats[burst[burst.size() - 1]]["t"])
		var spell_start: float = first_t - LEAD_S
		var linger: float = rng.randf_range(LINGER_S.x, LINGER_S.y)
		var spell_end: float = last_t + linger
		var spell_len: float = spell_end - spell_start
		if spell_len > SPELL_S.y:
			spell_end = spell_start + SPELL_S.y
			spell_len = SPELL_S.y
		elif spell_len < SPELL_S.x:
			spell_end = spell_start + SPELL_S.x
			spell_len = SPELL_S.x
		if spell_end < last_t:
			continue
		if spell_start < 0.5 or spell_end > 29.0:
			continue
		if _overlaps_any(spell_start, spell_end, picked):
			continue
		if _has_clinch_in(spell_start, spell_end, beats):
			continue
		if total_inside + spell_len > max_total:
			continue
		var who: String
		if sit == "press":
			who = "b"
		else:
			who = str(beats[burst[0]]["who"])
		picked.append({"start": spell_start, "end": spell_end, "who": who, "burst_idx": oi})
		total_inside += spell_len
	var new_beats: Array = []
	for p in picked:
		var bi2: int = int(p["burst_idx"])
		var burst2: Array = bursts[bi2]
		var who2: String = str(p["who"])
		new_beats.append({"t": float(p["start"]), "who": who2, "move": "inside", "result": "none",
			"caption": "", "end_t": float(p["end"])})
		for idx in burst2:
			var b: Dictionary = beats[idx]
			var m: String = str(b["move"])
			if m == "body_hook":
				continue
			if bool(b.get("combo", false)) or str(b.get("combo_id", "")) != "" or bool(b.get("big", false)):
				continue
			if rng.randf() >= TURN:
				continue
			if m == "jab":
				b["move"] = "lead_hook"
			elif m == "cross":
				if rng.randf() < 0.5:
					b["move"] = "rear_uppercut"
				else:
					b["move"] = "lead_hook"
	beats.append_array(new_beats)
	beats.sort_custom(_sort_t)
	return new_beats


static func _punch_indices(beats: Array) -> Array:
	var out: Array = []
	for i in beats.size():
		var m: String = str(beats[i]["move"])
		if m in PUNCHES:
			out.append(i)
	return out


static func _find_bursts(punch_idx: Array, beats: Array) -> Array:
	if punch_idx.is_empty():
		return []
	var out: Array = []
	var cur: Array = [punch_idx[0]]
	for pi in range(1, punch_idx.size()):
		var prev_t: float = float(beats[punch_idx[pi - 1]]["t"])
		var cur_t: float = float(beats[punch_idx[pi]]["t"])
		if cur_t - prev_t < BURST_GAP_S:
			cur.append(punch_idx[pi])
		else:
			out.append(cur)
			cur = [punch_idx[pi]]
	out.append(cur)
	return out


static func _overlaps_any(start: float, end_val: float, picked: Array) -> bool:
	for p in picked:
		if start < float(p["end"]) and float(p["start"]) < end_val:
			return true
	return false


static func _has_clinch_in(start: float, end_val: float, beats: Array) -> bool:
	for b in beats:
		var m: String = str(b["move"])
		if m == "clinch":
			if float(b["t"]) >= start and float(b["t"]) <= end_val:
				return true
			if float(b["break_t"]) >= start and float(b["break_t"]) <= end_val:
				return true
	return false


static func _sort_t(a: Dictionary, b: Dictionary) -> bool:
	return float(a["t"]) < float(b["t"])


static func _shuffle(a: Array, rng: RandomNumberGenerator) -> void:
	for i in range(a.size() - 1, 0, -1):
		var j: int = rng.randi_range(0, i)
		var tmp = a[i]
		a[i] = a[j]
		a[j] = tmp
