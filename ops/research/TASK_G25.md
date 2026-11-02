# TASK G25 — GROK — THE HONOURS BOARD: WHAT A CAREER HAS WON

Model: Grok 4 Heavy, effort **high**, Fast off. One pass, no shell.

**Agent:** grok · **Model:** Grok 4 Heavy, effort **high**, Fast **off** ·
**Opened:** 2026-09-08

You have no checkout and no shell. **Do not run any repo command, do not try
to clone, do not run a test.** Write ONE new file and post it back. Claude
runs the suite after splicing it.

## Why this exists — verified, not assumed

Two records of "what this fighter won" now exist in the game and **nothing
puts them on one board**:

1. **`TitleHonours.rows(...)`** — G22, yours, landed as `4629c06`. Belts held,
   interim belts, and the belts R70 retired. Each row is a Dictionary with
   `key`, `discipline`, `weight_class`, `sex`, `standing` (`"held"`,
   `"interim"` or `"retired"`), `label`, `since_week`, `defenses`,
   `weeks_held`, `weeks_held_source`, `organization_id`, `retired_reason`.
2. **`EventResult` records** — G23, yours, and **R74 landed today** writing
   them in production for the first time: every seat in an event-discipline
   Grand Prix now comes out with one. Each row carries `event_id`, `edition`,
   `organizer`, `discipline`, `week`, `year`, `sex`, `weight_class`,
   `age_division`, `grade_division`, `athlete_id`, `placing`, `contests`,
   `wins`, `ranking_points`, `selection_effect`.

A career can now hold an MMA belt AND a judo gold, and there is no object that
can hand both to a screen. This module is that object.

## The file

`Godot/scripts/HonoursBoard.gd`

```gdscript
extends RefCounted
```

**ZERO `preload` and ZERO `load` statements.** You may NOT preload
`TitleHonours.gd` or `EventResult.gd` — both arrays arrive already built and
already ordered by their own modules, and you take them as they come. No
`GameState`, no autoload, no JSON, no `Time`. All functions `static`.

## The contract (exact names — an unseen test will call these)

```
static func board(title_rows: Array, event_rows: Array) -> Array
static func kind_of(row: Dictionary) -> String
static func row_words(row: Dictionary) -> String
static func summary(board_rows: Array) -> Dictionary
static func filter_kind(board_rows: Array, kind: String) -> Array
static func is_empty_board(board_rows: Array) -> bool
```

### `board(title_rows, event_rows)`

Returns ONE new Array. **Every title row first, in the order given; then every
event row, in the order given.** You do not re-sort either list — each arrived
sorted by the module that owns it, and a second opinion here would be a bug.
Non-Dictionary entries in either input are skipped silently.

Each output row is a NEW Dictionary — never one of the caller's — carrying
every key of the source row plus exactly these three:

| key | value |
| --- | --- |
| `honour_kind` | `"title"` for a title row, `"event"` for an event row |
| `honour_words` | the display line, from `row_words` below |
| `honour_order` | its 0-based index in the returned array |

### `kind_of(row)`

`"title"` when the row has a `standing` key, `"event"` when it has a
`placing` key, `"unknown"` when it has neither or both. Never guess from any
other field.

### `row_words(row)`

One upper-case display line, and `""` when nothing is known.

* A **title** row: `"<STANDING> — <LABEL>"`, e.g. `HELD — MMA LIGHTWEIGHT`.
  A `retired` standing prints `RETIRED`. If `label` is empty, the line is just
  the standing; if the standing is empty too, return `""`.
* An **event** row: `"<PLACING> — <EDITION>"`, e.g.
  `GOLD — VANGUARD GRAND PRIX 3`. If `edition` is empty, the line is just the
  placing; if the placing is empty or `unknown`, and the edition is empty,
  return `""`. **A placing of `unknown` prints `UNKNOWN`** when there is an
  edition to print beside it — it is a real answer, not a blank.
* Anything else: `""`.

Never print a dangling separator: a dropped section takes its `" — "` with it.

### `summary(board_rows)`

Counts, over the rows given:

```
{"titles": int, "events": int, "held": int, "interim": int, "retired": int,
 "gold": int, "silver": int, "bronze": int, "total": int}
```

`held` / `interim` / `retired` count title rows by `standing`. `gold` /
`silver` / `bronze` count event rows whose `placing` is exactly that word,
lower case, edges stripped. **No other placing contributes to any medal
count** — a `fifth` is not a medal. `total` is `titles + events`. No other
keys, and every key present even when it is `0`.

### `filter_kind(board_rows, kind)`

A new Array of the rows whose `honour_kind` equals `kind`. Never mutates the
input. An unknown kind returns an empty Array.

### `is_empty_board(board_rows)`

`true` when the array holds no Dictionary rows at all. This is the read a
screen uses to print NOTHING — no header, no placeholder, no "0 honours".

## Rules you must not break

1. **A MEDAL IS NOT A TITLE, and this is the module where that rule lives or
   dies.** The two kinds stay separately tagged, separately counted and never
   merged into one "championships" number. No function returns a holder, a
   reign, a defence, or a combined "titles won" figure that adds a gold to a
   belt. `summary` deliberately has no such key: do not add one.
2. **Do not re-sort.** Order is the input's, not yours.
3. **Do not compute a placing rank or a medal.** `EventResult` owns both. You
   compare the placing STRING to `"gold"`, `"silver"` and `"bronze"` and
   nothing more.
4. Deterministic and stateless: no `randi`, no `Time`, no `static var` cache.
5. Never mutate a Dictionary or Array the caller passed in — `duplicate()`
   before writing.
6. Follow the house gotchas: `var n: int = ...` where the right side is a
   Variant (`.get()`, `.size()` on an untyped value); `%%` for a literal `%`
   in a format string; never reuse a variable name inside one function, even
   across separate `if`/`for` blocks.

## Owned files

* `Godot/scripts/HonoursBoard.gd` — Grok delivers this ONE file and no test.
* `Godot/tests/honours_board_test.gd` — Claude writes this from the SAME
  contract after splicing, so the test never agrees with the code by
  construction.

## What to send back

The complete text of `Godot/scripts/HonoursBoard.gd`, in one code block, and
nothing else. **Do not send a test.** Do not edit `HANDOFF.md`.
