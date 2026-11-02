# S275 DIGEST (2026-10-20) - the operator's S274 playtest list, Codex on the gym floor, one top bar

## What now works (each on master, tests named)
- **New career = empty gym** (playtest #1, 711ecf26): the story start no longer keeps Mara while the story is OFF.
  tests/new_career_empty_gym_test.gd (as_game; story=1 arm keeps her).
- **Nothing opens by itself on the floor**: day-1 HIRE A COACH card -> applicants wait behind the chip / bar badge, an empty gym meets a
  FIGHTER first (switch applicant_chip_only, c5ba8507; operator "is that what ludo proposed?" - no, Ludo S270 said non-blocking).
  The morning Day Plan drawer -> day_plan_on_demand: the morning starts the suggested plan, PLAN opens it (operator "why this is still
  showing up ? are you trolling ?"). tests/applicant_chip_first_test.gd.
- **Codex FLOORTPM1 steps 0-2** (c5ba8507): Two Point numbers (TPM_FLOOR_NUMBERS_S275.md), FREE CAMERA (right-drag pan, wheel zoom to cursor,
  follow on F only; switch free_camera), rooms = glides of the one camera; Claude fixed Ludo zoom names, far re-fit per yaw, mirrored room
  floor names. Codex's ChatGPT plan EXPIRED after step 2 (operator) - steps 3-5 not started by anyone.
- **Cursor PLAYFIX275 items 2-5** (4fdf25e3): dock hidden on the floor, bout countdown in the bar, one right-side drawer, fight plan needs
  a bout, camp setup centred. Item 1 (11 attributes on the cards) broke 5 plain tests -> NOT taken, Cursor round 2 running (#302).
- **ONE TOP BAR** (this commit, switch one_top_bar; ui/OneTopBar.gd): [back][forward] [OFFICE v][WORLD v] [floor: PLAN, APPLICANT] ...
  [speed + date] [money] [bell][options] on every career screen; the gym crest/name, the page-icon dock and the floor's second bar are gone;
  OFFICE = gym floor, desk, my fighters, scout, training, staff, finances; WORLD = news, fighters, promotions, schedule. SceneRouter
  history_back/forward. The date plate was dark-on-dark on every screen (TimelineBar) - light brass again. tests/one_top_bar_test.gd.
- Ziva ROKOKOMOVES1 collected (03cbc6cd): guard = two long captured windows (no 2 s loop), body cross = actor's own.
- FOCUSPOP1 (acfb6458), NIGHTLY12 part 1 (53340738: af_motion, asset_manifest, stat_vocabulary - Goose's regex dodge NOT taken).
- Tools: clean_view.gd (stills close pop-ups first - operator "what prevents you from taking clean pictures"), fight_motion_probe TREMBLE,
  s275_route_still.gd / s275_hud_dump.gd / s275_floor_walk_probe.gd, board_reconcile live-process fix.

## C124 "their hands are trembling" - measured, handed to Ziva (TASK_ZIVATREMBLE1)
Guard hand reverses 2.2x/s, zig 15 mm; raw clip 0; ~80% from contact_solve + contact_stop (table in the brief). Ziva chat started 17:40;
the PC FROZE + restarted at ~19:15 - the Ziva editor/MCP is DOWN (ECONNREFUSED): check its chat/branch first.

## PC freeze (S275, ~19:15)
Two Godot test runs at once (27 tests --jobs 2 + one more) beside Chrome 7 GB. Rule kept in memory: ONE test job at a time.

## Open / next (in order)
1. Collect in-flight: Cursor #302 round 2 (cards), Goose #303 round 2 (4 nightly reds), Arena FIGHTLINK2B + ATTRWIRE1, Ziva ZIVATREMBLE1.
2. Playtest #3 "he is walking but not moving" - NOT fixed: run tools/s275_floor_walk_probe.gd (written, never run) on the real route,
   then fix; Codex's uncommitted step-3 walker work sits in wt/ANIMSOURCE1 (smoothed routes, 900 deg/s turn, 1.85 m/s walk-ins, coach 1.35).
3. FLOORTPM1 steps 3-5 (people walk + station use + build mode) need a seat: Codex plan expired - operator's call to renew; else Claude.
4. Bar polish from the stills: goal pill under the bar; OFFICE menu rows for Contracts/Rankings if he wants them.
5. Pre-existing as_game reds (not ours): club_camera_orbit, gym_floor_view, iso_camera, room_info_hud, rooms_training_hud,
   see_through_occluders, top_bar_timeline, hud_v3_layout hang.
