# TASK CLASH6 - resolve the glove clash in two phases (all boxers update, then all resolve)

Status: OPEN (S481, Claude main). Discipline: boxing. Model: qwen3-coder (Qwen), default. Start from origin/main at or after
the S481 commits.

## Why now
CLASH5 (ops/research/CLASH5_RESULT.md, Qwen S479-S481) found the root cause of the last clash frames (seed 4242: 08_jab f40
0.054 m, 09_jab f19 0.057 m): the modifier stacks run one boxer after the other, so the FIRST boxer's ArmClash /
GloveClear reads the peer's `shown_arms` from the PREVIOUS frame. When a glove jumps ~12 cm in one frame after a hit-stop
(clip time catching up + PunchReach settle + HitSnap), the first boxer pushes off a stale place in the wrong direction.
Twelve tunings failed (table in the result page). The fix is structural: two phases.

## What to do
1. Read how the two boxers' modifier stacks run in a frame (scripts/fight3d: GloveClear.gd 434 lines, ArmClash.gd, the rig
   that adds them, the fight scene that owns both rigs). Write down in docs/CLASH6_RESULT.md the order a frame runs today
   (which skeleton first, where shown_arms is written and read).
2. Make the cross-boxer clash resolve with BOTH boxers' current-frame arms: phase 1 = every boxer's layers up to (not
   including) the cross-boxer clash write their current arms; phase 2 = the clash between the two boxers resolves once, with
   both current, and writes each boxer's arm correction. Pick the way that works in Godot 4.7.2 and SAY WHY (e.g. the second
   skeleton's last modifier resolves the pair and applies the first boxer's correction - check on the film that a write to
   the first skeleton then still shows THIS frame, not the next; or a pair node driven from Skeleton3D.modification_processed
   or a process_priority after both rigs). The own-glove pass (OWN_ROUNDS = 2) and the S478 rise gate stay as they are.
3. Then: seed 4242 08_jab AND 09_jab have no CLASH frame deeper than 0.02 m from the hit on; no shot on seed 4242 or seed 77
   gains a CLASH frame it does not have on main; every OWN line stays 0.
4. Regression (headless, `--headless --audio-driver Dummy --fixed-fps 60`): tests/own_gloves_test.gd (green - must stay),
   guard_knee, guard_weave, glove_cut, cam_line (green), hit_frame (3 FAIL on main) and hit_carry (32 FAIL on main) - the FAIL
   set must not grow - and block_meet at `--fixed-fps 30` (1 FAIL on main: CTRL_LANDED B_A RULER_FAIL - same rule).
5. Stills: seed 4242 08_jab f40 and 09_jab f19, main and branch side by side, from the films (docs/clash6/, at most 4 PNGs,
   each < 1 MB). Do NOT commit the film folders.

Film command:
`python ops/Tools/godot_slot.py run --who qwen -- python tools/hidden_desktop.py run --timeout=600 --log=<out>/log.txt <godot.exe> --path . --windowed --resolution 960x540 --audio-driver Dummy --fixed-fps 60 --script res://tools/hit_frame_film.gd -- <out> jabs=3 crosses=3 uppercuts=2 seed=4242`
(and seed=77). Main today: 08_jab f40 0.054 m, 09_jab f19 0.057 m (seed 4242).

## Pass lines
RESULT: tools/hit_frame_film.gd seed=4242 -> 08_jab CLASH frames deeper than 0.02 m from the hit on: 0
RESULT: tools/hit_frame_film.gd seed=4242 -> 09_jab CLASH frames deeper than 0.02 m from the hit on: 0
RESULT: docs/CLASH6_RESULT.md -> phases=2 how=<one line> stills=<n>

## Contract
OWNS: scripts/fight3d/GloveClear.gd, scripts/fight3d/ArmClash.gd, scripts/fight3d/BoxerBuild.gd, scripts/fight3d/ClashPair.gd, docs/CLASH6_RESULT.md, docs/clash6/
(BoxerBuild.gd adds the stack, 223 lines; ClashPair.gd is a NEW helper if the pair resolve needs its own file; FightStage.gd
is 482 lines and NOT yours - if the order has to change there, stop and say so in the result page)
RED_TEST: tools/hit_frame_film.gd seed=4242 jabs=3 crosses=3 uppercuts=2 -> 08_jab and 09_jab CLASH frames deeper than 0.02 m: 0 (main: 1 each)
REGRESSION: tests/own_gloves_test.gd, tests/guard_knee_test.gd, tests/guard_weave_test.gd, tests/glove_cut_test.gd, tests/cam_line_test.gd, tests/hit_frame_test.gd, tests/hit_carry_test.gd, tests/block_meet_test.gd
VISUAL: yes - the f40 / f19 stills main v branch; Claude and the owner judge them
NOT YOURS: every other file (tools/clash_meter.gd, tools/hit_frame_film.gd and all tests stay as they are); never delete or
weaken a test. Every file stays under 500 lines (GloveClear.gd is 434: split a helper out if it grows).
Godot 4.7.2: `%LOCALAPPDATA%\Programs\Godot\Godot_v4.7.2-stable_win64.exe` only (the plain exe, no terminal build). Never open
an image with an app.

## Prior research
ops/research/CLASH5_RESULT.md (root cause + 12 failed tunings); memory S465 (GloveClear), S468 (clash_meter, ArmClash order),
S470 (layer_trace first), S478 (rise gate, own pass order), S479 (CLASH5 brief).
## What would a human do?
Two boxers see each other at the same moment. Let both arms land where their own layers put them, then settle the contact once.
## Prefab check
None: our own animation layers.
