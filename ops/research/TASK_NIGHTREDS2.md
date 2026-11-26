# TASK NIGHTREDS2 - the three red tests of the 05:00 run (S559)

Kind: fix. Model: claude-opus-5-5. Discipline: boxing (demo path).
Seat: console worker. Estimate: 2-3 hours.

## Why
`ops/AgentComms/nightly/latest.txt` (FULL TESTS 2026-11-25, pass 517 fail 6, commit e8a291540; log
`ops/AgentComms/nightly/suite_2026-11-25.log`) - three tests red:
1. `tests/matchmaking_bots_test.gd`: "scouting is worth it: fewer stoppage losses than blind (+0.03)" (twice). Older
   analysis in `ops/research/TASK_NIGHTREDS1.md` (likely cause: 68067e0ba S535 DMGCLASS2 - WorldBout passes
   `rounds >= PRO_FROM` to Knockdowns.round_counts, so pro world bouts lose the amateur four-count limit). It runs ~11
   minutes: run it ALONE.
2. `tests/dues_card_test.gd`: read the log for its FAIL line.
3. `tests/ring_steps_test.gd`: "DB every played take has its feet table (without one: [\"pro_body_cross\"])".
Owner rule: a defect seen is fixed now; the nightly is reviewed and acted on (CLAUDE.md "FULL TESTS ONCE A DAY").

## Do
For each: read the FAIL and the test, find the cause on master (git log / bisect between the last green and the first
red nightly if needed), FIX it at the cause - never by loosening a test's bar or deleting a check (if the bar itself is
wrong, say why with numbers and ask the session before changing it). Run only the touched tests:
`GODOT=... ; python ops/Tools/godot_slot.py run --who NIGHTREDS2 -- <godot.exe> --headless --audio-driver Dummy --path . --script tests/<name>.gd`
(never `_console.exe`; a Godot start only through godot_slot). Parse gate first on any edited .gd. The PC is shared with a
render and a balance run: one test at a time, watchdog first (`powershell -NoProfile -ExecutionPolicy Bypass -File
ops\Tools\pc_watchdog.ps1 -Once`; RED = wait). Do NOT touch tools/pics2d_*.gd (a re-render is running on them) nor
proto/twohands/*.html.

## Output
`ops/research/NIGHTREDS2_RESULT.md`: per test - the cause (file:line, commit), the fix, the test's pass line before/after.
Commit ONLY your files by pathspec (`git commit -- <files>`; `git diff --cached --stat` first: never a folder sweep -
S559 a worker's commit swept in 8,200 unrelated files). Push.

## Contract
- OWNS: the files the three causes live in (name them in the result), ops/research/NIGHTREDS2_RESULT.md
- RED_TEST: the three tests, red on master today
- REGRESSION: the three tests green; any other test that imports a file you changed, run once
- VISUAL: none

## Prior research
ops/research/TASK_NIGHTREDS1.md; `python ops/Tools/prior_research.py matchmaking bots scouting stoppage`.

## What would a human do?
Read each failure, bisect to the commit that turned it, fix the cause, run the three tests.

## Prefab check
Not applicable (our tests).

## Feedback loops
None: test fixes.
