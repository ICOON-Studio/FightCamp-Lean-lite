# TASK GAMETREE1-A (stage 1) - Goose (S386; Grok Dev's gateway refused sends)

Model: Goose on GOOSE_QWEN_MODEL. Discipline: no-gi BJJ (ships with boxing, operator S353).

FIRST COMMAND: `git fetch origin claude/gametree1 && git merge --no-edit FETCH_HEAD` (the stage-1 work lives on that
branch; it merges clean onto main). Commit on your current branch; the job opens the PR. Claude reviews and merges.
Godot 4.7.2, headless only: `godot --headless --audio-driver Dummy --path . --script res://tests/<t>.gd`.
Run one `godot --headless --import` first (no .godot folder in a fresh clone).

## What exists (built in S384, NEVER run in Godot)
Read these on the branch first, in this order:
1. `ops/research/GAMETREE1_PLAN_S384.md` - the step-by-step plan (steps 0-11).
2. `ops/research/GAMETREE1_TUNING_S384.md` - the tuning bars (draft).
3. `ops/research/GAMETREE1_DESIGN_S384.md` sections 9-10 - the spec.
Code already written: scripts/rules/BjjTree.gd, BjjOpp.gd, BjjWalk.gd, BjjOpen.gd, assets/data/bjj_tree.json,
Grapplers opens on the tree, week-report paths/arrows/leak drill/roll line, Ana's one-page Playbook (MatTree centre),
tests bjj_tree_test, bjj_tree_odds_test, bjj_tree_ui_test. Last commit before the plan (3ebb2206) = UNRUN WIP of
tools/bjj_tree_balance.gd + tests/bjj_tree_sim_test.gd.

## Your job
1. Make it parse and run: `tests/bjj_tree_test.gd`, `tests/bjj_tree_odds_test.gd`, `tests/bjj_tree_ui_test.gd`,
   `tests/bjj_tree_sim_test.gd`. Fix every SCRIPT ERROR / FAIL in the new code (never weaken an assert to pass - if an
   assert is wrong against the spec, say which and why in the PR body).
2. The whole suite: `sh tools/run_tests.sh` (JOBS=4 is fine on your box). Every test that passes on `main` must pass on
   your branch. Add the four bjj_tree tests to tools/run_tests.sh's TESTS list if missing.
3. Tune: run `tools/bjj_tree_balance.gd` and move only the constants the TUNING doc names until its bars pass; write
   the before/after numbers into GAMETREE1_TUNING_S384.md.
4. Files that must end with an EMPTY diff vs origin/main: scripts/rules/NoGi.gd, BeltRoad.gd, TheRead.gd, OppFile.gd,
   OwnCombos.gd, BjjSide.gd, BjjFilm.gd, GroundRules.gd, scripts/grapple/*, scripts/fight3d/*.
5. Rules: no script over 500 lines; no he/she/his/her in player-facing strings (no_pronoun_test); GDScript traps in
   ops/research/GDSCRIPT_TRAPS.md (Variant `:=`, `%%`, reused names).

## PR body must carry
- `RESULT: tests/<x>_test.gd -> <exact pass line>` for each of the four bjj_tree tests.
- `SUITE: <n>/<n> passed` from tools/run_tests.sh, and the names of any test red on main too (if any).
- The tuning table (constant, old, new, bar, measured).
- A list of every file you changed and why in one line each.

## The one trap
The exit code alone is not a pass: a test fails on any SCRIPT ERROR line, its own FAIL line, or no output.
rc 124 / a hang = a parse error somewhere - run `godot --headless --check-only --script <file>` on what you touched.

## Contract
Added S392, after GAMETREE1 stage 1 ended in S386 (14 of 21 bars pass, 7 unmet). It records what that work owned; it reruns nothing.
OWNS: tests/bjj_tree_test.gd, tests/bjj_tree_odds_test.gd, tests/bjj_tree_sim_test.gd, tests/bjj_tree_ui_test.gd
RED_TEST: tests/bjj_tree_sim_test.gd
REGRESSION: bjj_tree_test, bjj_tree_odds_test, bjj_tree_sim_test, bjj_tree_ui_test
VISUAL: no
