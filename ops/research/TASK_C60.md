# TASK C60 — CODEX — THE TEST FOR `RingPlace.gd`

**Owner:** codex
**Model:** cheaper tier, effort **low**, Fast **on**.
Reason: a test written from a written contract. No design judgement.

**Ready now.** C59 landed in `d9f7da9` and no longer gates this.

## Why this is a separate task

Grok has no shell and cannot run the suite, so its module and its test are
always two tasks (standing rule, 2026-09-08). **You are writing this test from
the contract below, not from Grok's delivered code.** Do not read
`Godot/scripts/RingPlace.gd` before your assertions are written — a test written
against an implementation only agrees with it. Write the test, then run it
against whatever Grok delivered, and report any disagreement as a finding rather
than editing the test to match.

The module **has** landed - `Godot/scripts/RingPlace.gd`, 63 lines, Grok's
G27, commit `f0013d1`. That changes nothing about the order of your work:
write every assertion from the contract below FIRST, then run it. Claude has
already reviewed the module cell by cell against this same contract and found
it correct, so a disagreement almost certainly means the test is wrong - but
report it rather than silently editing either side.

## The contract (identical to `TASK_G27.md`)

```gdscript
const PLACES := ["CENTRE", "ROPES", "CORNER"]
const STEPS  := ["forward", "back", "lead_side", "rear_side"]

static func advance(place: String, step: String) -> String
static func is_trapped(place: String) -> bool
static func pressure(place: String) -> float
static func describe(place: String) -> String
```

`place` is where the **pressured** fighter stands; `step` is the step the
**pressuring** fighter takes.

### `advance` — the full table, all twelve cells

| from | `forward` | `back` | `lead_side` / `rear_side` |
|---|---|---|---|
| `CENTRE` | `ROPES` | `CENTRE` | `CENTRE` |
| `ROPES` | `CORNER` | `CENTRE` | `CENTRE` |
| `CORNER` | `CORNER` | `ROPES` | `ROPES` |

- Input case-insensitive; return always UPPERCASE and always in `PLACES`.
- Unrecognised `place` -> returned **unchanged**.
- Unrecognised `step` -> `place` returned **unchanged**.
- **RULING (2026-09-09) - read this before writing assertion 3.** Those two
  bullets and the "return always UPPERCASE" bullet conflict on exactly one
  input: a *recognised* place in the wrong case plus an *unrecognised* step,
  `advance("centre", "typo")`. Unchanged says `"centre"`; uppercase says
  `"CENTRE"`. **Unchanged wins: the argument echoes back verbatim, in whatever
  case it arrived.** "Return always UPPERCASE" applies only when a real
  transition happens. This ambiguity was Claude's, not Grok's; the delivered
  module already behaves this way. Assert the verbatim reading and do not
  assert the uppercase one.

### The other three

- `is_trapped` — `true` only for `CORNER`; `false` otherwise, unknown included.
- `pressure` — `CENTRE` `0.0`, `ROPES` `0.5`, `CORNER` `1.0`, unknown `0.0`.
- `describe` — `"centre of the ring"` / `"backed to the ropes"` / `"cornered"`,
  unknown `""`.

## What to assert

Cover all of it — this is a small surface and there is no excuse for a gap:

1. **All twelve `advance` cells** above, explicitly.
2. `lead_side` and `rear_side` produce **identical** results from every rung.
3. Case-insensitivity: `"centre"`, `"Centre"`, `"CENTRE"` all behave the same,
   and the return is uppercase in every case.
4. Round trips: `CENTRE -forward-> ROPES -forward-> CORNER -back-> ROPES
   -back-> CENTRE`, and that `back` from `CENTRE` is a floor (stays `CENTRE`),
   `forward` from `CORNER` is a ceiling (stays `CORNER`).
5. **The unknown-input rule, which is the trap:** `advance("DRESSING_ROOM",
   "forward")` returns `"DRESSING_ROOM"` unchanged — **not** `"CENTRE"`.
   Likewise `advance("CENTRE", "cartwheel")` returns `"CENTRE"`, and
   `pressure("DRESSING_ROOM")` is `0.0`, `is_trapped("DRESSING_ROOM")` is
   `false`, `describe("DRESSING_ROOM")` is `""`.
6. **The ruling case, explicitly:** `advance("centre", "cartwheel")` returns
   `"centre"` - lowercase, verbatim - while `advance("centre", "forward")`
   returns `"ROPES"` uppercase. Both, in the same test, so the boundary between
   "a transition happened" and "nothing happened" is pinned by assertion rather
   than by reading.
7. `PLACES` and `STEPS` contain exactly the documented strings in the
   documented order.
8. No `Vector2`, no coordinate, no distance anywhere in the module's API.

## Owned files

- `Godot/tests/ring_place_test.gd` — **new, and the only file you write.**

Do not edit `Godot/scripts/RingPlace.gd`. If it disagrees with the contract,
that is a finding for your report, not a fix — Claude splices and decides.

## Gate

```bash
python Godot/tools/check_scripts.py Godot/tests/ring_place_test.gd
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/ring_place_test.gd
python Godot/tools/run_tests.py
```
The suite currently carries **2 failures that are not yours** -
`athlete_development_test.gd` and `stat_help_test.gd`, Q11's migration
regression, which Qwen is fixing under Q12 and may already have landed by the
time you start. Your gate is **fails=2 or better**; if Q12 has landed, it is
`fails=0`. Either way `ring_place_test.gd` itself must be clean. Never gate on
an exact count.

Remember R75: **rc=0 is not a pass.** A GDScript runtime error still exits 0, so
read the runner's own `SUITE total=N fails=M` line, not the exit code.

## The trap

The one assertion that matters most is the one an implementer is most likely to
get wrong: **an unknown place comes back unchanged, and `CENTRE` is never a
fallback.** A module that answers `"CENTRE"` for input it did not understand
invents a fact about where a fighter is standing, and no caller can tell that
apart from a real reading. Assert it explicitly for all four functions.
