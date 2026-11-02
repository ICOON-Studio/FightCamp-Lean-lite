# TWO POINT ALIGNMENT - the one page every agent follows for the gym's camera, build mode and per-room items (S244)

Operator S244, verbatim: "Make sure every agent is aligned with 2point museum perspective and item integration per room".
Every brief that touches the gym view, a room, a station, decor or build mode cites this file in its `## Prior research` and says
which rule below it implements. Source: the operator's own Two Point Museum install, read S243-S244 (numbers and rules only - no
model, texture, sound, text or code of theirs enters the repo; raw dumps outside it in E:\FightCamp\tmp\tpm_study). Facts:
TWOPOINT_MUSEUM_STUDY_S243.md (camera, walls, build flow) + section 3-4 below (S244 per-room extraction: 1,622 items, 29 rooms).

## 1. Perspective (camera)
- Two Point Museum measured: PERSPECTIVE lens FOV 17 (telephoto, near-flat), pitch 35-90 deg down with a zoom pitch offset (+21 deg
  near, 0 far), initial yaw 235, free yaw (keys 90 deg/s), height 20-280 m. Ceilings are cut away (Config_CeilingOccludersManager);
  far walls show their inside, camera-facing walls go see-through (we keep a 0.4 m stub, ISOWALL1).
- FightCamp today: orthographic iso (Q-S239-1), 90-degree Q/E turns, roofless cutaway (S244: no ceiling lamp/truss/cap shows).
- DECIDED (operator Q-S242-3, 2026-10-17): "Two Point Museum FOV 17" - the gym camera becomes perspective FOV 17 (TASK_CAMFOV17.md),
  superseding Q-S239-1's orthographic iso. Every still is taken on the GAME's camera at all four yaws.
- Every gym still: tools/isowall_stills.gd (4 yaws) + tools/placement_audit.gd (no FLOAT/AISLE/OVERLAP on a new piece).

## 2. Build rules (PLACEMENT1 - TASK_PLACEMENT1.md, scripts/rules/PlacementRules.gd)
- Grid 0.5 m (87% of TPM items), 1.0 m for big platforms; stations turn in 90-degree steps, decor in 45 (74% of TPM items are 45).
- Free (off-grid) placement only for small decor (TPM: Tab toggles grid/free while holding; we: decor only).
- Invalid reason on the cursor ("Outside the gym", "Too close to the ring", "No aisle path", "Can't afford") - TPM shows the same kind.
- 100% refund while building, 65% once used (TPM room RefundMultiplier default 1.0).
- Wall items keep a full-height placement plane on a cut wall (TPM WallHeightForItemPlacement), decor on a cut wall hides with it.

## 3. Rooms (the TPM room model, measured S244)
A room is: a type, a MINIMUM size in cells, REQUIRED ITEM SLOTS (each slot = a list of accepted items + a DEFAULT item placed for
you when the room is built), a base capacity + capacity per cell, a prestige cap per cell, a cost (flat 5,000 or per cell).
The room is not valid until every required slot holds an item that people can reach. Examples (TPM, numbers only):
| TPM room | min cells | required slots | capacity | prestige cap/cell |
|---|---|---|---|---|
| Staff room | 3x2 | door, sofa, recovery device | 4 + 0.4/cell | 30 |
| Bathroom | 2x1 | door, cubicle | 2 + 0.4/cell | 48 |
| Cafe | 4x3 | door, food stall, 4-seat table, return bin | - | 0 |
| Gift shop | 4x3 | door, checkout till, one of 6 stands | 0.35/cell | 30 |
| Marketing | 2x2 | door, desk, draft table | 10 | 0 |
| Staff training | 3x2 | door, pod, desk, return bin | - | 0 |
| Lecture | 4x4 | door, lectern, seats | 1 | 30 |

FightCamp rooms mapped (demo: rooms fixed, items move; Early Access: room drawing - PLACEMENT_VERDICT_S243.md):
| FightCamp room | min (m) | REQUIRED slots (default first) | optional items (decor/function) | staff job item |
|---|---|---|---|---|
| Training hall | hall | door; ring (fixed in demo) | stations (bag, speed bag, pads, ropes, treadmill, bike, racks), decor | coach at a station |
| Office | 3 x 2.5 | door; desk; PC; filing cabinet | coach desk, photo wall, belts, tape TV, safe, credenza, chair | manager (desk) |
| Reception | 3 x 2.5 | door; counter; phone | bell, trophy cabinet, notice board, bench, coat stand | receptionist (counter) |
| Physio | 3 x 3 | door; physio table; cold-water tub | first aid, infrared lamp, skeleton, stool/bin | physio (table) |
| Equipment store | 3 x 2.5 | door; shelving | medicine-ball tree, glove-airing tree, bag gantry, pegboard, workbench | - |
| Locker room | 4 x 3 | door; lockers; bench | scale, showers | - |
Each room's items live in `assets/data/gym_club.json rooms.<id>.props` today; the required slots above are the rule the build mode
and the room checks enforce (a room missing a required item says so on the board/cursor, as TPM does).

## 4. Items (what an item carries - TPM measured, our values set per item, never copied)
- Cost (TPM median 250, p75 750), Prestige (decor median 0.6, p75 1.2, max 5) feeding the room's prestige up to its cap per cell.
- Bonus radius: decor works within a radius (TPM: 5 cells on 428 items, 4 on 233) - our gym-look rating reads decor near stations.
- Room modifiers: functional items change their room/area within a radius (TPM typical 3 cells), some only above a maintenance level.
- Maintenance: functional until 50, broken at 90 (TPM most common) - our station wear (STATIONWEAR) uses the same two thresholds.
- Staff job: one staff per job item (TPM 271 items, all max 1) - physio table, reception counter, office desk.
- Wall-hung vs floor (TPM WallType): wall items snap to the wall plane at their height; floor items obey the grid.

## 5. What every agent does (checklist - `start` flags a brief missing its Prior research section; this file goes in it)
1. Name the rule from sections 1-4 the task implements and keep its number (grid, snaps, slots, thresholds).
2. Rooms: required slots + defaults first, optional decor second; never a room that is valid without its required items.
3. A new piece is checked on the game camera at 4 yaws + placement_audit (no floating, no aisle, no overlap) before "done".
4. Nothing of Two Point's enters the repo - numbers and rules only; models come from our packs/Ludo (D39 LUDO FIRST for looks).
5. Discipline: BOXING (demo). The operator approves new mechanics on the board; this page is the agreed frame for them.


## HUD (S268)
Measured HUD/modal/icon numbers: `research/TWOPOINT_HUD_S268.md` (top bar + icon buttons + modals; 80 px modal title,
32 px margins, 21 px body, 35-45 px HUD icons). Every HUD/UI brief cites it.
