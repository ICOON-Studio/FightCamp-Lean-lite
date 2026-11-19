# TASK TREEVALUE6 - re-read the footwork steps' board now that a step's deny reaches the score (measurement only)

Status: OPEN (S531, Claude main). Discipline: boxing. Model: qwen3-coder (PC seat).

## Why
`ops/research/STEPS_SCOPE_S528.md` phase 5. STEPTUNE3 (`docs/STEPTUNE3_RESULT.md` s3c) found that DENY cut the opponent's
landed punches only AFTER `Exchanges.settle` had fixed the exchange, so it never reached the cards. S531 phase 5a:
`StepWire.deny_edge` (scripts/state/StepWire.gd) now adds the denied share x EDGE.best to the duel BEFORE settle
(LiveRound.gd line ~274). Phase 5c fixed the probe crash on steps with no wrong style (tools/treevalue_cells.gd `legs`).
This round MEASURES the board on that code. Change NO number in StepEffect.gd TABLE.

## What to do
Run the whole board once:
`python ops/Tools/godot_slot.py run --who qwen -- %LOCALAPPDATA%/Programs/Godot/Godot_v4.7.2-stable_win64.exe --headless --audio-driver Dummy --fixed-fps 60 --path . --script res://tools/treevalue_probe.gd`
(never the _console exe; every Godot run goes through godot_slot). Then write `docs/TREEVALUE6_RESULT.md`:
1. The board (step x style cells with targets), and for each step the cell change vs TREEVALUE5 (`docs/TREEVALUE5_RESULT.md`).
2. Which steps carry DENY in TABLE (step_back, roll_out, ...) and whether their cells moved more than the steps without
   it - that is the question this round answers. Name the population (styles, bouts a cell, seeds) and the calibration lines.
3. The `TREEVALUE2 done pass=` line verbatim (it must print now for all ten steps; if it does not, say where it stops).
Budget: one full board (~2.5 h of probe time). Do not tune.

## Deliverable
ONE new file `docs/TREEVALUE6_RESULT.md`. Do not edit any other file.

## Contract
OWNS: docs/TREEVALUE6_RESULT.md
RED_TEST: tools/treevalue_probe.gd
REGRESSION: tests/golden_path_test.gd
VISUAL: no

## Prior research
docs/TREEVALUE5_RESULT.md, docs/STEPTUNE3_RESULT.md, docs/STEPTUNE2_RESULT.md, ops/research/STEPS_SCOPE_S528.md.
## What would a human do?
After rewiring a lever, a coach watches the same sparring again before changing how hard anyone works.
## Prefab check
None: our own probe on our own code.
