# TASK G28 — GROK — FightClock.gd: ONE CLOCK, AND IT IS THE SIMULATION'S

**Model:** your default. **ONE FILE. DO NOT WRITE A TEST** — the test is a
separate task written from this same contract by someone who will not have seen
your code. That is deliberate: a test written against an implementation only
ever agrees with it.

## What you are building

A pure arithmetic module for a fight clock. No engine, no nodes, no signals, no
`_process`. `Godot/scripts/FightClock.gd`, `class_name FightClock`, **all
static, ZERO preloads.**

Operator ruling 2026-09-09: the fight becomes real time. C17 **Q2** stands and
is the rule you are encoding — **there is one clock and it belongs to the
simulation.** Playback speed changes how fast the player watches; it never
changes fight time. A pause freezes everything and each side resumes exactly
once.

## The contract — exact names, exact argument order, exact strings

```
const DEFAULT_ROUND_SECONDS := 300.0   # 5:00
const DEFAULT_REST_SECONDS  := 60.0    # 1:00
const SPEEDS := [1.0, 2.0, 4.0]
```

1. `static func round_seconds_elapsed(fight_seconds: float, round_seconds: float, rest_seconds: float) -> float`
   Seconds into the CURRENT round. During a rest period return `0.0`.
2. `static func round_number(fight_seconds: float, round_seconds: float, rest_seconds: float) -> int`
   1-based. Round 1 starts at `0.0`. During the rest AFTER round N, return N —
   the bell has gone but round N+1 has not started.
3. `static func is_resting(fight_seconds: float, round_seconds: float, rest_seconds: float) -> bool`
4. `static func seconds_remaining_in_round(fight_seconds: float, round_seconds: float, rest_seconds: float) -> float`
   Counts down to `0.0`; during a rest return `0.0`. Never negative.
5. `static func is_over(fight_seconds: float, rounds: int, round_seconds: float, rest_seconds: float) -> bool`
   True once the final round's last second has elapsed. There is no rest after
   the final round.
6. `static func real_to_fight(real_seconds: float, speed: float) -> float`
   `real_seconds * speed`. A `speed` not in `SPEEDS` is still applied as given;
   a `speed <= 0.0` returns `0.0`.
7. `static func fight_to_real(fight_seconds: float, speed: float) -> float`
   The inverse. A `speed <= 0.0` returns `0.0`.
8. `static func clock_text(fight_seconds: float, round_seconds: float, rest_seconds: float) -> String`
   `"M:SS"` of `seconds_remaining_in_round`, seconds always two digits —
   `"5:00"`, `"0:07"`, `"0:00"`. During a rest, `"0:00"`.

## The rules that decide the edge cases

- **Negative or zero inputs are unmeasured, not zero-valued.** A
  `fight_seconds < 0.0` is treated as `0.0`. A `round_seconds <= 0.0` means
  there is no round structure: `round_number` returns `1`,
  `round_seconds_elapsed` and `seconds_remaining_in_round` return `0.0`,
  `is_resting` is `false`.
- **A rest of `0.0` is legal** — rounds run back to back. Do not special-case
  it into a divide by zero.
- **`rounds <= 0` means `is_over` is `true` immediately.**
- Boundaries are inclusive at the start: at exactly `round_seconds` the round
  has ENDED and the rest has begun.

## RULING, pinned 2026-09-09 after delivery (the gap was MINE, not Grok's)

The contract said what a `round_seconds <= 0.0` does to `round_number`,
`round_seconds_elapsed`, `seconds_remaining_in_round` and `is_resting`. **It
said nothing about `is_over`.** The delivered module returns `true`, and that
is now the ruling: a bout with no round structure has nothing left to fight, so
it is over rather than eternally running. The alternative — `false` forever —
would hang any caller that loops until `is_over`.

Also settled by delivery, and correct: `is_over` computes the end as
`rounds * round_seconds + (rounds - 1) * rest_seconds`, which is the contract's
"no rest after the final round" written as arithmetic.

## Owned files

- `Godot/scripts/FightClock.gd` — **the only file you write.**

Do not write a test. Do not edit `HANDOFF.md`. Do not read or change
`FightSimulation.gd`.

## The trap specific to this task

**Speed must not appear anywhere except `real_to_fight` / `fight_to_real`.**
Every other function takes fight seconds and knows nothing about playback. If
speed leaks into `round_number` or `clock_text`, watching at 4x would change
what round it is — which is exactly the bug C17 Q2 was ruled to prevent.
