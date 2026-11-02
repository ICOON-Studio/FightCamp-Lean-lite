# S154 digest - ROOMS2B merged; modern exit signs; physio door, injury board, medical cabinet; floor shutter -> brick + windows (Claude, 2026-10-03)

Nightly read: 2026-10-03 at 9c53c6a4, 510 tests, 20 fail (AgentComms/nightly/latest.txt). Watchdog AMBER 80-83 C all session.

## What now works (evidence)
- ROOMS2B MERGED a4bc09bb (Cline e86f0e2c, owned diff only; check_workflow flagged 4 duplicate *_s153fix previews, left out):
  the training-floor door sign reads whole in office/mat/staff/physio; room_click_marks_test checks all 8 sign corners.
- MODERN EXIT SIGNS, every room (de60b098, TrainingFloor3D._doorway - one builder for all doorways): graphite panel in a thin
  frame, pictogram tile (green arrow = street exit, red first-aid cross = physio, house teal arrow = rooms), Inter SemiBold
  measured with `Font.get_string_size` so the panel always holds its words, glow strip. Operator: "use modern signs to the exits".
- PHYSIO DOOR "washed out": RoomFx.light_shaft assumed a BACK-wall window and ran a 6 m translucent slab along the physio's
  LEFT wall over the door. Found by hiding the room's node groups one at a time (lighting/SSAO/SSIL/glow/shadow arms all kept
  it). Left-wall windows (physio, staff) now keep dust, no shaft (a cross-room shaft read as a slab in the staff room).
- PHYSIO WALL: the 3 box-mannequin charts + box silhouette ("make no sense") -> one clinic INJURY BOARD (status magnet
  FIT/SORE/HURT, "M. BIANCHI", sore area + value, HOLD N WK); rows keep `Charts/<id>` and open the BODY LAB; row markers
  sit off the board's left edge (PhysioRoom3D.marker_points override).
- ROOM OBJECTS -> EXISTING MENUS (operator: "match the right assets with the right menus we already have"): treatment
  table -> the patient's body lab; the physio -> staff screen; hover names in OfficeRoomPanel._hover_label.
- MEDICAL CABINET (a91d8330): white steel, glass doors over shelves (tape, sprays, gauze, bandages), drawers, ISO green
  first-aid cross; out of the doorway (z 6.3). Replaces the grey Kenney bookcase.
- FLOOR TIER 1 (2730bdf7): the C225 roll-up shutter (a second street exit onto a blank yard once the club grew a front desk)
  -> full-height brick right wall with three high factory windows; daylight over the wall. Operator picked "Brick wall + high windows".
- Tests: room set 11/0 (physio_room +3 checks: table, physio, one board), physio set 4/0, floor set 6/0 - all --jobs 2 at AMBER.
  Stills opened: docs/previews/q232/{floor,lobby,office,locker,mat,staff,physio}_s154.png.
- J60 (John, free video generators) collected as reference (J60_FREE_VIDEO_GENERATORS.md) - its painted-rooms job died with D33.
- Briefs: TASK_TRAIN1B_FLOOR_DRILL_LOOP.md (launched on Cline 11:01), TASK_NIGHTLY1_CHRONIC_REDS.md (next free seat).

## Traps this session earned
- A left-aligned Label3D with no `width` puts the text's LEFT edge at `position` - do not add half the width.
- `RoomFx.apply(room, rect, wall)`: pass "left" for a side-wall window; the shaft only exists for back-wall windows.
- To find a render artefact no probe names: hide each top-level node group, render a crop per arm, tile them.

## Part 2 (same session, after the first handover block) - what landed
- SCHED1 part 2 DONE: LADDER tab; the cards board now agrees with booking on the level gate (it said BOOK on cards book_fight refused;
  46 locked / 6 open on the DevJump career) + "OPEN TO ..." line; SKIP TO NEXT DECISION on the NEXT UP card (advance_to_next_decision).
  schedule_my_gym_test 95/0. Commits c5b4ea57, 434d5e22 and the one after.
- NIGHTLY1 asset_manifest_test 39 failures -> 0 (b0fb3698): seven shipped asset folders had no manifest entry; each now has an honest one.
  OPEN ITEM: metahuman_boxers is marked approved only so shipped code may reference it - Epic's MetaHuman licence clause was never read
  first-hand (needs an Epic sign-in); CONFIRM BEFORE RELEASE.
- TRAIN1B MERGED (0a5fa4bf): picked move drilled on the 3D floor (clip, reps bar, +gain float). Cline died twice opening images through its
  file tool ("Hub connection closed"); Claude finished it. Never let Cline open images.
- TUT1 slice 1+2 MERGED (176b03cb, a217dc94): TutorialGuide (11 steps, 4 chapters, derived from the save), GameState tutorial_* API, GuideCard
  (bottom-right, skip/fold/skip-all), CareerRoot notes bill/ladder/week-review. tutorial_guide_test 35/0. OWED: slice 3 = the HANDBOOK button
  in the top bar (replay a chapter; the API tutorial_replay exists and is tested).
- MH3 COLLECTED, NOT merged (digest + light evidence ced25c4e): acceptance red (MH 59/88 findings vs MPFB 56/88; Kelvin 18 vs 14). Code on
  origin/codex/mh3-walk 5b9f5a21. MH3b send-back owed (nine landmark-floor findings, runtime sole dips).
- Q213E MERGED gate-side only (f964a08f): the clipping gate measures rendered skin. Honest table FAILS boxing_lead_uppercut, rear_hook,
  rear_hook_body (3.36 / 1.56 / 3.63 cm, defender's hand in attacker's head) - all in the certified demo palette.
- Q213F COLLECTED, NOT merged (baf08337 on origin/codex/q213c): elbow IK is a marginal gain (pinned 104/104 none worse, 7 improved; live >2 cm
  frames 10->8, 9->7, 4->3) and clears NONE of the 3 failing moves; it also carries the refused Q213D player changes.
  OPERATOR DECISION STILL OPEN: withdraw the 3 moves from the demo palette (recommended) / fix their clips (Q213G) / ship as is.
  Videos of the 3 moves with gloves: tools/q213_move_video.gd; sent to him.
- STAFF1 MERGED OFF (f5c2c9de): four clothed MetaHuman gym staff behind metahuman_staff (default OFF). Operator on the portrait: "why their
  hands look weird? it's weird pose" -> STAFF1b send-back launched on Codex 15:40 (STILL RUNNING at handover, wt E:/FightCamp/wt/STAFF1,
  out E:/FightCamp/wt/STAFF1b_out.txt). It carries only the MetaHumanRig.gd hunk of unmerged MH3.
- OPERATOR RULINGS: Codex OUT of rotation (STAFF1b is the last run); Claude + Cline do the tasks; Dola joins from this next session
  (memory project_agent_rotation_2026-10-03). Opus 5.5 for the next session.
- SpaceGame (a separate project, NOT FightCamp): E:\SpaceGame, private repo Guru-Meditation/space-strategy; its own Claude session was told to
  run the Cline GDD (prompts/GDD1.txt). Unity build in GitHub Actions needs the operator's UNITY_EMAIL/UNITY_PASSWORD secrets (he adds them).
- Mistake to not repeat: I ran a render at RED because my && chain checked the exit code of a pipe, not the watchdog's. Use
  `powershell ... pc_watchdog.ps1 -Once; echo rc=$?` and read it, never pipe it.

## GLOVES (operator, S154: "the gloves are still wrong ... wasted 2 hours ... prepare next session for opus 5.5 to fix them")
FIRST TASK next session. Read `research/GLOVES_HANDOVER_S154.md` before anything else. The operator has not said what is wrong; ask him with a
large close still, then fix it at the source.

## Next (decision)
1. GLOVES (above). 2. Ask/record the Q213 palette decision. 3. Collect STAFF1b (open its hands/pose stills yourself, send him the portrait;
switch stays OFF until he OKs). 4. Cline: MH3b, NIGHTLY1 reds (gloves_both_corners hang, readable_onset hang, flip-hangs), TUT1 slice 3 (HANDBOOK
button). 5. Rebuild the exe (S150-S154 are not in the S148 exe) and walk it with as_game. 6. Dola: brief only what prior_research shows is a gap.
