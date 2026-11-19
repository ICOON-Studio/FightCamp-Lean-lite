# TASK FITPROBE2 - coach fit on the EVENINGS: does a TOP fit bring moves to Sharp sooner? (probe only)

Status: OPEN (S525, Claude main). Discipline: boxing. Model: Qwen (PC, headless).
Mechanic: COACH FIT v8 (approved Q-235; scripts/rules/CoachFit.gd built, NOT wired). Design:
`ops/research/DESIGN_COACHFIT1_V8_REVISE_KALLI_KALLI.md` 2.1 ("fit multiplies the drill units on pad and sparring nights ...
and the stat gain on mornings") and 12 (pass lines).

## Why (docs/FITPROBE1_RESULT.md, S524)
FITPROBE1 applied fit to the MORNING stat gain only: TOP - AVERAGE = +0.95 on the FOCUS stat (bar +3..+5) and Sharp
0.00 weeks sooner - Sharp could not move, the evenings were never scaled. Today's base morning gain is +3.5 in 26 weeks,
so x1.32 can only add ~1: the stat bar is a design question for Claude, not yours. Measure the evenings.

## What to measure
Start from a COPY of tools/fit_probe.gd (same population, seeds, arms AVERAGE 50 / TOP 82 / CONTROL). Add, after each
week's evening drills (scripts/state/DrillWeek.gd `run`, the game's own path through Sim.step_day): for every move whose
mastery rose this week, add (CoachFit.gain_mult(fit) - 1) x that week's rise, through CoachFit.capped(gain, camp mult)
(the x1.6 stack cap), never past the move's 100. Keep the morning part as FITPROBE1 did. Print per arm:
- weeks to the first Sharp move (FireLevel's Sharp tier - name the constant you read), mean / p10 / p90, and how many
  boxers reach it;
- mastery of the drilled moves at week 26;
- TRAINBALANCE: the same 40 bouts per boxer against the same fixed opponents as FITPROBE1, wins in 100 per arm.
Pass lines (map 12): Sharp 2-4 weeks sooner; TOP wins +4..+8 in 100 over AVERAGE and under a good plan's +14. CONTROL must
equal AVERAGE exactly (it is the same fit). A FAIL is a finding, not a broken probe.

## Contract
OWNS: tools/fit_probe2.gd, docs/FITPROBE2_RESULT.md
RED_TEST: tools/fit_probe2.gd -> FITPROBE2 done
REGRESSION: coach_fit_test, training_week_test (read-only: run them, never edit them)
VISUAL: no
NOT YOURS: everything in scripts/ and tests/, tools/fit_probe.gd (read-only; copy from it). The result page is written by
the probe from its numbers. Each file under 500 lines. Pilot 4 boxers first and print the projected time; stop at 90
minutes of run time. PR body: `RESULT: tools/fit_probe2.gd -> sharp_sooner=<weeks> mastery_diff=<n> win_diff_in_100=<n>
control=<match|differs> fitprobe2=<pass|fail> trainbalance=<pass|fail>`.

## Prior research
`python ops/Tools/prior_research.py coach fit` -> TASK_FITPROBE1.md, docs/FITPROBE1_RESULT.md, the v8 map.

## What would a human do?
A pads coach who suits a boxer gets the combination into her hands weeks sooner; that is what to time.

## Prefab check
None: the game's own week loop.

## The one trap
Scaling the wrong number: scale the WEEK'S RISE in mastery, never the mastery total (that would compound every week).
