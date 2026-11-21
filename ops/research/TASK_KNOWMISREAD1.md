# TASK KNOWMISREAD1 - let the player be wrong about people (DEPTH_SCOPE_S534 change 4)

Model: claude-fable-5-2 console in this checkout. A BUILD (already sized: KNOWBOTS6).

## Why
DEPTH_AUDIT_S534 row 19: whom to sign is ONE ANSWER - a prospect's attribute errors cancel out, so the shown rating is right;
a signer who knows the truth beats a blind one by under 8% (KNOWBOTS4). KNOWBOTS6 found the fix and its size: one SHARED
misread per prospect (half the error shared across the attributes) makes knowing the truth worth 9 to 14%. Read
docs/KNOWBOTS6_RESULT.md (and KNOWBOTS4 and 7) and scripts/rules/Knowledge.gd first.

## Do
1. Red test first: tests/know_misread_test.gd - with the shared misread, a prospect's shown overall rating differs from the
   truth by a shared amount (bounded as KNOWBOTS6 sized it), deterministic by seed; with full knowledge the shown equals the
   truth; scouting, film and a trial narrow it as Knowledge already does.
2. Build the shared misread inside Knowledge (the smallest change KNOWBOTS6 names). No new screen: the existing ranges show it.
3. Re-run KNOWBOTS6's probe on the built rule: knowing the truth worth 9-14% (a bound, not exact).
4. Run the tests that call Knowledge (grep tests for "Knowledge.") and tests/golden_path_test.gd.

## Contract
OWNS: scripts/rules/Knowledge.gd, tests/know_misread_test.gd, docs/KNOWMISREAD1_RESULT.md
RED_TEST: tests/know_misread_test.gd
REGRESSION: the tests that call Knowledge (grep), tests/golden_path_test.gd
VISUAL: no

## Rules
Godot only through `python ops/Tools/godot_slot.py run --who knowmisread1 -- <command>`. Touch only the owned files; other
sessions have uncommitted edits (LineGrade.gd, LiveRound.gd, StepWire.gd) - never stage them. Commit to main, push, then
`python ops/Tools/where_we_are.py done "Wrong about people: misread"`, report in two lines, stop.
