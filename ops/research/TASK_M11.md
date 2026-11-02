# TASK M11 — THE LONG CAREER: AGE, WEAR, AND THE LAST WALK (Maria)

**Status: COMPLETE 2026-09-07.** Delivered and landed by Claude on the
operator relay: `research/M11_THE_LONG_CAREER.md` plus six boards at
`DesignLibrary/screens/long_career/m11_01..06`. The ruling is age = ink
weight, never hue; wear never borrows M6's medical family; no new token. See
Maria's block in `HANDOFF.md` for the token map and the one build-time
correction (the hero mock's "peak 2019" is impossible - the epoch is 2026 and
the real figure comes from G9's `CareerEpilogue.peak_year`).

Art direction. Maria pushes only her own deliverables and never edits
`HANDOFF.md`; Claude writes her block.

Model: top tier, effort medium, Fast off. One delivery.

Maria has no Windows shell, so `rtk` does not apply — use raw git. **Your one
answer to "do I have a task?" is root `TASKS.md`**, never `HANDOFF.md`. Read
this file and the `## MARIA START HERE` slice, nothing else — and never a
local stale copy of `HANDOFF.md`.

## Deliverable

`research/M11_THE_LONG_CAREER.md` plus any boards to
`DesignLibrary/screens/long_career/m11_*`. Delivery route is OPERATOR RELAY,
as M2-M10 were: pack plus manifest in one delivery, Claude lands it.

## Why this exists

THE YEARS is landing: fighters get birthdays, decline past a peak, and
retire (R51, C34). Every one of those is a visual problem the kit has never
had to solve. M6 gave the medical family its grammar (`GOOD` / `AMBER` /
`BAD`), M7 gave the belt `SODIUM` and `ICE`, M8 gave money its evidence
grammar. **Age is none of those**, and this is the pack that says what it is
instead.

R50 has just set the precedent worth extending: sourcing quality was banded
by **ink weight rather than hue**, because every hue in this game already
means something else. Age may want the same discipline, or it may want
something you can argue for better — that argument is the deliverable.

## What the pack must answer

1. **How does age READ?** A 21-year-old prospect and a 36-year-old veteran
   appear in the same `UIKit.squad_row`, the same profile hero, the same
   scouting row. What is different about them on screen, using only what the
   kit already has?
2. **Wear versus sheen.** Is there a treatment for a body that has taken
   years of damage that does not slide into the medical family's red? M6
   owns injury; age is not injury and must not borrow its colour.
3. **The last walk.** A retirement is the end of something the player spent
   real hours on. R45's post-fight screen is the precedent for a moment
   given room. Art-direct that moment: what is on it, what is emphatically
   NOT on it, and how it avoids being maudlin.
4. **The finished career.** G9's `CareerEpilogue.gd` produces years active,
   a peak year, one defining win and an authored epitaph. Direct how a
   finished career is presented — a card, a plate, a page — so it reads as a
   record and not as an obituary.
5. **The refusals.** Name the treatments you considered and rejected. The
   rejected list is what stops the next person re-proposing them.

## Standing constraints

- **No new token and no new UIKit factory.** Work inside `UITokens.gd` as it
  stands. If the direction genuinely needs a token that does not exist, make
  that case explicitly and separately, with what it costs; do not assume it.
- Ripped or third-party art never ships. Everything is drawn, code-drawn, or
  from the licensed sets already in the repo (Lucide, flag-icons).
- One figure once per screen; pair blocks never in the header colour; age in
  the header — the standing design rules from feedback 2026-09-04-03.
- The visual bar is the R18 profile
  (`DesignLibrary/screens/profile_revamp/`), the only previews the operator
  has approved.
- Females never fight males, and a veteran is not a caricature: no toothless
  greybeards, no shorthand for "old".

## Scope

Art direction and boards. No `.gd`, no `.tscn`, no test, no `HANDOFF.md`
edit, and no block drafted for this file — Claude writes it when the pack
lands.

## Owned files

<!-- Backfilled 2026-09-08. This file predates the owned-files gate, so `done --task` found nothing to check and passed vacuously. Every path below comes from this task file's own parse-gate command, test command, build sections and shipped deliverables - none was invented. -->

```
research/M11_THE_LONG_CAREER.md
```
