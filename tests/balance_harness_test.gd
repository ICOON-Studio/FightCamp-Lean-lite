extends SceneTree
## Balance harness test: 11 tests covering determinism, stats, camp, film, edge bounds,
## no draws, grid structure, parity with the game's real round path, tiredness, conditioning
## protection, and energy carry. Same shape as combos_test.gd.

const H := preload("res://scripts/rules/BalanceHarness.gd")
const BoutsScript := preload("res://scripts/state/Bouts.gd")
const BR := preload("res://scripts/rules/BoutRules.gd")

var failures: int = 0


func _initialize() -> void:
	_test_1_determinism()
	_test_2_stats()
	_test_3_camp()
	_test_4_film()
	_test_5_bounds()
	_test_6_no_draws()
	_test_7_grid()
	_test_8_parity()
	_test_9_tiredness()
	_test_10_conditioning_protects()
	_test_11_bell3_energy()
	_test_12_defaults_match()
	_test_13_wider_spread_pulls_favourite_down()
	_test_14_ramp_makes_r3_harder_for_unfit()
	print("BALANCE failures=%d" % failures)
	quit(1 if failures > 0 else 0)


func _check(cond: bool, label: String) -> void:
	if cond:
		print("PASS ", label)
	else:
		failures += 1
		print("FAIL ", label)


## 1. Determinism: same seed twice -> same win_share.
func _test_1_determinism() -> void:
	var stats: Dictionary = H.make_stats(60, 0)
	var camp: Dictionary = H.make_camp(2)
	var opp: Dictionary = {"rating": 62.0}
	var ws1: float = H.win_share(stats, camp, 1, opp, 400, 42)
	var ws2: float = H.win_share(stats, camp, 1, opp, 400, 42)
	_check(ws1 == ws2, "determinism: same seed -> same win_share (%.3f == %.3f)" % [ws1, ws2])


## 2. Stats: vs opp 62, win share at avg 70 > avg 60 > avg 55 (two profiles per average).
func _test_2_stats() -> void:
	var opp: Dictionary = {"rating": 62.0}
	var camp: Dictionary = H.make_camp(2)
	# Power-leaning profiles (variant 0)
	var ws55_p: float = H.win_share(H.make_stats(55, 0), camp, 1, opp, 400, 100)
	var ws60_p: float = H.win_share(H.make_stats(60, 0), camp, 1, opp, 400, 101)
	var ws70_p: float = H.win_share(H.make_stats(70, 0), camp, 1, opp, 400, 102)
	_check(ws70_p > ws60_p, "stats(power): avg 70 > avg 60 (%.3f > %.3f)" % [ws70_p, ws60_p])
	_check(ws60_p > ws55_p, "stats(power): avg 60 > avg 55 (%.3f > %.3f)" % [ws60_p, ws55_p])
	# Defense-leaning profiles (variant 1)
	var ws55_d: float = H.win_share(H.make_stats(55, 1), camp, 1, opp, 400, 200)
	var ws60_d: float = H.win_share(H.make_stats(60, 1), camp, 1, opp, 400, 201)
	var ws70_d: float = H.win_share(H.make_stats(70, 1), camp, 1, opp, 400, 202)
	_check(ws70_d > ws60_d, "stats(defense): avg 70 > avg 60 (%.3f > %.3f)" % [ws70_d, ws60_d])
	_check(ws60_d > ws55_d, "stats(defense): avg 60 > avg 55 (%.3f > %.3f)" % [ws60_d, ws55_d])


## 3. Camp: Hard (3) > Standard (2) > None (0) at matched stats.
func _test_3_camp() -> void:
	var stats: Dictionary = H.make_stats(62, 0)
	var opp: Dictionary = {"rating": 62.0}
	var ws_none: float = H.win_share(stats, H.make_camp(0), 1, opp, 400, 300)
	var ws_std: float = H.win_share(stats, H.make_camp(2), 1, opp, 400, 301)
	var ws_hard: float = H.win_share(stats, H.make_camp(3), 1, opp, 400, 302)
	_check(ws_hard > ws_std, "camp: Hard > Standard (%.3f > %.3f)" % [ws_hard, ws_std])
	_check(ws_std > ws_none, "camp: Standard > None (%.3f > %.3f)" % [ws_std, ws_none])


## 4. Film: depth 3 > depth 1.
func _test_4_film() -> void:
	var stats: Dictionary = H.make_stats(62, 0)
	var camp: Dictionary = H.make_camp(2)
	var opp: Dictionary = {"rating": 62.0}
	var ws1: float = H.win_share(stats, camp, 1, opp, 400, 400)
	var ws3: float = H.win_share(stats, camp, 3, opp, 400, 401)
	_check(ws3 > ws1, "film: depth 3 > depth 1 (%.3f > %.3f)" % [ws3, ws1])


## 5. Bounds from the round model.
func _test_5_bounds() -> void:
	# |edge| < 0.5 -> win_share in 0.40..0.60
	var stats_close: Dictionary = H.make_stats(60, 0)
	var camp_close: Dictionary = H.make_camp(2)
	var opp_close: Dictionary = {"rating": 62.0}
	var e_close: float = H.edge(stats_close, camp_close, 1, opp_close)
	_check(absf(e_close) < 0.5, "bounds: edge close to 0 (%.2f)" % e_close)
	var ws_close: float = H.win_share(stats_close, camp_close, 1, opp_close, 400, 500)
	_check(ws_close >= 0.40 and ws_close <= 0.60,
			"bounds: |edge| < 0.5 -> win_share in 0.40..0.60 (%.3f)" % ws_close)

	# edge >= +4 -> win_share >= 0.95
	var stats_high: Dictionary = H.make_stats(65, 0)
	var camp_high: Dictionary = H.make_camp(2)
	var opp_high: Dictionary = {"rating": 62.0}
	var e_high: float = H.edge(stats_high, camp_high, 1, opp_high)
	_check(e_high >= 4.0, "bounds: edge >= 4 (%.2f)" % e_high)
	var ws_high: float = H.win_share(stats_high, camp_high, 1, opp_high, 400, 501)
	_check(ws_high >= 0.95, "bounds: edge >= 4 -> win_share >= 0.95 (%.3f)" % ws_high)

	# edge <= -4 -> win_share <= 0.05
	var stats_low: Dictionary = H.make_stats(55, 0)
	var camp_low: Dictionary = H.make_camp(0)
	var opp_low: Dictionary = {"rating": 62.0}
	var e_low: float = H.edge(stats_low, camp_low, 1, opp_low)
	_check(e_low <= -4.0, "bounds: edge <= -4 (%.2f)" % e_low)
	var ws_low: float = H.win_share(stats_low, camp_low, 1, opp_low, 400, 502)
	_check(ws_low <= 0.05, "bounds: edge <= -4 -> win_share <= 0.05 (%.3f)" % ws_low)


## 6. A 3-round bout never ends "draw".
func _test_6_no_draws() -> void:
	var stats: Dictionary = H.make_stats(60, 0)
	var camp: Dictionary = H.make_camp(2)
	var opp: Dictionary = {"rating": 60.0}
	var rng := RandomNumberGenerator.new()
	rng.seed = 42
	var draws: int = 0
	for _i in 400:
		var result: Dictionary = H.bout(stats, camp, 1, opp, rng)
		if str(result["verdict"]) == "draw":
			draws += 1
	_check(draws == 0, "no draws in 400 bouts (3-round bout always has a winner)")


## 7. grid() returns 96 rows, every win_share in [0, 1].
func _test_7_grid() -> void:
	var rows: Array = H.grid(42, 400)
	_check(rows.size() == 96, "grid returns 96 rows (got %d)" % rows.size())
	var all_valid: bool = true
	for row in rows:
		var ws: float = float(row["win_share"])
		if ws < 0.0 or ws > 1.0:
			all_valid = false
	_check(all_valid, "grid: every win_share in [0, 1]")


## For tests 9/10: print FINDING (not FAIL) when the assertion does not hold, without counting as a failure.
## The operator asked "is round 3 harder?"; if the numbers say otherwise that is the answer, not a bug.
func _check_finding(cond: bool, label: String) -> void:
	if cond:
		print("PASS ", label)
	else:
		print("FINDING ", label)


## 8. Parity: live_bout's round-2 bonus equals an independent Bouts._energy call + weapons_edge
##    for a fresh copy of the fighter that went through round 1 the same way.
func _test_8_parity() -> void:
	var f: Dictionary = H.make_fighter(60, 55.0, {}, 0)
	var f2: Dictionary = H.make_fighter(60, 55.0, {}, 0)
	var corners: Array = ["", "body", ""]
	var rng1 := RandomNumberGenerator.new()
	rng1.seed = 12345
	var rng2 := RandomNumberGenerator.new()
	rng2.seed = 12345
	var result: Dictionary = H.live_bout(f, corners, rng1)
	var r2_bonus: float = float((result["rounds"] as Array)[1]["bonus"])
	# Independently step f2 through round 1 (same _energy call, same rng consumption).
	var _e1: Dictionary = BoutsScript._energy(f2, 1, "")
	var we: float = BR.weapons_edge(BR.weapons(f2.get("moves", {})))
	var _ra: float = rng2.randf()
	var _rb: float = rng2.randf()
	# Now call _energy for round 2 on f2 - it should see the same energy state as live_bout did.
	var e2: Dictionary = BoutsScript._energy(f2, 2, "body")
	var expected: float = float(e2["bonus"]) + we
	_check(absf(r2_bonus - expected) < 0.001,
			"parity: round-2 bonus matches independent _energy (%.4f == %.4f)" % [r2_bonus, expected])


## 9. Tiredness shows: conditioning 50, corner "body" in rounds 2 and 3 -> r3 share at least 0.05 below r1.
func _test_9_tiredness() -> void:
	var f: Dictionary = H.make_fighter(60, 50.0, {}, 0)
	var corners: Array = ["", "body", "body"]
	var rs: Dictionary = H.round_shares(f, corners, 500, 700)
	var r1: float = float(rs["r1"])
	var r3: float = float(rs["r3"])
	var drop: float = r1 - r3
	_check_finding(drop >= 0.05,
			"tiredness cond=50: r1-r3 >= 0.05 (r1=%.3f r3=%.3f drop=%.3f)" % [r1, r3, drop])


## 10. Conditioning protects: the r1 -> r3 drop at conditioning 80 is smaller than at conditioning 50.
func _test_10_conditioning_protects() -> void:
	var corners: Array = ["", "body", "body"]
	var f50: Dictionary = H.make_fighter(62, 50.0, {}, 1)
	var f80: Dictionary = H.make_fighter(62, 80.0, {}, 1)
	var rs50: Dictionary = H.round_shares(f50, corners, 500, 800)
	var rs80: Dictionary = H.round_shares(f80, corners, 500, 801)
	var drop50: float = float(rs50["r1"]) - float(rs50["r3"])
	var drop80: float = float(rs80["r1"]) - float(rs80["r3"])
	_check_finding(drop80 < drop50,
			"conditioning protects: drop@80 < drop@50 (drop50=%.3f drop80=%.3f)" % [drop50, drop80])


## 11. bell3_energy at conditioning 50 < at conditioning 80 (fitter carries more tank into round 3).
func _test_11_bell3_energy() -> void:
	var corners: Array = ["", "body", "body"]
	var f50: Dictionary = H.make_fighter(64, 50.0, {}, 2)
	var f80: Dictionary = H.make_fighter(64, 80.0, {}, 2)
	var rs50: Dictionary = H.round_shares(f50, corners, 500, 900)
	var rs80: Dictionary = H.round_shares(f80, corners, 500, 901)
	var b3_50: float = float(rs50["bell3_energy"])
	var b3_80: float = float(rs80["bell3_energy"])
	_check(b3_50 < b3_80,
			"bell3_energy: cond50 < cond80 (%.2f < %.2f)" % [b3_50, b3_80])


## 12. Default arguments reproduce BALANCE2 exactly: round_shares with defaults == explicit game defaults.
func _test_12_defaults_match() -> void:
	var f: Dictionary = H.make_fighter(62, 60.0, {}, 0)
	var corners: Array = ["", "body", "body"]
	var rs_default: Dictionary = H.round_shares(f, corners, 400, 42)
	var rs_explicit: Dictionary = H.round_shares(f, corners, 400, 42, BR.ROUND_SPREAD, "game")
	_check(float(rs_default["r1"]) == float(rs_explicit["r1"]),
			"defaults: r1 matches (%.4f == %.4f)" % [float(rs_default["r1"]), float(rs_explicit["r1"])])
	_check(float(rs_default["r3"]) == float(rs_explicit["r3"]),
			"defaults: r3 matches (%.4f == %.4f)" % [float(rs_default["r3"]), float(rs_explicit["r3"])])
	_check(float(rs_default["bout"]) == float(rs_explicit["bout"]),
			"defaults: bout matches (%.4f == %.4f)" % [float(rs_default["bout"]), float(rs_explicit["bout"])])


## 13. Wider spread pulls a strong favourite down: at avg 70 vs opponent 0, bout share at spread 18 < at spread 6.
func _test_13_wider_spread_pulls_favourite_down() -> void:
	var corners: Array = ["", "body", "body"]
	var f: Dictionary = H.make_fighter(70, 70.0, {}, 0)
	var rs6: Dictionary = H.round_shares(f, corners, 400, 1000, 6.0, "game")
	var rs18: Dictionary = H.round_shares(f, corners, 400, 1001, 18.0, "game")
	var bout6: float = float(rs6["bout"])
	var bout18: float = float(rs18["bout"])
	_check(bout18 < bout6,
			"wider spread pulls favourite down: bout@18 < bout@6 (%.3f < %.3f)" % [bout18, bout6])


## 14. Ramp makes round 3 harder for the unfit: at cond 50, spread 6, (r1-r3) with "ramp" > (r1-r3) with "game".
func _test_14_ramp_makes_r3_harder_for_unfit() -> void:
	var corners: Array = ["", "body", "body"]
	var f: Dictionary = H.make_fighter(60, 50.0, {}, 0)
	var rs_game: Dictionary = H.round_shares(f, corners, 400, 1100, 6.0, "game")
	var rs_ramp: Dictionary = H.round_shares(f, corners, 400, 1100, 6.0, "ramp")
	var drop_game: float = float(rs_game["r1"]) - float(rs_game["r3"])
	var drop_ramp: float = float(rs_ramp["r1"]) - float(rs_ramp["r3"])
	_check(drop_ramp > drop_game,
			"ramp makes r3 harder for unfit: drop_ramp > drop_game (%.3f > %.3f)" % [drop_ramp, drop_game])
