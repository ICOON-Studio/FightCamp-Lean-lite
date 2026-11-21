extends RefCounted
## TURNPRO6 (S533) the chance of a card of ANY length from its per-round edges (BoutRead.round_edges). BoutRead.chance is
## the amateur card (2 rounds of 3, no draw); a pro debut is 4 rounds, where a level card is a draw and a stoppage ends it
## early. card() is the points card alone; win() adds the stoppages' net effect, FITTED on real bouts by
## tools/turn_gap_probe.gd (the read walks no knockdowns: a share of the level cards never reaches the judges, and that
## share grows with the boxer's edge). tests/debut_read_test.gd bounds it against played bouts.
## Pure static; form_sd is passed in (RingDuel.FORM_SD) so this file preloads no state module.

const ComboOdds := preload("res://scripts/rules/ComboOdds.gd")
const WorldBout := preload("res://scripts/world/WorldBout.gd")

## The share of the points card's draws that real bouts end as her win: STOP_BASE + STOP_SLOPE x the card's win chance.
## Fit (least squares) on 10 boxers x 2 houses x 12 gaps, 200-300 played bouts each: rms 3.0 points, worst 8.0.
const STOP_BASE := 0.12
const STOP_SLOPE := 0.33


## {win, draw, loss} on points over the form both bring on the night (as BoutRead.chance integrates it).
static func card(e: Array, form_sd: float) -> Dictionary:
	var sd := form_sd * sqrt(2.0)
	var rounds := e.size()
	var win := 0.0
	var draw := 0.0
	for j in WorldBout.GH_X.size():
		var d := float(WorldBout.GH_X[j]) * sd
		var dist: Array = [1.0]   # the chance of k rounds won so far
		for n in rounds:
			var p := ComboOdds.round_odds(float(e[n]) + d)
			var nx: Array = []
			nx.resize(dist.size() + 1)
			nx.fill(0.0)
			for k in dist.size():
				nx[k] = float(nx[k]) + float(dist[k]) * (1.0 - p)
				nx[k + 1] = float(nx[k + 1]) + float(dist[k]) * p
			dist = nx
		for k in dist.size():
			if k * 2 > rounds:
				win += float(WorldBout.GH_W[j]) * float(dist[k])
			elif k * 2 == rounds:
				draw += float(WorldBout.GH_W[j]) * float(dist[k])
	return {"win": win, "draw": draw, "loss": maxf(0.0, 1.0 - win - draw)}


## {win, draw, loss} as real bouts end: the points card with the stoppages' share of its draws moved to her win.
static func result(e: Array, form_sd: float) -> Dictionary:
	var c := card(e, form_sd)
	var moved := float(c["draw"]) * clampf(STOP_BASE + STOP_SLOPE * float(c["win"]), 0.0, 1.0)
	var w := clampf(float(c["win"]) + moved, 0.01, 0.99)
	var d := clampf(float(c["draw"]) - moved, 0.0, 1.0 - w)
	return {"win": w, "draw": d, "loss": maxf(0.0, 1.0 - w - d)}


static func win(e: Array, form_sd: float) -> float:
	return float(result(e, form_sd)["win"])
