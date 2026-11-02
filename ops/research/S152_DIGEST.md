# S152 digest - TRAIN1 picker in the floor drawer, MH2 merged OFF, ROOMSUI1 part 4 (markers on 8 rooms, film cut, SCHEDULE, HOME pins, drawers everywhere); MH3 + ROOMS2 launched (Claude, 2026-10-03)

Nightly read: 2026-10-03 at 9c53c6a4, 510 tests, 20 fail (AgentComms/nightly/latest.txt).

## Operator rulings (verbatim)
- On the MH2 live-room video: "the metahuman look better, the walking animation on them needs polishing".

## What now works (all committed, pushed)
- TRAIN1 merged (Cline b6406054 -> 8b4fa72f): every owned floor station wears a pin; the pin opens the move picker
  (fighter chips -> certified moves of THAT station -> animated preview -> TRAIN THIS). Claude on top: the picker is the
  floor drawer's MOVES tab (one panel at a time, under the title slot, solid panel) instead of a glass pop-up over the title.
- DEFECT FIXED: UIKit.technique_preview_resolve returned NO MOTION for every kind=skill before looking for a clip, so the
  certified catch and slip never played in the picker or the Skills tree. A skill with its own clip now plays it.
- DEFECT FIXED: TRAIN1's station pins were projected once at build and stayed put while the camera panned (an expanded
  floor pans) - they follow every frame and hide off-view (mutant without the follow: FAIL 0.0 px).
- MH2 merged with metahuman_bodies OFF (e8d454af): 4 MetaHuman boxers + trunks + gloves + rest fold; only
  `-- metahuman_bodies=1` mounts them (the branch defaulted ON in the game). mh2_bodies_test 0 errors both arms. The
  230k-line C223 JSONs, probe logs and the 14 MB video stay on origin/codex/mh2-metahuman-boxers-wip-s143.
- ROOMSUI1 part 4:
  - 4a (0dc342c1): the click-mark overlay factored out of OfficeRoomPanel into RoomClickMarks.gd; clickable_boxes /
    marker_points / set_hover moved up to TrainingFloor3D; the training floor's and the front desk's doors now wear the
    brass markers + hover outline + name. room_click_marks_test 81/0 (+ floor + front desk).
  - 4b (dd2e16e3, SCENETREE2 decisions): film room = projector (STUDY) + laptop (GAME PLAN), the board/folders/binders
    are dressing; the office wall calendar is named SCHEDULE; HOME one pin per room - the ring pin opens the training
    floor (pins open rooms, never a menu), a FRONT DESK pin (walk-ins this week), a LOCKER ROOM pin from tier 2.
  - 4c (f6d66602): RoomDrawer.gd - the front desk (WALK-INS | THE DESK) and the mat room (CLASSES) put their side
    cards in a right drawer, closed by default (DeskCard covered 8.7% of the room, SlotCard 8.7%).
    NEW room_screen_layout_test 43/0: 8 rooms + 3 menus title at (402,120); closed drawers -> no card over the room;
    each tab opens its card alone, off the title plate, and closes again. Mutant (front desk without the drawer): FAIL 8.7%.
- Tests run this session: station_move_picker 80/0, ui_technique_preview 0, floor_drawer_expand 12/0, film_room 0,
  room_click_marks 78/0, home_pin_counts 0, day_feed_screen 0 (pin count derived, was a literal 4), skills_moves_screen 0,
  room_screen_layout 43/0, mat_room 0, front_door 0; --only training_floor,drill_mastery,spar,floor_,station_move,
  technique_preview,skills_moves,technique_training 16/17 (skills_moves_screen hit my concurrent MH2 apply; re-run alone
  green).
- NIGHTLY RED FIXED: front_door_test had asserted "$732 / every 2 weeks" since before ECON1 raised dues 12 -> 16 (S148);
  it now derives the worth from the definition (dues x 61 weeks, floor(worth / $320 wage)) with a non-vacuity check.
- OWED (said out loud): the room-systems --only subset (room,floor,office,locker,mat_room,staff,physio,film,lobby,
  front_door,shell,home_pin,day_feed,station_move) did NOT run - the watchdog stayed AMBER (78-81 C at 8% CPU) with two
  agents running, and CLAUDE.md forbids my test runs beside them when not GREEN. Every focused test of every touched
  script ran green alone. Next session runs it while collecting ROOMS2; the 05:00 nightly covers it first.

## Launched (running at handover - YOURS next session, collect, do not relaunch)
- MH3 (Codex gpt-6-astra, wt E:/FightCamp/wt/MH3, branch codex/mh3-walk, out E:/FightCamp/wt/MH3_out.txt):
  TASK_MH3_METAHUMAN_WALK_POLISH.md - bucket MH vs MPFB on the 22 certified moves (306 join_discontinuity rows on MH,
  0 on MPFB), fix the MH side (suspects: height_of includes hair cards -> wrong scale; watch_library folds only clips
  added after mount; foot mapping; root lift), s139 planted slide within 15% of MPFB, video + steps sheet.
  Switch stays OFF until the operator OKs the new video.
- ROOMS2 (Cline, wt E:/FightCamp/wt/CLINE, branch cline/rooms2, out E:/FightCamp/wt/CLINE_ROOMS2_out.txt):
  TASK_ROOMS2_BIGGER_BACK_ROOMS.md - staff room + physio 8x6 -> 10x7.5, locker 9x6 -> 10x7 re-framed to fill the view,
  furniture re-laid with its click boxes, _rooms2 stills. Merge after check_workflow + room tests + opening the stills.

## Queued, not done
- A floor door to the film room (SCENETREE2 "A door from the floor") - a 4th tier-1 door re-spaces every floor door
  and the decor cells; own item.
- TRAIN1 next slice on the 3D floor (D33 superseded the painted 2.5D floor): fighter + coach living loops at the station,
  progress bars / round-end floats (TRAINING_LOOP_DESIGN S4-S5). Then TUT1.

## Next (decision)
1. Collect ROOMS2 (Cline) and MH3 (Codex) - check_workflow, the tests their tasks name, open their stills/video;
   merge ROOMS2; MH3 merges OFF and its video goes to the operator for the walk verdict.
2. TRAIN1 slice 2 on the 3D floor (fighter + coach loop at the booked station, progress bar, round-end float).
3. Q213E relaunch only with the operator's OK; then Q213F.
