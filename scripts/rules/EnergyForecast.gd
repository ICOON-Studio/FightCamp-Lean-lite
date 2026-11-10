extends RefCounted
## How many rounds the tank lasts, from the drain the fight is already paying. Pure static. No randomness.
## Preloads are rule modules only.
## Drain per exchange is the mean of the last two drains, scaled by PaceAim.spend(pace) over the pace those
## exchanges were fought at. With fewer than two, it is PaceAim.spend(pace) times the round's base cost
## (Combos.ROUND_COST spread over the round's exchanges). Between rounds the corner minute gives back the
## second's water: all three points, the spend CornerJobsRow leaves when the ribs are quiet and the boxer
## is not hurt (CornerJobs.WATER_FRESH / WATER_TIRED).
##   rounds_left(energy, drain_per_ex, pace, ex_left, rounds_after) -> {by_round, out_round}
## by_round: energy at the end of this round, then each later round. out_round: the first of those below 20
## (1 = this round), or 0 when the tank lasts through the rounds asked for.
## drain_per_ex entries: {drain, pace}, or a bare number fought at steady.

const PaceAim := preload("res://scripts/rules/PaceAim.gd")
const CornerJobs := preload("res://scripts/rules/CornerJobs.gd")
const Combos := preload("res://scripts/rules/Combos.gd")
const Exchanges := preload("res://scripts/rules/Exchanges.gd")

const OUT := 20.0


static func rounds_left(energy: float, drain_per_ex: Array, pace: String, ex_left: int, rounds_after: int) -> Dictionary:
	var rate := per_exchange(drain_per_ex, pace)
	var by: Array = []
	var e := clampf(energy, 0.0, Combos.TANK)
	var out := 0
	e = clampf(e - rate * float(maxi(ex_left, 0)), 0.0, Combos.TANK)
	by.append(e)
	if e < OUT:
		out = 1
	for n in maxi(rounds_after, 0):
		e = clampf(e + minute_back(e), 0.0, Combos.TANK)
		e = clampf(e - rate * float(Exchanges.EXCHANGES), 0.0, Combos.TANK)
		by.append(e)
		if out == 0 and e < OUT:
			out = n + 2
	return {"by_round": by, "out_round": out}


## Energy the corner minute gives back at this bell. The second's three points, all on water.
static func minute_back(energy: float) -> float:
	var pts := {"water": CornerJobs.RECOVER_POINTS, "ice": 0, "head": 0}
	return float(CornerJobs.recover(pts, energy, 0, false)["energy"])


static func per_exchange(drain_per_ex: Array, pace: String) -> float:
	if drain_per_ex.size() < 2:
		return PaceAim.spend(pace) * (Combos.ROUND_COST / float(Exchanges.EXCHANGES))
	var a := _one(drain_per_ex[drain_per_ex.size() - 2])
	var b := _one(drain_per_ex[drain_per_ex.size() - 1])
	var mean := (float(a[0]) + float(b[0])) * 0.5
	var fought := (PaceAim.spend(str(a[1])) + PaceAim.spend(str(b[1]))) * 0.5
	if fought <= 0.001:
		fought = 1.0
	return mean * PaceAim.spend(pace) / fought


static func _one(item: Variant) -> Array:
	if item is Dictionary:
		var d: Dictionary = item
		return [float(d.get("drain", d.get("d", 0.0))), str(d.get("pace", "steady"))]
	if item is Array:
		var row: Array = item
		var pace := "steady"
		if row.size() > 1:
			pace = str(row[1])
		var drain := 0.0
		if row.size() > 0:
			drain = float(row[0])
		return [drain, pace]
	return [float(item), "steady"]
