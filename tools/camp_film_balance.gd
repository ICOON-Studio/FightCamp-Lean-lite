extends SceneTree
## S381 C229 stage 4: what the camp protocol and the film are worth on the night, through the game's real round path
## (BalanceHarness.round_shares: Bouts._energy + BoutRules.play_round). A power-leaning fighter (cond 65, all moves 30) at
## an even paper rating against Priya (OPPONENTS[1]); each row sets her camp protocol and the film answers (tells a plan
## line or a drilled combo answers, BoutRules.film_edge). One RNG seed per column, the same across rows (common random
## numbers), so a row's difference is the rule's, not the dice.
##   <godot.exe> --headless --path . --script res://tools/camp_film_balance.gd

const H := preload("res://scripts/rules/BalanceHarness.gd")
const B := preload("res://scripts/rules/BoutRules.gd")
const Data := preload("res://scripts/state/Data.gd")
const N := 2000


func _initialize() -> void:
	var opp: Dictionary = Data.OPPONENTS[1]
	print("CFB fighter avg 59 (power-leaning, cond 65) vs %s %.1f, n=%d, corners body/body" % [opp["name"], float(opp["rating"]), N])
	print("CFB protocol  film  power_edge  bout")
	for proto in [0, 1, 2, 3]:
		for answered in [0, 1, 2, 3]:
			var f: Dictionary = H.make_fighter(59, 65.0, {}, 1)
			f["camp"] = H.make_camp(proto)
			f["bout"]["answered"] = answered
			var e: float = B.fight_power(f["stats"], f["camp"], answered, "body") - float(opp["rating"])
			var s: Dictionary = H.round_shares(f, ["", "body", "body"], N, 4242)
			print("CFB %-8s  %d     %+5.2f      %.3f" % [B.PROTOCOLS[proto]["name"], answered, e, s["bout"]])
	quit(0)
