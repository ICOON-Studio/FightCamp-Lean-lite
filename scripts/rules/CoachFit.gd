extends RefCounted
## CoachFit: one number around neutral 50 that scales gain and tiredness.
## Pure static functions, no game state. Map:
## ops/research/DESIGN_COACHFIT1_V8_REVISE_KALLI_KALLI.md 2.1, 2.2, 3.3, 3.4, 4.1, 5.2, 6.1

const NEUTRAL := 50
const FIT_MIN := 10
const FIT_MAX := 90
const OVER_FREE := 0.5
const OVER_MID := 1.5
const OVER_MAX := 2.0
const PEN_MID := -8
const PEN_HIGH := -18
const BOND_STEPS := [
	["Stranger", 0, -4],
	["Working", 8, 0],
	["Trusted", 45, 6],
	["Corner", 110, 12],
]
const STRANGER_EVENINGS_ONLY := true
const TAUGHT_OUT_WITHIN := 5
const TAUGHT_OUT := -6
const ABOVE_CEILING := 0.5
const FOCUS_MORNING := 10
const FOCUS_OTHER_MORNING := -3
const TEMPER_SUITS := 6
const TEMPER_CLASH := -8
const STEADY_ALWAYS := 2
const MODE_RIGHT := 4
const MODE_WRONG := -4
const STACK_CAP := 1.6
const WORDS := [["TOP FIT", 75], ["GOOD", 58], ["MIXED", 40], ["RISKY", 0]]
const COACH_TIME := {
	"sessional": 10.0,
	"fulltime": 14.0,
	"head": 4.0,
	"club2": 2.0,
	"promoted": 8.0,
	"promoted_l2": 10.0,
}
const COST := {
	"pads": 1.0,
	"pads_shared": 1.5,
	"spar": 1.5,
	"spar_two": 2.0,
	"film": 0.0,
	"corner": 3.0,
	"morning_normal": 0.5,
	"morning_hard": 1.0,
}


static func bond_step(bond: float) -> Dictionary:
	var best_word: String = "Stranger"
	var best_fit: int = -4
	for entry in BOND_STEPS:
		var arr: Array = entry as Array
		var w: String = str(arr[0])
		var from_val: float = float(arr[1])
		var f: int = int(arr[2])
		if bond >= from_val:
			best_word = w
			best_fit = f
	return {"word": best_word, "fit": best_fit}


static func time_penalty(over: float) -> int:
	if over <= OVER_FREE:
		return 0
	if over <= OVER_MID:
		return PEN_MID
	return PEN_HIGH


static func temper_part(temper: String, mode: String, boxer: Dictionary) -> int:
	var temper_key: String = temper.to_lower()
	var mode_key: String = mode.to_lower()
	var morale_raw: String = str(boxer.get("morale_word", ""))
	var morale_low: String = morale_raw.to_lower()
	var is_flat_low: bool = morale_low == "flat" or morale_low == "low"
	var coachability_val: int = int(boxer.get("coachability", 50))
	var share_val: float = float(boxer.get("cards_known_share", 0.0))
	var total: int = 0
	if temper_key == "motivator":
		if is_flat_low:
			total += TEMPER_SUITS
		if mode_key == "lift" and is_flat_low:
			total += MODE_RIGHT
	elif temper_key == "technician":
		if coachability_val >= 70:
			total += TEMPER_SUITS
		elif coachability_val < 30:
			total += TEMPER_CLASH
		if mode_key == "polish":
			if share_val > 0.5:
				total += MODE_RIGHT
			else:
				total += MODE_WRONG
		elif mode_key == "teach":
			if share_val < 0.5:
				total += MODE_RIGHT
			else:
				total += MODE_WRONG
	elif temper_key == "steady":
		total += STEADY_ALWAYS
	return clampi(total, -12, 10)


static func fit(p: Dictionary) -> int:
	var temper_str: String = str(p.get("temper", ""))
	var mode_str: String = str(p.get("mode", ""))
	var boxer_dict: Dictionary = p.get("boxer", {})
	var over_val: float = float(p.get("over", 0.0))
	var bond_val: float = float(p.get("bond", 8.0))
	var evening_flag: bool = bool(p.get("evening", false))
	var mastery_val: float = float(p.get("mastery_or_stat", 0.0))
	var ceiling_val: float = float(p.get("ceiling", 0.0))
	var focus_str: String = str(p.get("focus", ""))
	var temper_component: int = temper_part(temper_str, mode_str, boxer_dict)
	var time_component: int = time_penalty(over_val)
	var bond_info: Dictionary = bond_step(bond_val)
	var bond_word: String = str(bond_info.get("word", ""))
	var bond_fit_raw: int = int(bond_info.get("fit", 0))
	var bond_component: int = bond_fit_raw
	if bond_word == "Stranger" and not evening_flag and STRANGER_EVENINGS_ONLY:
		bond_component = 0
	var taught_component: int = 0
	if ceiling_val > 0.0:
		if mastery_val >= ceiling_val:
			taught_component = 0
		elif mastery_val >= ceiling_val - float(TAUGHT_OUT_WITHIN):
			taught_component = TAUGHT_OUT
	var focus_component: int = 0
	if not evening_flag:
		var focus_low: String = focus_str.to_lower()
		if focus_low == "this":
			focus_component = FOCUS_MORNING
		elif focus_low == "other":
			focus_component = FOCUS_OTHER_MORNING
	var base_sum: int = NEUTRAL + temper_component + time_component
	base_sum += bond_component + taught_component + focus_component
	var sum_float: float = float(base_sum)
	var rounded: int = int(round(sum_float))
	return clampi(rounded, FIT_MIN, FIT_MAX)


static func gain_mult(fit: int) -> float:
	return 0.5 + float(fit) / 100.0


static func tired_mult(fit: int) -> float:
	return 1.125 - 0.0025 * float(fit)


static func ceiling_mult(value: float, ceiling: float) -> float:
	if value >= ceiling:
		return ABOVE_CEILING
	return 1.0


static func capped(gain_mult: float, camp_mult: float) -> Dictionary:
	var prod: float = gain_mult * camp_mult
	var limited: float = minf(prod, STACK_CAP)
	var capped_flag: bool = prod > STACK_CAP
	return {"mult": limited, "capped": capped_flag}


static func word(fit: int) -> String:
	for row in WORDS:
		var row_arr: Array = row as Array
		var label: String = str(row_arr[0])
		var floor_val: int = int(row_arr[1])
		if fit >= floor_val:
			return label
	return "RISKY"


static func morning_ceiling(area_rating: float) -> int:
	return int(floor(55.0 + area_rating * 0.35))


static func evening_ceiling(area_rating: float) -> int:
	return int(floor(area_rating))


static func week_cost(nights: Array) -> float:
	var total_cost: float = 0.0
	for raw in nights:
		var key: String = str(raw)
		var add: float = float(COST.get(key, 0.0))
		total_cost += add
	return total_cost


static func over(coach: String, cost: float, borrowed: float) -> float:
	var budget: float = float(COACH_TIME.get(coach, 0.0))
	return cost - (budget - borrowed)


static func can_take(coach: String, cost: float, borrowed: float) -> bool:
	return over(coach, cost, borrowed) <= OVER_MAX


static func next_week_time(coach: String, over_now: float, rested: bool) -> float:
	var base: float = float(COACH_TIME.get(coach, 0.0))
	if rested:
		return base + 3.0
	return base - maxf(0.0, over_now)
