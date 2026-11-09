# TASK HITREACT3 - QWEN (qwen3-coder) - run the conversion one step at a time and find where the head stops moving

Status: OPEN (S410, Claude main). Discipline: boxing. Model: qwen3-coder. Standing animation item (operator S401).

## Contract
OWNS: tools/hit_react_stages.gd, docs/HITREACT3_RESULT.md
RED_TEST: tests/guard_knee_test.gd -> GUARD_KNEE failures=0
REGRESSION: guard_knee_test
VISUAL: no

## Prior research
docs/HITREACT2_RESULT.md, its table and its peak frames. Reviewed by Claude S410: the table holds; the "stage" part does not. Its three stages are the source, the source times a body ratio, and the finished clip, so the conversion was never run in steps, and "the rotation retarget is the most likely cause" has no row behind it. Do not repeat that claim unless a row here shows it. Its proportion factor is also the wrong ruler: the measure is the head relative to UpperChest, so hips-to-head height says little about it.
ops/research/RETARGET2B_RESULT.md names the bake chain. feedback from S399 and S407: read poses inside skeleton_updated, and check two measures agree before believing a row.

## What would a human do?
Stop the production line after each machine, measure the same part at each stop, and compare against a part that comes out right.

## Prefab check
tools/owned_mocap_bake.gd (the bake and its `json_batch` mode), tools/owned_mocap_fit.gd (foot targets, plant holds, stance width), tools/raw_fbx_feet.py (the raw JSON), tools/hit_react_probe.gd and tools/hit_react_raw.py (the two measures). Find the existing switches first; add a stage dump only if none exists, and do it from your own tool, not by editing the bake.

## The job
Six clips, chosen because source and game peak on nearly the same frame, so it is the same movement:
- WEAK: pro_hit_by_hook_v5, pro_hit_by_jab_v5_short, pro_hit_by_cross_v2_short (45-51% of the source).
- CONTROL: pro_hit_by_hook_v3, pro_hit_by_cross_v1, pro_hit_by_hook_v6_short (86-112%). They go through the same line and come out right, so a stage that also drops the head on these is not the cause.

1. Read tools/owned_mocap_bake.gd and list every stage it runs, in order, with its line numbers.
2. tools/hit_react_stages.gd: for each of the six clips, the head travel relative to UpperChest, and the trunk angle, after EVERY stage: raw source JSON, after the retarget alone, then after each further stage in the order the bake runs them, then the saved clip as the game plays it. Same two measures as HITREACT1. Print the peak frame at each stage.
3. For the same six, print the length from UpperChest to the head on both skeletons. That is the ruler for this measure.
4. docs/HITREACT3_RESULT.md: the table, one row per clip per stage, then in plain words: at which stage do the three WEAK clips drop, by how much, and does the same stage leave the three CONTROL clips alone? If no single stage does it, say that. Name no cause without the row that shows it. Propose nothing to change in the game.

## Rules
scripts/ and tests/ are out of bounds: this task only measures. Do not re-bake or overwrite any clip in assets: write any test bake under E:/FightCamp/tmp/hitreact3. Godot through `python ops/Tools/godot_slot.py run --who qwen -- <godot cmd>`, headless, --audio-driver Dummy, --fixed-fps 30, Engine.max_fps = 30. Blender at the path tools/knee_plane_raw.py uses.

## The one trap
A stage's output and the next stage's input must be the same pose. Before believing any row, print the first-frame head position out of one stage and into the next: if they differ, the probe is reading the wrong thing, and the row is void.

## Result lines (PR body)
RESULT: tests/guard_knee_test.gd -> GUARD_KNEE failures=0
