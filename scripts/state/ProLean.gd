extends RefCounted
## S523 TURNPRO1 (design v2 1.2 + the softer-opponent ask), split out of ProLadder (500-line rule): after the softer ask
## the next pro_tune_ups offer sets are tune-ups only; for the first LEAN_FIGHTS pro fights the house leans - Harrow &
## Finch (the guarantee house) adds a second tune-up, Bow Lane (the ticket house) a second step up: the next-nearest read,
## kept even when another row beats it (the lean is the promoter's, not the player's best pick).

const LEAN_FIGHTS := 6   ## ESTIMATE (design v2)
const LEAN_KIND := {"hf": "tune", "bow": "above"}
const LEAN_WORD := {"hf": "Harrow & Finch leans to tune-ups", "bow": "Bow Lane leans to step ups"}


static func extra(f: Dictionary, out: Array, tunes: Array, steps: Array, no_step: bool, until: int, tape: Array,
		tune_aim: float, step_aim: float) -> Array:
	if int(f.get("pro_tune_ups", 0)) > 0:
		var only := out.filter(func(o): return str(o["kind"]) == "tune")
		if not only.is_empty():
			return only
	var house := str(f.get("pro_house", ""))
	if not LEAN_KIND.has(house) or pro_fights(f) >= LEAN_FIGHTS:
		return out
	var kind: String = LEAN_KIND[house]
	if kind == "above" and no_step:
		return out
	var pool: Array = (tunes if kind == "tune" else steps).duplicate()
	var aim := tune_aim if kind == "tune" else step_aim
	pool.sort_custom(func(a, b): return absf(float(a["mid"]) - aim) < absf(float(b["mid"]) - aim))
	var taken: Array = out.map(func(o): return int(o["id"]))
	for p in pool:
		if not taken.has(int(p["b"]["id"])):
			out.append({"id": int(p["b"]["id"]), "kind": kind, "file_found": tape.duplicate(), "scouted": false,
				"until": until, "lean": house})
			break
	return out


static func pro_fights(f: Dictionary) -> int:
	return int(f.get("pro_w", 0)) + int(f.get("pro_l", 0)) + int(f.get("pro_d", 0))


## The Fights screen's line under NEXT FIGHT ("" after the lean's fights or with no house).
static func line(f: Dictionary) -> String:
	if int(f.get("pro_tune_ups", 0)) > 0:
		return "The softer start you asked for: the next %d offers are tune-ups." % int(f["pro_tune_ups"])
	var house := str(f.get("pro_house", ""))
	if not LEAN_WORD.has(house) or pro_fights(f) >= LEAN_FIGHTS:
		return ""
	return "%s for your first %d pro fights (%d left)." % [LEAN_WORD[house], LEAN_FIGHTS, LEAN_FIGHTS - pro_fights(f)]
