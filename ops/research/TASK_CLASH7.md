# TASK CLASH7 - one pump runs both boxers' skeleton stacks once a frame, in a fixed order (glove clash root fix)

Status: OPEN (S484, Claude main). Discipline: boxing. Model: qwen3-coder (Qwen), default.

## Why
Claude's audit (ops/research/TASK_CLASH6.md "Audit (S484)") found why the last glove clash frames survive 13 tunings: the two
boxers' Skeleton3D modifier stacks do not run once a frame in a fixed order. GloveClear's arm clash is only right when the
boxer drawn second reads the other's arms from THIS frame (`late` false, she takes all of what is left). After a hit-stop
`ap.seek(t, true)` (HitImpact.gd:49) re-poses a boxer mid-frame, and the logs show both boxers reading last frame's arms
(08_jab f40, 0.051 m) or one stack running twice.

## What to do
1. RED, measure first (no fix yet): give GloveClear a per-frame pass log - in clash_pass append
   `"%d:%d" % [Engine.get_process_frames(), passes_this_frame]` to dbg (inside the existing `if dbg_on` lines). Run the film
   (command below, seed 4242) and write in docs/CLASH7_RESULT.md how many clash_pass calls each boxer made per frame and in
   which order, for frames f35-f45 of 08_jab and f15-f22 of 09_jab. Expected: irregular (0, 1 or 2 passes; order flips).
2. FIX: a new node scripts/fight3d/SkelPump.gd (extends Node, under 80 lines), `process_priority = 50` (after FightStage, the
   AnimationPlayers and HitImpact; before FightCalls at 100). FightStage creates it once both boxers exist (2-4 lines in
   FightStage.gd, which is 482 lines and must stay under 500). Each fight skeleton gets `modifier_callback_mode_process =
   Skeleton3D.MODIFIER_CALLBACK_MODE_PROCESS_MANUAL` ONLY when the pump is made (a body built without the pump - probes,
   tests - keeps Idle). Each frame SkelPump calls `advance(delta)` on boxer A's skeleton, then boxer B's: A = the boxer with a
   live punch (GloveClear._rank 2 on either side: a live punch's glove does not clear, so the defender must go second and read
   it fresh), else boxer 0. Then B always reads A's arms fresh.
3. CHECK on the film that the drawn bodies still carry every modifier when a `seek(t, true)` runs (guard, punches, gloves). If
   a forced pose after the pump drops the modifiers for a frame, run the pump later (process_priority) or also on the
   skeleton's `skeleton_updated`; say which in the result page. A manual skeleton never advanced shows its raw pose: every
   fight body must be pumped.
4. Then the pass lines, the regression set and the stills.

## Film command (hidden desktop - nothing on the owner's monitors)
`python ops/Tools/godot_slot.py run --who qwen -- python tools/hidden_desktop.py run --timeout=600 --log=<out>/log.txt <godot.exe> --path . --windowed --resolution 960x540 --audio-driver Dummy --fixed-fps 60 --script res://tools/hit_frame_film.gd -- <out> jabs=3 crosses=3 uppercuts=2 seed=4242`
(and seed=77). Main today: 08_jab f40 0.054 m, 09_jab f19 0.057 m (seed 4242). Never sleep to wait; use a foreground timeout.

## Pass lines
RESULT: docs/CLASH7_RESULT.md -> passes per frame before: <irregular|regular> after: 1 each, order <A then B>
RESULT: tools/hit_frame_film.gd seed=4242 -> 08_jab CLASH frames deeper than 0.02 m from the hit on: 0
RESULT: tools/hit_frame_film.gd seed=4242 -> 09_jab CLASH frames deeper than 0.02 m from the hit on: 0

## Contract
OWNS: scripts/fight3d/SkelPump.gd, scripts/fight3d/BoxerBuild.gd, scripts/fight3d/FightStage.gd, scripts/fight3d/GloveClear.gd, docs/CLASH7_RESULT.md, docs/clash7/
RED_TEST: tools/hit_frame_film.gd seed=4242 jabs=3 crosses=3 uppercuts=2 -> 08_jab and 09_jab CLASH frames deeper than 0.02 m: 0 (main: 1 each)
REGRESSION: tests/own_gloves_test.gd, tests/guard_knee_test.gd, tests/guard_weave_test.gd, tests/glove_cut_test.gd, tests/cam_line_test.gd, tests/hit_frame_test.gd, tests/hit_carry_test.gd, tests/block_meet_test.gd
VISUAL: yes - seed 4242 08_jab f40 and 09_jab f19, main and branch side by side (docs/clash7/, at most 4 PNGs, < 1 MB each)
NOT YOURS: every other file; never delete or weaken a test. Regression runs headless (`--headless --audio-driver Dummy
--fixed-fps 60`); hit_frame (3 FAIL on main) and hit_carry (32 FAIL on main) must not grow; block_meet at `--fixed-fps 30`
(1 FAIL on main). Godot: the plain `Godot_v4.7.2-stable_win64.exe` only (no terminal build); never open an image with an app;
never run the windowed film without hidden_desktop. Do NOT commit film folders.

## The one trap
Do not touch the clash maths (ARM_SHARE, passes, extrapolation): the audit says they are right once the order is right. If the
pump is in and a clash frame remains, write its `late` flags and pass log in the result page and stop - that is the finding.

## Prior research
ops/research/CLASH5_RESULT.md (stale read, 12 tunings); TASK_CLASH6.md (round 1 crash: never write the peer's skeleton from a
modifier; round 2 fail; Audit S484). Memory S468, S470, S478, S479, S484.
## What would a human do?
Make both boxers take their turn in the same order every frame: the puncher first, the one who must get out of the way second.
## Prefab check
None: Godot's own Skeleton3D manual mode (MODIFIER_CALLBACK_MODE_PROCESS_MANUAL + advance()).
