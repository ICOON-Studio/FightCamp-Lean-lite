# TASK U2 — WHAT THE YEARS COST, AND WHO IS TOLD (Cursor)

**Status: COMPLETE (2026-09-07, `11c1470`).** A study that rules a surface before it
is built. **Run this AFTER U1** — one task per session, and U1 is the one R54
is waiting on. This one blocks nothing, so it can wait a day.

Model: mid tier, effort medium, Fast off. One session.

## You are holding Kalli's seat this cycle

Kalli rules how a system is SHOWN before anyone builds it — K24 ruled the
birthday and the retirement ask, K25 ruled where a finished career lives and
what an honest number looks like. Kalli is not running this cycle, and R54 is
about to change two numbers with no ruling behind them at all.

Read `research/K25_AFTER_THE_LAST_FIGHT.md` first (91 lines). It is
short, it is the format you are writing in, and its honest-number table is the
thing you are extending.

## Deliverable

`research/U2_WHAT_THE_YEARS_COST.md`. **Study only.** No `.gd`, no
`.tscn`, no `assets/data`, no `HANDOFF.md` — Claude writes your block.
**No new rail item, no new UIKit factory, no new token.**

## Why this exists

R54 will make age cost something in two places that today ignore it entirely:

- **Recovery.** `BodyReadiness._apply_recovery()` heals every body the same
  way regardless of age. R54 adds an age factor.
- **Price.** `Retention.market_salary()` is `base + rating + fame/divisor`
  with **no age term**, so a 41-year-old and a 23-year-old of the same rating
  cost the same. R54 adds one.

Both will be **AUTHORED and UNKNOWN** — J10 ruled wage-by-age unsourceable, and
whether recovery is sourceable at all is what U1 is deciding. So the game is
about to show the player two numbers it does not actually know, on surfaces
that currently read as fact.

## The questions

**Q1 — Does the player see the age effect on recovery at all, or only feel
it?** K24's law is absolute: **decline is never a word.** Never "declining",
never "past peak", never "washed". A veteran taking longer to heal is real and
the player must be able to plan around it — but "this fighter is old" must
never appear. Options to weigh: silent (the weeks are simply longer), a
neutral surfaced figure (the forecast says six weeks and means it), or an
explicit but wordless mark in M11's ink ladder. **Rule one.**

**Q2 — The forecast is the honesty problem, not the number.**
`BodyReadiness.forecast_weeks_to_training()` already tells the player how long
a recovery will take. If R54 applies an age factor in `_apply_recovery` but not
in the forecast, the game promises four weeks and takes six — it lies. Rule
what the player is owed: does the forecast carry the age factor, and if a
figure is authored rather than known, does that change what the forecast may
claim?

**Q3 — Price.** A veteran costing less (or more) is a real negotiating fact the
player acts on. Where does an age-adjusted salary show, and does the player
ever see WHY it moved? K25's honest-number table says UNVERIFIED_SECONDARY
prints MUTED with an optional one-line `why` on detail surfaces and never on
`squad_row`. **Does an authored-UNKNOWN figure the game invented outright
deserve the same treatment, a stronger one, or none?** That row does not exist
in K25's table and it is the main thing you are adding.

**Q4 — Does an authored number get the same grammar as a sourced one?** R52
gave `Aging.gd` a `grade_for()` so a screen can say what it does not know.
K25's table covers DIRECT / INHERITED / UNVERIFIED_SECONDARY / UNKNOWN as
*research* grades. An AUTHORED game constant is a fifth thing: not researched,
not unknown, deliberately invented for play. Rule whether the player is ever
told, and be honest about the cost of telling them — a screen covered in
hedges is worse than the quiet lie.

**Q5 — Where it must NOT appear.** Name the surfaces that stay clean. K25
already refuses `squad_row` for `why` lines; say what else.

## The bar

- **Options considered, then one ruling**, in K25's shape: A / B / C, the
  ruling, and the reason it beat the others. A study that lists options and
  does not rule is not deliverable.
- Every ruling names the existing token or factory it uses. `SELECT` does not
  exist in `UITokens.gd`; the family is `GYM_DEFAULT` / `LINK` / `CHIP` /
  `TRACK` / `MUTED` / `DIM` / `TEXT` / `TEXT_2` / `LINE_SOFT`.
- **Wear is not the medical family**: `TRACK` recess plus `LINE_SOFT` and DIM
  ticks. Never BAD / AMBER / GOOD — those belong to injury and readiness.
- Close with a "Claude acts on this" paragraph at the top, the way K25 does,
  so R54 can be written from the first screenful.

## Done

```
git add -- research/U2_WHAT_THE_YEARS_COST.md
git commit && git push origin master
python Tools/agent_comms.py send --from cursor --to claude --topic "U2 landed" --body "<one line: the ruling on whether an authored number is marked>"
```

## Owned files

<!-- Backfilled 2026-09-08. This file predates the owned-files gate, so `done --task` found nothing to check and passed vacuously. Every path below comes from this task file's own parse-gate command, test command, build sections and shipped deliverables - none was invented. -->

```
research/U2_WHAT_THE_YEARS_COST.md
```
