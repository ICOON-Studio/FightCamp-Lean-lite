# TASK HITREACT4 - QWEN (qwen3-coder) - measure the conversion stages HITREACT3 did not run

Status: OPEN (S411, Claude main). Discipline: boxing. Model: qwen3-coder. Standing animation item (operator S401).

## Contract
BASE: qwen/hitreact3
OWNS: tools/hit_react_stages.gd, docs/HITREACT3_RESULT.md
RED_TEST: tests/guard_knee_test.gd -> GUARD_KNEE failures=0
REGRESSION: guard_knee_test
VISUAL: no

## Prior research
docs/HITREACT3_RESULT.md and ops/research/TASK_HITREACT3.md (the job this finishes). Reviewed by Claude S411: the RAW and RETARGET rows are useful and the probe's maths is fine. What is wrong:
1. The tool stops after RETARGET. The brief asked for every stage through the saved clip. hit_react_stages.gd has a _measure_ap function that nothing's table reaches.
2. RETARGET reads 0.191 m on hook_v5, while HITREACT2 read the finished clip at 0.109 m. So more than half of the loss comes AFTER the last row in the table. The conclusion "the drop happens at the RETARGET stage" cannot be drawn from that table.
3. The controls drop 12-14% at RETARGET and the weak clips 15%. Under the brief's own rule a stage that also drops the controls is not the cause. Say that.
4. "The weak clips start with less head travel" is false in its own table: hook_v5 starts with the most of all six (0.2236 m).
5. pro_hit_by_cross_v2_short RETARGET prints first_head_y 1.617, the source's value, while the other five print 1.652, and the text says all six are 1.652. Find out why. A row with the wrong rest pose is void.
6. The first-frame continuity check compared RAW with RETARGET, two different skeletons, which cannot match. The trap (below) is about one stage's output against the next stage's input on the same skeleton.

## What would a human do?
Finish walking the production line to the end, instead of stopping at the second machine and guessing about the rest.

## Prefab check
tools/owned_mocap_bake.gd _bake() (the stages, lines listed in HITREACT3_RESULT), tools/owned_mocap_plant.gd, tools/owned_mocap_smooth.gd, tools/owned_mocap_fit.gd, tools/hit_react_probe.gd (the finished clip, modes clip and game). RETARGET2B_RESULT: each of the 145 clips keeps whichever bake scored best, so FIRST find which bake settings produced each of the six saved clips, and run those same settings.

## The job
Same six clips, same two measures, same ruler.
1. Fix fault 5.
2. Add a row per clip for each remaining stage, in the order the bake runs them, using the settings each clip was really baked with: HIPS CORRECTION, SMOOTH, PIN (one row each, not one row for both), FIT, then the SAVED clip with every modifier off, then the same clip as the game plays it (mode game of hit_react_probe).
3. docs/HITREACT3_RESULT.md: replace the plain-words section. One table with a column per stage and a row per clip, head travel as metres and as % of RAW. Then answer: at which stage do the three WEAK clips lose the most, and does the same stage leave the three CONTROL clips alone? If no single stage does it, say that. Name no cause without the row that shows it. Propose nothing to change in the game.
4. Remove the sentences listed as faults 2, 3 and 4 above.

## Rules
scripts/ and tests/ are out of bounds: this task only measures. Do not re-bake or overwrite any clip in assets: write any test bake under E:/FightCamp/tmp/hitreact4. Godot through `python ops/Tools/godot_slot.py run --who qwen -- <godot cmd>`, headless, --audio-driver Dummy, --fixed-fps 30, Engine.max_fps = 30. Blender at the path tools/knee_plane_raw.py uses.

## The one trap
A stage's output and the next stage's input must be the same pose. Between each pair of stages on the MetaHuman skeleton, print the first-frame head position out of one and into the next: if they differ, the probe is reading the wrong thing and the row is void. Also check the last stage: your SAVED row must equal what hit_react_probe reads on the same clip within 0.005 m, or the probe is not reading what the game plays.

## Result lines (PR body)
RESULT: tests/guard_knee_test.gd -> GUARD_KNEE failures=0
