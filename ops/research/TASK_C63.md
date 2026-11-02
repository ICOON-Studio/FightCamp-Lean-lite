# TASK C63 — CODEX — ImpactModel.gd: U20's TWO CHANNELS, AS A PURE MODULE

**Model:** your strongest · high effort. Module **and** its test — you have a shell.

## Why this can start now

U20 (Cursor, merged 2026-09-09) specified real-time damage in full and priced
it **per fight-second, never per tick**, so C62's 20 Hz answer cannot invalidate
it. Claude is building the real-time core (R82) against
`FightSimulation.gd`. **You own the damage math as a pure module the core will
call**, so neither of us touches the other's file.

Read `research/U20_DAMAGE_IN_REAL_TIME.md` (267 lines) — that is your
specification. Read `research/C62_DIGEST.md` for context. Nothing else.

## The contract

`Godot/scripts/ImpactModel.gd`, `class_name ImpactModel`, **all static, ZERO
preloads.** It takes dictionaries and returns dictionaries; it holds no state,
reaches no autoload, and never writes to an athlete.

**The impact record**, U20's own shape — build it and validate it:

```
{ "t_s": float, "region": String, "force": float 0..1,
  "contact": "clean"|"glancing"|"absorbed"|"blocked"|"slipped"|"missed" }
```

1. `static func make_impact(t_s: float, region: String, force: float, contact: String) -> Dictionary`
   Clamps `force` to 0..1, clamps `t_s` at 0.0, and returns `{}` for a region
   or contact word it does not recognise — **an unrecognised input is refused,
   never defaulted.** Reuse the six region ids the game already uses; take them
   from `BodyReadiness.gd`, do not invent new ones.
2. `static func wear_from(impact: Dictionary) -> Dictionary`
   The WEAR channel: `{region: float}` to subtract from `body_condition`.
   Small and often. **Conservation-split per U20** so R80's ~1.8 lands per
   14 s do not quadruple the bout against today's numbers. A `missed` or
   `blocked` contact wears nothing on the target.
3. `static func shock_chance(impact: Dictionary, head_neck_remaining: float) -> float`
   The SHOCK channel: 0..1. Rare, **scaled by `force` SQUARED**, and rising as
   `head_neck_remaining` falls. Non-clean contact is 0.0. A torso impact uses
   U20's delayed liver-class rule; every other region is 0.0.
4. `static func is_flash_knockdown(shock: float, head_neck_remaining: float) -> bool`
   U20's mechanism the old lump could not express: **a flash knockdown is
   recovered shock** — high shock against a still-healthy head.
5. `static func per_minute(count: int, fight_seconds: float) -> float`
   `count / fight_seconds * 60.0`, and `0.0` when `fight_seconds <= 0.0`.
   This is the figure U19's hardcoded `* 14 / 60` becomes; Cursor is changing
   the consumer under U21 and will call THIS.

## Owned files

- `Godot/scripts/ImpactModel.gd` — new.
- `Godot/tests/impact_model_test.gd` — new.
- `research/C63_DIGEST.md` — new, short.

**Do NOT touch** `FightSimulation.gd` (Claude, R82), `BroadcastRead.gd`
(Cursor, U21), `RingSpace.gd` (Qwen, Q13) or `FightClock.gd`.

## The traps

- **No tick anywhere.** Every rate is per fight-second. If `tick` or a Hz
  figure appears in this module it is wrong, and C62 may still move the rate.
- **You are not allowed to decide the balance.** U20 gives the shape and the
  citations; where it gives a number use it, where it does not, expose a
  `const` with U20's reasoning in a comment so R82 can tune without editing
  logic. Do not bury a magic number in an expression.
- **Refuse, do not default.** An unknown region or contact word returns `{}` /
  `0.0` because it is unmeasured — the standing ruling from G27 and RingPlace.

## Gate

Parse gate, your own test, then the full suite in the background before the
commit: `python Godot/tools/run_tests.py` → **`fails=0` or better.** It reads
`total=193 fails=0` right now.
