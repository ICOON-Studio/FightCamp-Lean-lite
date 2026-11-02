# TASK ASGAMERED5 - round 2: the as_game arm is still red on most of the ASGAMERED4 list

Model: Goose (cloud, long task). Discipline: BOXING (demo).
Round 1 (goose/issue-311, ASGAMERED4) is COLLECTED on master (S278): `GameState.dev_built_gym()` now restores the starter roster and
staff and turns the level ladder off for the dev seed; `boxing_start_roster_test` got an as_game arm. dev_jump_test is green as_game
(171 checks). Measured S278 by Claude on master + that commit, `run_tests.py --jobs 2 --as-game`: the tests below are STILL RED
as_game. The first failure of each (from its log):

- coach_assignment_test: "C10 FAIL: per-coach capacity names the refusal", "staff board counts assigned fighters"
- candidate_card_test: "the guide is up on the scouting screen (as a pill - the plate is HOME only)"
- equipment_market_filter_test: "All shows every store-available catalogue item", "Wrestling shows real wrestling-tagged ... only"
- focus_card_test: "key 1 selects power_shots (focus=)", "row 1 shows selected after key 1"
- gym_club_ring_routes_test: "upgrades still greyed" (prints FAIL, exits 0)
- gym_hall_ring_steps_test: "walking in the scene he climbs (highest 0.00 m)"
- gym_hub_panel_test: "the store lists every store-available piece (74)", "ALL shows all of them"
- gym_market_slice_two_test: "the rival's refit lowers the player's target (0 -> 0)", "the weekly settlement walks members away (0 -> 0)"
- gym_market_test: SCRIPT ERROR "Out of bounds get index '0' (on base: 'Array')"
- gym_wing_test: SCRIPT ERROR "Invalid access of index '0' on a base object of type: 'Array'"
- day_feed_wire_fit_test: "WIREFIT FAIL: HOME hosts a DayFeedPanel", "HOME shows On the wire"
- gym_menu_test: "OFF: no street door, ledger or board", "the office pin still opens the office room"
- next_up_priority_test: "ON/beside: NEXT UP is the story promise (kind BOOK ...)", "the story line names its card"
- scene_router_test: "THE DAY mounts as the content child", "the content draws above the shell"
- office_hub_panel_test: "OFFICE > PROMOTIONS names the belts on every row"
- schedule_my_gym_test: "SCHED1 FAIL: ON: MY GYM then LADDER lead the eight tabs"
- schedule_hub_panel_test: "the hub opens on MY MONTH", "the grid is the month C7 returned ()"
(batch B - scouting/setpiece/story/timeline/training/tutorial/week/weigh/daily_progression - is still running on the PC; Claude adds
its reds to the issue as a comment. Fix the list above first.)

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
OWNS: Godot/tests/coach_assignment_test.gd, Godot/tests/candidate_card_test.gd, Godot/tests/equipment_market_filter_test.gd, Godot/tests/focus_card_test.gd, Godot/tests/gym_club_ring_routes_test.gd, Godot/tests/gym_hall_ring_steps_test.gd, Godot/tests/gym_hub_panel_test.gd, Godot/tests/gym_market_slice_two_test.gd, Godot/tests/gym_market_test.gd, Godot/tests/gym_wing_test.gd, Godot/tests/day_feed_wire_fit_test.gd, Godot/tests/gym_menu_test.gd, Godot/tests/next_up_priority_test.gd, Godot/tests/scene_router_test.gd, Godot/tests/office_hub_panel_test.gd, Godot/tests/schedule_my_gym_test.gd, Godot/tests/schedule_hub_panel_test.gd, Godot/scripts/DevJump.gd
RED_TEST: Godot/tests/schedule_hub_panel_test.gd -> as_game arm green
REGRESSION: one_top_bar_test, top_bar_timeline_test, ring_purchase_test, dev_jump_test, boxing_start_roster_test
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
