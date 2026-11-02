# TASK Q13 — QWEN — RingSpace.gd: WHERE THE TWO MEN ACTUALLY ARE

**Model:** your default · medium effort. Module **and** its test — you have a
shell, so both are yours.

## Why this is safe to build before the research lands

Codex (C62) is deciding whether a real-time core can still replay a seed, and
Cursor (U20) is designing damage. **Neither answer changes this module.** Under
every candidate design the two fighters have positions on a bounded floor and a
distance between them. Pure arithmetic, no engine state, no simulation coupling.

Operator ruling 2026-09-09: the fight becomes real time, with real movement.
This overturns U18's "no XY" refusal and C17's Q3.

## The contract — exact, because a test may be written from it and not from
your code

`Godot/scripts/RingSpace.gd`, `class_name RingSpace`, **all static, ZERO
preloads** (so it is testable in a throwaway project — see
`research/SANDBOX_MODULE_TESTING.md`).

The floor is a SQUARE centred on the origin, described by `half_width` (metres,
> 0). A real ring is 4.9–6.1 m a side, a cage 7.6–9.1 m across, so
`half_width` is typically 2.4–4.6.

1. `static func distance(a: Vector2, b: Vector2) -> float`
   Straight-line metres. Never negative.
2. `static func clamp_to_floor(pos: Vector2, half_width: float) -> Vector2`
   A man cannot leave the floor. Clamps each axis to `[-half_width,
   half_width]`. A `half_width <= 0.0` returns `pos` unchanged.
3. `static func step(pos: Vector2, direction: Vector2, metres: float, half_width: float) -> Vector2`
   Move `metres` along `direction`, then clamp. A zero-length `direction`, or
   `metres <= 0.0`, returns `pos` unchanged (clamped). `direction` need not
   arrive normalised — normalise it yourself.
4. `static func place_of(pos: Vector2, half_width: float) -> String`
   **Returns exactly `"CENTRE"`, `"ROPES"` or `"CORNER"` — the same three words
   `RingPlace.gd` already uses**, so G27's ladder becomes a derived view of a
   real position instead of a parallel truth. You may NOT preload RingPlace;
   the strings are duplicated by contract and that is deliberate.
   - `CORNER` when BOTH axes are within `CORNER_MARGIN` of the boundary.
   - `ROPES` when exactly ONE axis is within `ROPES_MARGIN` of the boundary.
   - `CENTRE` otherwise.
   - `half_width <= 0.0` returns `"CENTRE"`.
   Expose `const CORNER_MARGIN := 0.75` and `const ROPES_MARGIN := 0.75` so a
   test can read them rather than guess.
5. `static func is_cornered(pos: Vector2, half_width: float) -> bool`
   True only for `"CORNER"`.
6. `static func pressure(pos: Vector2, half_width: float) -> float`
   0.0 in the centre rising to 1.0 in a corner — how trapped this man is.
   Use the larger of the two per-axis boundary fractions, clamped 0..1.
   `half_width <= 0.0` returns `0.0`.

## Owned files

- `Godot/scripts/RingSpace.gd` — new.
- `Godot/tests/ring_space_test.gd` — new. Follow
  `Godot/tests/ring_place_test.gd` for shape; print
  `RING_SPACE_TEST PASS` / `RING_SPACE_TEST FAILS=%d` and `quit(0 or 1)`.
- `research/Q13_DIGEST.md` — new, short.

**Nothing else.** `FightSimulation.gd` is off limits to everyone this cycle.

## The traps

- **No coordinates leak into the strings.** `place_of` returns a word, never a
  number, and never a fourth word — U18's `ON_CYCLE` is NOT in this module.
- **A boundary is inclusive.** A man standing exactly `half_width` from centre
  is ON the rope, not past it.
- **`pressure` of a degenerate floor is `0.0` because it is unmeasured**, not
  because he is safe — the same ruling G27 got.
- No `_process`, no nodes, no `Node2D`. Statics on a plain script.

## Gate

Parse gate first, then your own test, then the full suite in the background
before you commit:
`python Godot/tools/run_tests.py` → **`fails=0` or better.** It reads
`total=192 fails=0` right now, so yours should make it 193.
