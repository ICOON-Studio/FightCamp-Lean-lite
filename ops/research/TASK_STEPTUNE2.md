# TASK STEPTUNE2 - size the footwork steps' levers to their targets, from the CORRECTED probe (tuning)

Status: OPEN (S527, Claude main). Discipline: boxing. Model: qwen3-coder (PC seat; Goose is at its 2-job cap).

## Why
STEPTUNE1 (#394) timed out and sized from a partial TREEVALUE3 whose roll_out cells were a probe defect (tie_up's any-time
arrow came first on the inside card, so roll_out never fired). S527 fixed tools/treevalue_probe.gd (_swept_first, and
`-- only=a,b` sweeps just those steps). Read ops/research/S527_PROBES.md first; the full TREEVALUE3 numbers for the other
eight steps are in E:/FightCamp/tmp/treevalue3.txt (read it there, absolute path), roll_out / push_off in
docs/TREEVALUE4_ROLLOUT_PUSHOFF.txt.

## What to do
Edit ONLY the numbers in scripts/rules/StepEffect.gd TABLE (deny, open, drain, tank, opp_ropes, opp_steps_less,
opp_counter_edge, wrong_extra_damage) - plus push_off may get an "open" value with open_on "any" (Claude's call: a push-off
makes space on your own terms). Targets: scripts/rules/StepValue.gd TARGET (best style +1.5..+5 in 100, wrong style
negative, others 0..+1). Loop: change a row, rerun ONLY that step with
`$GODOT_EXE --headless --audio-driver Dummy --fixed-fps 60 --path . --script res://tools/treevalue_probe.gd -- only=<step>`,
read its CELL lines. On this PC every Godot run goes through the queue:
`python ops/Tools/godot_slot.py run --who qwen -- <the godot command>` (from the repo root of your worktree; the exe is
%LOCALAPPDATA%/Programs/Godot/Godot_v4.7.2-stable_win64.exe, never the _console one). One step's sweep takes ~12-15 min.
Order: the furthest from target first - step_in, cut_off, herd, roll_out, push_off, tie_up (wrong cell +3.0 vs -1.0),
step_out, feint, step_back, pivot_out. Budget: 3 hours of probe time in total; then push what you have with the table of
where each step stands (a partial table with honest numbers is a good result).
Then run tests/step_effect_test.gd, tests/step_levers_test.gd, tests/golden_path_test.gd (update only the numbers a test
pins from TABLE, never delete a check).

## Deliverable
StepEffect.gd TABLE numbers, docs/STEPTUNE2_RESULT.md (per step: old -> new numbers, best/wrong cells before and after),
test number updates if any. One PR.
RESULT: tools/treevalue_probe.gd -> pass=<n>/10

## Contract
OWNS: scripts/rules/StepEffect.gd, docs/STEPTUNE2_RESULT.md, tests/step_effect_test.gd, tests/step_levers_test.gd
RED_TEST: tools/treevalue_probe.gd prints TREEVALUE2 done pass=<n>/10 (today 0/10)
REGRESSION: tests/golden_path_test.gd
VISUAL: no

## Prior research
TREEVALUE1-4, STEPVALUE1 map (DESIGN_STEPVALUE1_V1_KALLI_KALLI.md s3, s4.2, s9), STEPTUNE1 result (not taken).
## What would a human do?
A coach tries one change on the pads, watches the next sparring, keeps what worked - one step at a time.
## Prefab check
None: our own rule table.
