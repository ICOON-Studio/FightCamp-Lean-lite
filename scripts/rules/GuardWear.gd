extends RefCounted
## GUARDWEAR1 - guard damage v4, the pure rules. Source: ops/research/DESIGN_GUARDDMG1_V4.md
## sections 0, 1.1-1.5 (board Q-S294-275, critics Dola 8/8/7, Goose 8/7/7).
## Pure static module: plain values in, plain values out. Preloads nothing.
## Guard is a number 0..max (max 100 for a middleweight). Game text never says he, she, her or him.
## Transmission multiplier note: the brief line "0.5 + (100 - g) / 100" does not give its own
## "x1.0 at full, x1.5 at half, x2.0 at empty" (Goose critic flagged this in the design doc).
## The table and the test numbers (full jab 0.25, half power 0.6375, heavy-class jab 0.325)
## require 1.0 + (100 - g) / 100, so that is what is built here. The cap 0.80 wins over the
## design table's 83% line.

## Transmission bases - share of a blocked punch that gets through at a full guard.
const TRANS_JAB := 0.25  ## ESTIMATE
const TRANS_POWER := 0.425  ## ESTIMATE
const TRANS_HEAVY := 0.55  ## ESTIMATE
const TRANS_CAP := 0.80  ## ESTIMATE
const TRANS_FLOOR := 0.0  ## ESTIMATE
const GUARD_SCALE := 100.0  ## ESTIMATE
const TRANS_MULT_BASE := 1.0  ## ESTIMATE
const WCLASS_LIGHT := 0.9  ## ESTIMATE
const WCLASS_MIDDLE := 1.0  ## ESTIMATE
const WCLASS_HEAVY := 1.3  ## ESTIMATE
const COMBO_N := 3  ## ESTIMATE
const COMBO_MULT := 1.5  ## ESTIMATE
## Wear bases - guard points one block costs.
const WEAR_JAB := 1.0  ## ESTIMATE
const WEAR_POWER := 3.0  ## ESTIMATE
const WEAR_HEAVY := 5.0  ## ESTIMATE
const WEAR_ROPES := 0.12  ## ESTIMATE
const WEAR_MOVING := -0.05  ## ESTIMATE
const WEAR_CONDITION := 0.10  ## ESTIMATE
const WEAR_CONDITION_AT := 70.0  ## ESTIMATE
const WEAR_MISSED := 0.18  ## ESTIMATE
const WEAR_POSTURE_HIGH := 0.08  ## ESTIMATE
const WEAR_AMATEUR := 0.15  ## ESTIMATE
const WEAR_FACTOR_MIN := 0.5  ## ESTIMATE
## Shoulder endurance: stamina x 0.7 + strength x 0.3, then a piecewise wear cut.
const SHOULDER_STAMINA_W := 0.7  ## ESTIMATE
const SHOULDER_STRENGTH_W := 0.3  ## ESTIMATE
const SHOULDER_P1 := 50.0  ## ESTIMATE
const SHOULDER_P2 := 65.0  ## ESTIMATE
const SHOULDER_P3 := 80.0  ## ESTIMATE
const SHOULDER_PCT2 := -0.12  ## ESTIMATE
const SHOULDER_PCT3 := -0.20  ## ESTIMATE
const SHOULDER_PCT_FLOOR := -0.25  ## ESTIMATE
## Posture damage multipliers by target.
const POSTURE_HIGH_HEAD := 0.80  ## ESTIMATE
const POSTURE_HIGH_BODY := 1.15  ## ESTIMATE
const POSTURE_LOW_HEAD := 1.15  ## ESTIMATE
const POSTURE_LOW_BODY := 0.80  ## ESTIMATE
const POSTURE_NEUTRAL := 1.0  ## ESTIMATE
## In-round recovery.
const RECOVER_QUIET := 3.0  ## ESTIMATE
const RECOVER_QUIET_AMATEUR := 4.0  ## ESTIMATE
const RECOVER_LIGHT := 1.0  ## ESTIMATE
const RECOVER_NONE := 0.0  ## ESTIMATE
## Clinch: once per round, only under half guard.
const CLINCH_GUARD := 10.0  ## ESTIMATE
const CLINCH_GUARD_SKILLED := 13.0  ## ESTIMATE
const CLINCH_STAMINA := -10.0  ## ESTIMATE
const CLINCH_THRESHOLD := 0.5  ## ESTIMATE
## Corner recovery between rounds.
const CORNER_BASE := 15.0  ## ESTIMATE
const CORNER_HANDS_UP := 5.0  ## ESTIMATE
const CORNER_CUTMAN := 5.0  ## ESTIMATE
const CORNER_BACK_OFF := 20.0  ## ESTIMATE
## Max guard by weight class; an amateur max is 70 whatever the class.
const MAX_GUARD_LIGHT := 80.0  ## ESTIMATE
const MAX_GUARD_MIDDLE := 100.0  ## ESTIMATE
const MAX_GUARD_HEAVY := 120.0  ## ESTIMATE
const MAX_GUARD_AMATEUR := 70.0  ## ESTIMATE
## Traits.
const TRAIT_SLOW_EARLY := -0.12  ## ESTIMATE
const TRAIT_SLOW_LATE := 0.12  ## ESTIMATE
const TRAIT_SLOW_EARLY_ROUNDS := 2  ## ESTIMATE
const TRAIT_FADES := -0.25  ## ESTIMATE
const TRAIT_FADES_AFTER := 4  ## ESTIMATE
const TRAIT_CHASES := -0.10  ## ESTIMATE
const MORALE_LOW_AT := 40.0  ## ESTIMATE
const MORALE_LOW_PCT := -0.20  ## ESTIMATE
## Parry: only at defence 50 or more; shifted by (defence - 50) / 500.
const PARRY_JAB := 0.70  ## ESTIMATE
const PARRY_CROSS := 0.55  ## ESTIMATE
const PARRY_HOOK := 0.40  ## ESTIMATE
const PARRY_UPPERCUT := 0.35  ## ESTIMATE
const PARRY_DEFENCE_MIN := 50.0  ## ESTIMATE
const PARRY_SHIFT_DIV := 500.0  ## ESTIMATE
const PARRY_MIN := 0.05  ## ESTIMATE
const PARRY_MAX := 0.95  ## ESTIMATE
const PARRY_WEAR := 0.3  ## ESTIMATE
const PARRY_TRANSMISSION := 0.08  ## ESTIMATE
## Guard bar colours by share of max.
const COLOUR_GREEN_AT := 0.75  ## ESTIMATE
const COLOUR_YELLOW_AT := 0.50  ## ESTIMATE
const COLOUR_ORANGE_AT := 0.25  ## ESTIMATE


## Share of a blocked punch that gets through. kind is "jab", "power" or "heavy".
## Unknown kind counts as a jab. Unknown class counts as middle. Capped at 0.80, floored at 0.
static func transmission(kind: String, guard: float, max_g: float, wclass: String, combo_n: int) -> float:
	var base: float = TRANS_JAB
	if kind == "power":
		base = TRANS_POWER
	elif kind == "heavy":
		base = TRANS_HEAVY
	var g: float = 0.0
	if max_g > 0.0:
		g = clampf(guard / max_g * GUARD_SCALE, 0.0, GUARD_SCALE)
	var mult: float = TRANS_MULT_BASE + (GUARD_SCALE - g) / GUARD_SCALE
	var wmult: float = WCLASS_MIDDLE
	if wclass == "light":
		wmult = WCLASS_LIGHT
	elif wclass == "heavy":
		wmult = WCLASS_HEAVY
	var cmult: float = COMBO_MULT if combo_n >= COMBO_N else 1.0
	var v: float = base * mult * wmult * cmult
	return clampf(v, TRANS_FLOOR, TRANS_CAP)


## Guard points one block costs. kind is "jab", "power" or "heavy" (unknown counts as jab).
## combo_n 3 or more multiplies by 1.5. Percent modifiers in ctx add into one factor
## (1 + sum, never compounding), floored at 0.5. All ctx keys optional, absent means off:
## "ropes" bool +12%, "moving" bool -5%, "condition" 0..100 under 70 +10%,
## "missed_weight" bool +18% instead of the condition line, "posture" "high" +8%,
## "amateur" bool +15%, "shoulder" score via shoulder_wear_pct, "trait" via trait_wear_pct
## (round from "round_n" or "round" in ctx, or from a trait Dictionary).
static func wear(kind: String, combo_n: int, ctx: Dictionary) -> float:
	var base: float = WEAR_JAB
	if kind == "power":
		base = WEAR_POWER
	elif kind == "heavy":
		base = WEAR_HEAVY
	var combo_mult: float = COMBO_MULT if combo_n >= COMBO_N else 1.0
	var sum: float = 0.0
	var ropes: bool = bool(ctx.get("ropes", false))
	if ropes:
		sum += WEAR_ROPES
	var moving: bool = bool(ctx.get("moving", false))
	if moving:
		sum += WEAR_MOVING
	var missed: bool = bool(ctx.get("missed_weight", false))
	if missed:
		sum += WEAR_MISSED
	elif ctx.has("condition"):
		var cond: float = float(ctx.get("condition", 100.0))
		if cond < WEAR_CONDITION_AT:
			sum += WEAR_CONDITION
	var posture: String = str(ctx.get("posture", "neutral"))
	if posture == "high":
		sum += WEAR_POSTURE_HIGH
	var amateur: bool = bool(ctx.get("amateur", false))
	if amateur:
		sum += WEAR_AMATEUR
	if ctx.has("shoulder"):
		var sh: float = float(ctx.get("shoulder", 0.0))
		sum += shoulder_wear_pct(sh)
	if ctx.has("trait"):
		sum += _trait_wear_from_ctx(ctx)
	var factor: float = maxf(WEAR_FACTOR_MIN, 1.0 + sum)
	return base * combo_mult * factor


static func _trait_wear_from_ctx(ctx: Dictionary) -> float:
	var t: Variant = ctx.get("trait", "")
	var trait_name: String = ""
	var round_n: int = 1
	if t is Dictionary:
		var td: Dictionary = t as Dictionary
		trait_name = str(td.get("trait", td.get("name", "")))
		round_n = int(td.get("round_n", td.get("round", 1)))
	else:
		trait_name = str(t)
		if ctx.has("round_n"):
			round_n = int(ctx.get("round_n", 1))
		elif ctx.has("round"):
			round_n = int(ctx.get("round", 1))
	return trait_wear_pct(trait_name, round_n)


## Shoulder endurance from stamina and strength.
static func shoulder(stamina: float, strength: float) -> float:
	return stamina * SHOULDER_STAMINA_W + strength * SHOULDER_STRENGTH_W


## Wear cut from shoulder endurance: 50 or less 0, 65 -12%, 80 -20%, straight lines
## between, above 80 same slope as 65-80 to a floor of -25%.
static func shoulder_wear_pct(sh: float) -> float:
	if sh <= SHOULDER_P1:
		return 0.0
	if sh <= SHOULDER_P2:
		var t1: float = (sh - SHOULDER_P1) / (SHOULDER_P2 - SHOULDER_P1)
		return t1 * SHOULDER_PCT2
	if sh <= SHOULDER_P3:
		var t2: float = (sh - SHOULDER_P2) / (SHOULDER_P3 - SHOULDER_P2)
		return SHOULDER_PCT2 + t2 * (SHOULDER_PCT3 - SHOULDER_PCT2)
	var slope: float = (SHOULDER_PCT3 - SHOULDER_PCT2) / (SHOULDER_P3 - SHOULDER_P2)
	var v: float = SHOULDER_PCT3 + (sh - SHOULDER_P3) * slope
	return maxf(SHOULDER_PCT_FLOOR, v)


## Damage multiplier by posture and target ("head" or "body"). Unknown posture is neutral.
static func posture_damage(posture: String, target: String) -> float:
	if posture == "high":
		if target == "head":
			return POSTURE_HIGH_HEAD
		if target == "body":
			return POSTURE_HIGH_BODY
		return POSTURE_NEUTRAL
	if posture == "low":
		if target == "head":
			return POSTURE_LOW_HEAD
		if target == "body":
			return POSTURE_LOW_BODY
		return POSTURE_NEUTRAL
	return POSTURE_NEUTRAL


## Guard back in a quiet spell: 0 thrown +3 (amateur +4), 1-2 thrown +1, 3 or more 0.
static func in_round(punches_thrown_at: int, amateur: bool) -> float:
	if punches_thrown_at <= 0:
		return RECOVER_QUIET_AMATEUR if amateur else RECOVER_QUIET
	if punches_thrown_at <= 2:
		return RECOVER_LIGHT
	return RECOVER_NONE


## Clinch: only under half guard and once per round. Success gives guard back and costs stamina.
static func clinch(skilled: bool, guard: float, max_g: float, used_this_round: bool) -> Dictionary:
	if used_this_round:
		return {"ok": false, "why": "Already used this round."}
	if max_g <= 0.0:
		return {"ok": false, "why": "No guard to rest."}
	if guard >= max_g * CLINCH_THRESHOLD:
		return {"ok": false, "why": "Guard is still above half."}
	var gain: float = CLINCH_GUARD_SKILLED if skilled else CLINCH_GUARD
	return {"ok": true, "guard": gain, "stamina": CLINCH_STAMINA, "free_exchange": true}


## Corner recovery: base +15, "hands_up" +5, good cutman +5 only with no cut open,
## "back_off" +20 in the total (the caller spreads it over the next round).
static func corner(calls: Array, cutman_good: bool, cut_open: bool) -> float:
	var total: float = CORNER_BASE
	var hands: bool = false
	var back: bool = false
	for c in calls:
		var s: String = str(c)
		if s == "hands_up":
			hands = true
		if s == "back_off":
			back = true
	if hands:
		total += CORNER_HANDS_UP
	if back:
		total += CORNER_BACK_OFF
	if cutman_good and not cut_open:
		total += CORNER_CUTMAN
	return total


## Keep guard in 0..max.
static func clamp_guard(g: float, max_g: float) -> float:
	if max_g <= 0.0:
		return 0.0
	return clampf(g, 0.0, max_g)


## Max guard by weight class; an amateur max is 70 whatever the class. Unknown class is middle.
static func max_guard(wclass: String, amateur: bool) -> float:
	if amateur:
		return MAX_GUARD_AMATEUR
	if wclass == "light":
		return MAX_GUARD_LIGHT
	if wclass == "heavy":
		return MAX_GUARD_HEAVY
	return MAX_GUARD_MIDDLE


## Wear cut from a trait: "slow_starter" -12% in rounds 1-2, +12% from round 3; else 0.
static func trait_wear_pct(trait: String, round_n: int) -> float:
	if trait == "slow_starter":
		if round_n <= TRAIT_SLOW_EARLY_ROUNDS:
			return TRAIT_SLOW_EARLY
		return TRAIT_SLOW_LATE
	return 0.0


## Recovery cut from a trait and morale: "fades_late" -25% after round 4,
## "chases_stoppage" -10%, morale under 40 -20% (adds to the trait cut).
static func trait_recovery_pct(trait: String, round_n: int, morale: float) -> float:
	var pct: float = 0.0
	if trait == "fades_late" and round_n > TRAIT_FADES_AFTER:
		pct += TRAIT_FADES
	if trait == "chases_stoppage":
		pct += TRAIT_CHASES
	if morale < MORALE_LOW_AT:
		pct += MORALE_LOW_PCT
	return pct


## Parry chance by exact punch ("jab", "cross", "hook", "uppercut"). Only at defence 50 or
## more, else 0. Shifted by (defence - 50) / 500, clamped 0.05..0.95. Unknown kind is 0.
static func parry_chance(kind_exact: String, defence: float) -> float:
	if defence < PARRY_DEFENCE_MIN:
		return 0.0
	var base: float = 0.0
	if kind_exact == "jab":
		base = PARRY_JAB
	elif kind_exact == "cross":
		base = PARRY_CROSS
	elif kind_exact == "hook":
		base = PARRY_HOOK
	elif kind_exact == "uppercut":
		base = PARRY_UPPERCUT
	else:
		return 0.0
	var shift: float = (defence - PARRY_DEFENCE_MIN) / PARRY_SHIFT_DIV
	return clampf(base + shift, PARRY_MIN, PARRY_MAX)


## Judges' effective strikes from blocked punches: blocked / 3. Never damage.
static func blocked_strikes(blocked: int) -> int:
	if blocked <= 0:
		return 0
	return blocked / 3


## Guard bar colour by share of max: green 75% or more, yellow 50%, orange 25%, else red.
static func colour(guard: float, max_g: float) -> String:
	if max_g <= 0.0:
		return "red"
	var ratio: float = guard / max_g
	if ratio >= COLOUR_GREEN_AT:
		return "green"
	if ratio >= COLOUR_YELLOW_AT:
		return "yellow"
	if ratio >= COLOUR_ORANGE_AT:
		return "orange"
	return "red"


## Plain words for a guard colour.
static func word(col: String) -> String:
	if col == "green":
		return "Holding well"
	if col == "yellow":
		return "Arms tiring"
	if col == "orange":
		return "Leaking heavily"
	return "Arms dropping"
