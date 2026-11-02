# TASK G19 — GROK — THE SHAPE OF A STAT SET

Model: mid tier, effort **medium**, Fast off. One session.
Independent of G18; do them in either order.

A pure module and its test. **Zero preloads**, statics only, no node access, no
RNG, no file access, no `res://` path. You have no repository checkout and you
do not need one: build and test this in a throwaway Godot 4.7 project holding
only your two files, exactly as G13, G15, G16 and G17 were built. Claude
splices it, runs the real suite and writes your `HANDOFF.md` block.

Deliver exactly two files and nothing else:

- `Godot/scripts/StatSpread.gd`
- `Godot/tests/stat_spread_test.gd`

## Why this exists

A fighter has seven attributes as of this week — `power`, `technique`,
`speed`, `defense`, `conditioning`, `fight_iq`, `grapple`, each 0-100. Every
screen draws seven bars and says nothing about their **shape**: which one is
this fighter's best, which is the hole, how far apart the ends are, which sit
above their own average. Nothing in the codebase computes any of that, and the
moment two screens want it they will each do the arithmetic inline with their
own idea of what a tie is and what a missing stat means.

You ship that arithmetic once, tested.

## The hard boundary: NUMBERS ONLY

This module returns **ids and numbers**. It does not:

- return any label, word, sentence or player-facing string — `SpreadWords.gd`
  is a separate task with a separate author and owns every word;
- classify a fighter as a specialist, an all-rounder, balanced, lopsided, or
  anything else — that needs threshold numbers nobody has sourced, and
  inventing them here would bury a design ruling inside a utility;
- know what a good value is. 100 and 3 are both just numbers.

If you catch yourself needing a cutoff to answer something, that answer is not
in this task.

## The closed list

Seven ids, in this canonical order, and nothing else is an attribute:

```
power, technique, speed, defense, conditioning, fight_iq, grapple
```

"Canonical order" below always means that order. It is the tie-break for
everything, so the module is deterministic.

## The contract

One public static:

```
static func summarize(stats: Dictionary) -> Dictionary
```

`stats` maps a stat id to a value. A stat is **usable** when its id is in the
closed list, its value reads as an integer, and that integer is 0-100
inclusive. Anything else — a missing id, a string, a float that is not whole,
`-3`, `140`, or an id that is not in the list — is **not usable**, is never
defaulted, and is never silently dropped.

Returned keys, all of them always present:

| key | type | meaning |
|---|---|---|
| `ok` | bool | true when at least **two** stats are usable; a shape needs two ends |
| `usable` | Array | usable ids, canonical order |
| `unknown` | Array | ids that could not be read: first the closed-list ids that were missing or unreadable in canonical order, then any foreign ids in the order the dictionary gave them |
| `values` | Dictionary | usable id → int, usable ids only |
| `count` | int | `usable.size()` |
| `mean` | float | mean of the usable values; `0.0` when `ok` is false |
| `spread` | int | highest usable value minus lowest; `0` when `ok` is false |
| `high_value` | int | the highest usable value; `0` when `ok` is false |
| `low_value` | int | the lowest usable value; `0` when `ok` is false |
| `highest` | Array | every usable id tied at `high_value`, canonical order |
| `lowest` | Array | every usable id tied at `low_value`, canonical order |
| `ranked` | Array | usable ids, value descending, ties in canonical order |
| `gap_to_next` | Dictionary | for each usable id, its value minus the value of the id after it in `ranked`; the last id in `ranked` gets `0` |
| `deviation` | Dictionary | usable id → float, `value - mean` |
| `above_mean` | Array | usable ids with `deviation >= 0.5`, canonical order |
| `below_mean` | Array | usable ids with `deviation <= -0.5`, canonical order |
| `at_mean` | Array | usable ids with `abs(deviation) < 0.5`, canonical order |
| `mean_absolute_deviation` | float | mean of `abs(deviation)` over the usable stats; `0.0` when `ok` is false |

When `ok` is false, `usable`, `values`, `ranked`, `highest`, `lowest`,
`gap_to_next`, `deviation`, `above_mean`, `below_mean` and `at_mean` are still
returned, empty, and `unknown` still names everything that failed. **A caller
must never have to check whether a key exists.**

Half a point is the `at_mean` band and it is deliberate: it is the width of one
rounding step, not a judgement about fighters.

`highest` and `lowest` are arrays because a genuine tie is common and picking
one silently would make the same fighter read differently on two screens. When
every usable value is equal, `highest` and `lowest` are the same list and
`spread` is `0` — that is correct, not an error.

## Determinism

Two calls with the same dictionary must return the same arrays in the same
order. Godot's `Dictionary` iteration order is insertion order, which a save
does not guarantee: **build every output array by walking the canonical list**,
never by walking `stats`. The only place you may walk `stats` is to collect
foreign ids for the tail of `unknown`.

## The test

`Godot/tests/stat_spread_test.gd` — a `SceneTree` script like every other test
in this project: `func _initialize()`, count failures, print a summary line,
`quit(0)` on pass and non-zero on failure. `load()` your module inside
`_initialize()`; do not `preload` it at the top of the file.

At least these cases:

1. All seven usable, all different — `ranked` fully ordered, `spread` correct,
   `gap_to_next` for the last id is `0`.
2. All seven equal — `spread` 0, `highest` and `lowest` both all seven,
   `at_mean` all seven, `mean_absolute_deviation` `0.0`.
3. A tie at the top and a different tie at the bottom — both arrays carry both
   ids, in canonical order and not in insertion order.
4. Two usable stats only — `ok` true, the other five in `unknown` in canonical
   order.
5. One usable stat — `ok` false, and every array key present and empty.
6. `{}` — `ok` false, `unknown` is all seven in canonical order.
7. Junk: a string value, a negative, `101`, and a foreign id like
   `"charisma"` — each lands in `unknown`, none reaches `values`, and the
   foreign id sits after the closed-list ones.
8. Same dictionary summarised twice, arrays compared element by element.

## GDScript traps that cost a cycle

- `var n := stats.get(id)` on an untyped dictionary infers Variant and is a
  parse error where an int is wanted. Write the type: `var v: int = ...`.
- Reusing one variable name twice inside a single function is a parse error,
  even in two separate `if` blocks.
- `%` inside a format string must be `%%`.

## Done means

Two files, sent as files. No repo command, no test of ours to run, no
`HANDOFF.md` edit. Say in one line what you did and what you refused to invent.

## Owned files

<!-- Backfilled 2026-09-08. This file predates the owned-files gate, so `done --task` found nothing to check and passed vacuously. Every path below comes from this task file's own parse-gate command, test command, build sections and shipped deliverables - none was invented. -->

```
Godot/scripts/StatSpread.gd
Godot/tests/stat_spread_test.gd
Godot/scripts/SpreadWords.gd
```
