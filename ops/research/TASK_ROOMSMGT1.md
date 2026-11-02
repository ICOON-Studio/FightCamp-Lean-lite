# TASK ROOMSMGT1 - front rooms read like MGT2 (S288 brief for S289, Claude builds)

Model: Claude (look work on the game camera, stills each step). Discipline: BOXING gym (demo).
APPROVED: operator S288, Q-S277-9: "build all four steps (walls 1.8 m, room floors, furniture x1.3, flush pieces)."
Sources: research/MGT2_ROOMS_VERDICT_S288.md (what he approved), research/LUDO_MGT2_ROOMS_S288.md (Ludo verbatim),
research/MGT2_SCALE_S288.md (measured MGT2 scale), research/TWOPOINT_ALIGNMENT.md (0.5 m grid, 0.4 m cut stub - settled).

## Prior research
The three files above, plus S285 MGT2 walls (`GymClub3D.gd` lines ~106-112: PART_H 2.60, PART_T 0.15, door frame 2.20) and
S267 "side walls down".

## What would a human do?
Change one thing at a time on the same camera, take the same still before and after, and judge it.

## Prefab check
No new models for steps 1, 2 and 4. Step 3 scales the room pieces we already have. New hero pieces (L-counter, vending block,
solid racks) come only after his OK on the scaled set - Ludo 3D or the catalogue, licence named.

## Anchors measured S288 (trace again before editing - big file, sed windows only)
- Room partition height: `GymClub3D.gd` const `PART_H := 2.60` (S285), used in `_build_building` (~line 648: `top_h = PART_H` for
  `_is_partition`). The outer walls use `room["wall_h"]` = 3.6 (`assets/data/gym_club.json` room.wall_h).
- Door frames: a drawn room's door keeps the partition above its 2.20 m frame. With partitions at 1.8 m there is NO band above the
  door, so check the door frame/sign still reads (the band code silently drops it).
- Room floors: `club_look/GymLook2Shell.gd` `_floor_material` (~line 289) dresses ClubZones/Patches by material_id/zone_id; room
  floors may be built elsewhere - trace which node draws a drawn room's floor before step 2.
- Room items: BuildMode `_apply_plan_rooms` (~line 2563) writes `career.club_rooms_built[room].items` {id, furniture, at, yaw};
  the glb/height per furniture comes from `gym_club.json` rooms.<id>.furniture rows (`glb`, `height`, `at`, `yaw`). Placement:
  `place_draft_item` uses `PlacementRules.snap` (0.5 m grid already).

## Do (one step at a time; a still on floor_view after each, same camera; stills via tools/clean_view.gd save_if_clean)
1. WALLS: room partitions 2.60 -> 1.80 m. The building's outer walls ALONG THE FRONT-ROOM RIBBON (the rooms' street-side and side
   walls) 3.6 -> 2.2 m. TRAP: the hall's back wall carries the wall-mounted heavy bags (the arms hang at ~2.3-2.6 m) and the ceiling
   fixtures - it does NOT drop ("ring, bags, hall unchanged"). Camera-facing walls keep the 0.4 m cut stub (ISOWALL1).
2. FLOORS: one distinct floor per drawn room, stopping flush at its door: office dark wood or charcoal carpet; reception slate tile;
   physio clinical light (turquoise/white vinyl); equipment store bare concrete; locker room blue non-slip tile. The blur test: blur the
   still 10 px and the five rooms read as five colours.
3. FURNITURE x1.3 / x1.15: room hero pieces (desk, counter, treatment table, locker banks, racks/shelving, trophy cabinet, bench)
   scale x1.3 in width and depth and x1.15 in height. People and training-floor equipment stay true scale. Footprints for the
   placement checks grow with them (no new overlaps - tools/placement_audit.gd).
4. FLUSH + CLEAR MIDDLE + LIMITS: big pieces snap flush to the nearest wall (0.0 m gap, faces into the room); about 60% of each room's
   floor stays clear; 3-5 pieces per room (office 4, reception 4, physio 3, store 4, lockers 5); small dressing (phone, bell,
   clipboards, first aid box, coat stand) leaves the room list. The AUTO FILL presets and the BUILD draft follow the same rules.

## Test (tier: a script edited -> parse, focused test, then the systems it touches)
- New `tests/room_look_mgt2_test.gd` (-- as_game, stands down in the plain arm like shell_member_visit_test): RED first on master.
  Partition height <= 1.8; front-ribbon outer walls <= 2.2 and the bag wall unchanged; each drawn room's floor material differs from
  its neighbours; room hero items scaled 1.3/1.15 against their data size; every big piece within 0.05 m of a wall; per-room item
  count within its limit; reception counter faces the street door.
- Then: `run_tests.py --jobs 3 --as-game --only room_look_mgt2_test,shell_member_visit_test,gym_preset_autofill_test,gym_build_input_test,reception_desk_test,member_cap_read_test`
  and the same without --as-game.
- PLAYTEST = FULL BUILD (memory feedback_playtest_full_build_s288): tools/s288_member_visit_stills.gd (career hall, all rooms) - a
  member still walks desk -> lockers -> floor through the lowered walls.

## VISUAL GATE (.claude/skills/visual-gate/SKILL.md)
1. First run the gate on master's shipped rooms: room_look_mgt2_test must read RED (partition 2.60 m, true-scale furniture); paste the numbers.
2. Stills only on the game's own camera (floor_view, the career hall) via tools/clean_view.gd save_if_clean: before and after each step.
3. For every still report: wall heights seen / each room's floor colour / furniture size against a member / pieces on the walls / the
   member route still clear (desk -> lockers -> floor) / what replaced the old look.
4. Do not call it accepted or fixed. Claude opens every still; the operator closes it.

## Contract
OWNS: Godot/scripts/GymClub3D.gd, Godot/scripts/club_look/GymLook2Shell.gd, Godot/scripts/club_rooms/BuildMode.gd, Godot/assets/data/gym_club.json, Godot/tests/room_look_mgt2_test.gd
RED_TEST: Godot/tests/room_look_mgt2_test.gd -> ROOM_LOOK_MGT2 failures=0
REGRESSION: shell_member_visit_test, gym_preset_autofill_test, gym_build_input_test, reception_desk_test, member_cap_read_test
VISUAL: yes - floor_view stills before/after per step, operator closes
