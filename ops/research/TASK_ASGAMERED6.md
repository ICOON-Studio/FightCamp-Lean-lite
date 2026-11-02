# TASK ASGAMERED6 - round 3: the last 12 tests still red as_game

Model: Goose (cloud, long task). Discipline: BOXING (demo).
Round 2a (goose/issue-312, commit 6451eadb) is COLLECTED on master S279 (a35bbc8b): candidate_card, coach_assignment,
equipment_market_filter, gym_hub_panel, gym_market, gym_wing are green in both arms. Merge origin/master first.
STILL RED as_game (first FAIL lines are in TASK_ASGAMERED5.md; build_single_piece_test is new - measured S279 on master:
"FAIL a free spot on the floor is found ((inf, inf))" - the empty shell has no drawn training floor; S278 rule: the player DRAWS the
training floor zone first, then places single pieces on it, so the as_game arm must draw one through BuildMode before buying):
- focus_card_test
- gym_club_ring_routes_test
- gym_hall_ring_steps_test
- gym_market_slice_two_test
- day_feed_wire_fit_test
- gym_menu_test
- next_up_priority_test
- scene_router_test
- office_hub_panel_test
- schedule_my_gym_test
- schedule_hub_panel_test
- build_single_piece_test

Their common thread is NOT DevJump: most of them build a career with `finalize_new_career` (S277: under as_game a new career is the
EMPTY SHELL - no roster, no staff, no stations, no ring; `GameState.dev_built_gym()` turns it back into the built gym) or pin a screen
that a GAME_ON switch replaced (one_top_bar, no_interrupts, day_plan_on_demand, hud_topbar, gym3d_main - read each switch's comment
in `Godot/scripts/GameSwitches.gd`).

## Do
1. For each test: run it `-- as_game` and plain. Decide (a) the GAME is wrong (fix the game, name file:line in the PR body),
   (b) the test needs the built gym (call `game_state.dev_built_gym()` right after `finalize_new_career`, like day_clock_test does),
   or (c) the test pins a replaced design (port its as_game arm, citing the switch and the operator ruling in GameSwitches.gd).
2. Never delete a check, never loosen a bound; a check with no new-design equivalent moves to the plain arm only, with a comment.
3. Every test green plain AND as_game. PR body: one row per test (cause a/b/c, change, RESULT line both arms).

## Contract
OWNS: Godot/tests/focus_card_test.gd, Godot/tests/gym_club_ring_routes_test.gd, Godot/tests/gym_hall_ring_steps_test.gd, Godot/tests/gym_market_slice_two_test.gd, Godot/tests/day_feed_wire_fit_test.gd, Godot/tests/gym_menu_test.gd, Godot/tests/next_up_priority_test.gd, Godot/tests/scene_router_test.gd, Godot/tests/office_hub_panel_test.gd, Godot/tests/schedule_my_gym_test.gd, Godot/tests/schedule_hub_panel_test.gd, Godot/tests/build_single_piece_test.gd
RED_TEST: Godot/tests/schedule_hub_panel_test.gd -> as_game arm green
REGRESSION: one_top_bar_test, ring_purchase_test, dev_jump_test, room_unlock_wire_test
VISUAL: no

## Prior research
TASK_ASGAMERED4.md + its collected commit (S278), TASK_ASGAMERED1.md (Cursor, gym floor HUD tests, collected S278), S277 commits
3013afbd / 42710b57 (the shell, dev_built_gym), research/GDSCRIPT_TRAPS.md.

## What would a human do?
Sort the failures into "game wrong", "needs the built gym" and "pins an old screen" before fixing any one of them.

## Prefab check
None - project tests.

## The one trap
Never green a test by weakening it. Game-code changes need file:line and the reason in the PR body. `GameState.gd` is huge: grep +
`sed -n` windows only.

## Output
PR from goose/issue-<n> with `RESULT: tests/<x>_test.gd -> <pass line>` for each test, both arms.
Run one: `Godot_v4.7.2-stable_win64.exe --headless --path Godot --script tests/<name>.gd -- as_game`.
