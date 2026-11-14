# TASK OWNGLOVE1 - a boxer's own two gloves pass through each other in the guard (keep them apart, film + stills)

Status: OPEN (S476, Claude main). Discipline: boxing. Model: qwen3-coder (Qwen), default. Run AFTER BLOCKCLIP1 has landed
(both touch the clearance layers; start from origin/main with BLOCKCLIP1 merged).

## Why now
S476 added an own-pair read to tools/clash_meter.gd (`own(stage)`). Nothing in the game keeps a boxer's own gloves apart:
GloveClear.gd only clears one boxer's arms off the OTHER boxer's. tests/own_gloves_test.gd (new, red on main):
`OWN_GLOVES boxer=0 worst=0.100 (glove x glove, pro_idle_fidget_v7) deep_frames=54 of 600`,
`OWN_GLOVES boxer=1 worst=0.127 (glove x glove, pro_idle) deep_frames=149 of 600` - in the plain guard and its fidgets, no
punches. hit_frame_film shows the same after punches (seed 77: 9 of 10 shots, up to 0.117 m; seed 4242: 9 of 10, up to 0.137 m).
In a real tight guard the gloves TOUCH (padding squashes a little); they never stack one through the other.

## What to do
1. Run tests/own_gloves_test.gd on main and record the lines.
2. In scripts/fight3d/GloveClear.gd add an own-gloves pass in clash_pass() AFTER the cross-boxer clearance (it runs last of the
   arm layers, so nothing later moves the hands - clash_meter's `drift` and tools/layer_trace.gd prove it). Shapes = this file's
   GLOVE_AT / GLOVE_R / FORE_R (the same as clash_meter). When her two gloves (or a glove and her other forearm) overlap by more
   than the 2 cm give: move the hand with the LOWER rank (_rank: 2 live punch, 1 going home, 0 guard) out of the overlap; equal
   ranks: the REAR hand moves (orthodox right, southpaw left - read the stance the way BoxerFootwork does), never a live punch.
   Move it along the gap between the two gloves (sideways, away from her other glove), re-solve with PunchReach.solve keeping
   the hand's rotation (as _clear_arms does), a few passes, PUSH_MAX_M per pass. Keep the hand off her own face (TUCK_M idea).
   Keep the file under 500 lines (331 now); if it would pass that, put the pass in a new scripts/fight3d/OwnGloves.gd called
   from clash_pass().
3. Then: tests/own_gloves_test.gd must pass (both boxers <= 0.02 m). Film both seeds (hidden desktop, `--log=` takes `=`):
   `python ops/Tools/godot_slot.py run --who qwen -- python tools/hidden_desktop.py run --timeout=600 --log=<out>/log.txt <godot.exe> --path . --windowed --resolution 960x540 --fixed-fps 60 --script res://tools/hit_frame_film.gd -- <out> jabs=3 crosses=3 uppercuts=2 seed=77`
   and seed=4242: every shot's `OWN frames deeper than 0.02 m` line goes down, and no shot's `CLASH frames deeper` line gets a
   frame it did not have on main (the cross-boxer clearance must not get worse).
4. Regression (headless `--fixed-fps 60`): tests/guard_knee_test.gd, tests/guard_weave_test.gd, tests/glove_cut_test.gd,
   tests/hit_frame_test.gd + tests/hit_carry_test.gd (both RED on main: 3 and 32 failures - show the branch's FAIL set is not
   larger), tests/block_meet_test.gd (`--fixed-fps 30`; red on main, 13 - same rule).
5. Stills: the guard from the side and from the front, close, main and branch - `tools/knee_band_still.gd` renders one boxer
   (`-- <out_dir> kneeband=20`); also f33 of seed 77 01_rear_uppercut from both films. docs/ownglove1/, at most 6 PNGs, each
   < 1 MB. docs/OWNGLOVE1_RESULT.md: test lines before/after, OWN + CLASH lines per shot before/after, stills, one paragraph.

## Pass lines
RESULT: tests/own_gloves_test.gd -> OWN_GLOVES failures=0
RESULT: docs/OWNGLOVE1_RESULT.md -> stills=<n>

## Contract
OWNS: scripts/fight3d/GloveClear.gd, scripts/fight3d/OwnGloves.gd, docs/OWNGLOVE1_RESULT.md, docs/ownglove1/
RED_TEST: tests/own_gloves_test.gd -> OWN_GLOVES failures=0 (red on main: boxer 0 0.100 m, boxer 1 0.127 m)
REGRESSION: tests/guard_knee_test.gd, tests/guard_weave_test.gd, tests/glove_cut_test.gd, tests/hit_frame_test.gd, tests/hit_carry_test.gd, tests/block_meet_test.gd
VISUAL: yes - guard close stills side + front and the f33 film frame, main and branch; Claude and the owner judge them
NOT YOURS: every other file (tests/own_gloves_test.gd and tools/clash_meter.gd stay as they are); never delete or weaken a test.
Godot 4.7.2: `%LOCALAPPDATA%\Programs\Godot\Godot_v4.7.2-stable_win64.exe` (never _console.exe). Never open an image with an app.

## Prior research
memory S465 (GloveClear), S468 (clash_meter, ArmClash order), S476 (outward-open push fix, this ruler); GloveClear.gd header.
## What would a human do?
A boxer in a tight shell keeps the gloves side by side, touching at the thumbs; when one hand is busy the other stays where it
is. Move the guard hand aside off the other glove, the way GloveClear moves it off the opponent's.
## Prefab check
None: our own clearance layer.
