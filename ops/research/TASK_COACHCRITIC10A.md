# TASK COACHCRITIC10A - judge the coach fit sheet (COACHFIT_SHEET) design, fresh critic

Kind: research
Status: OPEN (S530, Claude main). Discipline: boxing. Model: Arena (cloud). Work on FightCamp-Lean-lite main, your own arena/ branch, a PR into main there; never merge. RESEARCH ONLY - no game code changes.

## Your job
You are a fresh, independent critic: a sports management-sim designer. Read the whole brief
`ops/research/DESIGN_COACHFIT_SHEET_CRITIC_DOLA.md` (the critic pack, then the design map at the end) and do exactly what it
asks: score DEPTH and GENERAL DESIGN out of 10 with reasons, say which options are missing or useless and what each changes,
and end with "To reach 10/10" - the concrete changes, most important first, each specific enough to build. The map is a numeric sheet written from the code (scripts/rules/CoachFit.gd, called by nothing yet; the levers it joins:
scripts/rules/WeekPlan.gd, scripts/rules/CoachedMornings.gd, scripts/ui/TrainGrid.gd) plus a probe's verbatim output
(docs/COACHFITPROBE2_RESULT.md: a TOP fit gives +27% focus-stat gain but +0.08 wins in 100). Check every number
against that code, and answer the sheet's own last question: keep coach fit as hover reasons (section 11), or cut it whole.
Do NOT read any other critic's answer (no file named *_CRITIC_* other than the brief above) before writing.
Say which code files you read.

## Deliverable
ONE new file `ops/research/DESIGN_COACHFIT_SHEET_CRITIC_ARENA.md` (the scores on their own line:
`SCORE depth=<n> general=<n>`). A PR that adds only that file. Do not edit any other file. Do not run Godot.

## Contract
OWNS: ops/research/DESIGN_COACHFIT_SHEET_CRITIC_ARENA.md
RED_TEST: none (research)
REGRESSION: none
VISUAL: no

## Prior research
docs/COACHFITPROBE2_RESULT.md, docs/FITPROBE1_RESULT.md, docs/FITPROBE2_RESULT.md. No earlier critic file is to be read.
## What would a human do?
A gym owner pairs each boxer with the coach whose manner she takes to, and moves her on when she has learned all he can teach.
## Prefab check
None: a design review.
