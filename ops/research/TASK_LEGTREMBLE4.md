# TASK LEGTREMBLE4 - QWEN (qwen3-coder) - the trembling legs, round 4: why head_aim voids a row with the smoothed clips

Status: OPEN (S424, Claude main). Discipline: boxing. Model: qwen3-coder. Animation item (operator S401).
Source: the operator, watching fights: the legs tremble in round 2. LEGTREMBLE3 (branch cursor/legtremble3, 5af23d18) rewrote
149 baked clips and its own bars pass, but tests/head_aim_test.gd goes red 1-2 times a run with them (0 on main's clips, twice).
Start your branch FROM cursor/legtremble3.

## What Claude read (S424, E:\FightCamp\tmp\head_aim.log, the branch's run)
- The only failure is a VOID, not an aim fault: `AIM B_A_dn lead_hook ... gap=0.972 ... VOID` with the pair at gap_m 0.916.
  GAP_TOL is 0.05, so it missed by 6 mm. Every height, depth, smooth, latch and join bar passed.
- The gap is NOT read at contact: `_reset()` (head_aim_test.gd line 110) puts both boxers back at +-gap_m/2, plays the guard,
  waits 3 frames, then reads `_hips_gap`. So a VOID means the hips had not settled 3 frames after the previous punch, or the
  guard now holds the hips somewhere else.
- tools/leg_smooth_bake.gd writes the Hips position only for clips that travel (`_travels`, pro_ + TRAVEL_WORDS); for the
  rest it changes leg rotations only.

## Contract
OWNS: tests/head_aim_test.gd, tools/leg_smooth_bake.gd, assets/anim/baked/*.res, docs/LEGTREMBLE1_RESULT.md
(head_aim_test.gd: only `_reset` and new print lines. The .res files only if step 3 says the bake moved the guard's hips.)
RED_TEST: tests/head_aim_test.gd -> HEAD_AIM failures=0
REGRESSION: beat_clips_test, move_tip_test, block_meet_test
BASE: cursor/legtremble3
VISUAL: Claude films round 2 after the merge. Do not render.

## The job
1. A probe (a print block in head_aim_test, or tools/reset_settle_probe.gd): after each `_reset`, print the hips gap every
   frame for 30 frames, for every setup and clip, on main's clips AND on the branch's clips (two runs). One line each:
   `SETTLE <setup> <clip> f3=<gap> f10=<gap> f30=<gap> settled_at=<frame within 0.01 of gap_m or -1>`.
2. If the branch's gap reaches gap_m +- 0.01 by frame 30 everywhere: the ruler read too early. Change `_reset` to wait until
   the hips gap is within 0.01 of gap_m (at most 30 frames) and print how many frames it waited. Nothing else in the test
   changes: GAP_TOL, HEIGHT_BAR, SMOOTH_TOL, DEPTH_TOL, LATCH_TOL stay.
3. If it never settles to gap_m with the branch's clips (it does with main's): the bake moved the guard's or the hook's hips.
   Find the clip (print the Hips position track's first key and its mean, main vs branch, for the guard clip and
   pro_left_hook's baked file) and re-bake it with `_hold_xz` on the Hips so the body stays where main's clip held it.
4. Run head_aim_test 3 times in a row on your branch: 0 failures each time. Run leg_tremble_test: still green.
5. docs/LEGTREMBLE1_RESULT.md: a "Round 4" section, the SETTLE table (main vs branch, short) and five sentences.

## Prior research
Branch cursor/legtremble3 commit message; tests/head_aim_test.gd lines 110-210; scripts/fight3d/FightStage.gd `_gap`,
`_gap_shown` (S391: with the footwork rig the feet may still be stepping to `pos`); ops/research/GDSCRIPT_TRAPS.md.

## What would a human do?
Watch the two boxers between punches and see whether they are still drifting when the ruler reads them.

## Prefab check
None: our own test and bake.

## Rules
Godot only through `python ops/Tools/godot_slot.py run --who qwen -- <godot.exe> --headless --audio-driver Dummy --path . --script <script>`.
No file over 500 lines (head_aim_test.gd is 300, leg_smooth_bake.gd 484: if it must grow, move a helper out). Never "he" or
"she" in text. Do not loosen any tolerance. Write no check that can only pass: say in the PR body which SETTLE lines differ
between main and the branch.

## Result lines (PR body)
RESULT: tests/head_aim_test.gd -> HEAD_AIM failures=0 (three runs)
RESULT: tests/leg_tremble_test.gd -> LEG_TREMBLE failures=0
