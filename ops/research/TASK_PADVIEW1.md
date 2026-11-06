# TASK PADVIEW1 - a pad-work view in the Playbook (S392, Cursor)

Model: Cursor Composer 2.5. Discipline: boxing.

## Why
Board Q-S294-108, operator: "Give a view". `scripts/fight3d/PadWork.gd` and `Mitts.gd` are finished (coach holds the mitts, the boxer throws the combo) but no screen plays them; only tools/padwork_still.gd and tools/padwork_probe.gd do.

## What to build (owned files ONLY)
1. `scripts/ui/PadView.gd` (new): a modal with a SubViewport that builds `PadWork` for this fighter and a coach, plays the chosen combo on a loop, and has one Close button. Use `PadWork.build(boxer_glb, coach_glb)` and `play(combo_id, loops)`; `tools/padwork_still.gd` shows the setup. Pick the boxer's body as the fight does (`Faces`). Frame both bodies head to feet. Free the viewport on Close.
2. In `scripts/ui/ComboBuilder.gd`, a "Watch on the pads" button on a combo row. It opens PadView for that combo. A combo with no clips shows no button.
3. `tests/pad_view_test.gd` (new): opens PadView for a known combo headless, checks the stage built and the combo started, closes it, checks nothing is left behind.

Rules: male boxers bare-chested in trunks, women keep the singlet, boots always. No flavour text. One button, one modal. Do not touch PadWork.gd or Mitts.gd unless a real bug stops the view, and say so if you do.

## Contract
OWNS: scripts/ui/PadView.gd, scripts/ui/ComboBuilder.gd, tests/pad_view_test.gd
RED_TEST: tests/pad_view_test.gd
REGRESSION: combo_builder_test, combo_flow_test, move_tip_test
VISUAL: yes
