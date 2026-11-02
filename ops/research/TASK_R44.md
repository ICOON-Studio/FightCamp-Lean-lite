# TASK R44 — THE MEMBERSHIP (Claude)

**Status: ASSIGNED 2026-09-07, awaiting the operator's go-ahead.** Depends on
R43 (`b300d3c`), C27 (`5afdfed`), J5 and J6 (`b508488`). J5 ranked this **2**
and J6 A16 refused to outrank it: *"the gym still has to live on something
after R43."*

Model: Opus, effort high, Fast off. One session; the stage ends at the push.

## Why this exists

R43 moved the purse to the fighter and refused to invent a `gym_cut`. J5 then
said what a real gym lives on — **the training floor, not the purse** — and
J6 A15 said the same object from the athlete's side. Nothing was built.

So the desk has no inflow at all. `weekly_projection` is literally
`-(athletes_payroll + staff_payroll + weekly_upkeep)` (`GameState.gd:2842`
and `:12285`) — a projection with **no inflow term in it**, which was only
survivable while the purse was covering the gap. C27's ledger read now says
this out loud, and M8 drew what it looks like: **$25,000 → -$5,342 over 26
weeks**, crossing zero quietly, with nothing in the game reacting.

The only inflow that exists is an authored sponsorship cheque
(`Sponsorship.gd:13`, tiers 250 / 400 / 650 / 1000). A gym whose sole income
is a sponsor is not a gym.

## The rule, in one sentence

**A gym has members, members pay the floor weekly, and every dollar of it is
labelled as authored — because nothing published says what a gym charges.**

J5 **G24** is the hard constraint and it is not negotiable here: **no
sport-wide dollar without `evidence`.** So the membership rate is authored the
way sponsorship is authored — present, spendable, and **labelled invented** on
every read that shows it. That is exactly what M8's AUTHORED chip and C27's
`source ∈ {evidenced, invented, absent}` field exist for. Do not go looking
for a real number to justify; author it, label it, and move on.

## What to build

- **`Membership.gd`** (new, pure): the member count a gym carries and what it
  pays. The count responds to what the gym already has — reputation and the
  facility it owns — and moves gradually week to week; the rate is authored in
  data. Deterministic, `overrides`-friendly like the other weekly helpers, so
  the test does not fight an RNG.
- **`assets/data/membership.json`** (new): every magnitude, each with a note
  that says GAME RULE / authored, in `championship_rules.json`'s shape
  (R41's `interim_hold_weeks` precedent). **No organization's name on it**
  (J1 §4.1), and no claim that any real gym charges this.
- **The weekly pass credits it**, in `_settle_billing` (`:4660`) where payroll
  and upkeep already come out. One inflow line, same week, same dict.
- **`weekly_projection` gains the inflow term at BOTH sites** (`:2842` and
  `:12285`). J5 named this a defect and M8 drew the honest form. The net is
  still allowed to be negative — this stage is not a difficulty pass.
- **`GymLedgerRead.gd`** gains the membership inflow line carrying
  `source: "invented"`. C27 is COMPLETE, so the file is free; keep its shape.
- **The J6 rider (A17 / A18), and nothing more than this**: the opaque
  `expenses` integer at `:10375` is the fighter's own **uncovered travel and
  accommodation** and reads at the call site as a mystery skim. Rename the
  local and label it, add the named key to the settlement log row, and leave
  `FightContract.settlement_for` (`:219`–`:239`) and `payee_split`
  (`:305`–`:337`) **arithmetic untouched**. It is a name, not a number.

## Out of scope

- **No `gym_cut`, no percentage of any purse.** J4 E3 / J5 G10 / J6 A16 all
  refused it and this stage does not reopen it.
- No bankruptcy, no game-over, no negative-cash consequence. M8: nothing in
  the game reacts to negative cash and the art must not imply it does.
- No membership UI. M8 is the grammar and a screen is a later stage.
- No commission cut, no tax line, no trainer or cutman percentage (J6 A4 /
  A6 / A10). No medical or licence dollar (A13).
- Do not touch the read-API region Codex holds for C28: `get_*_read` around
  `:9616`–`:9620` and the new `AthletePurseRead.gd`.

## Files

- `Godot/scripts/Membership.gd` (new).
- `Godot/assets/data/membership.json` (new).
- `Godot/scripts/GameState.gd` — the **billing and settlement regions only**:
  `:2842`, `_settle_billing` `:4660`, `:10341`–`:10384` (the rename), the log
  row at `:10583`, `:12285`. Nothing in the read-API region.
- `Godot/scripts/GymLedgerRead.gd` — the inflow line.
- `Godot/scripts/FightContract.gd` — comments and labels only.
- `Godot/tests/membership_test.gd` (new).

## Parse gate (before any test run)

```
python Godot/tools/check_scripts.py Godot/scripts/Membership.gd Godot/scripts/GameState.gd Godot/scripts/GymLedgerRead.gd Godot/scripts/FightContract.gd Godot/tests/membership_test.gd
```

## Test

```
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/membership_test.gd
```

Then `gym_ledger_read_test.gd` (C27's own, and the one most likely to see the
new inflow line), `contract_clauses_test.gd` and `day_clock_test.gd`, and the
full suite once before the commit. A regression that only passes after you
edit it means the old expectation encoded the no-inflow defect; say so in the
digest, as R43 did for the nine tests that asserted the gym was paid.

## Done

Digest `research/R44_DIGEST.md`, the HANDOFF block, push `master`,
and end the session.
