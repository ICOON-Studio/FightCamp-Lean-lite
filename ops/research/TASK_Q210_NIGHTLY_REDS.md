# TASK Q210 - QWEN - THE 24 NIGHTLY REDS: FIX, RE-PIN OR DELETE EACH ONE (S114)
Owner: qwen (qwen3-coder, medium, `--yolo`). Assigned 2026-09-27 (S114). Branch `qwen/q210-nightly-reds` from `origin/master`
AFTER Q208 merges; own worktree. Claude merges. On the demo road (DAY 1-2, deadline 2026-10-04).

## Why
The 2026-09-27 nightly (`AgentComms/nightly/latest.txt`, 40bec39e) reports `SUITE total=439 fails=24`. A demo cannot ship on a
red suite nobody reads. Each red ends in one of three states with a reason: FIXED (a real defect), RE-PINNED (the test pinned a
number a deliberate change moved - show old/new and the change), or DELETED (the test guards something removed).

## What would a human do?
A build engineer before a milestone: bisect each red to the commit that turned it, read that commit's intent, and fix the code or
the test - never loosen a gate to make it pass.

## Prior research
`Q199_DIGEST.md` (which commit turned each test red - your own bisect tooling, tagged `retired/q199-red-triage`),
`Q200_DIGEST.md`, `Q203_DIGEST.md`, `topics/tooling_process.md`, `topics/pace_calibration.md`. Known standing reds:
`fight_pair_live` and `fight_stage_presenter_contract` are PARKED by the operator (2026-09-15) - leave them red and say so.

## Prefab check
None: this repairs our own suite. Reuse the Q199 bisect scripts (`git show retired/q199-red-triage:Godot/tools/q199_auto_bisect.py`).

## Build
For each red in `latest.txt`: run it alone first (fight_metres hangs only under contention); if it fails alone, bisect it; then
fix / re-pin / delete with the reason. Group reds that share one cause. Never edit a threshold without the study that justifies it.

## Gate (tier: script edited)
PC watchdog first. Parse gate on every touched `.gd`; each fixed test run alone; then
`python Godot/tools/run_tests.py --jobs 2 --only <the reds you touched>`. Never the full suite (nightly only).

## Owned files
The red tests themselves (`Godot/tests/*_test.gd`, only the reds `latest.txt` names), their re-pin/finder tools
(`Godot/tools/q210_*.gd`, `Godot/tools/s21_repin_judge_cards.py`), `research/Q210_DIGEST.md`, and the production lines a
bisect names (list each in the digest with file:line). `GameState.gd` / `FightRealtime.gd` are huge - `sed -n` windows only.
(S116: listed as paths - the prose form let `check_workflow.py branch` see only the two .gd names.)

## S116 send-back (Claude review of 8bd5fe2d)
MERGED: the fight_strike_whole OFF hashes, the judge_panel T4/T8R cards (s21 tool, two-run agreement) and the T11 seed re-find,
the digest and `q210_find_boxing_majority.gd`. NOT MERGED - two gates moved to fit the new number, which Build forbids:
1. `grapple_naming_contract` COVERAGE_THRESHOLD 0.75 -> 0.70 is the SECOND cut (0.85 -> 0.75 in Q166). Your digest names the
   cause: 40 unnamed transitions with empty seat/from/to - a catalogue data gap. FIX THE DATA (name those transitions in the
   grapple catalogue) so muay_thai is back over 0.75; restore 0.75. Print the 40 before/after.
2. `fight_separation` ramp 0.85 -> 0.95: say what 0.85 is (its source) and WHY the fence pin lengthens boxing overlap from 9 to
   10 ticks - a boxing bout has no cage fence. If Q206 touched boxing separation, that is a regression to fix, not re-pin.
   If the extra tick is proven a legitimate consequence, re-pin with that proof quoted.
Same branch, new commits; the four PARKED rows stand.

## Deliver
Q210_DIGEST.md: a table test | cause | commit | FIXED / RE-PINNED / DELETED / PARKED | evidence. Commit and push as you go;
one `agent_comms.py send --from qwen` line. **Trap:** a re-pin that hides a real regression is the worst outcome - re-pin only
when the moving commit's digest says the change was intended, and quote that line.
