# TASK G10 — THE CAREER ARC: THE SHAPE OF THE YEARS (Grok)

**Status: COMPLETE (2026-09-07).** Landed `5ae338e`. A pure module and its test. Blocks
nothing, blocked by nothing.

Model: mid tier, effort medium, Fast off.

## What to build

`Godot/scripts/CareerArc.gd` — one new file, plus
`Godot/tests/career_arc_test.gd`.

G9's `CareerEpilogue.gd` answers *what a finished career says about itself*
in words. This answers a different question: **what the years look like laid
out end to end**, so a screen can draw a career the way a chart draws a line
— without the screen doing arithmetic.

## The contract

```gdscript
static func build(rows: Array, birth_age: int, debut_week: int, career_week: int, window := {}) -> Dictionary
```

- `rows` — the fighter's fight history, newest or oldest first; you decide
  and you document it. Each row is the shape `FightRecordStats.summarize()`
  already consumes.
- `birth_age` — the fighter's age at `debut_week`. **Passed in. Never
  derived, never imported.**
- `window` — optional `{"from": int, "to": int}`, the peak window the caller
  already looked up. **Passed in.** You do not import `Aging.gd` and you do
  not author a second peak table; if `window` is empty, the peak fields come
  back empty rather than guessed.

Returns, at minimum:

```
{
  "years": [ {"year": int, "age": int, "fights": int, "wins": int,
              "losses": int, "draws": int, "in_window": bool} ... ],
  "first_year": int, "last_year": int, "years_active": int,
  "busiest_year": {...}, "best_year": {...},
  "longest_gap_weeks": int, "gap_after_year": int,
  "window": {"from": int, "to": int}   # echoed back, empty when not given
}
```

A "year" is 52 career weeks from week 1 — the game's own clock, the same one
`Aging.gd` counts in. Career week 1 is Monday 5 January 2026 and careers only
run forward, so **there is no year before the first one and no negative
age.**

## Rules

- **ZERO preloads. Statics only. No node access. No RNG. No `class_name`.**
  That is what lets you test it in a throwaway Godot project holding only
  your own two files — see `research/SANDBOX_MODULE_TESTING.md`. You
  have no repo checkout and are not expected to run the real suite; Claude
  runs it after you push.
- **Compose, never recompute.** If the caller hands you a
  `FightRecordStats.summarize()` result, use it. Do not re-derive a record
  you were given.
- A fact the rows do not carry contributes **nothing**, rather than a
  default that reads as a fact. An empty `rows` returns an empty, valid
  answer — never a crash and never a fabricated year.
- Deterministic: same input, same output, always.
- `%` inside a format string must be `%%`. Reusing a variable name inside
  one function is a parse error in GDScript, even across separate blocks.
  `var x := <call>` fails when the call returns Variant — write the type.

## Push

**Only your two files**: `Godot/scripts/CareerArc.gd` and
`Godot/tests/career_arc_test.gd`. **Never edit `HANDOFF.md`** — Claude writes
your block, splices, and runs the suite. Your claim goes in the
`## GROK START HERE` block, max 20 lines.

## Owned files

<!-- Backfilled 2026-09-08. This file predates the owned-files gate, so `done --task` found nothing to check and passed vacuously. Every path below comes from this task file's own parse-gate command, test command, build sections and shipped deliverables - none was invented. -->

```
Godot/scripts/CareerArc.gd
Godot/tests/career_arc_test.gd
```
