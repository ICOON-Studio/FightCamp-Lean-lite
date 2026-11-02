# S173 DIGEST - the one big 3D gym, steps 1 to 2c (cloud session, 2026-10-06)

Request: `start` -> roadmap now: (1) collect Arena STORY5C + DAYLAP1A, (2) GYM3D1 layout on paper, (3) GYM3D1 build + DayLap on the
floor behind a switch. Operator mid-session: "i installed e:\actions-runner so you can run cloud sessions like you are in the pc when
the pc is open", then "you have full authorization".

## What now works
- **STORY5C merged 81255fd5** (Arena PR #54, diff applied, closed): `StoryCampaign.corner_line` - HOLL speaks; from round 3 every 2nd
  round he repeats the first cue three times before the unchanged instruction. story_corner_line_test 74/0; `story_` neighbours 12/12.
- **DAYLAP1A merged 5ad9923d** (Arena PR #55, diff applied, closed): `DayLap.gd` + `day_lap_stations.json`, the stamina day engine.
- **GYM3D1 step 1** - `research/GYM3D1_LAYOUT.md`: the hall 22 x 14 m (235 m2 floor, G113 club band), every station's zone, the aisle
  graph, the switch cost, one camera (HOME / STATION), hover = one live number, click = send him, HUD, build plan.
- **2a** `GymHallLayout.gd` + `assets/data/gym_hall.json` (pure): places, aisle graph (Dijkstra), routes, camera poses with yaw.
  gym_hall_layout_test 32/0 (no overlaps, corridor + aisles clear, all 90 station routes cross nothing solid, longest 19.8 m,
  HOME frames 22 m at 16:9 under the 45 deg cap). Mutant (ring into the aisle + cut link) = 4 red.
- **2b** `DayLap.switch_minutes(from, to, metres)` + `{"idle": n, "why"}` orders: walk (1.4 m/s at 0.3 s per game minute) +
  prepare 8 (+4 gloves on/off). A 7 m switch = 25 game min. day_lap_test 81/0 (12 new). Mutant idle-drains = red.
- **2c** `GymHall3D.gd` (extends TrainingFloor3D like Lobby3D): the hall built from the layout, the day clock (08:00, 600 min, no
  fast-forward), click a station -> he walks the route, prepares, trains with the station clip; ENGINE PARITY - the numbers on screen are
  DayLap.run_day of the plan he played; a click mid-walk is taken on arrival; hover shows the live gain per hour; camera eases HOME <->
  STATION; tags hide in close-ups. gym_hall_3d_test 29/0; mutant (no prepare charge) = red.
- **Stills on the hall's own camera** (as_game bodies, xvfb + software GL - a cloud session CAN render):
  `docs/previews/gym3d1/01-06.jpg`, all opened. Bug found by the stills and fixed: pads -> bag route went out to the aisle and back
  (8.5 m, mid-walk he stood on the pads again) -> mat hubs, now ~3 m. Bag close-up was his back with the tag over the bag -> side yaw 45,
  tags hidden.
- **pc.yml** (master c6e9f712): dispatch-only workflow for the operator's self-hosted runner - watchdog gate first, allow-listed inputs via
  env, outputs pushed to `pc-out/<run id>`; never a pull_request trigger (public repo). First run 37501139371 still QUEUED at handover.

## Owed (named)
Greybox crates for treadmill / staff corner / film corner; no walk clip (he glides in the idle pose); bare hands at the bag (as on the
shipped floor); not yet wired into the game (switch `gym3d_main`); coach pool + buff (DAYLAP1B); operator video.

## Verification
`Godot_v4.7.2-stable_win64.exe --headless --path Godot --script tests/gym_hall_3d_test.gd` -> GYM HALL 3D PASS checks=29
(plus gym_hall_layout_test 32, day_lap_test 81, story_corner_line_test 74, story_ 12/12 - all run in this container, Godot 4.7.2 Linux).
