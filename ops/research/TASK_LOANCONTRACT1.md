# TASK LOANCONTRACT1 - blind contract test of the gym fit-out loan

Kind: test
Status: DONE (S533: tests/loan_contract_test.gd on main) - was OPEN (S531, Claude main). Discipline: boxing. Model: Arena (cloud). Work on ICOON-Studio/FightCamp-Lean-lite main,
your own arena/ branch, a PR into main there; never merge. Do NOT run Godot (it does not install in your shell): the
mirror's CI runs the test.

## The contract (write the test from THIS, not from the code)
A gym that cannot pay a $12,000 move to bigger premises may move on a fit-out loan:
1. `GymSpend.move(c, true)` with cash >= $3,000 returns "" and: premises goes up by one, cash drops by exactly 3,000,
   `c.fitout_weeks` becomes 52, the newest ledger line is the deposit (-3000).
2. With cash below 3,000 the loan move is refused (a non-empty reason) and nothing changes (premises, cash, fitout_weeks,
   ledger size).
3. While `fitout_weeks > 0`, a second loan move is refused and nothing changes.
4. At the biggest premises, the loan move is refused.
5. `Sim.weekly_costs(c)["fitout"]` is 173 while a loan runs and 0 when none runs; `"total"` includes it.
6. `CashForecast.project(c, 8)` never changes `c.fitout_weeks` or `c.cash`.
7. Played day by day through `Sim.step_day(c)` (keep cash high so the gym stays open), the loan is charged exactly 52
   weeks and then stops; afterwards a new loan is allowed again (if premises can still grow).
8. The cash move `GymSpend.move(c)` (no loan) with cash below $12,000 is refused and changes nothing.
Build the career with `Career.quick_start()` and set `cash`, `reputation`, `members`, `premises`, `fitout_weeks` yourself.

## Deliverable
ONE new file `tests/loan_contract_test.gd` (`extends SceneTree`, prints `ok`/`FAIL` per check, ends with
`LOAN_CONTRACT failures=<n>` and `quit(0 if failures == 0 else 1)`). Under 200 lines. Preload what you use:
`res://scripts/state/Sim.gd`, `res://scripts/state/GymSpend.gd`, `res://scripts/rules/GymUpgrades.gd`,
`res://scripts/rules/CashForecast.gd`. Do NOT read tests/fitout_loan_test.gd (that is the implementation's own test; this
one must be blind). Do not edit any other file. If you believe the code breaks the contract, keep the failing check and
say so in the PR body.

PR body: the line `RESULT: tests/loan_contract_test.gd -> LOAN_CONTRACT failures=0` (or the failures you expect) and two
"mutants" you would make in GymSpend.gd or Sim.gd that your test catches (describe them, do not commit them).

## Contract
OWNS: tests/loan_contract_test.gd
RED_TEST: none (blind contract test of built code)
REGRESSION: none
VISUAL: no

## Prior research
GROWTH_SCOPE_S531.md (the loan's terms: $3,000 down, $750 a month x 12 = $173 a week x 52).
## What would a human do?
An auditor reads the loan agreement, not the bookkeeper's spreadsheet, and checks every promise against the bank statement.
## Prefab check
None needed: a GDScript test in the repo's own test style.
