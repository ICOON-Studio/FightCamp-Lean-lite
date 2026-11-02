# TASK STRESS1A - boxer stress, afflictions and virtue: pure rules module + blind test (S207)
Model: Qwen (cloud, label `qwen`). Repo ICOON-Studio/FightCamp, its own branch + PR into master; never merge.
Approved: operator board Q-S206-3 "Approve all three" (Ludo round 42 part B, verdict research/LUDO_ROUND42_VERDICT_S207.md).
Starting spec: Ludo's B2/B3/B7 in research/LUDO_ROUND42_S207_reply1.txt (lines 232-340) and reply2.txt (lines 63-238).
Ludo's code is a starting spec, NOT to be pasted: OUR RULES BELOW WIN where they differ.

## Our rules (above Ludo's code)
- PURE: `extends RefCounted`, `class_name StressRules`, static funcs only; no preload/load, no GameState, no Node, no files,
  NO randomness (randf/randi forbidden - the resolve roll is an argument `roll_0_100: float`), NEVER mutate an argument
  (duplicate(true) and return the new dict).
- Afflictions/virtue are Strings: "OVERCOOKED", "GUN_SHY", "STARVING", "FRAGILE"; virtue "STEELED"; none = "".
- Verdict corrections: STEELED gives composure +15 capped at 99 for the bout (NOT locked at 99); STARVING gives a fixed -20% gain on
  morning sessions (NO random skipped sessions). No animations in this module.

## Spec - NEW `Godot/scripts/rules/StressRules.gd`
1. `const GAINS := {...}` base gains from Ludo B2 (hard_day 3, extreme_strain 5, back_to_back 4, overreach_week 10, cut_3_5 4,
   severe_cut 12, failed_weigh_in 18, loss_split 8, loss_ud 12, loss_ko 22, knockdown 5, injury 10, withdrawal 16, opponent_pullout 8,
   broken_promise 18, ignored_request 10, inactive_week 3) each with its CATEGORY (training / trauma / weight_cut / wear / career);
   `const RELIEF := {...}` (rest_day 6, deload_week 18, win_decision 12, win_ko 18, title 30, promise_kept 12, physio 5,
   office_talk 8, clean_cut 8) - relief is NOT scaled by composure.
2. `static func composure_scale(composure: float) -> float` = clamp(1.6 - composure/100, 0.6, 1.6).
3. `static func apply(state: Dictionary, event_id: String, composure: float) -> Dictionary` - state {stress 0-100, history
   {category: float}, log [ {event, delta, total} ] newest first, max 20}. Unknown event -> unchanged copy. Stress clamped 0..100.
4. `static func weekly_decay(state: Dictionary) -> Dictionary` - stress < 40: -8; 40-69: -4; >= 70: 0.
5. `static func band(stress: float) -> String` - "CALM" < 50, "STRAINED" 50-79, "ON_EDGE" 80-99, "BREAKING" 100.
6. `static func resolve(state: Dictionary, composure: float, roll_0_100: float) -> Dictionary` - only at stress >= 100, else
   unchanged copy. virtue_chance = 15 + composure/5. roll <= chance -> virtue "STEELED", weeks 4, stress 50. Else affliction from the
   DOMINANT history category (training -> OVERCOOKED, trauma -> GUN_SHY, weight_cut -> STARVING, wear -> FRAGILE; career -> the next
   highest of those four; ties -> that order), stress 60, history cleared. Returns {state..., "outcome": "virtue"|"affliction",
   "virtue": String, "affliction": String}.
7. `static func effects(affliction: String, virtue: String) -> Dictionary` - the numbers from Ludo B3 with the verdict corrections
   (OVERCOOKED training_gain_mult 0.5, injury_risk_mult 1.25, late_round_stamina_drain_mult 1.25 from round 5, between_round_recovery
   0.65; GUN_SHY punch_output_mult 0.75, sparring_xp_mult 0.25, defensive_bias true, power_minus 10 until 5 clean; STARVING
   conditioning_regen_mult 0.6, morning_gain_mult 0.8, stamina_minus 15 bout, chin_minus 8 from round 4; FRAGILE region_wear_mult 2.0,
   region_damage_mult 1.3, defence_minus 12; STEELED stress_gain_mult 0.5 for 4 weeks, technique_gain_mult 1.15, composure_plus 15
   cap 99, power_stamina_hit_mult 0.8). Unknown -> {}.

## Test - NEW `Godot/tests/stress_rules_test.gd` (SceneTree `_initialize()`, prints `STRESS_RULES total=N fails=M`, quit(1) on
fail). Blind, from this contract: composure 80 scales 0.8, 20 scales 1.4; relief not scaled; clamp at 0 and 100; log max 20 newest
first; decay bands at 39/40/69/70; band edges 49/50/79/80/99/100; resolve below 100 = unchanged; roll at chance edge = virtue, just
above = affliction; each category maps to its affliction; career-dominant falls to the next; ties in the documented order; inputs
never mutated (deep compare before/after); deterministic; an inline MUTANT (virtue_chance + 50) must fail a check; a source scan of
StressRules.gd for preload / load( / GameState / randf / randi / Node / FileAccess (must be absent).

## Owned files
- `Godot/scripts/rules/StressRules.gd` (NEW)
- `Godot/tests/stress_rules_test.gd` (NEW)
GDScript 4: `const` (never `static const`), `for x in arr`, `dict.has()`, typed vars (`var n: float = ...`, never `:=` on a Variant).
Gate: `python Godot/tools/check_scripts.py <both files>`, then the test -> fails=0; CI green. Never delete or shrink a test.

## Prior research
J_STRESS_S206.md (John, sourced), K_STRESS_S206.md (Kalli), LUDO_ROUND42_S207_reply1/2.txt, LUDO_ROUND42_VERDICT_S207.md.
## What would a human do?
A designer writes the stress table and the threshold rule as one data module with tests, then wires it into the week loop.
## Prefab check
No Godot/asset-library stress system fits a boxing sim; Darkest Dungeon's model is the design reference only.
