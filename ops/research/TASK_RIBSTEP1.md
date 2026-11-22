# TASK RIBSTEP1 - GROK DEV - which commit moved the body plan's rib rate below its bar (a measurement, no fix)

Status: OPEN (nightly review 2026-11-22, Claude). Discipline: boxing. Model: Grok Dev default.
Source: nightly 2026-11-22: rib_damage_test red, green on 2026-11-21 (commit 540ddaa80).

## The failure
`FAIL body plan target more-hit rib at or under 55 in 59.0% (at least 60; mean of 8 windows: 54.5 60.0 64.0 56.5 57.0 56.0 63.0 61.0)`
Every other rib check passes. Population (tests/rib_damage_test.gd header): Lucy Jackson on a step plan vs Priya Nair, 200 seeds.

## Likely cause (not proved)
STEPPAY2 changed what a step plan earns in an exchange: bfe5a9817 (phase 2, PlaceEdge: ropes +5.0, corner +6.5) and
7aa64e2e3 (phase 3, StepWire.ride: a step in its best situation costs no exchange). Also in range: 8e984aa76 (a corner
retirement no longer wears the chin), ebff6f036 (a tie-up rests the guard), a3a219220 (STEPPAY2 phase 4).

## Contract
OWNS: nothing in the game. A result file: ops/research/RIBSTEP1_RESULT.md
RED_TEST: tests/rib_damage_test.gd (about 2 minutes headless)
VISUAL: no

## Do
1. In a seeded worktree, run rib_damage_test at 540ddaa80, then at the parents and tips of the commits above (bisect).
2. Write each run's 8 window means and the first commit where the mean drops under 60.
3. Say whether the drop is the step plan doing what STEPPAY2 meant (a design result: the bar needs the owner's look) or a
   side effect (a bug: name the line).
Do not change any number or threshold in the test or the rules.

## Prior research
`python ops/Tools/prior_research.py ribs body plan steppay`. RIBS1 / LIVERRIBS1 notes in the test header (the 8-window mean, S439, S487).

## What would a human do?
Play a body-plan night and see the ribs of the opponent take the damage the plan aims for.

## Prefab check
None.

## Rules for this seat
Godot only through `python ops/Tools/godot_slot.py run --who grok -- ...`, headless, `--audio-driver Dummy`, one run at a time.
Never a checkout in the main checkout. PR body: `RESULT: ops/research/RIBSTEP1_RESULT.md -> first commit under 60: <hash>`.

## The one trap
One window's spread is about 3 points: compare the 8-window MEAN, never one window.
