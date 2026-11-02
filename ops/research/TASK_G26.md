# TASK G26 — GROK — THE MEDAL TABLE: A GYM'S TROPHY CABINET

Model: Grok 4 Heavy, effort **medium**, Fast off. One pass, no shell.

**Agent:** grok · **Model:** Grok 4 Heavy, effort **medium**, Fast **off** ·
**Opened:** 2026-09-08

You have no checkout and no shell. **Do not run any repo command, do not try
to clone, do not run a test.** Write ONE new file and post it back. Claude
runs the suite after splicing it.

## Why this exists — verified, not assumed

R74 landed today: every seat in an event-discipline Grand Prix now writes an
`EventResult` onto the athlete, roster and world alike, and
`EventResult.medal_tally(results)` already counts ONE athlete's golds, silvers
and bronzes.

Nothing counts a **squad**. A gym with six fighters has six separate tallies
and no way to rank them, and the same hole exists for a nation, an
organization or a division — every "who won the most" question in the game.
That ordering is the classic Olympic medal table, and its tiebreak rules are
arithmetic, not a rules claim, so it can be written today without waiting for
any research.

## The file

`Godot/scripts/MedalTable.gd`

```gdscript
extends RefCounted
```

**ZERO `preload` and ZERO `load` statements.** You may NOT preload
`EventResult.gd`: each competitor's medal counts arrive **already tallied** by
the caller, who got them from `EventResult.medal_tally`. You never see a
placing string and you never decide what a medal is. No `GameState`, no
autoload, no JSON, no `Time`. All functions `static`.

## The contract (exact names — an unseen test will call these)

```
static func table(entries: Array) -> Array
static func rank_of(table_rows: Array, entry_id: String) -> int
static func totals(table_rows: Array) -> Dictionary
static func row_words(row: Dictionary) -> String
static func leader(table_rows: Array) -> Dictionary
```

### `table(entries)`

`entries` is an Array of Dictionaries, each:

| key | type | meaning |
| --- | --- | --- |
| `id` | String | the competitor's id — athlete, gym, nation, whatever the caller counted |
| `name` | String | display name, may be `""` |
| `gold` | int | from `EventResult.medal_tally` |
| `silver` | int | " |
| `bronze` | int | " |

Missing keys default to `""` / `0`. Non-Dictionary entries are skipped.
Entries sharing an `id` are **merged**, their counts summed, keeping the first
non-empty `name` seen.

Returns a NEW Array of NEW Dictionaries, ordered by the standard medal-table
rule and carrying two extra keys:

| key | value |
| --- | --- |
| `total` | `gold + silver + bronze` |
| `rank` | 1-based placing in the table, **shared by ties** |

**The order**: most gold first; ties broken by silver, then by bronze, then by
`name` ascending (case-insensitive), then by `id` ascending. The name and id
tiebreaks exist so the table is deterministic — two gyms with identical
medals must come out in the same order every run.

**Ties share a rank and the next rank SKIPS.** Two competitors tied on
gold/silver/bronze are both `rank` 1 and the next is `rank` 3, never 2. A tie
is decided only by the three counts: competitors separated by the name or id
tiebreak still share a rank if their medals are equal.

A competitor with three zeroes is kept, ranked last by the same rule, and
never dropped — "entered and won nothing" is a real answer.

### `rank_of(table_rows, entry_id)`

The `rank` of that id, or `-1` when the id is not in the table. **Never `0`** —
`0` would read as a rank.

### `totals(table_rows)`

`{"gold": int, "silver": int, "bronze": int, "total": int, "competitors": int}`
summed over the rows. No other keys, every key present even at `0`.

### `row_words(row)`

One upper-case display line: `"<RANK>. <NAME> — <G>G <S>S <B>B"`, e.g.
`1. IRONSIDE GYM — 3G 1S 2B`. When `name` is empty, the id takes its place;
when both are empty, the name section and its `" — "` are dropped. A zero
count still prints as `0G` — here a zero IS the counted answer, not an
unknown.

### `leader(table_rows)`

The single `rank` 1 row, as a copy. `{}` when the table is empty, **and `{}`
when more than one row shares rank 1** — a tied table has no leader, and
picking one would be inventing a result.

## Rules you must not break

1. **You never decide what a medal is.** No placing strings, no `medal_of`, no
   `placing_rank`. The counts arrive done. A `fifth` never reaches you.
2. **A medal table is not a ranking of fighters.** Nothing here returns a
   champion, a belt, a holder or a title, and no row may be read as one.
3. **Ties are real.** Do not break a tie in `rank`, and do not invent a leader
   for one.
4. Deterministic and stateless: no `randi`, no `Time`, no `static var` cache.
5. Never mutate a Dictionary or Array the caller passed in — `duplicate()`
   before writing.
6. Follow the house gotchas: `var n: int = ...` where the right side is a
   Variant (`.get()`, `.size()` on an untyped value); `%%` for a literal `%`
   in a format string; never reuse a variable name inside one function, even
   across separate `if`/`for` blocks.

## Owned files

* `Godot/scripts/MedalTable.gd` — Grok delivers this ONE file and no test.
* `Godot/tests/medal_table_test.gd` — Claude writes this from the SAME
  contract after splicing, so the test never agrees with the code by
  construction.

## What to send back

The complete text of `Godot/scripts/MedalTable.gd`, in one code block, and
nothing else. **Do not send a test.** Do not edit `HANDOFF.md`.
