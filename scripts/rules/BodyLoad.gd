extends RefCounted
## Per-part Burn: how worked each body part is. The body is the track.
## Pure static module over the beat format from RoundScript / ClinchBeats / InsideBeats.

const PARTS := ["lead_shoulder", "rear_shoulder", "lead_arm", "rear_arm", "core", "legs"]
## Lead hand (left for orthodox, right for southpaw - the 3D mirrors her): jab, lead_hook, body_hook.
const LEAD_MOVES := ["jab", "lead_hook", "body_hook"]
## Rear hand: cross, rear_uppercut.
const REAR_MOVES := ["cross", "rear_uppercut"]
## Burn added per THROWN punch (any result) to that hand's shoulder and arm. S322: 0.85 (Qwen measured 1.0 -> the busy
## shoulder 46 / 73 / 92 after rounds 1-3: every boxer's hands at her chest by round 3); 0.85 aims at 30-50 / 48-70 / 62-85.
## Then 0.70: the game's rounds throw more lead-hand punches than RoundScript alone (habits, combos) - burn_probe read the
## jab shoulder ~93 at 2:30 of round 3 (lead glove 0.17 m down); 0.70 aims at ~75 there.
const SHOULDER_PER_PUNCH := 0.70
const ARM_PER_PUNCH := 0.7
## Hooks and uppercuts load the arm more.
const POWER_ARM_MULT := 1.3
## A punch thrown at combination cadence costs 1.39x (Combos.FAST_PUNCH, Arseneau 2011 bag VO2).
const FAST_PUNCH := 1.39
## Every punch turns the trunk: core gets this per thrown punch.
const CORE_PER_PUNCH := 0.25
## Holding in a clinch (clinch t .. break_t), BOTH boxers, per second: both shoulders and core.
const CLINCH_PER_S := 0.6
## Legs per second of the exchange's 30 s (moving, bouncing); x SIT_LEGS for the boxer who moves more.
## S322: 0.035 -> 0.16 (burn_probe in the game: legs 5 at round 3 - the legs never showed); ~29 a round before the rest.
const LEGS_PER_S := 0.16
const SIT_LEGS := {"press": {"b": 1.3}, "range": {"a": 1.25, "b": 1.1}, "counter": {"a": 1.1}}
## Inside spells (inside t .. end_t) the feet stop: legs gain only this share during them.
const INSIDE_LEGS := 0.5
## Pace (the player's driver mode): effort per punch / per second.
const PACE := {"push": 1.2, "steady": 1.0, "save": 0.8}
## Tired muscles burn faster: gain x (1 + TANK_MULT x (1 - tank / 100)), tank = her Combos energy 0..100.
const TANK_MULT := 0.5
## The minute's rest gives back REST_BACK of each part's Burn x her conditioning (0.8 .. 1.2).
const REST_BACK := 0.55
## Body shots hurt -> she breathes harder -> refills slower.
const RIBS_HURT_REST := 0.7
## The corner's second works ONE part in the rest: that part loses SECOND_WORK more.
const SECOND_WORK := 12.0
## Effects start at EFFECT_FROM and are full at 100. S322: 50 -> 40 (burn_probe: the busy shoulder ends a 3-round bout
## ~60-70, so at 50 a guard barely moved in the last round).
const EFFECT_FROM := 40.0
const GUARD_DROP_MAX := 1.0
const STEP_MIN := 0.6
const POWER_MIN := 0.75
const EXCHANGE_S := 30.0
const PUNCHES := ["jab", "cross", "lead_hook", "body_hook", "rear_uppercut"]


static func fresh() -> Dictionary:
	var a_parts := {}
	var b_parts := {}
	for p in PARTS:
		a_parts[p] = 0.0
		b_parts[p] = 0.0
	return {"a": a_parts, "b": b_parts}


static func _leg_mult(sit: String, who: String) -> float:
	var sit_def: Dictionary = SIT_LEGS.get(sit, {})
	return float(sit_def.get(who, 1.0))


static func _gain_mult(pace: String, tank: float, rate: float) -> float:
	var pace_m: float = float(PACE.get(pace, 1.0))
	var tank_f: float = 1.0 + TANK_MULT * (1.0 - tank / 100.0)
	return pace_m * tank_f * rate


static func _is_power_arm(move: String) -> bool:
	return move == "lead_hook" or move == "body_hook" or move == "rear_uppercut"


static func _inside_time(beats: Array) -> float:
	var total := 0.0
	for b in beats:
		if str(b["move"]) == "inside" and b.has("end_t"):
			var dur: float = float(b["end_t"]) - float(b["t"])
			if dur > 0.0:
				total += dur
	return total


static func add_exchange(load: Dictionary, beats: Array, ctx: Dictionary) -> void:
	var sit: String = str(ctx.get("sit", ""))
	var pace_d: Dictionary = ctx.get("pace", {})
	var tank_d: Dictionary = ctx.get("tank", {})
	var rates_d: Dictionary = ctx.get("rates", {})
	for beat in beats:
		var m: String = str(beat["move"])
		if m == "clinch" and beat.has("break_t"):
			var dur: float = float(beat["break_t"]) - float(beat["t"])
			if dur > 0.0:
				for who in ["a", "b"]:
					var pace: String = str(pace_d.get(who, "steady"))
					var tank: float = float(tank_d.get(who, 100.0))
					var rates: Dictionary = rates_d.get(who, {})
					var co_rate: float = float(rates.get("core", 1.0))
					var gm: float = _gain_mult(pace, tank, 1.0)
					var co_g: float = CLINCH_PER_S * dur * gm * co_rate
					for sh in ["lead_shoulder", "rear_shoulder"]:
						load[who][sh] = float(load[who][sh]) + CLINCH_PER_S * dur * gm * float(rates.get(sh, 1.0))
					load[who]["core"] = float(load[who]["core"]) + co_g
	for beat in beats:
		var m: String = str(beat["move"])
		if not (m in PUNCHES):
			continue
		var who: String = str(beat["who"])
		var pace: String = str(pace_d.get(who, "steady"))
		var tank: float = float(tank_d.get(who, 100.0))
		var rates: Dictionary = rates_d.get(who, {})
		var combo: bool = bool(beat.get("combo", false)) or str(beat.get("combo_id", "")) != ""
		var combo_m: float = FAST_PUNCH if combo else 1.0
		var gm: float = _gain_mult(pace, tank, 1.0) * combo_m
		var is_lead: bool = m in LEAD_MOVES
		var sh_part: String = "lead_shoulder" if is_lead else "rear_shoulder"
		var ar_part: String = "lead_arm" if is_lead else "rear_arm"
		var sh_rate: float = float(rates.get(sh_part, 1.0))
		var ar_rate: float = float(rates.get(ar_part, 1.0))
		var co_rate: float = float(rates.get("core", 1.0))
		load[who][sh_part] = float(load[who][sh_part]) + SHOULDER_PER_PUNCH * gm * sh_rate
		var ar_g: float = ARM_PER_PUNCH * gm * ar_rate
		if _is_power_arm(m):
			ar_g *= POWER_ARM_MULT
		load[who][ar_part] = float(load[who][ar_part]) + ar_g
		load[who]["core"] = float(load[who]["core"]) + CORE_PER_PUNCH * gm * co_rate
	var in_t: float = _inside_time(beats)
	for who in ["a", "b"]:
		var pace: String = str(pace_d.get(who, "steady"))
		var tank: float = float(tank_d.get(who, 100.0))
		var rates: Dictionary = rates_d.get(who, {})
		var lg_rate: float = float(rates.get("legs", 1.0))
		var lm: float = _leg_mult(sit, who)
		var gm: float = _gain_mult(pace, tank, lg_rate)
		var normal_t: float = maxf(0.0, EXCHANGE_S - in_t)
		var inside_t: float = in_t
		var leg_g: float = LEGS_PER_S * lm * gm * (normal_t + INSIDE_LEGS * inside_t)
		load[who]["legs"] = float(load[who]["legs"]) + leg_g
	for who in ["a", "b"]:
		for p in PARTS:
			load[who][p] = clampf(float(load[who][p]), 0.0, 100.0)


static func rest(load: Dictionary, cond: Dictionary, ribs_hurt: Dictionary, second: Dictionary) -> void:
	for who in ["a", "b"]:
		var c: float = float(cond.get(who, 1.0))
		var rh: bool = bool(ribs_hurt.get(who, false))
		var sec_part: String = str(second.get(who, ""))
		var factor: float = REST_BACK * c * (RIBS_HURT_REST if rh else 1.0)
		for p in PARTS:
			var v: float = float(load[who][p])
			v = v * (1.0 - factor)
			if sec_part != "" and sec_part == p:
				v -= SECOND_WORK
			load[who][p] = clampf(v, 0.0, 100.0)


static func burn(load: Dictionary, who: String, part: String) -> float:
	return float(load[who][part])


static func worst_part(load: Dictionary, who: String) -> String:
	var best: String = PARTS[0]
	var best_v: float = float(load[who][PARTS[0]])
	for i in range(1, PARTS.size()):
		var p: String = PARTS[i]
		var v: float = float(load[who][p])
		if v > best_v:
			best = p
			best_v = v
	return best


static func band(v: float) -> String:
	if v < 25.0:
		return "fresh"
	if v < 50.0:
		return "warm"
	if v < 75.0:
		return "hot"
	return "burning"


static func guard_drop(load: Dictionary, who: String) -> float:
	var mean: float = (float(load[who]["lead_shoulder"]) + float(load[who]["rear_shoulder"])) / 2.0
	if mean <= EFFECT_FROM:
		return 0.0
	var t: float = (mean - EFFECT_FROM) / (100.0 - EFFECT_FROM)
	return clampf(t, 0.0, 1.0) * GUARD_DROP_MAX


static func step_scale(load: Dictionary, who: String) -> float:
	var v: float = float(load[who]["legs"])
	if v <= EFFECT_FROM:
		return 1.0
	var t: float = (v - EFFECT_FROM) / (100.0 - EFFECT_FROM)
	return lerpf(1.0, STEP_MIN, clampf(t, 0.0, 1.0))


static func power_scale(load: Dictionary, who: String) -> float:
	var mean: float = (float(load[who]["lead_arm"]) + float(load[who]["rear_arm"])) / 2.0
	if mean <= EFFECT_FROM:
		return 1.0
	var t: float = (mean - EFFECT_FROM) / (100.0 - EFFECT_FROM)
	return lerpf(1.0, POWER_MIN, clampf(t, 0.0, 1.0))


## 0..1: how far one part's Burn is into its effect (0 up to EFFECT_FROM, 1 at 100). S322: the 3D drops each glove from
## its OWN shoulder (the jab hand works most and sinks first) and takes the snap off a punch from its own arm.
static func part_effect(load: Dictionary, who: String, part: String) -> float:
	return clampf((float(load[who][part]) - EFFECT_FROM) / (100.0 - EFFECT_FROM), 0.0, 1.0)
