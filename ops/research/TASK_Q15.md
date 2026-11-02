# TASK Q15 — QWEN — FightIntent.gd: WHAT A FIGHTER DECIDES TO DO

**Model:** your default · medium effort. Module **and** its test.

## Why this exists

The fight is becoming real time. Claude is building the core (R82,
`FightRealtime.gd`), and `TickBudget` (G29) runs the **decision** subsystem at
2 Hz — every 10 ticks at 20 Hz. Twice a second, each fighter re-reads the
situation and picks what he is trying to do. **That choice is this module.**

If it were written inside the core it would be untestable in isolation and
tangled with tick plumbing. Pure and separate, it can be tested exhaustively.

Read `research/U18_WHAT_MAKES_A_FIGHT_FEEL_REAL.md` only if you want the
background — it is not required. `TASK_Q15.md` is self-contained.

## The contract — exact names, exact argument order, exact strings

`Godot/scripts/FightIntent.gd`, `class_name FightIntent`, **all static, ZERO
preloads.** No nodes, no `_process`, no RNG created inside — a caller passes a
roll in, so the core keeps its own seeded stream and this stays pure.

```
const CLOSE   := "close"     # cut the distance
const HOLD    := "hold"      # stay at this range and work
const RETREAT := "retreat"   # get out
const CIRCLE  := "circle"    # move laterally, reset position
const INTENTS := ["close", "hold", "retreat", "circle"]
```

1. `static func preferred_range(stats: Dictionary, reach_cm: float) -> float`
   The distance in metres this fighter wants. Longer reach and higher
   `technique` want more; higher `power` wants less. Clamp to `0.4 .. 2.0`.
   An empty `stats` uses 50 for every attribute.
2. `static func decide(stats: Dictionary, distance: float, preferred: float, stamina: float, place: String, roll: float) -> String`
   Returns one of `INTENTS`. `roll` is `0.0 .. 1.0`, supplied by the caller.
   - **A cornered man's first business is getting off the ropes.** When
     `place` is `"CORNER"`, `CIRCLE` and `RETREAT` dominate — never `HOLD`.
   - Too far from `preferred` → `CLOSE`. Too near → `RETREAT`.
   - Within tolerance → mostly `HOLD`, sometimes `CIRCLE`.
   - **Low `stamina` shifts the whole distribution away from `CLOSE`.** A
     gassed fighter does not walk people down.
   - `roll` decides only *between* the options the situation allows. **The
     same inputs and the same roll must always give the same answer** — this
     is called from a seeded stream and replay depends on it.
3. `static func tolerance(stats: Dictionary) -> float`
   How much slop around `preferred` still counts as "at range". Higher
   `fight_iq` is tighter. Clamp to `0.1 .. 0.6`.
4. `static func is_aggressive(intent: String) -> bool`
   True for `CLOSE` only. Present so a caller never string-compares.

## The rules that decide the edge cases

- **An unrecognised `place` is not a corner.** Treat it as open floor rather
  than refusing — position is always known in the core, and a typo must not
  freeze a fighter. But an unrecognised `intent` in `is_aggressive` returns
  `false`, because that IS unmeasured.
- `roll` outside `0.0 .. 1.0` is clamped, not refused.
- A negative `distance` is treated as `0.0`.
- `stamina` is `0.0 .. 100.0` and clamped.

## Owned files

- `Godot/scripts/FightIntent.gd` — new.
- `Godot/tests/fight_intent_test.gd` — new.
- `research/Q15_DIGEST.md` — new, short.

**Do NOT touch** `FightRealtime.gd` or `FightSimulation.gd` (Claude),
`ImpactModel.gd` (Codex), `BroadcastRead.gd` (Cursor), or any module you
already shipped.

## The traps

- **No RNG inside.** Not `randf()`, not a `RandomNumberGenerator`, not
  `randomize()`. The caller passes `roll`. If this module generates its own
  randomness, every seeded fight becomes unreplayable and C62's whole finding
  is wasted.
- **Determinism is testable and you must test it**: the same six arguments
  called twice return the same string. Assert it.
- **Do not add an eighth attribute.** U18 refused one and the refusal stands.
  Use `power`, `technique`, `speed`, `defense`, `conditioning`, `fight_iq`,
  `grapple` — the seven that exist.
- No tick, no Hz, no fight-seconds. This module does not know what time is.

## Gate

Parse gate, your own test, then the full suite in the background before the
commit: `python Godot/tools/run_tests.py` → **`fails=0` or better.**
