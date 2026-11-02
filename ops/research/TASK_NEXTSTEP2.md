# TASK_NEXTSTEP2 - the NEXT STEP card on her page (Cursor)

Model: Cursor (composer default). Discipline: BOXING = demo work (operator Q-S294-59 "Yes, those two first"). Repo:
**E:\FightCamp\Lean** (worktree E:\FightCamp\wt\LEAN_NEXTSTEP2, branch `cursor/nextstep2`). Lean rules: its CLAUDE.md, no
script over 500 lines, Godot headless only, nothing opens on the screen.

## Why
The player cannot see where his boxer is going. `scripts/rules/NextStep.gd` (merged S337) already computes her road: five
steps (First bout, Nationals ready, The nationals, Pro offer, Pro debut), the lit one, and one line of what it needs.

## Spec
1. `scripts/ui/areas/FighterPage.gd`, OVERVIEW tab (`_overview`, tab 0): FIRST card, titled "NEXT STEP": a row of the five
   steps as chips - done ones muted with a tick, the lit one in `UI.GOLD`, later ones plain - and under it the `need` line in
   `UI.BODY` size. When every step is done (lit -1) the card says "Pro - every step done".
2. Build NextStep.road's input from the career in ONE small function `_road_input(c, f) -> Dictionary` on the page (or a static
   on `scripts/state/Champs.gd` if it fits better): bouts = `Champs.bouts(f)`, w = `f["w"]`, reg_days = `Champs.club_days(c, f)`,
   age, injured = `Injuries.out(c, f)`, rank, pro_declines, nat_final, nationals ("entered" while `Champs.active(f)` and her draw
   is not over; her result words once it is; "" otherwise - read how Champs records it), pro, pro_bouts (her pro results in
   `c.results` with `pro` true). Read Champs.gd in windows; it is long.
3. Nothing else on the page moves.

## Contract
OWNS: Lean/scripts/ui/areas/FighterPage.gd, Lean/tests/next_step_card_test.gd (and Champs.gd only if the input function goes there)
RED_TEST: tests/next_step_card_test.gd -> PASS next_step_card_test
REGRESSION: golden_path_test, grey_reason_test, next_step_test
VISUAL: yes (Claude renders the page on the hidden desktop and checks it)

## The test (write it FIRST; red on main)
`tests/next_step_card_test.gd` (extends SceneTree): start a quick career the way tests/golden_path_test.gd does, open her
fighter page (OVERVIEW), and check: a card titled "NEXT STEP" exists and is the first card; it shows the five step names;
exactly one is lit; the need line equals `NextStep.road(<her input>, c.day)["need"]` and is not empty. Then give her 5 bouts and
100 registered days (edit the career the way the golden path does), rebuild the page: the lit step is now "The nationals" or
later. Ends `PASS next_step_card_test` / `FAIL <n>`, quit(0/1); a SCRIPT ERROR line is a failure even with exit 0.
Command: `"%LOCALAPPDATA%\Programs\Godot\Godot_v4.7.2-stable_win64.exe" --headless --audio-driver Dummy --path . --script res://tests/next_step_card_test.gd`
then the three REGRESSION tests the same way. The plain exe only; stop any Godot run you started that hangs, by its PID.

## Final answer
`RESULT: tests/next_step_card_test.gd -> PASS next_step_card_test`, the need line printed for the new career and after the
edit, the last lines of each run, the files touched.

## Prior research / human / prefab
NextStep.gd + next_step_test (S337); Dojo Legacy idea (operator Q-S294-59). A coach keeps the long road in view and gives one
line for this week. Prefab: none - our own card. Trap: never recompute the road on the page; NextStep.road is the one source.
