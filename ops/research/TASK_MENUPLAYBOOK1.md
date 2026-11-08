# TASK MENUPLAYBOOK1 - CURSOR (Grok 4.7 High) - the Playbook's game plan and Combos, built from the approved mockup

Status: OPEN (S403, Claude main). Discipline: boxing now, MMA parts drawn as not built. Model: grok-4.7-high.

## Contract
OWNS: scripts/ui/areas/Playbook.gd, scripts/ui/GamePlan.gd, scripts/ui/GamePlanRows.gd, scripts/ui/PlanRuler.gd, scripts/ui/PlanRateChart.gd, tests/menu_playbook_test.gd
RED_TEST: tests/menu_playbook_test.gd -> MENU_PLAYBOOK failures=0
REGRESSION: kit_icon_test, move_book_test, move_tip_test, bjj_tree_ui_test, first_week_test, golden_path_test, save_load_test, plain_words_test, no_pronoun_test
VISUAL: stills, opened by Claude after landing

## Read first
ops/research/MENU_BUILD_RULES.md (binding), docs/mockups/s403/playbook.html/.png, playbook_ground.html/.png, playbook_combos.html/.png (the spec), scripts/ui/WarmKit.gd, scripts/ui/KitIcon.gd, and today's scripts/ui/areas/Playbook.gd, GamePlan.gd, GamePlanRows.gd, ComboBuilder.gd.

## Prior research
`python ops/Tools/prior_research.py playbook combos`. Operator: the Combos tab is "really fun to try and also learn from the book". Do not rewrite how it works: the Combos work in this task is its place on the page, and ComboBuilder.gd is not yours to change.

## What would a human do?
A coach looks at the plan as a map of the distances: where do I have an answer, where is the hole, and how sure am I.

## Prefab check
The moving body in today's move preview is better than the mockup's stick figure: keep the real body and add the lit target zone only if it is cheap. Say which you did.

## Build
1. Game plan and Combos as two halves of the Playbook, switched at the top. On Game plan: Standing and Cage and ground tabs. Cage and ground not built: full colour, one mark.
2. Standing: a ruler of the five distances with the answer chip at each, red dashed where there is no answer, above the list of lines. Line rows: drag handle, place, answer, level, rating, drilled bar, change, clear. An empty line says "drag a move here".
3. Ratings are marked as estimates (hatched, "?") until the opponent is scouted. Today's rating code decides the word; this only marks how sure it is.
4. Sound plan as a number out of 6, beside a five-bar chart: the plan against each kind of opponent, from today's rating code.
5. Locked "no tell found" line offers scouting with its price and what it opens. Fight starts and rounds fold into one Fight shape row. Find a coach on moves that need one.
6. Move book by group with level pips, using KitIcon group icons.

## Do
1. tests/menu_playbook_test.gd FIRST, printing `MENU_PLAYBOOK failures=<n>`, on a real career. It must fail on main. Cover: panels exist by name; ruler has one chip per distance and flags an empty one; ratings show as estimates unscouted and plain after scouting; the five bars come from the rating code; a plan line set here is the same line the fight reads; Game plan and Combos both open; every action on today's page is still reachable.
2. Build inside OWNS.
3. Run REGRESSION. Do not edit an existing test's numbers.

## PR body
`RESULT: tests/menu_playbook_test.gd -> MENU_PLAYBOOK failures=0`, the not-built list, and what moved.

## The one trap
GamePlan feeds the fight: move drawing, not data. The saved plan's shape must not change or save_load goes red.
