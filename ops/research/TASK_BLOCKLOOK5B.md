# TASK BLOCKLOOK5B - GROK DEV - BLOCKLOOK5 round 2: one block row regressed (the jab preview catches with the wrong glove)

Status: OPEN (S453, Claude main). Discipline: boxing (demo). Model: Grok Dev.
Repo ICOON-Studio/FightCamp-Lean. Keep working on YOUR branch `grok/blocklook5` (PR 256 stays open). Plain headless Godot 4.7.2
(`godot --headless --audio-driver Dummy --path . --script res://tests/<t>.gd`). No stills - Claude renders them on the PC.

## Prior research
ops/research/TASK_BLOCKLOOK5.md (the round you just did), docs/BLOCKLOOK5_RESULT.md on your branch, ops/research/BLOCKLOOK4_RESULT.md.

## What would a human do?
A boxer catches a jab with the REAR glove (the one on the jab's side of her face) and keeps it at eye/cheek height - never drops the
lead glove under it.

## Prefab check
None - this is our own block layer.

## What Claude found collecting PR 256 (S453, measured on the PC, three runs each)
Everything you reported holds: block_catch 9 -> 5 failures (the 4 hook MATCH rows fail IDENTICALLY on main - 72.1/63.4/74.4/66.0 % -
so printing them as informational until HOOKTAKES1 is accepted), block_absorb 0, beat_clips 0.
ONE REAL REGRESSION in tests/block_meet_test.gd (both branch runs, identical):
```
main:   ROW A_B preview pro_left_jab touch=-0.002 between=yes to_face=0.150 gy=-0.048 ... (glove r, frame 9, catch weight 1.00)   PASS
branch: ROW A_B preview pro_left_jab touch=0.012 between=yes to_face=0.154 gy=-0.094 ... GY_FAIL(-0.094) (glove l, frame 10, catch weight 1.)
```
On the branch the PREVIEW jab A_B is caught by the LEAD glove (l), 9.4 cm under her face line (bar GLOVE_Y_LO). Main catches it with the
rear glove (r) at -0.048. Both runs: BLOCK_MEET failures=11; on main the 11 are all CTRL_LANDED ruler rows, on the branch 10 CTRL_LANDED +
this block row. So the count looked "<= 10-ish" but a block row went red. The change that likely did it: BlockCatch's MET_HOLD_S hold /
BlockCatchPoint's catch point picking the glove for the preview path (the preview path arms before the punch's landed line exists).

## The job
1. Make `ROW A_B preview pro_left_jab` pass again (rear glove, gy inside [GLOVE_Y_LO, GLOVE_Y_HI]) with everything else you won kept.
2. Do not touch tests/block_meet_test.gd's bars.

## Contract
OWNS: scripts/fight3d/BlockCatch.gd, scripts/fight3d/BlockCatchPoint.gd, scripts/fight3d/FightStage.gd (arm_block only)
RED_TEST: tests/block_meet_test.gd (the ROW A_B preview pro_left_jab line, GY_FAIL on your branch)
REGRESSION: tests/block_catch_test.gd, tests/block_absorb_test.gd, tests/block_set_test.gd, tests/beat_clips_test.gd, tests/fight_feel_test.gd, tests/file_limits_test.gd
VISUAL: no (Claude films the block reel after merge)

## Done when (RESULT lines in the PR body, main vs branch)
- block_meet: every ROW line passes; the only failures are CTRL_LANDED rows (main has 11 of them, run-to-run 10-11).
- block_catch <= 5 with only the hook MATCH (informational) / MEETS B_A pro_left_hook rows red; block_absorb 0; block_set 0; beat_clips 0.
- Push to grok/blocklook5; comment on PR 256 "BLOCKLOOK5B ready".

## The one trap
Run block_meet on MAIN and on your branch in the same session and compare the ROW lines, not the failure count: the CTRL_LANDED rows move
run to run, so a count can hide a block row going red (that is exactly what happened in round 1).
