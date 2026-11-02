# R43 — THE PURSE IS THE FIGHTER'S (COMPLETE 2026-09-06)

J4 priority rank **1**, and the biggest money lie the game had. Task file
`research/TASK_R43.md`.

## The bug

`GameState.gd:10253` settled every bout with

```gdscript
gym["cash"] += purse + win_bonus + performance_bonus + gate_share - expenses
```

The gym banked **one hundred percent of the fighter's purse**, and the line
below it only *counted* the same money onto `athlete["career_earnings"]` for
the Ambitions "Financial Security" goal. `FightContract.settlement_for()`
already computed a fighter-shaped `net`, and the settlement handed it to the
gym. Not a balance number slightly wrong — the wrong party paid, in the
player's own role.

**Two more sites had the identical defect, and the double-booking onto
`career_earnings` was the tell in all three.** The Grand Prix champion's bonus
(`:7986`) and the Performance / Fight of the Night payout (`:8597`) are also
promoter money for the contestant, and both were banked by the gym while being
counted onto the fighter. All three are fixed; leaving the other two would have
made E23 false in the tournament and awards paths.

## Stage A — the athlete's wallet

`athlete["cash"]` is the wallet, read through the new `get_athlete_cash()`.
Additive in the R39/R41 sense: the field simply does not exist on an older
save, reads 0, and starts at the first purse after the stage. No migration, no
historical balance re-split. `career_earnings` is untouched and stays the
lifetime counter — making it the wallet would have let Ambitions spend itself.
Uncovered travel and accommodation still come off the fighter's side (J4 E5);
no promoter-side or commission tax is deducted, because none exists and none
was invented (E25).

## Stage B — the gym's share is a filed manager share, or nothing

`FightContract.payee_split(gross, expenses, manager_contract)` is the one seam.
**E23 ships as the default: with no manager contract filed the gym's delta from
a purse is exactly `0`,** and nothing in the game files one. No house
percentage is authored anywhere.

What ships instead is the **cap**, in `Godot/assets/data/manager_share_caps.json`,
every number beside its statute (E21):

| Jurisdiction | Rule | Statute |
|---|---|---|
| Nevada | manager ≤ 33 1/3% of ring earnings | `NAC 467.102(6)` |
| California | manager ≤ 33 1/3% | `4 CCR 221(b)` |
| New Jersey | manager ≤ 33 1/3% | `N.J.A.C. 13:46-6.4` |
| New York | combatant keeps ≥ 50% after authorized deductions | `19 NYCRR 209.12` |

**One thing J4 did not separate, and the build had to:** New York is a *floor
under the combatant*, not a *ceiling on the manager*. Modelled as a percentage
cap it read as "cap 0%", which silently forbade any share at all. The resolver
now carries both shapes, and a jurisdiction with only a floor lets the floor
bind. E3 is honoured structurally: the manager share is the gym's whole delta,
and there is no second `gym_cut` beside it. A filed contract naming no
jurisdiction is held to the strictest cap on file rather than to an invented
number.

## Stage C — what the gym now lives on: measured, not guessed

**After R43 the gym's only inflow is sponsorship** (`GameState.gd:5116`).
Everything else on the account is an outflow: equipment, signing fees, and the
monthly payroll/upkeep bill.

A starter career, 26 weeks, no fights booked (`Godot/tools/` probe, since
deleted):

```
start cash=25000  roster=3  staff=1
weekly payroll 800 + upkeep 367 = 1,167;  billed monthly ≈ 4,668–5,835
w04 20,332   w08 15,664   w13 9,829   w17 5,161   w21 493   w26 −5,342
sponsorship income over the whole run: 0
```

The honest statement, and it is the acceptable answer J5 was told it could
give: **the gym does not currently live on anything.** It burns its $25,000
opening float in about 26 weeks and goes negative, and `Sponsorship.settle_week`
pays only while one deal is active *and* its condition is met — a starter gym
with no deal signed collects nothing. Before R43 the purse masked roughly half
a month's bill per bout (a local bout settles around $2,400 against a $4,668
monthly bill).

**The hole is real but soft: nothing in the game reacts to negative cash.**
There is no bankruptcy path, no game-over, no borrowing — the number simply
goes below zero and play continues. So R43 does not break a career; it makes
an already-unsound ledger visible.

**No number was invented to fill it.** John's J5 is researching the gym's own
ledger — dues, the manager share as a collectible revenue line, whether a gym
supplying corners is paid, and the gym as a sponsored entity — and that is the
honest source for whatever fills this. The desk licence (J4 E7, rank 3) stays
out as specified: a gym taking no cut needs no licence.

## Evidence

- Parse gate 11/11 (`GameState.gd`, `FightContract.gd`, nine tests).
- New `Godot/tests/purse_payee_test.gd`: **25/25**, P1–P7 from J4's E19–E25.
- Nine existing tests that asserted the GYM was paid now assert the fighter's
  wallet **and** that the gym's cash does not move: `contract_clauses`,
  `day_clock`, `fight_contract`, `promotion_matchmaking`, `weight_cut`,
  `tournaments`, `watched_status`, `smoke`. They could not pass unchanged —
  each encoded the wrong payee — so each kept its intent and moved its payee.
- Full suite green apart from `championship_read_test.gd`, which is **Codex's
  C26 landing in the shared tree, not R43**: its own Q8 fails because one of
  `get_championship_read` / `get_championships_read` / `get_bout_title_stakes`
  mutates state during a read. R43 writes only inside settlement and award
  payment, never on a read path. Codex has been messaged.

## A note on the commit

`GameState.gd` carried Codex's in-flight C26 hunks alongside R43's while this
shipped. Only the R43 hunks were committed, by staging a HEAD+R43 blob; the
working tree was left untouched so Codex's uncommitted work survives intact.

## Test

```
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/purse_payee_test.gd
```
