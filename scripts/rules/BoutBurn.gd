extends RefCounted
## Rebuild per-round body burn from settled exchange records (words-mode bouts).
## Pure static module - preloads only BodyLoad and BodyRates.

const BodyLoad := preload("res://scripts/rules/BodyLoad.gd")
const BodyRates := preload("res://scripts/rules/BodyRates.gd")

const LAND_RATE := 0.33
const MIX := [["jab", 0.50], ["cross", 0.25], ["lead_hook", 0.13], ["body_hook", 0.06], ["rear_uppercut", 0.06]]
const EX_SECONDS := 30.0


static func beats_of(exchange: Dictionary) -> Array:
	var landed_arr: Array = exchange.get("landed", [0, 0])
	var her_landed: int = int(landed_arr[0])
	if her_landed <= 0:
		return []
	var thrown: int = ceili(float(her_landed) / LAND_RATE)
	if thrown <= 0:
		return []
	var counts: Array = []
	var fracs: Array = []
	var total_floor: int = 0
	for i in MIX.size():
		var exact: float = float(MIX[i][1]) * float(thrown)
		var f: int = floori(exact)
		counts.append(f)
		fracs.append(exact - float(f))
		total_floor += f
	var remainder: int = thrown - total_floor
	var allocated: Array = []
	for _step in remainder:
		var best_idx: int = -1
		var best_frac: float = -1.0
		for j in MIX.size():
			if allocated.has(j):
				continue
			if fracs[j] > best_frac + 0.0001:
				best_frac = fracs[j]
				best_idx = j
			elif absf(fracs[j] - best_frac) <= 0.0001 and best_idx != -1:
				if j < best_idx:
					best_idx = j
					best_frac = fracs[j]
		if best_idx >= 0:
			counts[best_idx] += 1
			allocated.append(best_idx)
	var beats: Array = []
	var spacing: float = EX_SECONDS / float(thrown + 1)
	var slot: int = 0
	for i in MIX.size():
		for _n in counts[i]:
			beats.append({"who": "a", "move": str(MIX[i][0]), "t": spacing * float(slot + 1)})
			slot += 1
	return beats


static func per_round(rounds: Array, stats: Dictionary, style: String) -> Array:
	if rounds.is_empty():
		return []
	var load: Dictionary = BodyLoad.fresh()
	var rates: Dictionary = BodyRates.of(stats, style)
	var result: Array = []
	for rnd in rounds:
		var exchanges: Array = rnd.get("exchanges", [])
		for ex in exchanges:
			var beats: Array = beats_of(ex)
			var ctx: Dictionary = {
				"sit": str(ex.get("sit", "")),
				"pace": {"a": str(ex.get("pace", "steady"))},
				"tank": {"a": 100.0},
				"rates": {"a": rates},
			}
			BodyLoad.add_exchange(load, beats, ctx)
		var snapshot: Dictionary = {}
		for p in BodyLoad.PARTS:
			snapshot[p] = BodyLoad.burn(load, "a", p)
		result.append(snapshot)
		var cond_val: float = float(stats.get("conditioning", 50.0))
		var cond: float = 0.8 + 0.4 * cond_val / 100.0
		BodyLoad.rest(load, {"a": cond}, {}, {})
	return result
