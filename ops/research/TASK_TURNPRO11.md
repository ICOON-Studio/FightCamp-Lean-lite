# TASK TURNPRO11 - write the turning pro map v11 FROM THE CODE

Kind: research. Discipline: boxing. Model: Fable console in this checkout (maps come from the code, never a chat seat).
RESEARCH ONLY - no game code changes. Do not run Godot.

## Why
v10 (`ops/research/DESIGN_TURNPRO1_V10.md`) scored John 6/7/7 (`DESIGN_TURNPRO1_V10_CRITIC_JOHN_JOHN.md`) and Kalli 6/7/6
(`DESIGN_TURNPRO1_V10_CRITIC_KALLI_KALLI.md`): GENERAL DESIGN passes, DEPTH is one point short on both.
- John: the cover-costs ask on the safer start makes the gym ~$900 better off at every sales count; it decides the fork for any
  cash-minded player. His point 1 (gate and floor the cover ask) "lifts DEPTH to 7 and can be built now".
- Kalli: "the same on average" counts only members - morale, reputation and stoppage risk all favour the safer start, and the
  gym's money side of the fork is $60-$100 once (under 5% of a month's rent); the ticket ask pays at every count in the band;
  Later's benefit cannot be shown (DebutRead.card does not read debut_weeks); both debutants are the same boxer-puncher; the
  long tail (the first 6 pro fights, ProLean) is not measured; the boxer's wish mostly agrees with forces already at work.

## Your job
Write ONE new file `ops/research/DESIGN_TURNPRO1_V11.md`:
1. What the game does today ONLY from code you opened (ProOffer.gd, ProOfferWire.gd, ProCall.gd, ProDebut.gd, DebutPick.gd,
   DebutRead.gd, DebutOpp.gd, Roster.turn_pro, ProLean, GymBills). CODE lines name file + function and are TRUE today.
2. Answer both critics' "To reach 10/10" lists one by one: take it (how, which number it moves) / refuse (one line why). The
   goal: a real fork on DEPTH - each house right for some boxers and gyms, no ask with one answer, every lasting effect
   (morale, reputation, stoppage risk, the first pro fights) priced, not only money.
3. The table of every menu the mechanic appears on and what each is wired to, CODE TODAY vs TO BUILD.
4. The probe that must pass before any board (bounds, not exact counts; today's rules as the control).
Owner rulings to keep: the debut opponent is picked to each boxer (Q-286); the safer house about 75 in 100 ("78 is fine");
names only in headers; only actionable information on screen (C443); board text short.

## Contract
OWNS: ops/research/DESIGN_TURNPRO1_V11.md
RED_TEST: none (research)
REGRESSION: tests/debut_pick_test.gd (research only: nothing to rerun unless code is touched)
VISUAL: no

## Rules
Touch ONLY that file. Other sessions have uncommitted edits (LineGrade.gd, LiveRound.gd, StepWire.gd) - never stage them.
`git add -- ops/research/DESIGN_TURNPRO1_V11.md`, commit to main, push, report in two lines, then stop.
