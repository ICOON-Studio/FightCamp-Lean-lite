# TASK ASGAMERED4 - the as_game arm is red across 39 career/gym tests: find the common cause first

Model: Goose (cloud, long task). Discipline: BOXING (demo).
Measured S277 (Claude): every test below passes PLAIN and fails `-- as_game` on master - also on the pre-S277 baseline, so it is
not the S277 shell. 31 of them seed their career through `scripts/DevJump.gd`; dev_jump_test as_game fails with
"booked replay finds an eligible real bout: NO ROSTER ATHLETE COULD BOOK WEEK 22", and the S276 loop probe's DevJump seed failed the
same way ("NO -75 KG OPPONENT ON THIS CARD - NIKO PARK FIGHTS AT -75 KG, THE OPEN SLOT IS AT FLYWEIGHT"). That is the first suspect.
`GameState.gd` and `FightRealtime.gd` are huge: grep + `sed -n` windows only, never read them whole.

## The tests
boxing_start_roster_test, candidate_card_test, coach_assignment_test, day_feed_wire_fit_test, dev_jump_test, equipment_market_filter_test, fighter_card_test, focus_card_test, gym_club_ring_routes_test, gym_hall_ring_steps_test, gym_hub_panel_test, gym_hub_test, gym_market_slice_two_test, gym_market_test, gym_menu_test, gym_wing_test, next_up_priority_test, office_former_test, office_hub_panel_test, scene_router_test, schedule_hub_panel_test, schedule_my_gym_test, scouting_hub_panel_test, setpiece_api_test, setpiece_panels_test, setpiece_root_test, spar_block_floor_test, staff_hub_panel_test, station_move_picker_test, story_campaign_game_test, story_card_test, story_inbox_panel_test, story_wall_panel_test, timeline_bar_test, timeline_clock_test, training_hub_panel_test, tutorial_guide_test, week_presets_test, weigh_scale_test.
Run one: `Godot_v4.7.2-stable_win64.exe --headless --path Godot --script tests/<name>.gd -- as_game`.
Several runs at once: `python Godot/tools/run_tests.py --jobs 2 --as-game --only <comma list>` (40 names max per call).

## Do
1. ROOT CAUSE FIRST: run dev_jump_test as_game, trace why no roster athlete can be booked under the game switches (GameSwitches.GAME_ON
   - read the switch comments; S277 also made a NEW career an empty shell: GameState.dev_built_gym() turns it back into the built
   starter gym and DevJump already calls it). Fix the GAME if the game is wrong (a booking that can never succeed IS a defect: the
   player meets it too), else port the seed. Write the cause in the PR body with file:line.
2. Re-run all 39 as_game; for each still red: (a) a game defect -> fix it, or (b) the test pins a replaced design -> port its
   as_game arm citing the switch + the operator ruling in GameSwitches.gd. Never delete a check, never loosen a bound; a check with no
   new-design equivalent moves to the plain arm only, with a comment.
3. Every test green plain AND as_game. PR body: the root cause, then one row per test (cause, change, RESULT line both arms).

## Contract
OWNS: Godot/scripts/DevJump.gd, Godot/tests/boxing_start_roster_test.gd, Godot/tests/candidate_card_test.gd, Godot/tests/coach_assignment_test.gd, Godot/tests/day_feed_wire_fit_test.gd, Godot/tests/dev_jump_test.gd, Godot/tests/equipment_market_filter_test.gd, Godot/tests/fighter_card_test.gd, Godot/tests/focus_card_test.gd, Godot/tests/gym_club_ring_routes_test.gd, Godot/tests/gym_hall_ring_steps_test.gd, Godot/tests/gym_hub_panel_test.gd, Godot/tests/gym_hub_test.gd, Godot/tests/gym_market_slice_two_test.gd, Godot/tests/gym_market_test.gd, Godot/tests/gym_menu_test.gd, Godot/tests/gym_wing_test.gd, Godot/tests/next_up_priority_test.gd, Godot/tests/office_former_test.gd, Godot/tests/office_hub_panel_test.gd, Godot/tests/scene_router_test.gd, Godot/tests/schedule_hub_panel_test.gd, Godot/tests/schedule_my_gym_test.gd, Godot/tests/scouting_hub_panel_test.gd, Godot/tests/setpiece_api_test.gd, Godot/tests/setpiece_panels_test.gd, Godot/tests/setpiece_root_test.gd, Godot/tests/spar_block_floor_test.gd, Godot/tests/staff_hub_panel_test.gd, Godot/tests/station_move_picker_test.gd, Godot/tests/story_campaign_game_test.gd, Godot/tests/story_card_test.gd, Godot/tests/story_inbox_panel_test.gd, Godot/tests/story_wall_panel_test.gd, Godot/tests/timeline_bar_test.gd, Godot/tests/timeline_clock_test.gd, Godot/tests/training_hub_panel_test.gd, Godot/tests/tutorial_guide_test.gd, Godot/tests/week_presets_test.gd, Godot/tests/weigh_scale_test.gd
RED_TEST: Godot/tests/dev_jump_test.gd -> as_game arm green
REGRESSION: one_top_bar_test, top_bar_timeline_test, ring_purchase_test
VISUAL: no

## Prior research
TASK_ASGAMERED1.md (4f52e822), ASGAMERED2/3 (in flight, Cursor #309/#310 - do not touch their files), S277 commits 3013afbd / 42710b57
(the shell, dev_built_gym), GDSCRIPT_TRAPS.md.

## What would a human do?
When forty tests fail the same way, find the one thing they share before touching any of them.

## Prefab check
None - project tests.

## The one trap
Never green a test by weakening it; game-code changes outside DevJump.gd must be named in the PR body with the reason.

## Output
PR from goose/issue-<n> with the root cause and `RESULT: tests/<x>_test.gd -> <pass line>` for each test, both arms.
