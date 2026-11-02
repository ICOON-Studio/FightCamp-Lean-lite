# S181 DIGEST - the club's video sent, its clearances measured, six design-review defects fixed, three agent runs merged (2026-10-09)

## What now works (evidence)
- **Club ring rows open the real screens** (GYM4H, Cursor d3f2725d -> ebb7c9a0): office window hire/money/calendar/messages/week review,
  fighter profile + day plan, coach profile, walk-in INTERVIEW at the desk; the rest greyed with a reason. gym_club_ring_routes_test 51/0
  (re-run by Claude), gym_club 3/0, gym_hall 6/0.
- **Club video + stills sent** (operator: stills "ok not great"): tools/gym_club_video.gd - 30 s club morning on the club camera
  (walk-ins, a real click on him -> the ring, heavy bag TRAIN HERE, walk, prepare, close zoom). Seen in frame 21 s: his tag read ON THE
  MOVE while preparing at the bag -> fixed 0df9556c (gym_hall_3d_test 41/0, red on old). Video docs/previews/gym4_club/video/club_30s.mp4.
- **Club clearances** (operator: "items too close on the walls and doors of other rooms?"): tools/gym_club_clearance.gd measures the
  DRAWN models (39 items) against every door's 1.2 m clear zone and every wall line. No door hits; the weights rack poked 0.32 m through
  the hall's outer wall -> moved 0.45 m in. gym_club_clearance_test 7/0 with 3 controls, red on old (e8e48d9a).
- **Design review S172 fixes**: boxing camp offers only boxing (no Mat Mechanic / Anti-Wrestler / judo coach; coaches of the ruleset's art,
  abroad when none at home) dd7165b5; one-line settlement for an unpaid night + the chapter line no longer cut by THE READ (as_game walk
  still docs/previews/s181_settlement/56_result) + REST everywhere 5376d936; offers say how the opponent fights (style + one weapon) and
  the match-up line no longer runs into WHEN a50dde33 (still docs/previews/s181_offers/24_offers_signed); one record everywhere (REC1,
  Cursor 728021b9 -> 0715a326).
- **Holl speaks in the corner** (STORY5D): Arena stalled compiling Godot again -> Cursor 7148bfe7 -> merged 5376d936.
- Queue cleaned: STORY4A/4B, TUT1 handbook, SCHED1 badge, offers redesign were already shipped (rows stale); Arena PR #63 closed as a
  duplicate of f8867798.

## Traps this session
- PC went RED: memory 90% made Windows grow C:\pagefile.sys to 40 GB (peak use 8.9 GB) -> C: 3 GB free. Claude ran two small suites
  after the RED line - stop on RED. Operator to set a fixed pagefile (8-16 GB) and maybe powercfg /h off (12.5 GB). AMD's
  AppData\Local\AMD\PPC\sdkusage.csv (5.3 GB, growing) deleted with the operator's OK.
- A headless SceneTree test must `await process_frame` before reading global transforms (all AABBs read at the origin otherwise).
- An idle Godot test (0.4 s CPU in 5 s) is a dead script - kill by PID, rerun with --log-file.
- Arena stalls compiling Godot from source (STORY4A S180, STORY5D S181): give Arena tasks whose acceptance its CI can run, or move to Cursor.
- ui_kit_book_test: every new public UIKit static must be in ui_kit_manifest.json (as a factory or a declared helper).

## Open / next
- Operator: OK (or changes) on the 30 s club video -> then gym3d_main + gym4_club ON and an exe walk to the first club bout.
- K88 (Kalli, sent): 15 fictional sponsors local->global; then code: sponsors from that list, organisations only of the gym's sport.
- Design review part 1 still open: camp pays visibly (1), first corner played (2), causal three moments (3), first fighter a person (6).
- NIGHTLY1D (corner AI wins gate), KM3-RIGS. The 10-09 nightly had not run at handover (last: 10-08, 571/5, unchanged).
