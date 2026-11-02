# TASK FLOORGAIN2B - the coach-run day's confirm drawer + amber warning (Codex)

Model: Codex luna. Worktree E:/FightCamp/wt/FLOORGAIN2B, branch codex/floorgain2b from master (fd8903ba or later). Push the branch; never master.
NEVER open a window, image viewer or browser. Godot windowed only via `powershell -NoProfile -ExecutionPolicy Bypass -File Tools\godot_hidden.ps1 <args>`;
headless tests with `Godot_v4.7.2-stable_win64.exe` (never `_console.exe`).

## Prior research
- Design (operator took it S188): `research/LUDO_LOOPS_S188.md` Q2 - "Skipping never executes silently. Hitting Skip opens a
  1-second confirm drawer: 'Coach Miller will oversee: Focus: Jab Card, Est. Day-End Stamina: 38. Risk: 0%.' If a booked camp goal
  is in jeopardy (e.g. weight over limit), the button turns amber with an explicit warning."
- FLOORGAIN2 core (S189, fd8903ba): `GymHall3D.coach_runs_rest(cards)` runs the rest of the day under the coach at
  `CareerMorning.coach_day_efficiency()` (0.8) using `CareerMorning.coach_rest_of_day(minute, cards)`; `GymHallPanel.end_day()`
  calls it while a visit runs. HUD2's CONTINUE reaches it through `CareerRoot.on_continue` -> `content.end_day()`.
  Test: `Godot/tests/floor_gain_coach_day_test.gd` (keep it green).
- UI rules: icons with tooltips (GLOSSARY 'Icon with tooltip'), `UIKit.tip`, never bare `tooltip_text`.

## What would a human do?
Make the hand-off visible and reversible for one click: the first CONTINUE during a visit opens a small drawer over the hall HUD that
names what the coach will do; CONTINUE (or the drawer's HAND HIM OVER button) a second time confirms; BACK closes it and play goes on.

## Prefab check
N/A - our own HUD in GymHall3D.gd (same build style as the block stop panel `_stop_panel`, ~line 1557).

## Spec
1. `GymHall3D.coach_day_preview(cards: Array) -> Dictionary` (pure read, files nothing, changes no state): runs the same full plan
   `coach_runs_rest` would run through `Splice.run` and returns {coach_minutes, end_stamina, injury_risk, focus_card (first carded
   order's card or ""), stations: [station ids in order], coach_name (from the staff coach the panel passes in ctx, or "The coach")}.
   Refactor so `coach_runs_rest` and the preview share ONE plan builder (no copy).
2. A drawer node `Hud/CoachDayDrawer` (hidden by default): "<COACH> RUNS THE REST OF THE DAY" + one line "Focus <card> · ends at
   stamina <n> · risk <n>%" + "Coach-run minutes pay 80% of yours" + buttons HAND HIM OVER (confirms) and BACK.
3. `GymHallPanel.end_day()` while a visit runs: first call opens the drawer (time stays paused while it is open); a second call while
   it is open confirms (= `coach_runs_rest`). BACK hides it and the clock resumes.
4. AMBER: when the fighter's booked camp has a weight goal off track (use what GameState already exposes for the weight cut / scale -
   find it with grep `weight` near `act_on_weight_cut` ~2132 and the camp's diet; if nothing clean exists, use: walking weight above the
   division limit with the fight within the camp), the drawer's header turns amber and adds "Weight plan off track (+x.x kg)".
   No amber otherwise.

## Done = (tier: scripts edited -> parse, the focused tests, then --only suites)
- New test `Godot/tests/coach_day_drawer_test.gd`: RED on master fd8903ba first (paste its FAILS count): first END DAY during a visit
  files NOTHING and shows the drawer with the preview numbers; the preview equals what the confirm then files (end stamina within
  0.01); BACK -> drawer hidden, still running, nothing filed; confirm -> one lived day filed with coach_minutes > 0; amber shows only on
  an over-limit fighter (CONTROL: an on-weight fighter shows no amber).
- `python Godot/tools/check_scripts.py <touched .gd>`; the new test; `python Godot/tools/run_tests.py --jobs 2 --only <x>` for
  floor_gain, gym_hall, career_morning, daylap, hud2, club, continue - all green.
- `python Tools/check_workflow.py branch codex/floorgain2b FLOORGAIN2B` -> MERGEABLE. Final message: commit hash, FAILS red->green, suites.

## The one trap
`gym_hall_mornings_wired_test.gd` and `floor_gain_coach_day_test.gd` call `panel.end_day()` ONCE and expect a filed day - update those
two call sites to confirm (call end_day twice, or a `confirm := true` argument), never weaken their assertions.

## Owned files
- `Godot/scripts/GymHall3D.gd`
- `Godot/scripts/GymHallPanel.gd`
- `Godot/tests/coach_day_drawer_test.gd`
- `Godot/tests/floor_gain_coach_day_test.gd`
- `Godot/tests/gym_hall_mornings_wired_test.gd`
- `HANDOFF.md`
- `research/TASK_FLOORGAIN2B_COACH_DAY_DRAWER.md`
