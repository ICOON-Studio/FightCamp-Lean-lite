# NIGHTLY_TRIAGE S466

Generated: 2026-11-14 11:44
Source: E:\FightCamp\Lean\ops\AgentComms\nightly\latest.txt

| test | main today | first FAIL line | last green nightly | its commit |
|------|-----------|-----------------|-------------------|-----------|
| plan_test_it_test | PASS | - | 2026-11-13 | - |
| no_pronoun_test | RED | FAIL no she/her in a script's text: 2 found | 2026-11-13 | - |
| move_tip_test | RED | FAIL the partner slips or blocks the jab (["pro_hit_by_cross_v2_short", "pro_idle", "pro_idle_fidget_v6", "ow_bounce_idle", "pro_hit_by_cros | 2026-11-13 | - |
| bout_read_test | PASS | - | 2026-11-13 | - |
| plan_bots_test | RED | FAIL your plan beats the coach's clearly | 2026-11-13 | - |
| guard_knee_test | RED | FAIL boxer 0 rear knee stays on the source (-0.0652 v 0.0291) | 2026-11-11 | - |
| words_on_screens_test | PASS | - | 2026-11-13 | - |
| block_meet_test | RED | exit 1 | 2026-11-13 | - |

NIGHTLY_TRIAGE red=5 fixed=3 hang=0

## S467 Claude: fixed or known cause for each red
| test | now | what |
|---|---|---|
| no_pronoun_test | GREEN | two screen lines (ProReadWire read-proof, FighterPage study slot) no longer say she/her |
| result_defects_test (not in the nightly list, red on main) | GREEN | seed 44 no longer fights a wrong answer since the S466 card fix; check 2 takes the first of seeds 44-63 that does (seed 45) |
| block_meet_test | RED, on Qwen (TASK_LANDREACH3) | the latched hit point is on the face (<= 0.01 m); the drawn lead glove sits 4-11 cm above/below it on the contact frame |
| guard_knee_test | RED, queued for Qwen (TASK_GUARDKNEE2) | rear knee -0.065 v source +0.029 since the 11-12 POWER1 merges: bisect then fix |
| plan_bots_test | RED, known cause | GOOD = 1-1, step_back, pivot_out, tie_up; since S463/S464 a step fires by its bar and Lucy's step bars are low, so the "well-read" plan is no longer well read for her: plan+sim 0.485 v coach 0.447 (bar +0.05). A balance call for TRAINGAME2/STEPMASTERY1 (steps must be trainable first), not a test change |
| move_tip_test | RED, known cause | the move card's partner plays hit/idle clips, never a dodge/block, for the jab (S466 open item); goes with the block pose work (BLOCKPOSE) |

## S471 check (2026-11-14, the 05:00 run was on 7b7ac6e6 = S463, before the fixed 60 fps switch)
8 red (7 new against 11-13). Rerun on main at `--fixed-fps 60` (3d401685):
| test | on main | note |
|---|---|---|
| no_pronoun, plan_test_it, move_tip, guard_knee, words_on_screens, bout_read | GREEN | fixed by S464-S470 work |
| plan_bots_test | RED, known cause (row above) | plan+sim 0.485, coach 0.447, none 0.356: step answers fire by low step bars; closes with PLANFLOW1 v2 / steps past Usable |
| block_meet_test | RED only at fixed 60 fps (0 free-running, 11 fixed) | tests/ruler_stand.gd waited 45 FRAMES; at fixed 60 that is 0.75 s and the boxers have not stepped out yet (0.78 m, then 0.884 m from ~2.6 s). Fix written S471: wait in game seconds (3.0 s min, 8.0 s max, 20 still frames). NOT YET RUN: the PC was RED (memory) |
