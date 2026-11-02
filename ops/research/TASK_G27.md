# TASK G27 — GROK — WHERE IN THE RING

**Owner:** grok
**Model:** effort **medium**.
One new file, zero preloads, all static. **Send the module ONLY** — its test is
a separate task Claude writes from this same contract, so it never agrees with
your code by construction.

## Why this exists

U18 (Cursor's fight research) measured what a real round contains: ~20 punches,
2.5 defenses and **47 hip movements per minute**. Its D4 finding is that we
model *who wins the distance* but never *where in the ring it happened* — we
cannot say a man was walked down, cut off, or angled out of a corner.

U18 is emphatic that the fix is **not** XY coordinates. It is a three-rung
ladder. That ladder is this module.

## The file

`Godot/scripts/RingPlace.gd` — zero preloads, all static, no `class_name`,
no `_ready`, no signals. Nothing outside this file exists as far as it knows.

## The contract — exact names, exact order, exact strings

```gdscript
const PLACES := ["CENTRE", "ROPES", "CORNER"]
const STEPS  := ["forward", "back", "lead_side", "rear_side"]

static func advance(place: String, step: String) -> String
static func is_trapped(place: String) -> bool
static func pressure(place: String) -> float
static func describe(place: String) -> String
```

`place` is where the **pressured** fighter stands. `step` is the step the
**pressuring** fighter takes. One call, one rung.

### `advance(place, step) -> String`

| from | `forward` | `back` | `lead_side` / `rear_side` |
|---|---|---|---|
| `CENTRE` | `ROPES` | `CENTRE` | `CENTRE` |
| `ROPES` | `CORNER` | `CENTRE` | `CENTRE` |
| `CORNER` | `CORNER` | `ROPES` | `ROPES` |

- `forward` walks the pressured man backwards; from `CORNER` there is nowhere
  further to go, so it stays.
- `back` gives ground back, one rung.
- `lead_side` / `rear_side` are **angling off** — the pressured man escapes one
  rung toward the middle. They behave identically; both exist because D4 names
  four footwork atoms and a caller should not have to collapse them.
- Input is **case-insensitive**; the return is always one of the three
  UPPERCASE strings in `PLACES`.
- **An unrecognised `place` is returned unchanged. An unrecognised `step`
  returns the `place` unchanged.** Never raise, never substitute a default.
- **RULING (2026-09-09, after G27 shipped in `f0013d1`).** The two bullets above
  conflict for one input: a *recognised* place in the wrong case plus an
  *unrecognised* step - `advance("centre", "typo")`. "Returned unchanged" says
  `"centre"`; "the return is always UPPERCASE" says `"CENTRE"`. That was my
  ambiguity, not Grok's. **Settled as: unchanged wins - the argument is echoed
  back verbatim, in whatever case it arrived.** The delivered module already
  does this. C60 must assert exactly that and must not assert the uppercase
  reading; a caller cannot cascade on it, because `_canon_place` is
  case-insensitive on the next call either way.

### The other three

- `is_trapped(place)` — `true` only for `CORNER`, `false` for everything else
  including an unrecognised place.
- `pressure(place)` — `CENTRE` `0.0`, `ROPES` `0.5`, `CORNER` `1.0`,
  anything unrecognised `0.0`.
- `describe(place)` — `CENTRE` -> `"centre of the ring"`,
  `ROPES` -> `"backed to the ropes"`, `CORNER` -> `"cornered"`,
  anything unrecognised -> `""` (empty string, not a placeholder sentence).

## Owned files

- `Godot/scripts/RingPlace.gd` — **new, and the only file you write.**

Do not write a test. Do not edit `HANDOFF.md`. Do not touch any existing file.

## How to check it

Build and run it in a throwaway Godot project holding only this one file, the
way you always have (`research/SANDBOX_MODULE_TESTING.md`). Zero preloads
is what makes that possible — keep it that way.

## The trap

**`CENTRE` is not the fallback.** An unrecognised place must come back exactly
as it was handed to you, and `pressure` of an unknown place is `0.0` because it
is unmeasured — not because the man is in the middle. A module that quietly
answers "CENTRE" for input it did not understand invents a fact about where a
fighter is standing, and the caller has no way to tell that apart from a real
reading.

Second, smaller: there are **no coordinates in this file**. No `Vector2`, no
distance, no metres, no angle in degrees. Three rungs and four atoms. If a
function feels like it wants an X, it belongs to a different task.
