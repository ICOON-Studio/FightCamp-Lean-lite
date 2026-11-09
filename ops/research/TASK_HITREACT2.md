# TASK HITREACT2 - QWEN (qwen3-coder) - where does a hit reaction lose its movement?

Status: OPEN (S409, Claude main). Discipline: boxing. Model: qwen3-coder. Standing animation item (operator S401).

## Contract
OWNS: tools/hit_react_probe.gd, tools/hit_react_raw.py, tools/hit_react_steps.py, docs/HITREACT2_RESULT.md
RED_TEST: tests/guard_knee_test.gd -> GUARD_KNEE failures=0
REGRESSION: guard_knee_test
VISUAL: no

## Prior research
docs/HITREACT1_RESULT.md: most reaction clips read about half the head travel of their source (cross_v3 0.226 m source, 0.111 m clip; hook_v5 0.229, 0.103), while some match (hook_v3 0.126, 0.109; cross_v1 0.059, 0.066). So it is not one constant scale fault. NOT PROVED YET: tools/hit_react_raw.py reads the whole FBX take, frame 1 to the last, while the game's clips, the `_short` ones above all, may be cut from part of it. A window that holds the bigger part of the take can read bigger for that reason alone. Also, RETARGET2B (ops/research/RETARGET2B_RESULT.md) found smoothing hurts clean clips, and the S407 knee work found a table can be wrong for reasons only the probe shows: read the probe first.

## What would a human do?
Put the two films side by side, on the same seconds of the same take, and only then compare. If they still differ, run the conversion one step at a time and see at which step the head stops moving as far.

## Prefab check
tools/hit_react_raw.py and tools/hit_react_probe.gd (HITREACT1). The conversion's own steps are in the Punch PRO bake tool that tools/raw_fbx_feet.py and ops/research/RETARGET2B_RESULT.md name: find it, do not rewrite it.

## The job
1. For every clip in the HITREACT1 table: which source file and which frames of it the game's clip was made from, read from the bake's own settings or its log, not guessed. Print clip seconds and source seconds side by side. If the bake's window cannot be found for a clip, say so and leave that row out.
2. Re-measure SOURCE over exactly that window, with the same two measures. New table: SOURCE-window, CLIP, ratio.
3. Scale check: print each rig's hips-to-head height at the first frame on both sides, and give the ratio with the head travel divided by that height. A shorter body moves its head less for the same pose.
4. Only for the clips still under 70% after steps 2 and 3, pick the three that the game plays most (read the pools in scripts/fight3d/BeatClips.gd). For each, tools/hit_react_steps.py: head travel after each stage of the conversion. Name the stage where it drops.
5. docs/HITREACT2_RESULT.md: the new table, then in plain words: is the loss real once the windows match, how large, and at which stage. Name no cause without the row that shows it. Propose nothing to change in the game.

## Rules
scripts/ and tests/ are out of bounds: this task only measures. Godot through `python ops/Tools/godot_slot.py run --who qwen -- <godot cmd>`, headless, --audio-driver Dummy, --fixed-fps 30, Engine.max_fps = 30. Blender at the path tools/knee_plane_raw.py uses. Never _console.exe. Nothing opens on the monitors.

## The one trap
Peak head travel is a single-frame number. Print the frame it happens on for both sides: when the peaks sit on very different frames, the two clips are not the same stretch of movement.

## Result lines (PR body)
RESULT: tests/guard_knee_test.gd -> GUARD_KNEE failures=0
