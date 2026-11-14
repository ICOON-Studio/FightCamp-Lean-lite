# TASK LIVERPROBE1 - tune the liver fold to the design's bar on 400 played bouts (probe, no screen)

Status: OPEN (S467, Claude main). Discipline: boxing. Model: qwen3-coder (Qwen), default.

## Why now
S467 wired the liver fold (scripts/state/LiverFold.gd, called from BoutNight._counts). Its two knobs are static vars:
`LiverFold.shot_points` (points one liver shot of the live tally takes off; hurt <= 55) and `LiverFold.fold_scale`
(x LiverRibs.liver_fold_chance). tools/liverfold_probe.gd on 100 bouts (seeds 100-199) was too noisy to tune finer:
6.0/1.0 -> 7 folds of 27 counts (26 %), 7.5/1.0 -> 22 of 42, 7.5/0.6 -> 8 of 28, 6.0/0.5 -> 0, 5.5/1.0 -> 0.
Design bar (ops/research/DESIGN_LIVERRIBS1_V2_REVISE_KALLI_KALLI.md s7): body knockdowns 10-20 % of ALL knockdowns.

## What to build
tools/liverprobe1.gd (start from tools/liverfold_probe.gd): 400 bouts (seeds 100-499), a grid of shot_points
{5.5, 6.0, 6.5, 7.0} x fold_scale {0.5, 0.75, 1.0}; per cell print counts, liver_folds, share, and how many bouts ended
by RSC/KO before vs with folds (fold_scale 0 = the control arm, no folds). Pick the cell nearest 15 % share with the
fewest extra stoppages; write it into docs/LIVERPROBE1_RESULT.md (the probe's own writer) with the table.
Do NOT change LiverFold.gd's defaults yourself - Claude sets them from your table.

## Pass lines
- every cell prints; the control arm (fold_scale 0) prints liver_folds=0
- final line `LIVERPROBE1 best=<pts>/<scale> share=<x> folds=<n> counts=<n>`
- same seeds twice = identical (print `determinism yes|no` on one cell)

## Contract
OWNS: tools/liverprobe1.gd, docs/LIVERPROBE1_RESULT.md
RED_TEST: tools/liverprobe1.gd -> LIVERPROBE1 best=
REGRESSION: liver_fold_test, knockdowns_test
VISUAL: no
NOT YOURS: every file in scripts/ and tests/ (read-only).
Runs only through `python ops/Tools/godot_slot.py run --who liverprobe1 -- <godot> --headless --audio-driver Dummy --path . --script res://tools/liverprobe1.gd`.
Under 500 lines. PR body: `RESULT: tools/liverprobe1.gd -> LIVERPROBE1 best=...`.

## Prior research
ops/research/DESIGN_LIVERRIBS1_V2_REVISE_KALLI_KALLI.md s3 rules 2-3, s7 bars; ops/research/S467_DIGEST.md.
## What would a human do?
A body puncher folds a hurt opponent now and then late in a fight, far less often than head shots drop people.
## Prefab check
None: an in-house probe on our own rules.
