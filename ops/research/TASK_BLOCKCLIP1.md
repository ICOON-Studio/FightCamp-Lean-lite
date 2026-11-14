# TASK BLOCKCLIP1 - the catching glove sits 9.9 cm inside the cross it blocks (measure, fix, stills)

Status: OPEN (S476, Claude main). Discipline: boxing. Model: qwen3-coder (Qwen), default.

## Why now
S476 CLASH3 (commit after 6f7d160b, scripts/fight3d/GloveClear.gd): the clipping ruler tools/clash_meter.gd, read in
tools/hit_frame_film.gd at `seed=77 jabs=3 crosses=3 uppercuts=2`, shot 08_cross: 5 frames deeper than 2 cm from the hit on,
worst 0.099 m at f27, pair "0r glove x 1l glove (ranks 2 0)" - boxer 1's LEFT glove is inside boxer 0's punching right glove.
Its clashdbg line: `1: ... Left r0 before 0.087 after 0.087` - GloveClear does not move it ON PURPOSE: GloveClear._clear_arms
skips a hand whose punch is BLOCKED (`int(arm[7]) == 2`: "a blocked punch is the block's to meet"). So the meeting place is
BlockCatch's: scripts/fight3d/BlockCatch.gd `MEET_M := 0.06` ("the glove's centre sits this far behind the punching glove's
front (touching it)") and scripts/fight3d/BlockCatchPoint.gd. The ruler's glove is a capsule G0 0.04 -> G1 0.115 m ahead of the
wrist, radius 0.075 (clash_meter.gd header): a catching glove whose CENTRE is 6 cm behind the punching glove's front is inside
the punching glove's capsule by design. Suspect the meeting point, not GloveClear.

## What to do
1. Film main first and keep the numbers (hidden desktop, never a visible window):
   `python ops/Tools/godot_slot.py run --who qwen -- python tools/hidden_desktop.py run --timeout=600 --log=<out>/log.txt <godot.exe> --path . --windowed --resolution 960x540 --fixed-fps 60 --script res://tools/hit_frame_film.gd -- <out> jabs=3 crosses=3 uppercuts=2 seed=77`
   (`--log=` takes `=`; the HIT_FRAME_FILM ... CLASH lines are in log.txt). Also seed=4242 with the same counts.
2. Read BlockCatch.gd + BlockCatchPoint.gd (343 + its lines; read in windows). Find where the catching glove's target is set
   from MEET_M and why it lands inside the punch. Fix the meeting point so the catching glove's FRONT meets the punching glove's
   front (touching, not inside): e.g. MEET_M from the two capsules' radii, or the target pushed back along the punch line by
   the overlap the ruler would read. Keep BLOCKLOOK4/5's other bars (FACE_KEEP_M, OVER_HEAD_MAX_M, LOW_M, MET_HOLD_S).
3. Film again, both seeds: shot 08_cross (seed 77) must read <= 0.02 m on every frame from the hit on, and no other shot may
   get a frame deeper than 0.02 m that it did not have on main (compare the CLASH lines shot by shot; the shots are the same
   on the same seed).
4. Run (headless, `--fixed-fps 60` unless noted): tests/block_meet_test.gd (`--fixed-fps 30`, as tools/run_tests.sh FIXED_FPS),
   tests/guard_weave_test.gd, tests/glove_cut_test.gd. block_meet_test is RED ON MAIN (13 failures, "two stands of the same
   pair disagree" - it needs the stage); record main's FAIL set and show the branch's FAIL set is not larger.
5. Stills: the f27 frame of 08_cross (seed 77) from main and from the branch, side by side, into docs/blockclip1/
   (PIL is fine; at most 4 PNGs, each under 1 MB). Write docs/BLOCKCLIP1_RESULT.md: CLASH lines before/after per shot,
   test FAIL sets before/after, the stills, one paragraph.

## Pass lines
RESULT: tools/hit_frame_film.gd seed=77 -> 08_cross CLASH frames deeper than 0.02 m from the hit on: 0
RESULT: docs/BLOCKCLIP1_RESULT.md -> stills=<n>

## Contract
OWNS: scripts/fight3d/BlockCatch.gd, scripts/fight3d/BlockCatchPoint.gd, docs/BLOCKCLIP1_RESULT.md, docs/blockclip1/
RED_TEST: tools/hit_frame_film.gd seed=77 jabs=3 crosses=3 uppercuts=2 -> 08_cross CLASH frames deeper than 0.02 m from the hit on: 0 (red on main: 5, worst 0.099 m)
REGRESSION: tests/block_meet_test.gd, tests/guard_weave_test.gd, tests/glove_cut_test.gd
VISUAL: yes - f27 of seed 77's 08_cross, main and branch; Claude and the owner judge them
NOT YOURS: every other file (GloveClear.gd, clash_meter.gd, hit_frame_film.gd stay as they are); never delete or weaken a test.
Godot 4.7.2: `%LOCALAPPDATA%\Programs\Godot\Godot_v4.7.2-stable_win64.exe` (never the _console.exe). Never open an image with an app.

## Prior research
memory S465 (GloveClear glove-vs-glove), S468 (clash_meter, ArmClash order, block_meet reads a half-eased glove), S469;
BLOCKLOOK4/5 comments in BlockCatch.gd; this brief's numbers from S476.
## What would a human do?
A boxer catching a cross meets it with the palm of the glove: the two gloves touch, padding squashed a little, never one through
the other. Put the catching glove where the punch's glove face arrives, not inside it.
## Prefab check
None: our own block layer.
