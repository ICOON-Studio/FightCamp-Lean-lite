# TASK U49 — CURSOR — THE FIFTH RULE, THE ONE U48 SAID WAS MISSING

Model: cursor-agent, **medium** effort. Owner: cursor.

**Tier: EXTEND YOUR OWN `Godot/tools/measure_choose_rules.gd`. No `.gd` in
`scripts/`, no test.** Parse gate it, run it. **DO NOT RUN THE SUITE.**

## Why this exists — your own report asked for it

U48 (`5feeabf`, yours) priced four selection rules and recommended **keep
`current`**, and the reasoning from the loss column is sound: `defence_eligible`
costs **80 of 107 knockdowns** and 6,670 of 9,035 cleans, and `wear_blind` proves
the wear tiebreak is doing real work rather than merely hating blocks — without it
**31.9% of shown beats are `missed`**, which is the sharpest single line in the
report.

Then you wrote the sentence that makes this task:

> "A rule that never overrides knockdown/shocked, and only promotes
> blocked/slipped among the wear remainder, was **not** in this measurement set.
> If defence on screen remains a goal after reading these costs, that is the next
> harness — not `defence_eligible`."

**That is correct, and the gap was in R103's spec, not in your work.** All four
rules I gave you could override a knockdown, so all four bought defence with the
one thing the adapter's own comment says must never be dropped. The operator is
about to be handed a price list with the only sensible option missing from it, and
they would have to ask and wait. **Price it now so the decision can be made once.**

## The rule

**`promote_in_remainder`** — identical to `current` in its first two tiers:

1. a `knockdown` candidate still wins the window, always;
2. a `shocked` candidate still wins next, always;
3. **only when the window has neither** does a `blocked` or `slipped` candidate
   win, in place of the highest-wear one.

So it is strictly `current` plus a re-ranking **inside the wear remainder only**.
`kd_lost` must come out **0 by construction** — and you must assert that in the
output rather than assume it. If it is not 0, the implementation is wrong, not the
rule.

Also report the natural variant, because the remainder may be large enough that
promoting every defensive candidate in it still costs more cleans than the operator
wants:

**`promote_in_remainder_4`** — the same, but promoting only every 4th eligible
remainder window, so the cost column can be read against `alternating_4`'s 26
knockdowns lost and 1,605 cleans lost.

## What to report

**The same table and the same denominators as U48**, with the two new rows added
to it — so U48 and U49 are one column of the same quantity and the operator reads
one table, not two. Per ruleset and pooled, 40 bouts, the same seeds: `block+slip`
as a count AND as a share of **that rule's own shown population** (named on the
line), `clean_lost`, **`kd_lost`**, `sig_lost`, and the receiver-role mix.

**And restate the byte-identical assertion.** The seeded outcomes, scorecards and
method of victory must be identical across all six rules on one seed; you are
re-ranking candidates inside windows that already happened, and your harness draws
no RNG. Print it.

## What this task must NOT do

**Do not change `_choose` or any other script, and do not recommend shipping
anything on your own authority.** The question — whether defence belongs on screen
at all — is the operator's, and U48's job was to price it, not to settle it. U49's
job is to finish the price list. **If `promote_in_remainder` turns out to buy very
little defence** (the remainder may be thin once knockdown and shocked are taken),
**that is the answer and it argues for keeping `current`** — say so plainly. A
recommendation that hides its cost is worse than none; so is one that hides its
own futility.

## Owned files

- `Godot/tools/measure_choose_rules.gd` — yours, extend it.
- `research/U48_WHAT_THE_BROADCAST_REFUSES.md` — yours, **update the tables
  in place** and add a short U49 section. Do not start a second document.

**DO NOT EDIT** anything in `Godot/scripts/`, anything in `Godot/tests/`, or
`HANDOFF.md`.

## Anchors

- `Godot/tools/measure_choose_rules.gd` — your own harness.
- `research/U48_WHAT_THE_BROADCAST_REFUSES.md` — your own report.
- `Godot/scripts/FightBeatAdapter.gd` — `_choose`, `_first_where`, `_wear_total`.
  **READ-ONLY.**

`GameState.gd` is ~13,000 lines and is not involved — never open it whole.

## Gate

```
python Godot/tools/check_scripts.py Godot/tools/measure_choose_rules.gd
```

then run it. **rc=0 IS NOT A PASS** — read the output. `N RID allocations` and
`N resources still in use at exit` are teardown chatter.

## Report

Commit (explicit paths only, never `audio_exports/`), push **MASTER**, then
`python Tools/agent_comms.py send --from cursor --to claude --subject U49-done`
with `promote_in_remainder: block+slip% / clean_lost / kd_lost` and the same for
the `_4` variant. Do not edit `HANDOFF.md`.

## The trap specific to this task

**`kd_lost = 0` IS THE CLAIM, SO DO NOT LET IT BE VACUOUS.** A rule that never
reaches tier 3 because of a coding slip also reports `kd_lost=0`, and it would look
like a success. **Assert by occurrence**: print how many windows actually REACHED
the promotion branch and how many promotions actually happened. If that count is
zero the rule did nothing and the `0` means nothing — this project has shipped six
pieces of correct, tested, unreachable code on exactly that confusion.
