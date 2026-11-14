# TASK NIGHTLYTRIAGE1 - which of last night's red tests are still red on main, since when, and the first failing line

Status: OPEN (S466, Claude main). Discipline: boxing. Model: qwen3-coder (Qwen), default.

## Why now
The 05:00 full run of 2026-11-14 (ops/AgentComms/nightly/latest.txt, log suite_2026-11-14.log, commit 7b7ac6e6) has failing
tests. Main has moved since (S464-S466 fixes). Claude needs, per red test: still red on main today or not, the first FAIL line,
and the last nightly where it passed, so each gets a fix or a known-cause note. You measure; Claude fixes.

## What to build: tools/nightly_triage.py (python, stdlib only)
1. Read every `FAIL <name> (exit N)` line in ops/AgentComms/nightly/latest.txt -> the red test names.
2. For each: run it ONCE on this worktree (main) through
   `python ops/Tools/godot_slot.py run --who nightlytriage1 -- <godot> --headless --audio-driver Dummy --path . --script res://tests/<name>.gd`
   (godot = %LOCALAPPDATA%\Programs\Godot\Godot_v4.7.2-stable_win64.exe; one at a time; timeout 600 s each).
   Verdict: PASS only if exit 0, no "SCRIPT ERROR", and its own `<X> failures=0` (or no FAIL line) - else RED; rc 124/timeout = HANG.
3. First failing line: the first line starting with "FAIL" in the run output (or the first SCRIPT ERROR line).
4. Last green: scan ops/AgentComms/nightly/suite_*.log oldest to newest; the newest log where the test appears and did NOT fail
   (no `FAIL <name>` line); print its date, and the commit named on that log's first line if present.
5. Write docs/NIGHTLY_TRIAGE_S466.md from the run (never by hand): one row per test
   | test | main today | first FAIL line (<=140 chars) | last green nightly | its commit |
   and a final line `NIGHTLY_TRIAGE red=<n> fixed=<n> hang=<n>`.
CONTROL: also run golden_path_test (green on main in S466) through the same path; it must read PASS, else your verdict code is
wrong - say so and stop.

## Contract
OWNS: tools/nightly_triage.py, docs/NIGHTLY_TRIAGE_S466.md
RED_TEST: tools/nightly_triage.py -> NIGHTLY_TRIAGE red=
REGRESSION: golden_path_test (the control above)
VISUAL: no
NOT YOURS: every file in scripts/ and tests/ (read-only). Never fix a test; report.
Watchdog before you start (`powershell -NoProfile -ExecutionPolicy Bypass -File ops\Tools\pc_watchdog.ps1 -Once`); RED = wait.
Under 500 lines. PR body: `RESULT: tools/nightly_triage.py -> NIGHTLY_TRIAGE red=... fixed=... hang=...`.

## Prior research
ops/AgentComms/nightly/latest.txt and suite_*.log; roadmap NIGHTLY1 notes.
## What would a human do?
Re-run each red test on today's code before chasing it; a test red since last Tuesday has a commit to blame.
## Prefab check
None: a small script over our own logs.
## The one trap
Never `_console.exe`; never more than one Godot at a time from this script (godot_slot queues it).
