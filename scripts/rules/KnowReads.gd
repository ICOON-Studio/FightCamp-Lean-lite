extends RefCounted
## KnowReads - the reads table (design section 3), pure static.
## Preloads only Knowledge.gd. No he/she (S412). No names in lines (S448).

const K := preload("res://scripts/rules/Knowledge.gd")

# --- Read prices (ESTIMATE) ---
const PRICE_LOOK_CLOSER := 120  ## ESTIMATE
const PRICE_TRIAL_WEEKS := 4  ## ESTIMATE
const STIPEND_WEEKLY := 250  ## ESTIMATE - amateur fighter stipend
const PRICE_TEST_DAY := 60  ## ESTIMATE
const PRICE_RECHECK := 40  ## ESTIMATE
const PRICE_HARD_SPAR_OUTSIDE := 160  ## ESTIMATE

# --- Read risk numbers (ESTIMATE) ---
const RISK_INJURY_MULT := 2.0  ## ESTIMATE - injury x2 for the night
const RISK_TIREDNESS := 15  ## ESTIMATE - tiredness +15

# --- Read kinds ---
const READS: Array[String] = ["look_closer", "trial", "test_day", "recheck",
	"hard_spar_club", "hard_spar_outside"]

## Price of a read in dollars.
static func price(kind: String) -> int:
	if kind == "look_closer":
		return PRICE_LOOK_CLOSER
	elif kind == "trial":
		return PRICE_TRIAL_WEEKS * STIPEND_WEEKLY / 2  # half stipend for 4 weeks
	elif kind == "test_day":
		return PRICE_TEST_DAY
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
		return {"desc": "Every group as if signed", "group": "all"}
	elif kind == "test_day":
		return {"desc": "Body 4 off each edge; twice with under 5 bouts", "group": "body"}
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
		return price("trial")
	elif kind == "test_day":
		_apply_test_day(k)
		return 0
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

## Trial: every group narrows as if signed (significant exposure).
static func _apply_trial(k: Dictionary) -> void:
	# Simulate 4 weeks of training: significant exposure to body and skills
	K.expose(k, "body", 24.0, "session")
	K.expose(k, "skills", 24.0, "session")
	# Some spar exposure to under_fire (if opened)
	if k.get("under_fire_opened", false):
		K.expose(k, "under_fire", 8.0, "spar")

## Test day: body 4 off each edge; twice with under 5 bouts.
static func _apply_test_day(k: Dictionary) -> void:
	var narrow: float = K.BOUT_FIRE_NARROW  # 4 points
	var bouts: int = int(k.get("bout_count", 0))
	if bouts < 5:
		narrow *= 2.0  # twice with under 5 bouts
	K.expose(k, "body", narrow * 2.0, "test")  # exposure to narrow by ~4

## Recheck ready: once every 3 weeks per boxer.
static func recheck_ready(k: Dictionary, day: int) -> bool:
	return K.recheck_ready(k, day)

## Risk numbers for hard spar (for the screen).
static func risk(kind: String) -> Dictionary:
	if kind == "hard_spar_club" or kind == "hard_spar_outside":
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
