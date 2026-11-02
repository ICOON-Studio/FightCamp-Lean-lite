# TASK_PLANSCREEN1 - the coach's plan board on the boxing move map (Cursor)

Model: Cursor (composer default). Discipline: BOXING (the plan board is ONE mechanic for boxing and wrestling, operator
Q-S294-62 "Yes, in that order"; this task is the boxing half; the wrestling half reuses the panel after TIEUPS1 lands).
Repo: **E:\FightCamp\Lean** (worktree E:\FightCamp\wt\LEAN_PLANSCREEN1, branch `cursor/planscreen1`). Lean rules: its
CLAUDE.md, no script over 500 lines, Godot headless only, nothing opens on the screen.

## Why
The coach plans a fight as arrows on a move map: from a range card, which moves she throws, where they land. The rules exist
(`scripts/rules/PlanBoard.gd`, merged S337: arrow_limit by coach skill, validate, coverage, chains, change_one, rate for
undrilled moves) and the boxing map exists (`scripts/ui/StrikeBrowser.gd`, `-- jump=strikemap`: StrikeMap's 8 cards, moves
out/in, a walked route along the bottom). Nothing lets the player BUILD a plan yet. This task turns the route into a plan.

## Spec
1. NEW `scripts/ui/PlanPanel.gd` (sport-free, so the wrestling tie-ups reuse it): a VBox the browser adds; static or instance
   functions taking `map: Array` (PlanBoard rows), `plan: Array` ({"move": id} arrows), `limit: int`, `drilled: Array`.
   It shows: caps "THE PLAN", "Arrows <n> / <limit>", a coverage line "Covers <p>% of her map" (PlanBoard.coverage, as a
   whole percent), then one row per arrow "<move name>  <from card> -> <to card>" with a small "Remove" button, a move not
   in `drilled` marked "untrained (80%)" (PlanBoard.UNDRILLED) in UI.GOLD, and the first PlanBoard.validate error (if any)
   in UI.GOLD under the list.
2. `scripts/ui/StrikeBrowser.gd`: a top-bar toggle button "Build plan" / "Done". In plan mode a move OUT adds an arrow
   (`{"move": row id}`) instead of only walking; when the plan is at the limit the move-out buttons are greyed with the reason
   "The plan is full (<limit> arrows for this coach)" (UI.button2 `why`, GREYWHY1). Plan arrows are drawn on the map in a
   plan colour (thick, UI.GOLD) over the normal arrows. The route footer keeps working outside plan mode.
3. The coach skill for the prototype: const `DEMO_COACH := 55.0` beside DEMO_MASTERY, overridable with `-- coach=<0-100>`;
   limit = PlanBoard.arrow_limit(skill). `drilled` = the moves DEMO_MASTERY opens (no grey_reason).
4. `-- jump=strikemap plan=1` opens straight in plan mode (the still tool uses it). Nothing is saved to the career yet.

## Contract
OWNS: Lean/scripts/ui/PlanPanel.gd, Lean/scripts/ui/StrikeBrowser.gd, Lean/tests/plan_screen_test.gd
(do NOT edit tools/run_tests.sh - Claude adds the test at merge; another task edits that line)
RED_TEST: tests/plan_screen_test.gd -> PASS plan_screen_test
REGRESSION: strike_browser_test, plan_board_test, strike_map_test, grey_reason_test, golden_path_test
VISUAL: yes (Claude renders `-- jump=strikemap plan=1` on the hidden desktop and checks it)

## The test (write it FIRST; red on main)
`tests/plan_screen_test.gd` (extends SceneTree): build StrikeBrowser the way strike_browser_test.gd does, then: a "Build
plan" button exists; press it; take moves out until the plan holds PlanBoard.arrow_limit(DEMO_COACH) arrows; the panel reads
"Arrows <limit> / <limit>"; every move-out button is now disabled with the "The plan is full" reason; remove one arrow -> the
buttons enable again and the count drops by one; the coverage line equals the whole-percent PlanBoard.coverage of that plan.
Ends `PASS plan_screen_test` / `FAIL <n>`, quit(0/1); a SCRIPT ERROR line is a failure even with exit 0.
Command: `"%LOCALAPPDATA%\Programs\Godot\Godot_v4.7.2-stable_win64.exe" --headless --audio-driver Dummy --path . --script res://tests/plan_screen_test.gd`
then the five REGRESSION tests the same way. The plain exe only; stop any Godot run you started that hangs, by its PID.

## Final answer
`RESULT: tests/plan_screen_test.gd -> PASS plan_screen_test`, the arrow limit used, the coverage of the test's full plan, the
last lines of each run, the files touched, line counts of StrikeBrowser.gd and PlanPanel.gd.

## Prior research
searched: plan board whiteboard coach -> WRESTLE_S336.md step 2 (one mechanic, more arrows for a better coach, the corner
changes one arrow), STRIKEMAP_S335.md (the boxing map and the coach's whiteboard), PlanBoard.gd + plan_board_test (S337).

## What would a human do?
A boxing coach draws the game plan on a whiteboard before the fight: "from outside, jab to long range, then the 1-2 and roll
under to inside". A better coach holds a richer plan; a young coach keeps it to a few simple instructions.

## Prefab check
None - our own rules module and screen. Nothing downloaded.

## The trap
Never recompute plan rules on the screen: PlanBoard is the one source (limit, validate, coverage, rate). Do not touch
GrappleBrowser.gd or the grapple folder - TIEUPS1 owns them right now.
