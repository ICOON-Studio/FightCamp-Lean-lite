# TASK STEPPAY5 - finish STEPPAY4: cut_off back in band, step_back v Slugger under 5, result, tests, ready to merge (S539)

Model: claude-opus-5-5 (Code Mode tab). Discipline: boxing (demo). Work IN the worktree E:/FightCamp/wt/s538_steppay4 (branch
s538/steppay4, commit 85ec1b544 "work in progress"); never in main.

## Where it stands (S539 Claude read .probe_out/legs.txt, the STEPPAY3 gate re-run, GATEDONE)
ops/research/TASK_STEPPAY4.md is the brief and its bar. The gate: FOR leg in band 9 of 10, all three legs 8 of 10 (STEPPAY3: 5).
- PASS now: step_in, step_out, pivot_out, herd (the wrong leg reads < 0 - StepWrong.gd works), feint, tie_up, roll_out, push_off.
- FAIL 1 - cut_off REGRESSED: best leg out of 1.5..5 (it passed in STEPPAY3): find what StepWrong/RingDuel did to it.
- FAIL 2 - step_back v Slugger still over the top (by situation +6.73, bar <= 5.0): STEPPAY4 Do 3, by the Slugger moment, not
  a global number.
Also not done: docs/STEPPAY4_RESULT.md, the whole-game mix shift (mix_after.txt is there - read it), tests.

## Do
1. Fix FAIL 1 and FAIL 2 by situation rules (no StepEffect.TABLE tuning to force a sign). Re-gate ONLY the steps a change can
   touch (`treevalue_probe.gd when=best only=<steps>`, same population and seeds), then the legs read
   (step_fire_fit_probe.gd legs=...). Pass = TASK_STEPPAY4 step 5's bar: all ten FOR legs in band, the wrong leg < 0 for the five,
   nothing that passed fails.
2. docs/STEPPAY4_RESULT.md in STEPPAY3's shape (before/after table, the mix shift, thin margins said plainly).
3. Tests: tests/step_wrong_test.gd and the step tests STEPPAY3 used (tests/step_*_test.gd), tests/golden_path_test.gd - green.
4. Commit on the branch, push it, report "READY TO MERGE <commit>" or what failed. Claude merges by diff.

## Contract
OWNS: scripts/rules/StepWrong.gd, scripts/state/RingDuel.gd, scripts/state/StepWire.gd, scripts/state/LiveRound.gd (the step
lines only), scripts/rules/PlanFight.gd (one line), tests/step_wrong_test.gd, tools/step_fire_fit_probe.gd,
tools/treevalue_cells.gd, tools/treevalue_probe.gd, docs/STEPPAY4_RESULT.md
RED_TEST: tests/step_wrong_test.gd
REGRESSION: tests/step_*_test.gd, tests/golden_path_test.gd
VISUAL: no

## Rules
Godot ONLY via `python ops/Tools/godot_slot.py run --who steppay5 -- <godot> --headless ... --path E:/FightCamp/wt/s538_steppay4 ...`,
one run at a time, output to files, wait on done lines. No script over 500 lines. When done run
`python ops/Tools/idle_guard.py ok STEPPAY5-done`, report in two lines, stop.
