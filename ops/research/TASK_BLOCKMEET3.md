# TASK BLOCKMEET3 - QWEN (qwen3-coder) - a blocked right cross sinks 3.7 cm into the blocking glove

Status: OPEN (S426, Claude main). Discipline: boxing. Model: qwen3-coder. Animation item (operator S401).
Source: tests/block_meet_test.gd (BLOCKMEET2). S426 found its red was a RUN-TO-RUN fluke (a rhythm step or fidget starting mid-read)
plus ONE real row. With the stage's feet/fidget held still (S426 commit: STAND_S in `_reset`) the test is deterministic: 4 runs of 4,
the same line: `ROW A_B fight pro_right_cross touch=-0.037 between=yes to_face=0.124 gy=-0.018 gap=0.927` = the puncher's glove
sits 3.7 cm INSIDE the blocking glove; the bar allows 3 cm inside (touch > -0.03).
Start FROM main.

## Contract
OWNS: scripts/fight3d/BlockGloveLift.gd, scripts/fight3d/BeatFire.gd, scripts/fight3d/FightStage.gd (only the block carry), docs/BLOCKMEET3_RESULT.md
RED_TEST: tests/block_meet_test.gd -> BLOCK_MEET failures=0 (three runs, same result each)
REGRESSION: head_aim_test, beat_clips_test, move_tip_test, fight_flow_test, guard_weave_test
BASE: main
VISUAL: Claude films the block after the merge. Do not render.

## The job
1. Run block_meet_test 3 times on main; paste the ROW lines. Confirm A_B pro_right_cross is the only red row and the same each run.
2. Find why the cross's glove ends 3.7 cm deeper than the jab/hook rows (the carry onto the blocking glove in BlockGloveLift: is the
   contact point taken from the glove centre, and the cross arrives from the other side?). Fix it so the touch is within the bar
   for A_B and still within it for every other row (B_A, A_A, all four punches). Do not widen a bar and do not edit block_meet_test.gd.
3. A landed punch must still read < 0.05 (CTRL_LANDED): do not move the block onto punches that land.
4. docs/BLOCKMEET3_RESULT.md: the three-run table before and after.

## Prior research
docs/BLOCKMEET2_RESULT.md; scripts/fight3d/BlockGloveLift.gd; tests/block_meet_test.gd header; ops/research/GDSCRIPT_TRAPS.md.

## What would a human do?
A glove that blocks meets the punch at its surface; it neither stops short nor swallows the other glove.

## Prefab check
None: our own rig.

## Rules
Godot only through `python ops/Tools/godot_slot.py run --who qwen -- <godot.exe> --headless --audio-driver Dummy --path . --script <script>`.
No file over 500 lines. Never "he" or "she" in text. A red test is never "pre-existing" without the main run that shows it.

## Result lines (PR body)
RESULT: tests/block_meet_test.gd -> BLOCK_MEET failures=0
RESULT: tests/head_aim_test.gd -> the test's own pass line
