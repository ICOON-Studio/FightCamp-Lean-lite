# TASK_PLANSCREEN2 - the coach's plan board on the wrestling tie-ups (Cursor)

Model: Cursor (composer default). Discipline: MMA / wrestling PROTOTYPE (operator Q-S294-62 "Yes, in that order"; the plan
board is ONE mechanic for boxing and wrestling - PLANSCREEN1 built the boxing half, this is the wrestling half). Repo:
**E:\FightCamp\Lean** (worktree E:\FightCamp\wt\LEAN_PLANSCREEN2, branch `cursor/planscreen2`). Lean rules: its CLAUDE.md,
no script over 500 lines, Godot headless only, nothing opens on the screen.

## Why
In wrestling the opponent's REACTION picks the branch: from a tie-up, the coach plans one answer per reaction she expects
(PlanBoard allows two arrows from the same tie-up when their reactions differ). The rules are `scripts/rules/PlanBoard.gd`;
the sport-free panel is `scripts/ui/PlanPanel.gd` (merged S338, used by `scripts/ui/StrikeBrowser.gd` - read how it calls
`PlanPanel.build` and how `_take` adds an arrow in plan mode, and copy that behaviour). The Tie-ups tab is
`scripts/grapple/TieUpPanel.gd` + `scripts/grapple/GrappleBrowser.gd` (TIEUPS1, merged S338).

## Spec
1. The wrestling map, built ONCE in `TieUpPanel.gd` (static `plan_map() -> Array`), exactly as `tests/plan_board_test.gd`
   `_test_4_wrestling` builds it: one row per WrestleChains.ANSWERS entry, `id` = "<tie>:<reaction>", `from` = tie, `to` = link
   or "finish", `reaction`, plus `name` = the technique (PlanPanel prints `name`).
2. Tie-ups tab: a "Build plan" / "Done" button at the top of the side panel while a tie-up is open (or in the top bar next to
   "Tie-ups" - your call, one place only). In plan mode the side panel shows `PlanPanel.build(plan_map(), plan, limit,
   drilled, place_name, on_remove)` above the answers; pressing an answer ADDS its arrow (no clip plays) unless it is already
   on the plan; when the plan is full, answers not on the plan are greyed with "The plan is full (<limit> arrows for this
   coach)"; an answer with no clip can still be planned (the plan is words; the clip is only the picture). `place_name`
   turns a tie id into its name and "finish" into "Finish". Outside plan mode everything works as TIEUPS1 left it.
3. Coach skill: const `DEMO_COACH := 55.0` in TieUpPanel (or the browser), `-- coach=<0-100>` overrides; limit =
   PlanBoard.arrow_limit(skill). `drilled`: every answer whose technique has a clip (the prototype has no wrestler mastery).
4. `-- jump=grapple tie=collar_tie plan=1` opens the tab on that tie-up in plan mode.
5. Plan state lives on the browser (`var plan: Array`), cleared by a "Start again" button in plan mode.

## Contract
OWNS: Lean/scripts/grapple/TieUpPanel.gd, Lean/scripts/grapple/GrappleBrowser.gd, Lean/tests/tieup_plan_test.gd
(do NOT edit tools/run_tests.sh, PlanPanel.gd or StrikeBrowser.gd - Claude adds the test to the list at merge)
RED_TEST: tests/tieup_plan_test.gd -> PASS tieup_plan_test
REGRESSION: tieup_panel_test, plan_board_test, plan_screen_test, wrestle_chains_test, golden_path_test
VISUAL: yes (Claude renders `-- jump=grapple tie=russian_tie plan=1` on the hidden desktop and checks it)

## The test (write it FIRST; red on main)
`tests/tieup_plan_test.gd` (extends SceneTree): build the browser the way tests/tieup_panel_test.gd does; open Tie-ups, pick
"russian_tie", turn plan mode on; press two answers with DIFFERENT reactions -> the panel reads "Arrows 2 / <limit>" and no
validate problem line is shown; press the first one again -> still 2 arrows; keep adding answers (switching tie-ups as
needed) until the limit -> every answer not on the plan is disabled with the full-plan reason, the planned ones are enabled;
press a "Remove" -> count drops by one. Plan mode off -> pressing an answer with a clip sets `moving` non-empty (TIEUPS1
behaviour kept). Ends `PASS tieup_plan_test` / `FAIL <n>`, quit(0/1); a SCRIPT ERROR line is a failure even with exit 0.
Command: `"%LOCALAPPDATA%\Programs\Godot\Godot_v4.7.2-stable_win64.exe" --headless --audio-driver Dummy --path . --script res://tests/tieup_plan_test.gd`
then the five REGRESSION tests the same way. The plain exe only; stop any Godot run you started that hangs, by its PID.

## Final answer
`RESULT: tests/tieup_plan_test.gd -> PASS tieup_plan_test`, the limit used, the last lines of each run, the files touched,
line counts of GrappleBrowser.gd and TieUpPanel.gd.

## Prior research
searched: plan board wrestling reaction -> WRESTLE_S336.md step 2 (the opponent's reaction picks the branch; a plan with an
answer for each reaction scores more), PlanBoard.gd + plan_board_test _test_4_wrestling (S337), TASK_PLANSCREEN1 (S338).

## What would a human do?
A wrestling coach drills "if she does X, you do Y" from each tie-up and builds a short game plan of the chains his wrestler
trusts; a richer plan needs a better coach.

## Prefab check
None - our own rules module and panel. Nothing downloaded.

## The trap
PlanPanel and PlanBoard are shared with boxing - use them, never copy their logic into the tie-ups files. In plan mode an
answer press must NOT play a clip (TieUpPanel.play_answer stays the non-plan path).
