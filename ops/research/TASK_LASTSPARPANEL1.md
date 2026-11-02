# TASK LASTSPARPANEL1 - the last-spar decision screen as a panel (renders LastSpar data) + headless test (S198)
Model: Arena (cloud). Repository ICOON-Studio/FightCamp (Godot 4.7.2, GDScript in Godot/). Own arena/ branch, PR into master, never merge.

## Owned files
- `Godot/scripts/ui/LastSparPanel.gd` (NEW)
- `Godot/tests/last_spar_panel_test.gd` (NEW)

## Spec (operator approved, board Q-S196-3: "the last spar = one screen, three irreversible choices with predicted effects")
`class_name LastSparPanel extends VBoxContainer`, `static func build(spar_summary: Dictionary, ctx: Dictionary = {}) -> LastSparPanel`,
`signal committed(option_id: String, state: Dictionary)`.
Data ONLY from the pure module `res://scripts/rules/LastSpar.gd` (read it: `options()`, `predict(option_id)`, `commit(state, id, ctx)`).
- Top: "LAST SPAR - 2 ROUNDS DONE" + one line from `spar_summary.get("line", "")` (e.g. "Landed 14/18 lead hooks, took 4 flush
  counters"), then "CHOOSE ONE - IT CANNOT BE UNDONE".
- Three columns in an HBoxContainer, one per option in `options()` order: title, intent line, the `predict()` lines (gains green
  #10B981, costs red #EF4444 - decide by the sign/word in the line), and a COMMIT button. Keys 1/2/3 commit the matching column.
- Commit = `LastSpar.commit(ctx.get("state", {}), id, ctx)`; on ok emit `committed(id, result.state)` and DISABLE all three buttons
  (irreversible on screen too); show the chosen column highlighted with border #D69E2E. A second press does nothing.
- Every button gets a tooltip through `UIKit.tip(node, "text")` (`res://scripts/UIKit.gd`; NEVER `tooltip_text`). Background #12161F.
  Fits a 700 px wide drawer body (the DrawerHost right 38%).

## Test - `Godot/tests/last_spar_panel_test.gd` (extends SceneTree; prints `LASTSPARPANEL total=N fails=M`; quit(1) on fail)
(a) 3 columns with the three option titles from LastSpar.options(); (b) each column shows every predict() line for its option;
(c) pressing column 2's button emits committed once with id == options()[1].id and a state whose `committed` == that id; (d) after the
commit all three buttons are disabled and a second press emits nothing; (e) the key "3" before any commit commits option 3;
(f) minimum width <= 700. List 3 mutants in the PR body that each fail it.

## Gate
`godot --headless --path Godot --script tests/last_spar_panel_test.gd` exits 0, fails=0, no SCRIPT ERROR. Typed GDScript, tabs, never
`:=` on a Variant. Do not commit .import/.uid files or the .godot cache.

## Prior research
LUDO_ROUND32_S197.txt "5.2 The Last-Spar Decision Screen", LUDO_ROUND33_S198.txt "The Irreversible Last-Spar Choices",
scripts/rules/LastSpar.gd + tests/last_spar_test.gd, scripts/ui/DrawerHost.gd (the drawer it will sit in).
## What would a human do?
A coach in the corner after the last spar holds up three cards and makes the fighter pick one; the others go in the bin.
## Prefab check
None - project UI kit.

## The one trap
Irreversible means the SCREEN refuses a second choice too, not only LastSpar.commit.
