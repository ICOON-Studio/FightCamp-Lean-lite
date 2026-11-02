# TASK_BUILDFLOW1 - BUILD works exactly like Mad Games Tycoon 2: pick a room, draw its limits, place its eligible items, place the door, FINISH

Model: cursor. Discipline: boxing = demo. Queue behind TASK_AUTOFILL1 (#334): both edit BuildMode.gd - launch only after #334 is collected.
Operator, verbatim (S284):
1. "the building process is not what MGT2 looks like can you make it exactly like that ? when i select a room i dray its limits then i put the items eligble for that room a door and finish ? can you do it like that?"
2. "also why there are no items shown on the list i can place"
(Also on stills: "Reception - BLOCKS A DOOR" - fixed on master 4bc3ee17: a reception may cover the street door.)

## Today (read before changing)
Godot/scripts/club_rooms/BuildMode.gd (~2000 lines, read in windows): ROOMS tab -> `pick_room` -> drag a rect -> `finish_room(a, b)` commits at once with an auto-chosen door (`RoomDrawRules.door_for`) and the key item; OBJECTS tab shows only training-floor pieces plus the line "Draw a room under ROOMS - its furniture shows here." (see the operator's screenshot: the list under a drawn room is empty / has no eligible items). Rules: Godot/scripts/rules/RoomDrawRules.gd, RoomWorkRules.gd (`room_items()` rows carry `rooms: [...]`), room_types.json (permit, floor_per_m2, min size, key_item). UI: Godot/scripts/ui/BuildWindow.gd. Worked example of the API: Godot/tools/gym_build_stills.gd.

## The MGT2 flow to build (the operator's steps, in order)
1. SELECT a room type in the ROOMS list (price per m2 + permit shown).
2. DRAW its limits: drag the rectangle (live size in m, live cost, green/red with the reason: min size, overlap, outside, blocks a door - exactly today's `room_check`).
3. The room becomes a DRAFT (not committed): the item list now shows ONLY items eligible for this room type (from `RoomWorkRules.room_items()` `rooms` plus the room's key item, with price and what it does); the player places them inside the draft (grid snap, rotate R, legality as BUILD's piece rules). The list is NEVER empty for a drafted room: if a room type has no eligible items say so in one line and still allow FINISH. Required key item missing = FINISH disabled with the reason ("Needs a desk").
4. DOOR: the player places the door on the draft's wall edge (valid edges highlighted; default = the auto choice, movable) - a door is required.
5. FINISH commits: permit + floor + items charged, the room stands (drawn-room rules unchanged: stands empty except what was placed). CANCEL discards the draft and refunds nothing (nothing was charged). Esc cancels.
Rooms and items already built stay movable/sellable in BUILD as today. Training floor stays "a zone then single pieces" (S278) - same flow, its items are the station pieces (bags etc.).
The OBJECTS list outside a draft: list every standalone piece that can be bought for the current context (pieces for the selected built room, or training-floor pieces), never just a hint line; group with headers; greyed (with the reason) when it cannot be afforded or has no room. Fix whatever made the list empty in the operator's screenshot - first REPRODUCE it on the real route with a still, state the cause in the PR.

## Owned files
Godot/scripts/club_rooms/BuildMode.gd, Godot/scripts/ui/BuildWindow.gd, Godot/scripts/rules/RoomDraftRules.gd (NEW, pure: the draft state machine - states select/draw/items/door/finish, transitions, FINISH gate, eligible items), Godot/tests/room_draft_flow_test.gd (NEW).

## Prior research / What would a human do? / Prefab check
`python Tools/prior_research.py build room draft mgt2`. Two Point and Mad Games Tycoon: draw room -> add required items -> doors -> confirm. Read research/TWOPOINT_ALIGNMENT.md section 3 (rooms: required slots, doors). No prefab.

## Contract
OWNS: Godot/scripts/club_rooms/BuildMode.gd, Godot/scripts/ui/BuildWindow.gd, Godot/scripts/rules/RoomDraftRules.gd, Godot/tests/room_draft_flow_test.gd
RED_TEST: Godot/tests/room_draft_flow_test.gd -> ROOM_DRAFT_FLOW failures=0
REGRESSION: room_draw_rules_test, reception_street_door_test, bag_mount_test
VISUAL: see below

## VISUAL GATE
UI flow: closes only on game-camera stills of the REAL BUILD route, one per step (room list; drawing with cost; draft with its eligible-items list; door placement; after FINISH), opened by Claude, then the operator's OK. No tooltip or pop-up over the panel. Ships ON (GAME_ON); plain `--script` tests stay the OFF control arm.

## Acceptance
Parse gate `python Godot/tools/check_scripts.py <touched .gd>`; the new test red on master first, then green both arms (`Godot_v4.7.2-stable_win64.exe --headless --path Godot --script tests/room_draft_flow_test.gd`, plain and `-- as_game`; never the console build). ZERO SCRIPT ERROR lines. Asserts: draw -> draft (nothing committed, cash unchanged); item list == the eligible set for that room type (non-empty for reception/locker/office/physio/strength); FINISH disabled until key item and door; FINISH charges permit + floor + items exactly once; CANCEL/Esc leaves the career untouched; door placement refuses non-edge points. Existing BUILD tests stay green. PR body: `RESULT: tests/room_draft_flow_test.gd -> ROOM_DRAFT_FLOW failures=0`. Nothing opens on the operator's monitors; stills via Tools\godot_hidden.ps1. Edit code and tests only; do not edit this brief or HANDOFF.md.
