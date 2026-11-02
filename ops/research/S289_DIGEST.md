# S289 DIGEST (2026-10-23) - ROOMSMGT1: the front rooms read like MGT2 (all four steps built)

## Operator asks this session (verbatim)
- `git pull && python Tools/agent_comms.py start` (resume from roadmap now: ROOMSMGT1, approved S288 Q-S277-9 "build all four steps
  (walls 1.8 m, room floors, furniture x1.3, flush pieces)").

## What now works (evidence)
1. RED FIRST: `tests/room_look_mgt2_test.gd` (-- as_game; stands down in the switches-off arm) on the FULL build (gym-step preset,
   five rooms) on the real club scene: 22/34 FAIL on master (partitions 2.60, room outer walls 3.60, no room floor tone, true-scale
   pieces, desk 1.36 m and counter 0.56 m off any wall, counter facing +x not the street door). Now 47/47 (1c9d07d6).
2. STEP 1 WALLS: `GymClub3D.PART_H` 2.60 -> 1.80; new `FRONT_H` 2.20 for the building's outer walls along a drawn room
   (`_along_drawn_room`); the hall's own walls and the bag wall keep 3.60. The drawn-room door frame was 2.20 m and stood 0.4 m proud
   of the 1.8 m wall on the still - `ClubRoomDoor.FRAME_H/OPENING_H` 1.80/1.70.
3. STEP 2 FLOORS: each floor shader takes `base_color` (office walnut #6b4a32, reception slate #5d6670, physio turquoise #6cc7bd,
   store concrete #9a968c, lockers blue tile #3a74b0 - new `locker_floor.gdshader`), set from `gym_club.json rooms.<id>.drawn_floor`
   by `ClubRoomBase.drawn_floor(..., row)`. Neighbour rgb distances 0.27-0.49; on the still the five rooms read as five colours.
4. STEP 3 SCALE: drawn-room pieces x1.3 wide/deep, x1.15 high (`GymClubLayout.DRAWN_PIECE_SCALE`). DECIDED on the still: height
   capped at the 2.2 m outer wall (`drawn_height_factor`) - x1.15 made the store's 2.88 m shelving 3.3 m and it hid the physio room.
5. STEP 4 FLUSH + LIMITS: `GymClubLayout.flush_pieces` (in `_apply_built_rooms`, so render, walk-in and tests read one spot): a
   piece's back (local +Z turned by its yaw) goes on the wall behind it when within 1.5 m, from its measured `foot`
   (`tools/measure_room_feet.gd`, game dressing path) at the x1.3 scale; `stand_behind` 0.9 m for desk and counter; the physio
   table is `mid_room` (Ludo). AUTO FILL reads `drawn_at`/`drawn_yaw` (shell only - the fixed rooms keep their data): counter turned
   to face the street door, back on the hall wall. BUILD: item inset 0.5 -> 0.1 m, 3-5 pieces per room
   (`RoomDraftRules.ROOM_PIECE_LIMITS`). Walk-in `desk_front` = the counter's front (the member checks in on the street side).
6. MemberWalker heading from the walk direction - `look_at` took a local floor point as a global target and failed on the visit.
7. Regression both arms green: shell_member_visit, gym_preset_autofill, gym_build_input, reception_desk, member_cap_read, walk_ins,
   shell_walk_in (its desk check now follows the flushed desk).
8. Stills on the game camera (docs/previews/s289_rooms: step1, step2, step3_4, visit) on the board; approval Q-S277-11 with the
   still attached. OPEN until his OK.
9. BOUTREPEAT1 was already on master (ededc0f3, S288) - `start`'s COLLECT NOW line was stale; run archived.

## Found, not fixed
- Six tests red on master since S287/S288 (checked by swapping master's own files back - same FAILs without ROOMSMGT1, all six green
  in the 10-22 nightly): build_single_piece, reception_club_props, reception_street_door, room_draft_flow, room_walls_mgt2,
  gym_club_3d. Briefed TASK_S289RED1, Cursor issue #344 running.
- The first fast-tier nightly (S288 change) had not run yet at session time - check it next session.
- Ziva worktree (wt/ZIVA, ziva/playtest) is 156 commits behind master: `merge origin/master` refuses - untracked files in the worktree that master now tracks (e.g. Godot/tests/hit_feel_wire_test.gd). Editor restarted on its current tree (7012 up). Next session: list them, ask Ziva or move them to wt_salvage, then merge.

## Next (decision)
On his OK of Q-S277-11: Ludo's new hero pieces (L-counter, vending block, solid-back racks) through Ludo 3D or the catalogue (licence
named), placed with the flush rule. Collect Cursor #344 (S289RED1) when it lands. Q-S277-10 (bike clip US$3) waits on him.

## HANDOFF
commits 1c9d07d6 (ROOMSMGT1) + S289RED1 brief pushed. In flight: Cursor #344 S289RED1; John GYMCLIPS2 part 2 (seat queue); Ziva editor restarted.
