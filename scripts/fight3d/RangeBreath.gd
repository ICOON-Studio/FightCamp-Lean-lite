extends RefCounted
## S311 real-fight gap 1 (Game Godot/research/S310_REAL_FIGHT_GAPS.md): the range breathes. Real women's amateur bouts
## rest out of reach (pelvis to pelvis 1.3-1.6 m), one boxer lunges 0.4-0.7 m in ~0.3 s to open an exchange, punches
## land at the jab gap, hooks a little closer, and one of them steps out 0.3-0.7 s after the last punch. Ours held one
## 0.95 m gap all round (sd 0.04 NA vs 0.39-0.49 real, 0 range swings vs 18-35 a minute).
## This reads the exchange's beats (absolute times, FightView fires them in order) and says what range the stage keeps
## now. The view never decides anything: who lands what is unchanged, only where they stand.
##   phase(beats, next, t) -> {"phase": "in"|"pocket"|"rest"|"clinch"|"inside"|"pivot", "who": 0|1|-1, "move": String}
## S313 real-fight gap 4: a "clinch" beat (ClinchBeats: dur, break_t) holds them chest to chest until the referee's break.

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
## POWER1 step 4 (UPPERCUT_RANGE_S439.md): the lead uppercut and the right hook were missing from both lists (RoundStyle
## throws them; RoundScript.PUNCHES does not name them), so they were thrown from wherever the pair stood. With step 4 on
## they are punches here, each move keeps its own distance (RangeTable), and inside a spell the punch about to come is thrown
## from its own (an uppercut closes in, a straight steps out to it). `-- nopunchrange` = the lists as they were.
const MORE_PUNCHES := ["rear_hook", "lead_uppercut"]
## ... and between the punches of a burst (the pocket) and inside a spell, the footwork sets up for the next punch this far
## ahead (the "in" phase's LEAD_S alone left a step no time: the straights landed at 0.86-0.98 m, elbows 62-130 deg).
const NEXT_LOOK_S := 0.9
## A punch in the air is looked for this far back (its fire to its contact: a body hook flies 0.40 s, a wait for her own
## last punch or a fold adds to it).
const FLIGHT_LOOK_S := 2.0
static var step4: bool = not OS.get_cmdline_user_args().has("nopunchrange")
## Tied up, pelvis to pelvis (chest to chest without torso interpenetration).
const CLINCH_M := 0.45
## A clinch beat is looked for this far back (ClinchBeats.DUR_MAX_S + a margin).
const CLINCH_LOOK_S := 9.0
## S314 inside range: close enough for hooks and uppercuts without stepping inside each other's chests.
## HUMANFIGHT1 (two blind critics, 3/10, the first defect of both: "they walk through each other", "boots stacked on boots
## for a full second", "Liam's face sits in Danny's chest"): 0.64 m pelvis to pelvis puts two 0.5-0.6 m stances inside each
## other - a coach's inside is lead toes 45-55 cm apart, heads outside each other's lead shoulder. The range was never
## reached while steps were whole captured clips (the gap read 1.45 m "inside"), so nobody saw it. 0.92 keeps the boots apart (0.84 still read chest to chest on the round 2 frames).
const INSIDE_SPELL_M := 0.92   # S390: R16 had 0.68, 0.64 after; main 0.55 overlapped chests
const INSIDE_LOOK_S := 7.0


## The range the stage keeps at view time t. `next` = the first beat not yet fired.
static func phase(beats: Array, next: int, t: float) -> Dictionary:
	var held := clinch_at(beats, next, t)
	if not held.is_empty():
		return {"phase": "clinch", "who": _who(held), "move": "clinch"}
	var fly := _in_flight(beats, next, t) if step4 else {}
	var spell := _spell_at(beats, next, t, "inside", "end_t", INSIDE_LOOK_S)
	if not spell.is_empty():
		var up := fly if not fly.is_empty() else (_punch(beats, next, 1) if step4 else {})
		var soon := not up.is_empty() and float(up["t"]) - t <= NEXT_LOOK_S
		return {"phase": "inside", "who": _who(up) if soon else _who(spell), "move": "inside", "next": str(up["move"]) if soon else "",
			"clip": str(up.get("clip", "")) if soon else ""}
	# S315: a spell that ends in a pivot (InsideExits): the pressed boxer pivots out off the line until pivot_t.
	var out := _spell_at(beats, next, t, "inside", "pivot_t", INSIDE_LOOK_S)
	if not out.is_empty() and t >= float(out["end_t"]):
		return {"phase": "pivot", "who": 0 if str(out.get("exit_who", "a")) == "a" else 1, "move": "pivot"}
	if not fly.is_empty():
		return {"phase": "pocket", "who": _who(fly), "move": str(fly["move"]), "clip": str(fly.get("clip", ""))}
	var last := _punch(beats, next - 1, -1)
	var nxt := _punch(beats, next, 1)
	var to_next := float(nxt["t"]) - t if not nxt.is_empty() else 99.0
	var since := t - float(last["t"]) if not last.is_empty() else 99.0
	if to_next <= LEAD_S:
		return {"phase": "in", "who": _who(nxt), "move": str(nxt["move"])}
	if since < EXIT_AFTER_S or since + to_next < BURST_GAP_S:
		if step4 and not nxt.is_empty() and to_next < BURST_GAP_S:
			return {"phase": "pocket", "who": _who(nxt), "move": str(nxt["move"])}   # POWER1 step 4: set for the next one
		return {"phase": "pocket", "who": -1, "move": str(last.get("move", nxt.get("move", "jab")))}
	# Out of range: the one who did NOT throw the last punch steps out first (the stage falls back to the other).
	return {"phase": "rest", "who": 1 - _who(last) if not last.is_empty() else -1, "move": ""}


## Pelvis-to-pelvis metres for a phase, from the jab gap. `roll` 0..1 picks the rest distance of this quiet spell.
static func want_m(ph: Dictionary, jab_gap: float, roll: float, ranges: Dictionary = {}) -> float:
	if str(ph["phase"]) == "rest":
		return lerpf(REST_M.x, REST_M.y, roll)
	if str(ph["phase"]) == "clinch":
		return CLINCH_M
	if str(ph["phase"]) in ["inside", "pivot"]:
		var nx := str(ph.get("next", ""))
		return float(ranges[nx]) if ranges.has(nx) else INSIDE_SPELL_M
	if ranges.has(str(ph["move"])):
		return float(ranges[str(ph["move"])])
	var close := INSIDE.has(str(ph["move"])) or (step4 and MORE_PUNCHES.has(str(ph["move"])))
	return jab_gap - (INSIDE_M if close else 0.0)


## The clinch beat already fired (index < next) whose hold covers t (t < break_t); {} if none.
static func clinch_at(beats: Array, next: int, t: float) -> Dictionary:
	return _spell_at(beats, next, t, "clinch", "break_t", CLINCH_LOOK_S)


## The `move` beat already fired (index < next) whose window covers t (t < its `until` key), looked for `look` s back.
static func _spell_at(beats: Array, next: int, t: float, move: String, until: String, look: float) -> Dictionary:
	var i := mini(next, beats.size()) - 1
	while i >= 0 and float(beats[i]["t"]) >= t - look:
		if str(beats[i]["move"]) == move and t < float(beats[i].get(until, -1.0)):
			return beats[i]
		i -= 1
	return {}


static func _who(b: Dictionary) -> int:
	return 0 if str(b.get("who", "a")) == "a" else 1


## Review round 1 (blind review: "once a punch fires, the wanted distance moves on to the following punch while this one is
## still in the air"): the last punch fired whose glove has not landed yet (BeatFire writes its contact time), {} if none.
static func _in_flight(beats: Array, next: int, t: float) -> Dictionary:
	var i := mini(next, beats.size()) - 1
	while i >= 0 and float(beats[i]["t"]) >= t - FLIGHT_LOOK_S:
		var b: Dictionary = beats[i]
		if b.has("contact_t") and t < float(b["contact_t"]) and (RoundScript.PUNCHES.has(str(b["move"])) or MORE_PUNCHES.has(str(b["move"]))):
			return b
		i -= 1
	return {}


## The nearest punch beat from index i walking by `dir` (+1 forward, -1 back); {} if none.
static func _punch(beats: Array, i: int, dir: int) -> Dictionary:
	while i >= 0 and i < beats.size():
		if RoundScript.PUNCHES.has(str(beats[i]["move"])) or (step4 and MORE_PUNCHES.has(str(beats[i]["move"]))):
			return beats[i]
		i += dir
	return {}
