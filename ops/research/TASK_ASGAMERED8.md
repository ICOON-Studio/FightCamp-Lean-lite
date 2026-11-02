# TASK ASGAMERED8 - the last three ASGAMERED6 rows: focus_card, day_feed_wire_fit, build_single_piece under `-- as_game`

Model: Qwen (cloud, label `qwen`, .github/workflows/cloud-agent.yml). Discipline: BOXING (demo).
Merge origin/master first. Rows 1/2/4/5/6 of the ASGAMERED6 audit are done (research/ASGAMERED6_AUDIT_S281.md, S282-S284
verdict tables). Three rows were never reached - each is red, or suspected red, in the GAME arm (`-- as_game`), green plain:

| Row | Test | What the earlier agent claimed under as_game | First question to answer |
|---|---|---|---|
| 3 | focus_card_test | station focus stays empty | Does a station's focus card do anything on the as_game start? The test seeds a roster with DevJump after `finalize_new_career`; does it also need `game_state.dev_built_gym()` (the as_game start is the EMPTY SHELL - no stations), or is the focus card itself broken? |
| 7 | day_feed_wire_fit_test | DayFeedPanel ('Wire' node) not mounted on HOME | Under the S275 one top bar (`one_top_bar`, `gym3d_main` in GameSwitches.gd) HOME is the full-screen 3D gym, not the day-feed cards. If BY DESIGN, the as_game arm builds the DayFeedPanel the way the test's own headless fallback does and still checks the wire fit; the S166 overlap check must stay able to go red. |
| 8 | build_single_piece_test | "shell lacks zones even after dev_built_gym" (S279 FAIL: `a free spot on the floor is found ((inf, inf))`) | S278 operator rule: the player DRAWS the training-floor zone first, then places single pieces on it. The as_game arm must draw a training floor through BuildMode (the same entry the BUILD window uses) before buying. If `dev_built_gym()` promises every zone and does not restore them, that fixture is broken - say so with file:line. |

Read each switch's comment in `Godot/scripts/GameSwitches.gd` (one_top_bar, gym3d_main, empty_gym_start, no_interrupts) before
deciding a check is "by design".

## Do
1. For each test run it `-- as_game` and plain, copy the FAIL lines. Decide (a) the GAME is wrong (fix the game, name file:line),
   (b) the test needs the built gym / a drawn floor (fixture), or (c) the test pins a replaced design (port its as_game arm, citing
   the switch and the operator ruling quoted in GameSwitches.gd).
2. Never delete a check, never loosen a bound, never wrap a check in `if not as_game` to skip it; a check with no new-design
   equivalent moves to the plain arm only, with a comment naming the switch.
3. Every test green plain AND as_game.

## Contract
OWNS: Godot/tests/focus_card_test.gd, Godot/tests/day_feed_wire_fit_test.gd, Godot/tests/build_single_piece_test.gd
RED_TEST: Godot/tests/build_single_piece_test.gd -> BUILD_SINGLE_PIECE failures=0
REGRESSION: one_top_bar_test, dev_jump_test, focus_card_test, day_feed_wire_fit_test, build_single_piece_test
VISUAL: no

Game-code changes outside OWNS are allowed only for a verdict (a), with file:line and the reason in the PR body. Do NOT touch
Godot/scripts/club_rooms/BuildMode.gd, Godot/scripts/rules/GymLayoutRules.gd, Godot/scripts/rules/GymPresetRules.gd,
Godot/scripts/creation/* or Godot/scripts/CreationFlowPanel.gd - another agent owns them right now (AUTOFILL2); if the fix needs
them, stop and say so in the PR. `GameState.gd` is huge: grep + `sed -n` windows only.

## Prior research
research/ASGAMERED6_AUDIT_S281.md (all verdicts so far, and how each was decided), TASK_ASGAMERED6.md, TASK_ASGAMERED5.md (first
FAIL lines), S277 commits 3013afbd / 42710b57 (the empty shell, dev_built_gym), S278 25101df4 / 78d15fb6 (draw the zone, then
single pieces), research/GDSCRIPT_TRAPS.md.

## What would a human do?
Play the as_game start in their head: empty lot, draw a training floor, buy a bag, click its focus. Each test should walk that same
route instead of assuming the old pre-built gym.

## Prefab check
None - project tests.

## The one trap
Earlier rounds (Goose #315) "fixed" these by guarding checks with `if not as_game` - none of that was taken. A green test that can
no longer go red is a FAIL of this task.

## Output
PR from qwen/issue-<n>. Body: one row per test (verdict a/b/c, change, file:line), then for EACH test both arms:
`RESULT: tests/build_single_piece_test.gd -> BUILD_SINGLE_PIECE failures=0`
`RESULT: tests/focus_card_test.gd -> FOCUS_CARD failures=0`
`RESULT: tests/day_feed_wire_fit_test.gd -> WIREFIT day feed wire fit: <n> checks, 0 failures`
(once plain, once `-- as_game`). Zero SCRIPT ERROR lines.
Run one: `godot --headless --path Godot --script tests/<name>.gd -- as_game` (and without `-- as_game`).
