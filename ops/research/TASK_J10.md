# TASK J10 — THE YEARS: PEAK, DECLINE, AND WHY CAREERS ACTUALLY END (John)

**Status: COMPLETE 2026-09-07.** Delivered `J10_THE_YEARS.md` (503 lines) and `CLAUDE_LAND_NOTE_J10.md`; landed by Claude in commit `301ae3f`. Original brief below. Research only. No `.gd`, `.tscn`, data,
test or `HANDOFF.md` file is touched by this task.

Model: top tier, effort high, Fast off.

John has no Windows shell — use the GitHub API and raw git. Your one answer
to "do I have a task?" is root `TASKS.md`. Read this file and nothing else.

## Deliverable

`research/J10_THE_YEARS.md`, pushed to `master`. Claude writes your
`HANDOFF.md` block; you never edit that file.

## Why this exists

The game is about to give fighters birthdays, decline and retirement (R51,
C34). The curve those stages apply will be **authored numbers**, and this
project has one standing rule about authored numbers: it must be able to say
where each came from and admit the ones it guessed. J1 established that
vocabulary for organization rules — `DIRECT`, `INHERITED`,
`UNVERIFIED_SECONDARY`, `UNKNOWN` — and R50 just put it on screen. **Use the
same four grades here, per claim.**

Today the code has exactly one age fact: world athletes are generated at
`age = randi_range(18, 31)`. Nothing else about age exists anywhere.

## What the study must answer

1. **Peak.** At what ages do combat athletes peak, and does it differ by
   discipline (boxing, MMA, muay thai, kickboxing, BJJ, judo, wrestling,
   taekwondo, karate, sambo) and by weight class? Give a window, not a
   point, and say how wide the evidence really supports.
2. **Decline.** What declines first and how fast — speed, engine, recovery,
   chin, or nothing measurable at all? Separate what is EVIDENCED from what
   is folklore. Where the honest answer is "the record shows it but nobody
   has isolated the cause", say that.
3. **Maturation.** What improves with years in the sport while the body is
   still young, and until roughly when?
4. **Why careers end.** Rank the real triggers — accumulated damage, a
   medical suspension or licence refusal, money, a losing run, family, a
   title lost, a single bad night. Which of these does the game already
   model (it has medical holds, purses, records, rankings, morale, contract
   terms) and which would have to be invented?
5. **Retirement age.** The distribution, by discipline where it differs, and
   how often a retirement is reversed.
6. **The comeback.** How common is it, how long is the layoff, and how does
   the fighter usually do?

## How to deliver it

- **A table Claude can lift straight into `Aging.gd`.** Peak window per
  discipline, per-attribute yearly deltas by band (maturing / peak /
  declining), and the inputs to a 0-100 retirement pressure — each row
  carrying its own evidence grade.
- **A separate, explicit list of what you could NOT source**, so the game
  can mark those `UNKNOWN` rather than dress a guess as a citation. That
  list is as valuable as the table; do not pad it away.
- Cite what you used. A number without a source is `UNKNOWN` by definition
  here, however reasonable it looks.
- Females never fight males and the game books by weight class — where the
  evidence differs by sex, say so rather than averaging it away.

## Scope

Research and a document. No code, no data file, no test, no `HANDOFF.md`
edit. If a finding contradicts something R51 has already shipped, write the
contradiction down plainly — the fix is a later stage, not yours.

## Owned files

<!-- Backfilled 2026-09-08. This file predates the owned-files gate, so `done --task` found nothing to check and passed vacuously. Every path below comes from this task file's own parse-gate command, test command, build sections and shipped deliverables - none was invented. -->

```
research/J10_THE_YEARS.md
```
