# TASK C27 — THE GYM LEDGER READ (Codex)

**Status: OPEN, assigned 2026-09-06. Depends on R43 (`d5c688a`) and on J5,
both on `master`.** Read the contract below against the real files before you
start.

Model: Sonnet, effort medium, Fast off. This is the C4 / C7 / C19–C26 pattern
for the ninth time: one read, no writes, no UI, honest empties — with one new
requirement that is the whole point of the task (`source` labels).

## Why this exists

R43 moved the money. `GameState.gd:10253` used to bank one hundred percent of
a fighter's purse in `gym["cash"]`; the payee is now the athlete, in
`athlete["cash"]`, read by `get_athlete_cash()` (`:10275`). J5 then ruled what
the gym is honestly left with, and the answer is uncomfortable: **membership
dues have no published number and are not authored, the manager share is $0
until three gates pass, corner work pays the gym nothing, and the only live
credit is an invented sponsorship cheque** (`Sponsorship.settle_week`, banked
at `GameState.gd:5116`, magnitude `TIER_WEEKLY_CASH` 250/400/650/1000 plus
`(roll % 3) * 25` — invented, `Sponsorship.gd:13,209`).

**Nothing in the game can see any of this.** The one money read that exists,
the office projection at `GameState.gd:2799–2841`, returns
`"weekly_projection": -(upkeep + payroll)` — a number with **no inflow term at
all**. It was never wrong before R43 only because the purse quietly covered
the gap. R43 measured the real hole with the settlement instrumented: a starter
gym with no fights burns its $25,000 float in 26 weeks and ends at **-$5,342**,
collecting $0 in sponsorship because no deal is signed.

One read, so that a screen — and the next build stage — can ask what the desk
actually earns and spends, and can be told which of those numbers the game
made up.

## What to build

A new pure module `Godot/scripts/GymLedgerRead.gd` plus wrappers in
`Godot/scripts/GameState.gd`, in the read-API region beside the other
`get_*_read` functions:

```gdscript
func get_gym_ledger_read() -> Dictionary
func get_gym_ledger_week_read(week: int) -> Dictionary
```

`get_gym_ledger_read()` returns the standing picture:

- `cash` — `gym["cash"]` today.
- `inflow` — an Array of line dictionaries, one per KIND of money in, each
  `{"id", "label", "weekly_amount", "source", "why"}`.
- `outflow` — the same shape for money out: payroll (`weekly_salary` over
  roster and staff, `:5108–5111`), floor upkeep (`weekly_upkeep`,
  `:2799–2801`), and anything else already accrued by `_settle_billing`.
- `net_weekly` — inflow minus outflow, the number `weekly_projection` should
  have been.
- `runway_weeks` — `cash / net_weekly` when net is negative, `-1` when it is
  not. Integer weeks, floor. **Do not invent a bankruptcy threshold**; nothing
  in the game reacts to negative cash and this read does not start.
- `billing` — what `_settle_billing` is currently holding: accrued payroll,
  accrued upkeep, and the week the month's bill leaves the account.
- `athlete_cash_total` — the sum of `get_athlete_cash()` over the roster, so a
  screen can show that the money did not vanish, it moved.

### The `source` field is the task

Every line in `inflow` and `outflow` carries `source` ∈
`{"evidenced", "invented", "absent"}` and a one-sentence `why`. This is J5
G23–G28 made readable:

- `"invented"` — the game authored this number with nothing behind it. The
  sponsorship cheque is the flagship case (G16): keep it, label it.
- `"absent"` — a real line of a real gym's ledger that this game does **not**
  author because no number is published. Membership / training-floor dues
  (G1, G3) and corner fees (G11–G13) are `absent` with `weekly_amount = 0`.
  **They must appear in the array anyway.** A missing line reads as "gyms
  don't have members"; an `absent` line reads as "we know, and we refuse to
  make one up", which is the honest state and the whole reason J5 exists.
- `"evidenced"` — a number with a citation. Nothing qualifies today. The
  manager-share cap in `Godot/assets/data/manager_share_caps.json` is
  evidenced but it is a **cap, not a take** (J5 G9), so it is not an inflow
  line; expose it, if at all, as `manager_share_cap` metadata, never as money.

`get_gym_ledger_week_read(week)` is the same shape for one settled week rather
than the standing rate, so a screen can show a specific week. If nothing is
recorded for that week, return the standing shape with an `empty` flag — do
not fabricate history.

## Rules

- **Read only.** No settlement, no billing, no wallet is touched. If a value
  is not already stored, it is not in the read.
- **No new money.** You author no dues, no cutman percentage, no naming-rights
  figure, no gym cut of a purse (J5 G1, G10, G11, G14). A gym taking ≥ 10% of
  a gross purse *is* a manager (J4 E3) and is not this read's business.
- **The default gym delta from a purse is 0** (J4 E23). If your `inflow`ever
  shows purse money, the read is wrong.
- Honest empties everywhere: no roster → zero payroll, not a guess; no
  sponsorship deal → `weekly_amount` 0 with `source: "invented"` still on the
  line, because the *rate* is what was invented.
- No UI, no `.tscn`, no screen edits.

## Files you own

- `Godot/scripts/GymLedgerRead.gd` (new)
- `Godot/scripts/GameState.gd` — **the read-API region only.** Claude is in
  the settlement and billing region for R44 this cycle; do not edit
  `_settle_billing`, `advance_week`, or anything under `:5100–5120`.
- `Godot/tests/gym_ledger_read_test.gd` (new)

## Parse gate (before any test run)

```
python Godot/tools/check_scripts.py Godot/scripts/GymLedgerRead.gd Godot/scripts/GameState.gd Godot/tests/gym_ledger_read_test.gd
```

## Test

```
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/gym_ledger_read_test.gd
```

Cover at least: the read never mutates (run each accessor twice against an
isolated Career copy and compare — this is the Q8 defect C26 shipped with and
then fixed); every inflow and outflow line carries a `source` in the three
allowed values; membership and corner-fee lines are present with
`source: "absent"` and amount 0; no line reports purse money; `runway_weeks`
is -1 when net weekly is non-negative; the sponsorship line is labelled
`invented`; `athlete_cash_total` matches the sum of `get_athlete_cash()`.

Then the full suite once, and report the counts.
