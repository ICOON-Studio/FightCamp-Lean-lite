# TASK CLASH8 - with the order fixed, which layer puts the defender's glove back into the punch? (measure, then fix)

Status: OPEN (S486, Claude main). Discipline: boxing. Model: qwen3-coder (Qwen), default.

## Why
CLASH7 (branch qwen/clash7, commit 2471fc04; read docs/CLASH7_RESULT.md there) built SkelPump: both skeletons' modifier
stacks run once a frame, puncher first. On 09_jab f19 (seed 4242) the order is now RIGHT - the defender reads the puncher's
arms fresh (`late false`, same frame) - and both ranks are low, so GloveClear's clash takes 100% of the overlap. Yet the
meter still reads 0.057 m. So the clash pass does clear the glove, and SOMETHING AFTER IT puts the glove back in, or the
meter reads a different point than the clash clears. CLASH7 guessed (own-glove re-clear `_clear_own`, the soft knee
SOFT_M, ARM_SHARE) but measured none of them. Measure first; fix only the layer the numbers name.

## What to do
1. Your worktree starts from qwen/clash7 (2471fc04, the BASE line). Keep SkelPump as it is.
2. MEASURE (no fix yet). Attach tools/layer_trace.gd (`LayerTrace.attach(stage)`, `report(stage)`, its header says how)
   in the film run and, for 09_jab f17-f21 and 08_jab f38-f42 (seed 4242), write in docs/CLASH8_RESULT.md, per frame:
   the defender's clashing glove's world place right after GloveClear's clash pass, after EACH later layer (name, metres
   moved), and the place tools/clash_meter.gd measures from. Name the layer that moves the glove back in by more than
   0.02 m, or say that none does and the meter and the clash read different points (give both points).
3. FIX only what step 2 names:
   - a later layer moves it back -> that layer reads the cleared place (or runs before GloveClear); one change, say which;
   - meter vs clash read different points -> make GloveClear clear the point the meter measures (the glove volume the
     meter uses), never change the meter's bar.
   Never lower a bar, never add a new clamp layer after everything.
4. Pass lines, the regression set, two stills (the same frames) in docs/clash8/.

## Film command (hidden desktop - nothing on the owner's monitors)
`python ops/Tools/godot_slot.py run --who qwen -- python tools/hidden_desktop.py run --timeout=600 --log=<out>/log.txt <godot.exe> --path . --windowed --resolution 960x540 --audio-driver Dummy --fixed-fps 60 --script res://tools/hit_frame_film.gd -- <out> jabs=3 crosses=3 uppercuts=2 seed=4242`
(and seed=77). Today on qwen/clash7: 08_jab f40 0.054 m, 09_jab f19 0.057 m (seed 4242). Never sleep to wait; use a
foreground timeout.

## Pass lines
RESULT: docs/CLASH8_RESULT.md -> the layer that undoes the clash: <name | none: meter reads <point>, clash clears <point>>
RESULT: tools/hit_frame_film.gd seed=4242 -> 08_jab CLASH frames deeper than 0.02 m from the hit on: 0
RESULT: tools/hit_frame_film.gd seed=4242 -> 09_jab CLASH frames deeper than 0.02 m from the hit on: 0
RESULT: tools/hit_frame_film.gd seed=77 -> CLASH frames deeper than 0.02 m: not more than on qwen/clash7

## Contract
BASE: qwen/clash7
OWNS: scripts/fight3d/GloveClear.gd, scripts/fight3d/SkelPump.gd, scripts/fight3d/ArmClash.gd, scripts/fight3d/ElbowClear.gd, scripts/fight3d/FightStage.gd, tools/layer_trace.gd, docs/CLASH8_RESULT.md, docs/clash8/
(change only the ONE layer step 2 names among them, and say which; layer_trace: attach points only)
RED_TEST: tools/hit_frame_film.gd -> 09_jab CLASH frames deeper than 0.02 m from the hit on: 0 (qwen/clash7 reads 1, f19 0.057 m)
REGRESSION: tests/own_gloves_test.gd, tests/hit_carry_test.gd, tests/hit_frame_test.gd, tests/cam_line_test.gd
(one by one, `--headless --audio-driver Dummy --fixed-fps 60`)
VISUAL: yes - stills only through tools/still_framing.gd save_if_framed; Claude opens them, the owner closes it.
NOT YOURS: every other file. Every script under 500 lines. Work on qwen/clash8, commit, push, never merge.

## Prior research
docs/CLASH7_RESULT.md (qwen/clash7); ops/research/TASK_CLASH6.md "Audit (S484)"; tools/layer_trace.gd (S469); memory: print
the armed clip before tuning; the hit ruler read a frame early once (S470) - check the frame you measure is the frame drawn.

## What would a human do?
Watch the one bad frame layer by layer until the glove jumps, then fix that layer - not the whole stack.

## Prefab check
None: our own pose layers.
