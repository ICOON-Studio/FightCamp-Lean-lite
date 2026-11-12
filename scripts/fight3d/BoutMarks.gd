extends RefCounted
## S439 DAMAGESHOW1 (operator: "Stop, show damage"): the bout's body map from its SETTLED rounds, for a bout the ring did
## not show to the last bell (Skip bout, a words bout, a headless run). Before this the result page read the live map
## only (BodyLive), so a bout skipped after round 1 said "Nothing lasting" after a stoppage loss.
## The same path the ring takes (FightView._queue): each closed round's exchanges -> ExchangeBeats.build (the same seed,
## styles and energy) -> BodyMap.add_beats. No corner work is replayed (the cutman's closed cut, the enswell): those last
## one round and the corner of a skipped round is the coach's own.
##   build(c, f, m) -> map   (BodyMap.fresh() shape; every round in m["rounds"])
##   seen_all(m) -> bool     (the ring's own map covers every round fought)

const BodyMap := preload("res://scripts/rules/BodyMap.gd")
const ExchangeBeats := preload("res://scripts/fight3d/ExchangeBeats.gd")
const Exchanges := preload("res://scripts/rules/Exchanges.gd")
const RoundStyle := preload("res://scripts/rules/RoundStyle.gd")


## True when BodyLive rang the bell on every round of the bout: its map is the whole fight (and has the corner's work).
static func seen_all(m: Dictionary) -> bool:
	var map: Dictionary = m.get("body_map", {})
	return not map.is_empty() and map.has("a") and int(m.get("body_bells", 0)) >= (m.get("rounds", []) as Array).size()


static func build(c: Career, f: Dictionary, m: Dictionary) -> Dictionary:
	var map := BodyMap.fresh()
	var opp: Dictionary = (f.get("bout", {}) as Dictionary).get("opp", {})
	var south := {"a": str(f.get("stance", "")).to_lower() == "southpaw", "b": str(opp.get("stance", "")).to_lower() == "southpaw"}
	var profiles := {"a": RoundStyle.of_fighter(f), "b": RoundStyle.from_opponent(opp)}
	var won_last := false
	var rounds: Array = m.get("rounds", [])
	for i in rounds.size():
		var r: Dictionary = rounds[i]
		var n := i + 1
		var ctx := {"n": n, "plan": str(r.get("corner", "")), "a_style": str(f.get("style", "")),
			"b_style": str(opp.get("style", "")), "seed": c.day * 97 + n, "profiles": profiles, "f": f, "opp": opp,
			"names": [str(f.get("first", "")), str(opp.get("first", opp.get("name", "")))], "day": c.day, "won_last": won_last}
		var e: Dictionary = r.get("energy", {})
		var exs: Array = r.get("exchanges", [])
		for k in exs.size():
			for side in ["a", "b"]:
				var e0 := float(e.get(side, 100.0))
				var e1 := float(e.get(side + "_end", e0))
				profiles[side]["energy"] = lerpf(e0, e1, float(k) / Exchanges.EXCHANGES)
				profiles[side]["energy_end"] = lerpf(e0, e1, float(k + 1) / Exchanges.EXCHANGES)
			BodyMap.add_beats(map, ExchangeBeats.build(exs[k], k, r if k == exs.size() - 1 else {}, ctx), south)
		BodyMap.end_round(map)
		won_last = bool(r.get("won", false))
	return map
