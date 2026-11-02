# S287 DIGEST (2026-10-22) - the gym loop plays end to end; BUILD becomes the Life Fitness planner

## Operator asks this session (verbatim)
- "you crashed the pc , i want to know why pc froze , it is the second time you done that lately"
- "where my comments for the intro gym page saved before the crash ??"
- "i want to be able to build the rooms quickly put the objects i need and the gymfloor assets and start training , this is what needs to happen by the end of the session"
- "https://www.lifefitness.com/en-us/customer-support/gym-planner/builder check their builder and improve our own" / "this is how i want it pretty simple check the webiste link and try to fit their designer in our game" / "check how it rotates items and rotates the view" / "use your eyes skill and try to build a gym on their website looking as good as possible and show it to me" / "shouldn't you do it since you know how everything works ?"
- "is it possible for me to test gym floor without running the game ?"

## What now works (evidence)
1. PC FREEZE: hard hang 22:06 (no bugcheck, no WHEA, governor saw no heat/RAM alarm). Pattern = AMD RX 6800 XT driver: graphics live dumps 10-20 (0x193, the S275 two-Godot freeze) and 10-21 (0x1B0, Godot crash, driver reinstalled that second). Watchdog now logs AgentComms/pc_health_history.log every minute; agent_events fetches only missing heads (436a2b25). Driver rollback/clean install = operator's call.
2. HIS GYM-PAGE COMMENTS: none reached the board after 21:22 (opsboard.log: no POST after his Q-S277-8 answer); unsaved marks are lost. Markup Board now keeps unsaved marks per image in the browser until Save (e23115bf).
3. START TRAINING (e23115bf): Play on a new career did nothing - show_today returned for an empty roster and FIRST GAIN locked 2x/3x with no boxer. Now the gym's day runs (applicant waits behind its icon), day end advance_day, lock only with a signed fighter. Real-route probe tools/s287_build_loop_probe.gd: reception + locker room + floor + 6 pieces ($16.6k of $25k), Play 3x: days 1..6, week 2, members 0 -> 3 -> 6, dues paid. Members need a LOCKER ROOM (S280 rule).
4. "Reception reload deletes everything": NOT reproduced - reception_keeps_gym_test (both arms) + real-route stills docs/previews/s287_reception_reload keep floor, piece and reception in memory, on disk and in the rebuilt hall. His 22:22 save was a fresh career. My headless runs rotated his godot logs (Godot keeps 5) - copy his log first next time.
5. BUILD = THE PLANNER (55349101, TASK_PLANNERUI1): Claude built a gym in Life Fitness's planner (research/planner_study_s287) and fitted it: catalogue docked right (category, search, 3-column picture tiles; thumbnails rendered from our own models by tools/build_thumbs.gd), press a tile = pick, drag onto the floor = buy + place there, rail left (quarter view turns, 3D | 2D plan straight down), rotate ring on the selected piece (quarter turns - our footprints), TURN / SELL over it, middle-drag tilts in BUILD only, closing BUILD drops a carried piece. build_planner_ui_test 0 fails both arms; stills docs/previews/s287_planner (real route, ui=1). Plan editor chooser fixed (BLANK SHELL over row 2, drag scale).
6. "Gym Floor Sandbox.cmd" (repo root): straight to an empty gym, $200,000, BUILD open, no sound, own save folder.
7. WALKROUTE1 collected 34ebf2ef (Arena could not run Godot: engine run here failures=0, door-span mutant failures=10). Not wired yet.

## Nightly / as_game reds seen (all red on master too, not from S287)
club_one_dialog_test (coach-hire-first), build_single_piece_test, bag_mount_test (control checks in the game arm), gym_club_3d_test (camera poses pre-iso), sparring_pit_test, gym_club_ring_routes_test.

## Next (decision)
Operator judges the new BUILD (stills on the board 8787/review, or Gym Floor Sandbox.cmd). Then: wire WalkRouteRules.repair_path into GymClubLayout._shell_walk_in; collect Qwen BOUTREPEAT1 r2 (#341, running); build the exe; room-furniture thumbnails (draft items); the 2D plan framing (fit the whole floor).

## HANDOFF
commit 55349101 pushed; runs in flight: Qwen BOUTREPEAT1 r2 (#341), ziva/playtest worktree (idle).

## After ship - played live on his Samsung (FIGHTCAMP_STAGE_GATE=off, part of this stage)
Operator: "i still can't build anything the gyfloor refreshes and deletes everything", "make the game work", "mark the area as
mandatory for reception near the entrance door", "members should walk in through the entrance to their station, then train".
- 269801a4: a room tile picked on the PRESS rebuilt the list and the release fell onto the floor as a drawn room (a $1,500 floor
  built under the window) - THE reset he saw; drag-from-tile never placed; 45-deg drags made 1 m strips refused and the ghost
  vanished; reception area at the entrance (only the reception, built exactly there, marked in BUILD); BUILD holds both clocks;
  'is' on freed top bars (8 sites) froze the date label every day.
- 0a66dea2 + e98c9719: members visible on HIS pieces (ShellFloorMembers, half the members, one per piece, station work clip);
  new members walk in from the street door through the reception (MemberWalker + WalkRouteRules - WALKROUTE1 now wired), those
  inside stay at work across day rebuilds. Live: Week 18, 12/12 members, four training.
- Open: bike + agility ladder have no work clip (idle); 2D plan framing; room-furniture thumbnails; exe not rebuilt.
