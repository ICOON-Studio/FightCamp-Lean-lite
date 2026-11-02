# TASK LUDO-CUT3A - V9 weigh-in roulette (pure module + data) - Arena

Model: Arena Agent Mode. Repo ICOON-Studio/FightCamp, branch from master; work ONLY on your own arena/ branch, open a PR into master,
NEVER merge it. Write ONLY the three NEW files below; edit nothing else. Do not delete or weaken any existing test.

## Owned files
- `Godot/assets/data/weigh_in_cut.json` (NEW)
- `Godot/scripts/WeighInCut.gd` (NEW, pure: extends RefCounted, static funcs only, no autoload, no preload of game scripts)
- `Godot/tests/weigh_in_cut_test.gd` (NEW, extends SceneTree)

## Prior research
Design of record (approved D40, V9): Ludo's weigh-in roulette - `research/LUDO_ROUND4_S190.md` lines ~54-56 and ~246-247,
`research/LUDO_FIRST_HOUR_S190.md` minute 45-47, `research/LUDO_LOOPS_S188.md` line ~54. House style:
`Godot/scripts/PromoterTrap.gd` + `Godot/tests/promoter_trap_test.gd`. The screen and the live-fight wiring are a later task (LUDO-CUT3B);
this is the pure rules only.

## What would a human do?
Three rows of data, one function that resolves a choice against a given roll, test each row and both roll outcomes.

## Prefab check
N/A - our own rules module.

## Spec
`weigh_in_cut.json` - three options, numbers verbatim from Ludo, as fractions:
- `safe_sweat`: miss_chance 0.0, stamina_mult 0.95, chin_cap 1.0, power_mult 1.0.
- `sauna_push`: miss_chance 0.10, stamina_mult 1.0, chin_cap 0.85 (Ludo's acceptance: "chin meter starts capped at 85%"), power_mult 1.0.
- `extreme_drain`: miss_chance 0.30, stamina_mult 1.0, chin_cap 0.75 (Ludo S188: an emergency cut "cuts maximum concussion threshold by
  25%"), power_mult 1.10, chin_compromised true (the HUD's flashing red chin marker).
- `miss`: purse_forfeit 0.20 (Ludo: "forfeits 20% purse"; a missed weight is a miss whichever option caused it).

`WeighInCut.gd` (static, deterministic - the caller passes the roll in [0, 1)):
- `options() -> Array` - the three ids in screen order.
- `miss_chance(option: String) -> float`.
- `resolve(option: String, roll: float, purse: int) -> Dictionary` - {made_weight: roll >= miss_chance, purse: purse or
  round(purse * 0.80) on a miss, stamina_mult, chin_cap, power_mult, chin_compromised}. An unknown option push_error()s and returns {}.
- `fight_modifiers(result: Dictionary) -> Dictionary` - {stamina_mult, chin_cap, power_mult, chin_compromised} only (what the live fight
  will read).

## Done = (tier: new files only - parse + this test)
Parse gate (on Linux the headless binary from Tools/cloud_setup.sh): `Godot_v4.7.2-stable_win64.exe --headless --path Godot --check-only --script res://scripts/WeighInCut.gd`;
then `Godot_v4.7.2-stable_win64.exe --headless --path Godot --script tests/weigh_in_cut_test.gd` -> `WEIGH_IN_CUT_TEST FAILS=0`, rc 0, no
SCRIPT ERROR. Cases: each option's numbers match the JSON; safe_sweat never misses (roll 0.0); sauna roll 0.05 misses -> purse 1000 ->
800, roll 0.10 makes weight; extreme roll 0.29 misses, 0.30 makes it; power 1.10 and chin_cap 0.75 on extreme whether or not it made weight;
unknown option -> {}. PR description: 3 mutants with FAIL counts - (a) sauna miss 0.10 -> 0.20, (b) purse_forfeit 0.20 -> 0.10,
(c) `roll >= miss` flipped to `roll > miss`.

## The one trap
The roll is an argument - never call randf() inside the module (the fight engine owns its RNG and its determinism tripwire).
