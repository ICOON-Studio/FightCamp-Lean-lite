# TASK CLASH4 - two guard gloves still meet inside each other when BOTH boxers read the other a frame late

Status: OPEN (S478, Claude main). Discipline: boxing. Model: qwen3-coder (Qwen), default. Start from origin/main at or after
4af31f4d (OWNGLOVE1 + BLOCKCLIP1 + the CLASH3 rise gate are merged).

## Why now
GloveClear.gd keeps each boxer's arms off the other's. The boxer drawn FIRST in a frame reads the other's arms one frame old
(+ their last move, `shown_arms` [5] and [6]) and moves ARM_SHARE (0.6) of an equal-rank overlap; the boxer drawn SECOND is
meant to see the first one's arms as drawn THIS frame (`late` false) and take the rest. The S478 trace shows frames where BOTH
are late, so neither sees the real overlap:
  seed 4242, 08_jab f40: `clashdbg f40 depth 0.054 0l glove x 1l glove (ranks 0 0)`, `0: late true ...`, `1: late true ...`
  (two guard gloves 5.4 cm inside each other). Other leftovers on main now (hit_frame_film, CLASH frames deeper than 0.02 m):
  seed 4242 09_jab f19 0.057 m; seed 77 07_cross f19 0.047 m `0l glove x 1r fore (ranks 0 1)`, 08_cross f29 0.036 m,
  03_lead_uppercut f26 0.023 m.

## What to do
1. Film main on both seeds and record every `CLASH frames` line and every `clashdbg` block (they now print each boxer's layer
   `trail` too):
   `python ops/Tools/godot_slot.py run --who qwen -- python tools/hidden_desktop.py run --timeout=600 --log=<out>/log.txt <godot.exe> --path . --windowed --resolution 960x540 --audio-driver Dummy --fixed-fps 60 --script res://tools/hit_frame_film.gd -- <out> jabs=3 crosses=3 uppercuts=2 seed=4242`
   and seed=77.
2. Find out WHY both boxers can be late in one frame (GloveClear.clash_pass: `int(peer.shown_f) != Engine.get_process_frames()`).
   Candidates: shown_f is written at the end of clash_pass, so a boxer whose ArmClash did not run that frame never stamps it;
   the two skeletons' modifier stacks may run in an order where neither has stamped yet; process frames vs the skeleton's own
   update. Print what you need (dbg_on is the probe switch; take it out after). Write the answer in the result page.
3. Fix it so that in every frame exactly one boxer reads late and the other reads the drawn arms (or, if the engine order cannot
   promise that, the second reader re-reads after both have stamped). Keep the S468 rule: equals share it, the lower rank
   moves all of it, two live punches leave each other be. Keep OWN_ROUNDS and the S478 rise gate (`_block_up`) as they are.
4. Then: seed 4242 08_jab has no frame deeper than 0.02 m, and no shot on either seed gains a CLASH frame it does not have on
   main; every OWN line stays 0.
5. Regression (headless): tests/own_gloves_test.gd (green on main - must stay), guard_knee, guard_weave, glove_cut, cam_line
   (green), hit_frame (3 FAIL on main) and hit_carry (32 FAIL on main) - the FAIL set must not grow - and block_meet at
   `--fixed-fps 30` (1 FAIL on main: CTRL_LANDED B_A RULER_FAIL - same rule).
6. Stills: seed 4242 08_jab f40, main and branch side by side, game camera, from the films (docs/clash4/, at most 4 PNGs,
   each < 1 MB). Do NOT commit the film folders. docs/CLASH4_RESULT.md: why both were late, the fix, CLASH lines per shot
   before/after on both seeds, test lines.

## Pass lines
RESULT: tools/hit_frame_film.gd seed=4242 -> 08_jab CLASH frames deeper than 0.02 m from the hit on: 0
RESULT: docs/CLASH4_RESULT.md -> stills=<n>

## Contract
OWNS: scripts/fight3d/GloveClear.gd, scripts/fight3d/ArmClash.gd, docs/CLASH4_RESULT.md, docs/clash4/
RED_TEST: tools/hit_frame_film.gd seed=4242 jabs=3 crosses=3 uppercuts=2 -> 08_jab CLASH frames deeper than 0.02 m: 0 (main: 1, 0.054 m at f40)
REGRESSION: tests/own_gloves_test.gd, tests/guard_knee_test.gd, tests/guard_weave_test.gd, tests/glove_cut_test.gd, tests/cam_line_test.gd, tests/hit_frame_test.gd, tests/hit_carry_test.gd, tests/block_meet_test.gd
VISUAL: yes - the f40 still main v branch; Claude and the owner judge it
NOT YOURS: every other file (tools/clash_meter.gd, tools/hit_frame_film.gd and all tests stay as they are); never delete or
weaken a test. GloveClear.gd is 434 lines: stay under 500 (a helper file scripts/fight3d/ArmRead.gd is yours if needed).
Godot 4.7.2: `%LOCALAPPDATA%\Programs\Godot\Godot_v4.7.2-stable_win64.exe` (never _console.exe). Never open an image with an app.

## Prior research
memory S465 (GloveClear), S468 (clash_meter, ArmClash order), S476 (outward push), S478 (blocked punch = the catch's only once
it rises; own pass order: own, then 2 rounds of other-boxer + own). GloveClear.gd header and the clash_pass comments.
## What would a human do?
Two boxers' guard gloves bump and slide off each other; neither sinks into the other. Each sees where the other's hands are
right now, not where they were a moment ago.
## Prefab check
None: our own clearance layer.
