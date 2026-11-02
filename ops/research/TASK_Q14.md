# TASK Q14 — QWEN — Quantise.gd: THE FIXED POINT DETERMINISM NEEDS

**Model:** your default · medium effort. Module **and** its test.

## Why this exists

C62 (Codex, `e660d6d`) answered the question that gates the whole real-time
direction, and its answer had a condition attached:

> seeded replay survives a fixed step **only** with integer tick time,
> frame-independent tick/draw order, and **quantised or fixed-point
> authoritative state**. Variable-`delta` floats do not satisfy portable
> byte-exact replay.

You are building that quantisation. Claude's real-time core (R82) will store
every authoritative value through this module. It is pure arithmetic and
depends on nothing, so it can land before the core exists.

Read `research/C62_DIGEST.md` (19 lines) for context. Nothing else.

## The contract

`Godot/scripts/Quantise.gd`, `class_name Quantise`, **all static, ZERO
preloads.** No state, no nodes, no autoloads.

The representation is a **scaled integer**: a value is stored as
`int(round(value * SCALE))` and read back as `stored / float(SCALE)`. One
`SCALE` for the whole engine so two subsystems can never disagree.

```
const SCALE := 1000            # three decimal places
const HALF_UP_EPSILON := 1e-9  # see the rounding rule
```

1. `static func to_fixed(value: float) -> int`
   Quantise. **Rounding must be deterministic and symmetric**: exactly-half
   values round away from zero (`0.0005 -> 1`, `-0.0005 -> -1`), never
   banker's rounding, and never `round()`'s platform behaviour on ties. Use
   `HALF_UP_EPSILON` to make the tie test stable against float representation.
   A non-finite `value` (NaN or ±INF) returns `0`.
2. `static func to_float(fixed: int) -> float`
   `fixed / float(SCALE)`.
3. `static func quantise(value: float) -> float`
   `to_float(to_fixed(value))`. **Idempotent** — quantising twice equals
   quantising once, and a test must prove it.
4. `static func add(a: int, b: int) -> int` and
   `static func sub(a: int, b: int) -> int`
   Integer arithmetic on fixed values. Present so the core never mixes fixed
   and float by accident.
5. `static func mul(a: int, b: int) -> int`
   `a * b / SCALE`, with the SAME half-away-from-zero rounding as `to_fixed`.
   This is the one that drifts if you get it wrong.
6. `static func clamp_fixed(fixed: int, low: int, high: int) -> int`
   Returns `fixed` unchanged when `low > high` — a contradictory range is
   unmeasurable, not an excuse to invent a bound.

## Owned files

- `Godot/scripts/Quantise.gd` — new.
- `Godot/tests/quantise_test.gd` — new.
- `research/Q14_DIGEST.md` — new, short.

**Do NOT touch** `FightSimulation.gd` (Claude, R82), `ImpactModel.gd` (Codex,
C63), `BroadcastRead.gd` (Cursor, U21), or `RingSpace.gd`.

## The traps

- **Ties are the whole task.** `to_fixed(0.0005)` and `to_fixed(-0.0005)` must
  be `1` and `-1`. If they come back `0` and `0`, or `1` and `0`, replay drifts
  and C62's condition is not met. Test both signs explicitly.
- **`mul` is where precision dies.** `mul(to_fixed(0.1), to_fixed(0.2))` must
  equal `to_fixed(0.02)`. Prove it.
- **Round-trip is not identity.** `to_float(to_fixed(x))` equals `x` only when
  `x` is already on the grid. Assert idempotence, not exact round-trip of an
  arbitrary float — asserting the latter is a test that cannot pass and would
  send you editing the module to satisfy a wrong expectation.
- No `tick`, no Hz, no fight vocabulary. This module knows nothing about
  fighting.

## Gate

Parse gate, your own test, then the full suite in the background before the
commit: `python Godot/tools/run_tests.py` → **`fails=0` or better.**
