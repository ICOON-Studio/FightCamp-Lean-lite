# TASK LEANRED1 - why block_catch and hit_frame are red, and why a slower punch lean makes them worse (measure only)

Status: OPEN (S505, Claude main). Discipline: boxing. Model: Qwen (qwen3-coder), default.

## Why now
Fight motion week. A slower chest lean in a punch (`scripts/fight3d/PunchReach.gd` `LEAN_RATE`, settable per run with
`-- leanrate=<rad/s>`, default 4.0) cut the head jumps in a 3-minute film 77 -> 63. But two tests that are ALREADY red on
main get worse with it: `tests/block_catch_test.gd` 4 -> 6 failures, `tests/hit_frame_test.gd` 6 -> 7. Before the
slower lean ships we need to know what each failing check measures, by how much it misses, and which layer of the
boxer's modifier stack moves it. You change NO game code and NO test.

## What to do
1. Run each test at `leanrate=4.0` and at `leanrate=2.5`:
   `godot --headless --audio-driver Dummy --path . --script res://tests/block_catch_test.gd -- leanrate=2.5`
   (same for hit_frame_test). Copy every FAIL line, both rates.
2. For every check that fails at either rate: run it again with ONE control switch at a time added to the args and
   record whether that check passes, fails by less, or fails by more. Switches (each turns one layer off):
   `noarmhome`, `noprecap`, `nopopcap`, `noglove`, `nosnap`, `noleanease`, `noreach`.
3. Read the test's own code for each failing check (its bar, what it compares) and say in one line what it is asking
   the motion to do, in plain words.
4. Write `docs/LEANRED1_RESULT.md`: a table per test - check | FAIL text at 4.0 | at 2.5 | which switch fixes or moves it
   (with the number) | what it asks, in plain words. Then three lines: which checks a slower lean makes worse and why
   (the layer), which were red for another reason, and what you would change (do NOT change it).

## Contract
OWNS: docs/LEANRED1_RESULT.md
RED_TEST: tests/block_catch_test.gd -> BLOCK_CATCH failures=4 at leanrate=4.0 (read-only: it must print the same after your work)
REGRESSION: tests/hit_frame_test.gd
VISUAL: no - a measurement; no game code or test changes.
NOT YOURS: every other file. Never delete or weaken a test. Work on your own branch, commit, push, never merge.
Never `tools/run_tests.sh`. Never run Godot windowed. Nothing may open on the owner's monitors. One test at a time.
PR body: the two tables' summary lines and `RESULT: tests/block_catch_test.gd -> BLOCK_CATCH failures=4` (at 4.0).

## Prior research
`ops/research/S505_DIGEST.md` if present; `scripts/fight3d/BoxerBuild.gd` (the stack order: PopCapPre, ArmHome,
PunchReach, HitSnap, GloveClear, PopCap); `tools/trunk_tap.gd` header. `ops/research/GDSCRIPT_TRAPS.md`.

## What would a human do?
A coach watching a slowed-down replay asks "is the punch landing short because he stopped turning his shoulders?" -
one thing at a time, with the rest unchanged.

## Prefab check
None: running existing tests with switches.

## The one trap
Each switch is a command-line user arg after `--`; the tests read `OS.get_cmdline_user_args()`, so pass every switch in
the same `--` list as `leanrate=`. A test that prints no FAIL lines but exits non-zero is a SCRIPT ERROR: report it.
