# TASK M10 — THE BOOKS, THE SCREEN (Maria)

**Status: ASSIGNED 2026-09-07.** Art only. Depends on M8 (`b508488`), C27
(`5afdfed`), C28 (`aa36e27`) and R44 (`b4b2207` + `e26823d`).

Model: top tier, effort medium, Fast off. One delivery.

## Why this exists

M8 gave the money its **grammar**: EVIDENCED = TEXT, INVENTED = LINK, ABSENT =
MUTED, a falling balance = DIM, and the AUTHORED chip that lets the game admit
a number it made up. That pack is a chip family and a token map. It is not a
screen, and **there is still no screen** — the two wallets exist only inside
`get_gym_ledger_read()` and `get_athlete_purse_read()`, which nothing but the
tests has ever called.

Two things have landed since M8 that the grammar has never been drawn against:

- **R44 shipped the gym's first inflow.** A flat, labelled weekly membership
  credit: `membership_count × membership_weekly_rate`, both authored, both
  wearing your INVENTED = LINK candour because J5 G24 forbids a sport-wide
  dollar without evidence. J8 N2/N3 froze the count deliberately — **the
  number does not move, and the screen must not imply it is about to.**
- **C28 broke the purse open.** Per-bout rows: gross bout-agreement money, the
  weight fine if the scale took one, the logistics debit **named honestly** as
  the fighter's own uncovered travel and accommodation (J6 A1 — not a
  commission, not a tax, not a gym cut), the manager share, and what landed. A
  share that was never collectible is a present **$0** row, never a missing
  one.

And the fact that started the arc is still true and still invisible:
`weekly_projection` slid **$25,000 to -$5,342 over 26 weeks** and nothing in
the game reacted. `get_gym_ledger_read()` now returns `net_weekly` and
`runway_weeks`. Nobody has drawn what a gym looks like six weeks from zero.

## What to build

The composed surface, the way `m4_05_screen_composed.png` composed the
post-fight read: **one desk screen, two wallets, at 1920×1080.**

- **The gym's week** — cash now, the inflow side (membership, sponsorship) and
  the outflow side (payroll, upkeep) as C27's labelled lines, each carrying
  its own `source ∈ {evidenced, invented, absent}` chip. `net_weekly` is the
  number the screen is built around.
- **Runway.** `runway_weeks` is a countdown to a gym that cannot pay itself,
  and `-1` means it is not falling. Draw both. This is the screen's one piece
  of drama and it must be **legible without being a warning** — the gym is not
  broken, it is losing money, and those read differently. AMBER is a
  recoverable warning and BAD is M6's hold; decide which (if either) a falling
  runway may wear, and say why in the token map.
- **The fighter's purse beside it** — C28's per-bout rows, newest first, with
  the `$0` refusal row drawn as a refusal and the logistics debit labelled in
  the words J6 insisted on.
- **The two wallets are not one wallet.** R43 moved the purse to the fighter;
  the screen's whole job is that these are separate books that meet only at
  the desk. Do not draw a total.
- **The honest empties**: a career with no bouts, a gym with no sponsor, a row
  from before a key existed. M8's ABSENT = MUTED governs all three.
- Boards to `DesignLibrary/screens/books/m10_*` (alongside M8's `m8_*` in the
  same folder), 1920×1080, code-drawable from `UITokens.gd`.
- The rejects page. M7's, M8's and M9's rejects pages are why those packs
  landed clean.

## Out of scope

- No `.gd`, no `.tscn`, no `HANDOFF.md`, no `Godot/assets/data/` edits.
  **Claude writes your HANDOFF block after the land** — do not edit that file.
- **Do not reopen M8's token calls.** EVIDENCED / INVENTED / ABSENT are
  decided; you are composing with them, not re-litigating them.
- **No number the engine does not have.** No projection curve, no growth line,
  no member-count trend, no forecast — J8 N3 froze the count and N19/N20
  refused churn and seasonality outright. A chart of a flat number is a lie
  with axes on it.
- No `gym_cut` anywhere on the screen: J4 E1–E3 and J5 G10 killed it twice.
- No bankruptcy state, no loan, no "you are broke" screen. R44 shipped an
  inflow, not a fail state, and art must not invent one.
- No rail placement ruling — where this lives is a build call, not this pack's.

## Done

Push your deliverables only (spec `research/M10_THE_BOOKS_THE_SCREEN.md`
plus boards). Message Claude when they land; Claude writes the HANDOFF block
and marks the task done.

## Owned files

<!-- Backfilled 2026-09-08. This file predates the owned-files gate, so `done --task` found nothing to check and passed vacuously. Every path below comes from this task file's own parse-gate command, test command, build sections and shipped deliverables - none was invented. -->

```
research/M10_THE_BOOKS_THE_SCREEN.md
```
