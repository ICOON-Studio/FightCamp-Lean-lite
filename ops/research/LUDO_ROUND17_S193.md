# LUDO ROUND 17 (S193, 2026-10-10) - six approved design picks made build-ready: SHOUT1, REFEREE1, WEAR1, CUTSCAR1, CLUBROUTES1, CARDAUTO1

Operator S193: "ludo can contribute huge amount of code and design to the project 1 question consumes 1 token make the questions huge to
cover extensive areas of the roadmap". These six were approved S188 ("yes all picks", board Q-S188-2/3) and had no code yet (the other
S188 picks SPARTELL1/OFFERTRAP1/CHINCUT1/CORNEREYE1/CUTMAN1 are SUPERSEDED by the S190 Ludo builds - roadmap queue S193).
Question (sent, verbatim in substance): one TEXT ONLY request, 7 sections; house rules per feature: (a) JSON data table, (b) a PURE static
module (no nodes, no RNG - rolls passed in), (c) test cases with exact numbers, (d) the hook into an existing event/module, (e) the 3-second
UI read (icon + tooltip), (f) a real-boxing balance anchor, (g) how it could go wrong for the player + the guard; every feature behind a
switch defaulting OFF; built ON Composure, LudoCorner + CornerBreak, CutsDoctor, Tells + SparRead, MoveCards, FightWeek, WeighInCut,
PromoterTrap, Membership, GymSparring, FightRealtime.

## Round 17 - Ludo's answer, part 1 (verbatim, saved byte-exact via Tools/arena_rx.py; sections 1-4)

SECTION 1 — SHOUT1: Mid-Round Apron Shouts
(a) Data Table (JSON)
{
  "feature_flag": "FEATURE_MID_ROUND_SHOUTS",
  "default_state": false,
  "rules": {
    "max_shouts_per_round": 3,
    "cooldown_seconds": 22.0,
    "shout_stamina_cost_flat": 1.5,
    "failure_distraction_seconds": 2.5
  },
  "shouts": {
    "OFF_THE_ROPES": {
      "id": "OFF_THE_ROPES",
      "display_name": "Off the Ropes!",
      "target_tactical_need": "TRAPPED_ON_ROPES",
      "trust_threshold": 25.0,
      "iq_weight": 0.45,
      "trust_weight": 0.55,
      "success_effect": {
        "lateral_escape_boost": 0.40,
        "rope_trapped_clear_instant": true,
        "composure_delta": 4.0
      },
      "failure_cost": {
        "guard_drop_duration": 1.2,
        "composure_delta": -8.0,
        "bonus_punches_absorbed_risk": 0.25
      }
    },
    "GO_TO_THE_BODY": {
      "id": "GO_TO_THE_BODY",
      "display_name": "Go to the Body!",
      "target_tactical_need": "HIGH_GUARD_OPPONENT",
      "trust_threshold": 35.0,
      "iq_weight": 0.60,
      "trust_weight": 0.40,
      "success_effect": {
        "body_shot_bias_multiplier": 2.20,
        "opponent_gas_drain_bonus": 3.50,
        "composure_delta": 2.0
      },
      "failure_cost": {
        "counter_received_crit_chance": 0.20,
        "composure_delta": -5.0
      }
    },
    "TIE_HIM_UP": {
      "id": "TIE_HIM_UP",
      "display_name": "Tie Him Up!",
      "target_tactical_need": "ROCKED_OR_LOW_STAMINA",
      "trust_threshold": 40.0,
      "iq_weight": 0.30,
      "trust_weight": 0.70,
      "success_effect": {
        "clinch_initiation_bonus": 0.50,
        "survival_recovery_stamina": 4.0,
        "composure_delta": 6.0
      },
      "failure_cost": {
        "clinch_denied_shove_stumble": true,
        "vulnerable_uppercut_window": 1.5,
        "composure_delta": -10.0
      }
    },
    "BOX_AND_MOVE": {
      "id": "BOX_AND_MOVE",
      "display_name": "Box and Move!",
      "target_tactical_need": "SWARMED_INSIDE",
      "trust_threshold": 30.0,
      "iq_weight": 0.50,
      "trust_weight": 0.50,
      "success_effect": {
        "distance_keep_multiplier": 1.75,
        "jab_frequency_multiplier": 1.35,
        "composure_delta": 3.0
      },
      "failure_cost": {
        "trip_risk_flat": 0.15,
        "stamina_bleed_penalty": 2.0,
        "composure_delta": -6.0
      }
    },
    "STEP_ON_THE_GAS": {
      "id": "STEP_ON_THE_GAS",
      "display_name": "Step on the Gas!",
      "target_tactical_need": "OPPONENT_HURT",
      "trust_threshold": 50.0,
      "iq_weight": 0.40,
      "trust_weight": 0.60,
      "success_effect": {
        "punch_output_multiplier": 1.60,
        "finishing_crit_rate": 0.25,
        "composure_delta": 5.0
      },
      "failure_cost": {
        "cardio_exhaustion_dump": 6.0,
        "composure_delta": -12.0
      }
    }
  }
}

(b) Typed Pure GDScript Implementation
# Shout1.gd
class_name Shout1
extends RefCounted

const COOLDOWN_SEC: float = 22.0
const MAX_SHOUTS: int = 3

static func calculate_adherence_chance(
	shout_def: Dictionary,
	ring_iq: float,        # 0.0 to 100.0
	coach_trust: float,    # 0.0 to 100.0
	composure_band: String # "Focused", "Rattled", "Shaken", "Broken"
) -> float:
	var band_mult: float = 1.00
	match composure_band:
		"Focused":
			band_mult = 1.15
		"Rattled":
			band_mult = 0.85
		"Shaken":
			band_mult = 0.50
		"Broken":
			band_mult = 0.15
		_:
			band_mult = 0.50

	var iq_w: float = shout_def.get("iq_weight", 0.5)
	var trust_w: float = shout_def.get("trust_weight", 0.5)
	var raw_score: float = (ring_iq * iq_w) + (coach_trust * trust_w)
	var final_prob: float = (raw_score / 100.0) * band_mult
	return clampf(final_prob, 0.05, 0.95)

static func attempt_shout(
	shout_id: String,
	shouts_used_this_round: int,
	time_since_last_shout: float,
	fighter_stamina: float,
	ring_iq: float,
	coach_trust: float,
	composure_band: String,
	roll_0_to_1: float,
	table_data: Dictionary
) -> Dictionary:
	var result: Dictionary = {
		"executed": false,
		"success": false,
		"reason": "",
		"stamina_cost": 0.0,
		"cooldown_reset": false,
		"applied_effects": {},
		"applied_penalties": {}
	}

	if shouts_used_this_round >= MAX_SHOUTS:
		result["reason"] = "MAX_CAP_REACHED"
		return result

	if time_since_last_shout < COOLDOWN_SEC:
		result["reason"] = "COOLDOWN_ACTIVE"
		return result

	var shouts: Dictionary = table_data.get("shouts", {})
	if not shouts.has(shout_id):
		result["reason"] = "UNKNOWN_SHOUT_ID"
		return result

	var shout_def: Dictionary = shouts[shout_id]
	var trust_req: float = shout_def.get("trust_threshold", 0.0)
	if coach_trust < trust_req:
		result["reason"] = "TRUST_TOO_LOW"
		return result

	result["executed"] = true
	result["cooldown_reset"] = true
	result["stamina_cost"] = table_data.get("rules", {}).get("shout_stamina_cost_flat", 1.5)

	var p_success: float = calculate_adherence_chance(shout_def, ring_iq, coach_trust, composure_band)

	if roll_0_to_1 <= p_success:
		result["success"] = true
		result["applied_effects"] = shout_def.get("success_effect", {}).duplicate(true)
	else:
		result["success"] = false
		result["applied_penalties"] = shout_def.get("failure_cost", {}).duplicate(true)
		result["applied_penalties"]["distraction_sec"] = table_data.get("rules", {}).get("failure_distraction_seconds", 2.5)

	return result

(c) Unit Tests
static func run_tests() -> bool:
	var test_table: Dictionary = {
		"rules": { "max_shouts_per_round": 3, "cooldown_seconds": 22.0, "shout_stamina_cost_flat": 1.5, "failure_distraction_seconds": 2.5 },
		"shouts": {
			"OFF_THE_ROPES": {
				"trust_threshold": 25.0, "iq_weight": 0.45, "trust_weight": 0.55,
				"success_effect": { "escape": 0.4 }, "failure_cost": { "drop": 1.2 }
			}
		}
	}
	# Test 1: Blocked by cooldown
	var r1 = attempt_shout("OFF_THE_ROPES", 0, 10.0, 80.0, 70.0, 60.0, "Focused", 0.1, test_table)
	assert(not r1.executed and r1.reason == "COOLDOWN_ACTIVE", "Test 1 Failed: Cooldown check bypassed")

	# Test 2: Blocked by max shouts
	var r2 = attempt_shout("OFF_THE_ROPES", 3, 30.0, 80.0, 70.0, 60.0, "Focused", 0.1, test_table)
	assert(not r2.executed and r2.reason == "MAX_CAP_REACHED", "Test 2 Failed: Max cap bypassed")

	# Test 3: Math validation on success roll
	# IQ 50, Trust 50 -> Raw score = (50*0.45)+(50*0.55) = 50.0. Rattled = 0.85 mult -> Final P = 0.425
	var r3 = attempt_shout("OFF_THE_ROPES", 1, 25.0, 80.0, 50.0, 50.0, "Rattled", 0.40, test_table)
	assert(r3.executed and r3.success == true, "Test 3 Failed: Roll 0.40 should pass 0.425 target")

	# Test 4: Roll failure applies penalty
	var r4 = attempt_shout("OFF_THE_ROPES", 1, 25.0, 80.0, 50.0, 50.0, "Rattled", 0.45, test_table)
	assert(r4.executed and r4.success == false and r4.applied_penalties.has("distraction_sec"), "Test 4 Failed: Penalties missing")
	return true

(d) System Hook

Called inside FightRealtime.gd during round processing when a player clicks a shout action or when tactical state alerts trip. Modifies active fighter composure via Composure.gd and adjusts target ring positioning.

(e) UI Read (3 Seconds)

A 3-slot vertical apron bar next to the clock. When clicked, a stylized speech bubble pulses:

Green megaphone icon + "OFF ROPES!": Fighter instantly pivots 45° off ropes with bright visual arrow.
Red cracked megaphone icon + "CONFUSED!": Fighter hesitates, shoulders drop, red exclamation point over head for 1.2 seconds.
(f) Boxing Anchor

Trained boxers under duress filter shouting through crowd noise. Fighters trust long-time cornermen implicitly (e.g., Derrick James shouting "Angle out!"), but shouting at a panicking, inexperienced amateur makes them freeze up and get caught cleanly.

(g) Failure Mode & Guard

Risk: Player spams shouts constantly when their fighter is hurt, accidentally triggering failure cascades that cause quick KOs.

Guard: Hard 22-second cooldown and a maximum of 3 shouts per round prevent spam. Broken fighters drop adherence chance to 15%, causing the button to display a warning badge: "TOO RATTLED TO HEAR".

SECTION 2 — REFEREE1: Referee Personalities
(a) Data Table (JSON)
{
  "feature_flag": "FEATURE_REFEREE_PERSONALITIES",
  "default_state": false,
  "personalities": {
    "HAIR_TRIGGER": {
      "id": "HAIR_TRIGGER",
      "name": "Fast Stopper (e.g., Modern Championship Ref)",
      "stoppage_cut_threshold_pip": 3,
      "stoppage_doctor_odds_multiplier": 1.45,
      "kd_count_speed_multiplier": 1.05,
      "standing_eight_count_enabled": true,
      "clinch_break_time_seconds": 1.80,
      "point_deduction_leniency": 0.20,
      "home_bias_ratio": 0.00
    },
    "LET_EM_FIGHT": {
      "id": "LET_EM_FIGHT",
      "name": "Old-School Veteran (e.g., Las Vegas Old Guard)",
      "stoppage_cut_threshold_pip": 5,
      "stoppage_doctor_odds_multiplier": 0.60,
      "kd_count_speed_multiplier": 0.92,
      "standing_eight_count_enabled": false,
      "clinch_break_time_seconds": 4.50,
      "point_deduction_leniency": 0.80,
      "home_bias_ratio": 0.00
    },
    "HOMETOWN_SPECIAL": {
      "id": "HOMETOWN_SPECIAL",
      "name": "Regional Protector",
      "stoppage_cut_threshold_pip": 3,
      "stoppage_doctor_odds_multiplier": 1.00,
      "kd_count_speed_multiplier": 1.00,
      "standing_eight_count_enabled": true,
      "clinch_break_time_seconds": 2.50,
      "point_deduction_leniency": 0.50,
      "home_bias_ratio": 0.35
    },
    "BY_THE_BOOK": {
      "id": "BY_THE_BOOK",
      "name": "Strict Enforcer",
      "stoppage_cut_threshold_pip": 4,
      "stoppage_doctor_odds_multiplier": 1.00,
      "kd_count_speed_multiplier": 1.00,
      "standing_eight_count_enabled": false,
      "clinch_break_time_seconds": 1.50,
      "point_deduction_leniency": 0.10,
      "home_bias_ratio": 0.00
    }
  }
}

(b) Typed Pure GDScript Implementation
# Referee1.gd
class_name Referee1
extends RefCounted

static func evaluate_stoppage_risk(
	referee_profile: Dictionary,
	cut_pips: int,
	base_doctor_odds: float, # From CutsDoctor.gd (0.0 to 1.0)
	is_away_fighter: bool
) -> float:
	var threshold_pip: int = referee_profile.get("stoppage_cut_threshold_pip", 4)
	if cut_pips < threshold_pip:
		return 0.0

	var mult: float = referee_profile.get("stoppage_doctor_odds_multiplier", 1.0)
	var bias: float = referee_profile.get("home_bias_ratio", 0.0)

	var modified_odds: float = base_doctor_odds * mult
	if is_away_fighter:
		modified_odds += (modified_odds * bias)
	else:
		modified_odds -= (modified_odds * bias)

	return clampf(modified_odds, 0.0, 1.0)

static func evaluate_clinch_break(
	referee_profile: Dictionary,
	current_clinch_duration_sec: float
) -> bool:
	var limit: float = referee_profile.get("clinch_break_time_seconds", 2.5)
	return current_clinch_duration_sec >= limit

static func evaluate_point_deduction(
	referee_profile: Dictionary,
	foul_count: int,
	foul_severity_roll: float # 0.0 (accidental) to 1.0 (blatant)
) -> bool:
	var leniency: float = referee_profile.get("point_deduction_leniency", 0.5)
	# High leniency requires multiple fouls and higher severity before deducting points
	var threshold: float = leniency + maxf(0.0, (3.0 - float(foul_count)) * 0.25)
	return foul_severity_roll > threshold

(c) Unit Tests
static func run_tests() -> bool:
	var hair_trigger = { "stoppage_cut_threshold_pip": 3, "stoppage_doctor_odds_multiplier": 1.45, "home_bias_ratio": 0.0 }
	var old_school = { "stoppage_cut_threshold_pip": 5, "stoppage_doctor_odds_multiplier": 0.60, "home_bias_ratio": 0.0 }
	var hometown = { "stoppage_cut_threshold_pip": 3, "stoppage_doctor_odds_multiplier": 1.00, "home_bias_ratio": 0.35 }

	# Test 1: Old school ignores 4 pips completely
	var r1 = evaluate_stoppage_risk(old_school, 4, 0.70, false)
	assert(r1 == 0.0, "Test 1 Failed: Old school stopped on pip below threshold")

	# Test 2: Hair trigger scales up 3 pips
	var r2 = evaluate_stoppage_risk(hair_trigger, 3, 0.35, false)
	assert(is_equal_approx(r2, 0.35 * 1.45), "Test 2 Failed: Hair trigger multiplier incorrect")

	# Test 3: Hometown bias increases away fighter risk
	var r3 = evaluate_stoppage_risk(hometown, 3, 0.50, true)
	assert(is_equal_approx(r3, 0.50 + (0.50 * 0.35)), "Test 3 Failed: Hometown away bias failed")
	return true

(d) System Hook

Hooked into CutsDoctor.gd during round break medical evaluations and FightRealtime.gd inside the 20 Hz clinch and foul resolution routines.

(e) UI Read (3 Seconds)

Displayed on the pre-fight matchup screen via a referee card badge:

Whistle Icon + "FAST STOPPER": Tooltip reads "Breaks clinches in 1.8s. Calls doctor at 3-pip cuts."
Glove Icon + "LET 'EM FIGHT": Tooltip reads "Slow breaks (4.5s). Doctor ignores cuts until 5 pips."
(f) Boxing Anchor

Steve Smoger let fighters work inside through heavy punishment, whereas modern championship referees step in immediately when a fighter drops their hands or bleeds profusely.

(g) Failure Mode & Guard

Risk: Player brings an inside brawler into a bout against a fast-breaking ref, making inside infighting impossible without prior warning.

Guard: The referee’s personality and exact rules are clearly shown on the fight contract screen 2 weeks prior to fight night.

SECTION 3 — WEAR1: Career Wear Meter
(a) Data Table (JSON)
{
  "feature_flag": "FEATURE_CAREER_WEAR_METER",
  "default_state": false,
  "thresholds": {
    "pristine_max": 20.0,
    "weathered_max": 50.0,
    "battle_worn_max": 79.0,
    "spent_min": 80.0
  },
  "wear_penalties": {
    "battle_worn": {
      "chin_cap": 85.0,
      "stamina_recovery_multiplier": 0.88,
      "cut_resistance_multiplier": 0.85
    },
    "spent": {
      "chin_cap": 60.0,
      "stamina_recovery_multiplier": 0.65,
      "cut_resistance_multiplier": 0.60,
      "forced_retirement_warning": true
    }
  },
  "accumulation_sources": {
    "clean_head_shot_heavy": 0.08,
    "knockdown_suffered": 2.50,
    "rocked_state_entered": 0.75,
    "hard_sparring_round": 0.25,
    "extreme_drain_weight_cut": 4.00,
    "deep_cut_survived_to_decision": 3.00
  }
}

(b) Typed Pure GDScript Implementation
# Wear1.gd
class_name Wear1
extends RefCounted

static func accumulate_wear(
	current_wear: float,
	event_id: String,
	count: int,
	table_data: Dictionary
) -> float:
	var sources: Dictionary = table_data.get("accumulation_sources", {})
	var rate: float = sources.get(event_id, 0.0)
	var added: float = rate * float(count)
	return clampf(current_wear + added, 0.0, 100.0)

static func calculate_fighter_degradations(
	current_wear: float,
	base_chin: float,
	base_recovery: float,
	table_data: Dictionary
) -> Dictionary:
	var output = {
		"tier": "PRISTINE",
		"effective_chin": base_chin,
		"stamina_recovery_mult": 1.0,
		"cut_resistance_mult": 1.0,
		"retire_prompt": false
	}

	var th: Dictionary = table_data.get("thresholds", {})
	var pen: Dictionary = table_data.get("wear_penalties", {})

	if current_wear >= th.get("spent_min", 80.0):
		output["tier"] = "SPENT"
		var p_spent: Dictionary = pen.get("spent", {})
		output["effective_chin"] = minf(base_chin, p_spent.get("chin_cap", 60.0))
		output["stamina_recovery_mult"] = p_spent.get("stamina_recovery_multiplier", 0.65)
		output["cut_resistance_mult"] = p_spent.get("cut_resistance_multiplier", 0.60)
		output["retire_prompt"] = true
	elif current_wear >= th.get("weathered_max", 50.0):
		output["tier"] = "BATTLE_WORN"
		var p_worn: Dictionary = pen.get("battle_worn", {})
		output["effective_chin"] = minf(base_chin, p_worn.get("chin_cap", 85.0))
		output["stamina_recovery_mult"] = p_worn.get("stamina_recovery_multiplier", 0.88)
		output["cut_resistance_mult"] = p_worn.get("cut_resistance_multiplier", 0.85)
	elif current_wear >= th.get("pristine_max", 20.0):
		output["tier"] = "WEATHERED"

	return output

(c) Unit Tests
static func run_tests() -> bool:
	var test_table = {
		"thresholds": { "pristine_max": 20.0, "weathered_max": 50.0, "battle_worn_max": 79.0, "spent_min": 80.0 },
		"wear_penalties": {
			"battle_worn": { "chin_cap": 85.0, "stamina_recovery_multiplier": 0.88, "cut_resistance_multiplier": 0.85 },
			"spent": { "chin_cap": 60.0, "stamina_recovery_multiplier": 0.65, "cut_resistance_multiplier": 0.60, "forced_retirement_warning": true }
		},
		"accumulation_sources": { "knockdown_suffered": 2.5, "hard_sparring_round": 0.25 }
	}

	# Test 1: Accumulate knockdowns
	var w1 = accumulate_wear(10.0, "knockdown_suffered", 2, test_table)
	assert(is_equal_approx(w1, 15.0), "Test 1 Failed: Wear math error on knockdown")

	# Test 2: Chin cap enforcement when Spent
	var deg = calculate_fighter_degradations(82.0, 95.0, 1.0, test_table)
	assert(deg.tier == "SPENT" and deg.effective_chin == 60.0 and deg.retire_prompt == true, "Test 2 Failed: Spent caps not applied")
	return true

(d) System Hook

Hooked into FightRealtime.gd post-fight resolution, GymSparring.gd weekly tallying, and WeighInCut.gd. Feeds directly into fighter card state persistence.

(e) UI Read (3 Seconds)

A weathered bronze gauge on the fighter card:

0–20: Clean brass shield ("Fresh").
50–79: Cracked iron shield ("Battle-Worn: Chin capped at 85").
80+: Shattered skull with red hazard pulse ("SPENT: Retirement Recommended").
(f) Boxing Anchor

Fighters who endure brutal gym wars and multiple knockdowns (e.g., Meldrick Taylor) permanently lose punch resistance and reaction time.

(g) Failure Mode & Guard

Risk: Player grinds hard sparring every single week and accidentally ruins their best prospect before fight 3.

Guard: The assistant coach interrupts training with an alert if a single camp adds over 8.0 wear points: "Leo is leaving his career in the gym."

SECTION 4 — CUTSCAR1: Fight-2 Cut Decision & Scarring
(a) Data Table (JSON)
{
  "feature_flag": "FEATURE_FIGHT2_CUT_SCAR",
  "default_state": false,
  "rules": {
    "fight_2_mandatory_cut_event_round": 3,
    "initial_cut_severity_pips": 3
  },
  "decisions": {
    "THROW_TOWEL": {
      "id": "THROW_TOWEL",
      "immediate_outcome": "LOSS_BY_TKO_CORNER_STOPPAGE",
      "purse_penalty_ratio": 0.50,
      "scar_level_awarded": 0,
      "cut_heals_clean": true,
      "gym_prestige_delta": -15
    },
    "WAVE_HIM_ON": {
      "id": "WAVE_HIM_ON",
      "immediate_outcome": "FIGHT_CONTINUES",
      "purse_penalty_ratio": 0.00,
      "scar_level_awarded": 1,
      "cut_heals_clean": false,
      "gym_prestige_delta": 35
    }
  },
  "scar_tiers": {
    "0": { "name": "None", "re_cut_multiplier": 1.00, "base_bleed_pip_offset": 0, "doctor_risk_modifier": 0.00, "recovery_months": 0 },
    "1": { "name": "Cut-Prone Scar L1", "re_cut_multiplier": 1.35, "base_bleed_pip_offset": 0, "doctor_risk_modifier": 0.15, "recovery_months": 6 },
    "2": { "name": "Fibrotic Scar Tissue L2", "re_cut_multiplier": 1.75, "base_bleed_pip_offset": 0, "doctor_risk_modifier": 0.30, "recovery_months": 12 },
    "3": { "name": "Torn Grasp L3", "re_cut_multiplier": 2.50, "base_bleed_pip_offset": 1, "doctor_risk_modifier": 0.50, "recovery_months": 999 }
  }
}

(b) Typed Pure GDScript Implementation
# CutScar1.gd
class_name CutScar1
extends RefCounted

static func resolve_corner_decision(
	decision_id: String,
	table_data: Dictionary
) -> Dictionary:
	var decisions: Dictionary = table_data.get("decisions", {})
	if not decisions.has(decision_id):
		return { "valid": false }

	var d: Dictionary = decisions[decision_id]
	return {
		"valid": true,
		"outcome": d.get("immediate_outcome", ""),
		"purse_penalty": d.get("purse_penalty_ratio", 0.0),
		"scar_awarded": d.get("scar_level_awarded", 0),
		"prestige_delta": d.get("gym_prestige_delta", 0)
	}

static func calculate_future_cut_risk(
	scar_level: int,
	base_cut_chance: float,
	current_bleed_pips: int,
	table_data: Dictionary
) -> Dictionary:
	var tiers: Dictionary = table_data.get("scar_tiers", {})
	var tier_key: String = str(clamp(scar_level, 0, 3))
	var tier: Dictionary = tiers.get(tier_key, tiers["0"])

	var mult: float = tier.get("re_cut_multiplier", 1.0)
	var final_cut_chance: float = clampf(base_cut_chance * mult, 0.0, 1.0)
	var starting_bleed: int = current_bleed_pips + int(tier.get("base_bleed_pip_offset", 0))
	var doc_mod: float = tier.get("doctor_risk_modifier", 0.0)

	return {
		"modified_cut_chance": final_cut_chance,
		"effective_bleed_pips": starting_bleed,
		"doctor_risk_modifier": doc_mod,
		"tier_name": tier.get("name", "None")
	}

(c) Unit Tests
static func run_tests() -> bool:
	var table = {
		"decisions": {
			"THROW_TOWEL": { "immediate_outcome": "LOSS_BY_TKO", "scar_level_awarded": 0, "purse_penalty_ratio": 0.5 },
			"WAVE_HIM_ON": { "immediate_outcome": "FIGHT_CONTINUES", "scar_level_awarded": 1, "purse_penalty_ratio": 0.0 }
		},
		"scar_tiers": {
			"0": { "name": "None", "re_cut_multiplier": 1.0, "base_bleed_pip_offset": 0 },
			"1": { "name": "Cut-Prone L1", "re_cut_multiplier": 1.35, "base_bleed_pip_offset": 0 },
			"3": { "name": "Torn Grasp L3", "re_cut_multiplier": 2.50, "base_bleed_pip_offset": 1 }
		}
	}

	# Test 1: Throw towel avoids scar
	var r1 = resolve_corner_decision("THROW_TOWEL", table)
	assert(r1.scar_awarded == 0 and r1.purse_penalty == 0.5, "Test 1 Failed: Towel gave wrong penalty/scar")

	# Test 2: Scar L1 increases future cut chance
	var r2 = calculate_future_cut_risk(1, 0.20, 0, table)
	assert(is_equal_approx(r2.modified_cut_chance, 0.20 * 1.35), "Test 2 Failed: Scar multiplier failed")

	# Test 3: Scar L3 starts already bleeding 1 pip
	var r3 = calculate_future_cut_risk(3, 0.

Can you continue SECTION 1 with the complete typed GDScript shout module, tests, and exact probability formulas?
Can you define the referee personality module with typed GDScript, stoppage thresholds, and pre-fight card presentation?
Can you generate a stylized 3D concept image of the FightCamp club floor with painted color-coded training routes?


## Round 17b - "CONTINUE" (sent): SECTION 5 CLUBROUTES1, SECTION 6 CARDAUTO1, SECTION 7 build order + first-hour playtest script.

## Round 17b - Ludo's answer (verbatim, saved byte-exact via Tools/arena_rx.py)

(c) Unit Tests (CutScar1 Continued)
	# Test 3: Scar L3 starts already bleeding 1 pip
	var r3 = calculate_future_cut_risk(3, 0.10, 0, table)
	assert(r3.effective_bleed_pips == 1, "Test 3 Failed: Scar L3 base bleed pip offset not applied")
	assert(is_equal_approx(r3.modified_cut_chance, 0.25), "Test 3 Failed: Scar L3 multiplier failed")
	return true

(d) System Hook

Called by LudoCorner.gd during round 3 intermission in Fight 2 when the ringside doctor inspects a 3+ pip cut, and referenced by CutsDoctor.gd in every subsequent bout to modify laceration rolls.

(e) UI Read (3 Seconds)

A flashing split-choice modal in the corner drawer:

White Towel Icon: "THROW TOWEL — Forfeit $350 purse, eye heals clean (0 scars)."
Blood Droplet Icon: "WAVE HIM ON — Keep purse, permanent 'Cut-Prone' scar (+35% future bleed rate)."
(f) Boxing Anchor

Henry Cooper's fragile brow against Muhammad Ali or Vito Antuofermo's extensive scar tissue—once deeply cut, scar tissue lacks elasticity and splits in subsequent fights under minimal blunt impact.

(g) Failure Mode & Guard

Risk: Player waves the fighter on without realizing it can permanently ruin their chin and longevity.

Guard: A persistent red warning label appears above the confirmation button: "PERMANENT CAREER INJURY: Scar tissue never fully disappears."

SECTION 5 — CLUBROUTES1: Painted Drill Routes
(a) Data Table (JSON)
{
  "feature_flag": "FEATURE_CLUB_ROUTES",
  "default_state": false,
  "station_nodes": {
    "PADS": { "id": "PADS", "pos": [2.0, 0.0, -3.5], "category": "TACTICAL", "color_hex": "#3A86FF" },
    "HEAVY_BAG": { "id": "HEAVY_BAG", "pos": [-4.0, 0.0, -2.0], "category": "POWER", "color_hex": "#E63946" },
    "SPEED_BAG": { "id": "SPEED_BAG", "pos": [-4.5, 0.0, 2.0], "category": "SPEED", "color_hex": "#FFBE0B" },
    "TREADMILL": { "id": "TREADMILL", "pos": [4.0, 0.0, 3.0], "category": "CONDITIONING", "color_hex": "#2A9D8F" },
    "SPARRING_RING": { "id": "SPARRING_RING", "pos": [0.0, 0.0, 1.5], "category": "SPARRING", "color_hex": "#9D4EDD" },
    "RECOVERY_BENCH": { "id": "RECOVERY_BENCH", "pos": [3.5, 0.0, -1.0], "category": "RECOVERY", "color_hex": "#8338EC" }
  },
  "training_categories": {
    "TACTICAL": { "color": [0.227, 0.525, 1.0, 1.0], "line_width": 0.12, "dash_speed": 1.2 },
    "POWER": { "color": [0.902, 0.224, 0.275, 1.0], "line_width": 0.15, "dash_speed": 0.8 },
    "SPEED": { "color": [1.0, 0.745, 0.043, 1.0], "line_width": 0.08, "dash_speed": 2.0 },
    "CONDITIONING": { "color": [0.165, 0.616, 0.561, 1.0], "line_width": 0.10, "dash_speed": 1.5 },
    "SPARRING": { "color": [0.616, 0.306, 0.867, 1.0], "line_width": 0.18, "dash_speed": 0.5 },
    "RECOVERY": { "color": [0.514, 0.220, 0.925, 1.0], "line_width": 0.06, "dash_speed": 0.4 }
  },
  "route_rules": {
    "day_duration_seconds": 120.0,
    "max_stations_per_day": 4,
    "transition_walk_speed_mps": 1.6,
    "pulse_frequency_hz": 2.0
  }
}

(b) Typed Pure GDScript Implementation
# ClubRoutes1.gd
class_name ClubRoutes1
extends RefCounted

static func build_day_spline_points(
	station_sequence: Array,
	station_nodes: Dictionary
) -> PackedVector3Array:
	var points: PackedVector3Array = PackedVector3Array()
	for station_id in station_sequence:
		if station_nodes.has(station_id):
			var pos_arr: Array = station_nodes[station_id].get("pos", [0.0, 0.0, 0.0])
			points.append(Vector3(pos_arr[0], pos_arr[1], pos_arr[2]))
	return points

static func evaluate_route_progress(
	day_elapsed_sec: float,
	day_duration_sec: float,
	station_sequence: Array,
	station_nodes: Dictionary,
	walk_speed_mps: float
) -> Dictionary:
	var total_stations: int = station_sequence.size()
	if total_stations == 0:
		return { "current_station": "", "target_station": "", "is_walking": false, "actor_pos": Vector3.ZERO }

	var time_per_station: float = day_duration_sec / float(total_stations)
	var current_index: int = mini(int(day_elapsed_sec / time_per_station), total_stations - 1)
	var current_station_id: String = station_sequence[current_index]
	
	var station_time_elapsed: float = fmod(day_elapsed_sec, time_per_station)
	var cur_pos_arr: Array = station_nodes[current_station_id].get("pos", [0.0, 0.0, 0.0])
	var cur_pos: Vector3 = Vector3(cur_pos_arr[0], cur_pos_arr[1], cur_pos_arr[2])

	if current_index >= total_stations - 1:
		return {
			"current_station": current_station_id,
			"target_station": current_station_id,
			"is_walking": false,
			"actor_pos": cur_pos,
			"progress_ratio": clampf(day_elapsed_sec / day_duration_sec, 0.0, 1.0)
		}

	var next_station_id: String = station_sequence[current_index + 1]
	var next_pos_arr: Array = station_nodes[next_station_id].get("pos", [0.0, 0.0, 0.0])
	var next_pos: Vector3 = Vector3(next_pos_arr[0], next_pos_arr[1], next_pos_arr[2])
	
	var walk_distance: float = cur_pos.distance_to(next_pos)
	var walk_time_needed: float = walk_distance / maxf(0.1, walk_speed_mps)
	var time_remaining_in_station: float = time_per_station - station_time_elapsed

	if time_remaining_in_station <= walk_time_needed:
		var walk_progress: float = 1.0 - (time_remaining_in_station / walk_time_needed)
		var interp_pos: Vector3 = cur_pos.lerp(next_pos, clampf(walk_progress, 0.0, 1.0))
		return {
			"current_station": current_station_id,
			"target_station": next_station_id,
			"is_walking": true,
			"actor_pos": interp_pos,
			"progress_ratio": clampf(day_elapsed_sec / day_duration_sec, 0.0, 1.0)
		}

	return {
		"current_station": current_station_id,
		"target_station": current_station_id,
		"is_walking": false,
		"actor_pos": cur_pos,
		"progress_ratio": clampf(day_elapsed_sec / day_duration_sec, 0.0, 1.0)
	}

static func calculate_shader_pulse_offset(
	elapsed_sec: float,
	dash_speed: float,
	pulse_hz: float
) -> float:
	return fmod(elapsed_sec * dash_speed * pulse_hz, 100.0)

(c) Unit Tests
static func run_tests() -> bool:
	var nodes = {
		"PADS": { "pos": [0.0, 0.0, 0.0], "category": "TACTICAL" },
		"HEAVY_BAG": { "pos": [10.0, 0.0, 0.0], "category": "POWER" }
	}
	var seq = ["PADS", "HEAVY_BAG"]
	
	# Test 1: Spline point generation matches array count
	var points = build_day_spline_points(seq, nodes)
	assert(points.size() == 2, "Test 1 Failed: Spline point generation size mismatch")
	assert(points[1] == Vector3(10, 0, 0), "Test 1 Failed: Spline vector coordinate error")

	# Test 2: Actor stands at station during middle of session
	# 120s total, 2 stations = 60s per station. Walk distance = 10m. Speed = 1.6m/s -> walk time = 6.25s.
	# At t = 30.0s, actor should be static at station 0 (PADS)
	var r1 = evaluate_route_progress(30.0, 120.0, seq, nodes, 1.6)
	assert(not r1.is_walking and r1.current_station == "PADS", "Test 2 Failed: Station stationary check failed")

	# Test 3: Actor transitions when time remaining <= walk time needed
	# At t = 55.0s, remaining time = 5.0s (< 6.25s needed). Actor must be walking toward HEAVY_BAG.
	var r2 = evaluate_route_progress(55.0, 120.0, seq, nodes, 1.6)
	assert(r2.is_walking and r2.target_station == "HEAVY_BAG", "Test 3 Failed: Station walking transition failed")
	assert(r2.actor_pos.x > 0.0 and r2.actor_pos.x < 10.0, "Test 3 Failed: Actor position interpolation error")
	return true

(d) System Hook

Evaluated per-tick by the Gym Scene controller during training days. Translates FightWeek.gd daily assignments into Godot ImmediateMesh ribbon lines painted across the gym floor.

(e) UI Read (3 Seconds)

Pulsing dashed floor vectors on the gym floor:

Neon Blue line toward Mitts: "Station 1: Pads (Technique)."
Red dashed pulse toward Bags: "Station 2: Heavy Bag (Power)."
Hovering over a path displays total stamina cost and fatigue warnings.
(f) Boxing Anchor

Structured camps follow rigid circuit routines where athletes move systematically from dynamic mitts to conditioning to recovery bags without wasted downtime.

(g) Failure Mode & Guard

Risk: Player queues high-fatigue stations consecutively, injuring the boxer during route execution without realizing it.

Guard: The spline turns jagged orange-and-black hazard striped if the target stamina cost exceeds the athlete’s available daily endurance reserve.

SECTION 6 — CARDAUTO1: Auto-Firing Move Cards & Pad Chains
(a) Data Table (JSON)
{
  "feature_flag": "FEATURE_CARD_AUTO_CHAINS",
  "default_state": false,
  "execution_rules": {
    "iq_divisor": 70.0,
    "min_mastery_for_auto": 25.0,
    "cooldown_seconds": 4.0,
    "opponent_read_threshold": 3,
    "overuse_counter_rate_per_use": 0.12
  },
  "chains": {
    "SLIP_CROSS_COUNTER": {
      "id": "SLIP_CROSS_COUNTER",
      "display_name": "Slip 2 - Cross Return",
      "trigger_event": "OPPONENT_LEAD_JAB",
      "required_mastery": 100.0,
      "steps": [
        { "step": 1, "action": "READ_TRIGGER", "type": "TRIGGER", "target": "OPPONENT_LEAD_JAB" },
        { "step": 2, "action": "SLIP_OUTSIDE", "type": "EVASION", "window_ms": 180 },
        { "step": 3, "action": "REAR_CROSS", "type": "COUNTER", "damage_mult": 1.65, "crit_bonus": 0.20 }
      ]
    },
    "DUCK_HOOK_RIP": {
      "id": "DUCK_HOOK_RIP",
      "display_name": "Duck & Liver Rip",
      "trigger_event": "OPPONENT_REAR_HOOK",
      "required_mastery": 100.0,
      "steps": [
        { "step": 1, "action": "READ_TRIGGER", "type": "TRIGGER", "target": "OPPONENT_REAR_HOOK" },
        { "step": 2, "action": "DUCK_UNDER", "type": "EVASION", "window_ms": 220 },
        { "step": 3, "action": "LEAD_BODY_HOOK", "type": "COUNTER", "damage_mult": 1.85, "gas_drain": 4.0 }
      ]
    }
  }
}

(b) Typed Pure GDScript Implementation
# CardAuto1.gd
class_name CardAuto1
extends RefCounted

const IQ_DIVISOR: float = 70.0
const MIN_MASTERY: float = 25.0
const COOLDOWN_SEC: float = 4.0

static func calculate_fire_probability(mastery: float, ring_iq: float) -> float:
	if mastery < MIN_MASTERY:
		return 0.0
	var prob: float = (mastery * ring_iq) / (IQ_DIVISOR * 100.0)
	return clampf(prob, 0.05, 0.95)

static func evaluate_chain_trigger(
	chain_def: Dictionary,
	current_event: String,
	time_since_last_fire: float,
	mastery: float,
	ring_iq: float,
	composure_band: String,
	times_executed_this_fight: int,
	roll_fire: float,
	roll_step2: float,
	roll_step3: float
) -> Dictionary:
	var result: Dictionary = {
		"triggered": false,
		"steps_completed": 0,
		"total_steps": 3,
		"banner_text": "",
		"damage_mult": 1.0,
		"was_countered_by_opponent": false,
		"reason": ""
	}

	if composure_band == "Broken":
		result["reason"] = "BROKEN_COMPOSURE_BLOCK"
		return result

	if time_since_last_fire < COOLDOWN_SEC:
		result["reason"] = "COOLDOWN_ACTIVE"
		return result

	if current_event != chain_def.get("trigger_event", ""):
		result["reason"] = "TRIGGER_MISMATCH"
		return result

	var p_fire: float = calculate_fire_probability(mastery, ring_iq)
	if roll_fire > p_fire:
		result["reason"] = "PROBABILITY_FAILED"
		return result

	result["triggered"] = true
	result["steps_completed"] = 1 # Step 1: Read Trigger confirmed

	# Check opponent adaptation from repetition
	if times_executed_this_fight >= 3:
		var counter_risk: float = float(times_executed_this_fight - 2) * 0.12
		if roll_step2 < counter_risk:
			result["was_countered_by_opponent"] = true
			result["banner_text"] = "CHAIN READ & PUNISHED!"
			return result

	# Step 2: Evasion execution
	var p_evade: float = clampf((ring_iq / 100.0) * 1.10, 0.20, 0.95)
	if roll_step2 > p_evade:
		result["banner_text"] = chain_def.get("display_name", "") + " (1/3: EVASION MISSED)"
		return result
	result["steps_completed"] = 2

	# Step 3: Counter strike landing
	var p_counter: float = clampf((mastery / 100.0) * 1.05, 0.25, 0.95)
	if roll_step3 > p_counter:
		result["banner_text"] = chain_def.get("display_name", "") + " (2/3: COUNTER BLOCKED)"
		return result

	result["steps_completed"] = 3
	var counter_step: Dictionary = chain_def.get("steps", [])[2]
	result["damage_mult"] = counter_step.get("damage_mult", 1.0)
	result["banner_text"] = chain_def.get("display_name", "") + " (EXECUTED 3/3)"
	return result

(c) Unit Tests
static func run_tests() -> bool:
	var chain = {
		"display_name": "Slip 2 - Cross Return",
		"trigger_event": "OPPONENT_LEAD_JAB",
		"steps": [
			{ "step": 1, "type": "TRIGGER" },
			{ "step": 2, "type": "EVASION" },
			{ "step": 3, "type": "COUNTER", "damage_mult": 1.65 }
		]
	}

	# Test 1: Broken composure blocks execution
	var r1 = evaluate_chain_trigger(chain, "OPPONENT_LEAD_JAB", 10.0, 100.0, 80.0, "Broken", 0, 0.1, 0.1, 0.1)
	assert(not r1.triggered and r1.reason == "BROKEN_COMPOSURE_BLOCK", "Test 1 Failed: Broken boxer fired chain")

	# Test 2: Successful 3/3 completion
	# Mastery 100, IQ 70 -> P = (100 * 70) / 7000 = 1.0 -> clampf 0.95. Roll 0.1 passes.
	var r2 = evaluate_chain_trigger(chain, "OPPONENT_LEAD_JAB", 5.0, 100.0, 70.0, "Focused", 0, 0.1, 0.1, 0.1)
	assert(r2.triggered and r2.steps_completed == 3, "Test 2 Failed: Chain did not complete 3/3")
	assert(is_equal_approx(r2.damage_mult, 1.65), "Test 2 Failed: Counter damage multiplier missing")

	# Test 3: Opponent punishes telegraphing on repeat usage
	# 4 previous executions -> counter_risk = (4 - 2) * 0.12 = 0.24. Roll 0.10 triggers counter.
	var r3 = evaluate_chain_trigger(chain, "OPPONENT_LEAD_JAB", 5.0, 100.0, 70.0, "Focused", 4, 0.1, 0.10, 0.1)
	assert(r3.was_countered_by_opponent, "Test 3 Failed: Opponent adaptation counter not triggered")
	return true

(d) System Hook

Evaluated inside FightRealtime.gd whenever an incoming strike frame is registered. At intermission, totals are passed to LudoCorner.gd to populate the stool performance report.

(e) UI Read (3 Seconds)

A banner across the upper thirds of the screen:

Gold Banner + "SLIP-CROSS (3/3)": Clean slow-motion flash as the counter right connects.
Corner Stool Metric: "Pad Chains Executed: 2 of 3 (Opponent adapting: -24% efficiency)."
(f) Boxing Anchor

Floyd Mayweather drilling the pull-counter pad sequence until it fires as an unthinking motor reflex when an opponent leads with their left hand.

(g) Failure Mode & Guard

Risk: Relying solely on one mastered chain makes the fighter predictable, leading to a brutal counter-knockout late in the fight.

Guard: The stool drawer flashes an amber indicator once a chain has been run 3 times: "TELEGraphed: Opponent reading this sequence."

SECTION 7 — Build Order, Parallel Architecture & First-Hour Benchmark
========================= MODULE BUILD DEPENDENCIES =========================
   [Referee1.gd]      [Wear1.gd]       [ClubRoutes1.gd]      [CardAuto1.gd]
         |                 |                  |                    |
         +--------+--------+                  +---------+----------+
                  |                                     |
                  v                                     v
           [CutScar1.gd]                         [Shout1.gd]
                  \                                   /
                   v                                 v
        [INTEGRATED SIM ENGINE: LudoCorner, FightRealtime, FightWeek]
=============================================================================

7.1 Build Order Strategy
Parallel Stream A (Isolated Combat Logic):
Build Referee1.gd & Wear1.gd. Pure mathematical rules with zero cross-dependencies.
Build CutScar1.gd. Depends only on Wear1.gd damage structures and scalar doctor tables.
Parallel Stream B (Gym & Tactical Execution):
Build ClubRoutes1.gd & CardAuto1.gd. Standalone algorithmic solvers (spline node paths and step-chain state trees).
Build Shout1.gd. Ingests output from CardAuto1.gd and composure meters from Composure.gd.
Engine Scene Hooking: Connect all modules to Godot node trees via their static evaluation signatures.
7.2 The First-Hour Playtest Script

Exercises all six features in sequence across the first 60 minutes of real playtime.

0m               15m              30m              42m              55m              60m
[GYM SETUP] ----> [FIGHT 1] -----> [WEEK 2 CAMP] -> [FIGHT 2] -----> [PROMOTER] ---> [AUDIT]
ClubRoutes1       Referee1        Wear1            CutScar1         Trap Decision    All 6 Modules
Checked           Shout1 fired    Accumulates      Wave Him On      Offered          Verified

Timeline & Expected Telemetry Ticks
00:00 – 12:00 (Onboarding & Route Setup):
Player picks Leo Vance. Assigns Monday training route: ["PADS", "HEAVY_BAG", "RECOVERY_BENCH"].
Telemetry Check: ClubRoutes1.build_day_spline_points() returns exactly 3 vectors; shader dash offset increments continuously without hitching.
12:00 – 24:00 (Fight 1 vs. Tommy Perez):
Referee is assigned as HAIR_TRIGGER.
In Round 2, Perez pins Leo against the ropes. Player clicks "OFF THE ROPES!".
Telemetry Check: Shout1.attempt_shout() succeeds (Leo IQ 68, Trust 60 $\rightarrow$ 62% pass chance). Leo escapes ropes within $0.8\text{ s}$.
Leo's drilled SLIP_CROSS_COUNTER fires automatically twice on Perez jabs, reporting (EXECUTED 3/3) on screen.
24:00 – 38:00 (Post-Fight 1 & Week 2 Camp):
Leo took 18 clean head shots in Fight 1.
Telemetry Check: Wear1.accumulate_wear() increments Leo's Career Wear meter from $0.00$ to $3.94$. Tier remains PRISTINE.
38:00 – 50:00 (Fight 2 vs. Ray Miller):
Referee is LET_EM_FIGHT. Clinch breaks take a full $4.50\text{ s}$.
In Round 3, an accidental headbutt opens a 3-pip cut over Leo's left eyebrow.
Ringside doctor examines cut. Modal options appear: THROW_TOWEL vs WAVE_HIM_ON.
Player selects WAVE_HIM_ON. Leo rallies to win a split decision.
Telemetry Check: CutScar1.resolve_corner_decision() awards Cut-Prone Scar L1 ($+35%$ re-cut chance, 6-month healing timer).
50:00 – 60:00 (The Promoter's Trap):
Marcus Vance offers $$5,000$ short-notice bout against Hector Bravo.
Inspecting Leo's card confirms: Career Wear $= 8.44$, Trait: Cut-Prone Scar L1.
Final Assertion: All 6 systems register state updates accurately without engine node crashes or runtime allocations.
# FirstHourIntegrationTest.gd
class_name FirstHourIntegrationTest
extends RefCounted

static func run_first_hour_audit() -> bool:
	assert(Shout1.run_tests(), "Shout1 Module Failed")
	assert(Referee1.run_tests(), "Referee1 Module Failed")
	assert(Wear1.run_tests(), "Wear1 Module Failed")
	assert(CutScar1.run_tests(), "CutScar1 Module Failed")
	assert(ClubRoutes1.run_tests(), "ClubRoutes1 Module Failed")
	assert(CardAuto1.run_tests(), "CardAuto1 Module Failed")
	return true


CONTINUE FROM SECTION 8

Can you continue with SECTION 8 and preserve the same dense module, tests, UI, and integration format?
Can you consolidate all six systems into a single Godot 4 implementation roadmap with dependencies and file structure?
Can you create a top-down 3D concept image of the gym floor showing painted color-coded training routes between stations?

## CLAUDE'S VERDICT - round 17 (all six were approved S188 "yes all picks"; every feature behind a switch defaulting OFF)
TAKE the six specs. Pure modules: SHOUT1, REFEREE1, WEAR1, CUTSCAR1 -> LUDO-R17-MATH1 (cloud Qwen #90, renamed ApronShouts / RefereeStyle /
CareerWear / CutScar, tables in JSON); CLUBROUTES1 + CARDAUTO1 -> LUDO-R17-MATH2 next free cloud seat. Wiring (FightRealtime hooks, HUD
icons, the club floor paint) -> Cursor/Codex after the pure modules merge. Ludo's SECTION 7 first-hour playtest script becomes the
acceptance walk for LUDO-HOUR1 (the demo .exe flow).
CORRECT: class names Shout1/Referee1/Wear1/CutScar1 are placeholders - real names above; composure multipliers use OUR band names
(Focused/Rattled/Shaken/Broken from composure.json); CARDAUTO1 builds on MoveCards.gd + the LUDO-PAD1 pad-chain fire point, never a
second card system.
