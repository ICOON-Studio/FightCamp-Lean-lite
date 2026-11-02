# S199 DIGEST (2026-10-11) - the club on the game camera, Ludo camera, drawers, bags

## What now works (all behind switches, OFF by default; the exe plays as before)
- GYMFILL2 (club zones with their own equipment, <=2 lockers, no locker rows) - merged, then REPAIRED: my first merge took Cursor's unfinished repack after running ONLY club_fill_test and broke club_zones_test + gym_look2_props_test. Fixed by restoring zone rects and repacking items by footprint; later removed my 2 filler lockers (club_fill 1068/0 without them) and moved the Glove rack (a reused locker model) from mid-floor to the west wall (node mw_w2).
- WIRE-DRAWERS A+B: skip button -> SkipDay preview in the right drawer (`skip_drawer`); fighter profile -> FighterReadoutPanel in the drawer (`profile_drawer`); `open_last_spar()` exists, NO caller (no Thursday test-spar hook yet).
- Arena panels merged: FighterReadoutPanel (#110), LastSparPanel (#109). Qwen: MATCHMAKE1A (Matchmaking stages), AMBITION1A (4-want ambition engine). Both pure, not wired.
- CAMERA2 + CAMERA2B: Ludo's 3-stop camera (`ludo_camera`): overview FOV 55 (not 38) so the 4 hall corners project; works in floor mode; near+south walls cut at the overview. Game-camera stills opened by Claude.
- Exe rebuilt (Builds/FightCamp_Godot, pck 526 MB) - plays as before (all new switches OFF).
- Poles experiment: a per-bag gantry was built and REJECTED by the operator ("remove the poles"); reverted (474ba45c).

## Ludo
- Round 34 (LUDO_ROUND34_S199.txt, 25,924 chars): bag rig = WALL-MOUNTED CANTILEVER I-beam + 45 deg kicker strut + swivel/shackle + 4 chains; speed bag = wall board; double-end = wall arm + floor D-ring; plus generation prompts for assets 01-11+ (heavy bag, rack, ring, treadmill, ...). His z is mirrored and assumes bags 1.5 m from the wall: our zone-packed heavy bags (bag_line, bag_east, strength_east) are 3-12 m from walls - BAGRIG1 re-lays them.
- Ludo has NOT seen the current floor (last look = S198 stills). LUDOFLOOR1 = first thing next session (TASK_LUDOFLOOR1_S199.md, stills in docs/previews/s199_for_ludo).
- Operator S199: "new asset generation is approved if needed for any asset that doesn't qualify for AAA-grade game". Ludo had 805 credits.

## In flight at handover (collect first)
- Codex BAGRIG1 (wt E:/FightCamp/wt/BAGRIG1, branch codex/bagrig1) - wall bag rig behind `bag_rig` + re-lay.
- Cursor GYMART1A (wt GYMART1A, branch cursor/gymart1a) - thick walls, floors, trusses+lamps, street (gym_look2).
- Arena FILMIDLE1A chat 01a12a44 (film-room idle tasks, pure) and BAGSWING1A chat 01a12a89 (bag pendulum, pure) - PRs not seen yet.

## Mistakes recorded
- Ended a turn with "I'll collect it when it lands" and nothing to wake me: 7 hours lost (the fix: always leave a background waiter).
- Ran a test while the watchdog was RED; ran only one test after a shared data change (see GYMFILL2); told the operator ATTRITION1C was "uncollected" when it was merged earlier (stale roadmap row - always check master first); posted a question to the review page, not the board; claimed a locker belonged to the pads station without checking.
- Stale class cache after merges: `Godot --headless --path Godot --import` fixes "Identifier not found" for new class_name files.
- check_workflow can MemoryError under RAM pressure (not a verdict on the code).

## Evidence / gates
ludo_camera 26/0, profile_drawer 16/0, skip_day_drawer 15/0, readout panel 169/0, last_spar panel 137/0, club_fill 1068/0, club_zones 15/0, gym_look2_props 677, gym_club_3d 173, layout 70, clearance 7, hall_3d 41, floor_pick 16, training_floor_3d 0 failures.

## Queue after LUDOFLOOR1 and collections: see roadmap.json now.next_action.
