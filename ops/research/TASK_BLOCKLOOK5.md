# TASK BLOCKLOOK5 - GROK DEV - the block, round 5: straights armed on the landed path, hooks as today, meet and absorb held

Status: OPEN (S452, Claude main). Discipline: boxing (demo). Model: Grok Dev.
His marks still open (review board S449, ops/Feedback/2026-11-13-15): "the arm looks shorter", "90 degrees angle ? wtf is that move ?",
"colission!!".

## What round 4 measured (READ ops/research/BLOCKLOOK4_RESULT.md whole first - your own write-up, not merged)
- Placement alone is inert: armed as today, 90 % of the landed reach from the puncher's shoulder puts the hand at or behind her face.
- Your one-line hook in FightStage.arm_block (`pr.arm(..., float(boxers[who]["front"]), 0.001)`, the landed path) PASSES MATCH for both
  jabs (97.5 % / 96.1 %), gets the A_B cross to 87.3 %, but over-reaches both hooks (115-118 %, + MEETS touch) and regresses
  block_meet 10 -> 12 (A_B lead hook BETWEEN/TOUCH, B_A jab TOUCH -0.036) and block_absorb 0 -> 4 (both rear hooks glove back 0.10, B_A
  cross 0.017, SCALE B_A).

## Decided (Claude, S452): the landed path for STRAIGHTS only
1. arm_block arms a blocked JAB or CROSS on the landed path (the 0.001 carry), and a blocked HOOK exactly as today. Hooks and uppercuts
   get real targets from the mocap packs at the end of November (HOOKTAKES1); do not chase their MATCH rows now - report them only.
2. Keep your BlockCatchPoint placement for straights (the catch on the punch's line at 90 % landed reach, slid into the catch box).
3. Fix the two straight regressions the hook caused: the B_A jab TOUCH -0.036 in block_meet and the B_A cross absorb 0.017 /
   SCALE B_A in block_absorb, inside BlockCatch / BlockCatchPoint (the catching glove's place or the absorb's start point), never by
   loosening a bar.

## Contract
OWNS: scripts/fight3d/BlockCatch.gd, scripts/fight3d/BlockCatchPoint.gd (from your branch grok/blocklook4 - start from it),
scripts/fight3d/FightStage.gd (arm_block only) (the one call, a straight/hook test around it, at most 8 lines), tests/block_catch_test.gd,
docs/BLOCKLOOK5_RESULT.md
RED_TEST: tests/block_catch_test.gd -> MATCH rows for the 4 straights (A_B/B_A jab, A_B/B_A cross) PASS; hook rows printed, not gated
REGRESSION (none may rise above main): block_meet_test (main 10), block_absorb_test (main 0), block_set_test (0), beat_clips_test,
hit_carry_test (main 40), fight_feel_test, file_limits_test
VISUAL: yes - Claude renders the block reel on the PC after the merge; the operator closes it
NOT YOURS: every other file; never scripts/rules or scripts/state. PunchReach.gd is at 498 lines: do not add to it.

## Traps
- If the B_A cross cannot reach 90 % without a meet/absorb rise, say so with numbers and gate the cross rows at your best honest value;
  do not loosen block_meet, block_absorb or CATCH.
- Every file under 500 lines. Do not delete or weaken any test. Read ops/research/GDSCRIPT_TRAPS.md.

## Prior research
- ops/research/BLOCKLOOK4_RESULT.md, docs/BLOCKLOOK3_RESULT.md, ops/research/TASK_BLOCKLOOK4.md.

## What would a human do?
A coach: a straight is caught out in front on the glove with the punch fully extended; a hook is caught on the forearm by the ear -
two different blocks, so treat them differently.

## Prefab check
Our own captured clips and the existing landed path (PunchReach); nothing new.

Test command: `<godot> --headless --audio-driver Dummy --path . --script res://tests/block_catch_test.gd` (and each REGRESSION test).
Push branch grok/blocklook5, open a PR. RESULT lines in the PR body: one per test above, `RESULT: tests/<x>.gd -> <its failures= line>`,
main vs branch.
