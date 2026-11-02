# ROUND 2 (S286, Claude) - read this first
Round 1 (9a52acec) COLLECTED on master by diff: creation_root + gym_step_layout_s238 green both arms, and the BACK fix in
CreationRoot.gd. One more test, same cause (stripped_start / empty_gym_start under `-- as_game`), red on master before round 1 too:
`creation_api_test` as_game -> `ERROR: C14 FAIL: preview floor exactly matches final Career floor`. Plain arm green.
Do: the same method as round 1 (verdict a/b/c per FAIL, never guard a check away) for Godot/tests/creation_api_test.gd; OWNS adds
that file. RESULT lines: creation_api_test both arms, plus creation_root_test and gym_step_layout_s238_test still green both arms.

---

# TASK ASGAMERED9 - creation_root_test + gym_step_layout_s238_test are red under `-- as_game` (green plain)

Model: Cursor (cloud, label `cursor`). Discipline: BOXING (demo) - the new-career flow every player walks first.
Merge origin/master first (AUTOFILL2 e9a1bbe2 landed S286: four Ludo layouts, GymPlanEditor, chooser on the gym step).

Found S286 (Claude, PC, master a57513ef and e9a1bbe2 - red on both, so NOT caused by AUTOFILL2). Plain arm: both green.
`-- as_game` FAIL lines:

creation_root_test (15 FAIL):
```
FAIL: the country frame draws all three steps, ahead as well as behind
FAIL: the city frame draws all three steps, ahead as well as behind
FAIL: the gym frame draws all three steps, ahead as well as behind
FAIL: the strip lights the step the flow is actually on: [1, 1, 2]
FAIL: the market board draws one card per market: { "step": "country", ..., "markets": 175, "cities": 0, "cards_drawn": 0, ... }
FAIL: the board's one gold is illegal until a market is selected
FAIL: selecting a market arms the gold
FAIL: CHOOSE MARKET commits and moves to the city
FAIL: the market is on the trail: [{ "label": "MARKET", "value": "Cyprus" }, { "label": "CITY", "value": "Nicosia" }]
FAIL: the city board draws one card per city
FAIL: and its gold is illegal until a city is selected
FAIL: the gym board draws the starter take: { "step": "gym", ..., "cards_drawn": 0, "take_roster": 0, "take_used_space": 36, "refusal": "NO SAVE SLOT IS ARMED  ·  START A NEW CAREER FROM THE TITLE", ... }
FAIL: the saved floor is the floor the preview drew
FAIL: the people in the take are the people on the roster: []
FAIL: the previewed floor space is the saved floor space
```
gym_step_layout_s238_test:
```
FAIL @0.826 FLOOR USED tile '' == strip '333 / 540 M2'
FAIL @0.826 Mara's stats are built
FAIL @1.000 FLOOR USED tile '' == strip '333 / 540 M2'
FAIL @1.000 Mara's stats are built
```

Likely (check, do not assume): the as_game start is the QUICK start (`CreationChrome.gd:94` - two steps "THE COUNTRY", "THE GYM"
when quick), the market step is a globe (no market cards), and the as_game gym is the EMPTY SHELL with no roster (S277). Read each
switch's comment in `Godot/scripts/GameSwitches.gd` (quick start / empty_gym_start / globe / one_top_bar) before calling a check
"by design".

## Do
1. Run both tests `-- as_game` and plain; copy the FAIL lines.
2. Per FAIL decide (a) the GAME is wrong (fix it, file:line), (b) the test needs a fixture the as_game route has (armed save slot,
   a drawn gym), or (c) the test pins a replaced design - port its as_game arm to what the player now sees (the quick 2-step strip,
   the globe pick, the shell's empty roster), citing the switch and the operator ruling quoted in GameSwitches.gd.
3. Never delete a check, never loosen a bound, never wrap a check in `if not as_game` to skip it; a check with no new-design
   equivalent moves to the plain arm only, with a comment naming the switch. "NO SAVE SLOT IS ARMED" on the as_game arm is a
   fixture gap (b) unless the game itself refuses a real player - say which.
4. Both tests green plain AND as_game.

## Contract
OWNS: Godot/tests/creation_api_test.gd, Godot/tests/creation_root_test.gd, Godot/tests/gym_step_layout_s238_test.gd
RED_TEST: Godot/tests/creation_root_test.gd -> creation_root_test: <n> checks, 0 failure(s)
REGRESSION: creation_root_test, gym_step_layout_s238_test, gym_preset_autofill_test, gym_plan_editor_test, creation_api_test
VISUAL: no

Game-code changes outside OWNS only for a verdict (a), with file:line and the reason in the PR body. `GameState.gd` is huge:
grep + `sed -n` windows only.

## Prior research
research/ASGAMERED6_AUDIT_S281.md (how earlier as_game verdicts were decided), TASK_ASGAMERED8.md (same method),
research/TASK_NEWCAREER2.md, research/TASK_AUTOFILL2.md, research/GDSCRIPT_TRAPS.md.

## What would a human do?
Start a new career in the game build, watch which screens appear in which order, and make the test walk exactly that route.

## Prefab check
None - project tests.

## The one trap
A green test that can no longer go red is a FAIL of this task (earlier rounds guarded checks with `if not as_game` - never taken).

## Output
PR from cursor/issue-<n>. Body: one row per FAIL (verdict a/b/c, change, file:line), then for EACH test both arms:
`RESULT: tests/creation_root_test.gd -> <its pass line>` and `RESULT: tests/gym_step_layout_s238_test.gd -> <its pass line>`
(once plain, once `-- as_game`). Zero SCRIPT ERROR lines.
Run one: `godot --headless --path Godot --script tests/<name>.gd -- as_game` (and without `-- as_game`).
