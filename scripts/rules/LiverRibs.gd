extends RefCounted
## Liver vs ribs: two sides of the body do different things (LIVERRIBS2).
## Pure static module - no preloads, no class_name. Design map v2 sections 3 and 7.

## Rule 1: stamina drain by side (0.6*1.3 + 0.4*0.55 = 1.0 neutral at 60/40 traffic).
const LIVER_DRAIN := 1.3  ## Rule 1: liver shot costs BODY_COST x 1.3
const RIB_DRAIN := 0.55  ## Rule 1: rib shot costs BODY_COST x 0.55

## Rule 2: liver fold chance at HURT/CRITICAL.
const BASE_FOLD := 0.03  ## Rule 2: base fold probability
const FOLD_MIN := 0.01  ## Rule 2: floor after clamp
const FOLD_MAX := 0.08  ## Rule 2: ceiling before crit mult
const FOLD_CRIT_MULT := 2.0  ## Rule 2: doubled at CRITICAL
const FOLD_CAP := 0.16  ## Rule 2: absolute max after crit mult
const FOLDS_MAX := 2  ## Rule 2: max folds per bout

## Band thresholds (BodyMap words: value <= 35 critical, <= 55 hurt, else ok).
const HURT_LINE := 55.0  ## Rule 2/5: at or below this is hurt
const CRIT_LINE := 35.0  ## Rule 2/6: at or below this is critical

## Rule 5: ribs HURT tonight payoff (guard -5, output x0.85).
const RIB_GUARD_HURT := -5.0  ## Rule 5: hurt ribs drop guard by 5
const RIB_OUTPUT_HURT := 0.85  ## Rule 5: hurt ribs output x0.85

## Rule 6: ribs CRACK in the bout.
const CRACK_CHANCE := 0.04  ## Rule 6: 4% per landed shot at CRITICAL
const CRACK_OUTPUT := 0.6  ## Rule 6: cracked side punches x0.6
const CRACK_GUARD := -10.0  ## Rule 6: cracked side guard -10

## Rule 7: opponent corner retirement at each bell after crack.
const RETIRE_BASE := 0.40  ## Rule 7: 40 in 100 at each bell
const RETIRE_BEHIND := 0.65  ## Rule 7: 65 in 100 if behind on scorecards

## Rule 9: post-bout injury split.
const BELL_CRACK := 0.25  ## Rule 9: 25 in 100 crack at final bell when CRITICAL
const BRUISE_LINE := 50.0  ## Rule 9: bruised ribs if ribs_value < 50

## Rule 8/9: heal days by corner choice.
const HEAL_DAYS := {"pull": 35, "defend": 63, "fight": 84}  ## Rule 8: days by choice
const WORSE_DAYS := 28  ## Rule 8: extra days when fight through goes worse
const WORSE_CHANCE := 0.10  ## Rule 8: 1 in 10 worse on fight through

## Rule 9: injury day ranges.
const BRUISED_DAYS := [10, 21]  ## Rule 9: bruised ribs 10-21 days
const CRACKED_DAYS := [35, 56]  ## Rule 9: cracked rib 35-56 days


## The throwing hand picks the side: left hand -> "liver", right hand -> "ribs".
## Stance only changes which hand is lead, not which side the hand hits.
static func side_of(attacker_stance: String, hand: String) -> String:
	if hand == "left":
		return "liver"
	return "ribs"


## Band from value: ok (>55), hurt (35<value<=55), critical (<=35).
static func band(value: float) -> String:
	if value <= CRIT_LINE:
		return "critical"
	if value <= HURT_LINE:
		return "hurt"
	return "ok"


## The BODY_COST multiplier for a side.
static func drain(side: String) -> float:
	if side == "liver":
		return LIVER_DRAIN
	return RIB_DRAIN


## Liver fold chance at HURT/CRITICAL. 0 when band ok or folds_so_far >= FOLDS_MAX.
## attack_power = (strength + explosiveness) / 2 * (0.5 + mastery / 200).
## p = clamp(BASE_FOLD * exp((attack_power - durability) / 12), FOLD_MIN, FOLD_MAX).
## x FOLD_CRIT_MULT at critical; min FOLD_CAP.
static func liver_fold_chance(strength: float, explosiveness: float, mastery: float,
		durability: float, liver_value: float, folds_so_far: int) -> float:
	if band(liver_value) == "ok":
		return 0.0
	if folds_so_far >= FOLDS_MAX:
		return 0.0
	var attack_power: float = (strength + explosiveness) / 2.0 * (0.5 + mastery / 200.0)
	var p: float = clampf(BASE_FOLD * exp((attack_power - durability) / 12.0), FOLD_MIN, FOLD_MAX)
	if band(liver_value) == "critical":
		p *= FOLD_CRIT_MULT
	p = minf(p, FOLD_CAP)
	return p


## Ribs penalty: guard and output modifiers.
## cracked -> CRACK_*; hurt/critical (not cracked) -> RIB_*_HURT; ok -> {0, 1.0}.
static func ribs_penalty(ribs_value: float, cracked: bool) -> Dictionary:
	if cracked:
		return {"guard": CRACK_GUARD, "output": CRACK_OUTPUT}
	var b: String = band(ribs_value)
	if b == "hurt" or b == "critical":
		return {"guard": RIB_GUARD_HURT, "output": RIB_OUTPUT_HURT}
	return {"guard": 0.0, "output": 1.0}


## Crack chance: CRACK_CHANCE at critical, else 0; 0 when already cracked.
static func crack_chance(ribs_value: float, already: bool) -> float:
	if already:
		return 0.0
	if band(ribs_value) == "critical":
		return CRACK_CHANCE
	return 0.0


## Corner retires a cracked boxer: 0 / RETIRE_BASE / RETIRE_BEHIND.
static func corner_retires(cracked: bool, behind: bool) -> float:
	if not cracked:
		return 0.0
	if behind:
		return RETIRE_BEHIND
	return RETIRE_BASE


## Post-bout injury split. The liver NEVER produces an injury.
## cracked in the bout -> cracked; critical and roll < BELL_CRACK -> cracked;
## ribs_value < BRUISE_LINE -> bruised; else none.
static func injury_split(ribs_value: float, cracked: bool, roll: float) -> Dictionary:
	if cracked:
		return {"kind": "cracked"}
	if band(ribs_value) == "critical" and roll < BELL_CRACK:
		return {"kind": "cracked"}
	if ribs_value < BRUISE_LINE:
		return {"kind": "bruised"}
	return {"kind": "none"}


## Heal days by corner choice. HEAL_DAYS[choice] + WORSE_DAYS when choice == "fight" and roll < WORSE_CHANCE.
static func heal_days(choice: String, roll: float) -> int:
	var base: int = int(HEAL_DAYS[choice])
	if choice == "fight" and roll < WORSE_CHANCE:
		base += WORSE_DAYS
	return base


## S467 wiring: a boxer's body shots taken, as the fight keeps them: {"free": n, "liver": n, "ribs": n} - "free" are the
## un-aimed shots (LIVER_SHARE of them land on the liver). Aimed shots (PaceAim "right_ribs" = liver, "left_ribs" = ribs)
## count on their side.
const LIVER_SHARE := 0.6


static func add_shots(sides: Dictionary, n: int, aim: String) -> void:
	var k := "liver" if aim == "right_ribs" else ("ribs" if aim == "left_ribs" else "free")
	sides[k] = int(sides.get(k, 0)) + n


## Liver and ribs counts (the free shots split LIVER_SHARE / the rest, rounded) for hurt reads and screens.
static func counts(sides: Dictionary) -> Dictionary:
	var free := int(sides.get("free", 0))
	var liver := roundi(float(free) * LIVER_SHARE)
	return {"liver": int(sides.get("liver", 0)) + liver, "ribs": int(sides.get("ribs", 0)) + free - liver}


## Body-cost units the shots drain: liver x LIVER_DRAIN, ribs x RIB_DRAIN, a free shot their mean (1.0 at 60/40, unrounded).
static func drain_units(sides: Dictionary) -> float:
	var free_mean := LIVER_SHARE * LIVER_DRAIN + (1.0 - LIVER_SHARE) * RIB_DRAIN
	return float(sides.get("free", 0)) * free_mean + float(sides.get("liver", 0)) * LIVER_DRAIN + float(sides.get("ribs", 0)) * RIB_DRAIN
