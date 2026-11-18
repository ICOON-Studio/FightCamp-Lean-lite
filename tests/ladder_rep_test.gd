extends SceneTree
## LADDERREP1 - tests for the season ladder's pure rules.
## Tests every R3 table row, reach values, draw cap, method weights, clamp,
## price at gap 0, every grey status in priority order, yes_score factors and bounds,
## clock regular and pro rates.

var _pass := true
var _fails: int = 0

func _check(cond: bool, msg: String) -> void:
	if not cond:
		print("FAIL: %s" % msg)
		_pass = false
		_fails += 1

func _init() -> void:
	var LR := preload("res://scripts/rules/LadderRep.gd")

	# --- reach_up (R2) ---
	_check(LR.reach_up(0) == 10, "reach_up(0) = %d want 10" % LR.reach_up(0))
	_check(LR.reach_up(38) == 17, "reach_up(38) = %d want 17" % LR.reach_up(38))
	_check(LR.reach_up(55) == 21, "reach_up(55) = %d want 21" % LR.reach_up(55))

	# --- in_reach ---
	_check(LR.in_reach(30, 40) == true, "in_reach(30,40) reach=20, 40<=50")
	_check(LR.in_reach(30, 51) == false, "in_reach(30,51) 51>50")
	_check(LR.in_reach(30, 0) == true, "in_reach(30,0) down always ok")
	_check(LR.in_reach(30, 30) == true, "in_reach(30,30) same level")

	# --- far_below ---
	_check(LR.far_below(50, 30) == true, "far_below(50,30) diff=20")
	_check(LR.far_below(50, 31) == false, "far_below(50,31) diff=19")
	_check(LR.far_below(50, 29) == true, "far_below(50,29) diff=21")

	# --- expected (R3) ---
	var e0: float = LR.expected(50, 50)
	_check(absf(e0 - 0.5) < 0.01, "expected(50,50) = %.3f want 0.50" % e0)
	var ep10: float = LR.expected(40, 50)
	_check(absf(ep10 - 0.28) < 0.02, "expected(40,50) = %.3f want ~0.28" % ep10)
	var em10: float = LR.expected(50, 40)
	_check(absf(em10 - 0.72) < 0.02, "expected(50,40) = %.3f want ~0.72" % em10)
	var ep20: float = LR.expected(30, 50)
	_check(absf(ep20 - 0.14) < 0.02, "expected(30,50) = %.3f want ~0.14" % ep20)
	var em20: float = LR.expected(50, 30)
	_check(absf(em20 - 0.86) < 0.02, "expected(50,30) = %.3f want ~0.86" % em20)

	# --- change: R3 table (unanimous decision, weight 1.0) ---
	# Gap 0
	_check(LR.change(50, 50, "win", "ud") == 8, "change(50,50,win,ud) = %d want 8" % LR.change(50, 50, "win", "ud"))
	_check(LR.change(50, 50, "loss", "ud") == -8, "change(50,50,loss,ud) = %d want -8" % LR.change(50, 50, "loss", "ud"))
	# Gap +10 (they 10 above)
	_check(LR.change(40, 50, "win", "ud") == 11, "change(40,50,win,ud) = %d want 11" % LR.change(40, 50, "win", "ud"))
	_check(LR.change(40, 50, "loss", "ud") == -5, "change(40,50,loss,ud) = %d want -5" % LR.change(40, 50, "loss", "ud"))
	# Gap -10 (they 10 below)
	_check(LR.change(50, 40, "win", "ud") == 5, "change(50,40,win,ud) = %d want 5" % LR.change(50, 40, "win", "ud"))
	_check(LR.change(50, 40, "loss", "ud") == -11, "change(50,40,loss,ud) = %d want -11" % LR.change(50, 40, "loss", "ud"))
	# Gap +20 (they 20 above)
	_check(LR.change(30, 50, "win", "ud") == 14, "change(30,50,win,ud) = %d want 14" % LR.change(30, 50, "win", "ud"))
	_check(LR.change(30, 50, "loss", "ud") == -2, "change(30,50,loss,ud) = %d want -2" % LR.change(30, 50, "loss", "ud"))
	# Gap -20 (they 20 below)
	_check(LR.change(50, 30, "win", "ud") == 2, "change(50,30,win,ud) = %d want 2" % LR.change(50, 30, "win", "ud"))
	_check(LR.change(50, 30, "loss", "ud") == -14, "change(50,30,loss,ud) = %d want -14" % LR.change(50, 30, "loss", "ud"))

	# --- Draw cap (never more than a gap-0 win = 8) ---
	var d0: int = LR.change(50, 50, "draw", "ud")
	_check(d0 == 0, "draw at gap 0 = %d want 0" % d0)
	var dp10: int = LR.change(40, 50, "draw", "ud")
	_check(dp10 == 2, "draw at gap +10 = %d want 2" % dp10)
	var dm10: int = LR.change(50, 40, "draw", "ud")
	_check(dm10 == -2, "draw at gap -10 = %d want -2" % dm10)
	var dp20: int = LR.change(30, 50, "draw", "ud")
	_check(dp20 == 3, "draw at gap +20 = %d want 3" % dp20)
	var dm20: int = LR.change(50, 30, "draw", "ud")
	_check(dm20 == -3, "draw at gap -20 = %d want -3" % dm20)
	_check(absi(dp20) <= 8, "draw cap: |3| <= 8")

	# --- Method weights: split < majority < ud < stop ---
	var w_split: int = LR.change(50, 50, "win", "split")
	var w_majority: int = LR.change(50, 50, "win", "majority")
	var w_ud: int = LR.change(50, 50, "win", "ud")
	var w_stop: int = LR.change(50, 50, "win", "stop")
	_check(w_split < w_majority, "split(%d) < majority(%d)" % [w_split, w_majority])
	_check(w_majority < w_ud, "majority(%d) < ud(%d)" % [w_majority, w_ud])
	_check(w_ud < w_stop, "ud(%d) < stop(%d)" % [w_ud, w_stop])
	# Loss weights same order (more negative = heavier)
	var l_split: int = LR.change(50, 50, "loss", "split")
	var l_majority: int = LR.change(50, 50, "loss", "majority")
	var l_ud: int = LR.change(50, 50, "loss", "ud")
	var l_stop: int = LR.change(50, 50, "loss", "stop")
	_check(l_split > l_majority, "loss split(%d) > loss majority(%d)" % [l_split, l_majority])
	_check(l_majority > l_ud, "loss majority(%d) > loss ud(%d)" % [l_majority, l_ud])
	_check(l_ud > l_stop, "loss ud(%d) > loss stop(%d)" % [l_ud, l_stop])

	# --- Clamp at 0 and 100 ---
	_check(LR.apply(0, -10) == 0, "apply(0,-10) = %d want 0" % LR.apply(0, -10))
	_check(LR.apply(100, 10) == 100, "apply(100,10) = %d want 100" % LR.apply(100, 10))
	_check(LR.apply(50, 10) == 60, "apply(50,10) = %d want 60" % LR.apply(50, 10))
	_check(LR.apply(50, -60) == 0, "apply(50,-60) = %d want 0" % LR.apply(50, -60))

	# --- price at gap 0 ---
	var p: Dictionary = LR.price(50, 50)
	_check(p["rep_win"] == 8, "price.rep_win = %d want 8" % p["rep_win"])
	_check(p["rep_loss"] == -8, "price.rep_loss = %d want -8" % p["rep_loss"])
	_check(p["members_win"] == 8, "price.members_win = %d want 8" % p["members_win"])
	_check(p["members_loss"] == -1, "price.members_loss = %d want -1" % p["members_loss"])
	_check(p["standing_win"] == 4, "price.standing_win = %d want 4" % p["standing_win"])
	_check(p["standing_loss"] == -2, "price.standing_loss = %d want -2" % p["standing_loss"])
	_check(p["ticket"] == 450, "price.ticket = %d want 450" % p["ticket"])
	# morale_win at gap 0: floor(4 + 6*(1-0.5)) = floor(7.0) = 7
	_check(p["morale_win"] == 7, "price.morale_win = %d want 7" % p["morale_win"])
	_check(p["morale_loss"] == -12, "price.morale_loss = %d want -12" % p["morale_loss"])

	# --- grey: each status in priority order ---
	var g1: Dictionary = LR.grey({"out_of_reach": true})
	_check(g1["status"] == "OUT OF REACH", "grey out_of_reach = '%s'" % g1["status"])
	_check(g1["askable"] == false, "grey out_of_reach not askable")
	var g2: Dictionary = LR.grey({"booked": true})
	_check(g2["status"] == "BOOKED", "grey booked = '%s'" % g2["status"])
	var g3: Dictionary = LR.grey({"resting": true})
	_check(g3["status"] == "RESTING", "grey resting = '%s'" % g3["status"])
	var g4: Dictionary = LR.grey({"nationals": true})
	_check(g4["status"] == "NATIONALS", "grey nationals = '%s'" % g4["status"])
	var g5: Dictionary = LR.grey({"novice_vs_open": true})
	_check(g5["status"] == "NOT SAFE", "grey novice_vs_open = '%s'" % g5["status"])
	var g6: Dictionary = LR.grey({"clubmate": true})
	_check(g6["status"] == "CLUBMATE", "grey clubmate = '%s'" % g6["status"])
	var g7: Dictionary = LR.grey({"met_this_season": 2})
	_check(g7["status"] == "TWICE THIS SEASON", "grey met_this_season=2 = '%s'" % g7["status"])
	var g8: Dictionary = LR.grey({"too_heavy": true})
	_check(g8["status"] == "TOO HEAVY", "grey too_heavy = '%s'" % g8["status"])
	var g9: Dictionary = LR.grey({"bouts_this_year": 18})
	_check(g9["status"] == "SEASON CAP", "grey bouts_this_year=18 = '%s'" % g9["status"])
	# Askable when no flags
	var g10: Dictionary = LR.grey({})
	_check(g10["askable"] == true, "grey empty flags is askable")
	_check(g10["status"] == "", "grey empty status is empty string")
	# Priority: two flags set -> the earlier one wins
	var g11: Dictionary = LR.grey({"booked": true, "resting": true})
	_check(g11["status"] == "BOOKED", "grey booked+resting -> BOOKED (priority)")
	var g12: Dictionary = LR.grey({"clubmate": true, "too_heavy": true})
	_check(g12["status"] == "CLUBMATE", "grey clubmate+too_heavy -> CLUBMATE (priority)")
	var g13: Dictionary = LR.grey({"out_of_reach": true, "bouts_this_year": 20})
	_check(g13["status"] == "OUT OF REACH", "grey out_of_reach+season_cap -> OUT OF REACH")

	# --- yes_score: base case ---
	var y1: Dictionary = LR.yes_score({"their_expected_pct": 50})
	_check(y1["score"] == 50, "yes_score base = %d want 50" % y1["score"])
	_check(y1["yes"] == true, "yes_score base is yes")

	# --- yes_score: bounds 5 and 95 ---
	var y2: Dictionary = LR.yes_score({
		"their_expected_pct": 50, "protecting": true,
		"my_hot_streak": true, "their_rank_above": 3,
		"last_meeting": "they_lost", "temperament": "careful"
	})
	_check(y2["score"] == 5, "yes_score lower bound = %d want 5" % y2["score"])
	var y3: Dictionary = LR.yes_score({
		"their_expected_pct": 90, "their_idle_weeks": 10,
		"last_meeting": "they_won", "temperament": "bold"
	})
	_check(y3["score"] == 95, "yes_score upper bound = %d want 95" % y3["score"])

	# --- yes_score: each factor moves it the stated amount ---
	# Their odds: +floor((70-50)/2) = +10
	var y4: Dictionary = LR.yes_score({"their_expected_pct": 70})
	_check(y4["score"] == 60, "yes_score odds +10 = %d want 60" % y4["score"])
	# Protecting: -30 (only when their expected < 60%)
	var y5: Dictionary = LR.yes_score({"their_expected_pct": 50, "protecting": true})
	_check(y5["score"] == 20, "yes_score protecting -30 = %d want 20" % y5["score"])
	# Hot streak: -20 when they rank 0-8 above
	var y6: Dictionary = LR.yes_score({"my_hot_streak": true, "their_rank_above": 3})
	_check(y6["score"] == 30, "yes_score hot_streak -20 = %d want 30" % y6["score"])
	# Idle weeks: +3 per week, max +15
	# 5 weeks: +15 (max)
	var y7b: Dictionary = LR.yes_score({"their_idle_weeks": 5})
	_check(y7b["score"] == 65, "yes_score idle 5w = %d want 65 (max +15)" % y7b["score"])
	# 3 weeks: +9
	var y7c: Dictionary = LR.yes_score({"their_idle_weeks": 3})
	_check(y7c["score"] == 59, "yes_score idle 3w = %d want 59" % y7c["score"])
	# 10 weeks: still max +15
	var y7d: Dictionary = LR.yes_score({"their_idle_weeks": 10})
	_check(y7d["score"] == 65, "yes_score idle 10w = %d want 65 (max +15)" % y7d["score"])
	# Last meeting they won: +10
	var y8: Dictionary = LR.yes_score({"last_meeting": "they_won"})
	_check(y8["score"] == 60, "yes_score last_meeting they_won +10 = %d want 60" % y8["score"])
	# Last meeting they lost: -10
	var y9: Dictionary = LR.yes_score({"last_meeting": "they_lost"})
	_check(y9["score"] == 40, "yes_score last_meeting they_lost -10 = %d want 40" % y9["score"])
	# Temperament careful: -10
	var y10: Dictionary = LR.yes_score({"temperament": "careful"})
	_check(y10["score"] == 40, "yes_score temperament careful -10 = %d want 40" % y10["score"])
	# Temperament bold: +10
	var y11: Dictionary = LR.yes_score({"temperament": "bold"})
	_check(y11["score"] == 60, "yes_score temperament bold +10 = %d want 60" % y11["score"])

	# --- yes_score: biggest factor named ---
	var y12: Dictionary = LR.yes_score({"protecting": true, "their_expected_pct": 50})
	_check(y12["biggest"] == "protecting", "yes_score biggest = '%s' want protecting" % y12["biggest"])
	_check(y12["yes"] == false, "yes_score No when protecting drags below 50")
	var y13: Dictionary = LR.yes_score({"their_idle_weeks": 5})
	_check(y13["biggest"] == "idle", "yes_score biggest = '%s' want idle" % y13["biggest"])

	# --- yes_score: deterministic ---
	var y14: Dictionary = LR.yes_score({"their_expected_pct": 65, "temperament": "bold"})
	var y15: Dictionary = LR.yes_score({"their_expected_pct": 65, "temperament": "bold"})
	_check(y14["score"] == y15["score"], "yes_score deterministic: same input same output")
	_check(y14["biggest"] == y15["biggest"], "yes_score deterministic: same biggest")

	# --- clock: regular rate ---
	_check(LR.clock(8, 30) == 0, "clock(8,30) = %d want 0" % LR.clock(8, 30))
	_check(LR.clock(10, 30) == -1, "clock(10,30) = %d want -1" % LR.clock(10, 30))
	_check(LR.clock(12, 30) == -2, "clock(12,30) = %d want -2" % LR.clock(12, 30))
	_check(LR.clock(0, 30) == 0, "clock(0,30) = %d want 0" % LR.clock(0, 30))

	# --- clock: pro rate (rep >= 55) ---
	_check(LR.clock(8, 55) == 0, "clock(8,55) = %d want 0" % LR.clock(8, 55))
	_check(LR.clock(12, 55) == -1, "clock(12,55) = %d want -1" % LR.clock(12, 55))
	_check(LR.clock(16, 55) == -2, "clock(16,55) = %d want -2" % LR.clock(16, 55))
	_check(LR.clock(20, 60) == -3, "clock(20,60) = %d want -3" % LR.clock(20, 60))

	# --- Final verdict ---
	if _pass:
		print("LADDER_REP PASS")
	else:
		print("LADDER_REP FAIL %d" % _fails)
	quit(0 if _pass else 1)
