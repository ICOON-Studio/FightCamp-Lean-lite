# TASK GYMLOOP10 - the one-boxer gym day reads clearly: Day Plan drawer, end-of-day receipt with one choice, one meter read

Model: Cursor (cloud). Discipline: BOXING (demo).

## Why (approved: LUDO_R_S270_VERDICT.md "BUILD NOW" items 4, 6, 7; operator S274 "back to the gym floor loop and design")
Ziva rated the one-boxer gym loop 5.5/10 (ZIVA_PLAYTEST_S267.md); the multi-boxer puzzle (operator's idea) is parked until the
one-boxer day rates >= 9 (LUDO_MULTIBOXER_S270_VERDICT.md, operator "ok"). Items 1-3, 5, 9-13 of Ludo's 10/10 list are on
master (603acc7c, 5983d0c6, f769e3b6). Left: the three below.

## What to build (in the GAME path - GymHall3D is what the player sees; trace it, do not guess)
4. DAY PLAN AS A NON-BLOCKING DRAWER. Today the plan panel (Godot/scripts/ui/DayPlanPanel.gd, 538 lines; opened in
   GymHall3D.gd ~2736-2850 `_dp_panel = DayPlanPanelUI.new()`, START DAY ~2849) covers the floor each morning. Make it a drawer
   docked on one edge (the Two Point rule: TWOPOINT_HUD_S268 / HUD = top bar + modals - decisions may be modal, but the morning
   plan must leave the floor and the boxer visible). On START DAY the drawer tucks away (a tab stays to reopen it) and the camera
   follows the boxer to his first station (the iso camera's existing focus call - find it, do not add a second camera path).
   The plan stays a decision the player makes each morning (operator S267: "you set his program then watch him do it").
6. END-OF-DAY RECEIPT WITH ONE CHOICE. Extend Godot/scripts/ui/DayWrapDrawer.gd (426 lines; show_day ~242 already has top gains,
   coach line, trained/idle/coach minutes, stamina): add the day's COST (wages + gym upkeep the live money model charged today -
   read it, never compute a second number), FATIGUE / readiness for tomorrow (the live BodyReadiness read), and ONE choice with
   two buttons: KEEP THE PLAN or TOMORROW = RECOVERY (sets tomorrow's Day Plan to the recovery program the plan board already
   has). Never a new screen; numbers only from the live model (LUDO_R_S270_VERDICT "two models = two truths" - no new formula).
7. ONE METER READ. Drop the duplicate STAMINA / STRAIN bars on the floor HUD - the TrainingMeters panel (rules/TrainingMeters.gd,
   ui/TrainingMetersHud, GymHall3D ~2059) is the one read. List every place a stamina/strain bar is drawn for the floor before
   you remove one (GymHall3D, GymHallPanel.gd 1,509 lines, HUD top bar); keep the fight's bars untouched.

## Tests (GAME_ON switch: these are visible changes to approved features -> no new switch needed; plain --script tests stay the
## OFF control arm, run your tests `-- as_game`)
- A test per item, red on master: day_plan_drawer_test (START DAY leaves the floor visible: no full-screen Control over the
  viewport rect; the drawer tab exists), day_wrap_choice_test (the receipt shows cost + fatigue + both buttons; RECOVERY sets
  tomorrow's plan to the recovery program; KEEP leaves it), floor_meters_single_test (exactly one stamina read on the floor HUD).
- Regression: floor_week_bookkeeping_test, self_run_day_test, speed_lock_day_one_test, week_review_no_coach_test, plain + as_game.
- Parse gate: `python Godot/tools/check_scripts.py <touched .gd>`.

## Owned files
Godot/scripts/ui/DayPlanPanel.gd, Godot/scripts/ui/DayWrapDrawer.gd, Godot/scripts/GymHall3D.gd (5,384 lines - sed -n windows
around the anchors above only), Godot/scripts/GymHallPanel.gd (only to remove a duplicate bar), the three new tests.

## Prior research
LUDO_R_S270_VERDICT.md (items 4/6/7), ZIVA_PLAYTEST_S267.md (the 5.5 rating and why), TWOPOINT_HUD_S268 + TWOPOINT_ALIGNMENT.md
(operator S244: every gym item follows Two Point), feedback: HUD = top bar + modals, no flavour text, animated meters.

## What would a human do?
Two Point Museum: you plan on a side panel while the building stays visible, press go, and the day's summary comes back as
one small card with one decision.

## Prefab check
n/a - our own panels.

## The one trap
Never invent a number on the receipt - every figure is read from the live model; a figure the model does not have is left out
and listed in the PR.

## VISUAL GATE (.claude/skills/visual-gate/SKILL.md)
Stills on the game's iso camera (record_room / the gym capture tools, as_game): the morning with the drawer open, the floor right
after START DAY, the receipt. Claude opens every still; the operator closes it.

## Contract
OWNS: Godot/scripts/ui/DayPlanPanel.gd, Godot/scripts/ui/DayWrapDrawer.gd, Godot/tests/day_plan_drawer_test.gd, Godot/tests/day_wrap_choice_test.gd, Godot/tests/floor_meters_single_test.gd
RED_TEST: Godot/tests/day_wrap_choice_test.gd -> DAY_WRAP_CHOICE PASS
REGRESSION: floor_week_bookkeeping_test
VISUAL: yes
