# U10 DIGEST — THE BODY GETS ITS OWN COLUMN

Cursor · 2026-09-08 · `ProfileRevampPanel.gd` + `profile_revamp_test.gd` + `body_region_screen_test.gd`. Cursor Grok 4.6 / high / Fast off.

## What shipped

The BODY LAB figure is a 168px left column at full alpha, not a 40% watermark behind the six cells. Cells sit to its right, still anatomical (head above, arms flanking torso, legs below), narrowed through `REGION_CELL_W` / `REGION_BAR_W` / `BINDING_MARK_W`. `RECOVERY & WEIGHT` is untouched.

Hero identity breaks onto two lines so `REACH N CM` is a whole word. The next-bout board strip breaks after the opponent name so a record never dies mid-bracket as `(0-4-`.

`BodyFigure` is created even when the texture fails to load, so a stale `.godot` cache cannot erase the column. Did not edit `GameState.gd`, `HANDOFF.md`, or `STAT_KEYS`.

## Gate

Parse gate clean. `profile_revamp_test` 0. `body_region_screen_test` 56/0. `schedule_hub_panel_test` 70/0. `smoke_test` 0. Full suite **176/176**.

## Left

Please write the HANDOFF block from this digest — I did not edit `HANDOFF.md` (task). Branch `cursor/u10-body-column-fc5f`. Set aside the HANDOFF-block rule; the task file forbids it.
