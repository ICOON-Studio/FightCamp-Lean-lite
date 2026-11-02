# TASK K15 — THE RANKINGS (Kalli)

Model: top tier (Opus-class), effort high, Fast off. **Study only** — no
`.gd`, no `.tscn`. Deliverables in `research/`, pushed by you; Claude
writes your `HANDOFF.md` block. Nothing blocks this task.

## Why

`RankingsBoard.gd` (468 lines) is the **last pre-kit screen with no study
and no stage**. Six hubs have been rebuilt on your studies — GYM (K8),
TRAINING (K9), SCHEDULE (K10), SCOUTING (K11), OFFICE+STAFF (K12) — and the
three stages left all have theirs: the set-pieces (K7), career creation
(K13) and the boot (K14). Rankings has nothing.

It is also the strangest thing in the router. `rankings` is a career route
with its own `nav: "rankings"` id (`SceneRouter.gd:67`) — but
`ManagementChrome.NAV_ITEMS` has no rankings item, so **the rail cannot
reach it**. It is a destination the game builds, keeps current, and never
offers. Whether that is a bug or an accurate verdict on its importance is
the first thing your study has to settle.

## What is there today

The data is real and already served by GameState:
- `get_division_rankings(discipline, weight_class, sex)` (`:9235`)
- `get_p4p_rankings(limit, sex)` (`:9240`)
- `get_championships()` (`:9223`)
- `get_champion_superfight_offers()` (`:9289`)

The legacy board draws all three behind a discipline picker, a weight
picker, a sex switch and a tab switch (`RankingsBoard.gd:166-206`) — four
controls before the player sees a single name.

## Answer these, in this order

**A. Does RANKINGS exist at all?** Give ONE recommendation and name what you
rejected, as K8-K14 did. The real options: its own rail item; a tab of
SCOUTING (who is out there, ranked); a **WORLD** hub that finally gathers
rankings, organisations and the world's events into one destination; or
dissolved entirely, with a division's ladder shown where the player already
asks about a division. "Keep it exactly as it is, unreachable" is not one of
them — either it earns a way in or it goes.

**B. Four controls before a name.** Discipline × weight class × sex × tab is
a lot of choosing to see a list. What does the board open ON — the player's
own fighter's division, the belt they are chasing, the P4P top ten? Say what
it should default to and what the player should have to ask for.

**C. What a ranking row has to carry.** Rank, name, record, and then what?
Movement since last week, the belt, whether they are bookable, whether the
gym already has them, whether they are ahead of or behind our own fighter.
Name what earns its place and what does not.

**D. Where WE are in it.** The player's own fighters must be findable in a
world list without hunting. Say how that reads — and what the board says
when the gym has nobody ranked at all, which is the honest first-career
state.

**E. The seam out.** A ranking row is a person. Does pressing one open the
fighter card (ours), the scouting candidate (theirs), or nothing? Say which,
and be careful: SCOUTING signs people and a ranked world fighter is not
necessarily available.

**F. Champions.** `get_championships()` and the superfight offers are a real
system nobody has drawn. Is the belt list part of this board, its own board,
or a strip? K7 already owns the CROWNING set-piece — do not restate it.

**G. Kit gaps.** After trying the scouting, gym, schedule and office
families first, table what is genuinely missing, one line of need each.
Reuse before you mint. **No drag primitive.**

## Boards (1920×1080, ShellChrome)

1. **THE DIVISION** — one weight class's ladder, opened the way B says.
2. **P4P** — the cross-division list.
3. **CHAMPIONS** — the belts, per F's ruling.
4. **STATES** — the gym has nobody ranked; a division with no champion; our
   fighter ranked and visible in a world list; nothing generated yet.

## Kit rulings to obey

Bebas / IBM Plex Mono; SIZE_MIN 12; **gold once per board**; green is
CONTINUE only; `pair` is slate; the facility is a **gym**, never a camp;
**females never fight males and weight classes must match** — a ranking list
is exactly where that rule gets broken by accident, so keep the sexes'
ladders separate and say so; money is real; silhouettes, never ripped art;
body rhythm ~210. The kit book is `DesignLibrary/kit/index.html` (200
variants, 17 families) — read it before inventing anything.

## Files to deliver

- `research/RANKINGS_K15.html` — the full study
- `research/RANKINGS_K15_division.png`
- `research/RANKINGS_K15_p4p.png`
- `research/RANKINGS_K15_champions.png`
- `research/RANKINGS_K15_states.png`
- `research/K15_DIGEST.md` — short: the placement ruling and what you
  rejected, the default view, the row, where we are in it, the seam, the
  champions ruling, the kit gaps, and any GameState read the build will need
  that does not exist yet.

Push only your `research/` deliverables. Do not edit `HANDOFF.md`,
any `.gd` or any `.tscn` — Claude writes your block and does the build.

## Owned files

<!-- Backfilled 2026-09-08. This file predates the owned-files gate, so `done --task` found nothing to check and passed vacuously. Every path below comes from this task file's own parse-gate command, test command, build sections and shipped deliverables - none was invented. -->

```
research/RANKINGS_K15.html
research/RANKINGS_K15_division.png
research/RANKINGS_K15_p4p.png
research/RANKINGS_K15_champions.png
research/RANKINGS_K15_states.png
research/K15_DIGEST.md
```
