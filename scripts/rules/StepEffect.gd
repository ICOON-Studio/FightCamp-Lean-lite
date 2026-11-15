extends RefCounted
## StepEffect: what each boxing step does and how ability grades its effects.
## Owner: "Yes, build it after the fight week" (Q-S294-230).
## Owner: "three in a round on your count = the next exchange is on the ropes" (Q-S294-231).
## Map: ops/research/DESIGN_STEPVALUE1_V1_KALLI_KALLI.md sections 3 and 4.2.
## Every number ESTIMATE until probes 2-7 pass.
## effect(step) -> independent effect data, or {}.
## grade(mine, theirs) -> good, ok, or poor.
## grade_for(step, my_stats, opp_stats) -> grade using the step's abilities.
## scaled(step, grade_word) -> effect with graded magnitudes.
## is_best(step, situation) -> whether the step is best in that situation.
## is_wrong(step, situation) -> whether the step is wrong in that situation.
## ropes_after(count, step) -> your updated ropes count.
## on_ropes(count) -> whether the next exchange is on the ropes.

const STEPS := ["step_in", "step_out", "step_back", "pivot_out", "cut_off", "herd", "feint", "tie_up", "roll_out", "push_off"]
const GRADE_MULT := {"good": 1.2, "ok": 0.85, "poor": 0.35}
const GOOD_GAP := 5.0
const ROPES_AT := 3

const ABILITY := {
	"step_back": [
		"footwork",
		"speed"
	],
	"step_out": [
		"footwork",
		"footwork"
	],
	"pivot_out": [
		"footwork",
		"fight_iq"
	],
	"step_in": [
		"speed",
		"timing"
	],
	"cut_off": [
		"footwork",
		"footwork"
	],
	"herd": [
		"footwork",
		"strength"
	],
	"feint": [
		"fight_iq",
		"composure"
	],
	"tie_up": [
		"inside",
		"strength"
	],
	"roll_out": [
		"defence",
		"accuracy"
	],
	"push_off": [
		"strength",
		"strength"
	]
}

const TABLE := {
	"step_in": {
		"deny": 0.0,
		"deny_on": "",
		"distance": "inside",
		"open": 0.12,
		"open_on": "inside",
		"drain": 0.4,
		"break_to": "",
		"ropes": 0,
		"opp_ropes": 0,
		"clears_ropes": false,
		"opp_steps_less": 0.0,
		"opp_counter_edge": 0.0,
		"ends_early": false,
		"self_tank": 0.0,
		"tank": 0.3,
		"wrong_extra_damage": 0.2,
		"best": ["range", "she_tired"],
		"wrong": ["press", "counter"],
	},
	"step_out": {
		"deny": 0.25,
		"deny_on": "all",
		"distance": "",
		"open": 0.0,
		"open_on": "",
		"drain": 0.0,
		"break_to": "boxing",
		"ropes": 0,
		"opp_ropes": 0,
		"clears_ropes": true,
		"opp_steps_less": 0.0,
		"opp_counter_edge": 0.0,
		"ends_early": false,
		"self_tank": 0.0,
		"tank": 0.5,
		"wrong_extra_damage": 0.0,
		"best": ["press", "loadup"],
		"wrong": ["counter"],
	},
	"step_back": {
		"deny": 0.35,
		"deny_on": "power",
		"distance": "long",
		"open": 0.1,
		"open_on": "counter",
		"drain": 0.0,
		"break_to": "",
		"ropes": 1,
		"opp_ropes": 0,
		"clears_ropes": false,
		"opp_steps_less": 0.0,
		"opp_counter_edge": 0.0,
		"ends_early": false,
		"self_tank": 0.0,
		"tank": 0.3,
		"wrong_extra_damage": 0.0,
		"best": ["press", "loadup"],
		"wrong": ["range", "counter"],
	},
	"pivot_out": {
		"deny": 0.0,
		"deny_on": "",
		"distance": "mid",
		"open": 0.08,
		"open_on": "any",
		"drain": 0.0,
		"break_to": "",
		"ropes": 0,
		"opp_ropes": 0,
		"clears_ropes": true,
		"opp_steps_less": 0.0,
		"opp_counter_edge": 0.0,
		"ends_early": false,
		"self_tank": 0.0,
		"tank": 0.5,
		"wrong_extra_damage": 0.0,
		"best": ["press", "ropes", "inside"],
		"wrong": ["range"],
	},
	"cut_off": {
		"deny": 0.0,
		"deny_on": "",
		"distance": "",
		"open": 0.0,
		"open_on": "",
		"drain": 0.6,
		"break_to": "",
		"ropes": 0,
		"opp_ropes": 1,
		"clears_ropes": false,
		"opp_steps_less": 0.3,
		"opp_counter_edge": 0.0,
		"ends_early": false,
		"self_tank": 0.0,
		"tank": 0.5,
		"wrong_extra_damage": 0.0,
		"best": ["range", "she_tired"],
		"wrong": ["press"],
	},
	"herd": {
		"deny": 0.0,
		"deny_on": "",
		"distance": "",
		"open": 0.12,
		"open_on": "power",
		"drain": 0.0,
		"break_to": "",
		"ropes": 0,
		"opp_ropes": 1,
		"clears_ropes": false,
		"opp_steps_less": 0.0,
		"opp_counter_edge": 0.0,
		"ends_early": false,
		"self_tank": 0.0,
		"tank": 0.6,
		"wrong_extra_damage": 0.0,
		"best": ["range", "she_tired", "she_hurt"],
		"wrong": ["press"],
	},
	"feint": {
		"deny": 0.0,
		"deny_on": "",
		"distance": "",
		"open": 0.12,
		"open_on": "any",
		"drain": 0.0,
		"break_to": "",
		"ropes": 0,
		"opp_ropes": 0,
		"clears_ropes": false,
		"opp_steps_less": 0.0,
		"opp_counter_edge": -0.1,
		"ends_early": false,
		"self_tank": 0.0,
		"tank": 0.15,
		"wrong_extra_damage": 0.0,
		"best": ["counter"],
		"wrong": ["press"],
	},
	"tie_up": {
		"deny": 0.0,
		"deny_on": "",
		"distance": "",
		"open": 0.0,
		"open_on": "",
		"drain": 0.0,
		"break_to": "boxing",
		"ropes": 0,
		"opp_ropes": 0,
		"clears_ropes": false,
		"opp_steps_less": 0.0,
		"opp_counter_edge": 0.0,
		"ends_early": true,
		"self_tank": 0.8,
		"tank": -0.8,
		"wrong_extra_damage": 0.0,
		"best": ["loadup", "inside", "hurt"],
		"wrong": ["range"],
	},
	"roll_out": {
		"deny": 0.4,
		"deny_on": "head_hooks",
		"distance": "",
		"open": 0.1,
		"open_on": "counter",
		"drain": 0.0,
		"break_to": "",
		"ropes": 0,
		"opp_ropes": 0,
		"clears_ropes": false,
		"opp_steps_less": 0.0,
		"opp_counter_edge": 0.0,
		"ends_early": false,
		"self_tank": 0.0,
		"tank": 0.3,
		"wrong_extra_damage": 0.0,
		"best": ["press", "loadup"],
		"wrong": ["body"],
	},
	"push_off": {
		"deny": 0.0,
		"deny_on": "",
		"distance": "mid",
		"open": 0.0,
		"open_on": "",
		"drain": 0.3,
		"break_to": "",
		"ropes": 0,
		"opp_ropes": 0,
		"clears_ropes": false,
		"opp_steps_less": 0.0,
		"opp_counter_edge": 0.0,
		"ends_early": false,
		"self_tank": 0.0,
		"tank": 0.4,
		"wrong_extra_damage": 0.0,
		"best": ["inside", "clinch"],
		"wrong": ["range"],
	},
}


static func effect(step: String) -> Dictionary:
	if not TABLE.has(step):
		return {}
	var row: Dictionary = TABLE[step]
	return row.duplicate(true)


static func grade(mine: float, theirs: float) -> String:
	if mine - theirs >= GOOD_GAP:
		return "good"
	if theirs - mine >= GOOD_GAP:
		return "poor"
	return "ok"


static func grade_for(step: String, my_stats: Dictionary, opp_stats: Dictionary) -> String:
	if not ABILITY.has(step):
		return "ok"
	var pair: Array = ABILITY[step]
	return grade(float(my_stats.get(pair[0], 0.0)), float(opp_stats.get(pair[1], 0.0)))


static func scaled(step: String, grade_word: String) -> Dictionary:
	var result: Dictionary = effect(step)
	if result.is_empty():
		return result
	var multiplier: float = float(GRADE_MULT.get(grade_word, GRADE_MULT["ok"]))
	for key in ["deny", "open", "drain", "opp_counter_edge", "opp_steps_less", "self_tank"]:
		result[key] = float(result[key]) * multiplier
	return result


static func is_best(step: String, situation: String) -> bool:
	var row: Dictionary = effect(step)
	return situation in row.get("best", [])


static func is_wrong(step: String, situation: String) -> bool:
	var row: Dictionary = effect(step)
	return situation in row.get("wrong", [])


static func ropes_after(count: int, step: String) -> int:
	var row: Dictionary = effect(step)
	if bool(row.get("clears_ropes", false)):
		return 0
	return count + int(row.get("ropes", 0))


static func on_ropes(count: int) -> bool:
	return count >= ROPES_AT
