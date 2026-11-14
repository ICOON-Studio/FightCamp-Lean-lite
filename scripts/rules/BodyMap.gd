extends RefCounted
## The six places on each boxer where punches land, the round's punch tally, and the corner's fixes.
## Pure static module over the beat format from RoundScript / InsideBeats / ClinchBeats.

const PLACES := ["head", "left_eye", "right_eye", "nose", "left_ribs", "right_ribs"]
const FACE_PLACES := ["left_eye", "right_eye", "nose"]
## Settled bands (topics/body_damage.md): fine > 55, hurt <= 55, critical <= 35, doctor <= 15.
const HURT := 55.0
const CRITICAL := 35.0
const DOCTOR := 15.0
## Points one landed punch takes off. S318: tuned on test 5 - 3 rounds of 6 exchanges as the game plays them (BoutRules
## spread, 300 seeds): loser hurt 40-90 %, doctor <= 8 %, winner fine >= 50 %.
## S438: 1.1 -> 1.15 after the body count match. S439: 1.18 / 0.59 / 2.9, re-measured on the merged tree after PUNCHSTART1
## (one punch rule for both corners) over EIGHT 200-day windows of tests/rib_damage_test.gd (tools/rib_sweep.gd,
## docs/RIBS1_RESULT.md): S318 loser hurt mean 43.4 % (40-90), body plan rib at or under 35 mean 9.8 % (at most 20), body
## plan hurt 67.9 %, the unit list (body_map test 5) 89.3 % (40-90). Face 1.185+ takes the unit list over 90; 1.175- leaves
## loser hurt under 43.
const FACE_HIT := 1.18
const HEAD_HIT := 0.59
## RIBS1: was 1.5, too small to reach the hurt line; 3.1 in S438 (one window). S439: 2.9 (above). The rib reads move in steps
## of whole hooks: 2.9 sits in 2.83-2.95, where hurt (<= 55) takes 16 hooks and critical (<= 35) takes 23.
const RIB_HIT := 2.9
const BIG_MULT := 2.0
## PaceAim.LIVER_SHARE. Not a preload: this module stays pure. The DEFENDER's liver side gets this share, as PaceAim.opp_hurt
## reads it: her right ribs when she is orthodox, her left when she is southpaw.
const LIVER_SHARE := 0.6
const CUT_MULT := 1.5
const PUNCHES := ["jab", "cross", "lead_hook", "body_hook", "rear_uppercut"]


static func fresh() -> Dictionary:
	var a_places := {}
	var b_places := {}
	for p in PLACES:
		a_places[p] = 100.0
		b_places[p] = 100.0
	return {"a": {"places": a_places, "cuts": {}, "relief": {}, "closed": {}},
		"b": {"places": b_places, "cuts": {}, "relief": {}, "closed": {}}}


static func _ensure(map: Dictionary, who: String) -> void:
	var d: Dictionary = map[who]["places"]
	if d.is_empty():
		for p in PLACES:
			d[p] = 100.0


## Where a landed punch goes. Returns [{place, dmg}, ...].
## Random picks use hash(str(beat.t)+str(beat.who)+str(beat.move)) for determinism.
static func _punch_hits(beat: Dictionary, attacker_south: bool, def_south: bool = false) -> Array:
	var m: String = str(beat["move"])
	var opp_side: String = "left" if attacker_south else "right"
	var is_big: bool = bool(beat.get("big", false))
	var mult: float = BIG_MULT if is_big else 1.0
	var h: int = hash(str(beat["t"]) + str(beat["who"]) + str(beat["move"]))
	var out: Array = []
	if m == "jab":
		if (h % 100) < 60:
			out.append({"place": "nose", "dmg": FACE_HIT * mult})
		else:
			out.append({"place": opp_side + "_eye", "dmg": FACE_HIT * mult})
		out.append({"place": "head", "dmg": HEAD_HIT * mult})
	elif m == "cross":
		if (h % 100) < 50:
			out.append({"place": "nose", "dmg": FACE_HIT * mult})
		else:
			out.append({"place": opp_side + "_eye", "dmg": FACE_HIT * mult})
		out.append({"place": "head", "dmg": HEAD_HIT * mult})
	elif m == "lead_hook":
		out.append({"place": opp_side + "_eye", "dmg": FACE_HIT * mult})
		out.append({"place": "head", "dmg": HEAD_HIT * 1.5 * mult})
	elif m == "rear_uppercut":
		out.append({"place": "nose", "dmg": FACE_HIT * mult})
		out.append({"place": "head", "dmg": HEAD_HIT * 1.5 * mult})
	elif m == "body_hook":
		# A carried "side" wins. Otherwise the same hash as the face punches: the defender's liver side LIVER_SHARE of the
		# time, the other side the rest. S466 (LIVERRIBS1 v2 s2, anatomy): the liver is on the RIGHT of every body, orthodox
		# or southpaw (it was swapped for a southpaw defender).
		var rib := str(beat.get("side", ""))
		if rib != "left" and rib != "right":
			var liver := "right"
			var other := "right" if liver == "left" else "left"
			rib = liver if absi(h) % 100 < roundi(LIVER_SHARE * 100.0) else other
		out.append({"place": rib + "_ribs", "dmg": RIB_HIT * mult})
	return out


static func add_beats(map: Dictionary, beats: Array, south: Dictionary) -> void:
	for beat in beats:
		var m: String = str(beat["move"])
		if not (m in PUNCHES):
			continue
		if str(beat["result"]) != "lands":
			continue
		var who: String = str(beat["who"])
		var def: String = "a" if who == "b" else "b"
		_ensure(map, def)
		var att_south: bool = bool(south.get(who, false))
		var hits: Array = _punch_hits(beat, att_south, bool(south.get(def, false)))
		for hit in hits:
			var place: String = str(hit["place"])
			var dmg: float = float(hit["dmg"])
			var places: Dictionary = map[def]["places"]
			if not places.has(place):
				places[place] = 100.0
			var cur: float = float(places[place])
			if place in FACE_PLACES:
				var cuts: Dictionary = map[def]["cuts"]
				var closed: Dictionary = map[def]["closed"]
				if cuts.has(place) and not closed.get(place, false):
					dmg *= CUT_MULT
			cur -= dmg
			if cur < 0.0:
				cur = 0.0
			places[place] = cur
			if place in FACE_PLACES and cur <= CRITICAL:
				map[def]["cuts"][place] = true


static func value(map: Dictionary, who: String, place: String) -> float:
	_ensure(map, who)
	var v: float = float(map[who]["places"][place])
	var relief: Dictionary = map[who]["relief"]
	if relief.has(place):
		v += float(relief[place])
	return minf(v, 100.0)


static func band(v: float) -> String:
	if v > HURT:
		return "fine"
	if v > CRITICAL:
		return "hurt"
	if v > DOCTOR:
		return "critical"
	return "doctor"


static func tally(beats: Array) -> Dictionary:
	var out := {"a": {"thrown": {}, "landed": {}, "pct": {}},
		"b": {"thrown": {}, "landed": {}, "pct": {}}}
	var kinds := ["jab", "straight", "hook", "uppercut", "body", "total"]
	for side in ["a", "b"]:
		for k in kinds:
			out[side]["thrown"][k] = 0
			out[side]["landed"][k] = 0
			out[side]["pct"][k] = 0
	for beat in beats:
		var m: String = str(beat["move"])
		if not (m in PUNCHES):
			continue
		var who: String = str(beat["who"])
		var kind: String = _move_to_kind(m)
		out[who]["thrown"][kind] = int(out[who]["thrown"][kind]) + 1
		out[who]["thrown"]["total"] = int(out[who]["thrown"]["total"]) + 1
		if str(beat["result"]) == "lands":
			out[who]["landed"][kind] = int(out[who]["landed"][kind]) + 1
			out[who]["landed"]["total"] = int(out[who]["landed"]["total"]) + 1
	for side in ["a", "b"]:
		for k in kinds:
			var t: int = int(out[side]["thrown"][k])
			var l: int = int(out[side]["landed"][k])
			if t > 0:
				out[side]["pct"][k] = int(float(l) * 100.0 / float(t))
	return out


static func _move_to_kind(move: String) -> String:
	if move == "jab":
		return "jab"
	if move == "cross":
		return "straight"
	if move == "lead_hook":
		return "hook"
	if move == "rear_uppercut":
		return "uppercut"
	if move == "body_hook":
		return "body"
	return "total"


static func corner(map: Dictionary, who: String, cutman: String, second: String) -> void:
	_ensure(map, who)
	if cutman == "enswell_left" or cutman == "enswell_right":
		var eye: String = "left_eye" if cutman == "enswell_left" else "right_eye"
		var v: float = float(map[who]["places"][eye])
		if v > HURT:
			return
		var target: float
		if v <= DOCTOR:
			target = DOCTOR + 1.0
		elif v <= CRITICAL:
			target = CRITICAL + 1.0
		else:
			target = HURT + 1.0
		map[who]["relief"][eye] = target - v
	elif cutman == "cut":
		var cuts: Dictionary = map[who]["cuts"]
		for place in cuts:
			map[who]["closed"][place] = true
	if second == "ice_left" or second == "ice_right":
		var ribs: String = "left_ribs" if second == "ice_left" else "right_ribs"
		var v: float = float(map[who]["places"][ribs])
		map[who]["relief"][ribs] = 0.15 * (100.0 - v)


static func end_round(map: Dictionary) -> void:
	for who in ["a", "b"]:
		map[who]["relief"] = {}
		map[who]["closed"] = {}
