# TASK S289RED1 - six gym BUILD/club tests red on master since S287/S288 (S289, Claude)

Model: Cursor (cloud, label `cursor`). Discipline: BOXING gym (demo) - the BUILD/room flow the player uses every career.
Merge origin/master first (1c9d07d6 S289 ROOMSMGT1 landed: room walls 1.8 m, room floors, furniture x1.3 + flush, BUILD inset 0.1 m,
3-5 pieces per room).

Found S289 (Claude, PC): these six are red on master's own files (checked by swapping master's versions back in; NOT caused by
ROOMSMGT1 - same FAIL lines before and after it). They are newer than the last nightly (2026-10-22 c4dc03a0, all six green there), so a
S287/S288 commit broke them - suspects: 269801a4 (S287 reception area at the entrance, BUILD clicks no longer fall through),
55349101 (S287 BUILD = Life Fitness planner: catalogue right, rail left), e01772bf (S288 AUTO FILL lockers).

FAIL lines (`-- as_game`; * = also red in the plain arm):
```
build_single_piece_test: FAIL a piece has its catalogue price (speed_bag 450) / FAIL a free spot on the floor is found ((inf, inf))
  / FAIL one short: the reason names the price / FAIL enough cash: the piece goes down / FAIL one place bought ()
reception_club_props_test: FAIL room fighter information has a visible backing plate / FAIL counter screen click emits lobby (got )
  / FAIL bell screen click emits lobby / FAIL phone screen click emits story_inbox / FAIL trophy_cabinet screen click emits objectives
reception_street_door_test*: FAIL a locker room over the street door still blocks it (Kept for the reception at the entrance)
room_draft_flow_test*: FAIL key item placed / FINISH allowed with desk and door / finish commits / room stands in career / cash charged once
room_walls_mgt2_test*: FAIL desk placed / door accepted on the free north edge, a little off the line / door stored ON the wall edge ([])
  / FINISH allowed with desk and door / reception finishes / door refused on the shared wall
gym_club_3d_test: FAIL far: the camera reaches its pose (52.238 m off) / far: pitch 35.26 vs data 60.00 / far: roof on / ... mid ...
```

## Prior research
`python Tools/prior_research.py reception entrance build planner` - S287 digest (reception area reserved at the entrance: a floor into it
is refused - gym_build_input_test was moved clear of it in S288), S285 MGT2 drawn rooms (door is step 1 of the draft), S245 CAMFOV17
(the iso camera's FOV 17 + TPM poses replaced the old far/mid pitch numbers).

## What would a human do?
Bisect: run each test on 269801a4^ and 269801a4 (and 55349101) to find the commit that turned it red, read that commit's diff, then
decide per FAIL whether the GAME regressed (fix the game) or the test asks for a rule the operator changed (update the test to the new
rule, quoting the commit/operator line that changed it).

## Prefab check
None - existing game code and tests only.

## Do
1. For each test: copy its FAIL lines both arms, find the breaking commit (bisect), write a verdict per FAIL: (a) game bug -> fix the
   game; (b) the test encodes a rule that changed on purpose -> update the test to the new rule and cite why; (c) test setup stale (e.g.
   a draft drawn inside the reserved reception area) -> move the setup, never delete the check.
2. Never guard a check away, never lower a bound, never delete a test or a check.
3. Run all six both arms (`python Godot/tools/run_tests.py --jobs 2 [--as-game] --only <the six>`), plus regression
   `room_look_mgt2_test,shell_member_visit_test,gym_build_input_test,shell_walk_in_test` both arms.

## Contract
OWNS: Godot/tests/build_single_piece_test.gd, Godot/tests/reception_club_props_test.gd, Godot/tests/reception_street_door_test.gd, Godot/tests/room_draft_flow_test.gd, Godot/tests/room_walls_mgt2_test.gd, Godot/tests/gym_club_3d_test.gd, Godot/scripts/club_rooms/BuildMode.gd, Godot/scripts/rules/RoomDraftRules.gd, Godot/scripts/GymClubLayout.gd
RED_TEST: Godot/tests/room_draft_flow_test.gd -> ROOM_DRAFT_FLOW failures=0
REGRESSION: room_look_mgt2_test, shell_member_visit_test, gym_build_input_test, shell_walk_in_test
VISUAL: no

## PR body
One `RESULT: tests/<name>.gd -> <pass line>` per test per arm, the breaking commit per test, and the a/b/c verdict per FAIL.
