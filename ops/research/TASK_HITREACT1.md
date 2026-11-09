# TASK HITREACT1 - QWEN (qwen3-coder) - do the hit reactions move as much as the capture does?

Status: OPEN (S409, Claude main). Discipline: boxing. Model: qwen3-coder. Standing animation item (operator S401).

## Contract
OWNS: tools/hit_react_probe.gd, tools/hit_react_raw.py, docs/HITREACT1_RESULT.md
RED_TEST: tests/guard_knee_test.gd -> GUARD_KNEE failures=0
REGRESSION: guard_knee_test
VISUAL: no

## Prior research
ops/research/CLIP_SCORES_S390.md (11-06, before the 11-08 re-bake): pro_hit_by_cross_v1_short, pro_hit_by_cross_v2_short and pro_hit_by_hook_v2_short scored 3 of 10, "no readable hit, body stays in idle guard"; several jab reactions scored 4. Those scores came from clips alone, without the fight's head snap. Nobody has compared these clips with their source capture. ops/research/RETARGET2B_RESULT.md explains the re-bake. scripts/fight3d/BeatClips.gd holds the pools the game picks from (REACT rows and BIG_REACT) and its comments give earlier peak numbers. The standing rule since S399: a raw-against-ours table before any fix.

## What would a human do?
Lay the original capture next to our clip, play each hit, and measure how far the head goes. A weak clip that matches its source was weak when it was bought. A clip weaker than its source lost something in our conversion.

## Prefab check
tools/knee_plane_probe.gd, tools/knee_plane_raw.py, tools/torso_lean_probe.gd and tools/torso_lean_raw.py already read both sides, including where the Punch PRO source files are. Copy their bone reading and their process setup. Write no new maths beyond the two measures below.

## The job
1. Every clip name reachable from the reaction pools and BIG_REACT in scripts/fight3d/BeatClips.gd, listed from the code, not by hand. Skip the mc_ and react_ clips in the raw column if they have no Punch PRO source, and say so.
2. Two measures, the same maths in both tools, over the clip's own length:
   HEAD: the largest distance the Head bone moves from where it starts, measured relative to the chest (spine top), in metres, as a share of leg length too.
   TRUNK: the largest change in the angle of the line from hips to neck, in degrees.
   Self-check first: a made-up head moved 0.10 m reads 0.10, and moving the whole body 1 m changes neither measure.
3. Columns per clip: SOURCE (Blender, the Punch PRO capture), CLIP (the game with every SkeletonModifier3D off), GAME (nothing switched off, the reaction played as the fight plays it, if a stage setup can do that; otherwise say the column is empty and why). Bodies: mh_boxer_01 and mh_boxer_10. Read poses inside skeleton_updated, as tools/knee_plane_probe.gd does, or the numbers are the raw clip and not what is drawn.
4. docs/HITREACT1_RESULT.md: the table sorted weakest first by CLIP HEAD, then in plain words: which clips match their source and are simply small, which lost movement in our conversion (CLIP under 70% of SOURCE on either measure), and how often the game picks each weak clip, read from the pools. Name no cause without the column that shows it. Propose nothing to change in the game.

## Rules
scripts/ and tests/ are out of bounds: this task only measures. Engine.max_fps = 30 and Godot with --fixed-fps 30. Every row says which clip played and for how many frames, read from current_animation; a row with 0 frames of its clip is a failure, not a number. Godot through `python ops/Tools/godot_slot.py run --who qwen -- <godot cmd>`, headless, --audio-driver Dummy, never _console.exe. Nothing opens on the monitors.

## The one trap
The clips are short and some start mid-move. Measure from the clip's first frame, and print the first frame's head height for each clip: a clip that starts already hit will read small while looking large.

## Result lines (PR body)
RESULT: tests/guard_knee_test.gd -> GUARD_KNEE failures=0
