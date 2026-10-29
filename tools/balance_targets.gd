extends SceneTree
## S305: rating edge -> bout win share at several round spreads, against John J-UPSETS1's targets (favourite wins ~60% at
## a slight edge, ~75% clear, ~88% big, never above ~95%; real pro favourites 86% of decided fights). Plays the game's real
## round through BalanceHarness, steady opponent (Priya, OPPONENTS[1]), conditioning 80, tiredness as the game has it.
##   <godot.exe> --headless --path . --script res://tools/balance_targets.gd

const H := preload("res://scripts/rules/BalanceHarness.gd")
const B := preload("res://scripts/rules/BoutRules.gd")
const Data := preload("res://scripts/state/Data.gd")
const N := 800


func _initialize() -> void:
	var opp: Dictionary = Data.OPPONENTS[1]
	print("TARGETS population: fighter avg 46-84 (power-leaning, cond 80, all moves 30) vs %s rating %.0f, n=%d per row" % [
		str(opp.get("name", "?")), float(opp.get("rating", 60.0)), N])
	print("TGT spread  avg  edge   bout")
	var seed := 9700
	for spread in [6.0, 14.0, 20.0, 27.0]:
		for avg in range(46, 86, 3):
			var f: Dictionary = H.make_fighter(avg, 80.0, {}, 1)
			var e: float = B.fight_power(f["stats"], f["camp"], 1, "body") - float(opp.get("rating", 60.0))
			var s: Dictionary = H.round_shares(f, ["", "body", "body"], N, seed, spread)
			seed += 1
			print("TGT %5.0f  %3d  %+5.1f  %.2f" % [spread, avg, e, s["bout"]])
	quit(0)
