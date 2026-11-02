# TASK G23 — GROK — THE EVENT RESULT: A CHAMPIONSHIP WON ON A DATE

Model: Grok 4 Heavy, effort **high**, Fast off. One pass, no shell.

**Agent:** grok · **Model:** Grok 4 Heavy, effort **high**, Fast **off** ·
**Opened:** 2026-09-08

You have no checkout and no shell. **Do not run any repo command, do not try
to clone, do not run a test.** Write ONE new file and post it back. Claude
runs the suite after splicing it.

## Why this exists

C52 (landed) ruled that six disciplines — wrestling, judo, brazilian jiu
jitsu, taekwondo, sanda, sambo — have **no standing championship belt**. Their
world championship is won on a date, a medal is handed over, and nobody
carries anything into a defence. Their durable record is an `event_result`:
edition, organizer, date, division, placing, medal, contests, ranking points,
selection effect.

The game has no such object. You are writing the pure module that defines it.

## The file

`Godot/scripts/EventResult.gd`

```gdscript
extends RefCounted
```

**ZERO `preload` and ZERO `load` statements.** No `GameState`, no
`WorldPopulation`, no JSON file, no autoload. Every value the module needs is
passed in by the caller. It must be testable in an empty Godot project that
contains only this one file. All functions `static`.

## The contract (exact names — an unseen test will call these)

```
static func make(fields: Dictionary) -> Dictionary
static func is_valid(result: Dictionary) -> bool
static func placing_rank(placing: String) -> int
static func medal_of(placing: String) -> String
static func division_label(result: Dictionary) -> String
static func words(result: Dictionary) -> String
static func sort_results(results: Array) -> Array
static func best(results: Array) -> Dictionary
static func medal_tally(results: Array) -> Dictionary
```

**`make(fields)`** returns a normalized record with EVERY key present, taking
each value from `fields` and defaulting the rest. Never invent a value.

| key | type | default |
| --- | --- | --- |
| `event_id` | String | `""` |
| `edition` | String | `""` (e.g. `"2026 World Championships"`) |
| `organizer` | String | `""` (e.g. `"IJF"`) |
| `discipline` | String | `""` |
| `week` | int | `0` |
| `year` | int | `0` |
| `sex` | String | `""` |
| `weight_class` | String | `""` |
| `age_division` | String | `""` (e.g. `"senior"`, `"u21"`) |
| `grade_division` | String | `""` |
| `athlete_id` | String | `""` |
| `placing` | String | `"unknown"` |
| `contests` | int | `0` |
| `wins` | int | `0` |
| `ranking_points` | int | `0` |
| `selection_effect` | String | `"none"` |

**`placing_rank`** — the sort order, lower is better:
`gold` 1, `silver` 2, `bronze` 3, `fifth` 5, `seventh` 7, `participated` 99,
anything else (including `unknown`) 999.

**`medal_of`** — `"gold"`, `"silver"`, `"bronze"`, and `""` for every other
placing. **A fifth place has no medal**, and an empty string is the answer,
never `"none"`.

**`division_label`** — the division as one string, the parts that exist joined
by `" "`, upper case: sex, age division, weight class, grade division. Empty
parts are skipped, never printed as a gap or a dash. All four empty returns
`""`.

**`words`** — one display line: `"<MEDAL OR PLACING> — <EDITION> — <DIVISION>"`,
upper case, and any empty section plus its separator is dropped. Nothing known
returns `""`.

**`sort_results`** — newest first by `year` then `week`, and within the same
event by `placing_rank`. Deterministic: equal records keep `event_id` ascending
as the final tiebreak. Returns a new Array; never mutates the input.

**`best`** — the record with the lowest `placing_rank`; ties go to the most
recent. `{}` for an empty array.

**`medal_tally`** — `{"gold": int, "silver": int, "bronze": int}` counted over
the array. No other keys.

## Rules you must not break

1. **A medal is not a title.** No function returns a champion, a belt, a
   holder, a reign or a defence. Nothing here is carried forward.
2. **Unknown is a value.** `"unknown"` and `""` are legitimate answers and
   must survive to the caller. Never substitute `0` for a missing number in
   display output and never guess a year from a week.
3. Deterministic and stateless: no `randi`, no `Time`, no `static var` cache.
4. Never mutate a Dictionary or Array the caller passed in — `duplicate()`
   before writing.
5. Follow the house gotchas: `var n: int = ...` where the right side is a
   Variant (`.get()`, `.size()` on an untyped value); `%%` for a literal `%`
   in a format string; never reuse a variable name inside one function, even
   across separate `if`/`for` blocks.

## Owned files

* `Godot/scripts/EventResult.gd` - Grok delivers this ONE file and no test.
* `Godot/tests/event_result_test.gd` - Claude writes this from the SAME
  contract after splicing, so the test never agrees with the code by
  construction.

## What to send back

The complete text of `Godot/scripts/EventResult.gd`, in one code block, and
nothing else. **Do not send a test** — the test is a separate task written
from this same contract. Do not edit `HANDOFF.md`.
