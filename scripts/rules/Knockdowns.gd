extends RefCounted
## Standing counts, knockdowns and stoppages (fight model step 2, Qwen KNOCKDOWN1). Pure. Tuned S300 to John J-KDRATES1
## (Godot/research/J_KDRATES1_JOHN.md in the old repo): women's club/national amateurs 5-12 bouts in 100 stopped (IBA Worlds
## 2018-23 counted), 10-25 with a count (his guess: no source publishes counts), 2-4 counted bouts per stoppage.
## Amateur rule: three counts in one round or four in the bout and the referee stops it (RSC).

const COUNTS_ROUND_STOP := 3
const COUNTS_BOUT_STOP := 4
const BASE_COUNT := 0.05          # chance of a count for the loser of a CLEAR round between equals (tunable)
const MARGIN_FACTOR := {"close": 0.3, "clear": 1.0, "dominant": 2.2}
const POWER_CHIN_SCALE := 12.0    # every 12 points of winner power over loser chin multiplies the chance by e
const DAMAGE_SCALE := 60.0        # accumulated head damage 60 doubles the chance
const DAMAGE_PER_ROUND := {"close": 8.0, "clear": 18.0, "dominant": 32.0}   # added to the round's loser
const WINNER_DAMAGE := 2.0
const REF_STOP := 0.2             # after a count: stop chance = REF_STOP * (1 + damage / 60) * (1.4 - heart / 100)
const KO_ODDS := 0.7             # the chance a hurt boxer stays down is (1 - heart / 100) * KO_ODDS
const KO_DAMAGE := 60.0           # head damage from which a count can become a KO (two clear rounds and a bad third)


static func round_counts(margin: String, loser: String, sides: Dictionary, damage: Dictionary, counts_so_far: Dictionary,
		rng: RandomNumberGenerator) -> Dictionary:
	var winner := "b" if loser == "a" else "a"
	var loser_side: Dictionary = sides[loser]
	var winner_side: Dictionary = sides[winner]
	var power: float = float(winner_side.get("power", 60))
	var chin: float = float(loser_side.get("chin", 60))
	var heart: float = float(loser_side.get("heart", 55))
	var loser_dmg: float = float(damage[loser])

	var damage_out := {"a": float(damage["a"]), "b": float(damage["b"])}
	damage_out[loser] = loser_dmg + float(DAMAGE_PER_ROUND[margin])
	damage_out[winner] = float(damage[winner]) + float(WINNER_DAMAGE)

	var p: float = BASE_COUNT * float(MARGIN_FACTOR[margin]) * exp((power - chin) / POWER_CHIN_SCALE) * (1.0 + loser_dmg / DAMAGE_SCALE)
	p = minf(p, 0.85)

	var counts := 0
	var up_at_arr: Array = []
	var cur_p: float = p
	for _i in range(3):
		if rng.randf() < cur_p:
			counts += 1
			var ua: int = clampi(8 - int(heart / 25.0) + (1 if loser_dmg > 70.0 else 0), 2, 9)
			up_at_arr.append(ua)
			cur_p *= 0.6
		else:
			break

	# After a count the referee looks at her: the more damage and the less heart, the likelier he waves it off (RSC). Only a
	# counted boxer can be stopped this way; a stopped boxer with heavy damage and little heart did not beat the count (KO).
	var ko := false
	var waved := false
	if counts > 0:
		var stop_p: float = minf(0.9, REF_STOP * (1.0 + float(damage_out[loser]) / DAMAGE_SCALE) * (1.4 - heart / 100.0))
		if rng.randf() < stop_p:
			ko = float(damage_out[loser]) >= KO_DAMAGE and rng.randf() < (1.0 - heart / 100.0) * KO_ODDS
			waved = not ko

	var total_counts: int = int(counts_so_far[loser]) + counts
	var rsc := counts >= COUNTS_ROUND_STOP or total_counts >= COUNTS_BOUT_STOP or waved

	var how := ""
	var stopped := false
	if rsc:
		how = "RSC"
		stopped = true
	elif ko:
		how = "KO"
		stopped = true

	return {"loser": loser, "counts": counts, "up_at": up_at_arr, "stopped": stopped, "how": how, "damage": damage_out}


static func simulate_bout(sides: Dictionary, rounds: int, seed_value: int) -> Dictionary:
	var rng := RandomNumberGenerator.new()
	rng.seed = seed_value
	var counts := {"a": 0, "b": 0}
	var damage := {"a": 0.0, "b": 0.0}
	var power_a: float = float(sides["a"].get("power", 60))
	var power_b: float = float(sides["b"].get("power", 60))

	for rd in range(1, rounds + 1):
		var diff: float = (power_a - power_b) + rng.randf_range(-6.0, 6.0)
		var round_winner: String
		var round_loser: String
		if diff > 0.0:
			round_winner = "a"
			round_loser = "b"
		else:
			round_winner = "b"
			round_loser = "a"
		var abs_diff: float = absf(diff)
		var margin: String
		if abs_diff < 1.5:
			margin = "close"
		elif abs_diff >= 4.0:
			margin = "dominant"
		else:
			margin = "clear"

		var res := round_counts(margin, round_loser, sides, damage, counts, rng)
		damage = res["damage"]
		counts[round_loser] = int(counts[round_loser]) + int(res["counts"])

		if bool(res["stopped"]):
			return {"counts": counts, "stopped": true, "how": str(res["how"]), "by": round_winner, "round": rd}

	return {"counts": counts, "stopped": false, "how": "", "by": "", "round": rounds}
