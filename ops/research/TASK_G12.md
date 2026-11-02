# TASK G12 — GROK — CAREER MILEAGE: THE OTHER NUMBER BESIDE THE YEARS

**Status: COMPLETE (2026-09-07, `ba44e61`).** A pure module and its test. Blocks
nothing; R54 leaves a named seam for it.

Model: mid tier, effort medium, Fast off.

G9 (career epilogue) and G11 (exit roles) both landed and are both in use —
thank you. This is the same shape: **one small pure file, zero preloads, and a
test.** Everything you need is in this file.

## Why this exists

John's J12 study (2026-09-07) ruled, as **D5**:

> **Years and mileage are both real and not interchangeable.** If the game has
> `age` and fight history, key clearance/risk off **both**. Do not collapse
> recovery to birthday. NSAC treats **38, 425 rounds, and 36 months inactive**
> as *separate* comprehensive-contestant triggers.

The game has the years — `Aging.gd` is the one age curve. **It has no mileage
number at all.** Nothing anywhere in this codebase computes how much a fighter
has actually been through; grep confirmed it on 2026-09-07. So the commission's
425-rounds trigger cannot be encoded, and the per-body-part recovery system the
operator has ruled for a future stage has nothing to key a hard-used region off.

You are building that number.

## What you are building

`Godot/scripts/Mileage.gd` — statics only, `extends RefCounted`, **zero
preloads**, no node access, no autoload, no RNG. Everything is passed in.

```gdscript
static func summarize(rows: Array) -> Dictionary
```

`rows` is the fight log the game already keeps, newest first. **Every field
below is real and you may use only these** — the row shape is fixed by
`FightLog.gd` and is:

```
bout_id, week, opponent_id, opponent_name, result, method, round, time,
event_name, promotion, purse, hype, title_fight, streak_after, notes
```

- `result` is one of `"W"`, `"L"`, `"D"`, `"NC"`.
- `method` is a short code, upper-case: `"KO"`, `"TKO"`, `"SUB"`, `"DEC"` and
  similar. Finishes are `KO` / `TKO` / `SUB`.
- **`round` is the round the bout ENDED in**, and it is the only rounds figure
  the save has. A bout that ended in round 3 was three rounds of work. A row
  whose `round` is 0 or missing is a bout whose length the save does not know —
  see the refusal below.
- `week` is the career week. The game's year is 52 weeks.

Return at least:

- `rounds` — total rounds fought, the NSAC number.
- `bouts` — how many rows counted.
- `unknown_rounds` — how many rows had no usable `round`. **This must be
  visible in the answer**, not silently folded into 0.
- `finishes_taken` — losses by `KO` / `TKO`. J12 D5's second half: a fighter's
  history of being finished is not the same fact as their round count, and the
  per-region system will want them apart.
- `finishes_given` — wins by `KO` / `TKO` / `SUB`.
- `last_bout_week` and `first_bout_week` — 0 when there are no rows.
- `hard_bouts` — bouts that went the distance or near it. Define it from
  `round` alone and say in the header exactly what you defined.

Add a second static if it makes the caller's life easier:

```gdscript
static func nsac_rounds_trigger(summary: Dictionary) -> bool  ## >= 425
```

`425` is the only number in this file that is EVIDENCE. Put it in a named
constant with NSAC beside it, and say in the header that it is `DIRECT`.

## The central refusal: no rate, no score, no verdict

This module **counts**. It does not grade.

- **No wear score, no damage score, no "mileage rating" 0-100.** There is no
  source anywhere for turning rounds into a condition number — J10 and J12 both
  searched. A caller that wants a verdict makes its own.
- **No percentage, no chance, no probability of anything.** Same refusal as
  G11: grep your own file for `chance`, `rate`, `percent`, `score` and `%`
  before you finish.
- **No estimating an unknown round count.** A row with no `round` is counted in
  `unknown_rounds` and contributes 0 rounds. Do not assume 3, do not assume the
  distance, do not infer from `time`. A count that quietly invents its inputs is
  worse than a count that admits a gap.
- **No age.** Mileage is the OTHER number; that is the whole point of D5. Do not
  read `age` and do not accept an athlete dictionary. Rows only.

## Settled

- Empty `rows` returns the same keys with zeroes — never an empty dictionary
  and never a crash. A fighter who never fought has 0 mileage, which is a fact.
- A row that is not a Dictionary is skipped, not fatal. The log is data.
- Order-independent: the same rows in any order give the same answer.
- Nobody may call this with a GameState. If it needs something, the caller
  passes it.

## Your files, and only these

- `Godot/scripts/Mileage.gd`
- `Godot/tests/mileage_test.gd`

Touch nothing else: not `GameState.gd`, not `Aging.gd`, not `FightLog.gd`, not
`UIKit.gd`, not `HANDOFF.md`. Claude splices, runs the parse gate and the full
suite, and writes your HANDOFF block. Do not poll for it.

## Testing without the repo

**Do not try to clone this repo** — it is private, 1.7 GB of `.git`, and there
is no token in your sandbox. A zero-preload module runs in a throwaway Godot
project holding only your two files. The recipe is
`research/SANDBOX_MODULE_TESTING.md`; G9, G10 and G11 were all proved
this way.

Your test should cover: an empty log; a log with every `round` present; a log
with some rows missing `round` (proving `unknown_rounds` is not silently zero);
a fighter over 425 rounds and one under; and a log containing a non-Dictionary
row.

## Done

Push `master` with your two files and nothing else.

## Owned files

<!-- Backfilled 2026-09-08. This file predates the owned-files gate, so `done --task` found nothing to check and passed vacuously. Every path below comes from this task file's own parse-gate command, test command, build sections and shipped deliverables - none was invented. -->

```
Godot/scripts/Mileage.gd
Godot/tests/mileage_test.gd
```
