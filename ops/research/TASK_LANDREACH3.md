# TASK LANDREACH3 - the landed lead glove stops 5-11 cm above or below the face point it aims at (fix, headless)

Status: OPEN (S467, Claude main). Discipline: boxing. Model: qwen3-coder (Qwen), default.

## Why now
tests/block_meet_test.gd is red on main: 4 CTRL_LANDED rows (a landed punch must end < 0.05 m from the face point):
A_B pro_left_jab 0.060, A_B pro_right_cross 0.064, B_A pro_left_hook 0.089, A_A pro_left_hook 0.054.
S467 Claude measured each row on the CONTACT frame (temporary print, not on main):
- the latched hit point (PunchReach.hit_face) is ON the face point (within 0.01 m) - the AIM is right;
- the glove as drawn is off that hit point mostly in HEIGHT: A_B jab y -0.077, A_B cross y -0.044, A_B lead hook y -0.109,
  B_A jab y +0.095, B_A lead hook y +0.087 (the x/z parts are 0.00-0.06).
So the solve does not put the glove front on the point it aims at. Suspects, in order (read each, prove which):
1. PunchReach._note_shown (scripts/fight3d/PunchReach.gd ~290-316): on the hit frame `_hit_w` is reset to the glove AS DRAWN
   via ReachLimit.carry_base, which keeps the drawn glove for every punch but the rear cross/rear hook (S466: SHOWN_M 0.02).
   So a lead glove drawn 5-10 cm off becomes the new hit point and the reach never closes it. S466 tried carry_base for EVERY
   punch: block_meet 2 failures but hit_frame +4 THROUGH (lead jab/hooks, an uppercut carried 0.12-0.27 m through).
2. ReachLimit.cap (0.30 m from the clip glove) / ReachDrive.aim / solve_capped leaving the front point low or high
   (the forearm's tilt moves the front offset `_front`).
Docs to read first: docs/LANDREACH1_RESULT.md (S465-S466 table, bisect, what was tried and dropped).

## What to do
1. Add a print in a NEW probe tools/landreach3_probe.gd (copy block_meet's CTRL_LANDED setup: Stand, stg.play, stg.land, seek
   to contact, pause, 2 frames) that prints per row: glove - hit_face, hit_face - target, the drawn glove BEFORE carry_base,
   and whether carry_base moved _hit_w. Find which suspect it is.
2. Fix it in scripts/fight3d/ReachLimit.gd and/or PunchReach.gd: the lead hand's carry starts from the face point when the
   drawn glove is off it in HEIGHT (not along the punch line), and the carry itself stays THROUGH_M (no 0.12 m+ through).
   Uppercuts keep their drawn point (S466).
3. `-- nopunchrange` must keep the old behaviour (control arm).

## Pass lines
- block_meet_test: no CTRL_LANDED RULER_FAIL; total failures <= today's 4 minus the fixed rows (print before/after).
- tests/hit_frame_test.gd failures <= 10 (today 10) and no new THROUGH row.
- tests/hit_carry_test.gd failures <= 34 (noise band 32-38).
Final line in the probe: `LANDREACH3 ctrl_fail=<n> worst_height=<m>`.

## Contract
OWNS: scripts/fight3d/ReachLimit.gd, scripts/fight3d/PunchReach.gd (both under 500 lines - check `wc -l` before and after),
tools/landreach3_probe.gd, docs/LANDREACH3_RESULT.md
RED_TEST: tests/block_meet_test.gd -> BLOCK_MEET failures=
REGRESSION: hit_frame_test, hit_carry_test, block_meet_test
VISUAL: yes - Claude films the fix on the game camera (hit_frame_film seed 4242) before merge; you only run headless.
NOT YOURS: every other file in scripts/ and tests/. Never weaken a test bar.
Runs only through `python ops/Tools/godot_slot.py run --who landreach3 -- <godot> --headless --audio-driver Dummy --path . --script res://tests/<name>.gd`.
PR body: `RESULT: tests/block_meet_test.gd -> BLOCK_MEET failures=<n>` and the same for hit_frame_test and hit_carry_test.

## Prior research
docs/LANDREACH1_RESULT.md; ops/research memory S466 (carry_base bisect to d258cab0).
## What would a human do?
A boxer's jab lands on the nose because the arm finishes where the eyes aim; the hand does not stop short or skim the brow.
## Prefab check
None: our own IK stack.
