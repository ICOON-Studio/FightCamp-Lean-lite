# TASK NIGHTLY6B (S218) - two fight tests went red on 2026-10-13 (find the cause, fix it, never the tests' numbers)

Model: cloud Qwen (label `qwen`). Branch `qwen/issue-<n>` from master. Never master. Pure headless fight logic (no LFS).

## Why
The 2026-10-13 nightly (master b7685559) has two NEW reds, green on 2026-10-12:
1. `Godot/tests/causation_real_path_test.gd`: `FAIL seed 701 RTD {"a":9,"b":10}: no CAUSE line` - a fight that ends by RTD
   (retired on the stool) prints no cause.
2. `Godot/tests/corner_card_wired_test.gd`: `FAIL seed 159102 must reach the first break` - the fight ends before round 1's break.
Suspects that landed between the nightlies: fecf3757 (NIGHTLY4: RTD on the stool when a delayed collapse comes due - a NEW RTD
path that may skip the cause writer), 4d8d724d (career strand edge reaches the fight), fe9ae0f7 + 583d8d3b (Q226 technique strand
edge 0.24 in contact - more clean lands, possibly an early stoppage on seed 159102).

## Do
1. Run each test, then find the first differing quantity between master and the parent of each suspect commit (bisect with
   `git log --since="2026-10-12 05:00" --until="2026-10-13 05:00" -- Godot/scripts`).
2. Fix the CAUSE: e.g. the new RTD path must go through the same cause/event writer as the old one; if the strand edge makes
   seed 159102 a round-1 stoppage, check whether that edge is applied when the switch for it is OFF (headless tests run switches
   OFF - an OFF edge must change nothing). Never change a test's seed list or expectation, never a switch in the harness.
3. Run both tests + `python Godot/tools/run_tests.py --jobs 1 --only causation,corner_card,rtd,stool,q226,switch_gate,fight_realtime`.

## Prior research
`research/TASK_NIGHTLY4*.md`, `TASK_Q226TECH1.md`, `AgentComms/nightly/suite_2026-10-13.log`.
## What would a human do?
A referee's card always records why a fight ended; a corner always gets the first break unless the fight is stopped before it.
## Prefab check
None - a regression in our own engine.
## The one trap
FightRealtime.gd is 9,500+ lines - never read it whole, use grep + `sed -n` windows. Report in the PR: the cause (file:line), the fix,
and each test's own PASS line.
