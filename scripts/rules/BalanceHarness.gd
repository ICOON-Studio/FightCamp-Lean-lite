extends RefCounted
## Balance harness: measures win share across training, camp, film and opponent.
## Pure static functions, no class_name. Loads BoutRules with preload. Never edits BoutRules.

const B := preload("res://scripts/rules/BoutRules.gd")
const Bouts := preload("res://scripts/state/Bouts.gd")
const Data := preload("res://scripts/state/Data.gd")
const Combos := preload("res://scripts/rules/Combos.gd")


## Play a full bout. Returns {verdict, rounds_won, rounds: Array}.
static func bout(stats: Dictionary, camp: Dictionary, film_depth: int, opp: Dictionary,
		rng: RandomNumberGenerator, corner_mode: String = "auto",
		weapons_bonus: float = 0.0) -> Dictionary:
	var rounds_won: int = 0
	var rounds_arr: Array = []
	for r in B.ROUNDS:
		var n: int = r + 1
		var corner: String = ""
		if n > 1:
			if corner_mode == "auto":
				corner = B.auto_corner(stats)
			else:
				corner = corner_mode
		var roll_a: float = rng.randf()
		var roll_b: float = rng.randf()
		var result: Dictionary = B.play_round(n, stats, camp, film_depth, corner, opp, roll_a, roll_b, weapons_bonus)
		rounds_arr.append(result)
		if bool(result["won"]):
			rounds_won += 1
	var cards: Array = B.scorecards(rounds_won)
	var v: String = B.verdict(cards)
	return {"verdict": v, "rounds_won": rounds_won, "rounds": rounds_arr}


## Win share over n bouts with one seeded RNG.
static func win_share(stats: Dictionary, camp: Dictionary, film_depth: int, opp: Dictionary,
		n: int, seed: int, corner_mode: String = "auto") -> float:
	var rng := RandomNumberGenerator.new()
	rng.seed = seed
	var wins: int = 0
	for _i in n:
		var result: Dictionary = bout(stats, camp, film_depth, opp, rng, corner_mode)
		if str(result["verdict"]) == "win":
			wins += 1
	return float(wins) / float(n)


## Expected per-round margin: fight_power - opp.rating for the round-2 corner.
static func edge(stats: Dictionary, camp: Dictionary, film_depth: int, opp: Dictionary,
		corner_mode: String = "auto") -> float:
	var corner: String = ""
	if corner_mode == "auto":
		corner = B.auto_corner(stats)
	else:
		corner = corner_mode
	return B.fight_power(stats, camp, film_depth, corner) - float(opp.get("rating", 60.0))


## Build a fighter profile with uneven stats.
## variant 0: power-leaning (power +6, defense -6)
## variant 1: defense-leaning (defense +6, power -6)
static func make_stats(avg: int, variant: int = 0) -> Dictionary:
	var base: float = float(avg)
	if variant == 0:
		return {"power": base + 6.0, "speed": base, "technique": base,
				"defense": base - 6.0, "conditioning": base, "fight_iq": base}
	else:
		return {"power": base - 6.0, "speed": base, "technique": base,
				"defense": base + 6.0, "conditioning": base, "fight_iq": base}


## Build a camp dictionary.
static func make_camp(protocol: int, focus: String = "conditioning") -> Dictionary:
	if protocol == 0:
		return {}
	return {"protocol": protocol, "focus": focus}


## The grid: 4 averages x 4 protocols x 2 film depths x 3 opponent ratings = 96 rows.
static func grid(seed: int, n: int = 400) -> Array:
	var rows: Array = []
	var avgs: Array = [55, 60, 65, 70]
	var protocols: Array = [0, 1, 2, 3]
	var films: Array = [1, 3]
	var opp_ratings: Array = [58, 62, 66]
	var row_seed: int = seed
	for avg in avgs:
		for proto in protocols:
			for film in films:
				for opp_r in opp_ratings:
					var stats: Dictionary = make_stats(avg, 0)
					var camp: Dictionary = make_camp(proto)
					var opp: Dictionary = {"rating": float(opp_r)}
					var e: float = edge(stats, camp, film, opp)
					var ws: float = win_share(stats, camp, film, opp, n, row_seed)
					rows.append({"avg": avg, "protocol": proto, "film_depth": film,
							"opp_rating": opp_r, "edge": e, "win_share": ws})
					row_seed += 1
	return rows


## Build a fighter dict for the live bout harness (goes through Bouts._energy + BoutRules.play_round).
## moves: every Data.MOVES at mastery 30 (the weapon threshold); camp protocol 2 conditioning focus.
static func make_fighter(avg: int, conditioning: float, combos: Dictionary, opp_index: int) -> Dictionary:
	var stats: Dictionary = make_stats(avg, 0)
	stats["conditioning"] = conditioning
	var moves: Dictionary = {}
	for m in Data.MOVES:
		moves[m] = 30.0
	return {
		"stats": stats,
		"combos": combos.duplicate(),
		"moves": moves,
		"camp": {"protocol": 2, "focus": "conditioning"},
		"bout": {"opp": Data.OPPONENTS[opp_index].duplicate(true), "film": 1},
	}


## Ramp tiredness: linear from 0 at FRESH_AT to RAMP_MAX at energy 0.
static func _ramp(energy: float, ramp_max: float) -> float:
	return maxf(0.0, (Combos.FRESH_AT - energy) / Combos.FRESH_AT) * ramp_max


## Play a full bout through the game's real round path (Bouts._energy + BoutRules.play_round).
## corners[0] = "" (round 1), corners[1..] = corner calls for rounds 2+. Mutates f (energy tank).
## spread: effective ROUND_SPREAD (default = game's value; rescales rolls to match).
## tired: "game" = Combos.tired_penalty; "ramp" = linear from FRESH_AT to 0, max ramp_max power points.
## Returns {verdict, rounds: [{n, won, a, a_end, b, b_end, bonus, ...}]}.
static func live_bout(f: Dictionary, corners: Array, rng: RandomNumberGenerator,
		spread: float = B.ROUND_SPREAD, tired: String = "game", ramp_max: float = 2.0) -> Dictionary:
	var rounds_arr: Array = []
	var rounds_won: int = 0
	for r in B.ROUNDS:
		var n: int = r + 1
		var corner: String = ""
		if n - 1 < corners.size():
			corner = str(corners[n - 1])
		var e: Dictionary = Bouts._energy(f, n, corner)
		var we: float = B.weapons_edge(B.weapons(f.get("moves", {})))
		var w_bonus: float = we + float(e["bonus"])
		if tired == "ramp":
			var a_end: float = float(e["a_end"])
			var b_end: float = float(e["b_end"])
			w_bonus = we + float(e["bonus"]) + Combos.tired_penalty(a_end) - Combos.tired_penalty(b_end) - _ramp(a_end, ramp_max) + _ramp(b_end, ramp_max)
		var roll_a: float = rng.randf()
		var roll_b: float = rng.randf()
		var scaled_a: float = 0.5 + (roll_a - 0.5) * (spread / B.ROUND_SPREAD)
		var scaled_b: float = 0.5 + (roll_b - 0.5) * (spread / B.ROUND_SPREAD)
		var camp: Dictionary = f.get("camp", {})
		var film: int = int(f["bout"].get("film", 1))
		var opp: Dictionary = f["bout"]["opp"]
		var result: Dictionary = B.play_round(n, f["stats"], camp, film, corner, opp, scaled_a, scaled_b, w_bonus)
		result["a"] = float(e["a"])
		result["a_end"] = float(e["a_end"])
		result["b"] = float(e["b"])
		result["b_end"] = float(e["b_end"])
		result["bonus"] = w_bonus
		rounds_arr.append(result)
		if bool(result["won"]):
			rounds_won += 1
	var cards: Array = B.scorecards(rounds_won)
	var v: String = B.verdict(cards)
	return {"verdict": v, "rounds": rounds_arr}


## Round-by-round win share over n bouts, plus mean energy at the start of round 3.
## f is duplicated per bout (energy tank resets). seed drives one shared RNG across all n bouts.
## spread / tired / ramp_max pass through to live_bout.
static func round_shares(f: Dictionary, corners: Array, n: int, seed: int,
		spread: float = B.ROUND_SPREAD, tired: String = "game", ramp_max: float = 2.0) -> Dictionary:
	var rng := RandomNumberGenerator.new()
	rng.seed = seed
	var r1_wins: int = 0
	var r2_wins: int = 0
	var r3_wins: int = 0
	var bout_wins: int = 0
	var bell3_total: float = 0.0
	for _i in n:
		var fc: Dictionary = f.duplicate(true)
		var result: Dictionary = live_bout(fc, corners, rng, spread, tired, ramp_max)
		var rounds: Array = result["rounds"]
		if bool((rounds[0] as Dictionary)["won"]):
			r1_wins += 1
		if bool((rounds[1] as Dictionary)["won"]):
			r2_wins += 1
		if bool((rounds[2] as Dictionary)["won"]):
			r3_wins += 1
		if str(result["verdict"]) == "win":
			bout_wins += 1
		bell3_total += float((rounds[2] as Dictionary)["a"])
	return {
		"r1": float(r1_wins) / float(n),
		"r2": float(r2_wins) / float(n),
		"r3": float(r3_wins) / float(n),
		"bout": float(bout_wins) / float(n),
		"bell3_energy": bell3_total / float(n),
	}


## BALANCE3 what-if sweep: spread x tired x conditioning x rating edge.
## Rows: spread 6/10/14/18 x tired game/ramp x cond 50/80 x avg 55/60/65/70 vs OPPONENTS[0].
## Each row: {spread, tired, cond, avg, edge, r1, r3, bout}.
static func sweep(seed: int, n: int = 400) -> Array:
	var rows: Array = []
	var spreads: Array = [6.0, 10.0, 14.0, 18.0]
	var tired_modes: Array = ["game", "ramp"]
	var conds: Array = [50, 80]
	var avgs: Array = [55, 60, 65, 70]
	var corners: Array = ["", "body", "body"]
	var row_seed: int = seed
	for sp in spreads:
		for tm in tired_modes:
			for cond in conds:
				for avg in avgs:
					var f: Dictionary = make_fighter(avg, float(cond), {}, 0)
					var opp: Dictionary = Data.OPPONENTS[0]
					var camp: Dictionary = f.get("camp", {})
					var film: int = int(f["bout"].get("film", 1))
					var e: float = B.fight_power(f["stats"], camp, film, "body") - float(opp.get("rating", 60.0))
					var rs: Dictionary = round_shares(f, corners, n, row_seed, sp, tm)
					rows.append({"spread": sp, "tired": tm, "cond": cond, "avg": avg,
							"edge": e, "r1": float(rs["r1"]), "r3": float(rs["r3"]),
							"bout": float(rs["bout"])})
					row_seed += 1
	return rows
