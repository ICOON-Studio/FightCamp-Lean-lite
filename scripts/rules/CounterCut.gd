extends RefCounted
## S393 PUNCH INTERRUPTED (ops/research/TALE_OF_THE_TAPE_S392.md: a punch hit mid-throw STOPS; the reviewer's favourite moment).
## interrupt_probe: 4 of 124 hit reactions met a punch in flight, because boxers take turns. This moves a punch the sim already
## counted as stopped (blocked or missed) to start just before the other's landed punch arrives, so the hit cuts it off.
## Who lands what is unchanged: only `t` of a punch that never landed moves. Marked "stopped": BeatFire shows no defence or sound.
##   apply(beats, rng) -> the punch it moved, or {} (at most one an exchange; beats stays sorted)

const CHANCE := 0.7
## She starts this long after the other's punch: its contact comes about 0.4 s after it starts, so hers is mostly out by then.
const START_AFTER_S := 0.08
const REACH_S := 4.0
## Clear of her own punches (a flying punch makes the next wait) and of hits she is still reacting to (a reaction refuses a punch).
const OWN_CLEAR_S := 0.45
const HIT_CLEAR_S := 0.7
const CLINCH_CLEAR_S := 1.5
const PUNCHES := ["jab", "cross", "lead_hook", "rear_uppercut"]


static func apply(beats: Array, rng: RandomNumberGenerator) -> Dictionary:
	if rng.randf() >= CHANCE:
		return {}
	for hit in beats:
		if not (str(hit["move"]) in PUNCHES or str(hit["move"]) == "body_hook") or str(hit["result"]) != "lands":
			continue
		var moved := _partner(beats, hit)
		if moved.is_empty():
			continue
		moved["t"] = float(hit["t"]) + START_AFTER_S
		moved["stopped"] = true
		beats.sort_custom(func(a, b): return float(a["t"]) < float(b["t"]))
		return moved
	return {}


static func _partner(beats: Array, hit: Dictionary) -> Dictionary:
	var at := float(hit["t"])
	var her := "b" if str(hit["who"]) == "a" else "a"
	for b in beats:
		if str(b["who"]) == her and str(b["move"]) in PUNCHES and str(b["result"]) != "lands" and absf(float(b["t"]) - at) <= REACH_S \
				and str(b.get("combo_id", "")) == "" and not bool(b.get("combo", false)) and _clear(beats, b, at + START_AFTER_S, her):
			return b
	return {}


static func _clear(beats: Array, moving: Dictionary, start: float, her: String) -> bool:
	for b in beats:
		if b == moving:
			continue
		var t := float(b["t"])
		if str(b["move"]) == "clinch" and absf(t - start) < CLINCH_CLEAR_S:
			return false
		if str(b["who"]) == her and b.has("result") and str(b["result"]) != "none" and absf(t - start) < OWN_CLEAR_S:
			return false
		if str(b["who"]) != her and str(b.get("result", "")) == "lands" and t < start - START_AFTER_S and start - t < HIT_CLEAR_S:
			return false
	return true
