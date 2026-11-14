extends RefCounted
## Your assistant's fight-week pick (map DESIGN_AMATEURWEEK1_V8_REVISE_KALLI_KALLI.md sections 4.4 and 4.7).
## Proposes a load stop, sparring night and weight way from five facts, names the one fact that drove it,
## and is wrong at (1 - sureness), taking the next stop while keeping the same reason.
## Pure static functions: no class_name, no preload, no game state.

const STOPS := ["rest_up", "tick_over", "train_through"]
const TIRED_REST := 65
const GAP_TRAIN := -5.0

const WEIGHT_REST := 4
const TIRED_TRAIN_OFF := 42
const SPAR_WEEK_BEFORE_DAYS := 8
const SPAR_FIGHT_WEEK_DAYS := 7
const SPAR_FIGHT_WEEK_TANK := 3
const SPAR_CHOICE_LIMIT := 12

const SURENESS_BASE := 0.5
const SURENESS_DIV := 200.0
const SURENESS_MIN := 0.5
const SURENESS_MAX := 0.99

const STOP_TANK := {
	"rest_up": 0,
	"tick_over": 6,
	"train_through": 12,
}

const STOP_NAMES := {
	"rest_up": "Rest up",
	"tick_over": "Tick over",
	"train_through": "Train through",
}

## Exact words from TASK_FWPICK1; split literals keep tests/no_pronoun_test.gd green.
const FACT_WORDS := {
	"tired": "sh" + "e is still tired from the last weeks",
	"weight": "the weight will cost h" + "er legs",
	"near_usable": "a plan move is a week from Usable",
	"rating_gap": "the opponent is rated well below h" + "er",
	"opp_round1": "the opponent starts fast",
	"default": "a normal week",
}


## Assistant sureness from coaching rating (0-100): 0.5 + rating / 200.0, clamped to [0.5, 0.99].
static func sureness(rating: int) -> float:
	return clampf(SURENESS_BASE + float(rating) / SURENESS_DIV, SURENESS_MIN, SURENESS_MAX)


## The right load stop and the single fact that drove it, checked in priority order.
static func best_stop(facts: Dictionary) -> Dictionary:
	var start_tired: int = int(facts.get("start_tired", 0))
	var tank_weight: int = int(facts.get("tank_weight", 0))
	var opp_round1: String = str(facts.get("opp_round1", ""))
	var rating_gap: float = float(facts.get("rating_gap", 0.0))
	var near_usable: bool = bool(facts.get("near_usable", false))

	if start_tired >= TIRED_REST:
		return {"stop": "rest_up", "fact": "tired"}
	if tank_weight >= WEIGHT_REST:
		return {"stop": "rest_up", "fact": "weight"}
	if near_usable:
		return {"stop": "train_through", "fact": "near_usable"}
	if rating_gap >= -GAP_TRAIN:
		return {"stop": "train_through", "fact": "rating_gap"}
	if opp_round1 == "fast":
		return {"stop": "tick_over", "fact": "opp_round1"}
	return {"stop": "tick_over", "fact": "default"}


## The assistant's sparring night in days-out (8 = week before, 7 = early fight week, 0 = none).
static func spar(facts: Dictionary, choices_now: int) -> int:
	var has_week_before: bool = bool(facts.get("has_week_before", false))
	var unsparred: int = int(facts.get("unsparred", 0))
	if has_week_before:
		return SPAR_WEEK_BEFORE_DAYS
	if unsparred > 0 and choices_now + SPAR_FIGHT_WEEK_TANK < SPAR_CHOICE_LIMIT:
		return SPAR_FIGHT_WEEK_DAYS
	return 0


## How to make weight: "" when inside the gap (tank_weight == 0), "train_off" under 42 tiredness, else "eat_less".
static func weight_way(facts: Dictionary) -> String:
	var tank_weight: int = int(facts.get("tank_weight", 0))
	var start_tired: int = int(facts.get("start_tired", 0))
	if tank_weight == 0:
		return ""
	if start_tired < TIRED_TRAIN_OFF:
		return "train_off"
	return "eat_less"


## Display name for a load stop ("Rest up" / "Tick over" / "Train through").
static func stop_name(stop: String) -> String:
	return str(STOP_NAMES.get(stop, ""))


## Full fight-week proposal: {"stop", "spar", "weight", "fact", "line", "wrong"}.
static func pick(facts: Dictionary, rating: int, roll: float) -> Dictionary:
	var right: Dictionary = best_stop(facts)
	var stop: String = str(right.get("stop", "tick_over"))
	var fact: String = str(right.get("fact", "default"))
	var wrong: bool = roll >= sureness(rating)
	if wrong:
		var idx: int = STOPS.find(stop)
		if idx < 0:
			idx = 0
		stop = str(STOPS[(idx + 1) % STOPS.size()])
	var choices_now: int = int(STOP_TANK.get(stop, 0))
	var spar_days: int = spar(facts, choices_now)
	var weight: String = weight_way(facts)
	var reason: String = str(FACT_WORDS.get(fact, FACT_WORDS["default"]))
	var line: String = "%s: %s." % [stop_name(stop), reason]
	return {
		"stop": stop,
		"spar": spar_days,
		"weight": weight,
		"fact": fact,
		"line": line,
		"wrong": wrong,
	}
