# TASK K18 — THE DAY (Kalli)

Model: top tier, effort high, Fast off. **Study only**: no `.gd`, no
`.tscn`, no HANDOFF edit. Push your `research/` deliverables; Claude
writes your block.

## Why now

Every management surface has been rebuilt from the kit under the hub
grammar you set — GYM (K8), TRAINING (K9), SCHEDULE (K10), SCOUTING (K11),
OFFICE + STAFF (K12), the set-pieces (K7), CAREER CREATION (K13), the boot
(K14), RANKINGS (K15) and now THE RING (K16, Claude building as R31).

**THE DAY is the one surface that never got a study.** It is the default
route — `CareerRoot.DEFAULT_ROUTE = "day_feed"`, the first thing the player
sees every single session — and it is the oldest kit screen in the game:
`DayFeedScreen.gd` (55 lines) + `DayFeedPanel.gd` (255) shipped in **R17**,
before the hubs existed, before the drawer, the drill-in and the
select-then-act grammar were settled. It is kit-built, so this is not a
legacy replacement; it is the screen that has to catch up with the nine
that came after it, and it now has to absorb work two of your own studies
sent to it.

## What already exists (do not restate it, judge it)

- **`DayFeedPanel.gd`**: a briefing hero from the top headline, ticker rows
  from the next headlines, an action card holding Continue, upcoming events
  from the fight offers, and an alerts column (open requests, expiring
  contracts, injuries). Mounted at the shell's content position, 1494×846.
- **The shell owns** the rail, the top bar, the day strip and the green
  **Continue** unit — Continue is the one advance in the game
  (`advance_day`, `GameState.gd:4650`) and stays the shell's. THE DAY must
  not draw a second one.
- **`get_news(limit)`** (`GameState.gd:9608`) — headlines, `push_front`,
  newest first.
- **`get_weekly_objectives()`** (`GameState.gd:3169`).
- **`get_open_requests()`** (`GameState.gd:6260`).

## What has been sent here and is not built

1. **K12 §D**: "if attention needs a home later, it belongs on THE DAY".
2. **K17 §D**: the attention strip is THE DAY's — loyalty red/amber alerts,
   active rivalry heat bands, open grudge offers. Codex C16 is delivering
   the aggregate `get_day_relationship_attention()` for exactly this while
   you study; assume that read exists and shape the surface around it, but
   name any field it is missing.

## Rule

The player opens this screen more than any other and leaves it in seconds.
The question the study answers is **what earns a place on the one screen
every day passes through** — and what is a drill-in on a hub instead.
Attention that duplicates a hub's own badge is noise, not a briefing.

## Deliver in `research/`

- `THE_DAY_K18.html` + boards at **1920×1080**, ShellChrome (career tier,
  not the K7 set-piece frame), rail item THE DAY:
  1. **DAY** — the ordinary day, nothing wrong, Continue armed.
  2. **ATTENTION** — the loud day: striking fighter, blood-feud heat, a
     grudge offer waiting. Where the strip sits against the briefing hero.
  3. **FIGHT WEEK** — the day inside a booked week, when the set-piece
     path is what the day is for.
  4. **STATES** — contact sheet: first day of a new career (no news, no
     roster history), the day a result landed last night, an empty-inbox
     quiet day, and the week boundary.
- `K18_DIGEST.md` — the same shape as K16's: the pick and the two rejects,
  the priority order, the gold ×1 per board, the kit gaps named as
  instruments, the reads you relied on, and the blockers.

## Kit rulings that still bind

Bebas / Plex; SIZE_MIN 12; gold ×1 per board; **green = Continue only**;
the facility is a GYM; ♀ never fights ♂; silhouettes, never portraits;
invent nothing that is not in a read.

## Owned files

<!-- Backfilled 2026-09-08. This file predates the owned-files gate, so `done --task` found nothing to check and passed vacuously. Every path below comes from this task file's own parse-gate command, test command, build sections and shipped deliverables - none was invented. -->

```
research/K18_DIGEST.md
```
