extends RefCounted
## The club-show weight gap (England Boxing 2026 rules 7.1.3, 2.7.8).
## At club shows two amateurs are matched at walking weight within a gap, not by the class limit.
## Pure static functions: no class_name, no preload, no game state.

# Gap by class tier
const GAP_LIGHT_KG := 2.5    # classes with a limit up to 65.0 kg
const GAP_HEAVY_KG := 5.0    # limit above 65.0 kg
const GAP_SKILLS_KG := 2.0   # skills bout

# Cost / edge constants
const EAT_LESS_TANK := 4     # tank points the cut costs
const TRAIN_OFF_KG := 0.3    # kg a train-off shifts
const TRAIN_OFF_TIRED := 8   # tiredness a train-off adds
const KILO_EDGE_KG := 1.0    # ask_kilo works only within this of the gap

# Miss / rematch
const REMATCH_CHANCE := 1.0 / 3.0
const MISS_COST := 300
const MISS_FAVOUR := 1


## The gap in kg for a class limit (and whether it is a skills bout).
static func gap_kg(class_limit: float, skills: bool = false) -> float:
	if skills:
		return GAP_SKILLS_KG
	if class_limit <= 65.0:
		return GAP_LIGHT_KG
	return GAP_HEAVY_KG


## How far inside (positive) or outside (negative) the gap the match sits.
static func margin(own_kg: float, opp_kg: float, class_limit: float, skills: bool = false) -> float:
	return gap_kg(class_limit, skills) - absf(own_kg - opp_kg)


## True when the two boxers sit inside the gap (exactly on the edge counts).
static func in_gap(own_kg: float, opp_kg: float, class_limit: float, skills: bool = false) -> bool:
	return margin(own_kg, opp_kg, class_limit, skills) >= 0.0


## The three ways to make the match, always in this order:
## eat_less, train_off, ask_kilo. Each entry: id, ok, why, tank, tired, favours, kg.
static func ways(own_kg: float, opp_kg: float, class_limit: float, favours: int, start_tired: int, skills: bool = false) -> Array:
	var m := margin(own_kg, opp_kg, class_limit, skills)

	# eat_less: always ok, keeps her at weight (kg 0.0)
	var eat_less := {
		"id": "eat_less",
		"ok": true,
		"why": "",
		"tank": EAT_LESS_TANK,
		"tired": 0,
		"favours": 0,
		"kg": 0.0,
	}

	# train_off: always ok, shifts 0.3 kg
	var train_off := {
		"id": "train_off",
		"ok": true,
		"why": "",
		"tank": 0,
		"tired": TRAIN_OFF_TIRED,
		"favours": 0,
		"kg": TRAIN_OFF_KG,
	}

	# ask_kilo: ok only when favours >= 1 AND outside the gap by no more than 1 kg
	var ask_ok := false
	var ask_why := ""
	if favours < 1:
		ask_why = "no favour with the host"
	elif m >= 0.0:
		ask_why = "already inside the gap"
	elif m < -KILO_EDGE_KG:
		ask_why = "only within 1 kg of the gap"
	else:
		ask_ok = true

	var ask_kilo := {
		"id": "ask_kilo",
		"ok": ask_ok,
		"why": ask_why,
		"tank": 0,
		"tired": 0,
		"favours": MISS_FAVOUR if ask_ok else 0,
		"kg": KILO_EDGE_KG if ask_ok else 0.0,
	}

	return [eat_less, train_off, ask_kilo]


## The best cut for fight day: train_off beats eat_less only when start_tired < 42.
static func best_cut(start_tired: int) -> String:
	if start_tired < 42:
		return "train_off"
	return "eat_less"


## The boxer is outside the gap on the day. What happens?
static func miss(roll: float, host_has_spare: bool) -> Dictionary:
	if host_has_spare and roll < REMATCH_CHANCE:
		return {"rematched": true, "off": false, "cost": 0, "favours": 0}
	return {"rematched": false, "off": true, "cost": MISS_COST, "favours": MISS_FAVOUR}


## Day-before championship weigh-in: weight <= limit + tolerance (unchanged from BoutRules.made_weight).
static func championship(weight: float, limit: float, tolerance: float) -> bool:
	return weight <= limit + tolerance
