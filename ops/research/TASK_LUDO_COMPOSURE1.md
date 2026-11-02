# TASK LUDO-COMPOSURE1 - V14 composure (pure module + data) - Arena

Model: Arena Agent Mode. Repo ICOON-Studio/FightCamp, branch from master; work ONLY on your own arena/ branch, open a PR into master,
NEVER merge it. Write ONLY the three NEW files below; edit nothing else. Do not delete or weaken any existing test.

## Owned files
- `Godot/assets/data/composure.json` (NEW)
- `Godot/scripts/Composure.gd` (NEW, pure: extends RefCounted, static funcs only, no autoload, no preload of game scripts)
- `Godot/tests/composure_test.gd` (NEW, extends SceneTree)

## Prior research
Design of record (approved D41): `research/LUDO_CORNER_TABLES_S190.md`, section "COMPOSURE (Ludo, S190)" - read it whole; every
number below is from it. House style: `Godot/scripts/PromoterTrap.gd` + `Godot/tests/promoter_trap_test.gd` (table cached from JSON, one
_check per case with the numbers in the message, prints `<NAME> FAILS=<n>`, quit(1) on any fail). Later LUDO-CORNER2 wires this into the
live fight; this task is the pure rules only.

## What would a human do?
Put Ludo's table in JSON, one pure function per row, test every row and Ludo's three worked fighters.

## Prefab check
N/A - our own rules module.

## Spec
`composure.json`: start {base 30, fight_iq 0.35, chin 0.20, clamp [20, 90], traits {"Iron Will": 15, "Gatekeeper Composure": 10,
"Fragile Confidence": -15}}; events {clean_power_head: -4, rocked: -12, knockdown_suffered: -25, cut_opened: -10, ropes_per_s_after_4s: -1,
pad_chain: 8, knockdown_scored: 15, counter_on_whiff: 3, three_slips_or_guards: 4, round_won: 6, round_lost: -6, away_boos: -3};
corner_recovery_per_conditioning 0.15; bounds [0, 100]; bands (low edge inclusive) Focused 70, Rattled 45, Shaken 20, Broken 0 with
{plan_adherence 1.0/0.75/0.40/0.10, guard 1.0/0.85/0.65/0.40, counter_latency_s 0/0.15/0.30/0.60 (D43), jab_bias 0/0.15/-1.0(abandons)/0,
wild_hook_bias 0/0/0.30/0, pad_chains_allowed true/true/true/false}.

`Composure.gd` (static, deterministic):
- `start_value(fight_iq: float, chin: float, traits: Array) -> float` - formula, then clamp [20, 90].
- `apply(value: float, event: String, count: float = 1.0) -> float` - adds events[event] * count, clamp [0, 100]; an unknown event
  push_warning()s (NOT push_error: run_tests fails any engine ERROR line) and returns value unchanged.
- `ropes(value: float, seconds_on_ropes: float) -> float` - -1 per second beyond 4 s (0 at or under 4 s).
- `corner_recovery(value: float, conditioning: float) -> float` - + conditioning * 0.15, clamp.
- `band(value: float) -> String` and `effects(value: float) -> Dictionary` (the band's row).
- `can_fire_pad_chain(value: float) -> bool` - false only when Broken.

## Done = (tier: new files only - parse + this test)
Parse gate (on Linux the headless binary from Tools/cloud_setup.sh): `Godot_v4.7.2-stable_win64.exe --headless --path Godot --check-only --script res://scripts/Composure.gd`;
then `Godot_v4.7.2-stable_win64.exe --headless --path Godot --script tests/composure_test.gd` -> `COMPOSURE_TEST FAILS=0`, rc 0, no SCRIPT
ERROR. The test covers: Ludo's three fighters (Leo fight_iq 45 chin 82 Iron Will -> 77.15 then clamp stays 77.15; Damian fight_iq 39 chin
35 -> 50.65; Malik fight_iq 61 chin 44 Fragile Confidence -> 45.15), both clamps (a fighter whose formula gives 15 -> 20; 95 -> 90), every
event, ropes at 4 s (0) and 7 s (-3), corner recovery (Leo conditioning 66 -> +9.9), each band edge (70, 69.9, 45, 44.9, 20, 19.9, 0, 100),
Broken cannot fire a pad chain. PR description: 3 mutants with the FAIL count each - (a) chin 0.20 -> 0.25, (b) Rattled low edge 45 -> 50,
(c) start clamp removed.

## The one trap
Ludo's prose rounds Leo to 77 (he wrote 30 + 15.75 + 16.4 + 15); 45 x 0.35 = 15.75 exactly, so assert 77.15 with an epsilon, never 77.
