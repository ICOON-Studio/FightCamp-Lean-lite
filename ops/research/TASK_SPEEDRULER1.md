# TASK SPEEDRULER1 - sort punch_speed_test's 41 failures: which bar is wrong, which punch is wrong (measure only, headless)

Status: OPEN (S473, Claude main). Discipline: boxing. Model: qwen3-coder (Qwen), default.

## Why now
tests/punch_speed_test.gd (268 lines; header lines 1-26 say what it bars) has printed about 41 failures for many sessions,
the same before and after S472's split (docs/CLASH2_RESULT.md, ops/research/S472_DIGEST.md). It bars four things per
punch: SPEED (glove top speed in SPEED_BAND), FIRST (hand moves within FIRST_S 0.13 s), POP (no bone steps more than
POP_X 1.5x its old worst step), SYNC (clip on its contact when the hit timer fires). Nobody knows which of the four makes
the 41, so the test is noise: it cannot tell us when a punch gets better or worse. docs/JOINFIX1_RESULT.md line ~119 says
it also changes run to run (39-45) without `--fixed-fps 60`; with it, it repeats exactly (CLASH2_RESULT.md line ~102).

## What to do (measure only - change no game script and no bar)
1. Run it twice with `--fixed-fps 60` and confirm both runs print the same failure lines.
2. Write tools/speed_ruler_sort.py: reads the test's output (a saved log file given as argv[1]) and prints a table:
   one row per punch (jab, cross, lead_hook, rear_hook, uppercuts, body shot - the names the ROW lines use), one column
   per check (SPEED / FIRST / POP / SYNC), the failure count in each cell, plus each row's measured value range against
   its bar (e.g. SPEED 4.9-5.6 v 7-9). Last line `SPEED_RULER_SORT total=<n>` where n equals the test's failure count.
3. Write docs/SPEEDRULER1_RESULT.md: the table, then ONE short paragraph per check that fails, in plain words:
   is the bar asking for something the clip cannot do (name the number), or is one punch far off where the others pass
   (name it)? Use CROSS_POWER_S439.md's real-world numbers (6-11.5 m/s crosses) as the yardstick. No fix.

## Pass lines
- Two fixed-fps runs identical; the sort's total equals the test's failure count; the table in the result doc.
- RESULT: tools/speed_ruler_sort.py -> SPEED_RULER_SORT total=

## Contract
OWNS: tools/speed_ruler_sort.py, docs/SPEEDRULER1_RESULT.md
RED_TEST: tests/punch_speed_test.gd -> PUNCH_SPEED failures= (stays red: this task measures, it does not fix)
REGRESSION: punch_speed_test (PUNCH_SPEED failures unchanged from main)
VISUAL: no
NOT YOURS: every script under scripts/, every test under tests/. No number changed anywhere.
Runs only through `python ops/Tools/godot_slot.py run --who speedruler1 -- <godot> --headless --audio-driver Dummy --fixed-fps 60 --path . --script res://tests/punch_speed_test.gd`
(never the _console exe, never a window, never wrapped in `timeout`). One run at a time. Nothing opens on a monitor.

## Prior research
ops/research/CROSS_POWER_S439.md (real crosses 6-11.5 m/s, the start rule); ops/research/CLIP_CRITICS_S439.md (stillness
before the hand moves); docs/JOINFIX1_RESULT.md and docs/BLOCKLOOK2_RESULT.md (earlier counts 39-45); docs/CLASH2_RESULT.md
(fixed fps makes it repeat).
## What would a human do?
Before changing any punch, split the red count by check and by punch, so the next fix moves one known number.
## Prefab check
None: our own test's output.
