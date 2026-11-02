# TASK Q5 — QWEN — THE WORDS FOR A BODY'S RECORD

Model: Qwen3.8-Max, effort **high**. One session. Q4 is delivered; this is
next. Q6 follows.

**You have no repository and you do not need one.** This file is complete.
Build and test in a throwaway Godot 4.7 project holding only your two files.

## ONE FILE. THE MODULE. DO NOT SEND A TEST.

1. `LedgerWords.gd` — and nothing else.

**The rule changed on 2026-09-08 and it changed in your favour.** Q2, Q3 and
Q4 each asked you for a module and a test and each time the module arrived
alone, so the test is now its own task (Q5T) with its own author. You are not
being asked for one. Send `LedgerWords.gd` in a single labelled code block and
stop there.

Build it in a throwaway Godot 4.7 project and satisfy yourself it runs — but
the test file is not a deliverable and will be discarded if you send it.

## Why this exists

A shipped module counts what a fighter's body has been diagnosed with over a
career: how many injuries in total, how many per region, how many of each type,
how many weeks were lost, how long since the last one, and which regions have
been hurt more than once. It returns **numbers only** — deliberately, because
counting and judging are different jobs and the counting module refuses the
second one.

This module turns those numbers into lines a screen can print. It is the same
refusal, one layer up: **a count is a fact, a verdict is not yours.**

`InjuryWords.gd` (Q3, yours) owns an injury's labels. `RecoveryWords.gd` (Q4,
yours) owns where a live injury stands. This owns the finished record. Where a
line needs a region's name or an injury type's label, **the caller passes the
already-worded string in** — a pure module may not preload another, and a
second copy of those labels would drift.

## What you are handed

The summary, exactly as the counting module returns it:

```gdscript
{
  "diagnoses": 4,             # usable rows
  "unusable_rows": 1,         # rows that could not be read
  "weeks_lost": 12,
  "weeks_lost_known": true,   # false when a row could not say
  "last_onset_week": 41,
  "weeks_since_last": 6,
  "repeat_sites": ["left_arm"],
  "unknown": ["weeks_since_last"],
}
```

and a per-region block:

```gdscript
{
  "region": "left_arm", "diagnoses": 2, "types": {"fracture": 2},
  "worst_severity": 2, "last_onset_week": 41,
  "weeks_lost": 8, "weeks_lost_known": true, "re_injuries": 1,
}
```

**A field named in `unknown`, or a `*_known` flag that is false, is not
printable.** It is not zero, it is not "none", it is not "0 WEEKS". It is a
thing the record cannot say, and the honest line says so or says nothing.

## The API

```gdscript
extends RefCounted

## "4 DIAGNOSES" / "1 DIAGNOSIS" / "" for a clean record. A clean record says
## NOTHING - never "NO INJURIES", never "CLEAN", which is a verdict.
static func diagnoses_line(summary: Dictionary) -> String

## "12 WEEKS LOST", and "" when weeks_lost_known is false. Never "0 WEEKS
## LOST" for a record that could not say.
static func weeks_lost_line(summary: Dictionary) -> String

## "LAST INJURY 6 WEEKS AGO", "" when the record cannot say.
static func since_last_line(summary: Dictionary) -> String

## The region's already-worded name is passed IN. "LEFT ARM · 2 DIAGNOSES ·
## 8 WEEKS LOST", dropping any segment the block cannot say.
static func region_line(region_words: String, block: Dictionary) -> String

## Rows the ledger refused to read, named plainly so a screen can admit the
## gap: "1 BOUT THE RECORD CANNOT READ" / "" when there are none.
static func unusable_line(summary: Dictionary) -> String

## Everything a screen needs at once:
## {"diagnoses": String, "weeks_lost": String, "since_last": String,
##  "unusable": String}
static func lines(summary: Dictionary) -> Dictionary
```

Singular and plural both matter: `1 DIAGNOSIS` / `2 DIAGNOSES`,
`1 WEEK LOST` / `8 WEEKS LOST`, `1 BOUT` / `3 BOUTS`, `1 WEEK AGO` /
`6 WEEKS AGO`.

## Refusals — each of these is a failed task

- **No verdict, ever.** Never "injury-prone", "fragile", "durable", "made of
  glass", "worrying", "healthy", "clean", "good record", "bad record". Never a
  band, a grade, a score or a risk. A repeat site is a count of two; what a
  screen makes of that is the screen's business and the player's. **This is the
  single fastest way to fail this task.**
- **No prediction.** Nothing about what happens next, no chance of re-injury,
  no expected weeks. Those are explicitly unknown and inventing them here
  launders a guess into a sentence.
- **No age.** No parameter, no mention.
- **No number you were not handed**, and no number a `*_known` flag or the
  `unknown` list says is unavailable.
- **No region or type labels of your own.** They are passed in.
- **No sentence case.** Upper case, `·` as the separator.
- **No `preload`, no autoload, no `class_name`.**

## The test is NOT yours

`ledger_words_test.gd` is TASK Q5T, a separate task with a separate author,
written from this same contract rather than from your code. That is deliberate
— a test written against the spec catches what the module SHOULD do, and a
test written against the implementation only agrees with it.

What this means for you: **the API above is a contract, not a suggestion.**
Exact function names, exact argument order, exact strings, exact separators.
A test you never see will call it. Do not rename anything, do not add a
convenience argument, do not return a Dictionary where a String is specified.

## GDScript, as this project's parser actually behaves

Godot **4.7**, tabs.

- **`:=` fails on a Variant.** `var n := summary.get("diagnoses", 0)` is a
  parse error; write `var n: int = ...`. Same for every value returned by a
  `load()`ed script in your test.
- **A name may be declared once per function.** Give each case its own name.
- **`%` in a format string must be `%%`.**

`extends RefCounted` on the module, `extends SceneTree` on the test.

## The one trap

**A quiet ledger is not a clean fighter.** The summary counts only injuries
that have FINISHED — a fighter who is badly hurt right now has an empty record,
because nothing has run its course yet. So `diagnoses: 0` must never produce a
line that implies a healthy fighter. Return `""` and let the screen, which also
holds the live injury, say what is actually true.

## Owned files

<!-- Backfilled 2026-09-08. This file predates the owned-files gate, so `done --task` found nothing to check and passed vacuously. Every path below comes from this task file's own parse-gate command, test command, build sections and shipped deliverables - none was invented. -->

```
Godot/scripts/LedgerWords.gd
Godot/scripts/InjuryWords.gd
Godot/scripts/RecoveryWords.gd
```
