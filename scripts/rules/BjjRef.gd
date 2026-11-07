extends RefCounted
## S397 BJJREAL (ops/research/BJJ_REALISM_S397.md 3.5): the bell, as the IBJJF referee reads it - no coin.
## Order: points, advantages, penalties (fewer wins), then the referee's decision on who was more offensive.
## - STALLING: a hold (a beat, ~33 s, with no attempt) in a neutral or guard position is a stall; STALL_PER_PEN of them
##   (~66 s, the referee's 20-s count with room) = one penalty. Holding a pin (mount, back, side control, knee on belly,
##   north-south) or defending under one is never stalling (IBJJF; v2, all three critics: v1 penalised riding mount).
##   IBJJF steps: the 1st penalty is marked only, the 2nd gives the opponent an advantage, the 3rd two points (a 4th, a
##   disqualification, never happens in a walk this short).
## - OFFENCE: every non-BASE attempt adds OFF_W of its kind (a submission attempt counts most; a miss half - v2, the
##   veteran: a missed shot is not a landed one), every beat on top TOP_W (holds too). The decision goes to the higher share; inside CLOSE of even it is a judgement call,
##   weighted by the shares (never a flat coin unless both did exactly the same).
## Pure static; no preloads.

const STALL_PER_PEN := 2
const MISS_W := 0.5
## Node ids starting with these are pins: no stall on top (holding it properly) or underneath (defending).
const PINS := ["mount_", "back_", "side_control_", "knee_on_belly_", "north_south_"]
## [G] the referee's eye (the IBJJF decision favours the athlete who sought the submission and the dominant positions,
## then the more offensive one; the weights are ours).
const OFF_W := {"submission": 3.0, "pass": 2.0, "sweep": 2.0, "takedown": 2.0, "back_take": 2.0, "entry": 1.0,
	"transition": 1.0, "escape": 0.5}
const TOP_W := 0.5
const CLOSE := 0.05


static func new_tally() -> Dictionary:
	return {"off": [0.0, 0.0], "stall": [0, 0], "pen": [0, 0]}


static func attempt(t: Dictionary, s: int, kind: String, hit: bool = true) -> void:
	t["off"][s] = float(t["off"][s]) + float(OFF_W.get(kind, 0.0)) * (1.0 if hit else MISS_W)


static func on_top(t: Dictionary, s: int, w: float = 1.0) -> void:
	t["off"][s] = float(t["off"][s]) + TOP_W * w


static func is_pin(node_id: String) -> bool:
	for p in PINS:
		if node_id.begins_with(p):
			return true
	return false


## A hold by side s on node_id (s's own view): a stall unless it is a pin. Returns the IBJJF consequence for the other side.
static func hold(t: Dictionary, s: int, node_id: String) -> String:
	if is_pin(node_id):
		return ""
	return stall(t, s)


## A stall by side s; returns the IBJJF consequence for the other side: "" | "advantage" | "points".
static func stall(t: Dictionary, s: int) -> String:
	t["stall"][s] = int(t["stall"][s]) + 1
	if int(t["stall"][s]) % STALL_PER_PEN != 0:
		return ""
	t["pen"][s] = int(t["pen"][s]) + 1
	match int(t["pen"][s]):
		2:
			return "advantage"
		3:
			return "points"
	return ""


## The bell: {winner 0|1, by points|advantages|penalties|decision, share (side 0's offence share), call (true = a
## judgement call inside CLOSE)}.
static func decide(score: Array, adv: Array, t: Dictionary, rng: RandomNumberGenerator) -> Dictionary:
	if int(score[0]) != int(score[1]):
		return {"winner": 0 if int(score[0]) > int(score[1]) else 1, "by": "points"}
	if int(adv[0]) != int(adv[1]):
		return {"winner": 0 if int(adv[0]) > int(adv[1]) else 1, "by": "advantages"}
	var pen: Array = t.get("pen", [0, 0])
	if int(pen[0]) != int(pen[1]):
		return {"winner": 0 if int(pen[0]) < int(pen[1]) else 1, "by": "penalties"}
	var off: Array = t.get("off", [0.0, 0.0])
	var tot := float(off[0]) + float(off[1])
	var share := 0.5 if tot <= 0.0 else float(off[0]) / tot
	if absf(share - 0.5) >= CLOSE:
		return {"winner": 0 if share > 0.5 else 1, "by": "decision", "share": share, "call": false}
	return {"winner": 0 if rng.randf() < share else 1, "by": "decision", "share": share, "call": true}
