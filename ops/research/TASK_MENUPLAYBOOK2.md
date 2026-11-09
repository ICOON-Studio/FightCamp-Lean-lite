# TASK MENUPLAYBOOK2 - CURSOR (Grok 4.7 High) - the Playbook, round 2: to the mockup, on one screen

Status: OPEN (S408, Claude main). Discipline: boxing now, MMA parts drawn as not built. Model: grok-4.7-high.

## Contract
BASE: cursor/menuplaybook1
OWNS: scripts/ui/areas/Playbook.gd, scripts/ui/GamePlan.gd, scripts/ui/GamePlanRows.gd, scripts/ui/PlanRuler.gd, scripts/ui/PlanRateChart.gd, tests/menu_playbook_test.gd, tests/game_plan_test.gd
RED_TEST: tests/menu_playbook_test.gd -> MENU_PLAYBOOK failures=0
REGRESSION: game_plan_test, kit_icon_test, move_book_test, move_tip_test, bjj_tree_ui_test, first_week_test, golden_path_test, save_load_test, plain_words_test, no_pronoun_test
VISUAL: stills, opened by Claude after landing

## Read first
ops/research/MENU_BUILD_RULES.md (binding), docs/mockups/s403/playbook.html and playbook_combos.html (the spec; open the html, you cannot see the png). Worked example of every layout fix below: scripts/ui/WorldLadder.gd and scripts/ui/areas/World.gd on main. ops/research/GDSCRIPT_TRAPS.md.

## Prior research
Claude rendered this branch (23h_playbook_plans) and compared it with the mockup. The list below is what that showed.

## What would a human do?
Put the whole plan in front of the coach on one screen: the lines, the fight shape and the move playing, with no scrolling.

## Prefab check
None needed: WarmKit and the existing MovePlayer are the parts.

## Faults to fix (each seen on the render)
1. WALL: the page sits on the old blue. Add WarmKit.wall() to the holder exactly as World.gd build() does, and let the page fill the holder's full height (size_flags_vertical = SIZE_EXPAND_FILL), so the plaster reaches the bottom of the screen.
2. RULER TEXT CUT: the distance cards show "Doubl" and "Stej". Every move name on a ruler card shows whole. Test: for each card, text width <= label width.
3. STRETCHED BARS: the skill pips, the drilled bar and the rate chips stretch to the row's height, and the pips break out of their pills in the move book. Set size_flags_vertical = SIZE_SHRINK_CENTER and a fixed small height (pips 12 px, drilled bar 10 px). Pips sit inside their pill. Test: the drilled bar's height <= 12 px.
4. ONE SCREEN: at 1920x1080 with the guide hidden, the board ends above the bottom of the screen and Fight shape is on it. Show the five distance lines and one spare line as in the mockup. The other places (own ropes, opponent's ropes, corner) and the "+ When" chips fold behind one "More lines" row that opens in place. No data is lost: arrows still read and save for every place. Test: board bottom <= 1080; the Fight shape node is inside it.
5. MOVE PLAYER ON SHOW: top of the right column is the chalk-framed player, always visible, showing the last hovered or first planned move, with Watch, Slow, Steps, Replay and Drill on pads under it. The move book sits below, one row per group as in the mockup. Do not add a second viewport (move_tip_test: exactly one).
6. FIGHT SHAPE as the mockup's dark band: Fight starts and Rounds rows.
7. game_plan_test IS RED ON THIS BRANCH (12 checks; you did not run it). Keep what each check means. Lines nested deeper: use a recursive find. Not removed: PlanMeter, the coach's locked lines ("A coach rated..." tooltips, test 2), "Beats it" on the answer card (test 3), Line_mid_loadup when adding a situation (test 6). If a check's feature was truly moved, say where in the PR body and point the check there.

## Rules
Do not change PlanLines, PlanBoard or what gets saved on fighter.arrows. No file over 500 lines. Godot only through `python ops/Tools/godot_slot.py run --who cursor -- <godot cmd>`, headless, --audio-driver Dummy, never _console.exe. Nothing opens on the monitors.

## The one trap
A render on the hidden desktop is 1009 px tall. Test the fit at 1920x1080 in the test, not by the picture.

## Result lines (PR body)
RESULT: tests/menu_playbook_test.gd -> MENU_PLAYBOOK failures=0
RESULT: tests/game_plan_test.gd -> GAME_PLAN PASS
