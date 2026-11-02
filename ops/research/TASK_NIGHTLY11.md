# TASK NIGHTLY11 - 4 of the 12 nightly reds left after NIGHTLY10 (cloud runner vs PC), classify and fix each (boxing demo tests)

Model: Cursor (cloud). Discipline: BOXING (demo) - tests only; no game behaviour change.

## Why
The 2026-10-19 cloud nightly (`AgentComms/nightly/latest.txt`, 61ca511a) has 17 fails. NIGHTLY10 (issue #278) proved five of them
were the move of the nightly from the operator's PC to GitHub runners (S259), not a code change: the OFF-arm digests differ by
platform. Claude collected that as 69442854 by ACCEPTING BOTH witnesses (PC pin + cloud pin) - see
`Godot/tests/composure_live_test.gd` `CLOUD_LOG_HASH` and `fight_strike_whole_test.gd` `cloud`/`cloud_r16`. Your NIGHTLY10 branch
REPLACED the PC pins, which turns every PC run red - never do that.

## YOUR 4 (S269 split: the 12-test run was killed at ~26 min with nothing pushed)
hang (timeout): fight_grapple_seam_test, fight_room_positions_test, fight_strike_speed_test, first_corner_test
(The other 8 are other issues - do not touch them.)

PUSH EARLY: commit + push after EACH test you classify/fix, so a timeout never loses work.

## What to do, per test
1. Run it on master on the cloud: `python Tools/cloud_test.py <test> --shards 1` (the workflow `.github/workflows/cloud-tests.yml`).
   Read the log's own FAIL lines, not the rc.
2. Classify it in a table in the PR body: PLATFORM (a pinned digest/number that differs only on the runner - prove it with the same
   test at the 10-17 SHA 5b92bef2, which was green on the PC), HANG (timeout: say where it stalls - add a print, never raise a timeout
   to hide it; a test that needs > 600 s on a runner gets a proposed shard split in the PR body), LFS (a missing model on the
   runner), or REAL (a code regression - name the commit with `git bisect` between 5b92bef2 and 61ca511a).
3. Fix: PLATFORM -> add the cloud witness BESIDE the PC pin (same pattern as 69442854), comment `## NIGHTLY11`. HANG/LFS -> fix the
   test harness or the workflow. REAL -> do NOT fix game code; report the commit and the failing line, Claude routes it.

## Files you own
Your 4 test files above. Nothing under Godot/scripts. A shard split in `.github/workflows/nightly-suite.yml` is proposed in the PR body (Claude applies it - gate files never merge by machine).

## Acceptance
`python Tools/cloud_test.py <every PLATFORM/HANG/LFS test you touched> --shards 3` -> CLOUD_TEST_SUMMARY fails=0, link in the PR body;
the REAL ones listed with their commit. PR body lines: `RESULT: tests/<x>_test.gd -> <exact pass line>`.

## Prior research
NIGHTLY10 (issue #278, your branch cursor/issue-278, Claude's collect 69442854); NIGHTLY6 (S225 PC re-pins); CLAUDE.md s6 (exit code
alone is not a pass); memory reference_actions_budget (cloud tests, LFS on runners).

## What would a human do?
Run each red once where it fails, read the actual failing line, and only then decide if it is the machine or the code.

## Prefab check
n/a (test harness work).

## The one trap
Never replace a PC pin with the cloud value, never delete or weaken a check to go green.

## Contract
OWNS: Godot/tests/fight_grapple_seam_test.gd, Godot/tests/fight_room_positions_test.gd, Godot/tests/fight_strike_speed_test.gd, Godot/tests/first_corner_test.gd
RED_TEST: Godot/tests/fight_grapple_seam_test.gd -> PASS: fight_grapple_seam_test
REGRESSION: fight_grapple_seam_test
VISUAL: no
