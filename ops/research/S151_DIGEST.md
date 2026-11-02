# S151 digest - rooms stay 3D and become readable (Back, Options, fixed titles, click markers, floor drawer, live expand); SCENETREE2; Q213D refused (Claude, 2026-10-03)

Nightly read: 2026-10-02 at 86c8150f, 496 tests, 19 fail (AgentComms/nightly/latest.txt).

## Operator rulings (verbatim)
- Q213D pose sheet: "this doesnt look right" / "hand goes through the body".
- "chill with the demo remove the deadline" -> roadmap deadline.date empty, CLAUDE.md goal has NO DATE.
- "i think i like the 3d aspect better and seems pretty much done only some rooms need to be bigger and repurposed maybe"
  + "keep working on the 3d rooms , we keep the 3d aspect" -> DECISION_LEDGER D33 (supersedes D30/D31), ROOMS25D superseded.
- "i dont see any use for that menu" (locker fight-week board) -> cut.
- "i want a back button somewhere", "check all scenes and panels for that", "what happenned to the options it should
  always be visble and all menus should have option to move back".
- "i want the items that are clickable highlighted somehow so i knowwhere i can click".
- "thisis very bad the panelson the right overlap each other and hide the 3d scene , this room needs to be bigger and expandable".
- "the title of the room should be in a fixed place on every screen".

## What now works (all committed, pushed)
- BACK on every career screen (ShellChrome under the club name, SceneRouter.back_or("day_feed"), hidden only on HOME with
  no history; CareerRoot.refresh_back deferred because a push records history after show_route). Audit: boot, creation
  and set-pieces already had their way back. shell_back_button_test 11/11.
- OPTIONS gear back in the top-right of every career screen (the R17 shell had dropped ManagementChrome's gear; same menu
  MAIN MENU / SETTINGS / CAREERS / EXIT). Stale BUILD_VERSION 2026-08-31.1 -> 2026-10-03.S151 (OWED: build_playable stamps it).
- ROOMSUI1 (TASK_ROOMSUI1_ROOM_SCREENS.md):
  - part 1: the 6 OfficeRoomPanel rooms show an always-on gold marker per clickable, a brass outline on hover
    (Office3D.set_hover for objects AND doors, moved from the film room) and a name "<what you see>: <what opens>";
    room titles in the menus' fixed slot (402,120, display face) incl. the front desk. room_click_marks_test 64/64,
    no-markers mutant 12 fails.
  - part 2: Staff room one job each (board = your staff, noticeboard = sign a coach via Scouting STAFF, coach = his card),
    its door from tier 1 (floor widens 12.0 -> 13.5 m).
  - part 3: training floor - station list / sparring / floor event in ONE right drawer (tabs, one at a time, room clear
    by default), EXPAND ROOM live (two-step confirm), title slot. floor_drawer_expand_test 12/12 with a cannot-pay arm.
  - Locker fight-week board is a wall display, no longer a door.
  - Stills: docs/previews/q232/*_ui1*.png, docs/previews/shell_back/.
- SCENETREE2 published to the same artifact (v4): per scene for/sees/decides/state/objects+fate/defects (door census
  computed from the code map, 6 screens under >1 name)/operator comments/K85-M41-J61 verdicts/decision; pictures are
  renders of today's game (q232 s151p). Tools/scene_tree_render.py + scene_tree_analysis.py. Threads answered, open until built.
- PREFAB2: Boxing Arena - Game Level is FREE, by Marpa (maker of our MMA arena, C205) -> VENUES2, needs the operator's
  Unity download; Boxing animation package EUR 64 not bought (PREFAB2_UNITY_PACKS.md). Competitors logged in G62.
- Deadline removed; D33 recorded; memory updated.

## Refused / not merged
- Q213D (Codex): gate said 26/26 but the operator saw an arm in the chest. The gate measures capsules, not skin.
  Probe s151_trunk_arm_probe: a shoulder turn out of the torso made it WORSE (10 -> 16 frames >2 cm, worst 6.1 -> 11.2 cm)
  because _stop_posed_contact re-solves the arm from the wrist afterwards -> reverted. Real fix = elbow pole inside the arm
  IK (Q213F brief, AgentComms/prompts/Q213F.txt) after Q213E makes the gate see skin (prompts/Q213E.txt).
- Q213E launch was MISROUTED (worktree passed as an argument; codex_task.cmd reads CODEX_REPO / CODEX_MODEL env) and ran
  in the main checkout on luna; killed before any edit. The relaunch was BLOCKED by the permission classifier
  ("Interfere With Workloads") - asked the operator.
- MH2 (Codex) landed eb2677b2 on codex/mh2-metahuman-boxers-wip-s143: 4 MetaHuman boxers, body gates pass, but C223
  346/356 rows with findings, 44 combos missing, 16.6 vs 12.6 ms; metahuman_bodies is ON by default -> NOT merged.
  Video sent for the look; merge only with the switch OFF or after certification.

## Running at handover
- TRAIN1 slice 1 on Cline (wt E:/FightCamp/wt/CLINE, out CLINE_TRAIN1_out.txt) - still iterating on its test; its
  TrainingFloorPanel diff is pure additions, apply with --3way over ROOMSUI1 part 3.

## Next (decision)
1. Collect TRAIN1 (check_workflow branch cline/seat TRAIN1, station_move_picker_test + floor tests incl.
   floor_drawer_expand_test, stills), apply its diff over part 3; the picker goes INTO the floor drawer as a tab.
2. ROOMSUI1 part 4: markers/hover on the floor and the front desk (move clickable_boxes/marker_points/set_hover from
   Office3D up to TrainingFloor3D; factor the overlay out of OfficeRoomPanel), film room cut to projector + laptop,
   office wall sign SCHEDULE, HOME one pin per room, bigger staff/physio/locker rooms.
3. Q213E relaunch (needs the operator's permission) -> Q213F elbow pole.
4. MH2: merge with metahuman_bodies OFF once the operator has judged the look.
