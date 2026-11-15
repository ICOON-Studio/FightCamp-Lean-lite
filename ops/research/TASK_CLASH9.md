# TASK CLASH9 - the guard glove sees the true overlap and still stays in: why does the push not clear it? (measure, then fix)

Status: OPEN (S487, Claude main). Discipline: boxing. Model: qwen3-coder (Qwen), default.

## Why
CLASH8 (branch qwen/clash8, 4f63d719; read docs/CLASH8_RESULT.md there) measured 09_jab f19 and 08_jab f40 (seed 4242):
no layer after ArmClash moves the gloves back. GloveClear clears a glove capsule along the FOREARM ((wrist - elbow)),
but the glove is DRAWN along Gloves._follow's axis (the knuckle direction slerped 0.85 toward the forearm,
scripts/fight3d/Gloves.gd:104-117), and tools/clash_meter.gd:28 measures the drawn axis. At f19 boxer 0's right hand is
rank 0 (a guard hand) and DOES move: its forearm-axis depth goes 0.051 -> -0.016, while the drawn glove still overlaps
0.057 m. When CLASH8 made GloveClear use the drawn axis, _deepest and the meter agreed (0.069 m) but the overlap did not
clear (it reverted that).
CLASH8's note blames the rank skip; at f19 that is not it: the hand that should move (rank 0) is the one that moved.
The open question: a hand that SEES the true 0.069 m overlap pushes, and the glove is still in. Why?

## What to do
1. Your worktree starts from qwen/clash8 (the BASE line). Keep SkelPump.
2. Put the drawn axis into GloveClear (CLASH8's `_glove_along`: the same formula as Gloves._follow, reading the same
   bones) for its own glove AND the peer glove it reads (shown_arms index 2).
3. MEASURE at 09_jab f19 and 08_jab f40, per clash pass (CLASH_PASSES), for the hand that moves: the depth before, the
   push wanted, the push applied after PUSH_MAX_M, the wrist moved (metres) after PunchReach re-solves, the depth after.
   And once per frame: the glove node's axis after Gloves._follow vs the axis GloveClear used (degrees apart).
   Write them in docs/CLASH9_RESULT.md. Name which of these stops the clear: (a) PUSH_MAX_M caps it, (b) the re-solve
   does not move the wrist as asked (arm at reach / the hand's rotation kept turns the glove back in), (c) the glove
   node's axis changes after the push (the knuckle bone moves with the re-solve), (d) something else (say what).
4. FIX only what step 3 names. Never lower a bar, never add a clamp layer after everything, never change the meter.

## Film command (hidden desktop - nothing on the owner's monitors)
`python ops/Tools/godot_slot.py run --who qwen -- python tools/hidden_desktop.py run --timeout=600 --log=<out>/log.txt <godot.exe> --path . --windowed --resolution 960x540 --audio-driver Dummy --fixed-fps 60 --script res://tools/hit_frame_film.gd -- <out> jabs=3 crosses=3 uppercuts=2 seed=4242`
(and seed=77). Today on qwen/clash8: 08_jab f40 0.054 m, 09_jab f19 0.057 m (seed 4242). Never sleep to wait; use a
foreground timeout. A RESULT line states what the film printed in THIS run, never what you expect: CLASH8's pass lines
said 0 frames while its own note said the fix was reverted and f19 still read 0.057 m.

## Pass lines
RESULT: docs/CLASH9_RESULT.md -> what stops the clear: <a | b | c | d: ...>
RESULT: tools/hit_frame_film.gd seed=4242 -> 08_jab CLASH frames deeper than 0.02 m from the hit on: <n, printed>
RESULT: tools/hit_frame_film.gd seed=4242 -> 09_jab CLASH frames deeper than 0.02 m from the hit on: <n, printed>
RESULT: tools/hit_frame_film.gd seed=77 -> CLASH frames deeper than 0.02 m: <n, printed> (qwen/clash8: <n>)

## Contract
BASE: qwen/clash8
OWNS: scripts/fight3d/GloveClear.gd, scripts/fight3d/Gloves.gd, scripts/fight3d/PunchReach.gd, docs/CLASH9_RESULT.md, docs/clash9/
(Gloves.gd and PunchReach.gd: read-only unless step 3 names them; say which line and why)
RED_TEST: tools/hit_frame_film.gd -> 09_jab CLASH frames deeper than 0.02 m from the hit on: 0 (qwen/clash8 reads 1, f19 0.057 m)
REGRESSION: tests/own_gloves_test.gd, tests/hit_carry_test.gd, tests/hit_frame_test.gd, tests/cam_line_test.gd
(one by one, `--headless --audio-driver Dummy --fixed-fps 60`)
VISUAL: yes - stills only through tools/still_framing.gd save_if_framed; Claude opens them, the owner closes it.
NOT YOURS: every other file. Every script under 500 lines. Work on qwen/clash9, commit, push, never merge.

## Prior research
docs/CLASH7_RESULT.md, docs/CLASH8_RESULT.md; ops/research/TASK_CLASH6.md "Audit (S484)"; tools/layer_trace.gd (S469);
memory: print the armed clip before tuning; read the frame that is drawn (S470).

## What would a human do?
Push the glove out by hand, frame by frame, and watch where it lands after the arm is re-solved: the number that does not
add up names the fault.

## Prefab check
None: our own pose layers.
