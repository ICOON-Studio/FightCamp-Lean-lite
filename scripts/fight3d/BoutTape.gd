extends RefCounted
## S495 FIGHTFILM1 (owner Q-S294-256 "Yes, build it"; map ops/research/FIGHTFILM1_MAP_V3_S495.md section 1 "Every punch"):
## the bout's punch list, kept on the bout record when it is booked, so the fight analysis page, the result page's Punch by
## punch tab and History read every punch of a bout the ring did not show (Skip bout, a words bout, a headless run) too.
## The same path the ring takes (BoutMarks / FightView._queue): each closed round's exchanges -> ExchangeBeats.build with
## the same seed, styles and energy. Kept: the punches only (FightLog.PUNCH moves that were thrown), with times inside
## their exchange, plus each punch's AFTER fact (what the thrower did next) and whether the ringside camera saw it -
## the same rates and habit raises a film of a past bout has (FilmBout.AFTER_KEYS / AFTER_BASE), for both corners.
##   build(c, f, m) -> Array of exchanges {i, round, at, mode, place, pinned, won, landed: [a, b], beats}
## FightLog.lines(tape.filter(round n), n) gives the page's lines for round n.

const ExchangeBeats := preload("res://scripts/fight3d/ExchangeBeats.gd")
const Exchanges := preload("res://scripts/rules/Exchanges.gd")
const RoundStyle := preload("res://scripts/rules/RoundStyle.gd")
const FightLog := preload("res://scripts/rules/FightLog.gd")
const FilmBout := preload("res://scripts/rules/FilmBout.gd")

## A beat's keys the tape keeps (the rest is the ring's staging: captions, bubbles, clinch and pivot timings).
const KEEP := ["t", "who", "move", "result", "big", "def"]
## The ringside camera sees about 2 punches in 3 (map 2.1), as on a film.
const SEEN := 2.0 / 3.0
## An admired combination: the second of two punches landing this close together (FilmBout's rule).
const COMBO_S := 1.5


static func build(c: Career, f: Dictionary, m: Dictionary) -> Array:
	var opp: Dictionary = (f.get("bout", {}) as Dictionary).get("opp", {})
	var profiles := {"a": RoundStyle.of_fighter(f), "b": RoundStyle.from_opponent(opp)}
	var habits := {"a": (f.get("habits", []) as Array).duplicate(), "b": RoundStyle.opponent_habits(opp)}
	var rng := RandomNumberGenerator.new()
	rng.seed = c.day * 101 + 495
	var won_last := false
	var out: Array = []
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
			var x: Dictionary = exs[k]
			var ring := ExchangeBeats.build(x, k, r if k == exs.size() - 1 else {}, ctx)
			out.append(exchange(x, k, n, ring, habits, rng))
		won_last = bool(r.get("won", false))
	return out


## One exchange of the tape from the ring's beats (absolute times in the round) - pure, so the test feeds it by hand.
static func exchange(x: Dictionary, k: int, n: int, ring: Array, habits: Dictionary, rng: RandomNumberGenerator) -> Dictionary:
	var at := float(k * Exchanges.EX_SECONDS)
	var beats: Array = []
	var landed := [0, 0]
	for b in ring:
		var bd: Dictionary = b
		if not FightLog.PUNCH.has(str(bd.get("move", ""))) or str(bd.get("result", "none")) == "none":
			continue
		var keep := {}
		for key in KEEP:
			keep[key] = bd.get(key, false if key == "big" else "")
		keep["t"] = snappedf(float(bd["t"]) - at, 0.01)
		keep["big"] = bool(keep["big"])
		if str(bd.get("habit", "")) != "":
			keep["habit"] = str(bd["habit"])   # the habit that fired on this punch: the live log marks a FILED one (map 4)
		beats.append(keep)
		if str(bd["result"]) == "lands":
			landed[0 if str(bd["who"]) == "a" else 1] += 1
	after_facts(beats, habits, rng)
	return {"i": k, "round": n, "at": at, "mode": str(x.get("mode", "")), "place": int(x.get("place", 0)),
		"pinned": bool(x.get("pinned", false)), "won": bool(x.get("won", false)), "landed": landed, "beats": beats}


## Each punch's AFTER fact for both corners: FilmBout's base rates; a side's habit raises its fact only after its trigger
## (the jab habits after that side's jab, admires after the second of two landings within COMBO_S), taken out of guard_up.
static func after_facts(beats: Array, habits: Dictionary, rng: RandomNumberGenerator) -> void:
	var last_land := {"a": -99.0, "b": -99.0}
	for b in beats:
		var bd: Dictionary = b
		var who := str(bd["who"])
		var mine: Array = habits.get(who, [])
		var rates: Array = (FilmBout.AFTER_BASE as Array).duplicate()
		var jab := str(bd["move"]) == "jab"
		_raise(rates, 2, 0.30, jab and mine.has("drops_right_after_jab"))
		_raise(rates, 5, 0.30, jab and mine.has("lunges_with_jab"))
		var t := float(bd["t"])
		var lands := str(bd["result"]) == "lands"
		_raise(rates, 4, 0.45, lands and mine.has("admires_her_work") and t - float(last_land[who]) <= COMBO_S)
		if lands:
			last_land[who] = t
		bd["after"] = _roll(rates, rng)
		bd["seen"] = rng.randf() < SEEN


static func _raise(rates: Array, idx: int, by: float, on: bool) -> void:
	if not on:
		return
	var take := minf(by, float(rates[0]))
	rates[idx] = float(rates[idx]) + take
	rates[0] = float(rates[0]) - take


static func _roll(rates: Array, rng: RandomNumberGenerator) -> String:
	var total := 0.0
	for r in rates:
		total += float(r)
	var roll := rng.randf() * total
	for i in rates.size():
		roll -= float(rates[i])
		if roll <= 0.0:
			return str(FilmBout.AFTER_KEYS[i])
	return str(FilmBout.AFTER_KEYS[0])
