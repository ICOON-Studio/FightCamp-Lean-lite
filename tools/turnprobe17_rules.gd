extends RefCounted
## TURNPROBE17 (S542) GREYBOX - NOT GAME CODE. Turning pro v17 (ops/research/DESIGN_TURNPRO1_V17.md): WHEN (Turn pro now /
## Not yet, patience 3 marks, the rival gym) and HOW (pro fights 1-6: SAFE or RISKY, both chances printed), two bars on the
## boxer (CONFIDENCE, HUNGER). Pure static. The game's own numbers are READ from the game's modules (preloaded for their
## constants only); the v17 numbers below are the owner-approved starting numbers (Q-S294-320 "Yes, build it"), each ESTIMATE.

const Roster := preload("res://scripts/state/Roster.gd")
const ProLadder := preload("res://scripts/state/ProLadder.gd")
const MM := preload("res://scripts/rules/Matchmaking.gd")

## --- WHEN ---
const PATIENCE := 3                 ## ESTIMATE: three marks; two "Not yet"s, the third call is the rival gym
const NOT_YET_WEEKS := 4            ## ESTIMATE: the offer returns in about 4 weeks (room for about 2 amateur bouts)
const NOT_YET_HUNGER := -15         ## ESTIMATE
## --- HOW ---
const LEAN_FIGHTS := 6              ## pro fights 1-6 offer two bouts (mirrors ProLean.LEAN_FIGHTS, read in the probe)
const SAFE_BAND := Vector2(0.75, 0.90)    ## ESTIMATE, inside ProLadder.TUNE_READ (0.70-0.93)
const RISKY_BAND := Vector2(0.40, 0.55)   ## ESTIMATE, around ProLadder.STEP_READ (0.5)
const NAME_SAFE := 1                ## ESTIMATE: a win over a man you should beat
const NAME_RISKY := 3               ## ESTIMATE: a win over a real test
const RISKY_PURSE := 1.75           ## ESTIMATE: tuned by the probe (owner-approved start: double, 2.0)
const OPP_RISE := 0.3               ## ESTIMATE: each pro fight's opponents a little better (records climb), both bouts alike
## --- CONFIDENCE (0-100) ---
const CONF_START := 50
const CONF := {"safe_win": 4, "risky_win": 12, "points_loss": -10, "ko_loss": -30}   ## ESTIMATE
const CONF_SHIFT_MAX := 0.05        ## at most 5 points either way: linear, 0 -> -5, 50 -> 0, 100 -> +5
## --- HUNGER (0-100) ---
const HUNGER_START := 70
const HUNGER := {"safe_win": -10, "risky": 10, "idle_4w": -5}   ## ESTIMATE; safe_win tuned by the probe (start -8); "risky" win or lose; a safe LOSS moves nothing
const WARNINGS := 2                 ## at 0 hunger: two warnings (at the next two bookings), the third booking at 0 = gone
## --- stoppages: what share of a LOSS ends inside the distance (the game's read gives win / not win only) ---
const KO_BASE := 0.30               ## ESTIMATE: about a third of early pro losses (4-6 rounders) are stoppages
const KO_RISKY := 0.10              ## ESTIMATE: a real test hits harder
const KO_CHIN := 0.01               ## ESTIMATE: a point of chin under 60 adds a point of stoppage share


static func shift(conf: int) -> float:
	return clampf(float(conf - 50) / 50.0 * CONF_SHIFT_MAX, -CONF_SHIFT_MAX, CONF_SHIFT_MAX)


## The game's read of the bout, put inside the bout's band (the matchmaker finds a man in the band), then the boxer's
## confidence. This is the chance the booking screen prints and the dice use: one number, honest.
static func shown(raw: float, kind: String, conf: int) -> float:
	var b: Vector2 = SAFE_BAND if kind == "safe" else RISKY_BAND
	return clampf(clampf(raw, b.x, b.y) + shift(conf), 0.01, 0.99)


static func ko_share(chin: float, kind: String) -> float:
	return clampf(KO_BASE + (KO_RISKY if kind == "risky" else 0.0) + maxf(0.0, 60.0 - chin) * KO_CHIN, 0.10, 0.60)


## Purse for pro fight n (1-based) as the game pays today (Roster: $1,500, +$500 a win, top $3,000); risky doubles it.
static func purse(wins: int, kind: String) -> int:
	var p := mini(Roster.PRO_PURSE + Roster.PRO_PURSE_STEP * wins, Roster.PRO_PURSE_TOP)
	return int(p * (RISKY_PURSE if kind == "risky" else 1.0))


static func new_state() -> Dictionary:
	return {"conf": CONF_START, "hunger": HUNGER_START, "patience": PATIENCE, "warn": 0, "gone": false, "w": 0, "l": 0, "ko": 0,
		"name": 0, "purse": 0, "gym": 0, "fights": 0, "not_yet": 0, "week": 0, "safe": 0, "risky": 0, "run": 0, "worst_run": 0,
		"conf_lo": CONF_START, "conf_hi": CONF_START, "hun_lo": HUNGER_START, "hun_hi": HUNGER_START, "ko_early": false, "late_w": 0, "late_n": 0,
		"hunger_by_fight": [], "conf_by_fight": []}


static func _clamp_bars(s: Dictionary) -> void:
	s["conf"] = clampi(int(s["conf"]), 0, 100)
	s["hunger"] = clampi(int(s["hunger"]), 0, 100)
	s["conf_lo"] = mini(int(s["conf_lo"]), int(s["conf"]))
	s["conf_hi"] = maxi(int(s["conf_hi"]), int(s["conf"]))
	s["hun_lo"] = mini(int(s["hun_lo"]), int(s["hunger"]))
	s["hun_hi"] = maxi(int(s["hun_hi"]), int(s["hunger"]))


## "Not yet": a patience mark, hunger -15, four more weeks. Returns false when no mark is left (the rival gym's call).
static func not_yet(s: Dictionary) -> bool:
	if int(s["patience"]) <= 1:
		return false
	s["patience"] = int(s["patience"]) - 1
	s["not_yet"] = int(s["not_yet"]) + 1
	s["hunger"] = int(s["hunger"]) + NOT_YET_HUNGER
	s["week"] = int(s["week"]) + NOT_YET_WEEKS
	_clamp_bars(s)
	return true


## A booking (pro fights 2-6, and the booking after fight 6): at 0 hunger a warning; the third time at 0, gone.
static func booking_check(s: Dictionary) -> void:
	if int(s["hunger"]) <= 0:
		s["warn"] = int(s["warn"]) + 1
		if int(s["warn"]) > WARNINGS:
			s["gone"] = true


## outcome: "win", "points", "ko". Moves the bars, the record, the name, the purse; the next fight's week.
static func after_fight(s: Dictionary, kind: String, outcome: String, gym_share: float) -> void:
	var n := int(s["fights"]) + 1
	s["fights"] = n
	s[kind] = int(s[kind]) + 1
	var pay := purse(int(s["w"]), kind)
	s["purse"] = int(s["purse"]) + pay
	s["gym"] = int(s["gym"]) + int(round(pay * gym_share))
	if outcome == "win":
		s["w"] = int(s["w"]) + 1
		s["run"] = 0
		s["conf"] = int(s["conf"]) + int(CONF[kind + "_win"])
		s["name"] = int(s["name"]) + (NAME_RISKY if kind == "risky" else NAME_SAFE)
		if kind == "safe":
			s["hunger"] = int(s["hunger"]) + int(HUNGER["safe_win"])
	else:
		s["l"] = int(s["l"]) + 1
		s["run"] = int(s["run"]) + 1
		s["worst_run"] = maxi(int(s["worst_run"]), int(s["run"]))
		s["conf"] = int(s["conf"]) + int(CONF["ko_loss" if outcome == "ko" else "points_loss"])
		if outcome == "ko":
			s["ko"] = int(s["ko"]) + 1
			if n <= 3:
				s["ko_early"] = true
	if kind == "risky":
		s["hunger"] = int(s["hunger"]) + int(HUNGER["risky"])
	# the next fight: the game's gap between pro nights; a stoppage loss adds the game's medical rest (idle weeks)
	var rest := MM.STOP_REST_WEEKS if outcome == "ko" else 0
	s["hunger"] = int(s["hunger"]) + int(HUNGER["idle_4w"]) * int(rest / 4)
	s["week"] = int(s["week"]) + MM.NEXT_WEEKS + rest
	_clamp_bars(s)
	(s["hunger_by_fight"] as Array).append(int(s["hunger"]))
	(s["conf_by_fight"] as Array).append(int(s["conf"]))


## THE SCORE (written before the run, DESIGN_TURNPRO1_V17.md s7): the boxer's standing after fight 6. Gone = 0.
const SCORE_W := 10.0
const SCORE_L := -5.0
const SCORE_NAME := 2.0
const SCORE_CONF := 0.2
const SCORE_GYM := 0.01   ## trial fix: 1 point a $100 of the gym's cut of the purse (Roster.GYM_SHARE, as built)


static func score_parts(s: Dictionary) -> Dictionary:
	var kept := not bool(s["gone"])
	return {"kept": 1.0 if kept else 0.0, "wins": SCORE_W * int(s["w"]) if kept else 0.0, "losses": SCORE_L * int(s["l"]) if kept else 0.0,
		"name": SCORE_NAME * int(s["name"]) if kept else 0.0, "conf": SCORE_CONF * (int(s["conf"]) - 50) if kept else 0.0,
		"gym": SCORE_GYM * int(s["gym"]) if kept else 0.0}


static func score(s: Dictionary) -> float:
	var p := score_parts(s)
	return float(p["wins"]) + float(p["losses"]) + float(p["name"]) + float(p["conf"]) + float(p["gym"])
