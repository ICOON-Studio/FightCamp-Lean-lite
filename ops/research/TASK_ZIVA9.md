# TASK ZIVA9 - get every area of the boxing demo to at least 9/10 (Ziva, continues ZIVAPLAYTEST1)

Operator S270, verbatim: "can you ask ziva to make it at least 9/10 in all aspects ?"
Model: Ziva Smart, reasoning MAX. Worktree E:/FightCamp/wt/ZIVA, branch ziva/playtest. Discipline: BOXING (demo) only.

## Where you start
Your report research/ZIVA_PLAYTEST_S267.md (on master since c9d18432) rated: first 5 minutes 6, gym floor loop 5, station
focus unrated, fight PENDING, corner PENDING, menus/HUD 7, overall 5.5. Goal: EVERY row >= 9/10, rated the same honest way
(a Steam reviewer of a management sim). A 9 needs evidence: what you played, the stills, the numbers. Never inflate a grade to
close the task; a row that cannot reach 9 without a new mechanic or a look change gets your proposal (see "Asks" below).

## The loop (repeat until every row >= 9)
1. Merge origin/master into ziva/playtest first (other seats land fixes daily), then play the as_game build the same way as before.
2. Rate every row. Pick the lowest row and the change that gains the most rating per hour.
3. Build it (you own the files below), run its parse gate and focused tests, take game-camera stills, view them yourself.
4. Commit + push ziva/playtest after EACH fix (small commits, one defect each), and update the ratings table at the top of
   your report (add a "Round N" table; keep the old ones).
5. Back to 1.

## First: finish the fight leg
You recorded fight frames (13/14/15_fight_*.png). Watch a whole as_game bout (record_room + still_framing.save_if_framed,
--fixed-fps 30), the corner between rounds and the result screen, and rate Fight watchability and Corner. Then the loop.

## What you OWN (only these areas; another seat holds the rest this week)
- The fight: motion, spacing, watchability, corner between rounds, result screen (you are already the motion seat,
  TASK_ZIVAMOTION1 / FIGHTMOTION1 / FIGHTGAP1).
- The gym day loop: P4 (the day passes unseen) and P10 (plan -> receipt), the day speed default (scripts/ClubSpeedControls.gd), the
  Day Plan panel, the station focus card, the end-of-day wrap (scripts/ui/DayWrapDrawer.gd), GymHall3D/GymClub3D day flow.
- P5: the coach offer must not sit on top of the day plan (InterviewPanel / where GymHall3D mounts it) - a chip or a later moment.
- HUD round 2 (Two Point top bar + modals, research/TWOPOINT_HUD_S268.md, tools/s268_topbar_stills.gd): the training
  modal shows the meters panel frame + title inside the modal (drop them when embedded); the boxer is hard to find (a Two Point style
  selection marker); RING REPORT and coach note cards as modals; tooltips on the stamina/strain icons.

## Do NOT edit (held by other seats right now)
- Cursor issue #288 ZIVAFIX1: scripts/CreationFlowPanel.gd, scripts/creation/GlobePicker.gd, scripts/creation/GymStepPanel.gd,
  scripts/creation/GymPreview.gd, scripts/ui/FloorHud2Widgets.gd, scripts/ui/HudV3Widgets.gd (P1 freeze, P2 globe, P7 preview, P9 placeholder).
- Claude (branch s270-b1): scripts/WeekReviewPanel.gd, scripts/GymHallPanel.gd, the creation money preview in GameState.gd
  (B1: NOT NOW on the coach offer now gives a self-run day instead of the next coach popping up; the review names the missing
  coach; P6: the creation burn charges what the bill charges). Re-rate those once they reach master; report what still hurts.
- scripts/MetaHumanRig.gd (operator S269 - leave it).
If a fix you need is inside one of these files, write it in your report as "NEEDS <file>: <what>" - Claude routes it.

## OWNERSHIP UPDATE (S270, operator: "ziva needs to have access to all the mechanics right ?" - yes)
Claude's s270-b1 fixes are on master (e3362838) and Claude no longer edits these files - they are YOURS now, with the whole gym loop:
scripts/WeekReviewPanel.gd, scripts/GymHallPanel.gd, scripts/TrainingHubPanel.gd and the training / week-programme / file_visit /
week-summary parts of scripts/GameState.gd (read in windows; never whole). Your Round 3 finding is the next fix and you land it:
the floor's filed days (GymHall3D._end_visit -> GameState.file_visit lived records) must be what the Training page, its PLANNED
header and the week review count. Rules: a test that is RED on master first (the as_game player path: NOT NOW / hire, START DAY,
the day runs, week review -> must list the fighter and his gains); NO double counting - measure the week's stat gain with and
without your change (the daily programme slices vs the lived day) and write both numbers in the report; keep
tests/week_review_no_coach_test.gd, self_run_day_test.gd, floor_gain_test.gd, floor_gain_coach_day_test.gd green.
Still Cursor's until #288 lands: CreationFlowPanel.gd, creation/GlobePicker.gd, creation/GymStepPanel.gd, creation/GymPreview.gd,
ui/FloorHud2Widgets.gd, ui/HudV3Widgets.gd. Also yours: the grey screen after [Fast] (Round 3 still 38).

## Asks (do not invent these - they need the lead designer or the operator)
A new mechanic, a new screen, a changed look direction, money/price numbers, or anything MMA: write it as a proposal in the report
(problem, the Two Point / FM / Undisputed reference, your fix) and carry on with the next row. Claude sends it to Ludo / the board.

## House rules (same as before)
- Watchdog before every heavy run: `powershell -NoProfile -ExecutionPolicy Bypass -File E:/FightCamp/Game/Tools/pc_watchdog.ps1 -Once`
  - exit 1 (RED) = wait, do not start. The PC is at RAM 95% now: keep ONE Godot run at a time beside your editor; kill runs by PID only.
- Nothing on the operator's monitors: windowed Godot only via Tools/godot_hidden.ps1; view images with your file tool.
- Stills only through tools/still_framing.gd save_if_framed (both boxers head to feet in frame); boxers wear boots.
- Tests: parse gate (`python Godot/tools/check_scripts.py <files>`), then the focused test; never the full suite; a visual fix needs
  a still from the game camera, not only a test. New features ship ON (GameSwitches.GAME_ON); plain --script tests are the OFF arm.
- Move the operator's saves aside and back exactly as you did in ZIVAPLAYTEST1 (hash check).
- Commit messages end with: Co-Authored-By: Ziva <ziva@fightcamp.local>. Never commit to master; Claude collects ziva/playtest by diff.

## Done
Every row >= 9/10 in the latest Round table, each with its evidence, all fixes pushed on ziva/playtest, and a short list of the
proposals and NEEDS lines for Claude.
