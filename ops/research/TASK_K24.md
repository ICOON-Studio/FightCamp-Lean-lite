# TASK K24 — WHERE THE YEAR IS SHOWN (Kalli)

**Status: COMPLETE 2026-09-07.** Delivered:
`research/K24_THE_YEAR_TURN.md`. Four rulings - selective birthday feed,
decline never named, retirement as ask plus room, the epilogue on the retired
fighter's own profile. See Kalli's block in `HANDOFF.md`.

Study only. Kalli pushes only her own
`research/` deliverable and never edits `HANDOFF.md`; Claude writes
her block.

Model: mid tier, effort medium, Fast off.

Kalli has no Windows shell, so `rtk` does not apply — use raw git. Your one
answer to "do I have a task?" is root `TASKS.md`. Read this file and nothing
else.

## Deliverable

`research/K24_THE_YEAR_TURN.md`, pushed to `master`.

## Why this exists

THE YEARS gives the game three new facts it has never had to show: a fighter
had a birthday, a fighter is past their peak, and a fighter has retired.
R51 builds the engine and deliberately builds **no screen** — the screen is a
later stage, and it should be built from a ruling, not from whatever seemed
convenient on the day. That ruling is this study, the way K10 ruled SCHEDULE
and K12 ruled OFFICE.

## The surfaces that already exist

Rule on these; do not propose a new rail item (K10's standing finding: a
drill-in is not a destination).

- **THE DAY** (`DayFeedScreen.tscn` + `ShellChrome.gd`) — the briefing. It
  already carries the attention strip and the news ticker.
- **The fighter profile** (`ProfileRevampPanel.gd`, R18) — the HERO band
  already shows age; the ACTION ROW already surfaces what needs the player
  (medical hold, open ask, weight, contract, loyalty).
- **The GYM hub squad rows** (`UIKit.squad_row`) — one line per fighter.
- **The news feed** (`_push_news`) — headlines, `push_front`.
- **The ask system** — R51 delivers a retirement as an ASK the player
  answers, not as a fighter vanishing.

## What the study must rule

1. **The birthday.** Is it an event at all, or only a number that quietly
   changes on the profile? Thirty roster fighters have thirty birthdays a
   year; say which, if any, earn a line in the feed, and what makes one
   worth reading.
2. **The decline.** How does a player learn a fighter is past their peak
   without the game insulting them with a label? Rule on whether "declining"
   is ever a word on screen, or only a shape the numbers make.
3. **The retirement.** Where the ask appears, what the player is actually
   choosing between, and what the screen owes a fighter who says yes. R45's
   post-fight screen is the nearest precedent for a moment that deserves
   room.
4. **What must NOT happen.** The standing rules that apply: no popup that
   interrupts, no invented figure, an honest empty everywhere (a fighter
   whose age the save does not carry says so). Name anything else this
   feature could plausibly get wrong.
5. **The finished career.** G9 is building `CareerEpilogue.gd` — years
   active, peak year, the defining win, an authored epitaph. Rule where a
   finished career is READ: on the profile of someone who no longer fights,
   somewhere in OFFICE, or nowhere at all until the player asks.

## How to deliver it

Words and layout reasoning, in the shape K10/K12/K20 used: the question, the
options considered, the ruling, and the one line of why. ASCII sketches are
welcome; renders are Maria's job (M11 runs beside this task). Reference kit
factories by name from `UIKit.gd` — **propose no new factory and no new
token**; if the ruling needs something the kit lacks, say exactly what and
why, and leave the building to Claude.

## Scope

A document. No `.gd`, no `.tscn`, no data file, no test, no `HANDOFF.md`
edit.

## Owned files

<!-- Backfilled 2026-09-08. This file predates the owned-files gate, so `done --task` found nothing to check and passed vacuously. Every path below comes from this task file's own parse-gate command, test command, build sections and shipped deliverables - none was invented. -->

```
research/K24_THE_YEAR_TURN.md
```
