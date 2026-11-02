---
name: feedback_script_the_per_commit_loop
description: "S2 2026-09-13 - script the one-concern-per-commit loop (apply, measure, subsets, byte-compare failure lines) and let background notifications wake the session instead of polling a huge context"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 0f65a0d6-58b6-49a7-b942-a85c31d49103
  modified: 2026-09-13T06:33:54.758Z
---

For a stage the operator requires to land ONE DISCIPLINE (or one concern) PER COMMIT,
script the loop instead of driving each step by hand. S2 used a scratchpad
`s2_step.py <discipline> <subset>`: apply the data, run the measurement tool through a
hard-timeout wrapper, run the named test subsets with `run_tests.py --only ... --jobs 4`,
copy the per-test logs, and compare each known red's FAIL lines against the previous
step. Commit only after reading that report.

Where no engine path can reach the data (disciplines no ruleset draws on), a guarded
chain committed four disciplines unattended: it committed ONLY if every failing test was
a known red AND its failure lines were byte-identical (md5) to the previous step's;
anything else stopped the chain. Twelve discipline commits took an afternoon instead of a
day.

**Why:** S2's context passed ~700k tokens, and every poll of a background run re-reads
the whole context. Ending the turn and letting the task-completion notification wake the
session costs nothing while the run goes; a status poll every few minutes costs a full
cached read each time.

**How to apply:**
- Drop `fight_metres_test` from per-commit subsets (it asserts sanity only and times out
  under `--jobs 4`; alone it now takes ~580 s of run_tests.py's 600 s) and run it alone
  once at the end.
- Compare failure LINES, not pass/fail counts: S2's judge_panel pin list changed by one
  bout inside a test that stayed red, and only the line diff showed it.
- Run the measurement tool on the unchanged tree first - see
  [[feedback_run_the_instrument_on_the_old_tree_first]].
- Launch the step in the background, end the turn with a one-line status, act on the
  notification. Related: [[feedback_tier_the_test_gate]], [[feedback_new_session_per_shipped_stage]].
