extends RefCounted
## S311 real-fight gap 1 (Game Godot/research/S310_REAL_FIGHT_GAPS.md): the range breathes. Real women's amateur bouts
## rest out of reach (pelvis to pelvis 1.3-1.6 m), one boxer lunges 0.4-0.7 m in ~0.3 s to open an exchange, punches
## land at the jab gap, hooks a little closer, and one of them steps out 0.3-0.7 s after the last punch. Ours held one
## 0.95 m gap all round (sd 0.04 NA vs 0.39-0.49 real, 0 range swings vs 18-35 a minute).
## This reads the exchange's beats (absolute times, FightView fires them in order) and says what range the stage keeps
## now. The view never decides anything: who lands what is unchanged, only where they stand.
##   phase(beats, next, t) -> {"phase": "in"|"pocket"|"rest", "who": 0|1|-1, "move": String}

const RoundScript := preload("res://scripts/rules/RoundScript.gd")

## An entry lunge starts this long before the burst's first punch (real ~0.25-0.35 s).
const LEAD_S := 0.38
## Punches closer together than this are one burst: the two stay in the pocket between them.
const BURST_GAP_S := 1.4
## After a burst's last punch they stay in the pocket this long, then one steps out (real 0.3-0.7 s).
const EXIT_AFTER_S := 0.5
## The rest range between exchanges, pelvis to pelvis (real 1.3-1.6 m, p90 1.9-2.4 m; the elite mean 1.23 +- 0.16 m).
## From there an entry lunge covers 0.4-0.7 m to the jab gap, as the real ones do.
const REST_M := Vector2(1.35, 1.65)
## Hooks, uppercuts and body shots are thrown this much inside the jab gap (their gloves fall 0.1-0.27 m short there).
const INSIDE_M := 0.12
const INSIDE := ["lead_hook", "body_hook", "rear_uppercut"]


## The range the stage keeps at view time t. `next` = the first beat not yet fired.
static func phase(beats: Array, next: int, t: float) -> Dictionary:
	var last := _punch(beats, next - 1, -1)
	var nxt := _punch(beats, next, 1)
	var to_next := float(nxt["t"]) - t if not nxt.is_empty() else 99.0
	var since := t - float(last["t"]) if not last.is_empty() else 99.0
	if to_next <= LEAD_S:
		return {"phase": "in", "who": _who(nxt), "move": str(nxt["move"])}
	if since < EXIT_AFTER_S or since + to_next < BURST_GAP_S:
		return {"phase": "pocket", "who": -1, "move": str(last.get("move", nxt.get("move", "jab")))}
	# Out of range: the one who did NOT throw the last punch steps out first (the stage falls back to the other).
	return {"phase": "rest", "who": 1 - _who(last) if not last.is_empty() else -1, "move": ""}


## Pelvis-to-pelvis metres for a phase, from the jab gap. `roll` 0..1 picks the rest distance of this quiet spell.
static func want_m(ph: Dictionary, jab_gap: float, roll: float) -> float:
	if str(ph["phase"]) == "rest":
		return lerpf(REST_M.x, REST_M.y, roll)
	return jab_gap - (INSIDE_M if INSIDE.has(str(ph["move"])) else 0.0)


static func _who(b: Dictionary) -> int:
	return 0 if str(b.get("who", "a")) == "a" else 1


## The nearest punch beat from index i walking by `dir` (+1 forward, -1 back); {} if none.
static func _punch(beats: Array, i: int, dir: int) -> Dictionary:
	while i >= 0 and i < beats.size():
		if RoundScript.PUNCHES.has(str(beats[i]["move"])):
			return beats[i]
		i += dir
	return {}
