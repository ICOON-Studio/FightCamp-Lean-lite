# TASK MENUWEEK1 - CURSOR (Grok 4.7 High) - the Fighter Week page, built from the approved mockup

Status: OPEN (S405, Claude main). Discipline: boxing now, MMA parts drawn as not built. Model: grok-4.7-high.

## Contract
OWNS: scripts/ui/WeekBoard.gd, scripts/ui/WeekCards.gd, scripts/ui/WeekCardsPick.gd, scripts/ui/WeekCamp.gd, scripts/ui/WeekDay.gd, scripts/ui/WeekPops.gd, scripts/ui/WeekReadRows.gd, scripts/ui/WeekStrip.gd, tests/menu_week_test.gd
RED_TEST: tests/menu_week_test.gd -> MENU_WEEK failures=0
REGRESSION: week_actual_test, week_board_clarity_test, week_cause_test, week_coach_test, week_opp_test, week_phase_test, week_plan_test, week_read_test, week_strip_test, week_twist_test, kit_icon_test, first_week_test, golden_path_test, save_load_test, plain_words_test, no_pronoun_test
VISUAL: stills, opened by Claude after landing

## Read first
ops/research/MENU_BUILD_RULES.md (binding), docs/mockups/s403/fighter_week.html and fighter_week.png (the spec), scripts/ui/WarmKit.gd, scripts/ui/KitIcon.gd, and today's Week files listed in OWNS.

## Prior research
`python ops/Tools/prior_research.py week planner whiteboard`. Operator S354: morning sessions sum to a goal and an intensity, evening combos on the pads. Critic round 4: Fighter Week scored 8, the best of the seven.

## What would a human do?
A coach stands at the whiteboard on Monday, fills mornings and evenings, sees whether the week reaches the goal without burning the fighter out, and copies a good week forward.

## Prefab check
WarmKit and KitIcon exist. Nothing new to find.

## Build
1. Header: fighter tabs as today, week arrows and date range, This week / Next week, Coach runs it / I run it, Copy to next 4 weeks, Copy from a fighter, Back to the coach's week.
2. Gains line: this week's stat gains, read from the game's own numbers.
3. Fatigue ribbon across the camp: BUILD, PEAK, TAPER labels, the overreach line, the peak marked.
4. The week grid: Mon to Sun, AM and PM rows, each chip with its gain and load. Every chip comes from the sessions the game has today.
5. Session picker: the mockup's groups for the chosen slot. Rows the game lacks are drawn not built, one mark per panel.
6. Coach's line: one sentence with a Do it button, and Open Fight prep.
7. Side controls: weight, focus, intensity, sparring partner, this week's twist with its two options.
8. Learn on the pads: mastery ladder and the combination link to the Playbook.
9. Coach's pad nights and All eight weeks are drawn not built until row R55 lands.

## Do
1. FIRST split scripts/ui/WeekCards.gd: it is 543 lines, over the 500 limit. Move the session picker to scripts/ui/WeekCardsPick.gd with no change in behaviour, and run the REGRESSION list.
2. tests/menu_week_test.gd, printing `MENU_WEEK failures=<n>`, on a real career (`main.act("quick")`). It must fail on main. Cover: panels exist by name; putting a session in a slot changes the gains line and the fatigue ribbon the same way the game's rules do; Copy to next 4 weeks fills them; I run it then Back to the coach's week restores the coach's plan; not-built panels take no input.
3. Build inside OWNS.
4. Run REGRESSION. Do not edit an existing test's numbers.

## PR body
`RESULT: tests/menu_week_test.gd -> MENU_WEEK failures=0`, one RESULT line per REGRESSION test, the not-built list, and what moved.

## The one trap
The 10 attributes and 12 skills are not in the game yet. The mockup's names (Explosiveness, Fight IQ and others) are the future list: show today's names and numbers (MENU_BUILD_RULES rule 4), and never invent a gain.
