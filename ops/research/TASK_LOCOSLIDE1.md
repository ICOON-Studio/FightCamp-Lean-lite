# TASK LOCOSLIDE1 - QWEN (qwen3-coder) - do the walking feet slide? Source against game

Status: OPEN (S408, Claude main). Discipline: boxing. Model: qwen3-coder. Standing animation item (operator S401).

## Contract
OWNS: tools/foot_slide_probe.gd, tools/loco_slide_raw.py, docs/LOCOSLIDE1_RESULT.md
RED_TEST: tests/guard_knee_test.gd -> GUARD_KNEE failures=0
REGRESSION: guard_knee_test
VISUAL: no

## Prior research
docs/LOCOKNEE1_RESULT.md: the knee on the four walking clips matches the source, and its foot-slide figures were for the whole source file, so they compare nothing. Operator S399 on films: "the first 2 clips have no animation for walking the fighters are sliding". scripts/fight3d/RkLoco.gd moves the body by the clip's own hip travel; scripts/fight3d/RkClips.gd CLIPS gives each clip's source and window. tools/raw_fbx_feet.py measures slide on a source take. tools/knee_plane_probe.gd shows how to read inside skeleton_updated and how to prove which clip played. ops/research/GDSCRIPT_TRAPS.md.

## What would a human do?
Watch one foot while it is on the floor. If the body walks and that foot stays put, it is fine. If the foot creeps, it slides.

## Prefab check
tools/raw_fbx_feet.py exists: copy its bone reading, not its whole-file totals.

## The job
For each of rk_loc_in, rk_loc_back, rk_loc_left, rk_loc_right, one row per foot (left, right), three columns: SOURCE (Blender, only the clip's window), CLIP (all layers off), GAME (nothing off).
1. World positions of each ankle and ball, every frame. In the game the body really moves across the canvas: use global positions read inside skeleton_updated, and let the clip move her the way the game does (RkLoco), never with a test-only offset.
2. A foot is PLANTED on a frame when its ball is within 3 cm of the lowest height that ball reaches in the clip and it moves under 0.25 m/s. Use one definition, scaled by leg length, in both tools, and print the leg length used.
3. Report for planted frames: planted share of the clip; slide in metres per planted stretch (mean and worst); and SNAPS, the count of frames where a foot jumps more than 3 cm in one frame.
4. rk_loc_in has `"mirror": true`: compare its left foot with the source's right foot, and say so in the table.
5. docs/LOCOSLIDE1_RESULT.md: the table, then answer: on which clip and foot does GAME slide more than SOURCE by over 2 cm per stretch, and which layer does it (switch layers off one at a time, one process each)? If nowhere, say so. Then name the worst clip and frame for a still.

## Rules
scripts/ is out of bounds: this task only measures. Cap the frame rate in the tool with Engine.max_fps = 30 (clips run on real time; uncapped headless frames do not). Every row states which clip played and for how many frames, from current_animation; a row with 0 frames of its clip is a failure, not a number. A self-check first: a made-up foot that stays still reads 0 slide, one creeping 1 cm a frame reads the right total. Godot through `python ops/Tools/godot_slot.py run --who qwen -- <godot cmd>`, headless, --audio-driver Dummy, never _console.exe. Blender: "C:/Program Files/Blender Foundation/Blender 5.2/blender.exe" -b --factory-startup.

## The one trap
A foot on a body that glides reads as still in the body's own space. Measure in world space, in both tools, or the table hides the very thing it is for.

## Result lines (PR body)
RESULT: tests/guard_knee_test.gd -> GUARD_KNEE failures=0
