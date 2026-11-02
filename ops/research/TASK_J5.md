# TASK J5 — THE GYM'S OWN LEDGER: WHAT A GYM IS ACTUALLY PAID (John)

**Status: COMPLETE 2026-09-06, landed by Claude.** Research and proposals only. No `.gd`,
no `.tscn`, no `Godot/assets/data/` writes, no `HANDOFF.md` edit, no UI design.
Claude writes your HANDOFF block from your land note, as with J1–J4.

Model: top tier, effort high, Fast off. Same tier as J3/J4 — this is an
evidence study with a live economy on the other side of it.

## Why this exists, and why now

J4 **E1** ruled that the payee is the athlete, and **R43** is building it: the
purse stops landing in `gym["cash"]` at `GameState.gd:10253`. **E23** is the
default that ships with it — no manager contract filed, the gym's delta from
that purse is `0`.

That leaves a hole J4 named and did not fill. The gym still pays weekly payroll
and upkeep (`_settle_billing`), and after R43 the purses no longer feed it. J4
§Area 1(e) said the honest answer is not an invented gym cut. **This study is
the honest answer.** What is a combat-sports gym actually paid, and which of
those revenue lines can be modelled without inventing a number?

## What is in scope

Four areas, same shape as J1–J4: (a) decisions coming, named as calls, (b)
evidence with the UNKNOWN discipline, (c) what the game does today — honest /
invented / absent, (d) one minimum change, (e) issues each with a solution.

### Area 1 — Membership, dues and the training floor
Fees a gym charges its own members and its own professionals. What is
**published** (a gym's own posted rates are primary for THAT gym, not for the
sport), what is **CUSTOMARY**, and what is **UNKNOWN**. Whether a fighter on
the roster pays dues at all, or trades them for the desk's share. Note that the
game already runs a payroll and an upkeep and has never asked where the money
in comes from.

### Area 2 — The manager share, as a revenue line rather than a deduction
J4 **E2/E3** ruled the cap side of this (NV/CA/NJ 33 1/3% of ring earnings; NY
the ≥ 50% floor to the combatant; a gym taking ≥ 10% of a gross purse IS a
manager and must be licensed as one). **Do not re-derive those.** The open
question here is the other direction: when a filed manager share is the gym's
income, what is actually required for it to be collectible — a contract on
file, the combatant's approval (`NAC 467.137(3)`), a licence in the event state
— and what the desk loses when any of those is missing (J4 **E9**).

### Area 3 — Corner work, seconds and cornerman fees
J4 **E4** ruled the **payer** (fighter/manager expense, not a promoter
statutory obligation) and the licensing (NV/CA a manager may second without a
second's licence; NJ may not; NY may second their own). The open question is
whether a gym supplying corners is **paid** for it, by whom, and whether any of
it is published. Expect large UNKNOWN. Say so.

### Area 4 — Sponsorship and the gym as an entity
`Sponsorship.gd:224` already branches on `entity_type` (J2 P12) and J3 **D15**
adds `outfitting_policy ∈ {house_kit, fighter_sponsors}`; J4 **E17** added one
sentence about a manager share of remaining fighter-side money. **Do not redo
D15 or E17.** The open question is the GYM as a sponsored entity in its own
right — signage, an apparel deal, a facility naming deal — and whether anything
about that is published or is entirely CUSTOMARY.

## The ruling this pack has to end with

A priority ruling in the J3/J4 shape — rank, build-or-research, wait-a-year,
scenery — answering one question in plain words:

**After R43, what does the gym live on, and how much of it can we ship without
inventing a number?** If the honest answer is "less than the payroll costs",
say that: the fix is then the game's economy, not a fabricated cut.

## Rules

- **UNKNOWN policy, same as J1–J4:** a fee, a period, a percentage, a cap or a
  formula that is not in a primary statute, regulation, commission form, or an
  organization's own published page is **UNKNOWN**. Never invent one.
  Inherited practice is **INHERITED** / **CUSTOMARY**, not a published rule.
- No real gym's, manager's, official's, athlete's or executive's name as data.
- Do **not** reopen R40, J3 Areas 1–3, J4 E1–E3 or J3 D13/D14/D15.
- **No manager-simulator, no agency career, no second playable mode** (J2 §6.2,
  J4 E9). If it appears again it is scenery, one line, and it is dismissed.
- Number your operator calls **G1–G18** and your test assertions **G19–G34** so
  nothing collides with J3 D1–D16 or J4 E1–E34.

## Anchors (read, do not re-derive)

- `research/J4_THE_DESK_AND_THE_CUT.md` — E1–E18, the file-level anchor
  table, the priority ruling.
- `research/J2_THE_FEDERATION_PATHWAY.md` §2.6 money flow, §5.1 scenery,
  §6.2 the unplayed mode.
- `research/J3_THE_DECISION_QUEUE.md` — D13/D14/D15.
- `GameState.gd:10253` the settlement line R43 is changing, `_settle_billing`
  the weekly payroll and upkeep, `Sponsorship.gd:224` the entity branch.

## Deliverables

```
research/J5_THE_GYMS_OWN_LEDGER.md
research/CLAUDE_LAND_NOTE_J5.md
```

Push only those two (plus your `_john_delivery/` staging copies). Do not touch
`HANDOFF.md` — Claude writes your block.

## Owned files

<!-- Backfilled 2026-09-08. This file predates the owned-files gate, so `done --task` found nothing to check and passed vacuously. Every path below comes from this task file's own parse-gate command, test command, build sections and shipped deliverables - none was invented. -->

```
research/J5_THE_GYMS_OWN_LEDGER.md
```
