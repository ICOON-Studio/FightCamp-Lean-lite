extends SceneTree
## S304: the balance options put to the operator - round randomness (spread) x tiredness (game / ramp 4 / ramp 6) for an
## unfit (conditioning 50) and a fit (80) boxer, against a fader (opponent 0, Maria) and a steady one (opponent 1, Priya).
## Plays the game's real round through BalanceHarness (BALANCE1-3). Headless:
##   <godot.exe> --headless --path . --script res://tools/balance_options.gd

const H := preload("res://scripts/rules/BalanceHarness.gd")
const N := 600


func _initialize() -> void:
	print("OPT spread tired   cond avg opp   r1    r3    bout")
	var seed := 9100
	for spread in [6.0, 14.0]:
		for t in [["game", 0.0], ["ramp", 4.0], ["ramp", 6.0]]:
			for cond in [50.0, 80.0]:
				for avg in [60, 65]:
					for opp in [0, 1]:
						var f: Dictionary = H.make_fighter(avg, cond, {}, opp)
						var s: Dictionary = H.round_shares(f, ["", "body", "body"], N, seed, spread, str(t[0]), float(t[1]))
						seed += 1
						print("OPT %4.0f  %s%s %4.0f %3d %3d  %.2f  %.2f  %.2f" % [spread, str(t[0]), ("%.0f" % t[1]) if t[1] > 0.0 else " ",
							cond, avg, opp, s["r1"], s["r3"], s["bout"]])
	quit(0)
