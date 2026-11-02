# TASK GOALSTRIP1 - the camp's GAINS and ATTRITION bars on the gym goal card (boxing)

Model: Cursor (cloud). Discipline: BOXING (demo).

## Why
Operator board Q-S249-4 (S255): "Approve" - the S255 slice is "ONE screen with a deadline goal plus GAINS and ATTRITION meters that
show the day the player must change the plan". Design: Ludo r119 section 2 (research/ludo_rx/LUDO_R119_raw.txt:30-56) - the
mockup there is the spec. The numbers already exist: `Godot/scripts/rules/CampMetersFeed.gd` (S257) `read(athlete, opponent, days_left)`
returns `{readiness, ready_target (80), on_track, wear, band (fresh|productive|change_plan|breakdown), alert, days_left, opponent,
weight_gap_kg, inputs{...}, advice{drop_stations, recover}}`. Nothing draws them.

## The route the game runs (trace it, do not guess)
`Godot/scripts/GymHall3D.gd` (4,795 lines - read only `sed -n 2170,2260p`): `_goal_refresh()` builds `goal_card` (`scripts/ui/GoalCard.gd`,
380 lines) at the top centre of the gym HUD and calls `goal_card.show_goal({...})`. The booked opponent is `spar_opponent()` (:2931);
the athlete row is `_wire_athlete()`; the goal read gives `days_left`.

## Files you own
1. EDIT `Godot/scripts/ui/GoalCard.gd` - a new `show_meters(strip: Dictionary)` that draws TWO bars under the goal rows, exactly the
   r119 mockup: `GAINS: READINESS  [bar]  68%  TARGET >= 80%` (target tick at 80) and `ATTRITION: WEAR  [bar]  44%  DANGER >= 60%`
   (tick at 60). Wear bar colour by band: fresh/productive cool, change_plan amber, breakdown red. When band is change_plan or
   breakdown the card border goes amber/red and one line under the bars says: "CHANGE THE PLAN - drop sparring and heavy bag, recovery
   work until wear < 50". Bars tween and pulse on a band change (operator rule: every meter animates - UITokens/UIKit helpers, as the
   goal rows already do). `show_meters({})` hides them. Keep every existing goal row and test behaviour.
2. EDIT `Godot/scripts/GymHall3D.gd` - in `_goal_refresh()` only, after `show_goal`: if `GameSwitches.on("camp_meters")` and a fight is
   booked (`spar_opponent()` not empty), `goal_card.call("show_meters", CampMetersFeed.read(athlete_or_row, spar_opponent(), days_left))`,
   else `show_meters({})`. One preload line `const CampMetersFeed := preload("res://scripts/rules/CampMetersFeed.gd")`. Name the line window.
3. EDIT `Godot/scripts/GameSwitches.gd` - key `camp_meters` in `GAME_ON` (operator S221: new features ship ON); plain `--script` tests
   are the OFF arm.
4. NEW `Godot/tests/goal_strip_test.gd` (OK/FAIL lines; ends `print("GOAL_STRIP failures=%d" % failures)`, `quit(0 if ok else 1)`):
   a GoalCard given a strip with readiness 68 / wear 44 shows two bars whose fill targets are 0.68 and 0.44 and the 80/60 ticks; wear
   65 -> amber band + the change-the-plan line visible; wear 85 -> red; `show_meters({})` hides both; a GymHall3D test with the switch
   forced on (`game_state.career["camp_meters"] = true`, as tests/weigh_scale_test.gd does) and a booked fight holds the bars; no
   booking -> none. Red on master first.

## Acceptance
- `tests/goal_strip_test.gd` + `tests/camp_meters_feed_test.gd` + the goal card tests (`grep -l "GoalCard" Godot/tests`, at most 6) pass.
  PR body: `RESULT: tests/<x>_test.gd -> <pass line>` lines + the line windows edited.
- Claude takes the still on the gym's own iso camera and opens it; you cannot see images - report the bar rects in pixels.

## Prior research
LUDO_R119_raw.txt s2 (the mockup + thresholds), PRODUCTION_ROADMAP_S254.md "S255 READ", TASK_CAMPMETERS1.md (the pure module),
feedback "Animated meters" (every bar tweens + band-change pulse), TWOPOINT_ALIGNMENT.md (HUD stays clear of the room).

## What would a human do?
A trainer's whiteboard in camp: days to the fight, how ready he is, how beat up he is - and the day the beat-up line crosses the danger
mark, he pulls sparring and sends him to the pool.

## Prefab check
Godot ProgressBar/Panel + the project's UIKit/UITokens bars already used by GoalCard - no new asset.

## The one trap
Do not change CampMeters/CampMetersFeed numbers or the goal rows' maths - draw what they return.

## VISUAL GATE (.claude/skills/visual-gate/SKILL.md)
1. First run the gate on master's shipped clip: it must read RED on <the defect>; paste that number in your report.
   (Here: goal_strip_test must fail on master - no show_meters.)
2. Stills only via record_room.gd -- as_game + still_framing.gd save_if_framed: guard, contact frame, one between.
   (Here: Claude takes the gym HUD still on the iso camera.)
3. For every still report: gap between bodies / where each nose points / wrists in line / feet / the defect / which bodies.
   (Here: the bar rects, their fills, that nothing covers the boxer card or the ring.)
4. Do not call it accepted or fixed. Claude opens every still; the operator closes it.

## Contract
OWNS: Godot/scripts/ui/GoalCard.gd, Godot/scripts/GymHall3D.gd, Godot/scripts/GameSwitches.gd, Godot/tests/goal_strip_test.gd
RED_TEST: Godot/tests/goal_strip_test.gd -> GOAL_STRIP failures=0
REGRESSION: goal_strip_test, camp_meters_feed_test
VISUAL: yes
