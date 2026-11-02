# R44 — THE MEMBERSHIP (Claude) — COMPLETE 2026-09-07

The gym has an inflow for the first time. R43 moved the purse to the fighter
and refused to invent a `gym_cut`; J5 then named what a real gym actually
lives on — **the training floor, not the purse** — and nothing had been built,
so `weekly_projection` was literally `-(payroll + upkeep)`: a projection with
no inflow term in it at all. That is fixed.

## The rule

**A gym has members, members pay the floor weekly, and every dollar of it is
labelled authored** — because nothing published says what a fight gym charges.
J5 G24 forbids a sport-wide dollar without evidence, so the rate is authored
the way Sponsorship's tier cheques are: present, spendable, and `invented` on
every read that shows it. No number here was hunted for and no real gym is
being quoted.

## What shipped

- **`Godot/scripts/Membership.gd`** (new, pure, no RNG). The count is a
  function of the gym the player already owns — reputation, gym tier, floor
  room tier, equipment on the mat — clamped at an authored ceiling. It **can**
  walk toward that target a capped step a week; **it does not, as shipped** —
  see the disagreement section below.
  `settle_week(career, overrides)` takes the same `overrides` dict the weekly
  `_advance_*` helpers take, so a test pins members/target/rate and reads an
  exact dollar back. The module never touches `gym["cash"]`; the caller
  credits it, which is why a projection and a settlement can share it.
- **`Godot/assets/data/membership.json`** (new), in `championship_rules.json`'s
  shape: nine magnitudes, each with a `_note` saying GAME RULE / authored /
  invented, no organization's name anywhere on it (J1 §4.1), and a closing
  `source_rule` saying this file is where the number changes if a later stage
  ever evidences one.
- **The weekly pass credits it** in `_settle_billing`, the same week and the
  same dict as the cost it offsets. Dues are **weekly** — the floor pays
  whether or not the calendar month turned — so they go to cash rather than
  into the monthly accrual. `advance_week` surfaces `membership_income` and
  `membership` next to `sponsorship_income`.
- **`weekly_projection` gained the inflow term at both sites**: the save
  summary (`weekly_membership_dues`) and the office desk
  (`weekly_membership_dues`, `weekly_membership_count`). The net is still
  allowed to be negative — this was a truth pass, not a difficulty pass.
- **`GymLedgerRead.gd`**: the `membership_dues` line C27 shipped as an honest
  `absent` zero now carries real money and `source: "invented"`, with a `why`
  that names the count and the authored rate. `net_weekly` counts both
  inflows; the read also exposes `membership_count` and
  `membership_weekly_rate`.
- **The J6 rider (A17 / A18) and nothing more**: the opaque `expenses` local
  in the settlement is now `athlete_travel_expenses`, the settlement log row
  carries `athlete_travel_expenses`, and `FightContract.settlement_for`'s
  doc-comment says plainly what it is — the fighter's own uncovered travel and
  accommodation, never a promoter skim, commission cut, tax or gym share.
  **`settlement_for` and `payee_split` arithmetic is untouched**; `R44 Q30–Q32`
  and R43's own `purse_payee_test.gd` both hold it.

## Numbers, so they can be argued with

A day-one gym — reputation 0, tier 1, one room, the ten starter floor items —
carries **78 members at an authored $12/week = $936/week**, and as shipped it
carries them for good. Against M8's drawn run rate of about $1,167/week the gym
is still under water, by about $230 a week instead of the full $1,167. It no
longer crosses zero with nothing in the game having anything to say about it,
and membership is a floor to stand on rather than a growth curve.

## The disagreement, and how the operator settled it

**J8 landed after R44 was specified and rules the other way.** N2 / N3 read the
published record as a **flat** credit whose member count never moves, and N21
calls never-moving the more honest reading; the R44 spec asked for a count that
answers to reputation and the facility and walks gradually. Both are labelled
invention — N21 permits movement only as labelled invention, which is exactly
what this is — so neither is dishonest, and I built the spec I was given rather
than quietly narrowing it to J8's preference.

**Operator decision 2026-09-07: FLAT.** `weekly_drift_fraction` is `0` and the
count does not move. J8's reading won.

The choice is data, not code — one value in `membership.json`, documented in
its `flat_count_rule`. Set it back to `0.25` and the walk returns with nothing
else touched. `membership_test.gd` forces both settings and passes under
either, so neither reading can rot: the walk is covered while flat is shipped,
and the freeze stays covered if the walk is ever turned back on.

Two properties make the switch safe later. The save records `target` **every
week even while flat**, so a mid-career switch already has its data. And
`step_members` closes the accumulated gap gradually rather than snapping — a
gym that has grown to a target of 138 while parked at 78 climbs at 6/week for
ten weeks, which reads as word getting round rather than as a cliff.

## Out of scope, and stayed out

No `gym_cut` and no percentage of any purse (J4 E3 / J5 G10 / J6 A16 — R44
Q28 asserts none can appear as gym inflow). No bankruptcy, no game-over, no
negative-cash consequence. No membership UI — M8 is the grammar and the screen
is a later stage. No commission cut, tax, trainer or cutman percentage, no
medical or licence dollar. The C28 read-API region was not touched.

## Tests

`Godot/tests/membership_test.gd` — **36/36**, run under both the flat and the
walking setting. Full suite green.

**Six regressions that only passed after being edited — all six encoded the
no-inflow defect**, and all six were rewritten to assert what they were
actually about rather than to restore the old number:

1. `gym_ledger_read_test.gd` **Q4** expected `net_weekly == -900`, i.e. the
   sponsor was the gym's only income. Now measured against both inflows.
2. `gym_ledger_read_test.gd` **Q8** asserted membership dues were an *absent
   zero*. They are `invented` and non-zero — the same honesty, one state on.
3. `office_hub_api_test.gd` asserted the desk projection was **cost alone**.
   That assertion *was* the defect. It is now inflow minus cost.
4. `day_clock_test.gd` expected cash **unchanged** across a mid-month
   rollover. What that check was always about — nothing is *billed*
   mid-month — survives; the weekly dues are added to the expectation.
5. `smoke_test.gd` predicted `before_cash - billed` across `advance_week` —
   cost alone again. Now `- billed + membership_income + sponsorship_income`.
   Codex, running C29 against a mid-edit tree, independently hit this one
   (`membership_income=1212`, cash 2721 → 3933) and held rather than guessing.
6. `sponsorship_test.gd` asserted the settlement was `- billed + sponsor`,
   i.e. that **the sponsor was the gym's only income**. Both inflows now.

That six tests all had to be rewritten is the measure of how deep the
assumption ran: every one of them was, without saying so, asserting that a gym
earns nothing.

## Test command

```
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/membership_test.gd
```
