extends RefCounted
## S345 FIGHTHUD2 (operator Q-S294-69 "Yes, build it"; Game Godot/research/FIGHTHUD_S344.md, beat the UFC 6 fight HUD): the
## six bars a boxer the fight HUD draws, read off what the ring already keeps - no rule of its own changes the fight.
## A bar is {fill, keep, known}: fill 0..1 what she has now; keep 0..1 the most she can still have this fight (the grey end
## past it is gone for good); known false = the HUD shows "?" (the opponent's guard and heart until scouting found them).
##   bars(src) -> {head, body, legs, stamina, guard, heart}   edge(exchanges) -> -1 (blue's round) .. 1 (red's round)
##   heart(attr, counts, hurt_moments) -> 0..1   guard_known(opp)   heart_known(opp)   hurt_moments(exchanges, side)
## src: {places {BodyMap place: 0..100}, energy, energy_start, body_taken, burn {BodyLoad part: 0..100}, drop {lead, rear}
## 0..1 (the 3D's guard drop), heart_attr, counts, hurts, guard_known, heart_known}. Pure static; preloads OppFile and
## Exchanges (their names only).

const OppFile := preload("res://scripts/rules/OppFile.gd")
const Exchanges := preload("res://scripts/rules/Exchanges.gd")

const ORDER := ["head", "body", "legs", "stamina", "guard", "heart"]
const HEAD_PLACES := ["head", "left_eye", "right_eye", "nose"]
const RIB_PLACES := ["left_ribs", "right_ribs"]
## Tiring shoulders show on the guard bar before the 3D drops a glove: up to TIRE_SHOW of the bar from the shoulders' Burn,
## the glove the 3D really drops takes the rest.
const TIRE_SHOW := 0.6
## A standing count and a hurt moment take this much off her will to go on, times (HEART_BASE - heart / 100): a heart-55
## boxer is near empty at the 4th count, where the referee stops it (Knockdowns: four in the bout).
const KD_COST := 0.22
const HURT_COST := 0.06
const HEART_BASE := 1.5
## Round edge, the round's own rule (Exchanges.round_of: most exchanges won, a split goes to the bigger margin): each
## exchange won is a third of the meter (EDGE_FULL net fill it), the margins only nudge it (TIE_NUDGE at most).
const EDGE_FULL := 3.0
const TIE_NUDGE := 0.15


static func bars(src: Dictionary) -> Dictionary:
	var places: Dictionary = src.get("places", {})
	var burn: Dictionary = src.get("burn", {})
	var head := _worst(places, HEAD_PLACES)
	var body := _worst(places, RIB_PLACES)
	var energy := clampf(float(src.get("energy", 100.0)) / 100.0, 0.0, 1.0)
	# Every body shot greys a slice off the end of her tank for the fight (Exchanges.BODY_COST); the round's start caps it.
	var cap := minf(float(src.get("energy_start", 100.0)), 100.0 - float(src.get("body_taken", 0)) * Exchanges.BODY_COST)
	var keep := clampf(cap / 100.0, energy, 1.0)
	var drop: Dictionary = src.get("drop", {})
	var tire := (float(burn.get("lead_shoulder", 0.0)) + float(burn.get("rear_shoulder", 0.0))) / 200.0
	var sink := (float(drop.get("lead", 0.0)) + float(drop.get("rear", 0.0))) / 2.0
	var guard := clampf(1.0 - maxf(tire * TIRE_SHOW, sink), 0.0, 1.0)
	var will := heart(float(src.get("heart_attr", 55.0)), int(src.get("counts", 0)), int(src.get("hurts", 0)))
	return {
		"head": _bar(head, head, true),
		"body": _bar(body, body, true),
		"legs": _bar(1.0 - float(burn.get("legs", 0.0)) / 100.0, 1.0, true),
		"stamina": _bar(energy, keep, true),
		"guard": _bar(guard, 1.0, bool(src.get("guard_known", true))),
		"heart": _bar(will, will, bool(src.get("heart_known", true))),
	}


## How far she is from quitting: standing counts and hurt moments wear it down; her Heart decides how much each costs.
static func heart(attr: float, counts: int, hurt_moments: int) -> float:
	var per := HEART_BASE - clampf(attr, 0.0, 100.0) / 100.0
	return clampf(1.0 - (counts * KD_COST + hurt_moments * HURT_COST) * per, 0.0, 1.0)


## Who has this round so far: each watched exchange's margin, red (her) positive.
static func edge(exchanges: Array) -> float:
	var net := 0
	var sum := 0.0
	for x in exchanges:
		var margin := float((x as Dictionary).get("margin", 0.0))
		net += 1 if bool((x as Dictionary).get("won", margin >= 0.0)) else -1
		sum += margin
	return clampf(net / EDGE_FULL + TIE_NUDGE * clampf(sum / Exchanges.HURT_AT, -1.0, 1.0), -1.0, 1.0)


## Exchanges that left this side hurt (side 0 = her, 1 = the opponent), from each exchange's "after" display state.
static func hurt_moments(exchanges: Array, side: int) -> int:
	var n := 0
	for x in exchanges:
		var h: Array = ((x as Dictionary).get("after", {}) as Dictionary).get("hurt", [false, false])
		if h.size() > side and bool(h[side]):
			n += 1
	return n


## Her guard shows once the film found a habit of hers (the tape room's SPOT: her hands drop, she lunges, she admires);
## with no habit on file, her best weapon is enough.
static func guard_known(opp: Dictionary) -> bool:
	var habits := OppFile.tells(opp).filter(func(t): return str(t["id"]).begins_with("habit:"))
	if habits.is_empty():
		return OppFile.known(opp, "weapon")
	return habits.any(func(t): return OppFile.known(opp, str(t["id"])))


## Her heart shows once the file is read to the end: her weakness (what breaks her) is the last thing tape study opens.
static func heart_known(opp: Dictionary) -> bool:
	return OppFile.known(opp, "weakness")


static func _worst(places: Dictionary, keys: Array) -> float:
	var v := 100.0
	for k in keys:
		v = minf(v, float(places.get(k, 100.0)))
	return clampf(v / 100.0, 0.0, 1.0)


static func _bar(fill: float, keep: float, known: bool) -> Dictionary:
	var f := clampf(fill, 0.0, 1.0)
	return {"fill": f, "keep": clampf(maxf(keep, f), 0.0, 1.0), "known": known}
