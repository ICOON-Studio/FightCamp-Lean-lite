extends RefCounted
## LADDERREP1 - Season ladder pure rules: reach, points, grey rows, yes-score, clock.
## Source: ops/research/DESIGN_LADDER1_V6_DOLA.md lines 1047-1164 (Part 1, R1-R10).
## All functions static. No class_name. No scene preloads.
## Stands beside WorldLadderRules.gd and RankLine.gd (not changed by this module).

## why R2: reach_up, in_reach, far_below
## Up limit = 10 + floor(rep / 5). Down: no limit. 20+ below = far_below (WON'T STOP THE CLOCK).
static func reach_up(rep: int) -> int:
	return 10 + int(floor(rep / 5.0))

static func in_reach(my_rep: int, their_rep: int) -> bool:
	return their_rep <= my_rep + reach_up(my_rep)

static func far_below(my_rep: int, their_rep: int) -> bool:
	return my_rep - their_rep >= 20


## why R3: expected, change, apply
## Elo-style expected = 1 / (1 + 10^((their - my) / 25)).
## Table (R3 map): gap 0 -> +8/-8, +10 -> +11/-5, -10 -> +5/-11, +20 -> +14/-2, -20 -> +2/-14 (unanimous).
## Loss uses the LOSER's expected so the table holds (gap +10: my expected 0.28, but loss magnitude
## uses loser's expected 0.72 -> lose only 5).
static func expected(my_rep: int, their_rep: int) -> float:
	return 1.0 / (1.0 + pow(10.0, (their_rep - my_rep) / 25.0))

static func change(my_rep: int, their_rep: int, result: String, method: String) -> int:
	var w: float = 1.0
	var bonus: int = 0
	if method == "split":
		w = 0.5
	elif method == "majority":
		w = 0.65
	elif method == "ud":
		w = 1.0
	elif method == "stop":
		w = 1.15
		bonus = 2
	if result == "win":
		var e: float = expected(my_rep, their_rep)
		var mag: int = int(round(16.0 * (1.0 - e) * w))
		return mag + bonus
	elif result == "loss":
		var e: float = expected(their_rep, my_rep)
		var mag: int = int(round(16.0 * (1.0 - e) * w))
		return -(mag + bonus)
	else:
		var e: float = expected(my_rep, their_rep)
		return int(round(8.0 * (0.5 - e)))

static func apply(rep: int, delta: int) -> int:
	return clampi(rep + delta, 0, 100)


## why R4: price
## Full price card. No travel (CHECK in map: no venue data).
static func price(my_rep: int, their_rep: int) -> Dictionary:
	var rep_win: int = change(my_rep, their_rep, "win", "ud")
	var rep_loss: int = change(my_rep, their_rep, "loss", "ud")
	var e: float = expected(my_rep, their_rep)
	return {
		"rep_win": rep_win,
		"rep_loss": rep_loss,
		"members_win": maxi(2, mini(12, rep_win)),
		"members_loss": -1,
		"standing_win": maxi(1, mini(8, int(floor(rep_win / 2.0)))),
		"standing_loss": -2,
		"ticket": 450,
		"morale_win": int(floor(4.0 + 6.0 * (1.0 - e))),
		"morale_loss": -12,
	}


## why R5: grey
## Status priority (map order): OUT OF REACH, BOOKED, RESTING, NATIONALS, NOT SAFE,
## CLUBMATE, TWICE THIS SEASON, TOO HEAVY, SEASON CAP. First match wins.
static func grey(flags: Dictionary) -> Dictionary:
	if bool(flags.get("out_of_reach", false)):
		return {"askable": false, "status": "OUT OF REACH"}
	if bool(flags.get("booked", false)):
		return {"askable": false, "status": "BOOKED"}
	if bool(flags.get("resting", false)):
		return {"askable": false, "status": "RESTING"}
	if bool(flags.get("nationals", false)):
		return {"askable": false, "status": "NATIONALS"}
	if bool(flags.get("novice_vs_open", false)):
		return {"askable": false, "status": "NOT SAFE"}
	if bool(flags.get("clubmate", false)):
		return {"askable": false, "status": "CLUBMATE"}
	if int(flags.get("met_this_season", 0)) >= 2:
		return {"askable": false, "status": "TWICE THIS SEASON"}
	if bool(flags.get("too_heavy", false)):
		return {"askable": false, "status": "TOO HEAVY"}
	if int(flags.get("bouts_this_year", 0)) >= 18:
		return {"askable": false, "status": "SEASON CAP"}
	return {"askable": true, "status": ""}


## why R6: yes_score
## Deterministic. Base 50. Each factor modifies. Clamp 5..95. Yes >= 50.
## No home/away (no venue data). No random.
static func yes_score(f: Dictionary) -> Dictionary:
	var score: int = 50
	var biggest: String = "base"
	var big_abs: int = 0

	var their_pct: int = int(f.get("their_expected_pct", 50))
	var odds: int = int(floor((their_pct - 50) / 2.0))
	score += odds
	if absi(odds) > big_abs:
		big_abs = absi(odds)
		biggest = "odds"

	var protecting: bool = bool(f.get("protecting", false))
	var their_exp_low: bool = their_pct < 60
	var prot_delta: int = 0
	if protecting and their_exp_low:
		prot_delta = -30
	score += prot_delta
	if absi(prot_delta) > big_abs:
		big_abs = absi(prot_delta)
		biggest = "protecting"

	var hot_streak: bool = bool(f.get("my_hot_streak", false))
	var rank_above: int = int(f.get("their_rank_above", 99))
	var hot_delta: int = 0
	if hot_streak and rank_above >= 0 and rank_above <= 8:
		hot_delta = -20
	score += hot_delta
	if absi(hot_delta) > big_abs:
		big_abs = absi(hot_delta)
		biggest = "hot_streak"

	var idle_weeks: int = int(f.get("their_idle_weeks", 0))
	var idle: int = mini(idle_weeks * 3, 15)
	score += idle
	if absi(idle) > big_abs:
		big_abs = absi(idle)
		biggest = "idle"

	var last_meeting: String = str(f.get("last_meeting", ""))
	var lm_delta: int = 0
	if last_meeting == "they_won":
		lm_delta = 10
	elif last_meeting == "they_lost":
		lm_delta = -10
	score += lm_delta
	if absi(lm_delta) > big_abs:
		big_abs = absi(lm_delta)
		biggest = "last_meeting"

	var temp: String = str(f.get("temperament", "normal"))
	var temp_delta: int = 0
	if temp == "careful":
		temp_delta = -10
	elif temp == "bold":
		temp_delta = 10
	score += temp_delta
	if absi(temp_delta) > big_abs:
		big_abs = absi(temp_delta)
		biggest = "temperament"

	score = clampi(score, 5, 95)
	return {"score": score, "yes": score >= 50, "biggest": biggest}


## why R8: clock
## Idle drain: 0 for up to 8 free weeks, then -1 every 2 weeks after.
## Pro rule (rep >= 55): -1 every 4 weeks unbooked (replaces regular rate).
static func clock(free_weeks: int, rep: int) -> int:
	if rep >= 55:
		if free_weeks <= 8:
			return 0
		return -int(floor((free_weeks - 8) / 4.0))
	if free_weeks <= 8:
		return 0
	return -int(floor((free_weeks - 8) / 2.0))
