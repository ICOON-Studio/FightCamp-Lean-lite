# TASK_GREYWHY1 - every greyed button says why (and when it opens) (Cursor)
Status: DONE (merged S337 6010b3e2)

Model: Cursor (composer default). Discipline: BOXING = demo work (operator Q-S294-59 "Yes, those two first": the NEXT STEP card
and "a reason on every greyed button (why you can't yet + when)"). Repo: **E:\FightCamp\Lean** (worktree
E:\FightCamp\wt\LEAN_GREYWHY1, branch `cursor/greywhy1`). Lean rules: its CLAUDE.md, no script over 500 lines, headless only.

## Why
A greyed button that does not say why is a dead end: the player cannot tell whether he is missing money, time, a rule or a bug.

## Spec
1. `scripts/ui/UI.gd` `button()` and `button2()` take one more optional argument at the END, `why: String = ""`.
   When the button is disabled and `why` is set: `tooltip_text = why`; `button2` shows `why` as its small line (instead of its
   normal small text) in `UI.GOLD`. When enabled, `why` is ignored. Do the same in `scripts/ui/TV.gd` if it has the same helpers.
   Every place that sets `.disabled = <expr>` directly sets `tooltip_text` to the reason when disabled ("" when enabled).
   Set `gui/timers/tooltip_delay_sec` to 0.25 in project.godot so a reason shows at once on hover.
2. Every disabled button in the game gets a REAL reason built from the rule that greys it, saying what is missing and, when the
   rules know it, when it opens. Examples (write each from the actual rule; never a generic "Not available"):
   - `scripts/ui/areas/Fighters.gd` focus / diet in camp -> "In fight camp - the plan is set until fight night"
   - combo box with no combos -> "No combos yet - a combo opens when each of its punches reaches 30 on the Training page"
   - load when injured -> "Injured - back in N weeks" (from Injuries: weeks left)
   - `areas/BoutPage.gd` Decline when not open, `modals/Interview.gd` / `modals/Trial.gd` sign when not ready, the
     TitleScreen's disabled buttons - each its own reason.
3. Nothing else changes: no layout moves, no new screens.

## Contract
OWNS: Lean/scripts/ui/UI.gd, Lean/scripts/ui/TV.gd, Lean/project.godot, Lean/tests/grey_reason_test.gd, and the ui/areas + ui/modals
files whose disabled buttons need a reason (list them in the PR body)
RED_TEST: tests/grey_reason_test.gd -> PASS grey_reason_test
REGRESSION: golden_path_test
VISUAL: yes (Claude renders the layout snapshot on the hidden desktop and checks the stills)

## The test (write it FIRST; it must go red on main)
`tests/grey_reason_test.gd` (extends SceneTree): plays the SAME route as `tools/layout_snapshot.gd` (copy its `main.act(...)`
sequence, 35 moments from title to search; reuse its `_settle()`), and at every moment walks the tree for visible
`BaseButton`s with `disabled == true`. For each it prints `moment | button text | reason`. FAIL when any has an empty
`tooltip_text`, or a reason shorter than 12 characters, or the words "not available". It also counts disabled buttons overall:
the count must be > 0 (the instrument reads something; on main it reads them all as missing a reason).
Ends `PASS grey_reason_test` / `FAIL <n>`, quit(0/1).
Command: `"%LOCALAPPDATA%\Programs\Godot\Godot_v4.7.2-stable_win64.exe" --headless --audio-driver Dummy --path . --script res://tests/grey_reason_test.gd`
then golden_path_test the same way. The plain exe only, never the console build; nothing may open on the screen.

## PR body / final answer
`RESULT: tests/grey_reason_test.gd -> PASS grey_reason_test`, the printed list (moment | button | reason), the red run's
count on main, the files touched.

## Prior research
Operator Q-S294-59 (Dojo Legacy: greyed buttons carry a reason); Lean UI.gd button helpers; feedback_hud_topbar_s268 (no
flavour text: reasons are facts, short).

## What would a human do?
A UX designer never leaves a disabled control unexplained: the reason sits on or next to it ("Locked - needs X, opens in Y").
Players of management games read those lines to plan.

## Prefab check
Godot's own tooltip (Control.tooltip_text) carries the reason; nothing to add. Licence: engine.

## The trap
A reason that is not computed from the rule lies the moment the numbers change. Build each one from the same values that set
`disabled`, in the same place.
