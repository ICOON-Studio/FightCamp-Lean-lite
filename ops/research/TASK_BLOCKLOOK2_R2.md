# TASK BLOCKLOOK2 round 2 (Grok Dev) - finish on the same branch grok/blocklook2, same PR 245

Model: Grok Dev. Discipline: boxing (demo).

Round 1 review (Claude S448): good work - BLOCK_CATCH 19 -> 2 failures, the cause found and traced. Accepted decisions:

1. OWNS widened: apply your proposed fix in `scripts/fight3d/FightStage.gd` `arm_block` (~lines 196-212): when the blocker's
   BlockCatch has weight > 0, the punch is carried onto the CATCHING glove, not the nearer one. Only that change in that file.
2. `tests/block_set_test.gd` is now yours. Its intent stays (the block is SET before the glove arrives - no late block), but
   the brief removed every block clip, so the SET check must read the catch, not a clip name: SET = the blocker's BlockCatch
   arm weight is at full (gloves up) at least one frame before the punch's contact frame. Keep every punch row it has now;
   do not drop rows. It must go red on main for the right reason (no BlockCatch there) - paste that red line too.
3. BLOCK_MEET: the 4 GY rows (A_B jab fight/preview, A_B rear hook, A_A cross) must pass after fix 1. The 10 CTRL_LANDED
   rows fail the same on main (12) - leave them, list them as main's.
4. BLOCK_CATCH must read failures=0 on TWO runs in a row (the jab row was bimodal - say if it still is).

Never loosen a bar; never edit a test you were not given. Files stay under 500 lines.

## Contract
OWNS: scripts/fight3d/BlockCatch.gd, scripts/fight3d/BeatFire.gd, scripts/fight3d/BeatClips.gd, scripts/fight3d/MoveStudio.gd,
  scripts/fight3d/FightStage.gd (arm_block only), tests/block_catch_test.gd, tests/block_meet_test.gd, tests/block_set_test.gd,
  docs/BLOCKLOOK2_RESULT.md
RED_TEST: tests/block_set_test.gd (reads the catch, red on main)
REGRESSION: tests/block_catch_test.gd, tests/block_meet_test.gd, tests/hit_carry_test.gd
VISUAL: Claude films blocks in the played fight after merge (you cannot see images)

RESULT lines in the PR body, copied exactly:
RESULT: tests/block_catch_test.gd -> BLOCK_CATCH failures=0   (two runs)
RESULT: tests/block_set_test.gd -> BLOCK_SET failures=0
RESULT: tests/block_meet_test.gd -> BLOCK_MEET failures=<n> (all CTRL_LANDED, main has 12)
