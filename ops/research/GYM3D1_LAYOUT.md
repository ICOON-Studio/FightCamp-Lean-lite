# GYM3D1 - the one big 3D gym, on paper (S173, 2026-10-06)

Design of record: D38 + `DAYLAP1_DESIGN.md` (operator S172, verbatim there). This page is step 1 of GYM3D1: where everything stands,
how he walks, what the camera does, what a hover and a click do. Step 2 (the build) follows this page, behind a switch.
Engine already merged: `DayLap.gd` + `assets/data/day_lap_stations.json` (DAYLAP1A, 5ad9923d) - nine stations, stamina, efficiency, injury risk.

## Prior research
`python Tools/prior_research.py gym layout floor stations camera` -> G113 (real sizes: club boxing hall 150-250 m2; tier-2 boxing ~280 m2
= 16 ft ring, bags, speed, rack, bikes, rower, stretch), G121 (real plans: ring at one end, bag strips along the long wall, rooms off a
lobby, not on the floor), TrainingFloorLayout.gd (DEVICES sizes + use zones, ZONE_COLOURS rubber colours, the 2.4 m door corridor in the
LEFT wall, the 2.0 m front aisle, the knee-high front cutaway, doors -> SceneRouter routes), TrainingFloor3D.gd (camera fov 42 at
~9.5 m up, ~16 m of floor across, pan; click = raycast against prop boxes, route read off the meta), MMAM2_WATCH_S172 (one station at a
time, energy bar).

## What would a human do?
A gym owner lays the hall out so the coach can see everything from one spot: ring at the far end, bags along the back wall, open floor
for pads in the middle, cardio and iron near the door, the recovery corner quiet in a corner. A player needs the same: ONE view where
every station is a readable shape, the walk between two stations is short and visible, and the fighter is never hidden behind a prop.

## Prefab check
Every station has a model in `assets/models/props/gym/` EXCEPT the treadmill and the defence-drill slip rope:
heavy_bag (+t3, worn), speed_bag, double_end_bag, focus_mitts_locker, compact_weights (+t3), plyometric_step_rig, exercise_bike,
rowing_ergometer, cold_water_tub, physio_table, first_aid, grappling_dummy; the ring = `club_ring` (gym ring, U182) / Marpa's ring.
- TREADMILL: no CC0 GLB found in one search (Coohom "free" low-poly, licence unclear; CGTrader $8 RF glTF; G114's $16 pack has treadmills).
  Decision: greybox (box deck + console post, the S84 greybox style) until a mesh lands; source it with the `generate` skill
  (fal.ai image->3D, Hunyuan/Tripo, pay-as-you-go, cents) the way the S94 Tripo heavy bag was made. No purchase.
- SLIP ROPE: two posts + a rope = three primitives in code. No asset.

## The hall (metres; x across the screen left->right, z from the BACK wall (0) toward the camera)
Room 22.0 x 14.0 = 308 m2 (floor 19.6 x 12.0 = 235 m2, inside G113's club-hall band). Wall 3.6 m. Back wall and left wall full height;
front wall knee-high cutaway (as today); right wall full height, seen at an angle.

```
 z=0  back wall: THE WALL (story pins, fight posters) above the bag line, y 2.2-3.4
      +-----------------------------------------------------------------------------+
  D   | BAG LINE (red rubber)                  |  |      RING (16 ft, 5.8 deck)       |
  O   |  [HB1]      [HB2]     [SPEED] [DEB]    |  |          centre (17.0, 3.9)       |
  O   |  4.2,1.6    7.2,1.6    9.9,wall 11.5   |  |      zone x 13.2-20.8 z 0.1-7.7   |
  R   |----------------------------------------|  |                                   |
  S   | PADS (blue mat)   DEFENCE (grid+rope)  |ST|                                   |
      |  centre 4.7,5.7    centre 8.9,5.7      |AF|                                   |
  c   |  x 3.0-6.4         x 7.2-10.6          |F |              steps 13.9,7.3 ->    |
  o   |  z 4.0-7.4         z 4.0-7.4           |  |                                   |
  r   |============== MIDDLE AISLE z 7.8-8.8 ==================================== ... |
  r   | CARDIO (green)     | IRON (grey)  | FILM     | RECOVERY = THE PIT BOX (wood)  |
  i   | [TREAD] [BIKE]     | [RACK][PLYO] | TV+bench | mat, tub, table, first aid,    |
  d   |  3.6,10.3  6.6,10.3| 10.5,10.3    | 13.9,10.4| fridge; x 15.6-21.6 z 9.0-11.8 |
  o   |  x 2.4-8.4         | x 8.6-12.4   |x12.8-15.2|                                |
  r   |============== FRONT AISLE z 12.0-14.0 (camera side, knee-high wall) ======== |
      +-----------------------------------------------------------------------------+
  x=0  2.4                                    12.6 13.0                           22.0
```

| Place | Kind | Where (centre / rect) | Prop | Click opens |
|---|---|---|---|---|
| Heavy bag 1, 2 | station `heavy_bag` | (4.2, 1.6), (7.2, 1.6); bag zone 3x3 | heavy_bag.glb | sends him |
| Speed bag | station `speed_bag` | board on the back wall at x 9.9, y 1.5 | speed_bag.glb | sends him |
| Double-end bag | decor (later: hand speed alt) | (11.5, 1.6) | double_end_bag.glb | - |
| Pads | station `pads` | mat x 3.0-6.4, z 4.0-7.4 | focus_mitts_locker.glb at the mat edge | sends him; the coach holds pads |
| Defence drill | station `defence_drill` | grid x 7.2-10.6, z 4.0-7.4 | footwork grid + slip rope (code) | sends him |
| Ring | station `ring_sparring` + THE MOVE CARDS | ring centre (17.0, 3.9), deck 5.8 | club_ring | sends him; the move cards strip |
| Treadmill | station `treadmill` | (3.6, 10.3), faces the camera | greybox -> generated mesh | sends him |
| Bike | station `bike` | (6.6, 10.3), faces the camera | exercise_bike.glb | sends him |
| Weights | station `weights` | rack (10.5, 10.3) + plyo | compact_weights.glb, plyometric_step_rig.glb | sends him |
| Pit box | station `recovery` = THE PIT STOP | x 15.6-21.6, z 9.0-11.8 | mobility mat, cold_water_tub, physio_table, first_aid | sends him; the pit services strip |
| Film corner | expansion door | TV on a stand + bench, (13.9, 10.4) | Kenney TV + bench | FILM ROOM |
| Staff corner | the coach's home spot | whiteboard + bench, x 10.8-12.6, z 4.2-7.2 | Kenney board + bench | STAFF ROOM (hire) |
| The Wall | story wall (STORY4 re-homed) | back wall above the bag line, x 2.4-12.4, y 2.2-3.4 | pinned cards (Label3D/quads) | THE WALL view (zoom) |
| Doors, left wall | expansions | existing door_z_list: street/lobby nearest the front, then office, staff room, lockers | existing door frames | lobby, office (desk seen through its window), staff room, locker room |

Rules kept from the shipped floor: the 2.4 m door corridor along the left wall stays clear (no station in a doorway, sight line from
every door); every device keeps its G113 use zone; zone floors keep ZONE_COLOURS (red bags, blue mats, grey iron, green cardio, wood
recovery). Tier changes LOOK (worn/t3 props, wall colour), never the positions above - one layout for the demo.

## Walking routes
A tiny graph, not a navmesh: nodes = each station's APPROACH point (on the nearest aisle) + aisle junctions; edges along the two aisles
and the back strip z 3.2-4.0 under the bags. The pads mat and the defence grid are floor markings he may walk across;
the obstacles are the bag zones, the ring, the staff corner, the cardio/iron devices and the pit-box props.
- Approach points: bags (4.2 / 7.2, 3.6) step in from the pads/defence front edge; speed bag (9.9, 3.6); pads (4.7, 7.6); defence (8.9, 7.6);
  ring steps (13.9, 8.3); treadmill (3.6, 9.0); bike (6.6, 9.0); weights (10.5, 9.0); film (13.9, 9.0); pit box (16.5, 9.0).
- Route = approach of A -> aisle -> approach of B -> work point (DEVICES `work_point`, BAG_REACH_M for bags). Longest route (ring to speed
  bag) 20.9 m; neighbours 7 m (out to the aisle and back).
- Walk speed 1.4 m/s on screen (natural walk). The day clock keeps running while he walks.

## The clock and the switch cost (numbers are DATA in day_lap_stations.json, tuned on video)
- One game day = `day_minutes` 600. Real time per game minute `real_s_per_min` = 0.3 -> a day plays in 3:00. NO fast-forward while he
  trains (D38). A typical walk of 7 m = 5 s = ~17 game minutes; the longest ~45.
- Switch cost = WALK (metres / 1.4 m/s / real_s_per_min, rounded up) + PREPARE `prepare_minutes` (default 8; gloves on/off for bag/pads/ring
  +4 = `glove_minutes`). Walk and prepare minutes: no gain, no drain, no risk (DayLap idle minutes). A rotation costs ~5% of the day:
  rotating pays only when the next station earns that back - the decision the operator asked for.
- Blocks: three of `block_minutes` 200 (morning, afternoon, evening) mark the timeline; orders can be given any time.

## The camera (one camera, three distances)
- HOME: the whole hall. Target (11.0, 0, 6.5), from about (13.0, 15.5, 22.0), fov 42, pitch ~45 deg (S161's 45 deg cap stays the ceiling).
  Every station readable as a shape, the fighter ~60 px tall at 1080p.
- STATION: click a station or he arrives -> ease (0.6 s) to the station's own target at ~6 m, pitch ~35 deg, framing him and the station
  (ring: ~9 m, the whole deck). One target per row of the table above.
- FOLLOW: while he walks the camera stays where it is (HOME or STATION); it never chases (no motion sickness, the route stays readable).
- Wheel = HOME <-> STATION; Esc / right-click empty floor = HOME. No free orbit in the demo.

## Hover = one live number
| Over | Shows (one number + its word) |
|---|---|
| a station | his gain per hour THERE, NOW (`trains` x `efficiency(stamina)`): "CONDITIONING +4.2/h"; red when he is under `injury_risk_below` |
| the pit box | "+25 STAMINA/h" (later: the services) |
| the ring | the card he is on: "JAB 64% - usable at 100" |
| him | STAMINA 58 + the bar |
| the coach / staff corner | COACH POOL 62% (the week) |
| the Wall | "CHAPTER 1 - 3/14" |
| film corner | "NEXT OPPONENT - 2 tapes" |
| a door | what waits inside: office "2 OFFERS", staff "HIRE", lockers "-", lobby "FIGHT IN 3 WK" |

## Click = send him (the one verb)
1. One fighter in the demo: he is always selected. (More fighters later: click him first.)
2. Click a station: a chalk line draws his route on the floor + a chip at the station "WALK 5 + PREP 8 = 13 MIN"; he goes at once
   (no confirm - the day is running; a second click elsewhere re-routes). Right-click = stop, he stands (idle minutes).
3. On arrival: PREPARE (gloves / wraps / step on, a short clip or idle), then the station clip loops (the TRAIN1B drill loop + reps bar),
   +N gain floats (TRAIN1B) per game hour.
4. The coach: click the coach, then a station -> he walks there and buffs it while both stand there (DAYLAP1B, pool drains per session).
5. Doors and the Wall open their expansion scene with the gym behind it; closing returns to HOME with the clock PAUSED while a room is
   open (rooms are menus, not training).

## HUD on the one screen
Top: the day timeline (three blocks, a cursor, the current order as a coloured bar per station, walk/prep in grey). Top-left: his strip
(name, STAMINA bar, INJURY RISK pips, fight countdown). Top-right: COACH POOL (week). Bottom: the context strip (move cards on the ring,
pit services at the pit box, nothing elsewhere). One gold END DAY appears when the clock reaches 600 (never earlier: no skip).

## Status S173
- 2a DONE: `GymHallLayout.gd` + `assets/data/gym_hall.json` + `gym_hall_layout_test` (32 checks; mutant ring-in-aisle + cut link = 4 red).
- 2b DONE: `DayLap.switch_minutes` + idle orders + 5 data keys; `day_lap_test` 81 checks (12 new; mutant idle-drains = red).
  A 7 m switch = walk 17 + prepare 8 = 25 game min (+4 gloves on/off).
- Approach points sit ON the middle aisle line z 8.3 (bag approaches on the back strip z 3.6).

## Build plan (step 2, behind the switch `gym3d_main`, default OFF; read like `gym_is_menu`: career key, else the `gym3d_main` cmdline arg)
- 2a ARENA - `GymHallLayout.gd` (pure, zero preloads) + `assets/data/gym_hall.json` (the table above: places, rects, approach points, aisle
  graph, camera targets) + `gym_hall_layout_test`: no two use zones overlap, the door corridor and both aisles are clear, every station
  reachable, `route(a, b)` returns points + metres with longest <= 21 m, every DayLap station id has a place.
- 2b ARENA - DayLap switch cost: `DayLap.switch_minutes(metres, from, to)` from the data keys above + `run_day` accepting
  `{"idle": minutes, "why": "walk"}` orders (no gain, drain or risk); extend `day_lap_test` (a plan with walks gains less than the same plan without; idle minutes
  never drain).
- 2c CLAUDE (PC, needs a window) - `GymHall3D.gd`: builds the hall from 2a with TrainingFloor3D's builders (shell, zone floors, props,
  doors, house style); camera HOME/STATION; hover chip; click -> route line -> walk -> prepare -> station loop; HUD bars from DayLap.
  Judged on `record_room ... as_game` stills (HOME, STATION at the bag mid-punch, a walk mid-route) and a 30 s video to the operator.
- 2d later - DAYLAP1B coach pool + buff (pure, Arena); move cards on the ring; pit services.

## The one trap
Do not grow TrainingFloor3D.gd (2627 lines) into the hall: the hall is a new scene that CALLS its builders. The old floor stays behind the
switch as the control arm until the operator OKs the hall on video.
