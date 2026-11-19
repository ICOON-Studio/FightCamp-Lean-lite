# TASK STEPTUNE3 - size the footwork steps' levers on the phase-1 code, from TREEVALUE5 (tuning)

Status: OPEN (S530, Claude main). Discipline: boxing. Model: qwen3-coder (PC seat), after HOLD1.

## Why
ops/research/STEPS_SCOPE_S528.md phase 4. STEPTUNE2 found TABLE could not reach the gate because the opening never
reached the punch after a step and a wrong-fit step cost nothing; phase 1 (S528) wired both (StepWire.open_edge,
WRONG_COST). TREEVALUE5 (docs/TREEVALUE5_RESULT.md, S530) measured the ten steps on that code: 0/10 inside the gate. Its
board (step x style, with targets) is your starting point - read it first. Rule from the scope: if a step still has an
EMPTY WINDOW after sizing (no number moves its best cell into +1.5..+5 without breaking another leg), stop on that step and
write it down as needing a design change - do not force numbers.

## What to do
Edit ONLY the numbers in scripts/rules/StepEffect.gd TABLE (deny, open, drain, tank, opp_ropes, opp_steps_less,
opp_counter_edge, wrong_extra_damage) - plus push_off may get an "open" value with open_on "any" (Claude's call: a push-off
makes space on your own terms). Targets: scripts/rules/StepValue.gd TARGET (best style +1.5..+5 in 100, wrong style
negative, others 0..+1). Loop: change a row, rerun ONLY that step with
`$GODOT_EXE --headless --audio-driver Dummy --fixed-fps 60 --path . --script res://tools/treevalue_probe.gd -- only=<step>`,
read its CELL lines. On this PC every Godot run goes through the queue:
`python ops/Tools/godot_slot.py run --who qwen -- <the godot command>` (from the repo root of your worktree; the exe is
%LOCALAPPDATA%/Programs/Godot/Godot_v4.7.2-stable_win64.exe, never the _console one). One step's sweep takes ~12-15 min.
Order (TREEVALUE5's distance from the gate): cut_off, herd, push_off, roll_out, step_in, tie_up, step_out, pivot_out, feint, step_back. Budget: 3 hours of probe time in total; then push what you have with the table of
where each step stands (a partial table with honest numbers is a good result).
Then run tests/step_effect_test.gd, tests/step_levers_test.gd, tests/golden_path_test.gd (update only the numbers a test
pins from TABLE, never delete a check).

## Deliverable
StepEffect.gd TABLE numbers, docs/STEPTUNE3_RESULT.md (per step: old -> new numbers, best/wrong cells before and after),
test number updates if any. One PR.
RESULT: tools/treevalue_probe.gd -> pass=<n>/10

## Contract
OWNS: scripts/rules/StepEffect.gd, docs/STEPTUNE3_RESULT.md, tests/step_effect_test.gd, tests/step_levers_test.gd
RED_TEST: tools/treevalue_probe.gd prints TREEVALUE2 done pass=<n>/10 (TREEVALUE5: 0/10)
REGRESSION: tests/golden_path_test.gd
VISUAL: no

## Prior research
TREEVALUE5_RESULT.md, STEPS_SCOPE_S528.md, STEPTUNE2_RESULT.md, TREEVALUE1-4, STEPVALUE1 map (DESIGN_STEPVALUE1_V1_KALLI_KALLI.md s3, s4.2, s9), STEPTUNE1 result (not taken).
## What would a human do?
A coach tries one change on the pads, watches the next sparring, keeps what worked - one step at a time.
## Prefab check
None: our own rule table.
