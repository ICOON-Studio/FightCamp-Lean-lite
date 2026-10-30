extends RefCounted
## S305 hitstun (operator: "still no reaction animation on body shots"). The S305 film's joins log: a landed body shot's
## gut-shot reaction was overwritten by the next beat - a back-dodge the same frame (39.1 s), a block 0.3 s in (94.0 s), a
## fidget (80.7 s) - so the punch landed and she carried on. Shipped fighting games lock a hit boxer in her reaction
## (hitstun): while it plays out she cannot start a defence, a fidget or a step; a new hit restarts it, her own punches,
## the count and the KO still play. The lock lasts until the reaction is back in guard: BeatClips.REACT_PEAK_S to its peak,
## then the rest of the clip to clip_recovery's back_s at the recovery speed (capped at MAX_S).

const BeatClips := preload("res://scripts/fight3d/BeatClips.gd")
const MAX_S := 1.0
## S311 real-fight gap 2 (Game Godot/research/S310_REAL_FIGHT_GAPS.md): a plain head shot (not hurt, not the round's big
## shot) snaps her head and she fights on - real boxers counter at +0.16 s and are upright by +0.3 s (R1 2:10.9, R2
## 4:52.3); ours stood locked in the whole reaction 0.67 s. She is locked to the snap's peak plus a short settle, the
## reaction is cut HEAD_SETTLE_S after its peak and the join smoother eases her back into her guard. Hurt, big and body
## shots keep the full lock.
const HEAD_LOCK_S := 0.28
const HEAD_SETTLE_S := 0.12
## Clip names that are a defence, a fidget or a tired idle (blocked while she is stunned).
const BLOCKED := ["dodge", "weave", "block", "fidget", "idle_tired", "slighty_tired", "slip", "pull"]

var _left: Array = [0.0, 0.0]


func tick(delta: float) -> void:
	for i in _left.size():
		_left[i] = maxf(0.0, float(_left[i]) - delta)


func left(who: int) -> float:
	return float(_left[who])


func clear(who: int) -> void:
	_left[who] = 0.0


## A hit reaction `clip` starts at recovery `speed`: lock her until it is back in guard (`light`: a plain head shot).
func start(who: int, clip: String, speed: float, light: bool = false) -> void:
	if light:
		_left[who] = HEAD_LOCK_S
		return
	var r := BeatClips.recovery(clip)
	var pk := BeatClips.peak(clip)
	var s := BeatClips.REACT_PEAK_S + maxf(0.0, r.y - maxf(pk, 0.0)) / maxf(speed, 0.1) if r.y > 0.0 else 0.5
	_left[who] = minf(s, MAX_S)


## True when `move` may not start on a stunned boxer.
func blocks(who: int, move: String) -> bool:
	if float(_left[who]) <= 0.0:
		return false
	for w in BLOCKED:
		if move.contains(w):
			return true
	return false


## The recovery cut for a front-loaded reaction (fast to its peak, then `speed`), or {} when it plays at one speed.
static func react_cut(clip: String, speed: float, fast: float) -> Dictionary:
	var pk := BeatClips.peak(clip)
	if fast <= speed or pk <= 0.0:
		return {}
	return {"clip": clip, "contact": pk, "back": BeatClips.recovery(clip).y, "fast": false, "scale": speed / fast}


## S311: a plain head shot's reaction (playing at `fast` to its peak) hands back to the guard HEAD_SETTLE_S after the peak.
static func head_cut(clip: String, fast: float) -> Dictionary:
	var pk := BeatClips.peak(clip)
	if pk <= 0.0:
		return {}
	return {"clip": clip, "contact": -1.0, "back": pk + HEAD_SETTLE_S * fast, "fast": false, "scale": 1.0}
