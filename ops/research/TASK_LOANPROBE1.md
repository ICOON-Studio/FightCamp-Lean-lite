# TASK LOANPROBE1 - does the careful gym grow with the fit-out loan? The 60-career probe on the game's own loan

Kind: probe
Status: OPEN (S533, Claude main). Discipline: boxing. Model: Grok Dev (your own box: the run is long). Branch `grok/loanprobe1`, a PR; never merge.

## Why
Roadmap GYMMONEY1: the owner asked for "Careful gym grows" (Q-S294-277) and "Yes, build the loan" (Q-278). The fit-out loan is
BUILT (S531: `GymSpend.move(c, true)`, `GymUpgrades.LOAN` $3,000 down + $750 a month x 12 with the bills, `tests/fitout_loan_test.gd`).
What is missing is the proof: over two years, does a sensible player who takes the loan grow (more members, a second room, still
open), and does the loan ever sink a gym? `tools/gym_survive_probe.gd` has the arms (SENSIBLE, GROW, GROWLOAN) but has only been
run on 4 careers (docs/GYMSURVIVE1_GROW_RESULT.md, 2 careers x 2 seeds).

## Do
1. Read `tools/gym_survive_probe.gd` (428 lines) and check the GROWLOAN arm really takes the loan through `GymSpend.move(c, true)`
   when it is offered (the game's own path, not a copy). If it does not, fix the probe (tools/ only) and say what was wrong.
2. Run `-- arms=SENSIBLE,GROW,GROWLOAN` at 60 careers per arm (e.g. 15 careers x 4 seeds; the probe's own args), 104 weeks each.
   One run at a time on your box.
3. `docs/LOANPROBE1_RESULT.md`: per arm - closure share by week 26/52/78/104 (with its spread over seeds), members at 1 and 2
   years, cash at 2 years, how many moved and when, how many took the loan, how many loan-takers closed and whether the loan
   payments were the reason (cash below zero while paying). A control: SENSIBLE must reproduce GYMSURVIVE1's earlier SENSIBLE
   numbers within its seed spread. Bounds, never an exact count. Population named in the doc (quick_start = one boxer).
4. Verdict in plain words: does the loan help a careful gym grow, is it ever a trap, and which number (down, month, months, the
   move price) the measurement points at if it is off - measured, not guessed. No game change.

## Rules
- tools/ and docs/ only; nothing under scripts/ changes. Never `_console.exe`; headless, `--audio-driver Dummy`.
- Do not touch the files other sessions own (P4PBUILD1, STEPPAY2, DEBUTPICK1 - see their TASK files).

## Deliverable
PR on `grok/loanprobe1`; body `RESULT: tools/gym_survive_probe.gd -> GYMSURVIVE arms=SENSIBLE,GROW,GROWLOAN careers=<n> done` +
the verdict in three lines.

## Contract
OWNS: tools/gym_survive_probe.gd, docs/LOANPROBE1_RESULT.md
RED_TEST: none (probe). REGRESSION: tests/fitout_loan_test.gd. VISUAL: no

## Prior research
GROWTH_SCOPE_S531; docs/GYMSURVIVE1_*_RESULT.md; Q-277, Q-278.
## What would a human do?
An accountant runs the two-year cash plan with and without the loan before the gym owner signs.
## Prefab check
None.
