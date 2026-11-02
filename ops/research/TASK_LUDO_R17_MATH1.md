# TASK LUDO-R17-MATH1 - four approved design picks as pure modules + data (Ludo round 17 sections 1-4) (cloud seat)

Operator S188 (board Q-S188-2/3): "yes all picks" (SHOUT1, REFEREE1, WEAR1, CUTSCAR1 among them). Ludo's build-ready design:
`research/LUDO_ROUND17_S193.md` SECTIONS 1-4 - read them whole; every number is his and his code is the reference. This task is ONLY
the four pure modules, their JSON tables and one test; wiring comes later behind switches that default OFF.

## Owned files
- `Godot/assets/data/apron_shouts.json` + `Godot/scripts/rules/ApronShouts.gd` (NEW) - Ludo SECTION 1 (his `Shout1`): renamed class.
- `Godot/assets/data/referee_styles.json` + `Godot/scripts/rules/RefereeStyle.gd` (NEW) - Ludo SECTION 2 (his `Referee1`).
- `Godot/assets/data/career_wear.json` + `Godot/scripts/rules/CareerWear.gd` (NEW) - Ludo SECTION 3 (his `Wear1`).
- `Godot/assets/data/cut_scar.json` + `Godot/scripts/rules/CutScar.gd` (NEW) - Ludo SECTION 4 (his `CutScar1`).
- `Godot/tests/ludo_r17_math1_test.gd` (NEW) - extends SceneTree, prints `LUDO_R17_MATH1_TEST FAILS=<n>`, quit(1) on any fail.
- `AgentComms/messages/*` (your done note)
Every module: `extends RefCounted`, static funcs only, no nodes, no RNG (rolls are parameters), NO preloads of game scripts; it reads its
own JSON table (cache it in a static var, like `Godot/scripts/PromoterTrap.gd`); NO number in code that is in the table (a JSON edit must
change behaviour - the test proves one such edit per module). Ludo's `run_tests()`/`assert()` cases move into the test file. Use
`class_name` only if a repo-wide grep shows no collision; otherwise load by path in the test.

## Prior research
House style: `Godot/scripts/PromoterTrap.gd` + `Godot/tests/promoter_trap_test.gd`. Composure bands (Focused/Rattled/Shaken/Broken) are
in `Godot/assets/data/composure.json` - SECTION 1's composure multiplier must use THOSE band names; do not invent new bands.

## What would a human do?
Put Ludo's tables in JSON, one pure function per rule, test every number and every worked example he gave.

## Prefab check
N/A - our own rules.

## Acceptance (the test, from Ludo's numbers - not from your code)
- Every assertion in Ludo's four `run_tests()` becomes a `_check` with the numbers in its message.
- Plus per module: SHOUTS - 3 per round, the cooldown blocks a 4th, success chance = his formula for two worked inputs (one Focused,
  one Broken fighter); REFEREE - each style moves the stoppage risk / clinch-break time / deduction as his table says (one case each);
  WEAR - accumulation from a war, a hard spar and a knockdown matches his table; 'spent' gives his chin penalty; it never decays below his
  floor; CUT SCAR - towel = purse lost, no trait; push on = trait 'cut_prone'; future cut risk with the trait = his number.
- One JSON-edit case per module (change one table value in a loaded copy -> the function's output changes).
Mutants (each must FAIL; report FAIL counts in the PR): (a) shouts per round 3 -> 4, (b) a referee style's stoppage multiplier set to 1.0,
(c) wear knockdown cost halved, (d) cut_prone risk multiplier set to 1.0.
Run: parse each new .gd (`--headless --path Godot --check-only --script res://scripts/rules/<file>.gd`), then
`--headless --path Godot --script tests/ludo_r17_math1_test.gd` -> `LUDO_R17_MATH1_TEST FAILS=0`, no SCRIPT ERROR, no engine ERROR line.
Push your branch, open a PR into master, never merge it, never touch other files, never delete or weaken an existing test.

Model: cloud Qwen (qwen3-coder). Tier: new files only - parse + this test.

## The one trap
Ludo's text wraps numbers in LaTeX (`$0.35$`) - read the number. Godot JSON numbers are floats: compare with an epsilon.
