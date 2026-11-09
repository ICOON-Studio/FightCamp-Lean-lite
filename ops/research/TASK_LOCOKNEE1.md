# TASK LOCOKNEE1 - QWEN (qwen3-coder) - the walking clips against their source, with the ruler that works

Status: OPEN (S408, Claude main). Discipline: boxing. Model: qwen3-coder. Standing animation item (operator S401).

## Contract
OWNS: tools/knee_plane_probe.gd, tools/knee_plane_raw.py, docs/LOCOKNEE1_RESULT.md
RED_TEST: tests/guard_knee_test.gd -> GUARD_KNEE failures=0
REGRESSION: guard_knee_test
VISUAL: no

## Prior research
ops/research/KNEEPLANE_S408.md: the guard is settled, and why three earlier rulers were wrong. Read it first. scripts/fight3d/RkClips.gd CLIPS lists each walking clip's source file or take and its window. tools/raw_fbx_feet.py measures foot slide on a source take. ops/research/GDSCRIPT_TRAPS.md.

## What would a human do?
Lay the source take and our clip side by side, frame for frame, before touching either.

## Prefab check
None needed: the ruler exists. Do not write another one.

## The job
Every fighter's walk in the fight is one of rk_loc_in, rk_loc_back, rk_loc_left, rk_loc_right. The guard measure skipped those frames. Measure them.
1. Add `clip=<name>` to tools/knee_plane_probe.gd: play that clip on both boxers, looped, count its frames instead of guard frames. Use the off_plane and flex functions as they are; do not change them.
2. Add `start=<s> end=<s>` to tools/knee_plane_raw.py: only frames in that window. The self-check stays first.
3. For each of the four clips, one row per leg (left, right): SOURCE (window from RkClips.CLIPS), CLIP (`off=all`, one process), GAME (nothing off, one process). Columns: mean, min, max of norm; flex mean; and the foot slide while planted (tools/raw_fbx_feet.py way).
4. rk_loc_in has `"mirror": true`: compare its left leg with the source's right leg, and say so in the table.
5. docs/LOCOKNEE1_RESULT.md: the table, then answer: on which clip and leg does GAME first differ from SOURCE by more than 0.02 of leg length, and which layer does it (switch them off one at a time, one process each, as ops/research/KNEEPLANE_S408.md did)? If nowhere, say so. Name the clip and frame with the furthest-in knee, for a still.

## Rules
scripts/ is out of bounds: this task only measures. Every row states which clip was playing and for how many frames, from `current_animation`; a row with 0 frames of its clip is a failure, not a number. Godot through `python ops/Tools/godot_slot.py run --who qwen -- <godot cmd>`, headless, --audio-driver Dummy, --fixed-fps 30, never _console.exe. Blender: "C:/Program Files/Blender Foundation/Blender 5.2/blender.exe" -b --factory-startup.

## The one trap
Rounds 1 and 2 of the guard job said a fault was fixed when the code still had it, and scored walking frames as guard frames. Before you write that something is measured, quote the printed line that proves which clip it read.

## Result lines (PR body)
RESULT: tests/guard_knee_test.gd -> GUARD_KNEE failures=0
