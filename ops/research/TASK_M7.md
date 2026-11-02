# TASK M7 — THE BELT: CHAMPION, INTERIM, VACANT (Maria)

**Status: COMPLETE 2026-09-06, landed by Claude.** Art direction only. No `.gd`, no
`.tscn`, no `HANDOFF.md`, no `Godot/assets/data/` edits, no runtime bitmaps.
Claude writes your HANDOFF block and marks the task done, as with M4/M5/M6.

Model: top tier, effort medium, Fast off. Same setting M5 and M6 shipped on.

## Why this exists

**R41 landed today**, and it created a state the engine now tracks and nothing
looks like. Until this morning a title bout was decided AFTER the fight — its
entire test was whether the champion happened to be one of the two names, so a
Grand Prix quarter-final took the belt. Now:

- `is_title_bout` is written when the bout is **booked**, and read at
  settlement. A bout on the calendar already knows whether a belt is on it.
- Every belt carries `title_status ∈ {vacant, champion, interim}`.
- An **interim** exists only while the recognised champion is held out past an
  authored window, rides on the same belt entry, and is **consumed by
  unification** the moment the champion fights for it again. It is never a
  second keepable belt.

M6 dressed the medical hold — the same hold that is now the only honest reason
an interim can exist. This pack dresses what that hold does to a division.

## What to design

Eight boards, `DesignLibrary/screens/championship/`, same delivery shape as M6.

1. **The belt mark at three statuses.** One family: CHAMPION, INTERIM, VACANT.
   Readable at a rankings row's ~28 px and legible at hero size without being a
   second asset. The three must be distinguishable at a glance and never read
   as "error / warning / ok".
2. **The division header.** A division whose belt is vacant, whose champion is
   held out with an interim standing in, and whose champion is active — the
   same header, three states, no layout jump between them.
3. **Interim next to champion, without lying.** The hardest board. The
   recognised champion keeps the belt while he is held; the interim holder is a
   real name with a real claim. Show both **without** presenting two champions —
   the engine structurally cannot hold two, and the surface must not imply one.
4. **Unification.** The one bout that consumes the interim: what a card looks
   like when the champion is back and the two claims meet. This is a stakes
   board, not a ceremony board.
5. **A bout that is FOR the belt, on the calendar.** The booking-time flag is
   the point of R41: a scheduled bout must say it is a title bout **before** it
   is fought, and an ordinary bout with the champion in it must not.
6. **The reign, as a number the player earned.** `defenses`, `since_week`, and
   `last_defended_week` are all real tracked values. A defence counter that
   only moves on a real title defence is now trustworthy for the first time.
7. **Honest empties and unknowns.** A division with no belt at all (fewer than
   three fighters — the engine refuses to seed one), a vacated belt with no
   successor, an interim with no name yet. None of these may render as an
   error, and none may invent a champion.
8. **Composed.** One rankings/division surface carrying the family.

## Rules

- **Token calls only, and verify each one is present in `UIKit` / `UITokens`
  before you spend it.** Name the token, and give the written argument for it,
  the way M6 argued `BAD` for the hold.
- Gold is spoken for: **M5 spends the only gold in the pack on the verdict
  word.** If this pack wants gold for a belt, it has to argue why the verdict
  gives it up — and losing that argument is a fine outcome.
- Do **not** reuse M6's hold badge for the interim. The hold is a state a
  *body* is in; the interim is a state a *division* is in. If they look alike
  the player will read a held champion as a stripped one.
- No real federation's belt, colourway, strap or wordmark. No WBC/IBF/UFC
  likeness — the catalog's 18 are ours (J1 §4.1).
- One rejected anti-pattern board, kept deliberately, as M6 kept the medical
  chart. Say what it teaches.
- Boards are **direction, not runtime bitmaps.** The surface will be code-drawn
  from UIKit against `get_championships()`.
- The facility is a **gym**, never a "camp".

## Anchors

- `Godot/scripts/WorldPopulation.gd` — `TITLE_STATUS_*`, `apply_title_logic`,
  `may_crown_interim`, `_consume_interim`, `vacate_title`.
- `Godot/assets/data/championship_rules.json` — the interim window, and why it
  is labelled a GAME rule.
- `Godot/scripts/GameState.gd` — `get_championships()`, `get_athlete_titles()`.
- `DesignLibrary/screens/rankings_hub/` (K15), `DesignLibrary/screens/medical/`
  (M6, the hold this depends on), `DesignLibrary/screens/profile_revamp/` (R18,
  the visual bar).
- `research/J3_THE_DECISION_QUEUE.md` — D1, D2, Q1/Q2/Q3.

## Deliverables

```
research/M7_THE_BELT.md            (the spec, M6's shape)
DesignLibrary/screens/championship/      (eight boards)
research/CLAUDE_LAND_NOTE_M7.md
```

Push the boards and the two markdown files (plus your `_maria_delivery/`
staging copy). Do not touch `HANDOFF.md`.

## Owned files

<!-- Backfilled 2026-09-08. This file predates the owned-files gate, so `done --task` found nothing to check and passed vacuously. Every path below comes from this task file's own parse-gate command, test command, build sections and shipped deliverables - none was invented. -->

```
research/M7_THE_BELT.md
```
