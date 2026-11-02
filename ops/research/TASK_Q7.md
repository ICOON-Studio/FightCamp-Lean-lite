# TASK Q7 — QWEN — THE WORDS FOR THE SHAPE OF A STAT SET

Model: Qwen3.8-Max, effort **high**. One session. Runs after Q6.
Its test is TASK Q7T, a separate task — you are not asked for one.

**You have no repository and you do not need one.** This file is complete.
Build it in a throwaway Godot 4.7 project holding only your one file.

## ONE FILE. THE MODULE. DO NOT SEND A TEST.

1. `SpreadWords.gd` — and nothing else.

Q2, Q3, Q5 and Q6 each came back as the module alone, so the test is now
always its own task with its own author, written from **this file's contract**
rather than from your code. That makes the API below a contract: exact names,
exact argument order, exact strings, exact separators. A test you will never
see will compare them with `==`.

## Why this exists

A fighter has seven attributes, each 0-100. Another module, `StatSpread.gd`,
is being written in parallel to compute the **shape** of that set: which
attribute is highest, which is lowest, how far apart the ends are, which sit
above the fighter's own average, and how many could not be read at all. It
returns ids and numbers and, on purpose, not one word.

You ship the words. Every string a player reads about the shape of a stat set
comes from your file, once, so two screens can never word it differently.

## What you must NOT do

- **Never name an attribute.** You do not know that `grapple` is spelled
  `GRAPPLE`; another module (`StatWords.gd`) owns that and you may not
  duplicate, preload or guess it. Every function below takes labels **already
  resolved by the caller** and uses them verbatim — never re-cased, never
  trimmed, never abbreviated, never re-ordered.
- **Never judge.** No "ELITE", "WEAK", "NEEDS WORK", no advice, no coaching, no
  praise. The words say what the numbers are, and stop.
- **No preload, no `res://`, no node, no autoload, no RNG, no file access.**
  Statics only, `extends RefCounted`.
- **No `he`, `she`, `his` or `her`.** The game does not know, and both sexes
  fight in it. Where an owner is needed the words say `THIS FIGHTER'S`.

## The contract

House style is capitals, and the separator is a space, a middle dot, a space:
`" · "`. Copy it exactly.

### 1. `static func list_phrase(labels: Array) -> String`

Joins labels into one readable run. An entry that is not a String, or is the
empty String, is dropped before joining.

| input (after dropping unusable entries) | returns |
|---|---|
| nothing left | `` (empty String) |
| `["POWER"]` | `POWER` |
| `["POWER", "SPEED"]` | `POWER AND SPEED` |
| `["POWER", "SPEED", "DEFENSE"]` | `POWER, SPEED AND DEFENSE` |
| four or more | `A, B, C AND D` — comma and space between all but the last two, ` AND ` before the last |

Order is the caller's order. You never sort.

### 2. `static func highest_line(labels: Array) -> String`

`""` when `list_phrase(labels)` is empty. Otherwise
`"HIGHEST · " + list_phrase(labels)`.

So `["GRAPPLE"]` gives `HIGHEST · GRAPPLE`, and `["POWER", "SPEED"]` gives
`HIGHEST · POWER AND SPEED`.

### 3. `static func lowest_line(labels: Array) -> String`

The same, with `"LOWEST · "`. `["DEFENSE"]` gives `LOWEST · DEFENSE`.

Two labels here mean a genuine tie, not a mistake: a tie is normal and both
names are said.

### 4. `static func spread_line(spread: int) -> String`

| spread | returns |
|---|---|
| below 0, or above 100 | `` (empty String) |
| `0` | `EVERY ATTRIBUTE LEVEL` |
| `1` | `SPREAD 1 POINT` |
| `2` and above | `SPREAD 7 POINTS` for 7, and so on |

The singular at 1 is the point of this function existing.

### 5. `static func standing_word(sign: int) -> String`

Where one attribute stands against the fighter's own average.

| sign | returns |
|---|---|
| `1` | `ABOVE THIS FIGHTER'S OWN AVERAGE` |
| `0` | `AT THIS FIGHTER'S OWN AVERAGE` |
| `-1` | `BELOW THIS FIGHTER'S OWN AVERAGE` |
| anything else | `` (empty String) |

### 6. `static func stat_standing_line(label: String, standing: String) -> String`

`""` when either argument is the empty String. Otherwise
`label + " · " + standing`.

So `stat_standing_line("GRAPPLE", standing_word(1))` gives
`GRAPPLE · ABOVE THIS FIGHTER'S OWN AVERAGE`.

### 7. `static func unknown_line(count: int) -> String`

How many attributes the record could not read.

| count | returns |
|---|---|
| `0` or below | `` (empty String) |
| `1` | `1 ATTRIBUTE NOT RECORDED` |
| `2` and above | `4 ATTRIBUTES NOT RECORDED` for 4, and so on |

`NOT RECORDED` is the settled wording for "the game does not know". It is not
`UNKNOWN`, not `MISSING`, not `N/A`, and it never becomes a zero.

## Every function returns the empty String rather than a fallback

There is no `"NONE"`, no `"—"`, no placeholder. An empty String is how the
caller learns there is nothing to print, and a cheerful default here would be
drawn on a screen as though it were a fact.

## GDScript traps

- `%` inside a format string must be `%%`.
- Reusing one variable name twice inside a single function is a parse error,
  even in two separate `if` blocks.
- `var s := some_array.size()` can infer Variant; write `var n: int = ...`.

## Done means

**One file, `SpreadWords.gd`, sent as a file.** No test, no repository command,
no `HANDOFF.md`. If any row of any table above seems wrong, say so in one line
and ship it as written anyway — the test is being built from the same tables.

## Owned files

<!-- Backfilled 2026-09-08. This file predates the owned-files gate, so `done --task` found nothing to check and passed vacuously. Every path below comes from this task file's own parse-gate command, test command, build sections and shipped deliverables - none was invented. -->

```
Godot/scripts/SpreadWords.gd
Godot/scripts/StatSpread.gd
Godot/scripts/StatWords.gd
```
