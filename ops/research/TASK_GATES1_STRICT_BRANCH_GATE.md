# TASK GATES1 - a stricter automatic gate on every agent branch, so Claude checks results instead of reading diffs

Model: Codex gpt-6-luna, medium. Worktree E:/FightCamp/wt/GATES1, branch codex/gates1 (from master). Commit + push the branch; never master.
Operator 2026-10-09 (S187): "Make merging cheaper for me: stricter automatic gates on each agent branch, so I check results rather
than reading whole diffs" - "do all these". Today `python Tools/check_workflow.py branch <branch> <task>` (152 lines) only checks
that the branch stays inside the task's Owned files. `Tools/ci_arena.py guard` (97 lines) already fails deleted/gutted tests.

## What to add to `check_workflow.py branch` (same command, same exit code rule: 0 = mergeable)
1. **Parse gate** on every changed .gd: run `python Godot/tools/check_scripts.py <files>` - a fail is a defect.
2. **Tests that guard the changed code, run automatically.** For each changed script `X.gd`, the tests that reference it
   (`rg -l "X.gd|class_name of X|preload(.*X.gd)" Godot/tests`) plus every changed/new test; run them in the branch's worktree with
   `python Godot/tools/run_tests.py --jobs 2 --only <name>` one per test (one --only per run). Any FAIL = defect. Cap 25 tests;
   above that print "TOO BROAD - Claude picks" and do not fail. `--no-tests` skips this step.
3. **Test-weakening alarm** (the S187 case: a band that went green by moving its floor):
   - a deleted test file, or a test that lost >30% of its lines -> defect (reuse ci_arena.py guard logic, do not duplicate it);
   - in a changed test, any changed numeric literal on a line with `_check(`, a `const` or a `FLOOR|BAND|MIN|MAX|THRESHOLD` name ->
     print it as `LOOSENED?` with the old and new value (a warning, not a defect) so Claude reads just those lines.
4. **One-screen summary** at the end: files changed (owned / outside), parse result, tests run with SUITE lines, LOOSENED? lines,
   verdict MERGEABLE / NOT MERGEABLE.

## Owned files
- Tools/check_workflow.py
- Tools/ci_arena.py (only to expose the guard as a function; its CLI keeps working)
- Tools/tests/test_check_workflow.py (new - plain python unittest, no Godot)

## Tests
`python -m unittest Tools/tests/test_check_workflow.py` with fixtures built in a temp git repo: (a) a branch that deletes a test ->
NOT MERGEABLE; (b) a branch that changes `const FLOOR := 0.30` to `0.20` -> LOOSENED? printed with 0.30 -> 0.20; (c) a clean branch
inside owned files -> MERGEABLE with tests skipped via --no-tests. Then run the real command once on an existing branch:
`python Tools/check_workflow.py branch codex/nightly1e NIGHTLY1E` and paste the summary.

## Prior research / What would a human do / Prefab check
CI "required checks" + a danger.js-style summary of risky changes. No new dependency - standard library + git + rg only.

## The one trap
The main checkout is SHARED: never checkout/stash/reset in it; run everything in the branch's worktree (`git worktree list`).

## Done =
Pushed branch, unittest green, the real-branch summary pasted in your last message.
