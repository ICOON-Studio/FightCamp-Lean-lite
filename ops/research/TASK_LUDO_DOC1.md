# TASK LUDO-DOC1 - V15 doctor stoppage + cut-prone scar (pure module + data) - Arena

Model: Arena Agent Mode. Repo ICOON-Studio/FightCamp, branch from master; work ONLY on your own arena/ branch, open a PR into master,
NEVER merge it. Write ONLY the three NEW files below; edit nothing else. Do not delete or weaken any existing test.

## Owned files
- `Godot/assets/data/cuts_doctor.json` (NEW)
- `Godot/scripts/CutsDoctor.gd` (NEW, pure: extends RefCounted, static funcs only, no autoload, no preload of game scripts)
- `Godot/tests/cuts_doctor_test.gd` (NEW, extends SceneTree)

## Prior research
Design of record (approved D42): `research/LUDO_DOCTOR_S191.md` - read the whole "Ludo's answer, verbatim" section; every
number below comes from it. House style for a pure JSON-backed module: `Godot/scripts/PromoterTrap.gd` (table cached from JSON) and its
test `Godot/tests/promoter_trap_test.gd` (one _check per case, numbers in the message, prints `<NAME> FAILS=<n>`, quit(1) on any fail).

## What would a human do?
Put Ludo's five tables in one JSON, write one pure function per table, and test every row of every table plus the worked example.

## Prefab check
N/A - our own rules module.

## Spec
`cuts_doctor.json` holds Ludo's tables as data (no number lives in the .gd):
- `pips_max` 5; pip names ["Intact","Nick","Seeping","Heavy Stream","Gash","Torn Arterial"].
- `open`: clinch_clash 0.35; clean_hook = (power - defense) * 0.004 (i.e. 0.40% per point), min_net_damage 12; elbow_thumb 0.25 with
  `"enabled_in_boxing": false` (boxing EA has no dirty fighting - the function must return 0 for it while disabled).
- `worsen`: hook 1.0 pip, jab 0.5, cross 0.5, glancing/blocked 0.
- `doctor_call`: per pip level {0:0, 1:0, 2:0, 3:0.15, 4:0.50, 5:1.0}; 3 pips also calls when bleed_s > 45; 4 pips = mandatory at the break.
- `stoppage_base`: {1:0, 2:0, 3:0.35, 4:0.70, 5:1.0}; `cutman_reduction`: swab 0.20, coagulant 0.45 - ADDITIVE subtraction, floor 0.
- `decision`: towel {purse 150, record "loss_rtd", scar false, composure -10, gym_trust +15}; wave_on {purse_win 350, purse_if_stopped 150,
  composure +15, gym_trust -10, scar_if_pips_at_bell_ge 3}.
- `scar`: L1 {pips 3, cut_mult 1.35, start_pips 0, fades_after_months 6}, L2 {pips 4, cut_mult 1.75, start_pips 0, fades false,
  surgery_cost 1200, surgery_to 1}, L3 {pips 5, name "Torn Grasp", cut_mult 2.50, start_pips 1, fades false}.

`CutsDoctor.gd` (static, deterministic - every chance is RETURNED, never rolled; the caller rolls):
- `open_chance(source: String, power: float, defense: float, clean: bool) -> float` - source "clinch_clash" | "hook" | "elbow_thumb";
  0 when not clean; hook = (power-defense)*0.004 when power-defense >= 12 else 0; elbow_thumb 0 while disabled.
- `worsen(pips: float, punch: String, clean: bool) -> float` - adds the worsen value, clamps to pips_max.
- `doctor_call_chance(pips: float, bleed_s: float) -> float` - uses floor(pips); 3 pips returns 1.0 when bleed_s > 45.
- `mandatory_inspection(pips: float) -> bool` - true at >= 4.
- `stoppage_chance(pips: float, cutman: Array) -> float` - base minus the sum of reductions for the cutman actions in the array
  ("swab", "coagulant"), floor 0, cap 1.
- `towel() -> Dictionary` and `wave_on(won: bool, pips_at_bell: float) -> Dictionary` - the decision rows; wave_on adds "scar_level"
  (0 if pips < 3, else 1/2/3 for floor(pips) 3/4/5).
- `scar_cut_mult(level: int) -> float`, `scar_start_pips(level: int) -> int`, `scar_after_months(level: int, months_clean: int) -> int`
  (L1 -> 0 after 6 clean months; L2/L3 never fade), `surgery(level: int) -> Dictionary` ({level, cost}: L2 -> L1 for 1200; others unchanged, cost 0).

## Done = (tier: new files only - parse + this test)
Parse gate (on Linux use the headless binary from Tools/cloud_setup.sh): `Godot_v4.7.2-stable_win64.exe --headless --path Godot --check-only --script res://scripts/CutsDoctor.gd`
then `Godot_v4.7.2-stable_win64.exe --headless --path Godot --script tests/cuts_doctor_test.gd` -> prints `CUTS_DOCTOR_TEST FAILS=0`, rc 0,
no SCRIPT ERROR. The test covers every row of every table above, the floors/clamps, elbow_thumb = 0 while disabled, and Ludo's worked
example: 4 pips -> mandatory inspection true; stoppage_chance(4, ["swab"]) == 0.50; wave_on(true, 4) -> scar_level 2 and scar_cut_mult(2) == 1.75.
In the PR description list 3 mutants with the FAIL count each: (a) swab 0.20 -> 0.10, (b) L2 cut_mult 1.75 -> 1.5, (c) reductions
multiplied instead of subtracted.

## The one trap
Ludo's table says "(Punch Power - Defense) * 0.40%" - that is 0.004 per point as a fraction, NOT 0.40. Fractions everywhere (0.35, not 35).
