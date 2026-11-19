# TASK COACHFITPROBE3 - re-measure coach fit where the design uses it (probe, COACHSCOPE1 phase 3b)

Status: OPEN (S530, Claude main). Discipline: boxing. Model: Goose (cloud), default (or Qwen on the PC).

## Why
COACHFITPROBE2 (docs/COACHFITPROBE2_RESULT.md) said slope=NONE (+0.08 wins in 100 at today's slope) and tired=fail, and
ops/research/COACHFIT_SHEET.md s0b/s11 turned coach fit into a hover reason on that verdict. A fresh critic
(ops/research/DESIGN_COACHFIT_SHEET_CRITIC_ARENA.md, items 1-3 of its 10/10 list) found the probe measured the wrong places:
(a) the wins harness has no dose control - nobody showed that +1 stat moves it at all; (b) tiredness was read as energy at
the bell, but BoutRules.tank_parts holds the tiredness term flat from fatigue 60 up, so the ring cannot show it; the design
uses it in CAMP (week peak, mornings past 80, injury multiplier, PeakCamp); (c) the slope scaled the focus morning, while
the sheet wires the COACHED morning (CoachedMornings.day_mult) and the drill nights. This probe repairs all three. It
changes no rule.

## What to build (probe-side only - do NOT edit scripts/ or tests/)
New `tools/coachfit_probe3.gd` (under 450 lines), starting from tools/coachfit_probe2.gd (same 60 boxers, seeds
6100..6159, paired arms, CONTROL untouched once).
1. DOSE CONTROL (run first). Same harness that gave "wins in 100", three arms with no coach fit: untouched, +0.95 on the
   focus stat, +5 on the focus stat. Then the same three at EVEN odds (pick each boxer's opponents so the untouched arm
   wins 45..55 in 100). Print wins in 100 for all six. Print `COACHFITPROBE3 dose=<ok|blind>`: ok when +5 moves wins by
   10 or more in 100 at even odds; blind otherwise (then the wins lines below are reported but carry no verdict).
2. SLOPE ON THE WIRED LEVER. Scale `CoachedMornings.day_mult` (the coached morning) and the drill nights' weekly rise -
   NOT the plain focus morning - by `1 + k * (fit - 50) / 100` for k in [1.0, 1.5, 2.0], every lift through
   `CoachFit.capped(mult, today)`. Arms AVERAGE 50 / TOP 82 / RISKY 34. Print per k and arm: focus stat gain in 26 weeks,
   weeks to Sharp, the evening line's tier at week 26 (FireLevel: Usable / Sharp), wins in 100 at even odds.
3. TIREDNESS IN CAMP. A Standard and a Hard camp week from each boxer's week-26 state at tired_mult(82), tired_mult(50),
   tired_mult(34). Per week and arm print: week peak fatigue (f["week_peak"]), mornings started past 80 (the x0.6 days),
   InjuryRoll.fatigue_mult(peak), and PeakCamp.met. Do NOT use energy at the bell.
Pilot with 6 boxers first; the full run under 90 minutes (cut k arms, never seeds).

## Pass lines (print each)
- `COACHFITPROBE3 dose=<ok|blind> plus5_even=<wins delta>`
- `COACHFITPROBE3 slope=<k|NONE>`: smallest k where TOP - AVERAGE is +4..+8 wins at even odds OR Sharp 2..4 weeks sooner.
- `COACHFITPROBE3 camp=<pass|fail>`: pass when TOP keeps a Hard camp under 80 peak in at least half the boxer-weeks where
  AVERAGE crosses 80, or moves fatigue_mult by x1.25 or more.
- CONTROL: AVERAGE equals CONTROL to the digit.

## Deliverable
`tools/coachfit_probe3.gd`, `docs/COACHFITPROBE3_RESULT.md` (method, the dose table, the per-k table, the camp table, the
pass lines), one PR adding only those two files.
RESULT: tools/coachfit_probe3.gd -> COACHFITPROBE3 dose=<ok|blind> slope=<k|NONE> camp=<pass|fail>

## Contract
OWNS: tools/coachfit_probe3.gd, docs/COACHFITPROBE3_RESULT.md
RED_TEST: tools/coachfit_probe3.gd prints COACHFITPROBE3 dose=<ok|blind> slope=<k|NONE> camp=<pass|fail>
REGRESSION: tests/coach_fit_test.gd, tests/coach_fit_sheet_test.gd (unchanged); tools/coachfit_probe2.gd untouched
VISUAL: no

## The trap
Scale the WEEK'S RISE, never a mastery total (it compounds). And the even-odds arm: a 30-in-100 long shot is the worst
place to look for one stat point - pick opponents, never change the boxers.

## Prior research
docs/COACHFITPROBE2_RESULT.md, docs/FITPROBE1_RESULT.md, docs/FITPROBE2_RESULT.md, ops/research/COACHFIT_SHEET.md (s3,
s4, s11), ops/research/DESIGN_COACHFIT_SHEET_CRITIC_ARENA.md (10/10 items 1-3 only), scripts/rules/InjuryRoll.gd
(fatigue_mult), scripts/rules/PeakCamp.gd (met), scripts/rules/FireLevel.gd.
## What would a human do?
Before saying "a good coach match does not win fights", check that the test can see a good fighter win more at all, and
look for the coach's effect where trainers see it: in how the camp holds up, not in round 4.
## Prefab check
None: our own probe.
