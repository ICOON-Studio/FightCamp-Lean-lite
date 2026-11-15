# TASK CLASH5 - the guard glove that jumps 30 cm in one frame (seed 4242 08_jab f40), and the clash read that cannot see it

Status: OPEN (S479, Claude main). Discipline: boxing. Model: qwen3-coder (Qwen), default. Start from origin/main at or after
the S479 commits (GloveClear.gd unchanged since 4af31f4d).

## Why now
CLASH4 (PR 297, closed S479) raised OWN_ROUNDS 2 -> 3: 08_jab f40 stayed at 5.4 cm on Claude's film, and the brief said keep
OWN_ROUNDS. Claude tried reading "late" by drawing order (`peer.shown_f <= shown_f`) instead of "not this frame": the film was
IDENTICAL (08_jab f40 0.054 m), so the order of the two skeletons is not the cause. What the film does show at f40:
  `HIT_FRAME_FILM 08_jab speeds ... f39 2.2 m/s 0.429 m, f40 18.2 m/s 0.313 m, f41 0.8 m/s 0.326 m`
  `clashdbg f40 depth 0.054 0l glove x 1l glove (ranks 0 0)` / `hands moved after ArmClash by: 0: - | 1: -`
  trail 0: `... HitSnap L y1.33 > ArmClash L y1.25 +0.117 R y1.11 +0.199`
A glove moves 12 cm in one frame (18 m/s) after the hit, then stops. Each boxer reads the other's arms a frame old PLUS their
last move (`shown_arms` [5] [6]); a one-frame jump cannot be predicted from the frame before, so both push off the wrong place.

## What to do
1. Film main (seed 4242, command below) with `dbg_on` and print, for f37-f42 and BOTH boxers: the AnimationPlayer's current
   clip + position, PunchReach `_clip` / `_hand` / `_fades`, which hand is the left glove at f40, and each modifier's hand move
   (the film's `trail`). Write in docs/CLASH5_RESULT.md WHICH layer or clip change makes the 12 cm jump at f40.
2. If the jump is a defect (a clip starting or ending with no blend, a fade dropped, a layer switching on/off): fix it at that
   layer so the glove moves at punch-like speed or less (no frame-to-frame move > 6 cm on a guard hand). That is the real fix.
3. Only if the jump is a real fast move (a new punch starting): make the clash read cope - e.g. when the peer's arm moved more
   than 6 cm since the frame before, read it with no extrapolation and take all of an equal-rank overlap - and say why in the
   result page.
4. Then: seed 4242 08_jab has no CLASH frame deeper than 0.02 m from the hit on; no shot on seed 4242 or seed 77 gains a CLASH
   frame it does not have on main; every OWN line stays 0.
5. Regression (headless, `--headless --audio-driver Dummy --fixed-fps 60`): tests/own_gloves_test.gd (green - must stay),
   guard_knee, guard_weave, glove_cut, cam_line (green), hit_frame (3 FAIL on main) and hit_carry (32 FAIL on main) - the FAIL
   set must not grow - and block_meet at `--fixed-fps 30` (1 FAIL on main: CTRL_LANDED B_A RULER_FAIL - same rule).
6. Stills: seed 4242 08_jab f40, main and branch side by side, from the films (docs/clash5/, at most 4 PNGs, each < 1 MB).
   Do NOT commit the film folders.

Film command:
`python ops/Tools/godot_slot.py run --who qwen -- python tools/hidden_desktop.py run --timeout=600 --log=<out>/log.txt <godot.exe> --path . --windowed --resolution 960x540 --audio-driver Dummy --fixed-fps 60 --script res://tools/hit_frame_film.gd -- <out> jabs=3 crosses=3 uppercuts=2 seed=4242`
(and seed=77). Main today: 08_jab f40 0.054 m, 09_jab f19 0.057 m (seed 4242).

## Pass lines
RESULT: tools/hit_frame_film.gd seed=4242 -> 08_jab CLASH frames deeper than 0.02 m from the hit on: 0
RESULT: docs/CLASH5_RESULT.md -> jump layer=<name> stills=<n>

## Contract
OWNS: scripts/fight3d/GloveClear.gd, scripts/fight3d/ArmClash.gd, scripts/fight3d/HitSnap.gd, scripts/fight3d/PunchReach.gd, docs/CLASH5_RESULT.md, docs/clash5/
(the two layer files only if step 1 names that layer; PunchReach.gd is 464 lines - stay under 500. Another layer: stop and say which in the result page)
RED_TEST: tools/hit_frame_film.gd seed=4242 jabs=3 crosses=3 uppercuts=2 -> 08_jab CLASH frames deeper than 0.02 m: 0 (main: 1, 0.054 m at f40)
REGRESSION: tests/own_gloves_test.gd, tests/guard_knee_test.gd, tests/guard_weave_test.gd, tests/glove_cut_test.gd, tests/cam_line_test.gd, tests/hit_frame_test.gd, tests/hit_carry_test.gd, tests/block_meet_test.gd
VISUAL: yes - the f40 still main v branch; Claude and the owner judge it
NOT YOURS: every other file (tools/clash_meter.gd, tools/hit_frame_film.gd and all tests stay as they are); never delete or
weaken a test; keep OWN_ROUNDS = 2 and the S478 rise gate. Every file stays under 500 lines (GloveClear.gd is 434).
Godot 4.7.2: `%LOCALAPPDATA%\Programs\Godot\Godot_v4.7.2-stable_win64.exe` (never _console.exe). Never open an image with an app.

## Prior research
memory S465 (GloveClear), S468 (clash_meter, ArmClash order), S470 (the hit ruler read a frame early; layer_trace first),
S478 (rise gate, own pass order). TASK_CLASH4.md and qwen/clash4's docs/CLASH4_RESULT.md (OWN_ROUNDS 3: 3 -> 1 frame).
## What would a human do?
A guard hand never teleports; it slides at the speed of a hand. Find the layer that teleports it before teaching the
clearance to chase it.
## Prefab check
None: our own animation layers.
