# TASK COACHFITPROBE2 - can a coach fit be felt inside the cap? (probe, COACHSCOPE1 phase 2)

Status: OPEN (S529, Claude main). Discipline: boxing. Model: Goose (cloud), default.

## Why
ops/research/COACHFIT_SHEET.md (S529, read sections 0, 3, 4, 8 first) pins coach fit as numbers from
scripts/rules/CoachFit.gd. Two earlier probes (docs/FITPROBE1_RESULT.md, docs/FITPROBE2_RESULT.md) measured a TOP fit
(82: gain x1.32, tiredness x0.92) on the game's own week: +0.95 of a stat in 26 weeks, Sharp 1.5 weeks sooner, +0.08 wins
in 100 - nothing a player feels. This probe answers the ONE question the sheet hands phase 2: is there a gain slope,
inside the stack cap, that makes a TOP fit worth +4..+8 wins in 100? Plus the tiredness check (sheet 8 question 5).
Sheet questions 2-4 (coach choice, mode, bond) run ONLY if question 1 passes - not in this task.

## What to build (probe-side only - do NOT edit scripts/ or tests/)
New `tools/coachfit_probe2.gd` (under 450 lines): a COPY of tools/fit_probe2.gd (same 60 boxers, seeds 6100..6159,
paired arms, the same morning + evening levers, the same TRAINBALANCE bouts), changed in two places only:
1. SLOPE arms. Replace CoachFit.gain_mult(fit) by `1.0 + k * (fit - 50) / 100.0` for k in [1.0, 1.5, 2.0, 3.0]
   (k 1.0 = today's gain_mult; check it equals CoachFit.gain_mult(82) = 1.32 and print that). Every lift still goes
   through `CoachFit.capped(mult, today)` where today = the coached-morning x camp product that gain already gets
   (S529 semantics: held at max(1.6, today)). Arms per k: AVERAGE fit 50, TOP fit 82; plus CONTROL (untouched) once.
   Print per k: focus stat gain in 26 weeks (A / T), weeks to Sharp (A / T), wins in 100 (A / T), and how often the 1.6
   cap bit (share of lifted days).
2. TIREDNESS. After part 1, take each boxer's week-26 state twice: one camp week (WeekPlan.week on the boxer's plan) at
   tired_mult(80) and one at tired_mult(35) (CoachFit.tired_mult, clamped 0.92..1.08 since S529), then the same 4-round
   bout from each (same opponent, same seed). Print energy at the last bell (80 vs 35) and energy at the end of round 3.

## Pass lines (print each)
- SLOPE: the smallest k with TOP - AVERAGE = +4..+8 wins in 100 AND Sharp 2..4 weeks sooner. Print
  `COACHFITPROBE2 slope=<k or NONE>`. NONE is a valid finding (the sheet then turns fit into a hover reason, not a number).
- TIREDNESS: fit 80 ends 8..12 energy ahead at the last bell; fit 35 is 15..20 down by the end of round 3. Print
  `COACHFITPROBE2 tired=<pass|fail> ahead=<x> r3_down=<y>`.
- CONTROL: AVERAGE (fit 50) equals CONTROL to the digit for every k (both multipliers are exactly 1.0 at fit 50).
Pilot first with 6 boxers; the full run stays under 90 minutes on a GREEN PC (cut k arms, never seeds).

## Deliverable
`tools/coachfit_probe2.gd`, `docs/COACHFITPROBE2_RESULT.md` (method, the per-k table, the tiredness table, the pass lines), one PR adding only those two files.
RESULT: tools/coachfit_probe2.gd -> COACHFITPROBE2 slope=<k|NONE> tired=<pass|fail>

## Contract
OWNS: tools/coachfit_probe2.gd, docs/COACHFITPROBE2_RESULT.md
RED_TEST: tools/coachfit_probe2.gd prints COACHFITPROBE2 slope=<k|NONE> tired=<pass|fail>
REGRESSION: tests/coach_fit_test.gd, tests/coach_fit_sheet_test.gd (unchanged, still green); tools/fit_probe2.gd untouched
VISUAL: no

## The trap
Scale the WEEK'S RISE of a move's mastery, never the mastery total (fit_probe2's note: scaling the total compounds every
week). And keep `capped(mult, today)` - without it a k of 3.0 reads as a huge effect the game can never give.

## Prior research
ops/research/COACHFIT_SHEET.md, COACHFIT_SCOPE_S528.md, DESIGN_COACHFIT1_V9_CRITIC_ARENA.md (items 3 and 5),
docs/FITPROBE1_RESULT.md, docs/FITPROBE2_RESULT.md, tools/fit_probe2.gd.
## What would a human do?
A trainer who suits a fighter gets more out of the same hours - but the gap shows in months, not in one fight. The probe
asks whether our game can show that gap at all before we print a number for it.
## Prefab check
None: our own probe.
