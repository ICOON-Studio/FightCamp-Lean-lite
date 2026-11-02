# TASK K23 — THE BELT, HOW IT READS (Kalli)

**Status: OPEN, assigned 2026-09-06.** Study only. Depends on R41, C26
(`c320496`) and M7, all on `master`.

Model: top tier, effort medium, Fast off.

## Why this exists

Three pieces of the championship arc have landed and none of them is on a
screen. R41 made a title bout a **decision written when the bout is booked**
(`is_title_bout`) rather than a fact discovered from the result, and gave every
belt `title_status ∈ {vacant, champion, interim}`. C26 shipped the read —
`get_championship_read(division_key)`, `get_championships_read()` and
`get_bout_title_stakes(event_id, bout_index)`, with both holders exposed when a
division is interim, the reign fields, and the top five contenders. M7 dressed
it: one mark family at three fills, SODIUM for the recognised champion, ICE
outline for the interim, a MUTED plate for vacant, SELECT for a title bout on
the calendar.

**Nobody has ruled where any of it lives.** That ruling is this study, and it
is what the build stage after it is written from. K15 did exactly this for the
rankings — it found that the route existed and the rail had forgotten it — and
that ruling is what R30 was built on.

## What to rule

1. **Where the championship surface lives.** Its own rail item, a tab under
   RANKINGS, or a drill-in off a division? Argue it. The rail is finite and
   every item added is one the player has to learn; K15 already put RANKINGS
   on the rail and the belts and the ladder are arguably the same subject seen
   twice. Say which, and say what it costs.
2. **List versus drill-in.** There are eighteen organizations and belts keyed
   `discipline|weight_class|sex`, so the list can be long. What does the
   overview row carry, what needs the drill-in, and where do the top five
   contenders belong.
3. **Interim beside champion.** M7's hardest board. Where does that pair sit
   without a player ever reading it as two champions — the engine
   structurally cannot hold two, and the interim is consumed by unification.
   Is the interim visible from the overview row or only in the drill-in?
4. **The title bout before it is fought.** R41 writes the flag at booking, so
   the calendar can say a bout is for the belt in advance. Where does that
   appear — schedule, the event card, the fight-night frame, the fighter's own
   card — and how does an ordinary bout with the champion in it stay
   distinguishable from a title fight (it is not one).
5. **`stamped`, the honest field.** An announced open slot has no second name
   yet, and a pre-R41 bout on an old save carries no flag. C26 refuses to
   flatten either into "not a title bout". How does the UI say "not decided
   yet" without saying "no"?
6. **The reign.** `defenses`, `since_week`, `last_defended_week` — which of
   these earns space, and where.
7. **What the belt does to the surfaces that already exist.** The fighter
   card, the rankings hub, the schedule hub. Name the file and the line for
   each place that would change, and say whether it is worth changing.
8. **Kit gaps.** List the UIKit variants the build will need that do not exist
   yet, as K10 / K11 / K15 did.

## Rules

- Study only. No `.gd`, no `.tscn`, no `HANDOFF.md`, no data edits. Claude
  writes your block.
- Read C26's read shape and M7's spec before ruling; do not re-derive either,
  and do not propose art — M7 owns the visual language.
- Do not propose a second belt object, a dual-champion state, or a
  belt-on-the-scale rule (that is R42 and already scheduled).
- Rank your recommendations. A stage gets built from the top of your list.

## Deliverable

- `research/K23_THE_BELT_HOW_IT_READS.md`

Push only that file. Message Claude on the mailbox when it lands.

## Owned files

<!-- Backfilled 2026-09-08. This file predates the owned-files gate, so `done --task` found nothing to check and passed vacuously. Every path below comes from this task file's own parse-gate command, test command, build sections and shipped deliverables - none was invented. -->

```
research/K23_THE_BELT_HOW_IT_READS.md
```
