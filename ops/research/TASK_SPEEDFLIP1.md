# TASK SPEEDFLIP1 - why punch_speed_test's rows flip between runs, and what the new carry rule adds (headless, no fix)

Status: OPEN (S470, Claude main). Discipline: boxing. Model: qwen3-coder (Qwen), default.

## Why now
tests/punch_speed_test.gd is the ruler for punch power (SPEED, FIRST, POP, SYNC rows per punch). On 2026-11-14 it read
41 failures with the old rules (`-- noweightbase shortwind=0.08`) and 48 with the new ones (no arguments), and rows
flipped between two runs of the SAME arm. A ruler that changes its mind cannot gate a change. Nobody knows yet whether
the 7 extra rows are real (the new `ReachLimit.carry_base` by reach weight adds POP rows) or noise.

## What to do (measure and report; change NO game script and NO test bar)
1. Run the test FOUR times: twice with no arguments, twice with `-- noweightbase shortwind=0.08`. Save each output.
2. For each arm, list the rows that differ between its two runs (row id, which check, both values). That is the noise.
3. For the rows that are stable in both arms, list the rows that fail in the new arm and pass in the old one, and the
   reverse. That is the real difference. Say for each which check it is (SPEED / FIRST / POP / SYNC).
4. Find the source of the noise: read the test for anything unseeded (a `randf`, a `randomize`, a guard life or
   footwork seed, frame timing, `Time.get_ticks`). Name the line. If one seed call makes two runs of the same arm print
   the same rows, say exactly which call and where (do not commit it to the test: write it in the result doc).
5. Write docs/SPEEDFLIP1_RESULT.md: the four totals, the noise rows, the real-difference rows, the noise source with its
   file and line, and the one-line change that would make the test repeatable.

## Pass lines
- docs/SPEEDFLIP1_RESULT.md exists with the four totals and the two row lists.
- tools/speedflip1.gd (a SceneTree script: reads the four saved outputs from docs/speedflip1/) prints `SPEEDFLIP1 noise_rows=<n> real_new_only=<n> real_old_only=<n>` from the four saved outputs.

## Contract
OWNS: tools/speedflip1.gd, docs/SPEEDFLIP1_RESULT.md, docs/speedflip1/
RED_TEST: tools/speedflip1.gd -> SPEEDFLIP1 noise_rows=
REGRESSION: short_punch_test
VISUAL: no
NOT YOURS: tests/ (never change a bar or add a seed there), scripts/ (every file). If the cause is in one of those, report
the file and line in the result doc instead of editing it.
Runs only through `python ops/Tools/godot_slot.py run --who speedflip1 -- <godot> --headless --audio-driver Dummy --path . --script res://tests/punch_speed_test.gd [-- noweightbase shortwind=0.08]`
(never the _console exe, never a window). One run at a time. Tests are the OFF control arm; do not add opt-in flags.
PR body: `RESULT: tools/speedflip1.gd -> SPEEDFLIP1 noise_rows=<n> real_new_only=<n> real_old_only=<n>`.

## Prior research
tests/punch_speed_test.gd header (the JOIN check was dropped for run-to-run noise from the footwork and guard life),
docs/CLASH2_RESULT.md section S469, scripts/fight3d/ReachLimit.gd (`carry_base`, `BY_WEIGHT`), scripts/fight3d/BeatFire.gd
(`SHORT_WIND_S`), ops/research/GDSCRIPT_TRAPS.md.
## What would a human do?
Measure the same thing twice before trusting a difference between two things.
## Prefab check
None: our own test.
