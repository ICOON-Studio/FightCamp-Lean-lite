# TASK K25 — AFTER THE LAST FIGHT, AND THE HONEST NUMBER (Kalli)

**Status: COMPLETE (2026-09-07).** Landed `44d5c5b`. A study that rules a surface BEFORE
it is built, the way K10 ruled SCHEDULE and K24 ruled the year's turn.

Model: mid tier, effort medium, Fast off.

Deliverable: `research/K25_AFTER_THE_LAST_FIGHT.md`. **Push only your
own research file. Never edit `HANDOFF.md`** — Claude writes your block.

## What already exists, so you rule rather than invent

- **R51b shipped (2026-09-07).** A roster fighter ages, and over a pressure
  line asks to retire. The player answers GRANT or DECLINE on the existing
  request card. A granted retirement moves them off the roster and into the
  world population with `status: "retired"`, `retired_week`, `retired_age`.
  The gym keeps `career["retirements"]`, read by `get_retirements()`.
- **K24 (yours, 2026-09-07)** already ruled: decline is never a word; the
  birthday is a selective feed; retirement is the ask plus room, a beat with
  space, never a modal and never a vanish; and the finished career (G9's
  epilogue) is read **on the retired fighter's own profile**.
- **M11 (Maria)** already ruled the ink: age is INK WEIGHT, never hue.
  RETIRED is `MUTED`, not BAD and not GOLD. The epitaph wears `LINK` candour
  on a record plate, not an obituary. No new token.
- **J10 (John, 2026-09-07)** graded the numbers behind all of it. Its §2 is
  a list of 22 things that could NOT be sourced.

## Question 1 — where a finished career lives once the fighter is gone

K24 put the epilogue on the retired fighter's own profile. That answers
*where the story is read*. It does not answer **where the gym keeps them**:
after five years a gym may have retired six people, and right now the only
trace is a save key nothing draws.

Rule it:

- Does a gym-side record exist at all as a surface, or is
  `get_retirements()` a save fact that only ever surfaces one fighter at a
  time on their own profile?
- If it exists: on which destination that ALREADY exists (K10 standing: no
  new rail item, no new factory, no new token)?
- How does a player reach a retired fighter's profile at all once they are
  off the roster? That path does not exist today. Rule it, or rule that it
  should not exist.
- What does the gym's own history say about itself — a count, a list, the
  names, the belts they won while they were here? What is the SMALLEST
  version that is not sad and not a trophy cabinet?

## Question 2 — the honest number

This is the harder half and it outlives this stage.

J10 grades every figure it delivered: DIRECT / INHERITED /
UNVERIFIED_SECONDARY / UNKNOWN, plus 22 things it could not source at all.
R52 is putting those grades into `Aging.gd` so `grade_for()` can return one.
`CornerRulesRead.gd` already does the same thing in a different corner of
the codebase: it marks values `invented` or `absent` and carries a `why`.

**So the game is about to be able to say "I do not actually know this" — and
has no visual grammar for saying it.** Rule that grammar:

- When a screen prints a figure the game does not really know (a peak
  window graded UNKNOWN, an invented corner rule), does the player see the
  doubt at all, or is the honesty for the developers only?
- If the player sees it: what carries it? An ink step, a mark, a word, a
  detail line? It must work in the ink M11 already ruled, with **no new
  token**.
- What must NEVER carry it — because a screen covered in asterisks teaches
  the player to distrust everything, which is worse than the quiet lie.
- Does an UNKNOWN figure get printed at all, or withheld? Say which, per
  kind of figure.

## The bar

- Rule with reasons. A ruling nobody can build from is not a ruling.
- Name what you REFUSE, the way K24 did — a rejects list is worth as much as
  the rulings.
- No new rail item, no new factory, no new token.
- Cite the surfaces that already exist by name. Do not design a screen that
  is not there.

## Owned files

<!-- Backfilled 2026-09-08. This file predates the owned-files gate, so `done --task` found nothing to check and passed vacuously. Every path below comes from this task file's own parse-gate command, test command, build sections and shipped deliverables - none was invented. -->

```
research/K25_AFTER_THE_LAST_FIGHT.md
```
