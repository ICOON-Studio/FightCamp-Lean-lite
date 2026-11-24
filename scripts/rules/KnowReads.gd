extends RefCounted
## KnowReads - the reads table (design section 3), pure static.
## Preloads only Knowledge.gd. No he/she (S412). No names in lines (S448).
## S545 KNOWBUILD1 (map v9 C1-C3, owner K4): the trial runs BY THE DAY at PRICE_TRIAL_DAY ($36, a week's stipend by the
## day), and each evening the player picks tomorrow's QUESTION (QUESTIONS: body, skills, the pad test, the hard spar);
## apply_trial_day(k, q). A question asked again narrows again, half as much each time (the map's day-1 / day-6 body pair,
## 16 then 8). The test day is gone: its read is the "body" question (PRICE_TEST_DAY and the test_day button folded in).
## "trial" (the old 4-week, $500 read) now stands for the map's full seven-day ladder by the day ($252), for the probes.

const K := preload("res://scripts/rules/Knowledge.gd")

# --- Read prices (ESTIMATE) ---
const PRICE_LOOK_CLOSER := 120  ## ESTIMATE
const STIPEND_WEEKLY := 250  ## ESTIMATE - amateur fighter stipend
const PRICE_TRIAL_DAY := 36  ## MEASURED (KNOWSTAKES9 B2: $18 a day ties always-trial, $36 and $72 pass)
const TRIAL_MAX_DAYS := 7
const PRICE_RECHECK := 40  ## ESTIMATE
const PRICE_HARD_SPAR_OUTSIDE := 160  ## ESTIMATE

# --- Read risk numbers (ESTIMATE) ---
const RISK_INJURY_MULT := 2.0  ## ESTIMATE - injury x2 for the night
const RISK_TIREDNESS := 15  ## ESTIMATE - tiredness +15

# --- The trial's questions (owner K4: the player's pick each evening) ---
const QUESTIONS: Array[String] = ["body", "skills", "pads", "spar"]
## The first ask's exposure (map v9 3B: day 1 body 16; days 2-4 skills 24 over three, so 12 + 6 + 3 at halving); the pad test
## halves the ceiling's half-width; the hard spar opens under fire to half (Knowledge.hard_spar), then adds to it.
const FIRST_BODY := 16.0
const FIRST_SKILLS := 12.0
const FIRST_SPAR := (15.0 - 0.5) * 0.5

# --- Read kinds ---
const READS: Array[String] = ["look_closer", "trial", "test_day", "recheck",
	"hard_spar_club", "hard_spar_outside"]

## Price of a read in dollars.
static func price(kind: String) -> int:
	if kind == "look_closer":
		return PRICE_LOOK_CLOSER
	elif kind == "trial" or kind == "test_day" or QUESTIONS.has(kind):
		return PRICE_TRIAL_DAY  # a trial day; the old test day is the "body" question
	elif kind == "recheck":
		return PRICE_RECHECK
	elif kind == "hard_spar_club":
		return 0  # no cash cost, just risk
	elif kind == "hard_spar_outside":
		return PRICE_HARD_SPAR_OUTSIDE
	return 0

## What a read narrows. Returns a description dict.
static func narrows(kind: String) -> Dictionary:
	if kind == "look_closer":
		return {"desc": "One group to half its day-one width, or clears Hyped", "group": "any"}
	elif kind == "trial":
		return {"desc": "The seven trial days, one question a day", "group": "all"}
	elif kind == "test_day" or kind == "body":
		return {"desc": "The fitness test: the body read", "group": "body"}
	elif kind == "skills":
		return {"desc": "Pad rounds: the skills read", "group": "skills"}
	elif kind == "pads":
		return {"desc": "The pad test: the ceiling's range halved", "group": "ceiling"}
	elif kind == "spar":
		return {"desc": "The hard spar: under fire and the pressure trait", "group": "under_fire"}
	elif kind == "recheck":
		return {"desc": "Wins back half of what went stale", "group": "stale"}
	elif kind == "hard_spar_club":
		return {"desc": "Under fire to half way", "group": "under_fire"}
	elif kind == "hard_spar_outside":
		return {"desc": "Under fire to 3/4", "group": "under_fire"}
	return {"desc": "", "group": ""}

## Apply a read to the knowledge dict. Returns cost for trial (0 for others).
static func apply(k: Dictionary, kind: String) -> int:
	if kind == "look_closer":
		_apply_look_closer(k)
		return 0
	elif kind == "trial":
		_apply_trial(k)
		return PRICE_TRIAL_DAY * TRIAL_MAX_DAYS
	elif kind == "test_day":
		return apply_trial_day(k, "body")
	elif QUESTIONS.has(kind):
		return apply_trial_day(k, kind)
	elif kind == "recheck":
		K.recheck(k)
		return 0
	elif kind == "hard_spar_club":
		K.hard_spar(k, false)
		return 0
	elif kind == "hard_spar_outside":
		K.hard_spar(k, true)
		return 0
	return 0

## Look closer: one group to half its day-one width, or clears Hyped.
static func _apply_look_closer(k: Dictionary) -> void:
	if K.is_hyped(k):
		K.clear_hype(k)
		return
	# Narrow the widest group to half its day-one width (skip under_fire if not opened)
	var widest: String = ""
	var widest_w: float = 0.0
	for g in ["body", "skills", "under_fire"]:
		if g == "under_fire" and not k.get("under_fire_opened", false):
			continue  # skip unknown under_fire
		var w: float = K.width(k, g)
		if w > widest_w:
			widest_w = w
			widest = g
	if widest == "":
		return
	var start: float = _start_of(widest)
	var target_half: float = start / 2.0
	var current: float = _exposure_of(k, widest)
	# Solve for exposure that gives target_half width
	if target_half <= K.FLOOR:
		return
	var needed_exp: float = ((start - K.FLOOR) / (target_half - K.FLOOR) - 1.0) * K.HALF
	if needed_exp > current:
		_set_exposure(k, widest, needed_exp)

## The map's full ladder, seven days by the day (body, skills x3, the pad test, body, the hard spar).
static func _apply_trial(k: Dictionary) -> void:
	for q in ["body", "skills", "skills", "skills", "pads", "body", "spar"]:
		apply_trial_day(k, q)


## One trial day: tomorrow's question, picked the evening before (K4). Returns the day's price. k["asks"] counts each
## question; k["ceil_hw"] is the ceiling's half-width (ProspectClock.CEIL_HW before any pad test).
static func apply_trial_day(k: Dictionary, q: String) -> int:
	var asks: Dictionary = k.get("asks", {})
	var n := int(asks.get(q, 0))
	var size := pow(0.5, n)   # a second ask is half the first
	if q == "body":
		K.expose(k, "body", FIRST_BODY * size, "test")
	elif q == "skills":
		K.expose(k, "skills", FIRST_SKILLS * size, "session")
	elif q == "pads":
		k["ceil_hw"] = float(k.get("ceil_hw", 14.0)) * (1.0 - 0.5 * size)
	elif q == "spar":
		if n == 0:
			K.hard_spar(k, false)
		else:
			K.expose(k, "under_fire", FIRST_SPAR * size, "spar")
		k["pressure_seen"] = true
	else:
		return 0
	asks[q] = n + 1
	k["asks"] = asks
	return PRICE_TRIAL_DAY


## The question asked least so far (the default when an evening goes unanswered).
static func least_asked(k: Dictionary) -> String:
	var asks: Dictionary = k.get("asks", {})
	var best := "body"
	for q in QUESTIONS:
		if int(asks.get(q, 0)) < int(asks.get(best, 0)):
			best = q
	return best

## Recheck ready: once every 3 weeks per boxer.
static func recheck_ready(k: Dictionary, day: int) -> bool:
	return K.recheck_ready(k, day)

## Risk numbers for hard spar (for the screen).
static func risk(kind: String) -> Dictionary:
	if kind == "hard_spar_club" or kind == "hard_spar_outside" or kind == "spar":
		return {"injury_mult": RISK_INJURY_MULT, "tiredness": RISK_TIREDNESS}
	return {}

# --- internal ---

static func _start_of(group: String) -> float:
	if group == "body":
		return K.BODY_START
	elif group == "skills":
		return K.SKILLS_START
	elif group == "under_fire":
		return K.UNDER_FIRE_START
	return 0.0

static func _exposure_of(k: Dictionary, group: String) -> float:
	if group == "body":
		return float(k.get("body", 0.0))
	elif group == "skills":
		return float(k.get("skills", 0.0))
	elif group == "under_fire":
		return float(k.get("fire_bout", 0.0)) + minf(float(k.get("fire_spar", 0.0)), K.FIRE_SPAR_CAP)
	return 0.0

static func _set_exposure(k: Dictionary, group: String, amount: float) -> void:
	if group == "body":
		k["body"] = amount
	elif group == "skills":
		k["skills"] = amount
	elif group == "under_fire":
		k["fire_spar"] = amount
